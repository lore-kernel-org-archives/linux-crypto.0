Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C34E13212A
	for <linux-crypto@vger.kernel.org>; Thu, 22 May 2025 09:05:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.14
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747904720; cv=fail; b=QJ3BO445vb5gfpAPnp3+svFpkVlQA6aLasTWtTZo2AnQGpZ9ZV72lcdVmXVidvfswrw5PAfj5OnDvzacZMeoWfx1nkEf5GYOfJ4RJ4y8cOXhp3gIU6KAcTGIuPSiocO/J8CkRC67ay7KZFZWO5XvmiQurPtgZtKE4g/psM2G8lU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747904720; c=relaxed/simple;
	bh=xXG0U1w4E+CLkCksoHaG5rL1leChBYSqNeF9pdmzsio=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=a/vZO6uwlkJavySaA504F3mW2CWYsRfUk8668oXOrRgHVjAVSuBD5HZIscEINc/Ulk7cmY0V77KqR7Ktz7FiyKRSnLs7RGBzQFCuEbiw8OqBbhwiX2pNGL1XC6IM6NuDHA9LURxl9sWtnX1gFXuL3cjFn4+tKwg1TGNz9DpTERI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=UY/XV0pr; arc=fail smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="UY/XV0pr"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1747904719; x=1779440719;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=xXG0U1w4E+CLkCksoHaG5rL1leChBYSqNeF9pdmzsio=;
  b=UY/XV0pr9QDXxlsw+xXVQeR/rYkiqNJJJrfA7AYkAtxmyXxgpctBcpc9
   ceXj/Vzjpewo0e/70+RryDBXCGHR0EekRXPAGrqmC08PiejsN/Q10L1Tt
   69f9pyyKLOgWuu4gp5vEBekodj87czZdPeRE/TR9RvgY6yFFHIbtVD27I
   xU3D2uCr6gDMz/iOoFU4+Ws6atV+B81PUl817n7bzNKi4Y+kE/sPzqOUT
   f2q5+giDbvNROVs67v4DnMGDPZhM7gKlxG1XWKycTlxWVFLyfK6gAEkka
   GdNCFOdE++jyjcqmbCGZRAOZMJ4v4IK4MU4G7KCh1hp+yvP3AeECaJmAz
   g==;
X-CSE-ConnectionGUID: Z2RE1h9LSbGQOgKxpZRLdg==
X-CSE-MsgGUID: IUYxviuSSNmW9/b/dS7ruA==
X-IronPort-AV: E=McAfee;i="6700,10204,11440"; a="53724479"
X-IronPort-AV: E=Sophos;i="6.15,305,1739865600"; 
   d="scan'208";a="53724479"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 May 2025 02:05:17 -0700
