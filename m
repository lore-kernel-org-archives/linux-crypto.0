Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 534E3194A44;
	Wed,  9 Jul 2025 07:19:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752045550; cv=fail; b=fzOKrn3r/pCNZyFpv5g+tuHcp1keJl6r7b6gX5/doMM9MfAYpMQQ5/ERGg3e9j1cZ13RwzdzRfRsxWHn8BF8h9dw0kd2L1KmMVV4ZrQ5T4DfM1hxwKbJYKTBclg9PgDN1foqSKhMZ1rvomV27WKbYqIXSfgvusII5JH07ffDT1c=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752045550; c=relaxed/simple;
	bh=3e4s28F8MfslVWc/Am7g7VzMT3XO103OczX3lO+uig4=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=dol1PXsxPcoBDS9d2ry7iEAxjOe3avLoPxAgHzktZsXapVkuBGt+wijR4B9z4AvEwb5a3idSPypUAbDkcQbuXymK2fKW46i3wriU0fusVhZvrNzr+Vh2IOc8DRsMhC8O7hLmnRgp3X35grWNwfcR6G98v/igW1FEBPsD9qxdLJw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=AbRKJbtO; arc=fail smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="AbRKJbtO"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1752045550; x=1783581550;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=3e4s28F8MfslVWc/Am7g7VzMT3XO103OczX3lO+uig4=;
  b=AbRKJbtONbjLLw3zGh9nFrRL/WW8lCUQQtOlJ2prWnvgBYHaxp9gQSX5
   teqiVLK9AN28OWgxPO9tdic3sUlY4Odsnljib5oMG57mLJ5cdcbzo2mpW
   Sx88XTH5LzUF53vObszbp5BTMYulKZ7hF3vJLvWsf4J+6M9kCTUsOwu4g
   WyWQJ86uSWS5KaCb+6r/PPs6H7aGhjZrct/7Z+0yPiP4kYPJnoiagmKqs
   HHs7zpgKlWcd9a+wgpf+OmImx31bR521xC/dNDk79BXBNo/z+kW6XJFIs
   HIasISh62hzGxm3N5sktiPdJX7SeLf6Fe2b0lLG27l6FmUEpIZUrS3jv7
   w==;
X-CSE-ConnectionGUID: WCJ5f8paQMm+rxhDVSwU9w==
X-CSE-MsgGUID: SeFGTv8vRH60Jy/QrSjYBA==
X-IronPort-AV: E=McAfee;i="6800,10657,11487"; a="58100505"
X-IronPort-AV: E=Sophos;i="6.16,298,1744095600"; 
   d="scan'208";a="58100505"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jul 2025 00:19:09 -0700
X-CSE-ConnectionGUID: whtU7hv9R8ynp9gC/kxtwQ==
X-CSE-MsgGUID: yVEnS1vzQbOJ+5eEfZaUeA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,298,1744095600"; 
   d="scan'208";a="156177863"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by orviesa008.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jul 2025 00:19:09 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Wed, 9 Jul 2025 00:19:07 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Wed, 9 Jul 2025 00:19:07 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (40.107.236.79)
 by edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Wed, 9 Jul 2025 00:19:05 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=TqqHiw1VRcONcKgemHe3fhTgmHGx+Se8n7j4C+e7uwmLccusBRe/mo3VfpYrS27klxkKf2Nv4xQZv/fR+GSzVWXCmV90pTEJjgPXVdbtv+07OQANyi7n4A4GVEvxRmy2XAkhqAW7sdSS3uMwItJ9qyRpnlRm44XwfAymlAzy/3DgQFtanXNIinrEl7wiK1pKZOt10aWmMdLcQo7vurmQxoEAs6EbFwrS3IKakEbHFwld28VLa6tze518CSTkDzwuwLLejQzLwGboVZwn5AygIaBbZEauI4+BftOnWAFqPwgyyyjaG4uuEUVb6BSKIuiPXHvgAgULdk5bNFCqLMxuvQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=m2Z2yX9U1ip/iExQS4zG2cDRBOcY8I+MTLkPIZr+tu8=;
 b=p71QmcjtoEHWqWIx6H5O5FNxbJO70Ml0LzMBghbVCAoZhqoeXCuObdUqybz7/RQN4SWCyl2C+ZIjSchN1NUiXkCaG6obpZ5/cXiPplKY3NmyVSja7ccJ8Z0Ote82pIXVGU8C2jqfIuh9J4xq64duaR0PQgJMJ1sh8URX4EVKX+uG4Oeu8Je1S+b29oUGd37Dnj31X9NQBmPql5ztFQN8KID3JJvpO95VQbXRO2p6qi0+2gaVMp1cKfETyDMIBLlFLkS/TzQj67YMWlOcwB1GqtTtOKBTclMDCjSiGWpkT/Z5OzFQh9hYUgyPaI6f/LXiPyLPO0lgr5drvI3EN3qsMg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CY5PR11MB6366.namprd11.prod.outlook.com (2603:10b6:930:3a::8)
 by SJ5PPF183C9380E.namprd11.prod.outlook.com (2603:10b6:a0f:fc02::815) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8901.25; Wed, 9 Jul
 2025 07:18:36 +0000
