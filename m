Return-Path: <SRS0=mwGE=VG=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNWANTED_LANGUAGE_BODY,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BBAD7C73C53
	for <linux-crypto@archiver.kernel.org>; Tue,  9 Jul 2019 15:25:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 77BA721537
	for <linux-crypto@archiver.kernel.org>; Tue,  9 Jul 2019 15:25:11 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="BklQvu2K";
	dkim=pass (1024-bit key) header.d=marvell.onmicrosoft.com header.i=@marvell.onmicrosoft.com header.b="E+OBO/6v"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726218AbfGIPZK (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 9 Jul 2019 11:25:10 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:53550 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726126AbfGIPZK (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 9 Jul 2019 11:25:10 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x69FHXeh032029;
        Tue, 9 Jul 2019 08:24:51 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : content-type : content-transfer-encoding :
 mime-version; s=pfpt0818; bh=saWQTWdyaLSWCsDNwkgwlH/lqgqa+76wHar4wqSxU+Q=;
 b=BklQvu2KJiWBbZYITI9VD8M36Nh/kjH2kXCyCdEHVJnb0yLiBJzkAu+Q2mqrmNQE7Ue6
 0Ck05InlIf+IAfSorT5Aw8Fjv9k5chwb/TlgkK0OkZttW0DUbDiCBcZX58Frqam9STHS
 pZuLg5wrdB1gUJ6BRktY+byrk4pr1ssm5zjureFXZDu3rsAGvR9hOBT/Usj0fRSEuv+r
 7UlJdDKQycmXeRIqB0o9GiZux3DhBc0K4S2Ni5PSUCySvvn/BFL/50q5obblM4ZqVfae
 sM1VmOjw955+o3hVLvITqJwD0ICMnTx67/UtotKiM/6g1a1qan0EJ2YiA51ENC2a2x6H IQ== 
Received: from sc-exch03.marvell.com ([199.233.58.183])
        by mx0b-0016f401.pphosted.com with ESMTP id 2tmn10htky-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Tue, 09 Jul 2019 08:24:50 -0700
Received: from SC-EXCH02.marvell.com (10.93.176.82) by SC-EXCH03.marvell.com
 (10.93.176.83) with Microsoft SMTP Server (TLS) id 15.0.1367.3; Tue, 9 Jul
 2019 08:24:27 -0700
Received: from NAM01-BN3-obe.outbound.protection.outlook.com (104.47.33.50) by
 SC-EXCH02.marvell.com (10.93.176.82) with Microsoft SMTP Server (TLS) id
 15.0.1367.3 via Frontend Transport; Tue, 9 Jul 2019 08:24:27 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector2-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=saWQTWdyaLSWCsDNwkgwlH/lqgqa+76wHar4wqSxU+Q=;
 b=E+OBO/6vc+oyVBl84mFTmDEeJY8WcuICHyGT2sENzEaT1bFd5su1X5J2poUhADVqGEnPg8Of+R44XuLrAaYzlZV71BC4oguAqb78Prc39rXz42HcI4zx6Fq5A0GJPBSaBZo32HwbRMYgzPBymFkzguZ9QjIGkwrv03WQIJZzVU0=
Received: from MN2PR18MB2605.namprd18.prod.outlook.com (20.179.83.161) by
 MN2PR18MB3373.namprd18.prod.outlook.com (10.255.238.142) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2052.18; Tue, 9 Jul 2019 15:24:24 +0000
Received: from MN2PR18MB2605.namprd18.prod.outlook.com
 ([fe80::3861:44d9:a9e:b6d6]) by MN2PR18MB2605.namprd18.prod.outlook.com
 ([fe80::3861:44d9:a9e:b6d6%3]) with mapi id 15.20.2052.020; Tue, 9 Jul 2019
 15:24:24 +0000
From:   Phani Kiran Hemadri <phemadri@marvell.com>
To:     "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Phani Kiran Hemadri" <phemadri@marvell.com>
Subject: [PATCH] crypto: cavium/nitrox - Add support for loading asymmetric
 crypto firmware
Thread-Topic: [PATCH] crypto: cavium/nitrox - Add support for loading
 asymmetric crypto firmware
Thread-Index: AQHVNmpj8dGFBW7WSU6vN5u/SDAG7w==
Date:   Tue, 9 Jul 2019 15:24:24 +0000
Message-ID: <20190709152341.20953-1-phemadri@marvell.com>
Accept-Language: en-IN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: BMXPR01CA0078.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:b00:54::18) To MN2PR18MB2605.namprd18.prod.outlook.com
 (2603:10b6:208:106::33)
x-ms-exchange-messagesentrepresentingtype: 1
x-mailer: git-send-email 2.17.2
x-originating-ip: [115.113.156.2]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: fa747cf1-53ee-4d03-6786-08d704818621
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(7168020)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:MN2PR18MB3373;
x-ms-traffictypediagnostic: MN2PR18MB3373:
x-microsoft-antispam-prvs: <MN2PR18MB3373163B1E6947A87C164947D6F10@MN2PR18MB3373.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:328;
x-forefront-prvs: 0093C80C01
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(39850400004)(366004)(346002)(136003)(396003)(376002)(189003)(199004)(36756003)(6916009)(316002)(3846002)(2906002)(6116002)(30864003)(256004)(52116002)(4326008)(14444005)(107886003)(71190400001)(25786009)(99286004)(86362001)(50226002)(478600001)(2501003)(1076003)(6486002)(7736002)(186003)(66066001)(6436002)(14454004)(2616005)(8936002)(476003)(73956011)(66476007)(66556008)(64756008)(66946007)(66446008)(2351001)(305945005)(486006)(81166006)(53936002)(26005)(102836004)(1730700003)(81156014)(55236004)(54906003)(8676002)(6506007)(386003)(5660300002)(5640700003)(68736007)(71200400001)(6512007);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR18MB3373;H:MN2PR18MB2605.namprd18.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: marvell.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: MbLsxvGhbAKClPJ5ovbkQyD08UoO3dNm45Mu+Oaxmforez2L4RtUsMqNTeth2Csmchd4/k34pazUfaJ3uvKlwvgysHrY2E/iFCwuOOJwh/Sg7vo+tyEcPE4/xfdXpSigiATtJ3d1J8udxsN+8YaaV0JlMBHk84VS/vAL8HF2VHkVPjDxeNhw1uituPs29QqSvdCxoNiJVkk1wDqQBfqDqngeUVrcGSIeL2mFtYnFGL3vvUvxkEPr+I/8bXaGP7DXRPIA0Zvzb+3Kb/psLuh7q6NkdC4ZBYQeKRjS5XQnMAQZOSVQLM2a3dzeASUiKpVNeFJs6VOCcRjSRRnQZAz6B4mQjQCwNY+KO4A8YEFnVlW+fOQUelV6nVR8k+cVDKD00P4voVGP2xEsB8wvJD0mU5LvsXFCF8qb48QQwiYJngk=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: fa747cf1-53ee-4d03-6786-08d704818621
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Jul 2019 15:24:24.5622
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: phemadri@marvell.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR18MB3373
X-OriginatorOrg: marvell.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-07-09_06:,,
 signatures=0
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

This patch adds support to load Asymmetric crypto firmware on
AE cores of CNN55XX device. Firmware is stored on UCD block 2
and all available AE cores are tagged to group 0.

Signed-off-by: Phani Kiran Hemadri <phemadri@marvell.com>
Reviewed-by: Srikanth Jampala <jsrikanth@marvell.com>
---
 drivers/crypto/cavium/nitrox/nitrox_csr.h     | 124 ++++++++++++++-
 drivers/crypto/cavium/nitrox/nitrox_debugfs.c |   3 +-
 drivers/crypto/cavium/nitrox/nitrox_dev.h     |   4 +-
 drivers/crypto/cavium/nitrox/nitrox_main.c    | 144 ++++++++++++++----
 4 files changed, 244 insertions(+), 31 deletions(-)

diff --git a/drivers/crypto/cavium/nitrox/nitrox_csr.h b/drivers/crypto/cav=
ium/nitrox/nitrox_csr.h
index a2a452642b38..da1d73303780 100644
--- a/drivers/crypto/cavium/nitrox/nitrox_csr.h
+++ b/drivers/crypto/cavium/nitrox/nitrox_csr.h
@@ -40,9 +40,77 @@
 #define EMU_FUSE_MAPX(_i)	(0x1402708 + ((_i) * 0x40000))
=20
 /* UCD registers */
+#define UCD_SE_EID_UCODE_BLOCK_NUMX(_i)	(0x12C0000 + ((_i) * 0x1000))
+#define UCD_AE_EID_UCODE_BLOCK_NUMX(_i)	(0x12C0008 + ((_i) * 0x800))
 #define UCD_UCODE_LOAD_BLOCK_NUM	0x12C0010
 #define UCD_UCODE_LOAD_IDX_DATAX(_i)	(0x12C0018 + ((_i) * 0x20))
-#define UCD_SE_EID_UCODE_BLOCK_NUMX(_i)	(0x12C0000 + ((_i) * 0x1000))
+#define UCD_SE_CNTX(_i)			(0x12C0040 + ((_i) * 0x1000))
+#define UCD_AE_CNTX(_i)			(0x12C0048 + ((_i) * 0x800))
+
+/* AQM registers */
+#define AQM_CTL                         0x1300000
+#define AQM_INT                         0x1300008
+#define AQM_DBELL_OVF_LO                0x1300010
+#define AQM_DBELL_OVF_HI                0x1300018
+#define AQM_DBELL_OVF_LO_W1S            0x1300020
+#define AQM_DBELL_OVF_LO_ENA_W1C        0x1300028
+#define AQM_DBELL_OVF_LO_ENA_W1S        0x1300030
+#define AQM_DBELL_OVF_HI_W1S            0x1300038
+#define AQM_DBELL_OVF_HI_ENA_W1C        0x1300040
+#define AQM_DBELL_OVF_HI_ENA_W1S        0x1300048
+#define AQM_DMA_RD_ERR_LO               0x1300050
+#define AQM_DMA_RD_ERR_HI               0x1300058
+#define AQM_DMA_RD_ERR_LO_W1S           0x1300060
+#define AQM_DMA_RD_ERR_LO_ENA_W1C       0x1300068
+#define AQM_DMA_RD_ERR_LO_ENA_W1S       0x1300070
+#define AQM_DMA_RD_ERR_HI_W1S           0x1300078
+#define AQM_DMA_RD_ERR_HI_ENA_W1C       0x1300080
+#define AQM_DMA_RD_ERR_HI_ENA_W1S       0x1300088
+#define AQM_EXEC_NA_LO                  0x1300090
+#define AQM_EXEC_NA_HI                  0x1300098
+#define AQM_EXEC_NA_LO_W1S              0x13000A0
+#define AQM_EXEC_NA_LO_ENA_W1C          0x13000A8
+#define AQM_EXEC_NA_LO_ENA_W1S          0x13000B0
+#define AQM_EXEC_NA_HI_W1S              0x13000B8
+#define AQM_EXEC_NA_HI_ENA_W1C          0x13000C0
+#define AQM_EXEC_NA_HI_ENA_W1S          0x13000C8
+#define AQM_EXEC_ERR_LO                 0x13000D0
+#define AQM_EXEC_ERR_HI                 0x13000D8
+#define AQM_EXEC_ERR_LO_W1S             0x13000E0
+#define AQM_EXEC_ERR_LO_ENA_W1C         0x13000E8
+#define AQM_EXEC_ERR_LO_ENA_W1S         0x13000F0
+#define AQM_EXEC_ERR_HI_W1S             0x13000F8
+#define AQM_EXEC_ERR_HI_ENA_W1C         0x1300100
+#define AQM_EXEC_ERR_HI_ENA_W1S         0x1300108
+#define AQM_ECC_INT                     0x1300110
+#define AQM_ECC_INT_W1S                 0x1300118
+#define AQM_ECC_INT_ENA_W1C             0x1300120
+#define AQM_ECC_INT_ENA_W1S             0x1300128
+#define AQM_ECC_CTL                     0x1300130
+#define AQM_BIST_STATUS                 0x1300138
+#define AQM_CMD_INF_THRX(x)             (0x1300400 + ((x) * 0x8))
+#define AQM_CMD_INFX(x)                 (0x1300800 + ((x) * 0x8))
+#define AQM_GRP_EXECMSK_LOX(x)          (0x1300C00 + ((x) * 0x10))
+#define AQM_GRP_EXECMSK_HIX(x)          (0x1300C08 + ((x) * 0x10))
+#define AQM_ACTIVITY_STAT_LO            0x1300C80
+#define AQM_ACTIVITY_STAT_HI            0x1300C88
+#define AQM_Q_CMD_PROCX(x)              (0x1301000 + ((x) * 0x8))
+#define AQM_PERF_CTL_LO                 0x1301400
+#define AQM_PERF_CTL_HI                 0x1301408
+#define AQM_PERF_CNT                    0x1301410
+
+#define AQMQ_DRBLX(x)                   (0x20000 + ((x) * 0x40000))
+#define AQMQ_QSZX(x)                    (0x20008 + ((x) * 0x40000))
+#define AQMQ_BADRX(x)                   (0x20010 + ((x) * 0x40000))
+#define AQMQ_NXT_CMDX(x)                (0x20018 + ((x) * 0x40000))
+#define AQMQ_CMD_CNTX(x)                (0x20020 + ((x) * 0x40000))
+#define AQMQ_CMP_THRX(x)                (0x20028 + ((x) * 0x40000))
+#define AQMQ_CMP_CNTX(x)                (0x20030 + ((x) * 0x40000))
+#define AQMQ_TIM_LDX(x)                 (0x20038 + ((x) * 0x40000))
+#define AQMQ_TIMERX(x)                  (0x20040 + ((x) * 0x40000))
+#define AQMQ_ENX(x)                     (0x20048 + ((x) * 0x40000))
+#define AQMQ_ACTIVITY_STATX(x)          (0x20050 + ((x) * 0x40000))
+#define AQM_VF_CMP_STATX(x)             (0x28000 + ((x) * 0x40000))
=20
 /* NPS core registers */
 #define NPS_CORE_GBL_VFCFG	0x1000000
@@ -134,6 +202,60 @@
 /* PEM registers */
 #define PEM0_INT 0x1080428
=20
+/**
+ * struct ucd_core_eid_ucode_block_num - Core Eid to Ucode Blk Mapping Reg=
isters
+ * @ucode_len: Ucode length identifier 32KB or 64KB
+ * @ucode_blk: Ucode Block Number
+ */
+union ucd_core_eid_ucode_block_num {
+	u64 value;
+	struct {
+#if (defined(__BIG_ENDIAN_BITFIELD))
+		u64 raz_4_63 : 60;
+		u64 ucode_len : 1;
+		u64 ucode_blk : 3;
+#else
+		u64 ucode_blk : 3;
+		u64 ucode_len : 1;
+		u64 raz_4_63 : 60;
+#endif
+	};
+};
+
+/**
+ * struct aqm_grp_execmsk_lo - Available AE engines for the group
+ * @exec_0_to_39: AE engines 0 to 39 status
+ */
+union aqm_grp_execmsk_lo {
+	u64 value;
+	struct {
+#if (defined(__BIG_ENDIAN_BITFIELD))
+		u64 raz_40_63 : 24;
+		u64 exec_0_to_39 : 40;
+#else
+		u64 exec_0_to_39 : 40;
+		u64 raz_40_63 : 24;
+#endif
+	};
+};
+
+/**
+ * struct aqm_grp_execmsk_hi - Available AE engines for the group
+ * @exec_40_to_79: AE engines 40 to 79 status
+ */
+union aqm_grp_execmsk_hi {
+	u64 value;
+	struct {
+#if (defined(__BIG_ENDIAN_BITFIELD))
+		u64 raz_40_63 : 24;
+		u64 exec_40_to_79 : 40;
+#else
+		u64 exec_40_to_79 : 40;
+		u64 raz_40_63 : 24;
+#endif
+	};
+};
+
 /**
  * struct emu_fuse_map - EMU Fuse Map Registers
  * @ae_fuse: Fuse settings for AE 19..0
diff --git a/drivers/crypto/cavium/nitrox/nitrox_debugfs.c b/drivers/crypto=
/cavium/nitrox/nitrox_debugfs.c
index 848ec93d4333..16f7d0bd1303 100644
--- a/drivers/crypto/cavium/nitrox/nitrox_debugfs.c
+++ b/drivers/crypto/cavium/nitrox/nitrox_debugfs.c
@@ -9,7 +9,8 @@ static int firmware_show(struct seq_file *s, void *v)
 {
 	struct nitrox_device *ndev =3D s->private;
=20
-	seq_printf(s, "Version: %s\n", ndev->hw.fw_name);
+	seq_printf(s, "Version: %s\n", ndev->hw.fw_name[0]);
+	seq_printf(s, "Version: %s\n", ndev->hw.fw_name[1]);
 	return 0;
 }
=20
diff --git a/drivers/crypto/cavium/nitrox/nitrox_dev.h b/drivers/crypto/cav=
ium/nitrox/nitrox_dev.h
index 0338877b828f..5ee98eca728c 100644
--- a/drivers/crypto/cavium/nitrox/nitrox_dev.h
+++ b/drivers/crypto/cavium/nitrox/nitrox_dev.h
@@ -10,6 +10,8 @@
 #define VERSION_LEN 32
 /* Maximum queues in PF mode */
 #define MAX_PF_QUEUES	64
+/* Maximum UCD Blocks */
+#define CNN55XX_MAX_UCD_BLOCKS	8
=20
 /**
  * struct nitrox_cmdq - NITROX command queue
@@ -74,7 +76,7 @@ struct nitrox_cmdq {
  */
 struct nitrox_hw {
 	char partname[IFNAMSIZ * 2];
-	char fw_name[VERSION_LEN];
+	char fw_name[CNN55XX_MAX_UCD_BLOCKS][VERSION_LEN];
=20
 	int freq;
 	u16 vendor_id;
diff --git a/drivers/crypto/cavium/nitrox/nitrox_main.c b/drivers/crypto/ca=
vium/nitrox/nitrox_main.c
index faa78f651238..d478cc9c5ea2 100644
--- a/drivers/crypto/cavium/nitrox/nitrox_main.c
+++ b/drivers/crypto/cavium/nitrox/nitrox_main.c
@@ -16,12 +16,17 @@
=20
 #define CNN55XX_DEV_ID	0x12
 #define UCODE_HLEN 48
-#define SE_GROUP 0
+#define DEFAULT_SE_GROUP 0
+#define DEFAULT_AE_GROUP 0
=20
-#define DRIVER_VERSION "1.1"
+#define DRIVER_VERSION "1.2"
+#define CNN55XX_UCD_BLOCK_SIZE 32768
+#define CNN55XX_MAX_UCODE_SIZE (CNN55XX_UCD_BLOCK_SIZE * 2)
 #define FW_DIR "cavium/"
 /* SE microcode */
 #define SE_FW	FW_DIR "cnn55xx_se.fw"
+/* AE microcode */
+#define AE_FW	FW_DIR "cnn55xx_ae.fw"
=20
 static const char nitrox_driver_name[] =3D "CNN55XX";
=20
@@ -71,10 +76,10 @@ struct ucode {
 /**
  * write_to_ucd_unit - Write Firmware to NITROX UCD unit
  */
-static void write_to_ucd_unit(struct nitrox_device *ndev,
-			      struct ucode *ucode)
+static void write_to_ucd_unit(struct nitrox_device *ndev, u32 ucode_size,
+			      u64 *ucode_data, int block_num)
 {
-	u32 code_size =3D be32_to_cpu(ucode->code_size) * 2;
+	u32 code_size;
 	u64 offset, data;
 	int i =3D 0;
=20
@@ -95,11 +100,12 @@ static void write_to_ucd_unit(struct nitrox_device *nd=
ev,
=20
 	/* set the block number */
 	offset =3D UCD_UCODE_LOAD_BLOCK_NUM;
-	nitrox_write_csr(ndev, offset, 0);
+	nitrox_write_csr(ndev, offset, block_num);
=20
+	code_size =3D ucode_size;
 	code_size =3D roundup(code_size, 8);
 	while (code_size) {
-		data =3D ucode->code[i];
+		data =3D ucode_data[i];
 		/* write 8 bytes at a time */
 		offset =3D UCD_UCODE_LOAD_IDX_DATAX(i);
 		nitrox_write_csr(ndev, offset, data);
@@ -107,29 +113,74 @@ static void write_to_ucd_unit(struct nitrox_device *n=
dev,
 		i++;
 	}
=20
-	/* put all SE cores in group 0 */
-	offset =3D POM_GRP_EXECMASKX(SE_GROUP);
-	nitrox_write_csr(ndev, offset, (~0ULL));
-
-	for (i =3D 0; i < ndev->hw.se_cores; i++) {
-		/*
-		 * write block number and firware length
-		 * bit:<2:0> block number
-		 * bit:3 is set SE uses 32KB microcode
-		 * bit:3 is clear SE uses 64KB microcode
-		 */
-		offset =3D UCD_SE_EID_UCODE_BLOCK_NUMX(i);
-		nitrox_write_csr(ndev, offset, 0x8);
-	}
 	usleep_range(300, 400);
 }
=20
-static int nitrox_load_fw(struct nitrox_device *ndev, const char *fw_name)
+static int nitrox_load_fw(struct nitrox_device *ndev)
 {
 	const struct firmware *fw;
+	const char *fw_name;
 	struct ucode *ucode;
-	int ret;
+	u64 *ucode_data;
+	u64 offset;
+	union ucd_core_eid_ucode_block_num core_2_eid_val;
+	union aqm_grp_execmsk_lo aqm_grp_execmask_lo;
+	union aqm_grp_execmsk_hi aqm_grp_execmask_hi;
+	u32 ucode_size;
+	int ret, i =3D 0;
+
+	fw_name =3D SE_FW;
+	dev_info(DEV(ndev), "Loading firmware \"%s\"\n", fw_name);
+
+	ret =3D request_firmware(&fw, fw_name, DEV(ndev));
+	if (ret < 0) {
+		dev_err(DEV(ndev), "failed to get firmware %s\n", fw_name);
+		return ret;
+	}
+
+	ucode =3D (struct ucode *)fw->data;
+
+	ucode_size =3D be32_to_cpu(ucode->code_size) * 2;
+	if (!ucode_size || ucode_size > CNN55XX_MAX_UCODE_SIZE) {
+		dev_err(DEV(ndev), "Invalid ucode size: %u for firmware %s\n",
+			ucode_size, fw_name);
+		release_firmware(fw);
+		return -EINVAL;
+	}
+	ucode_data =3D ucode->code;
+
+	/* copy the firmware version */
+	memcpy(&ndev->hw.fw_name[0][0], ucode->version, (VERSION_LEN - 2));
+	ndev->hw.fw_name[0][VERSION_LEN - 1] =3D '\0';
+
+	/* Load SE Firmware on UCD Block 0 */
+	write_to_ucd_unit(ndev, ucode_size, ucode_data, 0);
=20
+	release_firmware(fw);
+
+	/* put all SE cores in DEFAULT_SE_GROUP */
+	offset =3D POM_GRP_EXECMASKX(DEFAULT_SE_GROUP);
+	nitrox_write_csr(ndev, offset, (~0ULL));
+
+	/* write block number and firmware length
+	 * bit:<2:0> block number
+	 * bit:3 is set SE uses 32KB microcode
+	 * bit:3 is clear SE uses 64KB microcode
+	 */
+	core_2_eid_val.value =3D 0ULL;
+	core_2_eid_val.ucode_blk =3D 0;
+	if (ucode_size <=3D CNN55XX_UCD_BLOCK_SIZE)
+		core_2_eid_val.ucode_len =3D 1;
+	else
+		core_2_eid_val.ucode_len =3D 0;
+
+	for (i =3D 0; i < ndev->hw.se_cores; i++) {
+		offset =3D UCD_SE_EID_UCODE_BLOCK_NUMX(i);
+		nitrox_write_csr(ndev, offset, core_2_eid_val.value);
+	}
+
+
+	fw_name =3D AE_FW;
 	dev_info(DEV(ndev), "Loading firmware \"%s\"\n", fw_name);
=20
 	ret =3D request_firmware(&fw, fw_name, DEV(ndev));
@@ -139,13 +190,50 @@ static int nitrox_load_fw(struct nitrox_device *ndev,=
 const char *fw_name)
 	}
=20
 	ucode =3D (struct ucode *)fw->data;
+
+	ucode_size =3D be32_to_cpu(ucode->code_size) * 2;
+	if (!ucode_size || ucode_size > CNN55XX_MAX_UCODE_SIZE) {
+		dev_err(DEV(ndev), "Invalid ucode size: %u for firmware %s\n",
+			ucode_size, fw_name);
+		release_firmware(fw);
+		return -EINVAL;
+	}
+	ucode_data =3D ucode->code;
+
 	/* copy the firmware version */
-	memcpy(ndev->hw.fw_name, ucode->version, (VERSION_LEN - 2));
-	ndev->hw.fw_name[VERSION_LEN - 1] =3D '\0';
+	memcpy(&ndev->hw.fw_name[1][0], ucode->version, (VERSION_LEN - 2));
+	ndev->hw.fw_name[1][VERSION_LEN - 1] =3D '\0';
+
+	/* Load AE Firmware on UCD Block 2 */
+	write_to_ucd_unit(ndev, ucode_size, ucode_data, 2);
=20
-	write_to_ucd_unit(ndev, ucode);
 	release_firmware(fw);
=20
+	/* put all AE cores in DEFAULT_AE_GROUP */
+	offset =3D AQM_GRP_EXECMSK_LOX(DEFAULT_AE_GROUP);
+	aqm_grp_execmask_lo.exec_0_to_39 =3D 0xFFFFFFFFFFULL;
+	nitrox_write_csr(ndev, offset, aqm_grp_execmask_lo.value);
+	offset =3D AQM_GRP_EXECMSK_HIX(DEFAULT_AE_GROUP);
+	aqm_grp_execmask_hi.exec_40_to_79 =3D 0xFFFFFFFFFFULL;
+	nitrox_write_csr(ndev, offset, aqm_grp_execmask_hi.value);
+
+	/* write block number and firmware length
+	 * bit:<2:0> block number
+	 * bit:3 is set SE uses 32KB microcode
+	 * bit:3 is clear SE uses 64KB microcode
+	 */
+	core_2_eid_val.value =3D 0ULL;
+	core_2_eid_val.ucode_blk =3D 0;
+	if (ucode_size <=3D CNN55XX_UCD_BLOCK_SIZE)
+		core_2_eid_val.ucode_len =3D 1;
+	else
+		core_2_eid_val.ucode_len =3D 0;
+
+	for (i =3D 0; i < ndev->hw.ae_cores; i++) {
+		offset =3D UCD_AE_EID_UCODE_BLOCK_NUMX(i);
+		nitrox_write_csr(ndev, offset, core_2_eid_val.value);
+	}
+
 	return 0;
 }
=20
@@ -308,8 +396,8 @@ static int nitrox_pf_hw_init(struct nitrox_device *ndev=
)
 	nitrox_config_lbc_unit(ndev);
 	nitrox_config_rand_unit(ndev);
=20
-	/* load firmware on SE cores */
-	err =3D nitrox_load_fw(ndev, SE_FW);
+	/* load firmware on cores */
+	err =3D nitrox_load_fw(ndev);
 	if (err)
 		return err;
=20
--=20
2.17.2

