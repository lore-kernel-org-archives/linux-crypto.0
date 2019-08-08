Return-Path: <SRS0=IdBJ=WE=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 306AFC0650F
	for <linux-crypto@archiver.kernel.org>; Thu,  8 Aug 2019 12:17:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DB845214C6
	for <linux-crypto@archiver.kernel.org>; Thu,  8 Aug 2019 12:17:54 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="EVYjvy2f";
	dkim=pass (1024-bit key) header.d=marvell.onmicrosoft.com header.i=@marvell.onmicrosoft.com header.b="pWzOFfkq"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732035AbfHHMRy (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 8 Aug 2019 08:17:54 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:18146 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727242AbfHHMRx (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 8 Aug 2019 08:17:53 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id x78C9Sjo031740;
        Thu, 8 Aug 2019 05:17:45 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pfpt0818;
 bh=FkxZ10j7Yxn9qVJ15kCLklnBo/nMpApGJUzkaHx3MUk=;
 b=EVYjvy2f5GJz0ZmOH62XHe9jsXp8sTqyMoK5ekJwUzh8yTZSrsa7g5AdgZLIDOUvn4Gy
 gegiLCEjEh9jkF29TW6aA27iYE/vLaYMZ+YjI6FWxmdQtLj+vhY89QGZq7k8u4ids1y1
 BZmZW+0R+iisBAgMkrP9yx0J5XagdoJMXCbuhC2VhieQmx2HBjCDksV46IuS46BA72rm
 e7EPWD8+Oh5OJqnRrK2YY4KBzrnVvrUzIsJTlXiOXHh+atMM9y6/+4wEMfDjGRHhbaR5
 oHFdD0MyZduNLvtSUTDYf8+gn8BVNMKXrp4TaNjFQP/o9l7WpJej0zOwXQ/08MetiHxP 2A== 
Received: from sc-exch01.marvell.com ([199.233.58.181])
        by mx0b-0016f401.pphosted.com with ESMTP id 2u59sm3gns-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Thu, 08 Aug 2019 05:17:44 -0700
Received: from SC-EXCH03.marvell.com (10.93.176.83) by SC-EXCH01.marvell.com
 (10.93.176.81) with Microsoft SMTP Server (TLS) id 15.0.1367.3; Thu, 8 Aug
 2019 05:17:43 -0700
Received: from NAM04-BN3-obe.outbound.protection.outlook.com (104.47.46.58) by
 SC-EXCH03.marvell.com (10.93.176.83) with Microsoft SMTP Server (TLS) id
 15.0.1367.3 via Frontend Transport; Thu, 8 Aug 2019 05:17:43 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ebqT9QMYH5jB3vqGWX/jP1fJ1vEaAJqVt2sLwdbqHvTzSaqYGxGmPO3OmIKbjropQAs0PiOZPAdqQUmb5MAALTFoWXW/GNTslcqSgJxXgCMk0oara52JZVn0/E4gW/vlJXh0KJNUNPK8AMOwOmHJJm8gYlIW1pz9wXot5ssMf5Gse/Kt5vXZ0wyaTunoFW6EjcSVJBha4YQxZYZqpmuRLTl6Sn3pejl7joacgmY/DQek53msPw7c2Yse4v8IZWsvFJmf1+eMzkaNytglFU822t0DUPIm2Lm3fEX+8BHS1p6jz894WMVrqdjTwjGAG8GsEhEjJYHlpTEKfggW4LHLVw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FkxZ10j7Yxn9qVJ15kCLklnBo/nMpApGJUzkaHx3MUk=;
 b=EYu/M0eJjyyOLcCWe8jz6GrZp3yek2+7JKHAGBuXAfZ5WD3vGNH7LEPmlmTele03BfyDYgS/6HA24QILs682XNVwCngJ2exDKv+1rK5RgWFaSvYrD48zhOMwEqGMpyGpHQGppZLx1fAT+++CH6Gk9gGgfrlyKzH58RIWMrZ2xzpwayvFl78vKt4fvc9vygAJzIky0nAyHdQDm9VQ6fcdyuRYIMm0m8cFTEt0smdGv5djJOrTL+UHpllhxN+5K0zq7f/hoE22ezCEPueQUHtZpiLgHWPPoDcAXHg/PAZYdhjbfe6RftRPHvcQmUZLPdf6dKEK0/nsEAmEiZxl2vxleQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector2-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FkxZ10j7Yxn9qVJ15kCLklnBo/nMpApGJUzkaHx3MUk=;
 b=pWzOFfkquqjLZRWv1o+088pTGIsb0IKlXeDDAACHuZ+kcOZ6E3gsrpRwIoZ0O7cyd1qXLrxkg+Gy7AR3WVdMAOcW4d8Ohi878qUq9cj4eoob7dw87SncN+xbB+HjzXD1ZAAIHXHQ30gaWxDTlF41qPcANoYnBwVYFo4CVLiOdAA=
Received: from MN2PR18MB2605.namprd18.prod.outlook.com (20.179.83.161) by
 MN2PR18MB3230.namprd18.prod.outlook.com (10.255.237.15) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2157.14; Thu, 8 Aug 2019 12:17:39 +0000
Received: from MN2PR18MB2605.namprd18.prod.outlook.com
 ([fe80::2dbc:3002:6213:bc9a]) by MN2PR18MB2605.namprd18.prod.outlook.com
 ([fe80::2dbc:3002:6213:bc9a%3]) with mapi id 15.20.2136.018; Thu, 8 Aug 2019
 12:17:39 +0000
From:   Phani Kiran Hemadri <phemadri@marvell.com>
To:     "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Phani Kiran Hemadri" <phemadri@marvell.com>
Subject: [PATCH 2/2] crypto: cavium/nitrox - Configure asymmetric queue
 manager Hardware unit
Thread-Topic: [PATCH 2/2] crypto: cavium/nitrox - Configure asymmetric queue
 manager Hardware unit
Thread-Index: AQHVTeNF6cdxM3e6x02hKBUjb8nstw==
Date:   Thu, 8 Aug 2019 12:17:39 +0000
Message-ID: <20190808121711.26495-2-phemadri@marvell.com>
References: <20190808121711.26495-1-phemadri@marvell.com>
In-Reply-To: <20190808121711.26495-1-phemadri@marvell.com>
Accept-Language: en-IN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: PN1PR01CA0077.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c00:1::17) To MN2PR18MB2605.namprd18.prod.outlook.com
 (2603:10b6:208:106::33)
x-ms-exchange-messagesentrepresentingtype: 1
x-mailer: git-send-email 2.17.2
x-originating-ip: [115.113.156.2]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 32e8bb54-bff1-490b-f658-08d71bfa67a5
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(7168020)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:MN2PR18MB3230;
x-ms-traffictypediagnostic: MN2PR18MB3230:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MN2PR18MB3230FC0C32897292A0A38FBAD6D70@MN2PR18MB3230.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:16;
x-forefront-prvs: 012349AD1C
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(366004)(376002)(396003)(346002)(39850400004)(199004)(189003)(6436002)(6116002)(66446008)(66556008)(66946007)(386003)(64756008)(7736002)(186003)(2616005)(2351001)(476003)(6506007)(99286004)(478600001)(50226002)(11346002)(8676002)(305945005)(102836004)(25786009)(316002)(2501003)(256004)(14444005)(66066001)(54906003)(107886003)(6916009)(486006)(53936002)(6512007)(1076003)(76176011)(5640700003)(55236004)(66476007)(6486002)(52116002)(1730700003)(3846002)(36756003)(81156014)(5660300002)(4326008)(446003)(30864003)(86362001)(14454004)(26005)(2906002)(71200400001)(71190400001)(81166006)(8936002);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR18MB3230;H:MN2PR18MB2605.namprd18.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: marvell.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: ZtIiFM8PwPuGsjNgNe4CflXOEeXDhCY13PSEuk+592aJM++as+0HRZG1sjluAVVKTLho13N+ZLmXzUwRABPnF5UzWlMZFB1Wl4lAQgmFzNTaMqbvQZLn17YvhKYzKg6IERH8M9Ag9FbblTz7SD3PNUvzFqrindEf3tglxyO0I2+GiyqAEO1ttdQqmwM2dBdWrV/UguYo8KlMs654DncZchidvkS8PeLuVozPdaJWmnLdxa6PmISLgrf6q2rk2TP5NLKGERaj/RK+88Ac3GDPSGeOp4KNzTRFNnziMwkqIyfLyY8giZtWvaqHSEgQb1itctKI5hIy/Xx4WcJlMim4IPVR3sgtjVDnzoOhxEQ+P2/LnxM3WqJCXc4WtLRRfNnszAXwpE6St4MTPTyuBvH5LLDvk+EyEMKLPWqUObpDLWk=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 32e8bb54-bff1-490b-f658-08d71bfa67a5
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Aug 2019 12:17:39.4196
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: phemadri@marvell.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR18MB3230
X-OriginatorOrg: marvell.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:5.22.84,1.0.8
 definitions=2019-08-08_06:2019-08-07,2019-08-08 signatures=0
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

This patch configures and initializes CNN55XX device AQM hardware unit.

Signed-off-by: Phani Kiran Hemadri <phemadri@marvell.com>
Reviewed-by: Srikanth Jampala <jsrikanth@marvell.com>
---
 drivers/crypto/cavium/nitrox/nitrox_csr.h   | 111 ++++++++++++++
 drivers/crypto/cavium/nitrox/nitrox_hal.c   | 158 ++++++++++++++++++--
 drivers/crypto/cavium/nitrox/nitrox_hal.h   |   6 +-
 drivers/crypto/cavium/nitrox/nitrox_main.c  |   4 +-
 drivers/crypto/cavium/nitrox/nitrox_sriov.c |   3 +
 5 files changed, 265 insertions(+), 17 deletions(-)

diff --git a/drivers/crypto/cavium/nitrox/nitrox_csr.h b/drivers/crypto/cav=
ium/nitrox/nitrox_csr.h
index da1d73303780..1c8715ae0488 100644
--- a/drivers/crypto/cavium/nitrox/nitrox_csr.h
+++ b/drivers/crypto/cavium/nitrox/nitrox_csr.h
@@ -256,6 +256,117 @@ union aqm_grp_execmsk_hi {
 	};
 };
