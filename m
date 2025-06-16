Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13B621DB377;
	Mon, 16 Jun 2025 15:03:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.17
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750086201; cv=fail; b=CPKPZ7zZVuWzwkyBlZ2i4n4HwGqDRM3j5uIweqVGAbCTCpi5LbT6BbPrUvdWEVvA+2a+g2qW4C2Z05SxVaQKHZ+9RdK4qLA91DOyb/UDAf2mdwl6GFHEB2s1W0AvFFeWSTFvv+QkG6FmpI5sxs4JdpxqL8kOC64SzHYyIkDxwco=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750086201; c=relaxed/simple;
	bh=LQcsvMvhVrtKV2kPukAojP+sRLvxNQYdDWfW7Riq9wI=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=ngSsC6jSIR4FmO6bEFD+i49qfFWUx6CiWS7sPQ1Wb0ZP1vwzxMROgRv3aX+qAcIuJl5KUP3MUhXHppZMAO+WnFQcf9oNp4ElASVng0AWgHXIxnaAH+qYLoUOhyyt7I8Fwyww0PWQiomI9HbbiZEbVdv2CrHowf5TkBLHIelhi10=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=oEclBkBj; arc=fail smtp.client-ip=198.175.65.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="oEclBkBj"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1750086200; x=1781622200;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=LQcsvMvhVrtKV2kPukAojP+sRLvxNQYdDWfW7Riq9wI=;
  b=oEclBkBjZH0EttYcgpbphBQTNOj75ZswiUi3uAA6twyj5nsPPSNGYPCN
   yDHMSaSjSOXJ+WyVq7SDsDe6tsAMWqjTOUl4zxLqv5e1VLG/XUDtpaY2Q
   Y0Z/Ewqp3g8LmJ+Ppb78mzszr3y19Bp5YPTkPAhDnlfJyCwIiviYBbjIB
   cPoWkWXc1gtr5d5R9SVI4LteEOUAj/Mkl2HWmfDqlnFwpD9AewAb9BbHj
   RbU88L+7SwTz/VbdR2wc1u8tcm2DTRL34lS00hS2fDd/S2lqmkxd/UpW3
   Tu2S9MDbX0q5JGuxDOlbXnvmpDskecbFO6whRjfBNq7j2q1qtekCuO/ic
   Q==;
X-CSE-ConnectionGUID: /fPrKJk7R9yyAsIk2gp0KA==
X-CSE-MsgGUID: 11xxOxCGSQ+TZ0U+24UcKQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11465"; a="52214719"
X-IronPort-AV: E=Sophos;i="6.16,241,1744095600"; 
   d="scan'208";a="52214719"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Jun 2025 08:03:11 -0700
X-CSE-ConnectionGUID: Rbz15PnUTgGGGIo8+2yZNA==
X-CSE-MsgGUID: fCtL4zKCQ2aB4zCHOvcsVw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,241,1744095600"; 
   d="scan'208";a="185755962"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by orviesa001.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Jun 2025 08:03:10 -0700
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Mon, 16 Jun 2025 08:03:09 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Mon, 16 Jun 2025 08:03:09 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (40.107.243.66)
 by edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Mon, 16 Jun 2025 08:03:07 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=hnIZ5GO36tjGo17x5/BebcKNcfafDnSXGEHc+VzWQgw26TAzW2suoswh+C8KCtle0k5G/somwMryAB8qdTtv0VQac7QR7heqrdikk415j8KhxEpN3Qpomtn6PkNmSN955JGyvY9SyvU0LoAvtfqaavjwoJF6bbB1bPz9ByydIN1icRi8whidUceq+Ze2svfmoEp5subzKnhKSuWY51nGF/hwCPl4WjKl5KaHKU1Ng/XGgs00AO+EzRXCCf/UtekXpZmj2SEAFd0Scwv8++Bh8nRIp6YZpZvTc05waUtB4iVdF420204MednEQvJp+kxvmQDCSvdNn+47hJAv0dRGxA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Iof8G5fMvJaV00NBEeM6TsQa0hxt11ARzSn8jTZsF7M=;
 b=ir9r9JoLO114QBfWBk0PMkAWx96aoGjLBjXczDXAIyoup6LD67Gv/njN7H8soRNRlPNvtwD4Xc87zkzI1KEIkni6Bx5gAzXEqODfcmWSORIdpMyxpOXwJhFTN3YUufdJm3cSMfKIq6ALlqY8y1z1CHBigSwN7H763VmO7bBg5VC1WMiB+cUNqZiLttuLdn8PhSP57bMqh17X0hN5V1VY1jlM36EACBd7COu738Zxy43ocVzykw8NVPTqeVdlPBW/8D5p94vcjkWXDOUZCySYwQcEtB4Zqh8EtfP8yJUaT9eABQaIxB6bbYr3iBr+veLBniPbi6OcQjeXedMXZ6l0zw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CY5PR11MB6366.namprd11.prod.outlook.com (2603:10b6:930:3a::8)
 by DS4PPF178D5B043.namprd11.prod.outlook.com (2603:10b6:f:fc02::d) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8835.29; Mon, 16 Jun
 2025 15:02:38 +0000
