Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2787018756E;
	Fri, 31 May 2024 07:08:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717139288; cv=fail; b=AfLevyoJWgwM7gSBZlggeVJ66FdblkCj6mV7103ygf6yPpEMVgP/s6JhleA2rYVnosxGbUgz1M6G9a0RizV6HOxHkZ25dJmqvkjr1GscKzp9EU8/9p01ULdKS6la0zvFHMh3mVMYEqtD2PlFwenx3hj2Tq2nFcvHaso2Kn0YrYM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717139288; c=relaxed/simple;
	bh=ZPtKCowiy7C+dSvZhU/UutbcHffi/Q1nzc/kF5RyjwY=;
	h=Date:From:To:CC:Subject:Message-ID:Content-Type:
	 Content-Disposition:MIME-Version; b=LTdBnR+3r3y7aFXlCUF66yCd3zIlwcSrWSsqAwvtjsyLQuVljbj23+IpdaZXQofjLlt6BPy8lGRpUfyOiNXXjERVZ1VRJsyuUEirEt1Yd+CA2jIuIIg432N99BUsCJp/YFBAFRk0336pNXTuNCL6aTxlklD3q0+VUpd+VdkrLBw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=K4b4rtme; arc=fail smtp.client-ip=198.175.65.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="K4b4rtme"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1717139287; x=1748675287;
  h=date:from:to:cc:subject:message-id:
   content-transfer-encoding:mime-version;
  bh=ZPtKCowiy7C+dSvZhU/UutbcHffi/Q1nzc/kF5RyjwY=;
  b=K4b4rtmeyyKNyleuMitS2PaXcXeMVFg+l8cjkyeMusu3x0HONK/SV7S6
   2z6lPSJCjMCPrPbMgeCRYm1WpFYSsmvVdxfsBsyQ2SZELOBamw6fFXNkz
   wszQYA6IydTsK+7sQn/XV7Oer3DK52v2LE8Y/UEedElCkBWzPvsTJwDf5
   KkLl6vwYr8NtVtPYKexHukFUHOihAH2FbldB9NmtYp3NlGn1DaS8roxao
   1KPNIC7shq440OhGJWtwBrOM/sLOqaJ7LHrYY53ovzXT0xOwv2BT1/cWw
   /PWQezJavwSGf5ZMZRU4tr7SVQl6hSruYVoQ7U8QZJvrH/OrPc9PVQ/fR
   w==;
X-CSE-ConnectionGUID: PtJVqv3cRQW5b3YrqXBITQ==
X-CSE-MsgGUID: zXWBMIydSAuZ9Jrt4erzcQ==
X-IronPort-AV: E=McAfee;i="6600,9927,11088"; a="13838399"
X-IronPort-AV: E=Sophos;i="6.08,203,1712646000"; 
   d="scan'208";a="13838399"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 May 2024 00:08:06 -0700
