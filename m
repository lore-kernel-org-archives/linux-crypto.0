Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C252E2562E;
	Thu, 15 Aug 2024 15:38:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.9
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723736292; cv=fail; b=qYvb3qNi9skn3wbeoJYRNSlp8t5g9QHkEyXiXgk6JrAEA1wfhIaYpjXBY8IC8XQOY8i7Um8HSIqOneC3JRnKKyS9O+x1cbaAvcIFBQhmruDj7CIqDchwnI5Q6w/acwb2hefpRxqTA/p7HSJ70nwZXZ/WgmBuGDGne1iwlTejyzM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723736292; c=relaxed/simple;
	bh=0lH2TmLCov/YScq8k7pMoBmdV/e+cidQG2pUxswqCP4=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=kQDdC/QEDS0C9EqAshFCoZq3crXWTXZcp4gVXKgdQslF++IVvk4tTaiplHE815Qyod6WJRIYDJ459UKkNUP5i7gIEqOYMbCtmaCc2UdRmTLTIFmaEp28UTBGHkfb8jfEkVRffMSbX61+Ro5GW7HIQHl17dfUhETYmPojZYSfbw8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=b8BmZtC7; arc=fail smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="b8BmZtC7"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1723736290; x=1755272290;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=0lH2TmLCov/YScq8k7pMoBmdV/e+cidQG2pUxswqCP4=;
  b=b8BmZtC7xnlzBrlFavN9iRZdnK861gc2dEUcvKBFJbiXNhhy9YJs/hgB
   yH0BOhs3+bhdF9DSFKrJorZZDK7gfK3K9aWNeBH9HkcqL8Q6WUZyXf9Tc
   V89O8uKcwquuIFpY6vJ9jXor/OFhyrdOV+22zJw4zsojwD7jfvrJRyFHz
   KRKFE2b2ftfbOAqW2+VmCe5rk17oc9iL3bapQIle4CdietJoTqq3f9a8l
   fWb74uCXWAZ67fZZY9q8Ey3aWOAIW30uKEpuZRC/X7U+X80IqTuaBLZ8L
   kqcnZ77+qRNSJRHpitJKlP/vBkxleKtjIs4iVbklhxhm7pejIlq9l/qNb
   A==;
X-CSE-ConnectionGUID: 3KH1KNWXQ1uRlBjuhKcaTQ==
X-CSE-MsgGUID: hFN4hKImRfueOf8j8q5jgA==
X-IronPort-AV: E=McAfee;i="6700,10204,11165"; a="44519555"
X-IronPort-AV: E=Sophos;i="6.10,149,1719903600"; 
   d="scan'208";a="44519555"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Aug 2024 08:38:08 -0700
X-CSE-ConnectionGUID: 90fo35QrSz6wuMVZnIU57Q==
X-CSE-MsgGUID: PZ6wSqhnRV2Mc/gVgQtpIg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.10,149,1719903600"; 
   d="scan'208";a="59351374"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by orviesa009.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 15 Aug 2024 08:38:07 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Thu, 15 Aug 2024 08:38:07 -0700
