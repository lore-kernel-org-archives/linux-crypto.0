Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F4941E520C;
	Fri, 23 Jan 2026 22:59:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.8
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769209176; cv=fail; b=fY8beFY68MEIpO0rtZkFcIAC9QcU6gT4IzoTGMIC9iBHuEG9hfbXF0S3HJyr7zNuMrPGujN0DRt7lX7XXIV6ZdKQGXQoLaj4id9fIxlsFnk1v1JD+yXuTmdDDBJ4/ERDXCyXc+sOO9Vvo2lKwEYeCu9orXWzEMh8HYcnwnA3b2c=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769209176; c=relaxed/simple;
	bh=cYVGVYZeOE4iauRJni/GbP4V85PTJyhSDvJZVtAs9xo=;
	h=From:Date:To:CC:Message-ID:In-Reply-To:References:Subject:
	 Content-Type:MIME-Version; b=WHd6oIqQ5rxHar1ObZe2rQXrGpFaIpx/4PQEZiFi5SdM35APGUx4mm5IaHUFlyM7VfRur4owzXg1eyWa8oJ+kIWah/DgM4zX4v39Tw+r3II21j7VMl90Q2bdHyasmTXQrZhuOGYrJGuG574IuOK9SkXYS/M2nxW1PtTUq4C2Pxo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=kIQMpvAD; arc=fail smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="kIQMpvAD"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1769209174; x=1800745174;
  h=from:date:to:cc:message-id:in-reply-to:references:
   subject:content-transfer-encoding:mime-version;
  bh=cYVGVYZeOE4iauRJni/GbP4V85PTJyhSDvJZVtAs9xo=;
  b=kIQMpvAD+VXu/pAgYySuJYDG8vHXIn5DHQu1Q6FzbR4fQL4VWgIMMyzD
   x1HLauHYQnhb2cTGNjP7rSQ/VJqldEadVOOpozizYn9VEIYdQjNSCsPyh
   rN4RDi43afbsA41LGkc30gfgVTfK06T5uLow+hBRYd+Av0GLqh4p8xbCN
   ArAFSn+CmmRGTI75TL+1UKQXLU2gL3oboaG73NDGxHN44rVGbVQ+Vo3Kk
   7S3DZMNrkgCqJUYK1ubGNmOLctlWA+KbCQ4PtJlJFM9zX+CmuqFbNcK+k
   TnMbIidi57ySlZ5Q7COAptudjZymDQzOcIvph1RDGqSCT5viDQAfVWMn9
   A==;
X-CSE-ConnectionGUID: kQGFMAerQNGVjEv7spjjZA==
X-CSE-MsgGUID: 5Xy9nyiDRLq3hvnbRhu5vw==
X-IronPort-AV: E=McAfee;i="6800,10657,11680"; a="88041614"
X-IronPort-AV: E=Sophos;i="6.21,249,1763452800"; 
   d="scan'208";a="88041614"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Jan 2026 14:59:17 -0800
X-CSE-ConnectionGUID: 23tqjFLYQ/uyqi+k04dlzA==
X-CSE-MsgGUID: l+zM0mA/SlWEHy+576ndLg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,249,1763452800"; 
   d="scan'208";a="207190245"
Received: from fmsmsx901.amr.corp.intel.com ([10.18.126.90])
  by orviesa007.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Jan 2026 14:59:16 -0800
Received: from FMSMSX903.amr.corp.intel.com (10.18.126.92) by
 fmsmsx901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Fri, 23 Jan 2026 14:59:15 -0800
Received: from fmsedg901.ED.cps.intel.com (10.1.192.143) by
 FMSMSX903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35 via Frontend Transport; Fri, 23 Jan 2026 14:59:15 -0800
