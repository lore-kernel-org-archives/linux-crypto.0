Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A8D33B1B3
	for <linux-crypto@vger.kernel.org>; Thu, 16 Apr 2026 17:04:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.19
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776359052; cv=fail; b=YMEcDyT5LtC33UF+oWt6OuZ3Xk3TLaY5H0604tfD6nYkGnvjPAW9cvQl8syDduQs+5hNTFJ7He1E2R71JhThcQsCaXgyF9259cDeHVHwFpcKHiZb5Ckcze4H2PxKvrPTl9X6/eqMFZ1jaO0hND3tFwBP61hl3M6VUlsrqu06B8c=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776359052; c=relaxed/simple;
	bh=VQcvK7v/0JAhFyv/jJKxBudJtqZQMYauWVAoCJR9TNs=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=MsxMg3jy5aIgHopO6tGNRWWC3dZ7LM3QIui1O8kLNxGCpj56NtNaGeTauLJAAcF0YfDoFlFh/eQmHa7w3g6XIsulDisEDG29g2x0UJma6pUnKl+EkwZ+/ajlqqv6Hs3XXz4hxqrRCNSF4LQkQQSvAE9vNadVo7+grLnT80wvEnI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Z8XyE7P7; arc=fail smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Z8XyE7P7"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1776359050; x=1807895050;
  h=date:from:to:cc:subject:message-id:references:
   content-transfer-encoding:in-reply-to:mime-version;
  bh=VQcvK7v/0JAhFyv/jJKxBudJtqZQMYauWVAoCJR9TNs=;
  b=Z8XyE7P7NtXDXMCjDp/XYO1keGfM9bS3pp8u0RZfT/MzA8KgD8OLyhES
   zK4S2EQ6dG69QBrQtD/YHityffpSHuEfUR5Ys2uBU1voRfyoMV6uotbaN
   DuBnDhxB/1mxVseaFTsYqAdFV1MM5bicXRl8ZIbN/bDTEB0tvqPo5BnUk
   paYrptxf2SqgoVL6hnlNanxdun1gn+UDXiQ58ZzqMzDCSa7U1Te5BGIL4
   aXcrmjAjEHJmwKXgeEqgjzlLGKPR6hCiDhlewAu/EvK1vQy4zS1kmqoqw
   1bk1CWaBj/L2+DTFCv9H6ySEXh/aHCTUWCvugr8H3RpsLGGQHeRIpHtRR
   Q==;
X-CSE-ConnectionGUID: UGCiryO2Te+8Wk+xzB6PQg==
X-CSE-MsgGUID: /mytPX5BR3aOo1QEb2snqg==
X-IronPort-AV: E=McAfee;i="6800,10657,11761"; a="77274699"
X-IronPort-AV: E=Sophos;i="6.23,181,1770624000"; 
   d="scan'208";a="77274699"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Apr 2026 10:04:10 -0700
X-CSE-ConnectionGUID: iyAp1UsnTzujuKUJJBW6aw==
X-CSE-MsgGUID: H548seQUQW2OiqugA062Ag==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,181,1770624000"; 
   d="scan'208";a="230652778"
Received: from fmsmsx901.amr.corp.intel.com ([10.18.126.90])
  by orviesa009.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Apr 2026 10:04:10 -0700
Received: from FMSMSX902.amr.corp.intel.com (10.18.126.91) by
 fmsmsx901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Thu, 16 Apr 2026 10:04:09 -0700
Received: from fmsedg901.ED.cps.intel.com (10.1.192.143) by
 FMSMSX902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37 via Frontend Transport; Thu, 16 Apr 2026 10:04:09 -0700
