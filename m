Received: from AM0PR02CU008.outbound.protection.outlook.com (mail-westeuropeazon11023092.outbound.protection.outlook.com [52.101.72.92])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0072E52D2AB;
	Tue, 29 Sep 2026 13:53:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.72.92
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790690013; cv=fail; b=bT1wWPZqhq3OZEmPqY3RWUGeaoTFYFYEKMtFmbq12aHGIK+b2baCC6rntZxdL3izTuFKTPFpgUycFLiBpiX3fva4mcSp34O5tmYDbyVr+Ukb4SlRAUf+ZkP9pp+K/7JStSicTPcuzbiX/8PfirbRLMUKxJhMf+3thiOgBVuuyzw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790690013; c=relaxed/simple;
	bh=SJR0ImkRuxOwjMjHz9ybNvQT+vJUmgi6d8U4vIl49DU=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=XOFUSTrbdWbE4nJHAbTNVzW0KNIGQXGzqWeMGx9XqlSGoOeUMRJQPirFXHWslfz9i5g4VT6B8sNWPfeC8FYn79e6jHO4LnuVPhRi93LnAhomB3IdCqOsQ1pmNh0xwo1NmrNb4Xx7OcyojCOJ6eelQLoi8nO2v5PPsNq4wEaeHK8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=ginzinger.com; spf=pass smtp.mailfrom=ginzinger.com; dkim=pass (2048-bit key) header.d=ginzinger.com header.i=@ginzinger.com header.b=KqGws1Ui; arc=fail smtp.client-ip=52.101.72.92
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=ginzinger.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ginzinger.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ginzinger.com header.i=@ginzinger.com header.b="KqGws1Ui"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=e4lY+QTjd1esHAalS0RadRtzmJx2LfuVsPLrWLKPfX20ubywgSU4SLMEW6U+N8JlZxPhlqf1PlP9vLDhBhJ++zROMeBSgCd3B7Y6xGQbyoznwL/DZRiWrLgLoPhgaFJCophiOLk24bXNeKPkpTLKCNFPthqIwOTMiB2ETgovc1sAzjFfBUJE9ECr2Kqu2joClaej33lw+RKB2KVJvDTMC+WE3Tm6WEvw+Rj7xIF1WqW0121iUGNAuIbhv3+2Q9eJKssO0aT+/XtAOZSNTNv55LI5CbtjkUdeLVGx2w3oACyu0PzH/IrNRM3nlLjFcS3EM3d5fHikGinEyqld2MPrLw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SJR0ImkRuxOwjMjHz9ybNvQT+vJUmgi6d8U4vIl49DU=;
 b=rmCnH4eHef06SlfPklZLesmt8FrJeXoEizpSAfH64QfLyztTU72MdStVgqLqf0GFJO4NBnk8bUbOCXYnj+OfveQp2kWawrnO7DyyMrdduFOKQ5bf8OS1xwEVhuL2xLiq+S8avSuW6Kw0JVIEm7T7xGywJo5PJUVz91yjPuB3DbFK5RqxNDVSPnbOh2SnTEfCjs3zdrRbTreURrzeV1X+X/MQGx8ie39RoJapPrpMv521lQbTuZSliHPHdllfVXUXlBTE/yuzVPkzYXMrNt50MxRPfAY/jCJcSJgHr/gU7UuVs42ItpfFJBQD4Kke16qkp2AfI2zY5l0Y7yLe4XuMpw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 20.93.157.195) smtp.rcpttodomain=canonical.com smtp.mailfrom=ginzinger.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=ginzinger.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ginzinger.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SJR0ImkRuxOwjMjHz9ybNvQT+vJUmgi6d8U4vIl49DU=;
 b=KqGws1UiTkloN2QbjP5dfbWiIhO7zCvgLZLRVjeL3xQ0r5aWwWvzloxbBaLh0WTSIPmKgOisBNqK1hDkglU+Dj+aAZ6AuDq/733YMUu5LVuT5+0oq2z74buafUfcERZaXBXti0ZezT/0P0kwOeXheR2GB1Ns+YIYyiUBZGt8Idaj7AlMxcrRo1YCxE0QNJeh35V3VsZ/qjTBMAavrV9IdxF8NKWi/3J0AJmnl/cYu9Kv0E7+NOdleyvgNn8uDkIBpd+dHNFa55rjzLnKmvItqA5MsrX5n81NTkJvA5LG/ENpreOCIU+Rnsjp8AgKTj2WiE7a3IwopZZEXJkDW/P2Ew==
