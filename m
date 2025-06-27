Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75BFF21517C
	for <linux-crypto@vger.kernel.org>; Fri, 27 Jun 2025 06:53:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.13
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751007191; cv=fail; b=mRN8vNWSMLzddRiR7KDSTkr5QPny9xzKcyqsEcQSDf6SP40gi0VX55GD+0f0M8fb52u290khKuVchyHMnwQSsqbo9cyxHALtzN26WiG9ZkGpyYggZ/7xI9+hofpNDiaJxT+YhDW+IkcSR8AwGXPg7r8pRk539Pbj8SUa+G2CDtw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751007191; c=relaxed/simple;
	bh=5fsFRqzu2CUBlW6+uY/EpjZsR/Xx7YYZIn2hy9Uuh9M=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=pSVoq5gIzNbCsDSdNQRB+bg38Eld0GFQhZEwjk6FnkXkMAAFLAoo++LWacWcyOLEaVyevoGuV8HItIdymQmlA8ff9s2/nMz1yJk8csx0nOt74FZnWueFryKCGGSlbwwzv+Gc/GOU1pthuauya0e59574LR+9p9YEvuFFDlELqi4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=NoXt4UZ5; arc=fail smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="NoXt4UZ5"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1751007189; x=1782543189;
  h=date:from:to:cc:subject:message-id:references:
   content-transfer-encoding:in-reply-to:mime-version;
  bh=5fsFRqzu2CUBlW6+uY/EpjZsR/Xx7YYZIn2hy9Uuh9M=;
  b=NoXt4UZ5JF7WCs15hJwDu2L1ti4bxEoQt2tQSv42C2ZDiEOj1119e4+r
   L4ilBzXqD8jbMyKguJlpZa2rsWfDG65o/neM3ePzxZOZybFuMUwdST9ix
   qJBuFav8SjAir0k5t+ckQoxqGekjmOP2he0nb3nqZ9Y3yZBRJBWioosXg
   JzXAmzaSZsorI/g7Gz9b79mNLxgkwOYIyVCc4JqpGdIwcAsuG+6zxmybJ
   w374A+MSChdD8e67GwhS53oQPL18yXYWVunDC2Xu5PH5gJV3QGMfqnunS
   y8a8mARM3Y9xPgxJ+QBlNCncmpB7BLPxD0fsUhJNev0rDVCKLVJPAuHLS
   A==;
X-CSE-ConnectionGUID: Qr6JdVHTQ9CYStmlyDoVSQ==
X-CSE-MsgGUID: yhUyHymXRAurDKy9MByBDw==
X-IronPort-AV: E=McAfee;i="6800,10657,11476"; a="55937991"
X-IronPort-AV: E=Sophos;i="6.16,269,1744095600"; 
   d="scan'208";a="55937991"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jun 2025 23:53:09 -0700
