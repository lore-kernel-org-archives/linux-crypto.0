Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8D632253FC;
	Thu, 16 Apr 2026 17:07:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.19
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776359230; cv=fail; b=nuDQAGT9WgQqnvtBWZ4MPmgd2IpgbA+VQ8VpZPl7huCaaIHwqlBzCQmjjihSMxydwFx2iGDk4XsLUM2cppD8paddfs7opic2szOlP7p9iI9Sm0tnAqqUqsoPom5WcplOMxwZmuqx+ZhurvqIfbhG3lcfkbVdqQKoIyHOrVy5UUU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776359230; c=relaxed/simple;
	bh=RN2GL+djwltJAerHCqbR3SR5TJG3EeJUHV/AmdqRY5w=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=Zpai6v9vLYQWahckfEdeIBJE9JbbziecW8qPihJqIYSUaINt3dTHhq1ELNHSCf/M2ePVal3jnR+Arw7n6Bm9vjPV+FGma2RXT4oyf2JZo93e5Ywf8WcLj/WsF5dnWKJgL+N1DOwuPFgJIMHdoHRZVe1OlXxkkysFStOt62WoaAU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=FInck9Qp; arc=fail smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="FInck9Qp"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1776359229; x=1807895229;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=RN2GL+djwltJAerHCqbR3SR5TJG3EeJUHV/AmdqRY5w=;
  b=FInck9QpC+VzzgYeovnz/DaEWfJ/Va3CQ/+Vl/T5J6H08TOpjun4zVU5
   H2BWCmUTl6TCrYh8/uW6/xGLCvQblJScy7Xgoh8QNAr7o9+aop7NwC8HY
   J+uA0Of9K/RhxIWJrpflMCblxWIGIt0rQHOXfeQVhdOxY1Z9BGzbAZyka
   A2GZ2X4yBx/op61clQk+zEDWk6fuVuudweWfGgOeawv7ZPW3ULFPVEBFw
   ALb/fpCSMgqUjIYLE2C9PrVfNySsbFD8PEJCJ0pY3+8O/bQT+icHLr6zA
   9MXp2aLZo7vf1QUKAhvmB5zd1u6A6zP0poGV1/JH+xCpATxYP0lrrtjhi
   g==;
X-CSE-ConnectionGUID: um1bPHT0R8SZjlPr7E+1xg==
X-CSE-MsgGUID: pHFoC5MoS4yIIl8vbNd+uA==
X-IronPort-AV: E=McAfee;i="6800,10657,11761"; a="77275414"
X-IronPort-AV: E=Sophos;i="6.23,181,1770624000"; 
   d="scan'208";a="77275414"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Apr 2026 10:07:08 -0700
X-CSE-ConnectionGUID: 4Wz/xnD1RqK3hAhRnl7ejQ==
X-CSE-MsgGUID: JQyejZMnQ2KU53uYVunUeQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,181,1770624000"; 
   d="scan'208";a="230654989"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by orviesa009.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Apr 2026 10:07:08 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Thu, 16 Apr 2026 10:07:07 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37 via Frontend Transport; Thu, 16 Apr 2026 10:07:07 -0700
