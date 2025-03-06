Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FE425B211
	for <linux-crypto@vger.kernel.org>; Thu,  6 Mar 2025 12:15:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.13
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741263312; cv=fail; b=BSIlKQLvYe8YlrnOpxR0k7ez4bwSxfi81AgOZ94CsStJS4tQbMgbX3ZNdULAmyeT24vEJ24ntmDPYBoAytJ5P276cVMuGrZbs584ZjQeTWuKJSZZq518gP/6etvuXGpPUMsG3E12gtnhRFwS8M8gUgUf4RilzI5/R6HNZIEECqU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741263312; c=relaxed/simple;
	bh=BPMOm07mt6/nME2y5pASXS6vZRIhGl89wAZacbIVNs8=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=CMCYtQlXpPbXN0SsfnacQwoBcfl/yWv1uExRq9L1ws3N7Zd30VoNIKL4rMa5FSEoYMYJjmt1sHyEbA6qDJA2EsJKlqXaSE9f/ZC7LutNsNPuYy9eFqc6pxTSt5GpmLZ4tHbTeAClXwMGVebrXF7moNDzGoomYbT+0UuVwphK6BA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=bneiYtaE; arc=fail smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="bneiYtaE"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1741263310; x=1772799310;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=BPMOm07mt6/nME2y5pASXS6vZRIhGl89wAZacbIVNs8=;
  b=bneiYtaEoJIhCu303SEWckg24z8/UTJELCzLFXA7rrsVqmiQuo9x7bf/
   HH4IT4znE4tDPCVz+BDPMPufAPTRY66Gr7vGga4lQU6H9IhlSWpmnmK9E
   yQCC8cthdUSMreKc3PS8JILxa1X5urp+O4+jQ9la6KDjcktbkML1oekqL
   pQmb9L0qKOQuzgTu1t7idg7lvYqKZQBex8xpGBfFo//16NPKqq9OWnihk
   gfNQoo8iW6HbWFAy2v6+ctwzlca6IVFj8K7AUmCicyd9JwM0QC6TXc+uQ
   BK8Mkjl5Wcc+Do5i7J2tx1RKplG4IdC9fjNFz2MmUY/Y6BTXKyGiRVsqS
   Q==;
X-CSE-ConnectionGUID: lLw+y7gSRXGtVyuDEIOQdA==
X-CSE-MsgGUID: QwZ/6MXsTkGRKPWTJwaihA==
X-IronPort-AV: E=McAfee;i="6700,10204,11363"; a="45073494"
X-IronPort-AV: E=Sophos;i="6.14,226,1736841600"; 
   d="scan'208";a="45073494"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Mar 2025 04:15:09 -0800
