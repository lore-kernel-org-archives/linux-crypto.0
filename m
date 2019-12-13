Return-Path: <SRS0=mgHx=2D=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A9BA5C43603
	for <linux-crypto@archiver.kernel.org>; Fri, 13 Dec 2019 09:54:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7355C2073D
	for <linux-crypto@archiver.kernel.org>; Fri, 13 Dec 2019 09:54:58 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=microchiptechnology.onmicrosoft.com header.i=@microchiptechnology.onmicrosoft.com header.b="TxMhJwu+"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725906AbfLMJy6 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 13 Dec 2019 04:54:58 -0500
Received: from esa3.microchip.iphmx.com ([68.232.153.233]:1858 "EHLO
        esa3.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725799AbfLMJy5 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 13 Dec 2019 04:54:57 -0500
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
IronPort-SDR: GJ7oKUEKgVDOso5Hu66lahXBApPq7nJet+Mst8Y9OpA0JOQCgSv1Xl+EtagboXPBcGVLWANUgf
 UVP2U3zssQo1An/uY8ON7b/F8mwc9A/ZC1b3ivJKLtwu+oRoAH/DjzGHtEjmb/mu5XEgCT9Fys
 CEIg91U6VlvAv7ymcfC5Zmmi0marddu22AKDjHiye/JtmlxxXw9TEiaQENMX4VNtHRfjzvAA3m
 Zhl8MzyLR1Zxj8e4tCUD9rBPBZ2khzvPJrvqWeTZr3LCfBYA8noqzv5eIY5EgIH/6iaT/HYvg1
 omE=
X-IronPort-AV: E=Sophos;i="5.69,309,1571727600"; 
   d="scan'208";a="60267803"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa3.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 13 Dec 2019 02:54:56 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Fri, 13 Dec 2019 02:54:56 -0700
Received: from NAM04-CO1-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1713.5
 via Frontend Transport; Fri, 13 Dec 2019 02:54:56 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VJVP7nzXe62BWYvNW0qUOimHLVcxVOkfkud+ySQSLbm6WkJ/GYh3pBxeLPtYmZ6Owo/x0tEZ2Xl023NQGeMJAkZSbS3vEWgEPMprS2s/WLUm4oVripRelYtogiQcUVyQOhW+VkMEr57oUVKLaDwiVybB9Lv93H7sSvUUxxbCk4iuuUbMqxIl975xevIYxHaP/79ms5Lv8+NtTjV5f+NTyRtKHpsu8TRz/6JOPqPNUcFYeUuZ8MdaAVshGt9p9MsLplTdUMFtHJpsaouJhKuDeWcex/F+ZcTeJpOqJk63RY87s6q6MIgKXtxZhk8/5ufKfmxANX1gE62k0ZichfjTBg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=M+8xSIbOtjmSYYRyoy2ZTUhVEHOqGhVXQzY1H9wCCFk=;
 b=bM+SbKMas8BYQjPmVcAkT9t0FDXCkxKECOwsvuGZQ6SAr9IHDXqCjanijKUUJ0t+gUJcs10ZBFa/JNHiGnuUPmZiIFbYPj67qE8bsfk7Y/eS1CkIqFHVWw0X7iR8mNz4/Oe9jnL9or9ZgcOFygRzFut5Szcv2fBoQeVbSHxUT00o5JCt0/gY55Vhr7Mtbzd9uSsvieRvaMpjnankurmVl3TkyhFZawmOUw1k1zdN9Xfqq6J8saAyo8j8d0Tfx15eEj8ltA/sdA1kYrU4hfeVwdGfGAwIyyM+fpeOZ/+zmtSfT+5EUKnplVHk+leNODfy2bhA3xQyUZgw7txU9XLnWw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=M+8xSIbOtjmSYYRyoy2ZTUhVEHOqGhVXQzY1H9wCCFk=;
 b=TxMhJwu+A+Z80/u3Egr9aBAlG3C/Cui2UfiWBsWcu0Rn0kjGudGq1W77rx5R1JL2EORb/jVOz3pVMu6xupip0SClNVx0Zy0G6JtLc68GMgqtelTjfusfpl7ce7Zg6sxbfATSFuIAK0+kTbuVoY4o5AZGOjrweRT8pLT47okjx30=
Received: from MN2PR11MB4448.namprd11.prod.outlook.com (52.135.39.157) by
 MN2PR11MB3935.namprd11.prod.outlook.com (10.255.180.93) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2538.17; Fri, 13 Dec 2019 09:54:54 +0000
Received: from MN2PR11MB4448.namprd11.prod.outlook.com
 ([fe80::84c:6e75:22df:cbc9]) by MN2PR11MB4448.namprd11.prod.outlook.com
 ([fe80::84c:6e75:22df:cbc9%5]) with mapi id 15.20.2538.017; Fri, 13 Dec 2019
 09:54:54 +0000
From:   <Tudor.Ambarus@microchip.com>
To:     <herbert@gondor.apana.org.au>
CC:     <Nicolas.Ferre@microchip.com>, <alexandre.belloni@bootlin.com>,
        <Ludovic.Desroches@microchip.com>, <linux-crypto@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <Tudor.Ambarus@microchip.com>
Subject: [PATCH 4/5] crypto: atmel-{sha,tdes} - Print warn message even when
 deferring
Thread-Topic: [PATCH 4/5] crypto: atmel-{sha,tdes} - Print warn message even
 when deferring
Thread-Index: AQHVsZteWaZn226a1EOkK8oh3K5wUg==
Date:   Fri, 13 Dec 2019 09:54:54 +0000
Message-ID: <20191213095423.6687-4-tudor.ambarus@microchip.com>
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
x-ms-office365-filtering-correlation-id: 61343722-f60c-4cf4-bfcf-08d77fb2812e
x-ms-traffictypediagnostic: MN2PR11MB3935:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MN2PR11MB3935476D72D53928580AA1BEF0540@MN2PR11MB3935.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5516;
x-forefront-prvs: 0250B840C1
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(376002)(346002)(39860400002)(396003)(366004)(136003)(199004)(189003)(2616005)(2906002)(6486002)(6916009)(71200400001)(6512007)(86362001)(186003)(26005)(478600001)(52116002)(64756008)(66446008)(81156014)(1076003)(5660300002)(81166006)(54906003)(107886003)(8936002)(36756003)(316002)(66556008)(66476007)(66946007)(6506007)(4326008)(8676002)(15650500001)(142933001);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR11MB3935;H:MN2PR11MB4448.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: microchip.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: UA5zgAIifrCeQmIp64Kbc9IkWyaZzfT+bIl10z6okjKDel1e3YiTi8IpFvW3LcHDlytl33ysG+FOjMO5UQzfKanc1HQ5H3SNahrEQhb/kowtMYy48ue6xE/fyNI7DQFU9sJ31D9Was0NCXfB7ByDg13t3KTxgxVgK23hLQshl9wLhuwxJdQGh4NbEhEGO+obHZn9o0C3oQPC/Gv/GpBJeVjgq5bpg4bhP05FRO7DqGZNvUW6KMJ/tUMDEDiFl/P1Q0Vp2I2Q6DjIpxuf4NMDtOuJn6DbWUwv78dZ3ehU6F7eCw+5QtpxIej1+nYObj8kxEIOQIQi9ZQiX4zsLPu2d2M4yf6/xZ1by3KN9Cy3HHvwwAwxus+0S8/RD1uoXyy+cPs6siQ0EHZjo/T+xPLgEBEYxT2dKF83JBq0HEAqgyCRCOKONEzB6hQxsgDb0JRr+5a3DA5w5M6bP8NQIYkkVlNIagvOC64zo0yDUYc33ZCalfeiqkLebb6Xeh/h9UYF
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 61343722-f60c-4cf4-bfcf-08d77fb2812e
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Dec 2019 09:54:54.6424
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 81Q2KsrswA9X9+sEeX/Q5FY/4VTwSGqaAtcR/Ik37QCx0VDhFyXvuhAFVrOneYGuQ16Eq2In4S4XhRNDEErJsx+jXbv0QEQ46qeMVhreWAs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB3935
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Tudor Ambarus <tudor.ambarus@microchip.com>

Even when deferring, we would like to know what caused it.
Update dev_warn to dev_err because if the DMA init fails,
the probe is stopped.

Signed-off-by: Tudor Ambarus <tudor.ambarus@microchip.com>
---
 drivers/crypto/atmel-aes.c  | 2 +-
 drivers/crypto/atmel-sha.c  | 7 ++-----
 drivers/crypto/atmel-tdes.c | 3 +--
 3 files changed, 4 insertions(+), 8 deletions(-)

diff --git a/drivers/crypto/atmel-aes.c b/drivers/crypto/atmel-aes.c
index 986f1ca682aa..855f0ccc9368 100644
--- a/drivers/crypto/atmel-aes.c
+++ b/drivers/crypto/atmel-aes.c
@@ -2292,7 +2292,7 @@ static int atmel_aes_dma_init(struct atmel_aes_dev *d=
d)
 err_dma_out:
 	dma_release_channel(dd->src.chan);
 err_dma_in:
-	dev_warn(dd->dev, "no DMA channel available\n");
+	dev_err(dd->dev, "no DMA channel available\n");
 	return ret;
 }
