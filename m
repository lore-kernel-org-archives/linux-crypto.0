Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D3BC15573F
	for <linux-crypto@vger.kernel.org>; Tue,  6 May 2025 10:56:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746528993; cv=fail; b=h83xjO35ie43E6Zur73LJdkAENIiGV4q/j0cyenhW4qiTPYgCFpa3gQcGHLm6v8ImxIE4e0qhv71XZ7iK6N7qgOQIRyqGRYNHlzWYlqZ6h8Nieg432Cl/aTeQNYKP9BIXNN4Xnm3gLP/PlZteyyVi7Ol/Oc5PXhu+8PhWeIJ6r8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746528993; c=relaxed/simple;
	bh=yePBXbt2wjWWL/VDzqZLJQAER+aB03h2qRUx4lPQRu0=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=j4qt3VQHn51ncaRsWt5sKytoTiDg4b7/v8Y8GsM3NFQsYH50E/7bnF0fLjkV8DZzz3Ycd4c8vzi9YfYctUcNsLuPSJ6dNEKbmQd48ZIfq7Xk6KeMawk6F79b8CCuX4/gaRy766fvAHRKZ7YAvfPYsh3Lxw11dt0VUOgjSE2yw6k=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=EJr6jAu6; arc=fail smtp.client-ip=198.175.65.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="EJr6jAu6"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1746528991; x=1778064991;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=yePBXbt2wjWWL/VDzqZLJQAER+aB03h2qRUx4lPQRu0=;
  b=EJr6jAu6/vPCggWiY+smXqCDpYo6paRI8veViOnbnQQAryVSetyWRKVw
   Pteu05bBjGKPt+BsWBAghrefGyWKbZ8yUIQg09+UjtH4Xh4lhvtyoKhhe
   Gl9NlC96pal7FT33vuwaLb2lfHg7C4drYgIoahbs5FBckfpuMH0ct4D6u
   dCcgdXlc1VM7bt9LC7mRkk1DsqtJVWOZhw92/sJu2SaBWimpeaxHbXaVp
   Vf1zvExFSiz1A5DSzJ8dInNHOp42ls8We+8WpWIinbYQ2Sz7Zie5d/bb2
   8Hg0Cxn4DIwnyUE+geRE5fubRZE7yC1OAGwt/FiTco5otJsVYrwa/mimy
   A==;
X-CSE-ConnectionGUID: oM5GY0SFRUOHGgwJz5HKQQ==
X-CSE-MsgGUID: WDCElV31RDKn/0+Gb1a8sA==
X-IronPort-AV: E=McAfee;i="6700,10204,11424"; a="48336546"
X-IronPort-AV: E=Sophos;i="6.15,266,1739865600"; 
   d="scan'208";a="48336546"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 May 2025 03:56:30 -0700
