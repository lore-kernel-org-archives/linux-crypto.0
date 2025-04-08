Received: from EUR03-DBA-obe.outbound.protection.outlook.com (mail-dbaeur03on2049.outbound.protection.outlook.com [40.107.104.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C03F025FA26;
	Tue,  8 Apr 2025 08:00:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.104.49
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744099205; cv=fail; b=Q9CveZne56SarNsmI/YUhb/gNdgrNI1q0291JB7lfucbh+3SaE0U61MI1QOOOiYZsDxBQ0lWHtE4CcMLXbEQrEGQdH78i5/vs2bHwwP6oSSfrBgH+FXOjfl+MimDjkYp9ViiR50AI+ieAWH4B5yj58SXPtfdR3LhLhIdmZKiS4o=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744099205; c=relaxed/simple;
	bh=+pnucCEilWu6gZ0fWxSJj2QQMT7ziiDj4aQgKPHkMAI=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=Qef4AWtsVi6aNWSmJ+GodMD3WYoV4eiBD3VYFIUKwSQiueusaYZEJj3oLlrS7Fkf6/CMTTq4LUObA6TQBfIVwXPT6tZy+LpeSoe2/3CT8p9QB4EtRBOMUslkOmxLt5k86AwiR4F+N4+fcoUZOsUto9ae8YJwewOY86ffaoRM7yA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nxp.com; spf=pass smtp.mailfrom=nxp.com; dkim=pass (2048-bit key) header.d=nxp.com header.i=@nxp.com header.b=IB8L9ZAV; arc=fail smtp.client-ip=40.107.104.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nxp.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nxp.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nxp.com header.i=@nxp.com header.b="IB8L9ZAV"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=UnBy7oQ16H0zTne9EQqsA3zuxQGH0OUO/8cuynqd2Z9LFfyqg1N5OXi8oo2h2HWM4AbAKFJGl/TIG9QFSJgn/kfxZF0AqC4HNWh8k2Xzv4OywUTEqY8WghpX6bz8udXvrnmLxiMfCWwDiCtAWesNIv0/UkDwJfjmGfGwOvQyw+b3kXn9uesqPdbTDp7ONkmI+tDk7+ean5fiXgIn3mhdyVpeOJIEZ6K7kedicbDdjwk2YOyNGofNb+WEDPY4tGOVpd6vHil5DQDM1ZGfWQsXFdjXYc+u00G6ctKvJtepM2hRDaAJ7zixKwYneQ0pZusCNqWn52xZEwsP7FIPcOHeJw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+pnucCEilWu6gZ0fWxSJj2QQMT7ziiDj4aQgKPHkMAI=;
 b=XHbU1W7PcCjRU3lVTdJ8fVTSbkhz4ISAmbm0XIHiRogpQZ22g5SAdvIUoAL/fDgpjTan8iM9XWgFgWm4IY/k2G9evr8B3sRYmSfeJ5vg/hTRwhQNNejbJa00OGC2q+hRaCjzUEHpoXFyVzjPKXoqmOMT3VR0Isc544o8Kh38ZA5QrcbywGnag2auwcF3/9xK61ZaKDDjjVGN4EjIgWKIWoBDGubD5lKGu1z+VRyXrWgBZlUZ8eulSKi/WOSYHGqNluc/TXMpUroBXSn9QpEuBlNrLHUXKhFNsIiaGho3Y+OkErfOY20XEz3JUGLUETT5n3wgxtN4g90IFUGzt3XQ+A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+pnucCEilWu6gZ0fWxSJj2QQMT7ziiDj4aQgKPHkMAI=;
 b=IB8L9ZAVuvm07vpohomRvtyXs3z+96gjVzD7FAdZYgD9TIyKdUnrU61aHsf63fVIypLhkbIsRBDSuCsjgEf8n8O6e2WnRW4NkfAa0vrUObZ1YDRJ5S5m0yBuy1OdVYJ+zqOXgDybD44Np5DVaVVTS0veDh7dorTLJgGAXbCwmH0PuJTdLigrbLLyW57a9w3eFSOFO/Q2p9WcoHCpPOntIxQZti6nwKBGbxntHUsdDCmfQnaB9+XyKkR/obnnTb/MbnKXPGFvE6I5WQ+wEDF+ygdZ/d+mpnA6i1sejbbi/TZQ/pGdtPgSm6uBZ8qvQsw5AlLWiUvknizWoD6xs8sgUw==
Received: from PA4PR04MB9709.eurprd04.prod.outlook.com (2603:10a6:102:26b::10)
 by AS8PR04MB9191.eurprd04.prod.outlook.com (2603:10a6:20b:44e::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8606.34; Tue, 8 Apr
 2025 07:59:58 +0000
Received: from PA4PR04MB9709.eurprd04.prod.outlook.com
 ([fe80::1009:ebb:d7ae:4628]) by PA4PR04MB9709.eurprd04.prod.outlook.com
 ([fe80::1009:ebb:d7ae:4628%4]) with mapi id 15.20.8606.033; Tue, 8 Apr 2025
 07:59:58 +0000
From: Horia Geanta <horia.geanta@nxp.com>
To: Herbert Xu <herbert@gondor.apana.org.au>, Sean Anderson
	<sean.anderson@linux.dev>
CC: Pankaj Gupta <pankaj.gupta@nxp.com>, Gaurav Jain <gaurav.jain@nxp.com>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>, "David S.
 Miller" <davem@davemloft.net>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, Valentin Ciocoi Radulescu
	<valentin.ciocoi@nxp.com>
Subject: Re: [PATCH] crypto: caam/qi - Fix drv_ctx refcount bug
Thread-Topic: [PATCH] crypto: caam/qi - Fix drv_ctx refcount bug
Thread-Index: AQHbqEWM1wAalL/+m0qX1HwzWxzSq7OZZ+WA
Date: Tue, 8 Apr 2025 07:59:58 +0000
Message-ID: <a14929ce-047f-485a-b70f-2b2c8f99b8d5@nxp.com>
References: <17f9af67-de10-4b96-99ef-3c5cd78124c0@linux.dev>
 <Z_SxYFdyBJTYe_7G@gondor.apana.org.au>
In-Reply-To: <Z_SxYFdyBJTYe_7G@gondor.apana.org.au>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Mozilla Thunderbird
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PA4PR04MB9709:EE_|AS8PR04MB9191:EE_
x-ms-office365-filtering-correlation-id: 245f414e-6641-4e02-e2d6-08dd76735b71
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|366016|1800799024|38070700018;
x-microsoft-antispam-message-info:
 =?utf-8?B?YzZVazk0NVFKY2pibWthOVRwYWVtUnZVVUdseUhNc0tQZm4yYWpRaWFCTFY2?=
 =?utf-8?B?OWZ6elpISmtnOWtNRDRUeG1DRkNQM0tTL2tjblBDMFVxWEZvSzY2YlVSMEJh?=
 =?utf-8?B?WU0ya3BDT2pmUkJyVFBuYmgyekpLRUptSnMzS29TT0RpY0plbFZISUtvSnlF?=
 =?utf-8?B?M1d5UzF1VHdWajkzSXVTNXlYVHl6T1hGRGNjTEhiRnV0WmZza29KbHJLWXUr?=
 =?utf-8?B?bGpGWGdHSFdOMEE4T3k2MmNsVTRjYm1kdnd5UWpsQW5pT0NOelJLN1AwMVJt?=
 =?utf-8?B?Zm9UZmtzUEdVc084M0tkWHRtZUpkM1pBVVJJTjd1c3dleWU5SG1wb3U4ZnlZ?=
 =?utf-8?B?eDFLL0MzREphc0R4Yzc5TTI1QXlZL2thelZtM1JmdmhFbGM5M0R4YTU2VU5Z?=
 =?utf-8?B?dlR2TmRlSHpQcDcrV085S0szWGx2WTlTWWg5d2dvMXR1c1BJbWdWbHYzSVpk?=
 =?utf-8?B?alVXNVAxOTcyV09RdHlZSk9MaFhmaUY5bFBkTGhVc2dic1J5WUtrLzVva0hn?=
 =?utf-8?B?ejYyNXNiN1gzUnhaRFNyb3lIQkV2RXE4WEtHZDRHalp1QzlaMVluVWRkVExU?=
 =?utf-8?B?NVlVcWc5VXF1ZU1OMW1BajVvbHF3YkNaclhyUlllRys0ejUzTjZLU2VoUUIv?=
 =?utf-8?B?UFJBeHJKUGZhbEtpMVFieStoQ2R4L0JkZlJpVkQ4UndZd2FweFZzcFFYNkNB?=
 =?utf-8?B?MVozTldLaGR2L1FMY2ZMbWFLdkFYQ2tFUEtDUnJyMXVjWE1wL0RlNXY0VnRq?=
 =?utf-8?B?d0NGMk9acGN6RDBrUUlUaUExM2NadkcvMnd6V2kzb1UxU0Vad2hKL2N4N1k1?=
 =?utf-8?B?Ny9BaWYrTTRIa1oxY0h1TWVzWmhMUXA2YSs2d1RCRWp4KzV3WnUySEo4aUs1?=
 =?utf-8?B?UzJSOVg3YVhWaE93bnFPR2JDeFdkK1lmeWQzT0JqdW4zZEJvN1A4MzU2em0x?=
 =?utf-8?B?R1cyVVZDSEliSUs4Y3J6Wi9KZ1h2TGpzdWpJR0JvWVFRYjJDWnlnVDVtYUNU?=
 =?utf-8?B?OThqYTJqVStiN1BvUTNhQlFyODZIVWF6WEpCTGFYc3BKbE9DVG1hUlpZK3d3?=
 =?utf-8?B?Mm5jN0xjRjF4bGNFYUdibXA3SnBVbWk4UGJ0L001dWpGWFNjRkdNb3NEN2tH?=
 =?utf-8?B?ZldXUmJvOWNiTDNVYXkzVnNwNG56SG16RmYxRm1FNmU0NkZDYldvNWJnUEZl?=
 =?utf-8?B?RmxySFloOWVMQWJqNzgzY3JVa1R6Kzl5S1hnZHJWUmlQL3ByeGtGQVltWE11?=
 =?utf-8?B?MzFPSXdVVWdmS1pBaTRydEZxK3NxeGo3UVVtVFdrZWI4M3RPMnhMcSs5V1dL?=
 =?utf-8?B?REFSeWpyazdWcVR4N3hPc0RpYld2UWVKaVJwNHI4NTlQOXRLNlo3YzkxRGpt?=
 =?utf-8?B?RTkrNHZlNmM1SUJORklGMWkzaDRwWUllZ1FYY3hJOUZxRGptMnE3R3pqbUJM?=
 =?utf-8?B?YVVCYnhYTDRlT0ZaamxmR1BxUTM2Z29lZTFmSmRoWWpzSVZZNFFmdFdNT3Ev?=
 =?utf-8?B?K1dsS1FPQ3lEQTZKYkxVc1pRcHRRUmtIV0l4a2dhcTlDS2ZMY1d0K1lMMUEy?=
 =?utf-8?B?cXZ5S2JTcmF3V0xqalBXZWRqSDllMkEvQ0hpN0wxcUNsY2dWUGI0MklYT2gr?=
 =?utf-8?B?OEVTM20yNXZiSFR4ekNRR2p3TzVBLy9xLzdNV2MxamxXL2tkT2NZYXg4TUlG?=
 =?utf-8?B?YngrMW5TV1JxMkpua0xnVlZLUW5pR25QMGV3akI5SG1NTXQ0MW1xMjZXa1No?=
 =?utf-8?B?ZXp2c2xGSnZNUGpsczFSZWtITEV4TmxSUytpQytiMFBiTWhxNUJpckl1UHJ5?=
 =?utf-8?B?OUI3dTRIS2JQRlNWYy8yRVBvU3YwYXhYT0VnM3F1SGxVamlMd3BlekkyeURo?=
 =?utf-8?B?TGVJY2RDWFhYMGxFWUxLOWxHUkprTTJRKzczMXBEYnIrdVljbllnWEFocHN4?=
 =?utf-8?Q?/yXd+XEOQudd5zUctiWfNrgu6/FIJ8fj?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PA4PR04MB9709.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?WHhrQTYvT3dKeEl5cllaMXNoNGxOSUE5a2tONzNHRmlUNTJVVGYyQXBlUkZ5?=
 =?utf-8?B?M1h3NElnT3FVUkI2ZWVqK0RsTmpkUUZzNnpnZlNYcXE5dUlUSWhFOGtXbnlB?=
 =?utf-8?B?N0ZMUjA2enJJcmJ0UmpLRVM1dUFVTEplRmNFanlvRGtwUHJSWmFyZFRVRTlF?=
 =?utf-8?B?dHpTdFZuTGtWeWs3WjZ4RStHdC9ocDJLZlZKWkJUcXJCV2ZzUGxIUEJXR21y?=
 =?utf-8?B?K2hqajhLVm9uZDdhcGVub3RvVWV4YUtyU3pSTUVBQXNTK3pwMkZaWVhNdVFI?=
 =?utf-8?B?TWVMMnBuR0xNUml1bzZpenNJcTRHRTFIQTFteHlXbTM2MjJ4RXY0aSs2Snpt?=
 =?utf-8?B?L2VEQ3FTTXBhb0p1NHI4T0NlblhYcnNKSXdobEQ4YjNKMzVQR0xLRmhGTVdh?=
 =?utf-8?B?ZVNLT3o3bkZIWGhiL1hMU3I2N1VsNjlMZ01TUmhVeTZMNHhzbVpqY1BjbU0r?=
 =?utf-8?B?WHU5ZU9vb1pkeXFJMGNiQjFFei95SEFaTHZwRGRqUlZ5YlJieExmaVBhbk9z?=
 =?utf-8?B?TXhTSExrRHdZRU92bzJMRkZuc1ZBNWN3ZzRhdW5wLzB6aHA3VkcwTHFlbzE5?=
 =?utf-8?B?QXc5SHA4THlDbnhTUE9XNlVjWUQ0OVA5WWhOalhKTTU1UExvTjRLWnRXeHZ1?=
 =?utf-8?B?bzE5TEhZWWhzalhCL080M3BVcUEzcWpnSk1hdVZubWtGVmZCeWR0KzF3STBm?=
 =?utf-8?B?RVhyNXNpb2loNndzdzMva1dKaFY1WU8yaHp2QmVIMGNydGw4ZzdoQmxqOXpn?=
 =?utf-8?B?QTNsblFza0NLR2pTbGpiSFRXdTJsZExibWdCZlkxY3Mvc1lpTUdTck5Eemlz?=
 =?utf-8?B?MjN0eW5keEMwbDZLQ2E2UHJEaGMvVEhzTWVxL0VIZTA2YUlrcVlscTFZQ3Ux?=
 =?utf-8?B?L1kvbHlxOStZQ1dwcUdIYVVjYlNLNVRieEJSVUk0b1hXbDNFa0Y2WE5NNTgw?=
 =?utf-8?B?RFhVSDc2ejE1ckJNVlVtRjh4RFRxVVU2ZXQ2NW5OajZkbkFMTjQ3MXpXaWxH?=
 =?utf-8?B?OWIyeEVCd1V0NTJyTnRwU0ZuL3F2OGVTcHFFMzdYMGhzT2k2eFFqMmlDOE1Z?=
 =?utf-8?B?cUNIWjZZcm1TZVRDUFBVUXc1dUdLcnBFT0liTFpGYkMzSW1pR2szUFE0c04y?=
 =?utf-8?B?M0EzNTFqYUQ5QnVXcWQxRGlZcjRYOCtXSTB0eWs4WjBOc2M3L0pTcXhxdUw5?=
 =?utf-8?B?TDdLYjhwK1hUOTUvUWFsZUNIZXlyZmNUakc2cGZFeFNXRDFSY2FKSnZEK0ly?=
 =?utf-8?B?NytMNnFCcTdOMjF2RkxBd0ZTeXk5aDE0U3JQb1JVS0xmRlYwUUVmQVRtdUZh?=
 =?utf-8?B?WTJWVkZ4ZE9WZnZJanFHa1dlMDZwem5kdnRxQXhVMWhIZENOa0x0TXk4dVJs?=
 =?utf-8?B?Qm9La1RFNUF3YUhYaTc3bnVnRkR6OWZiRjhMUzhGeHU4aHJSWVZ0NTE1TTBJ?=
 =?utf-8?B?TjVCajdKSG14ajFzeFhBWTRKZ3FURmVrUDh5UllPd3N1UzdjQjVWenZRaGdh?=
 =?utf-8?B?N1B2ZGcva3hUbFVhYVlFNnkxOVdBOGd6bkE4TEZRK29NSWR5RDVVcHZWVnhv?=
 =?utf-8?B?TWFsWjJ4MEh5RG9VNkl2V3FXL0g3Qzk4MnJjUlh1cE9KKzM0OXI2b0ttWktL?=
 =?utf-8?B?WmQvL3VkTlQyMzBDUjRoNE5iZjJHbGgrOVkrQURYNzNPeEZxRzlQZk5CalFJ?=
 =?utf-8?B?V3JuVldqSEpRRUUwbVYvMlorQkNsSnZFRWtMKzg4eEFmaTE4L1RPb3VtN0xw?=
 =?utf-8?B?cnkyMnNJaVZBZUQvd2xudkJaVWJDczNsSzhRWGhkNXNrdko2TTdzVVQwcGlo?=
 =?utf-8?B?M1czVFhKblVuNnZ1ZXJTV2FKM1gzTWdQd3FpSDdxTzdTM0FzekI2TXhwQXJH?=
 =?utf-8?B?R0ZscWFQQk81L21teEw4MmN5WVBSR1dZczRFR0NGNFN0N1FjK0V3NllqUzlN?=
 =?utf-8?B?MFZSeGVVYUpLVzhLZUtLTXFscmJUa1kxdHVTajVYR21UcnArWFlUV0w0Qitk?=
 =?utf-8?B?U21FOWh0eCsybmJ3NHIvY0wzUFpkbndGUGVXVHR3WVFtSkw1TGVPbjlYNVJh?=
 =?utf-8?B?MHBMMnprbjJpRHZ2ZDhwaE9jeGM3VFdpYzlrSjZQYWI1TVFBR1JCK3F4TnMz?=
 =?utf-8?B?WDl1bzU3UmF1MzZ2dkZ0Uk5LTFpmUEdVWjQ5c1c4b2N6eGxEZ0oyQVl6TlBx?=
 =?utf-8?B?ZVE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <D273987704D4994A9BF4F153F7FCC6ED@eurprd04.prod.outlook.com>
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 245f414e-6641-4e02-e2d6-08dd76735b71
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Apr 2025 07:59:58.3390
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: m9fPOTF7yuG0WCvbHGf73aV+2OiA06wKSgQ56re/4uFResX3XjyTru8VutmH2pP83hiAmWbdlKoirXvjib/xRA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR04MB9191

T24gNC84LzIwMjUgODoxNyBBTSwgSGVyYmVydCBYdSB3cm90ZToNCj4gRW5zdXJlIHJlZmNvdW50
IGlzIHJhaXNlZCBiZWZvcmUgcmVxdWVzdCBpcyBlbnF1ZXVlZCBzaW5jZSBpdCBjb3VsZA0KPiBi
ZSBkZXF1ZXVlZCBiZWZvcmUgdGhlIGNhbGwgcmV0dXJucy4NCj4gDQo+IFJlcG9ydGVkLWJ5OiBT
ZWFuIEFuZGVyc29uIDxzZWFuLmFuZGVyc29uQGxpbnV4LmRldj4NCj4gQ2M6IDxzdGFibGVAdmdl
ci5rZXJuZWwub3JnPg0KPiBGaXhlczogMTExNDQ0MTZhNzU1ICgiY3J5cHRvOiBjYWFtL3FpIC0g
b3B0aW1pemUgZnJhbWUgcXVldWUgY2xlYW51cCIpDQo+IFNpZ25lZC1vZmYtYnk6IEhlcmJlcnQg
WHUgPGhlcmJlcnRAZ29uZG9yLmFwYW5hLm9yZy5hdT4NClJldmlld2VkLWJ5OiBIb3JpYSBHZWFu
dMSDIDxob3JpYS5nZWFudGFAbnhwLmNvbT4NCg0KVGhhbmtzIQ0KSG9yaWENCg0K
