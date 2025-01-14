Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF617234CE3;
	Tue, 14 Jan 2025 11:51:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736855463; cv=fail; b=nLj9BgavbTp1dSqs4dxX3cU9aqhxlkyLfp+6RyGjwOd9zYj6akN6GcMdiK8xNQwCkaq/CR5ZFoR/V1RVldogOLpNPdBvLz3SmiquUYR5NabKkovGFLjzxi+u8VEfpsdQdv4W2cKp/W2UM7l/jFL+IDJgxI70/U+8f7L2ulA7HCI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736855463; c=relaxed/simple;
	bh=QvRcGyZ4/4XcdmiGnGHXGbbUKrZQQl4e2C9By4Hx22s=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=o0nI2+afL5A3FJaht68XaYBdwmKsrZYwXiUnBS8vfss+/7xnRi/38Q5Zp6+F5BR6wXHRxw2B31ieYZzMlM2GVNTAC9ADmpqlLMmTDyO1MN+TCUxUHdcrcYtJWPT246WJlZqfHt2wufkF8vDQegbl//lf7tHrfTdIAv96qSp0N0s=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=hKJFySpU; arc=fail smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="hKJFySpU"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1736855461; x=1768391461;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=QvRcGyZ4/4XcdmiGnGHXGbbUKrZQQl4e2C9By4Hx22s=;
  b=hKJFySpUsXc7y9RMfFQnAE2MdNOnJ4cl9m6TCe+8MFRNfdlVGdZRnUPx
   y3JuhSVhcNsJck27rx8/b/QiWxzWdH0alhBkeI0nqy2Kths/wudTQiiVj
   nJkS87WEdZrYdS6qsBCLZi+Nf3mhjOjbiYHiecLi+O8EhmvgJryDBYPlB
   InYLFrRwlklhibp0uM+ijfv3uyDSMALCE9ATS2clrcYpDAuYBc6xNMH4a
   n7sCd2oJusYKrxCOHyPDJoQg/afLWlbjaQN4Jh6zBtB48Me866NRBG/w7
   uJ9eks0ZJvlDmYQH4Bn4DkRp23u+EM4vrsAIj1iJYMx48p+446VC83iPU
   Q==;
X-CSE-ConnectionGUID: fIfDGUeRRLuWzwYOXPibfg==
X-CSE-MsgGUID: pfy+q5hUQRKBAJYpxfa6eQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11314"; a="41084972"
X-IronPort-AV: E=Sophos;i="6.12,314,1728975600"; 
   d="scan'208";a="41084972"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jan 2025 03:51:00 -0800
