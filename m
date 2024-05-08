Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 038423F8EA
	for <linux-crypto@vger.kernel.org>; Wed,  8 May 2024 10:24:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.19
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715163852; cv=fail; b=pRtn8WT0Vz6h8SrWiUnSk1MAEQ1eGP2AGscfRIOIir4upv+6WaZOFjgY+zUgLKX9EBc974qPYTdfJ6YcZj1OYf7zbhGCIX9u/J6A/xdg7oX4UQqcJi8yNc8cgLCnuMMKKA5n9speAkXcYdfEaq5rhT+3nuj1XNL+Ujxq9qN8i7g=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715163852; c=relaxed/simple;
	bh=FuuLz9eRKdVx4sJycgtKIJzi2lWdcfB0L1WY53uXYns=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=DqcA2qVVb4KImAfn+QqxDQLutiDJrpwIAHnlqnIAlZdp5b1kBUJrCvEBbL11sxleTOxh4lkYYP5e06YwCUUm+6z2G/29G+Z0YPRgFoV8G6nrDZG0hF5BjCZSlzi2PRBddr9C3Pe4y6hdvHvJ9QzVv+1SDsBTtAVBBiUYVV3JjdU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=H9A+h5Ms; arc=fail smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="H9A+h5Ms"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1715163851; x=1746699851;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=FuuLz9eRKdVx4sJycgtKIJzi2lWdcfB0L1WY53uXYns=;
  b=H9A+h5MsizHo/rF32SiDu78MjLKQpIhYdc/ZHClv8+41wfI9q9Wz36LV
   /avpUOo4gqlHqe2WqEBys5fIQvbNdBvHesSNHQbv2dyrWbRMqTivrzZsK
   41VMfc8Qj9c3mIZ1ZCJB6ifPLC4fYz/MARpX9R5DELcuCzIqXZWqn12fC
   D6l0sABGQv4LZhTvEEi0WsQRHVvOCQ/yIqUVhBnXtt81rzA1t+XaI3pci
   sTuGKobHoyhjxG8fZl2SSM5jWqI/EwB6951QGXQYrWLVxTlARJaRvq1N6
   zJelZPcJy8RlqOthWNW8Rfax+rpoIKHZH7u6H3af2yJF0gS59Cwf1xW6g
   A==;
X-CSE-ConnectionGUID: XvDeF4ysRn+Fe/QchlnxfA==
X-CSE-MsgGUID: MB7Lt1aPR3+39MRcJLgrpQ==
X-IronPort-AV: E=McAfee;i="6600,9927,11066"; a="10865484"
X-IronPort-AV: E=Sophos;i="6.08,145,1712646000"; 
   d="scan'208";a="10865484"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 May 2024 03:24:10 -0700
X-CSE-ConnectionGUID: VU+69qq7R/Kf2YkKgnsBjQ==
X-CSE-MsgGUID: SBUuokooS1SriRSRiyOGbA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,145,1712646000"; 
   d="scan'208";a="66271542"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orviesa001.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 08 May 2024 03:24:10 -0700