Received: from CY5PR11MB6366.namprd11.prod.outlook.com
 ([fe80::6826:6928:9e6:d778]) by CY5PR11MB6366.namprd11.prod.outlook.com
 ([fe80::6826:6928:9e6:d778%3]) with mapi id 15.20.8901.021; Wed, 9 Jul 2025
 07:18:36 +0000
Date: Wed, 9 Jul 2025 08:18:26 +0100
From: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
To: Eric Biggers <ebiggers@kernel.org>
CC: <linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>, "Suman
 Kumar Chakraborty" <suman.kumar.chakraborty@intel.com>,
	<stable@vger.kernel.org>
Subject: Re: [PATCH] crypto: acomp - Fix CFI failure due to type punning
Message-ID: <aG4Xwjups+9zr+Sl@gcabiddu-mobl.ger.corp.intel.com>
References: <20250709005954.155842-1-ebiggers@kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20250709005954.155842-1-ebiggers@kernel.org>
Organization: Intel Research and Development Ireland Ltd - Co. Reg. #308263 -
 Collinstown Industrial Park, Leixlip, County Kildare - Ireland
X-ClientProxiedBy: VI1PR07CA0159.eurprd07.prod.outlook.com
 (2603:10a6:802:16::46) To CY5PR11MB6366.namprd11.prod.outlook.com
 (2603:10b6:930:3a::8)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY5PR11MB6366:EE_|SJ5PPF183C9380E:EE_
