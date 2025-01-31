Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1FD719259F
	for <linux-crypto@vger.kernel.org>; Fri, 31 Jan 2025 11:15:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.20
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738322144; cv=fail; b=Im6rDeDCSqdleWsYk6hJb3Sn0Bj6Xiwf3ZyLkF+7wp5/11y7W0/luhCvnV8NeE6GgS7P7GFxP05dtFQHBsgJsQSHgUAZz4kVQRoqBVGCYldokknRRQE4zNsbnAlgZRXER17XLK6jErAO50Vchx+lWzDRDiSFWSut0y4n0fOvOCM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738322144; c=relaxed/simple;
	bh=KctXcqmpFPrE29cMUpbMW9IgFZ6WYc99QAHK2raV0Vs=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=DMZpa6ydxtRXfIS5+davMng3K+OkwWBaBLhVlYsvE96kupNKSJ0BVxOlbn0kVQu8Yj9YxDtCLd42biI3l/R9mW2JYzfc7UiXxge/lIYXaM3DLdm+1FA5rfP9jk8df4prbpEaEXLTTEucLpaqNAitRZuDNs5kMZXU9YgQwUnsr3U=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=XXKpLjma; arc=fail smtp.client-ip=198.175.65.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="XXKpLjma"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1738322142; x=1769858142;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=KctXcqmpFPrE29cMUpbMW9IgFZ6WYc99QAHK2raV0Vs=;
  b=XXKpLjmaNaUSppr8GeRwdgZdlKzCrlthoEIu/3haSpqO903b71WdC0k/
   MLelQaVL6ioI42zzuYfFLxlPj8CqaDpc/fpwPnMAOmjmGQsOjkW1kioXM
   +tFdwOw9ocXELoER8RzkwtcRypIGC4oCN/VDLO0SNcK75b7oIKxfTHQiz
   J+ztjXIRCTpel3hyc0aNVnl+rvgZn0Wri04c2KFHDffkZxqSNrKkpjgPP
   nj1G7qiFzCDYQlhR9aIFdANOWZmtWUh1BIdXKtMqqa3wxzRO7LHi+Ui3+
   rrRA+bdKIiiL4hJ7rwToJHa+n2okCdgiskU+mhBDslcapKROLUsFVSs6G
   g==;
X-CSE-ConnectionGUID: eEm/Rci1TuKpskaJkURfCw==
X-CSE-MsgGUID: qwFvT+R3SZepjc6aPgfiKg==
X-IronPort-AV: E=McAfee;i="6700,10204,11331"; a="38592764"
X-IronPort-AV: E=Sophos;i="6.13,248,1732608000"; 
   d="scan'208";a="38592764"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by orvoesa112.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Jan 2025 03:15:42 -0800
X-CSE-ConnectionGUID: YKEKVybITC+DaPW5UIqNjw==
X-CSE-MsgGUID: v2hKTc5uSrCCD7DHq4BU9A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,224,1728975600"; 
   d="scan'208";a="140486027"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmviesa001.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 31 Jan 2025 03:15:41 -0800
