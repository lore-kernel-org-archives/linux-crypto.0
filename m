Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D84C825CC42;
	Thu,  2 Oct 2025 11:36:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759404965; cv=fail; b=fgkSReeLY0KEfeVm7DRMd0Gpk9CmijH+ne9bUasS0yVN8G3AfauhEmY1KFloF+h06gMRc6oFEKGdNKCRFSKTLk5TKh1+8KhF5Laqcig7WSDMb4lhaydZZmOcj9Wv87JTsU5B0CgJ3isCLorhU/JWik3LRSpv2RR5El2uzFV5/ao=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759404965; c=relaxed/simple;
	bh=qCGWKizwhjl1b3KBZQIgSRZoayaVC5axZzHtxbCEeVc=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=I02oc6aawi/bvhKavE0PKBoVdHseq0PygpQ4oO0CjFF2bTHVultpAbeEdB2IzkS0JO5aUrhKEC/WO1Ee2erQjVTKoVHhPqZpqFQ7l1YQ24NQPIZV27cYJjZGhBNsbWDvO9C0ME3icJP4OtEDkkV4wA+ENNpW9VpKGqEhABcVdQ8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=Xx0+I5Sk; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=HJ85L9mn; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Xx0+I5Sk";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="HJ85L9mn"
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5928NJuh024130;
	Thu, 2 Oct 2025 11:30:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=7etfIHOjVIo7c7+WRo0oL+qgUIj9e5LtbKrx9Svkbtw=; b=
	Xx0+I5SketOjbr8z4QPqypvIwtRqSv1kchHoU8dDoIhGyzFyAXuCwaT89khXxbgD
	BMlJGWM89Z6hlznq38JP+fYJ77BxEyCTFfo+/u5y4sA9rtUnNqNdtbvw1+/D0hDG
	B5KRzZZbJ1hszeCzHaodZmVbwSgjmXSilSrGGGkxFmEdUwjPew0RH8cWjs/2WWV6
	DT4vfliwuKl9m26P9Vf6rNn9p0TTcgGGczr0xTZjLw5+gtFyDN345pDEnwHI+Z71
	VyXgXxPNhOQeUoJcVwYHN2DfVRiQ/xA3Cum/d9zDjORmEQ36YpUqOAT677vho0xY
	AfekRHSGuqMIhNAC9BGPLQ==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 49gmrfu3sw-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 02 Oct 2025 11:30:54 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 592AxBeS000412;
	Thu, 2 Oct 2025 11:30:53 GMT
Received: from sn4pr0501cu005.outbound.protection.outlook.com (mail-southcentralusazon11011021.outbound.protection.outlook.com [40.93.194.21])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 49e6cgtgh3-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 02 Oct 2025 11:30:53 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=tokzudnm3L5PwasH+TyBx7eaR9PFbkVIqC3ewb9ygntKWx8H7uhqyIqTM/a+ISYo+fjBn0I/aTxNDkt7/rTpmrs5KDKfRPvrK06kVGcua4MSdUpmoBXLIPFxWKCFQrhgN0NoXkkhotqQasznKHOGqI4oPpqaeVIeCf+8d3Izcg1UxaMZjohHLcEcvakZi6cOJT6NU07cY6x4CoREJYNib8JVE1muWYvRb6XJCN4TpvCnfhPHwJ5pHxl/YA+Reb/mbp3eBprifh0WmeDyg75wMPxA2pX5pEbeGjVedGBzufMA9ChYPxDd3josxfoUveMCL/pdrWhl1lymuVbLFJZ8JQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7etfIHOjVIo7c7+WRo0oL+qgUIj9e5LtbKrx9Svkbtw=;
 b=FTFjjLHQ5Pup+NvxN/YTqFptFefGCR85zFnrG1gyGrKhnqvjX9O1e/2saW9L3dSjGVHXb+aI/8E4KlUq85Yn96NnAGk3VrpiTLo2vgWZNIz/HWJQM8wQEdXb8q/speZ/r7m2yGF2mUktV8D89ioZtMVQ866hgyb2VAwRdbMY/S/3HQ4+hRhciu7xo2LZImJ8lZufDcHhv9ctv2DiL9U0Cuw5vTbJF0kksaBf66DwJwvm3fvHXoPZyITy21rOsXMSv09i+mEjZ9TfkTBetOB0gLk/U3Z1DdAyfotxDtweseOFibD3UR/ZZros3wAwondhMfTgTOwdCxACdjOjRJJ7+g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7etfIHOjVIo7c7+WRo0oL+qgUIj9e5LtbKrx9Svkbtw=;
 b=HJ85L9mnM2bsstkptmVHfOdRwMcZAvgXftP4UP0qmjGmIb6IB8E+SZX6AMd2NmltXfTIUDudYhXVczniqcIbh2j1z9yz7RUzAwHhK8nLADsEZnSZmCigJXydIM2r6HcYB+hXCo0a9GOIc1LjZ7VGKhF+vxBtuCt55fE2ogeHiTc=
