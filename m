Return-Path: <SRS0=mgHx=2D=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 71D44C2D0C9
	for <linux-crypto@archiver.kernel.org>; Fri, 13 Dec 2019 09:54:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 48EA52073D
	for <linux-crypto@archiver.kernel.org>; Fri, 13 Dec 2019 09:54:52 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=microchiptechnology.onmicrosoft.com header.i=@microchiptechnology.onmicrosoft.com header.b="oqf8w3iq"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725747AbfLMJyv (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 13 Dec 2019 04:54:51 -0500
Received: from esa6.microchip.iphmx.com ([216.71.154.253]:43918 "EHLO
        esa6.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725793AbfLMJyv (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 13 Dec 2019 04:54:51 -0500
Received-SPF: Pass (esa6.microchip.iphmx.com: domain of
  Tudor.Ambarus@microchip.com designates 198.175.253.82 as
  permitted sender) identity=mailfrom;
  client-ip=198.175.253.82; receiver=esa6.microchip.iphmx.com;
  envelope-from="Tudor.Ambarus@microchip.com";
  x-sender="Tudor.Ambarus@microchip.com";
  x-conformance=spf_only; x-record-type="v=spf1";
  x-record-text="v=spf1 mx a:ushub1.microchip.com
  a:smtpout.microchip.com -exists:%{i}.spf.microchip.iphmx.com
  include:servers.mcsv.net include:mktomail.com
  include:spf.protection.outlook.com ~all"
Received-SPF: None (esa6.microchip.iphmx.com: no sender
  authenticity information available from domain of
  postmaster@email.microchip.com) identity=helo;
  client-ip=198.175.253.82; receiver=esa6.microchip.iphmx.com;
  envelope-from="Tudor.Ambarus@microchip.com";
  x-sender="postmaster@email.microchip.com";
  x-conformance=spf_only
Authentication-Results: esa6.microchip.iphmx.com; spf=Pass smtp.mailfrom=Tudor.Ambarus@microchip.com; spf=None smtp.helo=postmaster@email.microchip.com; dkim=pass (signature verified) header.i=@microchiptechnology.onmicrosoft.com; dmarc=pass (p=none dis=none) d=microchip.com
IronPort-SDR: CQXblHFAnDE/4gj70aa2Fm05rncKwNJjzaRIKBsAWhM35Mxq3DvxA+uarksJQjwACy7micLudS
 AL53+knQHUoMyAzMP1vR63EnZ88eS4czLJwpXhvurCz/3UcOR2Yfilqma4et8HzQ4Dc0ZE2XpU
 RhZecbNSQL3aeRflXTkR81FTtu2ZNgu0cDyEt/qLH/mLKFnOlDsV2EHXX4mko8yMwnGu1Xdw/m
 FPiPPcY+cMTztoGr4beUynemy2n2+0pjtpaZU7CuYGLTHl7N1QEzwItSB7weQN/K9bveg8ApU1
 Nnw=
X-IronPort-AV: E=Sophos;i="5.69,309,1571727600"; 
   d="scan'208";a="57649455"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 13 Dec 2019 02:54:50 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Fri, 13 Dec 2019 02:54:50 -0700
Received: from NAM04-CO1-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.71) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1713.5 via Frontend
 Transport; Fri, 13 Dec 2019 02:54:51 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OedSMFtP2yVbw5Qx8RCA988S09xEMuNMi8Zgd/jOhOL3RUhYwxP7kuWY0izbHdtI1TJh2zaYWWiWjSreNodfX90ryLUjidjXM6zvd6lpItoTpKp8L0B/NzmLvcsYROwwRAas/camolSqcoY56bxrLe0iuKKibkxpXzLReBa6rOKfMOsLSA0c58Nx5SYx0+qNGn9AUbCwBI+k7Nt11gnjD6dK4TZQ1DXFgieSwDVgMXRsNSzjDNtyGtGXtDeFwX7AjUv2gumfXwIVU9cYipKf2iUnAZuxAKaJB2lV5UPDW/rbmMq9yqiioFaj7HkNGkr3dVs2/K3WOAjbVJufD78Wog==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=W4XB05tfkqYEMHuUwPlILJvhhTDoOIFJlaErhf7T3i4=;
 b=eYxVn5ffjTnr0W93hsVKfSGxTNewyHmykjmZkqTuL/7ogIMYtHpfQeWIXdtrB0yxRGH6WMBY6VVZCTytjz+B8MoIU1z77WroSEpAelw14hU2kQF7lqFlE+SRji9zE7duUywADMLa84qQ2tsmL3WXxsXDHIx/C9bAFwDQ3gwss9NAjEJ67G0nHUE5pPFfr6w9ljxdnJqfDzGsVOgN4PjdJrbvYpo0u4BeKvpb7kMpMspoWoNvB8JjF+bTFNY6C7/FOmrTU4yGoN7+hayIUKetkNOc4MWS2ka0Wl60yxGQ2xYZ1Y3WnDZCJqCZUR4qhId3E6JBOyjSwn808Ax4nRpQAw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=W4XB05tfkqYEMHuUwPlILJvhhTDoOIFJlaErhf7T3i4=;
 b=oqf8w3iqZ21pWoVrLbdpp6DVhS2uUk3Sez7sWfnQTdR+MQBooS0eoIhDWkqNM5L8z2Wx9aipNvDlaSClvpH1pcRxhJYGXLAONgpsxSTSDr/T9L+If9q2T4/HIEnWNNemQ3A0eKQajbR3I3NyNbeYoHR3iGP7zJQZiacEicFfceQ=
Received: from MN2PR11MB4448.namprd11.prod.outlook.com (52.135.39.157) by
 MN2PR11MB3935.namprd11.prod.outlook.com (10.255.180.93) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2538.17; Fri, 13 Dec 2019 09:54:49 +0000
Received: from MN2PR11MB4448.namprd11.prod.outlook.com
 ([fe80::84c:6e75:22df:cbc9]) by MN2PR11MB4448.namprd11.prod.outlook.com
 ([fe80::84c:6e75:22df:cbc9%5]) with mapi id 15.20.2538.017; Fri, 13 Dec 2019
 09:54:49 +0000
From:   <Tudor.Ambarus@microchip.com>
To:     <herbert@gondor.apana.org.au>
CC:     <Nicolas.Ferre@microchip.com>, <alexandre.belloni@bootlin.com>,
        <Ludovic.Desroches@microchip.com>, <linux-crypto@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <Tudor.Ambarus@microchip.com>
Subject: [PATCH 3/5] crypto: atmel-{aes,sha,tdes} - Stop passing unused
 argument in _dma_init()
Thread-Topic: [PATCH 3/5] crypto: atmel-{aes,sha,tdes} - Stop passing unused
 argument in _dma_init()
Thread-Index: AQHVsZtb4TmLqdhnCEy1DKQBtubjBA==
Date:   Fri, 13 Dec 2019 09:54:49 +0000
Message-ID: <20191213095423.6687-3-tudor.ambarus@microchip.com>
References: <20191213095423.6687-1-tudor.ambarus@microchip.com>
In-Reply-To: <20191213095423.6687-1-tudor.ambarus@microchip.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: VI1PR0501CA0046.eurprd05.prod.outlook.com
 (2603:10a6:800:60::32) To MN2PR11MB4448.namprd11.prod.outlook.com
 (2603:10b6:208:193::29)
x-ms-exchange-messagesentrepresentingtype: 1
x-mailer: git-send-email 2.20.1
x-originating-ip: [86.122.210.80]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 391e608d-1b5a-460b-0526-08d77fb27de4
x-ms-traffictypediagnostic: MN2PR11MB3935:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MN2PR11MB393580FA7D639BAD5295499EF0540@MN2PR11MB3935.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:586;
x-forefront-prvs: 0250B840C1
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(376002)(346002)(39860400002)(396003)(366004)(136003)(199004)(189003)(2616005)(2906002)(6486002)(6916009)(71200400001)(6512007)(86362001)(186003)(26005)(478600001)(52116002)(64756008)(66446008)(81156014)(1076003)(5660300002)(81166006)(54906003)(107886003)(8936002)(36756003)(316002)(66556008)(66476007)(66946007)(6506007)(4326008)(8676002)(142933001);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR11MB3935;H:MN2PR11MB4448.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: microchip.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: SdNMZBT9z0MOPJnrlaccVJnXvb2LKR/yaEhY3FeBd7wJF5wZnz1EyZ1o2Ss5yQBDUOG71AaCwNmJ0/vaiGWRUldEyT0E2p2IPqc0dvRfoXRnjdmA62FKrj2BUy7hLR9l9bePzWRR6N9TrHcqnffhOqu4aAzJuSNWJAD+kmThm4zmzrKHRok+NjLDWXgjAt341qvgHkVjMgaFP5F0yVWO1UnAu2YdUUY91EDYO6ZiNBwNyh5PhXk5jDMcJ5CVudTpe8f/ulunNHC5uN7IZ8tV92lrMfjbLyPK34+1BaS+fwBjNsx5skPZxl2kbRrvTnrzgvSPkvaXDTWnb9eTcDCkkHLtkUVIWzQb4jZPWLfgBPMfquTLLPoWJoOd1ITx5qYwMe02jjcJ/S+xTnwA3QrOManeYruK6nEIp4I958OjKq1HC3TzxafxDlr8krnifJOxsVdyJasWg6D967cH4tnL7sKcAYdSfoWWqrDGrGp+JpVD7zLjbflqLsdVFsP73xMo
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 391e608d-1b5a-460b-0526-08d77fb27de4
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Dec 2019 09:54:49.0805
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: eRmQtNB1jDe92tFIQFe9A5IOhUQb8SlnL3V5QnsJo8BU381twweYR/84yVlNgkt72sI7aAylUKYioW4+hhPnx6gg/yVq0ZUwES5GDaoAWJ8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB3935
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Tudor Ambarus <tudor.ambarus@microchip.com>

pdata is not used.

Signed-off-by: Tudor Ambarus <tudor.ambarus@microchip.com>
---
 drivers/crypto/atmel-aes.c  | 5 ++---
 drivers/crypto/atmel-sha.c  | 5 ++---
 drivers/crypto/atmel-tdes.c | 5 ++---
 3 files changed, 6 insertions(+), 9 deletions(-)

diff --git a/drivers/crypto/atmel-aes.c b/drivers/crypto/atmel-aes.c
index d5a116693010..986f1ca682aa 100644
--- a/drivers/crypto/atmel-aes.c
+++ b/drivers/crypto/atmel-aes.c
@@ -2270,8 +2270,7 @@ static void atmel_aes_buff_cleanup(struct atmel_aes_d=
ev *dd)
 	free_page((unsigned long)dd->buf);
 }
=20
-static int atmel_aes_dma_init(struct atmel_aes_dev *dd,
-			      struct crypto_platform_data *pdata)
+static int atmel_aes_dma_init(struct atmel_aes_dev *dd)
 {
 	int ret;
=20
@@ -2598,7 +2597,7 @@ static int atmel_aes_probe(struct platform_device *pd=
ev)
 	if (err)
 		goto err_iclk_unprepare;
=20
-	err =3D atmel_aes_dma_init(aes_dd, pdata);
+	err =3D atmel_aes_dma_init(aes_dd);
 	if (err)
 		goto err_buff_cleanup;
=20
diff --git a/drivers/crypto/atmel-sha.c b/drivers/crypto/atmel-sha.c
index 21fcc04f6688..a0d42bdc311f 100644
--- a/drivers/crypto/atmel-sha.c
+++ b/drivers/crypto/atmel-sha.c
@@ -2481,8 +2481,7 @@ static int atmel_sha_register_algs(struct atmel_sha_d=
ev *dd)
 	return err;
 }
=20
-static int atmel_sha_dma_init(struct atmel_sha_dev *dd,
-				struct crypto_platform_data *pdata)
+static int atmel_sha_dma_init(struct atmel_sha_dev *dd)
 {
 	dd->dma_lch_in.chan =3D dma_request_chan(dd->dev, "tx");
 	if (IS_ERR(dd->dma_lch_in.chan)) {
@@ -2674,7 +2673,7 @@ static int atmel_sha_probe(struct platform_device *pd=
ev)
 			}
 		}
=20
-		err =3D atmel_sha_dma_init(sha_dd, pdata);
+		err =3D atmel_sha_dma_init(sha_dd);
 		if (err)
 			goto err_iclk_unprepare;
=20
diff --git a/drivers/crypto/atmel-tdes.c b/drivers/crypto/atmel-tdes.c
index 51b332527efd..d42b22775ee9 100644
--- a/drivers/crypto/atmel-tdes.c
+++ b/drivers/crypto/atmel-tdes.c
@@ -741,8 +741,7 @@ static int atmel_tdes_crypt(struct skcipher_request *re=
q, unsigned long mode)
 	return atmel_tdes_handle_queue(ctx->dd, req);
 }
=20
-static int atmel_tdes_dma_init(struct atmel_tdes_dev *dd,
-			struct crypto_platform_data *pdata)
+static int atmel_tdes_dma_init(struct atmel_tdes_dev *dd)
 {
 	int ret;
=20
@@ -1268,7 +1267,7 @@ static int atmel_tdes_probe(struct platform_device *p=
dev)
 			}
 		}
=20
-		err =3D atmel_tdes_dma_init(tdes_dd, pdata);
+		err =3D atmel_tdes_dma_init(tdes_dd);
 		if (err)
 			goto err_buff_cleanup;
=20
--=20
2.20.1