Received: from orsmsx603.amr.corp.intel.com (10.22.229.16) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.44; Fri, 31 Jan 2025 03:15:40 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.44 via Frontend Transport; Fri, 31 Jan 2025 03:15:40 -0800
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.170)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Fri, 31 Jan 2025 03:15:40 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Jp1XM/Ou771ua12UL/jqbP0GB9ysrwE9KX2sidCRoNhjjNxVzWKL/7BNFH8sLkC4Gz9j7Lq+/+hbFFVHCFRvAzQaeubMhro1raqiiS5DpE9RuRtqn1lYcEof9TdXg9cTVSot77bdU+U0pImp3me520YMIn0FnNrZkUa7kn1yWzsmVaI93CiD3pcFOr0MJk+DM1c7NprRHXrtHdMMaFiZePyh2yHHSYSDKGhQjo+7S9lN1vmbOMLAb5OfoZ9sVFnnhhu5PA4eNJnrdSPF5P131qEUraCTYXQcej7a1fZkLP7lKt//NW+JCx9QWcsEu8yOSpEMH0NRFw1SrV/cMH0fTw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nBeqGYejG0oiF76WXoR7juc9oJLTbsFUCyHLSMjBg4c=;
 b=Ij5ut53V/+/ucZESzQvl38D+oOZTQiqZqtY8aaEn7UgWk+mc801GZFpFwwSniNDvRc0vlDnhv7CZxE0e+eExFBit7u7MMWnmWhnnCH1kUQzXfVJegiQLHXeLL+mDks8OEv9Bb97guz38u+MQVODWxWEshiiGLWPg8Hn0L7LTr2vu5fmbLi/c2qTjawNg4GYhEShtrusA3UN8IsmRZVhFNzGHxC/gft/88ijeMnrDb/5ttJaikQ+Eaz1ljnn2UWWocvkdIdSY4bZTd1WlBm7fwaTi4IoQs6eIja/C7wFap+laeZoSfoh77hHkunCuijlMdryfoHu01SgzX8Tq0I2E0A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CY5PR11MB6366.namprd11.prod.outlook.com (2603:10b6:930:3a::8)
 by MW5PR11MB5905.namprd11.prod.outlook.com (2603:10b6:303:19f::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8398.18; Fri, 31 Jan
 2025 11:14:58 +0000
Received: from CY5PR11MB6366.namprd11.prod.outlook.com
 ([fe80::6826:6928:9e6:d778]) by CY5PR11MB6366.namprd11.prod.outlook.com
 ([fe80::6826:6928:9e6:d778%3]) with mapi id 15.20.8398.018; Fri, 31 Jan 2025
 11:14:57 +0000
Date: Fri, 31 Jan 2025 11:14:49 +0000
From: "Cabiddu, Giovanni" <giovanni.cabiddu@intel.com>
To: Suman Kumar Chakraborty <suman.kumar.chakraborty@intel.com>
CC: <herbert@gondor.apana.org.au>, <linux-crypto@vger.kernel.org>,
	<qat-linux@intel.com>
Subject: Re: [PATCH] crypto:qat - set command ids as reserved
Message-ID: <Z5ywqSAsZXy0tPma@gcabiddu-mobl.ger.corp.intel.com>
References: <20250131034408.3249624-1-suman.kumar.chakraborty@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20250131034408.3249624-1-suman.kumar.chakraborty@intel.com>
Organization: Intel Research and Development Ireland Ltd - Co. Reg. #308263 -
 Collinstown Industrial Park, Leixlip, County Kildare - Ireland
X-ClientProxiedBy: VI1PR09CA0157.eurprd09.prod.outlook.com
 (2603:10a6:800:120::11) To CY5PR11MB6366.namprd11.prod.outlook.com
 (2603:10b6:930:3a::8)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY5PR11MB6366:EE_|MW5PR11MB5905:EE_
X-MS-Office365-Filtering-Correlation-Id: 88c46f3c-6d60-43a0-5ef3-08dd41e87f1c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?f5palL92H0litACu4uzTWZWIuETxjevyjGQnR16BAE0AjCH0SfNtwsV7ydCl?=
 =?us-ascii?Q?n7wZjwznyOLChkz1q8fTegZfkEduEn+sRYuwWjNss+H4I8zA7TJOzGWZxeaX?=
 =?us-ascii?Q?Jitf05sp2CmbXW1CI0fB7qf6dGlthoHV9cEL1WfCW9L2YhHun7ucS2BfzUV5?=
 =?us-ascii?Q?wOSdp811Ti/KnTe01HWwTLbFpR3QU6c19LmCmRtU5LBOU044+FAy1nN0NaSX?=
 =?us-ascii?Q?Ma6b3vtC3mOMELloZD91beOjfhPxKoNuf3Fen7tS2hzRkiSpM1vPaOWJDSsv?=
 =?us-ascii?Q?0d7n6tc0YuBHtDJkhcxCwIw5ECD2DQt3tk/DZnPQ8XQcfGwkAt54yAzgfnkr?=
 =?us-ascii?Q?9466WxAU3aymFw+mDkIw7Wlrye/YZXrnHvRjuXqSCOsKDunWLofZ/cXEuNdp?=
 =?us-ascii?Q?JtZUQh0PCBaYUfW2o7GvogrVP/AOoXCvgqena9VPZWyzatdeUx2gmhX8umAY?=
 =?us-ascii?Q?bXE355NVIn7peVwXqm4P34EK4TJxdRAq4dusJ8oaVYa5lgstTokKG6SdS191?=
 =?us-ascii?Q?eXkrBQ6Zt56JW3DkrwkoayzcdpNbljifu7cRhH+Sewr9sG5rRPpFfq2K4z2i?=
 =?us-ascii?Q?3KvAFs0Nk0kcCNotewmdf7rbQBYS9zu2bk3odRqs14symsNpv2ae4G8VD3kv?=
 =?us-ascii?Q?c8B1L5R09PlVpJ9r5LQmrTF+6lcgp/tAttwuIjAHiOyYX5ZbS6A2ht2fCehn?=
 =?us-ascii?Q?h3gRqKudJ2TvS9rvbP8ZVgnvDwztUbJbMewdfjz37IGwiTVM6EmYgwmTxlbD?=
 =?us-ascii?Q?8IgjXzpJ2hqtG3SrMj1iwgbJBj4b7I6oFRc08Pp76ABLjX86/P9MqFKZtKMj?=
 =?us-ascii?Q?poIexFrBTKQqQg4MK6GyEahEbWkdQwa4rwDZ78SvI5JZZrAQdXojNAByX+0H?=
 =?us-ascii?Q?g5TSQYl1Ju0bhrQIMqR4CU7wUlAM0o1WiuOrOvZR9p0DbmPDAiGTNrDdBugH?=
 =?us-ascii?Q?EqKamGaB+VFvJXg/O03AfdR9NQJFsCF0J2yiFbFp1EnhhjMIoaXjdSjkN3zY?=
 =?us-ascii?Q?jgv/j60/K12ZphhaROSp9RK0lYyYxEPgkmWckkahNcB8dNE2Jyk5OZMkMjvu?=
 =?us-ascii?Q?9/jdnN6yXR1Rr1Ggt9A/p3ovJobVFsv/Jx/mJz0Ny209kDLB1b14C+ytxnRL?=
 =?us-ascii?Q?+QuH/bnF01EUGX038Euw/6AU5pV4Eket06wT6WRP0wzelndvH1hH7A4vBO1w?=
 =?us-ascii?Q?e+DenSW9B0ZuIkxmFmRiInkeb6cBTGi555viGBGeLJPrWytMSKq79zlU2l1W?=
 =?us-ascii?Q?zNsSMj/sWIBdwgusb6L6VqqEtrN2inVgp/TF3H2JVLfqFqj0Sfs0/z6GT7b1?=
 =?us-ascii?Q?qkhvK4zww62GkDdbNctzsLQvcz6r2lpBig4F3FcVtXhJUWwH90w9ZFlrMoGg?=
 =?us-ascii?Q?L6dvXpJBM1iFvHj40FOXZMTQRrQt?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR11MB6366.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?gc2muu7TIUBNzlGjKCcCaEiwXSB6v20ZaeS/pFgm6XHMaZql5c65XT4e2jEI?=
 =?us-ascii?Q?DK9v53tjX7oRLt4t3M8D0BI7DsOZpQ5iCzpU5POvtdprMtkg//qSGbfK341P?=
 =?us-ascii?Q?prLZYV6MYUjlZTAfgcFjiOusv6OL1F9UrAefBkZ7JNiskUgcM5AjT7vHG9s9?=
 =?us-ascii?Q?jqzNyskUEC3eA6SJNJMag2ewIWoM3xqT02PGZi38fl5YqD0DW7n3tWrbSoY5?=
 =?us-ascii?Q?Lw2ov/pmxApWY7BvpToqog5Ia5WoOHfvZ7M0oqWbdZMUI1wbyYc8yajFPVLk?=
 =?us-ascii?Q?/ZwtyK7nTPqq81OVPqq/+M2wn3VT1o0/WQw5uptRRvjVenpp3eyZ8UXQwBs3?=
 =?us-ascii?Q?tDyAnzVhKe/O1HaTytyhdVa5YOpSTV0Kwl7kncwyjlddEwimtqfwk1yZ98bK?=
 =?us-ascii?Q?s2NbSUUSlLxKxIIQ8OlNbNW3V9tbsBBLkp/NxB1sWg9xLu9De1lGyzlr1tBC?=
 =?us-ascii?Q?+r5rNw6BRmAD17dfA1fr2ZRBna16wZeivryQm2L7j1kTFdxWyqGKE6+Xzu8x?=
 =?us-ascii?Q?Idwx+lkub1XhHyzGKU7htu1IPA7+5kIebmguWWhE/JtsP/oiI/Hb2CYTbXSL?=
 =?us-ascii?Q?XUowa5g8d3ngaja4OfBq+VqltmwZWB7wEjhO4z5EfupPt20e3+TQz5HseudW?=
 =?us-ascii?Q?zD4r1aAW7K75VElpCS4k8rDxXmMV9LYYFBtcds5ZBngGPJreqeDBA+2kBItk?=
 =?us-ascii?Q?VfO4s4x/Knti11Ci8UNoCDQpdGdIxWABNQJsN+SkDajhYEghjAXeTO9Q81/r?=
 =?us-ascii?Q?q5lQOwoVaV58RPd+JgpXllYq2iJATIvLVi8YApbfOMNjZ0RI1mHs+5iIEKfl?=
 =?us-ascii?Q?gkHOgRLzO1C8zAKcV/y67MeIHOn3OSVxBjRr9x2+xVYom+ile0iOO0CWMHQG?=
 =?us-ascii?Q?3ADlq4pA0iWtdthL0qJ0RGSTYmfGGLD6iJJFJesyKKIqB50rF8U400VfrN9Q?=
 =?us-ascii?Q?FLzdZrzqZmy/gEqoV6qrSKg6FeJFvj48c1P1hjnUoiYbND0nGfdw+xMvt6EF?=
 =?us-ascii?Q?3jDafz5OzmlIBMgRD5ZqOa03PuPlNFkY8GZHlhd1azDbY7vDBVHgusrm5YxB?=
 =?us-ascii?Q?DxF8J71reysE72zH7W3+ZvTO2TG9I0BTsOoguU18s94JYl9pKefOOXCPYvln?=
 =?us-ascii?Q?CDNPo8p2e9JMWOMbdKHPWDXTuHUs51PqaQJzW46+liQRvr/2Zl9vIntBJMjs?=
 =?us-ascii?Q?ksiZ0MflMzP+8Qtxqaz9qBrGwJNFzbwgRPtNXI13yXRbpj3yp9Rjn3rGuZBO?=
 =?us-ascii?Q?vkLW1DGGoHPwSJhwQ1Ll5vo+P5rdSsGmYjMssKl+NKQW8XYA+6nypFpIY46x?=
 =?us-ascii?Q?vMTt4A7H0Pw7rgCX31tJCtOQj7/Ga9Fg4V23RrhAdzY7/lXLnkv4/UlAnR42?=
 =?us-ascii?Q?BElir0WRQZ2zidLkq06zFqLbFqAFbMly6T4XipAEZ/CfbZ+5kcc+gjn6lyBC?=
 =?us-ascii?Q?Bs5vxCFKtdZldFSqqNlERNWV/OPUyOA/1HwrS0qvipNI9Ljl0OP9zidf0U+w?=
 =?us-ascii?Q?aodHMKEhs10zbqEagkEoB52YCP6a+5rMOpcuFFw4u4FcEMv8SmgPcoprmSix?=
 =?us-ascii?Q?Sx/mdptE7ixa21Q0zJ+I3NmryFfaeEomSwxONd8rbC1H5SUjrcaC48fDU67N?=
 =?us-ascii?Q?7Q=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 88c46f3c-6d60-43a0-5ef3-08dd41e87f1c
X-MS-Exchange-CrossTenant-AuthSource: CY5PR11MB6366.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Jan 2025 11:14:57.8312
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: gYu5pdMG68qGkl/WNt2Cq8R2x4ZWSErhP4bvim8ZaaoNg9JAEwJFXKP/9jHRGWlM9/jc2QnBMdgkcywevtOhvc4I/2QFmrD5J0BNRr8a73E=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW5PR11MB5905
X-OriginatorOrg: intel.com

NIT: should be `crypto: qat`, not `crypto:qat`.

Regards,

-- 
Giovanni
