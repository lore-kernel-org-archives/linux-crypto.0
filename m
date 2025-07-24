Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2052.outbound.protection.outlook.com [40.107.243.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 410F621D5BC;
	Thu, 24 Jul 2025 08:04:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.243.52
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753344302; cv=fail; b=AInpbdlJAUIJ3/RNK+DMK66CiNByOdzheOtjuLhn1suFvexQccGQ2WigHQ9Oe2a9iKwYVN9Sp9r9BboDrIwp/pxOAFUNQKbjQaMmW11CASfbRTr930rMNUYA0rv4b3fanvF9EQDb+jhMPocOam3TVQHqzbiQrOd5J7DZB5XjZkA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753344302; c=relaxed/simple;
	bh=VaHNKRweyu3M1CrYXSU6rdHqu+77bHUQvTolAnccKjY=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=uSvoAnUMcnI3gdXc16bOScPBJ6FawqYL7LW47nU/Xid3To5kWbQDVlwfYUSUcSvPOnIi7hhqyeWGbypS1mLCOTk4OrAPbzuvLrEfYGq5riko+aUyRFC5+/FkkDOAvxoyB+iWJ8J4vrGjFjVTx41neFugVJ9e6wgAEj5yNL4hMVA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=n9HDdTtA; arc=fail smtp.client-ip=40.107.243.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="n9HDdTtA"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=tmmPOw5FWZyhkMKfLh9d1RFQjAhFYv6/YkQb0qwKQk2QiVMOkz1I5MNuzJtspWHWgZGFEl7aTyIowzzRagnfLCZO8v8q95nhHeZVSQ1GsOfh7o8QOgevO2TQFklODXRTEt+LqSuIHnxXh3laoeMcGZvow4hy4wL3OTFLOwcFAOGEmmG6S1a2jm/evRuMIyWmBdyE0AOrsslaiQlsQIkmxEaqU0h4WjWt985RK5Tr9zD5bmVugFyAbKF/8WR9KlcTukAHPkFYJ9jom8pmtEjH8kVvAH4H35AR2lPIX/jUhGwHf4rXEzIvOe7cVvGl6uXUnrhzPi1Cl6dO/BQfal6rDg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VaHNKRweyu3M1CrYXSU6rdHqu+77bHUQvTolAnccKjY=;
 b=s7ThXGXXHflkaNDcfdlPcSu/e4IY/OLrVW0e0lXGPGnxxHhMLeoC6W5W0HPo5hTZEUkSYXPZws1D+bPOp5G3LTfMovXssR9nycqe9IgVHr6ejV3YsYO+9szxylGPIZFSKa8sCf6x7T4BrrmaiVVSTCg3lM4g1rvq481yUhrIHhAWVBtV115MjPRxGYPZgjDyiHCA+dQ+7X3tV3o5Wnf3CbeicK0VZ/nmxR/lW9Amys5UwcLziNSUFK2AdhA13kxpVK+Lh9yJ7HIWuPVQoFtTo0+qAgyDdcbFUoo2aMO8oP+6eAExa9+CFEwcB8NCDPwV0kQbwvW1nOxGcCc/DeRLdQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VaHNKRweyu3M1CrYXSU6rdHqu+77bHUQvTolAnccKjY=;
 b=n9HDdTtASrbA4yR+kLHwWB7YznZ5oWfmlLT/dr6R9jFWhnMK3KIyr7/HLaanxVy5FPlJzgX/79DfRqiRGBhTMqM7BM0HHjd/uNH1oc0miKdbKXCuOlWKQIUVzp90SlDeTIkP5b7eLXeUbf+qqgkXf9zmvru5Tdl1X+bYq69US2c=
Received: from DS0PR12MB9345.namprd12.prod.outlook.com (2603:10b6:8:1a9::10)
 by PH7PR12MB6785.namprd12.prod.outlook.com (2603:10b6:510:1ab::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8901.37; Thu, 24 Jul
 2025 08:04:56 +0000
Received: from DS0PR12MB9345.namprd12.prod.outlook.com
 ([fe80::65ab:d63c:7341:edbb]) by DS0PR12MB9345.namprd12.prod.outlook.com
 ([fe80::65ab:d63c:7341:edbb%6]) with mapi id 15.20.8964.019; Thu, 24 Jul 2025
 08:04:55 +0000
From: "Jain, Harsh (AECG-SSW)" <h.jain@amd.com>
To: Krzysztof Kozlowski <krzk@kernel.org>, "herbert@gondor.apana.org.au"
	<herbert@gondor.apana.org.au>, "davem@davemloft.net" <davem@davemloft.net>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	"devicetree@vger.kernel.org" <devicetree@vger.kernel.org>, "Botcha, Mounika"
	<Mounika.Botcha@amd.com>, "Savitala, Sarat Chand"
	<sarat.chand.savitala@amd.com>, "Dhanawade, Mohan" <mohan.dhanawade@amd.com>,
	"Simek, Michal" <michal.simek@amd.com>, "smueller@chronox.de"
	<smueller@chronox.de>, "robh@kernel.org" <robh@kernel.org>,
	"krzk+dt@kernel.org" <krzk+dt@kernel.org>, "conor+dt@kernel.org"
	<conor+dt@kernel.org>
CC: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Subject: RE: [PATCH v4 1/3] dt-bindings: crypto: Add node for True Random
 Number Generator
Thread-Topic: [PATCH v4 1/3] dt-bindings: crypto: Add node for True Random
 Number Generator
Thread-Index: AQHb+/7BMgSKAU2by0u5lD59rEtzcLRA3zkAgAALI+A=
Date: Thu, 24 Jul 2025 08:04:55 +0000
Message-ID:
 <DS0PR12MB9345EDA907BB0438C32EF12F975EA@DS0PR12MB9345.namprd12.prod.outlook.com>
References: <20250723182110.249547-1-h.jain@amd.com>
 <20250723182110.249547-2-h.jain@amd.com>
 <a350e9b6-9bbe-4045-8d9c-e3886b758a99@kernel.org>
In-Reply-To: <a350e9b6-9bbe-4045-8d9c-e3886b758a99@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
msip_labels:
 MSIP_Label_dce362fe-1558-4fb5-9f64-8a6240d76441_Enabled=True;MSIP_Label_dce362fe-1558-4fb5-9f64-8a6240d76441_SiteId=3dd8961f-e488-4e60-8e11-a82d994e183d;MSIP_Label_dce362fe-1558-4fb5-9f64-8a6240d76441_SetDate=2025-07-24T08:01:35.0000000Z;MSIP_Label_dce362fe-1558-4fb5-9f64-8a6240d76441_Name=AMD
 Internal Distribution
 Only;MSIP_Label_dce362fe-1558-4fb5-9f64-8a6240d76441_ContentBits=3;MSIP_Label_dce362fe-1558-4fb5-9f64-8a6240d76441_Method=Standard
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DS0PR12MB9345:EE_|PH7PR12MB6785:EE_
x-ms-office365-filtering-correlation-id: 29225009-bf25-4f53-7d63-08ddca88c6c3
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|366016|7416014|376014|1800799024|38070700018|921020;
x-microsoft-antispam-message-info:
 =?utf-8?B?cnpJMmRESmlBVW5sSGVjZDMrdzFXYXJLRHlyL1RLUWVXb1NwMWtINmlITG1v?=
 =?utf-8?B?Q2xDYndibk5PS054Z1VtbnhuTFcrUnlMQ1VWOXZRV0l3aXg2TGJmN3YzeU11?=
 =?utf-8?B?L2ovZmlQWXBqK1Z0MjhNTnE3Tks2OEpGeUFrMENKbkJYM2JWQW80L0NpQjlQ?=
 =?utf-8?B?OFRZWVdqTUhZVE0vNWZSSWNLaUcrdVlqa3RCbkdHdXNhS09zaFlQSUhDRUMr?=
 =?utf-8?B?OUZuV2VFeS82MHVvemJ2K2JzNjJVRGp0YklXS2xhbUppRmUzcE9OS1REQjFy?=
 =?utf-8?B?eWs0OHVidXJlbkppVElSc2Fnbm5yQWtkT0dqbEwxZUpYZkduL2NoT1UrbHJs?=
 =?utf-8?B?Ny9iNFhpTk9aSWt2Sm9JSkh6cGRtQlY3Q0VZMlJvRmNVZ24xbUJkaktzL09X?=
 =?utf-8?B?SUlqNm5BMjFQb05nYzJtOElYMVlFQjBFVVY3WTFmRjd5cFpMclFFS0UrM1VP?=
 =?utf-8?B?SnlVZm9lclRKV2FEZzBpQ1AzTjYwWHJ6K0YyckQ5WSt3QkdSV3RBTHY4VUNZ?=
 =?utf-8?B?dllIeDhnWEpWTkFyNWFYYm4vWnhENlZYM1E4TU5LZ3RyRTk1U1UyVFF1NjlC?=
 =?utf-8?B?anpqS25qcmo4Tk5HYnJobDNWbmpjdm5OclNOa3BJaEdLbGw5azZCYlJYYkVF?=
 =?utf-8?B?NVZsTVZUUEtJMTgxU0kwaldZNjRxTTJJdjZQVk5NUTBobjBuaWhIVWVES2hS?=
 =?utf-8?B?S0JrdmxOVmE3SkVwMGxHSm1RTUZUU3RPNGQ3cFRrNk1CNk5DWXFZcUpOemEy?=
 =?utf-8?B?SjFGRVNwK1BDWWhLQVlNcjROc1pYOTM3WXM5QktPczhDZW1nODdqSEx6eDlK?=
 =?utf-8?B?QzlKOFBVaEU2UEl5K1lNQzBXZzBqOHBHK2RHQUZPL084THo2bnBXS0Q4eDRP?=
 =?utf-8?B?ZmU3T2JhTDJRdnFUU2srSmIwdk9yTmxzd0hYbG9Vd3JHYkxyd042Z0lrdnBF?=
 =?utf-8?B?cFduRGJ1aTB3VTdNLzJDUFNGMjYwQXBKaHAvcU5aMitUY1plSFFjZ20yaFNa?=
 =?utf-8?B?SWMva0JLYWhoczBubGFWVEVVM2V3YmFGemhBbXRJTVl6cHd1RmJMcXo2RDBP?=
 =?utf-8?B?L2dITytTT3VNdjF4NUw5K3J3Z2tNNnlJT21McTlaVURxZFJYVUUxcFFzY0NL?=
 =?utf-8?B?dytBNjBqN29WRmFsUTdNdTFHZFlPSnpjM1RtZklGQWQreEp3Ty84UDFSTkZy?=
 =?utf-8?B?YlkxN1cwWEV1VjVjRHhadkY5ZUc0N2NLS1VHYU4zem12VStVdGJFNkhnczRV?=
 =?utf-8?B?Q3ZzVzNPYWNsbkxlajU1Zy8zdzB0andQaEcyYmprdDYrSHY2YzVTM2MxVG1s?=
 =?utf-8?B?OGdLUkVHNEl5T0IwSnNHd21WYUw0R3hpcDFmOTZETm83RzJCd1dQNGdyT1Ax?=
 =?utf-8?B?M1JJVjRFVVFPMjZMc3kwWGY5dnllVk9KWWdvQndQRFQ0VUw5V0x6NS84eTNC?=
 =?utf-8?B?bXQ3S0tyV1p2dGNjUGIvNU05QXpsMHhLTlo0MXc2RXpSVktLM2dvc2M2TC9L?=
 =?utf-8?B?TDB5bzRYdnV1MkxKdXoyVjRhci93WUQzbllYbFJyMUdWT05LT1NCdmllR2xI?=
 =?utf-8?B?NlhrUWNSOEUzc3kxN1hiVnN6ZG5naUZQSUswMXJ1Ti96S093RlA0WHIyZzhW?=
 =?utf-8?B?UEhSS0l5LzhvVGtxUlo3R3NrcnhIMTNqbHVTODRFSUV6RlFtdWVGeVN3S0Nt?=
 =?utf-8?B?dGlPWXM5L3BUajN2OHpJTC9sdHR6VW0rTk9XeGlycm5DTERVZEJrQ2Y4WFFi?=
 =?utf-8?B?ZC9HSm1VNW9mUmlVUnBUa2hMdTNmODhhZEYxSjNFV1NOcmlQQVU0ejNrMUtF?=
 =?utf-8?B?a1daRnAzalBLc1pTZUlWSUJjbU4zTGVSb0NpRWprYlpGNXV2TzNVbWFWM05i?=
 =?utf-8?B?V2JhazVJTnc3SzRMVDdEbkpveWhMK1AySnFCTmFCQnNNMzl0eDVIN2dwVFAv?=
 =?utf-8?B?eG9UdzJBWVN4ZzdESHFURnJxK3h1U2N0VkY4OHZDZHpzNjFNQXRBeTVKdGEv?=
 =?utf-8?B?MHEzSVRHdGczZWc3enhzQ1Bjb3VGV3Q5VTVrN3ZMRDVuNUtib2QyaVRnWWg1?=
 =?utf-8?Q?xwluV+?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR12MB9345.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024)(38070700018)(921020);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?TEdrbXBFRTFET0MrYWRBVmdKbmZKODRLVmdjbGI0UzkrK0YxWGt0azN0Vm5r?=
 =?utf-8?B?TmlSWEtGblVmcTVHeFppK0g4ZkVtaGN3TnYvNWpQWjZ5YktKNVd3UldlcWhM?=
 =?utf-8?B?Qnl4aU9wb204WE9wdURLVlZwaWtQY1BUNGlIdEtLanBVL0lHMG9ialpVWFpW?=
 =?utf-8?B?VE1mQVR2VTNNYTJjbEU5R1RJOHF5SFdFRlB5MlhrRmVwajJTR3h0M2l4cUx3?=
 =?utf-8?B?cjdUNHRLTEh0N2daQkxkNFM5Uk82R2hUQUlHM2FDd3FJSXlCNWQrVlpSd0cr?=
 =?utf-8?B?eWkzaS9yYXZuK1hRTlBycnFYS2pOaUh2bnRZdjYvSGVKTXJZQ2RaTzlwcElF?=
 =?utf-8?B?VlQ1dERmczZWZnNwd1MzMHNuTHRXeStkdDZwU05iTUZRbHdIa25ra25jQkty?=
 =?utf-8?B?MnRWbkE3UDJDb1JNNUQrOTlLeTVXdlpmRHZDNXFnV1F4QkxIZkNaN1Rub29q?=
 =?utf-8?B?b1h6WjQ4VVNha1hZcHlIYTBTdHRoL1AwYjFNWlhsa2FxbVhDYWtaZ0NIVVUr?=
 =?utf-8?B?Q1Vha1ZrL3V3Y0hGN2QrK3lOWGJJeWxkdUU4Nm1aL2E1cFJFb3hQS3BNR05D?=
 =?utf-8?B?dEU2alFaeXc5eFpCM05sTWNGL3kzV1lMTlUxZkpGZitacWZ3WFZRdnp1dUxB?=
 =?utf-8?B?TllVRnZPWkl6L2RlMktheE5jaE54TFdsNGJBajVjWXd1RnRWd29jbWx5OWpm?=
 =?utf-8?B?S1ZNQUk3Ri85a05zck1La1lEczVQdWhHbmVJTDlEY29ablpPcjdweGVmWk9F?=
 =?utf-8?B?ektrbHBoOGhMS2dFUUJZMTFwelkxazcremxCSFVmaTdpQlUzeXpiTG9zVVdN?=
 =?utf-8?B?MnNuVUN1L24rL2JHbG5tMEtDZ0p0eU1WWGJoWVlHSUhCTHdQSlN4ZG5wM2p3?=
 =?utf-8?B?U2hkQ0NoSkRJR3BuT0s0N0JsMHBQVDlaMHVxODJ5V3BFeGlSWnRtWDc3clQ1?=
 =?utf-8?B?aEgxUXZJQ3pOSFQrcE1vdU4ydGxaRWF0dHFPa2FyMjB3Q3lDN1BPVlpMckNo?=
 =?utf-8?B?ZGo4TmMyRmphcUh4ZHpjaElzREw1TFJEQXpyaFh1UDJVeU9KUTc3bEJKRlor?=
 =?utf-8?B?TEJDR3VmaEl0YmxZVTZSRmJzd3o4Mk9BVlBlUlJ6Nm9kY1M2N09LNU5WSXBE?=
 =?utf-8?B?ejJMTmxVejcrMDB3VUpmbWJFMEcrdTJPMnllaVQwN2p1bXB4YWxTdHVzWU9s?=
 =?utf-8?B?OTBVNkxLeDdhVnBlT1AxUkh0ZzFaMkZYWmlKTU42cWlDcEExM2dpZjQrYmpH?=
 =?utf-8?B?WnZtb2J4Qi9hQ2NxRlBVSHBxYlczdnhGRDR2U1ZZQU5NQ3lNUHVDOFdUTHVu?=
 =?utf-8?B?b2JOMTJPK1pFVkxqd2xtZUFRb0w2b3lrd1NheHluNlR3a1RjY043NkhYSnFR?=
 =?utf-8?B?cTZwT2FRaktyMXdQUVVERFdoY2laUFVSQjFOREVlMTJZTk9PZk1zL0k3V1pp?=
 =?utf-8?B?ZDlPQ09qY201ZVNPQkNWWTJxeklJUVdRWGdWaDB5c3dPQXZaL1FJRVlvVmM1?=
 =?utf-8?B?NGtkNzBqZGV4aWNEUkx4cGpqUXFsbDU5NmNhWCsvVllGNmNrczl3aGI1R0JQ?=
 =?utf-8?B?RERDN1lmblJpdWM3NHdkdmYrTldIdHVQN0ZIYWQrNlo3dnExUldtOThXVzgx?=
 =?utf-8?B?ekNJU0pjWFVvc3hpREh0TndTM0NWY2gvazRURjF5UDcxWTRjZXdNTmZyZHNV?=
 =?utf-8?B?VmJkTVJ6MGZQdXdhVFBkdDAxQzBNZkpvcnkvODJuYkRYTmp2TEU2aWZ5SS9m?=
 =?utf-8?B?K2JxeVhGcHNJRnp3akZPdklhRmY3cTlueUVQcjJQbmNIMTRqeGNNOEw3RzA3?=
 =?utf-8?B?NGs0aENVM1ZYMUdUUWVvVGwvd1puaHpTZGFrRG9QTVo0YXg3UkFkZ3ExaDhQ?=
 =?utf-8?B?dlRVaTlvS01ETDQxaXFRbXNyLzZXbXBOOCtuREhxQWFlN1lPT0Q3ZldnOEU1?=
 =?utf-8?B?U1VHb3VYU1RVMUFZR1MzaGJpVm16Njg3c3l5UmdwT1YzYkltTVByQzE5NHB5?=
 =?utf-8?B?OTQ4Z0ZHUEgrUEY0RitOOHp6SzN0d0d1Tlhmd1pIQ1BqZTRJb29yRDJlSjFy?=
 =?utf-8?B?WEVrNWJRUURUenFDRUN6RDJ0USsvZ0Y3cjVqYi9pOXp0S1FjZE11b3FQb1Qx?=
 =?utf-8?Q?0thw=3D?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DS0PR12MB9345.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 29225009-bf25-4f53-7d63-08ddca88c6c3
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Jul 2025 08:04:55.5071
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: JraXtadP5zgB3fhHBggpnumge60xCzdLrGW/OovM77TTuvwY6t3As9FRZIgRtcpD
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB6785

W0FNRCBPZmZpY2lhbCBVc2UgT25seSAtIEFNRCBJbnRlcm5hbCBEaXN0cmlidXRpb24gT25seV0N
Cg0KPiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiBGcm9tOiBLcnp5c3p0b2YgS296bG93
c2tpIDxrcnprQGtlcm5lbC5vcmc+DQo+IFNlbnQ6IFRodXJzZGF5LCBKdWx5IDI0LCAyMDI1IDEy
OjUyIFBNDQo+IFRvOiBKYWluLCBIYXJzaCAoQUVDRy1TU1cpIDxoLmphaW5AYW1kLmNvbT47IGhl
cmJlcnRAZ29uZG9yLmFwYW5hLm9yZy5hdTsNCj4gZGF2ZW1AZGF2ZW1sb2Z0Lm5ldDsgbGludXgt
Y3J5cHRvQHZnZXIua2VybmVsLm9yZzsgZGV2aWNldHJlZUB2Z2VyLmtlcm5lbC5vcmc7DQo+IEJv
dGNoYSwgTW91bmlrYSA8TW91bmlrYS5Cb3RjaGFAYW1kLmNvbT47IFNhdml0YWxhLCBTYXJhdCBD
aGFuZA0KPiA8c2FyYXQuY2hhbmQuc2F2aXRhbGFAYW1kLmNvbT47IERoYW5hd2FkZSwgTW9oYW4N
Cj4gPG1vaGFuLmRoYW5hd2FkZUBhbWQuY29tPjsgU2ltZWssIE1pY2hhbCA8bWljaGFsLnNpbWVr
QGFtZC5jb20+Ow0KPiBzbXVlbGxlckBjaHJvbm94LmRlOyByb2JoQGtlcm5lbC5vcmc7IGtyemsr
ZHRAa2VybmVsLm9yZzsgY29ub3IrZHRAa2VybmVsLm9yZw0KPiBDYzogS3J6eXN6dG9mIEtvemxv
d3NraSA8a3J6eXN6dG9mLmtvemxvd3NraUBsaW5hcm8ub3JnPg0KPiBTdWJqZWN0OiBSZTogW1BB
VENIIHY0IDEvM10gZHQtYmluZGluZ3M6IGNyeXB0bzogQWRkIG5vZGUgZm9yIFRydWUgUmFuZG9t
DQo+IE51bWJlciBHZW5lcmF0b3INCj4NCj4gQ2F1dGlvbjogVGhpcyBtZXNzYWdlIG9yaWdpbmF0
ZWQgZnJvbSBhbiBFeHRlcm5hbCBTb3VyY2UuIFVzZSBwcm9wZXIgY2F1dGlvbg0KPiB3aGVuIG9w
ZW5pbmcgYXR0YWNobWVudHMsIGNsaWNraW5nIGxpbmtzLCBvciByZXNwb25kaW5nLg0KPg0KPg0K
PiBPbiAyMy8wNy8yMDI1IDIwOjIxLCBIYXJzaCBKYWluIHdyb3RlOg0KPiA+IEZyb206IE1vdW5p
a2EgQm90Y2hhIDxtb3VuaWthLmJvdGNoYUBhbWQuY29tPg0KPiA+DQo+ID4gQWRkIFRSTkcgbm9k
ZSBjb21wYXRpYmxlIHN0cmluZyBhbmQgcmVnIHByb3Blcml0aWVzLg0KPiA+DQo+ID4gUmV2aWV3
ZWQtYnk6IEtyenlzenRvZiBLb3psb3dza2kgPGtyenlzenRvZi5rb3psb3dza2lAbGluYXJvLm9y
Zz4NCj4NCj4gV2h5IGRpZCB5b3UgcGxhY2VkIG15IHRhZyBoZXJlPw0KDQpZb3Ugc2hhcmVkIFJl
dmlld2VkLWJ5IG9uIHYzLiBJdOKAmXMgdGhlIHNhbWUgcGF0Y2guIElzbid0IEkgYW0gc3VwcG9z
ZWQgdG8gYWRkIGl0IGluIHN1YnNlcXVlbnQgcGF0Y2hlcyBpZiB0aGVyZSBpcyBub3QgY2hhbmdl
Pw0KDQpodHRwczovL2xvcmUua2VybmVsLm9yZy9saW51eC1jcnlwdG8vMjAyNTA2MTctcmF0aW9u
YWwtYmVuaWduLXdvb2RwZWNrZXItNmVlMzFhQGt1b2thLw0KDQo+DQo+ID4gU2lnbmVkLW9mZi1i
eTogTW91bmlrYSBCb3RjaGEgPG1vdW5pa2EuYm90Y2hhQGFtZC5jb20+DQo+ID4gU2lnbmVkLW9m
Zi1ieTogSGFyc2ggSmFpbiA8aC5qYWluQGFtZC5jb20+DQo+DQo+IFdobyByZWNlaXZlZCB0aGUg
dGFnPyBXaGVuIHdhcyB0aGUgcGF0Y2ggcHJlcGFyZWQ/DQoNCkRpZCBJIG1pc3NlZCBzb21ldGhp
bmcgaGVyZT8NCg0KPg0KPiBCZXN0IHJlZ2FyZHMsDQo+IEtyenlzenRvZg0K
