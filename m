Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=139.219.146.104
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1792636248;
	b=Z7g5nnuX8SAhor1sZYPBSDcEqzrzA0EcXIK+oFtf/6IYu0zDj8+y9RxlaiCFYy7Tk1LF
	 Eb+W7IhFJYYzHk5cvYPt2MpEDKlqYelXW+Vtx/Fie4cW2ArUMRTLP350UPggIzlqTgGfS
	 5ZvI6aaFnJ788ei7cAYvpWOJsS1LM3I50K3srKu30f49gwPS14Itc5KDF4zaIid5NCFso
	 qgaoDf1C0Tb8JUaFwNqFIfVF5rt1gCjAtudt77/k3OBOxGBooQyWcA39ju5tPA+0xH9Go
	 3nx72pOTHOzu/F5b65XkC50qrMLKSmXwB8JytHro3OhzS5imZ7dvPaSIbeWtlNK7DKA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792636248;
	h=DMARC-Filter:Received:Received:From:To:CC:Subject:Thread-Topic:
	 Thread-Index:Date:Message-ID:References:In-Reply-To:Accept-Language:
	 Content-Language:X-MS-Has-Attach:X-MS-TNEF-Correlator:
	 x-ms-publictraffictype:x-ms-traffictypediagnostic:
	 x-ms-office365-filtering-correlation-id:x-ms-exchange-senderadcheck:
	 x-microsoft-antispam:x-microsoft-antispam-message-info:
	 x-forefront-antispam-report:
	 x-ms-exchange-antispam-messagedata-chunkcount:
	 x-ms-exchange-antispam-messagedata-0:Content-Type:
	 Content-Transfer-Encoding:MIME-Version:X-OriginatorOrg:
	 X-MS-Exchange-CrossTenant-AuthAs:X-MS-Exchange-CrossTenant-AuthSource:
	 X-MS-Exchange-CrossTenant-Network-Message-Id:
	 X-MS-Exchange-CrossTenant-originalarrivaltime:
	 X-MS-Exchange-CrossTenant-fromentityheader:
	 X-MS-Exchange-CrossTenant-id:X-MS-Exchange-CrossTenant-mailboxtype:
	 X-MS-Exchange-CrossTenant-userprincipalname:
	 X-MS-Exchange-Transport-CrossTenantHeadersStamped;
	bh=ws+t28UQP5X4Ls/7N3u0h0s0rOUE9VEX77nC3LP86QM=;
	b=ryjgKq1CX/fmdsjqAyMGWGYkItTpzQtB4/kqksNTZYb4j5JySnha0fqAWVpkL6/A3Rpr
	 x76ej4p/KssQ6fQboalR2OsSsrsChdbX3FwhO92bMDd1sTa0iCYTZkhgoUFjSApIjhkOx
	 uKM0MH1iF+xwzR3ubHBOvnvhxOv3VDnYOSF0TZKbrhwj+0SGBrLs4d1lygb2WqJ0wjLZK
	 ieGkaZLpA/nnGwsYjMEtNPTxHUvyeS7G/Og3yC5WThdm6KIaSy3uJhieXwJTCtLAVEWmL
	 BOG8CDYY+R2y8bugZWRAT94oxeoQtiy6y650N9aJQ9KuwuWhyhVjQanTtrUdf6BrN9Q==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=starfivetech.com;
	spf=pass smtp.mailfrom=starfivetech.com;
	arc=pass header.oldest-pass=0 smtp.remote-ip=139.219.146.104