Received: from OL1P279CA0058.NORP279.PROD.OUTLOOK.COM (2603:10a6:e10:15::9) by
 DB9PR06MB8107.eurprd06.prod.outlook.com (2603:10a6:10:29a::15) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.451.24; Tue, 29 Sep 2026 13:53:27 +0000
Received: from WA1PEPF00009B3B.eurprd05.prod.outlook.com
 (2603:10a6:e10:15:cafe::77) by OL1P279CA0058.outlook.office365.com
 (2603:10a6:e10:15::9) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.451.24 via Frontend Transport; Tue,
 29 Sep 2026 13:53:27 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 20.93.157.195) smtp.mailfrom=ginzinger.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=ginzinger.com;
Received-SPF: Pass (protection.outlook.com: domain of ginzinger.com designates
 20.93.157.195 as permitted sender) receiver=protection.outlook.com;
 client-ip=20.93.157.195; helo=westeu11-emailsignatures-cloud.codetwo.com;
 pr=C
Received: from westeu11-emailsignatures-cloud.codetwo.com (20.93.157.195) by
 WA1PEPF00009B3B.mail.protection.outlook.com (10.167.242.41) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.472.14 via Frontend Transport; Tue, 29 Sep 2026 13:53:26 +0000
Received: from DB3PR08CU002.outbound.protection.outlook.com (40.93.64.86) by westeu11-emailsignatures-cloud.codetwo.com with CodeTwo SMTP Server (TLS12) via SMTP; Tue, 29 Sep 2026 13:53:26 +0000
Received: from VI1PR06MB5549.eurprd06.prod.outlook.com (2603:10a6:803:d6::26)
 by DUZPR06MB9035.eurprd06.prod.outlook.com (2603:10a6:10:4de::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.451.21; Tue, 29 Sep
 2026 13:53:23 +0000
Received: from VI1PR06MB5549.eurprd06.prod.outlook.com
 ([fe80::2c95:365d:522:dd25]) by VI1PR06MB5549.eurprd06.prod.outlook.com
 ([fe80::2c95:365d:522:dd25%5]) with mapi id 15.21.0451.022; Tue, 29 Sep 2026
 13:53:21 +0000
From: Kepplinger-Novakovic Martin <Martin.Kepplinger-Novakovic@ginzinger.com>
To: Changwei Zou <changwei.zou@canonical.com>, "lukas@wunner.de"
	<lukas@wunner.de>
CC: "davem@davemloft.net" <davem@davemloft.net>, "herbert@gondor.apana.org.au"
	<herbert@gondor.apana.org.au>, "ignat@linux.win" <ignat@linux.win>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"martink@posteo.de" <martink@posteo.de>
Subject: Re: [PATCH v5] crypto: rsassa-pkcs1 - Avoid cacheline sharing with
 underlying driver
Thread-Index: AQHdIJaUcVPHdsV6CkekRFD27ej6g7bl8pgA
Date: Tue, 29 Sep 2026 13:53:20 +0000
Message-ID: <e7b2e28eccfeb8c8dee87e9a8d782ccbd7d7da3d.camel@ginzinger.com>
References: <20260731024446.786329-1-changwei.zou@canonical.com>
In-Reply-To: <20260731024446.786329-1-changwei.zou@canonical.com>
Accept-Language: de-DE, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
Authentication-Results-Original: mx.microsoft.com 1; dkim=none (message not
 signed) header.d=none;dmarc=none action=none header.from=ginzinger.com;
x-ms-traffictypediagnostic:
	VI1PR06MB5549:EE_|DUZPR06MB9035:EE_|WA1PEPF00009B3B:EE_|DB9PR06MB8107:EE_
X-MS-Office365-Filtering-Correlation-Id: 75226b8f-3f81-4242-25a0-08df1e310983
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|23010399003|366016|1800799024|376014|18002099003|22082099003|38070700021|3023799007|6133799003|10067099003|56012099006|11063799006;
X-Microsoft-Antispam-Message-Info-Original:
 kzEr1dbR787jMqD8VFKp9RotL5RcF8gAzuPvFmns8KfoJjalNGNdFq4eUoBnwOfAiUt9gko6NArUOIFEBEssK4hgEeDC8X1iN+Cb1HPo2QwDIjRjCsBc+ij8ZwPRAQZGqmerEvCe4VtrBhOyI6uXH/nbFNogm3YoQGm82LrVYmMQyCjvMDHkesXD9uxa8ckZUksilWPXWhVod11rKzMnQ2duGI6+rZG0/4eVa14v1/mFBJ1hDr4aiNATaGcCPDsXdBmm0vPZixE9L0NOVfYfnk4o6Ujo8R+YlCY+oqZa49kAT6ZxicwELREBOj1fjYWWsvWhz9VEcX0tnts7vrbErTgT/tHfJW+gLfh/YfKUXeBWl+e0atem/j8GjTqMib1uili7onaIy2O3pJ9sg7j/PVOuaB28LJeBmhgJZABfmZIT5yQZE8IcmK7cVG3kf9hZXmMtHnHJFCN37Rr5102dvJlA9Z0ckCIidEDZeKpe95e6Oap5zdqy6qmNk9WR2DWX+QfSF6c/5jjbFpCU8EDde7fTtxepvR6/ZkRN+E9whlxO5VpR9JCOT/0WFlZTXek7atWo1/caLs/rt6VuDcMnIotkUd+Pjhgf6JV/q14zQDyVIHWGd8QvziHwAqSbGUEjV/dgwGY0fIulnUs95LYlrsh63PXjdcbOYt2O4eoOYdA=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR06MB5549.eurprd06.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(366016)(1800799024)(376014)(18002099003)(22082099003)(38070700021)(3023799007)(6133799003)(10067099003)(56012099006)(11063799006);DIR:OUT;SFP:1102;
Content-Type: text/plain; charset="utf-8"
Content-ID: <1BC4203CAEA2CE4DA6465F48ED9C4C3B@eurprd06.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked: JZi+vZmt+7WfPKk/dggOUsMV9h6hWeLRx2eSINAlTaTLM+vC97toA+06vc5rjCqTGG7sQgAz3iAKHVVZ5ZDkCSVJuJnmiTbn6jKlCjm4ngmaI2OftGnwdrc4vM9i3R233zMy4HMDYjCy/ACMVXQhT+5ZPzVQ8HgTi0tv7ZmJX+NDR7FxJBjOvSi8T4OTehgkCItZKbM/lmkhQcdgZ/sq/yeKwB023Ybo+Npme6SrEUJyfcK3X+Av7IiB7Lhtjep11LUIxbfVkbwrfzUKKP39s8IGRr+tIffc5W29whqsaCz2ZSv6FD24ZxBVjydGa2oxqni7B/Mbb+uP0fQ+dztE9w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DUZPR06MB9035
X-CodeTwo-MessageID: a496631e-6b65-4f16-89d5-36cf206054ce.20260929135326@westeu11-emailsignatures-cloud.codetwo.com
X-CodeTwoProcessed: true
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 WA1PEPF00009B3B.eurprd05.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	1ea40c63-e360-4648-c31e-08df1e3105d8
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|35042699022|23010399003|1800799024|376014|14060799003|36860700016|82310400026|6133799003|3023799007|10067099003|11063799006|56012099006|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	/SFQeb8IpT9WM3xKNE9RYmbdXK3TwR4E0Tc3NML8OqNq6hwIqYD2RqUlDv26EL911P39H8A+YiZxIHNuzUPowOZSaTcsrJZ43Zh3uBY2EcatQHmUDJ0G8hPOqbwSj4aHuv43Uqj777U+ai6VJ4MsNI8X3HeL1mNqKdRWwNRWQWVWoa/YlAprB8WGIhTTbGQKy27qaUSlGnm77MjX7Hx/G47ZNOIpiggmlXFlr9wVm+I0VHIm2dZ7cm5U9q4ypYslaReDjjDLv724TVvUC1DXftNOY7gPutNu0FmJefTjt+2XLyH3jEUSh8fG7p/jKOzz09ho6qMBeSmZOSnOk8K3fJVQOQ+CavMYSSTG0xmhfQzADMpYw9igjgrl+192QxwLJrtheqzEWkfG2z8rjYfvTlz+iDDPHAgebMu9B5pnZYEBTYQdrUzE47H+r0BnygcooaGZCdkafQU3k1ADkmvM5weRyGrqKYa3b8HJ23wSdapD07h9RxjvAn8dZJEwneBMQjq6Ylbrivel2D38DXOx60uB6nWamlq8nILRAm1VpKyW220UIL7ljafSb2UYVJuKeHpBdNqQro/8+24At7KoqXVrEgqppdjJEJ1MAk8fmKu9IR5qL+uRmmnv0mXIJ4ipjzpthGCUSDf6n+QNuG/gumoREMDZiHg0bjGzR+LU9uQ=
X-Forefront-Antispam-Report:
	CIP:20.93.157.195;CTRY:NL;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:westeu11-emailsignatures-cloud.codetwo.com;PTR:westeu11-emailsignatures-cloud.codetwo.com;CAT:NONE;SFS:(13230040)(35042699022)(23010399003)(1800799024)(376014)(14060799003)(36860700016)(82310400026)(6133799003)(3023799007)(10067099003)(11063799006)(56012099006)(18002099003)(22082099003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	J1Jt1s4mk6u6enhLbrOhgsF0IEDpaFQ0DhizUpx6ST7WYaZVbGMvxoW5AMDsJR+CoXoFOYWo+gR6P5jLfDf1lCXGuUHKuZSu1nr609P+IUrqbsAYQXjNHUb3nSVWWnS1a7qqetoGxWOFTp9doGxxlpmvTbX50NFfut4mwx/LIeAgAj1X886VBu9qiQHh3wfC0P9x+nEzgSgkyeAnYhOTuPuUxtsmgEboCgq/YbAJ6sahIdj/LqWQ5ALELIYl+WeG3HH9iXgCksr/u4yNkSWkWyyTduFkJfIzV3TBxD48xJ4ySEqZMDX8QSC5hlHD2elrJbvd4uzCyUPWuXy5g9mmI1I28JtcrfGb4nHzFskodCYlF+38XVX1tPDGPiaQZojNBOylLo5vaulcA1xAJrc7LGe0QTas9XXyANweCLrMvbbtZ9xXqMpQ4Br2aiId5Ne/
X-OriginatorOrg: ginzinger.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Sep 2026 13:53:26.9454
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 75226b8f-3f81-4242-25a0-08df1e310983
X-MS-Exchange-CrossTenant-Id: 198354b3-f56d-4ad5-b1e4-7eb8b115ed44
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=198354b3-f56d-4ad5-b1e4-7eb8b115ed44;Ip=[20.93.157.195];Helo=[westeu11-emailsignatures-cloud.codetwo.com]
X-MS-Exchange-CrossTenant-AuthSource:
	WA1PEPF00009B3B.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB9PR06MB8107

QW0gRnJlaXRhZywgZGVtIDMxLjA3LjIwMjYgdW0gMTI6NDQgKzEwMDAgc2NocmllYiBDaGFuZ3dl
aSBab3U6Cj4gb3V0X2J1ZiBpcyB1c2VkIGFzIGEgRE1BIGJ1ZmZlciBmb3IgdGhlIFJTQSB2ZXJp
ZmljYXRpb24gb3BlcmF0aW9uLgo+IElmIGl0IGlzIG5vdCBhbGlnbmVkIHRvIENSWVBUT19ETUFf
QUxJR04sIGNhY2hlbGluZSBzaGFyaW5nCj4gcHJvYmxlbXMgKGRhdGEgY29ycnVwdGlvbikgd291
bGQgb2NjdXIgb24gQ1BVcyB3aXRoIERNQS1pbmNvaGVyZW50IGNhY2hlcywKPiBsZWFkaW5nIHRv
IC1FS0VZUkVKRUNURUQuCj4gCj4gUmVuYW1lIG91dF9idWYgdG8gYnVmLCBhcyBpdCBzZXJ2ZXMg
YXMgYm90aCB0aGUgaW5wdXQgYW5kIG91dHB1dCBidWZmZXIuCj4gQWRkIGEgYnVmX3B0ciBwb2lu
dGVyIHRvIHRyYWNrIGl0cyBwb3NpdGlvbi4KPiAKPiBBbGxvY2F0ZSB0aGUgYnVmZmVyIHNlcGFy
YXRlbHkgdmlhIGttYWxsb2MoKSwgd2hpY2ggZ3VhcmFudGVlcyBjYWNoZWxpbmUKPiBhbGlnbm1l
bnQgb24gYXJjaGl0ZWN0dXJlcyB3aXRob3V0IGZ1bGx5IGNvaGVyZW50IERNQS4KPiBUaGlzIGFj
dHMgYXMgYSBkZWZlbnNpdmUgbWVhc3VyZSwgYW5kIGF2b2lkcyB0aGUgbmVlZCBmb3IgYW4gZXh0
cmEgY29weQo+IGluIHRoZSB1bmRlcmx5aW5nIGRyaXZlciwgd2hpY2ggc2hvdWxkIGNoZWNrIGFs
aWdubWVudCBiZWZvcmUgc3VwcGx5aW5nCj4gYnVmZmVycyB0byB0aGUgaGFyZHdhcmUuCj4gCj4g
VGhlIGludGVybWl0dGVudCBlcnJvciAnS2V5IHdhcyByZWplY3RlZCBieSBzZXJ2aWNlJyBvbiBp
Lk1YOCB3aXRoIENBQU0KPiBjYW4gYmUgdHJpZ2dlcmVkIHdoZW4gbG9hZGluZyBzaWduZWQga2Vy
bmVsIG1vZHVsZXMuCj4gCj4gwqDCoMKgIGZvciBpIGluICQoc2VxIDEgMTAwKTsgZG8KPiDCoMKg
wqDCoMKgwqDCoCBzdWRvIG1vZHByb2JlIHhmcyAyPiYxICYmIGVjaG8gIlNVQ0NFU1Mgb24gYXR0
ZW1wdCAkaSIgXAo+IMKgwqDCoMKgwqDCoMKgICYmIHN1ZG8gcm1tb2QgeGZzIHx8IGVjaG8gIkZB
SUxFRCBvbiBhdHRlbXB0ICRpIgo+IMKgwqDCoCBkb25lCj4gCj4gU2lnbmVkLW9mZi1ieTogQ2hh
bmd3ZWkgWm91IDxjaGFuZ3dlaS56b3VAY2Fub25pY2FsLmNvbT4KPiAtLS0KPiDCoGNyeXB0by9y
c2Fzc2EtcGtjczEuYyB8IDMxICsrKysrKysrKysrKysrKystLS0tLS0tLS0tLS0tLS0KPiDCoDEg
ZmlsZSBjaGFuZ2VkLCAxNiBpbnNlcnRpb25zKCspLCAxNSBkZWxldGlvbnMoLSkKPiAKPiBkaWZm
IC0tZ2l0IGEvY3J5cHRvL3JzYXNzYS1wa2NzMS5jIGIvY3J5cHRvL3JzYXNzYS1wa2NzMS5jCj4g
aW5kZXggOTRmYTVlOTYwMGU3Li5iMWZiNTExMWI2YWYgMTAwNjQ0Cj4gLS0tIGEvY3J5cHRvL3Jz
YXNzYS1wa2NzMS5jCj4gKysrIGIvY3J5cHRvL3JzYXNzYS1wa2NzMS5jCj4gQEAgLTIyMywxMSAr
MjIzLDEyIEBAIHN0YXRpYyBpbnQgcnNhc3NhX3BrY3MxX3ZlcmlmeShzdHJ1Y3QgY3J5cHRvX3Np
ZyAqdGZtLAo+IMKgCXN0cnVjdCByc2Fzc2FfcGtjczFfY3R4ICpjdHggPSBjcnlwdG9fc2lnX2N0
eCh0Zm0pOwo+IMKgCXVuc2lnbmVkIGludCBjaGlsZF9yZXFzaXplID0gY3J5cHRvX2FrY2lwaGVy
X3JlcXNpemUoY3R4LT5jaGlsZCk7Cj4gwqAJc3RydWN0IGFrY2lwaGVyX3JlcXVlc3QgKmNoaWxk
X3JlcSBfX2ZyZWUoa2ZyZWVfc2Vuc2l0aXZlKSA9IE5VTEw7Cj4gKwl1OCAqYnVmIF9fZnJlZShr
ZnJlZV9zZW5zaXRpdmUpID0gTlVMTDsKPiDCoAlzdHJ1Y3QgY3J5cHRvX3dhaXQgY3dhaXQ7Cj4g
wqAJc3RydWN0IHNjYXR0ZXJsaXN0IHNnOwo+IMKgCXVuc2lnbmVkIGludCBkc3RfbGVuOwo+IMKg
CXVuc2lnbmVkIGludCBwb3M7Cj4gLQl1OCAqb3V0X2J1ZjsKPiArCXU4ICpidWZfcHRyOwo+IMKg
CWludCBlcnI7Cj4gwqAKPiDCoAkvKiBSRkMgODAxNyBzZWMgOC4yLjIgc3RlcCAxIC0gbGVuZ3Ro
IGNoZWNraW5nICovCj4gQEAgLTIzNywxNiArMjM4LDE2IEBAIHN0YXRpYyBpbnQgcnNhc3NhX3Br
Y3MxX3ZlcmlmeShzdHJ1Y3QgY3J5cHRvX3NpZyAqdGZtLAo+IMKgCQlyZXR1cm4gLUVJTlZBTDsK
PiDCoAo+IMKgCS8qIFJGQyA4MDE3IHNlYyA4LjIuMiBzdGVwIDIgLSBSU0EgdmVyaWZpY2F0aW9u
ICovCj4gLQljaGlsZF9yZXEgPSBrbWFsbG9jKHNpemVvZigqY2hpbGRfcmVxKSArIGNoaWxkX3Jl
cXNpemUgKyBjdHgtPmtleV9zaXplLAo+IC0JCQnCoMKgwqAgR0ZQX0tFUk5FTCk7Cj4gLQlpZiAo
IWNoaWxkX3JlcSkKPiArCWNoaWxkX3JlcSA9IGttYWxsb2Moc2l6ZW9mKCpjaGlsZF9yZXEpICsg
Y2hpbGRfcmVxc2l6ZSwgR0ZQX0tFUk5FTCk7Cj4gKwlidWYgPSBrbWFsbG9jKGN0eC0+a2V5X3Np
emUsIEdGUF9LRVJORUwpOwo+ICsJaWYgKCFjaGlsZF9yZXEgfHwgIWJ1ZikKPiDCoAkJcmV0dXJu
IC1FTk9NRU07Cj4gwqAKPiAtCW91dF9idWYgPSAodTggKikoY2hpbGRfcmVxICsgMSkgKyBjaGls
ZF9yZXFzaXplOwo+IC0JbWVtY3B5KG91dF9idWYsIHNyYywgc2xlbik7Cj4gKwlidWZfcHRyID0g
YnVmOwo+ICsJbWVtY3B5KGJ1Zl9wdHIsIHNyYywgc2xlbik7Cj4gwqAKPiDCoAljcnlwdG9faW5p
dF93YWl0KCZjd2FpdCk7Cj4gLQlzZ19pbml0X29uZSgmc2csIG91dF9idWYsIHNsZW4pOwo+ICsJ
c2dfaW5pdF9vbmUoJnNnLCBidWZfcHRyLCBzbGVuKTsKPiDCoAlha2NpcGhlcl9yZXF1ZXN0X3Nl
dF90Zm0oY2hpbGRfcmVxLCBjdHgtPmNoaWxkKTsKPiDCoAlha2NpcGhlcl9yZXF1ZXN0X3NldF9j
cnlwdChjaGlsZF9yZXEsICZzZywgJnNnLCBzbGVuLCBzbGVuKTsKPiDCoAlha2NpcGhlcl9yZXF1
ZXN0X3NldF9jYWxsYmFjayhjaGlsZF9yZXEsIENSWVBUT19URk1fUkVRX01BWV9TTEVFUCwKPiBA
QCAtMjYzLDM1ICsyNjQsMzUgQEAgc3RhdGljIGludCByc2Fzc2FfcGtjczFfdmVyaWZ5KHN0cnVj
dCBjcnlwdG9fc2lnICp0Zm0sCj4gwqAJCXJldHVybiAtRUlOVkFMOwo+IMKgCj4gwqAJaWYgKGRz
dF9sZW4gPT0gY3R4LT5rZXlfc2l6ZSkgewo+IC0JCWlmIChvdXRfYnVmWzBdICE9IDB4MDApCj4g
KwkJaWYgKGJ1Zl9wdHJbMF0gIT0gMHgwMCkKPiDCoAkJCS8qIEVuY3J5cHRlZCB2YWx1ZSBoYWQg
bm8gbGVhZGluZyAwIGJ5dGUgKi8KPiDCoAkJCXJldHVybiAtRUlOVkFMOwo+IMKgCj4gwqAJCWRz
dF9sZW4tLTsKPiAtCQlvdXRfYnVmKys7Cj4gKwkJYnVmX3B0cisrOwo+IMKgCX0KPiDCoAo+IC0J
aWYgKG91dF9idWZbMF0gIT0gMHgwMSkKPiArCWlmIChidWZfcHRyWzBdICE9IDB4MDEpCj4gwqAJ
CXJldHVybiAtRUJBRE1TRzsKPiDCoAo+IMKgCWZvciAocG9zID0gMTsgcG9zIDwgZHN0X2xlbjsg
cG9zKyspCj4gLQkJaWYgKG91dF9idWZbcG9zXSAhPSAweGZmKQo+ICsJCWlmIChidWZfcHRyW3Bv
c10gIT0gMHhmZikKPiDCoAkJCWJyZWFrOwo+IMKgCj4gLQlpZiAocG9zIDwgOSB8fCBwb3MgPT0g
ZHN0X2xlbiB8fCBvdXRfYnVmW3Bvc10gIT0gMHgwMCkKPiArCWlmIChwb3MgPCA5IHx8IHBvcyA9
PSBkc3RfbGVuIHx8IGJ1Zl9wdHJbcG9zXSAhPSAweDAwKQo+IMKgCQlyZXR1cm4gLUVCQURNU0c7
Cj4gwqAJcG9zKys7Cj4gwqAKPiDCoAlpZiAoaGFzaF9wcmVmaXgtPnNpemUgPiBkc3RfbGVuIC0g
cG9zKQo+IMKgCQlyZXR1cm4gLUVCQURNU0c7Cj4gLQlpZiAoY3J5cHRvX21lbW5lcShvdXRfYnVm
ICsgcG9zLCBoYXNoX3ByZWZpeC0+ZGF0YSwgaGFzaF9wcmVmaXgtPnNpemUpKQo+ICsJaWYgKGNy
eXB0b19tZW1uZXEoYnVmX3B0ciArIHBvcywgaGFzaF9wcmVmaXgtPmRhdGEsIGhhc2hfcHJlZml4
LT5zaXplKSkKPiDCoAkJcmV0dXJuIC1FQkFETVNHOwo+IMKgCXBvcyArPSBoYXNoX3ByZWZpeC0+
c2l6ZTsKPiDCoAo+IC0JLyogUkZDIDgwMTcgc2VjIDguMi4yIHN0ZXAgNCAtIGNvbXBhcmlzb24g
b2YgZGlnZXN0IHdpdGggb3V0X2J1ZiAqLwo+ICsJLyogUkZDIDgwMTcgc2VjIDguMi4yIHN0ZXAg
NCAtIGNvbXBhcmlzb24gb2YgZGlnZXN0IHdpdGggYnVmICovCj4gwqAJaWYgKGRsZW4gIT0gZHN0
X2xlbiAtIHBvcykKPiDCoAkJcmV0dXJuIC1FS0VZUkVKRUNURUQ7Cj4gLQlpZiAobWVtY21wKGRp
Z2VzdCwgb3V0X2J1ZiArIHBvcywgZGxlbikgIT0gMCkKPiArCWlmIChtZW1jbXAoZGlnZXN0LCBi
dWZfcHRyICsgcG9zLCBkbGVuKSAhPSAwKQo+IMKgCQlyZXR1cm4gLUVLRVlSRUpFQ1RFRDsKPiDC
oAo+IMKgCXJldHVybiAwOwoKCkhpIENoYW5nd2VpLAoKVmVyeSBsYXRlLCBzb3JyeSwgYW5kIG1h
eWJlIHRoaXMgcGF0Y2ggaXMgaXJyZWxldmFudCg/KSBidXQgSSB0ZXN0ZWQgaXQgbm93LiB2ZXJp
dHlzZXR1cCgpIHN1Y2NlZWRzIGp1c3QKbGlrZSB3aGVuIHVzaW5nIHlvdXIgZHJpdmVyLWxldmVs
IHBhdGNoIEkgdGVzdGVkIGVhcmxpZXIgdG9kYXk6Cmh0dHBzOi8vbG9yZS5rZXJuZWwub3JnL2xp
bnV4LWNyeXB0by8yMDI2MDgyMTA0NTU1NS44MDY0NzEtMS1jaGFuZ3dlaS56b3VAY2Fub25pY2Fs
LmNvbS9ULyN0CgpJIHNob3VsZCBoYXZlIGFkZGVkIHRoZSBmb2xsb3dpbmcgdGFncyB0byB0aGUg
YWJvdmUgZW1haWwgYXMgd2VsbDoKClJlcG9ydGVkLWJ5OiBNYXJ0aW4gS2VwcGxpbmdlci1Ob3Zh
a292acSHIDxNYXJ0aW4uS2VwcGxpbmdlci1Ob3Zha292aWNAZ2luemluZ2VyLmNvbT4KQ2xvc2Vz
OiBodHRwczovL2xvcmUua2VybmVsLm9yZy9yLzYwMjlhY2MwZjBkZGZlMjVlMjUzN2MyODY2ZDU0
ZmQ3ZjU0YmMxODIuY2FtZWxAZ2luemluZ2VyLmNvbQoKSSBob3BlIHlvdSBjYW4gY29tZSB0byBh
IGNvbmNsdXNpb24gb24gdGhpcyEKCnRoYW5rcyBmb3Igd29ya2luZyBvbiB0aGlzLAoKICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgbWFydGluCg==
