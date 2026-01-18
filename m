Received: from SN4PR0501CU005.outbound.protection.outlook.com (mail-southcentralusazon11011069.outbound.protection.outlook.com [40.93.194.69])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E731284665;
	Sun, 18 Jan 2026 15:23:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.194.69
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768749803; cv=fail; b=R3PJsjwREPwXGfrcau02pby1Q+QTNNVxoF7Uml5E4xPNipRmE+iAgDXeu1Va3jWou4TX5mHpC1T/0cyU1W1KT1NPoJHebaOaX76jWpc6wj4dnIhH5hAd1zFqjDxJvaGLYj1S/QVhcvtapdArYFFzoMjjCHlaWiBQDtuZZdAe7GI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768749803; c=relaxed/simple;
	bh=cdR0AdmQHtGx3AtwBxUhxafAjzsusqTBjgL/6eHb/D4=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=gf7jOzk6erVDZppHkeLyE7T+awWgAX/IP3ExKklAA2BIPhXgYmBzOe/VWZOYHzbx05RCrKKfX6amgH8lp9gIQsyJkxp+EKPtQ877/IU7pmEd5dcalX0MIDQeWLyjVljdRgHNEkYL9VO1G1C9mMnab5WbbhHl9GOdTxVNPixOzdI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=D+qHguJI; arc=fail smtp.client-ip=40.93.194.69
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="D+qHguJI"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ofSILwoFDEMV0sYBDqP9uIjnX5glHDD3O6oiqnS8efNveY22IuTJLYz2KgdQsCczWQNFceweJ7T/TF2Mm8ihQtyLZ+YfGuidltRsa6te9D/Nlg33Gng6UYdxcotj0Wtxamjb3uoEQNTBsnAA6YvKQDdCP+nq0+0R8vMNvujjHsuMBGErDCpgxhkllAQwMSBxM8PzUXd9xd6tyV2VsNRkQdvLLFqotUTmhuKNSKKKQQcUcG2ZRAIDNoi4WaExMcyBopiA0S7f05wZNSuRUTuze04dsw77YV4ImccG70J06oZTFe3p8PFMa1O2kM6RXrNXWs0/4oxg9l1giMMO/H2Qrg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0KTXl/av4kVJWTncvMNgkXCZaXsQdOzl7ihwH1UIj58=;
 b=lioHu3lacbaBjuTSoutr2QrbOkYYCHCj7hyOCiIs1ZAPjUy3Su8xxLqEgsgDdLmgwRNkKpuChTB7kQiomp9HiiOFJ+nC3K2U333jts7MD6wSbOxcopl+75a5EBoFhM6M/EiNFfrLpDM5zqfaHyVC71QdvEsOAB4AbTP1bf3HOgMn4u/8Kho3UGvBoOTHIhvcYF/TngHD8JUZ9vl8/4sTs0A5ZpFTFiqeEx1n1BQVGAr9jpq3CFo7Ks19g9+C5e69gIklFmb1PePtZfB04h7kKf0oirrLQq/UOHz5OpFXT5lYZr2FSIyuWhLTcetYZDj4u6h/UMZlFLqoZbZDTLcWog==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0KTXl/av4kVJWTncvMNgkXCZaXsQdOzl7ihwH1UIj58=;
 b=D+qHguJIkGVWuRTeGB/PBNiCNKdiqf7qs6fo2m7EelIIV9DPX0arLxNxjPiqrAkTBHu/nyNpbqhYAP6rLdc0fKZtoyw91aMihms7jP5zmzvIj2jgM/b1V9v3htl9YMP6iY7tOM4jT7zlCs8T3YdO8wc1BYsl6eKsTYxngpiXz0o=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from BL1PR12MB5176.namprd12.prod.outlook.com (2603:10b6:208:311::19)
 by DM4PR12MB5964.namprd12.prod.outlook.com (2603:10b6:8:6b::6) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9520.11; Sun, 18 Jan 2026 15:23:18 +0000
Received: from BL1PR12MB5176.namprd12.prod.outlook.com
 ([fe80::91cb:8f10:c6d2:d683]) by BL1PR12MB5176.namprd12.prod.outlook.com
 ([fe80::91cb:8f10:c6d2:d683%5]) with mapi id 15.20.9520.009; Sun, 18 Jan 2026
 15:23:18 +0000