Received: from fmsmsx601.amr.corp.intel.com (10.18.126.81) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Wed, 8 May 2024 03:24:09 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Wed, 8 May 2024 03:24:09 -0700
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (104.47.73.169)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Wed, 8 May 2024 03:24:08 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bNCODMqqnC0bj23LvrKffatyRbIQAJZYqnwdBOmdThx98R1/RLuQY3ll09fT8st/NtKiBJQUAm2Z3Vul8PaUitBz6IEdfM67aFOj7ImT7RehzndGYuqNVJyskuYpoZHILrbUKo0eNDqFzu3+OS56VhgVWQbmfHbwQdyddGgj/2MqmCjnpAwXcPrYvdbyzCd9sMEWVrB/dbTh+xbvMO+NUEz72Hlc3k+49AENwfu011f+/TiHvYYyZk6SE8lcrRfE4oTqGVWlaZmhs7iqq/CbdvcR4Z/P0bJHUO5CbyBDJ0JaSnb8rdafMztN1UvUZ1M3HnYucZ69h4Qo/Ri/EhfpRw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JPbNu21d/uWUPpjY6dtBfYK8+oDhNmpX9V1oO89vlWE=;
 b=m82jvj6YGEcXl8h9IYh+Wr5ToK9Hec5am02p2Q32dX3iGbc6dP594/zXdVIzoqkc5s0gxmMrG/TDL2qAQ/igijLKfn0aX7M+ZdXOn0rG/IjJQ1cpVjQuKDJS7NRsn+H/1stfJ2EdFp5XSN5hUCAaSFoz0jMjZN68/b1vn0FNhMoWBwoil445urLnUcffiA5ogk6HPV/j1DSX4c9LdgVd8ZF9+3+vq3VnqnRYzVcTsIVV4qD3WB2CvJpG4dOypjQIRFoQ9Rza9uyo42Q/EBgWcdNy3mGUKSyOMg0I54Hs6ax7jIskuRH5tSqTrU2ryqs6YzZnXlt5DiBuaPtJU0kGqg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SN7PR11MB7667.namprd11.prod.outlook.com (2603:10b6:806:32a::10)
 by LV3PR11MB8726.namprd11.prod.outlook.com (2603:10b6:408:21a::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7544.46; Wed, 8 May
 2024 10:24:01 +0000
Received: from SN7PR11MB7667.namprd11.prod.outlook.com
 ([fe80::a375:5a76:57a0:ac3b]) by SN7PR11MB7667.namprd11.prod.outlook.com
 ([fe80::a375:5a76:57a0:ac3b%4]) with mapi id 15.20.7544.041; Wed, 8 May 2024
 10:24:01 +0000
Date: Wed, 8 May 2024 12:23:50 +0200
From: Damian Muszynski <damian.muszynski@intel.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
CC: <linux-crypto@vger.kernel.org>, <qat-linux@intel.com>, Giovanni Cabiddu
	<giovanni.cabiddu@intel.com>
Subject: Re: [PATCH] crypto: qat - Fix ADF_DEV_RESET_SYNC memory leak
Message-ID: <ZjtStuIt2COdz5Dp@dmuszyns-mobl.ger.corp.intel.com>
References: <20240209124403.44781-1-damian.muszynski@intel.com>
 <Zjs6VxtkL8QLtHIH@gondor.apana.org.au>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <Zjs6VxtkL8QLtHIH@gondor.apana.org.au>
Organization: Intel Technology Poland sp. z o.o. - ul. Slowackiego 173,
 80-298 Gdansk - KRS 101882 - NIP 957-07-52-316
X-ClientProxiedBy: WA2P291CA0046.POLP291.PROD.OUTLOOK.COM
 (2603:10a6:1d0:1f::15) To SN7PR11MB7667.namprd11.prod.outlook.com
 (2603:10b6:806:32a::10)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN7PR11MB7667:EE_|LV3PR11MB8726:EE_
X-MS-Office365-Filtering-Correlation-Id: ff55232d-4f87-4000-3c96-08dc6f48faa7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|376005|366007|1800799015;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?e7fVBnqhr5dw/jIQM75uauNokNho9eHEwBSYW+6Eohx5A8kDX9HNV0QKYf/Q?=
 =?us-ascii?Q?LQMkXZsGE/pBB1hS+4WMxg9U0lCtfrMvHuOH1JVfR5o5ZESe7b4D58gofp2r?=
 =?us-ascii?Q?6gbifNnnEv45FcXbkFmqE+h9SoI/mQK5yN+XuqbAVtpY11Zf18GVFpeFENnv?=
 =?us-ascii?Q?Th6BbeGhXx+xIC2q9zxoc0o4WM1CPMEgutvmwykrUlkbQK0n/XUFDh/3zVGh?=
 =?us-ascii?Q?l8T5n1Xz5yCb6Zqss/rXv6HfkEZvOnKWYilklxBrROVq0pU5/3wew0bg9BFh?=
 =?us-ascii?Q?HSU/FPZraEwmmMMwCfAFzPYIinUXxVlen9zcrje1csOPycDe4FUJCyS/4HD6?=
 =?us-ascii?Q?VpK1P9NI1WnFQM7VzFVPIDuEw3RqWUNmpKq/P+84tlb6weXl+oOiT3E0QLJF?=
 =?us-ascii?Q?DzXl5Wnlz0X7CkVTm8GBG3pZT+04+OKQP7mNbObSXWWRdj4QRCZWKDmaK+Zz?=
 =?us-ascii?Q?v0J+G+1pXDiEE/CSIxI1Q905zTcrCp6i5MNifBiSjNVMMwhk8HyEa950swrC?=
 =?us-ascii?Q?YzI/xngzHJXM8FAECTu+L6zQPReXKqwFOjY9u+2Bxn9fTJd8Kb5gFKvexXBl?=
 =?us-ascii?Q?fRi0uhC97iePyQ951LeqlyjYT+bRznh16HYq+jt7LWh31hjCfKDOTxKI3C+W?=
 =?us-ascii?Q?fVZK9W0m/g2+sF1SvZf3z0jL1xu42WFDcOvCoaNyBYdEjSEBNWeLvpUacUdu?=
 =?us-ascii?Q?H0tppCmmgro3nljWuloKbtaP8c8dCE+0qVDHhx8G2wgglGsHSjuOIotdPFtA?=
 =?us-ascii?Q?uTjDxDuh0ytRAxu8oCAMnwsS+OeZ/vys2O1iG2FKt8JsfwyKZp3ZJxU0rAgI?=
 =?us-ascii?Q?lf3BovVa5GbYdwKtLkdQfNm94vP0FDMK83THFvCFtma1IFylgc5DSLhb+X6w?=
 =?us-ascii?Q?X80tnSpm7AYl/A0QplFSBwGoej7saov/3FUeHmbjxaSzZYY0LCTucBF+zg7B?=
 =?us-ascii?Q?ZJyOnQSfru/3FnacGA2p10iuXaTZ2YfA5hbKijX4Z1XQf0K083NxopQW7c0B?=
 =?us-ascii?Q?eaMrB7bKx0tZV3eTkVHRR0Z0rRweob+6n8HT04FzNQ9JfzjD/Txb3+Hwlpbf?=
 =?us-ascii?Q?7UJopH46OpilXJMB67MfzHiKXNWNsL0TErmCRifOaGh28R9dvLg9av08/Xrh?=
 =?us-ascii?Q?OPCRAvXt/GRHC3Mi0KNpUwseXCaUL3sHyB3JLtsxRuZ8i8kulBITPelNebhD?=
 =?us-ascii?Q?cXAxG06qzM3gsvm8jhAx6Plvzzx/UONzsSQZXZrz835GfGwtpS/nBbDqNOk?=
 =?us-ascii?Q?=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN7PR11MB7667.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005)(366007)(1800799015);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?MxIpLvAwdvnLVIyOj2BWkRxqtJQtlpwYotTcavoUT/SRI3Shhm+aQ3+ztIKN?=
 =?us-ascii?Q?7lH9htHVT5YbN7614dx2RDOns2g2QwodyNYgwMpvgwk6EsqzNpbGUYFTZUEC?=
 =?us-ascii?Q?pya+Xwg3tUHBs3Bbx93f9m4RpidataJIrs9pZSaXvIDZ9Ez1rTjXrFBMsV6v?=
 =?us-ascii?Q?1j+vGAj4aoaYWD4abUDZB2WiREIp60LXom73fQ+gpohzvjelThepRd37lpXg?=
 =?us-ascii?Q?aq+VC77W3NA1Ls1BEpEwfZI7I3ZTXR4mB9Ec56/3p2py6eHUQ7vfNtnTLhs9?=
 =?us-ascii?Q?/NGOK0b0jf0TTqk0Z7P/AxxeGf/Rz0bz+q0vXAdRMhL11gyyR6olwcIAUqWL?=
 =?us-ascii?Q?tPTF5AR4ky/ZHoMlxOLAE/l5SwgTIANwpMt2/zCrDKzWd0BZkI3AZq44WRQq?=
 =?us-ascii?Q?kU5bXQvruBTTLuyR4suzeyezdARKhmllSig25O6QFjDONQ6poCENrhv+m4LP?=
 =?us-ascii?Q?BM3sTDY+4Ln2pVt5YsyWuA3MlwbTe2kpEM+DkGsY2JVBa3MpNb/KLkHJbPyV?=
 =?us-ascii?Q?HtSsQzG7M8q6tGq6Oci5w7tjPjSSB8k6SNNqEmTvM0MvgOD9DpY5gqbh4+0q?=
 =?us-ascii?Q?f0Xu71FTleOIN3khTO+RVSPxakeDOq8gD+vsa3Z7hW5bet854hlTBu2UKDdC?=
 =?us-ascii?Q?pL1REOao3RR8nY8sqEbGq0l2Q85Pb4q1rkG8e8SqdVZxtzTMOfuBHJz6BSrF?=
 =?us-ascii?Q?7avSE9guTwVefNw5TovTrvv74viNpJf6/fayOlm17V5x4dvx1bpPoT23JY5n?=
 =?us-ascii?Q?kcafuvcxXPLWD5NIw1IE/JOspDYbFYoor5fkn9yaHnUwLG53kxDwYjuXGy32?=
 =?us-ascii?Q?I+qSaeqrWhKgdd95MycsoxBwom/lRcFBBdy1oMm75b7SKS/4Y87hLgnEjcfY?=
 =?us-ascii?Q?GXZFPOiTOH9rtI7MTZ73wmTzBv9ilkQUPYQyM4tjUvGW+Mis597rL+LTyYEA?=
 =?us-ascii?Q?WNgZU1upfOt9xbWF14CUVRXJpxGaAfxnMNak1wchQ8A/b/fqTI5iyMK+EwSX?=
 =?us-ascii?Q?1UYf/rX+7EeNzm6NV/fErhQWTjtaO0DDFiDd5kjZWp7+7qu+eP81Snk8L4vn?=
 =?us-ascii?Q?E/QjJ7hO04vAqnrsm55Z1H8G6rcqUzDKBegASCP7sS9MnNCdxYWFTVhleQdj?=
 =?us-ascii?Q?jTelbT2uAYUbmd/3picNLX/UBCYjJM3azCVxAosw1CPSh87uV4316nJ88X1o?=
 =?us-ascii?Q?LEy7mK62GNdGiP9B9yGcuGDL0axx2gwxUN1m6nc4VydIIS0JvjfyPHe2hTaG?=
 =?us-ascii?Q?K40EZP2Hgdvr2XKg2flplavgEIEMD+XrJeyApI8QEIh9t3ozEGwosoK2AbCl?=
 =?us-ascii?Q?+wLKqkibmYa+7CE5dgvLXkeFoW2e9lwb8xcOPvZQzykBpnUCR1CSyc0h4CMo?=
 =?us-ascii?Q?zhWM8IItrUNO6yUVm1BYnLzsOAMvNl/6pzGsUVLOWckXsINeF8FHuLrKPWJc?=
 =?us-ascii?Q?DeoxVCmVObzqzrXoA9tQxwEnVPs3os9kzn/TRBMURLfo6Yh1SGhWJ2D/2qdY?=
 =?us-ascii?Q?bCMyN9XtnBJ1w+hGsP5N9N1TWzhYt2eWCRWm+BQ5LDIIGpGF84kkVcSvEhTE?=
 =?us-ascii?Q?dLAH8sbUcr52ubhXeeSBGjiaCiyzB5ZA40OFPZX/eUcUXr0Y/jChwXJG6N9R?=
 =?us-ascii?Q?rw=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: ff55232d-4f87-4000-3c96-08dc6f48faa7
