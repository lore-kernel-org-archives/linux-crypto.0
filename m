Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4356718BC06;
	Fri, 25 Oct 2024 08:33:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729845186; cv=fail; b=U627O6BwaFSQL6kg8geq9rCbvB3859S2TETVoXxB17iq+AmWDyqYuLaeWLUUWhMsO+1oPr7B5sPsf1A5GNenaK4Kb06+PmpfpgeDebYqF2fDv4MIxlLU2K5yFS0cH3S09z/gridqK6X4Z8yzAIJt9gn0OhK6mTsX6MFx5cRsioY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729845186; c=relaxed/simple;
	bh=BYYykAXF0BOJjFf0BjgOYizpF9E4KVJfucBXtx3y+dc=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=lgj0hHHtW/I59Qt3+6aYgD89ZkvNWTVgN8gOPVVubMBH6exLsRMNjAbI29DRAqgLjqxgnHBx3QtI+ZSr591FlnswI5a502jSCDheRjPKh1jm1r1iwYMX2SysvK02te7hAXBQcVVzctpNH1DlHu4LWxdoDy2dxBD1WxbS2Hlpw1M=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=BtINDq+n; arc=fail smtp.client-ip=192.198.163.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="BtINDq+n"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1729845184; x=1761381184;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=BYYykAXF0BOJjFf0BjgOYizpF9E4KVJfucBXtx3y+dc=;
  b=BtINDq+nWIlDBPfpUZUXgl2x/Qp2ZImRgyrV12lyYmuCuOocBnzReO+X
   AXbmTi35+qE+sQYuYaX261KFCVC10dk8qCE+lFtZhvyaExK3TjTCD6Gyt
   Q/hLqiPZa/aUnh7JSLdO9tfl8QeDMNG9QreO8v3tDn+yjn4wAW3NYnd8W
   v1zP8tn99rfPYbIZqXkYtwiVeYkjU86Mv8r/8GIlZYxWC3tWxz6uUadyL
   I+y0/HAp6WjLrWHKtp4cKo9zJZdzZnJ33Nk2R4O0GkU6bJc4DIgeogQf6
   G5kKkj9njfAztEKPuVk/VxUDKoMqXCgddAmMbdvSp/YJZW0iGJo77D/LS
   Q==;
X-CSE-ConnectionGUID: tciQj5woQjKUZ5ltk72Ccg==
X-CSE-MsgGUID: kU3DFgsYQTKmT9BhFza4fQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11235"; a="29624559"
X-IronPort-AV: E=Sophos;i="6.11,231,1725346800"; 
   d="scan'208";a="29624559"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Oct 2024 01:33:03 -0700
X-CSE-ConnectionGUID: fC1M76eLQGeUEP80bBaasw==
X-CSE-MsgGUID: WXpV3bt7SFe4TY046ptTWw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,199,1725346800"; 
   d="scan'208";a="85613919"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orviesa003.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 25 Oct 2024 01:33:03 -0700
Received: from fmsmsx601.amr.corp.intel.com (10.18.126.81) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Fri, 25 Oct 2024 01:32:53 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Fri, 25 Oct 2024 01:32:53 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.48) by
 edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Fri, 25 Oct 2024 01:32:53 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=cYClgCqs/D10vt37kYAoNuMUW3aptWloPIECOiOyQciiKQcQbNb0Da55JmFFDB/5rEg3EobGCZkfGjSJiFHO38GcDxwJWhWWTeJfQC8kryWtjeUSss8cx6pXtQiTtm/dONMIrpUoJPsF+sex2iZXOW/0qnPt5eiFNGRv8g+tiJPeCZBtO5HD2Wyf6uTd45FuaWJpqBcOElHq83zoJ5P9pvVG0bmE63qPLVowFqQpXC29Yk5uojZhODEMRAJq9+OZKTG9bu6lj6MfkBM7nQgWVcuKmmBMZJbq5f176UVlgN9wiR7/otPj25E0fTJi55UQuUggdNsWptoARehnk/GT8g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9j3lmIlxT+4I2SOgf3tDdSc/nemuUxQamVf09TzlGrE=;
 b=gFX7OCjK2O6qhZ6VaE+5tgFP/AxCN9QEjKnm+BTflG7EAfG525Awts5g79+vfBDPYSBgWzcqaWRYojj1Sv4GllbuYTnNYHece+XzaR+iY4U1zT6W4V7XKykamjBpUSpWpb5asGDq3zp9iXzpZMm25zsizucPyXLwW37bHSd0i0t7OO2CjT39vcPG0+6UU0jy7f/TJSEQygJDrZzz7Qca6OWWlGpcKVu6G8HzCuEBNp3yDGRtcAgdLPAxugdIhm6Y2Bo4qaVtTgWw6A2tmFyogBnNCzo/rGERGJ91rE0GqHC3iOLkDV4nnE7V925ghesYZG3ynkO2EXJAqh2gJ313/g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CY5PR11MB6366.namprd11.prod.outlook.com (2603:10b6:930:3a::8)
 by MW6PR11MB8409.namprd11.prod.outlook.com (2603:10b6:303:24c::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8048.16; Fri, 25 Oct
 2024 08:32:51 +0000
Received: from CY5PR11MB6366.namprd11.prod.outlook.com
 ([fe80::6826:6928:9e6:d778]) by CY5PR11MB6366.namprd11.prod.outlook.com
 ([fe80::6826:6928:9e6:d778%5]) with mapi id 15.20.8093.018; Fri, 25 Oct 2024
 08:32:51 +0000
Date: Fri, 25 Oct 2024 09:32:42 +0100
From: "Cabiddu, Giovanni" <giovanni.cabiddu@intel.com>
To: Wang Hai <wanghai38@huawei.com>
CC: <herbert@gondor.apana.org.au>, <davem@davemloft.net>,
	<ahsan.atta@intel.com>, <mun.chun.yep@intel.com>,
	<markas.rapoportas@intel.com>, <damian.muszynski@intel.com>,
	<furong.zhou@intel.com>, <adam.guerin@intel.com>, <zhangxiaoxu5@huawei.com>,
	<qat-linux@intel.com>, <linux-crypto@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] crypto: qat - Fix missing destroy_workqueue in
 adf_init_aer()
