Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12BE9EEDE;
	Thu, 26 Jun 2025 02:57:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.14
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750906677; cv=fail; b=EOyzRus9T3LhKyWTF0CKcXwqZsB8KyLKT8b49K0ioOClVjIBKmi4Yt7RuF42eqPJNgd4gVkXUn7qy8LRRVz24LgsCK4eDv+FIxp08W+BT30t/cHqLy/tgICcE3DMUSPF2WJZsNMg7/hVkLvYLjIcwkiXSgZlZrv1vIkfA1HAZZ8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750906677; c=relaxed/simple;
	bh=TmzfF10ue4hdmERPDQswikILEvs2B7sl+h1zmCakwVI=;
	h=Date:From:To:CC:Subject:Message-ID:Content-Type:
	 Content-Disposition:MIME-Version; b=C4T4pqFMzlOfF45tgSOSEdcgiYAQLOYPOinC4i3qgaFi0qwpLyOQ2WEAoE++Q50ZeR+uAH8y1cH5vORglpZGhrltYGGsPyJTNoGBh7+fKPc3fzeR521KrYZXKwSeryj0Ec7e8THlUpSs/OVjAyPptA+3Om7BxezbkwUYJyIfdhQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ZEOORRtJ; arc=fail smtp.client-ip=192.198.163.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ZEOORRtJ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1750906675; x=1782442675;
  h=date:from:to:cc:subject:message-id:
   content-transfer-encoding:mime-version;
  bh=TmzfF10ue4hdmERPDQswikILEvs2B7sl+h1zmCakwVI=;
  b=ZEOORRtJ84i4UFPZgars+LlOb8Q2WzWLhpbx0x40yOdfBlI6YUQLu/GW
   HZjwuiwdRsV5qqCF3nkFRxFQSLc/Jx64iSpyc7lff0AxTuKLfjBFfU9dd
   xjAve9lWMko0Zeb+jzcx2bVPEX60x8PLBANHKTN1qvMhH+FhuQuYehzy2
   O3p8E3TVYrwE8Cqyya3EyRP3jVy7CfNA2s6LgJqncGp2L3izNXHS5nDsG
   dne0X4Ve3nWKuqHnDNndcwRNvdteBZjAl1ZZvotOihcIImNeoXzMiRiO1
   d4NrOIn/v4OC/pedTTt3u+pX0gSkks7xa/93qZj8VeC9J1dmRFTp9WBTN
   A==;
X-CSE-ConnectionGUID: DKydthTMQByIAXqxQpCFtg==
X-CSE-MsgGUID: /gQjrMWMQ/OowcQ9SGGqMQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11475"; a="53261260"
X-IronPort-AV: E=Sophos;i="6.16,266,1744095600"; 
   d="scan'208";a="53261260"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jun 2025 19:57:54 -0700