Received: from CY5PR11MB6366.namprd11.prod.outlook.com
 ([fe80::6826:6928:9e6:d778]) by CY5PR11MB6366.namprd11.prod.outlook.com
 ([fe80::6826:6928:9e6:d778%5]) with mapi id 15.20.8835.027; Mon, 16 Jun 2025
 15:02:37 +0000
Date: Mon, 16 Jun 2025 16:02:30 +0100
From: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
CC: <ebiggers@kernel.org>, <linux-crypto@vger.kernel.org>,
	<qat-linux@intel.com>, <stable@vger.kernel.org>
Subject: Re: [PATCH] crypto: qat - lower priority for skcipher and aead
 algorithms
Message-ID: <aFAyBgwCUN2NLXOE@gcabiddu-mobl.ger.corp.intel.com>
References: <20250613103309.22440-1-giovanni.cabiddu@intel.com>
 <aE-a-q_wQ5qNFcF_@gondor.apana.org.au>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <aE-a-q_wQ5qNFcF_@gondor.apana.org.au>
Organization: Intel Research and Development Ireland Ltd - Co. Reg. #308263 -
 Collinstown Industrial Park, Leixlip, County Kildare - Ireland
X-ClientProxiedBy: DUZP191CA0067.EURP191.PROD.OUTLOOK.COM
 (2603:10a6:10:4fa::26) To CY5PR11MB6366.namprd11.prod.outlook.com
 (2603:10b6:930:3a::8)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY5PR11MB6366:EE_|DS4PPF178D5B043:EE_
