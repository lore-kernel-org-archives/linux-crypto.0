Return-Path: <SRS0=f1VZ=XN=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 49049C4CEC4
	for <linux-crypto@archiver.kernel.org>; Wed, 18 Sep 2019 09:39:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 08B36218AF
	for <linux-crypto@archiver.kernel.org>; Wed, 18 Sep 2019 09:39:48 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="PwdS/Eix";
	dkim=pass (1024-bit key) header.d=marvell.onmicrosoft.com header.i=@marvell.onmicrosoft.com header.b="m5Y1H/qs"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726772AbfIRJjr (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 18 Sep 2019 05:39:47 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:2146 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726382AbfIRJjr (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 18 Sep 2019 05:39:47 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id x8I9ZQYs010577;
        Wed, 18 Sep 2019 02:39:38 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : content-type : content-transfer-encoding :
 mime-version; s=pfpt0818; bh=1YxlYm7hz6Dp6VyliP4Ie2oWjHnMdKc0ZotKYsLPgUU=;
 b=PwdS/Eix0lTovrdbD+vwCPESn0DiYp0FalOJZf/rxpDC0NKmMeHUfQ21795vDGbX8jOF
 2ejJSBwDBEAlWdhpOXocC56u8kpuwwstr5PLcbVtNC33ZsWpa4OfGLMBwguzhb4rGc+k
 vo7R/23cSE/5ESvO/Uqe82lfhRj/n4yhrppjinrBNqsPVFwtT73+9Etf8JvMpLRfN4ai
 XkeX0TdAUJ69DpydZOw3vgsLK2EyhQ6ksPQbRNVTJJHWVjKD0IBNCWYoAQGA+kGGjNsp
 Hq/6ghvhw6wbNkA+7WMPQIWRxovDnfJ9NYI/xQpAGG7w2FAkBfOpRhmo2Uc+TuseP4Ek nQ== 
Received: from sc-exch02.marvell.com ([199.233.58.182])
        by mx0a-0016f401.pphosted.com with ESMTP id 2v37mg252n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Wed, 18 Sep 2019 02:39:38 -0700
Received: from SC-EXCH02.marvell.com (10.93.176.82) by SC-EXCH02.marvell.com
 (10.93.176.82) with Microsoft SMTP Server (TLS) id 15.0.1367.3; Wed, 18 Sep
 2019 02:39:36 -0700
Received: from NAM01-BN3-obe.outbound.protection.outlook.com (104.47.33.54) by
 SC-EXCH02.marvell.com (10.93.176.82) with Microsoft SMTP Server (TLS) id
 15.0.1367.3 via Frontend Transport; Wed, 18 Sep 2019 02:39:36 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=D2yx5RYURJij2Uy3szT8DyJR+vTdAdIFVxli4sxjS3YzqaRjmWMLCDhUdRWdbs8LKj4RKFlR1QTKUgtls0hB2miMjdARg8xOoF3G2hrPLa3jyxjBqx3jyNd7DHTm/qlE6fdj8PXw32WkpSYyZy+Q30v6zckK3Xs5BPZi3iPO60xpyOakkKabfgH+lreihgDZFzM5EbD76kQP/qyC26XOyEeib8tQSpklUGGr94FhAh3QwsBkM6KK5BNUcUfaUFhRxnUJMZY7RUE6hqjBDYtOmWmtTDaa024nb6r1VBWW3l1HaZcl+XlOGENzKPOl0FkZnOro//FbiUgkSHcZMIPdZA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1YxlYm7hz6Dp6VyliP4Ie2oWjHnMdKc0ZotKYsLPgUU=;
 b=KPgiOkJ68mArcl0lanhIKQks/v4XVx3OAouJ7UBX4/D0cxDAgnf/s32vMUtsmUIKd2MALklUTHHbbFjjnNHH0uxajSSnpe2U0ZFmraOfIbJ1MBERyQQaPwKCCcJ93PDjqt0mGZek2Zy8Rb+U15GaqQLmtiaOnpkgFNhxRfcq55KS7GWa+YgAvCPmYS4OQhBDt/SLI6NtblGkixf4VwXpiOOLma0ue81DXegSyOBVmDDclbeBmt//VEVC8WwBmr1rmApcwyUUJBb32KHBE4r4Lr43FtVNXEmSV7xm5wIycymklzCt3+uRT7wt6JIUAb3BuL2RcIW2kHYqlDM+oPSYxw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector2-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1YxlYm7hz6Dp6VyliP4Ie2oWjHnMdKc0ZotKYsLPgUU=;
 b=m5Y1H/qsVVRxMM1Ge9YckR4d5Mhyugr9pnd7PnrvBT1If7Iazv55lqa91LUcDjSh9BQOTDAHC2njeDNGUfMNh1l1JYrNi+9z9kyyLNXBOhh+63PLsBLczyuJlV4RgdJsIPCgVfe02Yfrnh0JoDIqppf3uMqXdXWlWVFktlQsoOY=
Received: from MN2PR18MB2797.namprd18.prod.outlook.com (20.179.22.16) by
 MN2PR18MB3085.namprd18.prod.outlook.com (20.179.21.16) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2284.18; Wed, 18 Sep 2019 09:39:35 +0000
Received: from MN2PR18MB2797.namprd18.prod.outlook.com
 ([fe80::2010:7134:bdcf:8ad9]) by MN2PR18MB2797.namprd18.prod.outlook.com
 ([fe80::2010:7134:bdcf:8ad9%7]) with mapi id 15.20.2263.023; Wed, 18 Sep 2019
 09:39:35 +0000
From:   Nagadheeraj Rottela <rnagadheeraj@marvell.com>
To:     "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
        "davem@davemloft.net" <davem@davemloft.net>
CC:     Srikanth Jampala <jsrikanth@marvell.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Nagadheeraj Rottela <rnagadheeraj@marvell.com>
Subject: [PATCH] crypto: cavium/nitrox - Add mailbox message to get mcode info
 in VF
Thread-Topic: [PATCH] crypto: cavium/nitrox - Add mailbox message to get mcode
 info in VF
Thread-Index: AQHVbgT7evuBeNkKn0+ndI98tEnhjw==
Date:   Wed, 18 Sep 2019 09:39:34 +0000
Message-ID: <20190918093901.6477-1-rnagadheeraj@marvell.com>
Accept-Language: en-IN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: BMXPR01CA0025.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:b00:c::11) To MN2PR18MB2797.namprd18.prod.outlook.com
 (2603:10b6:208:a0::16)
x-ms-exchange-messagesentrepresentingtype: 1
x-mailer: git-send-email 2.13.6
x-originating-ip: [115.113.156.2]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 7ada9b43-7afb-44d5-d30b-08d73c1c1d77
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(5600167)(711020)(4605104)(1401327)(4534185)(7168020)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7193020);SRVR:MN2PR18MB3085;
x-ms-traffictypediagnostic: MN2PR18MB3085:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MN2PR18MB3085AAC11D3C2EDB70DCB54AD68E0@MN2PR18MB3085.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:257;
x-forefront-prvs: 01644DCF4A
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(39860400002)(396003)(346002)(366004)(376002)(136003)(189003)(199004)(86362001)(2906002)(256004)(66946007)(66556008)(15650500001)(36756003)(2501003)(6116002)(81166006)(81156014)(54906003)(6486002)(107886003)(110136005)(8676002)(3846002)(8936002)(1076003)(316002)(50226002)(5660300002)(66066001)(7736002)(305945005)(102836004)(6506007)(4326008)(55236004)(386003)(26005)(6512007)(25786009)(64756008)(186003)(66476007)(66446008)(486006)(478600001)(71190400001)(99286004)(71200400001)(476003)(2616005)(14454004)(6436002)(52116002)(6606295002);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR18MB3085;H:MN2PR18MB2797.namprd18.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: marvell.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: L8CTZ48z1rEuT7adXcHnOtAHag4eBb0AHwhhvYVf/ZZKM93nD6tkxLsNhsxEE+qoD7UnDQ3Pk7928ogK2VjTWhNeP0VZ0rmhsyqjjTnXFcsSXBE5BNMb548uALex/qFIsGmRoWmXv6pnbJGZfMBMIAckGbuEnk3FzqSfJml/7MYvaZp7C9qWpoT9aC+oKehCDtTfvEMlGiToe7bz11mfSjMQU3NsJHFd6N22DUEoOxKsDJQLmMsMYD4KKR6w7g6AuYf/o4pj22vgsnoPxdrSVYIxkb5tm8BwMcSZqTvQ2x4xywu1ZR6v+s0nCDmCltES3DpxfAed+iJEhi7J/acv7SKVoiUdTftovUwN5OS8tiuciAPV2ielTkPx0sk3gUNVJTyuZzHLJYW7WOa7bPzDAQheB1itjpdZz5LC9kmmAVc=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 7ada9b43-7afb-44d5-d30b-08d73c1c1d77
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Sep 2019 09:39:34.9516
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: r2A490Cj97sDMKq0ri+KWeZ9CzOik0GupTocX1Jd3z8D9vyR0CW0lfFR3OPJmO2I3WyHQPXkmBlg8vdIbSb7XTAiVkQNHk2Dpl9GIjCkPDQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR18MB3085
X-OriginatorOrg: marvell.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.70,1.0.8
 definitions=2019-09-18_06:2019-09-17,2019-09-18 signatures=0
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Add support to get microcode information in VF from PF via mailbox
message.