Received: from CHN02-SH0-obe.outbound.protection.partner.outlook.cn (mail-sh0chn02on2104.outbound.protection.partner.outlook.cn [139.219.146.104])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98247606A319;
	Thu, 22 Oct 2026 02:30:46 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 98247606A319
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=starfivetech.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=starfivetech.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JYtXwK/GF/dZ8jP2h4Qy/+Smo0tKYywepJdo64ymsgfKcqJLSfkwMwgL2BexYtXaODIlMa8JHYhd6DrIx9sJcGaFf18HpVa/BF1/YGuz2e6+DCtgcvqBWze3rfc4g8kqFUWK3CgAy69kiYKWdD/SezcZsn3sLvZKS30R/j7JNmYOVkM6UCQIMOgOJ9Q8QUVn3+0474XudurupsCoxR4BkBo7/M44zUXPabBr9+Xpj7sm8Dl3KjhLuYPDwqe0MMnIT8MJxS0YYBFonwj0z8LfslBL03GbiUvMzr3Ma24vVrXdJyhPc+3oFH2FEeyEiLGYC9hBe6Qpf/J02vd5LBBf/A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ws+t28UQP5X4Ls/7N3u0h0s0rOUE9VEX77nC3LP86QM=;
 b=Vq6Wcyb2Fp6W5BDFSWJIiqFWIyTTJkbvTaLn7RbM+nZNQiImQ/XPy51VS0w6eAheIGukCF+xhvAhOeF3kzlYcVHbelF/+xPbS/LgYsXxe4ySiBF9exxz6wWZlWamQTYUi1C4S69YO8x0lFgYqMG8BCrDdLBiS/JWa+GPUyXCzFkN7ncmG6r3UB6rHqO2cWjxL+HUnZwOOinEAS3FPHtyvje8T4UDcJW1V8NW+/TD/csN19hfy4URm/Czpz08S9Oo441zpT2qqGYh+QW7GMdq1iWHPxH2bY2jDbDYp+mjyFHj+0e/A2tX+MN0PJv2zNWqODsa1PpyN6ChNRYkyiYGlQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=starfivetech.com; dmarc=pass action=none
 header.from=starfivetech.com; dkim=pass header.d=starfivetech.com; arc=none