Received: from CY3PR05CU001.outbound.protection.outlook.com (40.93.201.7) by
 edgegateway.intel.com (192.55.55.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Fri, 23 Jan 2026 14:59:15 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=JsSlGl7AlucBiWBzz4zV4E87jZEcAAw0+5f2LP6HJ4DvNAJ45mTtUMzACduP8LFqX8aWGwNhwitb3SD3pec/e/EHqFhvuG2VkYI5zZqugmf1drVoN0lLh/YUTiVuDICYY/YOb0q8wMrKi1QehlPqgGfi00PEfE9Gsoqp7gxiVa8u7gqObs+GjATLUgMVC5Qg968c4+p8jKCUl80ho296en7u6Wg95nUCX1VPqmb7K9qHd/fWy2v7GVeMqTPK/Dyben0C05T/FM+YhcxtqY/pkhTbmIH9twbQfrQOF3Q/vyLomOXbt3Gy0DytQHjNAZuU1g4xQ5IFm5CI1hz3ChEBGA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cYVGVYZeOE4iauRJni/GbP4V85PTJyhSDvJZVtAs9xo=;
 b=kL9SOeUOx2jzw3tuHI1cOopLKmZSSP3IZdu8YZU9XZOxERCWDH82auSWUN8ruyuDn+57C2xGg0tZc5gy5PLlJHc4wVvwSjvFDHq6HSl2umTA4viONi2Yd1jBGIdn1uCSg264K6Li5RfbKy8qDerymPW5i9s5DRbWd36PVbvwSjT0AhEm4fL9FUtcmQP0m9IuRALD6wkIyMccYYYkcdyS+b/qtUbIE/8fk8gS/PKuQBtt2RcWD86GOw+KXeaIcoxeO0uezRBWV0cJbFmaickqYc8mkMziicc8i3o/R24dk29KJijW+ap1y37dAa+AQVb1+PMb0VOzsUUvaYXCyVzOCQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH8PR11MB8107.namprd11.prod.outlook.com (2603:10b6:510:256::6)
 by CO1PR11MB4978.namprd11.prod.outlook.com (2603:10b6:303:91::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9542.12; Fri, 23 Jan
 2026 22:59:13 +0000
Received: from PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::1ff:1e09:994b:21ff]) by PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::1ff:1e09:994b:21ff%6]) with mapi id 15.20.9542.010; Fri, 23 Jan 2026
 22:59:13 +0000
From: <dan.j.williams@intel.com>
Date: Fri, 23 Jan 2026 14:59:12 -0800
To: Alexey Kardashevskiy <aik@amd.com>, <linux-crypto@vger.kernel.org>
CC: <linux-kernel@vger.kernel.org>, Ashish Kalra <ashish.kalra@amd.com>, "Tom
 Lendacky" <thomas.lendacky@amd.com>, John Allen <john.allen@amd.com>,
	"Herbert Xu" <herbert@gondor.apana.org.au>, "David S. Miller"
	<davem@davemloft.net>, Dan Williams <dan.j.williams@intel.com>, Alexey
 Kardashevskiy <aik@amd.com>, <x86@kernel.org>, <linux-coco@lists.linux.dev>,
	"Pratik R . Sampat" <prsampat@amd.com>
Message-ID: <6973fd402a74a_309510049@dwillia2-mobl4.notmuch>
In-Reply-To: <20260123053057.1350569-3-aik@amd.com>
References: <20260123053057.1350569-1-aik@amd.com>
 <20260123053057.1350569-3-aik@amd.com>
Subject: Re: [PATCH kernel 2/2] crypto/ccp: Allow multiple streams on the same
 root bridge
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR13CA0154.namprd13.prod.outlook.com
 (2603:10b6:a03:2c7::9) To PH8PR11MB8107.namprd11.prod.outlook.com
 (2603:10b6:510:256::6)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR11MB8107:EE_|CO1PR11MB4978:EE_