Signed-off-by: Nagadheeraj Rottela <rnagadheeraj@marvell.com>
Reviewed-by: Srikanth Jampala <jsrikanth@marvell.com>
---
 drivers/crypto/cavium/nitrox/nitrox_dev.h | 15 +++++++++++++++
 drivers/crypto/cavium/nitrox/nitrox_mbx.c |  8 ++++++++
 2 files changed, 23 insertions(+)

diff --git a/drivers/crypto/cavium/nitrox/nitrox_dev.h b/drivers/crypto/cav=
ium/nitrox/nitrox_dev.h
index 2217a2736c8e..c2d0c23fb81b 100644
--- a/drivers/crypto/cavium/nitrox/nitrox_dev.h
+++ b/drivers/crypto/cavium/nitrox/nitrox_dev.h
@@ -109,6 +109,13 @@ struct nitrox_q_vector {
 	};
 };
=20
+enum mcode_type {
+	MCODE_TYPE_INVALID,
+	MCODE_TYPE_AE,
+	MCODE_TYPE_SE_SSL,
+	MCODE_TYPE_SE_IPSEC,
+};
+
 /**
  * mbox_msg - Mailbox message data
  * @type: message type
@@ -128,6 +135,14 @@ union mbox_msg {
 		u64 chipid: 8;
 		u64 vfid: 8;
 	} id;
+	struct {
+		u64 type: 2;
+		u64 opcode: 6;
+		u64 count: 4;
+		u64 info: 40;
+		u64 next_se_grp: 3;
+		u64 next_ae_grp: 3;
+	} mcode_info;
 };
=20
 /**
diff --git a/drivers/crypto/cavium/nitrox/nitrox_mbx.c b/drivers/crypto/cav=
ium/nitrox/nitrox_mbx.c
index 02ee95064841..b51b0449b478 100644
--- a/drivers/crypto/cavium/nitrox/nitrox_mbx.c
+++ b/drivers/crypto/cavium/nitrox/nitrox_mbx.c
@@ -25,6 +25,7 @@ enum mbx_msg_opcode {
 	MSG_OP_VF_UP,
 	MSG_OP_VF_DOWN,
 	MSG_OP_CHIPID_VFID,
+	MSG_OP_MCODE_INFO =3D 11,
 };
=20
 struct pf2vf_work {
@@ -73,6 +74,13 @@ static void pf2vf_send_response(struct nitrox_device *nd=
ev,
 		vfdev->nr_queues =3D 0;
 		atomic_set(&vfdev->state, __NDEV_NOT_READY);
 		break;
+	case MSG_OP_MCODE_INFO:
+		msg.data =3D 0;
+		msg.mcode_info.count =3D 2;
+		msg.mcode_info.info =3D MCODE_TYPE_SE_SSL | (MCODE_TYPE_AE << 5);
+		msg.mcode_info.next_se_grp =3D 1;
+		msg.mcode_info.next_ae_grp =3D 1;
+		break;
 	default:
 		msg.type =3D MBX_MSG_TYPE_NOP;
 		break;
--=20
2.13.6

