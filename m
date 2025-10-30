Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50810217705;
	Thu, 30 Oct 2025 14:10:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.19
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761833427; cv=fail; b=XQC59z2iZbMpVOMYCKzAj1TJnlogf41WZAeITIsSTG1S4Ki3QjWv7WxIeYdL2A4iZzc3fH0ewxSKKy5WbtOApOO1yojcOxM5fnBWL0forCybWqtPSzgSVjjPCmkM/du3e1MzsbYAnpCdVq0QvuLuIE5fol68umOKivuzC2nWVUo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761833427; c=relaxed/simple;
	bh=LWuRvbua8Cil8z+WzT51NtR6yKhQIhCYPoohHRIMWW8=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=berGXSZLfcV9czbKitLh+QryNCsuWw08aR2Vs2xxKpKUtAo679ATxC6X08PgYGG/PYAxqJ86bx19DpVr8x1qOj7+Bbj/vLSLifrb+yMVfJ11xIFmV3pHQoet6qYT8yoDAICcBLhiJMooyVw4WuxJWR7WWvYm3LCGr92bb1jl2VQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Xl8Ygv/h; arc=fail smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Xl8Ygv/h"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1761833426; x=1793369426;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=LWuRvbua8Cil8z+WzT51NtR6yKhQIhCYPoohHRIMWW8=;
  b=Xl8Ygv/hhSZUNpHI0X/nFmT6pZA5rJAhKQjneZvO2uWvs+iyJh7NZtvy
   MfeE7nK6VDssyj/BwIEP2AngRec+5Wx/YwxQbDbn6t0ZURHcSZtaH4CD3
   kJkycroLtnGZeAZWaW5dtIEuWqU9OvQg37cweT9HmAIIUAnduUeIKDx/K
   UXkiWhU4L2pJspWygm0P0lQeIM9OpCBLc0cf+DuaBBMvWUbZv0MczI+bR
   9syHqsaD4WEuu15MKchMiZ93/acHcAbXFUR6Dw/BmTbCRjkNFnpaQ9pL6
   IouMYTLHtF2piGeOxZ4TAlmwOfWr5KbyiegTigdyrtT8899Z59SR8tkdK
   g==;
X-CSE-ConnectionGUID: yg0rU+X5QSSDs3BvWmsGWw==
X-CSE-MsgGUID: JzTF6kbbST2vJh8t7tEC+Q==
X-IronPort-AV: E=McAfee;i="6800,10657,11598"; a="63860887"
X-IronPort-AV: E=Sophos;i="6.19,266,1754982000"; 
   d="scan'208";a="63860887"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Oct 2025 07:10:26 -0700
X-CSE-ConnectionGUID: X3wIkmWtTNWBo1qegHiAbA==
X-CSE-MsgGUID: f19cQfMzRouVk3eVNPe/kA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,266,1754982000"; 
   d="scan'208";a="209541654"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by fmviesa002.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Oct 2025 07:10:25 -0700
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Thu, 30 Oct 2025 07:10:24 -0700
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Thu, 30 Oct 2025 07:10:24 -0700
Received: from SJ2PR03CU001.outbound.protection.outlook.com (52.101.43.61) by
 edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Thu, 30 Oct 2025 07:10:24 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=t10uGbkap9IZxrXqrYlvZlgLBFPuhYp6tRJbzGlKxLMjm58TspP4+1KMRvT0n0MHRl1x+AeUx+QznMfsRh5xaIa3euQCd8nStFU59Y6Jcq3FuVFhRYM+xFPKX14TnEr5iGuaUBTPwvi/TSDqKMWrVY8ep7G7b8UR4tVdHWm2tC1hy6Fd0dvUQ6FpligOEX3TptGttDPIhI2+bSEi0ZZns+USq7Six9whR49dsKQV+nufljWnwyAEvY+k6fr7TDPGX62ZCNKWO1aSWH0AdBCZ/N0O6yQBHNZqI+ARudn1ZSnrlPxuWIq4dAnGVG9x2attvjVGowSZcJUp+b9vB5XLZw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KkvsNpsETPZhHQA7f/gQnUQxdWqgYLfaz222xKwmiyo=;
 b=VkVIg+AO9PbAT6/8eeHYSDdlHJ9U2ibFUM19veadnICveOK7MkXekNTujg/YOWvlY45bHLjtAiWCmpOL5Ir0SQFwBZPp/t+rKmLBrd0g5aCMQEQpLK8DtMojeAmgN+oX8n66o1ny/A2a3TFhI16eDVtbYKY3ZIuTB3x60z7JSua4Oresz2Vb7r7kjFv9fE+mKg7gIAKWJqygcqm0VJAM0nSuwBCI4zyEYmBhaK7Irau5u4ErL0h+gtaZAnHDa5bKchOZQ+TqlNyB1grOsqi/SVOPEK/wGA77zrFMhUaOcPfpF2oHDKRhFrylMUmOzGBVlfh8CoCF/fronhHhlXZBZA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CY5PR11MB6366.namprd11.prod.outlook.com (2603:10b6:930:3a::8)
 by PH0PR11MB7472.namprd11.prod.outlook.com (2603:10b6:510:28c::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9275.14; Thu, 30 Oct
 2025 14:10:23 +0000
Received: from CY5PR11MB6366.namprd11.prod.outlook.com
 ([fe80::22af:c9c9:3681:5201]) by CY5PR11MB6366.namprd11.prod.outlook.com
 ([fe80::22af:c9c9:3681:5201%4]) with mapi id 15.20.9253.017; Thu, 30 Oct 2025
 14:10:22 +0000
Date: Thu, 30 Oct 2025 14:10:15 +0000
From: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
CC: Thorsten Blum <thorsten.blum@linux.dev>, Herbert Xu
	<herbert@gondor.apana.org.au>, "David S. Miller" <davem@davemloft.net>, "Jack
 Xu" <jack.xu@intel.com>, Suman Kumar Chakraborty
	<suman.kumar.chakraborty@intel.com>, Qianfeng Rong <rongqianfeng@vivo.com>,
	<qat-linux@intel.com>, <linux-crypto@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] crypto: qat - use simple_strtoull to improve
 qat_uclo_parse_num
