Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09CA2199939
	for <linux-crypto@vger.kernel.org>; Wed,  7 May 2025 13:17:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746623829; cv=fail; b=WBwNymzxbeGHo05dZXnNTecO4FYbEyd2rSiGXL0CC2pi1nDijOpfG1zHK2bgewJ80Lkndo43FyxOF2OmspwlsbmGI/052+dVGALq4MCJnVmzhLnMGSFho3HqKs3Gbm4p5XnxHv8RzG+pCZSYrCNj76S0mi/4rzkQfARP2PerMNQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746623829; c=relaxed/simple;
	bh=ziPt5tfSLolbxnZolKeoWwju0dynHCoML+monKgqv18=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=jOs1UsXsQOr5+K0P4hOPCaUlqgHlVat6Fx24kTEK5tKQcdiW+FaDbaP3SH0R7Tlt+XAwRYMAhpEdng99XN5/cu+v09RuOetsr/Uevq+9HdRb0DEaePPgksqz10dDnTSE7EalYiSbA4mVGVsTnG0RdA/Imz+p3YO3Quk8bs6fGl0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=XZ3gDmOd; arc=fail smtp.client-ip=192.198.163.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="XZ3gDmOd"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1746623828; x=1778159828;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=ziPt5tfSLolbxnZolKeoWwju0dynHCoML+monKgqv18=;
  b=XZ3gDmOdyrkBkI97w8Sgz1vnJoLdtteWk7DzQsLaNIsdJFNiV8SF2m5Y
   E9flM5bh9dKooZ1RNhwVEh5XNVz7g3YKHYyHhYHfaxfx8Es9cSBWEYJ/K
   J4gi5cMnT8CflDtSGaEYRZnWc0b6f/4o6i1cm4CT9usJQcRneT2wUCIjF
   +7h9e5C+VuyMLslZWugSZ/o+GM/HJoVnPGgmiAXCb4IQZAiVUyEo6IFuR
   /a3zT04AbmywVUSjKoaY0/duF8Ac/2b65Zy3k1nGD7tvZ12jKFvHDm8yL
   vDq4cPemt+DceD+QE8B/c27gVfOBq2h5zmYmh24CBI84do35f5vb82KY6
   g==;
X-CSE-ConnectionGUID: HQK5fihnRAaqvi2hJ3jiJQ==
X-CSE-MsgGUID: A70tUKdKTtOtAX67FgAMgw==
X-IronPort-AV: E=McAfee;i="6700,10204,11426"; a="48489032"
X-IronPort-AV: E=Sophos;i="6.15,269,1739865600"; 
   d="scan'208";a="48489032"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 May 2025 06:17:07 -0700