Message-ID: <ZxtXqkbPUJPvpiW2@gcabiddu-mobl.ger.corp.intel.com>
References: <20241024140057.18548-1-wanghai38@huawei.com>
 <ZxpeVD/D9Y7sfL7H@gcabiddu-mobl.ger.corp.intel.com>
 <1094e5d9-208c-4c41-83cd-5a77081aa5c1@huawei.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1094e5d9-208c-4c41-83cd-5a77081aa5c1@huawei.com>
Organization: Intel Research and Development Ireland Ltd - Co. Reg. #308263 -
 Collinstown Industrial Park, Leixlip, County Kildare - Ireland
X-ClientProxiedBy: ZR2P278CA0002.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:50::7) To CY5PR11MB6366.namprd11.prod.outlook.com
 (2603:10b6:930:3a::8)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY5PR11MB6366:EE_|MW6PR11MB8409:EE_
X-MS-Office365-Filtering-Correlation-Id: 6ccc960e-7bf2-4631-eec3-08dcf4cf9d33
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?nvZfwvRVynQH7EkwqpotsOtAoG+rwIeR0xfmVu+4QZ5NtEEylimDrvKSJSOt?=
 =?us-ascii?Q?otvTIWD8ytyqwXqSOz5+n8lgPT3r7xDvCn/DY3yKJx6bQpgHpRtsxkJV+pkl?=
 =?us-ascii?Q?Okx1iTopPeyapz37bXrPaTxTj2Bdu4erj5moEJMFOMFE3qwYijRhRswJ5N8C?=
 =?us-ascii?Q?av6BX/dvCydRRy0YBikqrOcCMj89llm5RJRyPc4nqMFAuMDoKyig0n2JcLyl?=
 =?us-ascii?Q?DJyGAiNoZneG2I4hORaSVXn1enuDxXPawxw/sTd33KHwAYIYyPwa7sAzZiB1?=
 =?us-ascii?Q?pSgngoDfgMvjfJ8Y0RPk265O9EQs7bj+CYU5u2OE2WmRaiGdW9Pr0Q11eZxH?=
 =?us-ascii?Q?q0XtPgXpp/08cTtO0qwHo1ieFF9WOEueulkl1rtoQc7VS3i3quQIwd7E4vNr?=
 =?us-ascii?Q?w91EbYD3+2TiykVkt7JX5vup0A5obZCayfVxKMe1MTyJDi76WhRgIvg88LdF?=
 =?us-ascii?Q?K9up8zfkJaUqtOIg9Nzh9ISwQqNdIjsJBP0LgohgcMJuJtzdEaUsS7syTEf3?=
 =?us-ascii?Q?BXOv7b6gmpfXkLQvlqnMnOnUOAFoqUic+y1Zhjl3X0P833+HIeER4QIXX9dc?=
 =?us-ascii?Q?A6pfYZWev5ZCEuPYmPfh0FA9WkD7RpSywNlcne6pGmFeugg6/PUc8J+yP0cW?=
 =?us-ascii?Q?zo6k3IdxuhCX/IwB2RbR1WpKgzCxN82yEj3Tsjuqw8rhg//igaEwCkJhT+bk?=
 =?us-ascii?Q?93WgMAklwxZjCjfe3Nzo+n7k9nNHPO4JDDBSbNH4wC0G3/sGiovNr+jA16IV?=
 =?us-ascii?Q?zu2oD2SOaZdDcx9UqsX8HyM4Zb3LqLpg+wIYn0TBZz0M0eZve9KFbBlMoVgQ?=
 =?us-ascii?Q?x/sKX6xnAlTlzV5b0vrIpbQit/mjv9jDKzPdxTQZlscHaP2sfEs1aRM2ePVV?=
 =?us-ascii?Q?XyC4YWKbjlHkfOL1beI9Rpywr0uK3WeKv/kYExK43+2vUQ1hDCRkl19trNOi?=
 =?us-ascii?Q?5dUmjJAL4d0qiS5VPRdx2l2x5H4NViaTrGXNNRHjn51lAHHqyAAI5xRlS/iI?=
 =?us-ascii?Q?PQve1H9nMAj3uk2MZUZjEo1B2Cc2CXFcdNSiV+VmlNoAvT8RoUROH1GbWP/9?=
 =?us-ascii?Q?r0DXk3DliFrjPc9L+h+xlZOUOz+WTwciSL3ww04vCRmLcu48h6fK2GdJC7fx?=
 =?us-ascii?Q?JItJlQHsoTRE9E6BYnDu/uIjKdibl6zrMS7N4SiQzZG4FmQ/LPT+lfbfigJl?=
 =?us-ascii?Q?BUMz/ma81u9dlQglTqcerabgf8VzKCNzjqGVbKAq6wVVF4f5vNU9O0y8hi2Y?=
 =?us-ascii?Q?tyE7MdIsyQwleGlhGV6/ABm6jtau3q5GX1F+7dxdOkLBgEjFo2z0XDaZdTwi?=
 =?us-ascii?Q?15M=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR11MB6366.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?8bi0iO2kLGcsFzaQT7H0IqvXCV8wAw04HGsLBMfVm+uYLayOCYzwBmqYC4u1?=
 =?us-ascii?Q?wgVKeOgY8CNW03/fFFACkt5CQ+1D8ZKf2jpa6vuAg/kUsUb3g9ti/7IrXb/1?=
 =?us-ascii?Q?gYAMWZ80aowy/QfEIfLGVE+FXbf7CVfZAuqR7CvsQuKX6Zs1tKyxXEP9Lqk3?=
 =?us-ascii?Q?Kf8aQMO8+Q+i+K251seb3QLo2h3d5zrTU4RENV2kLNsdB71XB4MRx4Bv8x20?=
 =?us-ascii?Q?l5FEdmf2EqNWDRK06yTHiqCpc+TH6tPrmZOOackYm/z/aADHDqUlo1cb6r+Q?=
 =?us-ascii?Q?dpzrdpN3nvyRVOxnJc/9lBBShweJySNOOvEHtWRllegxHJ6ahBp1q8kbNr5H?=
 =?us-ascii?Q?RbK4lCYfkxQTB1eiaWCjYL0W2E53lp9dC2kYqz2OgSamfAWYVR9h3GGT00Qm?=
 =?us-ascii?Q?FpQf6AHxfk799JWEInXFSsocA7MdEZv+rtUJHtku4oITeJCi/ZWQCvbc79wE?=
 =?us-ascii?Q?j2OH1j+sq/Fbz9Z5MerB7LigJGx8tK+Y07/2oq6f7SLHv14LEfnq6U98MZyc?=
 =?us-ascii?Q?5hcwmF6vSkWHtEsIFQGT+CEr+HeX+saKWMrCUluuokkavH784rFX5B66mdAR?=
 =?us-ascii?Q?WZrk+ol8a4QiEDVyeg/LjfI1MZXYc63PlC6o1iL20U8rsb0GekdslzxNsHph?=
 =?us-ascii?Q?5foIM4k9C45oHuaBzLjx3+85tek7z8nhpwSHiyCDs85NKgPOxyEP3tzxcLUC?=
 =?us-ascii?Q?jn9694MEDmC/wmUtWCpPFlF+z7SLltXklxQ6Vf9zxhTgIxmuSwQzt4Ebi3ic?=
 =?us-ascii?Q?vAouYP9SMf3UvGBmLLDqQVpFo9qRPGGDK3u+/Wlvb8MYwVbTU6hLYSdmCKjz?=
 =?us-ascii?Q?VFO3Pb0eycjpYMKqX01UeHufzwxWWiyKBddQ1V1hkTetAdIikem4/GIMlQiv?=
 =?us-ascii?Q?ej+f37JgO3xIhn3+3hvDA21rvQOKxk3fZmJHNMRlEZczxXKQpdCNckCATAtV?=
 =?us-ascii?Q?wxZB1ZzcVfbtR/fv+ZX0MtLy+ZL7ES3z50brr7dQW0bcNB1+VL3CCAbh2aWz?=
 =?us-ascii?Q?6PKbTdRKgVRtmOisQH2uatDRJ5bir0TwUX6GJbvhel78wx8yCpQlym04CwWF?=
 =?us-ascii?Q?at7PUerlFAXg64Zx/jz2SaRs1wB0eYWT64LRwXk+yO0mcUi4gPsEoHWgbhr0?=
 =?us-ascii?Q?9ys9rzaS26QmytRyQd78nG5z5kOWu1ADRy94heZNWTGn6rVExOpX2U2sjyqF?=
 =?us-ascii?Q?A5YxRBf2keYqZ0ooKf6drqtEmUbPmZTU16iV3Mf6ElNfr6pVB9cXFY6g8Rfr?=
 =?us-ascii?Q?G7tRRHaTMa4mJV8VMUQIHxRW8hbr4rcb9Kor37jCebfzwXIPVrE15sYrb7Er?=
 =?us-ascii?Q?SqyJYbpfhXy9gdQ3sC+rmldkD8sejFwpTReh4MIBg6g2EUBsDkdN9lR9TvCb?=
 =?us-ascii?Q?kNy86oOYXP8g4VAS7shnyhOLmdXxKqwLrfn+VSa155VI89IqhQSNiT/kJxXU?=
 =?us-ascii?Q?xEZ4pdbIvigahZ4V+WLpHU4KS/tbac9KlWyf56c0uJUphih3XNgBJ78sOYWn?=
 =?us-ascii?Q?zD3ALG6sIhP0bxQW1LL8ioZtsMUJNXPAdBo86qppSXPOYDf5AFV3N2aW5CvP?=
 =?us-ascii?Q?G+/FfPDrN6jDiuaupqv+UXXeaXp9/lFzoHMWNKanKuZgdXy6f7mgc7KvVW7J?=
 =?us-ascii?Q?Yw=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 6ccc960e-7bf2-4631-eec3-08dcf4cf9d33
