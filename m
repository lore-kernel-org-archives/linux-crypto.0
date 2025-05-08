Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67ECF221703;
	Thu,  8 May 2025 08:19:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.11
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746692362; cv=fail; b=pUXwm3oNK0SuF6kSSqwZwC0RDzP8kebpadhRpdy6pJDZG1Q6cpKV2jOmScyMK14OOODHKmAPLyKzcG0Adl4orGcdV7jMj1fSWFEh4f6yMsnvdBiAs6XkN2xx9sf9Vu0H2BEddZJ1rCB+NKCzmzAs/uezFH8g3jA/i737ECkPodY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746692362; c=relaxed/simple;
	bh=krrf3HSfDNmcHlVwJbwmvxKIjj8ITiLpjcMRZ1WPic0=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=tQtZSRhufIWG07sUf9fwaIn45O3XOitunb9/NGSUbwMG4rfxEZq8AiqVyb4ik8NvbERR33TIOAPTGaZDGHR5OPZeVAr9mNFHpVc5TXEDuwu5bBUM9Rj2W05PgH4TkwnWrno1G+izbW0WGBZOcjbBqYCQJbRgwq9MVoFgiudrPuE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=DtqL0uZl; arc=fail smtp.client-ip=198.175.65.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="DtqL0uZl"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1746692360; x=1778228360;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=krrf3HSfDNmcHlVwJbwmvxKIjj8ITiLpjcMRZ1WPic0=;
  b=DtqL0uZlgH8KHg4KHdM1fq3lVOA4ZTW347Ymass72h/63WOnzYfr6Uil
   pfjwUobNmWrl6td0DxnjDMgYUhfF2wPnkK1Q5blso2wWnsDyMvHLo00/M
   9Y24ntfMkAUewRyAcdSxXqUmohiz6GCyBSMXUZoGSIWUZplNd0+B45+G7
   0SA6W/wgID0LTVkEZDj/KpGGUkxIOATjcgosR53XBmejqE+Xml7CR3/24
   66sdb/dKeSOt4wY/5nSqZmc0DrwSyV1sMhRR2ID97xsZNsHfNzLpzgbtY
   ZybMGatyVYF+dryx43N9rVcOWr1tswy4WCXyGb5vYyGWY6Cv0wrFa1oxk
   A==;
X-CSE-ConnectionGUID: 4t5/7pX0Sn25lH6opC4/BA==
X-CSE-MsgGUID: kNekZxxZQvuH2KoRLBSl3Q==
X-IronPort-AV: E=McAfee;i="6700,10204,11426"; a="58663744"
X-IronPort-AV: E=Sophos;i="6.15,271,1739865600"; 
   d="scan'208";a="58663744"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 May 2025 01:19:10 -0700
