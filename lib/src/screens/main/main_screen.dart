import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:tms/src/common/services/main_service.dart';
import 'package:tms/src/common/dependencies/nv_dio.dart';
import './cubit/get_main_info_cubit.dart';
import './cubit/get_main_document_cubit.dart';
import './widgets/attendance_card.dart';
import './widgets/feature_card.dart';
import './widgets/profile_card.dart';
import './widgets/utility_item.dart';
import './widgets/document_item.dart';
import './widgets/svg_nav_icon.dart';
import 'package:get_it/get_it.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;
  late Box userBox;

  @override
  void initState() {
    super.initState();
    userBox = Hive.box('user');
  }

  static const double _horizontalPadding = 16;
  static const double _verticalPadding = 8;
  static const double _cardSpacing = 12;

  String getMonthName(DateTime date) {
    final months = [
      'Январь',
      'Февраль',
      'Март',
      'Апрель',
      'Май',
      'Июнь',
      'Июль',
      'Август',
      'Сентябрь',
      'Октябрь',
      'Ноябрь',
      'Декабрь',
    ];
    return months[date.month - 1];
  }

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final dateFrom = DateFormat(
      'yyyy-MM-dd',
    ).format(DateTime(now.year, now.month, 1));
    final dateTo = DateFormat(
      'yyyy-MM-dd',
    ).format(DateTime(now.year, now.month + 1, 0));

    final nvDio = GetIt.I<NvDio>();

    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create:
              (_) => GetMainInfoCubit(
                mainService: MainServiceImplement(nvDio: nvDio),
              )..loadMainInfo(dateFrom, dateTo),
        ),
        BlocProvider(
          create:
              (_) => GetMainDocumentCubit(
                mainServiceDocument: MainServiceImplement(nvDio: nvDio),
              )..loadMainDocument(),
        ),
      ],
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          title: const Text('Главная', style: TextStyle(color: Colors.black)),
          actions: [
            IconButton(
              icon: const Icon(Icons.notifications_none, color: Colors.black),
              onPressed: () {},
            ),
          ],
        ),
        body: SafeArea(
          child: ListView(
            padding: const EdgeInsets.symmetric(
              horizontal: _horizontalPadding,
              vertical: _verticalPadding,
            ),
            children: [
              BlocBuilder<GetMainInfoCubit, GetMainInfoState>(
                builder: (context, state) {
                  if (state is GetMainInfoLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is GetMainInfoError) {
                    return Text(
                      state.message,
                      style: const TextStyle(color: Colors.red),
                    );
                  } else if (state is GetMainInfoLoaded) {
                    return AttendanceCard(
                      month: getMonthName(now),
                      onTimeCount: state.ok,
                      lateCount: state.notOk,
                    );
                  } else {
                    return const SizedBox.shrink();
                  }
                },
              ),
              const SizedBox(height: 16),
              const FeatureCard(
                backgroundImage: 'assets/images/purple-back.png',
                iconPath: 'assets/images/paper.png',
                title: 'Эффективное управление задачами',
                subtitle: 'Блок поручения',
              ),
              const SizedBox(height: _cardSpacing),
              ProfileCard(
                userName:
                    (userBox.get('user')
                        as Map<String, dynamic>?)?['first_name'] ??
                    'Пользователь',
                initials: 'ДМ',
              ),
              const SizedBox(height: _cardSpacing),
              const FeatureCard(
                backgroundImage: 'assets/images/orange-back.png',
                iconPath: 'assets/images/cash.png',
                title: 'История выплат и начислений',
                subtitle: 'Моя заработная плата',
              ),
              const SizedBox(height: _cardSpacing),
              const FeatureCard(
                backgroundImage: 'assets/images/blue-back.png',
                iconPath: 'assets/images/user-icons.png',
                title: 'Данные и доступ к таблицам',
                subtitle: 'Мои сотрудники',
              ),
              const SizedBox(height: 24),
              const Text(
                'Для вашего удобства',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  fontFamily: "SF-Pro",
                ),
              ),
              const SizedBox(height: 12),
              GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                childAspectRatio: 1.3,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                children: const [
                  UtilityItem(
                    imagePath: 'assets/images/search-picture.png',
                    label: 'Мои основные средства',
                  ),
                  UtilityItem(
                    imagePath: 'assets/images/tabel-picture.png',
                    label: 'Посмотреть табель',
                  ),
                  UtilityItem(
                    imagePath: 'assets/images/file-picture.png',
                    label: 'Задания для выполнения',
                  ),
                  UtilityItem(
                    imagePath: 'assets/images/list-picture.png',
                    label: 'Мои заявления',
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Документы и справки',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      fontFamily: "SF-Pro",
                    ),
                  ),
                  TextButton(
                    onPressed: () {},
                    child: const Text(
                      'Смотреть все',
                      style: TextStyle(
                        fontSize: 15,
                        color: Color(0xFF007AFF),
                        fontFamily: "SF-Pro",
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Container(
                height: 300,
                decoration: BoxDecoration(
                  color: const Color(0xFFF5F5F5),
                  borderRadius: BorderRadius.circular(20),
                ),
                padding: const EdgeInsets.all(16),
                child: SingleChildScrollView(
                  child:
                      BlocBuilder<GetMainDocumentCubit, GetMainDocumentState>(
                        builder: (context, state) {
                          if (state is GetMainDocumentLoading) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          } else if (state is GetMainDocumentError) {
                            return Text(
                              state.message,
                              style: const TextStyle(color: Colors.red),
                            );
                          } else if (state is GetMainDocumentLoaded) {
                            return Column(
                              children:
                                  state.documents.map((doc) {
                                    final title = doc['title'] ?? '';
                                    final createdAt = doc['created_at'] ?? '';
                                    final formattedDate =
                                        createdAt.isNotEmpty
                                            ? DateFormat(
                                              'dd.MM.yyyy',
                                            ).format(DateTime.parse(createdAt))
                                            : '-';
                                    return DocumentItem(
                                      title: title,
                                      date: formattedDate,
                                    );
                                  }).toList(),
                            );
                          } else {
                            return const SizedBox.shrink();
                          }
                        },
                      ),
                ),
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          showSelectedLabels: false,
          showUnselectedLabels: false,
          items: [
            BottomNavigationBarItem(
              icon: SvgNavIcon(
                assetPath: 'assets/icons/main-page-icon.svg',
                isActive: _currentIndex == 0,
                label: 'Главная',
              ),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: SvgNavIcon(
                assetPath: 'assets/icons/qr-page-icon.svg',
                isActive: _currentIndex == 1,
                label: 'QR',
              ),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: SvgNavIcon(
                assetPath: 'assets/icons/cabinet-page-icon.svg',
                isActive: _currentIndex == 2,
                label: 'Кабинет',
              ),
              label: '',
            ),
          ],
        ),
      ),
    );
  }
}
