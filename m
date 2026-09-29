Received: from AS8PR04CU009.outbound.protection.outlook.com (mail-westeuropeazon11011062.outbound.protection.outlook.com [52.101.70.62])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A0F6501293;
	Tue, 29 Sep 2026 11:52:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.70.62
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790682774; cv=fail; b=h+Mt+g/XDsMxR3W6dS2vkRZTyp2vCFC07SiW9onUOWt2hWt6Tru5p4O13bp6moPhhsyqG7PoYApUev67o4TaAm5V8FMusFth/yRA+z3ZFsDYC0k9VTFgphGrGeRW6WSn4+irspvW+GXV8zqQYU4KJF2k6mrWZTn2jJy6m9V7UoE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790682774; c=relaxed/simple;
	bh=PB2b7fUqcZM7co8fG1ZiVDeix3yiiIDM9lOuOnPXWHw=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=TbJkEmC+JGJFhG46rcqFUa/1cRWxoaXeRDYeAZeHy/v9OsWHocle3k7AaIAXnX7wjYnwr/xOOy2kS06qiPAMElLhrAnDr98AGzCCjWVjt9xlLSaThS/7omfqzjWz2A+kmglXuz9cuEftvNpATSGXTGMLxIM+RAFKKLaa7me+ZVM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.nxp.com; spf=pass smtp.mailfrom=oss.nxp.com; dkim=pass (2048-bit key) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.b=W9CvwO1N; arc=fail smtp.client-ip=52.101.70.62
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.b="W9CvwO1N"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=jv1rUAdZPtX1E/evLJN73EwUe5EtH1iVZ6E2oSqvoIY7Z+SwA0xQUeIgOTmpg6tRwLoCc0lwO71dTs0BS0H/gmKm9qXjuEoecFitE2vLi1TUjPocWIE9y/jBNG2H7hdhCYnPN/FuwMhjZus0RT0+NdPDPVsrvWQ9zzggSdNlyc7Oa+lv2lzpA+AoKsvCwaHcovlgThQhT7bip6U3G5j2raANNbm6OIKuqCoIHWb7ds8jebMTMXhE2whuBV40rzFgva9o2xG451/cnbo/Vd61z+aImHZiY9bGG2gMR0LiNpskAeLXz+2kzmC2VoiuXKLRbsiLrPem7eMX2O7qqF4UCQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PB2b7fUqcZM7co8fG1ZiVDeix3yiiIDM9lOuOnPXWHw=;
 b=qu8RH/L7nEORdxAHFTLh4m2S3tN3fcGqbLN1S0I8PmGkw27zLx2fLxgy+Z+toqK6ZGh2st45pMACKD/ioM5z30OfufA/u7H1K1y+W0aLpJtrZAquZqma8+cG+dl096rgrVmG+7ZA2O8ZUgOLHGCRc0qQ5ZKipkroAw0CkqcV817RyzlVRNEyG0xcdjzElwUmq0r0WGH2hhkfD4zhqfRXGsz7xce0WIxMXzumqtp1Dosm4cYBWz6JrC3m27SABPe2Je1C8798GTGMkxgze8frsBeAkFor9zUH/aKD+5a+d/eXJL7aMMSodVden3UwVCQUPjBWHCae9f2gmZmOVsl/yQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector1-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PB2b7fUqcZM7co8fG1ZiVDeix3yiiIDM9lOuOnPXWHw=;
 b=W9CvwO1Ns/1fDoWzGVLV3HRvsM4XT5CW/QW5LHCxveNdhFcD3YiNhbq066Ouvh2Bmbzcq+Ob0+ISOImGdM7nvSwOdBfsBsf+bvpyNpMFU6g5MWAZyKwTemjDkdty3iX9L0mRs68AeJdA1QgeUkqOBfHbJzfcwucRzUonKJpTT30Q5RS/TEOvuwZ7/3lvhKEypsjv21N/Wkw4UW0gmBmiEEG1IoU5uDqTAzztU4v7vfSfbmhtD3uD0eJP/XEo9qjm0WF/UYFvY4X5zoqZ0CoyTvQzjS3r48ivI9FZRvtlvhlqcrP/ZhM6M61J9XGXtlTBuCHTHfd5kIL0tinkMUpCuw==