=20
+/**
+ * struct aqmq_drbl - AQM Queue Doorbell Counter Registers
+ * @dbell_count: Doorbell Counter
+ */
+union aqmq_drbl {
+	u64 value;
+	struct {
+#if (defined(__BIG_ENDIAN_BITFIELD))
+		u64 raz_32_63 : 32;
+		u64 dbell_count : 32;
+#else
+		u64 dbell_count : 32;
+		u64 raz_32_63 : 32;
+#endif
+	};
+};
+
+/**
+ * struct aqmq_qsz - AQM Queue Host Queue Size Registers
+ * @host_queue_size: Size, in numbers of 'aqmq_command_s' command
+ * of the Host Ring.
+ */
+union aqmq_qsz {
+	u64 value;
+	struct {
+#if (defined(__BIG_ENDIAN_BITFIELD))
+		u64 raz_32_63 : 32;
+		u64 host_queue_size : 32;
+#else
+		u64 host_queue_size : 32;
+		u64 raz_32_63 : 32;
+#endif
+	};
+};
+
+/**
+ * struct aqmq_cmp_thr - AQM Queue Commands Completed Threshold Registers
+ * @commands_completed_threshold: Count of 'aqmq_command_s' commands execu=
ted
+ * by AE engines for which completion interrupt is asserted.
+ */
+union aqmq_cmp_thr {
+	u64 value;
+	struct {
+#if (defined(__BIG_ENDIAN_BITFIELD))
+		u64 raz_32_63 : 32;
+		u64 commands_completed_threshold : 32;
+#else
+		u64 commands_completed_threshold : 32;
+		u64 raz_32_63 : 32;
+#endif
+	};
+};
+
+/**
+ * struct aqmq_cmp_cnt - AQM Queue Commands Completed Count Registers
+ * @resend: Bit to request completion interrupt Resend.
+ * @completion_status: Command completion status of the ring.
+ * @commands_completed_count: Count of 'aqmq_command_s' commands executed =
by
+ * AE engines.
+ */
+union aqmq_cmp_cnt {
+	u64 value;
+	struct {
+#if (defined(__BIG_ENDIAN_BITFIELD))
+		u64 raz_34_63 : 30;
+		u64 resend : 1;
+		u64 completion_status : 1;
+		u64 commands_completed_count : 32;
+#else
+		u64 commands_completed_count : 32;
+		u64 completion_status : 1;
+		u64 resend : 1;
+		u64 raz_34_63 : 30;
+#endif
+	};
+};
+
+/**
+ * struct aqmq_en - AQM Queue Enable Registers
+ * @queue_status: 1 =3D AQMQ is enabled, 0 =3D AQMQ is disabled
+ */
+union aqmq_en {
+	u64 value;
+	struct {
+#if (defined(__BIG_ENDIAN_BITFIELD))
+		u64 raz_1_63 : 63;
+		u64 queue_enable : 1;
+#else
+		u64 queue_enable : 1;
+		u64 raz_1_63 : 63;
+#endif
+	};
+};
+
+/**
+ * struct aqmq_activity_stat - AQM Queue Activity Status Registers
+ * @queue_active: 1 =3D AQMQ is active, 0 =3D AQMQ is quiescent
+ */
+union aqmq_activity_stat {
+	u64 value;
+	struct {
+#if (defined(__BIG_ENDIAN_BITFIELD))
+		u64 raz_1_63 : 63;
+		u64 queue_active : 1;
+#else
+		u64 queue_active : 1;
+		u64 raz_1_63 : 63;
+#endif
+	};
+};
+
 /**
  * struct emu_fuse_map - EMU Fuse Map Registers
  * @ae_fuse: Fuse settings for AE 19..0
diff --git a/drivers/crypto/cavium/nitrox/nitrox_hal.c b/drivers/crypto/cav=
ium/nitrox/nitrox_hal.c
index 3f0df60267a9..34a2f4f30a7e 100644
--- a/drivers/crypto/cavium/nitrox/nitrox_hal.c
+++ b/drivers/crypto/cavium/nitrox/nitrox_hal.c
@@ -241,12 +241,12 @@ void nitrox_config_pkt_solicit_ports(struct nitrox_de=
vice *ndev)
 }
=20
 /**
- * enable_nps_interrupts - enable NPS interrutps
+ * enable_nps_core_interrupts - enable NPS core interrutps
  * @ndev: NITROX device.
  *
- * This includes NPS core, packet in and slc interrupts.
+ * This includes NPS core interrupts.
  */