X-MS-Office365-Filtering-Correlation-Id: ab61b8ed-f31e-45c4-99a2-08ddace6d53b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?7RL8Nxb0rnzkOJRSnixpmZKZ4hurePSv0tXEjoRjuoD/wkzBgqPgBt4JKWYX?=
 =?us-ascii?Q?/jZNLPHes2vFvtow+7/ERVfKAOTPsspPRmsttZo8v+zleRoFKwIpGYSUvBSv?=
 =?us-ascii?Q?ZiLHywF75+iLL9zEK+G39EEnBdOrq7NNgrOMXMMwDBNocv4pxV5Swpw81fM+?=
 =?us-ascii?Q?Xf2j8VurxUGx2tKA43XWTXU/qrMN0Spg+Kpk6mdtpAyFBJmFG2dM1PV1fi1Z?=
 =?us-ascii?Q?+K/Cgpaab4RxMhOf5aOmg7hSSLoGZtGRI0DANyKiLoJvsHIR5viDju7iS6Pr?=
 =?us-ascii?Q?rSt1GpMZxM5QuNA0v3ktzIXb+E+C4zoCa390VsCMXIbyGSnwl96dCLam3X9F?=
 =?us-ascii?Q?ZW6Fepx8l8OdpOY2F6knR0tiAnIo0UVN2cdgHrDudKxfK7OkOAYyvAiR4mqg?=
 =?us-ascii?Q?B/wcCmtPeFp0HL28eNERLFH68ygswyl0ErkqlxyleKc53Z5o/VkXYOkUdgzu?=
 =?us-ascii?Q?vIacJp5ORA+d65iY1IT6/5sQ4q/wh0MsxF5wi27Sxf93SayuQFL+7NQ9ejUf?=
 =?us-ascii?Q?+dwk2Avi1X8tNd9rcGCCaQrWqO0MR04K9KOXq1ZYHoBCKRFMg5M/uE8ZOo9N?=
 =?us-ascii?Q?8tXJeR1otKYHEbO50E4N2wD1cCJGXi9UxmkzDLGCNKOGKbCzDMHzgmlPuTcM?=
 =?us-ascii?Q?LNGeiq8U3+5E1lt45wxh+gMzYZfZvtbQbP0NVQdKqGZ4kHm7lCKtw571fbLs?=
 =?us-ascii?Q?FwQk9d633AcL9yHZFgR6shJ2OmeA3+mxNj8dcKOJq1YgJ41XUrN8SlBEERUy?=
 =?us-ascii?Q?/DHOUmCmYRsQuBwYvODlIusrGmKdl7ljzeTvz5CpUkk7s1xjDFR2Oey9jWbM?=
 =?us-ascii?Q?cy896iaLTSJlB+MJVMwdyeNpY5CDXpeDgJKngvUe8dbuJf0gfYkVnZBD6isx?=
 =?us-ascii?Q?3BCYD6CcYM+aevnMkGkwfBrtZfDh9oODyso+YRec72LlwXwSo6ciVoz24Y7W?=
 =?us-ascii?Q?eclxSRoFPG3HU9bwnDB5vNvfxZF+QHhuZFLG3lf5qh4e352N+cpl3RJC+1Jk?=
 =?us-ascii?Q?8D2loUHJffh9uIjYrDcOROqwX2aRGV0DewgAFKfo1YBicWGCI48xY5abHfP/?=
 =?us-ascii?Q?R17DrLS93CPoSSOEzsOCBfz81RrBDDyqt4enh1cwQc1klO2wIAYiIa99VBI3?=
 =?us-ascii?Q?U/fRuMcKqmtjXAyXle5Cc6oY1L/nwB431hdKsG0PeGxro8HG91pvMJej8pfm?=
 =?us-ascii?Q?pLFoN/DNDJmAPi/IpEruEnv9Y7aeO6elakAbrxrbwOd5/uU80K49bAUr+M5k?=
 =?us-ascii?Q?dLlhZdy56kcnGCK+78LIJ7xIwgFFX1eM1a6PWX8Hx19BpiOdMP9dtL9t2qyV?=
 =?us-ascii?Q?pYlnrG/PwXZb2Lc0h1Li2CfVZI9ny4AA5G4CnUXYrHQi/PuOpUAH3E8aiF9G?=
 =?us-ascii?Q?99OPDzXR1tEk5JYu2EAenzpfjdXkUKxQmifccSpRS8a+8PJsvIPRa+xfP537?=
 =?us-ascii?Q?Sd0xaj2UBw0=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR11MB6366.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?nQURhHOHHTPujP4+D842GD/iMy8r95Dc8tS3IslSjv6nLNmDZr4lMQ545y6H?=
 =?us-ascii?Q?ZSJuGD11CopJxfl7TB48QScTs8eq/YLr+AbMAhXEW3u+Ks6+dyTJw9hz41lc?=
 =?us-ascii?Q?w1eFFGmdfCo+B20vhIEcGvqlFRsvhgfUBSput6wT5PLEmd1VwnTxWRTHThIv?=
 =?us-ascii?Q?gJKL7ALR5LSDTNQX3V34neHn+zC76R4qV+cGT7FCNbAqxob+JX78zI0V7hRb?=
 =?us-ascii?Q?yAUbd/+Xt3T1l8NGAzN9MNEu1jmp2L2l0lm+AcmfuoodIzWDxt07tT8cfQxh?=
 =?us-ascii?Q?n1K4rAyXdmh/A6/HrsS2Zbf/79arxEefHgycfXXJt40Ezd07+A98BekL/zlU?=
 =?us-ascii?Q?BdWM+/Aad8PxQ83ysFMwh1BwTOLpUbLdsuAzhVrkJbV4MGAR1D6Ll5+N25at?=
 =?us-ascii?Q?eNPwYyPPVQhumwpUVOX/W2/XP6tLRxb0avRjEbEt1XxoLxTI/WBdrjOQKuPS?=
 =?us-ascii?Q?MrZtL2H8Rhk4xJ4R1XPtuwsK+N8tCBh43hZpaRXMCXORAn/DClU240HbdPiA?=
 =?us-ascii?Q?PlZOiGNQE48OyPG/P5w8eOsJyXDLoze9QoMiut2SZLTPy6+A5Nqdzlpk3IWp?=
 =?us-ascii?Q?wQ7oLT0wgJV4te9ybD4cTjwZcp+fKEIBkBBVzfFyMoEoDf7qAlcHcKFyLaVo?=
 =?us-ascii?Q?JRSMKzW/BqhoZ7vtnyJBTwRJ4TQPQSLwS8aaCrXYpWMjU5HZK9Hs8BImVST9?=
 =?us-ascii?Q?HlPxJkiH9tEqz/O2QC+J6ykelHoBXzwcKvZyaWIwYixGQW/ZI7wUWPv9qUvS?=
 =?us-ascii?Q?iHQtprmJSIgwLLAAXfZoSgjofpT/QDyAG95bf8U3JU4PiDIdF6mTYVZWiuG2?=
 =?us-ascii?Q?SdvaFlc4hfpoe/m0dOFjhz2guaMBSYMqRkq0Y89693jlrpCZZWdxDb3+HTXl?=
 =?us-ascii?Q?ogHPc6E9Dp+ep1/qaFa9XOWQzUgzP79boHG9Bh1Z4goICVTkSu6VwhCFNKA3?=
 =?us-ascii?Q?X0o2MJYYSViGgRmkuFXi4rceu2X6oiT7qEz5v7tGQpvEVUvrgXhNVZenrz7N?=
 =?us-ascii?Q?CshFe50VUgG/xIYI3+XVp8EYvD9qCTOzaXXEOHeq3v/x5GijHZJg64AnFjWw?=
 =?us-ascii?Q?EiFSymeGQwfOOm0+mgmSFoF0hKYxrkLeKXFEQVH8LTfyzY9+JtpH5vt2AeTV?=
 =?us-ascii?Q?5E37w8cI+z+2gawMeqkzonL+MFSIk3rsqnm3+EtMPNR0AW8eiaCiueihoKZP?=
 =?us-ascii?Q?viWTbM/Prs8m2yzZWSBjUa0Z7p0UOocEFOHkxv2w/I+ZCMku00RQCKFm6lXm?=
 =?us-ascii?Q?cet+f/ocPC/B2OZEcyJXMidi3ld1PSxqYp2A+xGxcZinCBE5ddjN1smVBZGM?=
 =?us-ascii?Q?PuxUv9tULofbHYIxtjM6dX+d8y6wN8fXy17mBq1TnOpz2MYUC1iz44FnUGd5?=
 =?us-ascii?Q?JmG3EakzxQ0oMqzVcrVHKY/zda+zn8xNIy65g0jh/SU1YB4HHUBY+ZQAf14Y?=
 =?us-ascii?Q?6oFMkGahyWZtjPP1YNZDmhmE/mTy4npHZ70Rxf9u+rjmvk0arJXAPUZmAbM3?=
 =?us-ascii?Q?jmISTDbpKtAA1BsSa3Ezk6LOo44DFQXZPZUz4pId9/zmH57s9vVtIFthuRtr?=
 =?us-ascii?Q?A25LQPzkSNgzMPohYM3S97jJSR1ytCAWcKYOK0K4eWVbIw4EbkPs7+W2v7jI?=
 =?us-ascii?Q?Uw=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: ab61b8ed-f31e-45c4-99a2-08ddace6d53b