X-MS-Office365-Filtering-Correlation-Id: e5af0bc0-7099-495e-402a-08de5ad30722
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?TWhLbjl5MUJibTVjd0hoMnB2NlRRTlRsNlV3WWlJTWpqOUR0TTBhWURGRlJz?=
 =?utf-8?B?YnJyR0NCNVRNc2NXbjE1dTc5L0prZ212T0VnV2dMQVlXbFBFUW5uRUxuVjdy?=
 =?utf-8?B?U2hHOVR6SVNGcVpuQld3OTZWYnJYRDZFS1hjU2dTV3cxSzAyaWZ4cHA5c3c4?=
 =?utf-8?B?VWpqdUZHc1ZZT3pQakY0MXJCOFZ6MHFtdnoraE03VHh0dXpuSWFhQ1VaWjZp?=
 =?utf-8?B?dmxBZ3VOZjVJV0JzbERvQXAzMjROODlyNFBGNEVRbVd6RmdaZ21TV1c4Y1pv?=
 =?utf-8?B?b28xMXJ5VTd2emNnREMwaUsyVU03OVRINnVpSitJT1ArSXpZV3MxVGxjN2xx?=
 =?utf-8?B?ZWI2dlE0aDNkOFFWTFNFZVdDSmVML2ZOSE5lM29rb1lVNFBhanJqMFA0N1hG?=
 =?utf-8?B?Ykpmb2N3M3Vxamt2bjVXclc5WUJQOUZHTFQxWnF2ZnB4azVtNXhielpLK3c0?=
 =?utf-8?B?dm01dnhVNGhuNUJOUjh5VzBBeDllVjdSblI5MlRSOHRyMGZIYnZIUnU0bVlH?=
 =?utf-8?B?R1V6bE1WRjVYcW1VbWlURFU0TmJMMk9ucnh6MVlPY3NQdzJWY3Y0OEVJc0N3?=
 =?utf-8?B?N1RIYjg4T25LblQ2b1A3K0FBbkNiS2Z1c3hXMzlSUnVscmliajFQYk5SWklj?=
 =?utf-8?B?dGtDUlRGMGU2NlBOUU45ckNwNG5vbVZ4ZU5UQ0dkSUNGSUs3Z1BaNlEyZGx0?=
 =?utf-8?B?UFZRNlpYaWtyRjFHNEg5SEhQUDg2a0t6dC9zK2x0d200dWluellwR09RUnBE?=
 =?utf-8?B?RUdOcU9mazBXci9IRG5MK3B5ZERwV0RuMW4rMUZzRi94d0RSVHJJZXZtbVlG?=
 =?utf-8?B?TCtFV0NuYU9BSEhQb3QvTGFFREt1K1JQMUV1d2V2OTBqN3Mydlc5S3RDQ21U?=
 =?utf-8?B?bmJWTWsyRlE3SHRLVkdpbGdYQVl4dFBNdVZtNVZjanVkMXpBNlNEYlhETjd4?=
 =?utf-8?B?UE9rTXNRclhIVVhXbmd2VU4zc0pKeTNYVGE0QUNCRmtRK0ZIMlRkSmRtaTZs?=
 =?utf-8?B?N3kxbTVFUWlxZXhVZGQ2Mld2Q21vamM1eDJSUlpnampoTVlwYklKM08rd0JS?=
 =?utf-8?B?bXVmVzV1QkU3ZmlqcUJVSkZXdVN4aWR2VjFSR2ZDb2FzS0x6R05HOFdYN1dH?=
 =?utf-8?B?WlZneGJvMGI2QXh4OUM3S3NNNVhnYStaUGZrTlRXN0NwR1BLOHhha1U5MGdE?=
 =?utf-8?B?M1o5a3JjNlI0UmllUlFueitwZ3ZzRGpUTjcxYjFsclo1ZE1KeTdiOTBMbk4v?=
 =?utf-8?B?SXZaOGV4ckFnWHBsNjZUZGhaWnBxNnkrVlhoWVdrSy85N2dWWGlKUFZuY2lt?=
 =?utf-8?B?ZVB4NDVHQmRsNFVxRTM5c1E4K0dSUnZLYWNZMGpNeExKZERXMU5kbHAxRW1S?=
 =?utf-8?B?cUMyS1h6c1RJZ2JkWU1vWFd4VkRRZ0NvQys5OWZpK1hXQ293MVQ5a2VDNHpS?=
 =?utf-8?B?OXVPb1VrTGZFN0RST1l0ak5EVmxKTmg4bXF2WmMybUxzUGsrZEQ2WkswT3pV?=
 =?utf-8?B?YU5VY3dJZHZWVVMrdDRRNVdCZUFzNGNhOG55ODBTRHo5VVB6aDhyaWZvT05M?=
 =?utf-8?B?UGVsVUYzV1dXYlZmMXFPT2dWY1NWNi9nTHJlY2tzaytFdzhqNm5GT05OeVJz?=
 =?utf-8?B?U0pWNEdzMlBaN1JNRm84OGJmcFJFK2NLY09PNVhSNVZrUUplUzBiRE42aWRm?=
 =?utf-8?B?OGRKL1g0b0hONzk1bHNRS2Nwdytsc2pSd2NhY2hsRy9jbHA5TE9OS25qYmIz?=
 =?utf-8?B?S1pnejhTeFdZOHlKdTZ5S3pHQ0x0SUFZeExxU0t0ek1saE8xeEJRVFdNNzlp?=
 =?utf-8?B?bkUvR2orTitCdS82V1lZb3l6Z2I0bHNTYjFBVkU3dGYrcUp5anFaWnoxNm5W?=
 =?utf-8?B?c2Uwcm5vei9ua285U0ZmeWNjYVZGK2FzaE00NGZwYmN4L0RHQ3I0YmJYVXpy?=
 =?utf-8?B?cE1rY0ZjNW9SUXJHYXlHVitzdVFsTWNTMzNPZWVPcTIxa2cyQnM1OXNWMVBI?=
 =?utf-8?B?d2pyZEtncFBBcUphbU1pY01RVG05TWI4UUUvd2RIUUhxT0VTNkVlaG95VEdW?=
 =?utf-8?B?dy9UOXFaSEdTVjEwejNvZ09GTkJBRkVpWnZibkJ2NFRzOG00cWpDcU9tek5u?=
 =?utf-8?Q?zVn4=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR11MB8107.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?NFowZndsRDdoUFhtRkVhSXNYVG5CTXorREMxQkFlWW5RZ0xoV2J5MEcyNlBw?=
 =?utf-8?B?Q1MrZVJOcS9JSGVaL2xpMTF6eTU1WjVzTmQyTXNTVm93MS93WTZIZWd4YlJS?=
 =?utf-8?B?ZkJKeUhOTFJXOXB1bU1xKzVMdU9vMkZ6WU0zZlVRam9DTzR6ZGo3WlhrL2Y3?=
 =?utf-8?B?ZVNSeXVsYTI5OHJOR1NLR1VUSmRvTW8xMHAxZTJCd0pCcUlBTElnWDhQNzVk?=
 =?utf-8?B?cEZqK0R2OFF2V2xSNzJkcUJULzlxMHhyZFA0NzUzVkgxS0h2eUJ3UGJkS2R6?=
 =?utf-8?B?dEcwUFUzak5ISWY2bGRPRkxvcHMxME84Zk16aTZWWmVBT3ZPVnU0WG1VcG1i?=
 =?utf-8?B?WnZ5Y3hyQlloWVc3SUd1Y21xTU84VVFFMVoreU5JV1Rxby9OU003MzBJSWt5?=
 =?utf-8?B?QVMyNjQvbWhacUVOUjZSYS85OUQwK2tNVnRBYmd5OTJ1Vk8wQ29iaGcxT253?=
 =?utf-8?B?N0hhM0xlcjlnQzZnQU9MUlFhT2JvcWk4WWNQL3V4RVU5WXd2TkVmQVIrc1h0?=
 =?utf-8?B?bkNlWmZPM0VtdlVEOG5OcDVKOVRFc1NodFJqaW9TaEg1NWlBNFRuaW5tdGFU?=
 =?utf-8?B?c3pHaGZPYldOOTAyY3hncGJ4aUd2RnlJZk1jb0J3WlFVZHhibnZNMzZtZ0Rl?=
 =?utf-8?B?ais5K3hVZ3QyZW9DS0VoditBbFBIN0J1WllOd2RYRVovUlhPYUFyOE9QWnpC?=
 =?utf-8?B?TlBQOCtJYnZJYjZnbXJkTXgzM3F2WUFNTGhRU3p0emw0SlhNL3lRcitINnJS?=
 =?utf-8?B?WnZSNFVSY3IvREdIVmQ1ZTYwM1hNaCtoRkNXZkhhTk9RS3ZNeERpSHUwNnJ6?=
 =?utf-8?B?WHlQVWJIOHluV0hvM0lLTjFtOFhTUXYvaml5dzdIQ1FPVHRXbklVeHoxWDBG?=
 =?utf-8?B?Rm5tZ2tSK0xKdHB6T1o1d2VpT2dPbmFUQ2l2NHdURC9YZDRwQjZZekw2Y2Jx?=
 =?utf-8?B?dnFyL1JLc1loNE42b3VpQzF6UC9XQzEySWdZVWM4Um9yZWpBQXdHVVl3dHh1?=
 =?utf-8?B?Y3NtY3BxdnFvb2lCUXpNUDdGclcvOWpWTWs0aXA4RHNQN0IwRFhvcXJXUTdX?=
 =?utf-8?B?WVU5TzZTTWtFM0hrU1dKUDQyNUpTbE8vaXFJcXVZdHlzbXo3SXZDUEN4dW5k?=
 =?utf-8?B?YkJNZ09pcXNPTDRrU2t4bWdmdVZMMjd6WVhaKzRZRWVyUlU4MFk0dVkzUkI0?=
 =?utf-8?B?VjNjS0s0d00rRjB1T0ZlWklBdmhvYmFDR1Q1T1FMcHBpZE9VMnNkdjdwK055?=
 =?utf-8?B?QkdhK0V6aXMwc3d6eUo1MWZYK2hqMzFwajlNKzU4N0JISVlITUZuQ2J2K0VP?=
 =?utf-8?B?cWdsTW9yb29naGRJaWJhSDVqK3B4bWgrTjE3ZEZhQzQzY0JKTHBEOGhKdlZp?=
 =?utf-8?B?SlBVejVHUS9SZ2hWbk9ZUVo0Y2JleWp1citnR3VXM2RCaW5RRUlKZnBDQzBH?=
 =?utf-8?B?dTJlVW1GQWpoZittZDkvV04yOWZWeENnckJiQUQ4dWtTTHJnazFOSDNnd0Ns?=
 =?utf-8?B?NHJuNWdMazk2cE1xRldoQjBwcTBRdXlQajJSZE1Bdjd2SGtwMU91RnlnSWtJ?=
 =?utf-8?B?dENsby9RVFpqYmZnUjlIRUoyUUVmM1NTOFZrVEQ4eldDQUkwNWtqUWU4MjJn?=
 =?utf-8?B?Q1lJNHlmV2xCYXk1MTVjNi9obXpyZlkwOSsxZkdEVWlGMm9xWjVBc2lJaXlR?=
 =?utf-8?B?Mk1yc3NMODlPdTFFZjUwWHdpbnJKM1oyaVc5OWdvRFJ5RmJla1lITCtvbVBh?=
 =?utf-8?B?RGZhLzhzZCt5YUtKQmg3aWlrODU4bWZNUEM4VFhvbzFMSDVURFF3ZTJ2T0hO?=
 =?utf-8?B?WS93TmVoaENBYjJGZU9GRlRXQTZvMXk4b2paRnRFSXhLYVlsdVdYcWV4NzBT?=
 =?utf-8?B?QURQY0xKcnJXVjI4SDJjSEs4aE9leE5IdFZ5T2hNamVhQUQ3dEJHbEJzSjZ4?=
 =?utf-8?B?K0FRV3JiNDZ4UWFzQUpjVFpUZ1VSd3hpdmxQQUp0YnMrZ01Zc3dNNEU4ZE5J?=
 =?utf-8?B?WWxEdTRNbXdwZVpoMUdkaDd3RytWNkNUeXA5d3hYZ1FNcW9wYnlYcmpFMlVH?=
 =?utf-8?B?RzFxQXdtQkdxSFhsL1g4anNYVC9pcFdmZDZua3BWTFN4dU5JT2M1Z3k2b3o3?=
 =?utf-8?B?QklxckxuVnFDT045MG91VXdoQmdvUngzOU9QZkFQSHVZNlhRWUQxS1pPNTdr?=
 =?utf-8?B?THMwZGxLYW5BdkYvUllyWDlNTzM4TXZoQlpNMXJvZTl0SjdocVl2TzJQd1B6?=
 =?utf-8?B?QTd4SHJRK0FJODJUTk9ockRHNkN6dVRrdmlaakt5UmxHcEFYeHhaVllYT0k4?=
 =?utf-8?B?NGZHcG56WGY3Nmcvc3kxeXdQQ3VHakxmdGthYlVrZnRIVmVCOHhlSVBvYjgz?=
 =?utf-8?Q?rFOAafgWfTorW7c8=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: e5af0bc0-7099-495e-402a-08de5ad30722
X-MS-Exchange-CrossTenant-AuthSource: PH8PR11MB8107.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jan 2026 22:59:13.8330
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2iPc3Z8Rj/ZeTRScaBtr4F9Cg6XE4cIFMJTgr4Y4Ee2IEgrOobwvlZ6ldSQnqAgrHrPqo3n6o1o9nGOUU3jQvsaXeYGhBDwj5CPnnJvmbyI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR11MB4978
X-OriginatorOrg: intel.com

Alexey Kardashevskiy wrote:
> IDE stream IDs are responsibility of a platform and in some cases TSM
> allocates the numbers. AMD SEV TIO though leaves it to the host OS.
> Mistakenly stream ID is hard coded to be the same as a traffic class.

I scratched my head at this comment, but now realize that you are saying
the existing code used the local @tc, not that the hardware stream ID is
in any way related to traffic class, right?

It would help to detail what the end user visible effects of this bug
are. The TSM framework does not allow for multiple streams per PF, so I
wonder what scenario is being fixed?

Lastly, are you expecting tsm.git#fixes to pick this up? I am assuming
that this goes through crypto.git and tsm.git can just stay focused on
core fixes.