Message-ID: <aQNxx+sTMydyG2ub@gcabiddu-mobl.ger.corp.intel.com>
References: <20251026015710.1368-1-thorsten.blum@linux.dev>
 <aP81GIlKmMv4pW-8@smile.fi.intel.com>
 <aQNLqclwOpEhMcaT@gcabiddu-mobl.ger.corp.intel.com>
 <aQNwHuNwPy6rDz-1@smile.fi.intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <aQNwHuNwPy6rDz-1@smile.fi.intel.com>
Organization: Intel Research and Development Ireland Ltd - Co. Reg. #308263 -
 Collinstown Industrial Park, Leixlip, County Kildare - Ireland
X-ClientProxiedBy: DUZPR01CA0272.eurprd01.prod.exchangelabs.com
 (2603:10a6:10:4b9::12) To CY5PR11MB6366.namprd11.prod.outlook.com
 (2603:10b6:930:3a::8)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY5PR11MB6366:EE_|PH0PR11MB7472:EE_
X-MS-Office365-Filtering-Correlation-Id: 09037ec9-a3be-4399-9823-08de17be10d7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?sAb8N3vmIyojGguZpzJNgNl6nSxPwXUpPJx9Q7/CGvu9C7rIKNE5ckKWe0bg?=
 =?us-ascii?Q?hgytCecGjFv/X6SUVxPlsFC/Kg0M7gpYy7la/iXB7Cxe9dZ3Bf7t6uN2Rxs7?=
 =?us-ascii?Q?7SLP5ze2/reybojdL3XljUf4FpW54XozthxXI0jeUoKvCzhgjh/aq3lYpxqX?=
 =?us-ascii?Q?RpS8rlYWqKsrqQaIPyZxUR0KRnMGd+M6M4XgHAZNzVeXe9p2dm6zCTCG2gFk?=
 =?us-ascii?Q?b/KhZNlUANDp9ENswONY0LyqFzgWL9/bJ+UgeP806OyPh6TEf8zwpOUTlCRA?=
 =?us-ascii?Q?T2CQMTPqLmr4u3S0iJNZCzmOYhIaZ8ZZ6poErnZezp9eIDCGbA++DrSR4UZj?=
 =?us-ascii?Q?e6tqNE7hUtq2UT+UR1AqBtiSmV83ECGTmbr9ark9UUv5cHp+KYVH9fu6rfm5?=
 =?us-ascii?Q?EaG0E4Ue/8z0gG0sOh8KfzARAgy96mTOSRTXLos7zoLS0rGfSGEU4fsS6+yF?=
 =?us-ascii?Q?xpKnySf2sDFLTpe7xFLlE7wpn9QLlQjVofiV4tMfozfhKmB8Qr8X7fd7v2kX?=
 =?us-ascii?Q?/6F+0VszkaPTYpo2oZH9TI7X1RFRb68koDSOj3982KztbQPHrt7UA1kOSV9Q?=
 =?us-ascii?Q?ztkPIR5aELxfhtAoEgJLnC41neKevW6E+275XMi6nLUcK9MVo9VjQ5qucoFL?=
 =?us-ascii?Q?N9GsaDt83UGGMBkQkY/hre+1+FV5B7MwoX5pD/a1r3OUMDI/0N7NqW3vXdm0?=
 =?us-ascii?Q?bfjyjy+ZHhIAUJ4cOcVcAVi3OM2D9hMzZhROzHyqKHSXPNZAvRI9pqtNsp23?=
 =?us-ascii?Q?7f7/QPFXJQ6Gsz8pQ02M/9RRB4bQ0BipZ228xBEbmkSACv9PDLpLcIZQq6eN?=
 =?us-ascii?Q?+Gf7Ppbpfrvgd0LppsTvfQB3c6rQr9MuYUraR7oH0po9VvKLlHWJRVrWU82k?=
 =?us-ascii?Q?WpGq1dg3rBcM6MB5ceTbbe3lz2bcpB5ZVJ6ordcqTIcBw+00rHZcu+N9QPRj?=
 =?us-ascii?Q?N59DULQ6+oZMGD/cdAgcnuJuakNABEOW5vC8mHwxfcwDg0X6oymjN9RRJp53?=
 =?us-ascii?Q?+xsvGRhTaUPLbxc4BlNN7A4I5m0x6fJCjW8UlDTWAfR4IPws2rFJwio1yUD3?=
 =?us-ascii?Q?9I+u1UJPWyz1ncxOey7JbCjalASSkGLbpyC2MOD4t3+S29qeosJCJSNM0gti?=
 =?us-ascii?Q?CIVvJvPqYudWxKOdFR8OzjOyYniKUrF5eWpb5mTvvO6mFrk+vSX9oWKRzUnS?=
 =?us-ascii?Q?89qqN4sgRG44Ty1zYMQG4kM0VkCjXJhru7YGz/VAN6YiwZSfFZMHmdSHiXuz?=
 =?us-ascii?Q?7Qv3eI3Vj0WyyCVzQjF2dKq7KlBL7+KsNfZ9wQtMq5YUzZcHCK5JMvydxJAS?=
 =?us-ascii?Q?CjlsL3EHwqpdHOPobTvGc1ZKTeIXwqNSsiM5klT0konazNPPrAkWRjzkDl0E?=
 =?us-ascii?Q?VUh5mnTcZcuu2CqBubHhAl77yL7z50Qv1qwkH2X/OS/JfxiQKYKiXyPvNkju?=
 =?us-ascii?Q?taFvLngIzNzRqUfIkyTtR9LhZKz9xIr3?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR11MB6366.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?+mb8PzeYQogfFbuDr30MyGYH4GX5wyMkAXNmtT2smEA4YmoU5C6RfBxZ8Sw4?=
 =?us-ascii?Q?mbqhpmxvSX3XUiwxjOLxaBD5kCQnoLCXgnUjTl7ax3aM9QYwe7Uo09V/O69t?=
 =?us-ascii?Q?P1fG/LJ28WoHrNXx5jMLx9UsiMEd8VulQJgFhV6yz8tZ6ovLVWJlKQrTZ0s7?=
 =?us-ascii?Q?g88fpLzHpFMoYhVSkUk2CIpStWjlM7JxlAUgcpYU5o5lxlHFgSNewLHeMKDX?=
 =?us-ascii?Q?GV77HgkWaBijZxJVlkSwmn86+HzIxZK6plbc8UEXff0ZQG/9nR/FAswxJTB2?=
 =?us-ascii?Q?opKZtNOfw8tPfJXQifQGSnpBGYj2wtzlmAzjq6+woqwPoUTpRsU3wZvYRu8/?=
 =?us-ascii?Q?gAF1UyAxryvfBK2+O6Ks7bMUCC/G4FhF3JttAI9FDJ9bRejaIDLLCSIo4Yw9?=
 =?us-ascii?Q?9yLu6RXTNR3o14KHFnKIOrW6PTQLM6tlV0xy7hO90HsdH4sCfwyqzn9fSZPI?=
 =?us-ascii?Q?41yqqlcWOItgW11Y98GsuCZj/oU3xncO6/h5DBNCcKduhx440u2nFfdAnMvr?=
 =?us-ascii?Q?IO5Gtb3J4kR9qt14vn0PhRsRt7Ufg1wxqysSPKcGEy+fFhfe94uJQFTXH0YB?=
 =?us-ascii?Q?fiJ/gMARL0RYoUJQQO+RuH+kXm2D5O6PuBUxPsZJNhr1pK8stOt1Ztk1Kj9G?=
 =?us-ascii?Q?7/etBndieD1P3iH/jqXyh7WW138MsKk6eZoIWpt2wVHg0DDAjF8WMepEnXsq?=
 =?us-ascii?Q?6EQ7vu9YLN08Zh7P9cog7xrTV6xqn4wkvXvtNPQqxZuM+1HFCkD7BRBwYKQ6?=
 =?us-ascii?Q?nfHZhJw1gTOwHdNfuVNSkjcvCuEDz11tCfqkZh7AEoFnp0flWQ7t521kUAfi?=
 =?us-ascii?Q?kyih68cAbA3OLJ3GHKfXr/CdrbrlVOStBBAgc/qbpJ2axPWuhfkoNYw05/k4?=
 =?us-ascii?Q?hXnjBVVaw6nGm0Haxf3098dzOkL7jjIbbK5fEAlvZSs4ZfRi1uRFpTjw77xw?=
 =?us-ascii?Q?0u3lZQgTr3+B3cewy6O+AK4Rmw/6mABLu6S3Xp04LVCBhNZYgFfEjr2wf3ig?=
 =?us-ascii?Q?aQn+Dt4Wamv8Xu3L/d4/J71SdLstbXO6NQQbs722ytCY4GIA65x13CHfGgUv?=
 =?us-ascii?Q?HJ7LKvA+/b3jVaonpcRyur/v8tTnylqKQZ05Qc2sv6s2In/QoeVNQxo+NMAR?=
 =?us-ascii?Q?JOl7idSGxRoAQjo9RCSrjyHPgLQxUyOe73/Tut/2vekhRdZn2MQAlwYghiO8?=
 =?us-ascii?Q?gc8g6tYOHzFTb8Ye8mirBt7UQuA7RLQB8MvHCRIhrmwDM+KUx7pj0fSXKeEm?=
 =?us-ascii?Q?eDYQuOHfbGU+TZABj6foxWNQ0CGTDXgzt1dxpPNQDRfPmsobVlTwwFY1dq1n?=
 =?us-ascii?Q?DnTgMLHhUuZvqUJxRok9ay+jInvSbHxL6r9ngXWW/Ex0qf852me8M1UuoMI6?=
 =?us-ascii?Q?pPyvDrOoD6WZQKg06LOSEd04NYSYy1EZIlUjtBVsTlHJ7lD41/D4M4tA1wMT?=
 =?us-ascii?Q?jN8oN16KQmRie2k8S0zXq979WXkH+pmROlyLzSnV/zAnm23Xu3jJ+HgntA2C?=
 =?us-ascii?Q?AYB2oUH4at1B8htvhBjezARR1m99AbQ7PX62jYc4peLQUfMIznwrDSHaTwrw?=
 =?us-ascii?Q?b4mtuaK2iMm0j2HrywuVQHO3f4j0lZpWle0FW6c+V6PO5hZHLUpzTejFhJtH?=
 =?us-ascii?Q?mw=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 09037ec9-a3be-4399-9823-08de17be10d7
