Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F7C2293B5F
	for <linux-crypto@vger.kernel.org>; Mon, 29 Dec 2025 11:07:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.13
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767006457; cv=fail; b=ljawlhR8KgveJd9qLlvPNmx88zfmFa4LJ6dosKDTBuHpwcToTZgXN036mCJR11Pj1Q9ZHH9Z+D81Fqd2sGeUiBO9bTgJcmd+CGptFfWXJDQzgD3DUEgVCeYYqPBtu5PtDPetWvQ+ErCiJWgOqDFe3fndKf3tEutqvZocYg0Nvho=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767006457; c=relaxed/simple;
	bh=SU2IJ0CHpj0PxwvQieAKkH48Bx9EccTkoree8KjYsnk=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=pibQv3tuk4U8jUPLS/0GduKPBJycS8dXBGA4CYY4z13kAl3692b1dImZoPqCmhaYgtYpz9NMHV2lsbVAfaXHhew/e1VFCGe/agB3Vuh35hSO059SJrJooZU63c4vyHkYtvG+2aQLyAmeN0VB3LPlorkVKohJ55TT1Mcug5iQ/Ac=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=aP0wk412; arc=fail smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="aP0wk412"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1767006456; x=1798542456;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=SU2IJ0CHpj0PxwvQieAKkH48Bx9EccTkoree8KjYsnk=;
  b=aP0wk412vSlTaXVVyQhOCbLl/bWiboYyNImb8/5MLlK9vYOTot20obZz
   WdrNLUx3LjMN0z4mOqGRqgqF8tCD/QwG6JDg7REaQCcP9ObE5pa0DZLlj
   UXczXVT+eG0jRl7WM5VNxlirZ6k0a1koRK3mQ6GWXzoT3K3JQ0GIlAmyA
   n2OoeD7zX+tYUC/NfCNWQuuj9nLNtJx9D/SvQCPMseGWr50dn7rwX15cs
   I6d3V2MOjyYR4u/wtLtDxyaJpZTycaAO9bQ2C/v81aMGvX5l1sHdf3aF+
   Zd+tGHnqkwS8VrVTj+Gz2+5mUQPacApO0taGzCFbe5b73b/+SwSID5s1t
   w==;
X-CSE-ConnectionGUID: DUMbdK8/SaenU7P0UarA2g==
X-CSE-MsgGUID: M8YZm4iXRl2OQw12DxOEOw==
X-IronPort-AV: E=McAfee;i="6800,10657,11655"; a="71201188"
X-IronPort-AV: E=Sophos;i="6.21,185,1763452800"; 
   d="scan'208";a="71201188"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Dec 2025 03:07:35 -0800
X-CSE-ConnectionGUID: MVLGsaiPRJ6/gnSPVAcq/A==
X-CSE-MsgGUID: XZwzfeB8ThGP1w9D0oiBwA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,185,1763452800"; 
   d="scan'208";a="200892961"
Received: from fmsmsx902.amr.corp.intel.com ([10.18.126.91])
  by orviesa008.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Dec 2025 03:07:34 -0800
Received: from FMSMSX901.amr.corp.intel.com (10.18.126.90) by
 fmsmsx902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Mon, 29 Dec 2025 03:07:34 -0800
Received: from fmsedg902.ED.cps.intel.com (10.1.192.144) by
 FMSMSX901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29 via Frontend Transport; Mon, 29 Dec 2025 03:07:34 -0800
