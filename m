Received: from DUZPR83CU001.outbound.protection.outlook.com (mail-northeuropeazon11012048.outbound.protection.outlook.com [52.101.66.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD3E638838F;
	Wed, 30 Sep 2026 07:21:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.66.48
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790752920; cv=fail; b=NQ1zPhdw1M7ibLbivuRsRebdxKc4az7g2SUCIFFr7mJXZ3huUUgARDvNdH9m3CXzuSUNGv+Z0bq5IVmArwEXmI5Y3FsMYUafItJpHy6ZjBDzWlyQCLhRcLEWwqmQlSFJOjZNqiXziiAvR0E2f68jYcjkT9PxytXhjYAjWuHHHuk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790752920; c=relaxed/simple;
	bh=mElaAs59ZKEZY41BMQdBZ+LRnosCr36wOqMutDuVSWA=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=Ib+PpWJIR8FK8GSKgxehClV2Ds4C6oS0nRPUrjm3rMu8iIK+h1bq6jwrnVeBn56D4PEEhib0TLVAWhdb3WlRXdfwQg6B4aC7vY9dEgqW2+Iw3OhzcUOS7p9zXN/eJcRFuLsdCUXnw7jjZUTmaLvnByCPTz/iOj8IPeLPuVROzBM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.nxp.com; spf=pass smtp.mailfrom=oss.nxp.com; dkim=pass (2048-bit key) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.b=HHZ/IFwb; arc=fail smtp.client-ip=52.101.66.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.b="HHZ/IFwb"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=UxE3b4HnuQMZhCpGqsnQF5n2vImxo6fDCwIz0JtKNiVtm4fYwRVRT6mtjqttdCmM/UoPJhX3X2Poh5wyJdClkmP5k+QJl1uilzFDS0wqvvdGV1N0A4DWFSNEms8dcl0RsphWwjo8xBYWNbj6PQmNUF5D0x+10kHWBnDWuEATqZLUm7q2EX2CY2A7DzDO2HB5mEa9IzGB7X826NzNobd0BauaQV4Sv54oK/4J5VNjvWwd3u5eGRXYCdISkvKIG2+b9Ty9paQqx4lHhHvZ0ZDJihYZMMBavBJgyMUnnMOzh86U9978hFG6m+VBEL392W3N5gmincONBU5X7tx6cSRkAw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mElaAs59ZKEZY41BMQdBZ+LRnosCr36wOqMutDuVSWA=;
 b=mP8yAq8wtR7M5sHRUWA8xuHUk7OzhGdI74FBsDsPh0peZtinikl87vY0ckQs1eI7mswV9anJFIdOhJc0/BciFS3zODLwBkxp8doiTXEQlegKbgh/m+EwOsZbrcGPSETKNXviKIpdue2TAwrP1PekkBZeff9DIWVEkt6lW4ovufumE9neqhHKdyvJN7jn4rGGJ+p4jjpqb+2ldDGtZu/Ggl7ezfNnckKp75UIhCAiZ224gZVsDgo4mOoAhnA97ZgEuPmYo8BeRJapKq9qew/kd6wgnYMwr6Wr0wRXmSvTA1zs9fmsOw9w5hZwpHKWPuPFTLo0UIiMGRaoYHNN2mXyKA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector1-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mElaAs59ZKEZY41BMQdBZ+LRnosCr36wOqMutDuVSWA=;
 b=HHZ/IFwblETG+O9kos7p/yDAsDV3gVEu7kHPLWsV6l36nDwq9xyen8XKpyZZS8SLfwv7RJ2Ok1BKny79c41Rqyon79zqysIf0/3CtFDGtmLKIATcYZXc0Wj+YZ1zyy3Xa7zFMCbTf6PfmJ0+XE/o3d2pao6m2AkvNSdxkXXEJHJ4NZt1z46EASksCqoh0FCGwdSpqW7tz1LUVmhoUU8uF/gYW7lVDEZc5PkkZUnEigmBFesHyfOYRTDBdA+I15TaIb9YsaX1a06Mnp//BsFofZEDhIl+S/yqbVNPU3Y4nk7tIlY+N6ckd0hkCsjHMvzUxBzcFZTArKvy1zqxnPQsjQ==
Received: from DB9PR04MB8139.eurprd04.prod.outlook.com (2603:10a6:10:248::17)
 by DB9PR04MB9306.eurprd04.prod.outlook.com (2603:10a6:10:36e::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.451.25; Wed, 30 Sep
 2026 07:21:54 +0000
Received: from DB9PR04MB8139.eurprd04.prod.outlook.com
 ([fe80::97c8:7d82:e34b:3d43]) by DB9PR04MB8139.eurprd04.prod.outlook.com
 ([fe80::97c8:7d82:e34b:3d43%5]) with mapi id 15.21.0451.022; Wed, 30 Sep 2026
 07:21:53 +0000
From: "Sahil Malhotra (OSS)" <sahil.malhotra@oss.nxp.com>
To: "vjardin@free.fr" <vjardin@free.fr>, Horia Geanta <horia.geanta@nxp.com>,
	Pankaj Gupta <pankaj.gupta@nxp.com>, Herbert Xu
	<herbert@gondor.apana.org.au>, "David S. Miller" <davem@davemloft.net>,
	Gaurav Jain <gaurav.jain@nxp.com>
CC: Eric Biggers <ebiggers@kernel.org>, "linux-crypto@vger.kernel.org"
	<linux-crypto@vger.kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>
Subject: RE: [EXT] [PATCH v2] crypto: caam/qi2 - lower the algorithm priority
Thread-Topic: [EXT] [PATCH v2] crypto: caam/qi2 - lower the algorithm priority
Thread-Index: AQHdUFEyqpVyUPmPFEismuIaSWStHbbmtr0w
Date: Wed, 30 Sep 2026 07:21:52 +0000
Message-ID:
 <DB9PR04MB8139034E6D0186A687183208828B2@DB9PR04MB8139.eurprd04.prod.outlook.com>
References:
 <20260929-for-upstream-caam-qi2-priority-v2-1-bf0559ebf574@free.fr>
In-Reply-To:
 <20260929-for-upstream-caam-qi2-priority-v2-1-bf0559ebf574@free.fr>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
msip_labels:
 MSIP_Label_0d9c909a-577b-4ba2-96de-69ada94b137a_Enabled=True;MSIP_Label_0d9c909a-577b-4ba2-96de-69ada94b137a_SiteId=686ea1d3-bc2b-4c6f-a92c-d99c5c301635;MSIP_Label_0d9c909a-577b-4ba2-96de-69ada94b137a_SetDate=2026-09-30T07:17:01.0000000Z;MSIP_Label_0d9c909a-577b-4ba2-96de-69ada94b137a_Name=NXP
 Confidential;MSIP_Label_0d9c909a-577b-4ba2-96de-69ada94b137a_ContentBits=3;MSIP_Label_0d9c909a-577b-4ba2-96de-69ada94b137a_Method=Standard
authentication-results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oss.nxp.com;
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DB9PR04MB8139:EE_|DB9PR04MB9306:EE_
x-ms-office365-filtering-correlation-id: 30a0a4e1-e947-47f2-2146-08df1ec3802f
x-ms-exchange-sharedmailbox-routingagent-processed: True
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|376014|366016|23010399003|19092799006|1800799024|10067099003|4133799003|56012099006|11063799006|260925021911599003|260925022911599003|260925021311599003|6133799003|13003099007|22082099003|18002099003|38070700021|41080700001|15866825006;
x-microsoft-antispam-message-info:
 tVDMhAwI0xc2E/6D9Bk+xiFbBajtRGlnMXQtNHY8dt+RjJo2zY8UhJY7LVxJk3bznYWpSqVgV3mf973rumtueIi8Fba8JsWKmdXoK12NiIIdmpmJAE3qhjltPXsWSd/UsMqw/t4FVc8AEUV77ETMrbC3Cv0nvIJbcEbunhBFOoFtrOWwTMrTpz7qwd4gcYqEw7ouhnvwgnw1Z8XRUwl/qsbTzfXAOgp5XVboOC9US0Y7ir22hUR6ncY/NDDuKpra+PqWIEea7r3nf/g9S4FMUq5A055KV4fwjiBEGY0v+fuw/eDgkX1X/mT0FC/ca5luzZGIaldcgICOtdQ3dA9jnjVJyZRd2uXDAZN4YccC4kQcVoARHz/MTK+7C6JDr0HXpXCsHO9PJ5xWDJ7HSA0IOE+k7NxghzGV/BJL0Bp9MCfxuz1gTS3yOO9Px3XC++22K8ql86YTzNX/0+CvvtVLTmcFC45EgHQjwp64QGDnKS9egvP8mU57BsPXQPTSHE7Bb0iwxrkKHnWolrof8PwYF8cbQ5Vc5haC/i2/MKvewtRtmwB/pxtscD/9K1Xh8MJVf4fGrJHLXL51xY3841N23J65dNadZVccvS96t2VAgNr5gvBDWsBhtHTmXfdiZA0ZLvoCFkTcIZ6L4YuZ8Gs9amQqq+i1J5AzKOqgT9HpZw3YHWnYSE5TA+OJPvOB9OcUjH81jQxAYR5TeIJe7NczPLvIyWg0irHX3GxAvUbJ5As=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB9PR04MB8139.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(23010399003)(19092799006)(1800799024)(10067099003)(4133799003)(56012099006)(11063799006)(260925021911599003)(260925022911599003)(260925021311599003)(6133799003)(13003099007)(22082099003)(18002099003)(38070700021)(41080700001)(15866825006);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?YU4rUGdDeFg3ZE9ZSXdPN2RIYkE2dlQ1ZlJKdmdtVU9iNHNCWm1NaHl0QU1O?=
 =?utf-8?B?a21wUWZZWkNvdGJ0bHdnN1poeTlWcU1hK0RLOXpPRFpBb1VVV25uQWc1Qk5m?=
 =?utf-8?B?L2RlK0Fsem85dkQ2eVJub1dsSHBObkdwWkpDenkwc0lEejlkYzRORlArbFBM?=
 =?utf-8?B?b0syVElpdnVlYm5Jb2UwMFRmVTdvcU9aWk1tUU9IbXNIQm0yeW5SdUsrSW0w?=
 =?utf-8?B?SmQwMHFNako0LzVmclJwZ1NyU2x3K0ZtbzFvM0xTcHA4RDlNb2dHd1BQYkFG?=
 =?utf-8?B?ekd5TFVCeVZXRkFMRmM0bGhOKzJnZ252eTlqRXdsNXBVMXVXeG45VG9FSWdv?=
 =?utf-8?B?RWZ2WVhROC9rb083Zko1dWo2dU5VcWJuam82SjBQclNqY3ptLzk4b3dtbWth?=
 =?utf-8?B?azZMaUxaN2NkRDJCYStycXVrbko1aFdWZHJZRjFQQTZNU2NGYzZhTTdpRzVX?=
 =?utf-8?B?cnVPRXdOL1kxcnNRYXRiUFRGTG91L2J4b1BXQWM2TW1kS213VUo0OStoWkRl?=
 =?utf-8?B?cXRXWHZZbGJJbm5vR2VVR0t5TlY2cVQ0SGhBT3l4M1AzR0JqYkEyYTZhMGdY?=
 =?utf-8?B?TW16MkRCZDNxM2IzUWhUUEdWV2J1NE5Wd2xaR2g4TWdwdU0rbUlYclFxYmly?=
 =?utf-8?B?WmIxYTRVMldQa2NRRG8rVEVLUmxCMXlVSFJKdXY2cWQxMWZreTJVMDBQcDh6?=
 =?utf-8?B?M3pQYjVzL0lhYlR4NVRhZFp6Skw1VFQ0S3hqVTVveG1nd1ZpRzIyTHZpZVhD?=
 =?utf-8?B?OWEraTBUSWxMbVVmZ0RNdnZ0cHlyVkZKbFQ2UnF2NUlrY3BwdkdrRzlsRmRI?=
 =?utf-8?B?ODR3NS8rcjNGckZyL0dmN0F0MDNITXlVU1dsWlhMRW1CZFhqVEtaTFI0dnh2?=
 =?utf-8?B?aC83SHErZnoxZ0NQYTdJcm1HTXJNVVJDZmNaRk9VY3J6R1c4NHl2K21qWS9N?=
 =?utf-8?B?eXZEaW54Q0ZEa2JqWEFmdC9USW1YZ0FpK3VsQ0FCZ0ZxNU05bHZ4YlF3UkxU?=
 =?utf-8?B?clI3d29qNzYwNnBvbUFOdGZaYlI5SmNqSjNFd0QzdjNqZ0lXRjV3aG5PMlNx?=
 =?utf-8?B?cWxmNE5aVnh3TWZQUGtpUStJaGJXbFQ2bk8rQzhuMkRucHprcjRsbGN2Q3lm?=
 =?utf-8?B?ODNGVElaK1BVYjZNSEtnL2xiS1BVdHI4Z3BBeG9Cb3B0OGQydmtOSjVVRnZP?=
 =?utf-8?B?eUl6SmJnRXNTYXpZNkRGWUhMVTBTd0hWSndSWWNqSW9TYUFrbHZpODZUTnJj?=
 =?utf-8?B?REZnaW8rOFNHcVMvMzlyN2ZvdlRZb0psN2hnSDUrRkI1Y0Fqb2luWGNiZFNT?=
 =?utf-8?B?VWhYdlRVU0EvTHFzbWJqdnpMSnVJRStieUVDa2ZMV1dBUXA5aGxCWnZkL1hs?=
 =?utf-8?B?NFlRMnFpZm5iZUUzcEZGRFFyeXlYTDBCQk5oMW52M0lyRlNSeTA5YXZuWUpr?=
 =?utf-8?B?MG93ZnBna1ppUnZKUU40dEhuTFd6Z0ZsTU8yRnVSQSsrRjNXcHd2UkE3ZXF3?=
 =?utf-8?B?a1hLWEwyOTg1dFhFeklSOExDOE9ZR1JNZktqVGFqTWYyRUNuazY2MEM1MllY?=
 =?utf-8?B?YzdlOUNuTFM4WTFPVTlod3BwRzRrcFZ4bEM5Q0ppKzhZRDFWTDlyM3F4ZkVZ?=
 =?utf-8?B?V0s2V0M4UjZLOVM1TWJnRG1iSkczT0ZUaHJNUWE2d0hleTMwRXYyNlJKL1FP?=
 =?utf-8?B?KytaOXEwbUhRUFZ3ck5hSnJTdzdST2JQNlE2SGxrOHlUZVlpU0pnVmJOVDRS?=
 =?utf-8?B?VGlBTlcwK2t3aGhUQXVEdFNsNmloWU9UbUNTYlVsQitlYU5lSmZtWTFaVHI2?=
 =?utf-8?B?NHZNOGZBUWdoU0I4TUgzaG5INzZIdERLUnR2Mm1wNW8vT1VEMzkwZUxwSGxE?=
 =?utf-8?B?ZFlLUEZ2ZWt3ZHpKb0M2NDZpbldZODZnRVE1ekxtUm1WWkJWUmIvZUQ0SW5Z?=
 =?utf-8?B?eTVDRzM4Nm8xRnBhUElka3JZT2dmZE5Dd0Vpbis5MTZWZGpaRjh3SExFQysz?=
 =?utf-8?B?eU9lODlCdHFMSENINTNlT05ES1V5cDdoQnl5NnJZV3hTVGZXcmU2VnlHQ2ha?=
 =?utf-8?B?MjdNMkVVVUhibDdpN1NQc0cwcEc1Z2NyalRrcHZ0Z1ptOU5uaDVQQjk5Y1hT?=
 =?utf-8?B?SC9xNlhSZVEvNUpTS1FEUGlBR3dDdTlsdUVkQVlJSlZuckl1S3RaNkF3RTdw?=
 =?utf-8?B?cEw1SHQ2MExMZVdXZlkwSUtSMFdQQm8xS3NmZ0wxSSs5Z1R0ZHBqY3VEMnNM?=
 =?utf-8?B?YUJWRElnQ3dnSWlkSW1MWTAyMnFkTjZ6T2xqeVlvWjBENTUwNlVJdWlMVXdy?=
 =?utf-8?B?S1NyclgxaWlKRERvVDZEckhqWWV0MGpad1Q5SndEKzRiQm16dUxLZz09?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DB9PR04MB8139.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 30a0a4e1-e947-47f2-2146-08df1ec3802f
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Sep 2026 07:21:52.7895
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 6pXCdFnALMUhfkOZwSdqBcu1Y8HwKHs0rnNAHKgX2Jp/0pN8ptQI3mYGP39+PHL1qjb3APFwwAgxwE5CcJq/+A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB9PR04MB9306

SGkgVmluY2VudCwNCg0KSSdtIG5vdCBzdXJlIEkgdW5kZXJzdGFuZCB0aGUgbmVlZCBmb3IgdGhp
cyBjaGFuZ2UuDQpJcyBpdCBub3cgZXhwZWN0ZWQgdGhhdCBoYXJkd2FyZSBhY2NlbGVyYXRvcnMg
c2hvdWxkIGhhdmUgYSBsb3dlciBkZWZhdWx0IHByaW9yaXR5IHRoYW4gQVJNIENFPw0KVXNlcnMg
d2hvIHdhbnQgdG8gdXNlIEFSTSBDRSBjYW4gYWxyZWFkeSBjaG9vc2UgaXQgYXQgcnVudGltZSwg
c28gY2hhbmdpbmcgdGhlIGRlZmF1bHQgcHJpb3JpdHkgZG9lcyBub3Qgc2VlbSBuZWNlc3Nhcnkg
ZnJvbSBteSBwZXJzcGVjdGl2ZS4NCg0KUmVnYXJkcywNCiBTYWhpbCBNYWxob3RyYQ0KDQoNCk5Y
UCBDb25maWRlbnRpYWwNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogVmlu
Y2VudCBKYXJkaW4gdmlhIEI0IFJlbGF5IDxkZXZudWxsK3ZqYXJkaW4uZnJlZS5mckBrZXJuZWwu
b3JnPg0KPiBTZW50OiAzMCBTZXB0ZW1iZXIgMjAyNiAwMTo1OQ0KPiBUbzogSG9yaWEgR2VhbnRh
IDxob3JpYS5nZWFudGFAbnhwLmNvbT47IFBhbmthaiBHdXB0YQ0KPiA8cGFua2FqLmd1cHRhQG54
cC5jb20+OyBTYWhpbCBNYWxob3RyYSA8c2FoaWwubWFsaG90cmFAbnhwLmNvbT47IEhlcmJlcnQN
Cj4gWHUgPGhlcmJlcnRAZ29uZG9yLmFwYW5hLm9yZy5hdT47IERhdmlkIFMuIE1pbGxlciA8ZGF2
ZW1AZGF2ZW1sb2Z0Lm5ldD47DQo+IEdhdXJhdiBKYWluIDxnYXVyYXYuamFpbkBueHAuY29tPg0K
PiBDYzogRXJpYyBCaWdnZXJzIDxlYmlnZ2Vyc0BrZXJuZWwub3JnPjsgbGludXgtY3J5cHRvQHZn
ZXIua2VybmVsLm9yZzsgbGludXgtDQo+IGtlcm5lbEB2Z2VyLmtlcm5lbC5vcmc7IFZpbmNlbnQg
SmFyZGluIDx2amFyZGluQGZyZWUuZnI+DQo+IFN1YmplY3Q6IFtFWFRdIFtQQVRDSCB2Ml0gY3J5
cHRvOiBjYWFtL3FpMiAtIGxvd2VyIHRoZSBhbGdvcml0aG0gcHJpb3JpdHkNCj4NCj4gQ2F1dGlv
bjogVGhpcyBpcyBhbiBleHRlcm5hbCBlbWFpbC4gUGxlYXNlIHRha2UgY2FyZSB3aGVuIGNsaWNr
aW5nIGxpbmtzIG9yIG9wZW5pbmcNCj4gYXR0YWNobWVudHMuIFdoZW4gaW4gZG91YnQsIHJlcG9y
dCB0aGUgbWVzc2FnZSB1c2luZyB0aGUgJ1JlcG9ydCB0aGlzIGVtYWlsJw0KPiBidXR0b24NCj4N
Cj4NCj4gRnJvbTogVmluY2VudCBKYXJkaW4gPHZqYXJkaW5AZnJlZS5mcj4NCj4NCj4gTG93ZXIg
dGhlIHByaW9yaXR5IHRvIDEwMCwgYXMgZG9uZSBmb3IgUUFUIGluIGNvbW1pdA0KPiAgIDgwMjQ3
NzQxOTBhNSAoImNyeXB0bzogcWF0IC0gbG93ZXIgcHJpb3JpdHkgZm9yIHNrY2lwaGVyIGFuZCBh
ZWFkIGFsZ29yaXRobXMiKS4NCj4NCj4gVGhlIFNFQyBzdGF5cyByZWFjaGFibGUgYnkgZHJpdmVy
IG5hbWUsIGFuZCB1c2VyIHNwYWNlIGNhbiByYWlzZSBpdHMgcHJpb3JpdHkNCj4gdGhyb3VnaCB0
aGUgY3J5cHRvX3VzZXIgaW50ZXJmYWNlLg0KPg0KPiBTdWdnZXN0ZWQtYnk6IEhlcmJlcnQgWHUg
PGhlcmJlcnRAZ29uZG9yLmFwYW5hLm9yZy5hdT4NCj4gTGluazoNCj4gaHR0cHM6Ly9sb3JlLmtl
cm5lbC8NCj4gLm9yZyUyRnIlMkZhcnV2SkVDQ0ROZGd1TWR3JTQwZ29uZG9yLmFwYW5hLm9yZy5h
dSZkYXRhPTA1JTdDMDIlN0NzDQo+IGFoaWwubWFsaG90cmElNDBueHAuY29tJTdDMTBjNDNmMjFi
MjEzNDcxN2QxZjEwOGRmMWU2ODUyZWQlN0M2ODZlYTENCj4gZDNiYzJiNGM2ZmE5MmNkOTljNWMz
MDE2MzUlN0MwJTdDMCU3QzYzOTI2MzEwNTU1NDQzMTIwNCU3Q1Vua25vDQo+IHduJTdDVFdGcGJH
WnNiM2Q4ZXlKRmJYQjBlVTFoY0draU9uUnlkV1VzSWxZaU9pSXdMakF1TURBd01DSXNJbEFpDQo+
IE9pSlhhVzR6TWlJc0lrRk9Jam9pVFdGcGJDSXNJbGRVSWpveWZRJTNEJTNEJTdDMCU3QyU3QyU3
QyZzZGF0YT0zDQo+IHdvelVIWXB4ZEltaklCVkUlMkZ3ZldSQTBTdDFKdEpsU1lmeDNoZ1pBaE93
JTNEJnJlc2VydmVkPTANCj4gU2lnbmVkLW9mZi1ieTogVmluY2VudCBKYXJkaW4gPHZqYXJkaW5A
ZnJlZS5mcj4NCj4gLS0tDQo+IHYyIGxvd2VycyB0aGUgcHJpb3JpdHkgdG8gMTAwLCBhcyB3YXMg
ZG9uZSBmb3IgUUFULCBhbmQgbGVhdmVzIHRoZSBjaG9pY2UgdG8gdXNlcg0KPiBzcGFjZSB0aHJv
dWdoIGNyeXB0b191c2VyLg0KPiAtLS0NCj4gQ2hhbmdlcyBpbiB2MjoNCj4gLSBEcm9wIGJvdGgg
dGhlIGRwYWEyX2NhYW0ucHJpb3JpdHkgbW9kdWxlIHBhcmFtZXRlciBhbmQgdGhlDQo+ICAgZnNs
LHFpMi1jcnlwdG8tcHJpb3JpdHkgRFQgcHJvcGVydHkNCj4gLSBMb3dlciB0aGUgZGVmYXVsdCBw
cmlvcml0eSB0byAxMDAsIHVzZXIgc3BhY2UgYWRqdXN0IGl0IHdpdGgNCj4gICBjcnlwdG9fdXNl
ciAoSGVyYmVydCkuDQo+IC0gTm8gcG9saWN5IGluIHRoZSBkZXZpY2UgdHJlZSAoS3J6eXN6dG9m
LCBFcmljKS4NCj4gLSBMaW5rIHRvIHYxOg0KPiBodHRwczovL2xvcmUua2VybmVsLw0KPiAub3Jn
JTJGciUyRjIwMjYwOTI4LWZvci11cHN0cmVhbS1jYWFtLXFpMi1wcmlvcml0eS12MS0wLQ0KPiBl
NGE4ZTVmMDFkYmMlNDBmcmVlLmZyJmRhdGE9MDUlN0MwMiU3Q3NhaGlsLm1hbGhvdHJhJTQwbnhw
LmNvbSU3QzEwYw0KPiA0M2YyMWIyMTM0NzE3ZDFmMTA4ZGYxZTY4NTJlZCU3QzY4NmVhMWQzYmMy
YjRjNmZhOTJjZDk5YzVjMzAxNjM1JTcNCj4gQzAlN0MwJTdDNjM5MjYzMTA1NTU0NDYzMjU4JTdD
VW5rbm93biU3Q1RXRnBiR1pzYjNkOGV5SkZiWEIwZQ0KPiBVMWhjR2tpT25SeWRXVXNJbFlpT2lJ
d0xqQXVNREF3TUNJc0lsQWlPaUpYYVc0ek1pSXNJa0ZPSWpvaVRXRnBiQ0lzSWxkDQo+IFVJam95
ZlElM0QlM0QlN0MwJTdDJTdDJTdDJnNkYXRhPVhOT0M3VzkybEgwTmxLVmNVeUs2OU81VnJZQ2w0
DQo+IDlGNHd3cjNkVTFRNk1vJTNEJnJlc2VydmVkPTANCj4gLS0tDQo+ICBkcml2ZXJzL2NyeXB0
by9jYWFtL2NhYW1hbGdfcWkyLmMgfCAyICstDQo+ICAxIGZpbGUgY2hhbmdlZCwgMSBpbnNlcnRp
b24oKyksIDEgZGVsZXRpb24oLSkNCj4NCj4gZGlmZiAtLWdpdCBhL2RyaXZlcnMvY3J5cHRvL2Nh
YW0vY2FhbWFsZ19xaTIuYw0KPiBiL2RyaXZlcnMvY3J5cHRvL2NhYW0vY2FhbWFsZ19xaTIuYw0K
PiBpbmRleCA2YjQ3YmNjMTZhNTAuLmQzY2IyYmQ1YzQxZCAxMDA2NDQNCj4gLS0tIGEvZHJpdmVy
cy9jcnlwdG8vY2FhbS9jYWFtYWxnX3FpMi5jDQo+ICsrKyBiL2RyaXZlcnMvY3J5cHRvL2NhYW0v
Y2FhbWFsZ19xaTIuYw0KPiBAQCAtMjYsNyArMjYsNyBAQA0KPiAgI2luY2x1ZGUgPGNyeXB0by94
dHMuaD4NCj4gICNpbmNsdWRlIDxsaW51eC91bmFsaWduZWQuaD4NCj4NCj4gLSNkZWZpbmUgQ0FB
TV9DUkFfUFJJT1JJVFkgICAgICAyMDAwDQo+ICsjZGVmaW5lIENBQU1fQ1JBX1BSSU9SSVRZICAg
ICAgMTAwDQo+DQo+ICAvKiBtYXgga2V5IGlzIHN1bSBvZiBBRVNfTUFYX0tFWV9TSVpFLCBtYXgg
c3BsaXQga2V5IHNpemUgKi8NCj4gICNkZWZpbmUgQ0FBTV9NQVhfS0VZX1NJWkUgICAgICAoQUVT
X01BWF9LRVlfU0laRSArDQo+IENUUl9SRkMzNjg2X05PTkNFX1NJWkUgKyBcDQo+DQo+IC0tLQ0K
PiBiYXNlLWNvbW1pdDogNjdhZWZlY2NjNDEwMWE5MzYyN2YzNmFiYmQwNDlmMTkxYjU0ZjkwMw0K
PiBjaGFuZ2UtaWQ6IDIwMjYwOTI4LWZvci11cHN0cmVhbS1jYWFtLXFpMi1wcmlvcml0eS03NjMw
MWI4ZWIzYTYNCj4NCj4gQmVzdCByZWdhcmRzLA0KPiAtLQ0KPiBWaW5jZW50IEphcmRpbiA8dmph
cmRpbkBmcmVlLmZyPg0KPg0KPg0KDQo=