Received: from SA9PR02CU001.outbound.protection.outlook.com (40.93.196.28) by
 edgegateway.intel.com (192.55.55.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Thu, 16 Apr 2026 10:04:08 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=KkArm0CVVeOwE+IhSkFXQUcHZ54vd/+Nhf4rDBMUKEr0WQKUXCMN9wWV2vcTup8+fwH2DZTuKngoZbjlE89B4Xa0IsTa3fGyrkux8YMTM833p42KbGS/FYt3qw2bbWWnjUaAVa/PIblxora0BLRdGcAt2pk0oRP+L7dzW2YNyLq8/CHkQk9SViEwMBav7+h+tHILph542HTkVllv6VrfAGL15WoC+46DwjQtJXQWvHN1PQjIQjvIOl56tZiLz/WbdkhbuF04JSQJMpzSYM54gDtBi7zPKrqxkZLjBuj71J4ITyWPAKMSMOX9TqQSRaxX1AZLttNhO2fpFrz0DqK09w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=n8nxm4Zh4d2CVktTAfli1m7MhRqjJoxG5MoGfnCk7gI=;
 b=jq9YQ5xn55K+gSxMrGogkpzAgzaonawZzvfO7pMPm2pMaGRFuuk1v8jab2pI7A3rF3OgR+F4H9WIcbv2F3+c7NQ3327EZnBuYBN6Eahw3HLusoZS+Q7DXxQ5r9kcWt7wIB5PTMdY9b8o+KDrgZ20foHjDd11gjjzLiYht7BZ53smYTY7QeSN7utvglU+CVAeS0mDi2sIIt2mlCrSJXSo7grVjpF3SbY1H9iNfkIoicVogfya3NbQtZJ1lcXANtyUMoansl9Ho2I7/bH3zpibQRP+SMb3DU2BaBZ0zoAjysY7KaEtfUPq0mSgORy6CxKvzvmK7LnPUgRopIz7HS685g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM4PR11MB6407.namprd11.prod.outlook.com (2603:10b6:8:b4::11) by
 CO1PR11MB5074.namprd11.prod.outlook.com (2603:10b6:303:97::19) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9818.20; Thu, 16 Apr 2026 17:04:06 +0000
Received: from DM4PR11MB6407.namprd11.prod.outlook.com
 ([fe80::26bd:1704:645f:7fd4]) by DM4PR11MB6407.namprd11.prod.outlook.com
 ([fe80::26bd:1704:645f:7fd4%6]) with mapi id 15.20.9818.017; Thu, 16 Apr 2026
 17:04:06 +0000
Date: Thu, 16 Apr 2026 18:03:59 +0100
From: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
CC: <linux-crypto@vger.kernel.org>, <qat-linux@intel.com>, Laurent M Coquerel
	<laurent.m.coquerel@intel.com>
Subject: Re: [PATCH v2] crypto: deflate - fix decompression window size
Message-ID: <aeEWf4j+VO0FziNj@gcabiddu-mobl.ger.corp.intel.com>
References: <20260326100433.57324-1-giovanni.cabiddu@intel.com>
 <ac8I4mpkdn8uy8TE@gondor.apana.org.au>
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <ac8I4mpkdn8uy8TE@gondor.apana.org.au>
Organization: Intel Research and Development Ireland Ltd - Co. Reg. #308263 -
 Collinstown Industrial Park, Leixlip, County Kildare - Ireland
X-ClientProxiedBy: DU2PR04CA0229.eurprd04.prod.outlook.com
 (2603:10a6:10:2b1::24) To DM4PR11MB6407.namprd11.prod.outlook.com
 (2603:10b6:8:b4::11)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR11MB6407:EE_|CO1PR11MB5074:EE_
X-MS-Office365-Filtering-Correlation-Id: 728ab44d-b0bf-46e7-a7c1-08de9bda2ace
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014|18002099003|22082099003|56012099003;
X-Microsoft-Antispam-Message-Info: 2Kn8BtJK4n+PpzZr8iS1UrSVRvpKTYGUOC9diJyXpDrro92/a6M3Gvs0YxRtx9WW5Id46/lQd1hgZOcqyIxiXiwic+aBNTQVSNNKuYuPzFy3xV9Qe9SpQ/4LzoogZMVYQ8bG+27pZRtqJ60WpgI2qqM2JfQBvXbqgujksLTBj9uDiExaz7iOjkB+wkrjvJCCIx09iYwkc6GOPj5cbkdiUJTkvmYRiMKQSMPIlw1qsLOk8/xQGP48w0+W3j5s8LPTsLqYXJJdijR0Fw7XGLazyMdj0nZq2YaQND3ZnA3Razb5tQwIKoGM64QEtY9i1X7J0L4jH/S5mNzBDtHO0JKQM9tTUm2jNho9+OdHjF4t/srTI7jkq9+n3IdqRQ1Iq+7h/q8yNJBKG43Y6nVOemPMeEn7AFUN6fY7VPMuiP+ncnYSenW6KIRXWIm0NfnDBI0Aer7AfwuC3BxOduhEYuoaQyRvd3O7j0iE/uOl8n+HRkwQN4rNNDM/ajxlylRYIsVQ7h9Sm7EBe/qcghUEXRW9jnczh/KnMA7N9ZB4W7by5ic46IAKS2ihP038mABF2lVuUPvBvlgk6Tgyu/Wv8V3Ik9MalrjLdVdtbiAdH73OlE/hV/zNDUF4w2GczjP49NkoLg099IjoR7xVtHlcI8rLjIre0B991F+mchjw85BGIZkzs/DZWzvfxRhdmfzSho+XQ5IoHZcElanwN1xcE3zzuPgWIpo1S+xiuQnVgQi3v3o=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB6407.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(18002099003)(22082099003)(56012099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?iso-8859-1?Q?ufVTGz46/0829fejv4jmHUEs95+p2OqlLJjiK7mLVFWRrjhIaaYLa4hj6X?=
 =?iso-8859-1?Q?hBXX+jIfrvV1/ad7KfFWOnQpObusLCwm3XCMY8jj+6NDPjSM+cxK0dYu4C?=
 =?iso-8859-1?Q?dfCWCvxJDOthzx1r1UexkHnSanXZV9/glkw3QXpzUdOi437msdrRMJ4DBM?=
 =?iso-8859-1?Q?BdB0aglyl7pwiqOkVDW+K9oS/vO4aA7ZasERLYjTpNSbWIaXUud7iE360X?=
 =?iso-8859-1?Q?jQ+9DyDy7RNw+gAOy1Z8iDAqe9HMdNjD8oO7nNT8B257NrVnSkBgqaD95S?=
 =?iso-8859-1?Q?/e3BkTrSZuNJvRStDIHLIau3xbPZnTtnLo8CX+RE9YHUCy0PxO0+qyHCEd?=
 =?iso-8859-1?Q?kaCySJ42glgVJUn3s/74qFvFP+jCBpT3ghlZnlI1x8Tfdl0xi40qY2YlB0?=
 =?iso-8859-1?Q?cz00ncYgmdZYQ6phAEZEBLghexi80U45lvZF6aBZqbNfx+oDHxrY36p0PR?=
 =?iso-8859-1?Q?pnTGXpd0CN4GC2FRs0tephp1hDZ0AEfQ1yTbPwtT2CK1bbmMSayaB5cHJB?=
 =?iso-8859-1?Q?xPOIl3CWDnyloQrj0dLHxapUTgOl7Lirk+jQtv+nKrqFHoaq2EgjsOyU8b?=
 =?iso-8859-1?Q?gc68WL/qskWljD+/wQlGp3f/ZzBXq8WG2mE0bC8eg25OEmCGZThI18fDB1?=
 =?iso-8859-1?Q?6hqdsg6vSpLin0+qzKcdsaaq3sD8eHPb5UVuB9uoNdod2/u/XRzJoDmi61?=
 =?iso-8859-1?Q?Gcjb9iD+lpoU6SViC8tM9EVsO5yuZaaO+Da+KB5gACU+xJb3mt4Z1KU4iV?=
 =?iso-8859-1?Q?eBHFjYt+oAmLK/GDJCXGkN/BMTSUXD/EOfcedwdAp6akxliKvdoSOGi61z?=
 =?iso-8859-1?Q?Irm6is194z7enYUMmaksXkokI7IRq34LQnhsf/eEq6ty/C6zjzEo2ghChS?=
 =?iso-8859-1?Q?MBSoOTama7pSjoWcqQMq8cA4gm7SKThsuqsGvd5KyP8yfC4WbLMqBIkS2F?=
 =?iso-8859-1?Q?N2mo1Tncivv1TDR0f70cs0jX9YsKTGSvCt6RgeLQ3PPVx9ZQPwVF0rO9XR?=
 =?iso-8859-1?Q?TLLJk2ZcuLOhxuWbSBKj2E6g6qXiM4dCB0zkd34i32wSaEQhtWCgED7RE8?=
 =?iso-8859-1?Q?T1wwYACubGXvSNGf7WR1uGfihfUfQEYyt+E8MQdNjxxDCOp0b4PefE2LDA?=
 =?iso-8859-1?Q?sE5udjOpIXR3+OeI0P3Otiq4RTBUYZIJ1lobxTQ/Up4niX8ncVN1vWMdto?=
 =?iso-8859-1?Q?nKmYjqYpJc8QLWPo2ZINo0TZdi7kMxqVru5cV/sSzufgNRv8GmzEvy8JmO?=
 =?iso-8859-1?Q?meL0R1UvmNM8rcnEYQhL13Ky2ELSE1pCLo9r2SnEDey+oDuhpeJm8D4lsQ?=
 =?iso-8859-1?Q?THr+qUFBcMQbFFWvzjW9tWg3RgwtYcwaZWddr7mpP4pJ8DwvzNujq8+//H?=
 =?iso-8859-1?Q?4YpDJeRAaH8mC3J5YqODMpbmrzAC8qc3GZdb1CickcRAfe1u9lMBfhV2/O?=
 =?iso-8859-1?Q?DUCfDCjWvzs6stLSjznr2ofZrMBaQcgmsUGOCZS6udwjXiP17S8W1SglK4?=
 =?iso-8859-1?Q?aZyRHna9aFGL67Rtcd5Gxcxmv4Dvdy16XMcBhwYy5aNnaJ3wK+n2VWhAD8?=
 =?iso-8859-1?Q?VUE8CBPECdf/UjILzCTlYHHJtL3gLEk4YciEd8t448n1uXlCYM80VxSdui?=
 =?iso-8859-1?Q?CcYcERQ/dtS5SeTwWWw6LxS39b9RYF7jVO7SPsCo+el4jB+E5K32sUrkb/?=
 =?iso-8859-1?Q?9Bs8nAW1w6WStnNVPJETsDQa7kno7sz4HiafeH2NX5SoIpv3wPif10sPq0?=
 =?iso-8859-1?Q?b+Nu7qyzYsTH5pozi26tYb16Pbvbo2S9ILj14aYT00zaW/dAecsyUWp8XD?=
 =?iso-8859-1?Q?7d246on3SaTK1Lfeiv8WSXEuYhej2CM=3D?=
X-Exchange-RoutingPolicyChecked: fjy6rrbzFqNYOk1KkCgG4TWz5/qIbHda4k700tXjvb6rGeHOBtkJNzSCkOmHP0jFOBXDBTiHTulk9MBkK3uAdldIc6bsmmxtcC2IhGYlZtaRD0bPAazH3NX9hMDPqG02F/YX2yrDIti4A2HvediIr0akIx8ma3Smanm2r6/T4DqBXTE61n98imExbyeepUoxGvtNZSVbuVssI20HPRMcKUUWzPvURQBI/EiDvPJh75asTjzu8Pzuy0EoKz80eqfsQxk21E3g95YUw+UlSquPohIxFCkqJq/ypR7iRXyp7W4HBDNvHBfTOceat3fNGsEGvkRsH//7L/1SCsOq5Dlntg==
X-MS-Exchange-CrossTenant-Network-Message-Id: 728ab44d-b0bf-46e7-a7c1-08de9bda2ace
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB6407.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Apr 2026 17:04:05.9718
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: JDpzU57Ql7vOk2HsMqp+xB579/9LeZ7B5QicS+FY73UZDvygTND8BDp70Q81LGT+QxfR5BXhT+xcNN5QdUePKp4wU+Y/1uckkM1uBLc1rto=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR11MB5074
X-OriginatorOrg: intel.com

Hi Herbert,

On Fri, Apr 03, 2026 at 08:25:06AM +0800, Herbert Xu wrote:
> On Thu, Mar 26, 2026 at 09:59:22AM +0000, Giovanni Cabiddu wrote:
> > deflate_decompress() initializes the inflate stream with windowBits set
> > to -DEFLATE_DEF_WINBITS (11 bits, 2KB window). Valid raw DEFLATE streams
> > allow window sizes up to MAX_WBITS (15 bits, 32KB).
> > 
> > Data compressed with a history window larger than 2 KB, for example
> > produced by hardware compressors such as QAT or IAA, might not be
> > decompressed by deflate-generic since the inflate stream is initialized
> > with a 2 KB window. This might be seen, for example, when
> > deflate-generic is used as fallback.
> > 
> > Use -MAX_WBITS when calling zlib_inflateInit2() to accept all valid raw
> > DEFLATE streams. The inflate workspace allocated in deflate_alloc_stream()
> > is already sized using zlib_inflate_workspacesize(), which accounts for
> > the maximum window size, so no allocation change is needed.
> > 
> > Fixes: f6ded09de8bd ("crypto: acomp - add support for deflate via scomp")
> > Signed-off-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
> > Reviewed-by: Laurent M Coquerel <laurent.m.coquerel@intel.com>
> > ---
> > Changes since v1:
> > - Updated commit message to clearly state why this is needed for the
> >   deflate algorithm (i.e. allow data produced by HW compressors with
> >   larger history windows to be decompressed by deflate-generic, which
> >   is used as fallback).
> > - Updated fixes tag to point to the commit that introduced deflate
> >   support in scomp.
> > 
> >  crypto/deflate.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> What happened to the parameters patch-set?
I'm reworking the acomp/BTRFS set, and that will be included there.

> Wouldn't this be something that should be treated as a parameter?
I don't think this should be treated as a parameter. A decompressor must
be able to handle any valid DEFLATE stream. RFC1951 (section 3.3) [1]
states that while a compressor may restrict parameters such as window
size, a compliant decompressor must accept the full range defined by the
specification.

In this case, deflate-generic does not accept valid streams compressed
with the full 32KB history window, which is why I proposed this change.

[1] https://datatracker.ietf.org/doc/html/rfc1951

Regards,

-- 
Giovanni
