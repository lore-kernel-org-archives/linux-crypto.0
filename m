Received: from mail.actia.se (mail.actia.se [212.181.117.226])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B19C280A5A;
	Tue, 10 Jun 2025 08:51:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.181.117.226
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749545484; cv=none; b=Px6bR8FO/tC7pPE7Ep5eHZKuQZuLaAw49+6p0nhhUb2Vp02pSDai8igl3RsKogJQLn400KQALDvAnbBVy5ZtI/Cn7aqX3YfypagaUrPVkknaOKCehGjLyegpJbyLfcWH1pkpBUEdtqSx+7VNBd+/XE7KHzo408Al7coS4SYdCSA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749545484; c=relaxed/simple;
	bh=NdCx0a0uooAEmwgKJAXSoYL3eEeZT4nzJSwFsvAOD8k=;
	h=From:To:CC:Subject:Date:Message-ID:Content-Type:MIME-Version; b=fuu34vKDz4Jmfd4PeBxs2nRBehPTvwN3F/9twFOa+/msOpyqnPzZgWRFLqeIsfpfYN01lqWifbZhzMuKpFDu2FMQS5wTdi2/Im4zR7PNF0CASHAioJX9SFnyBpi8uqgwEe4Bj9ymW38GirIDWobdxt1+7CpkzdR1YN6k4/ByeTU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=actia.se; spf=pass smtp.mailfrom=actia.se; arc=none smtp.client-ip=212.181.117.226
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=actia.se
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=actia.se
Received: from S036ANL.actianordic.se (10.12.31.117) by S036ANL.actianordic.se
 (10.12.31.117) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Tue, 10 Jun
 2025 10:51:17 +0200
Received: from S036ANL.actianordic.se ([fe80::e13e:1feb:4ea6:ec69]) by
 S036ANL.actianordic.se ([fe80::e13e:1feb:4ea6:ec69%3]) with mapi id
 15.01.2507.039; Tue, 10 Jun 2025 10:51:17 +0200
From: John Ernberg <john.ernberg@actia.se>
To: =?utf-8?B?SG9yaWEgR2VhbnTEgw==?= <horia.geanta@nxp.com>, Pankaj Gupta
	<pankaj.gupta@nxp.com>, Gaurav Jain <gaurav.jain@nxp.com>, Herbert Xu
	<herbert@gondor.apana.org.au>, "David S . Miller" <davem@davemloft.net>, "Rob
 Herring" <robh@kernel.org>, Krzysztof Kozlowski <krzk+dt@kernel.org>, "Conor
 Dooley" <conor+dt@kernel.org>, Shawn Guo <shawnguo@kernel.org>, Sascha Hauer
	<s.hauer@pengutronix.de>
CC: Frank Li <Frank.Li@nxp.com>, Peng Fan <peng.fan@nxp.com>, "Pengutronix
 Kernel Team" <kernel@pengutronix.de>, Fabio Estevam <festevam@gmail.com>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	"devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"imx@lists.linux.dev" <imx@lists.linux.dev>,
	"linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, John Ernberg <john.ernberg@actia.se>
Subject: [PATCH v5 0/4] crypto: caam - iMX8QXP support (and related fixes)
Thread-Topic: [PATCH v5 0/4] crypto: caam - iMX8QXP support (and related
 fixes)
Thread-Index: AQHb2eTUrq3ZCiDJTEuBMgC/eD8VYQ==
Date: Tue, 10 Jun 2025 08:51:17 +0000
Message-ID: <20250610085110.2295392-1-john.ernberg@actia.se>
Accept-Language: en-US, sv-SE
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-mailer: git-send-email 2.49.0
x-esetresult: clean, is OK
x-esetid: 37303A2955B1445362776A
Content-Type: text/plain; charset="utf-8"
Content-ID: <0423180830A00341BE5A88454E6144E6@actia.se>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