Received: from SN4PR2101CU001.outbound.protection.outlook.com (40.93.195.71)
 by edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Thu, 16 Apr 2026 10:07:07 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=HSztEeqv8cXEoyTmzeAzJUc/QRNyKvsCWfAR/2pAkh0IN5tcWqqTZyB3aJSQ5YsCVIuKOk/KHvJYtr0WQQUiyDLLEDqlgagEHs9mioDc1qH6Tc98KS6mK0DG1hawYCjAf49EWbGs0TrRYWIVMw7eJ6m2vSRnNSYO5teG/CLxwvxSOfnAvDto8+Zq85f83EDcSv3RAAhVL6KxyLS/eOHGzePiZLgyVI8pjk4qXwFQxXdXzODwjg14pDRgW/lJW7D+VYDlpqMTeDPkvUUAvA+XfqpUUk4cg9xNiPNHlmAZ1IpzjFJ3m9T+5XNRV4FGRfQUkHmKI5hY4POoTeqCse7/yg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pkJxdFoWdr9K0NtVBPrmDdNq0SKC4gmYCTtqMU/aDzA=;
 b=jPuWdgWzvVQ8eaBfMUIRZat86ZGoK4sMUJVcOAnvzbs3V3vl1ENP5+yFMgQOA3iJGiGrlDFm3CiXee/44PVXbaHbvpQ04f+8RP9VJmNCAic3mr0wnVTwm3Lz+0j8i8zajmtNXWwh3bOBCiAmQFyxVPXzjjCqw93QqTl/qoGciKrGL4jj9AxCVNOyhn5CQ+rpief5w1iyMI/CvHp4GzCb1aqPcdWWPnSx21dlvpJ+/CZFo/Agyw1mSHyPJgvNd8QOnJ6D/3RnsU22Q3mgBfmfgclcGfvE4HfBVM3/DfSWad5unxyLlP8c4eACxbQyU/1B7VtG7GkXXdGRLRCpJGNDRA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM4PR11MB6407.namprd11.prod.outlook.com (2603:10b6:8:b4::11) by
 SJ2PR11MB8472.namprd11.prod.outlook.com (2603:10b6:a03:574::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9818.20; Thu, 16 Apr
 2026 17:07:05 +0000
Received: from DM4PR11MB6407.namprd11.prod.outlook.com
 ([fe80::26bd:1704:645f:7fd4]) by DM4PR11MB6407.namprd11.prod.outlook.com
 ([fe80::26bd:1704:645f:7fd4%6]) with mapi id 15.20.9818.017; Thu, 16 Apr 2026
 17:07:05 +0000
Date: Thu, 16 Apr 2026 18:07:00 +0100
From: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
CC: <linux-crypto@vger.kernel.org>, <qat-linux@intel.com>, Laurent M Coquerel
	<laurent.m.coquerel@intel.com>, Wojciech Drewek
	<wojciech.drewek@linux.intel.com>, Andy Shevchenko
	<andriy.shevchenko@intel.com>, <stable@vger.kernel.org>
Subject: [PATCH] crypto: acomp - fix wrong pointer stored by acomp_save_req()
Message-ID: <aeEXNL2CH8njXY0Q@gcabiddu-mobl.ger.corp.intel.com>
References: <20260324180721.120175-1-giovanni.cabiddu@intel.com>
 <ac8NYE0XsniCvNSk@gondor.apana.org.au>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <ac8NYE0XsniCvNSk@gondor.apana.org.au>
Organization: Intel Research and Development Ireland Ltd - Co. Reg. #308263 -
 Collinstown Industrial Park, Leixlip, County Kildare - Ireland
X-ClientProxiedBy: DUZPR01CA0112.eurprd01.prod.exchangelabs.com
 (2603:10a6:10:4bb::11) To DM4PR11MB6407.namprd11.prod.outlook.com
 (2603:10b6:8:b4::11)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR11MB6407:EE_|SJ2PR11MB8472:EE_
X-MS-Office365-Filtering-Correlation-Id: b01bb90a-110a-4a65-361d-08de9bda95a2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014|18002099003|56012099003|22082099003;
X-Microsoft-Antispam-Message-Info: cQTieSelsRLw6KmA+rD6b5hC6WXZhLteW2q1jyXNkJljWiXNYqyzU0Kpq96cCM1/2/hADRr+VIr+oc0HjtmdzyjVEmkYll9UkTNYjJa/LuzUB+Z4zCvDvJvucoy809RAMLDBkhZJMaZU4OEA1AEZgCCrQ9vvu3Okh8EahJmyl5cJqsGkNVGWt9g5gG8W8ai0NloFmuLelER08WKsxKGmMgsgu0XRAiyyjUumeTPJ6kiQoUSdK6Xmkuib+/PhiiU4Gp+wbU5R+li/6MVMNGdc8dlOWnLE6WS9zBfs6m/O95QqXp7K+ZG2f4+lwwnOpNeQkWiEiSa3Hb3qciGsjCz8d/fIo8CBC4hja0mJZ3F9sXIPa5JpstN/GOBGHWGJ8KBkrV0wRQQ+zJ94KtGW65lM0ZpT3cORVu0Tzbww5dobapSCiMbIcRZvTepy9XB2e1b7kakBhKK10VALg2CDVnV480vu5yjqH/o3xnn6gClJN7SRNsSmLGXTVjLzIYCo+b6y0AOBwdNNJGO46fJh5iw5FS6yvvj9rVWk1cUXkgOWVJMMHNw5aPGrXwZ9/dNhz/s7cdNacpN6tvC2hoagyz+9h+tUEZPhj03nGgj4/zwqtI9H5gcwYft2lroqU1CMBn0BDOuby2p85x9Us7K2Uu+RWls6xISy8MhETTXYLwT4ZKhW+ZtTpsUMIwf5UGLTXy5AP6JOhQSCI0Lq/zNciqPpRJ3uC2f/S3gp8MdUUzzXcAo=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB6407.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(18002099003)(56012099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Ji4ml4QVfUy/jbB8utS9MBxhrbD/E4s5ryLTF7lNdYVVR5Uk9HoebTH0ikJo?=
 =?us-ascii?Q?jIv0hgsOpEuT17CCUp9dG79E1+8M6HpRf32OU8l7MHHvgRGJqUi2MbS75xQn?=
 =?us-ascii?Q?gDrZYCruzsGhSiEb1VpesPl8uzq1FskH5WNdPjp7umctf1UwzTW6ma3qIT/1?=
 =?us-ascii?Q?+8ViLAfjMwQHCk4vrGsSIMiaVUBTVlZN5EQUAgu+6WTMfDoWhIWbkGw1jH/4?=
 =?us-ascii?Q?MYSaJOv8ptAxsG6dqLKyJOVcNrgg1tqna+3VbdUIvfWjpTlotBt5H/7AUHbA?=
 =?us-ascii?Q?yWBtCY2Hga4/ssS6LhEfG2vg+l3DtHoZc05a2LNqjlF+FbhUxPOez1R4p2AB?=
 =?us-ascii?Q?xmaAfYUm7m3yAF6xie6rMG5JQe8BB7kpqlNNXp+N6Sahtp6dbYdEnXiuOcn+?=
 =?us-ascii?Q?OPn6Bv7/nvnFHxXZFg0lHYlqUIoinjRX1HOnzoNLZg5r1O9BJJIJFHmDwX6l?=
 =?us-ascii?Q?TuxZCpCH9EngLDyY7WtvhXQ/0dPHMcfe2XgdsvPtrgCAd191NFXo4xxA5YMQ?=
 =?us-ascii?Q?39cqksKHy+oyqfxNWR2vi/Na0TCqRaCBDNMYMC00PMEsWNLiTiROxK1cgHjb?=
 =?us-ascii?Q?BdRlqaJiQRzsU4pMCZ78RFp3oMYfK4dq6LJMyJVVqXPLVRxIMnS4i9yAE4Dk?=
 =?us-ascii?Q?sZQ1vH4C9oJarRnb8Z5IR8h7lTfWrM/2plHDnRLr2dG9sukDPVUNzkMSGPi4?=
 =?us-ascii?Q?jO87555SWCK73I9qoz4Ww/JtK1rLUhzQiuQ4br2ge3ZYTdmjh/vFEXQgeUZv?=
 =?us-ascii?Q?NVQ3v3QuTfehGXTkrFAMYysK8+9ut/eTeRbY0oyjw69hVm5FiK91dvQni75w?=
 =?us-ascii?Q?SIUgm7Y5DSleUzZ0tL1Jrm+klzohqSX7G/XlG39MS4gFVhFy04ZuQMta8KrB?=
 =?us-ascii?Q?clFh9XM0MjPOrTOgPcirxYLDnPb6MsnZNo3G4epnOzcMzSZoovwKgZhBv/KG?=
 =?us-ascii?Q?IcdanWgpdd24oWb/MABzbmT7dTJpb8ygsqsALHhZPFY2fLVKsxV/q3j0Wozx?=
 =?us-ascii?Q?49N6lRoMJLbt6Zszy6ghd/gdnDUZkr6suhfEqONbiSSf4ThO8jM/fI/z/PiI?=
 =?us-ascii?Q?PyXeV49s7jfKpCUnLzOsnGMmaGaN3Vmy07UFzSanhBjzDKkO8QyVlN7M1Or/?=
 =?us-ascii?Q?WmNXjBPAuVCTKOUPyGMPNaecNT3gpfJcHGRHuZtFKLHlEv1dQoI5v8PfQbjq?=
 =?us-ascii?Q?r+YBwwLqMUTMpiW43JJZYqTXYjylKJN5uzSyvmVgusULIpUlcW0xCKMhGkku?=
 =?us-ascii?Q?a/6ur3EguYM5KaroKlBGhI6E6tp2uOMj9YHF9uAr6mAVeMILMPvVaDSJEj4q?=
 =?us-ascii?Q?0gpqA4tXx3tMOttPPnhTtEqL69FQKRBQrZCuQNSuqaHVjpJk5tVXb3z8EBGh?=
 =?us-ascii?Q?wwEONdURR8Z2f+QP89gAKuJDGP1pJrpmyFRNfQ8+ZTxOrJ6rVDf1OZUOwe6K?=
 =?us-ascii?Q?sQad2iUnwZauZ63ggNFWe6DfSdqOiKX8xed4SgDtQOH2xyqkpGjQ8TyJdQal?=
 =?us-ascii?Q?3JGleSdY2QBnkSk7JDLYUQU9r8A4yLwSjHBWerNbJkO8Bi6US3ilMwBB0b/N?=
 =?us-ascii?Q?jATK2SiUOo3D5XLw16vVZQjU4gBHb3vsgvUuVdi6gi+EK/uWWg5rz+XTiFZI?=
 =?us-ascii?Q?HkNHr26RyqRwBy5qbksVbk7wTafzkzBkf6rjiIF5wHN9ySzVKr/Nz+KlPFAK?=
 =?us-ascii?Q?dzEot0/4/h24txzuhuMGjaeeykJtg7zB4GfLLXJ4dZ+AcEUR79WjnVWh/KBu?=
 =?us-ascii?Q?+cnpqlH2vdfkum9OMxKr91GlLXPwaRU=3D?=
X-Exchange-RoutingPolicyChecked: aNs49qFRGXMxGkT9qSkwAjmISexoYsaTmlCqZMoKAbVNfgzH4/5AJmo6a76ByFu7lBvqZPq1Q7JoFnAilvyyoMVJKxoEGrcbkPf8manIu0m0OvEcWObaUGGjBn+OVxpRybnyGqzPl7uARhaRW8wTIlm5TUmtYPuLZUmbJshnkjVI+RAYr6VaUscLQSLWChjHj9hQYPwION6Ee/r4dvC0+m4oZrHHCuWVybf/WJ3I0J+teJr9ikvyO2Ruq9UpjxMMOCjVcGIFP7vnxz+B01mN4gCOiy5pUIO4yEgVNRcnUm2xV174ZMw8U+DKqpXJsb7sN+no+nNxgQFvnt0OhYPcMg==
X-MS-Exchange-CrossTenant-Network-Message-Id: b01bb90a-110a-4a65-361d-08de9bda95a2
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB6407.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Apr 2026 17:07:05.0176
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: yUusUOz2p0DdEwv9fqkXEzSMSSJSZFdU4s+dw6KsT88byBmn3+dr/ZzvesJMikZ0WEHH6k+BLrtPBky0dYv+5KcpWHYrLwWKwA2fZEXPeqk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR11MB8472
X-OriginatorOrg: intel.com

On Fri, Apr 03, 2026 at 08:44:16AM +0800, Herbert Xu wrote:
> On Tue, Mar 24, 2026 at 06:07:09PM +0000, Giovanni Cabiddu wrote:
> >
> > @@ -251,7 +252,7 @@ static int acomp_reqchain_finish(struct acomp_req *req, int err)
> >  
> >  static void acomp_reqchain_done(void *data, int err)
> >  {
> > -	struct acomp_req *req = data;
> > +	struct acomp_req *req = container_of(data, struct acomp_req, chain);
> 
> How about just passing the request in as data?
Sure! Here is an alternative implementation. Since this is a rewrite, I
decided not to label it as v2.

---8<---
acomp_save_req() stores &req->chain in req->base.data. When
acomp_reqchain_done() is invoked on asynchronous completion, it receives
&req->chain as the data argument but casts it directly to struct
acomp_req. Since data points to the chain member, all subsequent field
accesses are at a wrong offset, resulting in memory corruption.

The issue occurs when an asynchronous hardware implementation, such as
the QAT driver, completes a request that uses the DMA virtual address
interface (e.g. acomp_request_set_src_dma()). This combination causes
crypto_acomp_compress() to enter the acomp_do_req_chain() path, which
sets acomp_reqchain_done() as the completion callback via
acomp_save_req().

With KASAN enabled, this manifests as a general protection fault in
acomp_reqchain_done():

  general protection fault, probably for non-canonical address 0xe000040000000000
  KASAN: probably user-memory-access in range [0x0000400000000000-0x0000400000000007]
  RIP: 0010:acomp_reqchain_done+0x15b/0x4e0
  Call Trace:
   <IRQ>
   qat_comp_alg_callback+0x5d/0xa0 [intel_qat]
   adf_ring_response_handler+0x376/0x8b0 [intel_qat]
   adf_response_handler+0x60/0x170 [intel_qat]
   tasklet_action_common+0x223/0x820
   handle_softirqs+0x1ab/0x640
   </IRQ>

Fix this by storing the request itself in req->base.data instead of
&req->chain, so that acomp_reqchain_done() receives the correct pointer.
Simplify acomp_restore_req() accordingly to access req->chain directly.

Fixes: 64929fe8c0a4 ("crypto: acomp - Remove request chaining")
Cc: stable@vger.kernel.org
Signed-off-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
---
 crypto/acompress.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/crypto/acompress.c b/crypto/acompress.c
index 1f9cb04b447f..6025c1acce49 100644
--- a/crypto/acompress.c
+++ b/crypto/acompress.c
@@ -169,15 +169,13 @@ static void acomp_save_req(struct acomp_req *req, crypto_completion_t cplt)
 	state->compl = req->base.complete;
 	state->data = req->base.data;
 	req->base.complete = cplt;
-	req->base.data = state;
+	req->base.data = req;
 }
 
 static void acomp_restore_req(struct acomp_req *req)
 {
-	struct acomp_req_chain *state = req->base.data;
-
-	req->base.complete = state->compl;
-	req->base.data = state->data;
+	req->base.complete = req->chain.compl;
+	req->base.data = req->chain.data;
 }
 
 static void acomp_reqchain_virt(struct acomp_req *req)
-- 
2.53.0