X-MS-Exchange-CrossTenant-AuthSource: SN7PR11MB7667.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 May 2024 10:24:01.4731
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: VC7pn4qdXwmoC5+HSsWTgMmYn9dLVL5QsV0ScaW96wbNqlM1Tc02435CAo2Xc52nsgRBeznHLEEQo3dOu25hI/UBOhN2JIWSrMaayIiOu2A=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV3PR11MB8726
X-OriginatorOrg: intel.com

Hi Herbert,

Thanks for your vigilance. I based this fix on the description of
completion_done() which can be misunderstood as can be seen.

--
Damian

On 2024-05-08 at 16:39:51 +0800, Herbert Xu wrote:
> On Fri, Feb 09, 2024 at 01:43:42PM +0100, Damian Muszynski wrote:
> >
> > @@ -146,11 +147,19 @@ static void adf_device_reset_worker(struct work_struct *work)
> >  	adf_dev_restarted_notify(accel_dev);
> >  	clear_bit(ADF_STATUS_RESTARTING, &accel_dev->status);
> >
> > -	/* The dev is back alive. Notify the caller if in sync mode */
> > -	if (reset_data->mode == ADF_DEV_RESET_SYNC)
> > -		complete(&reset_data->compl);
> > -	else
> > +	/*
> > +	 * The dev is back alive. Notify the caller if in sync mode
> > +	 *
> > +	 * If device restart will take a more time than expected,
> > +	 * the schedule_reset() function can timeout and exit. This can be
> > +	 * detected by calling the completion_done() function. In this case
> > +	 * the reset_data structure needs to be freed here.
> > +	 */
> > +	if (reset_data->mode == ADF_DEV_RESET_ASYNC ||
> > +	    completion_done(&reset_data->compl))
> >  		kfree(reset_data);
> > +	else
> > +		complete(&reset_data->compl);
>
> This doesn't work because until you call complete, completion_done
> will always return false.  IOW we now have a memory leak instead of
> a UAF.
>
> ---8<---
> Using completion_done to determine whether the caller has gone
> away only works after a complete call.  Furthermore it's still
> possible that the caller has not yet called wait_for_completion,
> resulting in another potential UAF.
>
> Fix this by making the caller use cancel_work_sync and then freeing
> the memory safely.
>
> Fixes: 7d42e097607c ("crypto: qat - resolve race condition during AER recovery")
> Cc: <stable@vger.kernel.org> #6.8+
> Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
>
> diff --git a/drivers/crypto/intel/qat/qat_common/adf_aer.c b/drivers/crypto/intel/qat/qat_common/adf_aer.c
> index 9da2278bd5b7..04260f61d042 100644
> --- a/drivers/crypto/intel/qat/qat_common/adf_aer.c
> +++ b/drivers/crypto/intel/qat/qat_common/adf_aer.c
> @@ -130,8 +130,7 @@ static void adf_device_reset_worker(struct work_struct *work)
>  	if (adf_dev_restart(accel_dev)) {
>  		/* The device hanged and we can't restart it so stop here */
>  		dev_err(&GET_DEV(accel_dev), "Restart device failed\n");
> -		if (reset_data->mode == ADF_DEV_RESET_ASYNC ||
> -		    completion_done(&reset_data->compl))
> +		if (reset_data->mode == ADF_DEV_RESET_ASYNC)
>  			kfree(reset_data);
>  		WARN(1, "QAT: device restart failed. Device is unusable\n");
>  		return;
> @@ -147,16 +146,8 @@ static void adf_device_reset_worker(struct work_struct *work)
>  	adf_dev_restarted_notify(accel_dev);
>  	clear_bit(ADF_STATUS_RESTARTING, &accel_dev->status);
>
> -	/*
> -	 * The dev is back alive. Notify the caller if in sync mode
> -	 *
> -	 * If device restart will take a more time than expected,
> -	 * the schedule_reset() function can timeout and exit. This can be
> -	 * detected by calling the completion_done() function. In this case
> -	 * the reset_data structure needs to be freed here.
> -	 */
> -	if (reset_data->mode == ADF_DEV_RESET_ASYNC ||
> -	    completion_done(&reset_data->compl))
> +	/* The dev is back alive. Notify the caller if in sync mode */
> +	if (reset_data->mode == ADF_DEV_RESET_ASYNC)
>  		kfree(reset_data);
>  	else
>  		complete(&reset_data->compl);
> @@ -191,10 +182,10 @@ static int adf_dev_aer_schedule_reset(struct adf_accel_dev *accel_dev,
>  		if (!timeout) {
>  			dev_err(&GET_DEV(accel_dev),
>  				"Reset device timeout expired\n");
> +			cancel_work_sync(&reset_data->reset_work);
>  			ret = -EFAULT;
> -		} else {
> -			kfree(reset_data);
>  		}
> +		kfree(reset_data);
>  		return ret;
>  	}
>  	return 0;
> --
> Email: Herbert Xu <herbert@gondor.apana.org.au>
> Home Page: http://gondor.apana.org.au/~herbert/
> PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