-static void enable_nps_interrupts(struct nitrox_device *ndev)
+static void enable_nps_core_interrupts(struct nitrox_device *ndev)
 {
 	union nps_core_int_ena_w1s core_int;
=20
@@ -258,18 +258,9 @@ static void enable_nps_interrupts(struct nitrox_device=
 *ndev)
 	core_int.s.npco_dma_malform =3D 1;
 	core_int.s.host_nps_wr_err =3D 1;
 	nitrox_write_csr(ndev, NPS_CORE_INT_ENA_W1S, core_int.value);
-
-	/* NPS packet in ring interrupts */
-	nitrox_write_csr(ndev, NPS_PKT_IN_RERR_LO_ENA_W1S, (~0ULL));
-	nitrox_write_csr(ndev, NPS_PKT_IN_RERR_HI_ENA_W1S, (~0ULL));
-	nitrox_write_csr(ndev, NPS_PKT_IN_ERR_TYPE_ENA_W1S, (~0ULL));
-	/* NPS packet slc port interrupts */
-	nitrox_write_csr(ndev, NPS_PKT_SLC_RERR_HI_ENA_W1S, (~0ULL));
-	nitrox_write_csr(ndev, NPS_PKT_SLC_RERR_LO_ENA_W1S, (~0ULL));
-	nitrox_write_csr(ndev, NPS_PKT_SLC_ERR_TYPE_ENA_W1S, (~0uLL));
 }