VGhpcyBzZXJpZXMgZW5hYmxlcyB0aGUgdXNlIG9mIHRoZSBDQUFNIChDcnlwdG9ncmFwaGljIEFj
Y2VsZXJhdGlvbiBhbmQNCkFzc3VyYW5jZSBNb2R1bGUpIG9uIHRoZSBpTVg4UVhQIChhbmQgaXRz
IHZhcmlhbnRzKS4NCg0KdjU6IChkZXRhaWxlZCBjaGFuZ2Vsb2cgaW4gZWFjaCBwYXRjaCkNCiAt
IEZpeCBpbmRlbnRhdGlvbiBpc3N1ZXMgaW4gYmluZGluZ3MgKFJvYiBIZXJyaW5nJ3MgYm90KQ0K
IC0gQ29sbGVjdCB0YWdzDQoNCnY0OiBodHRwczovL2xvcmUua2VybmVsLm9yZy9saW51eC1jcnlw
dG8vMjAyNTA2MDUxMzI3NTQuMTc3MTM2OC0xLWpvaG4uZXJuYmVyZ0BhY3RpYS5zZS9UDQogLSBE
ZWNsYXJlIG1vcmUgY29tcGF0aWJsZXMgaW4gYmluZGluZ3MgKEZyYW5rIExpKQ0KIC0gTW92ZSBq
b2ItcmluZyBjb21wYXQgY2hlY2sgdW5kZXIgdGhlIGpvYi1yaW5nIHN1YnNjaGVtYSAoUm9iIEhl
cnJpbmcpDQoNCnYzOiBodHRwczovL2xvcmUua2VybmVsLm9yZy9saW51eC1jcnlwdG8vMjAyNTA1
MjgxNDQyNTkuMjYwMzkxNC0xLWpvaG4uZXJuYmVyZ0BhY3RpYS5zZS9UDQogLSBGaXggZGV2aWNl
dHJlZSBDSSBkZXRlY3RlZCBlcnJvcnMgKFJvYiBIZXJyaW5nJ3MgYm90KQ0KIC0gRGVjbGFyZSB0
aGUgY29tcGF0aWJsZXMgY29ycmVjdGx5IGluIGJpbmRpbmdzIChLcnp5c3p0b2YgS296bG93c2tp
KQ0KDQp2MjogaHR0cHM6Ly9sb3JlLmtlcm5lbC5vcmcvbGludXgtY3J5cHRvLzIwMjUwNTI3MDcx
NTUyLjE0MjQ5OTctMS1qb2huLmVybmJlcmdAYWN0aWEuc2UvVA0KIC0gQ2xhcmlmeSBpbiB0aGUg
Y29tbWl0IG1lc3NhZ2UgaG93IHRoZSBjcmFzaCBmaXggd29ya3MgKEZyYW5rIExpKQ0KIC0gUmVz
dHJpY3QgcG93ZXItZG9tYWlucyBvbmx5IGZvciBpTVg4USogU29DcyBpbiBiaW5kaW5ncyAoRnJh
bmsgTGkpDQogLSBDb2xsZWN0IHRhZ3MNCg0KdjE6IGh0dHBzOi8vbG9yZS5rZXJuZWwub3JnL2xp
bnV4LWNyeXB0by8yMDI1MDUyMzEzMTgxNC4xMDQ3NjYyLTEtam9obi5lcm5iZXJnQGFjdGlhLnNl
L1QNCg0KSG9yaWEgR2VhbnTEgyAoMSk6DQogIGFybTY0OiBkdHM6IGZyZWVzY2FsZTogaW14OHF4
cC9pbXg4cW06IEFkZCBDQUFNIHN1cHBvcnQNCg0KSm9obiBFcm5iZXJnICgzKToNCiAgY3J5cHRv
OiBjYWFtIC0gUHJldmVudCBjcmFzaCBvbiBzdXNwZW5kIHdpdGggaU1YOFFNIC8gaU1YOFVMUA0K
ICBjcnlwdG86IGNhYW0gLSBTdXBwb3J0IGlNWDhRWFAgYW5kIHZhcmlhbnRzIHRoZXJlb2YNCiAg
ZHQtYmluZGluZ3M6IGNyeXB0bzogZnNsLHNlYy12NC4wOiBBZGQgcG93ZXIgZG9tYWlucyBmb3Ig
aU1YOFFNIGFuZA0KICAgIGlNWDhRWFANCg0KIC4uLi9iaW5kaW5ncy9jcnlwdG8vZnNsLHNlYy12
NC4wLnlhbWwgICAgICAgICB8IDQxICsrKysrKysrKysrKysrKysrKy0NCiAuLi4vYm9vdC9kdHMv
ZnJlZXNjYWxlL2lteDgtc3Mtc2VjdXJpdHkuZHRzaSAgfCAzOCArKysrKysrKysrKysrKysrKw0K
IGFyY2gvYXJtNjQvYm9vdC9kdHMvZnJlZXNjYWxlL2lteDhxbS5kdHNpICAgICB8ICAxICsNCiAu
Li4vZHRzL2ZyZWVzY2FsZS9pbXg4cXhwLXNzLXNlY3VyaXR5LmR0c2kgICAgfCAxNiArKysrKysr
Kw0KIGFyY2gvYXJtNjQvYm9vdC9kdHMvZnJlZXNjYWxlL2lteDhxeHAuZHRzaSAgICB8ICAyICsN
CiBkcml2ZXJzL2NyeXB0by9jYWFtL2N0cmwuYyAgICAgICAgICAgICAgICAgICAgfCAgNyArKy0t
DQogZHJpdmVycy9jcnlwdG8vY2FhbS9pbnRlcm4uaCAgICAgICAgICAgICAgICAgIHwgIDEgKw0K
IDcgZmlsZXMgY2hhbmdlZCwgMTAyIGluc2VydGlvbnMoKyksIDQgZGVsZXRpb25zKC0pDQogY3Jl
YXRlIG1vZGUgMTAwNjQ0IGFyY2gvYXJtNjQvYm9vdC9kdHMvZnJlZXNjYWxlL2lteDgtc3Mtc2Vj
dXJpdHkuZHRzaQ0KIGNyZWF0ZSBtb2RlIDEwMDY0NCBhcmNoL2FybTY0L2Jvb3QvZHRzL2ZyZWVz
Y2FsZS9pbXg4cXhwLXNzLXNlY3VyaXR5LmR0c2kNCg0KLS0gDQoyLjQ5LjANCg==
