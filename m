Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65DE429D1C
	for <linux-crypto@vger.kernel.org>; Fri, 13 Sep 2024 14:53:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.16
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726239193; cv=fail; b=AIaU25fFu6If62K2c71PG2OXGHzoX/lw8zzC5q/qShNy4fo2EWk+vqukNZWRdLe8995RKJr5NeIjeVQlpr2mHQZXTeJ/bcfjSNxbYTmwDPAm0PI5/FND6CA1ivQznT3ANLm2jTxbCUYb5dcN1woISq9NdWhuDQWKOXEpluuYLG8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726239193; c=relaxed/simple;
	bh=D8P8mFN9fQ+Yj00QflVpTrC439jcHu4Fc/DASM0NC1A=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=BnsrlIl/H1uCPVLLdTfPdD9o7FhGbF2ovIzj+5KqNTxyzbCYNvbM8s482rDQqHLBzt9w8qZ++Inusw5ahJyO3NqUtzsrUOGOD+/mInygFWSnPTsMDGxlqBwvjpugljQmw/u+tWvc8SyxzkvJKrbrXP3zVjpM1vJ2WuJRGVbL85M=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Fv67TRUN; arc=fail smtp.client-ip=192.198.163.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Fv67TRUN"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1726239191; x=1757775191;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=D8P8mFN9fQ+Yj00QflVpTrC439jcHu4Fc/DASM0NC1A=;
  b=Fv67TRUNt1vcbl27t2o1IB9yozKxHyH36Lw6GR4F/u44OpMtVUs9wEx/
   CDbPLjVujDMaJ7NyPIW/myzyH09ctMPuZ6yOS6YNdcmR10UNTBYFEegLf
   9ZJXvNZefkeMtLcYfoewVh2tT3xh2+zxK+R2AF2funFcd7Hh70FPbWj+/
   cptcKbt48LI9b9VQJi2IbulllPGsZdFjFneUTBv5hdCWdMfNSqjleFZPX
   pnOALs+ELlwZsTgHgq1LXlpaa9guI2+q067JMcQbaIFgnVS8zY6RC3mzF
   Zkb8yN1E65Hv82EXlHL/rzTYABMM3kKnMvec3sBYUCtm0lNXmMj6nvgS+
   g==;
X-CSE-ConnectionGUID: /+bbzgEhR/mXjv1+qULofA==
X-CSE-MsgGUID: xZZ2gGYCQ7CGFTtlYTpK3w==
X-IronPort-AV: E=McAfee;i="6700,10204,11194"; a="13512654"
X-IronPort-AV: E=Sophos;i="6.10,226,1719903600"; 
   d="scan'208";a="13512654"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Sep 2024 07:53:11 -0700