X-CSE-ConnectionGUID: 8EA9yOGUSpGtUzCDHHxyEA==
X-CSE-MsgGUID: vEUPM71kSemiEhP5NzK7SA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,269,1744095600"; 
   d="scan'208";a="153440951"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by fmviesa010.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jun 2025 23:53:09 -0700
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Thu, 26 Jun 2025 23:53:08 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Thu, 26 Jun 2025 23:53:08 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (40.107.223.76)
 by edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Thu, 26 Jun 2025 23:53:08 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=xTGb6h5E71hgf9QifhsZh8tngWZt+InIGkyAD4e5x3cxwleAWFlNB8dBw0KWapb0Wd0yq//PH2ko3tl0FEoQGvkX/lj+Rs89aRYvG1NQKSXlzQPJxcr9kaa3qGvB9zNubv2cXJBO914P3yLjVNMMaEEVsRzK7+CnRy5EndGyiTvFFCNp8o5Cj4AbGn+syxBwTliYM4LRe1rK45mHEf6D6FoxHPahcm3E+VatTrjmcKCweCWRWb93yt0NKfUkSmhVpyg2y8ZYBBFaUxvJuIwbJkmHZ0ht9ugatp86AtJHMa4w5P9oFnVSJPnu26RC4B1i2R9rMxyhE8KYNDScoy2wKw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5fsFRqzu2CUBlW6+uY/EpjZsR/Xx7YYZIn2hy9Uuh9M=;
 b=RNLCx8HKrFRgztS+yo+3jDb1PBp+D0Ilje7gqqm4IrAqht6JSpXGfSMR9Yd0XDZrmvqXX19GQ5spO5wSnudLnUzxz1iLYuSAVJfcFciwNLG3B0UWUJWcmjFkR7tooD8iT0g+D6sf/Y6ujOhvEmFNsBAUPvIKdK/S2he+VVGy2OKuW0VHVUp4J3HQDAoVh4SC8myhMhzU41AY8sFjH7UmtEgjp/pIRgs1XC2m/wbCq2MwP0ziynZGI4zsVajQea3KqPoBA5GhgCm7FFvBSqTvY45qqUNdouSVS8ANnm42Dr1g9tb7j47wQxaGgZr/DdrlotskiUYLOHYwmgx/p/uCSw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM4PR11MB5295.namprd11.prod.outlook.com (2603:10b6:5:392::14)
 by IA1PR11MB6324.namprd11.prod.outlook.com (2603:10b6:208:388::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8880.23; Fri, 27 Jun
 2025 06:52:39 +0000
Received: from DM4PR11MB5295.namprd11.prod.outlook.com
 ([fe80::769a:177e:10f2:f283]) by DM4PR11MB5295.namprd11.prod.outlook.com
 ([fe80::769a:177e:10f2:f283%3]) with mapi id 15.20.8880.021; Fri, 27 Jun 2025
 06:52:38 +0000
Date: Fri, 27 Jun 2025 07:52:31 +0100
From: Suman Kumar Chakraborty <suman.kumar.chakraborty@intel.com>
To: Dan Carpenter <dan.carpenter@linaro.org>
CC: <linux-crypto@vger.kernel.org>
Subject: Re: [bug report] crypto: zstd - convert to acomp
Message-ID: <aF4/r+03iqzs4c9H@t21-qat.iind.intel.com>
References: <92929e50-5650-40be-8c0a-de81e77f0acf@sabinyo.mountain>
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <92929e50-5650-40be-8c0a-de81e77f0acf@sabinyo.mountain>
X-ClientProxiedBy: MAXPR01CA0110.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a00:5d::28) To DM4PR11MB5295.namprd11.prod.outlook.com
 (2603:10b6:5:392::14)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR11MB5295:EE_|IA1PR11MB6324:EE_
