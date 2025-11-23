Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1B9113A3F7;
	Sun, 23 Nov 2025 01:55:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.10
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763862953; cv=fail; b=FhsjfSfBeeLUvK7RBNpCIm925p7pGuRLzOdjuoeeIuqnazj5Czg84oAvJah/YW6/QwGjt+G+gY4csHcr8iKdufd7HwkbAyLZf5bP0xjya8gbj2bHXQ1z720bZYwNwPFrQO5gxXK/I9ekKoA7/4xOsyR53L689gTuwP91zJY1Dy8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763862953; c=relaxed/simple;
	bh=xLfaWjlQWBu09o6QCSYmQPQaIassBbMoHMBaYl4cogA=;
	h=Date:From:To:CC:Subject:Message-ID:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=JfE9wK5t3VouUkv8VNeQNRP5BWJ60QXrk2dmRh1uztn/nXmJilKgXB3/nppPC39yMrJhJJTL+3NS4/moaiKK+6Rv4YtD80qZkCzsgA+zKl1+7GhAjXC2p4j+9bLxSu397OHiYgZ7bngfavs4pSPEUeDgi+NC46WpG+3ULWpBZTE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=T3iyJ+7R; arc=fail smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="T3iyJ+7R"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1763862951; x=1795398951;
  h=date:from:to:cc:subject:message-id:in-reply-to:
   mime-version;
  bh=xLfaWjlQWBu09o6QCSYmQPQaIassBbMoHMBaYl4cogA=;
  b=T3iyJ+7RhjI0b2Y7OP10RVPmfpQ8srqjbFz3jSBdkG/H/qOa37UyiiBg
   /kYtXl0bKB3qUZIcS/I/GhrkseZG/8PVm5EE64Y6fCn+2HLYODJYCXF0Q
   VP7w3CCwhQooqizPThEJKLe8184kk/V7o00wxpHErLgkAuBczB2Qe+kge
   dN4ZowRhry3+1mR9m5mgLXvbeVuePYUpXguYpyCGcLvseTpnnKUq0Bps4
   AGqvFyc+7ctMw+lBh+fUZOO6iLzdGdGZ3XNHKFW3crS1ZqgUgNEenVpkD
   kDXroqDVJonvRXp9MjVGyqOhTLUky8GHCEbVuOs/3Z9h7rgi8TqnqNHzU
   w==;
X-CSE-ConnectionGUID: UwXFfRtjSvaHhlzzBD97FQ==
X-CSE-MsgGUID: yEKPbFqYTjWVYfG1JGXMSA==
X-IronPort-AV: E=McAfee;i="6800,10657,11621"; a="77272435"
X-IronPort-AV: E=Sophos;i="6.20,219,1758610800"; 
   d="scan'208";a="77272435"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Nov 2025 17:55:50 -0800
X-CSE-ConnectionGUID: Gdm1M4PMRXy11rN0PWFe8w==
X-CSE-MsgGUID: 9zyyGCoxSmmr8zN5lQsT4Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.20,219,1758610800"; 
   d="scan'208";a="192122591"
Received: from fmsmsx902.amr.corp.intel.com ([10.18.126.91])
  by orviesa008.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Nov 2025 17:55:50 -0800
Received: from FMSMSX902.amr.corp.intel.com (10.18.126.91) by
 fmsmsx902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Sat, 22 Nov 2025 17:55:48 -0800
Received: from fmsedg903.ED.cps.intel.com (10.1.192.145) by
 FMSMSX902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Sat, 22 Nov 2025 17:55:48 -0800
Received: from CH5PR02CU005.outbound.protection.outlook.com (40.107.200.6) by
 edgegateway.intel.com (192.55.55.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Sat, 22 Nov 2025 17:55:48 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=uToiduz6QslXMuhGEvUtEgTmWfjaPwjkhydVJ/urMKicajKjUgB/NCNmaYWWRelYldy2qWL3e+RCQ4z7VQi0yTd65BLoQ3sSYRVbkFzDGQXZpWvnIumSxyho8yQz94ASNHKLnmBovwojnuGDA75sX1wdG/G7uq0NU4Nd8lPiwOY/Xe8efTeIYU95qnJOLhzqvy7yjKwBAMofNo6EDB3xkQoU1sH3pbX7uW6FzdO0YcNKlXUVj01dtclpnrdazu0sKWr+wl0z3ClAy4EmJy6gxW173IgR1DLz1h23CdMImNVvFBpcc4/aL+dFd0EZ4VAsiFoK+FS4IGQSCQWnF04VgA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xmYxRfWbTxYlDuN8wVHaixSbL/7Fl3HqnQYcfXvoCTg=;
 b=hQ7Q000QWeZGWy3IH9IeSMmBxFahS9LAyc8CA3+2FGJIg9jFVIqEYtmKOz7tEnZP8MW7BSN30ht1AuXG+iBRxRTWnXbqswRjQipiOuymXsdDqJUNCKXBawYTu/5P7udb4ANYqHyN6h7JDtZ0Qn+IhEqe470Hm14PKjZaKJKeiqy77YjhQZj2v/Pp8hwPc6suVvikjn5S1vrE/eaf0lHu+qYS4nUMsgHf5rcJQl9bWWEf+0YegabuCXjPtTac9WnI1II5C1KhnmHF44daYIPGl8g5Wua9l81JNOwlDkjqLpxE5X1eZIAYr2S7xWAHvkYNw7Te9XC/unyK+DkBFYTcmQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by PH0PR11MB5111.namprd11.prod.outlook.com (2603:10b6:510:3c::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9343.15; Sun, 23 Nov
 2025 01:55:45 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9%5]) with mapi id 15.20.9343.011; Sun, 23 Nov 2025
 01:55:45 +0000