X-CSE-ConnectionGUID: guUFdftBQ8yLMX7KS+nILg==
X-CSE-MsgGUID: nPxTfZtzSRGGBlrJmj3oCw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,224,1728975600"; 
   d="scan'208";a="135660312"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmviesa001.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 14 Jan 2025 03:50:59 -0800
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.44; Tue, 14 Jan 2025 03:50:59 -0800
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.44 via Frontend Transport; Tue, 14 Jan 2025 03:50:59 -0800
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (104.47.73.172)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Tue, 14 Jan 2025 03:50:59 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Dl3uILe5+D7L9eY0uwjoDmbX437l1bwYVWBxjTWLyUtD2Nax2mq1tnSYhb9U0XMC9Y7sEOlQuwvZ0dggH7crSZY1mVmKJp7WPUXG1I/BUGXV1Min3BXK+bUq4jecAZPz/iWezCTkjZXIP0BB6OQFdai9q3QCDB0wo/yFwvQrlyXEnOBGuIkSzCtp+/Vo0QGrMW/BmkoIwJ3Yz5tDxxuRIIK+BZRfwaG5O6tC11EJPQky2WPNqaiuBNulUgZbk2v1sqjZZo1etjDHwyVZ4PTJgNlvU9h26ALCqtAHlRDhdv87vGnp/9807zj9otGtm+3icg2CLI2nHasiY0L6lbEr5A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=E4yoDQ6FtGpIlD7ByPx1dDBZoLHXVmXJ905pS7BsgTQ=;
 b=YHIcF/nvxNjoUK0odW1YiUMmsneId5SMl1O4GEm+0gHIiZNlRbG6vAuWuC7l1Z8ofFI2rb/vTtTlFUzhvwMMisMDnTxyKG3jnnhlsbcM4N5iG37Ax9uR86ntHgEMCdMYP2ZepJXkTSNLKrWJexcKOVa+Tg5hBHy67z1H5QVXqus0K+IFFUf1BUs4tSDd/PwW8nyNugtNR7ektGMQY9BDIr5YrroFNuwseDSYxD+atygfiPVBjEXYKO5wNFiSJvxoj45ChdJ5h7cIbyD0xC55sF+g14yQ4RNuE++9zSrgREHLnwTrvK/CXlUm9iEi7r2HomFB9k8lQEu5o/HqFGoRhQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CY5PR11MB6366.namprd11.prod.outlook.com (2603:10b6:930:3a::8)
 by DS7PR11MB6062.namprd11.prod.outlook.com (2603:10b6:8:75::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8335.18; Tue, 14 Jan
 2025 11:50:57 +0000
Received: from CY5PR11MB6366.namprd11.prod.outlook.com
 ([fe80::6826:6928:9e6:d778]) by CY5PR11MB6366.namprd11.prod.outlook.com
 ([fe80::6826:6928:9e6:d778%3]) with mapi id 15.20.8356.010; Tue, 14 Jan 2025
 11:50:57 +0000
Date: Tue, 14 Jan 2025 11:50:46 +0000
From: "Cabiddu, Giovanni" <giovanni.cabiddu@intel.com>
To: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
CC: Herbert Xu <herbert@gondor.apana.org.au>, "David S. Miller"
	<davem@davemloft.net>, Boris Brezillon <bbrezillon@kernel.org>, "Arnaud
 Ebalard" <arno@natisbad.org>, Srujana Challa <schalla@marvell.com>,
	<linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<qat-linux@intel.com>
Subject: Re: [PATCH] crypto: Use str_enable_disable-like helpers
Message-ID: <Z4ZPlu6iqCFWmWDm@gcabiddu-mobl.ger.corp.intel.com>
References: <20250114105603.273161-1-krzysztof.kozlowski@linaro.org>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20250114105603.273161-1-krzysztof.kozlowski@linaro.org>
Organization: Intel Research and Development Ireland Ltd - Co. Reg. #308263 -
 Collinstown Industrial Park, Leixlip, County Kildare - Ireland
X-ClientProxiedBy: ZR2P278CA0078.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:65::13) To CY5PR11MB6366.namprd11.prod.outlook.com
 (2603:10b6:930:3a::8)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY5PR11MB6366:EE_|DS7PR11MB6062:EE_