X-CSE-ConnectionGUID: +u2EyIRaTXOU6ahPg3ZpGw==
X-CSE-MsgGUID: I+6hcv50QSqHgY0ylMDUuw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,271,1739865600"; 
   d="scan'208";a="137211604"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by fmviesa009.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 May 2025 01:19:10 -0700
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Thu, 8 May 2025 01:19:09 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14 via Frontend Transport; Thu, 8 May 2025 01:19:09 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.46) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Thu, 8 May 2025 01:19:08 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=GVpcHquDlbTmrapSQ/ItNUs5fMLLF0Xa3MGClF4p3Vdt6KA+LBNWBKkz2PL7lmbAd0on22LvBCdLRarjTB9NKdJQUM1RL/7pl0HO6IA5UBzGi4RxDAxqM2FXNrQpKs6qdE/8zeo1sXveVEuy22Z2/UrbBrlt7YMwKjOO5r6F3uuTOW8RwSn2ZYzDLRGx4CDgXBNtHvCoW16mfVWzsQVak7I3yI00eFsWDxWtTX7QloCg09JG29bYVFr+tRKM4ardkN+gOHJoMXPi+tDC8CNduv7AFDzbduLXlDp9q3NL3gX7+y3r9vZRWvinQCTZrmBnj7zNsE2bmARA2FWkGZ/8bg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kR43zS1Cmv7/SEX6DWQOgMu4EWKQv4xegOhX6EBKiyE=;
 b=cTWPzSAKMUwV1bfbAr4JMz0bnkw65q93Pj6qD0k9wHzBq9AyCsOgxR56YueZj0po+fbGB7GLZotBPl9Ey0SmJ/SlXGuVAiyKTCgppR1D+luKQrr1KDW7G8+MvVJ97Xh2HIQj8QBLPqrL6msMIhRALgp0RRZsR1EM6I1Xc01xRYkRBaNhszrLzY5VlOfN34smEATDCHJDtBh6BXhI+L4qdYOSUXgW8O6sIwmqrxXiIIbLabtmJMvKpT9Ar0/1Pm0kzGbU1n8cl90IzdX2BaylGqZGBaTE4lb7H+OnGubivk79TH30VDHKVU7fHDwORSRJYRRbgnHh5HCPMmfJ1JZqwg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CY5PR11MB6366.namprd11.prod.outlook.com (2603:10b6:930:3a::8)
 by IA1PR11MB7319.namprd11.prod.outlook.com (2603:10b6:208:425::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8722.23; Thu, 8 May
 2025 08:19:02 +0000
Received: from CY5PR11MB6366.namprd11.prod.outlook.com
 ([fe80::6826:6928:9e6:d778]) by CY5PR11MB6366.namprd11.prod.outlook.com
 ([fe80::6826:6928:9e6:d778%5]) with mapi id 15.20.8678.028; Thu, 8 May 2025
 08:19:02 +0000
Date: Thu, 8 May 2025 09:18:50 +0100
From: "Cabiddu, Giovanni" <giovanni.cabiddu@intel.com>
To: Dan Carpenter <dan.carpenter@linaro.org>
CC: Laurent M Coquerel <laurent.m.coquerel@intel.com>, Herbert Xu
	<herbert@gondor.apana.org.au>, "David S. Miller" <davem@davemloft.net>,
	George Abraham P <george.abraham.p@intel.com>, Suman Kumar Chakraborty
	<suman.kumar.chakraborty@intel.com>, Karthikeyan Gopal
	<karthikeyan.gopal@intel.com>, <qat-linux@intel.com>,
	<linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<kernel-janitors@vger.kernel.org>
Subject: Re: [PATCH next] crypto: qat/qat_6xxx - Fix NULL vs IS_ERR() check
 in adf_probe()
Message-ID: <aBxo6nHlp92UjB4h@gcabiddu-mobl.ger.corp.intel.com>
References: <aBxOkY99jQF7q-7M@stanley.mountain>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <aBxOkY99jQF7q-7M@stanley.mountain>
Organization: Intel Research and Development Ireland Ltd - Co. Reg. #308263 -
 Collinstown Industrial Park, Leixlip, County Kildare - Ireland
X-ClientProxiedBy: DUZPR01CA0036.eurprd01.prod.exchangelabs.com
 (2603:10a6:10:468::14) To CY5PR11MB6366.namprd11.prod.outlook.com
 (2603:10b6:930:3a::8)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY5PR11MB6366:EE_|IA1PR11MB7319:EE_
X-MS-Office365-Filtering-Correlation-Id: 680712de-b902-4d45-219b-08dd8e08fdcf
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016|7053199007;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?PN0WmQkSF5YG7NiQ6EpyPrD9HFU1vi/hsGLgaLqjXdhqPduvNGyT8lCs0zyu?=
 =?us-ascii?Q?bzyG3Z27eW857aFlFHVP25t4/pyVImcIwDdtFgKD3MFR9/T5TKgmXKgBk5QC?=
 =?us-ascii?Q?Lts1ELyM7EyfDGrAtk+6n/Qv6JHghIN2dOn93iwkoxpKXZ/BE7eu4wr6vnvA?=
 =?us-ascii?Q?Kf+I7F9nXdSRuXZtS8HdTvK0B0yg3TE29MQ0lQPin0+CuwUvzVQ5KOr8txJ5?=
 =?us-ascii?Q?yBgZhXGjiyf2Giv5GHn9+zAFcdIxwhWGcNMJZDVvMS2PJMYU1qN2SAAQIQCb?=
 =?us-ascii?Q?fcZ3T3uxU7fup7J1zRGpxFNFytO4dW1lp3jq8pf9J5QNEm8qMdU/Dgx145mF?=
 =?us-ascii?Q?8wjc7RB5ADZfyEc/RRw6CvHmvTNVGw63S03hDbFTxEye5HmmSfO05Gd9cObx?=
 =?us-ascii?Q?nOm8RhtrXmJSquKCG6qEftCOWuwQrpzxir+SmouwEuC+uW/YS6XduusG/ze7?=
 =?us-ascii?Q?N61t7MDW1l63yOOOzR2rejgTo1JCUXDgcJ7FIWHQwPF4NAEx7BoViBrF1Yek?=
 =?us-ascii?Q?xGaMkzZGKixGHNm1TBmYyTqBAQe0uvlytLJQmFKsdPVm30P8XgnpjS5qqu77?=
 =?us-ascii?Q?ptkwFnZ3mPfD9vb1TnUjre0wRXQ5lZnX53otrERdJWc45I6ml6xOWwdOyrkj?=
 =?us-ascii?Q?PxUrZdGgrR9vvILqDhdP7VwvCfCE9APhKSPw4x9e6Mmdv9L7cNfsQK4i5Niy?=
 =?us-ascii?Q?cIMyHJjvsH+hpBiQBXjoOA1RkzsORRMv98DHDrylQivDGmFz4cb4Hv2wb64G?=
 =?us-ascii?Q?XgGO562WYC13O6GVLEoouc5ONs54HYx8k+Q3CKKrwmNeiTKsF2+hZ13xczIr?=
 =?us-ascii?Q?I+X049WTDTBks03rT5sqDQV6naCxvEnBEOZUiGsZjUdt3+Tx9CStkug0rOVY?=
 =?us-ascii?Q?1kR9yBY8ZQRlPRdQVDd6NH++BXgm9dREJF3bDAisxZBK/O8Cz5K12ftpeG3s?=
 =?us-ascii?Q?Ty/2fsdrRUpJ8DlKA/90E7pQNLErfO29cdwdOWfQboV7jLhweKap3qpow4Bc?=
 =?us-ascii?Q?ThZiTAkFd+tOGfL3W6FpKkUhd6PZ/kmZPL/K0KpM4cKoEM92FN9NrfV3rPzg?=
 =?us-ascii?Q?ZPsYHW65pkZ4kRK61z2WTl6HPTb6QYDreEc/P+90BGtGUDGpdubO/HYrpFU8?=
 =?us-ascii?Q?aGylGTWk2oMoOb+mqQv4wZlTINWXvgNhsCJszcOgxkiiS5NKh0vq2jpNMEfV?=
 =?us-ascii?Q?jzv7k0TvXxDgDnYigk48RPQX57L3waPduYLKb7mWAIiaXetYooEV0qdhw6tn?=
 =?us-ascii?Q?UOXh8Q75rRtoukto315ETP+sjvIZGSXCzBcXyhG9R6DQYzUXCenHpRfn/mAY?=
 =?us-ascii?Q?4sbURGVtqfhnHsPhzlTNmovPrWFCtAGZk789cmXk7VSPj4rLAjAZryL6AbcL?=
 =?us-ascii?Q?KJnP4y6znuErT0xRZST4TZn1cAg9GH7/8Dw4/UEWAqsv4JE5gw=3D=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR11MB6366.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?9v2eASjfwmBYqtjnmCUwlIJrIkd+mPHrbD8XEOUOKMA7SfndzAgSaKUbTlLk?=
 =?us-ascii?Q?iP3WvDsEBatyetd/JHx4fxEUK1EfuYY2USfW+rl/stcXEM//dxsyUYwBPZki?=
 =?us-ascii?Q?zzEFsIBC6p8u+0lhhKIJnbHWvRtKd7DoaXi+WxC2qulDiVM4v7LEPHewl2Yi?=
 =?us-ascii?Q?dC+Z0T9zyH2ApZ9r8GiPnOFSKcHRSlEDgCc3YUKxdHUkpKzOVPRAA08zqwF7?=
 =?us-ascii?Q?bq0T9LNKoR8jeUkIIFrEhM+AIn2ud3Rjde/ev1nsF6R65ybCHLig7I4aiVP1?=
 =?us-ascii?Q?NlzwQnlpe10p5jZYM5WuIiP96L5c8jQffbqDjy8/lzRd0SUGExjOccU40lOA?=
 =?us-ascii?Q?le8QmZJrQmx3qDWeZ4ALC1NLAV6iaWBuTcDj37DXi4RRQMHsDqJEXskbpP2e?=
 =?us-ascii?Q?lzj7U9nKjflYsBACNJ0Dh3CXx/jZBjaE2vZPMoyr5pXVRbMc4L+GxSFLzd0Y?=
 =?us-ascii?Q?VoFB42vgHb/HQi6e4CaWiyrDouHVF9CsnJuaDIF4tOgDw9RKlPgV1U4SJd9L?=
 =?us-ascii?Q?6J46gAa13Uai5RQDgUFDItseBN2MHck3xr1K+bE/UM6LRYXgQoz1vqbc9E4d?=
 =?us-ascii?Q?D4ki2LCM1RJggRg414LEQDMECVN+X2RnAjgIcTTx3CLtFMpxZTTGsPAzO4K7?=
 =?us-ascii?Q?TNDM7+53O8b1pXnwlbbQCRsXMlmXi+XUQS0ae+ar83RBHDD18fMhG2ckY0Dh?=
 =?us-ascii?Q?0BqZBJmycOVQKr9n3ol+pK2cPPzbzDQO6i1D5x08idi0GfbEa9IMBLvHwNH+?=
 =?us-ascii?Q?ZpWlCrPFH7vbXKYnCc1zYL9TkhySKgUV/HFwYHoiwaOA8y2OkphVbly0+m0F?=
 =?us-ascii?Q?9MzLNCuqVBWSJwnuvRvRIYyCPgnz/+OkvrARNJwT21HO/Q//B2QcwWWfszFD?=
 =?us-ascii?Q?VOv5hNR85b/Cb285SUwooytIEfy5nJehLuIDlB/O+CovXeHJosCVtwy8ss24?=
 =?us-ascii?Q?gX5lJ3+BKr7xwgdWrODgjl5OaW8GRrt/UGF5IQ2CrnXs6pyIOfhVeU9+tIWS?=
 =?us-ascii?Q?KqNsoVdZwwgxru/HHqC17elpqf5ryOSQmYT8nKN/fa2hRSf7VZuKPQpQb/gk?=
 =?us-ascii?Q?OsUb7p4wEyuU0x6Ls/c8ETj0/tqxn/i4yaZt9Zc0lU1U9rBSjbwB0++W/x32?=
 =?us-ascii?Q?F5FvxITtIbmKbR+ly3XaKL3aeeUGtQgHWn09TtZoP6J8Omk4FJHwRdhLs5MA?=
 =?us-ascii?Q?LJiAkPBMLy0huyiuvGC/83Jp6r2la/56VJvFuWG7KdNXutVJb4sWC0cWaxF9?=
 =?us-ascii?Q?+x1bFEfpE2l44xOW5mVp522W9MU4ckvUi8pnMX5d/j+0CFR0op477QpTQ76T?=
 =?us-ascii?Q?3ySct5WmvfHLa0AiFNGmAcXU69CRAVgeiFjCy21N6UfEG/eJV9USTdpCcOhk?=
 =?us-ascii?Q?a096fD7RJ16yJ3F8y7ObXuVr4iZnCfwp+bs5sLkXF3yY7/KG+qRbbzSyTXe2?=
 =?us-ascii?Q?rIHOmIkBTgFfskyBW88KY3FISSAUVpvm4fXTpsPirqjrbwOVWAjHe7TTW9pm?=
 =?us-ascii?Q?4C/IXXZxz0JkQbj4/jzoPcUnRznfQS+P9O2QjoQtnOlCESDk6ZPQemvqJcGX?=
 =?us-ascii?Q?elIM9KqMGVlwFqBx90ppLmKPThnBTv6XF5zxe9Ln8cGhRsDCYKkgmb/kNj3g?=
 =?us-ascii?Q?iA=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 680712de-b902-4d45-219b-08dd8e08fdcf
X-MS-Exchange-CrossTenant-AuthSource: CY5PR11MB6366.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 May 2025 08:19:02.7412
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1Re2BIpry9hidQaY7Bk6P+XHDKEn0v2iPrV8RqcW+F2VoLtVbsm7WpgUp2jlhy1ssHxmo0ia+ulj66zpMKMEl+EIvsl1pu9WuI0LMRL1SII=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB7319
X-OriginatorOrg: intel.com

Thanks Dan.

On Thu, May 08, 2025 at 09:26:25AM +0300, Dan Carpenter wrote:
> The pcim_iomap_region() returns error pointers.  It doesn't return NULL
> pointers.  Update the check to match.
> 
> Fixes: 17fd7514ae68 ("crypto: qat - add qat_6xxx driver")
> Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
> ---
Acked-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