Date: Sun, 23 Nov 2025 09:55:35 +0800
From: kernel test robot <lkp@intel.com>
To: Thorsten Blum <thorsten.blum@linux.dev>, Eric Biggers
	<ebiggers@kernel.org>, "Jason A. Donenfeld" <Jason@zx2c4.com>, Ard Biesheuvel
	<ardb@kernel.org>
CC: <oe-kbuild-all@lists.linux.dev>, Thorsten Blum <thorsten.blum@linux.dev>,
	<linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] lib/crypto: blake2b: Limit frame size workaround to GCC
 < 12.2 on i386
Message-ID: <aSJpl/MuavSLoJjK@rli9-mobl>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20251122105530.441350-2-thorsten.blum@linux.dev>
X-ClientProxiedBy: SG2PR04CA0165.apcprd04.prod.outlook.com (2603:1096:4::27)
 To MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN0PR11MB5963:EE_|PH0PR11MB5111:EE_
X-MS-Office365-Filtering-Correlation-Id: 40b62ba8-2eb7-4524-b69d-08de2a336a26
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?hASMniDMtBrtCyOLBeXSHT7tPNuw7xDm4PJpMebiTTzfhRozm6lF5iZkWbvv?=
 =?us-ascii?Q?rZvtt4zodqYMtxuUNDEqibm1XWBfLXs7PgDWwuzxHD+jg2DvTfsp6i/94Q6o?=
 =?us-ascii?Q?hB6y4uYNPyWG83LyaCNJyOE3fDaumE0qvS9mUIDyUthAP8kUPTe8OkEz7evj?=
 =?us-ascii?Q?b+JQj25JL06kdHjQkiJYdIG2qEo0gmZAsL4GeGLaMG3z6RpbfC4FwEYntKIe?=
 =?us-ascii?Q?yCWDYrRyLzZWhnihuRZX5PPx04Lp2NnMl5zHJ7GrFOjIqKcdExZdOH4cC5U2?=
 =?us-ascii?Q?YB/Vdo2dTrdvNxGCXpAG7I2rpHC5YQKNwGl2kwIca6Sc540oyVqjgS6HpIvp?=
 =?us-ascii?Q?EadEDVNWyHh4u7uih39T9Xv/q8+gZFvHiztlbskUfbU0j3kNyKR8hA//7iA5?=
 =?us-ascii?Q?ysthF8oGfTyN244TOEmtfKTOCUQqjg4iFykSEDBTmKvm6T98iimignGbB/ya?=
 =?us-ascii?Q?TAisgdT+bUAchLUNGvasMPoVRF3clh9XZwKdCYqGjAMbRIxd49RB1u0sVOlY?=
 =?us-ascii?Q?Z9lrqxE6iX4jrq5pKNpFRpr2ZehA6DsN6sJtekj7Ot7jHSz4Ifc//8C6TRnE?=
 =?us-ascii?Q?ed0WYhLp/bFN8xwLhUlkk+V6ip5RLJMvV89gtJEE+Rofg1BEUDpxpO/lWleE?=
 =?us-ascii?Q?SVuq+CjP0HDheh1z+Tquk5LadchkDfsJsxl8lHyNgGS28sKWDM6QZGUciBVN?=
 =?us-ascii?Q?AkPr0nbw4zwaJYC+69SLCxqxnb+hK0swDOYc+YPWxInjzSKM2FbeRRlivHJB?=
 =?us-ascii?Q?IHmaGWQIY0GLn5g1kuV/T9G5tBUpiZhoHHQ1yr3pXGR3k10uVZhGJivf8xMJ?=
 =?us-ascii?Q?b6xsBKBSKenenSekUKmr1J3MCmygwv/eoYQyzCLDF5zSVjxMXnvZkTAK7QXo?=
 =?us-ascii?Q?wbixFW1AxZa++MN9l+s2m1GapCxxvZ35f3zO+rTYuLTYySXsxp12kstLfxed?=
 =?us-ascii?Q?YpJYvI2XYYarhwLhv01F4+Rbm9UAkCKKJqFNHhConUzGx2QZRCWpOEeMj+0o?=
 =?us-ascii?Q?aba9HeVCfEf0NJQHYYvnURA/twrD2uXEppwqHsF+ORaZHnmxuI6+ywFmS20P?=
 =?us-ascii?Q?KraBQlwUu89HLWis87xfhRiOKzqVwcenVtxZvle+iwanP8nGUdTY9ljAoIlJ?=
 =?us-ascii?Q?WCC8MrXwUuTwN0XLjIDtzspoyIXD2jAocJy5uKsEoWmQGnWTsByzYSH9TdFA?=
 =?us-ascii?Q?C2SQ8Z0nS2gNHTY4j4/JDmoRtIxWCFpAYqbHRP+JgUrErXV7Db6xBj6b+FWZ?=
 =?us-ascii?Q?YfRl7JGD8USHPxvzhGMRSwId8UpyPvIbi7faCyRPx2O31Fu6SpNwlrx2QDRp?=
 =?us-ascii?Q?BQhee5nFWIJaio7nBr9uLh9EFx48UydYWik9Fp7takKNwoXsP/KfZei7e379?=
 =?us-ascii?Q?fCUcQu+gGVO+02DhwRfTHTG06IDsRWvlbSEbX+UOrezwV58vzA=3D=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?dnXWyMJm+I+xKWTqlHHaUVQSymBkrNC2sz3em8zNIePl7U9Qb1rbBGtjfKNd?=
 =?us-ascii?Q?5Ze2Vt0KEr/2Gk0OCpEbirKyD7t10SBUtyHWw4DuqbPu8/svzf0epB5DTAUh?=
 =?us-ascii?Q?J3RSOqRZTX4HHde2pod1nweYPrwkXaxwDY8nJ8O+x1/F9LpeoyuP6ZAsec6T?=
 =?us-ascii?Q?4CnkNmEkj3fk9ntxs5hTqBiVfFTbKn354kJToCbeNgdU6FFVRthr0nWeY9xk?=
 =?us-ascii?Q?WLARK0IeLj2zOAQyw4sN9mJAvnk1HCfJ0tzogksyVqEhM+hLF23lNORcU38V?=
 =?us-ascii?Q?h91RQlLOPB+EEk95maIyYioQoO/IirVAQXIlVkUGPTKD7JiT8fuiiDgb0bjT?=
 =?us-ascii?Q?yvq8ACXJGaZNjYt1jYqnDtGGZDEY15y/qdJ41ScBqLtRWvO60mK0usEdscQS?=
 =?us-ascii?Q?IlH/TQdS6S7S/REiBIKYAQMFs7QXoGoYx7ac+SQIZcXXUEAeZK0IR4TPnmt+?=
 =?us-ascii?Q?WRvNPqiumIZFSDdq+1126vPV8ZumdMJRCV8oAKVRSwuLOZZ4Csc/tBL6POIT?=
 =?us-ascii?Q?MOWtm1AraL5RO1evCP67VcZkbnmRfeiM03GkKnzfTy1cF0HYmbo5vaKu1JBt?=
 =?us-ascii?Q?0sJAxL2V31COEyjo1p4yAVlGF2YNPgl70H8G6ecGFAWIeA68gqbxCLpQh1Am?=
 =?us-ascii?Q?01bVkjJUcQdNJw5HJzvZCe99r9RuNdXijxju9acXw5KWMmwAZZu3AoIzt1Yi?=
 =?us-ascii?Q?AcIYjDgu5Wsj6ofAwoLopL3JPWYVIyPgKJxOXwn3h2Mdjtf0qDCoInKg1EB7?=
 =?us-ascii?Q?UdoLWAcstbY7G5/aYboWED/n7dn5K2VCLj5IMzr9bExEKyQyOHbgRf4wH9IU?=
 =?us-ascii?Q?EEYxpy/BJEzGXF378LHZ/rK6HZEKTqqlmN2vDhZahToaHh48zbQdd/sJULfb?=
 =?us-ascii?Q?KN8rqtyy3occGf8zg9dMDbXUA652aKz0fIFDuouEz9F+CxSz/+TrF3s79OA1?=
 =?us-ascii?Q?qCtJIcIKrOZ6eSm5CWE8WmRxKHuAQN+VE1AO9HxRwsPyi/6f1WZdL8y6V0Ol?=
 =?us-ascii?Q?PC8Be9PVqSj/K5FshtnT38ssatoqJkd/eJuDFsEDS/XUlKG/taGeiAMxCEYB?=
 =?us-ascii?Q?xgouSP/vpcj8J7EMmP52OThv75t4abN79sORLhkwKkE574n9WuHQiqJnl9qb?=
 =?us-ascii?Q?h5wxcZXLBClzmoc4GMX0KayyQ7OyR1OOJ7eek8qpcD+xSiqSqe6Qw9V0FjEI?=
 =?us-ascii?Q?fcWijohHqv2So4z3ixcDoT2WkTHYCIoWhQzk36s1sN1nkMQGlEcJYqXXIMCw?=
 =?us-ascii?Q?MJQvFwNsTvrELq2EpQbHbuxkGkOrZ05VVpnwjM4ClfId5bFTcj+aikAjTy8B?=
 =?us-ascii?Q?14+Qe8c08b3wbLOV1jqrwCMozfTx4X+1lS6Bjx56WdIUNGu8AHGCk1FoauVh?=
 =?us-ascii?Q?ZZygMa/3tCECRgyCV8OEWHaqNQooC4kLY5j4V9wIpY0A6GEliKp8v2W0kPPq?=
 =?us-ascii?Q?s7jl+1NtZ/tOedEB2sMQGH03N/tbqabzSTdzwWk8xfYzaE/upaD/QRkQ0L0w?=
 =?us-ascii?Q?cT3UBaN9v7xPe1TGBGLhTtBhQPqF5UTa0drTDeXuy+C8lrqF566GMmogKkxQ?=
 =?us-ascii?Q?a2aYB7lv/OMlcX6w/2NzEMEfvu0cmAwi9zTbP8qA?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 40b62ba8-2eb7-4524-b69d-08de2a336a26
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Nov 2025 01:55:44.9519
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: MSq5xUwhbiKY/2fY+/uA5Z3VtIZjz2HiOuepMLDafnR1pBtji2wgQaKFq7x9hclKcf6MUAWQr7mEZDyasjnWYw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB5111
X-OriginatorOrg: intel.com