Received: from CH4PR04CU002.outbound.protection.outlook.com (40.107.201.48) by
 edgegateway.intel.com (192.55.55.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Mon, 29 Dec 2025 03:07:33 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=s95WpuT2mOq9/WcrQcM64mCSpoLxo/ZodcMTPSu6XzcCOrS3p8IT3FCr63DIZHdA4KWtB3dklNuxsn2PKIGxUbJgUP9aH73Jmo+3IltKOfmyl/h8i10FjIcFiUiVU9Gecx7nt6U/OrwZ7aHkqnIC9cT8hOQURzXtZks5cWpgq8E2+NyDayQlwCwEGsDtT1hJ7fpovaQLoqo2NtmLB+vdWaAgYHrBzSOZTVjVPbjmrB9vhK2w8tdWOLJOBCtv3pzj83klCUWsmULbl8tfejFq2c/AkzrLMD9Yhe8tYVpyPYJHNy8H5zqqAbwXPX0jSc30vZ1HU6cuHP6jcWEbMQRcwg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fIsnnDU33OOlBToIIFI/9a3YRoJ2ob+qwaPFLs93VS0=;
 b=MB280/01HpGk/pNAr2TkHdWu4LzNAlmm2KoG0kELQDnvwPap0dDTMJf94p5VNIYO1WaZgL7150O447IVhvIrNQXJvcrtk3bTQ0moSO3iXfVpnmOSTrudISj73KeQqw0PRtSKFKhNf4nm6w76MAxwfScD88X7nqEg+IPx53kKO6ySa+18ywwzQGvmOy7xAKeqCMvgImhBXwUoMFs+bXAXf5t7w8vQHUILVUMCsOOesKnyhqLK+6WEYKRD5uc4LHf6iOnQnj1FIOj0SFK+fvr92CRdyIdrd1v/XrIXQlf6Is1Dqo0hByrCK0OTB1m4i+ggKSDXHru0n5azXMhP9h5gTw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CY5PR11MB6366.namprd11.prod.outlook.com (2603:10b6:930:3a::8)
 by PH7PR11MB5796.namprd11.prod.outlook.com (2603:10b6:510:13b::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9456.13; Mon, 29 Dec
 2025 11:07:31 +0000
Received: from CY5PR11MB6366.namprd11.prod.outlook.com
 ([fe80::22af:c9c9:3681:5201]) by CY5PR11MB6366.namprd11.prod.outlook.com
 ([fe80::22af:c9c9:3681:5201%5]) with mapi id 15.20.9456.008; Mon, 29 Dec 2025
 11:07:31 +0000
Date: Mon, 29 Dec 2025 11:07:24 +0000
From: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
CC: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
	<yosry.ahmed@linux.dev>, <nphamcs@gmail.com>, <chengming.zhou@linux.dev>,
	Kanchana P Sridhar <kanchana.p.sridhar@intel.com>
Subject: Re: [PATCH 1/3] crypto: acomp - Define a unit_size in struct
 acomp_req to enable batching.
Message-ID: <aVJg7Gov5rWKOfVB@gcabiddu-mobl.ger.corp.intel.com>
References: <cover.1766709379.git.herbert@gondor.apana.org.au>
 <9565daceae6efbac8ba35c291e7f9370ecfc83d6.1766709379.git.herbert@gondor.apana.org.au>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <9565daceae6efbac8ba35c291e7f9370ecfc83d6.1766709379.git.herbert@gondor.apana.org.au>
Organization: Intel Research and Development Ireland Ltd - Co. Reg. #308263 -
 Collinstown Industrial Park, Leixlip, County Kildare - Ireland
X-ClientProxiedBy: DUZPR01CA0023.eurprd01.prod.exchangelabs.com
 (2603:10a6:10:46b::17) To CY5PR11MB6366.namprd11.prod.outlook.com
 (2603:10b6:930:3a::8)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY5PR11MB6366:EE_|PH7PR11MB5796:EE_
X-MS-Office365-Filtering-Correlation-Id: fa0f0c44-d3b9-40b1-a21b-08de46ca760d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?Ru3Op93qm5ws9cLYoEjPR77/9v3kBTNDDI8UGjNg/wQ9ie1aDLGkmnO3zsGV?=
 =?us-ascii?Q?ycF3G27ceLIjJScFkiEXgenOZev0hA+ms14lM/c3ybRo9KuduJ0adHHrZUft?=
 =?us-ascii?Q?MhPi5sSU4r+LMbXLPrMBhYHeGp1KaRKOh3BFir9M2RlpF1dbE/yjtrWTSInN?=
 =?us-ascii?Q?xKwELIKI2rf7Or62977Q05WzUnJZiE1UQi+B0NabQwjkq96gU8EjayM2ZKCJ?=
 =?us-ascii?Q?0R0klUSQk4/xf5LqEKm5lDta6BQ9KP8tuyDVVBXMexy/t4xRcpbaGylfB2Qm?=
 =?us-ascii?Q?N5r+WGhuQX5DAfmjIp89Xnn280vCME9xr2BGaFv0pGiGmEn8boAJ8oXG0OHE?=
 =?us-ascii?Q?khqcg1k8k9bDQ6gMbFvgih9D1DdXQDKwJBbP7JiKCH2scTn9z53/hjptk8cW?=
 =?us-ascii?Q?j2fWh1LZLdFbTL/hvMYPwyT5iwVRQyX8Z826EK8F+IkwEdVkwlZ5n7rqhjeM?=
 =?us-ascii?Q?3Kode/c/GOiive+XoV0DqCRme7Qpxrnd8F9NfHMWXMGo3CBGn6z/i7B+lV5w?=
 =?us-ascii?Q?wAgFrZ9y5o30I0ma5OTXbaTBUC6jT6znbDLLkyBiSrvajohCEFdyGsodREZF?=
 =?us-ascii?Q?d1mG2bDlHup4cdOZ5V4vggZXMej3TpDLk6wwcRM+WZ4cyqyhmBN8IgN5FCY1?=
 =?us-ascii?Q?2o74p2axJRObuMfsjTW4QTgASiZXc2ti2cKrvLG+H/WkxoxVdT6vquBu4cmw?=
 =?us-ascii?Q?pAsHiYZQbwCsF8lZ6PyK67KV3sUzax/1Tcb0YdIXvxHPGvydKEfbFIfZ8NX3?=
 =?us-ascii?Q?TM95czerEe93sXBVcEqyr2Lq3wH1q4WQ5XFLF4StSchRn4bx8urFou8XVDL7?=
 =?us-ascii?Q?vLFm/wm65PBLCKASju+YWwfJJ9CRNfgc2uiVKNRssS7RFDZT18rfcidYgq7q?=
 =?us-ascii?Q?8DQKRzqZZ2Rp43qFLC4qwhFyN59RGjZhqKJqOEq03MyDyw8S3w5uu1LIDyIO?=
 =?us-ascii?Q?ou1RF/nJooqbSTjq0uGLJpSg1OE9EBF5U1wU1jLCwiCZf3U4xRr+iAqQeDWr?=
 =?us-ascii?Q?jRPDMi5wxRuX+PX/jLKOwsiauXRzQBBwodbToCiyzlPkXP8U0ENp/iuNs/84?=
 =?us-ascii?Q?XuurrEe9oB4E0zFXg9o+8X2GN5uxS765cr5L+GqfX82/8CRJvnqix7ldTWO2?=
 =?us-ascii?Q?OE+w+sCdSfjf2iJDH719QL5m40MpmpJj3Bwj9elZZLt3oxmIFOFhT58iIjuy?=
 =?us-ascii?Q?USG0nYTim048Ji3CQ8se3scL64VCHsaTx9MOuX+e8Vq+1cMsm+P4iBQTEYNf?=
 =?us-ascii?Q?Ys8g1ZvVeu/pN4GylQrUfKk7WGv4HJ64XCtpl99N2bwRWLiNrZcuHxWzTt/f?=
 =?us-ascii?Q?SYfCjNae5olRBTSDu2mDmc9CBWWrxUICZ1cMTx+u3+SE9+yYuyDwF77dB+mL?=
 =?us-ascii?Q?y9SG1mQr5fRgKETft8nr0qK/Lcx3DSOUjiUaKxXg40V3DrOqAcYPC0RrsAn9?=
 =?us-ascii?Q?w6KaYttlQe5F/jRdDd5b6VcWyxZFgFmb?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR11MB6366.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?FQdUoWhLS/gcU4rQdQ4vCKE8WmWuVqD5gfdzZKLEORPLEOgKECrtHrYoqhvX?=
 =?us-ascii?Q?zn+3A8GyST815WK5VOQCz4GfOnx0HABNxPflmD0c7bH+1sPckSn+NYG4z27w?=
 =?us-ascii?Q?nYowHpHUxgZtDqRU6FALPQ7KuxDkb9mXo+nVYOMcB0mLEdvtESu41Rjuqslg?=
 =?us-ascii?Q?0dRMiZYsq+Get2apymOC65nxP/RH0SRae5shZFAOnMWanFNCwrVmZrdxOGFM?=
 =?us-ascii?Q?QS0HvusgL7gPDfXcQsx+BmVcjQNx5ve9bO9pjCH8F4nts3p7QJdb9X/mzwBe?=
 =?us-ascii?Q?uoPBEhYYq9JF9qxxiIH7ekJ9z38LMOf8xSkM09LDgAHZL3RUVu6WNuc4hU6/?=
 =?us-ascii?Q?ZbIqUxG8bVBIbFP71cQEdBhRAIhws3TVNI8Tg/FY04duSRYcsXpA1d3zE3yu?=
 =?us-ascii?Q?xVhw/NTAAwhbSKR1+RcrDIC2/esPgN/fF3fN03HSUcAZu9NAYW+hOiZkvzO1?=
 =?us-ascii?Q?zAg3Gex97uLlydqx3c9GxM5EkOmdXhMJx+RSawFIGv7kZoTHLELIEcO4z2/m?=
 =?us-ascii?Q?mSd3VmFgHIh4MCT+KibWUE1GvKObyeS9yOCUGYM2BDPoyVDgM3ZXOMVxeKu/?=
 =?us-ascii?Q?ddIUNPRBD1USWRA1202OTEG1WOIWBQONaCKhZy0NnY+cFs7Uv7eNGd5lYL7l?=
 =?us-ascii?Q?2i0JtMrO4q8hOKtIOuFb1+ua+kZd/EykafNF6PQqn5iEKemKX2dBLFQFy45A?=
 =?us-ascii?Q?Bo99M9D8EqiMKwsQc42VmnyqGCBikAXfjoX00RjVc1sTxwxA8LqIp16GcwcG?=
 =?us-ascii?Q?PhmDO44Zefixs/gT2doVqr5tbxUGNy+InR4tG8sEDv/utJjZ1CV0AyHq2THx?=
 =?us-ascii?Q?vPwSL2fwxW62TjPb6evNdN158VmesPdl94Zlpzmnwfa7tVB9ns2bDr/6C5s5?=
 =?us-ascii?Q?VyZOKEwilH/QRyNV0crz+tBCvS+uLvAyhX2CX76VOtZQkRMozrZlT607RvPq?=
 =?us-ascii?Q?iBPn66lAQULHlTeIPob4Bdu8eMZoDiA0LjCDM9gwIa3EHcx4DDXxJNE1s/aR?=
 =?us-ascii?Q?NiF9Hhhoa9uI5UdeRH0Cw2v8H4e3LgKsQjoEI5ZWJ/JWqKHgAB77O5Nzo1VV?=
 =?us-ascii?Q?rOWXOkaXae9STLZUviv1qJgCooUp3BVBJu36zCIYanVLXuPxXMcCYSqae61R?=
 =?us-ascii?Q?56RGlHDT0kCTvbM97oPD/WrLi1qmEYBVWAj+iS6cjObNQ7GVQj1g+HRxPVO1?=
 =?us-ascii?Q?ABxx6HOusOaSM3K+g51Umv43PNpb3knx5aKn/n+VIclE/jcxSZI6xd8IYFPQ?=
 =?us-ascii?Q?fL3SfHFEgfdaE28dLsryJcVF1Bs2egMzMt19qLoPDR/v6H6vT/gQ+7JsxaeC?=
 =?us-ascii?Q?zKF+ra/8aePNcUsUU/nlkRO0NTCnLk8AKcCKv5PFBxiNYGva7N/RLQSP3w+c?=
 =?us-ascii?Q?TnaXbIkrLvP26Sm+3lv8QMAwVNJjvnQ3U7eszL8N3OvTpnCWb0NPlNPCbYe7?=
 =?us-ascii?Q?qglBb6zDobc3gYjzACk8hGEx72KcTLJbG4HfHAYDfApRlk4nLO5DIV4StsTK?=
 =?us-ascii?Q?/+0C5xbLgmHpaZ5kSGtaRK2ZilKqJnUWdAoRft8UQegRqZ+M5RNIAGMqRMYu?=
 =?us-ascii?Q?oli6/waI6hFlUOjzPF1MAbkmjgi/aKDBe8a3Ll6lBSLVEftU5PI+A2oq/0Qj?=
 =?us-ascii?Q?p+C+MuuoaB6KNsXNKpFeRr6W6vIUfrNswZvi1ifWQMUUBRGJKNh3zYoQO1Ee?=
 =?us-ascii?Q?Xkuy6R3/P21eSnVPVB0SikeJi9XUxU6LaBLbtrOKWOvZffHPuZxtOUROUc7E?=
 =?us-ascii?Q?I16QQqhfVApBaI0d2dog7ogHHyjjsBg=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: fa0f0c44-d3b9-40b1-a21b-08de46ca760d
X-MS-Exchange-CrossTenant-AuthSource: CY5PR11MB6366.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Dec 2025 11:07:31.2525
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: X9feUHxtFSifcP8SmKXKV9k+oPQQNQcaA4ZqDUiiOiDCBWSvKbwebwCT8MobQ4cktJVD0l68/xMbgXTWSwRDMIY/guue9XCVldsv7frnF/Q=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB5796
X-OriginatorOrg: intel.com

On Fri, Dec 26, 2025 at 08:38:25AM +0800, Herbert Xu wrote:
> From: Kanchana P Sridhar <kanchana.p.sridhar@intel.com>
> 
> We add a new @unit_size data member to struct acomp_req along with a
> helper function acomp_request_set_unit_size() for kernel modules to set
> the unit size to use while breaking down the request's src/dst
> scatterlists.
> 
> An acomp_alg can implement batching by using the @req->unit_size to
> break down the SG lists passed in via @req->dst and/or @req->src, to
> submit individual @req->slen/@req->unit_size compress jobs or
> @req->dlen/@req->unit_size decompress jobs, for batch compression and
> batch decompression respectively.
> 
> In case of batch compression, the folio's pages for the batch can be
> retrieved from the @req->src scatterlist by using an struct sg_page_iter
> after determining the number of pages as @req->slen/@req->unit_size.
> 
> Suggested-by: Herbert Xu <herbert@gondor.apana.org.au>
> Signed-off-by: Kanchana P Sridhar <kanchana.p.sridhar@intel.com>
> Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
> ---

A few comments below.

>  include/crypto/acompress.h | 36 ++++++++++++++++++++++++++++++++++++
>  1 file changed, 36 insertions(+)
> 
> diff --git a/include/crypto/acompress.h b/include/crypto/acompress.h
> index 9eacb9fa375d..0f1334168f1b 100644
> --- a/include/crypto/acompress.h
> +++ b/include/crypto/acompress.h
> @@ -79,6 +79,7 @@ struct acomp_req_chain {
>   * @dvirt:	Destination virtual address
>   * @slen:	Size of the input buffer
>   * @dlen:	Size of the output buffer and number of bytes produced
> + * @unit_size:  Unit size for the request for use in batching
NIT: use a tab after the colon for consistency with the other fields.

>   * @chain:	Private API code data, do not use
>   * @__ctx:	Start of private context data
>   */
> @@ -94,6 +95,7 @@ struct acomp_req {
>  	};
>  	unsigned int slen;
>  	unsigned int dlen;
> +	unsigned int unit_size;
>  
>  	struct acomp_req_chain chain;
>  
> @@ -328,9 +330,43 @@ static inline void acomp_request_set_callback(struct acomp_req *req,
>  {
>  	flgs &= ~CRYPTO_ACOMP_REQ_PRIVATE;
>  	flgs |= req->base.flags & CRYPTO_ACOMP_REQ_PRIVATE;
> +	req->unit_size = 0;
>  	crypto_request_set_callback(&req->base, flgs, cmpl, data);
>  }
>  
> +/**
> + * acomp_request_set_unit_size() -- Sets the unit size for the request.
> + *
> + * As suggested by Herbert Xu, this is a new helper function that enables
> + * batching for zswap, IPComp, etc.
This sentence should be removed. We shouldn't be mentioning on the
documentation that this function is new or who suggested the change.

Instead, explain what batching actually means in this context: that it
allows multiple independent compression (or decompression) operations to
be submitted in a single request, where each segment is processed
independently. It would also be helpful to clarify that each unit has
the same size for source and destination, and that each segment must be
physically contiguous, if that is the case.

> + *
> + * Example usage model:
> + *
> + * A module like zswap that wants to use batch compression of @nr_pages with
Pages or folios?

Also, @nr_pages is not a parameter of this function. Is the usage of `@`
correct?

> + * crypto_acomp must create an output SG table for the batch, initialized to
> + * contain @nr_pages SG lists. Each scatterlist is mapped to the nth
> + * destination buffer for the batch.
> + *
> + * An acomp_alg can implement batching by using the @req->unit_size to
> + * break down the SG lists passed in via @req->dst and/or @req->src, to
> + * submit individual @req->slen/@req->unit_size compress jobs or
> + * @req->dlen/@req->unit_size decompress jobs, for batch compression and
> + * batch decompression respectively.
> + *
> + * This API must be called after acomp_request_set_callback(),
> + * which sets @req->unit_size to 0.
This mentions a constraint, but does not explain why.
Explain why this restriction is needed.

> + *
> + * @du would be PAGE_SIZE for zswap, it could be the MTU for IPsec.
> + *
> + * @req:	asynchronous compress request
> + * @du:		data unit size of the input buffer scatterlist.
> + */
> +static inline void acomp_request_set_unit_size(struct acomp_req *req,
> +					       unsigned int du)
> +{
> +	req->unit_size = du;
> +}
> +
>  /**
>   * acomp_request_set_params() -- Sets request parameters
>   *
> -- 
> 2.47.3
> 
Thanks,

-- 
Giovanni