X-CSE-ConnectionGUID: NQA4ir6lT/aqJUY77xoKCA==
X-CSE-MsgGUID: mQ3b/jl2TOuy5K7438Jr2w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,266,1739865600"; 
   d="scan'208";a="166508347"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by orviesa002.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 May 2025 03:56:31 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Tue, 6 May 2025 03:56:30 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14 via Frontend Transport; Tue, 6 May 2025 03:56:30 -0700
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (104.47.51.49) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Tue, 6 May 2025 03:56:29 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=TPyjIz6Wyw2L/ris+n/Zx8uQ/Vf/e2Yrm00ylqxiYda9pOHh+9UZTohfJ29blLSN9d45A7y68N0uU1MMWlKgZZcyS30gF54spmhXJrQAJdmgCJcP/zR+TB9/WiQrdYE5cxAkZue5eliZ4lBTthIKJt7AM0ngEU+GBoYMj+yXpS5rxrZp1copmgKOWVywvd67exbFp8RrF/iLFCllIPy/if2zlvmvan2gnZhw5aU40c+apGTbzAY4enYtj5x+rI2On3pb560+dzcvSs+bAA3qe7ohsG38vXWW+7Sf2zHS50tkI4nyxfAqe60gGTvUrDlQjOqveT/+LqnHY6n0OIwS6A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SvBu7l1f3FF2lcBuRaCj3Re5bvjCxwiVvaeeuLJjujY=;
 b=nz4j8Ttk+qO4Hb//8QvjfRmyKCXcT7e2g86cb6teaj85ksTCT5RaoH3FSGqEpiaJO/61gJ8i5VpjJQa2oy/+9ksvTpGDa6xNQfazCZu6H8Pek/D5fefT6Ca2g2huWmcrh/kf7sKMStWKfTIsOccDoCloi8optl0btCfRvlT8PCI42wSLUlzVe7m6DI9J0CsseFfJHZ9J+7EZSHWGezXKtSd+TOPfvPIgjgw1O2Wv15f1Moo+EpCzy13AycwdiNKcZh3uGhz2oGx+RrN1hy1rO90s6Vg6vrh3c4TN5he3tdUZIg/nVvj12EfJB0i1eUKAGggb1ZSQHN8X99wtCE0ccw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CY5PR11MB6366.namprd11.prod.outlook.com (2603:10b6:930:3a::8)
 by SA0PR11MB4607.namprd11.prod.outlook.com (2603:10b6:806:9b::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8699.23; Tue, 6 May
 2025 10:56:09 +0000
Received: from CY5PR11MB6366.namprd11.prod.outlook.com
 ([fe80::6826:6928:9e6:d778]) by CY5PR11MB6366.namprd11.prod.outlook.com
 ([fe80::6826:6928:9e6:d778%5]) with mapi id 15.20.8678.028; Tue, 6 May 2025
 10:56:09 +0000
Date: Tue, 6 May 2025 11:56:03 +0100
From: "Cabiddu, Giovanni" <giovanni.cabiddu@intel.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
CC: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Subject: Re: [PATCH] crypto: lib/poly1305 - Build main library on
 LIB_POLY1305 and split generic code out
Message-ID: <aBnqw2PCznYO6lPB@gcabiddu-mobl.ger.corp.intel.com>
References: <cover.1745815528.git.herbert@gondor.apana.org.au>
 <0babdb56d14256b44249dc2bf3190ec200d9d738.1745815528.git.herbert@gondor.apana.org.au>
 <aBjAFG4+PXbPgqFw@gcabiddu-mobl.ger.corp.intel.com>
 <aBluBfXCtOoGrPKW@gondor.apana.org.au>
 <aBluVB9Xg2hbNlKX@gondor.apana.org.au>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <aBluVB9Xg2hbNlKX@gondor.apana.org.au>
Organization: Intel Research and Development Ireland Ltd - Co. Reg. #308263 -
 Collinstown Industrial Park, Leixlip, County Kildare - Ireland
X-ClientProxiedBy: DUZPR01CA0083.eurprd01.prod.exchangelabs.com
 (2603:10a6:10:46a::19) To CY5PR11MB6366.namprd11.prod.outlook.com
 (2603:10b6:930:3a::8)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY5PR11MB6366:EE_|SA0PR11MB4607:EE_
X-MS-Office365-Filtering-Correlation-Id: 7069afa1-b3c3-42de-d561-08dd8c8c9bd6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?R51cmawLWdXrTSJgt3s5UFgLI2wb/MYgFkc5l/JtcQ9RZ1hFW4qgX+K5oPk4?=
 =?us-ascii?Q?sbkaTQ5hxqePbGfjNARIMusHFJaxsO066moneGSVZW//8HQJk9Wk+Zkikkfy?=
 =?us-ascii?Q?e4t9AgM4yyC7Lnr9VMgz1AoIpzt16JpfjPMN4wBxlMKbzGsSuW2u0bmMfcTU?=
 =?us-ascii?Q?6WInm6LlXtrG5S+OiO2+HdR95W5mf5Yse+L1pvK1WaLmvSsCUVisYcoZM4GF?=
 =?us-ascii?Q?BAK6/OoX22RXLI6M8h3rV8es//++EcGs+x8BtbF2zOSp2p5D9xlfaFiBodtW?=
 =?us-ascii?Q?JBqxkFAKOOQwfRmI82QgA2diQWhYb333B3VKgY/ClYfNlMnFJiTC3ZqIhDND?=
 =?us-ascii?Q?K6yk4apMAzxEd1J914eS/iBS+fCoOXq9OUa6zWrf1+JQjfdv698xkOceRcAE?=
 =?us-ascii?Q?tOwftKurQFWOOEkqbhTeIi0/ghq9CNINhqtZsXH1MZcgyXjMptgeyXpEbA3i?=
 =?us-ascii?Q?N/O7r2mR5Z20yAu7Mok2ifYoUbV+p5Gewch/9UauXrsCdn7pzQWJ1FuVW48g?=
 =?us-ascii?Q?wcUw605f09irjycYS1w4YbaA+BTRJc1SG7dbVgsEIgj8etmCsvOB+YnaJkUz?=
 =?us-ascii?Q?81nhkh+OBMfAkGXOIE8VLI+uEQJjeCZs2/SZswgQRoz0IGIE/ifr7gWMsK1+?=
 =?us-ascii?Q?yI4R1smbgDnW/XT8Zn5up33xMf7cZLAqLoyUa3ZQGexck3FRH4FYZv0MGaVV?=
 =?us-ascii?Q?yotAvrXmjh/yBF/E9UtBuaAOWvrDrIFUT6YdPOU4S8BJDDBDzLNXnuYw/hSo?=
 =?us-ascii?Q?9YIm03vZBdAVG1xB8ltbq3jIHwfJkBkK+yufkuCxFADIvfI6cMpXZhD+uLhS?=
 =?us-ascii?Q?G/DE1Dc8j/XZONK/guZ3YsRVqwrjISmtD++bWyH6cOz2HtfEr2o3nxhZSt2N?=
 =?us-ascii?Q?2RnUVPyrvVcBsjYe340OzgUHkDz8UO/UnfypkEwuiNxRrj4g6k4+UXht191E?=
 =?us-ascii?Q?A/qsJv0INgR7oOFQ1LBDYWh7XXce76DEBU20EtfK7q/3PmkH+vrEL3Eq8K7I?=
 =?us-ascii?Q?TybRevElfa3/T5pBWx5OIbhRk8PiEeUuogXdZrhcrVn3MdibCEfLZ91zO8l9?=
 =?us-ascii?Q?OH/2ZnkdZEVRtZC2M3W6NmMfvuDZSPWWYyDNgSaaCT2l8HeRwPVnzgwECtjd?=
 =?us-ascii?Q?027SjyVuQSHx/Qia2A3YhObHLsFqUwL14RjAtHvpqBaKty65pGyjijTuF7Lk?=
 =?us-ascii?Q?ZyJ7mCgFYXMr6fjuJP0uWXd5oZ8eA1TJR/kGomoKQPJkHmgVy1BTo8brb/PC?=
 =?us-ascii?Q?opFEygyN6+x5w5AH1NSdZgC6RLK0v1SfPW6BSrnDLGQzMI3d5DP5G5Okbumu?=
 =?us-ascii?Q?o+QRIF+WKk+nhsm3T8Qbs0tbf79a8Sz6LNdhlv7vqbyL6PbSU5ToVraPtlxT?=
 =?us-ascii?Q?vmut30/Z3VPpPBz8MHrVPqQuizCReheyQda4hv0uEm02mMTMwA=3D=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR11MB6366.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?t9b+kdKoWQ4PVDODdl+tltXK0wR6dgyhWQWSA0iqRl8moJKKaY53r4ULcLcd?=
 =?us-ascii?Q?2TA18wvRIAJJVrVgBt1cAGHhxij5wCbOBNW8UllVm0cv53+QWBii/CqrZPt8?=
 =?us-ascii?Q?DoZDLLuV7uuY/mcg7ovfBM2T5wM/Kx/OUrtDBcFTEwtdwFeSGVECGz3HzOiQ?=
 =?us-ascii?Q?YkkbHkUeTGHHpsF4Hz86F86NTrxSgijZ/Uj0KTRHsLqxqnYxATn2inK7KFKR?=
 =?us-ascii?Q?EoraT/Y/YHHStj+2Gr5PrD1+fYwiD6H+x+gsLBcVuvUhhWlmQQNSpl95h5pz?=
 =?us-ascii?Q?JTw6aLLlXwGccVAQKypaTP582T+XU4TRawbHeKRwwNlKP9pwc5Xp98R36Nij?=
 =?us-ascii?Q?lAQNe4vwm7MwjoS7fLXch+B9PWhoLYylWj/NIAhrllS2Zpqh3plaRAGoM/z8?=
 =?us-ascii?Q?GmxVwaMxmzLJ5io9n8huL70tPRzE0g1kLPSHSifeWERFZy1SCFlk5xfrqfEY?=
 =?us-ascii?Q?420DLpdO+mwg/P9ou1SCa8F26nN5YRcoRMnVReoc7GJIoYTFWLa69lel0auC?=
 =?us-ascii?Q?coSaMS9TlmT5nCPnMSF6AxPuRLn1VADL7bUcuQWj9ZBrXcjgSgmC2EGOJjLO?=
 =?us-ascii?Q?Rda23xVzgNsvL/dfhbvj53QKuDP7OkTNrBw4mfNUbXMXl+z2FKiSi/0MLKmq?=
 =?us-ascii?Q?ZrCDT11ySLiLkp/N+Nc25MGwGoKuGH2I0ZG9+lzo8Uc7iRbzWNf6Ntg4LRAw?=
 =?us-ascii?Q?sdCAq+L/XAbIgByKmXwCPTV9/rRfm2gXnGeG3cUdhqijaEWm8gtqS9WM/2PS?=
 =?us-ascii?Q?fgleC0+UPPnZVuEh9DP6i6egiDxQTSzBdUm3mfEpPmE124EmZG/arrv/y6cl?=
 =?us-ascii?Q?j4eNZj1GcUVjYoKfdsncguhhaOPImiyjifQFeE/vJGu3S5ID7DSDh8MjZzlS?=
 =?us-ascii?Q?I84EnCmEBu6SKkTgYA8WjB9JiEcIbjNdlx9t1REvNPkFb0VLe/u6Wo2pB1Qs?=
 =?us-ascii?Q?lm/LMyddYpzlzT2CJ7U2ordDwrnb1RaEdxFenhSc2eZ5ZzYVyQvf/gSdpzKu?=
 =?us-ascii?Q?jNo4wGZwbVaKTLnWCer1CPIDphjcHOFph2oWynn6s6/Q5Om5vgpys3qUluUA?=
 =?us-ascii?Q?Bgwo0lMl86Wj1UtTiGH4B5IKnDvQf3p5MUOP+GT8Y0U8/+T/Y87c1Li9+O+f?=
 =?us-ascii?Q?OSicdvJyw4mDpwnzYkO6/sq0GOEBs8+ATKdE7beNuE/J7rGjxMXS/FySYbhN?=
 =?us-ascii?Q?AJbph8+K/r0Urdehh8bd32+RcAuL6yeK8YG4VXgsuARPdlT62Nff1xZV/Jqe?=
 =?us-ascii?Q?sFYSi2PHBzbj0OBEZ0NyKFrnuN9WvfrUKBT+GVI9n8vVQJqmcTgaeTQdZJem?=
 =?us-ascii?Q?mme02odO1ctprJCC6HgaT64RelbEn4G59tcjrDnPu8wQu5m8/Ty0cNDom8RV?=
 =?us-ascii?Q?fZ30BEpBdfLrTtnw/8SbmHbaTNa++BdeQxKHh+tI+fWWuL6ex2U1GajzasR0?=
 =?us-ascii?Q?C3Oay8BgZzYinpgCr+Rnn87krGqSL76ktYeVdGwNECxgUDR8BMPsj8x/2ACY?=
 =?us-ascii?Q?SP4OZ+e5mgQoGgEEqgzCQZB+kuF0K/1eIAs7DqPDvhblTucyW8ZD6Ov6IAX2?=
 =?us-ascii?Q?MlV4xEy2aDDWLB9hQAoQH2FOvRH4Hp8pP2lLgvlTtQV7GNsZdz4sZtpQjkYT?=
 =?us-ascii?Q?1w=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 7069afa1-b3c3-42de-d561-08dd8c8c9bd6
X-MS-Exchange-CrossTenant-AuthSource: CY5PR11MB6366.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 May 2025 10:56:09.5401
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3XV1Il1XkZ7PNYT5cpoBxOvuQosUwzGb4BWAG3U1opOXZSErz0ke7JBVnF7fIomUhrMNStHVlyRAXTvVEOPCIbnXobGg4YTKs6M7/TLb2Hs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR11MB4607
X-OriginatorOrg: intel.com

On Tue, May 06, 2025 at 10:05:08AM +0800, Herbert Xu wrote:
> Split the lib poly1305 code just as was done with sha256.  Make
> the main library code conditional on LIB_POLY1305 instead of
> LIB_POLY1305_GENERIC.
> 
> Reported-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
> Fixes: 10a6d72ea355 ("crypto: lib/poly1305 - Use block-only interface")
> Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
With this patch the build fails reporting a missing MODULE_LICENSE() and
MODULE_DESCRIPTION():

    ERROR: modpost: missing MODULE_LICENSE() in lib/crypto/libpoly1305-generic.o
    WARNING: modpost: missing MODULE_DESCRIPTION() in
    lib/crypto/libpoly1305-generic.o
    make[2]: *** [scripts/Makefile.modpost:147: Module.symvers] Error 1
    make[1]: *** [/devel/cryptodev-2.6/Makefile:1954: modpost] Error 2
    make: *** [Makefile:248: __sub-make] Error 2

My config has
    CONFIG_CRYPTO_CHACHA20POLY1305=y
    CONFIG_CRYPTO_LIB_POLY1305_GENERIC=m

Thanks,

-- 
Giovanni