X-CSE-ConnectionGUID: uAIoT/dRQ7OK++WbCMGpcA==
X-CSE-MsgGUID: dGTNmiyCS+OGo6OnqTMuAg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.10,226,1719903600"; 
   d="scan'208";a="73087132"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orviesa004.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 13 Sep 2024 07:53:11 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Fri, 13 Sep 2024 07:53:10 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Fri, 13 Sep 2024 07:53:10 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Fri, 13 Sep 2024 07:53:10 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.170)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Fri, 13 Sep 2024 07:53:08 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=XI9WXuaOvwez2zz+ZauqXVSoqdhfGldoH/lItzJXibE9u/WP6eRebfPgf0M3telH8GF3Hi4tieci8icQXthCgv+W+8jhbiTML9mRS5SXFbqblQ+yutRrjOiS15sfvboOZoUff787XxkXEOYbSAYgH27/0/Vc2WufJNuL2bFjBrgS/Qu82VwlNPGhEr+NWI/cfprcH899F/U39bzFMRYVR2d7hXo80T3wT6pd+d5fDvdHPI5elP3NQZvY9nKTKNt8rFQnoROeWsGw8Zib+HCehWsXuUot3GVAiIUHX6hqIBEN5UT7Jikf2CJewJbfR0oglCzEA10MOZAD3dTzP1zmAw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=70lyt34ezJ8jIMqlGQ0nCueZHA3BvAg+UckL/3RWIcw=;
 b=I1xt+eEAaM6GDoDHxcnTbRlAGDZ++JkB0Lnq0p+0dr6cg/OlnPZhj2Y5dubGCq56AjezZvrQoGsUE4no3wJDcSflFXGvjwZFbNaWnZklBmhGYNMbnz13ZYnx84AnaysI0watMWlCKdX4u6JCrH+Lz5Oh4NL1N+sRoP1VwCdcvrAaIXlV+tzySmbl0zpNCpB/UECOnTDKzep6fKY1dxrMs6VE4nDYg4VK9XVImYp83Tfya0sCpx34jJNWNE8FnSl6Gm7HOPpWfkfuW0FfsPj4vN5jx2eI5UMjF9kW+t7HCEbufQzOxsIrYZXdEva2QJtbbW6CNoFm3V6NKzrEPWXecA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CY5PR11MB6366.namprd11.prod.outlook.com (2603:10b6:930:3a::8)
 by LV2PR11MB6023.namprd11.prod.outlook.com (2603:10b6:408:17b::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7962.18; Fri, 13 Sep
 2024 14:53:00 +0000
Received: from CY5PR11MB6366.namprd11.prod.outlook.com
 ([fe80::6826:6928:9e6:d778]) by CY5PR11MB6366.namprd11.prod.outlook.com
 ([fe80::6826:6928:9e6:d778%3]) with mapi id 15.20.7962.018; Fri, 13 Sep 2024
 14:53:00 +0000
Date: Fri, 13 Sep 2024 15:52:52 +0100
From: "Cabiddu, Giovanni" <giovanni.cabiddu@intel.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
CC: Li Zetao <lizetao1@huawei.com>, <davem@davemloft.net>,
	<lucas.segarra.fernandez@intel.com>, <damian.muszynski@intel.com>,
	<qat-linux@intel.com>, <linux-crypto@vger.kernel.org>
Subject: Re: [PATCH -next] crypto: qat - remove redundant null pointer checks
 in adf_dbgfs_init()
Message-ID: <ZuRRxIjK8WMvStJ+@gcabiddu-mobl.ger.corp.intel.com>
References: <20240903144230.2005570-1-lizetao1@huawei.com>
 <ZuQRqP9CgDp7cuGi@gondor.apana.org.au>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <ZuQRqP9CgDp7cuGi@gondor.apana.org.au>
Organization: Intel Research and Development Ireland Ltd - Co. Reg. #308263 -
 Collinstown Industrial Park, Leixlip, County Kildare - Ireland
X-ClientProxiedBy: WA2P291CA0020.POLP291.PROD.OUTLOOK.COM
 (2603:10a6:1d0:1e::9) To CY5PR11MB6366.namprd11.prod.outlook.com
 (2603:10b6:930:3a::8)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY5PR11MB6366:EE_|LV2PR11MB6023:EE_
X-MS-Office365-Filtering-Correlation-Id: a972db17-8aaf-4f97-6b23-08dcd403c310
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?Qhlf6BWYahft9WxvtSpBEHpclR9e5EZCpIAE1X+SvJpwScRpwZwuZJ9y2oI+?=
 =?us-ascii?Q?zMJFsm0PEXCK8YatUXUThcfApKB1G+PpN2xczy5LM2YTUnS2TOkv+w8AAsx/?=
 =?us-ascii?Q?/jfIr0LsdlCS5yp3k6i8zqQIaHpd0vw1hJv+WIy8npl/bCEx9TGqrh9SOgCx?=
 =?us-ascii?Q?DlRnJ6xj+n0FDdNNBS9Bpt88rDfd5JiyXWVSofBF/KWfT8Rc32UQU0k50zX7?=
 =?us-ascii?Q?obJvFFtXLjBemI0FswM9QlJJ4Axv8r+fcqsNWnrrKGJan6FQjlhTpJryCSqh?=
 =?us-ascii?Q?HI7aPEmabY3iOMGrLPU3y+9vFzM6GGKd/28tZHoGUGEBKOPJFyQTEC3XeXj5?=
 =?us-ascii?Q?nOeyOKCSSqNaTQI9C1MHBavHFB7u/pc6oJ7yL5RSmlw3psvhU/wFyaiHS8hb?=
 =?us-ascii?Q?0c6hXLm2p2tTQ1bUKMCU7ybkhkZ5j6uHbtDPmBlbz/I4JOKHpzampHDaB5o7?=
 =?us-ascii?Q?7SniCspirHdl0T5zc1BakNNxq/aa3I2KekoxWQxwGk/VgiCSMJFJBP/0iAlW?=
 =?us-ascii?Q?bMLAhpEgRg3JnJPHWp4Sua8fGthnDEPvvSSDA1s+xdLfqgWhBDDaKnw0I9cB?=
 =?us-ascii?Q?BvCL0VFfRs9KPad122hU5CdY/iRu1myi9Tl49nvcMOFLgIQf0psEi3PtffLL?=
 =?us-ascii?Q?Z0XSuCHrIuPGWZ9N8ifMePHMDN/Pi1lxDFozfFvErv33+D21VnJiBMv7P7Uw?=
 =?us-ascii?Q?6h1SggryWxhTN+MhJ3E/elSqJdFI3O+OrZGfaAuPqBSn9FUHpn0C9xLxix5a?=
 =?us-ascii?Q?CPVVhUtCLAnR2PnMIlkn8XhCt5ai95cp13VRwDF0ITkCm/nqKyau1huWDtWv?=
 =?us-ascii?Q?g7DwGhdtDwmzHZ1PPM9tm8cPIO6RSqLOnRXi5WQRR/qBJakPpPqK/0A0gxEs?=
 =?us-ascii?Q?82RjF2l3l8J85hkl2hR1I8cbra4breALPfkyKXeFEYCQu7jEA1eoa4QVlcVk?=
 =?us-ascii?Q?LeWsen7uwAFKLhp6xY9oMmGNHD1rK2Lp3aeO1ad9Bp3CQxnyvR/52cg2RyK1?=
 =?us-ascii?Q?un7Cra0FI4lNZ/N0jso8GF5x6Uw0PwKONsHtpCuejdul3qiS5m/xr0InCGMq?=
 =?us-ascii?Q?3NrLTfsioSHALPQvjsVNjBHEdyR4I+WZguZDkfTto00kT03B2fsEBrCqvkik?=
 =?us-ascii?Q?siIcXYi49S9R/dyFSBcB7LDejKpVIg/v5z7hMHaIUp1o94tPd6VyYrDOHiMR?=
 =?us-ascii?Q?ipL/NUsZ4sO9eKoWjR4S9/J+8DPVusAtRKUwijGCqLgwSlWHJrsNH3/FnI6W?=
 =?us-ascii?Q?zueJliXoZ8TJqLHzMz9iVt6h13gH5x8VOByaetNaFxKc0S0WTtAEi6D53wt2?=
 =?us-ascii?Q?TuUPtNZV+xw4yWkYeRqnjS37V0jgcbL11pqJvmfh9YZAFA=3D=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR11MB6366.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?x1A43+5q3vbIzB7+qOinYmQI7XsBZLgIwm/IdSk0d4X8UGtqtUtdBBTgFpNz?=
 =?us-ascii?Q?0VU/113oHU9D6zy3NkGT9VrKLs/chBFJwubuk/89bt+P42OpN/Xk3trnWt/u?=
 =?us-ascii?Q?TPBbCHYLYvtx/9Ot0q3nD/SZc408gvUvcftzosIxqiiCj9wVrdfCXw/cvpt6?=
 =?us-ascii?Q?mUBQKLjgbA9A9NT6CtBfYT//aXMlgcfbkYg5oYx647/2y9uv/tPyObSGxid+?=
 =?us-ascii?Q?CgjhjvyQF1xIwd36/TYYz+l22Qoai+YT/FHc2uD4D4hNAk6bYl10l8CUfS0A?=
 =?us-ascii?Q?878j7GPHeB5uCx9dN9k+80IbIC3oJ58xPXSxMpeH6wInQSQ1CpJvdV5+tIZ7?=
 =?us-ascii?Q?PCn3jWmx4AR5TdqbU9pftIq1zK6YbUTSQ50du1p4NFFY+CxzCN9z120K2v1A?=
 =?us-ascii?Q?L+oYTP4BkfhD88mld/CPxhOmhODl+y9Lvv094VRTwpaLP9X36yERUX7k7Qek?=
 =?us-ascii?Q?r6l4ph+hNvhRLQ3pKzJhC0k8JaB9rt1XS+Z8kPdXSdk6Zm9VSOvJsnqdI+yl?=
 =?us-ascii?Q?VOGHTfM0skYnCmvFIJAVgN7cfLTGcdDf+MkxpPeQP0Msais/OkGYVvbJ7IZh?=
 =?us-ascii?Q?WFJuLliQnJ8bSdbq5fTNhZEDlIFrQqsoU0pf5IMtJ3/6Gf0dFyylT1+H8cxV?=
 =?us-ascii?Q?v0vAoliHFj8vnYMz/ga0LsetVj6XsJ+Ot8INEhJyG+dgm0ftulB4iZo+YVt6?=
 =?us-ascii?Q?ylPsLy0Av5xScOjwrCOCkofMQK8Tmqrj1c+s0CbI1aLMLGrWyiFlOB8v7+n1?=
 =?us-ascii?Q?l/dau+ch3vWIhrw73EBx4hR710vpyhlj2ZBCsdCytG+NL8mG8p/lg2MljxfH?=
 =?us-ascii?Q?tkpi2z0xBhanRuRRTD0IcNaBLqlcSdvE7Y1guE91d4cFLNIeP9TZOw7g/IVU?=
 =?us-ascii?Q?QCaAX2TUBW1gv/OhoKSbB4X3WYMvejsvNPpVWU8dwvroOEUVGQfsOKkfwhBu?=
 =?us-ascii?Q?cDazL48ltNTMNh3D+pj8fwOaiP0GFBdyGUyhKXfplBnUhBF3ifT1zKCZA4fW?=
 =?us-ascii?Q?4h2ellnVCD4pD0grGZG7uJj5wSVkq73NwLy95scAoSwzQaT2ai1ukid+fhuo?=
 =?us-ascii?Q?pgS7IhzrRsZ+cflCnPV79PVvfmtSjCIS2IOvrrsrhPXHUD8Hc2/d13w61Xek?=
 =?us-ascii?Q?jIu5VVo9i6rt/z2cr7Gclf/FyTi2/4wBnMKtLyllXOIEXya8oVdreQ+UvIcA?=
 =?us-ascii?Q?IILUQcRJeU/YeQZxmYpAuThvlIxSIve3KyqCI7adR2/QUxk7wzFcJ3ea+9+B?=
 =?us-ascii?Q?H57/eDaDterYgscz0Xv8R5I77NK9/0RZfCB+sq1YjZMBFDDbAAtwYql3/old?=
 =?us-ascii?Q?jKkUfwxN5hWbesKeTMfb2IEX7HLcqNbgciJ2sLie9CCyDeHl7Y09lbRrl+B7?=
 =?us-ascii?Q?FftrvNaVVyV0VmcLz9PfnTHlAgIlg7MjqQ7u1p600PvT/uqVnr9QmtV3h6wL?=
 =?us-ascii?Q?dVw+2ar20G3F3PdgB+gtJUvXaymdg3/GS4UARWW3rvbpGyJUINb+e4VyamIS?=
 =?us-ascii?Q?UX3ON6RyP2bTB9dpWhRZddpAPyu3dX5iXrzx+/W4StdnL8rcqy9dqL2tE1Cm?=
 =?us-ascii?Q?UIUWjQX8lNEh3b9FKAEvhRx87awzUSwmxUKbfvmhSZMKhFNnaDVZatLbphpa?=
 =?us-ascii?Q?sg=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: a972db17-8aaf-4f97-6b23-08dcd403c310
X-MS-Exchange-CrossTenant-AuthSource: CY5PR11MB6366.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Sep 2024 14:53:00.3569
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Ev2lTiR0IQUfvXVQA7eZQxVR8dKg3hvBIu3zuO30urae4F9HWGsKhO8IqXAYhQUziFz9G5sbLaUdunaWA1pV3IhqjPmSsti8GfNVzl9RekA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV2PR11MB6023
X-OriginatorOrg: intel.com

On Fri, Sep 13, 2024 at 06:19:20PM +0800, Herbert Xu wrote:
> On Tue, Sep 03, 2024 at 10:42:30PM +0800, Li Zetao wrote:
> > Since the debugfs_create_dir() never returns a null pointer, checking
> > the return value for a null pointer is redundant, and using IS_ERR is
> > safe enough.
> > 
> > Signed-off-by: Li Zetao <lizetao1@huawei.com>
> > ---
> >  drivers/crypto/intel/qat/qat_common/adf_dbgfs.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/drivers/crypto/intel/qat/qat_common/adf_dbgfs.c b/drivers/crypto/intel/qat/qat_common/adf_dbgfs.c
> > index c42f5c25aabd..ec2c712b9006 100644
> > --- a/drivers/crypto/intel/qat/qat_common/adf_dbgfs.c
> > +++ b/drivers/crypto/intel/qat/qat_common/adf_dbgfs.c
> > @@ -30,7 +30,7 @@ void adf_dbgfs_init(struct adf_accel_dev *accel_dev)
> >  		 pci_name(accel_dev->accel_pci_dev.pci_dev));
> >  
> >  	ret = debugfs_create_dir(name, NULL);
> > -	if (IS_ERR_OR_NULL(ret))
> > +	if (IS_ERR(ret))
> >  		return;
> 
> There is no point in creating patches like this.  It doesn't
> make the code better at all.  IS_ERR_OR_NULL usually compiles
> to a single branch just like IS_ERR.
> 
> However, I have to say that this code is actually buggy.  Surely
> this function should be passing the error back up so that it does
> not try to create anything under the non-existant dbgfs directory?
As I understand it, there is no need to check the return value of
debugfs_create_*() functions. See f0fcf9ade46a ("crypto: qat - no need to check
return value of debugfs_create functions"), where all checks after the
debugfs_create_*() were removed.

In this particular case, the check is present only to avoid attempting to
create attributes if the directory is missing, since we know such an
attempt will fail.


Regards,

-- 
Giovanni
