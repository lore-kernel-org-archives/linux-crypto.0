Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBC4810E4
	for <linux-crypto@vger.kernel.org>; Tue, 20 May 2025 07:57:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.8
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747727834; cv=fail; b=VkH/5SN7E5icp8SxTqtVBlP1tMZGscMZnUvlZ15iE/YeE7OQGR8TxVBiApV0WfSvSM8kXRAzDCm1NhgQUr/kqv3S8ZqWbzSg6X1rwwczx8O6cYQ+xC6WInJ+WgsFEd58ghRJ71AO4ecIeSfL7j+0SRWRHJFfYnfFwPRPNtM62wo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747727834; c=relaxed/simple;
	bh=fRjqAyMmT+FA6reBA5jIMeGWiR0g0/2LQTMvwIMc9JQ=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=FilJhKzXBljVmW6+NxA+KaK3nnYAWK0ySZpTfUwb8k/seoku9texc9r23so6DGIUUdForPoFiTwUZmT9GTxh/i5Y9BN8A63XwgFiscc8auB/L8rwZ9VE8TbBNSuOlQTSw4H3O4kkdbWYDwwwxYXf/eJZVLElF+OYRViGs3exYz8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=JJYSlszS; arc=fail smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="JJYSlszS"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1747727833; x=1779263833;
  h=date:from:to:cc:subject:message-id:references:
   content-transfer-encoding:in-reply-to:mime-version;
  bh=fRjqAyMmT+FA6reBA5jIMeGWiR0g0/2LQTMvwIMc9JQ=;
  b=JJYSlszSgnkAmGnN3ajbIEOQu2CV1aHXSlDysPqAgA6Sg5c9LYwi3I8B
   HTo0z3CaEIunrqGASRj7y6FDA4p7moDOWwGTuX2qDdUW+RTOtdWr7S1c5
   +bp7ZPgRYie7rnMimPQFw8W+McysKhC7g8V6tg9hEKLsr9A4U9nkxdj7S
   RYv8Xgs+eWRhkgXkzIR8Dx+BQaJjm4BhCKKytoWO04u2ma7cQp7DN7zuc
   UkIa2OpSdzjaeFsvyNivwu+0QSVJTqDj2Jx8uqezyAYL59cXiwKCjYIud
   kKSAfIRH9GgDUJqOTRnnoZztLJLucNoCoRxlSNtDceJennur1hhSlN3dB
   w==;
X-CSE-ConnectionGUID: A8oezV2pTQKzige6XIDplQ==
X-CSE-MsgGUID: +3gMIVYlRhyqIKi/Dk1FkA==
X-IronPort-AV: E=McAfee;i="6700,10204,11438"; a="67202814"
X-IronPort-AV: E=Sophos;i="6.15,302,1739865600"; 
   d="scan'208";a="67202814"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 May 2025 00:57:12 -0700
