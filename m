Received: from EUR03-AM7-obe.outbound.protection.outlook.com (mail-am7eur03on2079.outbound.protection.outlook.com [40.107.105.79])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 279EA14D718;
	Wed, 13 Nov 2024 16:22:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.105.79
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731514938; cv=fail; b=sLlI4zyVZjH5zSwawh10uGxIRxkuPUjREmQs+Uf+hMo4uz9XYD4Ucy0JbG2KTqTprC0ELlvfsyX39PuG7GZHvJEK7SFfllOIsEae1n0Lt8hXoyB62GJNimVzy7NP4BhxEYNhpczCb7frtIOJrC2QKALvAaI3raBPBxCrGRGbCcQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731514938; c=relaxed/simple;
	bh=ZYKpLaCroHoTrVUkjEPnz5nObOw0mNZbCVWkSoQPcIg=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=dGbl67rB404T5JTHc2KDSjSDzsvvHKSFBLr0pj6B0XouESUdz4ilQ1cFrgSjGyz3w3TeGOzKdnFVb3cq8L4XbvA305lwBCWe/adDTRjoUMoYDK8VgbU7rTqfCI+leZBjmevsubsWP3I4Gxt0SV8QwVv0s0V9+AqU61+naxUscqI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nxp.com; spf=pass smtp.mailfrom=nxp.com; dkim=pass (2048-bit key) header.d=nxp.com header.i=@nxp.com header.b=BDT0XSNg; arc=fail smtp.client-ip=40.107.105.79
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nxp.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nxp.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nxp.com header.i=@nxp.com header.b="BDT0XSNg"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=W74Etc/dsIV19MsjDt1+mKywvf/1s5rkqjRvgwPdVlEVgfaWvFir3Cs48GXP/zZf2QWnNF+w06hYSyyJT5TMeeDWD7IYLvuV6orf6HiZuam6do1Zz2ln8N0ZG6EY4r+GqkbKrhY5ebLOsLO8znP1OvBVv04pULK3mhLYu76G5wRJq+mKyXJsA0yXaoJD+WUplnKphyMZy3gNxZ198BWjwQRfQ5VxYLAF1GWz6Y6J3buT0j30xdsZzj2oZXDfWn7IcAsxQwxHrMrpbV4nE8BwHo0F0+aMO8H+rH4HGKvjtXhgp9eJ3vtnm9J3CdfnImkF6sUWl75syCh3Jc6iLCr5oA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZYKpLaCroHoTrVUkjEPnz5nObOw0mNZbCVWkSoQPcIg=;
 b=d4pp1RbEopGxXpVaCKMf6bmH2HaH3iNW7fMiwHIpPUCxnqv6StdJ141Id1P3hXLUM95af6UgHU4+XGPvqCeJZ3WOnjsIxRyjatcYrWhVyw8I7WW6wfHU4h2l+lhwCAUacrRkYqh9ajU1F2RW31oeaIeJG4whBWGYTFO8IF2EMqkDh5hPtGcVywOobZ/LR6Z5r3IRdCIYiDyyAmAko9RbIwEReIwtfWfla/vy6ws7WnOrZrUBUsCyYP/Gn7rSyB4ykMg18ij3c/ngqE3svBCFbwUdvoHdDVDjZgxrwVTv7bCpRF7vwbAqfnwXZhaqGXmDBetco93iVlv4ilYhrMWa9g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZYKpLaCroHoTrVUkjEPnz5nObOw0mNZbCVWkSoQPcIg=;
 b=BDT0XSNgAbs4SU2yW2cXLE8LMNrAnQtwlIO+STGj0RS6WR4Vlu03tuzkrt7OIV+kvbGqz3/Wpc18KafdEoAZRiXWJ2G/BxmJ6uIa+WyHNHCweVHp1zvU2S3O+4bGuTffavR/Qhd9zmdWCbqqwuXhyQyxsQXV2VlsLWG+Qfz8N3cpcgz0tsIORsYhg4kf/zh6k3eR0NAIZgVNipONwomFwOPpHMdOpPH1UGoGTvyPLCoXXHz2rXd4rFlkH8I+WOemHdPJJRV8HK9I5qDoQhQ86Zo/mYPvz63ed1bcKcs9yJBaHo5hwRVE1rn0VM7AC91YFh81/c47EN741mgW//fl/g==
