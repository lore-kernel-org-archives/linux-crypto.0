Return-Path: <SRS0=IdBJ=WE=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EACA4C0650F
	for <linux-crypto@archiver.kernel.org>; Thu,  8 Aug 2019 12:17:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9D57A214C6
	for <linux-crypto@archiver.kernel.org>; Thu,  8 Aug 2019 12:17:51 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="IMrwVsIM";
	dkim=pass (1024-bit key) header.d=marvell.onmicrosoft.com header.i=@marvell.onmicrosoft.com header.b="QkCpfVyw"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729410AbfHHMRu (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 8 Aug 2019 08:17:50 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:50766 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727242AbfHHMRu (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 8 Aug 2019 08:17:50 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id x78C9xs1014128;
        Thu, 8 Aug 2019 05:17:43 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : content-type : content-transfer-encoding :
 mime-version; s=pfpt0818; bh=ieZtFjnLiFCfQq5o/B18+SCUiq8TcKOGpOWbx5Drf8Y=;
 b=IMrwVsIMp0s7JRY5ONvv3HThR1D4mHuMggrT8sMxxyIvKpglCSX/M7A9iW96XvxnSLrF
 1C1QdC1+1bpzi6Vhjaig3f7W5K/39QgkxPEr1iK6KDXkoBzf29+Cj8Q+k9LFXRsXStti
 CXbhMMlmdinohIJoS11PaLZGM8d8/sDz0AJNLKW/smVEPLKzi37MRsMyEOwEIdkRqZqb
 klLsnfOkmy9ZTJkQAckqGqEPa1un+KKV5/IPeKwjYBqTwyj8SGQBNWwYYAknoV8FpY3I
 aWFMH+GnL889JFmCDVS+rB+gRWKLOiHiaMAvD5ESNlwx4nKUko/rdDoObtpwIHMV6+2R 4w== 
Received: from sc-exch04.marvell.com ([199.233.58.184])
        by mx0a-0016f401.pphosted.com with ESMTP id 2u8cqj9efe-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Thu, 08 Aug 2019 05:17:43 -0700
Received: from SC-EXCH03.marvell.com (10.93.176.83) by SC-EXCH04.marvell.com
 (10.93.176.84) with Microsoft SMTP Server (TLS) id 15.0.1367.3; Thu, 8 Aug
 2019 05:17:42 -0700
Received: from NAM04-BN3-obe.outbound.protection.outlook.com (104.47.46.58) by
 SC-EXCH03.marvell.com (10.93.176.83) with Microsoft SMTP Server (TLS) id
 15.0.1367.3 via Frontend Transport; Thu, 8 Aug 2019 05:17:42 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=m0/1aBjqutSG4P3srApE8CHKpAo+DjT7MkM1OHKgycBWwvwgvfbiMrppwZpXeHrr9wMO8GvK07szIFgLih16Q2ZPsA7jivQX5Msq8VWDK0Zn0OMKnQb8anjN07ofWhYjrE6DKaAYSLBCGrtDPdQcQBjmAXRHBlvYoyPNpkB09onh9+hZMc5mqIPe3oc4jo431Hc+wQKxQ4rPI9WYWuOfEsL4Yor8bB02vXYjBA7+edDgbCRjbV/5eWpkxJLkjK36VMlX6n5xUsvHc/yWKVuhkni5yFOfJTynkiUuQYqrguME8fCYgaVl6xCN+IuUqzSkoJs4Q72wbEgmun8PSlickg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ieZtFjnLiFCfQq5o/B18+SCUiq8TcKOGpOWbx5Drf8Y=;
 b=BfCXW0iVuQkYKIroECGZjtYG5SVpDOasCo/+hQSlvG391e4vTO7LyJgh7EKEdkWpXNWVJ1/2vWa2l4OIK8Z8NpCBaL5I+rhh+eW1845g8bINaxfEu4/ZTVz9ecYUAYtQKds+GQTkVYcq4JdNj6fyEkUdDhPMqEj0QrWl7DGTlrBjg/EERMxqkKGCPjziVfIEURFdpJ85NAHcjCjcm2DXkyHTqVAJMi6wtpV4X7LSWQ7jLFZeKNgBP9zdxDcI9t9Vz83FaKoLvet36PU4TT9puEn4BQPicGwenGADY0OVKHkWeKprEuLTdy14ofc29N7lCIU6QlfRMmurWRuxHZpYLQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector2-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ieZtFjnLiFCfQq5o/B18+SCUiq8TcKOGpOWbx5Drf8Y=;
 b=QkCpfVywM/1o4YNKP9fdE9DyzyJARdyneP/4c1gBCy2XtgUngmiBwy76lHwWQmwEUsv2d3wZz5xGK2Y1xkCO9bJewBkfAIfqD2xQsi1sivQs0FH/jrvo5fj2bLf7RQvJaTdFfUAjnX5qAidmveZLFRBKmlmUY79yEU8n8Y2j1L0=
Received: from MN2PR18MB2605.namprd18.prod.outlook.com (20.179.83.161) by
 MN2PR18MB3230.namprd18.prod.outlook.com (10.255.237.15) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2157.14; Thu, 8 Aug 2019 12:17:37 +0000
Received: from MN2PR18MB2605.namprd18.prod.outlook.com
 ([fe80::2dbc:3002:6213:bc9a]) by MN2PR18MB2605.namprd18.prod.outlook.com
 ([fe80::2dbc:3002:6213:bc9a%3]) with mapi id 15.20.2136.018; Thu, 8 Aug 2019
 12:17:37 +0000
From:   Phani Kiran Hemadri <phemadri@marvell.com>
To:     "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Phani Kiran Hemadri" <phemadri@marvell.com>
Subject: [PATCH 1/2] crypto: cavium/nitrox - Allocate asymmetric crypto
 command queues
Thread-Topic: [PATCH 1/2] crypto: cavium/nitrox - Allocate asymmetric crypto
 command queues
Thread-Index: AQHVTeNDaUG9EbiZ40GDR1+KZa+d4g==
Date:   Thu, 8 Aug 2019 12:17:37 +0000
Message-ID: <20190808121711.26495-1-phemadri@marvell.com>
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
x-ms-office365-filtering-correlation-id: e630e2b5-4145-4c8d-62ab-08d71bfa6667
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(7168020)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:MN2PR18MB3230;
x-ms-traffictypediagnostic: MN2PR18MB3230:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MN2PR18MB3230FC424F9D0C21E1ECF5BDD6D70@MN2PR18MB3230.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:200;
x-forefront-prvs: 012349AD1C
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(366004)(376002)(396003)(346002)(39850400004)(199004)(189003)(6436002)(6116002)(66446008)(66556008)(66946007)(386003)(64756008)(7736002)(186003)(2616005)(2351001)(476003)(6506007)(99286004)(478600001)(50226002)(8676002)(305945005)(102836004)(25786009)(316002)(2501003)(256004)(14444005)(66066001)(54906003)(107886003)(6916009)(486006)(53936002)(6512007)(1076003)(5640700003)(55236004)(66476007)(6486002)(52116002)(1730700003)(3846002)(36756003)(81156014)(5660300002)(4326008)(86362001)(14454004)(26005)(2906002)(71200400001)(71190400001)(81166006)(8936002);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR18MB3230;H:MN2PR18MB2605.namprd18.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: marvell.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: 237MyBn45I0riWcy75pshXSUhu3u6jhTpJnOmEfUdUhfYhW+1q1K3p3KIIwpjSXbdle5M2IYhZx8oBC1Bfb6vv2aX1fdJ0jZZTO5NVvnhRRMUqRa0wLePOOS7V2uWXj2zwM9iJgm610ZQmuNb35/LiD9JuLd2XXL7o5v8BnE+Llw0SuUGd5H8luU+hB18MTCe9EQh1h3Z6KcCFkoyvAu2aWIuy8fQxmkWeTkkdYoWm9kXyTwy87iWddZe/FmUCRg71GzirkQQ7MKN919UoQBqqUfFRWeA7IN+tBwTKccV27sOm4F7+PDFL0piTDhj6i591/TwcxqhXX89azzf1RKREjtMFJv/81CTEOB9TpKr4TVXKp4xQrsdIHijzjxcIMsLPxorEtPr+tRNmhT6JV3XgllUoU0Ct+Uipmm02M/RaU=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: e630e2b5-4145-4c8d-62ab-08d71bfa6667
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Aug 2019 12:17:37.2198
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

This patch adds support to allocate CNN55XX device AQMQ command queues
required for submitting asymmetric crypto requests.

Signed-off-by: Phani Kiran Hemadri <phemadri@marvell.com>
Reviewed-by: Srikanth Jampala <jsrikanth@marvell.com>
---
 drivers/crypto/cavium/nitrox/nitrox_dev.h |  4 ++
 drivers/crypto/cavium/nitrox/nitrox_lib.c | 66 ++++++++++++++++++++++-
 drivers/crypto/cavium/nitrox/nitrox_req.h | 30 +++++++++++
 3 files changed, 99 insertions(+), 1 deletion(-)

diff --git a/drivers/crypto/cavium/nitrox/nitrox_dev.h b/drivers/crypto/cav=
ium/nitrox/nitrox_dev.h
index 5ee98eca728c..2217a2736c8e 100644
--- a/drivers/crypto/cavium/nitrox/nitrox_dev.h
+++ b/drivers/crypto/cavium/nitrox/nitrox_dev.h
@@ -10,6 +10,8 @@
 #define VERSION_LEN 32
 /* Maximum queues in PF mode */
 #define MAX_PF_QUEUES	64
+/* Maximum device queues */
+#define MAX_DEV_QUEUES (MAX_PF_QUEUES)
 /* Maximum UCD Blocks */
 #define CNN55XX_MAX_UCD_BLOCKS	8
=20
@@ -208,6 +210,7 @@ enum vf_mode {
  * @mode: Device mode PF/VF
  * @ctx_pool: DMA pool for crypto context
  * @pkt_inq: Packet input rings
+ * @aqmq: AQM command queues
  * @qvec: MSI-X queue vectors information
  * @iov: SR-IOV informatin
  * @num_vecs: number of MSI-X vectors
@@ -234,6 +237,7 @@ struct nitrox_device {
=20
 	struct dma_pool *ctx_pool;
 	struct nitrox_cmdq *pkt_inq;
+	struct nitrox_cmdq *aqmq[MAX_DEV_QUEUES] ____cacheline_aligned_in_smp;
=20
 	struct nitrox_q_vector *qvec;
 	struct nitrox_iov iov;
diff --git a/drivers/crypto/cavium/nitrox/nitrox_lib.c b/drivers/crypto/cav=
ium/nitrox/nitrox_lib.c
index 4ace9bcd603a..5cbc64b851b9 100644
--- a/drivers/crypto/cavium/nitrox/nitrox_lib.c
+++ b/drivers/crypto/cavium/nitrox/nitrox_lib.c
@@ -19,6 +19,8 @@
=20
 /* packet inuput ring alignments */
 #define PKTIN_Q_ALIGN_BYTES 16
+/* AQM Queue input alignments */
+#define AQM_Q_ALIGN_BYTES 32
=20
 static int nitrox_cmdq_init(struct nitrox_cmdq *cmdq, int align_bytes)
 {
@@ -57,11 +59,15 @@ static void nitrox_cmdq_reset(struct nitrox_cmdq *cmdq)
=20
 static void nitrox_cmdq_cleanup(struct nitrox_cmdq *cmdq)
 {
-	struct nitrox_device *ndev =3D cmdq->ndev;
+	struct nitrox_device *ndev;
+
+	if (!cmdq)
+		return;
=20
 	if (!cmdq->unalign_base)
 		return;
=20
+	ndev =3D cmdq->ndev;
 	cancel_work_sync(&cmdq->backlog_qflush);
=20
 	dma_free_coherent(DEV(ndev), cmdq->qsize,
@@ -78,6 +84,57 @@ static void nitrox_cmdq_cleanup(struct nitrox_cmdq *cmdq=
)
 	cmdq->instr_size =3D 0;
 }
=20
+static void nitrox_free_aqm_queues(struct nitrox_device *ndev)
+{
+	int i;
+
+	for (i =3D 0; i < ndev->nr_queues; i++) {
+		nitrox_cmdq_cleanup(ndev->aqmq[i]);
+		kzfree(ndev->aqmq[i]);
+		ndev->aqmq[i] =3D NULL;
+	}
+}
+
+static int nitrox_alloc_aqm_queues(struct nitrox_device *ndev)
+{
+	int i, err;
+
+	for (i =3D 0; i < ndev->nr_queues; i++) {
+		struct nitrox_cmdq *cmdq;
+		u64 offset;
+
+		cmdq =3D kzalloc_node(sizeof(*cmdq), GFP_KERNEL, ndev->node);
+		if (!cmdq) {
+			err =3D -ENOMEM;
+			goto aqmq_fail;
+		}
+
+		cmdq->ndev =3D ndev;
+		cmdq->qno =3D i;
+		cmdq->instr_size =3D sizeof(struct aqmq_command_s);
+
+		/* AQM Queue Doorbell Counter Register Address */
+		offset =3D AQMQ_DRBLX(i);
+		cmdq->dbell_csr_addr =3D NITROX_CSR_ADDR(ndev, offset);
+		/* AQM Queue Commands Completed Count Register Address */
+		offset =3D AQMQ_CMD_CNTX(i);
+		cmdq->compl_cnt_csr_addr =3D NITROX_CSR_ADDR(ndev, offset);
+
+		err =3D nitrox_cmdq_init(cmdq, AQM_Q_ALIGN_BYTES);
+		if (err) {
+			kzfree(cmdq);
+			goto aqmq_fail;
+		}
+		ndev->aqmq[i] =3D cmdq;
+	}
+
+	return 0;
+
+aqmq_fail:
+	nitrox_free_aqm_queues(ndev);
+	return err;
+}
+
 static void nitrox_free_pktin_queues(struct nitrox_device *ndev)
 {
 	int i;
@@ -222,6 +279,12 @@ int nitrox_common_sw_init(struct nitrox_device *ndev)
 	if (err)
 		destroy_crypto_dma_pool(ndev);
=20
+	err =3D nitrox_alloc_aqm_queues(ndev);
+	if (err) {
+		nitrox_free_pktin_queues(ndev);
+		destroy_crypto_dma_pool(ndev);
+	}
+
 	return err;
 }
=20
@@ -231,6 +294,7 @@ int nitrox_common_sw_init(struct nitrox_device *ndev)
  */
 void nitrox_common_sw_cleanup(struct nitrox_device *ndev)
 {
+	nitrox_free_aqm_queues(ndev);
 	nitrox_free_pktin_queues(ndev);
 	destroy_crypto_dma_pool(ndev);
 }
diff --git a/drivers/crypto/cavium/nitrox/nitrox_req.h b/drivers/crypto/cav=
ium/nitrox/nitrox_req.h
index efdbd0fc3e3b..f69ba02c4d25 100644
--- a/drivers/crypto/cavium/nitrox/nitrox_req.h
+++ b/drivers/crypto/cavium/nitrox/nitrox_req.h
@@ -399,6 +399,36 @@ struct nps_pkt_instr {
 	u64 fdata[2];
 };
=20
+/**
+ * struct aqmq_command_s - The 32 byte command for AE processing.
+ * @opcode: Request opcode
+ * @param1: Request control parameter 1
+ * @param2: Request control parameter 2
+ * @dlen: Input length
+ * @dptr: Input pointer points to buffer in remote host
+ * @rptr: Result pointer points to buffer in remote host
+ * @grp: AQM Group (0..7)
+ * @cptr: Context pointer
+ */
+struct aqmq_command_s {
+	__be16 opcode;
+	__be16 param1;
+	__be16 param2;
+	__be16 dlen;
+	__be64 dptr;
+	__be64 rptr;
+	union {
+		__be64 word3;
+#if defined(__BIG_ENDIAN_BITFIELD)
+		u64 grp : 3;
+		u64 cptr : 61;
+#else
+		u64 cptr : 61;
+		u64 grp : 3;
+#endif
+	};
+};
+
 /**
  * struct ctx_hdr - Book keeping data about the crypto context
  * @pool: Pool used to allocate crypto context
--=20
2.17.2

