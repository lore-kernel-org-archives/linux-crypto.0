Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2DB62E3386
	for <linux-crypto@vger.kernel.org>; Mon, 24 Mar 2025 09:40:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.10
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742809254; cv=fail; b=tiZNuAFVrMsr8Hl0xzncH3nkyknbqb/B/MuMJ8/O5rlJrlHNM95K5beYeOiDXm3Mgg+IRTA4PhvtvAPlLWhN8YJL6kbMHFwQ822mWQ8O+WA/vDMPlmzIxLVSvhEzaeJyIPRjdNWpaXFKTWFVjQwTE5F4TaPiAI6A+sB0W4tDpMk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742809254; c=relaxed/simple;
	bh=7b+hVCN5eztrst8dVANkBOhcXYvdW9bnRqbSojdYUL4=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=NenzgWBK0GrEh8LdngvbBlm2+9VTpOAg9+hVuXqI/ffUd1d9v5mEcs9SXmptcAgSl1qKz7NMjrLgfGnzq0ogl21VLo5OtQjFSkdDOxBeMu/16QT6H3F0m5C/Eo7K/7LhhraD3gCzniI4vO7AFFQeBw4TnSwnqViHZVI9drRKmJE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=EwXXJijs; arc=fail smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="EwXXJijs"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1742809252; x=1774345252;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=7b+hVCN5eztrst8dVANkBOhcXYvdW9bnRqbSojdYUL4=;
  b=EwXXJijssYaGeGnHL2DVqhemWEQUnDQ176osORdtJFMLvAxvczLJEeNT
   Z8n41Uauzmov40lAbPdo+I9XKB+1/veDQbSJxKkUJkGdoZXTWl+lzWRFL
   E9C6AXZ609VOrI07iw3mJn4ebD/zOVrhO0dGw4ibKXcbYNJx1u9HtzaOj
   p+voARw8z0j0ImVScVo+PO26n/nB2Y7LxxUFnS2qOJF6JL1gO/eMB5j3p
   WWev3kEalloVDVFIVbga+c+W6b5DSy5Yh3XIZE1bPUh02cmIn8Glh/3YR
   Y9bRR40xcjcWzwK4V5hWYDq2qQPraWqLA3FvwKdGwOXy3Lby52Hpyspuu
   w==;
X-CSE-ConnectionGUID: cMcBNhkYRc+/q0qG30pyNQ==
X-CSE-MsgGUID: eDbRKmTiS2e43Rni63sZFw==
X-IronPort-AV: E=McAfee;i="6700,10204,11382"; a="55382281"
X-IronPort-AV: E=Sophos;i="6.14,271,1736841600"; 
   d="scan'208";a="55382281"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Mar 2025 02:40:52 -0700
