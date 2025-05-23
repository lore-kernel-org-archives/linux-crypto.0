Received: from mail.actia.se (mail.actia.se [212.181.117.226])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80A1F5FB95;
	Fri, 23 May 2025 13:33:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.181.117.226
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748007225; cv=none; b=T//RaCOblFdyX4nLghnw4PC/zt9BBXTISis/cEHSDe9basINWMkftZHFrHZtlguXAKmWoM20EEYA7uRy4DclnU87yQJj6Gd4OOon3TeBXf9pGM42Rct8ibqk+gE5fcrIdWGiuNTPqQYfoXiGjrzuUnenSCPWk7TyZKa8QtSNsA8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748007225; c=relaxed/simple;
	bh=+oWbheLtmxAxFo30a5sy0XXCegWFyhqhELgo3ZhyLng=;
	h=From:To:CC:Subject:Date:Message-ID:Content-Type:MIME-Version; b=Y44ScvuSKRRn0D58g/JWji6Qu3wJIEg1q6nTaN13DRXZEXu2+Dk077W2wtxG1vGsF/xJOEusgb6cDGtC8oMt6dXY1dR4hFbWentp6z8N1b+Z84la6lO89GfI9t6bFs+s3RIk95vbxovadJZ7+xYYPd3FsWSAKkA/dOyT6MxSdJ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=actia.se; spf=pass smtp.mailfrom=actia.se; arc=none smtp.client-ip=212.181.117.226
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=actia.se
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=actia.se
Received: from S036ANL.actianordic.se (10.12.31.117) by S036ANL.actianordic.se
 (10.12.31.117) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Fri, 23 May
 2025 15:18:32 +0200
Received: from S036ANL.actianordic.se ([fe80::e13e:1feb:4ea6:ec69]) by
 S036ANL.actianordic.se ([fe80::e13e:1feb:4ea6:ec69%3]) with mapi id
 15.01.2507.039; Fri, 23 May 2025 15:18:32 +0200
From: John Ernberg <john.ernberg@actia.se>
To: =?utf-8?B?SG9yaWEgR2VhbnTEgw==?= <horia.geanta@nxp.com>, Pankaj Gupta
	<pankaj.gupta@nxp.com>, Gaurav Jain <gaurav.jain@nxp.com>, Herbert Xu
	<herbert@gondor.apana.org.au>, "David S . Miller" <davem@davemloft.net>, "Rob
 Herring" <robh@kernel.org>, Krzysztof Kozlowski <krzk+dt@kernel.org>, "Conor
 Dooley" <conor+dt@kernel.org>, Shawn Guo <shawnguo@kernel.org>, Sascha Hauer
	<s.hauer@pengutronix.de>
CC: Pengutronix Kernel Team <kernel@pengutronix.de>, Fabio Estevam
	<festevam@gmail.com>, Thomas Richard <thomas.richard@bootlin.com>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	"devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"imx@lists.linux.dev" <imx@lists.linux.dev>,
	"linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, John Ernberg <john.ernberg@actia.se>
Subject: [PATCH 0/4] crypto: caam - iMX8QXP support (and related fixes)
Thread-Topic: [PATCH 0/4] crypto: caam - iMX8QXP support (and related fixes)
Thread-Index: AQHby+UudBZY+LpW90mK/tjBsTdMwg==
Date: Fri, 23 May 2025 13:18:31 +0000
Message-ID: <20250523131814.1047662-1-john.ernberg@actia.se>
Accept-Language: en-US, sv-SE
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-mailer: git-send-email 2.49.0
x-esetresult: clean, is OK
x-esetid: 37303A2955B14453607162
Content-Type: text/plain; charset="utf-8"
Content-ID: <DF573AF18ED1AA43B5D721DEF54B24E9@actia.se>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

VGhpcyBzZXJpZXMgZW5hYmxlcyB0aGUgdXNlIG9mIHRoZSBDQUFNIChDcnlwdG9ncmFwaGljIEFj
Y2VsZXJhdGlvbiBhbmQNCkFzc3VyYW5jZSBNb2R1bGUpIG9uIHRoZSBpTVg4UVhQIChhbmQgaXRz
IHZhcmlhbnRzKS4NCg0KSG9yaWEgR2VhbnTEgyAoMSk6DQogIGFybTY0OiBkdHM6IGZyZWVzY2Fs
ZTogaW14OHF4cC9pbXg4cW06IEFkZCBDQUFNIHN1cHBvcnQNCg0KSm9obiBFcm5iZXJnICgzKToN
CiAgY3J5cHRvOiBjYWFtIC0gUHJldmVudCBjcmFzaCBvbiBzdXNwZW5kIHdpdGggaU1YOFFNIC8g
aU1YOFVMUA0KICBjcnlwdG86IGNhYW0gLSBTdXBwb3J0IGlNWDhRWFAgYW5kIHZhcmlhbnRzIHRo
ZXJlb2YNCiAgZHQtYmluZGluZ3M6IGNyeXB0bzogZnNsLHNlYy12NC4wOiBBbGxvdyBzdXBwbHlp
bmcgcG93ZXItZG9tYWlucw0KDQogLi4uL2JpbmRpbmdzL2NyeXB0by9mc2wsc2VjLXY0LjAueWFt
bCAgICAgICAgIHwgIDYgKysrDQogLi4uL2Jvb3QvZHRzL2ZyZWVzY2FsZS9pbXg4LXNzLXNlY3Vy
aXR5LmR0c2kgIHwgMzggKysrKysrKysrKysrKysrKysrKw0KIGFyY2gvYXJtNjQvYm9vdC9kdHMv
ZnJlZXNjYWxlL2lteDhxbS5kdHNpICAgICB8ICAxICsNCiBhcmNoL2FybTY0L2Jvb3QvZHRzL2Zy
ZWVzY2FsZS9pbXg4cXhwLmR0c2kgICAgfCAgMSArDQogZHJpdmVycy9jcnlwdG8vY2FhbS9jdHJs
LmMgICAgICAgICAgICAgICAgICAgIHwgIDcgKystLQ0KIGRyaXZlcnMvY3J5cHRvL2NhYW0vaW50
ZXJuLmggICAgICAgICAgICAgICAgICB8ICAxICsNCiA2IGZpbGVzIGNoYW5nZWQsIDUxIGluc2Vy
dGlvbnMoKyksIDMgZGVsZXRpb25zKC0pDQogY3JlYXRlIG1vZGUgMTAwNjQ0IGFyY2gvYXJtNjQv
Ym9vdC9kdHMvZnJlZXNjYWxlL2lteDgtc3Mtc2VjdXJpdHkuZHRzaQ0KDQotLSANCjIuNDkuMA0K
