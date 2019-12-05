Return-Path: <SRS0=t288=Z3=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 22851C2BD09
	for <linux-crypto@archiver.kernel.org>; Thu,  5 Dec 2019 09:54:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E35FA24654
	for <linux-crypto@archiver.kernel.org>; Thu,  5 Dec 2019 09:54:14 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=microchiptechnology.onmicrosoft.com header.i=@microchiptechnology.onmicrosoft.com header.b="rbvmhcUM"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729459AbfLEJyN (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 5 Dec 2019 04:54:13 -0500
Received: from esa1.microchip.iphmx.com ([68.232.147.91]:30717 "EHLO
        esa1.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729441AbfLEJyM (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 5 Dec 2019 04:54:12 -0500
Received-SPF: Pass (esa1.microchip.iphmx.com: domain of
  Tudor.Ambarus@microchip.com designates 198.175.253.82 as
  permitted sender) identity=mailfrom;
  client-ip=198.175.253.82; receiver=esa1.microchip.iphmx.com;
  envelope-from="Tudor.Ambarus@microchip.com";
  x-sender="Tudor.Ambarus@microchip.com";
  x-conformance=spf_only; x-record-type="v=spf1";
  x-record-text="v=spf1 mx a:ushub1.microchip.com
  a:smtpout.microchip.com -exists:%{i}.spf.microchip.iphmx.com
  include:servers.mcsv.net include:mktomail.com
  include:spf.protection.outlook.com ~all"
Received-SPF: None (esa1.microchip.iphmx.com: no sender
  authenticity information available from domain of
  postmaster@email.microchip.com) identity=helo;
  client-ip=198.175.253.82; receiver=esa1.microchip.iphmx.com;
  envelope-from="Tudor.Ambarus@microchip.com";
  x-sender="postmaster@email.microchip.com";
  x-conformance=spf_only
Authentication-Results: esa1.microchip.iphmx.com; spf=Pass smtp.mailfrom=Tudor.Ambarus@microchip.com; spf=None smtp.helo=postmaster@email.microchip.com; dkim=pass (signature verified) header.i=@microchiptechnology.onmicrosoft.com; dmarc=pass (p=none dis=none) d=microchip.com
IronPort-SDR: BV2aU6pNUP/+0bwG3QbbBQRhLmfchapXczLp5S49HqFJk6jDnohROsWDcKHLIBOUHtOelfQpDm
 hTHnMBM+AV0UM0bKIXw7340y71qrXMIzzHIofdoVumiyqtYT6hVeRKS895ZqjQzHYh4OY2TDRO
 Wla0+cj5GgatnSvnPhgtU6MQC0eBRl60zhpnPlI/5p3tWd414mawT4FDS4CC6Kzpjp8usXzB8J
 NLEEzAL6tomi9+RJ67w0RL29qWhRalEWM5yiN7M4FmHQ+SMAWfyq0kAvT9UqAAcBx32Xrnhu/j
 MSc=
X-IronPort-AV: E=Sophos;i="5.69,281,1571727600"; 
   d="scan'208";a="60720975"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa1.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 05 Dec 2019 02:54:11 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.87.72) by
 chn-vm-ex02.mchp-main.com (10.10.87.72) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Thu, 5 Dec 2019 02:54:13 -0700
Received: from NAM04-CO1-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.72) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1713.5 via Frontend
 Transport; Thu, 5 Dec 2019 02:54:13 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fCfQuAq7uos93T1rNrz13bSjqN/qYyAUUA6mudP81Bvqz/zGib/2djIjIfpN9PVe0lNJ0f5PP+Pu0Y3G3a5R0Tntmx0IPiA9LPW7Yv4SfjbGQGqaa6yi9RxNiAHHUGKbhi1PMzVGEXo0/WQbiUyNY+AqgWNZI6jqKq+uyD6Kjm2IEWQhokFHtXGHUrP7fHwTul3zD3YzdkWuikkbqPiZ3sucU84LdOlSee7pVYsTgAyU4/PJv4lJBovtOTWw8JUgTV9TIlLplUk3VyihX+JP5fdoDi2rEYXoP3DuzMuEiux3w/itNnjiZS7q+0rSnwQn21dfGM7x/logMvNPPwCZHA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OAOWNs1s5agnr7SuVhtFNcGCj2V/kJs6rFylGY8kjLU=;
 b=PQHXGNl3Tm2NyVcoYYFQlZo3Gv697zneODWpj7O0nN/jSWD8Tb7MkgRBzdjj6rwjDx/70kG27xzkGkhlCjN0r9KEjab8VZjAc/P+/OxO4N7U7wu5Nh0eO5iXeONFG4YfPf8K62elvh8+Gaem5Nv6+vqKUVj4gocg1mYzfZFGdaAk2V1WjNlsFxJzC1IGbCIMq7qryvDcDfVqQ21E6VPhvSLjYJ7tq+53Oh/hwHRG18nU1BJY+93bkdvtCDMF5oZQ2OGa4HqvLSoIjcJM6XPti5ctDnSbkbO49pZzd77k6M9s2FmN6irW+K7arHpXatoR5iGvsZ0oAJeNqzCXj7hPJw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OAOWNs1s5agnr7SuVhtFNcGCj2V/kJs6rFylGY8kjLU=;
 b=rbvmhcUMBJGeHsdXTWN/Jv0rsCkQ5cUY7oUsIg97Xk4Z7TmuMy7dFCrCQR8oPkSfM0qKEJXMBpBe/VyxpLLosLcp3WSA18uWgHwDnQbFe0OB1+pOpHZm/7hgEe+c8cZWqOWp+YJxeK137wYTZNCczZZ3wJuc1/71Oh2HElRzkTg=
Received: from MN2PR11MB4448.namprd11.prod.outlook.com (52.135.39.157) by
 MN2PR11MB4288.namprd11.prod.outlook.com (52.135.37.206) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2495.20; Thu, 5 Dec 2019 09:54:08 +0000
Received: from MN2PR11MB4448.namprd11.prod.outlook.com
 ([fe80::84c:6e75:22df:cbc9]) by MN2PR11MB4448.namprd11.prod.outlook.com
 ([fe80::84c:6e75:22df:cbc9%5]) with mapi id 15.20.2495.026; Thu, 5 Dec 2019
 09:54:08 +0000
From:   <Tudor.Ambarus@microchip.com>
To:     <herbert@gondor.apana.org.au>
CC:     <Nicolas.Ferre@microchip.com>, <alexandre.belloni@bootlin.com>,
        <Ludovic.Desroches@microchip.com>, <linux-crypto@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <Tudor.Ambarus@microchip.com>
Subject: [PATCH 15/16] crypto: atmel-aes - Use gcm helper to check authsize
Thread-Topic: [PATCH 15/16] crypto: atmel-aes - Use gcm helper to check
 authsize
Thread-Index: AQHVq1Hw4WjMrsbR9EK2AA7AYtclSQ==
Date:   Thu, 5 Dec 2019 09:54:08 +0000
Message-ID: <20191205095326.5094-16-tudor.ambarus@microchip.com>
References: <20191205095326.5094-1-tudor.ambarus@microchip.com>
In-Reply-To: <20191205095326.5094-1-tudor.ambarus@microchip.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: FR2P281CA0018.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:a::28) To MN2PR11MB4448.namprd11.prod.outlook.com
 (2603:10b6:208:193::29)