X-CSE-ConnectionGUID: oEXEVDExT26mcN+gmddJAw==
X-CSE-MsgGUID: X3wjebN+TUyEDI5pSXdacA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,266,1744095600"; 
   d="scan'208";a="152688592"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by fmviesa009.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jun 2025 19:57:54 -0700
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Wed, 25 Jun 2025 19:57:53 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Wed, 25 Jun 2025 19:57:53 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (40.107.223.84)
 by edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Wed, 25 Jun 2025 19:57:53 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ZZ7RyA+AnK+YJGu/BD0Esfx1OkaCgogUe89jhHxxWehg0cYb8zdFlRrjN5OKLzYzAeCTRFSuzhKwhMHu9j8f4hmiebp9TCoTlJGEGErs5lXWtHbZuChIk4xe1G/6HRBdrliKfkNhrf0Aw+7tkUNOLi6LLQVt4cA7jC7PNFM6LClMKUYsgLdzWDmwiSsj36iitg46iBbNVmRaUnRrPrugBvDb10P08JPDZu8TrqC1A37NrWG+uLTVgTvhgcssW3sehF0GJzwMUm2iZVp9FfpyqiIzoJa53dgm7+pSXzu++djL/ITjVXETvRCuG50iyNzEFzadp0g5ozu6MTEAwevr7g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=L5ML1V940ogtwVwqjhKTlh/PSQ9shOtty0auaCFkurU=;
 b=VysT9ooRXGOhIXShj6yY2xjHVvIf0LV6ckbnmD6pNuANL9vSX70NpDARTdWRNKO0FboBIvFm8DnGAe8KBj8NRpedzX1ubYQh6fY9VETCQ/QhSyW8eX0ziXA8iSezdTgYszFHnBCWZzRfXmNYzpUvYfqp2ffmu9fD2MfBNpBWvhy7i17GdMK8r8pfzvvH4K4wj2JHMrGgCK45vzKZ/e/s5qj1pi+AR+Yg2yotbNKpM7WioV2E9DVJ3A8o0I/aJ+83kGTwbSIeAm+6rnPYwJ5xysl3pUhC6FaQFGtyYCf2ioCKKKGY6OhSQJ8iBqO6qXGalZulHSFd72yH3uNxClnqJA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from LV3PR11MB8603.namprd11.prod.outlook.com (2603:10b6:408:1b6::9)
 by MW5PR11MB5761.namprd11.prod.outlook.com (2603:10b6:303:195::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8857.28; Thu, 26 Jun
 2025 02:57:24 +0000
Received: from LV3PR11MB8603.namprd11.prod.outlook.com
 ([fe80::4622:29cf:32b:7e5c]) by LV3PR11MB8603.namprd11.prod.outlook.com
 ([fe80::4622:29cf:32b:7e5c%3]) with mapi id 15.20.8857.025; Thu, 26 Jun 2025
 02:57:24 +0000
Date: Thu, 26 Jun 2025 10:57:15 +0800
From: kernel test robot <oliver.sang@intel.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
CC: <oe-lkp@lists.linux.dev>, <lkp@intel.com>, <linux-crypto@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <oliver.sang@intel.com>
Subject: [linux-next:master] [padata]  71203f68c7:  unixbench.throughput 3.1%
 regression
Message-ID: <202506261012.11b518e7-lkp@intel.com>
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SG2PR01CA0121.apcprd01.prod.exchangelabs.com
 (2603:1096:4:40::25) To LV3PR11MB8603.namprd11.prod.outlook.com
 (2603:10b6:408:1b6::9)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV3PR11MB8603:EE_|MW5PR11MB5761:EE_
X-MS-Office365-Filtering-Correlation-Id: 97c58cf3-5b2c-4617-e641-08ddb45d2d27
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016;
X-Microsoft-Antispam-Message-Info: =?iso-8859-1?Q?x3RwebgGfgc8RTenl6Ro+Fbysj0jX5c6Cqydh1n4kaf0uVoz1H/mIDR00S?=
 =?iso-8859-1?Q?C3vcKxlRx55KOm96L/dqftptCM5p6ctKn1m+j0j9/nNG6nVd7XB2rgAw0O?=
 =?iso-8859-1?Q?3N7+cm8e7Y6FKRgAh4DJEviCy0aBCVy3y1X3NMyI2v1SQjYU56D9A82MnE?=
 =?iso-8859-1?Q?u1ehrcKSDCx9FtOnl43e4ZCKOxHRloiJAqolJdvsFmt2STrvuuruSncaZQ?=
 =?iso-8859-1?Q?/X0I4DGn3rzJqJephqPMrP8HulmpJ6nAFCCpaQVzOY6zO/QOohItnYgG7Z?=
 =?iso-8859-1?Q?P0EkVUKGY1HG5f5L5H4ukMQbPudExjfQbiVxBCgQqkwYfsDGahyeFkEpZS?=
 =?iso-8859-1?Q?QFQcZl4zWepTRW7yrPjF7dc0XEhy8Z3euxYDl2XP6ItV0WzaTn+lQph0/7?=
 =?iso-8859-1?Q?lS4G8VOZjISHR+QWRaAsKD6w0eHB+DVWH31B++y00p2LilXIOHDWXsNnMJ?=
 =?iso-8859-1?Q?7xPzPHoHEYib+01BF9wfR5RCx2kFljX/zTXLrimxsCQMyuu9mN51oFfpXn?=
 =?iso-8859-1?Q?HPbmcCy3d5jS5mlABzKDWTSaX4XGdmDeY9Yl41PcatkRyjNkdbIPd9+yXD?=
 =?iso-8859-1?Q?XN3Ksqg9uFbVNqDY7SBGXWCXgIV4fxs3eH5AVNOaUiiaZNy/UCWT2rqFBJ?=
 =?iso-8859-1?Q?Zeaqa4bwNycKOa/Ux66kep2ANvAyjxtqkhhV25edsy70HLnNFBS5WerQt3?=
 =?iso-8859-1?Q?euy2ruRZK4Ypl4Xl0rbKmWgPgAoumHrxYKTOVvrrRP39zmh+ptrxxo7KyN?=
 =?iso-8859-1?Q?atVRavSJbV5I/dmHhLYG4M4nYYpnXXHXXwvFu/TWgRHcBpXccB91/VpQiH?=
 =?iso-8859-1?Q?MKV6TuUGbsJEM1Fgw511YAiwttIhUCPfcwyEQ9GoW2FJwgS+KRxA8hT/KY?=
 =?iso-8859-1?Q?RiTzb+6pZjDdoo7Pcm3O/ARJegNMnR+N51h66q4xCCirbKtM+CmBb7tGrs?=
 =?iso-8859-1?Q?HbFExK3DdkjY71LIRka4i2iTpCBcryBgOT2kCG/zMe+T7FjdXbsws0d9+H?=
 =?iso-8859-1?Q?X0k5LtXwOs3Ef+1YRLT0fZ+xo8Td/4quDCdc3uzw0Vv6XzlJE4UUaaG/AF?=
 =?iso-8859-1?Q?heEvlpSuQZGSTGYz5QmTM5Xk53JgCR6m5wtLhQvCYcxlzYkU2AzlivxN+l?=
 =?iso-8859-1?Q?9r89WMLMIF7bHWtlNi7eA6yLmgpis2fwKJWIzpg8oagJRONrHmNr0zS3Ju?=
 =?iso-8859-1?Q?5kgxpjXX+zrDT44M+auA8R1AYJRwIrE6KCviZa1EIUPZE98dfSjzn5qbwJ?=
 =?iso-8859-1?Q?L/YUtGLNemcNlQpg9CI4e/83m5/8lTsWvRgDT6QMkgZ2czlouyyzobTXDL?=
 =?iso-8859-1?Q?tRKSUuaLx9YbBkwm1moVf2TK3WLctpsX/tZNjf5uz4QzFpWZ0+M5mxb71B?=
 =?iso-8859-1?Q?V/UyO56dSq7tr15Gk4mftSVK6tIh+ZfMBR8qNLDtYUBCTJK8x0SuaccE7E?=
 =?iso-8859-1?Q?g/qbfT9mFQDDPo60?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV3PR11MB8603.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?iso-8859-1?Q?qLoMwC6Mpqje3PpOBycT5u+MKNNwpBrc6F5aS3woA8SaCdB5Ih1QyNer0I?=
 =?iso-8859-1?Q?KBI6XKjPKfYCrFKrSUa9QVIGEYthI5uqbiL8wDeRqXGNjxHkDCqlDm0kb+?=
 =?iso-8859-1?Q?iaqeU1DV1xE3IsPz5n0xh8R0DnfMopUzUpY6bdKghy3jikhQ/yAJkW/rHn?=
 =?iso-8859-1?Q?E5Z6YgzqOVVqKfjRrv953ElyEJ6qaoqNOAUjA4MVZPYYPfKIlACqbKpb44?=
 =?iso-8859-1?Q?MoOGUJEMKlbgxnOdkc/q1rtGh/su+tMhNIJiKOoohnoKE5c6e4YDe3IzBI?=
 =?iso-8859-1?Q?zhcntPzi38f8QNCaBqVgiYBvDV5e30Z/y01gJPT4SDLo9dYeqFPy2vkJpQ?=
 =?iso-8859-1?Q?KPg6Su4rg5WsnYMwjNYNgWieM1jKl+1ldcsLNmgUlTfMMiAerWv/G9lQLb?=
 =?iso-8859-1?Q?OSwz3vKshytiG4iGgFwoD5wHxafuIzNzgzOiyQCuW55VDlfJFjzSqAibzU?=
 =?iso-8859-1?Q?L3o8kh63kiPI4tpfRcFm9yCBQOPVLX6yBRj+s/BIxz3WmdT2xxEjXQQuvb?=
 =?iso-8859-1?Q?YMw8DUx+W3EnZJD2A51CoSi9sKHBmrOYS6xHK70sYqh0EJxJkj9HuW3m5W?=
 =?iso-8859-1?Q?/rDbkTsG0NeQ2Vvo5KcOWIhQjOG+feaLB2aAsu/3rKL7RLF5fiWhJiF9LY?=
 =?iso-8859-1?Q?+WUB9bszb9nDRofDJImrAENM4oULBDaij7fYe10VQ7GwUW9PKcD89F6jO3?=
 =?iso-8859-1?Q?eegWyV3PVUafRrOEfksrgI6h9jO0EhsyWPcyV5yE59ubUEMZadxE0jN70y?=
 =?iso-8859-1?Q?aNfFV/nXMoH/1vjOdrZd64OC2TeF3y9NRnLZ1bN8H/FMAeTm441W3EyeT9?=
 =?iso-8859-1?Q?DAQnIRySJIWEtth2wrY0lNQ+VCk5uVoAJmmSB8jdT7NI3Gnrv9efJ1oYRZ?=
 =?iso-8859-1?Q?RZoorgVnbCY+TO9YxqhhdT3hIzCIU6rqTzacmAS+jq/fh/8+wFBIrpWP7u?=
 =?iso-8859-1?Q?IZNza7RTbCrvHCEGr5lmAqEsBvzxoygt5IWn405JPyFDCCfFW7NZ8x6GwQ?=
 =?iso-8859-1?Q?qmx5rKPY+UsHay5yg4IiOdzg2qAyKXfKcOztxHE/yjwWz6g0pQsIr0YvXl?=
 =?iso-8859-1?Q?QUencNfRrMoFl8iHKWAMszaytQXeWyi/nmp/n5B49o3VqcyHT/NWjFzA8a?=
 =?iso-8859-1?Q?uzloSOxTTtaoXCf5ec1BhMOOpWcLbHUzmDZQulAN4XvmizLSq1sLGifUKQ?=
 =?iso-8859-1?Q?p7X6JD1dWQ9o5mvjN7eY7vVeFhNsdooGnCpUS5FOBQYC013fpX4gd2oRSH?=
 =?iso-8859-1?Q?ukMnAFbIYaZ9EPLdmLeOC4cAmRMO18Ho7yyAAU0l/sxRCgKHayQ7Oe9YPH?=
 =?iso-8859-1?Q?znsGY/EZu/aUbM2w8pef2Xp1oB+aUdnWhJYIJ6eetoovIAV71JXdyS/aBp?=
 =?iso-8859-1?Q?kZ0ooirpknaatE6dtA6xfHowosQuujU9XxCpmNWMBakQI+/NMBIb813bNY?=
 =?iso-8859-1?Q?N62kMGkflS96ObPRtf4r5svKmp4H5Wag3q1e+TIGNwHDP2dd8ovy/QMW5B?=
 =?iso-8859-1?Q?lVMNNLbU0GKumQSCJ7I619u4J2Ed7Z97NlHv4EiPQB+VtFyJm14WokW52G?=
 =?iso-8859-1?Q?EpDCWl9jE8/1jhdpfYY3j8xJPgKt7JBA6p6D84g/PeCk+hw2papQpYO2Sj?=
 =?iso-8859-1?Q?ki5oVc/rDCv4HKnXSbF8L7x7J1hkGyL3s1phkaOAPtj7PIrWA0214B6Q?=
 =?iso-8859-1?Q?=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 97c58cf3-5b2c-4617-e641-08ddb45d2d27
X-MS-Exchange-CrossTenant-AuthSource: LV3PR11MB8603.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Jun 2025 02:57:24.0654
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 42lgSaEgMz/AudjCi5WXN9EJ+PMnFnAlDIU4UVkAEphanQFR29t8zstiSdnhcyayB+SwBZ8GDxSgagbcB7u/ww==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW5PR11MB5761
X-OriginatorOrg: intel.com



Hello,


normally we won't report performance results if we suspect it is caused by
alignment problems.

since this patch touches the code related with alignment:

-       struct work_struct              reorder_work;
-       spinlock_t                      ____cacheline_aligned lock;

we still make out below report FYI what's the possible performance impact.


kernel test robot noticed a 3.1% regression of unixbench.throughput on:


commit: 71203f68c7749609d7fc8ae6ad054bdedeb24f91 ("padata: Fix pd UAF once and for all")
https://git.kernel.org/cgit/linux/kernel/git/next/linux-next.git master

[test failed on linux-next/master 1b152eeca84a02bdb648f16b82ef3394007a9dcf]

testcase: unixbench
config: x86_64-rhel-9.4
compiler: gcc-12
test machine: 64 threads 2 sockets Intel(R) Xeon(R) Gold 6346 CPU @ 3.10GHz (Ice Lake) with 256G memory
parameters:

	runtime: 300s
	nr_task: 100%
	test: fsbuffer-w
	cpufreq_governor: performance


In addition to that, the commit also has significant impact on the following tests:

+------------------+--------------------------------------------------------------+
| testcase: change | will-it-scale: will-it-scale.per_thread_ops 1.1% improvement |
| test machine     | 104 threads 2 sockets (Skylake) with 192G memory             |
| test parameters  | cpufreq_governor=performance                                 |
|                  | mode=thread                                                  |
|                  | nr_task=100%                                                 |
|                  | test=pwrite1                                                 |
+------------------+--------------------------------------------------------------+


If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <oliver.sang@intel.com>
| Closes: https://lore.kernel.org/oe-lkp/202506261012.11b518e7-lkp@intel.com


Details are as below:
-------------------------------------------------------------------------------------------------->


The kernel config and materials to reproduce are available at:
https://download.01.org/0day-ci/archive/20250626/202506261012.11b518e7-lkp@intel.com

=========================================================================================
compiler/cpufreq_governor/kconfig/nr_task/rootfs/runtime/tbox_group/test/testcase:
  gcc-12/performance/x86_64-rhel-9.4/100%/debian-12-x86_64-20240206.cgz/300s/lkp-icl-2sp9/fsbuffer-w/unixbench

commit: 
  73c2437109 ("crypto: s390/sha3 - Use cpu byte-order when exporting")
  71203f68c7 ("padata: Fix pd UAF once and for all")

73c2437109c3eab2 71203f68c7749609d7fc8ae6ad0 
---------------- --------------------------- 
         %stddev     %change         %stddev
             \          |                \  
    111306            +2.0%     113530        proc-vmstat.pgreuse
      0.01 ±  4%     +14.9%       0.01        perf-sched.sch_delay.max.ms.schedule_hrtimeout_range_clock.ep_poll.do_epoll_wait.__x64_sys_epoll_wait
    715.14 ±167%     -99.4%       3.99 ± 80%  perf-sched.total_sch_delay.max.ms
  33278354            -3.1%   32249523        unixbench.throughput
      1854            -4.8%       1765        unixbench.time.user_time
 1.233e+10            -3.1%  1.195e+10        unixbench.workload
 4.717e+10            -3.1%  4.573e+10        perf-stat.i.branch-instructions
      0.42            -0.0        0.41        perf-stat.i.branch-miss-rate%
  28489209 ±  2%     -10.9%   25397034        perf-stat.i.branch-misses
      0.97            +2.8%       1.00        perf-stat.i.cpi
 1.946e+11            -3.1%  1.886e+11        perf-stat.i.instructions
      1.05            -2.8%       1.02        perf-stat.i.ipc
      0.06 ±  2%      -0.0        0.06        perf-stat.overall.branch-miss-rate%
      0.94            +3.2%       0.97        perf-stat.overall.cpi
      1.06            -3.1%       1.03        perf-stat.overall.ipc
 4.706e+10            -3.1%  4.562e+10        perf-stat.ps.branch-instructions
  28421825 ±  2%     -10.9%   25336865        perf-stat.ps.branch-misses
 1.942e+11            -3.1%  1.882e+11        perf-stat.ps.instructions
 7.212e+13            -3.1%  6.991e+13        perf-stat.total.instructions


***************************************************************************************************
lkp-skl-fpga01: 104 threads 2 sockets (Skylake) with 192G memory
=========================================================================================
compiler/cpufreq_governor/kconfig/mode/nr_task/rootfs/tbox_group/test/testcase:
  gcc-12/performance/x86_64-rhel-9.4/thread/100%/debian-12-x86_64-20240206.cgz/lkp-skl-fpga01/pwrite1/will-it-scale

commit: 
  73c2437109 ("crypto: s390/sha3 - Use cpu byte-order when exporting")
  71203f68c7 ("padata: Fix pd UAF once and for all")

73c2437109c3eab2 71203f68c7749609d7fc8ae6ad0 
---------------- --------------------------- 
         %stddev     %change         %stddev
             \          |                \  
    997120            +1.5%    1011812        proc-vmstat.pgfree
  55606929            +1.1%   56223715        will-it-scale.104.threads
    534681            +1.1%     540612        will-it-scale.per_thread_ops
  55606929            +1.1%   56223715        will-it-scale.workload
      0.01 ± 34%     +63.9%       0.02 ± 31%  perf-sched.sch_delay.avg.ms.anon_pipe_read.fifo_pipe_read.vfs_read.ksys_read
    233.78 ±143%    +242.3%     800.28        perf-sched.wait_and_delay.avg.ms.__x64_sys_pause.do_syscall_64.entry_SYSCALL_64_after_hwframe.[unknown]
     74.68 ±  6%     +18.5%      88.49 ±  7%  perf-sched.wait_and_delay.avg.ms.anon_pipe_read.fifo_pipe_read.vfs_read.ksys_read
      4.69 ± 44%     -84.7%       0.72 ± 30%  perf-sched.wait_and_delay.avg.ms.exit_to_user_mode_loop.do_syscall_64.entry_SYSCALL_64_after_hwframe.[unknown]
    576.00 ±  9%     -17.7%     473.83 ±  7%  perf-sched.wait_and_delay.count.anon_pipe_read.fifo_pipe_read.vfs_read.ksys_read
    999.68           -98.9%      11.47 ± 85%  perf-sched.wait_and_delay.max.ms.exit_to_user_mode_loop.do_syscall_64.entry_SYSCALL_64_after_hwframe.[unknown]
    234.63 ±142%    +240.8%     799.73        perf-sched.wait_time.avg.ms.__x64_sys_pause.do_syscall_64.entry_SYSCALL_64_after_hwframe.[unknown]
     74.67 ±  6%     +18.5%      88.46 ±  7%  perf-sched.wait_time.avg.ms.anon_pipe_read.fifo_pipe_read.vfs_read.ksys_read
      4.31 ± 48%     -91.6%       0.36 ± 29%  perf-sched.wait_time.avg.ms.exit_to_user_mode_loop.do_syscall_64.entry_SYSCALL_64_after_hwframe.[unknown]
    999.37           -99.3%       6.65 ± 67%  perf-sched.wait_time.max.ms.exit_to_user_mode_loop.do_syscall_64.entry_SYSCALL_64_after_hwframe.[unknown]
 1.686e+10            +1.1%  1.704e+10        perf-stat.i.branch-instructions
      1.62            +0.0        1.67        perf-stat.i.branch-miss-rate%
 2.726e+08            +4.1%  2.836e+08        perf-stat.i.branch-misses
      3.36            -1.0%       3.32        perf-stat.i.cpi
 8.562e+10            +1.1%  8.656e+10        perf-stat.i.instructions
      1.62            +0.0        1.66        perf-stat.overall.branch-miss-rate%
      3.36            -1.0%       3.33        perf-stat.overall.cpi
  1.68e+10            +1.1%  1.698e+10        perf-stat.ps.branch-instructions
 2.717e+08            +4.1%  2.827e+08        perf-stat.ps.branch-misses
 8.533e+10            +1.1%  8.627e+10        perf-stat.ps.instructions
 2.578e+13            +1.1%  2.607e+13        perf-stat.total.instructions
      4.44 ±  3%      -0.9        3.51 ±  5%  perf-profile.calltrace.cycles-pp.entry_SYSCALL_64_safe_stack.__libc_pwrite
     11.68            -0.3       11.41        perf-profile.calltrace.cycles-pp.copy_folio_from_iter_atomic.generic_perform_write.shmem_file_write_iter.vfs_write.__x64_sys_pwrite64
      0.85 ±  8%      -0.2        0.70 ±  3%  perf-profile.calltrace.cycles-pp.file_remove_privs_flags.shmem_file_write_iter.vfs_write.__x64_sys_pwrite64.do_syscall_64
      0.81 ±  3%      -0.1        0.67        perf-profile.calltrace.cycles-pp.balance_dirty_pages_ratelimited_flags.generic_perform_write.shmem_file_write_iter.vfs_write.__x64_sys_pwrite64
      2.26            -0.1        2.13        perf-profile.calltrace.cycles-pp.fdget.__x64_sys_pwrite64.do_syscall_64.entry_SYSCALL_64_after_hwframe.__libc_pwrite
      0.94            -0.0        0.90 ±  2%  perf-profile.calltrace.cycles-pp.noop_dirty_folio.shmem_write_end.generic_perform_write.shmem_file_write_iter.vfs_write
      1.14            +0.1        1.19 ±  2%  perf-profile.calltrace.cycles-pp.folio_mark_dirty.shmem_write_end.generic_perform_write.shmem_file_write_iter.vfs_write
      2.18 ±  2%      +0.4        2.58 ± 10%  perf-profile.calltrace.cycles-pp.filemap_get_entry.shmem_get_folio_gfp.shmem_write_begin.generic_perform_write.shmem_file_write_iter
      2.58 ±  3%      -0.5        2.07 ±  4%  perf-profile.children.cycles-pp.entry_SYSCALL_64_safe_stack
      7.87            -0.5        7.38        perf-profile.children.cycles-pp.entry_SYSCALL_64
     11.90            -0.3       11.62        perf-profile.children.cycles-pp.copy_folio_from_iter_atomic
      9.13            -0.3        8.87        perf-profile.children.cycles-pp.rep_movs_alternative
      0.87 ±  8%      -0.1        0.72 ±  3%  perf-profile.children.cycles-pp.file_remove_privs_flags
      0.84 ±  3%      -0.1        0.71        perf-profile.children.cycles-pp.balance_dirty_pages_ratelimited_flags
      2.26            -0.1        2.13        perf-profile.children.cycles-pp.fdget
      1.01            -0.0        0.96        perf-profile.children.cycles-pp.noop_dirty_folio
      0.43 ±  2%      -0.0        0.39 ±  3%  perf-profile.children.cycles-pp.rcu_all_qs
      0.29 ±  3%      -0.0        0.26        perf-profile.children.cycles-pp.inode_to_bdi
      0.30            -0.0        0.27        perf-profile.children.cycles-pp.x64_sys_call
      0.35 ±  2%      -0.0        0.32        perf-profile.children.cycles-pp.rw_verify_area
      0.39 ±  3%      +0.2        0.58 ± 24%  perf-profile.children.cycles-pp.xas_load
      2.20 ±  2%      +0.4        2.61 ± 10%  perf-profile.children.cycles-pp.filemap_get_entry
      6.97            -0.5        6.48        perf-profile.self.cycles-pp.entry_SYSCALL_64
      2.14 ±  3%      -0.4        1.71 ±  2%  perf-profile.self.cycles-pp.shmem_get_folio_gfp
      2.60            -0.3        2.28 ±  4%  perf-profile.self.cycles-pp.do_syscall_64
      8.90            -0.2        8.65        perf-profile.self.cycles-pp.rep_movs_alternative
      2.28            -0.2        2.10        perf-profile.self.cycles-pp.shmem_write_end
      0.86 ±  8%      -0.1        0.71 ±  3%  perf-profile.self.cycles-pp.file_remove_privs_flags
      2.24            -0.1        2.11        perf-profile.self.cycles-pp.fdget
      0.58 ±  4%      -0.1        0.48        perf-profile.self.cycles-pp.balance_dirty_pages_ratelimited_flags
      0.70 ±  3%      -0.1        0.62 ±  3%  perf-profile.self.cycles-pp.entry_SYSCALL_64_safe_stack
      0.61 ±  2%      -0.1        0.55        perf-profile.self.cycles-pp.generic_write_checks
      0.34 ±  2%      -0.0        0.31 ±  3%  perf-profile.self.cycles-pp.rcu_all_qs
      0.28            -0.0        0.25        perf-profile.self.cycles-pp.x64_sys_call
      0.25 ±  4%      -0.0        0.22        perf-profile.self.cycles-pp.inode_to_bdi
      0.24 ±  3%      -0.0        0.21        perf-profile.self.cycles-pp.rw_verify_area
      0.77 ±  2%      +0.0        0.82 ±  2%  perf-profile.self.cycles-pp.folio_mark_dirty
      0.72            +0.1        0.78 ±  2%  perf-profile.self.cycles-pp.current_time
      0.20 ±  3%      +0.2        0.39 ± 31%  perf-profile.self.cycles-pp.xas_load
      1.80 ±  2%      +0.2        2.02 ±  6%  perf-profile.self.cycles-pp.filemap_get_entry
      9.38            +0.2        9.61        perf-profile.self.cycles-pp.entry_SYSCALL_64_after_hwframe
      2.18 ±  2%      +0.3        2.50 ±  5%  perf-profile.self.cycles-pp.shmem_write_begin
      2.54            +0.8        3.37 ±  4%  perf-profile.self.cycles-pp.__libc_pwrite





Disclaimer:
Results have been estimated based on internal Intel analysis and are provided
for informational purposes only. Any difference in system hardware or software
design or configuration may affect actual performance.


-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