=20
-void nitrox_config_nps_unit(struct nitrox_device *ndev)
+void nitrox_config_nps_core_unit(struct nitrox_device *ndev)
 {
 	union nps_core_gbl_vfcfg core_gbl_vfcfg;
=20
@@ -281,12 +272,149 @@ void nitrox_config_nps_unit(struct nitrox_device *nd=
ev)
 	core_gbl_vfcfg.s.ilk_disable =3D 1;
 	core_gbl_vfcfg.s.cfg =3D __NDEV_MODE_PF;
 	nitrox_write_csr(ndev, NPS_CORE_GBL_VFCFG, core_gbl_vfcfg.value);
+
+	/* enable nps core interrupts */
+	enable_nps_core_interrupts(ndev);
+}
+
+/**
+ * enable_nps_pkt_interrupts - enable NPS packet interrutps
+ * @ndev: NITROX device.
+ *
+ * This includes NPS packet in and slc interrupts.
+ */
+static void enable_nps_pkt_interrupts(struct nitrox_device *ndev)
+{
+	/* NPS packet in ring interrupts */
+	nitrox_write_csr(ndev, NPS_PKT_IN_RERR_LO_ENA_W1S, (~0ULL));
+	nitrox_write_csr(ndev, NPS_PKT_IN_RERR_HI_ENA_W1S, (~0ULL));
+	nitrox_write_csr(ndev, NPS_PKT_IN_ERR_TYPE_ENA_W1S, (~0ULL));
+	/* NPS packet slc port interrupts */
+	nitrox_write_csr(ndev, NPS_PKT_SLC_RERR_HI_ENA_W1S, (~0ULL));
+	nitrox_write_csr(ndev, NPS_PKT_SLC_RERR_LO_ENA_W1S, (~0ULL));
+	nitrox_write_csr(ndev, NPS_PKT_SLC_ERR_TYPE_ENA_W1S, (~0uLL));
+}
+
+void nitrox_config_nps_pkt_unit(struct nitrox_device *ndev)
+{
 	/* config input and solicit ports */
 	nitrox_config_pkt_input_rings(ndev);
 	nitrox_config_pkt_solicit_ports(ndev);
=20
-	/* enable interrupts */
-	enable_nps_interrupts(ndev);
+	/* enable nps packet interrupts */
+	enable_nps_pkt_interrupts(ndev);
+}
+
+static void reset_aqm_ring(struct nitrox_device *ndev, int ring)
+{
+	union aqmq_en aqmq_en_reg;
+	union aqmq_activity_stat activity_stat;
+	union aqmq_cmp_cnt cmp_cnt;
+	int max_retries =3D MAX_CSR_RETRIES;
+	u64 offset;
+
+	/* step 1: disable the queue */
+	offset =3D AQMQ_ENX(ring);
+	aqmq_en_reg.value =3D 0;
+	aqmq_en_reg.queue_enable =3D 0;
+	nitrox_write_csr(ndev, offset, aqmq_en_reg.value);
+
+	/* step 2: wait for AQMQ_ACTIVITY_STATX[QUEUE_ACTIVE] to clear */
+	usleep_range(100, 150);
+	offset =3D AQMQ_ACTIVITY_STATX(ring);
+	do {
+		activity_stat.value =3D nitrox_read_csr(ndev, offset);
+		if (!activity_stat.queue_active)
+			break;
+		udelay(50);
+	} while (max_retries--);
+
+	/* step 3: clear commands completed count */
+	offset =3D AQMQ_CMP_CNTX(ring);
+	cmp_cnt.value =3D nitrox_read_csr(ndev, offset);
+	nitrox_write_csr(ndev, offset, cmp_cnt.value);
+	usleep_range(50, 100);
+}
+
+void enable_aqm_ring(struct nitrox_device *ndev, int ring)
+{
+	union aqmq_en aqmq_en_reg;
+	u64 offset;
+
+	offset =3D AQMQ_ENX(ring);
+	aqmq_en_reg.value =3D 0;
+	aqmq_en_reg.queue_enable =3D 1;
+	nitrox_write_csr(ndev, offset, aqmq_en_reg.value);
+	usleep_range(50, 100);
+}
+
+void nitrox_config_aqm_rings(struct nitrox_device *ndev)
+{
+	int ring;
+
+	for (ring =3D 0; ring < ndev->nr_queues; ring++) {
+		struct nitrox_cmdq *cmdq =3D ndev->aqmq[ring];
+		union aqmq_drbl drbl;
+		union aqmq_qsz qsize;
+		union aqmq_cmp_thr cmp_thr;
+		u64 offset;
+
+		/* steps 1 - 3 */
+		reset_aqm_ring(ndev, ring);
+
+		/* step 4: clear doorbell count of ring */
+		offset =3D AQMQ_DRBLX(ring);
+		drbl.value =3D 0;
+		drbl.dbell_count =3D 0xFFFFFFFF;
+		nitrox_write_csr(ndev, offset, drbl.value);
+
+		/* step 5: configure host ring details */
+
+		/* set host address for next command of ring */
+		offset =3D AQMQ_NXT_CMDX(ring);
+		nitrox_write_csr(ndev, offset, 0ULL);
+
+		/* set host address of ring base */
+		offset =3D AQMQ_BADRX(ring);
+		nitrox_write_csr(ndev, offset, cmdq->dma);
+
+		/* set ring size */
+		offset =3D AQMQ_QSZX(ring);
+		qsize.value =3D 0;
+		qsize.host_queue_size =3D ndev->qlen;
+		nitrox_write_csr(ndev, offset, qsize.value);
+
+		/* set command completion threshold */
+		offset =3D AQMQ_CMP_THRX(ring);
+		cmp_thr.value =3D 0;
+		cmp_thr.commands_completed_threshold =3D 1;
+		nitrox_write_csr(ndev, offset, cmp_thr.value);
+
+		/* step 6: enable the queue */
+		enable_aqm_ring(ndev, ring);
+	}
+}
+
+static void enable_aqm_interrupts(struct nitrox_device *ndev)
+{
+	/* clear interrupt enable bits */
+	nitrox_write_csr(ndev, AQM_DBELL_OVF_LO_ENA_W1S, (~0ULL));
+	nitrox_write_csr(ndev, AQM_DBELL_OVF_HI_ENA_W1S, (~0ULL));
+	nitrox_write_csr(ndev, AQM_DMA_RD_ERR_LO_ENA_W1S, (~0ULL));
+	nitrox_write_csr(ndev, AQM_DMA_RD_ERR_HI_ENA_W1S, (~0ULL));
+	nitrox_write_csr(ndev, AQM_EXEC_NA_LO_ENA_W1S, (~0ULL));
+	nitrox_write_csr(ndev, AQM_EXEC_NA_HI_ENA_W1S, (~0ULL));
+	nitrox_write_csr(ndev, AQM_EXEC_ERR_LO_ENA_W1S, (~0ULL));
+	nitrox_write_csr(ndev, AQM_EXEC_ERR_HI_ENA_W1S, (~0ULL));
+}
+
+void nitrox_config_aqm_unit(struct nitrox_device *ndev)
+{
+	/* config aqm command queues */
+	nitrox_config_aqm_rings(ndev);
+
+	/* enable aqm interrupts */
+	enable_aqm_interrupts(ndev);
 }