X-CSE-ConnectionGUID: gTRFROLkRUadg0nGwlFoEQ==
X-CSE-MsgGUID: 7wgRMLBbTSSMLv60vf/z/g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,203,1712646000"; 
   d="scan'208";a="67266309"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmviesa001.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 31 May 2024 00:08:05 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Fri, 31 May 2024 00:08:04 -0700
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Fri, 31 May 2024 00:08:04 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Fri, 31 May 2024 00:08:04 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.100)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Fri, 31 May 2024 00:08:04 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=B01dE26uKpexR6oLfP1SDPTY4kkJHZ3JONt5yvIIrb1LdWAv4fe3eRprFgGf0huv+C13jFPcKXMKOd/CK+jrdobTT2Sz/kYaz9rvh4CN5b5FPO6JmVLiQUuHvPBnkhGj1+uRzD1w5fqZRd2tcO023C5LOJuPuTC8jib270I+WdmVd33Yv3cQ+OAvruU4XZow/NaaIXJ4by892rHyg6dC/XWeiRXpGTnFGVWnww9bod77FjOhoV1qARhiIEzCa1hC7kjjtHJwrPRKhjiDtSj4qiKbBnUimCpOiY3oMqsfts1PdHQ+YzRvYRE5O4bnlveh64DMIgijSxyZWYOniuxZUg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=J1+lHud3N2b8wfCGt08pNVXiOtq6xQ2rxh+T5cg0Xuw=;
 b=RhV/zS6+n5TWnER2kDvBPIz7PM7bHGXJJkR0+1bwFg8o1XbvJ0kYtT4YxF70giNCczUFKSdOMcncuq5SNPKsVulvR7A7fDLzVsfzA7APglDzNxUGKA2Ug2RYwMqg6mVOqhujDmfvz2SscUaNJx5oaTvYkR6sg5zhTSbSLJiA8A9Zm4qSgFE/Br8EyDkB3LoJG2xOTAP3SmSHZ1wY2turD/tDfJdgLHD3alEaJ12tSwYFEs54XjHk+ExpR0a3ztEO/HtEh5zjl28iqjH35PWwe4Mrnanbv/IQltJ+UubtH+hll5j78KiG/Gft+q+U3Y24mAsQ4S5NSxjXQGAl62ydOw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from LV3PR11MB8603.namprd11.prod.outlook.com (2603:10b6:408:1b6::9)
 by MN6PR11MB8196.namprd11.prod.outlook.com (2603:10b6:208:47b::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7611.33; Fri, 31 May
 2024 07:08:02 +0000
Received: from LV3PR11MB8603.namprd11.prod.outlook.com
 ([fe80::4622:29cf:32b:7e5c]) by LV3PR11MB8603.namprd11.prod.outlook.com
 ([fe80::4622:29cf:32b:7e5c%2]) with mapi id 15.20.7611.025; Fri, 31 May 2024
 07:08:02 +0000
Date: Fri, 31 May 2024 15:07:53 +0800
From: kernel test robot <oliver.sang@intel.com>
To: Eric Biggers <ebiggers@google.com>
CC: <oe-lkp@lists.linux.dev>, <lkp@intel.com>, <linux-kernel@vger.kernel.org>,
	Herbert Xu <herbert@gondor.apana.org.au>, <linux-crypto@vger.kernel.org>,
	<ying.huang@intel.com>, <feng.tang@intel.com>, <fengwei.yin@intel.com>,
	<oliver.sang@intel.com>
Subject: [linus:master] [crypto]  e787060bdf:  stress-ng.sigtrap.ops_per_sec
 5.7% improvement
Message-ID: <202405311430.e1f484a4-oliver.sang@intel.com>
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SG2PR02CA0006.apcprd02.prod.outlook.com
 (2603:1096:3:17::18) To LV3PR11MB8603.namprd11.prod.outlook.com
 (2603:10b6:408:1b6::9)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV3PR11MB8603:EE_|MN6PR11MB8196:EE_
X-MS-Office365-Filtering-Correlation-Id: 5821821b-abb3-4884-2edc-08dc814068e6
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|376005|1800799015|366007;
X-Microsoft-Antispam-Message-Info: =?iso-8859-1?Q?xHYd4IeRSTjdBhdJJ/og64jjG+/xYjFx+o+Tx1dgTtKi1zMSmH/U0HpCH9?=
 =?iso-8859-1?Q?CAgUEGOjbP1kYE/qvI2kuKLRZM7JVraoYmgh8fbhAwhYeyAz5owMF1HvTi?=
 =?iso-8859-1?Q?bTcvnDgHil3sWUq+ZHEPDUFvZlyJFz+9LU0pYmyG9fckFGvg5UL0MVG+74?=
 =?iso-8859-1?Q?vAdX87ea8FFN+COZOWhK5gVihREMteGv62eUS/yiNkN2PRYmNd5nj1JvKo?=
 =?iso-8859-1?Q?U5BVwvBfMBVr5Ne8GPp4BxK1PvD8MXPDO6r0mCqkF0vbWe4VL124dooJYl?=
 =?iso-8859-1?Q?Du2jxS/2Df3J91p4rHpyKIuaHAjREwLzXJIBPsUKnuufgVranXBAfGoOYA?=
 =?iso-8859-1?Q?mTGEz9ATMiJPjZXDdJJo7g+D1DV7RxCFuqPCG6cnyK6/muPG4FXMg7u4F8?=
 =?iso-8859-1?Q?77NfWV4cJuq9F4Yued2TBB+RRTudnE/cTbvo8vpYfWTXqurVi+d/1rEQ8n?=
 =?iso-8859-1?Q?52oWgY8vADMm+DxZDyyocDwRYo9avtiWov0bt3DYzgVOr0j1TLSIiDqWgu?=
 =?iso-8859-1?Q?FXxeUdbuTwG/1GPqsQ2z05CUb8LtkXJIpQfsWoJyIeWLk3Y/BchiF8zx77?=
 =?iso-8859-1?Q?1OpJ0d0wfDkuJwF65NbAmTJiomL5EgCt6xieCkjqYiAlQmSxDXqvHcYAGb?=
 =?iso-8859-1?Q?LD8tK7zM3YR/sfi+vhChtbopDUHScItC0zWhgq/Jk6rrpcfY/pshyQdjZ1?=
 =?iso-8859-1?Q?MII37EEUi4u+4XxRddRN2pdQI6Uvprk+kI/xhp3AMknRgE0PyDkhJcwOMK?=
 =?iso-8859-1?Q?XKzgGbx1xQPmgRvgD0bRWC1LU65XHL059AOltilDWj1ydtIEXzcsttTvo8?=
 =?iso-8859-1?Q?5bwgCl2ndMRdtx+BE040UuL43tPvb55pFRYp8HalJCh0OE4di7ssovF4U+?=
 =?iso-8859-1?Q?i02aYC6zE8wDL3RHwG/6juda7D4ms5oBbiY3GzBEuypzIWuGjL20vyofqw?=
 =?iso-8859-1?Q?FeeKHUjd4qMEVkrJcaI/K+OOaVs4ZBv+Y/eNYOClhsbAznDCvn+JkMMcmj?=
 =?iso-8859-1?Q?Z1WWA8Q2jXGyfga28Sj99x4tB60PEKG7wTmyLmI/kM1ENzd5u1ak749Q08?=
 =?iso-8859-1?Q?S8ywm62UWiwIaV28QrsyTh6TR+Kb3sf4Y+btSsG2iboq/G4DAkZeOJMjO/?=
 =?iso-8859-1?Q?HsLCcufc2b/xRg8tLvQ7NjumAi92H9xvk5kjk/vSIBy3CpsRfv1i2+QMJh?=
 =?iso-8859-1?Q?1gysSYNL9Ot3SQVzYnk0IZlFASBnbGa5kLWYTJiKVrr9DHH+nfRq3M9GzP?=
 =?iso-8859-1?Q?QhcySNHdCEm7XAKZYHB3CMhSzP+mRMp5N11y61+5I=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV3PR11MB8603.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005)(1800799015)(366007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?iso-8859-1?Q?YKJ3q5xqaPsIRD1VTSmzZfOPLGR+v/ZNglq5pzJTKB/fXX2ybk9rdtzbEj?=
 =?iso-8859-1?Q?lXU76uiW5QXxlSTN3C9n5EPvV1P5H482QuVRIMxHTFmd6Vxnc7m1WcbRXa?=
 =?iso-8859-1?Q?HGSuiq2LCvhsItm8GpO0r6RjYz/rqDfXIuMR3WAAu3Z86lBetF2yoU4a4A?=
 =?iso-8859-1?Q?myuLK3vAjsgFr/VOQWjdkNdNsJRNUsRljanvjJV7w8AVpyA7ibQm/LOGZL?=
 =?iso-8859-1?Q?spl+FFkw2V63mPABUC2kX14tfCCOcvWV1Q+MKe3idVn6Gct27G7+EyityG?=
 =?iso-8859-1?Q?+CMvTAdH0aDd7Px9hSwspUSqVgVaCjwd8qqLL3/xte2CoEQfSqQwO4BnZw?=
 =?iso-8859-1?Q?4SVFTR8WEoXP6jWpo9+l3rlvZhkTVLvD8ETjd8oNllGPo4u+yht35tNSKR?=
 =?iso-8859-1?Q?FT5fhfYNyKGFRtip4LU0cZW2NWOxqsIdyDaikPfrYr8uGv3ad55WpO6mAs?=
 =?iso-8859-1?Q?uA2tVvTd4aelW9n+phyuM7r/7wenWDCJQ0jTkOBI3JXg7v1MTGE9WAeq+a?=
 =?iso-8859-1?Q?wox4ijXr45qQyKwrEg9NMpvANY9rj51kZE3XPiUrEHmRZZCL5k4PnJ1A6t?=
 =?iso-8859-1?Q?VrvMgr+tqUjmVv2MlVgrks5tBCMbyMK5PcUyQ5HCiAiQ/vGo+lJ8NXwmj3?=
 =?iso-8859-1?Q?LuxVfwAmRD259bt+eacCRdhAc1eJ2OERPtmjllJSaF3+kNFS2mFZW6YrK4?=
 =?iso-8859-1?Q?duEahTv/fhV9un8ITx5GZuv59uT16/HbSd1l/eid6gQSe6D8y2I3dAQQNi?=
 =?iso-8859-1?Q?DKOTGcsG57qnqw/Re0OsWkXFK0hjFSm4BkIlSP1NaX0tcnzPvuOuBSwF8v?=
 =?iso-8859-1?Q?7z5ImU8dj9FtdTzUND2vKk3iXT/+OzBI5h6GCxDsHu8TTMV4gRyTwvHGmI?=
 =?iso-8859-1?Q?OfsB1Gu7Hx0r9zjEMJMeCW7uKTKmMYJhk22gCJwIeDpj51XGXsxibjHNbJ?=
 =?iso-8859-1?Q?mm4L96rWYIflRR1vslE+H8p9cjtXXhNfUd6zbnwcA/QZd186OBJNmupuAX?=
 =?iso-8859-1?Q?txt21ofJ3Odf7IKwfNFlVwK0nCIsmCPD4NX3NIH4j+ZRn/fgFuL6I16ebS?=
 =?iso-8859-1?Q?3IsCfaGgXtzxwujGo1pZxxsfNhecSD1Zz9nKzUae/22sUdqQN1rd4Kx63M?=
 =?iso-8859-1?Q?hNZb36aNTNF038+I1yojUBvg+s4PvESCy1z6ACIPmo32z9QcBjja0n55+K?=
 =?iso-8859-1?Q?46JD1ZQyQHNdJYgEq3VzEw63CzL0Q1GdKsVLwlZOol+Lvikdw4QwHEqeV/?=
 =?iso-8859-1?Q?W07TuKbbIPWcohNKac9n7dyrvHoF2i9TYEeFKrNWnu4di2muGNhLW2660A?=
 =?iso-8859-1?Q?KvjgnEPIlOYdm8KY6jpxDWTsbiv5At1kUir1p/3U3suzlNM+lu6aNaXbGf?=
 =?iso-8859-1?Q?cf+fmlyjgAEDtEfOCFXbFpxatalAVYSMFvHvvy+CPxymtEXZV6Y9VObMMv?=
 =?iso-8859-1?Q?xQAVUSOaQvCBsH6LWqbXNHs3jMd/nfDiqTyvx4Yf1F6MN03tleOb5dYw9D?=
 =?iso-8859-1?Q?CtYuPQ+Wenis02r3PZZgfj7Ih2b/KUERZiluqrflfh5xKNnVq00iFSxVYx?=
 =?iso-8859-1?Q?00o0WgZ3XTZqNGI2b7aQYxj/FlV4xyjCoWDbFENZkXhm3s3LJqnrbWaOY3?=
 =?iso-8859-1?Q?j4moREh4zyBu6Zj0HTxZO97dP3e+KVNuG+4bektk5N/xQogqvnPA43iA?=
 =?iso-8859-1?Q?=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 5821821b-abb3-4884-2edc-08dc814068e6
X-MS-Exchange-CrossTenant-AuthSource: LV3PR11MB8603.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 May 2024 07:08:02.0673
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: cr9gU7upTN1fixN6mtGlUwctpinh1DlBv5oRP7UcAAszolNpkBHVrINTbYifmrGWtYxs32En6hqgEFBsO2QZ6Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN6PR11MB8196
X-OriginatorOrg: intel.com



Hello,

kernel test robot noticed a 5.7% improvement of stress-ng.sigtrap.ops_per_sec on:


commit: e787060bdfa35f8b40ef4d277a345ee35b41039f ("crypto: x86/aes-xts - wire up VAES + AVX2 implementation")
https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git master

testcase: stress-ng
test machine: 64 threads 2 sockets Intel(R) Xeon(R) Gold 6346 CPU @ 3.10GHz (Ice Lake) with 256G memory
parameters:

	nr_threads: 100%
	testtime: 60s
	test: sigtrap
	cpufreq_governor: performance






Details are as below:
-------------------------------------------------------------------------------------------------->


The kernel config and materials to reproduce are available at:
https://download.01.org/0day-ci/archive/20240531/202405311430.e1f484a4-oliver.sang@intel.com

=========================================================================================
compiler/cpufreq_governor/kconfig/nr_threads/rootfs/tbox_group/test/testcase/testtime:
  gcc-13/performance/x86_64-rhel-8.3/100%/debian-12-x86_64-20240206.cgz/lkp-icl-2sp8/sigtrap/stress-ng/60s

commit: 
  996f4dcbd2 ("crypto: x86/aes-xts - wire up AESNI + AVX implementation")
  e787060bdf ("crypto: x86/aes-xts - wire up VAES + AVX2 implementation")

996f4dcbd231ec02 e787060bdfa35f8b40ef4d277a3 
---------------- --------------------------- 
         %stddev     %change         %stddev
             \          |                \  
     11005 ±  5%     -18.0%       9022 ±  5%  perf-c2c.DRAM.remote
      4834 ±  7%     -23.8%       3684 ±  5%  perf-c2c.HITM.remote
      6143 ± 48%    +101.7%      12390 ± 27%  proc-vmstat.numa_hint_faults
      4427 ± 35%     +56.7%       6939 ±  6%  proc-vmstat.numa_hint_faults_local
    301865            +2.3%     308839        proc-vmstat.pgfault
      5597            -6.4%       5240        stress-ng.sigtrap.nanosecs_to_handle_SIGTRAP
 6.075e+08            +5.7%  6.418e+08        stress-ng.sigtrap.ops
  10124240            +5.7%   10696368        stress-ng.sigtrap.ops_per_sec
    177.72            +6.9%     190.03        stress-ng.time.user_time
      0.53           -17.3%       0.43        perf-stat.i.MPKI
 7.911e+09            +5.1%  8.314e+09        perf-stat.i.branch-instructions
     32.57            -5.5       27.10        perf-stat.i.cache-miss-rate%
  22467086           -13.2%   19505617        perf-stat.i.cache-misses
  69342308            +4.1%   72189549        perf-stat.i.cache-references
      5.26            -5.0%       5.00        perf-stat.i.cpi
     10083           +15.5%      11642        perf-stat.i.cycles-between-cache-misses
 4.275e+10            +5.1%  4.495e+10        perf-stat.i.instructions
      0.20            +5.1%       0.21        perf-stat.i.ipc
      3976            +3.7%       4122        perf-stat.i.minor-faults
      3976            +3.7%       4122        perf-stat.i.page-faults
      0.53           -17.5%       0.43        perf-stat.overall.MPKI
      0.78 ±  3%      -0.0        0.73        perf-stat.overall.branch-miss-rate%
     32.29            -5.3       26.95        perf-stat.overall.cache-miss-rate%
      5.29            -4.9%       5.03        perf-stat.overall.cpi
     10068           +15.2%      11596        perf-stat.overall.cycles-between-cache-misses
      0.19            +5.2%       0.20        perf-stat.overall.ipc
 7.772e+09            +5.1%   8.17e+09        perf-stat.ps.branch-instructions
  22071930           -13.2%   19162218        perf-stat.ps.cache-misses
  68355866            +4.0%   71101498        perf-stat.ps.cache-references
 4.201e+10            +5.2%  4.418e+10        perf-stat.ps.instructions
      3892            +3.7%       4035        perf-stat.ps.minor-faults
      3892            +3.7%       4035        perf-stat.ps.page-faults
 2.571e+12            +5.0%  2.698e+12        perf-stat.total.instructions
     34.18            -0.6       33.55        perf-profile.calltrace.cycles-pp.asm_exc_int3.stress_sigtrap
     15.07            -0.5       14.58        perf-profile.calltrace.cycles-pp.force_sig.exc_int3.asm_exc_int3.stress_sigtrap
     15.47            -0.5       14.99        perf-profile.calltrace.cycles-pp.exc_int3.asm_exc_int3.stress_sigtrap
     14.94            -0.5       14.46        perf-profile.calltrace.cycles-pp.force_sig_info_to_task.force_sig.exc_int3.asm_exc_int3.stress_sigtrap
     37.71            -0.5       37.26        perf-profile.calltrace.cycles-pp.stress_sigtrap
     14.04            -0.4       13.65        perf-profile.calltrace.cycles-pp.__send_signal_locked.force_sig_info_to_task.force_sig.exc_int3.asm_exc_int3
     14.94            -0.4       14.58        perf-profile.calltrace.cycles-pp.get_signal.arch_do_signal_or_restart.syscall_exit_to_user_mode.do_syscall_64.entry_SYSCALL_64_after_hwframe
     12.48            -0.4       12.11        perf-profile.calltrace.cycles-pp.do_dec_rlimit_put_ucounts.collect_signal.dequeue_signal.get_signal.arch_do_signal_or_restart
     15.19            -0.4       14.83        perf-profile.calltrace.cycles-pp.get_signal.arch_do_signal_or_restart.irqentry_exit_to_user_mode.asm_exc_int3.stress_sigtrap
     12.54            -0.4       12.18        perf-profile.calltrace.cycles-pp.collect_signal.dequeue_signal.get_signal.arch_do_signal_or_restart.syscall_exit_to_user_mode
     13.34            -0.3       13.03        perf-profile.calltrace.cycles-pp.dequeue_signal.get_signal.arch_do_signal_or_restart.syscall_exit_to_user_mode.do_syscall_64
     12.30            -0.3       12.00        perf-profile.calltrace.cycles-pp.do_dec_rlimit_put_ucounts.get_signal.arch_do_signal_or_restart.irqentry_exit_to_user_mode.asm_exc_int3
      0.73            -0.3        0.47 ± 33%  perf-profile.calltrace.cycles-pp.complete_signal.__send_signal_locked.force_sig_info_to_task.force_sig.exc_int3
     12.43            -0.2       12.18        perf-profile.calltrace.cycles-pp.inc_rlimit_get_ucounts.__sigqueue_alloc.__send_signal_locked.do_send_sig_info.do_send_specific
     17.48            -0.2       17.25        perf-profile.calltrace.cycles-pp.irqentry_exit_to_user_mode.asm_exc_int3.stress_sigtrap
     17.44            -0.2       17.21        perf-profile.calltrace.cycles-pp.arch_do_signal_or_restart.irqentry_exit_to_user_mode.asm_exc_int3.stress_sigtrap
     12.85            -0.2       12.63        perf-profile.calltrace.cycles-pp.__sigqueue_alloc.__send_signal_locked.do_send_sig_info.do_send_specific.__x64_sys_tgkill
     12.64            -0.2       12.44        perf-profile.calltrace.cycles-pp.inc_rlimit_get_ucounts.__sigqueue_alloc.__send_signal_locked.force_sig_info_to_task.force_sig
     13.07            -0.2       12.88        perf-profile.calltrace.cycles-pp.__sigqueue_alloc.__send_signal_locked.force_sig_info_to_task.force_sig.exc_int3
      0.73 ±  2%      -0.1        0.61 ±  5%  perf-profile.calltrace.cycles-pp.fpregs_mark_activate.fpu__clear_user_states.handle_signal.arch_do_signal_or_restart.irqentry_exit_to_user_mode
      2.50            -0.1        2.40        perf-profile.calltrace.cycles-pp.arch_do_signal_or_restart.irqentry_exit_to_user_mode.asm_exc_int3.stress_sigtrap_handler
      2.55            -0.1        2.45        perf-profile.calltrace.cycles-pp.asm_exc_int3.stress_sigtrap_handler
      2.54            -0.1        2.44        perf-profile.calltrace.cycles-pp.irqentry_exit_to_user_mode.asm_exc_int3.stress_sigtrap_handler
      3.07            -0.1        2.97        perf-profile.calltrace.cycles-pp.set_current_blocked.__x64_sys_rt_sigreturn.do_syscall_64.entry_SYSCALL_64_after_hwframe
      1.37 ±  2%      -0.1        1.28        perf-profile.calltrace.cycles-pp._raw_spin_lock_irq.set_current_blocked.__x64_sys_rt_sigreturn.do_syscall_64.entry_SYSCALL_64_after_hwframe
      1.16            -0.1        1.08 ±  3%  perf-profile.calltrace.cycles-pp.fpu__clear_user_states.handle_signal.arch_do_signal_or_restart.irqentry_exit_to_user_mode.asm_exc_int3
      1.24            -0.1        1.16 ±  2%  perf-profile.calltrace.cycles-pp.handle_signal.arch_do_signal_or_restart.irqentry_exit_to_user_mode.asm_exc_int3.stress_sigtrap_handler
      0.79            -0.1        0.71        perf-profile.calltrace.cycles-pp.fpu__clear_user_states.handle_signal.arch_do_signal_or_restart.syscall_exit_to_user_mode.do_syscall_64
      0.64            -0.1        0.57        perf-profile.calltrace.cycles-pp._raw_spin_lock_irqsave.force_sig_info_to_task.force_sig.exc_int3.asm_exc_int3
      0.82            -0.1        0.75        perf-profile.calltrace.cycles-pp.get_task_cred.apparmor_task_kill.security_task_kill.do_send_specific.__x64_sys_tgkill
      0.73            +0.0        0.77        perf-profile.calltrace.cycles-pp.__set_current_blocked.signal_setup_done.arch_do_signal_or_restart.syscall_exit_to_user_mode.do_syscall_64
      0.78            +0.0        0.82        perf-profile.calltrace.cycles-pp.signal_setup_done.arch_do_signal_or_restart.syscall_exit_to_user_mode.do_syscall_64.entry_SYSCALL_64_after_hwframe
      0.52            +0.0        0.57        perf-profile.calltrace.cycles-pp.recalc_sigpending.__set_current_blocked.signal_setup_done.arch_do_signal_or_restart.syscall_exit_to_user_mode
      0.75            +0.1        0.80        perf-profile.calltrace.cycles-pp.sync_regs.asm_exc_int3.stress_sigtrap
      1.34            +0.1        1.39        perf-profile.calltrace.cycles-pp.complete_signal.__send_signal_locked.do_send_sig_info.do_send_specific.__x64_sys_tgkill
      3.06            +0.1        3.12        perf-profile.calltrace.cycles-pp.handle_signal.arch_do_signal_or_restart.syscall_exit_to_user_mode.do_syscall_64.entry_SYSCALL_64_after_hwframe
      1.34            +0.1        1.41        perf-profile.calltrace.cycles-pp.get_sigframe.x64_setup_rt_frame.handle_signal.arch_do_signal_or_restart.irqentry_exit_to_user_mode
      2.30            +0.1        2.37        perf-profile.calltrace.cycles-pp.restore_fpregs_from_user.__fpu_restore_sig.fpu__restore_sig.restore_sigcontext.__x64_sys_rt_sigreturn
      1.38            +0.1        1.46        perf-profile.calltrace.cycles-pp.get_sigframe.x64_setup_rt_frame.handle_signal.arch_do_signal_or_restart.syscall_exit_to_user_mode
      1.82            +0.1        1.90        perf-profile.calltrace.cycles-pp.restore_sigcontext.__x64_sys_rt_sigreturn.do_syscall_64.entry_SYSCALL_64_after_hwframe.stress_sigtrap
      1.58            +0.1        1.67        perf-profile.calltrace.cycles-pp.x64_setup_rt_frame.handle_signal.arch_do_signal_or_restart.irqentry_exit_to_user_mode.asm_exc_int3
      1.47            +0.1        1.56        perf-profile.calltrace.cycles-pp.copy_fpstate_to_sigframe.get_sigframe.x64_setup_rt_frame.handle_signal.arch_do_signal_or_restart
      1.64            +0.1        1.73        perf-profile.calltrace.cycles-pp.x64_setup_rt_frame.handle_signal.arch_do_signal_or_restart.syscall_exit_to_user_mode.do_syscall_64
      2.13            +0.1        2.23        perf-profile.calltrace.cycles-pp.__x64_sys_rt_sigreturn.do_syscall_64.entry_SYSCALL_64_after_hwframe.stress_sigtrap
      2.20            +0.1        2.31        perf-profile.calltrace.cycles-pp.entry_SYSCALL_64_after_hwframe.stress_sigtrap
      2.19            +0.1        2.30        perf-profile.calltrace.cycles-pp.do_syscall_64.entry_SYSCALL_64_after_hwframe.stress_sigtrap
      2.12            +0.1        2.24        perf-profile.calltrace.cycles-pp.handle_signal.arch_do_signal_or_restart.irqentry_exit_to_user_mode.asm_exc_int3.stress_sigtrap
      2.51            +0.1        2.64        perf-profile.calltrace.cycles-pp.restore_sigcontext.__x64_sys_rt_sigreturn.do_syscall_64.entry_SYSCALL_64_after_hwframe
      3.42            +0.1        3.54        perf-profile.calltrace.cycles-pp.__fpu_restore_sig.fpu__restore_sig.restore_sigcontext.__x64_sys_rt_sigreturn.do_syscall_64
      3.50            +0.1        3.63        perf-profile.calltrace.cycles-pp.fpu__restore_sig.restore_sigcontext.__x64_sys_rt_sigreturn.do_syscall_64.entry_SYSCALL_64_after_hwframe
      7.59            +0.2        7.78        perf-profile.calltrace.cycles-pp.stress_sigtrap_handler
      0.15 ±152%      +0.4        0.53        perf-profile.calltrace.cycles-pp.__rseq_handle_notify_resume.handle_signal.arch_do_signal_or_restart.syscall_exit_to_user_mode.do_syscall_64
      0.00            +0.5        0.52        perf-profile.calltrace.cycles-pp.__rseq_handle_notify_resume.handle_signal.arch_do_signal_or_restart.irqentry_exit_to_user_mode.asm_exc_int3
      0.00            +0.5        0.52        perf-profile.calltrace.cycles-pp.__get_user_nocheck_8.__x64_sys_rt_sigreturn.do_syscall_64.entry_SYSCALL_64_after_hwframe
      0.00            +0.5        0.54        perf-profile.calltrace.cycles-pp._copy_from_user.restore_sigcontext.__x64_sys_rt_sigreturn.do_syscall_64.entry_SYSCALL_64_after_hwframe
      0.00            +0.6        0.57 ± 26%  perf-profile.calltrace.cycles-pp.save_xstate_epilog.get_sigframe.x64_setup_rt_frame.handle_signal.arch_do_signal_or_restart
     30.20            -0.7       29.47        perf-profile.children.cycles-pp.get_signal
     37.21            -0.7       36.51        perf-profile.children.cycles-pp.asm_exc_int3
     24.78            -0.7       24.12        perf-profile.children.cycles-pp.do_dec_rlimit_put_ucounts
     38.90            -0.6       38.31        perf-profile.children.cycles-pp.arch_do_signal_or_restart
     28.53            -0.5       28.03        perf-profile.children.cycles-pp.__send_signal_locked
     15.08            -0.5       14.59        perf-profile.children.cycles-pp.force_sig
     14.96            -0.5       14.47        perf-profile.children.cycles-pp.force_sig_info_to_task
     15.50            -0.5       15.01        perf-profile.children.cycles-pp.exc_int3
     25.08            -0.5       24.62        perf-profile.children.cycles-pp.inc_rlimit_get_ucounts
     37.92            -0.4       37.48        perf-profile.children.cycles-pp.stress_sigtrap
     25.95            -0.4       25.54        perf-profile.children.cycles-pp.__sigqueue_alloc
     12.55            -0.4       12.19        perf-profile.children.cycles-pp.collect_signal
     20.04            -0.3       19.71        perf-profile.children.cycles-pp.irqentry_exit_to_user_mode
     13.35            -0.3       13.04        perf-profile.children.cycles-pp.dequeue_signal
      1.79            -0.2        1.56        perf-profile.children.cycles-pp.fpregs_mark_activate
      2.02            -0.2        1.85        perf-profile.children.cycles-pp.fpu__clear_user_states
      2.09            -0.2        1.93        perf-profile.children.cycles-pp.complete_signal
      3.09            -0.1        3.00        perf-profile.children.cycles-pp.set_current_blocked
      0.82            -0.1        0.76        perf-profile.children.cycles-pp.get_task_cred
      0.05            +0.0        0.06        perf-profile.children.cycles-pp.generic_perform_write
      0.24            +0.0        0.26        perf-profile.children.cycles-pp.__put_user_8
      0.05            +0.0        0.07 ±  7%  perf-profile.children.cycles-pp.shmem_file_write_iter
      0.23 ±  2%      +0.0        0.25 ±  3%  perf-profile.children.cycles-pp.__get_user_8
      0.40            +0.0        0.42        perf-profile.children.cycles-pp.__put_user_nocheck_4
      0.07 ±  5%      +0.0        0.09 ±  4%  perf-profile.children.cycles-pp.record__mmap_read_evlist
      0.06            +0.0        0.08        perf-profile.children.cycles-pp.record__pushfn
      0.34            +0.0        0.36        perf-profile.children.cycles-pp.rseq_update_cpu_node_id
      0.06 ±  7%      +0.0        0.08 ±  5%  perf-profile.children.cycles-pp.perf_mmap__push
      0.08 ±  5%      +0.0        0.10 ±  3%  perf-profile.children.cycles-pp.main
      0.08 ±  5%      +0.0        0.10 ±  3%  perf-profile.children.cycles-pp.run_builtin
      0.36            +0.0        0.38        perf-profile.children.cycles-pp.entry_SYSRETQ_unsafe_stack
      0.06            +0.0        0.08 ±  5%  perf-profile.children.cycles-pp.writen
      0.29 ±  2%      +0.0        0.32 ±  2%  perf-profile.children.cycles-pp.rseq_get_rseq_cs
      0.07 ±  6%      +0.0        0.10 ±  4%  perf-profile.children.cycles-pp.__cmd_record
      0.07 ±  6%      +0.0        0.10 ±  4%  perf-profile.children.cycles-pp.cmd_record
      0.53            +0.0        0.56        perf-profile.children.cycles-pp.__get_user_nocheck_8
      0.55            +0.0        0.58        perf-profile.children.cycles-pp.__getpid
      0.58            +0.0        0.62        perf-profile.children.cycles-pp.restore_altstack
      0.53            +0.0        0.57        perf-profile.children.cycles-pp.__get_user_nocheck_4
      0.68            +0.0        0.72        perf-profile.children.cycles-pp.kmem_cache_free
      0.67            +0.0        0.71        perf-profile.children.cycles-pp.check_xstate_in_sigframe
      0.79            +0.0        0.83 ±  2%  perf-profile.children.cycles-pp.kmem_cache_alloc
      0.63            +0.0        0.67        perf-profile.children.cycles-pp.rseq_ip_fixup
      0.77            +0.0        0.82        perf-profile.children.cycles-pp.sync_regs
      0.23 ±  2%      +0.1        0.28        perf-profile.children.cycles-pp.prepare_signal
      1.00            +0.1        1.05        perf-profile.children.cycles-pp.save_xstate_epilog
      1.00            +0.1        1.07        perf-profile.children.cycles-pp.__rseq_handle_notify_resume
      2.32            +0.1        2.39        perf-profile.children.cycles-pp.restore_fpregs_from_user
      0.93            +0.1        1.02        perf-profile.children.cycles-pp._copy_from_user
      1.52            +0.1        1.61        perf-profile.children.cycles-pp.copy_fpstate_to_sigframe
      6.45            +0.1        6.54        perf-profile.children.cycles-pp.handle_signal
      3.45            +0.1        3.57        perf-profile.children.cycles-pp.__fpu_restore_sig
      3.51            +0.1        3.64        perf-profile.children.cycles-pp.fpu__restore_sig
      2.75            +0.2        2.91        perf-profile.children.cycles-pp.get_sigframe
      3.27            +0.2        3.45        perf-profile.children.cycles-pp.x64_setup_rt_frame
      8.65            +0.2        8.84        perf-profile.children.cycles-pp.__x64_sys_rt_sigreturn
      2.17            +0.2        2.36        perf-profile.children.cycles-pp.native_irq_return_iret
      4.35            +0.2        4.56        perf-profile.children.cycles-pp.restore_sigcontext
     58.30            +0.4       58.70        perf-profile.children.cycles-pp.do_syscall_64
     58.48            +0.4       58.89        perf-profile.children.cycles-pp.entry_SYSCALL_64_after_hwframe
     24.78            -0.7       24.12        perf-profile.self.cycles-pp.do_dec_rlimit_put_ucounts
     25.07            -0.5       24.62        perf-profile.self.cycles-pp.inc_rlimit_get_ucounts
      1.72            -0.2        1.49        perf-profile.self.cycles-pp.fpregs_mark_activate
      1.97            -0.2        1.80        perf-profile.self.cycles-pp.complete_signal
      0.81            -0.1        0.75        perf-profile.self.cycles-pp.get_task_cred
      0.08 ±  5%      -0.0        0.06 ±  4%  perf-profile.self.cycles-pp.force_sig_info_to_task
      0.22            +0.0        0.23        perf-profile.self.cycles-pp.__send_signal_locked
      0.16 ±  3%      +0.0        0.18 ±  2%  perf-profile.self.cycles-pp.get_sigframe
      0.18 ±  2%      +0.0        0.20 ±  2%  perf-profile.self.cycles-pp.syscall_exit_to_user_mode
      0.27 ±  2%      +0.0        0.29        perf-profile.self.cycles-pp.mod_objcg_state
      0.33            +0.0        0.35        perf-profile.self.cycles-pp.restore_sigcontext
      0.23            +0.0        0.25        perf-profile.self.cycles-pp.__put_user_8
      0.28            +0.0        0.30        perf-profile.self.cycles-pp.kmem_cache_alloc
      0.22 ±  2%      +0.0        0.24 ±  3%  perf-profile.self.cycles-pp.__get_user_8
      0.47            +0.0        0.49        perf-profile.self.cycles-pp.__fpu_restore_sig
      0.34            +0.0        0.36        perf-profile.self.cycles-pp.entry_SYSRETQ_unsafe_stack
      0.33            +0.0        0.35        perf-profile.self.cycles-pp.rseq_update_cpu_node_id
      0.37            +0.0        0.39        perf-profile.self.cycles-pp.__put_user_nocheck_4
      0.36            +0.0        0.38        perf-profile.self.cycles-pp.save_xstate_epilog
      0.39            +0.0        0.41        perf-profile.self.cycles-pp.check_xstate_in_sigframe
      0.51            +0.0        0.54        perf-profile.self.cycles-pp.__get_user_nocheck_8
      0.52            +0.0        0.55        perf-profile.self.cycles-pp.x64_setup_rt_frame
      0.52            +0.0        0.55        perf-profile.self.cycles-pp.__get_user_nocheck_4
      0.76            +0.0        0.81        perf-profile.self.cycles-pp.sync_regs
      0.21            +0.1        0.26        perf-profile.self.cycles-pp.prepare_signal
      0.96            +0.1        1.01        perf-profile.self.cycles-pp.fpu__clear_user_states
      1.12            +0.1        1.19        perf-profile.self.cycles-pp.stress_sigtrap
      1.36            +0.1        1.44        perf-profile.self.cycles-pp.copy_fpstate_to_sigframe
      1.60            +0.1        1.68        perf-profile.self.cycles-pp.restore_fpregs_from_user
      0.91            +0.1        1.00        perf-profile.self.cycles-pp._copy_from_user
      2.17            +0.2        2.36        perf-profile.self.cycles-pp.native_irq_return_iret




Disclaimer:
Results have been estimated based on internal Intel analysis and are provided
for informational purposes only. Any difference in system hardware or software
design or configuration may affect actual performance.


-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

