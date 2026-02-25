Received: from DB3PR0202CU003.outbound.protection.outlook.com (mail-northeuropeazon11020072.outbound.protection.outlook.com [52.101.84.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47D1C2561A7;
	Wed, 25 Feb 2026 08:02:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.84.72
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772006542; cv=fail; b=OlIJNdnZTIE2LLAOqvPo83FFOebR+LXV6MclFomKezP3ac4KEIXgDi6LZ5tmxTOH//yndDxNK/Ip8A6TVHJIpNT38DA820qtuNdqB7lvjhVzrcLOpnGU1oSeBq8KKDwuhmKUUBAp6kSPjBjyIYGZPMGoP3rZO7MeQAGRsyhv3vY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772006542; c=relaxed/simple;
	bh=Tk5esycOBSv9JgOiUPba992DBadbh6gr90lKZtx9+dU=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=c4msJlwRjSoXzyjn9xD2liKZzODZ0w3jTmu/dW3fyrpW9jSh24oAu+/UQFwEPDQ1uFh4gRiOq8BDcKzBFIvQMa9Bdmttn7kuSOG0730txWEjsP2XK5tsfHNmpMNq0NdUWzYCG1E/yx55PhOWleRLgvQJnZ0196jzEm6z4p+HeNo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=ginzinger.com; spf=pass smtp.mailfrom=ginzinger.com; dkim=pass (2048-bit key) header.d=ginzinger.com header.i=@ginzinger.com header.b=hSVLHMFt; arc=fail smtp.client-ip=52.101.84.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=ginzinger.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ginzinger.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ginzinger.com header.i=@ginzinger.com header.b="hSVLHMFt"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=w27jgy+zwRcM71aJ67VM5hWwcSL/WAVLshUDTRlLqWINtwSSi5wf5BctJ+ZQAOadBMfJg5GVbg+LP/vNlSfcU2k+DsUhxwNb6+1NVhkeDkGn0e77VdpEhBmLQfaLvIIHUqbRaYQD8fPl/4+TIGWMsUtMofl1xBSLxvKPTKa646mkhQpUoDKMFnsqxWnFo15uqFC1CWK373F1fddFgzSRIUxzHQMbCSYrnANyoLxRqiZeIPmEzigDyjXKji7tY/sXhhXy5eRxvkA6dxqN9bIEV7nDCayrlNsprBe2/VLOHOfMGbhLbpuv9RlKZOoqqRj6y9lIMQFXPlK57LiYFzzbeg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Tk5esycOBSv9JgOiUPba992DBadbh6gr90lKZtx9+dU=;
 b=mkcq8A4pE40thN4uuQr+ZAJOdUIHGqdPjsMeUzYNxnWY+WjjMpg3eW85LJYnMH6AZ3d0wT75IP/akqupWVMFMpkViwivAav7UPHNVwkV87+fEsVMjeANtL0fuwS8PZXlIxz1y/ShQyeNGRvK9ExW4VTViek7a+mR9/3OPO2WMot++LgnSu7tCPOtkR5QdUfME1uCjIpgtThBO41Lqm6grpnhraPAnFpYppiluBGhU8fw4hykIg8xdGn/MXwvyjBMeNlut/lyFrFd+x+u/eKIXqX573UrjzjCJFuUOXeaN0tCdtCqUX0VI6AduHUbnYyT9Gl6vnTsmLQZfEqy+o540A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 20.93.157.195) smtp.rcpttodomain=wunner.de smtp.mailfrom=ginzinger.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=ginzinger.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ginzinger.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Tk5esycOBSv9JgOiUPba992DBadbh6gr90lKZtx9+dU=;
 b=hSVLHMFtI9CVd+QkgJqd7OOAKQQ4dLa24CBMJC38exQKUZbaCWW84uFY/YXFTXP+nct7khRxkhwU9/hhxXO7c/4BKcqRImvJb/QjNJ1KrbOrrDd2ujjfJD6gVXimubvdlKqPZLPBEmx54Ukjvc2pYZt8ibs6Vuy5VDK8R00NFM0o7SQSbZVeSeX7THAItcpNZKfKPSneoroiCXi03PTBTYZOJD4T5g5cPY5GnF/gy67hQoy1Y2DFwJOe4umlN8WE5F28bFPl9VuPjqYbZzqUcHma3rHnaLCi5KaJkWAGFlTc+4Q2BTCDVjmIW7Bi141+KYx3i2rXPMJJwYwgxz9nxA==
Received: from AS9PR06CA0067.eurprd06.prod.outlook.com (2603:10a6:20b:464::26)
 by VI0PR06MB9674.eurprd06.prod.outlook.com (2603:10a6:800:237::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9654.11; Wed, 25 Feb
 2026 08:02:14 +0000
Received: from AM3PEPF0000A78D.eurprd04.prod.outlook.com
 (2603:10a6:20b:464:cafe::d2) by AS9PR06CA0067.outlook.office365.com
 (2603:10a6:20b:464::26) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9632.23 via Frontend Transport; Wed,
 25 Feb 2026 08:01:58 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 20.93.157.195)
 smtp.mailfrom=ginzinger.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=ginzinger.com;
Received-SPF: Pass (protection.outlook.com: domain of ginzinger.com designates
 20.93.157.195 as permitted sender) receiver=protection.outlook.com;
 client-ip=20.93.157.195; helo=westeu11-emailsignatures-cloud.codetwo.com;
 pr=C
Received: from westeu11-emailsignatures-cloud.codetwo.com (20.93.157.195) by
 AM3PEPF0000A78D.mail.protection.outlook.com (10.167.16.116) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9632.12 via Frontend Transport; Wed, 25 Feb 2026 08:02:14 +0000
Received: from DB3PR08CU002.outbound.protection.outlook.com (40.93.64.83) by westeu11-emailsignatures-cloud.codetwo.com with CodeTwo SMTP Server (TLS12) via SMTP; Wed, 25 Feb 2026 08:02:13 +0000
Received: from VI1PR06MB5549.eurprd06.prod.outlook.com (2603:10a6:803:d6::26)
 by GVXPR06MB9099.eurprd06.prod.outlook.com (2603:10a6:150:1b7::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9632.22; Wed, 25 Feb
 2026 08:02:08 +0000
Received: from VI1PR06MB5549.eurprd06.prod.outlook.com
 ([fe80::2c95:365d:522:dd25]) by VI1PR06MB5549.eurprd06.prod.outlook.com
 ([fe80::2c95:365d:522:dd25%4]) with mapi id 15.20.9632.017; Wed, 25 Feb 2026
 08:02:08 +0000
From: Kepplinger-Novakovic Martin <Martin.Kepplinger-Novakovic@ginzinger.com>
To: Lukas Wunner <lukas@wunner.de>, "ebiggers@google.com"
	<ebiggers@google.com>
CC: "horia.geanta@nxp.com" <horia.geanta@nxp.com>, "pankaj.gupta@nxp.com"
	<pankaj.gupta@nxp.com>, "gaurav.jain@nxp.com" <gaurav.jain@nxp.com>,
	"herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
	"davem@davemloft.net" <davem@davemloft.net>, "ignat@cloudflare.com"
	<ignat@cloudflare.com>, "linux-crypto@vger.kernel.org"
	<linux-crypto@vger.kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>
Subject: Re: [BUG] crypto: caam - RSA encrypt doesn't always complete new
 data in out_buf
Thread-Index: AQHcpZhLhQf6tsYBZky80qwgD1KH9rWR8nmAgAASVwCAAAjFgIABAUyA
Date: Wed, 25 Feb 2026 08:02:08 +0000
Message-ID: <e36dd6fa756015ec1f2a16002fabfa941c33d367.camel@ginzinger.com>
References: <6029acc0f0ddfe25e2537c2866d54fd7f54bc182.camel@ginzinger.com>
	 <aZ296wd7fLE6X3-U@wunner.de>
	 <e1d7ad1106dbb259f7c61bdd1910ac9f08012725.camel@ginzinger.com>
	 <aZ3Uqaec79TUrP2I@wunner.de>
In-Reply-To: <aZ3Uqaec79TUrP2I@wunner.de>
Accept-Language: de-DE, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=ginzinger.com;
x-ms-traffictypediagnostic:
	VI1PR06MB5549:EE_|GVXPR06MB9099:EE_|AM3PEPF0000A78D:EE_|VI0PR06MB9674:EE_
X-MS-Office365-Filtering-Correlation-Id: e972c4e6-55c0-4d1a-c8a7-08de74443008
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|366016|376014|7416014|1800799024|38070700021;
X-Microsoft-Antispam-Message-Info-Original:
 =?utf-8?B?UW92U2c4YkR5UHc2WVY3TnhlYk5qcGc5bzNiUmw5Qnl5dUJBQnlqdmxxTG81?=
 =?utf-8?B?MkJjWnYrNEdoUDFKaW12czdsMlpoTnliVGdUbWFKK2VuUFZmU1VPZmt0Z0hO?=
 =?utf-8?B?WkZ5UVg4Ry9nd3pDenpIcTJUdkRCOGlZQlY5ejBXbHdoYW85S0dNb0lqMFly?=
 =?utf-8?B?ekVPalp6ZUwwMHdreERXTzVLeXBMQjVucWw1MmJmSzc5TnlRN3doUDRrSWpZ?=
 =?utf-8?B?KzgvSlNVTW51aTJzMnE3TEVZQzVWbmdnaW40UldTNU10SGFjTW1KM0UrUjhl?=
 =?utf-8?B?MkNTa3F4dFdRVm1YR01teEk5dkNwanA2VCtJdmt5cjdaTlZvU013clJncklU?=
 =?utf-8?B?YlI1YzB0VGJzOWJkc2d5UUE5cFh5MmNvM2wvYWN1b0d1ZXBGWlB3bVhlYk1R?=
 =?utf-8?B?L3NvQVY3bS9LUnpEZlFoMjdBV0RNYVFoMTdzL2hmdzk2Zk8xS21tMjdWTHJY?=
 =?utf-8?B?OWpVREpVYURkNTE4YUJjL0ZWUXZyeGdBSU5GUHpROEtjNlYvZVJ6WndWaE1R?=
 =?utf-8?B?YmlYcnNsZ3JhclFsUTNyUDVQRDcyUFQzckFYU3NLUWhKNjFCK0cwa1AvTnEr?=
 =?utf-8?B?VlU0bmF5SDdwd0pvZkE1UndRM3JUb2dwWHZkVEJ5T3IwMmQ0YVliTHk3Ym80?=
 =?utf-8?B?UXV3ZE04ZENZaUNiSnhGVTlybGhOWmFQLzdxald2c20reFd3ZFRLbTdaS0d6?=
 =?utf-8?B?cVc4a0JhTWNkdnZlbDF0aS9SdUdZOFFobGxGWjVOUGMyeVhETUlpZENtVFpS?=
 =?utf-8?B?bkk2VmhtYU9vemVDdVlvK3VnY3ZGaE5MZkgrT3gxUGROZXd2M1pldDRKdDVz?=
 =?utf-8?B?NUtZWjdyT3lwVkhzRWdrdGpBRFpTcGxabE1uek5LSFFuRng0RFFOdHVyYkR3?=
 =?utf-8?B?Q3hXMEw2cDMzaGtWbERBS2RQdnh0ZjZsVnhMcW1xYWM3UmsySFE2TmthbUNI?=
 =?utf-8?B?eVBmTEFtREhjaWl6cmtmc2Z6bFhpZ2JNYS9naUxOSlVLRTE4UklCajArbEdG?=
 =?utf-8?B?bWZYT0tMU0RrWHlwTTBoaG0xMm1sSFUra2pvOU5NNXNCRUdoRWtzRlh1TGRL?=
 =?utf-8?B?R2ZrdEU3dlUvSTMyUXYxZVg4eUIxSktHVGdzcUJxNHBnQUI5cGJHdTdWbDNp?=
 =?utf-8?B?VEdEdkhCWFU4Y2ZsSTJBQ05tZ2lWUkFMQTg1Y09JemljcUg3R3dUMDN6U1hz?=
 =?utf-8?B?WTdmMU04VnFSS1pwNzRwc2ZtTVNlOE5Bb1hjMGhvN1ZDUnhTd0NzWUlQL1ll?=
 =?utf-8?B?MHJYZlNTSHJ1eUpOL1lwQmc2M3NtV1Fwa0F2NDdUVHNlWDJPTVErME9udldh?=
 =?utf-8?B?bUwxQlpadjBTOWtET1VCV0RNczdnbzdVOXpFL1dTc2ZCeE9jOUJsdGFTWnpv?=
 =?utf-8?B?RTRiWERHWFlwOE9jS3d4MUN4cTZrSEZiaUJHbXpRTEtYbDFOWGZ0ZEhPcEhu?=
 =?utf-8?B?UUQ1MVNOblJVTkxRMytjL3RDSjVxazJ1eVRBSkx3YzVTQ3A4TitQRzBEeExw?=
 =?utf-8?B?NDY5Zkl0dlUrUXZ4R1JPOUppbFhvaFF4ZjFud21odE9rN1oreEhseGFDN290?=
 =?utf-8?B?U2pRVzYyTHlKR2dYVTRSQk9LWVE0QTlwb2NCQUc4c2Z0ZWxGMWpUU1FrY2xJ?=
 =?utf-8?B?R2tHOVpmamlaY2hEQU1FYVZIU3RvRmg5SGtZRkpSYWN0VmdxRWdNNGl1eU9m?=
 =?utf-8?B?NlhYb0IxMkhUN2RodkFCTGZUTVhxcUZBTjlzU21yb1pTU3l5YmlDNDRGK3ZJ?=
 =?utf-8?B?bnVZS3Y0NUw0ajg0UG9oSEtSYXJpR3RQZ2ZyS3hNeVp2MmErQTlOTUdYc24w?=
 =?utf-8?B?a1dlOUV2cFBsOXM4WXl3eVY4QzN4ZStBYnAxdEVoMm1ZSDNZTlZEeUpua0Ir?=
 =?utf-8?B?WmYwQVZrd3VnZXBRVHowNTdrem5jUDJlWHJIdU5SNk1vZmkxL2dCZmVHcjA3?=
 =?utf-8?B?cm9KRXU3THhuK0JqOHRqM3BSdmNhYTV5R0dqV3k1S2hFdndkdzlDVFJHRFZr?=
 =?utf-8?B?QllYVTZTcVVLZ20zdndoSFpUQkh1RTZyb3lBK05GM09ZdFh3VTN4aWJlcnJ0?=
 =?utf-8?B?Lys5VW5kTVdsZldpRHI4bnJxcWp0SkhDcFY2VEphRjN4N2xDOU5pRW1uZnlP?=
 =?utf-8?B?RnpaSmZlVnM1V0RDUzFRWlhrc3pCb0VlWVY4U1lkN2dZTW1JcVYxeUY2Wm44?=
 =?utf-8?Q?CXI0HR1SJP0lxfVeC5O/fr4=3D?=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR06MB5549.eurprd06.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024)(38070700021);DIR:OUT;SFP:1102;
Content-Type: text/plain; charset="utf-8"
Content-ID: <4FCF7C27E4EDE2439F2D7A43AD39B230@eurprd06.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-Transport-CrossTenantHeadersStamped: GVXPR06MB9099
X-CodeTwo-MessageID: 360f57ed-3d96-4e5c-9564-5fa769120dc7.20260225080213@westeu11-emailsignatures-cloud.codetwo.com
X-CodeTwoProcessed: true
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 AM3PEPF0000A78D.eurprd04.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	a4a893ba-d1cb-4eb8-1498-08de74442c61
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|14060799003|7416014|82310400026|35042699022|36860700013;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?NWswUGg4Qm54MlNydDRmS1E3YjN6Tm9ITGhtVUpEVzEzUXhLOVhpSVpxbkJ3?=
 =?utf-8?B?SlVYakp4bU1hQStKTVBCMTJsNHprSlZHcWVtUkhKMUV0ZVVNMWxDSHBETGpC?=
 =?utf-8?B?NUZ4bC9ES0NtcFJLeEdBVXdPNlZkY09IYy9RcWI4bDNEZ2RPVlVDWWF1ZTNZ?=
 =?utf-8?B?VmI1Rkpvb1FBWndjSERCbzNhSStnV3RpLzZlMEkxaFdSUkVwRkh2KzErdmh3?=
 =?utf-8?B?Q0k5UHQyOGdPQlVqUXorTWtla2NsVnhwUUIyMTRHSmFReFdtZ2xWL0RVQ1RZ?=
 =?utf-8?B?ZHdxK09wMUFqVVVxTVRHeVNjem15ajVrTWxoUU5nSjhtQ0k4SmtzNlV6eW1F?=
 =?utf-8?B?UHVSNkFEdEwrd1l2aGRNcGREeit0aUhaWFlNNmFRWnZrbVBTOG5JS3ZYY1lY?=
 =?utf-8?B?RWJWZXB6bzlNQnVtWWpsUmd2NmVWMHhseFB4NU51QmRFbGhPYUFzbnhoZjNh?=
 =?utf-8?B?RUpYVnVsbENlM25VZlJKVmJWL3hXNkdUMUR6QWllN1dmcWgwSGg0UUd5cmtI?=
 =?utf-8?B?REJRQ2JnYjVrN1NjZWVYNzBrR3F6UGplSmRNZ21hNi9wYitPcTlITWdMeTRX?=
 =?utf-8?B?c05URWo1ell3VXB2QTRDTHVySFZ0WnhzZC85TzdWU0JGeUhUS3NyUy80RzhN?=
 =?utf-8?B?bkFlb2JzanR1Z2EzSVJ4NzQvNEwyWkhWcElEeWFiK0pLWVA5NVZOeTB4VzdM?=
 =?utf-8?B?NWF2d2FzRE4rMTg4dTFVTDRsQVg5eHhFUGVqN2pzamxYWUwrc3RmZlNMK3RK?=
 =?utf-8?B?SXNISERWNEdwRitqeFJRQWtXbGhHTmRQSVorOVNLc2F4M2hMSHNrRHBoZ2R5?=
 =?utf-8?B?OGlJcXNyMkhSOW93eUtncVdPbUd3Y3BYa1dRYmlqQ211azF5NmUzRVRhdHI0?=
 =?utf-8?B?ZmdXejNmamZFc3FodnBmcE5CZDgvZjhKVDFtL2p0aUNlSU9lTE1naXdJOXdE?=
 =?utf-8?B?Mmk0RW5EdGd2bWhQVjFDMzNUL1pnQzZvQUVMVWxLWFR1WTJTVHBicmVydVlK?=
 =?utf-8?B?Tk5SY0RzOGgwandEQ0RKcnAzZ29EWURKcnh6YWFwalZEektaU2hwMWxxNDVo?=
 =?utf-8?B?N3J2dytMSmVMR2Q0UHB4TmhSd2h4NXZWY3E5cExsR1JYWkxQYjlCZEFEM3Nj?=
 =?utf-8?B?aHBOU01BcTI5QVppMk9jcjBpTHdBM3FEbFBTb2FBZkh3MHpJN1FJL0JnaU9F?=
 =?utf-8?B?a244bE1neVZrM3l3dGFiMlVpeU4wRDJ0MHRCb0VEVnVPcHpseVpvSjJWMTRE?=
 =?utf-8?B?NVR2Y2xUUmZkQVRzNmozTW9FbTNRM2k5cjZCQmU2VUdWcW45WCsrYVhsRTVP?=
 =?utf-8?B?WXQxdjlTNWRPakE4S2dNS2RDczBDOEJEOWhTeXA2aHdlUGZDYU5vUnUwcGNQ?=
 =?utf-8?B?eE5sK081WTRSRm10bCsxbGsrTkY4ZHgxWTcrTHNLWExVek1PUkMzRTgzSFYx?=
 =?utf-8?B?bVkxVHRpNmtQVzdReWtGamIxTWF3UmRxY0FqYWpQbHJ2ajEzODI2QVFxd3NW?=
 =?utf-8?B?R1NXd2Q1MnZoOEFmem9wZ1Vabk8vcHdWSzJLWk5zL3ArR2J3OEkvVlpUaHJi?=
 =?utf-8?B?RzhINHpWSUVVdWtPa0RHa3dxOU9yUURrOGdhUjFta0Y2QlZNUlE0MVUvMkh0?=
 =?utf-8?B?Nko3T1ZjLzVlVy9ubWNCd2RFaW1Kdk9tUTNiMkV6QkdramNpb0pYL2RoN3M1?=
 =?utf-8?B?RHI1d0JDSUdSK0dFeHNpTjBjWmRBU2RJcUJoWEJHWS9WbUg5M1ZrNlQxZ1hn?=
 =?utf-8?B?WWtmRmxZTGNxTTFhZTJxUDd1VWNXZ2twQU9ENG5lSFd4T0hzcUcyTTNZSUFu?=
 =?utf-8?B?dXVWVXhUT0dwL0h0ZEFHYVFoc2k1L2tKUEs4U2J2SUpSeTN0L2pwNnhzb09V?=
 =?utf-8?B?cERXczRxZ1BMZ09RblRXYUErWjZnZUhUSkowZVZFQ2VBVThVa1BiNUV5L0pD?=
 =?utf-8?B?SmJBUWc3akhXTUFjVXNLOHpURUlVMk9JWG53U2ZDSDJTTnM2RUlIYWtoajZT?=
 =?utf-8?B?TlV4MGRCRDdMYUc5NnlrV1VMeGY1TXZPanRoNVdGak5FLzM4OEtBSWRKcVlE?=
 =?utf-8?B?SEJVbTNwVmdtSGhlak1DTWwvWGVCcnhDVjQvK2lIenBsZ09CS3pOMEkwWDVm?=
 =?utf-8?B?SVFPVmVHY2VTNkpMMkcwRTFCbWZIdzZYM0JSbFJRS2p5VFdnZWVKc0Nib3B2?=
 =?utf-8?B?NmFzRS9PRjNQcGIrZEVaWHRkSXdQZXJRRkJDR1RlS0RFUmFzVGdhZ1NIUVNz?=
 =?utf-8?B?ZVdZb2NqUVZmNGpYOVhzRDczRUp3PT0=?=
X-Forefront-Antispam-Report:
	CIP:20.93.157.195;CTRY:NL;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:westeu11-emailsignatures-cloud.codetwo.com;PTR:westeu11-emailsignatures-cloud.codetwo.com;CAT:NONE;SFS:(13230040)(1800799024)(376014)(14060799003)(7416014)(82310400026)(35042699022)(36860700013);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	BPcXq9IXjf1uUio/5BK/nXpstQu9xgOqX4t8a5I+8kTcuZF/UczCDHBTRiEXAG/upTSHABEV80k64V8Q+tFG0mKgmoYmWjeepYFo/Udja378QDnjrOn6gZ4FD1DAzav8g5IESlIbILV/NbTU1kbN05nMn6ZPHdbX0dZTuHfXULobEpRqQKvf1IfcROuGnOaEUquYRxNY3bLpWTiwq1RzPtSx8zEWRz3FXLodo7hNRDOvj2o7IqxJ3Yoj6hJhamcKcIkZGhvsFbHrizzv8nUWrNRD/Rrko6yoqamOtf24ib2ldnxTvXKKG7jVax67n+zSPqYsWpH5mTdSJ3f69HwueyPOQyB3/t9fiA5xQcSXZD3BzaGC+FMbCSjnErWXtvFabVH9/7/dttDcfgb6LXue8W5pVGmXCfytWC4i3t5qAkvW0qTxNf8+csgRzrMdASOo
X-OriginatorOrg: ginzinger.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Feb 2026 08:02:14.4517
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: e972c4e6-55c0-4d1a-c8a7-08de74443008
X-MS-Exchange-CrossTenant-Id: 198354b3-f56d-4ad5-b1e4-7eb8b115ed44
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=198354b3-f56d-4ad5-b1e4-7eb8b115ed44;Ip=[20.93.157.195];Helo=[westeu11-emailsignatures-cloud.codetwo.com]
X-MS-Exchange-CrossTenant-AuthSource:
	AM3PEPF0000A78D.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI0PR06MB9674

QW0gRGllbnN0YWcsIGRlbSAyNC4wMi4yMDI2IHVtIDE3OjQxICswMTAwIHNjaHJpZWIgTHVrYXMg
V3VubmVyOgo+IE9uIFR1ZSwgRmViIDI0LCAyMDI2IGF0IDA0OjA5OjUxUE0gKzAwMDAsIEtlcHBs
aW5nZXItTm92YWtvdmljIE1hcnRpbiB3cm90ZToKPiA+IEFtIERpZW5zdGFnLCBkZW0gMjQuMDIu
MjAyNiB1bSAxNjowNCArMDEwMCBzY2hyaWViIEx1a2FzIFd1bm5lcjoKPiA+ID4gT24gVHVlLCBG
ZWIgMjQsIDIwMjYgYXQgMDI6MTc6MjJQTSArMDAwMCwgS2VwcGxpbmdlci1Ob3Zha292aWMgTWFy
dGluIHdyb3RlOgo+ID4gPiA+IFRoaXMgd29ya3MgdW50aWwgdjYuNiBhbmQgZmFpbHMgYWZ0ZXIg
KCJjcnlwdG86IGFoYXNoIC0gb3B0aW1pemUKPiA+ID4gPiBwZXJmb3JtYW5jZSB3aGVuIHdyYXBw
aW5nIHNoYXNoIikKPiA+ID4gPiBidXQgdG9vIG11Y2ggaGFzIGhhcHBlbmVkIHRoYXQgSSBjb3Vs
ZCByZXZlcnQgb25lIGFuZCBJIG1pZ2h0IGJlIHdyb25nCj4gPiA+ID4gd2l0aCB0aGF0IGNvbW1p
dCBldmVuLgo+ID4gPiAKPiA+ID4gSXQgd291bGQgYmUgZ29vZCBpZiB5b3UgY291bGQgYmlzZWN0
IHRvIGV4YWN0bHkgcGlucG9pbnQgdGhlIG9mZmVuZGluZwo+ID4gPiBjb21taXQuCj4gPiAKPiA+
IEkga25vdyB2Ni42IHdvcmtlZC4gdjYuNyBzaG93ZWQKPiA+IFvCoMKgwqAgMi45Nzg3MjJdIGNh
YW1fanIgMjE0MjAwMC5qcjogNDAwMDAwMTM6IERFQ086IGRlc2MgaWR4IDA6IEhlYWRlciBFcnJv
ci4KPiA+IEludmFsaWQgbGVuZ3RoIG9yIHBhcml0eSwgb3IgY2VydGFpbiBvdGhlciBwcm9ibGVt
cy4KPiAKPiBXZWxsIHRoZXJlIGFyZSAxODQwNCBjb21taXRzIGJldHdlZW4gdjYuNiBhbmQgdjYu
Nywgc28gMTQgb3IgMTUgc3RlcHMKPiBzaG91bGQgYmUgc3VmZmljaWVudCB0byBmaW5kIHRoZSBj
dWxwcml0IHdpdGggZ2l0IGJpc2VjdC4KPiAKPiBJdCdzIHF1aXRlIGRvdWJ0ZnVsIHRoYXQgMmYx
ZjM0YzFiZjdiICgiY3J5cHRvOiBhaGFzaCAtIG9wdGltaXplCj4gcGVyZm9ybWFuY2Ugd2hlbiB3
cmFwcGluZyBzaGFzaCIpIGhhcyBhbnl0aGluZyB0byBkbyB3aXRoIGl0Lgo+IEl0IGRvZXNuJ3Qg
dG91Y2ggYXN5bW1ldHJpYyBjcnlwdG8gY29kZS7CoCBJZiB5b3UgYWJzb2x1dGVseQo+IHBvc2l0
aXZlbHkgdGhpbmsgaXQncyB0aGUgY3VscHJpdCwgImdpdCBjaGVja291dCAyZjFmMzRjMWJmN2Je
Igo+IHBsdXMgY29tcGlsZSB3b3VsZCBjb25maXJtIHRoYXQuCj4gCj4gPiBJIGNhbiB0cnkgdG8g
bmFycm93IHRoaXMgZG93biBhIGJpdCBsYXRlci4KPiAKPiBJIHJlYWxseSByZWNvbW1lbmQgc3Rh
cnRpbmcgd2l0aCBnaXQgYmlzZWN0IG5vdywgbm90IGRvaW5nIGl0IGxhdGVyLgo+IEl0J3MgdGhl
IG1vc3QgZWZmaWNpZW50IHVzZSBvZiB5b3VyIHRpbWUuCj4gCgpvayBJIGNhbiBjb25maXJtOiAi
Z2l0IGNoZWNrb3V0IDJmMWYzNGMxYmY3Yl4iIGluZGVlZCBpcyBvayBhbmQgMmYxZjM0YzFiZjdi
IGlzIGJhZC4KCkl0J3Mgbm90IHRoZSBzYW1lIGJlaGF2aW91ciBJIGRlc2NyaWJlZCAoZnJvbSB2
Ni4xOC92Ni4xOS4gdGhhdCBjb3VsZCBiZSBhIGNvbWJpbmF0aW9uIG9mIGJ1Z3MpIGJlY2F1c2Ug
b24gMmYxZjM0YzFiZjdiIHJlZ2RiIGNlcnQgdmVyaWZ5IHN1Y2NlZWRzLApvbmx5IGRtLXZlcml0
eSBmYWlscywgc3RhcnRpbmcgd2l0aCB0aGlzIGNvbW1pdApodHRwczovL2dpdC5rZXJuZWwub3Jn
L3B1Yi9zY20vbGludXgva2VybmVsL2dpdC90b3J2YWxkcy9saW51eC5naXQvY29tbWl0Lz9pZD0y
ZjFmMzRjMWJmN2IzMDliMjk2YmMwNDMyMWEwOWU2YjVkYmEwNjczCgoKICAgIDIuOTU2MjIyXSBj
YWFtX2pyIDIxNDIwMDAuanI6IDQwMDAwMDEzOiBERUNPOiBkZXNjIGlkeCAwOiBIZWFkZXIgRXJy
b3IuIEludmFsaWQgbGVuZ3RoIG9yIHBhcml0eSwgb3IgY2VydGFpbiBvdGhlciBwcm9ibGVtcy4K
WyAgICAyLjk2NzkxOF0gU1FVQVNIRlMgZXJyb3I6IEZhaWxlZCB0byByZWFkIGJsb2NrIDB4MDog
LTUKWyAgICAyLjk3MzI2OV0gdW5hYmxlIHRvIHJlYWQgc3F1YXNoZnNfc3VwZXJfYmxvY2sKa2lu
aXQ6IENhbm5vdCBvcGVuIHJvb3QgZGV2aWNlIGRldigyNTQsMCkKa2luaXQ6IGluaXQgbm90IGZv
dW5kIQpbICAgIDMuMDA5MzYwXSBLZXJuZWwgcGFuaWMgLSBub3Qgc3luY2luZzogQXR0ZW1wdGVk
IHRvIGtpbGwgaW5pdCEgZXhpdGNvZGU9MHgwMDAwMDIwMApbICAgIDMuMDE3MDYzXSBDUFU6IDAg
UElEOiAxIENvbW06IGluaXQgTm90IHRhaW50ZWQgNi42LjAtcmMxLWdlLTI2LjAyLjEtZ2VfcGNf
Y2NfZ3ctZnJvbml1cy1nYmVjNzkyOTRhZDI0ICMyMTUKWyAgICAzLjAyNjkxOF0gSGFyZHdhcmUg
bmFtZTogRnJlZXNjYWxlIGkuTVg2IFVsdHJhbGl0ZSAoRGV2aWNlIFRyZWUpClsgICAgMy4wMzMx
MjRdICB1bndpbmRfYmFja3RyYWNlIGZyb20gc2hvd19zdGFjaysweDEwLzB4MTQKWyAgICAzLjAz
ODM5Nl0gIHNob3dfc3RhY2sgZnJvbSBkdW1wX3N0YWNrX2x2bCsweDI0LzB4MmMKWyAgICAzLjA0
MzQ5NF0gIGR1bXBfc3RhY2tfbHZsIGZyb20gcGFuaWMrMHhmNC8weDJkMApbICAgIDMuMDQ4MjUy
XSAgcGFuaWMgZnJvbSBkb19leGl0KzB4MjI0LzB4ODc0ClsgICAgMy4wNTI0OTJdICBkb19leGl0
IGZyb20gZG9fZ3JvdXBfZXhpdCsweDAvMHhhNApbICAgIDMuMDU3MTUwXSAgZG9fZ3JvdXBfZXhp
dCBmcm9tIHJldF9mYXN0X3N5c2NhbGwrMHgwLzB4NTQKCgp3aGF0IGNvdWxkIEkgdGVzdCBmb3Ig
eW91IGluIG9yZGVyIHRvIGhlbHA/Cgp0aGFuayB5b3UhCgogICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgIG1hcnRpbgo=