Received: from PH0PR10MB5433.namprd10.prod.outlook.com (2603:10b6:510:e0::9)
 by DS0PR10MB7429.namprd10.prod.outlook.com (2603:10b6:8:15d::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9160.18; Thu, 2 Oct
 2025 11:30:50 +0000
Received: from PH0PR10MB5433.namprd10.prod.outlook.com
 ([fe80::47be:ad6e:e3be:ba80]) by PH0PR10MB5433.namprd10.prod.outlook.com
 ([fe80::47be:ad6e:e3be:ba80%4]) with mapi id 15.20.9160.018; Thu, 2 Oct 2025
 11:30:49 +0000
Message-ID: <f31dbb22-0add-481c-aee0-e337a7731f8e@oracle.com>
Date: Thu, 2 Oct 2025 13:30:43 +0200
User-Agent: Mozilla Thunderbird
Subject: Re: 6.17 crashes in ipv6 code when booted fips=1 [was: [GIT PULL]
 Crypto Update for 6.17]
To: Jiri Slaby <jirislaby@kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        "David S. Miller" <davem@davemloft.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        netdev@vger.kernel.org, Eric Biggers <ebiggers@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>
References: <aIirh_7k4SWzE-bF@gondor.apana.org.au>
 <05b7ef65-37bb-4391-9ec9-c382d51bae4d@kernel.org>
 <aN5GO1YLO_yXbMNH@gondor.apana.org.au>
 <562363e8-ea90-4458-9f97-1b1cb433c863@kernel.org>
 <8bb5a196-7d55-4bdb-b890-709f918abad0@kernel.org>
 <1a71398e-637f-4aa5-b4c6-0d3502a62a0c@kernel.org>
Content-Language: en-US
From: Vegard Nossum <vegard.nossum@oracle.com>
Autocrypt: addr=vegard.nossum@oracle.com; keydata=
 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 8A==
In-Reply-To: <1a71398e-637f-4aa5-b4c6-0d3502a62a0c@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: PA7P264CA0085.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:102:349::11) To PH0PR10MB5433.namprd10.prod.outlook.com
 (2603:10b6:510:e0::9)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB5433:EE_|DS0PR10MB7429:EE_