X-MS-Exchange-CrossTenant-AuthSource: CY5PR11MB6366.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Oct 2025 14:10:22.9220
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hkJeg0/pVBk8r9deIUv8dDK3j4EkldnkOEQkPXW84s6/Zn1gXgXze/X/7yoj5dofYNnwwhsx1CcEVUWAuCnW1Bc8uz1WEw0H2rnWQFI4etM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB7472
X-OriginatorOrg: intel.com

On Thu, Oct 30, 2025 at 04:03:10PM +0200, Andy Shevchenko wrote:
> On Thu, Oct 30, 2025 at 11:27:37AM +0000, Giovanni Cabiddu wrote:
> > On Mon, Oct 27, 2025 at 11:02:16AM +0200, Andy Shevchenko wrote:
> > > On Sun, Oct 26, 2025 at 02:57:07AM +0100, Thorsten Blum wrote:
> > > > Replace the manual string copying and parsing logic with a call to
> > > > simple_strtoull() to simplify and improve qat_uclo_parse_num().
> > > > 
> > > > Ensure that the parsed number does not exceed UINT_MAX, and add an
> > > > approximate upper-bound check (no more than 19 digits) to guard against
> > > > overflow.
> > > 
> > > Reviewed-by; Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> > s/;/:
> > 
> > I just noticed this while applying the patch to my local tree.
> > 
> > Due to the typo, patchwork is not applying your tag [1].
> 
> Oh, thanks for catching this. Have you added it manually or should I do
> something about it?
I haven't added it manually. If you reply with your tag again it will
get sorted.

Thanks!

-- 
Giovanni
