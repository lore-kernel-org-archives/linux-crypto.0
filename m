Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.84.19
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794815915;
	b=uXUALrlDxLl9lL7PIPFo9nkX9UtTCLcjat5syqexx26HhFZTOF6OpLl/9kdwPxNYHFHC
	 H3x5YVSgND3XA0SnLeUpdhXVFF6cxCou31rzCNTQjlNeI2/o/WhAu054fX2u7sxH8D9Ue
	 ST65GYAaIA4g4Euh2bt5/eatWS3tLIyndW2q4mjcc8bbJLKp/l2fkgLyzrMPoJIJfoeYq
	 FTJd6H2FPqQ6U6vfWLjEQ8NR8rsOmDo+CV46I713w/SYHu49OVG7zjotjBqOBHl6izwXV
	 TPQ25vQD/KlKCBCqJGbYDrRbHzgcCe3opoWQ7mlFlI5k8ve4J/zLtJuLbUAx1Qe+8tA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794815915;
	h=DMARC-Filter:DKIM-Signature:Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:Content-Type:
	 Content-Transfer-Encoding:X-ClientProxiedBy:MIME-Version:
	 X-MS-PublicTrafficType:X-MS-TrafficTypeDiagnostic:
	 X-MS-Office365-Filtering-Correlation-Id:X-MS-Exchange-SenderADCheck:
	 X-MS-Exchange-AntiSpam-Relay:X-Microsoft-Antispam:
	 X-Microsoft-Antispam-Message-Info:X-Forefront-Antispam-Report:
	 X-MS-Exchange-AntiSpam-MessageData-ChunkCount:
	 X-MS-Exchange-AntiSpam-MessageData-0:
	 X-MS-Exchange-AntiSpam-MessageData-1:X-OriginatorOrg:
	 X-MS-Exchange-CrossTenant-Network-Message-Id:
	 X-MS-Exchange-CrossTenant-AuthSource:X-MS-Exchange-CrossTenant-AuthAs:
	 X-MS-Exchange-CrossTenant-OriginalArrivalTime:
	 X-MS-Exchange-CrossTenant-FromEntityHeader:
	 X-MS-Exchange-CrossTenant-Id:X-MS-Exchange-CrossTenant-MailboxType:
	 X-MS-Exchange-CrossTenant-UserPrincipalName:
	 X-MS-Exchange-Transport-CrossTenantHeadersStamped;
	bh=rjsKV8UX6ey4OWTwfj0EgQtLaDtd51FG9P4MOsSIDeU=;
	b=5ai3yp/3JXs3aSidHjZLHIf3SQhmUMGLsX2PeUlJL6RZZsNopT/PW1vUH6Br0bHXIQwX
	 CS7pmzzBeW9wWLSxDFWcT9sfCxtYPsrXImVsRhi3XiSF/ZTeirWTJzTWsu+LPwU+ILR7Y
	 QAEGTAkjYBmlWoDfeEoAqH/Wn+SRr9bY8rBbNRdvNKu1Aawp/KVmDXGpCXNDSWDsZtCLq
	 6g+mQ5LBBHXFrxNjdJSVWKEsEKmJBntPtxo6whOPz0zH/MBXw9WZ4obgrZxbDiYGA718O
	 ldUY2+BAMRKCP209IoGiUI2Do5Wcpd5EW6bC+zgipVbW8WuPGr/Je/wkrMHdVcCAJqQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=oss.nxp.com;
	spf=pass smtp.mailfrom=oss.nxp.com;
	dkim=pass header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.a=rsa-sha256 header.s=selector1-NXP1-onmicrosoft-com header.b=mFfiJYZw;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.84.19