X-MS-Office365-Filtering-Correlation-Id: f0d5e07e-f700-49b3-b744-08ddb547343f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?T2ZrbTFtT0piVHh0M3dlZ2RRNFNYZXJFR2wyTGxjdWxTSjBGWjlhQmV2TEJ5?=
 =?utf-8?B?TVB5bmNjNmg0UUgrcVZRK2xzOHB5SXJJZ2M1cU04WHZSQmVLZzBPRWNIb2ZM?=
 =?utf-8?B?WWJOaTFSOUd1c1RNeVVPa25GMDdtK0xWT095YW54eTYvUTl2bUlPSEY2YlRZ?=
 =?utf-8?B?MHlOajhQZm9kb0JQQS92dlphRVVhVWttQ0hqMEdEaE5Pb1I1M0dpa0Fkdy9Q?=
 =?utf-8?B?eldqejQ3VmM1V3BUT0p1V2FSUFBrY3dMT2JZcm9WcTFDTmtGbURRWEhiOHhi?=
 =?utf-8?B?cXp6TGhLWVJFWFZncktkTzE1T3VKY3BEYWU2aHJWNFlhTURiRE9ab09TNk9N?=
 =?utf-8?B?THlvMlJRa2cwa2szNTBHNUtLckNoRjcwZm1xUDlicjFvN2VUbkFFazIzc3E4?=
 =?utf-8?B?K1VBSDVkcHlEczJVNmpERUtBVzF6SDEvNUpURlgvbjdpenVDWUM5SHdlLzVY?=
 =?utf-8?B?SlJtSkNtMUU2Tmx5SENLbmZTSGkrTnNqdXEzYmpNNlBzNFVYeHRpd1NHNDBq?=
 =?utf-8?B?QTQrZVVSQ04zM3g0QlA5N0pHVDVXRlNIMTFiNHJBWTFGbzV4S2VVMmw2VVV4?=
 =?utf-8?B?VlVuNTN6WXFjb3JQTFFXby90dVRpLzVqQ0R4cllnWnBNY3VUNGt6WER3ZEtU?=
 =?utf-8?B?S3lVNjg2OUlzWnYrSTFvSk1pYzJvalcrbzdKZ0g5TXZWMEtXNlJ2QmhRSmhJ?=
 =?utf-8?B?MEVEalV3QjZOZEgxK05pbGVZSGpPMDZDV0N6dHdnQkh6dlZkL1pWSDdUVzZ3?=
 =?utf-8?B?eHk1TUIvU0UrVjhiZ0hkNmFMTC8wa2tmOHdCUDE0U3ZKNVZ6WmVXbE1iT1Az?=
 =?utf-8?B?V1BvWDNoWExyYUFkdHZabExmRFd3L3BMTWh3WWkwV0xVMkVmcENvR3JYVEVX?=
 =?utf-8?B?VUhUeXhsYmdoM2M0TVBxNWd0ZkEyS01PNG9kQU14ZVFzd0VmdVlmME1HQXE4?=
 =?utf-8?B?Qjl4eEdTK2w1cXBZZHpENlNYZXFVMkVzMXYyeWVQWGhXRWxiVlhURHBEakJh?=
 =?utf-8?B?UVZjeEZ1bkU4Y1FpMEFnOGpWa1ltdHpPWUZFVTJLWW1GczFQaGJISWJmMnNw?=
 =?utf-8?B?UkV1NE1sSTlranhWOHJ4WjNQMkFTbTVZOTU5YkhPYnd5ZTRyU3d2RVlneXR4?=
 =?utf-8?B?bzlUR3lhWDloTklFVGpRTEE5Umt5V3N2bURBQnBnSzZhNWQ1Z1AxMFpKRndp?=
 =?utf-8?B?UU5MWXAzcDZOVkx2TVZMUmdNbHhSYXZLNzYrd20vbnVkTWlaR1ZOeGxmbTdW?=
 =?utf-8?B?azZWMUJXc2FxMzlTL0hkd3BqM0RQUXgzeHNYVUlDaDdZVUp1THEvclBVZ1FM?=
 =?utf-8?B?ZzdyV0RMcXF0blJvNjFYSGZtNW5CS0FJYW1lTExiSEVoR2FQSUFrR2E5SGVQ?=
 =?utf-8?B?K094N28vR3U3bVZXU3YrU0ZjbEo2NEhXZ3NIbDBHQXhRV1dRNFlKdHNNd2Rp?=
 =?utf-8?B?bGlDOWNNK2dPT1VxcktzWjhpOVRJb2Q1Y2lyeTExejhDZHl1YmIyLzVVM1pm?=
 =?utf-8?B?MFRHbGJMekhkbVloZVJjWnB4WHBVeG1yMWVoUzRCRUM5SElxUkd1akVjYW51?=
 =?utf-8?B?ejhHZ3loVXN6emJWUlc0M0ZTVVBlR1paVlZhaW9ZVkdtQTcxdndBcHRHSlY3?=
 =?utf-8?B?QytDUGcyMEhhYVlDaFUyVUs5NmZqZEV0dEt2LzYweHh0cWFVN0dMSEI4K1RN?=
 =?utf-8?B?K21ic3gvK2VKd2ZHZEowMDRnankvVlB3QUV6WXZMa0pVWXFpS2thbk5yUVd3?=
 =?utf-8?B?dHo3eGdleFdGVGZDZGFVZ2llakZYUDZ4VmtONXFIQk1qZXBxNENrbTJ2ajdv?=
 =?utf-8?B?OHBsMzJkVEhUcmlYU21zZTZDUVYzRGZiZFdma1pTdGRwRGh2ejBLTEdsWHQy?=
 =?utf-8?B?SnNwb20zSGR2L1RnT2V3NFA4WGZRcmpEb2xrdVFUMzVPcXAyUElQZ0NHcWpW?=
 =?utf-8?Q?dsZ2l+Wtiwc=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB5295.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?YmgzdzNIeU5mMklqU0FDaXJ1SDVEMjI4aENSaUxJeHlLUEtDejFCbHFxNmJO?=
 =?utf-8?B?L2RIV2xHbW8ydk85TG8rSVZwTGVoMnZueVMwdWlBOEFoUmcvQ1h6SHR2RG9B?=
 =?utf-8?B?dnNaWGJQbmg0YVdtN2FvZVdvL2d3Q1pEZnBaMVRvTE5ydGw3M2FzZzlHbGlK?=
 =?utf-8?B?aW1TdDV5bm40Y1dnM2puc0RZRDlQY2hsaW82b1hoSjA0WkNxTk9EbmZMYzF1?=
 =?utf-8?B?SUZmbmdpUWFJUHhWNVV6NklYVmF6M1VESzBabVpaV2o5THlPYTVaNE1tb1oy?=
 =?utf-8?B?OWlkTHE0aVdOQmxDU3lBeXNzejd1WHNONFM2Vkl4QVAxR1I2OGxjaE5SdlV0?=
 =?utf-8?B?dE0rQXgyUmZwcDFwT2Ntcnk2b2hLSlRESmRwbG40YjhjdnFjQkNpZU5rSi9z?=
 =?utf-8?B?aFN4cWdPWU5obTM5R2VpemFvaWhSMUQzV3VqN0VtNm50SEZ3ckNFYXN6L1Mw?=
 =?utf-8?B?NnR2ekFlbVQ4ZzVzSllyYThNNnN1dXdEZXhYck9kQ0NQaXgzQ0NaQ1BpcVAz?=
 =?utf-8?B?RFRWTVNzOU41RVFhdmtUdUx0VU96RXAxTnJaWkN4YVdEalJ5dnJNYUpUcmhy?=
 =?utf-8?B?aXRSamQwODdSRlRuQ3I2OG0vbXA5Zk5nS3pTL0lzUUROd3dwNHhucUhPTFVv?=
 =?utf-8?B?enFhVXcxSlVhWjB6SWFmMlQ3KzdCVTRVK0RmY0ZrSmZodHMwVXVtcTA1RXFY?=
 =?utf-8?B?a3NhZUdtUG1zM0hGSG5MbXA3K1FLZkRhVDhUU2hBa3dOUFcxT2VjU1BHclk2?=
 =?utf-8?B?Q3JtaU41dytQTXV4YmcrR2NWVlZFMEZQVDlJeXVDUDhFWmNsSEdGa3ZHNURO?=
 =?utf-8?B?MDVqZ2tkSGxxOWZPOEw4enhOMFpSYXM0T3E4U29ub0pWczlYQkxCMklraGtR?=
 =?utf-8?B?ZGZUL0J2RDgxWnNXbkZQY2xXbHpaM3NnS1RJSkF6NWFtRTdtOXJmMHNOM2xD?=
 =?utf-8?B?OEd6Rk0ydzhkV3pGWDIxeW1PeUFjQXdCQWZOQmM2ZHQyakRRZi8vS0RiZmZY?=
 =?utf-8?B?S0J0clpGdHgvR2piYUY1T3JiSE0zQWY5TVFTaGZBMWhheU5idVRWOVlWaTYx?=
 =?utf-8?B?WEF5WWM0VW1uNUs4b09UVXNlMUxBOCtybmNDNEYvRGx1b282ZFg2WURUeTg2?=
 =?utf-8?B?MUpYQm5Jd0FHUlRhbzdGdSs1RE5wRTc5ZnM2UXBkWWtibG9UekNya1J4UDZO?=
 =?utf-8?B?MWl1SERFbUJPM2YvTS9xazV1V3ZnQm1tVFk5Q0ZVaTlBZUJKUUt0YnhSNnZ3?=
 =?utf-8?B?K2NINGVjVUpIaHZtK1BlV1dydTJLTHNUR1MxZUpucXhuQXR0VjFNKy9GUE01?=
 =?utf-8?B?d3lwbUFya3FmYS9URHYraFBzbDNvSjhIUWV4LzN4NnhTVlBxby9KNG1GbEcz?=
 =?utf-8?B?bHU3a2lvbnFERkpWOENwV1kvOGJSbjh3d2RadXlOYSsxd3k3bzMvMTdPc0ZX?=
 =?utf-8?B?SnRETFlhRVMzRERraldacUN2TW1UTzBWTDlFYWNuVnRSM3luY2wrNHRFMGNk?=
 =?utf-8?B?OXZSbHkzN2RYUTEyMmNqUVZLM05rR0ZmMEpzclQzb095KytLWlVabm9WT1U1?=
 =?utf-8?B?aVlGZUo1SkUyOW5VbXNsclBKem9lUHVlbjJwSUNOVUs5bjZmMFlFdG9iZUxE?=
 =?utf-8?B?SG1oMEdXNE53NXk3K2xVVThBaUFUSGhnR1VwaGdaMW5weUFkVmtERjhBWC91?=
 =?utf-8?B?eGozdW9Pd3lZSHhBQUN1N2Q3WkdsSVNqWnRvSXIyc1o0R1RoOU5TeXQ4bVlC?=
 =?utf-8?B?aGhldnlCOE1lMzFheko2blc2QUVpVGZ0bUVnNGVNU1JKemQvMUZTWVdpVWZL?=
 =?utf-8?B?ajJqWG1VTU9BN0lwL0VUcEpvOGoxNEM2N28veG9nODByTXpzZWlVU0RkVENV?=
 =?utf-8?B?VktudCtaWExTTi95ZmtGMC9qWHFnRTJ2T0RsV1NHL0hTa2p4T0NJem9BWVhi?=
 =?utf-8?B?S0VJbTdJZDZSSFlpblkyRGJGQUczbHdqMWJodk8wclFYcVFVUXozWFE2ZWdv?=
 =?utf-8?B?dFJBcnk0NXZMdmlYNUFnL1F3RjEzNzdCYmlSNk1hTDJTM0R3SzlURnErb1Vu?=
 =?utf-8?B?UFY1MUE0TTV4bXVKQXltTytIRXl4Sml5TkhLdEtTTHA3WkJtOWRpeGVYRmwx?=
 =?utf-8?B?RUFNVFQrN21obGNNc0wyTHFlY0VrYlhsUGNITXVScllrNjFCcGhzb0R3OU1C?=
 =?utf-8?Q?2w12Lj3SObUxSFS+z7cAW8A=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: f0d5e07e-f700-49b3-b744-08ddb547343f
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB5295.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jun 2025 06:52:38.1537
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: S/awTHu0NjBPq41qgK8dW8QXdSCWLeOHMAOXf6iygn3SoG21sAXrtkjh6tAdtuMt5Siy9jpdamYjYTSCoanS/eN+jVWUopb4wLQz+L/YlWzf7EZC/b+bDJ1BT6WUJkjE
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB6324
X-OriginatorOrg: intel.com

Hello Dan,

I’ve installed the Smatch tool locally from https://github.com/error27/smatch.git
on my Fedora 38 system. However, I'm not seeing any warnings when I run it using the following command:
make C=2 CHECK="/root/smatch/smatch" M=crypto/

Is there any configuration that needs to be enabled for Smatch to work correctly?

Regards
Suman Chakraborty