X-CSE-ConnectionGUID: HrPrLAiZS5yrZnWr56WMkw==
X-CSE-MsgGUID: WEuF7DOsSPmudAMpsNuUsA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,269,1739865600"; 
   d="scan'208";a="136881112"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by orviesa008.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 May 2025 06:17:08 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Wed, 7 May 2025 06:17:06 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14 via Frontend Transport; Wed, 7 May 2025 06:17:06 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.46) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Wed, 7 May 2025 06:17:06 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=LAio5hP3vkZxntQwmCPsU7QA/3/wgY6kDEGFf862RcQj9DEBevoTRjIwOx44Oh5+hsaWmllIkbxtiv0VqXDm4tyqJ3w0jjW+YvQxTcDuf3bEazhH83C3zPwonkp/+TNyWtQ1bjI1zjYLTjm8Vb9T+HqbNBDeqh2wJIuTQh/5NMBGXnNJxCS2eh/RAiV7C9lIqU9XVN60M3PBehV/lN5gv+gxmy9Wx9ySHnOAoMSOhQk15FwPo/efpuWrozohG5atAl5HDPWqMHEkHVNpvA74IZ7UCznRzdnqCZFoz764hwMNJxiJW0oxg/VT0NP4NMaFH+nXlKOlRFgqO+/4D/rPhg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uCvfoSBRDu2rikMAPg8RcPq20MTVn/t3lgLNfjfN6ro=;
 b=xvHnTneERBr33Z9n357pqE2+g7AuW649RDh5BZDgu0fXo0+wHH4v0wfjHHA0wXLghkv2tanpw4a3J5+z5lP58rCEt571usdsi+AIQv1EAUB8ogGu8YgUgAUIq0rvKIo0Gw8V+6MQGwSxfFrUgavHqsjUfoIWvUM8JM74V1+ohJdHPxzPzL0RCrAVLlctSR25hdq2SAZbs9KQY96GIpkV/+6zUZH9WR0mACXO2N1yHDKBG9o+C5mCI1o/3pxbBfDQzRJik1vJobYj9D1RUZt7opH572NnUDurtDeUsFQwGPJfq7rhxr+VlVCRvN/Jx/DFvI5GNRamGuZ9Kry7w7vfrw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CY5PR11MB6366.namprd11.prod.outlook.com (2603:10b6:930:3a::8)
 by SA2PR11MB4908.namprd11.prod.outlook.com (2603:10b6:806:112::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8722.21; Wed, 7 May
 2025 13:16:46 +0000
Received: from CY5PR11MB6366.namprd11.prod.outlook.com
 ([fe80::6826:6928:9e6:d778]) by CY5PR11MB6366.namprd11.prod.outlook.com
 ([fe80::6826:6928:9e6:d778%5]) with mapi id 15.20.8678.028; Wed, 7 May 2025
 13:16:46 +0000
Date: Wed, 7 May 2025 14:16:41 +0100
From: "Cabiddu, Giovanni" <giovanni.cabiddu@intel.com>
To: Herbert Xu <herbert@gondor.apana.org.au>, Sergey Senozhatsky
	<senozhatsky@chromium.org>
CC: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Subject: Re: [PATCH 2/3] crypto: acomp - Add setparam interface
Message-ID: <aBtdOevCMsIDwSmv@gcabiddu-mobl.ger.corp.intel.com>
References: <cover.1716202860.git.herbert@gondor.apana.org.au>
 <74c13ddb46cb0a779f93542f96b7cdb1a20db3d4.1716202860.git.herbert@gondor.apana.org.au>
 <aBoyV37Biar4zHkW@gcabiddu-mobl.ger.corp.intel.com>
 <aBrDihaynGkKIFj8@gondor.apana.org.au>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <aBrDihaynGkKIFj8@gondor.apana.org.au>
Organization: Intel Research and Development Ireland Ltd - Co. Reg. #308263 -
 Collinstown Industrial Park, Leixlip, County Kildare - Ireland
X-ClientProxiedBy: DU2PR04CA0082.eurprd04.prod.outlook.com
 (2603:10a6:10:232::27) To CY5PR11MB6366.namprd11.prod.outlook.com
 (2603:10b6:930:3a::8)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY5PR11MB6366:EE_|SA2PR11MB4908:EE_
X-MS-Office365-Filtering-Correlation-Id: 65b0f62c-81e2-4086-7410-08dd8d696ad6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?mw7JBOuOTEcPLM7GdmcF5RzcD+/gnOMQQHtxO6qMAH0xbYkVO+juaV3Ppp9O?=
 =?us-ascii?Q?vcERkseQtqc0dU2bvgxka1UUbocEBMuStmfvm2q+hgWQQab96K8ZwcCOhwmK?=
 =?us-ascii?Q?RplYcXbmsrUcI24lGobiri3/pHlLX6ypGyUQWWNtxh3fOWcvDryzONozxI5G?=
 =?us-ascii?Q?Lun0s4/FpbaTWdzrBdqJFt7f6xWiB5E3qY7JmKMA6olbiNJpktMrJKbDEO7y?=
 =?us-ascii?Q?IIXj/PH6bxwHZV0OhFQnkBrvtWXkPpIq3aTxg/Q8lf4mdOQJZqVe1VMGyZ3W?=
 =?us-ascii?Q?HADpqSJdkUKtyc4fscwp81ISLzQSB0gBUR66w1q3l6FJqzJWN1rvWhixEZbw?=
 =?us-ascii?Q?654KX68CkYA/Cfq+bYyVYPpkmaqqB4CNxqAFdBfzSauZrsqCocK73JlJ3pFy?=
 =?us-ascii?Q?EIQ2LAO6Mx+PLkZDS8emHMQbhJM7hQIXDIo8tsm5qIg+ukro+c3C9ljX4QUW?=
 =?us-ascii?Q?9tnitGql59YVyGZ2kmX3Ctc/nJ09cTqALeedsac0bvg4WwZSBSSFtFoBNzMb?=
 =?us-ascii?Q?4uRDQumk7MjFR5pnWOPdzVHsYr9y/Bdf5QPe2mGN0vZJoYjUS+RYjaFdt7Cc?=
 =?us-ascii?Q?JUbsiXE2Pcyb8M6nC/NKo8MRObZZHYO8HZpG0qjL2X894MeXd57hfirq04Oq?=
 =?us-ascii?Q?bcXpuG6pi9NAT54tBBevWrwl3MN3qzdpXUnzhtqDfCSb/xy9clWJ4h1x1YUd?=
 =?us-ascii?Q?jWaDCqNS69h3CdVODUXHx/rHqNUCugwtZhzW4KFsPj8p4bIfL/zs9kDwxGmA?=
 =?us-ascii?Q?Meh6wqYE4aqIvBhJ1YWAy3gS9vqI2fR+gTy42U+IwOOtv/JwpzoVQeMaCtHV?=
 =?us-ascii?Q?Mfc594d43hoctRa7RlsFZbj5m7RNktlKigE714dXiB1PHDV9bVVqGR5qWwjj?=
 =?us-ascii?Q?SuCNqvXHJOkVkd/13d11ORkhc4pxpqIAnPgM7ugIvN9l6q9xSdc0g5Cl1Ldg?=
 =?us-ascii?Q?nqggfrusY3JEAaymJ9v7miI3GteSe2Y9Qg5uOlMpC1UMlN7QPQAjdqa7joil?=
 =?us-ascii?Q?hfmAAjzKUeDAVCx5fnTW/9CcMrAf6tF5ez2KHC4Z0Atb5g9m5Kbsk/BfqiSq?=
 =?us-ascii?Q?Xjsf8ZeTfZdo1EJ8yGLpNmoSSCUOjcrpDLGik9CYGUELDqJ0G5lCzseM9IE0?=
 =?us-ascii?Q?6ip7WAx+5KfZmmYBVCvfYwAuqTZKN+GZ6echPCNJrfl2788/F7XMUojrf8xU?=
 =?us-ascii?Q?wCF0ES2MXlLbJqy4fH5HhZB4sRTuVd3ORw5K7XLVPcpL1kbnonwBqs74Wtn4?=
 =?us-ascii?Q?PFAoP8QRHddElisa16X7STUlxoc6KkW/apl3AzxqNnek72C0DjxB6I6we60C?=
 =?us-ascii?Q?L3i5/UD0A9vANaBE2yR0Q1xqcJXPpxW0AGunnIYOkBQTjShGduAyiPQlpPow?=
 =?us-ascii?Q?BeH0mQS95F5j//5mrpOIvq3bwLcbHnHrOiXkOC/YWmVylkiqyES4rFTQ+7H7?=
 =?us-ascii?Q?snw2QhSBQGI=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR11MB6366.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?EaVlbl9ePjo9pl+ktqu0sqiRWfWM+2fgLiyUFMs0klWgrxAlOBFFgQsQM4Ue?=
 =?us-ascii?Q?Ua0l9KWf8yvT0+5c5bRjB4+XceSa7LxGU8wLhVoEECMhhZmM3OBnmaBXbz4D?=
 =?us-ascii?Q?SRZKMbnmTC3i811pvhg1ZukLXwg8iY9E+aCeJCDjPHcoUTXSbndZ4EZWqxh9?=
 =?us-ascii?Q?NE24bSdJcJMMOMN3DMMKTQSHd/Rw04upDkGvEddMM54tAot6NW2kH7PAxcrM?=
 =?us-ascii?Q?Uvn57to7WTBiLSLZYQvF3p3N2uojhDm0/lw+wdrTHk5KKRYVP2KXj5mKNJB3?=
 =?us-ascii?Q?DiAOyw9uE0TqC7eE1hbjNmX6GYn2lSyine5GKxWFcQko4tCUHqzu2wRuG5OF?=
 =?us-ascii?Q?CEzQ1uszqQ6sBA30zt0h0xiha8A8FCnFIsxzDlWYKKtKQWbwg4jbzqzEOMUr?=
 =?us-ascii?Q?BpY6MQ8NmgFj5Impx/3iCoEdP3Xf4uKsVQzvzwC9Dsz7KosOqn1eTjsYUslt?=
 =?us-ascii?Q?Bod/uPP0UdVnEq+B8Gu5BWqk7G5jlovdnVriwSz72FkP5s9p2gc5qIeiZ2fC?=
 =?us-ascii?Q?9PAVWKUySBWKLI+g5XBh1TNGrOPy85Ywg1+LaMANF5AG9yuSKRsi33QtlU7h?=
 =?us-ascii?Q?nRNHur5OJPHy/oFWeQyK0K9Lp3fpYgXk0WVTkZVQvs8oOdOr7gHqENduPe7X?=
 =?us-ascii?Q?xDi9UjIxxbS9Kh/fGMkOsRtfzbAxjKuDdJsfOxHlwR2SJoeal4y5LHKVAYRE?=
 =?us-ascii?Q?E89MlFllXpjQhfz6uKR0llsVUEl9Ut5sXLxr7yD2FkdVuk89TBcUFbHJ7oPn?=
 =?us-ascii?Q?W+iDE215lTNOf5R7IXZCrEKRBSVryqfCUvWXq8j6QGIWeXmwariQl7Moe4b0?=
 =?us-ascii?Q?lRJ6UhtOjGF9grlPBbSDIYtQrWlRfDqIlRoTnh0IQv73lqt29FFhdz25PnXL?=
 =?us-ascii?Q?a7zByn/0+rYSjt/HGJwNIkMEmTgD7QJwhD+1rwOMGDtGMYYgRGMUmgV0aaei?=
 =?us-ascii?Q?cHXFF30mzWs3D9helnh5Xy9+AN3VkENNDJJZefdJR7HW3qp+VL6YrbzOfe+l?=
 =?us-ascii?Q?zjIUagt+bUgZEQwmJcYa1Ah78hfbEqrsltQaBT2vwWRLb6LuFtevhPmXHenS?=
 =?us-ascii?Q?3Pfbtb7oppM0UX6C29PdnUNdLOOcR4EwE4bZzMbRuycHCTEBXrKiAysWrme+?=
 =?us-ascii?Q?wTUXTnXcerjWYvuSQZS7kDu5JWlzm/ONJSEYCPlt6BuQRJ1Jyg2X+COsegjO?=
 =?us-ascii?Q?N7pw61zSAuurh+/tQD7pKtLLL/HcdKnk6vDmxhDS4YIvcXPrhBikUJBemUl9?=
 =?us-ascii?Q?4PStCkUtgVGGYHwb7mjBfu4y8MjK8RSuE13WnohGTEBIu9+p2YmSjmcQvzFk?=
 =?us-ascii?Q?2q0wfejCuSQzwydLPA31JN5dP5GEkaej3BUcJyAiifXAxN7SE0At21YAPW28?=
 =?us-ascii?Q?/EGMZLNlr7NdMV7bANxsBnX1vxo/l0jpK1aNO19vd4TDEbTPd//ANyLf2sBw?=
 =?us-ascii?Q?K3EeVOzX5duYS2plJrfsK1TBNYPAK30nwJwtMWKsHcTsGFkP3wTTroBHkdze?=
 =?us-ascii?Q?unY2mlZ3sw7PdHvZoFlo2P8xhYhofsgwxq+TUZVitYmc8nBpWwdn9907xXQx?=
 =?us-ascii?Q?AxYO1uJiO5CX4b82jnfciDJqVsEfnqOH/g8dBUAys3yKxkxuJ8WozT3B7llQ?=
 =?us-ascii?Q?kA=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 65b0f62c-81e2-4086-7410-08dd8d696ad6
X-MS-Exchange-CrossTenant-AuthSource: CY5PR11MB6366.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 May 2025 13:16:46.1410
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2b4kW7QdyXeMMmQ4JAZjEfWwDLStX+skUyUjYXKhoBJvbFgvixyLLhpSGxP7E4efPNOsxen9bBlF7a+h6fjq7zE6irF9YqQNQudbgbCr+Sg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR11MB4908
X-OriginatorOrg: intel.com

On Wed, May 07, 2025 at 10:20:58AM +0800, Herbert Xu wrote:
> On Tue, May 06, 2025 at 05:01:27PM +0100, Cabiddu, Giovanni wrote:
> >
> > > diff --git a/crypto/acompress.c b/crypto/acompress.c
> > > index 6fdf0ff9f3c0..cf37243a2a3c 100644
> > > --- a/crypto/acompress.c
> > > +++ b/crypto/acompress.c
> > ...
> > > +int crypto_acomp_setparam(struct crypto_acomp *tfm, const u8 *param,
> > > +			  unsigned int len)
> > Is the intent here to use strings to identify parameters? In such case,
> > `len` should be called `value`.
> > Or, is `param` a pointer to a structure?
> 
> param is just an arbitrary buffer with a length.  It's up to each
> algorithm to put an interpretation on param.
> 
> But I would recommend going with the existing Crypto API norm of
> using rtnl serialisation.
> 
> For example the existing struct zcomp_params (for zstd) would then
> look like this under rtnl (copied from authenc):
> 
> 	struct rtattr *rta = (struct rtattr *)param;
> 	struct crypto_zstd_param {
> 		__le32 dictlen;
> 		__le32 level;
> 	};
> 
> 	struct crypto_zstd_param *zstd_param;
> 
> 	if (!RTA_OK(rta, keylen))
> 		return -EINVAL;
> 	if (rta->rta_type != CRYPTO_AUTHENC_ZSTD_PARAM)
> 		return -EINVAL;
> 
> 	if (RTA_PAYLOAD(rta) != sizeof(*param))
> 		return -EINVAL;
> 
> 	zstd_param = RTA_DATA(rta);
> 	dictlen = le32_to_cpu(zstd_param->dictlen);
> 	level = le32_to_cpu(zstd_param->level);
> 
> 	param += rta->rta_len;
> 	len -= rta->rta_len;
> 
> 	if (len < dictlen)
> 		return -EINVAL;
> 
> 	dict = param;
Thanks Herbert.

> BTW Sergey said that he was going to work on this.  So you should
> check in with him to see if he has any progress on this front.
Sergey, do you have an updated patchset?

If not, I can take over on this work. I have already rebased this version
against the latest head of cryptodev-2.6.

Regards,

-- 
Giovanni
