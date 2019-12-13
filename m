Return-Path: <SRS0=mgHx=2D=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 436A6C43603
	for <linux-crypto@archiver.kernel.org>; Fri, 13 Dec 2019 09:54:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0BE5D214D8
	for <linux-crypto@archiver.kernel.org>; Fri, 13 Dec 2019 09:54:52 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=microchiptechnology.onmicrosoft.com header.i=@microchiptechnology.onmicrosoft.com header.b="utfwM0TM"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725818AbfLMJyv (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 13 Dec 2019 04:54:51 -0500
Received: from esa6.microchip.iphmx.com ([216.71.154.253]:43918 "EHLO
        esa6.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725747AbfLMJyv (ORCPT
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
IronPort-SDR: Wxc1BHQu0Ft7Vbod7NyRM3QAGynH88OulwHc/OzbHDOVOzyfLInMj0V4jzA+xeylAXnO8qRjkn
 sdL+6zAd5BFufsSPWemqcze6326oMlaIwxgtuK1DQAOBrI0BWb+B41du4qml1Afsjql+5RAhfR
 7TmFMy8NsIS2YW7LENGGVvdZJjSwWfQXcuecNq1pl2ScF3HDOZFEiutPG1bky01bdw9akqdeuK
 rROm26FaBbKV8e5w2i9FaNsk+Gzy4wpB6miTI9Y4NlsdTgEkrQlL72/ThZdG1q/0LkvsBee+rz
 0hQ=
X-IronPort-AV: E=Sophos;i="5.69,309,1571727600"; 
   d="scan'208";a="57649452"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 13 Dec 2019 02:54:49 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Fri, 13 Dec 2019 02:54:49 -0700
Received: from NAM04-CO1-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.71) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1713.5 via Frontend
 Transport; Fri, 13 Dec 2019 02:54:50 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JAZv96/oVjhy0TywBkSEm7i4soEA9IiAMBMMYiRiTKRbpvEEa5A01H2IZyV+kkL8lU+rlp7I2QyNoalu82yXJBDO3bqdv4S9f9YHPYLWp42hXZaXmzeye8ApvVwH4EKrLj79A2XKHrgl4Zz4U5MggkLvg43EDiOq6cjd//v5fh/Wif852kYEiozCfxWJzJdxq9DVb7S5RAcrnK4gbSCeVzVnZjU67mFf6W7S7Loxs75PcWWV/T43jPrOxViRv9iOeSYhucpBET9LmVF/mLqW0JPh2joszzJEIi9c/dnnLMaOhcHGCz0d+iLiBgxHvYnUMEj/9YRJlDBgOCUw3ILJEA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4NeDqx7LrQMA08AVT50hCJsEFCoejkUetk+9QxD5C1U=;
 b=ErJ6of+E7zlpc4KITDHQVgmjRfiVCXhFFKp2qDggf7DK9ULvr64PtKaLbHdyODaerETTrAmcA9GJdTxMqUAASsbMtTuDCk55KsAj4r+DNOMEx3+J9KIhwcwBpreCrwdRd7DMXqJmHncag9YjCgnqeHKtBalvc1ECCGQsLnOzqJp2bRZHAg5drl+ORTWiR5zaF7V3UtaKZyPsXYt9JfVCC6RaFYtcH25SVQMMCjjVkvlgc3F3N3ofeGlSeKOQLZW0dt5BYX7fjmjEdBP5WDJAJUIU8xv3U21lyID/LgA733MHlRqZSYPh3FsLTq9XK+7zOY4hxj7hta0k0onhM+BkSw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4NeDqx7LrQMA08AVT50hCJsEFCoejkUetk+9QxD5C1U=;
 b=utfwM0TM+MhWbJkhV6BrO5ZbUYdDZ8OWapruG9NpAbY6FWuAYSrlR8KLDgCFhkF/SQg1jObeJei8XUnnFolaQ+panmIetUNsfd6lGtkXmYcfySZXYWlZUzwopvUcN+lBR1E5c0zW8lbk9MJNIzyYZjkpwVv5Zmp/MiRNeaiRA5s=
Received: from MN2PR11MB4448.namprd11.prod.outlook.com (52.135.39.157) by
 MN2PR11MB3935.namprd11.prod.outlook.com (10.255.180.93) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2538.17; Fri, 13 Dec 2019 09:54:47 +0000
Received: from MN2PR11MB4448.namprd11.prod.outlook.com
 ([fe80::84c:6e75:22df:cbc9]) by MN2PR11MB4448.namprd11.prod.outlook.com
 ([fe80::84c:6e75:22df:cbc9%5]) with mapi id 15.20.2538.017; Fri, 13 Dec 2019
 09:54:47 +0000
From:   <Tudor.Ambarus@microchip.com>
To:     <herbert@gondor.apana.org.au>
CC:     <Nicolas.Ferre@microchip.com>, <alexandre.belloni@bootlin.com>,
        <Ludovic.Desroches@microchip.com>, <linux-crypto@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <Tudor.Ambarus@microchip.com>
Subject: [PATCH 2/5] crypto: atmel-{aes,sha,tdes} - Drop duplicate init of
 dma_slave_config.direction
Thread-Topic: [PATCH 2/5] crypto: atmel-{aes,sha,tdes} - Drop duplicate init
 of dma_slave_config.direction
Thread-Index: AQHVsZta6SvbcgatykCqmhrO1amI4Q==
Date:   Fri, 13 Dec 2019 09:54:46 +0000
Message-ID: <20191213095423.6687-2-tudor.ambarus@microchip.com>
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
x-ms-office365-filtering-correlation-id: 489a8edc-f158-4a83-9cba-08d77fb27ca3
x-ms-traffictypediagnostic: MN2PR11MB3935:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MN2PR11MB3935B5A50FD57DA29756DF8AF0540@MN2PR11MB3935.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-forefront-prvs: 0250B840C1
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(376002)(346002)(39860400002)(396003)(366004)(136003)(199004)(189003)(2616005)(2906002)(6486002)(6916009)(71200400001)(6512007)(86362001)(186003)(26005)(478600001)(52116002)(64756008)(66446008)(81156014)(1076003)(5660300002)(81166006)(54906003)(107886003)(8936002)(36756003)(316002)(66556008)(66476007)(66946007)(6506007)(4326008)(8676002)(142933001);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR11MB3935;H:MN2PR11MB4448.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: microchip.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: av3zv3dJ38E3DTZRebKgenpfp6Y+gyGx1mDOnpUDLblKsAf4ATwF8xQieqbQDciNjho22Q7SD2ZpR6gkCJVodvKBdCCLs0tR8IIsLHxEJKAQxYOYJtlehWZ1rj85+GJqyeMeqCuT+ijYYUX4pMq6Tu6JYBBccdjYTDd6E5GqyH41jBy/ajue+5dpq8C0uRq93A8t1PGB7+vg5PSsuHYUYFqRcH9ZbVnZCmCMGTeFLEZwbtLzjNTtwZeIO41aCLdFO7mg/LECGAO5vl70S6VepQ+a/TevSS88LFtfYpKoapZc0NExXuuZt81qC10DNMbBm4+QBFibUg7nOwm/jsvFdgFUKcZebCo6fSCrgjHdbhkcOPwRjI165t/9bDaTjCHfkpTJ2XKDol6+o0Hc3OoGUjFmi+umNZnN1D+7/IKujfvHrAeZHeynqgqMIIWmyc9fTUacT6RGZi1rqBJ6dQQldrLP1hu2aWrxuGjhDhCyUnTq2IyeX+JhYvRhItW8/Pc9
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 489a8edc-f158-4a83-9cba-08d77fb27ca3
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Dec 2019 09:54:46.9947
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: emSCxbgYZo2dhNWivkyxxsLvezPZE7X60Q4r6I64A+FY11s9B62KLOSnivfTw8uer1E7WPn+l8BDGNgk7tZc2G6dmLECT+trrQMihiee8BQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB3935
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Tudor Ambarus <tudor.ambarus@microchip.com>

The 'direction' member of the dma_slave_config will be going away
as it duplicates the direction given in the prepare call.

Signed-off-by: Tudor Ambarus <tudor.ambarus@microchip.com>
---
 drivers/crypto/atmel-aes.c  | 1 -
 drivers/crypto/atmel-sha.c  | 1 -
 drivers/crypto/atmel-tdes.c | 2 --
 3 files changed, 4 deletions(-)

diff --git a/drivers/crypto/atmel-aes.c b/drivers/crypto/atmel-aes.c
index c3f0e99d24b0..d5a116693010 100644
--- a/drivers/crypto/atmel-aes.c
+++ b/drivers/crypto/atmel-aes.c
@@ -817,7 +817,6 @@ static int atmel_aes_dma_transfer_start(struct atmel_ae=
s_dev *dd,
 	int err;
=20
 	memset(&config, 0, sizeof(config));
-	config.direction =3D dir;
 	config.src_addr_width =3D addr_width;
 	config.dst_addr_width =3D addr_width;
 	config.src_maxburst =3D maxburst;
diff --git a/drivers/crypto/atmel-sha.c b/drivers/crypto/atmel-sha.c
index 7cf4ec9ed93a..21fcc04f6688 100644
--- a/drivers/crypto/atmel-sha.c
+++ b/drivers/crypto/atmel-sha.c
@@ -2493,7 +2493,6 @@ static int atmel_sha_dma_init(struct atmel_sha_dev *d=
d,
 		return ret;
 	}
=20
-	dd->dma_lch_in.dma_conf.direction =3D DMA_MEM_TO_DEV;
 	dd->dma_lch_in.dma_conf.dst_addr =3D dd->phys_base +
 		SHA_REG_DIN(0);
 	dd->dma_lch_in.dma_conf.src_maxburst =3D 1;
diff --git a/drivers/crypto/atmel-tdes.c b/drivers/crypto/atmel-tdes.c
index 12268b549596..51b332527efd 100644
--- a/drivers/crypto/atmel-tdes.c
+++ b/drivers/crypto/atmel-tdes.c
@@ -753,7 +753,6 @@ static int atmel_tdes_dma_init(struct atmel_tdes_dev *d=
d,
 		goto err_dma_in;
 	}
=20
-	dd->dma_lch_in.dma_conf.direction =3D DMA_MEM_TO_DEV;
 	dd->dma_lch_in.dma_conf.dst_addr =3D dd->phys_base +
 		TDES_IDATA1R;
 	dd->dma_lch_in.dma_conf.src_maxburst =3D 1;
@@ -770,7 +769,6 @@ static int atmel_tdes_dma_init(struct atmel_tdes_dev *d=
d,
 		goto err_dma_out;
 	}
=20
-	dd->dma_lch_out.dma_conf.direction =3D DMA_DEV_TO_MEM;
 	dd->dma_lch_out.dma_conf.src_addr =3D dd->phys_base +
 		TDES_ODATA1R;
 	dd->dma_lch_out.dma_conf.src_maxburst =3D 1;
--=20
2.20.1