X-MS-Exchange-CrossTenant-AuthSource: CY5PR11MB6366.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jun 2025 15:02:37.8888
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ZqTxRdngRmVeMpPbBvipAWTVYqbsRvoneuv2IjvQCv6urJmc8CB0YQj92Gh1UXZuQEShs18Xhz2sDFNlVke/xNN1kaSSzZnlwiGA/YOuKgc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS4PPF178D5B043
X-OriginatorOrg: intel.com

On Mon, Jun 16, 2025 at 12:18:02PM +0800, Herbert Xu wrote:
> On Fri, Jun 13, 2025 at 11:32:27AM +0100, Giovanni Cabiddu wrote:
> > Most kernel applications utilizing the crypto API operate synchronously
> > and on small buffer sizes, therefore do not benefit from QAT acceleration.
> 
> So what performance numbers should we be getting with QAT if the
> buffer sizes were large enough?

Specifically for AES128-XTS, under optimal conditions, the current
generation of QAT (GEN4) can achieve approximately 12 GB/s throughput at
4KB block sizes using a single device. Systems typically include between
1 and 4 QAT devices per socket and each device contains two internal
engines capable of performing that algorithm.

This level of performance is observed in userspace, where it is possible
to (1) batch requests to amortize MMIO overhead (e.g., multiple requests
per write), (2) submit requests asynchronously, (3) use flat buffers
instead of scatter-gather lists, and (4) rely on polling rather than
interrupts.

However, in the kernel, we are currently unable to keep the accelerator
sufficiently busy. For example, using a synthetic synchronous and single
threaded benchmark on a Sapphire Rapids system, with interrupts properly
affinitized, I observed throughput of around 500 Mbps with 4KB buffers.
Debugfs statistics (telemetry) indicated that the accelerator was
utilized at only ~4%.

Given this, VAES is currently the more suitable choice for kernel use
cases. The patch to lower the priority of QAT's symmetric crypto
algorithms reflects this practical reality. The original high priority
(4001) was set when the driver was first upstreamed in 2014 and had not
been revisited until now.

That said, symmetric encryption support in QAT remains relevant for
chained operations, where compression and encryption can be offloaded in
a single request. This capability is planned for full support in GEN6
and may be backported to GEN4 if there is sufficient demand. However,
there is currently no infrastructure or in-kernel user for this
functionality.

Regards,

-- 
Giovanni