X-CSE-ConnectionGUID: qzgo8BcZTgGF8F2xn/oFNw==
X-CSE-MsgGUID: /COYHNTOQUWIVX/G54HOCg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,305,1739865600"; 
   d="scan'208";a="171380959"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by orviesa002.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 May 2025 02:05:17 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Thu, 22 May 2025 02:05:16 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Thu, 22 May 2025 02:05:16 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.46) by
 edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.55; Thu, 22 May 2025 02:05:16 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=yh802XW3HcY59JKx+byf0okbB/UeTWT3j57QVkQ+BxvwGshk26qdnxdeR1+x2qE42yqRUDA8aMAMHxEbY6PAl4HwyspM1QofH7ZT9D8W+7J+vSLnHNUhuGdYFnsz2Jqtl32z3XyA5MeMh+0qdhkCnEpZA0qZku6aZMY65UYh4ZYkob5KJnevPM5+KXI7v9+KpDo3CQFuZnjoW66puXNCKo+9Xr6+FI/wcHYhkeZjslJn+ws0VkFUhotp8Sj0q51kwnGSPCzAgpczKLyvmPCRBm2hvjIXBgT9BorB5hnNDYach0JopPU8GD4rANYr6ZRsfdajeUgmz+wSDfguznjBEg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Ril1RTBLcbkYVqo4leh98padJELQYS4cOQ+trxafegE=;
 b=aK4ICRvUYICLG/TrSmpgyjftG0oAtduoS4X/I2NRMZTaKWdGe3MlayP75E0ULhL6uiLXapoBzys4UwHGNKtOcFogk69Gow/aNZmS7Q2JJHTwdmCtt2DBsfardcmTLzEmayTIKA2BRD6I/jtBaULD+pY3OXq9inskJMi9CIJ9P/8CIFv7b4G8z2lxtN7ObczO5Qgwhirx8b12xq8PezZKnIxpHmBZ5xQMP24OmEbXL6k1yR15KDHDfcjaG/Je9gRaDJvhfQBbOmqYNhLeiDBzhIHEUUSetc8Bg/trO/behWFLrcTlSf1xdSDynz53yaeHEmdha1caZsTka98hgoHdbQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CY5PR11MB6366.namprd11.prod.outlook.com (2603:10b6:930:3a::8)
 by SA2PR11MB5100.namprd11.prod.outlook.com (2603:10b6:806:119::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8769.21; Thu, 22 May
 2025 09:05:14 +0000
Received: from CY5PR11MB6366.namprd11.prod.outlook.com
 ([fe80::6826:6928:9e6:d778]) by CY5PR11MB6366.namprd11.prod.outlook.com
 ([fe80::6826:6928:9e6:d778%3]) with mapi id 15.20.8746.030; Thu, 22 May 2025
 09:05:14 +0000
Date: Thu, 22 May 2025 10:05:06 +0100
From: "Cabiddu, Giovanni" <giovanni.cabiddu@intel.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
CC: Suman Kumar Chakraborty <suman.kumar.chakraborty@intel.com>,
	<linux-crypto@vger.kernel.org>, <qat-linux@intel.com>, <dsterba@suse.com>,
	<terrelln@fb.com>, <clabbe.montjoie@gmail.com>
Subject: Re: [v2] crypto: zstd - convert to acomp
Message-ID: <aC7owoGDFl5YVVxP@gcabiddu-mobl.ger.corp.intel.com>
References: <20250521064111.3339510-1-suman.kumar.chakraborty@intel.com>
 <aC2I0_F2BJbexte4@gondor.apana.org.au>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <aC2I0_F2BJbexte4@gondor.apana.org.au>
Organization: Intel Research and Development Ireland Ltd - Co. Reg. #308263 -
 Collinstown Industrial Park, Leixlip, County Kildare - Ireland
X-ClientProxiedBy: DB3PR06CA0026.eurprd06.prod.outlook.com (2603:10a6:8:1::39)
 To CY5PR11MB6366.namprd11.prod.outlook.com (2603:10b6:930:3a::8)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY5PR11MB6366:EE_|SA2PR11MB5100:EE_
X-MS-Office365-Filtering-Correlation-Id: 55e6473f-9568-4880-2c26-08dd990fc37f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?DZzSOJRBfYz8HL5YskO7JN8SOv8aivLpMIP/zjNfY+3VMqUbkFcW/Hs8I3/6?=
 =?us-ascii?Q?KaXVOYNrwtI64vjTWFb512ooUKg6JthsjJIYKDv60W1X0X4tzuBafJk+Y1if?=
 =?us-ascii?Q?e1AYrefC60pl6dGTT19lwReh7kWKdLCHC4M28QznHO486Ap/Z7IHs+F1E/e0?=
 =?us-ascii?Q?PhzpT3QMSZ35tq16t0oIw8cuyFuVncJANhbU/nFkAdcO94HDlCdlUBf9gx7N?=
 =?us-ascii?Q?mKxVWVd8X5T5q9JgRFqRnXQV+Xtoi4iXYNDG4gmDztnbCTMm8xO31i1I29x9?=
 =?us-ascii?Q?8ZTOiHQCYyeoI0IymZCN53ik8PqKLR7MapNcsVb2QCGZFWgTBgw+Qvv5kmO5?=
 =?us-ascii?Q?LCXYZ+pdDA0ksabiBXW3pHhq9tooThs8voqgj3mnQlZ9EmYcHNyv4cJBSodJ?=
 =?us-ascii?Q?cYnE2VckaxXGPPQ7NcRoYNLOSjtoQRiA/bVGPqKNtn2J+CckvOm5YPN5jgDL?=
 =?us-ascii?Q?VS9xxU3KE1Pu46NiszJoUmWHAp2QVuuQKzIJ/6aR6yOOD+2RCM6TpU+diWDv?=
 =?us-ascii?Q?igRZ3xzqYvGcuonI3Ic0PmM2/TrDfPTtwdhTfngn96wUGskdd3p4D3cA4hIB?=
 =?us-ascii?Q?HSzMRCMQRJHzi/NNtzO5nn/0eK2O62leBTMau+OfSaC0iFuNtofqNlSY4Bq8?=
 =?us-ascii?Q?r0cVOCP+emhKLX1nX/33G+yqQH+IAsOOvdRFD/K+QN/nyjz7TDU3HXIovuVh?=
 =?us-ascii?Q?GHBo4n3Fexg3r3VhmsKfJW28B99scVjTIsUUZp3ra86f7CLPnazxG46atL42?=
 =?us-ascii?Q?yaRazvE++EeHmVtAfb1rGqS84QGXfcnH5DZujXaFvE3T2lppQj1UmbHVsrXR?=
 =?us-ascii?Q?IuOu1+iP8sJ8fCqWisPXgVmhzsnMlESDGtUbNQf2LtRW4LpOMAmXYjszv4lg?=
 =?us-ascii?Q?JffmG7LwHZK18DXYWbhXVoMjlq5Rg9gZhkH/BaoVj/KHTeuULaZcn9d6wy/D?=
 =?us-ascii?Q?CUyDGFuywuIADot76ehJvpeANKckfUXp1R/1y6sBAkbFZGVcMwGykK5M9fD7?=
 =?us-ascii?Q?EYUQAborgwftV2SCMugsTamtHNIHQoudP0c8EHg68G7cB9NgNEe24kNT85xi?=
 =?us-ascii?Q?5xWq0hpr2UB7vlhshE/xq3JyCPjZyPKlJimt4OpP+X74I82PgntrjaCZG8Ex?=
 =?us-ascii?Q?VRFwWu/QVYIMoujmkaWT+2UnoQNNeRoOp+ZDfOBkuEnymVnFdWtPP7GvqAnC?=
 =?us-ascii?Q?CrtH9WKyUz5M9iYwOcekRKEctWhghvXdW5l9+G/tCu8tHM9YfCfsg8VM5Z0/?=
 =?us-ascii?Q?ZvzXqGLLbxGMOW9+HmtExsM2+3Ybncxsx9hmNrnw/6MAgpN7o+CEHPF1cq/a?=
 =?us-ascii?Q?nl5t5eACFSBavNKHoxcObsZ3Tm8h3pfXBg6k31fJCpJ7J0uhysI1EP6L+p1s?=
 =?us-ascii?Q?Io7Wc88=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR11MB6366.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?SXS/qeC8w4iCuIoZvRfmGkCZC5KACMNa5I9kLGvuoTHrD489/48swH+m5sqQ?=
 =?us-ascii?Q?f27tz1KysSOyc/gxGvqSUEyHs9KHIXBeYAm+/oUrBC4zYA3+2zsjd2ASV6s+?=
 =?us-ascii?Q?hDQaxWp4KazCtuV77mwMRH7vTiEe+GosoN6paC6pg1Tuk4mf4yFo8QaAJQzi?=
 =?us-ascii?Q?45eeYvvVh+cvS3nSQqBLOdjojwbIztXEOmcN1jmYA/jr0n1DZdKJUgJsaTF7?=
 =?us-ascii?Q?WpKziDSm2GyjDjU7++zkO78XKkDrnybpVd+WZrf0MxDrl0xEebRyMdL4ITUQ?=
 =?us-ascii?Q?8cKUonh47QLdSj068cvSrRfcn5x04Tt+8nMmUlI+HfaIH8vM1gEgU3udZgIx?=
 =?us-ascii?Q?6mpYMGAu4LASMjEvAQ5RB1YzMfXeobSUdpXASaYl8ijW5AF1Ndt5FOWAG4+0?=
 =?us-ascii?Q?4bwt2F3O3rPzhCxW058Bu3g+I1vgqyvgjqGNkPLjpeA/VDPdmj5ksEMLfl7Y?=
 =?us-ascii?Q?3aKpT4Q/ZhaPBV6F4GZ1iHKugf31aCM4siMXI/eX2u6/SpsfBFo5wqTXU7TW?=
 =?us-ascii?Q?qWprED9va3Pu0glNHu4vte6G4U3ZK4fEjJD1xh2qVld+dJ8OIX4SqlEMo8e3?=
 =?us-ascii?Q?gruHf3eadqXXYIbyKaHLQ/Kcm1srwv82fn4xCSI10WWyrm4+mGGjlD0+/B3J?=
 =?us-ascii?Q?RJorJt47+RpE5zF6nYXgGV5jqQUFEgvVK7w40G7ZcANGSqHpvUnyew8dqrlK?=
 =?us-ascii?Q?Z6d+WeE5oGaKhQ/eie1OgSfTUwfReBMzBMkjKnq/PjDsPC7iZQO9486eD8/Q?=
 =?us-ascii?Q?PODOzsnj2f1P9ywZGsOjswZGt5DIYvUP6ALAeAoNFLyNc4A3tOpAZCMBp/XO?=
 =?us-ascii?Q?83fjMcKeGXAcWNFvGo5q78jF1tZ9w+eCedF2pcA/L792JlHgiPrxR9JjicUN?=
 =?us-ascii?Q?jDBf46oII/7wg3U3yBhYMOK0m+FTFqsKIgOg/ASO7SMNpJqcnFsnz4OOTErR?=
 =?us-ascii?Q?Jwj8RYNOJWQtjFvZnxWbG6FGKDKNihMfCuM3i5Kkbn0OVUDAxSwk+JwnAYOI?=
 =?us-ascii?Q?gD8eop2rUW3UpqSjQRcYATWR32dAKbsW8uc09lheaPJtBUEpYkx/RQgtCigf?=
 =?us-ascii?Q?36ICOKt8z+2HOd44j1m8UHSB8jd6dK/XMLWLf7+pFceB5h1jJn0zd5jG+LCe?=
 =?us-ascii?Q?RQ4jdLqAEh55U7D8nH+5Rp3iquLZsQdPbwy360E4jcJfFCWsGrGlxa9zfYMJ?=
 =?us-ascii?Q?/0ulUEyLJKKclI1e/L1ScSGhE2Ca+Y9H6z2wk7ekVYYpPHDOYkmZIza5ElxF?=
 =?us-ascii?Q?2/igrNJAtpiap2iacldyVXiRz8M6M4lXCZYLYWqNumi+YxZ0Nm6VVZZwQrYt?=
 =?us-ascii?Q?F9KEJ/nYdL8s5q4Ucf2Dg0NG7p229qALe0xLJ69ICtyC7YONLLN5hasO+q0n?=
 =?us-ascii?Q?RfyT4nHGY2ukMUiZyPKBUbxYTKXI5sP314tCn7/FYxdFwgWwdghhkc7Ug/Bc?=
 =?us-ascii?Q?1wEW2PP6yeNjBxYyogtXAdhzTYMoUU53wdd12Klx1nglFIXIFRXeH7clhd2R?=
 =?us-ascii?Q?EQuJoiGKLDF2J7ppd77bh6PbtB+5PWDZPbxepJV1t2FoMKYE9PUYsY42ZC0Y?=
 =?us-ascii?Q?kdVfKF/AdYByYGG7LpdXxdHUdAKyXnkxyXoLKiX+o+WTz1xi/lNhndVlKe66?=
 =?us-ascii?Q?OQ=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 55e6473f-9568-4880-2c26-08dd990fc37f
X-MS-Exchange-CrossTenant-AuthSource: CY5PR11MB6366.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 May 2025 09:05:14.1183
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jkNDHM/EIsQBmT/H9blencB16fUtJXPDYaC0RvVlpWsxkAdLdWQWjwnuU04O6ckb1meJz3dcPAJ1vp6Ex1v4HWjWU7NbC/p4BpnGuizbztw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR11MB5100
X-OriginatorOrg: intel.com

On Wed, May 21, 2025 at 04:03:31PM +0800, Herbert Xu wrote:
> On Wed, May 21, 2025 at 07:41:11AM +0100, Suman Kumar Chakraborty wrote:
> >
> > +	if ((sg_nents(req->src) == 1) && (sg_nents(req->dst) == 1)) {
> > +		ret = zstd_compress_one(req, ctx, &total_out);
> > +		goto out;
> 
> This isn't right.  Even if the SG list is a singleton, it could
> consist of multiple pages in highmem.
> 
> What's worse, if src and dst are in fact linear, then you're
> dereferencing bogus pointers.
> 
> Just get rid of this optimisation unless you've got numbers
> proving that it makes a difference.
Without this optimization the performance drop is significant, compared
to the original implementation based on scomp. About -40% using
compressible data and 4KB flat buffers.

Is it an option to check if the SG list consists of multiple pages in
highmem like it was in scomp [1]?

Thanks,

[1] https://elixir.bootlin.com/linux/v6.14.7/source/crypto/scompress.c#L138

-- 
Giovanni
