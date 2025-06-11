Received: from mail.actia.se (mail.actia.se [212.181.117.226])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BFCE23BCF8;
	Wed, 11 Jun 2025 11:38:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.181.117.226
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749641895; cv=none; b=BQRML9CB8Muy2GeSMEhUIqdBd3qqpqeEvK4IjIEClJGJvFHkb6KECVcckx/6oRGNydTZnJniAetQJH3A3vRFYR7k7jWsSDeHUPEN1g3lEbga5i+7jVcJf67Q+WsAAh6+p3GguQ+sJeC4AZP19+JlePCvxSrL3TQlBoIU54PVN6o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749641895; c=relaxed/simple;
	bh=mLT6Szq/xGEa3XXcxtJnhZSsdic8SU0ZR7G+WQsu4dI=;
	h=From:To:CC:Subject:Date:Message-ID:Content-Type:MIME-Version; b=Pg+XvDmVRHB358f9nFmPjvcPml+/kin+xgtQXtBFq1iOiRg0AwGiCLG99LY5lYIXiwtJDcfA0CLaXB8iKIC/yRRntvM9cVY256s5wAsnNhDvJ42RTWf4Xf+royvT7Y93lZ5NbQ9ZU5xLWT31jJhL3E6CI5GZM2xS5uD8V4lK0Jo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=actia.se; spf=pass smtp.mailfrom=actia.se; arc=none smtp.client-ip=212.181.117.226
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=actia.se
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=actia.se
Received: from S036ANL.actianordic.se (10.12.31.117) by S035ANL.actianordic.se
 (10.12.31.116) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Wed, 11 Jun
 2025 13:38:08 +0200
Received: from S036ANL.actianordic.se ([fe80::e13e:1feb:4ea6:ec69]) by
 S036ANL.actianordic.se ([fe80::e13e:1feb:4ea6:ec69%3]) with mapi id
 15.01.2507.039; Wed, 11 Jun 2025 13:38:08 +0200
From: John Ernberg <john.ernberg@actia.se>
To: =?utf-8?B?SG9yaWEgR2VhbnTEgw==?= <horia.geanta@nxp.com>, Pankaj Gupta
	<pankaj.gupta@nxp.com>, Gaurav Jain <gaurav.jain@nxp.com>, Herbert Xu
	<herbert@gondor.apana.org.au>, "David S . Miller" <davem@davemloft.net>, "Rob
 Herring" <robh@kernel.org>, Krzysztof Kozlowski <krzk+dt@kernel.org>, "Conor
 Dooley" <conor+dt@kernel.org>, Shawn Guo <shawnguo@kernel.org>, Sascha Hauer
	<s.hauer@pengutronix.de>
CC: Peng Fan <peng.fan@nxp.com>, Frank Li <Frank.Li@nxp.com>, "Pengutronix
 Kernel Team" <kernel@pengutronix.de>, Fabio Estevam <festevam@gmail.com>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	"devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"imx@lists.linux.dev" <imx@lists.linux.dev>,
	"linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, John Ernberg <john.ernberg@actia.se>
Subject: [PATCH v6 0/4] crypto: caam - iMX8QXP support (and related fixes)
Thread-Topic: [PATCH v6 0/4] crypto: caam - iMX8QXP support (and related
 fixes)
Thread-Index: AQHb2sVNVczInQ6djkqz+g3DSp7mBg==
Date: Wed, 11 Jun 2025 11:38:08 +0000
Message-ID: <20250611113748.2986988-1-john.ernberg@actia.se>
Accept-Language: en-US, sv-SE
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-mailer: git-send-email 2.49.0
x-esetresult: clean, is OK
x-esetid: 37303A2956B14453627160
Content-Type: text/plain; charset="utf-8"
Content-ID: <9FD4A6CEBDB8CF48B68EA0CA7731A73B@actia.se>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