X-CSE-ConnectionGUID: 1KqN3khyTI66Q4OhgLaVhg==
X-CSE-MsgGUID: BGFdx7G1SNqMhG/xl9ZaAg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,302,1739865600"; 
   d="scan'208";a="170505414"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by orviesa002.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 May 2025 00:57:12 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Tue, 20 May 2025 00:57:11 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Tue, 20 May 2025 00:57:11 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.40) by
 edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.55; Tue, 20 May 2025 00:57:11 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=qCfIW0WHkQhzkjBzNea8IMRJ2FJzw3rwC0eAQK8aTzZUL3LozGvTdskL6qpA+m5Qti4nbcj7g/kpyMyywdxOOGR/Vuz8kU9n9MQme9mePSEM+S8upLzcpLyvTwNKbMwrp2OPNrLTMR8OprHKcVD965QPAXUOcD9v9kOZ7YukEg5C9cu4AoVrVFW24pK0PDvOKHAn2NhmAvfrtHK54/VfCRV7o+oKhLQPm4WETw6Aw7mkZ467IBR7W6TFI9MhAQmgJ5oBryNecs2Of1mx/0OvP3U86AQNXGzTrxNgrQYOvQM/6+avCUabN2cBAp/Um+gUDIqJNK6nhROxmjVbeOJgjw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lp7sJmW9ddiyyD/xVl6dixqBh2Px9P+R7qHzEO9eVGU=;
 b=CVwl9jbV51EcEuX6JD6jFQpX/+ZCATfsRhF2D8R6CuTXx06bbKtTh7p7vMnNz2nL3BWkHS3W47eofv1tUoLAp6rkzfvNdGfpCOvpAFy/qJDvJ8D04cNGIYYxUa3NtJmHqTRGo/GJPkZld4QhrcQ94GX42AjjKxBsRRXeKkVk/7U3YnHVb8GoMpDKbW1+StQF24sjbZL7MWqa/DB/gleFmhVgO/tPodyLRgtrqDiYX88XgpVD6f94zIB920J1b5xn5Veg0cH3OV3rygJo7TNy/ZxCFL42Sckg/eZaYhbnAgAp573ikKXemuiWMdjJraZCTUw4OUDgK+6BEj3fnN6TUQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM4PR11MB5295.namprd11.prod.outlook.com (2603:10b6:5:392::14)
 by PH0PR11MB4919.namprd11.prod.outlook.com (2603:10b6:510:34::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8746.31; Tue, 20 May
 2025 07:57:09 +0000
Received: from DM4PR11MB5295.namprd11.prod.outlook.com
 ([fe80::769a:177e:10f2:f283]) by DM4PR11MB5295.namprd11.prod.outlook.com
 ([fe80::769a:177e:10f2:f283%5]) with mapi id 15.20.8746.030; Tue, 20 May 2025
 07:57:08 +0000
Date: Tue, 20 May 2025 08:57:00 +0100
From: Suman Kumar Chakraborty <suman.kumar.chakraborty@intel.com>
To: Corentin Labbe <clabbe.montjoie@gmail.com>
CC: <dsterba@suse.com>, <terrelln@fb.com>, <linux-crypto@vger.kernel.org>,
	<qat-linux@intel.com>, <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: zstd - convert to acomp
Message-ID: <aCw1zDuv45AHR3YN@t21-qat.iind.intel.com>
References: <20250516154331.1651694-1-suman.kumar.chakraborty@intel.com>
 <aCpKwjzLoqUi5ZwK@Red>
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <aCpKwjzLoqUi5ZwK@Red>
X-ClientProxiedBy: MA0PR01CA0035.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a01:81::6) To DM4PR11MB5295.namprd11.prod.outlook.com
 (2603:10b6:5:392::14)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR11MB5295:EE_|PH0PR11MB4919:EE_