X-MS-Exchange-CrossTenant-AuthSource: CY5PR11MB6366.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Oct 2024 08:32:51.3667
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +JvFmtXB31m+rjJCk+9iZG9GqjtBsJgVyrSPksxOZaXZV2pVJHwwKr0vuPKTSVQe9BEEAvAv5yO7nZMJQ5NeF+HZSPxWK2E4pUMzj0dPNWI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW6PR11MB8409
X-OriginatorOrg: intel.com

On Fri, Oct 25, 2024 at 09:24:52AM +0800, Wang Hai wrote:
> 
> 
> On 2024/10/24 23:04, Cabiddu, Giovanni wrote:
> > On Thu, Oct 24, 2024 at 10:00:57PM +0800, Wang Hai wrote:
> > > The adf_init_aer() won't destroy device_reset_wq when alloc_workqueue()
> > > for device_sriov_wq failed. Add destroy_workqueue for device_reset_wq to
> > > fix this issue.
> > > 
> > > Fixes: 4469f9b23468 ("crypto: qat - re-enable sriov after pf reset")
> > > Signed-off-by: Wang Hai <wanghai38@huawei.com>
> > > ---
> > >   drivers/crypto/intel/qat/qat_common/adf_aer.c | 4 +++-
> > >   1 file changed, 3 insertions(+), 1 deletion(-)
> > > 
> > > diff --git a/drivers/crypto/intel/qat/qat_common/adf_aer.c b/drivers/crypto/intel/qat/qat_common/adf_aer.c
> > > index ec7913ab00a2..907144ec7e65 100644
> > > --- a/drivers/crypto/intel/qat/qat_common/adf_aer.c
> > > +++ b/drivers/crypto/intel/qat/qat_common/adf_aer.c
> > > @@ -281,8 +281,10 @@ int adf_init_aer(void)
> > >   		return -EFAULT;
> > >   	device_sriov_wq = alloc_workqueue("qat_device_sriov_wq", 0, 0);
> > > -	if (!device_sriov_wq)
> > > +	if (!device_sriov_wq) {
> > > +		destroy_workqueue(device_reset_wq);
> > The missing destroy_workqueue() here is intentional as the device_reset_wq
> > is destroyed in adf_exit_aer() which is called if adf_init_aer() fails,
> > see [1].
> > 
> Hi, Giovanni.
> 
> Thanks for the review.
> 
> If adf_init_aer() fails, it will goto err_aer and then call
> adf_exit_misc_wq() instead of goto err_pf_wq and then call
> adf_exit_aer(). So this patch is needed.
Sorry, I overlooked it. You are right.
On the error path I would also set device_reset_wq to NULL.
	if (!device_sriov_wq) {
		destroy_workqueue(device_reset_wq);
		device_reset_wq = NULL;
		return -EFAULT;
	}

Regards,

-- 
Giovanni