=20
 void nitrox_config_pom_unit(struct nitrox_device *ndev)
diff --git a/drivers/crypto/cavium/nitrox/nitrox_hal.h b/drivers/crypto/cav=
ium/nitrox/nitrox_hal.h
index d6606418ba38..48b0af039099 100644
--- a/drivers/crypto/cavium/nitrox/nitrox_hal.h
+++ b/drivers/crypto/cavium/nitrox/nitrox_hal.h
@@ -4,10 +4,13 @@
=20
 #include "nitrox_dev.h"
=20
+void nitrox_config_aqm_rings(struct nitrox_device *ndev);
+void nitrox_config_aqm_unit(struct nitrox_device *ndev);
 void nitrox_config_emu_unit(struct nitrox_device *ndev);
 void nitrox_config_pkt_input_rings(struct nitrox_device *ndev);
 void nitrox_config_pkt_solicit_ports(struct nitrox_device *ndev);
-void nitrox_config_nps_unit(struct nitrox_device *ndev);
+void nitrox_config_nps_core_unit(struct nitrox_device *ndev);
+void nitrox_config_nps_pkt_unit(struct nitrox_device *ndev);
 void nitrox_config_pom_unit(struct nitrox_device *ndev);
 void nitrox_config_rand_unit(struct nitrox_device *ndev);
 void nitrox_config_efl_unit(struct nitrox_device *ndev);