X-MS-Office365-Filtering-Correlation-Id: 36f28922-a8c5-4ea2-14bf-08dd3491b512
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014|7053199007;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?9hrT4S6ld2zkQprmU6AWrV8okpwzfQPpNGuwQb3KfEzECthoHZfouXoWYC9i?=
 =?us-ascii?Q?XfrpDQ/zHpAoS3z0D5C7Axz32Jq2v+gMNknDCs6dUUTXe+Q6PbhmFOKjWHsF?=
 =?us-ascii?Q?fXh2WqpkFd1OGQKItCuCk2yZM8YWbKvrM9A4oPSKoeZ3Z3b4YuUHv3RIGBFx?=
 =?us-ascii?Q?/hu4P9Nit0+GcvQyGYiQ5Oh3H8Fm+vL7tq1tKW4/ch9e8i2un216dIq49dmt?=
 =?us-ascii?Q?+DpCc/QizsMY2p90C7tCKbkLX5TXCyrxnLAeN5RNk5Ao0xNgpPLsBLJmUenO?=
 =?us-ascii?Q?7mIhadsa3OWOxrXttR/r6MqvPQMbWkgDgtp/P7d4LP/qjlPMq+GWDkzpTzTR?=
 =?us-ascii?Q?P27YD7VuGOghIIrxLXNXw3LMOWG1xDuNiaVDLIWN2wX8LXAeIYr/BDJ3Vawq?=
 =?us-ascii?Q?230kr5Vwxk0w2cWdyV/zUk8TIi26lDVImPPqW/sTN+Xmq6j2oaHoFBszGblh?=
 =?us-ascii?Q?B2B2/M3pGtFp7Ot5Batm8/8hdrQU7kmsoSYp7sOjexhy6mpB88Mk+JyVGoyG?=
 =?us-ascii?Q?H8JBd38se1OtMUN3rsaeRL/dQsxXQhrIDBV3tR3SpS1+E4a5HmrGmHlirLtQ?=
 =?us-ascii?Q?h9JJgoNhz2eKZ8ap+k6HUEDpePz24xFpxOTOSGa740zVGr6/TvFA2aGN4OO7?=
 =?us-ascii?Q?zHEWf07oKouL6JBc6dFlPUMMSEtNvqP/IolDLkEIcLNFumjv32CRZBcQO8q3?=
 =?us-ascii?Q?FkQXlADu50U4HzIrtVO8waIMba5HWjjQZODXJUZIO+NTmdzFMxJ6kaXSD8lZ?=
 =?us-ascii?Q?+j9V8Jk2JMNQ62y078JZ52zg82MwZFg36rViNYeqHEnoOSqSJ+xQcJEFSFwZ?=
 =?us-ascii?Q?434hlAm2n2kwOif0mPrTSVotgKC3CHjbrnWe+ZePwrxlNjrLF4oJpJ4ttE2B?=
 =?us-ascii?Q?Wz4xWpytuTq00WV97AuMQzvLT/OO5bwZESvH7DZqWW8rt1a2iLGfTAGtcszV?=
 =?us-ascii?Q?OcFFEQS45Rfji24iOZtzZXny3Kq2z5F0Yh/Czo3EHxRO/Zerk9Z6ujumYLWP?=
 =?us-ascii?Q?cAYtbFzAD/R/duXWfWiBKkZGifdi3rjs61nve/CHLBUfd7a4zB7Lo40MbIZF?=
 =?us-ascii?Q?4ogcuTF8AyrTo5n9OQkSrb5MzH6WU6YUMesakkZcAh53RI3KvCX02BmRWCYx?=
 =?us-ascii?Q?8Eu1radC8AJuQ4sXkHkWE5DGE/vWainRDYT+CSIohNs1r14bw5jjbDOUWhFH?=
 =?us-ascii?Q?Z97BBytYhUtA0+cO6NMtVSkXIBty9h/lOYzkuOPm95k+rrvuBEOv81UhUkHj?=
 =?us-ascii?Q?CPdePD0bk+TuTiOdvqXOxbDMEdUiB/B3VqMssgfw1iZsAaR1aWa4Bdno0eV+?=
 =?us-ascii?Q?FXoKv13VEBce/AAFac1SZw6D7L+CqnlpSFSyalz8SQkf83CGrFIXYnBja6JT?=
 =?us-ascii?Q?funjIT87nxQzaXYRCBisXHwBXKHr?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR11MB6366.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?m12RltA1Hvb9R7DD6iLcuU5aEy8Go+djo6FF48LJvpXItM794l6ix7F5CadD?=
 =?us-ascii?Q?qJJhGuEIbbz0x4HUogdKS98M2SyaqOEaW39SqHFcfBMHADJo3QReyGYtcVaP?=
 =?us-ascii?Q?0wlvkSbNOuZk4kV5k4ylxHXUYeQIP5CspO+HIBwA15L9WE+Jrf5r76P3B+bK?=
 =?us-ascii?Q?FAnh15Q9yiJC7RmefaXxe5sibzJRIhq+OzdeUmn8XkPW7YZubd49YVAI3RfN?=
 =?us-ascii?Q?3mtMNEjedf+MiQtXkAXsCcZxZqqALk/iVY4+GKs4mrPGNohi/ghSFF32P+aZ?=
 =?us-ascii?Q?Pvg7zCSslHhSM1WXdaN6CJ2rg3Ol2j/sIb3Hu4O/MmNntbuVIvSaXudEGHC6?=
 =?us-ascii?Q?i37ElIbm+pfoPC1qTuFhziwMvYpZgoJSfuIWbM4Q22gTiIun2/DWByoW2sTN?=
 =?us-ascii?Q?V3LfNwp52PgIPnM2DXQnzUhAWwJjDL8YFOfrwyBDzMOeK9AN/eMs8AgAIoKf?=
 =?us-ascii?Q?9NNMdOFUokmSstp2GNaV3vKpWDPtNqqxhyll1GWcGOucA11S2dqAXwyK9apr?=
 =?us-ascii?Q?s1dopQoAZYnOLSfoLKFKPa19Bik4ZP2HCHntrsY1jt07tGJyc7AZlPisAifO?=
 =?us-ascii?Q?NR5JnnTnJ6K1tBENw+PX+u66xyma9LHPvVsuew3S5XxYOP9qhiw0zvl6MwNl?=
 =?us-ascii?Q?UapyfbjWlf2LEqlLifqUFQ7NB0LOD0XqJPqh89yCid1D4PBU7cdp1pLP4O7v?=
 =?us-ascii?Q?/aTuEeBCZdx/SLen7zytAbK1HErgol7Qja56JAn8gzQfsYtXn+btjiEk96Xd?=
 =?us-ascii?Q?JAZZTCBJqApt32soFdRZVdbt0V2wzNwi+dFuFPKvmBWOtDV+b7E4kRrAL+4/?=
 =?us-ascii?Q?t0DqhM0vNAvIJ+ec4m9w6CvW2gIC85CZ18dSEWyv3E2EfJtwQVzyY1OlUlvo?=
 =?us-ascii?Q?T8/CEaZ+RQd+0ELtqcczbjIOED4ViLQgXg0m2oRGI+Zt/rkmOxeGyg7RR7Ye?=
 =?us-ascii?Q?KOc/06wVYq9LnteNBFuxvV47RxbJ7S1UOf5w0sOJgepUEaIMIEOs5BSPkMzo?=
 =?us-ascii?Q?kVTvqQkKWlZSzR7HkuFu10rZ6lf3UqTC7NQBvlxfh+EBMNGG6K25QK63PF7/?=
 =?us-ascii?Q?adRNufHjz02j2U0jJP8GZ8L6o8gsq5+eEKYCJNkKpK+T72KnRhtIgGgjskzo?=
 =?us-ascii?Q?3Wy0Mf4hmd8h+8GbhIFCzZuhos/i32GAZSH2mGNEMrphln57UVfMSKjokX9A?=
 =?us-ascii?Q?qeuTYNq9O03oIfa2QjdkMJw/77PdsMPCAAtRLs4iQHOFml+yRZ2q1IxfOk01?=
 =?us-ascii?Q?9zClEVoCVkufE8AlzuwRzYaeU6iZTIjDaqvT+Cdref8gwNINaBXELSYRvciA?=
 =?us-ascii?Q?kM3ufSPSfgFsEe3QnpxQQyaJSDRfZZgrnLJ8+3TfQ+19kp4W/Gt8we0Qhllp?=
 =?us-ascii?Q?rUoxU7nIruCKHytrtfrudctmsIZAXDnch0mQiur0mjbfFmbTTxb9a3h/GMd2?=
 =?us-ascii?Q?8Yh5Ufjk6nCpP99VlC7dfugja8Dx2mfA1PhkNFAwQB8/3tIMzzWddsz1zna2?=
 =?us-ascii?Q?oZXOQ6T83wZPe89vQWmR6piCBhgPKAeT5Iv/47aiWaY5uYpkwLvlnFNGG+jd?=
 =?us-ascii?Q?Zesu8DVa25tdsyI7JUKSjclBEEb1gXM8k00AJJXVhr0agbQVpIkXP75uVxIk?=
 =?us-ascii?Q?Bw=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 36f28922-a8c5-4ea2-14bf-08dd3491b512