X-CSE-ConnectionGUID: 2KLlvgtpSESCM1ZIh9vExQ==
X-CSE-MsgGUID: lOIf89WZR3KKAZz58ZgJzQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.14,271,1736841600"; 
   d="scan'208";a="128813312"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by orviesa003.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Mar 2025 02:40:52 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Mon, 24 Mar 2025 02:40:51 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14 via Frontend Transport; Mon, 24 Mar 2025 02:40:51 -0700
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (104.47.57.47) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Mon, 24 Mar 2025 02:40:51 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=C51L6TtIZWCdOUJ/NpPtnWPFvBCccoakE5QwohCdTC/nku2NO1hD4h+ClPKvRHBOkkFzpFY9c7XTtZo3FXJGOIRCgAIQUdvrOQw8gEbErnJNeS0G45ppi2DXBBn0O94UcX0VMPW+ENn3xYnhUA/K41BEIPbxQ6ojRxnOSQSf3CoyYbq/uFJuspESI7LBAt/GJE8k3FFuuwtSDpel6qMITawtVT2mdIac9vfPlffJC/StjAxJRM76TjpYFL1UtNDr3ZWWla0Tb7ijmEcEBIsQVPgy1GTshqBfpcaXmSb3u0q1NZeSOTYbx9FVSdw3IcmRahw/NE0sC8+1YeWID01UJA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UX2JBHKliQLVV6lUfNwvxpjYPwreoxa60uNr7VnczK0=;
 b=CmNuxkeXg1QrOdEWegTeGWyoW5+/JfFJJVYsQRngaO/YshR8ogU7iZqC4LXTeqVzgbG7MEMSiGaAvuetmCvIb1Xl7Mbf9mHl7ZA170ah693euLrEcOJXDI4yg2wKRIE2Dq3Pxz0ktraEvJZzXmSn4ow+jNYT/xMPqULcCcTBPitPG0zdreN2WrFRlxefHYcRIpUQjR6YPH7mplFuVE4KuQroM//8V2CkwLFckf7ZNzMlSUMirBRvYwTx2YDai966rqzr3qKFOSE+n+BwHCAH/Dm9ZGKwvxyFmtlaJ2Y6lVGYYpDlbtIftzfOSavCU3JXwvio3U7H1YfqBs2aD9nZ4g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CY5PR11MB6366.namprd11.prod.outlook.com (2603:10b6:930:3a::8)
 by MW3PR11MB4636.namprd11.prod.outlook.com (2603:10b6:303:5a::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8534.42; Mon, 24 Mar
 2025 09:40:08 +0000
Received: from CY5PR11MB6366.namprd11.prod.outlook.com
 ([fe80::6826:6928:9e6:d778]) by CY5PR11MB6366.namprd11.prod.outlook.com
 ([fe80::6826:6928:9e6:d778%5]) with mapi id 15.20.8534.040; Mon, 24 Mar 2025
 09:40:07 +0000
Date: Mon, 24 Mar 2025 09:39:53 +0000
From: "Cabiddu, Giovanni" <giovanni.cabiddu@intel.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
CC: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>, Yosry Ahmed
	<yosry.ahmed@linux.dev>, Kanchana P Sridhar <kanchana.p.sridhar@intel.com>,
	Sergey Senozhatsky <senozhatsky@chromium.org>
Subject: Re: [v3 PATCH 5/8] crypto: acomp - Add request chaining and virtual
 addresses
Message-ID: <Z+EoaVTA4xEtECfp@gcabiddu-mobl.ger.corp.intel.com>
References: <cover.1741488107.git.herbert@gondor.apana.org.au>
 <e9da3237a4b9ca0a9c8aad8f182997ad14320b5a.1741488107.git.herbert@gondor.apana.org.au>
 <Z9xPaQNIyFi9fiYe@gcabiddu-mobl.ger.corp.intel.com>
 <Z9zQALjYg7F_ZXUs@gondor.apana.org.au>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <Z9zQALjYg7F_ZXUs@gondor.apana.org.au>
Organization: Intel Research and Development Ireland Ltd - Co. Reg. #308263 -
 Collinstown Industrial Park, Leixlip, County Kildare - Ireland
X-ClientProxiedBy: DU7P189CA0001.EURP189.PROD.OUTLOOK.COM
 (2603:10a6:10:552::27) To CY5PR11MB6366.namprd11.prod.outlook.com
 (2603:10b6:930:3a::8)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY5PR11MB6366:EE_|MW3PR11MB4636:EE_
X-MS-Office365-Filtering-Correlation-Id: 3e0fbe7d-46f9-49fb-6fde-08dd6ab7dd1f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?WXt3ZpQV1nG3cH4agx9sVEG2k1lM1VWjE+k++xk76vset0F8+br2Eh0p98J+?=
 =?us-ascii?Q?sKjLccDLdPm/FkUWvLyJxktpWnACIUGV8rtgMCmuPTqdjpMNS7tnfq0LvGJA?=
 =?us-ascii?Q?cvrkedD/lGSChpO7M+v54k2rwBbNRRissSH+Uam3eUK3/rHVo06b/1fdnKRN?=
 =?us-ascii?Q?O1GOJYVmVR0GQ4/a7NXs+4gUuSCOTRB4FObPFYUi0AP/7wmSCBg0i3edCeWC?=
 =?us-ascii?Q?2j5zClTnl6UsF6ftG4LOfuyesGDyNCa62RxIF5n4r3ZUQER4Rm2Dag1DVKk/?=
 =?us-ascii?Q?fqV+ckeLe8Q4RG7YfhKxhYH/vXIbXr8VUay/lMedXiXhQwnS8Kj2I9cewtW3?=
 =?us-ascii?Q?YwKpj4k780iI3A8BQQS+JG47bMnjcr0kRErYGUY/R0txYUtvsATt9YXKzZqF?=
 =?us-ascii?Q?0P4AbgoypqbE34Ls+pjQ9KcHU7BpBwkaS8CKMGVJ7dFskucUnrjeDe2XxK37?=
 =?us-ascii?Q?rA8iAwihoB9/FRp+I7wJ449owmUFqwVjTrOPNMJTGrKq1gF09+9sy+ubLd8i?=
 =?us-ascii?Q?YAz/jHuCvvgoADASa1x7iXCtRNOa2KsCC7f+6IQdDcTIhBvSo4sYykSyGKdM?=
 =?us-ascii?Q?czptEV7yt6ypdnsSSfE4aayEDxRivbkj1GWSuWpKj1sng+nhYdMsiYmyzdKv?=
 =?us-ascii?Q?Yv7uajmjelVowlkMzvOkUD3LuU35MSIFdeQk2efzD1A+Wxl5jrhcGTlb/gsR?=
 =?us-ascii?Q?D09AQr1uTAih3PlEpatN0cSRuPaPPezmSlpgYtBntVviyptQ1ftamAYWiht8?=
 =?us-ascii?Q?HL77ZK9PSCqPyybRJqsjSOWawwK8Imk9E+8v53kGTahkA3SrJmwElrg2tqEs?=
 =?us-ascii?Q?0IPCSjNGHyoEXy79NaZV8wlCtVjxco+qdmSxcKRd0S0wfy/a3Z0v2jXbos3g?=
 =?us-ascii?Q?/gQqXKEUZ2H8EvResb1zjtwcS+eZleo3TK0DfeOfrbk53od3VtDnt1zSRV2a?=
 =?us-ascii?Q?VGpLUdvU5M9/hIR2sSg3vkcmC17CFQxp52ChU5YlyKOnuIO2YlmQhp+bGS8l?=
 =?us-ascii?Q?CDurI9tnRCyPPQaiL4yTHn+VfpT4t3XO0qzMuKgy14++mGnWLdPyvmbSrvKK?=
 =?us-ascii?Q?drBaqMpRA5ArNynb6QPuSP+wLXNG+7x5N7I+3kZMl0DuEQkpazpVK27O/Z9s?=
 =?us-ascii?Q?4H31QjwZbMjHJNHOs45nPeQveD1axDklFrsbgyeBlsQ9DO7a2GYIvAWBgM0C?=
 =?us-ascii?Q?Y/AfeTNEDRasbTApjSvGK1qP5dbA5PGR8ixnALTpGo0UWFot+zJutCm4M7Za?=
 =?us-ascii?Q?EVXcnVAZ+0u1/tRTmvIj+QD4hvdBVnYt//bt+fMdFniJwDPnNuAuosy1hRGt?=
 =?us-ascii?Q?XdnEUuyl5I34Tjk/qAZoAspcAt2E9rK/z4U0U4SWEJU3cVevJBthab6MKt21?=
 =?us-ascii?Q?hbbtvba5gm+We00+M6DOVspuD9gw?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR11MB6366.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?zrYbDlSYb2q3mD0ZxEIRnaRRyNV0Ti02Sm7Fy+jQuoulFIQZlcbbHn+Ulod9?=
 =?us-ascii?Q?y/qFfl4scDFhcu1EgbfHVEVgSfx5SvHtWgZMM+iuARNWlY2qflqj8ZBQmvfJ?=
 =?us-ascii?Q?Z0QuEiuZNX3/n1xkXUoAjkAy66DB3FjVICI4RzbGfdPgRuk4PgCNAFj50IUY?=
 =?us-ascii?Q?ill82xlQpgPcgbzpt8vHRoPffgQE2Em+2FjSaypunkXxbH4RDvF/LqYrAEW8?=
 =?us-ascii?Q?9JRszeARQaXNdOTvaJplJEIPL807UzNOpMlSdIjOwAr2L37Z7RPd/yHa9Ypd?=
 =?us-ascii?Q?eMpYDTVTo4TtQ9q/r4XaYCpiY+EIaWRXhXsWsNGIkqwB0u9RGfeXPnG6ugMv?=
 =?us-ascii?Q?u2Xl9bkmj4G0OWG5UmkhuzhaJfBt7oVIkrd6Ak/UBOZsIf2gF6d5PGpNvnBZ?=
 =?us-ascii?Q?3I7vfSaSpzQLUXV221U4yJ5dDKxIC+bunYtdBbtIkvhkZ+gB5MOtY5h9DbhT?=
 =?us-ascii?Q?iDDoe+DfLuj15NZBG0bEWy62vglxV1XsCGluL38TDDtraEAn+hKfnTZRO6aH?=
 =?us-ascii?Q?NdthRriyxTakH4AyWP3p6RhNth48E0sNNulKvSo9Dxywz8F2b22I4Aeh4jlP?=
 =?us-ascii?Q?euMRbbH0GKwfPNNqxgrG4YJWUJfP9zv1TaSqDeNBjz7NtOAvfgJiCi19vTI1?=
 =?us-ascii?Q?96gAAPTuCMEzQ8n8MHMbqLKRk7lUhefxBs48hA/2Lzj03/PVDPlAKusrQ8g5?=
 =?us-ascii?Q?jgvXJb8MGRCnA8Ndbkp+gxN6767ChdazR10fmmnmSzTUvVkgI4pwjHtJdEoy?=
 =?us-ascii?Q?Nq3/BfS1klzRr/jad/Su2UFEpUh0QB2W53SkLu0qKXX8jV9ASGPgbafxGfj8?=
 =?us-ascii?Q?NqL9aMBZ5UCBsfbleVrHNEwtTQAhxCGYBgYeOJIfbiq2n3DIArpAxF1qnXgi?=
 =?us-ascii?Q?IqHVonVSveD4e2XBh+txbMeUZSUKxhMqFRsv+MhvBPbmHNONWNOQBk1/OeYy?=
 =?us-ascii?Q?ayvEi0cOURQC9VYf+P+sSZXemkqdH35nB/uosiR7IwH8R/qJsxzLHciRMe0X?=
 =?us-ascii?Q?g1aaY1uv2St2/rtuzw6RIAfA42jIWEKCLx0ZPiMy7BLOZcTSKqmYxYx3zd93?=
 =?us-ascii?Q?A/1/AHcMkcYLXbUDxxkYt6bCRgJlMiAiXXQv5DtnHdDt43lt7dyl4+W/E41O?=
 =?us-ascii?Q?A0obyWVYXGrLk9lpgG3h0OZ3ullfPeZqFiUfmTNFpZ1ZCaWNPn3ha6II/mU2?=
 =?us-ascii?Q?uMFCq072OkwvFHB6C5zM507auBd1zC0Zu6SletGQxDduLZSUjNKsDruDzW6s?=
 =?us-ascii?Q?ECdKcjF8bkry9+gszuWVC0HAjsbxuCJjjSREN+JIk7T+uF6mXpwnJbUzHRBs?=
 =?us-ascii?Q?0EBmkeIPbn5zkG6JydNkcBz6wmTu7jIXgjt9Ck3cw2SnSlY8nIDVVRBRtkua?=
 =?us-ascii?Q?PrgMF+G903xG8BCX8gC7hxNfE4aLIgjYgBg93gBRUVuuQgi/ifRWJk6T8g2d?=
 =?us-ascii?Q?sz6hfApAhoYgsmdRcillACHF9R7DivttIIQq7idx9FWPjKonydvltk+XokBB?=
 =?us-ascii?Q?2qKElonXsLQWRvxqqLIyQFZqEqP2IAM6S8r305iMr20nLyWZc7lOwyx5eK3l?=
 =?us-ascii?Q?wFQOmnAVOIq04ZKmI2vUSiCujwDvNm7ijhjbpkj1ApCYvP4PIpYrhsUpr2iu?=
 =?us-ascii?Q?5g=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 3e0fbe7d-46f9-49fb-6fde-08dd6ab7dd1f
X-MS-Exchange-CrossTenant-AuthSource: CY5PR11MB6366.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Mar 2025 09:40:07.8978
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: n4L4RF41XrmrhgPNSpJw5LAyU1WyWE6R4+fKtoo/f/R/raa3/8VZK1IXJ4Z4LxpZmI4850wx0pwIDa8nN4eYNZ09SKwaQsz0JVy1rLKiaUQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR11MB4636
X-OriginatorOrg: intel.com

On Fri, Mar 21, 2025 at 10:33:36AM +0800, Herbert Xu wrote:
> On Thu, Mar 20, 2025 at 05:24:57PM +0000, Cabiddu, Giovanni wrote:
> >
> > > +static int acomp_reqchain_finish(struct acomp_req_chain *state,
> > > +				 int err, u32 mask)
> > > +{
> > > +	struct acomp_req *req0 = state->req0;
> > > +	struct acomp_req *req = state->cur;
> > > +	struct acomp_req *n;
> > > +
> > > +	acomp_reqchain_virt(state, err);
> > > +
> > > +	if (req != req0)
> > I'm hitting a NULL pointer dereference at this point as req0 is NULL.
> 
> Yes sorry, my testing was screwed up.  When I thought I was testing
> the chaining fallback path I was actually testing the shash
> fall-through path.
No problem. The set fix that you sent, "Fix synchronous fallback path for
request chaining", resolved the issue.

Thanks,

-- 
Giovanni