Message-ID: <fcfce2ed-69c0-49a6-9e4d-247cb2b5f538@amd.com>
Date: Sun, 18 Jan 2026 20:53:10 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 2/5] crypto: ccp - Declare PSP dead if
 PSP_CMD_TEE_RING_INIT fails
To: "Mario Limonciello (AMD)" <superm1@kernel.org>,
 Tom Lendacky <thomas.lendacky@amd.com>,
 Herbert Xu <herbert@gondor.apana.org.au>,
 =?UTF-8?Q?Ilpo_J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
 Rijo Thomas <Rijo-john.Thomas@amd.com>
Cc: John Allen <john.allen@amd.com>, "David S . Miller"
 <davem@davemloft.net>, Hans de Goede <hansg@kernel.org>,
 "open list:AMD CRYPTOGRAPHIC COPROCESSOR (CCP) DRIVER"
 <linux-crypto@vger.kernel.org>,
 "open list:AMD PMF DRIVER" <platform-driver-x86@vger.kernel.org>,
 Lars Francke <lars.francke@gmail.com>, Yijun Shen <Yijun.Shen@dell.com>,
 Devaraj Rangasamy <Devaraj.Rangasamy@amd.com>
References: <20260116041132.153674-1-superm1@kernel.org>
 <20260116041132.153674-3-superm1@kernel.org>
Content-Language: en-US
From: Shyam Sundar S K <Shyam-sundar.S-k@amd.com>
In-Reply-To: <20260116041132.153674-3-superm1@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PN4PR01CA0095.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:2af::10) To BL1PR12MB5176.namprd12.prod.outlook.com
 (2603:10b6:208:311::19)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL1PR12MB5176:EE_|DM4PR12MB5964:EE_