X-MS-Exchange-CrossTenant-AuthSource: CY5PR11MB6366.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Jan 2025 11:50:57.0103
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: IHjqfSoqRoomT0hJEtanQIuj3JaKXAIkYCkE6Pn+XSGnhlWMGjNguoTGWUbzvQWGGy9C4ONbDvmfT1XyYaoEVGQk9Wall8IdvOT7ksYm/Sw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR11MB6062
X-OriginatorOrg: intel.com

On Tue, Jan 14, 2025 at 11:56:03AM +0100, Krzysztof Kozlowski wrote:
> Replace ternary (condition ? "enable" : "disable") syntax with helpers
> from string_choices.h because:
> 1. Simple function call with one argument is easier to read.  Ternary
>    operator has three arguments and with wrapping might lead to quite
>    long code.
> 2. Is slightly shorter thus also easier to read.
> 3. It brings uniformity in the text - same string.
> 4. Allows deduping by the linker, which results in a smaller binary
>    file.
> 
> Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
For QAT:
Acked-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>

> ---
>  drivers/crypto/bcm/cipher.c                         |  3 ++-
>  drivers/crypto/bcm/spu2.c                           |  3 ++-
>  drivers/crypto/intel/qat/qat_common/adf_sysfs.c     | 10 +++-------
>  drivers/crypto/marvell/octeontx/otx_cptpf_ucode.c   |  5 +++--
>  drivers/crypto/marvell/octeontx2/otx2_cptpf_ucode.c |  3 ++-
>  5 files changed, 12 insertions(+), 12 deletions(-)
> 
> diff --git a/drivers/crypto/bcm/cipher.c b/drivers/crypto/bcm/cipher.c
> index 9e6798efbfb7..66accd8e08f6 100644
> --- a/drivers/crypto/bcm/cipher.c
> +++ b/drivers/crypto/bcm/cipher.c
> @@ -15,6 +15,7 @@
>  #include <linux/kthread.h>
>  #include <linux/rtnetlink.h>
>  #include <linux/sched.h>
> +#include <linux/string_choices.h>
>  #include <linux/of.h>
>  #include <linux/io.h>
>  #include <linux/bitops.h>
> @@ -2687,7 +2688,7 @@ static int aead_enqueue(struct aead_request *req, bool is_encrypt)
>  	flow_log("  iv_ctr_len:%u\n", rctx->iv_ctr_len);
>  	flow_dump("  iv: ", req->iv, rctx->iv_ctr_len);
>  	flow_log("  authkeylen:%u\n", ctx->authkeylen);
> -	flow_log("  is_esp: %s\n", ctx->is_esp ? "yes" : "no");
> +	flow_log("  is_esp: %s\n", str_yes_no(ctx->is_esp));
>  
>  	if (ctx->max_payload == SPU_MAX_PAYLOAD_INF)
>  		flow_log("  max_payload infinite");
> diff --git a/drivers/crypto/bcm/spu2.c b/drivers/crypto/bcm/spu2.c
> index 3fdc64b5a65e..ce322cf1baa5 100644
> --- a/drivers/crypto/bcm/spu2.c
> +++ b/drivers/crypto/bcm/spu2.c
> @@ -11,6 +11,7 @@
>  
>  #include <linux/kernel.h>
>  #include <linux/string.h>
> +#include <linux/string_choices.h>
>  
>  #include "util.h"
>  #include "spu.h"
> @@ -999,7 +1000,7 @@ u32 spu2_create_request(u8 *spu_hdr,
>  		 req_opts->is_inbound, req_opts->auth_first);
>  	flow_log("  cipher alg:%u mode:%u type %u\n", cipher_parms->alg,
>  		 cipher_parms->mode, cipher_parms->type);
> -	flow_log("  is_esp: %s\n", req_opts->is_esp ? "yes" : "no");
> +	flow_log("  is_esp: %s\n", str_yes_no(req_opts->is_esp));
>  	flow_log("    key: %d\n", cipher_parms->key_len);
>  	flow_dump("    key: ", cipher_parms->key_buf, cipher_parms->key_len);
>  	flow_log("    iv: %d\n", cipher_parms->iv_len);
> diff --git a/drivers/crypto/intel/qat/qat_common/adf_sysfs.c b/drivers/crypto/intel/qat/qat_common/adf_sysfs.c
> index 4fcd61ff70d1..84450bffacb6 100644
> --- a/drivers/crypto/intel/qat/qat_common/adf_sysfs.c
> +++ b/drivers/crypto/intel/qat/qat_common/adf_sysfs.c
> @@ -3,6 +3,7 @@
>  #include <linux/device.h>
>  #include <linux/errno.h>
>  #include <linux/pci.h>
> +#include <linux/string_choices.h>
>  #include "adf_accel_devices.h"
>  #include "adf_cfg.h"
>  #include "adf_cfg_services.h"
> @@ -19,14 +20,12 @@ static ssize_t state_show(struct device *dev, struct device_attribute *attr,
>  			  char *buf)
>  {
>  	struct adf_accel_dev *accel_dev;
> -	char *state;
>  
>  	accel_dev = adf_devmgr_pci_to_accel_dev(to_pci_dev(dev));
>  	if (!accel_dev)
>  		return -EINVAL;
>  
> -	state = adf_dev_started(accel_dev) ? "up" : "down";
> -	return sysfs_emit(buf, "%s\n", state);
> +	return sysfs_emit(buf, "%s\n", str_up_down(adf_dev_started(accel_dev)));
>  }
>  
>  static ssize_t state_store(struct device *dev, struct device_attribute *attr,
> @@ -207,16 +206,13 @@ static DEVICE_ATTR_RW(pm_idle_enabled);
>  static ssize_t auto_reset_show(struct device *dev, struct device_attribute *attr,
>  			       char *buf)
>  {
> -	char *auto_reset;
>  	struct adf_accel_dev *accel_dev;
>  
>  	accel_dev = adf_devmgr_pci_to_accel_dev(to_pci_dev(dev));
>  	if (!accel_dev)
>  		return -EINVAL;
>  
> -	auto_reset = accel_dev->autoreset_on_error ? "on" : "off";
> -
> -	return sysfs_emit(buf, "%s\n", auto_reset);
> +	return sysfs_emit(buf, "%s\n", str_on_off(accel_dev->autoreset_on_error));
>  }
>  
>  static ssize_t auto_reset_store(struct device *dev, struct device_attribute *attr,
> diff --git a/drivers/crypto/marvell/octeontx/otx_cptpf_ucode.c b/drivers/crypto/marvell/octeontx/otx_cptpf_ucode.c
> index c4250e5fcf8f..2c08e928e44e 100644
> --- a/drivers/crypto/marvell/octeontx/otx_cptpf_ucode.c
> +++ b/drivers/crypto/marvell/octeontx/otx_cptpf_ucode.c
> @@ -10,6 +10,7 @@
>  
>  #include <linux/ctype.h>
>  #include <linux/firmware.h>
> +#include <linux/string_choices.h>
>  #include "otx_cpt_common.h"
>  #include "otx_cptpf_ucode.h"
>  #include "otx_cptpf.h"
> @@ -614,8 +615,8 @@ static void print_dbg_info(struct device *dev,
>  
>  	for (i = 0; i < OTX_CPT_MAX_ENGINE_GROUPS; i++) {
>  		grp = &eng_grps->grp[i];
> -		pr_debug("engine_group%d, state %s\n", i, grp->is_enabled ?
> -			 "enabled" : "disabled");
> +		pr_debug("engine_group%d, state %s\n", i,
> +			 str_enabled_disabled(grp->is_enabled));
>  		if (grp->is_enabled) {
>  			mirrored_grp = &eng_grps->grp[grp->mirror.idx];
>  			pr_debug("Ucode0 filename %s, version %s\n",
> diff --git a/drivers/crypto/marvell/octeontx2/otx2_cptpf_ucode.c b/drivers/crypto/marvell/octeontx2/otx2_cptpf_ucode.c
> index 5c9484646172..881fce53e369 100644
> --- a/drivers/crypto/marvell/octeontx2/otx2_cptpf_ucode.c
> +++ b/drivers/crypto/marvell/octeontx2/otx2_cptpf_ucode.c
> @@ -3,6 +3,7 @@
>  
>  #include <linux/ctype.h>
>  #include <linux/firmware.h>
> +#include <linux/string_choices.h>
>  #include "otx2_cptpf_ucode.h"
>  #include "otx2_cpt_common.h"
>  #include "otx2_cptpf.h"
> @@ -1835,7 +1836,7 @@ void otx2_cpt_print_uc_dbg_info(struct otx2_cptpf_dev *cptpf)
>  	for (i = 0; i < OTX2_CPT_MAX_ENGINE_GROUPS; i++) {
>  		grp = &eng_grps->grp[i];
>  		pr_debug("engine_group%d, state %s", i,
> -			 grp->is_enabled ? "enabled" : "disabled");
> +			 str_enabled_disabled(grp->is_enabled));
>  		if (grp->is_enabled) {
>  			mirrored_grp = &eng_grps->grp[grp->mirror.idx];
>  			pr_debug("Ucode0 filename %s, version %s",
> -- 
> 2.43.0
> 