Received: from DB3PR0202CU003.outbound.protection.outlook.com (mail-northeuropeazon11010019.outbound.protection.outlook.com [52.101.84.19])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D28D1606A323;
	Mon, 16 Nov 2026 07:58:34 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D28D1606A323
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.a=rsa-sha256 header.s=selector1-NXP1-onmicrosoft-com header.b=mFfiJYZw
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=G057QzqwcV1eNypkIQiaCVa9xmGcQFqAREEapy3e3Tg8YFBbhq50d7N01dcZv95xf/YSS1Zn2bwwNWbdHzTkr4jzL2On4xYlsaIlN/tjXovW/9jpLWmF9heoekQdSAkNkuQaoY1vHvOpke9bh+CGzsvpGWndV2RSirdBBs/vqM2EQExZCvtjorGWorWrUElGxS6fBv59Ol41H8TJqaIaV7NIxKAjv8TA3cYMq1qkXLic03QlmGEJbWGUMil1ZKmcCW+b6qSvyVORVUwHbIrH55g2FVALr2egZ+sJkufHccDACelldaH/dh0JffOQj7EH/cEtcMvUeICGdNWKcyks1Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rjsKV8UX6ey4OWTwfj0EgQtLaDtd51FG9P4MOsSIDeU=;
 b=vJJUUpX3sLk21O7kZckX341EOnmXjAf4E8GVfxCe/B2oGx6j7IkuDnxwcalYPRtAHDJSy/0aybOz9zQjiUuFQwPAUJ1g6XWM5B9l6v4wVrsv5FKKYB3C0ENsQ9D3Br/Gp02GIUuuwuW7o4jpJDL8fyE1xiFmPVa67LGwwRL46GheY0MkSLqkKo8Qtz6PtbUKF9pSAxWMLSsEcVwgXFUe/aFEAkLA8pNe11tJj9gfFv2SaXF0zhoFckxw7Vn5+KAgqUwPpwfIjE7XhT4s3G3en1uwFuEMWLN4T9c473+olg0UonOd7rm6XEOF2fS6/9gsOVwtkOWhuqWMyQdPmA3AsA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector1-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rjsKV8UX6ey4OWTwfj0EgQtLaDtd51FG9P4MOsSIDeU=;
 b=mFfiJYZwc+siaXJ5RXOVGu8RX9q9rsr454m75TirnncsJCVxrRqOckGMerHM0ZFeN2eSbodjOJOmF6Xns1qU74KsQjDuVuKReuV/eg92YwzgcVTa9jaFa7qJdG/om9MOkEB+Wwf9cxdG1PChHibTZK0Y9cfj8nXShLVDsJkWxzCfmxem+3jVbKGEcR6ZYTMDsmT6sC27jBecFnko0d7arU5MqEOcPTwMESWQq4zeupflII3JJdAodPXaR7EdlB9bojqt9aNq9AJ7XSW/OXbvGLM+6JqcxRrTAcmxti0w43NvyMqmWZ/Q4PzEoYF8UwLCgNWBHa1p5DaH1VfSsj7akw==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oss.nxp.com;
Received: from AS1PR04MB9358.eurprd04.prod.outlook.com (2603:10a6:20b:4dc::19)
 by VI0PR04MB10494.eurprd04.prod.outlook.com (2603:10a6:800:231::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.615.14; Mon, 16 Nov
 2026 07:58:31 +0000
Received: from AS1PR04MB9358.eurprd04.prod.outlook.com
 ([fe80::677:d5bf:c3ce:3ad4]) by AS1PR04MB9358.eurprd04.prod.outlook.com
 ([fe80::677:d5bf:c3ce:3ad4%5]) with mapi id 15.21.0615.013; Mon, 16 Nov 2026
 07:58:31 +0000
From: Sahil Malhotra <sahil.malhotra@oss.nxp.com>
To: Vincent Jardin <vjardin@free.fr>
Cc: horia.geanta@nxp.com,
	pankaj.gupta@nxp.com,
	herbert@gondor.apana.org.au,
	davem@davemloft.net,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH RFC] crypto: caam - never share the gcm and skcipher descriptors serially