=20
diff --git a/drivers/crypto/atmel-sha.c b/drivers/crypto/atmel-sha.c
index a0d42bdc311f..e8e4200c1ab3 100644
--- a/drivers/crypto/atmel-sha.c
+++ b/drivers/crypto/atmel-sha.c
@@ -2485,11 +2485,8 @@ static int atmel_sha_dma_init(struct atmel_sha_dev *=
dd)
 {
 	dd->dma_lch_in.chan =3D dma_request_chan(dd->dev, "tx");
 	if (IS_ERR(dd->dma_lch_in.chan)) {
-		int ret =3D PTR_ERR(dd->dma_lch_in.chan);
-
-		if (ret !=3D -EPROBE_DEFER)
-			dev_warn(dd->dev, "no DMA channel available\n");
-		return ret;
+		dev_err(dd->dev, "DMA channel is not available\n");
+		return PTR_ERR(dd->dma_lch_in.chan);
 	}
=20
 	dd->dma_lch_in.dma_conf.dst_addr =3D dd->phys_base +
diff --git a/drivers/crypto/atmel-tdes.c b/drivers/crypto/atmel-tdes.c
index d42b22775ee9..83a6d42c8921 100644
--- a/drivers/crypto/atmel-tdes.c
+++ b/drivers/crypto/atmel-tdes.c
@@ -783,8 +783,7 @@ static int atmel_tdes_dma_init(struct atmel_tdes_dev *d=
d)
 err_dma_out:
 	dma_release_channel(dd->dma_lch_in.chan);
 err_dma_in:
-	if (ret !=3D -EPROBE_DEFER)
-		dev_warn(dd->dev, "no DMA channel available\n");
+	dev_err(dd->dev, "no DMA channel available\n");
 	return ret;
 }
=20
--=20
2.20.1

