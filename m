Return-Path: <SRS0=mgHx=2D=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C0676C43603
	for <linux-crypto@archiver.kernel.org>; Fri, 13 Dec 2019 09:55:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 849AF2073D
	for <linux-crypto@archiver.kernel.org>; Fri, 13 Dec 2019 09:55:03 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=microchiptechnology.onmicrosoft.com header.i=@microchiptechnology.onmicrosoft.com header.b="hUAJWCLl"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725945AbfLMJzD (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 13 Dec 2019 04:55:03 -0500
Received: from esa3.microchip.iphmx.com ([68.232.153.233]:1858 "EHLO
        esa3.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725799AbfLMJzC (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 13 Dec 2019 04:55:02 -0500
Received-SPF: Pass (esa3.microchip.iphmx.com: domain of
  Tudor.Ambarus@microchip.com designates 198.175.253.82 as
  permitted sender) identity=mailfrom;
  client-ip=198.175.253.82; receiver=esa3.microchip.iphmx.com;
  envelope-from="Tudor.Ambarus@microchip.com";
  x-sender="Tudor.Ambarus@microchip.com";
  x-conformance=spf_only; x-record-type="v=spf1";
  x-record-text="v=spf1 mx a:ushub1.microchip.com
  a:smtpout.microchip.com -exists:%{i}.spf.microchip.iphmx.com
  include:servers.mcsv.net include:mktomail.com
  include:spf.protection.outlook.com ~all"
Received-SPF: None (esa3.microchip.iphmx.com: no sender
  authenticity information available from domain of
  postmaster@email.microchip.com) identity=helo;
  client-ip=198.175.253.82; receiver=esa3.microchip.iphmx.com;
  envelope-from="Tudor.Ambarus@microchip.com";
  x-sender="postmaster@email.microchip.com";
  x-conformance=spf_only
Authentication-Results: esa3.microchip.iphmx.com; spf=Pass smtp.mailfrom=Tudor.Ambarus@microchip.com; spf=None smtp.helo=postmaster@email.microchip.com; dkim=pass (signature verified) header.i=@microchiptechnology.onmicrosoft.com; dmarc=pass (p=none dis=none) d=microchip.com
IronPort-SDR: rP/er24DGt+qDdQxEk8Rh3UZP830ZG17zaAMTV6r001FM40FTdYs327wI+6w25U/cdM8tRrOa5
 uBNeDBr5TWeN78otg/kdjIqKqy5e/kHPxgSEfKbKYxGOCUNht1YE2RdtELOOLUrMTOtCTJIhVs
 OZMSEmaQ/vZqQW6G3F/vRHohSzH26Nwsy6rXCBXEn4PcXZ6IabaPG+sQk15PzK7vFxDb09qqeu
 mPQUU+GFcwTlyzFOErbaa/KYjPO/ZSdSiSlXzi1Jv5fKaum/sCOR9cE0U7R7ZXQSMvqNd7JEIn
 /jU=
X-IronPort-AV: E=Sophos;i="5.69,309,1571727600"; 
   d="scan'208";a="60267812"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa3.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 13 Dec 2019 02:55:01 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Fri, 13 Dec 2019 02:54:58 -0700
Received: from NAM04-CO1-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1713.5
 via Frontend Transport; Fri, 13 Dec 2019 02:54:57 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QnjMNDI6gmAaTaDpCaI1rNiYTaixV/SngiUx2zYbOJ1Rkb53vcagK5HRmyRvoeOaWD6s+YQCuhDA/hmPTk2Om/VKKjWO2U1nN47ktFrcRIUeJOOQm6NqKETMl1zkFvGW3PD2NJSOFlS0dOyqDIiqcE0g2EqEpSiO0LnDNSh2TC5Z2cttKc0L8rCOxMm5hSwD3pUbR4u+nDf3udXAruycmQiETrJLPfQLZv5Sy6GKy3VN9RmwmabAk4yEnwmNaFG6yp1bH9mET4swavHg1ZFSlA1+rqvDtbSNN4Xnwp3vRyGA83zUGzfMpB6I7MIOHumtUbWjgSqqitfNnjrEaCF+nA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=32EckjQQqgoLtOx0b8/KiJ0d5GeJ/4L9UgJWttysbLY=;
 b=iW+acy3UKhKw9lJe+1bEKORnIYu4+Iz8GCRo87mwR0HZ8IYQoXN6qceIE6zMYiUEYIr7F2K65gkwJV0wBzbwTX5GUZhTWHWQ0gly5tw5kl736Z8p8iZdXpucCbSCvzKF9cLJoYunj8cgru2wQT7TwhunJzNA8o/rtP+JJ+ULuShukMX8aETjP49SD2Vmf98Tfa8zEyL8hxei70Q/9Y2wPqqFisSwhMr9dWhXnzNd5LlNzb3x4HrnESmbwGxFJG1YNeoQWYhR7mNL4TlpH8ELB3H0RVQd446zwSIuIzq/87GEeAB0LrPGHfPlAUVpHNxPGSiJbZ+kvKJMzBXCLNP/ug==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=32EckjQQqgoLtOx0b8/KiJ0d5GeJ/4L9UgJWttysbLY=;
 b=hUAJWCLljEZh+3/9HtpWGNOJ0pCd/zXDbEQ6K0dgAJXYg+WSugJ4BeDRomdo8Hu/VaQ4TnaN9YS1fyRUW/mF6Oa/e9P39xa3REhPRIbykkdZ7p9NJjeHusLq9vgYfA1kjprZMUBzNejr6TA4rxlc4V60Gn2EruKKRNgIHubYUPM=
Received: from MN2PR11MB4448.namprd11.prod.outlook.com (52.135.39.157) by
 MN2PR11MB3935.namprd11.prod.outlook.com (10.255.180.93) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2538.17; Fri, 13 Dec 2019 09:54:56 +0000
Received: from MN2PR11MB4448.namprd11.prod.outlook.com
 ([fe80::84c:6e75:22df:cbc9]) by MN2PR11MB4448.namprd11.prod.outlook.com
 ([fe80::84c:6e75:22df:cbc9%5]) with mapi id 15.20.2538.017; Fri, 13 Dec 2019
 09:54:56 +0000
From:   <Tudor.Ambarus@microchip.com>
To:     <herbert@gondor.apana.org.au>
CC:     <Nicolas.Ferre@microchip.com>, <alexandre.belloni@bootlin.com>,
        <Ludovic.Desroches@microchip.com>, <linux-crypto@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <Tudor.Ambarus@microchip.com>
Subject: [PATCH 5/5] crypto: atmel-{aes,tdes} - Update the IV only when the op
 succeeds
Thread-Topic: [PATCH 5/5] crypto: atmel-{aes,tdes} - Update the IV only when
 the op succeeds
Thread-Index: AQHVsZtfj2psfTAPsECkyIsj65ou2A==
Date:   Fri, 13 Dec 2019 09:54:56 +0000
Message-ID: <20191213095423.6687-5-tudor.ambarus@microchip.com>
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
x-ms-office365-filtering-correlation-id: ad02d5c2-fd9b-4189-3765-08d77fb2824e
x-ms-traffictypediagnostic: MN2PR11MB3935:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MN2PR11MB393521B5565B62416F89FF04F0540@MN2PR11MB3935.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4303;
x-forefront-prvs: 0250B840C1
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(376002)(346002)(39860400002)(396003)(366004)(136003)(199004)(189003)(2616005)(2906002)(6486002)(6916009)(71200400001)(6512007)(86362001)(186003)(26005)(478600001)(52116002)(64756008)(66446008)(81156014)(1076003)(5660300002)(81166006)(54906003)(107886003)(8936002)(36756003)(316002)(66556008)(66476007)(66946007)(6506007)(4326008)(8676002)(15650500001)(142933001);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR11MB3935;H:MN2PR11MB4448.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: microchip.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: cOVB8Zw4/ACkPzdwfQVTgVBX+eAow3QMhxO6U9P3LZAS9URY0cyvhJMe6+E3hHiF8w+Jx7G1Hgfwr5vjaCcqxeMTvUYH+f7DDv1AjTVurRW15nN5qj4QNMsY4XV+UeGFuPfn/tQuJBlReczYu671d00SZH2s4z+1iig5y6PijskwSRz6tOL8CHITNZ3ziEVdrAYEOvD3cwW6K01ZURN8tZKp9VIEFe+OMdsgVoki7Bj2Owx11XSISDwzg8HTl5sQTmuWp9cJwFnp04zZgSIOXQJi4H0BXXJ2fArSquj2hleb6gC9MRZ4eCg1Hky8j9iQdNnkBDJJX+PRTYiZTXPP3nptZDwaeQAKVmoL1cMgM1kZPLgcF5v8j8CUSGF8hxRZs02RfV+2e49Eq5o0gMhY6O2QpHgUMZHXl1JESLZTaKpuGyxYfg+3Vypmf299E7WH/9O8tvG0BZC2aZOunJfz+cGCP0HP96HbgrS28pPQ+WvSMaig85Ime1SI+Hjj1AUx
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: ad02d5c2-fd9b-4189-3765-08d77fb2824e
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Dec 2019 09:54:56.5393
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 0u7v3FAzpqFb9NF+Dql5Sqf1/TrMm8L74G8DhElwsk0vpvyQtwQnTutwxSJM6Nd5iSGUAo5KHdNQrmj8ulJ6qcnlyOJMfZaHJ3M+7D6Ywe8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB3935
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Tudor Ambarus <tudor.ambarus@microchip.com>

Do not update the IV in case of errors.

Signed-off-by: Tudor Ambarus <tudor.ambarus@microchip.com>
---
 drivers/crypto/atmel-aes.c  | 2 +-
 drivers/crypto/atmel-tdes.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/atmel-aes.c b/drivers/crypto/atmel-aes.c
index 855f0ccc9368..245d45f93b61 100644
--- a/drivers/crypto/atmel-aes.c
+++ b/drivers/crypto/atmel-aes.c
@@ -546,7 +546,7 @@ static inline int atmel_aes_complete(struct atmel_aes_d=
ev *dd, int err)
 	clk_disable(dd->iclk);
 	dd->flags &=3D ~AES_FLAGS_BUSY;
=20
-	if (!dd->ctx->is_aead &&
+	if (!err && !dd->ctx->is_aead &&
 	    (rctx->mode & AES_FLAGS_OPMODE_MASK) !=3D AES_FLAGS_ECB) {
 		if ((rctx->mode & AES_FLAGS_OPMODE_MASK) !=3D AES_FLAGS_CTR)
 			atmel_aes_set_iv_as_last_ciphertext_block(dd);
diff --git a/drivers/crypto/atmel-tdes.c b/drivers/crypto/atmel-tdes.c
index 83a6d42c8921..e7cd7b01b931 100644
--- a/drivers/crypto/atmel-tdes.c
+++ b/drivers/crypto/atmel-tdes.c
@@ -597,7 +597,7 @@ static void atmel_tdes_finish_req(struct atmel_tdes_dev=
 *dd, int err)
=20
 	dd->flags &=3D ~TDES_FLAGS_BUSY;
=20
-	if ((rctx->mode & TDES_FLAGS_OPMODE_MASK) !=3D TDES_FLAGS_ECB)
+	if (!err && (rctx->mode & TDES_FLAGS_OPMODE_MASK) !=3D TDES_FLAGS_ECB)
 		atmel_tdes_set_iv_as_last_ciphertext_block(dd);
=20
 	req->base.complete(&req->base, err);
--=20
2.20.1