Hi Thorsten,

kernel test robot noticed the following build warnings:

[auto build test WARNING on ebiggers/libcrypto-next]
[also build test WARNING on next-20251121]
[cannot apply to ebiggers/libcrypto-fixes crng-random/master linus/master v6.18-rc6]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Thorsten-Blum/lib-crypto-blake2b-Limit-frame-size-workaround-to-GCC-12-2-on-i386/20251122-185851
base:   https://git.kernel.org/pub/scm/linux/kernel/git/ebiggers/linux.git libcrypto-next
patch link:    https://lore.kernel.org/r/20251122105530.441350-2-thorsten.blum%40linux.dev
patch subject: [PATCH] lib/crypto: blake2b: Limit frame size workaround to GCC < 12.2 on i386
:::::: branch date: 13 hours ago
:::::: commit date: 13 hours ago
config: m68k-allmodconfig (https://download.01.org/0day-ci/archive/20251123/202511230820.9CzhKlk6-lkp@intel.com/config)
compiler: m68k-linux-gcc (GCC) 15.1.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20251123/202511230820.9CzhKlk6-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/r/202511230820.9CzhKlk6-lkp@intel.com/

All warnings (new ones prefixed by >>):

   lib/crypto/blake2b.c: In function 'blake2b_compress_generic':
>> lib/crypto/blake2b.c:108:1: warning: the frame size of 3440 bytes is larger than 1024 bytes [-Wframe-larger-than=]
     108 | }
         | ^


vim +108 lib/crypto/blake2b.c

23a16c9533ed92 Eric Biggers 2025-10-17  101  
23a16c9533ed92 Eric Biggers 2025-10-17  102  		for (i = 0; i < 8; ++i)
23a16c9533ed92 Eric Biggers 2025-10-17  103  			ctx->h[i] ^= v[i] ^ v[i + 8];
23a16c9533ed92 Eric Biggers 2025-10-17  104  
23a16c9533ed92 Eric Biggers 2025-10-17  105  		data += BLAKE2B_BLOCK_SIZE;
23a16c9533ed92 Eric Biggers 2025-10-17  106  		--nblocks;
23a16c9533ed92 Eric Biggers 2025-10-17  107  	}
23a16c9533ed92 Eric Biggers 2025-10-17 @108  }
23a16c9533ed92 Eric Biggers 2025-10-17  109  

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