X-MS-Office365-Filtering-Correlation-Id: 754de09a-ba0e-4081-7f30-08de56a581f5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?bWFXUXhYSGtMbXlqc1BKajJZMVg3dlp0d2dBeGhWTis3alZQNjg2eENsWVc5?=
 =?utf-8?B?WGdYY1Z5MFprV0htN21BR1NVUTJIaWtwbTgrazRsRVlTR015dmtlbjl5V2N5?=
 =?utf-8?B?QXVUbmYrYWtHRWtET0F5WW9LYU1JRTRodTVDYnpwbWgrZ3ByOTlVZUZBeVlJ?=
 =?utf-8?B?a251M2taNC9BcjZ0UDR3N3ZhZk5vMGFZd3NocWhsUU1LZ0ZpbXNZL1NzdEpl?=
 =?utf-8?B?RGpoQnRHSGpMUTAwUldvOUhCWGZlWXJnbE1IRnVHUHdib2N6RXV6M3kySFhn?=
 =?utf-8?B?SVJZT1NqUjBGNCtxaGNkU3lkVWpFODZDOFRtWTJsZzFmVjhJc2VYRy9XcTdO?=
 =?utf-8?B?cC8xKzl1UmtkY1MrT3dxVllDVURHYUttb0swblZSUHoya0MvdFdCdlhFcFVL?=
 =?utf-8?B?eTFlQzluTytCS09lRmFGcWRGdXZCZlczL3VramdxQitvZVlsQ1BHRDdXVFQv?=
 =?utf-8?B?RFZtNlVDcElRSGNEdGU1VXFsYXczTk1FR1A4YlM0LzllVFcrZGo3bHU3OEVx?=
 =?utf-8?B?YzRtdTl2d0s5K3o1UGtFdWhZdWxKMzQxYVl6WFF4OFo0cW0xMW80WHdjSU0y?=
 =?utf-8?B?Njh2WlNDODA5OEMxV3lwa0gvejRMR09IL0ZDS3YzcVIreWlxMGFvRFA0WVlj?=
 =?utf-8?B?cDU4anRFa3Z5WFlHU1NRSWp6TjZlZ3Z2VFNvTUFBU2EyNTBoL2pZOFFOZU81?=
 =?utf-8?B?eFozYjBpZWQ3TkhIUVdIbTlYSEhIem1DQjRBVFJsZ2J3OXVabi9NaDBGdlZM?=
 =?utf-8?B?M3duVVMzdm1DMmQ4a3Q0bXJ5N1l4U3M1dzA5QldsSzhTYUZCL2NKNXlkT1Fz?=
 =?utf-8?B?ajVOSlBHblREbEVZMTFKeFdYVnIrYTNxckNoUldVbVRvTEtZa2twM0pTcXVj?=
 =?utf-8?B?NE0rejI3ZitoaVUyaGdwdWdKclpJZ2VLOTk1VzQ1U096bStoRjk3RExUUThp?=
 =?utf-8?B?VXVndlRuVmlqVCtaZHlOZTh6Q0x1Smswa0V1cHFtaHM1YmFndTB5ZlBJbVRu?=
 =?utf-8?B?SU9nS0JML29pL0JaUnNpZUl6NnFLcjBDWVQ1c1BxZkJ5TTNkVXpSakNzR0RG?=
 =?utf-8?B?UFBwRk9kUWltbVhFMTA3ajhMRzhLM05adWhmSGtXRWwxRnp1Z1ZWNUx3Qldq?=
 =?utf-8?B?S3g4SGNqbXoxUHY0bllHb1k2WDBacWZTYmtlM1ZQSkdPY3lWZnBGMU5vVHFs?=
 =?utf-8?B?cWppTWZOd0oxMlhVRjQ3T0hQZVdHczcrbzVFcnBjTUR5ajZpK29WMy9NZEdZ?=
 =?utf-8?B?VDZzYnJSWEo4dFAvRWlQdUM5RDd5OUcwNHJRY1ZKR0hvUnBXVG85SlMvLzNl?=
 =?utf-8?B?eDZJR0VZeGRqbFdzWWpsQTRGQml4Z3ZlREVUdFArQlhsQ0NoUmp5VTBaaGV3?=
 =?utf-8?B?RXk5SUFXL1VkbTVmZXJMdjJnMzF6TzZUOGZFTEtpcm5yZkJ1UDBvdGp0aHUr?=
 =?utf-8?B?dDJtYk42MVZyd3FaSVJpcVU5MTZjTVdONFppK085eWNGMFpDcngzZGtRS04y?=
 =?utf-8?B?QmNIRzRiU0lYczQvdHZnbHdqWXkySnRIcHprR2V1UUFIeVU4aTdGWUY2TTBW?=
 =?utf-8?B?QVV2NUtJSFdTd0I5RlVNZGRRcy9lYVJYNGo5RTRybmZGdEV3eUIvL1lhcU9a?=
 =?utf-8?B?K3hnNXhjYUR4MXk1bitBOVNWZyt6NFI5NTZaUWplM2xBQjY4elpXdUZPc0RW?=
 =?utf-8?B?Qzc1NytsZDc5dzRaazZmVk9EcmhRNTBRaUc2S3pNK2dqMTFsa0pxVG9Pd2wx?=
 =?utf-8?B?cm5GcFRQY0VZcHliRjU5WDh3WGlZbUR2YUk5bnFDR2ZXT0YyYVREa251Ym5r?=
 =?utf-8?B?NFdxQXVSbDB4NlNvRmpmV2dTZG9WVGhiZzNRU0ZBa2tHOXJxNU5zWitSWEV3?=
 =?utf-8?B?K1ZEYzAzN2dBdGpoMXg0bmNFcnJFSHk1eE81UmxVVHZXeklaUDJlRXZ0NlRJ?=
 =?utf-8?B?MTZPVElIdDliOEZOeGE3NVBoWHJmc0t2dGtjeEsvdHpUUFhwd1NyWnlobXFh?=
 =?utf-8?B?cUV6WHdZSXJMQWxzS3hhWHc3eVExTmdLSDZNQU9QMnR5Rm5Xc043MHdtSkx1?=
 =?utf-8?B?WDBmU0lDQmtsQW9aSXk2MEJWR05zWnRlN1kxaHVDeG9IKy9lQVAwM01GM1B4?=
 =?utf-8?Q?ueJU=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR12MB5176.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?U0JCb3I1eGpXVTRyWEFaNEErdUJKR0tQeDh1SWlhMEtNV2w0dzBYUW50VmZw?=
 =?utf-8?B?YVRuNGxWbEUwN1JUbXdYdGVqTzFJbU5ydmxCNW50ZVlTTmJtS0V3djFudmZq?=
 =?utf-8?B?V052V05MenNWUjRjQzNjQ242RUdSSWxSK2hKbXdMZ3diSW9POS9xOXhmLzNY?=
 =?utf-8?B?aHVlYU8wWVQzU29vbkJSSzhxRXdTaXZoRkc2Zmw0NEo5QUV1cGgwRjVIUGdT?=
 =?utf-8?B?akJtNGRsNnBMOVR3OWdibGMvTVloMXl1OWsrajUwQm05UXJRUTFRczZodnJs?=
 =?utf-8?B?bDJacSt0SFFHamJadzgvbDBxT2J6TXg1Wnd4cTJBbmVTeHYxblljbS9hK0Q1?=
 =?utf-8?B?MlNucjQ5UGY1Q3poNGJBYjAxSnFlSTB0dEZMNFZYVGo3b0trL1FZNnhvVE8y?=
 =?utf-8?B?U3M5TE1hY0dycHpBSUxEN3hXc1VjOEhzTlJ5Ym5Ed2MxUlhab2dPOEdqTEY1?=
 =?utf-8?B?WTFIZnRIM05HdmNXMFZST2R5WklxRkt3cHFjT2VxQ2FjK0tCOXJXd1YrOG5Z?=
 =?utf-8?B?TitOYUJNTWpnTlQ4QUlqYmt5NTRrTm1GSzJMU1V1MlNsVGNWNW9lQ3lIa250?=
 =?utf-8?B?NDFVbGNoekp5QUt6Y21pM0pGbmNKZE1OS095TVUrUjdUWWtOU3VBY0IrY0pP?=
 =?utf-8?B?VGhzSllqRkRuanVoSmRZcjFyNnVKUSs4N1FmODZyeE9pSlNjUDlaQ05sV0h3?=
 =?utf-8?B?WHozdzRHRW80T3FJSDErMGQ2dWE3VFlsOEhnRGxPci9lbS9rajBXbEhOUmFy?=
 =?utf-8?B?VzlLNnFBemxSWUVSNmxDWUN0NC9YcTdBZC9Qenppd0RsSC8zWlhwUk14bVVX?=
 =?utf-8?B?Sm44WTBnVkRLYnVMcE9oRXhUZVFJNlVjcU9mcXFkcWZqT1JmQzdqaVFPUUk2?=
 =?utf-8?B?bWpMaXE0dmdFZHpuOGJiOGdMMXdVRzRSM3RnMDl2T0ZRY1UxNDhVNmtkdUda?=
 =?utf-8?B?OEwraUFzYTh6MERBUjRNK25BN3l6SVZyKzlkNWxsRGwrM3hMQnhtQVg0UzhQ?=
 =?utf-8?B?MEx4Q3lWMVFGS2QzekQra1ZwYkJLTmtUYytSZXJQZ0NhY25Zc285UzEvL0hL?=
 =?utf-8?B?djJWeWhoeWlsNFk5T0ROcHFZUC9BYkpyeWFEWXNpSjQva2pRa2pBTXBMano0?=
 =?utf-8?B?d0JGaWxDaUxIMitacXNOdHRpVWVVQytUT28zSXUwMDNrN3pZZ3o4ck9pL0xa?=
 =?utf-8?B?ckZqWHNtVzZReDIxUktzN0NOU1dZUm5DTk1jN2M1SjR4M0JtcVRORDcwbnhL?=
 =?utf-8?B?V09XRVh3WnUvSGtOS1JqRjltdHZ6VDFiK0doZGN4YTRkajJFZWk2KzBHcnpv?=
 =?utf-8?B?eDlmUERVRUVvRzVidDBtTG16em9Xc0lNSXBMSEpZZ2E0NVUvM013ZTE4bnp5?=
 =?utf-8?B?bTA3SUFmeVF2TmozZ2NRcGN2U1ExdklUbU14Y1lDT1kvcEF5OXFlTGhlaExu?=
 =?utf-8?B?emdOUG8zQnYyUnlEQUpWbStwdFcrS0RyQmNQK0xuUkZFM2VCemRyK2lsU0x4?=
 =?utf-8?B?SzJMRjFWNmx3QlRQNUFkQ1I3ZEsyZTkydEh2YmFZMWR5K3ZsRWxWc0JpZUJO?=
 =?utf-8?B?bWdCcVJMRWJ2ei84OFZlcThjNURFUDRpdjJIK3p6b1pJZ2EvWVFnTWUvZnVC?=
 =?utf-8?B?QVpPenY2WENhMkxieCtxSlU0SE0vaGs1Z1A0Q3M5UnhvV0hIZEV4akU3YVor?=
 =?utf-8?B?VTB5NXIycjZPSWx5ZTZpQTlnOG8yTGpTVlN4YTdxNnp6Vzk1QlZQNmlrTm9u?=
 =?utf-8?B?Q1V3SWQ5ZHFoUjRjRzhVZXhVMFkwbkNBT0lzTHpCaktLUmVka0paamF2WWQy?=
 =?utf-8?B?eVA3dHhJc1gxc3hYN2t1NnBNMVFFR1JtQkNkRUNWaHc4eUtWb3BFOVVPL25m?=
 =?utf-8?B?WTN2eWk1ZVdDalFqaTJVZ09sVlVRWW9EV3IvNDYrcUhmZ3U5a1B2bjhHUkRL?=
 =?utf-8?B?dkdWOVd4K1VuRkE4cWdCemlGMmpubTBKM1JMSFpOeGdFbnNoNElsTnh0aDNo?=
 =?utf-8?B?ZzEvdVk4VktQVjZFWkFKOFhvc0ZPQmJxYjk0R0hQQUpvaW5uOXI3M2JBaDhF?=
 =?utf-8?B?WExZSmFzdEZFQWdkRU9HU3J3ZFBTa1RlTUtuYnRvTW41WEl0WHJZRkFBR1JU?=
 =?utf-8?B?QkIxVVZ6a2NLRnNuNGRTTmpmeUJ6TUFYUlBHKzRSUk12bW40MjF5VFBYNFJG?=
 =?utf-8?B?NGdRQ3Zaazh3S2xsaml1eGlqV2FHUmFVQWNpVlBpclA5bFVIejFsajJjZEZx?=
 =?utf-8?B?bDcwWXBqenBySTR3ZzFpVXg2REpkbzhDbndjY1JHREJKRmlyb3FRaXI0QjZJ?=
 =?utf-8?B?bGJ0NnZ6My91anU4OHNzZEZzaHFlMWdGWGpYL0hHOTQ4S2RzZjFxdz09?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 754de09a-ba0e-4081-7f30-08de56a581f5
