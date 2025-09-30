Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FDCA244693;
	Tue, 30 Sep 2025 08:34:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759221297; cv=fail; b=jx043hxVOdxsMGu+qly04bMdoFLJkkryZIUnoWnjnHCID4k2RO7WVvrbDEUO5GR9h90aMjUwr4McsQWvmKHGqk/86rcwLG+PLwm9dlQJt/TuE9wOmtTJalmoXaenoAaPXFDg5Ryl1yR3rwuesNRu5L965DbstDRO/t7eitXQHQE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759221297; c=relaxed/simple;
	bh=PZyqanzW88J1s43tCvkubGkPM/CKgcoiYhfAJi9uOiw=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=qdHjlvQCbnmqY1vsoM/HN67i+ByOJ1F6+Spo8MM5sip1iviALNFAlhUsRkdtmsj9nOg80GDjkwuTTQZ0CF3ByFiLZsme7y9aJgwo+MR+0Y4nt4h38du3iaxHAR9tFTUd/9IyJwTz18uHU/dWRyjC9UFLYM34La6H0xrpxGtwQhk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=BRE7EA9q; arc=fail smtp.client-ip=192.198.163.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="BRE7EA9q"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1759221295; x=1790757295;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=PZyqanzW88J1s43tCvkubGkPM/CKgcoiYhfAJi9uOiw=;
  b=BRE7EA9qGtj0Skm48Pur6vjJfRBWCCDK3aGL93Jua8j0yQMEfMiU31ny
   Ao/Za0q1HLyfNSY59X+WyU3V6eDGbCMdu7xnI8NoWZv+NhlfOHNQ4FDLi
   WPaY3L97aKHneg1MBcQXl2M5O7c6FIXM543knVX1pavbEILd3fAcQl2ss
   rAUK2yHoHHYpv/DE0NZR4oqWGtF2tkYQIbqO/gJm1wO2FXUwr2rznFC4s
   N0ja9was3Wh+DxZ9gJnOHkIlUKOiotgk0EddSWHQbbaAh79cjG8mKCzhm
   +tT9Jc0Fp2erfCwrst/u7MZGz65066Dju8YpEN6CUm73kKlNXf0Jl5scZ
   Q==;
X-CSE-ConnectionGUID: 4ijaFveZSEKeJ+0J0lUcUw==
X-CSE-MsgGUID: 9HVqlSCnS+msCu/sp5HLaA==
X-IronPort-AV: E=McAfee;i="6800,10657,11568"; a="61579782"
X-IronPort-AV: E=Sophos;i="6.18,303,1751266800"; 
   d="scan'208";a="61579782"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Sep 2025 01:34:54 -0700
X-CSE-ConnectionGUID: z/DsuvRTTxus8y9c+p8haA==
X-CSE-MsgGUID: 7kjtCR5nTMa1rl/yed9jcg==
X-ExtLoop1: 1
Received: from fmsmsx903.amr.corp.intel.com ([10.18.126.92])
  by fmviesa003.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Sep 2025 01:34:54 -0700
Received: from FMSMSX901.amr.corp.intel.com (10.18.126.90) by
 fmsmsx903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Tue, 30 Sep 2025 01:34:53 -0700
Received: from fmsedg903.ED.cps.intel.com (10.1.192.145) by
 FMSMSX901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Tue, 30 Sep 2025 01:34:53 -0700