X-MS-Office365-Filtering-Correlation-Id: b3d2d69c-4d96-4680-876c-08de01a722dd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?OUl5Q0FVN05oTkxzcnpTUmM2N3FPV21xb3FFZUlHWWFyOFh3M3o3Vy9lR0hy?=
 =?utf-8?B?U3k5bnB6RVN1ZkxjVVpSZkJoZGRFL0E2V3RkV05oRTFYa0pxSnhoZ3loQ1dR?=
 =?utf-8?B?LzNnL0srT0llMlljUU1iQ0lGWllRNUF3WTdaSElBY1p4VDdOUWJVc0JzNjZV?=
 =?utf-8?B?TE5zU3NaNWZPOFg4MVpnUURTMmROeDMzSHdISnJHUGJ0TG9yS0tOelBleWJi?=
 =?utf-8?B?OGJ4a0ZleVBWanBXQ1ViQ1o1ZlZKZ0FRMnBtOWRCdE11RFA4RnlFQXRPc29q?=
 =?utf-8?B?Yk12OUhFYy9jTTZDNWlvTEF0NXB4V3RmVnB4T3E2bmxYNVZrcVExc0NBbWY3?=
 =?utf-8?B?bHl4aHlFQ1FISHdadFhhbWdKUjNSR1V1VEdhamhETVo0VlFpRzk3K0ZpN0hh?=
 =?utf-8?B?aGx5NmNQQTF2WlZWRWRQMVJKR3NoYkJoTzJBSjhtYUVQdlJEN1dxQ2NTUjdr?=
 =?utf-8?B?NmpLSExlRzlWdzNWTlR6elFkbForNDBJVHF0QWxUZjJJbisydkJIWHVydEUv?=
 =?utf-8?B?Y2laejd6MUI3dHhQQ0gxQzhMUXBobXpkdDNZTHVFVVJtWEZWS0dBL0tkOXUy?=
 =?utf-8?B?ZUU3ODdGa0FHWEg5NkFSNTdjajVQbEF4di9WMnI0NzhVcnRZVndqd3QyMjBE?=
 =?utf-8?B?S251STJESzlqNGIvTGhwalJmQzNpRHQ1TlQ0dkVIZWJtMlJxemQ1UkZEcmtu?=
 =?utf-8?B?bTlUb2ZyTmYrbUg3OXZjMm11eGRFN0ZYeWNYTzhZZUIvRzd0cEFac0k0MW1Y?=
 =?utf-8?B?TnFpQWplb3BhQXJBT3hISmc3NXdSa3B3SEtSZDlWWEg5dXdJa3YranVXWUhX?=
 =?utf-8?B?RlYyR1JldDB4NGNKVVhpMnZVbXVlcGxmVTI1NUJKZ016SFpFR3ZvS05kaFBD?=
 =?utf-8?B?MzFwc3JJbWhqOW1PYm9OT29VaCtoeXBtYjI5Mm11emxTSC9tdHpRT2VOaEh1?=
 =?utf-8?B?dENMOU9iY1JtSUxWZlo1VVlhQ0RZek9ITUhKVlczNlRJclN1K2FIL2FaK0cx?=
 =?utf-8?B?RUlKamplQmoyb0dzQVVYUXdBT3V0ZVJjWW9WRzRFWmJtZ1VjSGNYSHk0QjBP?=
 =?utf-8?B?Y05HWHlBaW9Jdi82TlVPcUxabzdhZk0vdXhJTlc1V3BPQmEwdkdmaXJiSWEz?=
 =?utf-8?B?YTMzc1I1eG9CbUVzR3AyR0s4bHd3UERUU0cwbG5pRlVzVlZ5a20vdGpHRDJW?=
 =?utf-8?B?VXYwMmc5UzhCYzJsZkVsZmJmaXRxdFdYT0pUQTlvQXY1b1BQMEJxTUtDcVgz?=
 =?utf-8?B?c0tQaVBqQXZlWmRPNkZ0eU1kOVVpYTBSUDRJSzVEVWZQdXA4VFBkcEZCQVda?=
 =?utf-8?B?VVNpMm9jQXR4UGZKb0R1RzNRK2xuSEdrd3JYdzZQdUwrMExmNE9zKytxbEVi?=
 =?utf-8?B?aG5nL0ZORWdwN1BacTF0cnpMUmFubThWR0dkOXBWcFcyRlpVdmo0ZDBxdjdB?=
 =?utf-8?B?ZVBDY2pheGtuWjU3U3VtMGZQTXVNbWE3blBpNHdLbE1wbmVqUkxVYmM1RkN3?=
 =?utf-8?B?dVA0dXFUVE5iN3ljN1JneGlzckwzNlU0ejA3R2VWZUtkN0NkVmxZN2RtOXhs?=
 =?utf-8?B?VkI3ZXVRaGF6WGhDVkZqWFdkOWo1SEVLVlN4b0lPaURZWllPTER0eXhRRmJu?=
 =?utf-8?B?ZkZpL1YwR0JnRzFXdkZwS2xKcG1ibEpSRlNiUkJxUFdFY0ZMOURyMHlRMGNO?=
 =?utf-8?B?V1FlbWRMZnlFd2hPd0lhb1F2aURwVzMydk5hRlMrbHgxa1N6d0dLSXpsTFV4?=
 =?utf-8?B?d3VCREszZzFuRTR4UXBDQlFaOVZVSHNxT1NEUlIvSFNubVFsY0xDSFErb1ZC?=
 =?utf-8?B?RU9hbzdBb2taL3lqM0lwYTdFNmg0d29rV0ZZYjFiV2paVWdoVHJwZWtQa0ZF?=
 =?utf-8?B?MCtJL01HdlVwTUFxL3VYUWpEQUlZQndxd3dldmg5YjYyUFREWU9hOHZMSmRm?=
 =?utf-8?Q?ahUk5JV9g8IXiWzTjo+i1l4AcCirKBhf?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB5433.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?YUJXeHFQZEthUy9NQ1MvQ2J4YS9jWUM4aG55RitRbi9iaW42ampkNDVJaVJx?=
 =?utf-8?B?UVJPRmErSy9pd1pQVld4OFBlNFVoZVd0WkhZNzlSbXdMNS9CYU9GQ1owQVhu?=
 =?utf-8?B?aFZLNmJJSWVvMWJQN0JZMFNOM29QRnhvakd3V2p0UHNYN09ueDJPazRBMk5K?=
 =?utf-8?B?Z2NScHdHMDZqR2t1YnJ4QjUzeTNvR3lPLzk2aU50QllyMXJVM3g2M0VDWXVY?=
 =?utf-8?B?VTVDU1FsWHVLaDlQczJ1eGV5YmJTdlJNN2F2OTR0RU9LWGVaMGN4SUZFNkcy?=
 =?utf-8?B?b3h6Tm16V0NhWVhLODRmdWFiN1B2eTFNRDcvSEFoeVZlYi9uWStWOWxCUVFX?=
 =?utf-8?B?Wi9ZazYyN0lmL0tqZDVTNW1jR2JKNHVoelFrTjZabjJHV1VSWHBvZS80ME0r?=
 =?utf-8?B?M2xoSVRXTHJoZFpvYlE5Yk56cFZjZjFBaFp5Y0JYSHFFa0Qxa0hLc2VmOS9s?=
 =?utf-8?B?REtIRXRIQWZadDZxN2dVaXFJdmpWNytpYjBmWmxiVnp6aTRheUpQaGVkdmhC?=
 =?utf-8?B?b0FFTXVkd0tQYTlUczhaUU5hVUlvN0MwcjU3YUNJMzlsTU83UkVkaVo4bVZI?=
 =?utf-8?B?M1NvSERZRmk1SnVVMEc0SUExZHVDaVA2RUpOYzR0aURZRVZKMVJNT3BjREtW?=
 =?utf-8?B?QUxtZ09ZenNHbFVpQklOLzRDWFVkQTVMMnpIS281WUR0R2lzQmdVbEhYTEhu?=
 =?utf-8?B?cWhqVVRkYmd5aUxjcFNESVlaUmdadXpKcTdBWjhSZkl3WHphbXYweHE0c2k4?=
 =?utf-8?B?SHNNN2dCWFVGdk9GZ0RaUTJKK0VWUndMZElJcURrcmdWWXpVNmc0dFh1U0k5?=
 =?utf-8?B?dkUzVDJTa2FBSDRWUVJRVnA3T1A4SkRXWjA3WldlV3grVjlPY1ZYZE1kSnJ0?=
 =?utf-8?B?a3NNUDF0S21nU3pYV3pZT2FDc3IvdXhEMmdCdVpEQ3lBQU9WbWJ4eThVdVdO?=
 =?utf-8?B?VmVoY05ZankxRUZYclA5R2sxbURqaVM5L2I0S2E4d1BWTWdpNlFwTFFCQ2Y5?=
 =?utf-8?B?allqb1BEa2xNSkpsQnJ3YmFjVEY4QmR2Wi95Ky9LVGdhY1BpdU5Fei9rUE00?=
 =?utf-8?B?cUQvamRHZWd3Mi9JZURnRGNub1NsOEVlWmUvNUFCb09rMStlV3JGeU55QXZ1?=
 =?utf-8?B?UzByRi83WUIwSUxMd2RZa2FEODQ5L3Uxakd4SG5BYnZxTUVhajR5TUJqNFM3?=
 =?utf-8?B?NlpBZEk2MnByTmdQakJQVEdEeThBZnB5OWxISHJ5RGhvb1krcGI2K1p0VzFx?=
 =?utf-8?B?MGcrcjJJRVJ4NDgxZm5wWmNUNysxT3N1RWFnR0F0ZmxoTjV4TC9xUkgyeUlk?=
 =?utf-8?B?NEVtZkxpMTZiT2tJeEo2L0xFZm1zakNPR2hMT29BU0o2amJEK0hJV1FrTmVJ?=
 =?utf-8?B?d2R1Wng2TzF3SHEwMnhySUVqd2EzMDN3TUY1bFlXczQrMmVrOHdZK05EZHBn?=
 =?utf-8?B?eXNYanFRUXR4ZzJUSEM2bXFSSW5hVEJqYmJmSTFOamF0bVdVZG5SVmk1QStv?=
 =?utf-8?B?UGRLNno3MHhqQmVyZVJiTEpJTzZUY2wybys5bVRGZ1pnMWsrVGtCeHFpcjZH?=
 =?utf-8?B?Q2hVckNnVm5abVpxbklMRHBNam5jTWNSL0dDcWdYS2VFVEtsN1BUVThvVGFV?=
 =?utf-8?B?SVpiSHQ4eW9UQ0dwdm1OQ0ZUc0JJUXA1Z0hNampveU5XOUxHOFFrdi9mSit0?=
 =?utf-8?B?YWIxOXhuQ0RZM01XSHc1T0x2QVZWL1hab2g0bDlkMEhuR3NCNFB2MFluWktJ?=
 =?utf-8?B?Y20rV21LcUl3MVZYNk84WXZYUjY3aWxLY1Rzb2dSVFFkM3FwdUlpYXc3b1BS?=
 =?utf-8?B?eWJjWE9sN3RDcU9oS2xpb051VVRnM2VuQ1RwY0VMWEpqUXpONDlHRDJQYWo2?=
 =?utf-8?B?ODd0MkdWVnEyeTBZUi9BY1AzeGVod1ZVNTRleEw3TTY5UC81WnZCc1FOSElZ?=
 =?utf-8?B?cjdwbUVIM2lIb1BHUitzZmRmZDZiY3RlbXlnVEtPbjVxY3hNZndGMUorOTVI?=
 =?utf-8?B?bmhRYUFFaVpXSHhZQnIvNXIrdFB3THR1YW8vUmtwbUtHTWtkcTZDRFBRcGJv?=
 =?utf-8?B?MHRXaFcxL1lIS2FnUDB0THhGdGFEQVZsekx0WDFVYVFLZTBhOXdJU0trRmRj?=
 =?utf-8?B?TFhSYkRoR25oc1QwYXlCQmlvcUp2S1pGYXJ3WDFxd01nT2llVnp6aStZTDVF?=
 =?utf-8?B?MFE9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	ajJlWYnCu/qXNP41UQnMrRaL8TVGBaZ4LBtQoI3XSwGSOiziLKfi6MZtkLWQlCPmjybhglmKcQ1JSgT4S/QNdVXBl1WTOUC8EfavCgn7LbWWDsmRep451OzBtyVelH5nR+snj2lUMsyiZrH+xV7RMypUyZhDV+zJ1QXvgNNDLs2EPF/dmj45YCQUPtc5T7c+I4Rj8Nv9tgnJSlYV0IXnea++qz3snPUwgVX6o4oFBmYC6Dnke8dawAthfv4NRsKDkjAfk9U6/P40uAHeSBg+7ABrQ9AL/nvs5kCX4CiRLCZYz6rb2+Ozl8IdFtq71LRhAjU3QHvms3KYf/JZ3dSQd4hA9fre8g0brOStMzhHKjbXdk/j9LAWWEuHsE86JT6Re5EdIKZwo+wnEEWoaFUh8DcI4ZoJonBpKtvnpGMhh/h74YmIM9SVFigwMk3HMjSxNce7TM4U65XECEWEetp1NRpwjaicKLOt5ENC37oq0UlN5smFvL1+9/QVVRkIbOmGivjOOt+jioe9hXOxWAv/zSvTg0csgxdt8ODEN9Q+OYw4DBOHCS7urmOI6X4HTlwTkgPie3Mq2kCllhDOZF9GslGpbxNKLi2ytNv5xbOXnoo=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b3d2d69c-4d96-4680-876c-08de01a722dd
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB5433.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Oct 2025 11:30:49.3413
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 60XOimE+h4rFkPKSVz1P3mfRVcDSNqRHewlrs4erZRARcltGYctLR8jMsGJ3Wb/+rxQbPIr21hsn8eiNJS7G5fo1i2QEju9wwo85QGlyUsA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR10MB7429
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-10-02_04,2025-10-02_03,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxlogscore=999
 phishscore=0 mlxscore=0 suspectscore=0 adultscore=0 spamscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2509150000 definitions=main-2510020097
