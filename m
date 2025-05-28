Received: from mail.actia.se (mail.actia.se [212.181.117.226])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E95CD20C47C;
	Wed, 28 May 2025 14:43:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.181.117.226
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748443395; cv=none; b=K/9mV76ccdTwE9PR7szJlPmUJxB+B9zMWMgy1E9EJ0jchGgSbSrIMY0aqZUs1V6PVz5kP93Z3SaSSqltZaoA2zmmkun3XR98kv7fL2SBxL84OgPaL8ACD/gU9NPs43UZmQUtfOR3x36APsXyqNemG1okQWOzteBSdNAb2OoAVmQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748443395; c=relaxed/simple;
	bh=lpHAaiWow+aad2BBKkvtJuEQxaOZwqLxi8ae+QrPWKA=;
	h=From:To:CC:Subject:Date:Message-ID:Content-Type:MIME-Version; b=Yk+olMbAZSbm+9j51IQ/G5hR7cn+uACNZ3qmgkBgXkK07dq9XvXqgSfVc6NYPQdZbHltfimMTDbjGmYs7jpHeZ+/ImrfXCZaFdXcQR+zv4F5W8LgC057KQatGulh4S/NmP8BhbCTlZReeGrxGwzuvtIgYM6RXEkbLPIub63xteQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=actia.se; spf=pass smtp.mailfrom=actia.se; arc=none smtp.client-ip=212.181.117.226
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=actia.se
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=actia.se
Received: from S036ANL.actianordic.se (10.12.31.117) by S036ANL.actianordic.se
 (10.12.31.117) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Wed, 28 May
 2025 16:43:07 +0200
Received: from S036ANL.actianordic.se ([fe80::e13e:1feb:4ea6:ec69]) by
 S036ANL.actianordic.se ([fe80::e13e:1feb:4ea6:ec69%3]) with mapi id
 15.01.2507.039; Wed, 28 May 2025 16:43:07 +0200
From: John Ernberg <john.ernberg@actia.se>
To: =?utf-8?B?SG9yaWEgR2VhbnTEgw==?= <horia.geanta@nxp.com>, Pankaj Gupta
	<pankaj.gupta@nxp.com>, Gaurav Jain <gaurav.jain@nxp.com>, Herbert Xu
	<herbert@gondor.apana.org.au>, "David S . Miller" <davem@davemloft.net>, "Rob
 Herring" <robh@kernel.org>, Krzysztof Kozlowski <krzk+dt@kernel.org>, "Conor
 Dooley" <conor+dt@kernel.org>, Shawn Guo <shawnguo@kernel.org>, Sascha Hauer
	<s.hauer@pengutronix.de>
CC: Frank Li <Frank.li@nxp.com>, Pengutronix Kernel Team
	<kernel@pengutronix.de>, Fabio Estevam <festevam@gmail.com>, Thomas Richard
	<thomas.richard@bootlin.com>, "linux-crypto@vger.kernel.org"
	<linux-crypto@vger.kernel.org>, "devicetree@vger.kernel.org"
	<devicetree@vger.kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "imx@lists.linux.dev" <imx@lists.linux.dev>,
	"linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, John Ernberg <john.ernberg@actia.se>
Subject: [PATCH v3 0/4] crypto: caam - iMX8QXP support (and related fixes)
Thread-Topic: [PATCH v3 0/4] crypto: caam - iMX8QXP support (and related
 fixes)
Thread-Index: AQHbz97TPuW5MW56gEKcuq8Jspje1Q==
Date: Wed, 28 May 2025 14:43:07 +0000
Message-ID: <20250528144259.2603914-1-john.ernberg@actia.se>
Accept-Language: en-US, sv-SE
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-mailer: git-send-email 2.49.0
x-esetresult: clean, is OK
x-esetid: 37303A2955B14453607C60
Content-Type: text/plain; charset="utf-8"
Content-ID: <47E64EBDE00C974EAAF9F94B34C0B364@actia.se>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