VGhpcyBzZXJpZXMgZW5hYmxlcyB0aGUgdXNlIG9mIHRoZSBDQUFNIChDcnlwdG9ncmFwaGljIEFj
Y2VsZXJhdGlvbiBhbmQNCkFzc3VyYW5jZSBNb2R1bGUpIG9uIHRoZSBpTVg4UVhQIChhbmQgaXRz
IHZhcmlhbnRzKS4NCg0KdjY6IChkZXRhaWxlZCBjaGFuZ2Vsb2cgaW4gZWFjaCBwYXRjaCkNCiAt
IEZpeCBwcm9wZXJ0eSBvcmRlciBpbiBiaW5kaW5ncyAoRnJhbmsgTGkpDQogLSBDb2xsZWN0IHRh
Z3MNCg0KdjU6IGh0dHBzOi8vbG9yZS5rZXJuZWwub3JnL2xpbnV4LWNyeXB0by8yMDI1MDYxMDA4
NTExMC4yMjk1MzkyLTEtam9obi5lcm5iZXJnQGFjdGlhLnNlL1QNCiAtIEZpeCBpbmRlbnRhdGlv
biBpc3N1ZXMgaW4gYmluZGluZ3MgKFJvYiBIZXJyaW5nJ3MgYm90KQ0KIC0gQ29sbGVjdCB0YWdz
DQoNCnY0OiBodHRwczovL2xvcmUua2VybmVsLm9yZy9saW51eC1jcnlwdG8vMjAyNTA2MDUxMzI3
NTQuMTc3MTM2OC0xLWpvaG4uZXJuYmVyZ0BhY3RpYS5zZS9UDQogLSBEZWNsYXJlIG1vcmUgY29t
cGF0aWJsZXMgaW4gYmluZGluZ3MgKEZyYW5rIExpKQ0KIC0gTW92ZSBqb2ItcmluZyBjb21wYXQg
Y2hlY2sgdW5kZXIgdGhlIGpvYi1yaW5nIHN1YnNjaGVtYSAoUm9iIEhlcnJpbmcpDQoNCnYzOiBo
dHRwczovL2xvcmUua2VybmVsLm9yZy9saW51eC1jcnlwdG8vMjAyNTA1MjgxNDQyNTkuMjYwMzkx
NC0xLWpvaG4uZXJuYmVyZ0BhY3RpYS5zZS9UDQogLSBGaXggZGV2aWNldHJlZSBDSSBkZXRlY3Rl
ZCBlcnJvcnMgKFJvYiBIZXJyaW5nJ3MgYm90KQ0KIC0gRGVjbGFyZSB0aGUgY29tcGF0aWJsZXMg
Y29ycmVjdGx5IGluIGJpbmRpbmdzIChLcnp5c3p0b2YgS296bG93c2tpKQ0KDQp2MjogaHR0cHM6
Ly9sb3JlLmtlcm5lbC5vcmcvbGludXgtY3J5cHRvLzIwMjUwNTI3MDcxNTUyLjE0MjQ5OTctMS1q
b2huLmVybmJlcmdAYWN0aWEuc2UvVA0KIC0gQ2xhcmlmeSBpbiB0aGUgY29tbWl0IG1lc3NhZ2Ug
aG93IHRoZSBjcmFzaCBmaXggd29ya3MgKEZyYW5rIExpKQ0KIC0gUmVzdHJpY3QgcG93ZXItZG9t
YWlucyBvbmx5IGZvciBpTVg4USogU29DcyBpbiBiaW5kaW5ncyAoRnJhbmsgTGkpDQogLSBDb2xs
ZWN0IHRhZ3MNCg0KdjE6IGh0dHBzOi8vbG9yZS5rZXJuZWwub3JnL2xpbnV4LWNyeXB0by8yMDI1
MDUyMzEzMTgxNC4xMDQ3NjYyLTEtam9obi5lcm5iZXJnQGFjdGlhLnNlL1QNCg0KSG9yaWEgR2Vh
bnTEgyAoMSk6DQogIGFybTY0OiBkdHM6IGZyZWVzY2FsZTogaW14OHF4cC9pbXg4cW06IEFkZCBD
QUFNIHN1cHBvcnQNCg0KSm9obiBFcm5iZXJnICgzKToNCiAgY3J5cHRvOiBjYWFtIC0gUHJldmVu
dCBjcmFzaCBvbiBzdXNwZW5kIHdpdGggaU1YOFFNIC8gaU1YOFVMUA0KICBjcnlwdG86IGNhYW0g
LSBTdXBwb3J0IGlNWDhRWFAgYW5kIHZhcmlhbnRzIHRoZXJlb2YNCiAgZHQtYmluZGluZ3M6IGNy
eXB0bzogZnNsLHNlYy12NC4wOiBBZGQgcG93ZXIgZG9tYWlucyBmb3IgaU1YOFFNIGFuZA0KICAg
IGlNWDhRWFANCg0KIC4uLi9iaW5kaW5ncy9jcnlwdG8vZnNsLHNlYy12NC4wLnlhbWwgICAgICAg
ICB8IDQxICsrKysrKysrKysrKysrKysrKy0NCiAuLi4vYm9vdC9kdHMvZnJlZXNjYWxlL2lteDgt
c3Mtc2VjdXJpdHkuZHRzaSAgfCAzOCArKysrKysrKysrKysrKysrKw0KIGFyY2gvYXJtNjQvYm9v
dC9kdHMvZnJlZXNjYWxlL2lteDhxbS5kdHNpICAgICB8ICAxICsNCiAuLi4vZHRzL2ZyZWVzY2Fs
ZS9pbXg4cXhwLXNzLXNlY3VyaXR5LmR0c2kgICAgfCAxNiArKysrKysrKw0KIGFyY2gvYXJtNjQv
Ym9vdC9kdHMvZnJlZXNjYWxlL2lteDhxeHAuZHRzaSAgICB8ICAyICsNCiBkcml2ZXJzL2NyeXB0
by9jYWFtL2N0cmwuYyAgICAgICAgICAgICAgICAgICAgfCAgNyArKy0tDQogZHJpdmVycy9jcnlw
dG8vY2FhbS9pbnRlcm4uaCAgICAgICAgICAgICAgICAgIHwgIDEgKw0KIDcgZmlsZXMgY2hhbmdl
ZCwgMTAyIGluc2VydGlvbnMoKyksIDQgZGVsZXRpb25zKC0pDQogY3JlYXRlIG1vZGUgMTAwNjQ0
IGFyY2gvYXJtNjQvYm9vdC9kdHMvZnJlZXNjYWxlL2lteDgtc3Mtc2VjdXJpdHkuZHRzaQ0KIGNy
ZWF0ZSBtb2RlIDEwMDY0NCBhcmNoL2FybTY0L2Jvb3QvZHRzL2ZyZWVzY2FsZS9pbXg4cXhwLXNz
LXNlY3VyaXR5LmR0c2kNCg0KLS0gDQoyLjQ5LjANCg==