X-Proofpoint-ORIG-GUID: u3ciFXELRgnxyy8TjMBm7KqvvYiZ9xui
X-Proofpoint-GUID: u3ciFXELRgnxyy8TjMBm7KqvvYiZ9xui
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTMwMDE3MCBTYWx0ZWRfX1qJABQPTr9bu
 oBj5cyaR2Jc/Dg7cOisgFZEC8qEbC+jQaDL/PjNoy961Fn1C7oY00eqwfzDJF/7M+ADgLxeCXGH
 q5m/ZN3IIE+A4flBDlYvcXqK/RCPLqWdxtRQxfaOm4Rkdq1lD+i3Rks9xtopTpDM8ndlZGDkz1E
 h0XuhPriV1DcCq9rCPr258xuDPSJ+zGrfiqg9LVOFkJZDgbRATWuifnx/u8RY8byzL5KfcDOP5o
 yuJh5vaw467pNnD5w2NP8GH5CgeE1+jkf+ZLtNBGRzhm4qFS0LDSkhZHpcYZirELEmkVEFA4UiM
 qKf0703kb+WXV4QvVIa78av9EGgVZns54F+EZe3B3ryoHifOPwmizlk+MICZMlLVisfwOyF1ynF
 Wp/qqzyabgDgEIhXww0FQ5M5xOOFshsxO7DJ5WtgQ97fsW0jr08=