X-MS-Exchange-CrossTenant-AuthSource: BL1PR12MB5176.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Jan 2026 15:23:18.4561
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6gG9/y0kbURJpSmXtqE4MOHg/oZixUss/9la1hs2sHQiiLCutgeXcZOsVoh+tFO8bRVBWwbssArYtr2mAG7hsQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5964



On 1/16/2026 09:41, Mario Limonciello (AMD) wrote:
> tee_init_ring() only declares PSP dead if the command times out.
> If there is any other failure it is still considered fatal though.
> Set psp_dead for other failures as well.
> 
> Fixes: 949a0c8dd3c2 ("crypto: ccp - Move direct access to some PSP registers out of TEE")
> Tested-by: Yijun Shen <Yijun.Shen@Dell.com>
> Signed-off-by: Mario Limonciello (AMD) <superm1@kernel.org>

Reviewed-by: Shyam Sundar S K <Shyam-sundar.S-k@amd.com>

Thanks,
Shyam

> ---
>  drivers/crypto/ccp/tee-dev.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/crypto/ccp/tee-dev.c b/drivers/crypto/ccp/tee-dev.c
> index 5e1d80724678d..af881daa5855b 100644
> --- a/drivers/crypto/ccp/tee-dev.c
> +++ b/drivers/crypto/ccp/tee-dev.c
> @@ -125,6 +125,7 @@ static int tee_init_ring(struct psp_tee_device *tee)
>  		dev_err(tee->dev, "tee: ring init command failed (%#010lx)\n",
>  			FIELD_GET(PSP_CMDRESP_STS, reg));
>  		tee_free_ring(tee);
> +		psp_dead = true;
>  		ret = -EIO;
>  	}
>  