X-MS-Office365-Filtering-Correlation-Id: c294d63e-4008-4517-d20e-08dd9773eb5c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info: =?iso-8859-1?Q?IIjtq+rSnkSrrycpgrPhJbdfskkw4xj3Iukt+ZcebdSJBlRygNNz8sYG2N?=
 =?iso-8859-1?Q?XgxYFA2CoXAYfx7g6So8rl8REaxbjlyiBHEXqIKiqohWpHuOlJDN3YZqJM?=
 =?iso-8859-1?Q?NPVeC5W6wB6e/257fwvgkYevI/CD9wsvWjOhYlxKPU67n+93jzq278yMFx?=
 =?iso-8859-1?Q?2Z0rj1QbyoCAEufHB9iIgQGyvzdU8nxmobrV3PVSuze7SuGMlOjIv3rvRv?=
 =?iso-8859-1?Q?i4TLP73+FLmDNgqDQgy24tbpV9twlQ4rJS1CEMZV3tvpYBfTo9lgsb6y5V?=
 =?iso-8859-1?Q?puFzpuXf2FLlpWga0i+sRxYGliQ0XvuMOTFPnF/kRnc3+ibAiIUPnM0IgM?=
 =?iso-8859-1?Q?4a/BnlvlQM3ANsb+q4hG9YY9EkF2u2XKPuztUknTEuU5Ek/75EHuMGHAJS?=
 =?iso-8859-1?Q?YPdxrojvNPDj87pQEWoZUiw5Cw/FC2t0JZpuU8Y+XDh1BACLcr9J0tfJQ2?=
 =?iso-8859-1?Q?zW582Fp28FqA5fOmup69o5LfD/hTAOBGpLQOdiLxSrD0x72bLJ7FaQdPI3?=
 =?iso-8859-1?Q?+cRc772xZTBaWoPDGVTLMJLIVnkrxIaJupijLrZwn2sMgnPiVjQiED9ZCO?=
 =?iso-8859-1?Q?NVJ35gCy69ltnzjLA5F9kH/9VDMjA/kW/xesG1SAKn5tyUmuYLu9FWtOP+?=
 =?iso-8859-1?Q?6997lw09IWARbLGOSwQLSxy+VwFlGqGsgqWm/lfVIcBVC6oQjK/Z1hNhsG?=
 =?iso-8859-1?Q?sXxeFA/9NNtpsX46fR2Tu3zw7/aBN5Td63QqQ9HDhJ9NBAlqx9m+w25dWP?=
 =?iso-8859-1?Q?3Je4vthn88T7vSwSCy1qOE78XFMFTINM29N2d66Qvyb3NRSK1km7VCfpCW?=
 =?iso-8859-1?Q?niYJ/14HCKggRe7sB05BhRcyxShpc+1Cm7Bq1e6A91d4SaCn6e5bYP9zL4?=
 =?iso-8859-1?Q?DV7Kg4oDAWf15mQadRppxs6DkWHJrnLqwLW9fRyYuJWgyn3qzIDvMYk1zk?=
 =?iso-8859-1?Q?YAGidFKeDGRVdrTgjGiWUxbVleoVNxOvChpbdIarwAL5Y73p692Ww6cpa6?=
 =?iso-8859-1?Q?TNv2oSbrLUHKawXgUI46oodq4jmX5VyQvCuJT6fK4igkUuLHPhbp9O4L39?=
 =?iso-8859-1?Q?zjqLLIg3vOc83C4ChQAH0fHyxEPoQMrfxLsMEU96BPvPzrhkPQGCVOwscy?=
 =?iso-8859-1?Q?Qz3lWjTgUpe059nHDgOJDdrzGt5VxPz68yGZw2U+iQiWtFht2Gw+jbTusO?=
 =?iso-8859-1?Q?wpNCo88FPaiDL1g/ZVyMoBoI3yrGzbZ2fN60fmwlR7MLOa3qestmS/SORM?=
 =?iso-8859-1?Q?+ePVcsbLQQHNPwtV0idRCdiRP1VTkwv/TR9M5Zk4v2W8pwmLEIHzIi0hwf?=
 =?iso-8859-1?Q?gD9Xy1QTOm7MzKXYN2oOTd63aAJ8gf0B5nsa+M9sFCB1YXYMVqkGhGXGbo?=
 =?iso-8859-1?Q?clTqmHHzpII9XSSqSrHVOyMSSNi0HwEmtA2duBTUOBds1Xdpyzj3gtKe2o?=
 =?iso-8859-1?Q?bLk7EnDIZmhBN+qVEjl+zISmXUxAAweXIaIVWGQWhYht5V1Z6Xx8lX4UqR?=
 =?iso-8859-1?Q?k=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB5295.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?iso-8859-1?Q?yk5jMVgpY9iuFkqp0RbELgbvs98bonuERa+iOewc4+QARL/U0vrRIo2oCA?=
 =?iso-8859-1?Q?ynUr8kuOvoVOQfligIej+2h5qxkDPA8TntzzQsExq/VCEx54xX74/d5ZZ2?=
 =?iso-8859-1?Q?ZnT+5Nk8Cbq7Tm0QyT/rGvEzZmNe8NGMZ/UrNXHK/GC70K4aFQnEuI7kaI?=
 =?iso-8859-1?Q?1Lw0Fh/WXmVAuQP4eYLNjzxGda50+LuNT7xKsLCdbhNjTh3ahWmPz4ZBP3?=
 =?iso-8859-1?Q?ql4ovkqgTCGL+5+LYqzh4wYqiK2MbWWpas8MnE6Hg7IxQFIM5u0EcX4T2J?=
 =?iso-8859-1?Q?j9nWseUH/GgfRDNkAF7M7wKcbIg9iJuLvtzjTQ80v7oty5l5IdnB8FkiSZ?=
 =?iso-8859-1?Q?l8SPQpegZBeBpGQYmlMLTs72Rbh9T5Oqa1XpltEAT+PhPu4ODix84A91Nn?=
 =?iso-8859-1?Q?k2l7taWVaG307e4/S4iyCO0tpI+n65Idpi3xnwNw5nFjkaiivHBgwoMldy?=
 =?iso-8859-1?Q?15u+WamLCbdBbrBHzti9uG9y7c9mYG9XJ6J561t1H/K+Rkk2nQQJasJb1i?=
 =?iso-8859-1?Q?4dwjWvXDCrsfnJIDzeczgrTclTOZS7SePEQPqQVAlg6lF8jDC1EYkMOP2X?=
 =?iso-8859-1?Q?hv0Esa7mwfsBlS0McgaMo7Of0jSc+kYmQbkPiGERv46vDDEKUc6Yi4goZE?=
 =?iso-8859-1?Q?Sd1W7cuui3r73K+htsvv5PJBEzkyOxegtMt5RqQXEUeCQxF/VpkE/YG+QG?=
 =?iso-8859-1?Q?5OmxAObj8kfhIgtePq815j7+eaWvWHZFY+HZra/Lqqtf5wVVC7B2hHTcgM?=
 =?iso-8859-1?Q?R7dFWl1/OggDZPQauaoX/sKLiG61L1S4JKXbl3xQPE7nfJubgp179hjcVJ?=
 =?iso-8859-1?Q?fUND7x2yIUPTjoEMcki5g+F1K4SpzEQLrLo7XEp4PZ7L/9ChP3mymFVzfC?=
 =?iso-8859-1?Q?jdiK+nKyTOMGdJvcFHnLo5JQkKdFpkCZ6zXBMJ3rplg+PtpplUIpMTalXz?=
 =?iso-8859-1?Q?gKZODtVuYa85yvIDNXSVq8Ecr/Pk9jvZpiNXB2sj/ZPdvjvFA2I5hcZWpQ?=
 =?iso-8859-1?Q?C98Rpj/W6LNJw2+QBvlX38hRyb5eCwBcczu94DfsNPr+ZIkWQhbgNEfIWs?=
 =?iso-8859-1?Q?EdkJlSjmdf22sYZiRgyzqDcaiDEo/YmcFsJhaKkr103W7yTYbOnjjRPbqq?=
 =?iso-8859-1?Q?gVFa14aFkMfWtOVK3Oyrj2oWzlJ27iZSp41i5r5uZP4Po2f8eLgICRCo6/?=
 =?iso-8859-1?Q?KOaXxRpIBkKnPNRTuNwiwCkoXG//9kODz6S7IJS0Ijf5EwxEILtIInO5uO?=
 =?iso-8859-1?Q?ZRuBS9PcYlKrpir0ORGi7JqXHnpX2UXpXpTXmnI4jPLqTNyQjaRVqsZEzL?=
 =?iso-8859-1?Q?tpnj4W9WNVaYOOG62ZWdAbATaB9YLxJvvE4/MYwCFmMgkse6pReBb80CMZ?=
 =?iso-8859-1?Q?nJF6SdxWGwz1WxUbUoYSO8F6Isg5ZizN+GlVpQ1kWZdXCNAS/klrTk5yV+?=
 =?iso-8859-1?Q?qmo2c9gmHcyT0/HuG/IzA5hpqpolHQZ9B3u+eb0Oh6wvJ7vcf7GCTkxoUX?=
 =?iso-8859-1?Q?uK2Aa9wrWMMBXT0ZEi+MHvtt/GZDILeDKuhyGqv76k7W/DHAqKE3yLlgeQ?=
 =?iso-8859-1?Q?WfBHjTmY66ge7w1BIGhkA6ncLswfhKWeM9XGNE0sjJI0D0BqHsYJVaf5PI?=
 =?iso-8859-1?Q?5++w5O10S4F3f79njJ9tFDiNR56oIZHKfO+sXMby44T3AOlQH8q56dpQnd?=
 =?iso-8859-1?Q?wzqDkE7EMoUIS+Ew6NI=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: c294d63e-4008-4517-d20e-08dd9773eb5c
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB5295.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 May 2025 07:57:08.6021
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Qot4/C9rfwejhdZFZX8qIZCl8ucTNk6M8Z/aY2oKWnf3SMLpz9yqCBWYZNP7NGOGz142UZmEb8nQaf9ZmCLlBrsKhylLPJ3hGB8a3LivAeCJGC05ilwdFNSgJT6avZ9G
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB4919
X-OriginatorOrg: intel.com

On Sun, May 18, 2025 at 11:01:54PM +0200, Corentin Labbe wrote:
> Le Fri, May 16, 2025 at 04:43:31PM +0100, Suman Kumar Chakraborty a écrit :
 
> This patch lead to a selftest failure on qemu ARM:

Hi Coretin,

Can you please share the below 
   - Configuration for the VM, including size of dram
   - Kernel config file

Can you try increasing the DRAM size in the QEMU configuration and
check whether the self-test passes with the updated memory?

Regards
Suman Chakraborty
