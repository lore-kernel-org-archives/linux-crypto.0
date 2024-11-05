Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8ACED2943F
	for <linux-crypto@vger.kernel.org>; Tue,  5 Nov 2024 02:08:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.11
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730772522; cv=fail; b=ePKFUjVt+a/7lWSdGfK//g0j77tsqUEeZlwThaUHTFz2IzU3UMqfR74LlmKxxO1zR9x0uhCv2X4cN5dwG4nUSc4pdSVyOwQItOr9Pei7PjDdQGIoJC+2ZF/slXGsnMoAHLsQIJpGcVERJQx2JkfSuJ4sDoFA4mT7u25S4xzT49g=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730772522; c=relaxed/simple;
	bh=l7IRSC7dIfLHYc6+222PJOZlBGQExNnhYpoq7gkM8aI=;
	h=Date:From:To:CC:Subject:Message-ID:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=Mm3GmcioGyttpauH78PKBBmnm0LcDVJhBkk4p53qw14R5tx16FxE4rPy5nun/OpgVIQgjwGk5uWEARkZvSAkSDDSC4y10CfsRW0w6Dv7NARg/R/phq3DqLLx3w2oecDrJ6J4Wo9ZnmVvgc7wucCROQKgmFYKj/ltH4jPp5ubRyg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=PLYJeBcv; arc=fail smtp.client-ip=198.175.65.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="PLYJeBcv"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1730772521; x=1762308521;
  h=date:from:to:cc:subject:message-id:in-reply-to:
   mime-version;
  bh=l7IRSC7dIfLHYc6+222PJOZlBGQExNnhYpoq7gkM8aI=;
  b=PLYJeBcvNtf2fPDKlgEMqTxYtzeaKSQu66l6Q2KiMWyTulZvCEWcmCMb
   +gyoFd9BKpNW1Y/8SjH2hoGw6XQMNWqACAKxCouY8rAcn53s8NH279pRo
   xEiVFRhR6D36Kzo3ko7DF1/brmqKKXg3cKlQCH0b18RlX5fHBFk+4breI
   pSwFp15Fcjzyltph1ywSXCLD3fbr1QyRcRbpQID43g4q84LzK+FsEQB/T
   4bq07FX5liWsj2GAObArI4ZVjvoYzavXtbvCDVs4vsqV1WuDwZHpui74X
   KIX5CMpxBQp9UiBtXflCGlUZcVcikRLtBxNocIliFtx1jyGYksSiMTR9E
   g==;
X-CSE-ConnectionGUID: VdsRW1EcRN+vGf1KIhRYyQ==
X-CSE-MsgGUID: JyLs5zLCQUGUqSq9z7B9kg==
X-IronPort-AV: E=McAfee;i="6700,10204,11222"; a="41047083"
X-IronPort-AV: E=Sophos;i="6.11,199,1725346800"; 
   d="scan'208";a="41047083"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Nov 2024 18:08:40 -0800