X-CSE-ConnectionGUID: hlNWtAIOSPGzhymEyCR46Q==
X-CSE-MsgGUID: qsbeIUR8R46RK3BXDecatQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.14,226,1736841600"; 
   d="scan'208";a="118815382"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by fmviesa006.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Mar 2025 04:15:09 -0800
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Thu, 6 Mar 2025 04:15:08 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14 via Frontend Transport; Thu, 6 Mar 2025 04:15:08 -0800
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.168)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Thu, 6 Mar 2025 04:15:08 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=EwZ5P3IDorfKAebq/I+8filaZtAp9+rouVduT72JMvVu07Y9cX1KiTvP2mLWU93qrK8g4Cgqs8J5G4E6xab57QizeTNyVc/hh/Vv+pCU6Rco1Tqs2bFaAhoZCEfPswiVH0CNumrDg2v3KkGbpsfXvCKc0vsVeU1YMxzgT7RefDS4eQ6qjxZRWXytzW4SXi0LwEO/ORTIJ4BDzrKBzCyusQGCc3KB3OVXK0JN55U3x48lwSO/d4B1zSt8MDoEO8G8HIFi4afxiQ/eqZojcQ58X5S8hs87KTrqc9307HjPlicyg9bH89/12BGblHpcPluz8Sfj/XLOYDH7DmNFNOy1GA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=T7MzLxTPVpas+FhkeTTMJ5o4CZ1zZgBXBPof2fbyNnU=;
 b=APh1Q32mkKUCdHRsTTIrglSJm3i9bA/RC0IWGc3IJQyqKMmHfqSgsThT5tghuw0WTIGcYM4niXSLmWWnLdHFxuob0Jo6QVSktK11/y2nH8aZUm6FhCAYuXGZiQkYnvUmRhUiknUf5Nt+m28uDK1/r2Bf8XiyFtnzXlQQDs2foJXifHMNiJKQN84IlkzEGlkPTYoddHFwMlkGbq1JPtfXTzu2a8fGCDPqao6TZFG3U6LXoD1c5w37OQBYaVCMLadJDrJ8+z8MMz1PwuoWuGFSJVDeCO/5wIGNMQ/6LHVIH5K3f+KiEhNgfOfTcKNSQ4lqfB1ziZP75MnrIpOzk6Ptfw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CY5PR11MB6366.namprd11.prod.outlook.com (2603:10b6:930:3a::8)
 by IA1PR11MB6121.namprd11.prod.outlook.com (2603:10b6:208:3ef::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8489.28; Thu, 6 Mar
 2025 12:14:20 +0000
Received: from CY5PR11MB6366.namprd11.prod.outlook.com
 ([fe80::6826:6928:9e6:d778]) by CY5PR11MB6366.namprd11.prod.outlook.com
 ([fe80::6826:6928:9e6:d778%4]) with mapi id 15.20.8511.017; Thu, 6 Mar 2025
 12:14:20 +0000
Date: Thu, 6 Mar 2025 12:14:16 +0000
From: "Cabiddu, Giovanni" <giovanni.cabiddu@intel.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
CC: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
	<linux-mm@kvack.org>, Yosry Ahmed <yosry.ahmed@linux.dev>, Kanchana P Sridhar
	<kanchana.p.sridhar@intel.com>
Subject: Re: [v2 PATCH 0/7] crypto: acomp - Add request chaining and virtual
 address support
Message-ID: <Z8mRmCjVYo20o74P@gcabiddu-mobl.ger.corp.intel.com>
References: <cover.1741080140.git.herbert@gondor.apana.org.au>
 <Z8jEJ1YVRU0K1N8/@gcabiddu-mobl.ger.corp.intel.com>
 <Z8jvbL8dbjsx83g1@gondor.apana.org.au>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <Z8jvbL8dbjsx83g1@gondor.apana.org.au>
Organization: Intel Research and Development Ireland Ltd - Co. Reg. #308263 -
 Collinstown Industrial Park, Leixlip, County Kildare - Ireland
X-ClientProxiedBy: DUZPR01CA0046.eurprd01.prod.exchangelabs.com
 (2603:10a6:10:469::14) To CY5PR11MB6366.namprd11.prod.outlook.com
 (2603:10b6:930:3a::8)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY5PR11MB6366:EE_|IA1PR11MB6121:EE_
X-MS-Office365-Filtering-Correlation-Id: 60020912-d0b6-4cfd-511d-08dd5ca86cbf
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7053199007;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?FppS7pmwvT/7mGIzKzf10t2AlgDqtDOWlWf+aix7nynrTdx0vZ/KIg1SGUSF?=
 =?us-ascii?Q?aMvEeNO1oF3r4c167Nc/ATqxwJQLkPzUXhKzpmA1Qr3gLLb4T8yUwIKrDLjV?=
 =?us-ascii?Q?tRVNYYnxrocBbpMoUKxpaIfqWGHwIvS+hJLgIV7/D1o8mFss5utbkFSt/xE9?=
 =?us-ascii?Q?YawyNTjVwkjVNOfr2i/5MLAON1Du2w4zi6o2QDrkSzD5Y2ehpI4VGeMdzFqX?=
 =?us-ascii?Q?g1YYXNbV9ZjheDVqnn5l3Cpc42w44Z35OhtXfJaeFPVOCfzsHG1LfLzTBuNv?=
 =?us-ascii?Q?7aT1evyRRJAKwbtr0M1W4E4hNWzpl29UYm9ykK9C/PFNcqKaZ208rto6SIsR?=
 =?us-ascii?Q?cjEa4otT2rMTqFeE5VMQEKTZrCyspMWiguAjsMnhQAAGsnuinn7RCFbJrrzy?=
 =?us-ascii?Q?6/8C1tz7fvsIjDP34AUhyoPLMfbf2sSG9no6iElCGe86/FpSZMTzmHdU8KIQ?=
 =?us-ascii?Q?UUsCIaY1YUh312GDpwnANxOSoRXoUOlDAACIXvDl8anXqlQqX9DrbbSkEW2T?=
 =?us-ascii?Q?OfV8ZSyfa0//b4KYFLOm9Y9jt+gP4XSzGKGf2aforgH3g8kGa0IojkzL7aRp?=
 =?us-ascii?Q?0zRL9rvrjseTADiDZT/fTuN53LX8ZKb84XE3X9kzSQsRhxJ6JeR3Z30708WS?=
 =?us-ascii?Q?TBwp9gAUdCR5g72x7WZg3//ic8hu2CnIHro44TSWEmdUM3b0HYyE0IKPn3Vx?=
 =?us-ascii?Q?Rzmp1mZdlEEAwF0fOjlE97HTlsM+INNBwg9e7f2B9q+tv3lZA5wHmca8sqH4?=
 =?us-ascii?Q?1GmxyPPe4Nq35+My9pBXAmojqFl5k0W80btHXLaS4edksHf13Ou59wYVyfyh?=
 =?us-ascii?Q?K9rL+f6YHiZgclCgbQqlFEADpXaOTLorSrv+LdHZr4k2G0z5rxMeVeGA/4Rf?=
 =?us-ascii?Q?Jz0YjiZ4FkDXuS9Y7/9Du+e9HQl4zAn1v6uawelet5QvurJwiJr1fAM8zqCY?=
 =?us-ascii?Q?aCUgAFFnXP1KEJ3ZlElZzUKPsE3OMnYh5j04/aaQke6jzuDRjjz95BIjZcf0?=
 =?us-ascii?Q?V/OhNFakAWBhEFNuLb2T2czCBwc3DA+C4tb3Vc4DLxK2egmy10QiV7QkXCWV?=
 =?us-ascii?Q?wKuqi8r0V0flWM51gr+Zm2qcAbOctacIbq88fIpQ+U41darrNXcGaEoBe9JB?=
 =?us-ascii?Q?zj3RLiTs33wxplJ+RskBQM2jD9JBUvjWTYtP+e1J8U5eLArhEo8DPcyzqDFg?=
 =?us-ascii?Q?RLIq9DLaKee/bngbCh9LCeLLEh92GCTmy8A46nQ/Q6nw4Y9GHFUSMhZMi6hb?=
 =?us-ascii?Q?7wWaw9YBAN7GQZVLvagV1lxPbE3tgHIbxWlbbRvaWqZvT8eQ6AsRA9CyLf8x?=
 =?us-ascii?Q?oLdY9Mx6eZGQhykbvU2cWLif2qftHGqAIva+eG57NiQ4Ri5kXNYU1lAwiBIl?=
 =?us-ascii?Q?hJXA+iWe2fJStncLcjT33qpNDSBArlVYhDiLrJDsKL13Mm7keA=3D=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR11MB6366.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?abmqLYug4V3oflPXXaY16rjxQ/CbkRKkrR6oPGhKk2Xzs7MeBLB+Awb1ax4B?=
 =?us-ascii?Q?zG+khmFCmOHugBSnib6l6lMnMDroFm/Vjs9Tb0+Ur8Pja8CtIkNW3XrJZq6W?=
 =?us-ascii?Q?bDuuzEWE0hL1OuIalGTdriuM+xOlzcB5UUSvYw0BaBr4smBxAXz3dct82qfF?=
 =?us-ascii?Q?uO+wj6MzFT/j53oHxU+p8ri21PAoZqPX9xFYrNPqyvvAaX+zTnbQ5N6obXqL?=
 =?us-ascii?Q?XBETNXLO8VLCOCG2MmLXDFllenl+G3pIKk9sFa0yGNsjD6m3/u3OG6yT0m+a?=
 =?us-ascii?Q?aoHIRSr+Unu/PqiXn9dztqKjZ0w0xlyasLk/DWWm/Hog10BABO5DxYidEYGx?=
 =?us-ascii?Q?1l3iBf29RA12PfoqZtY8pSKUlm575KV2NDMTT+ipOlfU8/u4HS33yiPOKLDC?=
 =?us-ascii?Q?ZmMO+iNY8VkMORYm6m6iVzW8yNbg9AFlhB711tfWCWKsXt7O3FCxbBtLk0G/?=
 =?us-ascii?Q?1Lmpt3/e0gUpsQnMh7kkAV2fovHfgERNfoDr+8x3H8jb3WhcXgSNMtibkzdw?=
 =?us-ascii?Q?TJZcw12XbR64Y+yXFp3vltdQhX1IffhWXsz3+afPL9x1rCCZE8OI2XlSuqN5?=
 =?us-ascii?Q?BAsL1bLGPKXQzEBiYOV5UmAb7v+/ynRNl1PdKKHonkZIc/3TqC6SXoH2tTT6?=
 =?us-ascii?Q?XTJz6rWmafZYI2wJWw17Le0mPJavDQ6B7FPCOdvR+Ifj/4ontg1goAbuIh50?=
 =?us-ascii?Q?JSO+MEm8uAPNgNkUPDch/pPsQDbhgrzKW6OzMJy74xk/9S2PvEvLYv9ux9p6?=
 =?us-ascii?Q?Zpcw4afwjg57yJEjlFigERjd8KwlUXt9RHKqVUuDgJ+G4G2XzMZbyvwyHKst?=
 =?us-ascii?Q?SyNSCl7HIvRPBQC+KW7Vl5yUCBNJGJp5b+DkTQ5aFFIBY8XuOOGE64l4vRUd?=
 =?us-ascii?Q?mYkSoN5RJvk+yQW/u2Y4rFaiw0eChO6p/NChz7Hxf1qb6j1PDZ1vK6KMs2TQ?=
 =?us-ascii?Q?5Y2jsazGqEIzcCCU4sDqqBmGrtFtsESXIz//Pdrtv0fzkR0SSjqQ3iAGzrYI?=
 =?us-ascii?Q?Elu4QQz395+/lSfWsWLn+DELJ7gbWURzIhcY0K6VJOsUtr5+6ze+Uvn+Q3kk?=
 =?us-ascii?Q?FIJI7mMyfrxgdBc7zvASox1+y4+oVj9uBHV4DArKa0sxmsvVLDNYW7mBAzlC?=
 =?us-ascii?Q?r++Oz7VEmfh89+cmi+jCMaIiiLXPlPSB+SBc6YDoQfPNgOc23HPNYs0NVDc2?=
 =?us-ascii?Q?1l4lg7U3ml2YkniCo1273Wu1y+9hcWHhKgK5k1Q7dyHZQBS0JD7xVyZbdxQI?=
 =?us-ascii?Q?PAofX3p4WomXCh6S811zKOlxm/F8U8zvXN4mpqeLfLYfzqt+XXzSdWXGi32h?=
 =?us-ascii?Q?woHvPHYxSkMPwpY2hOrBMAHjTqsdW0yocCrfuvUNrKuJldyLGqRcplPvvF1u?=
 =?us-ascii?Q?DpvZ4gIH0ShpMt1aCMcaNefQX4T3SC9FWEJp49xiZlpXRGnMQei9H3RELPim?=
 =?us-ascii?Q?OkZMV7n62um2lSEzKSraV5Z60SQuCn1lymIUxiH+TLZKQ4trrn+WADyfWfsQ?=
 =?us-ascii?Q?mykrZ2z/g/LWjXlAuadaSfijd6yKa1HVn8fLbB+Te+TPy0RAulMykGujeZb3?=
 =?us-ascii?Q?VAoRn1zFC9iE0nSySDo27fH58VxiTW8XgBpxcHBML9NBEySmOpZ3msk2Ysw9?=
 =?us-ascii?Q?IA=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 60020912-d0b6-4cfd-511d-08dd5ca86cbf
X-MS-Exchange-CrossTenant-AuthSource: CY5PR11MB6366.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Mar 2025 12:14:20.6781
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9UhNmUbp8szB5y1//Ebg0lHwljY4h29orizj/p4P0FIMeUmBl2Yuz8y6059E1s8ocycctKrAmqdDS7WmqJnOSzbT1vacXwtQJBPypBA1tXY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB6121
X-OriginatorOrg: intel.com

On Thu, Mar 06, 2025 at 08:42:20AM +0800, Herbert Xu wrote:
> On Wed, Mar 05, 2025 at 09:37:43PM +0000, Cabiddu, Giovanni wrote:
> > 
> > What is the target tree for this set? It doesn't cleanly apply to
> > cryptodev.
> 
> It's based on the other two acomp patches in my queue:
> 
> https://patchwork.kernel.org/project/linux-crypto/list/
It is also dependent on `crypto: api - Move struct crypto_type into
internal.h`.

In case someone else wants to give it a go, this is the complete list of
dependencies:

  https://patchwork.kernel.org/project/linux-crypto/patch/Z71PHnpl0FeqChRE@gondor.apana.org.au/
  https://patchwork.kernel.org/project/linux-crypto/patch/aa2a2230a135b79b6f128d3a8beb21b49800e812.1740651138.git.herbert@gondor.apana.org.au/
  https://patchwork.kernel.org/project/linux-crypto/patch/bb32fbfe34c7f5f70dc5802d97e66ec88c470c66.1740651138.git.herbert@gondor.apana.org.au/

Regards,

-- 
Giovanni