X-MS-Office365-Filtering-Correlation-Id: e2241dcb-1db5-4432-3fc6-08ddbeb8d1da
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?AsnT4i+ppotQkDbWRjvES1XfSezGu/qRfJSAOIbS98NMip0VfP3RMMuI9eqM?=
 =?us-ascii?Q?EKAQ4x78ZA+kW2fQKZ/4EIh+A52VZ7jLJ+MuH8uwR60m0/IZh00pKrq/mYA8?=
 =?us-ascii?Q?7Ak8tc2SwJaDb/dqam0LcqLqoUP0d15Yno0wR/LtZGG5fslAy3sPlENbxQKX?=
 =?us-ascii?Q?KPSSXljGmRNJm/19utdlWmOHYiXQqXz12YJi32x1tGVtutcehbeqBqrlM9Dc?=
 =?us-ascii?Q?oBB4U7FyG4cF4d1QJZUvthV2r52rJxO7JqVt0FhXdObgUWJeXdBUJGD/yFDW?=
 =?us-ascii?Q?D7tPJPxje3c/An2Wf4XUKDmqti0l30YgeOLUZjn8b+MAdzl3NL4ZN9u/37l1?=
 =?us-ascii?Q?6sYpf9SQKComDkNGJZz0s8poagXGhtwrVHcK6pXRuE8hN+OE+K3pPlf1tz2X?=
 =?us-ascii?Q?52cW6X4YPbEHM2HDHVSD9btQ4oN5bpsspBIZWE5jmAYdTgXx7fORWJ+LzJQq?=
 =?us-ascii?Q?iA0KgNmI8GVJzhJWAzCqIo6yzqjY9FHugZH8KjBQf1Q7zTw96R+ACZAZLVz8?=
 =?us-ascii?Q?3Y6eitykAC7du0LvYKT+hImLQT6aBlr9VlN5aFBVDcl1GepJPJVRqtvZOymA?=
 =?us-ascii?Q?uePoUCzHtAEwhjk9uWBcZUFprQtAD4zNyGh/xVigPeQSn+72gCk7Lxueo0ap?=
 =?us-ascii?Q?F9HeO9iVQBq9TIbNK1x/PvhUWq+/3Mqpm4mmVLpaoi48VcRJM9hSkuR6EzJo?=
 =?us-ascii?Q?hIRUnIGRYRZMMRFSc91/l5J5yIfaeRDPCeIViSJ+pzPnsdgQoI6bEv94TxmU?=
 =?us-ascii?Q?NDncx8kGOdoVBNKTqI2SxrdGYZHobe+gzCHu3Py7TMfMoRNbdvkjOSitW6ik?=
 =?us-ascii?Q?Qbz/sR8iJc0/pJThbGqJXt/qWx1rZ72r+u0U5l8zwsmkBC/OvyHbypWFLbW2?=
 =?us-ascii?Q?X1lnVd7gWJD5yq8v98m+XIiPqjDj4MQsZ/uqwzsW36p0IDyhm3mp2VZJg7mT?=
 =?us-ascii?Q?p2MO0KhkMAlMWuCrhskx3WI9aNRqYiwv7299yb2wI3L15xnrmpMA7AvCInGJ?=
 =?us-ascii?Q?DGPXFHi6v1cx/ZRjZxrUy1NBxph4vkMH51vWDMlBCmYeNb+jjhMTt0wEoT71?=
 =?us-ascii?Q?/Rn7+v0cr1zcS8IlKEh3L0Gc9spcxRc1dA9J2QHbVXTwD5gXpbYALLtjO3Ga?=
 =?us-ascii?Q?cmauvd3XrhopNqRjr2uSEVpchudqwGhW+1PTaY9TcADbLCA6jHC9yXQN4215?=
 =?us-ascii?Q?VsMfK8AFvuCQv/StadE8sfM3fR0zq8oAvyKjiMyQFDpbXkf86Zvuv4ejBkeI?=
 =?us-ascii?Q?fTBgSb3gMl449x0xHkOtCyaSPRIhTuRdYB8jT9Z1kzADZzu0WFy0YWodjvxy?=
 =?us-ascii?Q?aotXi72cgj3k1Ok0QyB+hc/QIaZOOpJKA1tMCCT98j5XBpqKimmgDjul2cmy?=
 =?us-ascii?Q?i4MuZwxlz96vsnK3dta+GBiRZJu/pc1cBCupvfEaG0EwTdvFf2OlPerIv9QO?=
 =?us-ascii?Q?8/yGWQE5tRk=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR11MB6366.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?AqElzx0vwsISZcchgl+9Jevasc2p6Od4BRKwbebRKFDGgKHWuZ4FbC30MhqI?=
 =?us-ascii?Q?IOGBzzYk8mW+k9oQvMD6TSrdiaAzPhIMzTmfS6rX3Ju65cEuBg2FlozJxvCg?=
 =?us-ascii?Q?ddxhUMyUaCMcdM8lPP4iEd9xa+i4Sgd1qtwDjIT3RR6sXfyk3vAXt9Uxt6EZ?=
 =?us-ascii?Q?1nLSwLoSwL9untp1f3taOSS+Qhy36r9e3Oh62J72+hw3aTfWPKupALcMtxLI?=
 =?us-ascii?Q?4V8Ft4XMjWn5RqUYY3HUzIernOYrTeUvNhbGRcyv7VcEu1bzpYONEJNcFh8V?=
 =?us-ascii?Q?2MLoUiNm0M37nA/pnmnt68EsP6wteljwltHIHKrQgzLkbw0J/b6BqixI7xMn?=
 =?us-ascii?Q?cNcMw4c1O9daTYsCabRz+/XcXyOpfdmVEaBIQzlGHPzP0xtAuoWufyJvBqw9?=
 =?us-ascii?Q?EUS3oiEA+ADUEZMws25tbDr8YbqyNkrcS6i2Vpdxk4sNDvC2/We3SUlWomok?=
 =?us-ascii?Q?e23uGYnWfg9MDu2f942XuKqMpFkRZRwUMGsTy4JAPvRLOH3YM9wk5PYrikdw?=
 =?us-ascii?Q?J9L2sa28waTpHd2iGUeNx0qCidWhAj5pnr/0pjk/jKAFv3acxp8nPrtoWszb?=
 =?us-ascii?Q?WxjQreqwt2Oe3XsUFrUCXQMxu1x7KvuGqTaQSaGgr/QbipX4xfyymoOjqwQq?=
 =?us-ascii?Q?WN/2Kd8Rq4Tr14x80cPmlIICxRMVO3q7OLXVnQucradRusWzOqAPKb7qbmUi?=
 =?us-ascii?Q?vBKkRWEgnaKJwc2HW7a/pcDUhCLMRJS3+EwVSY018Zcy3emyyYx8PAUkK9ww?=
 =?us-ascii?Q?bM1KeQyOMfeKqpoW2tEIyFtw2sw6eHDnNH+htGmwHswR4f1GOJ+6CF2yFb82?=
 =?us-ascii?Q?2hkinLRaPcAnzDf/GdKupL0XcSSi8AbzoyqEukduFFiSJ0uYf+lBdMpNajdW?=
 =?us-ascii?Q?bXQarjNOUo9fYsAMg7hwR4NSG3aFjycH58hW5tD2gWl6v8o+S7bcJ5oyBmAL?=
 =?us-ascii?Q?EZ2g4j/u+JbrGIm27lS0Eo0DWR2f5Gh3+0Qdy3NY9RW+Hrrq9r8ysu+3rrs6?=
 =?us-ascii?Q?aonGMd/5PLj7v2kbW93qsN8Te+wZeGweY2OA0mmwEOk3J2vTLoU3IPEhlVAK?=
 =?us-ascii?Q?FCUbUpO0vyioREYxZ6qze+X3NhGAGstZSQnNvhGzEPdkZaZM97wgcF1JnIj4?=
 =?us-ascii?Q?fwp7oF8bkV0fkErZ83QyuxSfU1w/2+eQLj4PGn9/5VJjJmFTBjCTwXx8+DuJ?=
 =?us-ascii?Q?Cxg2L91hOxzhicsIzHcK6k9UPzL1q19XyjD1u/uCajt7jO+bnb3cFEGyxv78?=
 =?us-ascii?Q?yABsrBbrwB+Rpa2sTmsRhPs5eCZ3wWIEMXL3eZeo6cKdI0Zf1dOI+loDNfuT?=
 =?us-ascii?Q?+V+O1MtRTnkuS1Lph9vrpio1u+WRf7S6bSrbCRj9C3zA14uKEvlsG98w1VxG?=
 =?us-ascii?Q?KJZNe6/FR4WW7NuM5QQma0vwcPUGzZzItGOysor8BYbPOhjy9gLt3kDza0Xc?=
 =?us-ascii?Q?x8zBhluH8ORfPjpkuYPQczohHTn86FGZ4jNSjDUM5Q7+3ZJZA0HAOC4DYBLg?=
 =?us-ascii?Q?3CtzvMIgRPQnp/h0yRC7lu1jcbmhDHlfvAh5Q4g5EJpnkFdc1/M3T5Og2UxH?=
 =?us-ascii?Q?M5Ofe6aQJId+GNiTXFxzto9wXhe788JWtJR4KczJ5KeY/qGksRMRZhydJ7/K?=
 =?us-ascii?Q?Nw=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: e2241dcb-1db5-4432-3fc6-08ddbeb8d1da
X-MS-Exchange-CrossTenant-AuthSource: CY5PR11MB6366.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jul 2025 07:18:36.1799
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: OF8NuOVXt3dMu5IYCH4oQciJ67SdhnK9bAPkDx5n0FSVOGIYISK8vacgrFV6ELxqni3m5aldsd97nKV2WXMgHfoczlgiUFQQF4vsPd+lIkM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ5PPF183C9380E
X-OriginatorOrg: intel.com

On Tue, Jul 08, 2025 at 05:59:54PM -0700, Eric Biggers wrote:
> To avoid a crash when control flow integrity is enabled, make the
> workspace ("stream") free function use a consistent type, and call it
> through a function pointer that has that same type.
> 
> Fixes: 42d9f6c77479 ("crypto: acomp - Move scomp stream allocation code into acomp")
> Cc: stable@vger.kernel.org
> Signed-off-by: Eric Biggers <ebiggers@kernel.org>
> ---
>  crypto/deflate.c                    | 7 ++++++-
>  crypto/zstd.c                       | 7 ++++++-
>  include/crypto/internal/acompress.h | 5 +----
>  3 files changed, 13 insertions(+), 6 deletions(-)
> 

Reviewed-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>

Regards,

-- 
Giovanni