@@ -15,6 +18,7 @@ void nitrox_config_bmi_unit(struct nitrox_device *ndev);
 void nitrox_config_bmo_unit(struct nitrox_device *ndev);
 void nitrox_config_lbc_unit(struct nitrox_device *ndev);
 void invalidate_lbc(struct nitrox_device *ndev);
+void enable_aqm_ring(struct nitrox_device *ndev, int qno);
 void enable_pkt_input_ring(struct nitrox_device *ndev, int ring);
 void enable_pkt_solicit_port(struct nitrox_device *ndev, int port);
 void config_nps_core_vfcfg_mode(struct nitrox_device *ndev, enum vf_mode m=
ode);
diff --git a/drivers/crypto/cavium/nitrox/nitrox_main.c b/drivers/crypto/ca=
vium/nitrox/nitrox_main.c
index 345d3ea10b1f..bc924980e10c 100644
--- a/drivers/crypto/cavium/nitrox/nitrox_main.c
+++ b/drivers/crypto/cavium/nitrox/nitrox_main.c
@@ -387,7 +387,9 @@ static int nitrox_pf_hw_init(struct nitrox_device *ndev=
)
 	/* get cores information */
 	nitrox_get_hwinfo(ndev);
=20
-	nitrox_config_nps_unit(ndev);
+	nitrox_config_nps_core_unit(ndev);
+	nitrox_config_aqm_unit(ndev);
+	nitrox_config_nps_pkt_unit(ndev);
 	nitrox_config_pom_unit(ndev);
 	nitrox_config_efl_unit(ndev);
 	/* configure IO units */
diff --git a/drivers/crypto/cavium/nitrox/nitrox_sriov.c b/drivers/crypto/c=
avium/nitrox/nitrox_sriov.c
index bf439d8256ba..43287f8471d1 100644
--- a/drivers/crypto/cavium/nitrox/nitrox_sriov.c
+++ b/drivers/crypto/cavium/nitrox/nitrox_sriov.c
@@ -109,6 +109,9 @@ static int nitrox_pf_reinit(struct nitrox_device *ndev)
 		return err;
 	}
=20
+	/* configure the AQM queues */
+	nitrox_config_aqm_rings(ndev);
+
 	/* configure the packet queues */
 	nitrox_config_pkt_input_rings(ndev);
 	nitrox_config_pkt_solicit_ports(ndev);
--=20
2.17.2