Received: from PA4PR04MB9709.eurprd04.prod.outlook.com (2603:10a6:102:26b::10)
 by PA4PR04MB7550.eurprd04.prod.outlook.com (2603:10a6:102:f0::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8158.17; Wed, 13 Nov
 2024 16:22:13 +0000
Received: from PA4PR04MB9709.eurprd04.prod.outlook.com
 ([fe80::1009:ebb:d7ae:4628]) by PA4PR04MB9709.eurprd04.prod.outlook.com
 ([fe80::1009:ebb:d7ae:4628%4]) with mapi id 15.20.8158.013; Wed, 13 Nov 2024
 16:22:12 +0000
From: Horia Geanta <horia.geanta@nxp.com>
To: Ahmad Fatoum <a.fatoum@pengutronix.de>, Gaurav Jain <gaurav.jain@nxp.com>,
	Pankaj Gupta <pankaj.gupta@nxp.com>, Herbert Xu
	<herbert@gondor.apana.org.au>, "David S . Miller" <davem@davemloft.net>,
	Silvano Di Ninno <silvano.dininno@nxp.com>, Varun Sethi <V.Sethi@nxp.com>,
	Meenakshi Aggarwal <meenakshi.aggarwal@nxp.com>, Sahil Malhotra
	<sahil.malhotra@nxp.com>, Nikolaus Voss <nikolaus.voss@haag-streit.com>
CC: "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Pengutronix
 Kernel Team <kernel@pengutronix.de>
Subject: Re: [PATCH] crypto: caam - use JobR's space to access page 0 regs
Thread-Topic: [PATCH] crypto: caam - use JobR's space to access page 0 regs
Thread-Index: AQHbNDRWBe8a/N7/eEOVxYOv+BiMZ7K1Z/oA
Date: Wed, 13 Nov 2024 16:22:12 +0000
Message-ID: <d3800aa8-dd28-43f7-ab80-339a978740dc@nxp.com>
References: <20241111121020.4013077-1-gaurav.jain@nxp.com>
 <93e915b3-ef8e-4b98-aa7f-7759ae0b3091@pengutronix.de>
In-Reply-To: <93e915b3-ef8e-4b98-aa7f-7759ae0b3091@pengutronix.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Mozilla Thunderbird
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PA4PR04MB9709:EE_|PA4PR04MB7550:EE_
x-ms-office365-filtering-correlation-id: cd3d6a99-a6d5-451f-d924-08dd03ff549e
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|366016|376014|1800799024|38070700018|921020;
x-microsoft-antispam-message-info:
 =?utf-8?B?WWowZzdPaS80OVc4NDVmaFNJbVV1TTg4TGpzbGkxVDdINHZuSk8yK0VKeVBV?=
 =?utf-8?B?eFhRS3k2anJFVld4c2tWU1RPaHhZMk8zNE9OWnZKV3JpeUtSUE1ZbXV1YmlX?=
 =?utf-8?B?NGdaVzgrbHRBVWdmaWFwdDJRZG1Vb2d3eDE1UWNKdXhzN1FxczRjdS85ajE5?=
 =?utf-8?B?QU1oU1A4eDhJdjY0dEh2Uk1yem1LdWx5cm95cEdYZ29CT3dWak5nTEdUTGNw?=
 =?utf-8?B?bnhHczZlSEFmTlRKRG5KeDdyZ0FpNFpvcm9Oc204dzIvVXl1ZnEyUjhhM25w?=
 =?utf-8?B?RFlpMEdubS9vV1M4U1VwT0xlaXB1RWVicFNtY1U4YWk0MFZJM1dJeW8zU0hO?=
 =?utf-8?B?ajNmZHE3NkVLQ0F6UGgzNjlyK0I5U2E4M2prclM4K0xiMC80MnlsNzJiQXRq?=
 =?utf-8?B?c1lWeWpUbkhvejY1eDRuc216REtQVVhNaHcrbzhkaC9FRHAvV1ZDRDlnc0xm?=
 =?utf-8?B?ZmhqZGIraTZMbStJKzlDc25QTzUrbmd2QmZxYld3YStXcEZNa3BXb3NFZ3hw?=
 =?utf-8?B?RDJHcHFMWnVxMUxpY1UwazREenl1ZzRsTFdiVHhuUDNjeFF2OFNwOGpTbGVX?=
 =?utf-8?B?UGZybUtyM3VGdXVabDF5b0x2MDR6d3gzbVQwNWYxbzhCWlVQZGoyMlVEL25k?=
 =?utf-8?B?MXBzVEpXUjFYRnN6Zm0vNFltWmtwLzIwakZHV1JyV054WFIrdVFRUW9aWHhH?=
 =?utf-8?B?NHVnL1dtU3ZMR0h2em1TMExFVDlYTU1hNnNnM2F0VlEyUUZZSDRQM1g5eDhN?=
 =?utf-8?B?T2ltZXp3UTFZQi9aZU44N043RkpBc3NJbS9BTEp6UjBsSG5IcEpzTUZwOXJk?=
 =?utf-8?B?QmVyejRPZmJLdlI2ODNIL1lHNFZRWC9PeXdLYVdJaUtlTFpQUG43Z3dvZEZi?=
 =?utf-8?B?cUY2M1lmN3JURTFXZUhURElCTE9SVXI2NytxanIzWG50TWRqNWJlV2tVejRo?=
 =?utf-8?B?L01hTjRrZnNuZi9IQnVvaFVoRFRnWGtQK0JsTEx1elNLRC96SkkxSTdsNmdQ?=
 =?utf-8?B?TTRJZmRhVW4rNStuUFNHWUR6dmwyL2k0Zis1aGJJTHhLWFR1UkhqN1R5K2FY?=
 =?utf-8?B?SzZMZHVDM0J0WEtpSVBVQWpWM0ZselNVeUYzSC9IR0lIOVRRVUYzSmlnMjY4?=
 =?utf-8?B?MVpIdnFUZWJkTXNtQVVRb0FCbmtGNXR3eEJDTElnb3VncHE5d0loc3hKdlFE?=
 =?utf-8?B?RVdpNUp6RG5MOVBnVzgzWlMxMHEydVBWN1Q2SXcya093cXc4Y2pLWVMzbi9p?=
 =?utf-8?B?NkU2QkpRaXJWczk2aEVLci9uQUhobHFBNThWTU8rQUdWbHhvWi91YjJTZVJu?=
 =?utf-8?B?TnM1ZS95bmVQcXFGZGVCV2E4N0l4aE9zc1RCODhLNUxTMmM5Y2I5TTNqR1g4?=
 =?utf-8?B?dGNJZzRpejBsYkRzR3BHNFdzVWVUUVVyTlE5aVJhUllNV3p4Y3RZWGVVYkRI?=
 =?utf-8?B?UEgxMXFGVmgrTjlaVVBFdXNlekNXNTh5Y05LZkdhUGIrbW5yYWlFbGR5dDBh?=
 =?utf-8?B?WG9aQ3VqQVgya1FhdFFuTkc1dlRXTngwMU1VeWJxQlZxaS9RdzFaRUwyM2pL?=
 =?utf-8?B?cXhkbFBWUVVrMVBJZGxQbnJxWmtETG1jMDZraFNRQnk4VU1rY1FsU1ZrdEQv?=
 =?utf-8?B?Z2cxVGF4K0tndDhUR1A4aFJuTUdGdW5Ga3RzZ2UzYlpsT3ZxUnpjR2h1bi8y?=
 =?utf-8?B?N0tBQVV6VUZTQWtoczhKcW9YbGE1V2svMXM4bVQvNjZBNzFzSU9sYTN2OVpY?=
 =?utf-8?B?Z2NoeFVHT0oyWUx1SjlmOG1HeU9weHczVHA2UnVSd0d5ODI1TFBna1drbXZ5?=
 =?utf-8?B?NHVENGZPL1d5MGtlZ2dhM01JYjhZNHJHZkhheXJlN1F3RnIzbllZZGpUajVh?=
 =?utf-8?Q?t8zMj2iqaV+hf?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PA4PR04MB9709.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(38070700018)(921020);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?ZG41NGs0Z2lqaDZ2bUlzUWtFUy9vdlRIZmU5WnpIaFQzaHIranlQeHVZb2ln?=
 =?utf-8?B?VExRb1NqbWJhZFBuTzJzaUV0bTM3aDAzS0JQRXJXNTk0OTU4MHFIcjRYUkQv?=
 =?utf-8?B?YjZwcm0vc0tFRnlrUkZ0RnY2UGxveEh4TS80RWJ1SVNRVlA3clN0QXVRTGNN?=
 =?utf-8?B?WmVhVkdnc28vQnlESWljSURnT1hIdGZEZkFyeURNRkswdjhVWFpmUXpocWoy?=
 =?utf-8?B?MzluVHQreDBjQzRjdXhOM01MOEJvYWhXWEQrbWlLRlM4dEpxY2N3TGhhbXZH?=
 =?utf-8?B?dGhCRENTYVl0ZDBBOTE0OU5kYmtzV1U2Z0x2dEU0TTdNM0tURWJYSmJpOEdR?=
 =?utf-8?B?aDBXSElGYzVtSGNPa2MreEVjRVJYaVNHdDBveFVhK1p6OGpodDBiN0kzR1NJ?=
 =?utf-8?B?RFdvNUpaUlBVWis3N1VqK0pqeUEvUjhoVUVzdk1XeEQrbHpzMG1SMXAvMDVz?=
 =?utf-8?B?aUFCOW04L3JmTnl5UnVSV1FrclBzWGRQSitCV0hRdThTb3pDbnFTdkwyVTV6?=
 =?utf-8?B?T1lpSHlZRWtPREpDZEdFdTR2SUVCcVJSdVR2d1lrTHlDUUN2TldySUlKenpr?=
 =?utf-8?B?NlREQklhWE9kTWwweElDdUZSeWtwWlNtK1FueXdNNVpBZDlIK1dPMXdvSzBk?=
 =?utf-8?B?aXB2V2VNenpER0hNWTE1QStoNnZRWTlNdGhLTEhJcHJWcktLM0I2L3hPU25P?=
 =?utf-8?B?SnVjdkJQYk5raENMb0hRNDJrWVE1OFdIS3Q5UVRmMTFZUzQ3TWo1cXVmeDha?=
 =?utf-8?B?U1BrSldxTWVCTHl3UnlBUGlOU3U5eDl4bzhxZlpwb3Z6YzAxdmZ0MDlad2dY?=
 =?utf-8?B?Z0xkWjcyM0xzMlFqQVZjd0NpQVpjSi84TFdsdVJVT3JOS2xjZUdta0Y5dFRw?=
 =?utf-8?B?SFFpVWwvbEE1aGlycDk3QndCYUltNDJNVExwSU50cktqR3BCYmkrNjJ6V09q?=
 =?utf-8?B?R2ExZFFzTVFZY1dYNVlDMzRaaWRxbnRKT2ZxdXlzSVZvOGxnd3FEeHFqbGRZ?=
 =?utf-8?B?THZLblZ6WnJlZFVmekZ2dVc1dGJtZGtjQzJuSTAwZHBadTMwWndGZElPQlRv?=
 =?utf-8?B?NVFVbXI0YUtnRHJXZi9ZVXJDUG14MEVBN21rVEhxYjlCejVFbnhQVEtVaW9F?=
 =?utf-8?B?cWdnSENqVW1XMzhTZ1BXR0hlSFI2a2M2SXR3cWFYQkE2TGZUdW9UMm85TDVE?=
 =?utf-8?B?RWFxOVdEeGpTWHZTL2J0M21GdkdVZDJlSklJUTE0L0Vycy9haTNVaGJ5TlVK?=
 =?utf-8?B?N0tlYjczU2hNTkU0VENmaVlZakJESklLYng0NGR5UWtxZ2EvRmtkZmN4NWRm?=
 =?utf-8?B?R0E3WnNVNmRybEFmK3F0dU1hSGVuVS9VSkpwMTR0ZzM2akZtVmhzaERVV2ha?=
 =?utf-8?B?NDloMm5CdUIrSXF2S0Q3MXoxMmp6bGJIZkE4SHNTcERKK2s4L3J3QXJpNHk0?=
 =?utf-8?B?SkVEVkZ1dXlKeUcySy9PMWZySnFlc2gxaGFybFRoZk5MZFI2NlJrck8rVXBy?=
 =?utf-8?B?WjIySmdhTk1FU0t1SlBzcGVLM0hHRlRhRUJ4dU9NdEoxN2JnLzdCb3hMeXV0?=
 =?utf-8?B?NWVic2JRMStaTUM4clVJckVjWElLNm5Mc3NMM2IxUUZDSFk3VUR1Mm5BUXVP?=
 =?utf-8?B?Q3BaYkhWTnZ3QXFlbXFkWlZBZllETDlKdTd5czNWckdLV09kWGtUTGJ3NTlL?=
 =?utf-8?B?QkVFYjdBVlRjR2Zwa3BwcGRMeWcyYysrdjB0b2Y1OWxCK3NMR2tzTzY3Ylhw?=
 =?utf-8?B?blU0MFR0SkpCVS9wQlRxOGdSaFNES0Q4Z2lHbXdNWlZ3N0ZORlczdzhNc2tY?=
 =?utf-8?B?NEZ5QURQYTd5cTdDR2hRanlhY0xmTVJ5bXU1MEw5c0FzcUE1SnpPQ0FOUnhQ?=
 =?utf-8?B?Mjc3MzN5NWVrTFB6V3lwdUVlVDhqYXdyRDVFWGduUlExZUhMVHUyb01Qb0RX?=
 =?utf-8?B?eHJnR0tOWEdFamJRQjNVMUxhVUFxaERyQWVnUXhwSkF6RkEyNFIxRlZ6bVBR?=
 =?utf-8?B?SWhhcW9wVmRpZFNycDJwdEhod1JXamJNZ2ZGQWJ1VEMyZGRGd1dqL1pBMkxo?=
 =?utf-8?B?VVo5b3NTRThmTzJlYi84L0pTdHV4Rm8va2hHQmttNU1DS2hqTmJPbGhmSDFT?=
 =?utf-8?B?cnpKVzdFd0NMOFkrT25JeURvRXA2VERicThtbzRLUU0wV3FibTVxZXFCelow?=
 =?utf-8?B?Ync9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <67A4500D7D0D474BB3F504F470A7BFCB@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PA4PR04MB9709.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cd3d6a99-a6d5-451f-d924-08dd03ff549e
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Nov 2024 16:22:12.7317
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: C7R+l5Qevg/n+2ub0/rjgVVnN4C8N5GUsOKhzG8xIW5KpiSwEVa2PRJH7ar/DfQpwLTJ3F1LOCxscJABt1nnQA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PA4PR04MB7550

T24gMTEvMTEvMjAyNCAyOjIyIFBNLCBBaG1hZCBGYXRvdW0gd3JvdGU6DQo+IEhlbGxvIEd1YXJh
diwNCj4gDQo+IFRoYW5rcyBmb3IgeW91ciBwYXRjaC4NCj4gDQo+IE9uIDExLjExLjI0IDEzOjEw
LCBHYXVyYXYgSmFpbiB3cm90ZToNClsuLi5dDQo+PiAgI2RlZmluZSBwcl9mbXQoZm10KSAiY2Fh
bSBibG9iX2dlbjogIiBmbXQNCj4+IEBAIC0xMDQsNyArMTA1LDcgQEAgaW50IGNhYW1fcHJvY2Vz
c19ibG9iKHN0cnVjdCBjYWFtX2Jsb2JfcHJpdiAqcHJpdiwNCj4+ICAJfQ0KPj4gIA0KPj4gIAlj
dHJscHJpdiA9IGRldl9nZXRfZHJ2ZGF0YShqcmRldi0+cGFyZW50KTsNCj4+IC0JbW9vID0gRklF
TERfR0VUKENTVEFfTU9PLCByZF9yZWczMigmY3RybHByaXYtPmN0cmwtPnBlcmZtb24uc3RhdHVz
KSk7DQo+PiArCW1vbyA9IEZJRUxEX0dFVChDU1RBX01PTywgcmRfcmVnMzIoJmN0cmxwcml2LT5q
clswXS0+cGVyZm1vbi5zdGF0dXMpKTsNCj4gDQo+IEkgYmVsaWV2ZSB5b3VyIGNoYW5nZSBpcyBj
b3JyZWN0LCBidXQgSSB3b3VsZCBwcmVmZXIgdGhhdCBjdHJscHJpdiBnZXRzIGEgcGVyZm1vbg0K
PiBtZW1iZXIgdGhhdCBpcyBpbml0aWFsaXplZCBpbiBjYWFtX3Byb2JlIHRvIGVpdGhlciAmY3Ry
bHByaXYtPmN0cmwtPnBlcmZtb24uc3RhdHVzDQo+IG9yICZjdHJscHJpdi0+anJbMF0tPnBlcmZt
b24uc3RhdHVzIGFuZCB0aGVuIHRoZSBjb2RlIGhlcmUgd291bGQganVzdCB1c2UNCj4gJmN0cmxw
cml2LT5wZXJmbW9uLT5zdGF0dXMuDQo+IA0KPiBUaGlzIHdvdWxkIHNpbXBsaWZ5IGNvZGUgbm90
IG9ubHkgaGVyZSwgYnV0IGFsc28gaW4gY2FhbV9jdHJsX3JuZ19pbml0Lg0KPiANCkFncmVlLg0K
QnV0IG1heWJlIHRoaXMgcmVmYWN0b3JpbmcgZGVzZXJ2ZXMgYSBzZXBhcmF0ZSBwYXRjaCwgZ2l2
ZW4gdGhhdCBpcyBzaG91bGQgYWxzbw0KY292ZXIgdGhlIGNhc2Ugd2hlbiB0aGUgSm9iIFJpbmcg
ZGV2aWNlIGNvcnJlc3BvbmRpbmcgdG8gImN0cmxwcml2LT5qclswXSINCmlzIHVuYm91bmRlZCBm
cm9tIHRoZSBkcml2ZXIuDQoNClRoYW5rcywNCkhvcmlhDQoNCg==