X-Authority-Analysis: v=2.4 cv=VpMuwu2n c=1 sm=1 tr=0 ts=68de626e b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=x6icFKpwvdMA:10 a=GoEa3M9JfhUA:10 a=VwQbUJbxAAAA:8 a=1xoX7UV1siopNeT0hd4A:9
 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10 cc=ntf awl=host:12089


On 02/10/2025 12:57, Jiri Slaby wrote:
> On 02. 10. 25, 12:13, Jiri Slaby wrote:
>> On 02. 10. 25, 12:05, Jiri Slaby wrote:
>>> On 02. 10. 25, 11:30, Herbert Xu wrote:
>>>> On Thu, Oct 02, 2025 at 10:10:41AM +0200, Jiri Slaby wrote:
>>>>> On 29. 07. 25, 13:07, Herbert Xu wrote:
>>>>>> Vegard Nossum (1):
>>>>>>         crypto: testmgr - desupport SHA-1 for FIPS 140
>>>>>
>>>>> Booting 6.17 with fips=1 crashes with this commit -- see below.
>>>>>
>>>>> The crash is different being on 6.17 (below) and on the commit --
>>>>> 9d50a25eeb05c45fef46120f4527885a14c84fb2.
>>>>>
>>>>> 6.17 minus that one makes it work again.
>>>>>
>>>>> Any ideas?
>>>>
>>>> The purpose of the above commit is to remove the SHA1 algorithm
>>>> if you boot with fips=1.  As net/ipv6/seg6_hmac.c depends on the
>>>> sha1 algorithm, it will obviously fail if SHA1 isn't there.
>>>
>>> Ok, but I don't immediately see what is one supposed to do to boot 
>>> 6.17 distro (openSUSE) kernel with fips=1 then?