Received: from fmsmsx603.amr.corp.intel.com (10.18.126.83) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Thu, 15 Aug 2024 08:38:06 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Thu, 15 Aug 2024 08:38:06 -0700
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (104.47.74.47) by
 edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Thu, 15 Aug 2024 08:38:06 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=XT9nT7/niZibrd0+2RSsB+kSJkY32B6BKIdLB8QGjBPfaE2/nGl6UtXT4/gHyeFNR7fq/R8ZDv1Sz+AjmLEbr4PrmPyRloJ8aLeFOcgN2ldhb70O48A9lWTlU3AEx69pA9PTkSZcVB8Jngnotl7sWrai84mOiNeEFMTLzB84Xpn+dPhMa+tSV2aF3HWpqmbCkAmcuSjWe4Hywmu31IvingrSvqYqWnn1o/IY7+z5fG5LB+T8Qqv1j5kw+uhNZcyUTTLceoTVsR56NFEgwwBOB/5hnfWbVk27JLW2MjX71puVZp2yxXxWEyezVaiinmLlNITEIMPcJnL3xoVtFhfLcw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4WG5lzRLRGnaBFidwF064Svd8Z30TJ3VpaseACXRWCI=;
 b=H2iw8NNHSAUkk9Zd2uO4vrP9yUYKrDxd3Qjv264xtXk4cT2T6jNj+rIGdkYXKMQH6x3CwavkJfajj9et7I1F4WjbJj0QCauWqUVSGs1J+r76W8dnYxSnB9FrF4VYHLW5dIBiOiocrlCAvz8/qON7x0WOskBDEV233UGd3NHntk1DGJbXwSR0QLtKvak6Z9/2TM3Rn1nf2ucgE26NCOMhNUyDQ3FssgVcnOUiE+zHv3zO2GnyTHSE1o/M8he4dbhs+UyPFdGd1cAWQpzqXvfURhvaxFgEVALJeDDp4zxiS9pa2P9jo+ywLHR9iVpy66KuIS11M7dWcKHHg+GRI4nPdw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CY5PR11MB6366.namprd11.prod.outlook.com (2603:10b6:930:3a::8)
 by PH0PR11MB4853.namprd11.prod.outlook.com (2603:10b6:510:40::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7875.19; Thu, 15 Aug
 2024 15:38:04 +0000
Received: from CY5PR11MB6366.namprd11.prod.outlook.com
 ([fe80::6826:6928:9e6:d778]) by CY5PR11MB6366.namprd11.prod.outlook.com
 ([fe80::6826:6928:9e6:d778%4]) with mapi id 15.20.7828.031; Thu, 15 Aug 2024
 15:38:04 +0000
Date: Thu, 15 Aug 2024 16:37:53 +0100
From: "Cabiddu, Giovanni" <giovanni.cabiddu@intel.com>
To: "Gustavo A. R. Silva" <gustavoars@kernel.org>
CC: Herbert Xu <herbert@gondor.apana.org.au>, "David S. Miller"
	<davem@davemloft.net>, <qat-linux@intel.com>, <linux-crypto@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <linux-hardening@vger.kernel.org>
Subject: Re: [PATCH][next] crypto: qat - Use static_assert() to check struct
 sizes
Message-ID: <Zr4g0exFCQXwR2H4@gcabiddu-mobl.ger.corp.intel.com>
References: <ZrVBJqdL1q3X3Dg/@cute>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <ZrVBJqdL1q3X3Dg/@cute>
Organization: Intel Research and Development Ireland Ltd - Co. Reg. #308263 -
 Collinstown Industrial Park, Leixlip, County Kildare - Ireland
X-ClientProxiedBy: TLZP290CA0010.ISRP290.PROD.OUTLOOK.COM (2603:1096:950:9::9)
 To CY5PR11MB6366.namprd11.prod.outlook.com (2603:10b6:930:3a::8)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY5PR11MB6366:EE_|PH0PR11MB4853:EE_
X-MS-Office365-Filtering-Correlation-Id: 71544613-3a47-48e0-6f69-08dcbd4040a5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?Z0LKyHDuX8VqMPdsL8HIaJCjeY+xEW63LALe8m2nO35QO/EWpj94a6ISbTqI?=
 =?us-ascii?Q?WBTmwUolwKmqARJz3cu63u7kXF3TnXkaPLopfd4Untd9JJE+YLDOu9f+cZy4?=
 =?us-ascii?Q?9SMH1ontkjB4vNTK1uKFA1S7tpAaS8gnCqkU0CpV8fA5u3RQtPxB5TfFGgtG?=
 =?us-ascii?Q?f2vKINI8JzS1LYdV9pAqLDlJA4ISQ2CBOjpA9nDLq29OiJW/ERBKv7JW98r9?=
 =?us-ascii?Q?TY92Lg4RgyFbjw7AEQXcCiYyohO9KZu5603nfw96KPWODCkQuPuDjF8E1Ayz?=
 =?us-ascii?Q?k1BKzcWJMRRcBzT4S2nUYJL8h1CVGQoK49heivDoffi1rEZ1L1+apL5znSmM?=
 =?us-ascii?Q?MEbIBl8KLOE0N0Xn5alv9oToQYdTsaqihDnSmk9KDaN05VA9DbSWcB467W9W?=
 =?us-ascii?Q?pEqMwjsnXfI2TRZh90Ei5F+2dXULlybMvdGFPnd4VU/FmOwrAVgZQdlwur2J?=
 =?us-ascii?Q?wcqjfgpfkFkN5PY9eQQlaaSJATp6UeX9S3lgEhv8/xw0pAf5rlwNmsUZ8VtD?=
 =?us-ascii?Q?Vo1hqGjdntKEQcyvTePRvJVXea8ZM8clpq7BVU9QzzRy9NHTwT9QN7JNW4bj?=
 =?us-ascii?Q?4Xv/ous8aFb2rBFGi8TxEow7n1ajJ20m9MV5wPwZmC3Af1Uevh2UYM9k2IKl?=
 =?us-ascii?Q?uw+Tsajh/xkN7s+Lft0o5tVDzIhGo2k6hwwUITyGynD13osiI6eg4lUCVsY3?=
 =?us-ascii?Q?usMYb5U9Fn6nUvzNtzln8VSauTjtzq8ZdQz9NbSEykS1yVKDDHPplX4hFDDU?=
 =?us-ascii?Q?ShBmegwKJsb9GGnUi8Mpg8idKYDQf1bqYPndf3PsBnCFjlECk2s1tDn1VgQ7?=
 =?us-ascii?Q?La6uU/dak7yOxSy7O+dkYhEFXoqwjbKQPM+ca5w6ZrmXgpH16H/yXN9qP4Vw?=
 =?us-ascii?Q?JoTLFxQA68/wM2UKfwAH+YgHomptGMwoTQ3/Lsotjy3ZnZn1przP1PlP14jv?=
 =?us-ascii?Q?cbKRrsuXCuwN5FAF2UxATrmrbvPPFzREsCmA9Eh10IHv6HXBt2STpyN44ZZf?=
 =?us-ascii?Q?NV7F7qUJg26uQSkRzxjZoKX/C3qoTr7JTcQ3mfwHfy4f+gKpv4g/PUxG74eP?=
 =?us-ascii?Q?35DOJoCyrM45Z5scVIyaRWUaPYTBwCjCTPVMWfu4sMIKyCv3c1kGd2uaqxBY?=
 =?us-ascii?Q?iWMdvz7S43RBnwMEkxo3fD507IVf/PB6QZ4BE8TP+jrz/uyOYdS/PWPPChjd?=
 =?us-ascii?Q?SgyF/F9pyy3RIZlLpjYCseNpAenZigJ4VVeKJlKCc1Ry+S9DYfTRzIzaB3GY?=
 =?us-ascii?Q?vJyL1yhPEUGHU4RXqNBTCk0+DKAdRAGMbiyxgukeEeRLURAx7Z8g5ZIKNgLC?=
 =?us-ascii?Q?LL92bhXm3Nv1aqg5vsNlVPQi20/aESSDuumfOdla6ZDTeg=3D=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR11MB6366.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?yxvodMDfiRE9RGa8QprTu3VCwKlOIORXIszt8zQEuYH1YVR039Kpu1UpPx6v?=
 =?us-ascii?Q?DiJeLBJNIRuiFBZzbSUwIXCmwI3A7GpWs67qpNTNJN6dy+2b/FvZrXSOuMnC?=
 =?us-ascii?Q?xmaNg9oO37Vcp32/2lBXiWZemNy2WTIzsJ49HI9ZdgJ4kTytjQdug9Ly8Glh?=
 =?us-ascii?Q?u1WlcNY0O6MNaOFXpZ1HWHE/G/yhf2uVhNghAahQw4neH0evSNRGXpA8FpYU?=
 =?us-ascii?Q?TYMRC9/SRrsp+sp7tFjkV2PMB4aG5+oRF9OtBrJIn2zXSSCFzdgc/Uyi6eWl?=
 =?us-ascii?Q?QRgSt9VxcWEx0QaQJW/J+6nHXUEGfDXaJdSlCeIj2MVZlbq7h74rzJf/iSGm?=
 =?us-ascii?Q?JXkCiwXjfGemA5V5J/Kxa9Tt7Kog66oLMl+LE/cOAUT6+3Iv6EQ0C6VBQxHu?=
 =?us-ascii?Q?86Jn1ICrvPJJe8+9HJqPActHJRenRHQBhPGe1QtyfEj4ynKA7mMOueT67QHx?=
 =?us-ascii?Q?kU9yx294jSjOmquo7sMJCr8vmw0/GLelCttmETKaSsZ1lVRLQKehdNrRiu+q?=
 =?us-ascii?Q?DnjIOSKtAN46EAdtUHah2gOag4PDpbiDF+7E8p8xbSO4kD+bOz0v+SqKRoBZ?=
 =?us-ascii?Q?gR2CYfZG70R8ZaaMwaXotCfmZsl50J8kdP8wmjHdVijv5zcvC/LrnCVcemJA?=
 =?us-ascii?Q?5aIb97Y+FAPuVIpuYNj0zYP+tXDRCELhAd9tHb6B6xMdCfNYq3ZO1B2O4t75?=
 =?us-ascii?Q?GYPxbp/6rDttgDlrRTbltimUsKcGqIG0UTSwpeSufhgNQ6NEr+M8jUxEamLS?=
 =?us-ascii?Q?Pvlndv+sh7RxMEvs5BQKOG0fvfLU5CGc9vixluXjnNmutwK55Mtyg2qdyKgv?=
 =?us-ascii?Q?ZNQyczb/2gT5oyiOM6ZsM2Dyk6mO/dq0+Kgwgv4a0Y4SadluuxlvHnSqRTYK?=
 =?us-ascii?Q?7DV8zLL0H/FxXKjUiejXzdH7QcWyon2QxwLiCwZB1LaJ11XH2hjPf6BhQKm6?=
 =?us-ascii?Q?kGEOyH9+D+tVm4AjQhyauPxFlCm9+belW2pM1ZHcREheiXJFqWbF68w0u+oV?=
 =?us-ascii?Q?fDwUkA5otDyIDTASOeOx6On8pT++wibTFjV84i8sBXH2XpQLOUa8NmNGeRCZ?=
 =?us-ascii?Q?nxTzNvx6q05R/7srYWAd9c3vRdQtmKayzt8fYaTQjm2BKmwaFQ0iQ36MR1NQ?=
 =?us-ascii?Q?q1+/Blg6OF+RZaRJxqYBvY2Mqo/CSgoV7KG0C0dSpyD/GQIn8PeefP6gaw8j?=
 =?us-ascii?Q?N6XWqHuswqb6cyNvhY8G0jLnYzeaVSxl2M/7Vdr5xfMHts3hkBjA/exzo/Mt?=
 =?us-ascii?Q?kR1lAEyHvSHcajwXNGH5SlaZ+eymlKWgtclXhln6A8z6jYo54K3FSktdl/CC?=
 =?us-ascii?Q?0gwbFHQqVsyGIR9GJe1JECU0qGYpnuMX8xux9X6Df3tnSBMYlmn0zNkMeEMn?=
 =?us-ascii?Q?PU3o09WWuZ+/34e2MFjZ/9Gs6RDqes5n/EWPwrL59pghbtKfWQnXcuoUuM6E?=
 =?us-ascii?Q?FxMKrGWW6zDXm8I+l9F4ho4xp5N/5uLfa0ZTV0klWJ2d9O+3AYN+sb2YVeuw?=
 =?us-ascii?Q?LWTi7U5qV6PEtLFdq6mn+wUbtTLlWyNkugQRVVrBaWG0Acud/v52BfU5BV5u?=
 =?us-ascii?Q?FO/bxp/9zwFuhQZVQTXvRlowi01COhgvEvqD/WDkm9WjhUQrctSdbBJnXI+C?=
 =?us-ascii?Q?bQ=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 71544613-3a47-48e0-6f69-08dcbd4040a5
X-MS-Exchange-CrossTenant-AuthSource: CY5PR11MB6366.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Aug 2024 15:38:04.1058
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: H3yZ+Ms5HepB/Atn2IcaiK2igeNF8ceIdhG3lbH1MLM536vC9WyPTOeKuT8GMbX/A+VhbHEM+BozXV8tZsm9cYeRA+P2OzxI04+uarI34Vk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB4853
X-OriginatorOrg: intel.com

On Thu, Aug 08, 2024 at 04:05:26PM -0600, Gustavo A. R. Silva wrote:
> Commit 140e4c85d540 ("crypto: qat - Avoid -Wflex-array-member-not-at-end
> warnings") introduced tagged `struct qat_alg_buf_list_hdr`. We want to
> ensure that when new members need to be added to the flexible structure,
> they are always included within this tagged struct.
> 
> So, we use `static_assert()` to ensure that the memory layout for
> both the flexible structure and the tagged struct is the same after
> any changes.
> 
> Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
Acked-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