Received: from ZQ0PR01MB1269.CHNPR01.prod.partner.outlook.cn
 (2406:e500:c550:18::6) by ZQ0PR01MB1141.CHNPR01.prod.partner.outlook.cn
 (2406:e500:c550:1a::5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.522.19; Thu, 22 Oct
 2026 02:30:34 +0000
Received: from ZQ0PR01MB1269.CHNPR01.prod.partner.outlook.cn
 ([fe80::973:272c:ab11:7570]) by ZQ0PR01MB1269.CHNPR01.prod.partner.outlook.cn
 ([fe80::973:272c:ab11:7570%4]) with mapi id 15.21.0546.016; Thu, 22 Oct 2026
 02:30:34 +0000
From: Lianfeng Ouyang <lianfeng.ouyang@starfivetech.com>
To: =?utf-8?B?VXdlIEtsZWluZS1Lw7ZuaWc=?= <u.kleine-koenig@baylibre.com>
CC: Olivia Mackall <olivia@selenic.com>, Herbert Xu
	<herbert@gondor.apana.org.au>, Rob Herring <robh@kernel.org>, Krzysztof
 Kozlowski <krzk+dt@kernel.org>, Conor Dooley <conor+dt@kernel.org>, Philipp
 Zabel <p.zabel@pengutronix.de>, "linux-crypto@vger.kernel.org"
	<linux-crypto@vger.kernel.org>, "devicetree@vger.kernel.org"
	<devicetree@vger.kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>
Subject:
 =?utf-8?B?5Zue5aSNOiBbUEFUQ0ggdjkgMi8yXSBod3JuZzogc3RhcmZpdmU6IHJld29y?=
 =?utf-8?Q?k_clk/reset_teardown_order_for_JHB100?=
Thread-Topic: [PATCH v9 2/2] hwrng: starfive: rework clk/reset teardown order
 for JHB100
Thread-Index: AQHdYTdjYIj5UIbHnEu4JULVXd5PC7cILAgAgACmbEA=
Date: Thu, 22 Oct 2026 02:30:34 +0000
Message-ID:
 <ZQ0PR01MB126996B22A2E2A413EE0B8AA82652@ZQ0PR01MB1269.CHNPR01.prod.partner.outlook.cn>
References: <20261021083712.3032-1-lianfeng.ouyang@starfivetech.com>
 <20261021083712.3032-3-lianfeng.ouyang@starfivetech.com>
 <atjkINr76NvWasY8@monoceros>
In-Reply-To: <atjkINr76NvWasY8@monoceros>
Accept-Language: en-US
Content-Language: zh-CN
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=starfivetech.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: ZQ0PR01MB1269:EE_|ZQ0PR01MB1141:EE_
x-ms-office365-filtering-correlation-id: 41a48006-ddba-4741-e45e-08df2fe47360
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam:
 BCL:0;ARA:13230040|7416014|1800799024|376014|23010399003|366016|38070700021|56012099006|4143699003|261009223027099003|10067099003|22082099003|18002099003|261021121427099003|6133799003;
x-microsoft-antispam-message-info:
 PlpPRjgqLmov4PMKIOSHXcQNKd9KabGvFc/BWMpl+4x1M4gUF/gJDo5tfPiwofu/xCbfEKrbRLgps4GQLBD7DONf0i6Sa+FS3Ix329utyaHZrO7KoUm96mHAe5l9ZFvZ2yRPxCX6CPmuqG3XO8nxVD1167gA/hFWQiTq52pDcT09b3VXcK9rc23xfq9ZP5LuZNTI654kAxa4ZSJGgb/BvdsehymZ4c4EL2NWE3YovWeTstTTo2mVeLWCbZuMiBAnKwbcBrX+gq8yRXUauLJ1ZDw0NQAFO8tUPcQbFRsB8toWTqgp7malT8njCuaPW2pZfNpiQ5vDUoZDfaSUIuiEdinfObDGJKrVb0qOXL5BreAj/Tm3fFkwLQEzRJKGWUIwwpCFtcgXSUJffECTZlBm3TWG9KyDgPm08LR1iHHGfDui2JaY/ew2Pyfxh35k9JSasuKYHpgcoI1IOKar/kv1vDhTC6DwBOtGhEPXaUeluV/HJyH/ZWYHabDu7BUW5nkDPDYRBVSduDsVTgNA0sgOQNjUE36cfwvMSZZWzetOeiwMkGlBYfEf2171mXwjIFxw
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:zh-cn;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:ZQ0PR01MB1269.CHNPR01.prod.partner.outlook.cn;PTR:;CAT:NONE;SFS:(13230040)(7416014)(1800799024)(376014)(23010399003)(366016)(38070700021)(56012099006)(4143699003)(261009223027099003)(10067099003)(22082099003)(18002099003)(261021121427099003)(6133799003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?YmFTYmV3cnhLeGlXZTUxSFhsYUhsK2xIL3NTeUVrYlh1M3V0OWNubFJCUUY2?=
 =?utf-8?B?eVZ6cm1Cb2Y3Zyt1Y2lnVm1OM2hCcWsrK3o1c3pwVHdhcEo2YUh6MDlqa3dT?=
 =?utf-8?B?R25kdzQxanAvaERTSE5pcUFXVEtzUmViUEFFNUhOOUFQRVBsS3hkUVd3Z3Jk?=
 =?utf-8?B?RVloRjMzZmxaanNwMGFySld3dW80NXpXRlVQOXVhOUpraHNBMXNiYU5RVmR6?=
 =?utf-8?B?d0R5Wm1vRjVxdTdvM1ZCWS9zNWE2V0pzTm9xSURpQkZjYjE5UGFXVXR0bThN?=
 =?utf-8?B?M3BLZGFaUlQ2ajNlS0kzckJzc1JsVXVSc05sUzRxdElQcE13T0JPdmlIbXI5?=
 =?utf-8?B?c1NrZUpDYUNmSU9EdVFab0ZaamdHT2FMYkhnK0lRNGlGWkV5UkcrdktQVXVa?=
 =?utf-8?B?WTFnUk9RRWtqRXlqN2p5bGZPWWJIbFhnRm9MbmJRdThKTjU2WG04RHFlSnVC?=
 =?utf-8?B?bW1lVWZlOU0yV28rQ1BpZjF2NE96dHIwWUtZbndCVXExcVZwejliemFFM3Na?=
 =?utf-8?B?ajJxOVNmSUVZTG5GNVFnOXRLU2doaUJxNUc4bEJLRWRVL0w2SlFUaXlpWXE4?=
 =?utf-8?B?T0dJUWpXeGExN1hqYitvL2wvaXlnTG9BUDhJZE53VSs4OCs2aFlVdm1QVjlk?=
 =?utf-8?B?NHJ3eUl2MllqbVpjU1lqbTZsYXQ2LzV6bmU4azlqckhaelJHNWQzei9ZS2Zo?=
 =?utf-8?B?Lzhtd0t4bElEUTdLME1lamZYWDRPOVFXYUl0SkJwRWUzSEgvUTlDOUg2ZjZu?=
 =?utf-8?B?bDZNVmFmcGpFRUIrR2hSaDFqdmNBUnNYdU0yNTVBdVRvbG9RWVFWU3hZL3Jz?=
 =?utf-8?B?eHYwYjN1TXZOQ05XMWFxdFlyOS9yQktmcHZVL0dmUjFpVXE1M0F0OVJBeXR2?=
 =?utf-8?B?bm1Bb0lsQUJ4T2VsdXNkc3V0UjVzV0tLejJuTWJnN2hOSWU3T1Bzd2pWZVFJ?=
 =?utf-8?B?OGlUZ25XdUNrSEoycXk1RTIvU09aWDZadHJzeEdRMDBJb3lnM3NHek5EWkgz?=
 =?utf-8?B?U1V5V0RQaXZzcVdKNExzREF3aHd3RTJZcnZyTThONy9XWi9LVlhERWJOSnNp?=
 =?utf-8?B?ZG1OV2RwU0doaXU2OERqWmpkeUlRL1JEKzVmaUpPME1uK296a01PcTRZODdt?=
 =?utf-8?B?alJZZDUxV015Qng5OGs3MDJ1dGJHTzUzbkdZeGlQK0VoU3dzM25VSEN4d0xt?=
 =?utf-8?B?ZUk1bS9PZWJ1T0VCenJiaC9ESDdicUE5S3g4VWsvdU5yTy95aXVweUdMSkdM?=
 =?utf-8?B?WE1jYjUraHdocWVSQUxiVG9HRXJRdXZSKytrYWJCeTgxV3BlY0dkMEtPRmJH?=
 =?utf-8?B?NDYrQnJlY1dKcnd2bzJ2UW52UEsxK2xqVk0zYjY3VXlaOVJDM2lSZkcwUXFX?=
 =?utf-8?B?a2xlZk9PeitZamg2KzgzYlVZVzNtOGc2anpCNWsvdDZhZG83RHI1MFh3VUpH?=
 =?utf-8?B?SXJkb1cyWGlwVThtNGJabHpsQ0dsWWZQMmU1bEw3YjcxOTVUK3hCOXVXVGE3?=
 =?utf-8?B?VDY1R1BjVW1JWXZDZm1Ia1VabXpMWlhzaHE5MWRGSGFQc3lOTWo4YXoyRXQw?=
 =?utf-8?B?cWNQSXJWa01pSEppc3hySFVEVUFFTklTLy8ydTE3bkhvSXIxSUtiTjJQMTRE?=
 =?utf-8?B?TUJ0ZXhHcWVaYnY0eWJWeEFWNGYwMnpyR1hhdHF6STYyWHpxaXlhbDhNR0Fx?=
 =?utf-8?B?ZFVDMlZIMENzTGRMVStjcTVENUg1MTJDeGxvdHM3T0g0K0Fzb3JkWkFzQ0Vl?=
 =?utf-8?B?dmF3VWdTWDZqYWt3WCtucVowdW15bDRIc1VleXk1OHN0UVU5Nk1yNStmenRE?=
 =?utf-8?B?bGdYSFJ1b3V4ZFJROEw3eFh4aVBDTWRkbHAzU0VXbFNrbXI5YzVXUDlxSXU1?=
 =?utf-8?B?Tnc2Y1ppeFltYzZHUlpOZXZ0ekpHaWE0ZnJWMTZxbXo1a3F0WmZVUGYxV2x0?=
 =?utf-8?B?Y1FjTExrdXYzUWFsRDJ3RzVZQkdyQXlYQ1A3SGdVdXVyeDNqaG9wV09HL2pa?=
 =?utf-8?B?bVVjQUdTWVN6RXE5R1hiQitya25oSlBKSFRqaEpXRllBWjE5eGRmWk8rVEN4?=
 =?utf-8?B?YzhYekVuOWhxak9nRXVzZzdmekVHYlgyKzg2ZHFBZXpyK21MU0xzWWg0bWJh?=
 =?utf-8?B?b21SYmZzRWhVNlI1RTBVek5tN3NSaWZOYjVBdi90cnBXaTRnZ28rKzRvZGIz?=
 =?utf-8?B?Q0VJaXhsSjBwV05sQlJjbVY5bVNxeldWMGt2MFQ3Qm9qUTJZdkZVQzZSWHpT?=
 =?utf-8?B?RHo0RGRQZG9wWWo0UUF6a01pWkwzWDMwRHVJUHRSbk9Ka04va3BlN2EvVW5E?=
 =?utf-8?B?RE1KME1HMmdaZ1MzVXFvZDVKYjFqL0pUL2hoc0lQSm5GV1ZjQUpKc2JzZzRh?=
 =?utf-8?Q?2KtyjuygMEoilUVQ=3D?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
X-OriginatorOrg: starfivetech.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: ZQ0PR01MB1269.CHNPR01.prod.partner.outlook.cn
X-MS-Exchange-CrossTenant-Network-Message-Id: 41a48006-ddba-4741-e45e-08df2fe47360
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Oct 2026 02:30:34.3664
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 06fe3fa3-1221-43d3-861b-5a4ee687a85c
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: HW/sAr9suVrwgYY1Nr40YhQvYBndx61ZD+KTaxifuonvmhAjh6PTDxFPyzAEeUueh5JFCWHqFrQJZKlElRPMzFOU2zzRW7oUm2GV4nlmG+aKM4F+CPZWkuK91uyUJRd0
X-MS-Exchange-Transport-CrossTenantHeadersStamped: ZQ0PR01MB1141

DQoNCj4gLS0tLS3pgq7ku7bljp/ku7YtLS0tLQ0KPiDlj5Hku7bkuro6IFV3ZSBLbGVpbmUtS8O2
bmlnIDx1LmtsZWluZS1rb2VuaWdAYmF5bGlicmUuY29tPg0KPiDlj5HpgIHml7bpl7Q6IDIwMjbl
ubQxMOaciDIy5pelIDA6MTQNCj4g5pS25Lu25Lq6OiBMaWFuZmVuZyBPdXlhbmcgPGxpYW5mZW5n
Lm91eWFuZ0BzdGFyZml2ZXRlY2guY29tPg0KPiDmioTpgIE6IE9saXZpYSBNYWNrYWxsIDxvbGl2
aWFAc2VsZW5pYy5jb20+OyBIZXJiZXJ0IFh1DQo+IDxoZXJiZXJ0QGdvbmRvci5hcGFuYS5vcmcu
YXU+OyBSb2IgSGVycmluZyA8cm9iaEBrZXJuZWwub3JnPjsgS3J6eXN6dG9mDQo+IEtvemxvd3Nr
aSA8a3J6aytkdEBrZXJuZWwub3JnPjsgQ29ub3IgRG9vbGV5IDxjb25vcitkdEBrZXJuZWwub3Jn
PjsgUGhpbGlwcA0KPiBaYWJlbCA8cC56YWJlbEBwZW5ndXRyb25peC5kZT47IGxpbnV4LWNyeXB0
b0B2Z2VyLmtlcm5lbC5vcmc7DQo+IGRldmljZXRyZWVAdmdlci5rZXJuZWwub3JnOyBsaW51eC1r
ZXJuZWxAdmdlci5rZXJuZWwub3JnDQo+IOS4u+mimDogUmU6IFtQQVRDSCB2OSAyLzJdIGh3cm5n
OiBzdGFyZml2ZTogcmV3b3JrIGNsay9yZXNldCB0ZWFyZG93biBvcmRlciBmb3INCj4gSkhCMTAw
DQo+IA0KPiBPbiBXZWQsIE9jdCAyMSwgMjAyNiBhdCAwNDozNzoxMlBNICswODAwLCBsaWFuZmVu
Zy5vdXlhbmcgd3JvdGU6DQo+ID4gRnJvbTogTGlhbmZlbmcgT3V5YW5nIDxsaWFuZmVuZy5vdXlh
bmdAc3RhcmZpdmV0ZWNoLmNvbT4NCj4gPg0KPiA+IFJld29yayB0aGUgU3RhckZpdmUgVFJORyBk
cml2ZXIgdG8gYWRkcmVzcyBoYXJkd2FyZS1zcGVjaWZpYyByZXF1aXJlbWVudHMNCj4gPiAgIGZv
ciBKSEIxMDAgU29DLiBUbyBhdm9pZCByZXNldC1kb21haW4gY3Jvc3NpbmcgZ2xpdGNoZXMsIHRo
ZSBkcml2ZXIgbm93DQo+ID4gICBlbnN1cmVzIGNsb2NrcyBhcmUgZ2F0ZWQgYmVmb3JlIGFzc2Vy
dGluZyByZXNldCBkdXJpbmcgdGVhcmRvd24gZm9yDQo+ID4gICBKSEIxMDAsIHdoaWxlIEpINzEx
MCByZXRhaW5zIHRoZSBvcmlnaW5hbCByZXNldC1maXJzdCBzZXF1ZW5jZS4NCj4gPg0KPiA+IEFk
ZCBwZXItY29tcGF0aWJsZSBtYXRjaCBkYXRhIChzdHJ1Y3Qgc3RhcmZpdmVfdHJuZ19kYXRhKSBk
ZXNjcmliaW5nIHRoZQ0KPiA+ICAgY2xvY2svcmVzZXQgdGVhcmRvd24gb3JkZXIsIGEgbmV3ICJz
dGFyZml2ZSxqaGIxMDAtdHJuZyIgY29tcGF0aWJsZSwgYW5kDQo+ID4gICBzZWxlY3QgdGhlIG9y
ZGVyaW5nIGZyb20gaXQuDQo+ID4NCj4gPiBGaXggdGhlIHJ1bnRpbWUtUE0gZ2V0L3B1dCBiYWxh
bmNpbmcgYWNyb3NzIHRoZSBpbml0L3JlYWQvcmVzZWVkL2NsZWFudXANCj4gPiAgIHBhdGhzLCBt
YW5hZ2UgUE0gYW5kIHRoZSBjbGsvcmVzZXQgdGVhcmRvd24gdmlhIGRldm0gc28gYWxsIGVycm9y
IHBhdGhzDQo+ID4gICB1bndpbmQgY29ycmVjdGx5LCBydW4gdGhlIFNFVS10cmlnZ2VyZWQgcmVz
ZWVkIGZyb20gYSB3b3JrcXVldWUgaW5zdGVhZA0KPiA+ICAgb2YgaGFyZCBJUlEsIGFuZCBzZXJp
YWxpc2UgdGhlIGNvbW1hbmQgc2VxdWVuY2VzIHdpdGggYSBtdXRleC4NCj4gDQo+IFRoaXMgc291
bmRzIGxpa2UgdGhyZWUgY29tbWl0cywgd2l0aCBhdCBsZWFzdCB0aGUgdGhpcmQgZ2V0dGluZyBh
IEZpeGVzOg0KPiBsaW5lLg0KDQpPa2F5LCBteSBuZXh0IHN1Ym1pc3Npb24gd2lsbCBiZSBzcGxp
dCBpbnRvIG11bHRpcGxlIHN1Ym1pc3Npb25zIGFjY29yZGluZyB0byB0aGUgcmVxdWlyZW1lbnRz
DQoNCj4gDQo+ID4gKyNpbmNsdWRlIDxsaW51eC9iaXRzLmg+DQo+ID4gICNpbmNsdWRlIDxsaW51
eC9jbGsuaD4NCj4gPiAgI2luY2x1ZGUgPGxpbnV4L2NvbXBsZXRpb24uaD4NCj4gPiAtI2luY2x1
ZGUgPGxpbnV4L2RlbGF5Lmg+DQo+ID4gKyNpbmNsdWRlIDxsaW51eC9jb250YWluZXJfb2YuaD4N
Cj4gPiArI2luY2x1ZGUgPGxpbnV4L2RldmljZS5oPg0KPiA+ICsjaW5jbHVkZSA8bGludXgvZGV2
bS1oZWxwZXJzLmg+DQo+ID4gICNpbmNsdWRlIDxsaW51eC9lcnIuaD4NCj4gPiArI2luY2x1ZGUg
PGxpbnV4L2Vycm5vLmg+DQo+ID4gICNpbmNsdWRlIDxsaW51eC9od19yYW5kb20uaD4NCj4gPiAg
I2luY2x1ZGUgPGxpbnV4L2ludGVycnVwdC5oPg0KPiA+ICAjaW5jbHVkZSA8bGludXgvaW8uaD4N
Cj4gPiAgI2luY2x1ZGUgPGxpbnV4L2lvcG9sbC5oPg0KPiA+IC0jaW5jbHVkZSA8bGludXgva2Vy
bmVsLmg+DQo+ID4gKyNpbmNsdWRlIDxsaW51eC9qaWZmaWVzLmg+DQo+ID4gKyNpbmNsdWRlIDxs
aW51eC9sb2NrZGVwLmg+DQo+ID4gKyNpbmNsdWRlIDxsaW51eC9taW5tYXguaD4NCj4gPiArI2lu
Y2x1ZGUgPGxpbnV4L21vZF9kZXZpY2V0YWJsZS5oPg0KPiANCj4gUGxlYXNlIGRvbid0IGFkZCA8
bGludXgvbW9kX2RldmljZXRhYmxlLmg+LiA8bGludXgvcGxhdGZvcm1fZGV2aWNlLmg+DQo+IGFs
cmVhZHkgcHJvdmlkZXMgb2ZfZGV2aWNlX2lkLCBzbyBqdXN0IGRyb3BwaW5nDQo+IDxsaW51eC9t
b2RfZGV2aWNldGFibGUuaD4gc2hvdWxkIHdvcmsgZmluZS4NCg0KT2theSwgSSB3aWxsIHJlb3Jn
YW5pemUgdGhlc2UgaGVhZGVyIGZpbGVzDQoNCj4gDQo+ID4gICNpbmNsdWRlIDxsaW51eC9tb2R1
bGUuaD4NCj4gPiAtI2luY2x1ZGUgPGxpbnV4L29mLmg+DQo+ID4gKyNpbmNsdWRlIDxsaW51eC9t
dXRleC5oPg0KPiA+ICAjaW5jbHVkZSA8bGludXgvcGxhdGZvcm1fZGV2aWNlLmg+DQo+ID4gICNp
bmNsdWRlIDxsaW51eC9wbV9ydW50aW1lLmg+DQo+ID4gLSNpbmNsdWRlIDxsaW51eC9yYW5kb20u
aD4NCj4gPiArI2luY2x1ZGUgPGxpbnV4L3Byb3BlcnR5Lmg+DQo+ID4gICNpbmNsdWRlIDxsaW51
eC9yZXNldC5oPg0KPiA+ICsjaW5jbHVkZSA8bGludXgvdHlwZXMuaD4NCj4gPiArI2luY2x1ZGUg
PGxpbnV4L3dvcmtxdWV1ZS5oPg0KPiANCj4gQWxsIHRoYXQgaGVhZGVyIHJlYXJyYW5nZW1lbnQg
aXMgd29ydGggcG9pbnRpbmcgb3V0IGluIHRoZSBjb21taXQgbG9nLg0KDQpPa2F577yMVGhhbmtz
IGZvciB0aGUgcmV2aWV3Lg0KDQpCZXN0IFJlZ2FyZHMsDQpMaWFuZmVuZyBPdXlhbmcNCg0KPiAN
Cj4gQmVzdCByZWdhcmRzDQo+IFV3ZQ0K