Date: Mon, 16 Nov 2026 08:58:29 +0100
Message-ID: <20261116075829.17672-1-sahil.malhotra@oss.nxp.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <avZYhjJsa6Ih7nBG@L30177.local>
References: <20261109-for-upstream-caam-shdsc-share-never-v1-v1-1-65a1dd146db2@free.fr> <20261112101440.673231-1-sahil.malhotra@oss.nxp.com> <avZYhjJsa6Ih7nBG@L30177.local>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: AM0P190CA0004.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:208:190::14) To AS1PR04MB9358.eurprd04.prod.outlook.com
 (2603:10a6:20b:4dc::19)
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AS1PR04MB9358:EE_|VI0PR04MB10494:EE_
X-MS-Office365-Filtering-Correlation-Id: e38981c1-2adb-4003-5617-08df43b767a0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|1800799024|23010399003|366016|19092799006|10067099003|11063799006|4143699003|56012099006|261022105027099003|261026121527099003|261026140227099003|261028144727099003|18002099003|22082099003|41080700001;
X-Microsoft-Antispam-Message-Info:
	ZPF18COtunktDHMuKYIWdl59oTEcP8iGLXItG/dDe7F+ZcsJ0TVR1/9rrolMliZ/PEAffjCC1DzOG9p4ErAlvk4UVNjaQ35dfdF/ok/Xbf5iSlpBMqG2r0+dVAZ+Fmh1LlMXRiXoCGe2HX27UZGAewUcDXfJBaFBaDPndMyGUN0h0aHNhn/NYZa2pEcD4htCMlLcYk5s1R398WIBsNvuGDiMTrSHUht+E2ZTn6ZgZuTjjIXytXW1LxBHLBYR4j62TqWbVWCPS2jcTGc5RrxeIT8ug8vr48d0z7pZr5xzlZaGQ103ZNPG4UGjb0Qx2dc7rXE28T1GoL+TSfw1xsHpVq/pDKVpXYvuqU6MU0SvVcpTRmj241DM1OQsRWUO3Ei4Mjkrbxu4KR/p/8WMNWoPBcJx8pVZlmwsFfWCrsYJemTR5wPMa+M4cfY3on8jik0M0mlSSUp+CAOLgtA0FoWGuA8hxL0j6rjS0VrcZBr06FWQNliZnChOr6pp2QS90BqFxLUOde1h156eBLJ58Q2Q99RfYWgH5AtKIy7OpqRNpbJ6dwf4f3lBTiIJNwadW0K/mWd4tlMxIEqD8HGWdyqZVlN0aHPUyeRdk2M0LXKIjUV3s48OaQywaoDX6GV/6Z27qnGXaHk+sx2cq00jRa7yer01Y646Z6lovnNobWdpQdv0+cFAdJV6yn6iqjV5dabgkbITgyD5UyhU0bjv6+UdGFf/kQ92fT86DFUdi5/gbTQ=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AS1PR04MB9358.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(23010399003)(366016)(19092799006)(10067099003)(11063799006)(4143699003)(56012099006)(261022105027099003)(261026121527099003)(261026140227099003)(261028144727099003)(18002099003)(22082099003)(41080700001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?SC9xblRXSWlkNTBsNDh1Z0tUdXI5VjZ6YXEvY2w3N2lwV2VyY3prMDNlN1gy?=
 =?utf-8?B?YkFHb1VMRWo3U3dHdXNJeXNYdkJpK0JVdFVuRDBhMjdJVHBJd2x2NG5NTWJL?=
 =?utf-8?B?TGdLMWd2OGV0Z1BYNE9lQXJjVXZnWlptc2grZVBuQndQMXlkSEtDMlNYN3VG?=
 =?utf-8?B?VS9MKzNZUlZDalZoaFQ3ZkN6c25UQXdOYzZMN0c2UlYxdTJtTVdSRVAzRnl0?=
 =?utf-8?B?KzRDTDU4bVRSMnhkNFFxZXBxKzJBZXpuaU9CSmVWMnYxNEZVZC9rOWhNUVhO?=
 =?utf-8?B?REFMR2lwaEVBTlVDVXMvQnNaa1U5RFZwVjJHU2N2T2laUDBFSWU0OHZ2bXhI?=
 =?utf-8?B?WFQ2TktqcFpTd3JKaXduK3F5SS9ueDBiVENjMjZ6Qi9PRG54d0NabHFTYXo2?=
 =?utf-8?B?d2RZQnQ2WHd5MDNHa0Z6bjJueDkyZSs1MXFTUFhGMEFHM2NVWFVkbUxFRG9Y?=
 =?utf-8?B?YUxMVEU0UW00UDRoWmJZcG5ydnJhbVQ5alk2bHkxZU5JeUpNb1hVcFgwNXAz?=
 =?utf-8?B?Q3lWaGJTbFJIQkxLNS9Ecjd3eUcxc0dOdmNWWHZpakEramNMVjJCb0VVSm5C?=
 =?utf-8?B?bS9NcTdibFlkT1FNelVHemJBemM3eUhsUGh5WEJINFdvdDhsMG1zemVSUlpQ?=
 =?utf-8?B?ak5EUElUZ2dTdHAxTzJtd1J5Z1Q3dnBneFpBR2h0QWRpZWg4a3BRdzRGRDJI?=
 =?utf-8?B?YzNqSlVMOC9EWDd1NWZoRFhQRTlSTDVlZEFGY2tQZ09ydGEvT0FXUXk4a3ZH?=
 =?utf-8?B?UU1xOFRvQ2s0VWpXSlNWeDFXNEh1Z2wzV1VnQ1YxQy84NWdZSHU4VmYyeno2?=
 =?utf-8?B?Y3h5M3NmU3kzWnZPMVdnYnJVVCtoemlWNmhwNkJXTGoxRFBRUnFBVm5pQlFB?=
 =?utf-8?B?RzA3ZWorNTZlbFRhYXFCTnUrek1OWWFqNFRNZ1h2K254THBubERJZ3dOaS9G?=
 =?utf-8?B?U0d0NFUzeEdsK2xDRHFaRnMrQXpXTFRkRThDbURKeDFGdnlON3RaYW91TnFh?=
 =?utf-8?B?OXlRRGRpYWkvcDVQdzdJeXBqSDlkSzFWNlQxSnd0NXBJSDJvdXVRNjd6UkFV?=
 =?utf-8?B?NWsyclNuQ09SRWJnSnozamtaT210bFIvWFk0dnYzWGNRQUVEWDlvb3EyNlpF?=
 =?utf-8?B?VVo2UHhIc0Ywem8ybkt5dC9kdFJxa3QzdUZaOG1EdW5MaG9GZzhYWmo1eWo1?=
 =?utf-8?B?ZHZNSlRJdU5PU0FTNEhDUUYzTmJwallZeENDQjBGUmU4QU1CMHozSTcxUTFZ?=
 =?utf-8?B?VlJlRDU2Z1hRYkNQUEsrbkJRYWE5V3FraE9MZlJleHljS1R6MmNhdFJOOXda?=
 =?utf-8?B?enROMFV2M3liUmwxamtxLytIUHFZZm0yVXdJZHk4NnIrZTg0VHVDYzdkMEZD?=
 =?utf-8?B?VXFya2N5VlY0UWJsQ0xBVlQraW9Nd0JlUXkvZmFSWmZrR1Nvc0VQV092SGVX?=
 =?utf-8?B?OS9Rcjh3NmloeVY1OVRhUFZGc1JzbkRqRGc4b3J5ZTRqUEVpYkxwSStudEZj?=
 =?utf-8?B?ejdRZDJKVWlMc1EzOTM0V1lXdEV3cU8yZ3lwTnkvVEE0VitzRU5JbkdTcEF5?=
 =?utf-8?B?WU5jQjMyNFoyZml5Zklva0VnS1lRYmE2dnZ0ck9XRll1YXJrNTBML1ptUVRM?=
 =?utf-8?B?VWYzTXJsa1pLWnVHRy9IbnhUUTd4c3Rhd0RrUHM1UnZkb1Zhb3ExRlQybm5r?=
 =?utf-8?B?S2gwQUVJTHBTWE9FTndUOTg4YTh3YnVPemNrV1M2bkFXcXlZVTJrM0cxNkFY?=
 =?utf-8?B?a25zRUlITTZGcWVJOGdzWmpJN3p5N3BCTkFnbDBBU0xsV2xLV2EvRlBsbndk?=
 =?utf-8?B?YzhoaGNRamg1NUF6dFZJcjA4S3lWd0EyRlVzSDlZUlVEUXFYSGNIRGhGZThq?=
 =?utf-8?B?YTVZY01Yb05LaDhuWllqQlFqZGExNHNQaTZtSlhuQytSTDhQSkhqSS91aktG?=
 =?utf-8?B?U042aHZnWDZteEczSTVJUTZQVGVZSDlzODF2SzNRWUtHNmcwdkhkUEpERVIw?=
 =?utf-8?B?M291amJrUDJJT3FpYkhFQjFsTHdLb0R5L081bGtWbHBHOSszTWlmNncyRVlI?=
 =?utf-8?B?OHA4U09hV1JsNXAyNE1ML1o2YVh3TU5kMmNRckdBcnpWMkhSblo3aGN6Q3lH?=
 =?utf-8?B?Nk5FTGRSVVhKNzVwZ0lWQ3VLVXV1RVpueHQ2OWY5ZVpyV0NVb1orYmJtTGhn?=
 =?utf-8?B?U29vczNqWDlTTWxkdmNFQ1BLK08wazEyYktobUdOV0F6Slk2OU5xaWNOSTYv?=
 =?utf-8?B?Mm5oS1NnV1czcExnN0ZyTmJwb0xVOWRkcjU1VCt3TGVqRFQwdkdPVDdBakFV?=
 =?utf-8?B?WTI2bXJFNkp3WTFjUGgvS2JISGJpKzJqMHJ2UmRHSUlnR2RKYlFCMXU0MXpq?=
 =?utf-8?Q?JlIH2kPYz8+XIGqC1c/0/0WHd1Xa28uUfBZhUD6pGMvV9?=
X-MS-Exchange-AntiSpam-MessageData-1: CTZ9fryQAFkXoA==
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e38981c1-2adb-4003-5617-08df43b767a0
X-MS-Exchange-CrossTenant-AuthSource: AS1PR04MB9358.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Nov 2026 07:58:30.9998
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: YwF3Jfk2QdfpGG5LG47z6p8KYorsO6h4+f3dNbmvHqxEE5u5fBo8lLdzCz8Sfk/0APyw/9WYyeWdginUCnylPAM0cQfH7JEkVwadjtcTE9n+WlZpXewzLwiX+7uqLVvJ
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI0PR04MB10494

Hi Vincent,

On Fri, Nov 13, 2026 at 01:23:34AM +0100, Vincent Jardin wrote:
> No, I do not have other CPUs than the LX2160 : your feedbacks with i.MX
> is welcomed.

Sure, we will run the same comparison on i.MX platforms and share the
results on this thread.

> Since SERIAL vs NEVER impacts the performance depending on the CPU and
> on the selected crypto algorithm as you suggest, the code should be more
> dynamic, instead of a single option that slows down all the other cases.
>
> How could we keep "selecting" the best one for each case ?

Agreed, it should be dynamic. But I think we first need the numbers
for each platform before choosing how to select. Depending on what they
show, the choice could be per SoC (e.g. derived from CHA_NUM_MS[DECO_NUM]),
per algorithm, or both. Picking the mechanism now would be guesswork.

To keep the numbers comparable, could you share the exact benchmark
setup you used on LX2160A (tool and command line, e.g. tcrypt mode or
openssl/cryptodev, buffer sizes, number of threads/tfms)? We will use
the same on i.MX.

Also, if possible, could you run the same on LX2160A for authenc
(e.g. authenc(hmac(sha256),cbc(aes))) and xts(aes)? They use the same
kind of shared descriptors, so it would help to see whether the gain
is specific to gcm/skcipher or not.

Thanks,
Sahil