Received: from DM1PR04CU001.outbound.protection.outlook.com (52.101.61.31) by
 edgegateway.intel.com (192.55.55.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Tue, 30 Sep 2025 01:34:53 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=a4pw7z2gGO4cOfOwzzF5SoHBtrHWJRCJZb2o+aAhEPEV0koi92rGUInZqRLl0jZeoBu2Mzcqrn4a8dpx0d8Y+4r0wzmDa/Dmk2KkXrAcBlHJ3dElBXdlgD5/qS6F+Bzf8BW5PM6vtLCe/RJAXk328BiRNHGcyEJgxGqVBBy8VRkqO59TZjqRw0q83dRbl1OMf4yWKG08JogC/bp7hlPWaiP9pyWDkYfXbQ4St5uhJQkJL1sizOwEvtG0+v3vm9D7KyNV71YjAK/1njWl6o678buO5RtzU1cOjHb7ECny1nr+w2omcParf1sanJEGgKU9W6aZahpsqCtOFpi94Kl1pw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TLm4wdNB4UvHh76YjrAzpxH2lME624LdSHxJpF9bwok=;
 b=YNp/Rsm4DSHZqkdFBZmEUsxaBdRhGQAyVb+PsqyGMVgyiq6OoZ+mMWE26S9IeV9vlGM7476LEBxUZu9zLJ4reyQYiW533bGkxTmCDb0Ezh44ORBA9m7vIoNx1MRlp4nGmlkJn/kJAKrzqLOdQhjof5BYNx4LjguFdpatJxwPZh4P70wi5piDzvPJ0kcn0dVzdLVuhPETcZ3XdPkj5fzH/14et9YRxPNYsxXp29DHV4SWL6feTb85c4HTVJZSNMsenXA0s243x7HUxYRUsEaM37UYEpfTdY2BBxX/LVB2Cea6rv90fZNcGhw2WW6u3qjqjyVyv4T4GzFlQDEz7EFRvQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM4PR11MB5295.namprd11.prod.outlook.com (2603:10b6:5:392::14)
 by SA1PR11MB7037.namprd11.prod.outlook.com (2603:10b6:806:2ba::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9160.17; Tue, 30 Sep
 2025 08:34:47 +0000
Received: from DM4PR11MB5295.namprd11.prod.outlook.com
 ([fe80::769a:177e:10f2:f283]) by DM4PR11MB5295.namprd11.prod.outlook.com
 ([fe80::769a:177e:10f2:f283%4]) with mapi id 15.20.9160.015; Tue, 30 Sep 2025
 08:34:46 +0000
Date: Tue, 30 Sep 2025 09:34:37 +0100
From: Suman Kumar Chakraborty <suman.kumar.chakraborty@intel.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
CC: Han Xu <han.xu@nxp.com>, "davem@davemloft.net" <davem@davemloft.net>,
	"terrelln@fb.com" <terrelln@fb.com>, "dsterba@suse.com" <dsterba@suse.com>,
	Richard Weinberger <richard@nod.at>, "chengzhihao1@huawei.com"
	<chengzhihao1@huawei.com>, Miquel Raynal <miquel.raynal@bootlin.com>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>, open list
	<linux-kernel@vger.kernel.org>, "open list:MEMORY TECHNOLOGY DEVICES (MTD)"
	<linux-mtd@lists.infradead.org>, "imx@lists.linux.dev" <imx@lists.linux.dev>
Subject: Re: [PATCH] crypto: zstd - Fix compression bug caused by truncation
Message-ID: <aNuWHekFas2g7a5b@t21-qat.iind.intel.com>
References: <GV1PR04MB9071B5AC95DBD48B67FACF44971BA@GV1PR04MB9071.eurprd04.prod.outlook.com>
 <aNuQAr79Hdky3WII@gondor.apana.org.au>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <aNuQAr79Hdky3WII@gondor.apana.org.au>
X-ClientProxiedBy: MA5PR01CA0030.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a01:178::14) To DM4PR11MB5295.namprd11.prod.outlook.com
 (2603:10b6:5:392::14)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR11MB5295:EE_|SA1PR11MB7037:EE_
X-MS-Office365-Filtering-Correlation-Id: bc8e5a89-0ede-4bae-af36-08ddfffc367b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|366016|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?I9doXAatH6Uz1lBoZwBs3WFmyWhq2vcn3RXdx371Dywu6PTNH+hOlRBuX5BJ?=
 =?us-ascii?Q?wMAjUi9LLY14dI4dWQylBIyV9KJ29SG4Eem+XQGDp7ytaspjt3ouKmmFGJdW?=
 =?us-ascii?Q?oJIA9f8Umgf9RCYoyTjj/jdbqh4ZScYTcbcm2wGa0GNDj+Gz06rGCupTwQ0/?=
 =?us-ascii?Q?JjTsGsJQvLHkAql3oggzomFq9MUFYCWX9n5nEyFSwFLJP5oAvRcKNrqWYx25?=
 =?us-ascii?Q?M7Oo9K1C6yVi0YRGF71xiG8PYDDXxZcVyF5LkNDAM2dAocXpjPkDQMZFxbS2?=
 =?us-ascii?Q?aFPDw9FYpMLILeFRWhm40OvoqkUsOIgg7PLdOhgWaIhVHmFBNPKsE1AsKVu9?=
 =?us-ascii?Q?XDkQ60n363wHjn4P/AmmKCMGIxQEj+M7jug+a1BW2jw/aONxvXXyFTx3SKil?=
 =?us-ascii?Q?0A8rJj+va4HLOVnYVvS6CrYj/6UwM2joXKw+qzPS97uubRSZDz8fDBQesIBz?=
 =?us-ascii?Q?75yrbg3+AAXD/09hPjAnPDHridp4WYmPQfCgPe5SRihD2S7XmS3DSryarRwx?=
 =?us-ascii?Q?qtm6zYH3oBFJYgq5Ii/wtye4b8GBYEC8F8Dkj+FCIm2Wtj92pHd61pu9hG5L?=
 =?us-ascii?Q?+2EN/9+Ln0iDWoHToui4tAWx45nNObJuiFM5Qd7XD9GuB4LjdFtb54n18tQ0?=
 =?us-ascii?Q?+7yLm5VbfzsEP3CPnoeHV4lS4rG3SBDcB0cVHIF0qOu5NVGkYIbstE2VBZPV?=
 =?us-ascii?Q?9jOxvc5RvGfk+Cyp7cMdiZzA53wo3Q9GNLivLqaj65MHDGOh22C18Q2gM5SR?=
 =?us-ascii?Q?6v9mK0+3Sge9FZEWMy1/9liqRWY3Jd9NygJ9/JU/9wwS/v2I6iyPoSH7i6xc?=
 =?us-ascii?Q?gRS5oRWDAe30ld7+9UYL+9nCR+W8iv0VpsxW8vbt3fsriEZotxxqEchPzibf?=
 =?us-ascii?Q?yFpldSqYRjwPvcEu73bSZd/MWsuR6EwEb65gpVRh+sLVCnq9rpqXG/bPDcmn?=
 =?us-ascii?Q?SAlpDB/gBThJ8VQbXf8NMugC84sbRNYYuOEl0DXJCSc4xIYwUx3kI702jomP?=
 =?us-ascii?Q?T28kTpJECRmnynjFb4S8F1mp3s6PfW7/CGSU9IqGuv8wcX+5YLUxJSZvjyLL?=
 =?us-ascii?Q?6sE5lQzvmQjFiWkJIDQSSvCVuPrJf8055LeeqhexXMDg/mqsEdLXD57BmbAB?=
 =?us-ascii?Q?UXaNYvuuVtYnrQLlk5ITZevUzu4cGk4xsA+oHtg9e6F1iI9QKpf/qMIRvBw4?=
 =?us-ascii?Q?BsQUm90hLH//ntRkqAPXK6/BJNa0F7rCxpOObS45cHas9vyNNm5fOLEJ6YoF?=
 =?us-ascii?Q?eUMcliNoRWsv0stlgwaW115v1ly4EV65MrY+EdC+XNKgPuGiuK+ldrDW284X?=
 =?us-ascii?Q?c9Jcl+CdLvCA0bM57QfqERHzGZfKS+JqNdialokuQc9v9IDpTdoJG/nOa663?=
 =?us-ascii?Q?VDhwFhDNNCOcJ/W8/dwPdHgpjySoVq6J4ioCd3S6qXU3/t6xfQ=3D=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB5295.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?87zrqCPO7H7sMal2EmN+97uNShpP14EES3yJlxr9H3iIwx9FmmVyxKYozJub?=
 =?us-ascii?Q?CHx2a4e1TvTjcQy9gkaRXf1oo+2ulhwEcjI4kY5bbStFR2unWJdQRbOpNttg?=
 =?us-ascii?Q?aDmY5VDmryZz2dsLka+sRh8XNWXaLC8wxLrz80vslkhe1AAoOLbbAhftOJD+?=
 =?us-ascii?Q?h7pOmR/3fnmuhwv1xrwrt9ZsevDwT7Y29OoXq1s0D5GAEBASN5UNdL36FaPJ?=
 =?us-ascii?Q?JU2ba13+AQkg30rl4aKKHQfTc4XitmnVGgKTndpRjuiHhrG0o4J8+CeOrHd+?=
 =?us-ascii?Q?2V74IZee/XxgYWY7+e/4lb3Ek3uo8OYtnpEPsSQfG93IgfBGUGhkV/gIKUTB?=
 =?us-ascii?Q?Y/GW2EP/7LRGp9Zh2D33NQFDdtLLc81Lxm3Q9LRC1w/I3cK6IHif1JcAhx/b?=
 =?us-ascii?Q?da2Bk6OZ27kFBgXRwwSRLeF18D2vd9/aioD2a5X/WH+o8+2eDDmhqExvIzlo?=
 =?us-ascii?Q?Tadk5azrI0a1IeoymvU/NH1NSJCZCf/xKIWt3ro+xgnB2mqFkkZBf+m7SD/W?=
 =?us-ascii?Q?/2gKGcwp3ObjaUHIkmn/sojnjsSlrQDjemeHXX+nH+07WORCeXmoDDh8XNyU?=
 =?us-ascii?Q?/iJe0UsNIJq0Vh20LwPTO93Q9m5+PnD9y5WIsqsLK67ctqg3wSMK2k5rQdZe?=
 =?us-ascii?Q?Xivrnz6kyPNyFPYzetVFunPqr5GvkNU68E61fI/YEqq8plDJ6ReqwtIawMfK?=
 =?us-ascii?Q?fWZEOBgPfj3eFst1xNbgdMt+TnSLQjQV6atwu3Mkc1KyGjuAn4kUNN39zP0R?=
 =?us-ascii?Q?hgVko48J5GE7M7o5MRnnSqWVE+FjITj/P8IUngBwtoXt3MHVOVaJ/NyWxOvw?=
 =?us-ascii?Q?msOlAVCf0wDokOV8CsblKELKxwHUsgjClCPzSmoJRDcDknY97d9pqC1btixb?=
 =?us-ascii?Q?pHH8GGpJuEYTjCADTRePOMg31idqlrlz9Uar4k0AMZUe60xQdy2Kx0ifzzE3?=
 =?us-ascii?Q?BGPiCqLqEQXh1heIjJIW/zNH171wqLunqjeAbvsN+uVgsiPQwq2NTI5iOG6h?=
 =?us-ascii?Q?7OT63RcP02JuNF7FgEloNtPZ4kmUb5jIMy+v0qhm0qMh8j2i9V7dt9gH4sm4?=
 =?us-ascii?Q?SIAhk9couOXnY27d2l+A+NE2yf9KaJYOzhkk882CTmidv0RcNbTGMbgArX9Y?=
 =?us-ascii?Q?dUf9Fku/f5yp5k47ceTLQIuaCV2ptw3OlZEUaxPl7YDjAAXk1QUDBmvdg2EN?=
 =?us-ascii?Q?u2dREQbcMC0242nuEG3/nNvvVNljA5plQPWrXU6+N2y3vAOLzhdvSD2poLkN?=
 =?us-ascii?Q?jLhTuyPS5kfSvZPS0LYMHjBMOX3PWKi6euc4X27sA6QZyeS5NGFE9v/ccxSj?=
 =?us-ascii?Q?0Oe1LfAAIiT4aUjITBPdokyEyC2wdR/PBYk6EnSmZ95ZEAoEQKYlfYmj9dtZ?=
 =?us-ascii?Q?uWWWUsbCtXPtIn/+bIiuYRo2PlFl08YxXKjFnIfXTFNlEQA65gmOhI4MwsMw?=
 =?us-ascii?Q?DU/oKdAaKI+XEWFdBCqLrxZMrbyGeSxnY5iY6Iu5CRKhuxZ1wZuT/e8LVnE4?=
 =?us-ascii?Q?DVfQvPWF0NpP6NU+zj98HpIaV4PjbRsIlbgf2EMrl9K9ehicXthX+Sy6MTqO?=
 =?us-ascii?Q?7ZzVazJkK/suyNc0PkoUwU3vRt9dJluQiuJTTXzznCUSxdZ5qHLWKhyechnQ?=
 =?us-ascii?Q?sWYy+ANKN67+FfRYBk+F638=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: bc8e5a89-0ede-4bae-af36-08ddfffc367b
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB5295.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Sep 2025 08:34:46.8642
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: SfQHpC6D4D+Urlsz4rPC8t0AwYfpRRbKHIrvH0kR5L+C+GNzHzDdN2FRzAm3hONDdJWpY1ojWf2zX7vwnTW9MMM1x66WK/5FTNqufSAFNS9tNw+fimQIE7I6tZksAuRk
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR11MB7037
X-OriginatorOrg: intel.com

On Tue, Sep 30, 2025 at 04:08:34PM +0800, Herbert Xu wrote:
> On Mon, Sep 29, 2025 at 11:51:36PM +0000, Han Xu wrote:
> > Hi Suman,
> > 
> > The patch f5ad93ffb5411 "crypto: zstd - convert to acomp"
> > leads to the following kernel dump during UBIFS write back.
> 
> Thanks for the detailed report and instructions!
> 
> Please let me know if you still get the crash with this patch:

Thank you Herbert. It fixes the issue.

> 
> ---8<---
> Use size_t for the return value of zstd_compress_cctx as otherwise
> negative errors will be truncated to a positive value.
> 
> Reported-by: Han Xu <han.xu@nxp.com>
> Fixes: f5ad93ffb541 ("crypto: zstd - convert to acomp")
> Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
> 
> diff --git a/crypto/zstd.c b/crypto/zstd.c
> index c2a19cb0879d..ac318d333b68 100644
> --- a/crypto/zstd.c
> +++ b/crypto/zstd.c
> @@ -83,7 +83,7 @@ static void zstd_exit(struct crypto_acomp *acomp_tfm)
>  static int zstd_compress_one(struct acomp_req *req, struct zstd_ctx *ctx,
>  			     const void *src, void *dst, unsigned int *dlen)
>  {
> -	unsigned int out_len;
> +	size_t out_len;
>  
>  	ctx->cctx = zstd_init_cctx(ctx->wksp, ctx->wksp_size);
>  	if (!ctx->cctx)
> -- 
> Email: Herbert Xu <herbert@gondor.apana.org.au>
> Home Page: http://gondor.apana.org.au/~herbert/
> PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