VGhpcyBzZXJpZXMgZW5hYmxlcyB0aGUgdXNlIG9mIHRoZSBDQUFNIChDcnlwdG9ncmFwaGljIEFj
Y2VsZXJhdGlvbiBhbmQNCkFzc3VyYW5jZSBNb2R1bGUpIG9uIHRoZSBpTVg4UVhQIChhbmQgaXRz
IHZhcmlhbnRzKS4NCg0KdjM6IChkZXRhaWxlZCBjaGFuZ2Vsb2cgaW4gZWFjaCBwYXRjaCkNCiAt
IEZpeCBkZXZpY2V0cmVlIENJIGRldGVjdGVkIGVycm9ycyAoUm9iIEhlcnJpbmcncyBib3QpDQog
LSBEZWNsYXJlIHRoZSBjb21wYXRpYmxlcyBjb3JyZWN0bHkgaW4gYmluZGluZ3MgKEtyenlzenRv
ZiBLb3psb3dza2kpDQoNCnYyOiBodHRwczovL2xvcmUua2VybmVsLm9yZy9saW51eC1jcnlwdG8v
MjAyNTA1MjcwNzE1NTIuMTQyNDk5Ny0xLWpvaG4uZXJuYmVyZ0BhY3RpYS5zZS9UDQogLSBDbGFy
aWZ5IGluIHRoZSBjb21taXQgbWVzc2FnZSBob3cgdGhlIGNyYXNoIGZpeCB3b3JrcyAoRnJhbmsg
TGkpDQogLSBSZXN0cmljdCBwb3dlci1kb21haW5zIG9ubHkgZm9yIGlNWDhRKiBTb0NzIGluIGJp
bmRpbmdzIChGcmFuayBMaSkNCiAtIENvbGxlY3QgdGFncw0KDQp2MTogaHR0cHM6Ly9sb3JlLmtl
cm5lbC5vcmcvbGludXgtY3J5cHRvLzIwMjUwNTIzMTMxODE0LjEwNDc2NjItMS1qb2huLmVybmJl
cmdAYWN0aWEuc2UvVA0KDQpIb3JpYSBHZWFudMSDICgxKToNCiAgYXJtNjQ6IGR0czogZnJlZXNj
YWxlOiBpbXg4cXhwL2lteDhxbTogQWRkIENBQU0gc3VwcG9ydA0KDQpKb2huIEVybmJlcmcgKDMp
Og0KICBjcnlwdG86IGNhYW0gLSBQcmV2ZW50IGNyYXNoIG9uIHN1c3BlbmQgd2l0aCBpTVg4UU0g
LyBpTVg4VUxQDQogIGNyeXB0bzogY2FhbSAtIFN1cHBvcnQgaU1YOFFYUCBhbmQgdmFyaWFudHMg
dGhlcmVvZg0KICBkdC1iaW5kaW5nczogY3J5cHRvOiBmc2wsc2VjLXY0LjA6IEFkZCBwb3dlciBk
b21haW5zIGZvciBpTVg4UU0gYW5kDQogICAgaU1YOFFYUA0KDQogLi4uL2JpbmRpbmdzL2NyeXB0
by9mc2wsc2VjLXY0LjAueWFtbCAgICAgICAgIHwgNDUgKysrKysrKysrKysrKysrKysrLQ0KIC4u
Li9ib290L2R0cy9mcmVlc2NhbGUvaW14OC1zcy1zZWN1cml0eS5kdHNpICB8IDM4ICsrKysrKysr
KysrKysrKysNCiBhcmNoL2FybTY0L2Jvb3QvZHRzL2ZyZWVzY2FsZS9pbXg4cW0uZHRzaSAgICAg
fCAgMSArDQogYXJjaC9hcm02NC9ib290L2R0cy9mcmVlc2NhbGUvaW14OHF4cC5kdHNpICAgIHwg
IDEgKw0KIGRyaXZlcnMvY3J5cHRvL2NhYW0vY3RybC5jICAgICAgICAgICAgICAgICAgICB8ICA3
ICstLQ0KIGRyaXZlcnMvY3J5cHRvL2NhYW0vaW50ZXJuLmggICAgICAgICAgICAgICAgICB8ICAx
ICsNCiA2IGZpbGVzIGNoYW5nZWQsIDg5IGluc2VydGlvbnMoKyksIDQgZGVsZXRpb25zKC0pDQog
Y3JlYXRlIG1vZGUgMTAwNjQ0IGFyY2gvYXJtNjQvYm9vdC9kdHMvZnJlZXNjYWxlL2lteDgtc3Mt
c2VjdXJpdHkuZHRzaQ0KDQotLSANCjIuNDkuMA0K
