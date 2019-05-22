Return-Path: <SRS0=1Zye=TW=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.2 required=3.0 tests=FREEMAIL_FORGED_FROMDOMAIN,
	FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNWANTED_LANGUAGE_BODY,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7224DC18E7D
	for <linux-crypto@archiver.kernel.org>; Wed, 22 May 2019 10:07:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 526242075E
	for <linux-crypto@archiver.kernel.org>; Wed, 22 May 2019 10:07:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728869AbfEVKHR (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 22 May 2019 06:07:17 -0400
Received: from mail-oln040092071063.outbound.protection.outlook.com ([40.92.71.63]:37395
        "EHLO EUR03-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728424AbfEVKHQ (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 22 May 2019 06:07:16 -0400
Received: from DB5EUR03FT027.eop-EUR03.prod.protection.outlook.com
 (10.152.20.52) by DB5EUR03HT031.eop-EUR03.prod.protection.outlook.com
 (10.152.21.117) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.20.1900.16; Wed, 22 May
 2019 10:07:14 +0000
Received: from VI1PR07MB4432.eurprd07.prod.outlook.com (10.152.20.52) by
 DB5EUR03FT027.mail.protection.outlook.com (10.152.20.121) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.1922.16 via Frontend Transport; Wed, 22 May 2019 10:07:14 +0000
Received: from VI1PR07MB4432.eurprd07.prod.outlook.com
 ([fe80::91f:b1bb:a60a:fdc3]) by VI1PR07MB4432.eurprd07.prod.outlook.com
 ([fe80::91f:b1bb:a60a:fdc3%7]) with mapi id 15.20.1922.013; Wed, 22 May 2019
 10:07:14 +0000
From:   Philippe Mazenauer <philippe.mazenauer@outlook.de>
CC:     Philippe Mazenauer <philippe.mazenauer@outlook.de>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Russell King <linux@armlinux.org.uk>,
        "open list:CRYPTO API" <linux-crypto@vger.kernel.org>,
        "moderated list:ARM PORT" <linux-arm-kernel@lists.infradead.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: [PATCH] crypto: arm/sha512 - make function static
Thread-Topic: [PATCH] crypto: arm/sha512 - make function static
Thread-Index: AQHVEIYg0/n17GVM/0WrI34N1yB+nw==
Date:   Wed, 22 May 2019 10:07:14 +0000
Message-ID: <VI1PR07MB44324EFEF57062FCCA758358FD000@VI1PR07MB4432.eurprd07.prod.outlook.com>
Accept-Language: de-CH, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: CO2PR05CA0079.namprd05.prod.outlook.com
 (2603:10b6:102:2::47) To VI1PR07MB4432.eurprd07.prod.outlook.com
 (2603:10a6:802:67::17)
x-incomingtopheadermarker: OriginalChecksum:93E2A0D80A89EB0FBAA122ADC242ADBB36D5B9329F2929AEE227FBF289682C1E;UpperCasedChecksum:364AF332B8014653A71F9C05F8B8F4EA0A2873242A451BC0C99AFF3C41216965;SizeAsReceived:7591;Count:47
x-ms-exchange-messagesentrepresentingtype: 1
x-mailer: git-send-email 2.17.1
x-tmn:  [omNYMT9E9m9SRgFtDZrK8qFeDf5ZrQAu]
x-microsoft-original-message-id: <20190522100649.158063-1-philippe.mazenauer@outlook.de>
x-ms-publictraffictype: Email
x-incomingheadercount: 47
x-eopattributedmessage: 0
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(5050001)(7020095)(20181119110)(201702061078)(5061506573)(5061507331)(1603103135)(2017031320274)(2017031323274)(2017031324274)(2017031322404)(1601125500)(1603101475)(1701031045);SRVR:DB5EUR03HT031;
x-ms-traffictypediagnostic: DB5EUR03HT031:
x-microsoft-antispam-message-info: k9zPpgcEv+Y35MFMFfvUzP1JUpTutQyXOJSTCm07G3tj/aMDswjt7vN8KPYP1JgguXFtAGC7tO959slhAHC5k2dMcOhJS/6LSMPO/3rpSSETjlzJBnkTKqT3e2Dtt+u1WerN/kf1O+nsxg8bLh8M3hj1mY9gW/VoSp5beddeGsZx1tb4ByhnqNwk14ET2DtT
Content-Type: text/plain; charset="utf-8"
Content-ID: <73AB4A9B5F272D408CC901F2856F9BDD@eurprd07.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: outlook.com
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-CrossTenant-Network-Message-Id: 43087c09-cd2d-4f59-444e-08d6de9d4342
X-MS-Exchange-CrossTenant-rms-persistedconsumerorg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 May 2019 10:07:14.2749
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Internet
X-MS-Exchange-CrossTenant-id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB5EUR03HT031
To:     unlisted-recipients:; (no To-header on input)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

RnVuY3Rpb24gc2hhNTEyX2FybV9maW5hbCgpIGlzIG9ubHkgdXNlZCBpbiB0aGlzIGZpbGUsIHRo
ZXJlZm9yZSBzaG91bGQNCmJlIHN0YXRpYw0KDQouLi9hcmNoL2FybS9jcnlwdG8vc2hhNTEyLWds
dWUuYzo0MDo1OiB3YXJuaW5nOiBubyBwcmV2aW91cyBwcm90b3R5cGUgZm9yIOKAmHNoYTUxMl9h
cm1fZmluYWzigJkgWy1XbWlzc2luZy1wcm90b3R5cGVzXQ0KIGludCBzaGE1MTJfYXJtX2ZpbmFs
KHN0cnVjdCBzaGFzaF9kZXNjICpkZXNjLCB1OCAqb3V0KQ0KICAgICBefn5+fn5+fn5+fn5+fn5+
DQoNClNpZ25lZC1vZmYtYnk6IFBoaWxpcHBlIE1hemVuYXVlciA8cGhpbGlwcGUubWF6ZW5hdWVy
QG91dGxvb2suZGU+DQotLS0NCiBhcmNoL2FybS9jcnlwdG8vc2hhNTEyLWdsdWUuYyB8IDIgKy0N
CiAxIGZpbGUgY2hhbmdlZCwgMSBpbnNlcnRpb24oKyksIDEgZGVsZXRpb24oLSkNCg0KZGlmZiAt
LWdpdCBhL2FyY2gvYXJtL2NyeXB0by9zaGE1MTItZ2x1ZS5jIGIvYXJjaC9hcm0vY3J5cHRvL3No
YTUxMi1nbHVlLmMNCmluZGV4IDg2NTQwY2Q0YTZmYS4uMjNmYzM4MTNhOTFiIDEwMDY0NA0KLS0t
IGEvYXJjaC9hcm0vY3J5cHRvL3NoYTUxMi1nbHVlLmMNCisrKyBiL2FyY2gvYXJtL2NyeXB0by9z
aGE1MTItZ2x1ZS5jDQpAQCAtMzcsNyArMzcsNyBAQCBpbnQgc2hhNTEyX2FybV91cGRhdGUoc3Ry
dWN0IHNoYXNoX2Rlc2MgKmRlc2MsIGNvbnN0IHU4ICpkYXRhLA0KIAkJKHNoYTUxMl9ibG9ja19m
biAqKXNoYTUxMl9ibG9ja19kYXRhX29yZGVyKTsNCiB9DQogDQotaW50IHNoYTUxMl9hcm1fZmlu
YWwoc3RydWN0IHNoYXNoX2Rlc2MgKmRlc2MsIHU4ICpvdXQpDQorc3RhdGljIGludCBzaGE1MTJf
YXJtX2ZpbmFsKHN0cnVjdCBzaGFzaF9kZXNjICpkZXNjLCB1OCAqb3V0KQ0KIHsNCiAJc2hhNTEy
X2Jhc2VfZG9fZmluYWxpemUoZGVzYywNCiAJCShzaGE1MTJfYmxvY2tfZm4gKilzaGE1MTJfYmxv
Y2tfZGF0YV9vcmRlcik7DQotLSANCjIuMTcuMQ0KDQo=