X-CSE-ConnectionGUID: QKHd9Ue4QNWLE+U3pkKujQ==
X-CSE-MsgGUID: jWWtJy2XQm2ZODVu9+op+w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,258,1725346800"; 
   d="scan'208";a="88981987"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by orviesa004.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 04 Nov 2024 18:08:39 -0800
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Mon, 4 Nov 2024 18:08:38 -0800
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Mon, 4 Nov 2024 18:08:38 -0800
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (104.47.56.43) by
 edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Mon, 4 Nov 2024 18:08:38 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=eSUICzWZ+OXB+SYLP0vNOQMQ52s4ioy+Ey4FF0IFapHrAuBM5fHLwi/A6+DzBHgEXNRkNitKCkYozYnsqywJmYFsoV5K5cylNgTDWRP2YE8c5r0MRI9iDyhi9am5o/kNkmlxzwHd29/H5LPxuXxUGFjNuHF0/tb+LhQyUdFV1iuzhce7gG3mzK8CNArrRvDHRkKHz9TWts8Sm7oNH6zu1IbKLN4HfYIjO1WkESwQLRpXI7geygYFCdt6694FZ75OyWHIS36lnDa3BHZ/fsSztAgsAHarBdvxhYA4QHvJ1I8Ggpguc5rTAnIh3//0tkR5o/U2sXR2zJ6lTsw3OXLrFw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bLdgY9o/CjfNOKy33XihIgQZ8l7ngNNPKt07TFlWP+U=;
 b=LRVWcFdmDZ6u9nFFGVFDsxbqefxMTjpUHmA+NekSUvqaYdFgsAgGyfTaMbucJ6WD74eq/uVQ/zUg1ePCp+BVvYJXMcKgkhofvh1PALXSOWe76tApUGQhEW53pfMMxD8K4eNfB7y3Z1zi/22HjX8ZN+WD8fNCaqi3bigxHlviyFtqLyROSXLvyLFcVqjjYYH1k1I8RY54clAu+75PkQywiYNmCV8M94rHTpK8ZEkQH8ptV+x1/SCgKHlf+0BGyjxp1+fqEbXZeATUAuP1aTAa0OHkENVzfZCflCMk6czHRXaZeeiGX+U9KdGQgk/1np6nEoCfb98mjbO3AyBL7Ki62Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from LV3PR11MB8603.namprd11.prod.outlook.com (2603:10b6:408:1b6::9)
 by DM4PR11MB8225.namprd11.prod.outlook.com (2603:10b6:8:188::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8114.30; Tue, 5 Nov
 2024 02:08:35 +0000
Received: from LV3PR11MB8603.namprd11.prod.outlook.com
 ([fe80::4622:29cf:32b:7e5c]) by LV3PR11MB8603.namprd11.prod.outlook.com
 ([fe80::4622:29cf:32b:7e5c%4]) with mapi id 15.20.8114.028; Tue, 5 Nov 2024
 02:08:35 +0000
Date: Tue, 5 Nov 2024 10:08:26 +0800
From: kernel test robot <oliver.sang@intel.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
CC: <oe-lkp@lists.linux.dev>, <lkp@intel.com>, <linux-crypto@vger.kernel.org>,
	Eric Biggers <ebiggers@kernel.org>, Ard Biesheuvel <ardb@kernel.org>, "Megha
 Dey" <megha.dey@linux.intel.com>, Tim Chen <tim.c.chen@linux.intel.com>,
	<oliver.sang@intel.com>
Subject: Re: [PATCH 4/6] crypto: ahash - Add virtual address support
Message-ID: <202411050927.673246d5-lkp@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <bffef4bab1bf250bd64a3d02de53eb1fd047a96e.1730021644.git.herbert@gondor.apana.org.au>
X-ClientProxiedBy: SI2PR02CA0044.apcprd02.prod.outlook.com
 (2603:1096:4:196::17) To LV3PR11MB8603.namprd11.prod.outlook.com
 (2603:10b6:408:1b6::9)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV3PR11MB8603:EE_|DM4PR11MB8225:EE_
X-MS-Office365-Filtering-Correlation-Id: 0e53ac41-3a0a-4d26-6bf8-08dcfd3ec161
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?vSY/uuJRayMGBHH988l0mQv8A+VQBI8mxFQv8GfWL5/1rZ8x2whPsbEOi6nX?=
 =?us-ascii?Q?/mbXmOJ7/4xeQ9+G64XuxJXkw2ES76YT4GH3NUh0qQjvqUHhH9pZTZrS6bRP?=
 =?us-ascii?Q?YMUVjVUszPEGeDx+M1+ZD6ODAAUd/qN25b2keauqn26ZQDBLFMncz+QaS12q?=
 =?us-ascii?Q?Li0ejhXOzynMOymqLbTbg+6sHVUjzWGzhovSBLm4Ndkuc/w+MmgFJf8veJJZ?=
 =?us-ascii?Q?pP7t5H7duSUbN04SkrhWyV1QPWREpXdNeGmvAIC2aiqDwtk0nk1cDkYGFU1F?=
 =?us-ascii?Q?3nLeEWBSlM87C1p3/1IOoSVJu8zALrZWf+PjH88veQ5jNBTxOlVmpzfUv3E/?=
 =?us-ascii?Q?N1HPWPmDBfw2YkEgzvvRYuhQ8Sfkn+ZnZ0iVh6d4w2YL1XxzAqrrGf8RgzPP?=
 =?us-ascii?Q?zvw9VpsnkS3ISanOKvqgLDte/Xd+gRtNrnfO4c6EDD/GVdUNBM76vKuSDlBX?=
 =?us-ascii?Q?m7Xi028zuiFl/zi1BiAyypn3WAtGQQsc3HwOzdfI9ZAq9I4Eq+b7C7HmIRO9?=
 =?us-ascii?Q?YEZ5m9XoHeo1cABuIFxz5M0eb/RrL16u7soRmZrb5kn1yFOjIX905aTS0D2d?=
 =?us-ascii?Q?iylSRpTfH+/+t2LTa9tWtzqFkQPOIM65F7bVMafHE9Wp4jnllwYmMdXwtNZ7?=
 =?us-ascii?Q?5xDGl5UjS4AFFXsmJALHj7UJx9hI1JwM+peLkaMT3HBVmUunc6OteB9OVo1i?=
 =?us-ascii?Q?J2Lcry2zVty/udaiVi0vXCrW1I4Wy+p4I+qPoogS7pWaqDhOlDIOyhz+qn0y?=
 =?us-ascii?Q?sXldlYdWLZyMFN6DrnaapNetD2krn96rXPCScQ8boWdcFSUj9Jg8/DMePrx9?=
 =?us-ascii?Q?FZLOkvZN74ZZRkiVA064xT+tHFK5d2LV/4+pqkSvQTSH8DKywBhYLWdUcESp?=
 =?us-ascii?Q?9OvWKtCjmEV20rlcg4fL8hXgxlLeQxE53K5OvP9ld1nlkAkfFMSrugR83IAw?=
 =?us-ascii?Q?dQfU605VlEchk95yipo09Ni0na7FVfPxR5k3nLEOlrTg307I0XKfMy1Sk8aV?=
 =?us-ascii?Q?r++YNR2l5MgnscYKNCf7pZAuB+l6nTqfPBccM2fpPJMokhqW+4WtgV54rE0B?=
 =?us-ascii?Q?IjhpJJwOFQUYyhSy3Lk7BjuegTZSwO1VVgMLS2ET5gUcGYlmlpts+5Xjop15?=
 =?us-ascii?Q?2i6vwnKhQwkZ78xpmpy96cajtmjL02q4tticwW7thmx8h9KuyrqjnSDqJxy3?=
 =?us-ascii?Q?6dVyfjSNHIDGsYtGkOtalND69llgoafwzIpeh/kWIyNka/O/CXBAh6aVnfMt?=
 =?us-ascii?Q?zd3dkBuCTsDutDGELaOSPD+/wul+Gv0hP12tU4J3AQ=3D=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV3PR11MB8603.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?nKNu34PClQmqUQKzkoIDJbHpdAmkU9VAEW+i61Ts2EVQQ1Zn2vGlxSrzBtjy?=
 =?us-ascii?Q?woYdWb1lulIS+Ka2Vpzoiv+YfJfP+6Zs2NAfYXmd9Vc0xLQfS4U8JSXcCf0m?=
 =?us-ascii?Q?Y9saULfuNSQb8QlmID1UBbD8Jlg7RBdMaDEi4kstFZz763me1zfP32siD4zD?=
 =?us-ascii?Q?X4HNcA0mRQ8oCNNV0MFlO8xQ4q5RgPNXUdcsFJsuBQDNsMRSSTHLOhuuJR5u?=
 =?us-ascii?Q?QRIC6TuEcNgjBzIrhjQqPo5FmTzk0QDz5NsdLvRA9n3kY2OuFLKCscbC9rVQ?=
 =?us-ascii?Q?DQdYMDmWysP+FOrUT0fAAUeYecX/TurGERlJXQd7ybyZ1bt+vji6SP6SfqPT?=
 =?us-ascii?Q?el2Q25eplSu+0KROq4LM0NYjUZkHViID4Y1OMKp5xWtCU0+TbXnJzh06rUD0?=
 =?us-ascii?Q?FSMnHhbxd8MAaiIYXsvcIP+iARLO2oJMutyWLtCRufMwgIZHjeGviRjG8NlG?=
 =?us-ascii?Q?hx6FznDQ/2uZq5ktMTDXExntaNSqf8OywsAitYjw3UmR4CMaCBKGvrfPbekQ?=
 =?us-ascii?Q?6Tig1xLBKTcrmIrrzK2CEwW+bIuAbvTX/GY7pV5E38HNEQ0GTG12Yy0R99Tr?=
 =?us-ascii?Q?Y+LWN89rb2sjdvcEk1/r+Ns2uy4AcY9r0oNbnMYrxtdeirX4ejWbI9bBCVia?=
 =?us-ascii?Q?ytxy/51BsoECul/f/fDRr0YVRG6ksU+kq23ArvF9zYFx7nqkpHOv+Hyezh0c?=
 =?us-ascii?Q?HB1xSIM/Y7VBAOGeHR4NAtJCDPrSdLLfwWCDvYHUuXBluYOleCG6Gxme9k6w?=
 =?us-ascii?Q?5NYbp1xxxDbWwDvbdlbGqa5BDpZB+j7IgGT7V4cIDJivVSEk0mEKVwyCGvU0?=
 =?us-ascii?Q?JWZkdyxVBCj5DSP9Fuy7XlcYsrUPWTjyhFU4bF133mb2xuG2EPGHpjE/ct8r?=
 =?us-ascii?Q?2OI3qKIH1iIQG3skhIPiODUdrEBkastwiRdBRvNBRPhjldzfJP+J7KqGGDC9?=
 =?us-ascii?Q?BWZ769RuYkK7mCz/pUIhjK/FHgYMLoE/va3PbrbzRjsaUZYUurU06XSH2fpf?=
 =?us-ascii?Q?N+Dx0j2gLG6jjKojcowJu7yqXVMUc5i31EDQdu13ZOc8Kaw8UE6Ineb0tnv2?=
 =?us-ascii?Q?FN9A6WsQKRnGr7Wjeon+zgwCx7r0gk4KQ2zAiCZ502wkhozwDzlCyRPZV3c2?=
 =?us-ascii?Q?N8VlgasjeZ0hRUgtWzlR+Y3YI6WQY4L7+dotsP1y4B92BM3FzIlcfXch4j1Q?=
 =?us-ascii?Q?FuH3nRdv+8TeEnxUIdpH0BJ1yumqtyylh7tFsL8FpyauDBPDDcStzvOndOn6?=
 =?us-ascii?Q?0mfGhuxGJTj5CIufq8iRMNyiAKo4/r46rwzJpjnIxh8ETM2HYJq4lE2d9qDx?=
 =?us-ascii?Q?qc/QsRaSxAb0qxkEsRXec5LQ7ZWNfMORYRC1ye0BX2E35/DctKmltfzcspYs?=
 =?us-ascii?Q?Y5M3jGvB4Cm9PLO9OKvR3SjPKAM+t4p1iuP4WPnRkDV75u2/JV0BSrnkamIq?=
 =?us-ascii?Q?eOKrgRcCeM4SWXiHvE9cdKaMe9bnNpu00q1U8eTr5X3w/hSG9BDAYPM2Lb6i?=
 =?us-ascii?Q?dPD/Qqv7wofeer7skYvRXVci/wEQDho95Tyzcj2cDeNYXzSFolyoPpWs4SkB?=
 =?us-ascii?Q?DqqcN+GlWyOciouyqXDGCt7ZBHRdnU7c+3BdSMlm0W99mpcXX/x2YZoBLAfe?=
 =?us-ascii?Q?tQ=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 0e53ac41-3a0a-4d26-6bf8-08dcfd3ec161
X-MS-Exchange-CrossTenant-AuthSource: LV3PR11MB8603.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Nov 2024 02:08:35.5617
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: TN9qzy0M/P24dKfPXtKO1yHDC6dJ7C/8X1DYpNveETNdDUun3Tspy4Ix5ud/DzyBoYoC2utyYXu1QqCiGayXXg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB8225
X-OriginatorOrg: intel.com



Hello,

kernel test robot noticed "BUG:sleeping_function_called_from_invalid_context_at_crypto/internal.h" on:

commit: 1e1d7cc33bd78b992ab90e28b02d7a2feef96538 ("[PATCH 4/6] crypto: ahash - Add virtual address support")
url: https://github.com/intel-lab-lkp/linux/commits/Herbert-Xu/crypto-ahash-Only-save-callback-and-data-in-ahash_save_req/20241027-174811
base: https://git.kernel.org/cgit/linux/kernel/git/herbert/cryptodev-2.6.git master
patch link: https://lore.kernel.org/all/bffef4bab1bf250bd64a3d02de53eb1fd047a96e.1730021644.git.herbert@gondor.apana.org.au/
patch subject: [PATCH 4/6] crypto: ahash - Add virtual address support

in testcase: kernel-selftests-bpf
version: 
with following parameters:

	group: net/netfilter
	test: nft_flowtable.sh



config: x86_64-rhel-8.3-bpf
compiler: gcc-12
test machine: 36 threads 1 sockets Intel(R) Core(TM) i9-10980XE CPU @ 3.00GHz (Cascade Lake) with 32G memory

(please refer to attached dmesg/kmsg for entire log/backtrace)



If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <oliver.sang@intel.com>
| Closes: https://lore.kernel.org/oe-lkp/202411050927.673246d5-lkp@intel.com


kern  :err   : [   43.366785] BUG: sleeping function called from invalid context at crypto/internal.h:189
kern  :err   : [   43.367576] in_atomic(): 1, irqs_disabled(): 0, non_block: 0, pid: 2600, name: socat
kern  :err   : [   43.368344] preempt_count: 101, expected: 0
kern  :err   : [   43.368804] RCU nest depth: 1, expected: 0
kern  :warn  : [   43.369258] CPU: 6 UID: 0 PID: 2600 Comm: socat Tainted: G S                 6.12.0-rc1-00092-g1e1d7cc33bd7 #1
kern  :warn  : [   43.370202] Tainted: [S]=CPU_OUT_OF_SPEC
kern  :warn  : [   43.370639] Hardware name: Gigabyte Technology Co., Ltd. X299 UD4 Pro/X299 UD4 Pro-CF, BIOS F8a 04/27/2021
kern  :warn  : [   43.371552] Call Trace:
kern  :warn  : [   43.371871]  <IRQ>
kern :warn : [   43.372155] dump_stack_lvl (lib/dump_stack.c:123) 
kern :warn : [   43.372574] __might_resched (kernel/sched/core.c:8632) 
kern :warn : [   43.373014] crypto_hash_walk_done (include/linux/sched.h:2031 crypto/internal.h:189 crypto/ahash.c:201) 
kern :warn : [   43.373483] shash_ahash_finup (crypto/ahash.c:96) 
kern :warn : [   43.373929] crypto_ahash_digest (crypto/ahash.c:747) 
kern :warn : [   43.374390] crypto_authenc_genicv (crypto/authenc.c:151) authenc
kern :warn : [   43.374929] esp_output_tail (net/ipv4/esp4.c:627) esp4
kern :warn : [   43.375417] esp_output (net/ipv4/esp4.c:701) esp4
kern :warn : [   43.375869] xfrm_output_one (net/xfrm/xfrm_output.c:553) 
kern :warn : [   43.376310] xfrm_output_resume (net/xfrm/xfrm_output.c:588) 
kern :warn : [   43.376763] ? __pfx_csum_partial_ext (include/net/checksum.h:120) 
kern :warn : [   43.377252] ? __pfx_csum_block_add_ext (net/core/skbuff.c:103) 
kern :warn : [   43.377754] ? skb_checksum_help (net/core/dev.c:3346) 
kern :warn : [   43.378215] __netif_receive_skb_one_core (net/core/dev.c:5662 (discriminator 4)) 
kern :warn : [   43.378732] process_backlog (include/linux/rcupdate.h:882 net/core/dev.c:6108) 
kern :warn : [   43.379163] __napi_poll+0x28/0x1c0 
kern :warn : [   43.379652] net_rx_action (net/core/dev.c:6842 net/core/dev.c:6962) 
kern :warn : [   43.380078] handle_softirqs (kernel/softirq.c:554) 
kern :warn : [   43.380518] do_softirq (kernel/softirq.c:455 kernel/softirq.c:442) 
kern  :warn  : [   43.380907]  </IRQ>
kern  :warn  : [   43.381196]  <TASK>
kern :warn : [   43.381485] __local_bh_enable_ip (kernel/softirq.c:382) 
kern :warn : [   43.381945] tcp_sendmsg (net/ipv4/tcp.c:1361) 
kern :warn : [   43.382342] sock_write_iter (net/socket.c:729 net/socket.c:744 net/socket.c:1165) 
kern :warn : [   43.382781] ? sock_recvmsg (net/socket.c:1051 net/socket.c:1073) 
kern :warn : [   43.383199] vfs_write (fs/read_write.c:590 fs/read_write.c:683) 
kern :warn : [   43.383598] ksys_write (include/linux/file.h:83 fs/read_write.c:739) 
kern :warn : [   43.383987] do_syscall_64 (arch/x86/entry/common.c:52 arch/x86/entry/common.c:83) 
kern :warn : [   43.384406] entry_SYSCALL_64_after_hwframe (arch/x86/entry/entry_64.S:130) 
kern  :warn  : [   43.384937] RIP: 0033:0x7f39ddcef240
kern :warn : [ 43.385348] Code: 40 00 48 8b 15 c1 9b 0d 00 f7 d8 64 89 02 48 c7 c0 ff ff ff ff eb b7 0f 1f 00 80 3d a1 23 0e 00 00 74 17 b8 01 00 00 00 0f 05 <48> 3d 00 f0 ff ff 77 58 c3 0f 1f 80 00 00 00 00 48 83 ec 28 48 89
All code
========
   0:	40 00 48 8b          	rex add %cl,-0x75(%rax)
   4:	15 c1 9b 0d 00       	adc    $0xd9bc1,%eax
   9:	f7 d8                	neg    %eax
   b:	64 89 02             	mov    %eax,%fs:(%rdx)
   e:	48 c7 c0 ff ff ff ff 	mov    $0xffffffffffffffff,%rax
  15:	eb b7                	jmp    0xffffffffffffffce
  17:	0f 1f 00             	nopl   (%rax)
  1a:	80 3d a1 23 0e 00 00 	cmpb   $0x0,0xe23a1(%rip)        # 0xe23c2
  21:	74 17                	je     0x3a
  23:	b8 01 00 00 00       	mov    $0x1,%eax
  28:	0f 05                	syscall
  2a:*	48 3d 00 f0 ff ff    	cmp    $0xfffffffffffff000,%rax		<-- trapping instruction
  30:	77 58                	ja     0x8a
  32:	c3                   	ret
  33:	0f 1f 80 00 00 00 00 	nopl   0x0(%rax)
  3a:	48 83 ec 28          	sub    $0x28,%rsp
  3e:	48                   	rex.W
  3f:	89                   	.byte 0x89

Code starting with the faulting instruction
===========================================
   0:	48 3d 00 f0 ff ff    	cmp    $0xfffffffffffff000,%rax
   6:	77 58                	ja     0x60
   8:	c3                   	ret
   9:	0f 1f 80 00 00 00 00 	nopl   0x0(%rax)
  10:	48 83 ec 28          	sub    $0x28,%rsp
  14:	48                   	rex.W
  15:	89                   	.byte 0x89
kern  :warn  : [   43.387012] RSP: 002b:00007fff1b6b3288 EFLAGS: 00000202 ORIG_RAX: 0000000000000001
kern  :warn  : [   43.387756] RAX: ffffffffffffffda RBX: 0000000000000007 RCX: 00007f39ddcef240
kern  :warn  : [   43.388465] RDX: 0000000000002000 RSI: 000055ba398a7000 RDI: 0000000000000007
kern  :warn  : [   43.389173] RBP: 000055ba398a7000 R08: 0000000000002000 R09: 0000000000000000
kern  :warn  : [   43.389881] R10: 00007f39ddc104f0 R11: 0000000000000202 R12: 0000000000002000
kern  :warn  : [   43.390590] R13: 0000000000000007 R14: 0000000000002000 R15: 000055ba398a7000
kern  :warn  : [   43.391300]  </TASK>



The kernel config and materials to reproduce are available at:
https://download.01.org/0day-ci/archive/20241105/202411050927.673246d5-lkp@intel.com



-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