First off, I just want to acknowledge that my commit to disable SHA-1
when booting with fips=1 is technically regressing userspace as well as
this specific ipv6 code.

However, fips=1 has a very specific use case, which is FIPS compliance.
Now, SHA-1 has been deprecated since 2011 but not yet fully retired
until 2030.

The purpose of the commit is to actually begin the transition as is
encouraged by NIST and prevent any new FIPS certifications from expiring
early, which would be the outcome for any FIPS certifications initiated
after December 31 this year. I think this is in line with the spirit of
using and supporting fips=1 to begin with, in the sense that if you
don't care about using SHA-1 then you probably don't care about fips=1
to start with either.

If you really want to continue using SHA-1 in FIPS mode with 6.17 then I
would suggest reverting my patch downstream as the straightforward fix.

>> Now I do, in the context you write, I see inet6_init()'s fail path is 
>> broken. The two backtraces show:
>> [    2.381371][    T1]  ip6_mr_cleanup+0x43/0x50
>> [    2.382321][    T1]  inet6_init+0x365/0x3d0
>>
>> and
>>
>> [    2.420857][    T1]  proto_unregister+0x93/0x100
>> [    2.420857][    T1]  inet6_init+0x3a2/0x3d0
>>
>> I am looking what exactly, but this is rather for netdev@
> 
> More functions from the fail path are not ready to unroll and resurrect 
> from the failure.
> 
> Anyway, cherry-picking this -next commit onto 6.17 works as well (the 
> code uses now crypto_lib's sha1, not crypto's):
> commit 095928e7d80186c524013a5b5d54889fa2ec1eaa
> Author: Eric Biggers <ebiggers@kernel.org>
> Date:   Sat Aug 23 21:36:43 2025 -0400
> 
>      ipv6: sr: Use HMAC-SHA1 and HMAC-SHA256 library functions
> 
> 
> I don't know what to do next -- should it be put into 6.17 stable later 
> and we are done?

I'd like to raise a general question about FIPS compliance here,
especially to Eric and the crypto folks: If SHA-1/SHA-256/HMAC is being
made available outside of the crypto API and code around the kernel is
making direct use of it, then this seems to completely subvert the
purpose of CONFIG_CRYPTO_FIPS/fips=1 since it essentially makes the
kernel non-compliant even when booting with fips=1.

Is this expected? Should it be documented?

FIPS also has a bunch of requirements around algorithm testing, for
example that every algorithm shall pass tests before it can be used.
lib/crypto/ has kunit tests, but there is no interaction with
CONFIG_CRYPTO_FIPS or fips=1 as far as I can tell, and no enforcement
mechanism. This seems like a bad thing for all the distros that are
currently certifying their kernels for FIPS.


Vegard