x-ms-exchange-messagesentrepresentingtype: 1
x-mailer: git-send-email 2.14.5
x-originating-ip: [94.177.32.156]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 47e624d2-3653-49f9-e6f4-08d77969128b
x-ms-traffictypediagnostic: MN2PR11MB4288:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MN2PR11MB4288D13234F0320FE0B0DFA1F05C0@MN2PR11MB4288.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:404;
x-forefront-prvs: 02426D11FE
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(346002)(376002)(136003)(39860400002)(396003)(366004)(189003)(199004)(6506007)(1076003)(305945005)(4326008)(2616005)(86362001)(478600001)(11346002)(14444005)(102836004)(107886003)(2906002)(50226002)(5660300002)(66446008)(66946007)(66476007)(66556008)(14454004)(1730700003)(64756008)(76176011)(8936002)(4744005)(52116002)(81166006)(186003)(5640700003)(81156014)(36756003)(71200400001)(71190400001)(54906003)(6512007)(316002)(6486002)(25786009)(8676002)(26005)(6916009)(99286004);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR11MB4288;H:MN2PR11MB4448.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: microchip.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: zC03FiKmMEsbHSAAqagsf8JqoZkZY+J6IlwJXsW0vpYE/Bqy3yHM1cR00XyiuhYT0DVPNkvPiHBNzTjtlTZtKGfd4FQstXfw1gHODiutfW4kQUg+rsRryXBdIYGQSFTKtnIpRtTkgicX25wvyPwXcBoIY6WzAOnj7fRDrK5fkiMfcxf6wCqd/D7B4Ah/ARhFZO9PqTaetqP7C4LnRSiS14dsKLcpl3RNoFkcqMVjhLRXFUlybokOybH/MwZrDPQ+INfXofgROflr6Jf2a7nEHylAlFK+bUpn/8Puo9nOdsdyyGe5cWI8sMbZBVICZ5VMM7YNDcDMSuELdsDasKisosC0HmchQMSUGKgFYV3eHIkyF/P49ALE45dR7jWN5Hh12mxuYsbyGUelsCgpVWHFGRMo2cMeTXx1zQfkUm+02DOWl+VBlX576R85mKEGhaC7
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 47e624d2-3653-49f9-e6f4-08d77969128b
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Dec 2019 09:54:08.8208
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: IQXUIhG9qk+xKMZzw16GLSghsks/Gyrb8c8OFbSXoHAxHFVQ7JAZLm1abNoDOr5hV9TnjkdKNIO0Yk4x3G1fDYZeGsjdoH9O5nuDsaRenqM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB4288
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Tudor Ambarus <tudor.ambarus@microchip.com>

Use core helper functions.

Signed-off-by: Tudor Ambarus <tudor.ambarus@microchip.com>
---
 drivers/crypto/atmel-aes.c | 16 +---------------
 1 file changed, 1 insertion(+), 15 deletions(-)

diff --git a/drivers/crypto/atmel-aes.c b/drivers/crypto/atmel-aes.c
index 60f54580d646..18802c977291 100644
--- a/drivers/crypto/atmel-aes.c
+++ b/drivers/crypto/atmel-aes.c
@@ -1790,21 +1790,7 @@ static int atmel_aes_gcm_setkey(struct crypto_aead *=
tfm, const u8 *key,
 static int atmel_aes_gcm_setauthsize(struct crypto_aead *tfm,
 				     unsigned int authsize)
 {
-	/* Same as crypto_gcm_authsize() from crypto/gcm.c */
-	switch (authsize) {
-	case 4:
-	case 8:
-	case 12:
-	case 13:
-	case 14:
-	case 15:
-	case 16:
-		break;
-	default:
-		return -EINVAL;
-	}
-
-	return 0;
+	return crypto_gcm_check_authsize(authsize);
 }
=20
 static int atmel_aes_gcm_encrypt(struct aead_request *req)
--=20
2.14.5