Received: from DB9PR04MB8139.eurprd04.prod.outlook.com (2603:10a6:10:248::17)
 by AS4PR04MB9315.eurprd04.prod.outlook.com (2603:10a6:20b:4e6::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.451.24; Tue, 29 Sep
 2026 11:52:49 +0000
Received: from DB9PR04MB8139.eurprd04.prod.outlook.com
 ([fe80::97c8:7d82:e34b:3d43]) by DB9PR04MB8139.eurprd04.prod.outlook.com
 ([fe80::97c8:7d82:e34b:3d43%5]) with mapi id 15.21.0451.022; Tue, 29 Sep 2026
 11:52:49 +0000
From: "Sahil Malhotra (OSS)" <sahil.malhotra@oss.nxp.com>
To: Changwei Zou <changwei.zou@canonical.com>, Horia Geanta
	<horia.geanta@nxp.com>, Pankaj Gupta <pankaj.gupta@nxp.com>,
	"gaurav.jain@nxp.com" <gaurav.jain@nxp.com>, "herbert@gondor.apana.org.au"
	<herbert@gondor.apana.org.au>, "davem@davemloft.net" <davem@davemloft.net>
CC: "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"lukas@wunner.de" <lukas@wunner.de>
Subject: RE: [EXT] [PATCH 2/2] crypto: caam - Use bounce buffer for unaligned
 RSA destination buffers
Thread-Topic: [EXT] [PATCH 2/2] crypto: caam - Use bounce buffer for unaligned
 RSA destination buffers
Thread-Index: AQHdMSl17/Nejx3a8Eaw+B65aCD6n7blrTsA
Date: Tue, 29 Sep 2026 11:52:48 +0000
Message-ID:
 <DB9PR04MB8139B1C5A2502C01DD260393828C2@DB9PR04MB8139.eurprd04.prod.outlook.com>
References: <20260821045555.806471-1-changwei.zou@canonical.com>
 <20260821045555.806471-3-changwei.zou@canonical.com>
In-Reply-To: <20260821045555.806471-3-changwei.zou@canonical.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
msip_labels:
 MSIP_Label_0d9c909a-577b-4ba2-96de-69ada94b137a_Enabled=True;MSIP_Label_0d9c909a-577b-4ba2-96de-69ada94b137a_SiteId=686ea1d3-bc2b-4c6f-a92c-d99c5c301635;MSIP_Label_0d9c909a-577b-4ba2-96de-69ada94b137a_SetDate=2026-09-29T11:43:42.0000000Z;MSIP_Label_0d9c909a-577b-4ba2-96de-69ada94b137a_Name=NXP
 Confidential;MSIP_Label_0d9c909a-577b-4ba2-96de-69ada94b137a_ContentBits=3;MSIP_Label_0d9c909a-577b-4ba2-96de-69ada94b137a_Method=Standard
authentication-results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oss.nxp.com;
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DB9PR04MB8139:EE_|AS4PR04MB9315:EE_
x-ms-office365-filtering-correlation-id: 208d800c-c972-4870-0d54-08df1e202ef9
x-ms-exchange-sharedmailbox-routingagent-processed: True
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|366016|19092799006|1800799024|376014|23010399003|6133799003|18002099003|22082099003|10067099003|4143699003|38070700021|11063799006|56012099006;
x-microsoft-antispam-message-info:
 Im8ivdMYU6xnv4y3NzfgONc9Jt8Bd9hneJyAH7mNaQC0vVC/ptPQnjj3FrLNgTqWXSBXtYf0VgklA+9blnFAb713zGB4uFlyiP0vxYVFhY1XOWJhz9UxgBXZxS1S25m+XYcRd/e4X+usftlUwoP+cVKStCHKaxAOsRyHujsHIyQHS6iDBNPdh0LmMIsmSRzmBNnKjyCe/aRfFdwjs0cI6tOuxJiyJmHoJ2QFmuDYQqqWd5WBX0asGcrZFQtjOG9wNfxU5G7PyAxzoeOhT4GV1DlIvkZufmZS9KcmHxvOo1lHn6Xxnd0C5bkNzu0rkvp8UJ4kaXE8McOWreUL4UStwi+cfcTqg3yBTxWpOYvYS0BAZimMOTHgQcbC8QOht3wZM0cNoGwwfc43W07Ff8QCqxwFgrL1j9XYN/Ieab1U7+fMYeK8RM5WQVvzQvWyfYtjaVk5cunecAJBWPJnrhJWxKM2xDhG7DAh/80Cu8U8GujRIXieDqd0qbQiHIXDOT1eNMAwzge9wmUlccPVocg3EV51eE4mVPrybrvhoziaCo2tYaLFIUa4oyuuj/SwLKM46H1Md804UVlQy9Rl10kHRQHqIQGgaZ4TRoJH+2rAYu/bP8bSnLbqkGFmPJPzLISuumGzw4fp2jG9ffxviD8f7W+GaeaY0VyqDKwUJZxomijLBvmYyLVj+wJkDo+hMhrDxUwY+hydPbiO+JWiCDwkg9yPGdvGyUWXYKldxettAdw=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB9PR04MB8139.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(19092799006)(1800799024)(376014)(23010399003)(6133799003)(18002099003)(22082099003)(10067099003)(4143699003)(38070700021)(11063799006)(56012099006);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?TWd3Umk3YkxKUGExYmJNeTk2VFNEbFJ5dEtiWlRVbDB1bnBiZ1phSUFLRFR2?=
 =?utf-8?B?M0JEUEZWT0xGeld4dnhNZ25kOVVZdm92U2ROV1dqNnJNWXRVZDlVU2ljK2Rt?=
 =?utf-8?B?RTZNbitVSExhQUhpYmtkbmNSWlFDOGZWVksrNTBMVlkrMzl1SGhjQzJxckh2?=
 =?utf-8?B?dVpkSFpWSXc2aGowY29BS2VOMFBudDdySmFhelppQ3luT1RyNnFIUXhTa3pX?=
 =?utf-8?B?a1RvNlZhajlYT0NpclFBTTdBUzVHQXRpcDRjM3lEanNqU293K0pxUlY3QXpv?=
 =?utf-8?B?Y0hHdGFGcUZCd0l5VGtvd3pkc25CTjc1R0lLWTc4Wk1KU0s1NkdKT3lqcjZu?=
 =?utf-8?B?d3NOQTRhYVdsTHZ4R21EamgyRi9oRFJLdjlFTWtxWndKTi92RllVVG1yN1c5?=
 =?utf-8?B?R0prb3BDOXVOek5aUjNYbktrQU8vdjlrM0FyMnRNdVpQZERydTRZbDZYRW5v?=
 =?utf-8?B?V1dhM0dSaWtMeTkyVTcySWNoT21vbk5SS0tEdzZoTG5MaEhnbkF6MWRodU5x?=
 =?utf-8?B?d2graTYvSzFpS01obThJMEE4RGUwaTNWSnUvdm9kR0NWdkdrZTRFN3MwMkhU?=
 =?utf-8?B?WUxJOXE4UlpnUFlCN28vcTJHdHQrZE00elhlWFo4UFRXcEgwckc4ZzZTcVNH?=
 =?utf-8?B?Q2F3VHVvTjRDWTV2UEFRMnh4TjdsWFNpR1RQVlYwNXlEd0NXaldEeE5YQVM5?=
 =?utf-8?B?dGV3a3Q1Ym9sb3lSMTIxMHZrY3YwM2Z0U2t3VENxUDRUb01IY0s0WkExb2Jv?=
 =?utf-8?B?VXFYejRPU2ljSFR0L0tZRU0rRnpaTU91a2JTL1dleE1ZdE0yVUtrclU1OENl?=
 =?utf-8?B?Z2FRYndlRkw0cHgxajVzSlRFMnN0TTlQck9SUkJrZ3pxOEp2Y3NraDFya1dM?=
 =?utf-8?B?RlJXU3VIOXlQQTN5bTI3QlFSU1drRkJXdlVaODlyM2FkcnQrVndhOHRselNT?=
 =?utf-8?B?N3JNZUEzK0Q0dWN1L0Z3QTZ0dlBCaUxsTXlFejdzSGFYNk9sR0NOd3lrWTd3?=
 =?utf-8?B?MmRvOUowalR1blFpRDZOUTJNczZJQVRnY00xcGlNNC9qSG1neXpxaDRqS3ZV?=
 =?utf-8?B?d3NJM1RUQldaSGJ0L2djR05YeVY0RUE0MXdRVnpDMVgvcU1IMVI1Mm9pbUJz?=
 =?utf-8?B?OCtWK1JBZWJpTDdXRWxYaVJBTmExSnNLRFVyMlJLaXpsQVdxMHRqZU5wWWFU?=
 =?utf-8?B?STBkUGVianhJbUprRE5Xd08zaDBISDRUaENVL2prbll3dlJjNEN1NFRpSTE4?=
 =?utf-8?B?bzhuVm5ReXdmdHlScnVQSkovUzVqajhxYVJ6eXZUVDV3eE05MjRUWE1TMTd5?=
 =?utf-8?B?QlBXZkJYL2psMEpvWng0RG1mL2FqOXVTRHQ4a25zN2xENXZOOXVzM3laa2kv?=
 =?utf-8?B?MnVkZmVnbFV0YWtNZU1Ra2YyaXRPN09ZTnAycEdPY3g3K3pJRnhuSUNBV2tq?=
 =?utf-8?B?Sndjd2xuRXppUzZXMjY2UkpNTUw1Sm8zejM3WHJNRlNoa0JXcWVPeW9xeGZk?=
 =?utf-8?B?NnZVYWFDRHpVTE1vRHlmb0FudS9FN0xoQzRlUGNIQnlRcDJ2N1BVd0doaWp3?=
 =?utf-8?B?UDJUWVZIZUtMaElNdEFXMDJGT09qVmJJQXA0a09IbWd5SGcyQkxBVmlpRmda?=
 =?utf-8?B?cmtHTWFLR0xwSmxkRVZZVWNYVEVEQlcwMldsTmQ3NGdRUHkzV1BGYlM4Q2ZK?=
 =?utf-8?B?dzUzTjArZ2ZXR0xDYzU3ZWhtWEdDMFMzSmxVRTBnWVJsKzFTc1ZiYXRmdjN1?=
 =?utf-8?B?MnFaS1FoWmNoRWRvaytiVXhCT1JTZEgySlpJTkRIaURaRmUxeFRXUG5zZm9S?=
 =?utf-8?B?clhra2Z4K2trRFBKU1FUVzhzSkhHOWVEOUhoeVlFUmlUazNLdWdGdy96N0FW?=
 =?utf-8?B?RTFBUHpUd0pnQi9nSnBTS3g5ejhYZTNTbDFqaEJwR1dXd1U5VWV4NllQcWFG?=
 =?utf-8?B?WU9PS2ZlbS9LcnZrRnRQTm5JWFZtbjIyU2pxa2JWYkUxYWlSWTJMMmN0OGR5?=
 =?utf-8?B?Z2lMZm50cGVjdXF2eTAxOVNGK3lET3dxQ29JQVd5cTVVMnlDWUw5cmkvU09J?=
 =?utf-8?B?U3paa2NObUNhTi9VZG5HMUxQTDdQSllYb25Mb3QzS2cwaW9rWlNJZDZIU290?=
 =?utf-8?B?Wkp0WjU4blpVTlRXdVdzNjF6aGxiZUJ1TlR0Z0l1Uks2QVNDYjQzTGxqdXY5?=
 =?utf-8?B?Si9acnMyOTgzN2NMZmkraXVSVlZvNVhNYjdFZ2MveEtCeEtXV3NjSEVXVEV2?=
 =?utf-8?B?bHd1RVAwTWFMcDYrSkZhNFEwM2ltRkRLOEpDZHNQaEc5dmRBTnZBNEZyZW9S?=
 =?utf-8?B?K1pqU1ArZ0M5U2NEVWxkQnFucHNoSldjY2s1UDZ1azBiTUJjMjEwZz09?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 208d800c-c972-4870-0d54-08df1e202ef9
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Sep 2026 11:52:48.5177
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: dsYsyKI8fyvAuECsnLalqQAI1GUD2XlgereELL6PJdvJ3dcINsHpSszM0lL4DIOwCIdL3v1bNf3zyKKuXbvfgA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS4PR04MB9315

SGkgQ2hhbmd3ZWksDQoNClBsZWFzZSBmaW5kIG15IGNvbW1lbnQgaW5saW5lLg0KDQoNCk5YUCBD
b25maWRlbnRpYWwNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogQ2hhbmd3
ZWkgWm91IDxjaGFuZ3dlaS56b3VAY2Fub25pY2FsLmNvbT4NCj4gU2VudDogMjEgQXVndXN0IDIw
MjYgMTA6MjYNCj4gVG86IEhvcmlhIEdlYW50YSA8aG9yaWEuZ2VhbnRhQG54cC5jb20+OyBQYW5r
YWogR3VwdGENCj4gPHBhbmthai5ndXB0YUBueHAuY29tPjsgZ2F1cmF2LmphaW5AbnhwLmNvbTsN
Cj4gaGVyYmVydEBnb25kb3IuYXBhbmEub3JnLmF1OyBkYXZlbUBkYXZlbWxvZnQubmV0DQo+IENj
OiBsaW51eC1jcnlwdG9Admdlci5rZXJuZWwub3JnOyBsaW51eC1rZXJuZWxAdmdlci5rZXJuZWwu
b3JnOw0KPiBsdWthc0B3dW5uZXIuZGU7IGNoYW5nd2VpLnpvdUBjYW5vbmljYWwuY29tDQo+IFN1
YmplY3Q6IFtFWFRdIFtQQVRDSCAyLzJdIGNyeXB0bzogY2FhbSAtIFVzZSBib3VuY2UgYnVmZmVy
IGZvciB1bmFsaWduZWQNCj4gUlNBIGRlc3RpbmF0aW9uIGJ1ZmZlcnMNCj4NCj4gQ2F1dGlvbjog
VGhpcyBpcyBhbiBleHRlcm5hbCBlbWFpbC4gUGxlYXNlIHRha2UgY2FyZSB3aGVuIGNsaWNraW5n
IGxpbmtzIG9yDQo+IG9wZW5pbmcgYXR0YWNobWVudHMuIFdoZW4gaW4gZG91YnQsIHJlcG9ydCB0
aGUgbWVzc2FnZSB1c2luZyB0aGUgJ1JlcG9ydA0KPiB0aGlzIGVtYWlsJyBidXR0b24NCj4NCj4N
Cj4gVGhlIHJzYS1jYWFtIGRyaXZlciBkaXJlY3RseSBETUEtbWFwcyB0aGUgZGVzdGluYXRpb24g
YnVmZmVyIHN1cHBsaWVkIGJ5IHRoZQ0KPiBjYWxsZXIgdmlhIHJlcS0+ZHN0IHdpdGhvdXQgY2hl
Y2tpbmcgd2hldGhlciBpdCBtZWV0cyB0aGUgY2FjaGVsaW5lIGFsaWdubWVudA0KPiByZXF1aXJl
bWVudHMgb2YgRE1BLWluY29oZXJlbnQgaGFyZHdhcmUgc3VjaCBhcyBpLk1YOC4NCj4NCj4gT24g
Q1BVcyB3aXRoIG5vbi1jb2hlcmVudCBETUEgY2FjaGVzLCBpZiB0aGUgZGVzdGluYXRpb24gYnVm
ZmVyIHNoYXJlcyBhDQo+IGNhY2hlbGluZSB3aXRoIG90aGVyIGRhdGEgKGkuZS4gaXQgaXMgbm90
IGNhY2hlbGluZS1hbGlnbmVkKSwgY2FjaGUNCj4gd3JpdGViYWNrL2ludmFsaWRhdGlvbiBkdXJp
bmcgRE1BIGNhbiBjb3JydXB0IGFkamFjZW50IG1lbW9yeSBvciBjYXVzZQ0KPiBzdGFsZSBkYXRh
IHRvIGJlIHJlYWQgYmFjay4gVGhpcyBtYW5pZmVzdHMgYXMgaW50ZXJtaXR0ZW50IC1FS0VZUkVK
RUNURUQgZXJyb3JzDQo+IHdoZW4gbG9hZGluZyBzaWduZWQga2VybmVsIG1vZHVsZXMuDQo+DQo+
IFdoZW4gYW55IHNlZ21lbnQgb2YgcmVxLT5kc3QgaXMgbm90IGNhY2hlbGluZS1hbGlnbmVkIGlu
IGVpdGhlciBpdHMgc3RhcnQgb2Zmc2V0DQo+IG9yIGxlbmd0aCwgYWxsb2NhdGUgYSBzaW5nbGUg
Y29udGlndW91cyBhbGlnbmVkIGJvdW5jZSBidWZmZXIgY292ZXJpbmcgdGhlIGZ1bGwNCj4gZHN0
X2xlbiByb3VuZGVkIHVwIHRvIGEgY2FjaGVsaW5lIG11bHRpcGxlLCByZWRpcmVjdCB0aGUgb3Bl
cmF0aW9uIHRvIGl0LCBhbmQNCj4gY29weSB0aGUgcmVzdWx0IGJhY2sgdG8gdGhlIG9yaWdpbmFs
IGRlc3RpbmF0aW9uIG9uY2UgdGhlIGhhcmR3YXJlIGhhcw0KPiBjb21wbGV0ZWQgc3VjY2Vzc2Z1
bGx5Lg0KPg0KPiBJbnRyb2R1Y2UgYSBoZWxwZXIgc2dfaXNfZG1hX2FsaWduZWQoKSB0aGF0IGNo
ZWNrcyBib3RoIHNnLT5vZmZzZXQgYW5kDQo+IHNnLT5sZW5ndGggZm9yIGNhY2hlbGluZSBhbGln
bm1lbnQuIENoZWNraW5nIHNnLT5vZmZzZXQgc3VmZmljZXMgZm9yDQo+IHRoZSBzdGFydCBhZGRy
ZXNzIHNpbmNlIHBoeXNpY2FsIHBhZ2VzIGFyZSBhbHdheXMgcGFnZS1hbGlnbmVkIGFuZCBQQUdF
X1NJWkUNCj4gaXMgYSBtdWx0aXBsZSBvZiBkbWFfZ2V0X2NhY2hlX2FsaWdubWVudCgpLiBzZy0+
bGVuZ3RoIGlzIGFsc28gY2hlY2tlZCB0bw0KPiBlbnN1cmUgdGhlIGJ1ZmZlciBlbmQgZG9lcyBu
b3Qgc2hhcmUgYSBjYWNoZWxpbmUgd2l0aCBhZGphY2VudCBtZW1vcnkuDQo+DQo+IFRoZSBpbnRl
cm1pdHRlbnQgZXJyb3IgJ0tleSB3YXMgcmVqZWN0ZWQgYnkgc2VydmljZScgb24gaS5NWDggd2l0
aCBDQUFNIGNhbg0KPiBiZSB0cmlnZ2VyZWQgd2hlbiBsb2FkaW5nIHNpZ25lZCBrZXJuZWwgbW9k
dWxlczoNCj4NCj4gICAgIGZvciBpIGluICQoc2VxIDEgMTAwKTsgZG8NCj4gICAgICAgICBzdWRv
IG1vZHByb2JlIHhmcyAyPiYxICYmIGVjaG8gIlNVQ0NFU1Mgb24gYXR0ZW1wdCAkaSIgXA0KPiAg
ICAgICAgICYmIHN1ZG8gcm1tb2QgeGZzIHx8IGVjaG8gIkZBSUxFRCBvbiBhdHRlbXB0ICRpIg0K
PiAgICAgZG9uZQ0KPg0KPiBTaWduZWQtb2ZmLWJ5OiBDaGFuZ3dlaSBab3UgPGNoYW5nd2VpLnpv
dUBjYW5vbmljYWwuY29tPg0KPiBBc3Npc3RlZC1ieTogT3BlbkNvZGU6Y2xhdWRlLXNvbm5ldC00
LjYNCj4gLS0tDQo+ICBkcml2ZXJzL2NyeXB0by9jYWFtL2NhYW1wa2MuYyB8IDc3DQo+ICsrKysr
KysrKysrKysrKysrKysrKysrKysrKysrKysrKystDQo+ICBkcml2ZXJzL2NyeXB0by9jYWFtL2Nh
YW1wa2MuaCB8ICA2ICsrKw0KPiAgMiBmaWxlcyBjaGFuZ2VkLCA4MiBpbnNlcnRpb25zKCspLCAx
IGRlbGV0aW9uKC0pDQo+DQo+IGRpZmYgLS1naXQgYS9kcml2ZXJzL2NyeXB0by9jYWFtL2NhYW1w
a2MuYyBiL2RyaXZlcnMvY3J5cHRvL2NhYW0vY2FhbXBrYy5jDQo+IGluZGV4IDg0MDI3MTg0MGNj
ZS4uMTFjNmIwN2Y1ZGFkIDEwMDY0NA0KPiAtLS0gYS9kcml2ZXJzL2NyeXB0by9jYWFtL2NhYW1w
a2MuYw0KPiArKysgYi9kcml2ZXJzL2NyeXB0by9jYWFtL2NhYW1wa2MuYw0KPiBAQCAtNTksNiAr
NTksNDAgQEAgc3RhdGljIHZvaWQgcnNhX2lvX3VubWFwKHN0cnVjdCBkZXZpY2UgKmRldiwgc3Ry
dWN0DQo+IHJzYV9lZGVzYyAqZWRlc2MsDQo+ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgIERNQV9UT19ERVZJQ0UpOyAgfQ0KPg0KPiArc3RhdGljIGludCBkb19yc2FfYm91bmNlX2J1
ZihzdHJ1Y3QgYWtjaXBoZXJfcmVxdWVzdCAqcmVxLCBpbnQgcmVxX2VycikNCj4gK3sNCj4gKyAg
ICAgICBzdHJ1Y3QgY2FhbV9yc2FfcmVxX2N0eCAqcmVxX2N0eCA9IGFrY2lwaGVyX3JlcXVlc3Rf
Y3R4KHJlcSk7DQo+ICsgICAgICAgaW50IG5lbnRzLCBlcnIgPSAwOw0KPiArDQo+ICsgICAgICAg
aWYgKCFyZXFfY3R4LT5ib3VuY2VfYnVmKQ0KPiArICAgICAgICAgICAgICAgcmV0dXJuIDA7DQpQ
bGVhc2UgYWRkIHRoaXMgY2hlY2sgaW4gcnNhX2JvdW5jZV9idWZfZG9uZSgpIGFuZCByZXR1cm4g
ZnJvbSB0aGVyZSBvbmx5Lg0KV2UgbmVlZCBub3QgdG8gY29tZSBoZXJlIHRvIHJldHVybi4NCg0K
DQo+ICsNCj4gKyAgICAgICAvKiBPbmx5IGNvcHkgYmFjayB0byB0aGUgb3JpZ2luYWwgZGVzdGlu
YXRpb24gb24gc3VjY2VzcyAqLw0KPiArICAgICAgIGlmICghcmVxX2Vycikgew0KPiArICAgICAg
ICAgICAgICAgbmVudHMgPSBzZ19uZW50c19mb3JfbGVuKHJlcV9jdHgtPm9yaWdfZHN0LCByZXEt
PmRzdF9sZW4pOw0KPiArICAgICAgICAgICAgICAgaWYgKG5lbnRzIDwgMCkNCj4gKyAgICAgICAg
ICAgICAgICAgICAgICAgZXJyID0gbmVudHM7DQo+ICsgICAgICAgICAgICAgICBlbHNlIGlmIChz
Z19jb3B5X2Zyb21fYnVmZmVyKHJlcV9jdHgtPm9yaWdfZHN0LCBuZW50cywNCj4gKyAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgcmVxX2N0eC0+Ym91bmNlX2J1ZiwN
Cj4gKyAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgcmVxLT5kc3Rf
bGVuKSAhPSByZXEtPmRzdF9sZW4pDQo+ICsgICAgICAgICAgICAgICAgICAgICAgIGVyciA9IC1F
RkFVTFQ7DQo+ICsgICAgICAgfQ0KPiArDQoNCg==
