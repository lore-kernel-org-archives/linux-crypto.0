Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2579B28691
	for <linux-crypto@vger.kernel.org>; Wed,  7 May 2025 05:35:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.9
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746596141; cv=fail; b=rtk0NOL2tN9SrftgDa5Hc5mEKHwL3SN7PWqhf4a42egO+0IKqzrlmXHLWwBpJFR6fTF56ZhNxfzmKmqANmEZMwHc0nguWBcgc5pmzAXS81v1DnWha75kJMiB/oBbPY8J+4p9E1S6Vh38elws5i4UQTR7bEiMCv7V/8hk55CLUg0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746596141; c=relaxed/simple;
	bh=cP3Cc+DclMUmtsnzoQbloGIUOnobQkL5cJCnZB2l9i0=;
	h=Date:From:To:CC:Subject:Message-ID:Content-Type:
	 Content-Disposition:MIME-Version; b=BsCMySH9itc8OOLcLOMhSSRVTCNZ7oQLb1mTt5xLNbOmx/rLW1ZttemfCb+FksRdcOPeK60XTHU7qf4ba4BONjGtryHUMGs6e3+eczg1MqZ189unajENIonLVUxgN5W8/ZQeAO6BTusXjzLntPi8fP4nqySIwNWpc32aPVcjF5w=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=TE3JIRJt; arc=fail smtp.client-ip=192.198.163.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="TE3JIRJt"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1746596138; x=1778132138;
  h=date:from:to:cc:subject:message-id:mime-version;
  bh=cP3Cc+DclMUmtsnzoQbloGIUOnobQkL5cJCnZB2l9i0=;
  b=TE3JIRJtcHEjXTfPnxd5XiRagDP/QNHYnWrv8bUudOYFC//YoIc9S3io
   4IR4bcMXX+mcmizpPIn5+f1xR6su6z3gNHSGnh4O8fF2efH8JXt4eZrs8
   sLEld+jg4Sp6/6+kB94s2acoEmQlO+U/IRqJt2CJB3ZZOaKbsflb5SyGY
   S9ic+CY6gdhJur4Bxdf+rXKaUf4ZCzCam8Qr77RK2oXXH1LiL+0tZdwB4
   ZpMIm1I+GQLWgRJWdp3lATehzle8xkr9h4G9gh9y8vjpdqfBL9siWpsLd
   teYccNa7SwyefFdg5CX1+yP7EEY+kwdGhzu9XVlNM/Mcku77su09LGs7G
   Q==;
X-CSE-ConnectionGUID: pkrh198OSFm01cyt24z6Eg==
X-CSE-MsgGUID: 4QW8jIWrQU+JR/T4Gv/8og==
X-IronPort-AV: E=McAfee;i="6700,10204,11425"; a="58962566"
X-IronPort-AV: E=Sophos;i="6.15,268,1739865600"; 
   d="xz'341?scan'341,208,341";a="58962566"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 May 2025 22:35:37 -0700
X-CSE-ConnectionGUID: JEelQ2B3TqiX/L0g6TN7mg==
X-CSE-MsgGUID: cjoLeudqTySdvRFs+DXPsw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,268,1739865600"; 
   d="xz'341?scan'341,208,341";a="159140767"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by fmviesa002.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 May 2025 22:35:36 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Tue, 6 May 2025 22:35:36 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14 via Frontend Transport; Tue, 6 May 2025 22:35:36 -0700
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (104.47.73.168)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Tue, 6 May 2025 22:35:36 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=s+DrGswd80yio7ZoQgsE8SiiRx6NddMlQeFjpqtiaylYfHTXh+X9nK0YAwYcvnj56Wgx4UO3UHxZ4pfUQBQtqF51Ks8lYMEZC24F8EaTI8rC6pMoZ8X0poaAGOAp3mWcwPQWGwVs9o7mtP3j3/7CxlGahJIcd6OCjefkhub2Jwhzlad7CfTQqTwDe+iRCXGUHy9gdJqzYpjs5kmn6XpTD1SkFJza8XC4j2+ZrJm6B7iN8O7J2+reCRzwHhtadTiKIUtV+hIp2XlMa8PKFtQCKmaUhSu8P0gTqWUdIDtzxmlMb6OT9XrXT/60mD+6HtPWOED371+LsuEvv9QpZKLjcg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0+T8bKAn1FZkm8ZaEe+Mae4Uz1prTOanr8NIxqtgjCg=;
 b=fKG8vaw3pZWO92kntt6tortR5q7J3KWD/5E2uqXFjplxDlEIwOUk34qMz8dWPXqCC19njmAKeu8XalhrIcS5hq2SplQ0u+YJ/jhgEDqA7f21tj+VBaR8XwyTj8P86wTkrE7kxmJ1v02DFM7mvaGdqOBxkgCeeB8goUcVx9uKTmTBfVEMsKuAHw2XzwhMfEkNXU6vdMHNniMfedsetaofreXbjSP8WXZBUxHaeSKT01WdoM5TknCGURyx2vwopahWaOfjTlopqLYaP1aaaqY4l9sucz0lbyAn+OYgkmGqurzI6NKicGfkPptx1zSv0rYxyv+xsBoX2mbdGw91LVCncg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from LV3PR11MB8603.namprd11.prod.outlook.com (2603:10b6:408:1b6::9)
 by DS7PR11MB6222.namprd11.prod.outlook.com (2603:10b6:8:99::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8699.26; Wed, 7 May
 2025 05:35:27 +0000
Received: from LV3PR11MB8603.namprd11.prod.outlook.com
 ([fe80::4622:29cf:32b:7e5c]) by LV3PR11MB8603.namprd11.prod.outlook.com
 ([fe80::4622:29cf:32b:7e5c%4]) with mapi id 15.20.8699.026; Wed, 7 May 2025
 05:35:27 +0000
Date: Wed, 7 May 2025 13:35:18 +0800
From: kernel test robot <oliver.sang@intel.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
CC: <oe-lkp@lists.linux.dev>, <lkp@intel.com>, <linux-crypto@vger.kernel.org>,
	<oliver.sang@intel.com>
Subject: [linux-next:master] [crypto]  34f170a590:
 CFI_failure_at_sk_filter_trim_cap
Message-ID: <202505071038.a6282b83-lkp@intel.com>
Content-Type: multipart/mixed; boundary="XpV4H1CS+bHWiHcT"
Content-Disposition: inline
X-ClientProxiedBy: SI1PR02CA0037.apcprd02.prod.outlook.com
 (2603:1096:4:1f6::13) To LV3PR11MB8603.namprd11.prod.outlook.com
 (2603:10b6:408:1b6::9)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV3PR11MB8603:EE_|DS7PR11MB6222:EE_
X-MS-Office365-Filtering-Correlation-Id: bd95549b-43cf-433f-9641-08dd8d28f8b3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014|4053099003;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?xMOx4UxR35SgVcKgu7PCq0q1CDjxHziiSPs3DzOtFhj2uSSpegr+qSSOD+yL?=
 =?us-ascii?Q?+iWmij3uEaT2yHQwjL83NmcM1KTPNmuQmLk1GUd6lx44ibhUcBXWFEfPfoh/?=
 =?us-ascii?Q?H55aDitVeBJlzMQOQVYxKtmxHoTPI/AMdy9ybMniif6CwfzGz/i5d2z5llV4?=
 =?us-ascii?Q?+N5acri8NhifY76yl3BTMqTylX45MFnbACRF1Kf129tOZFiGZQP3XWLP23Cr?=
 =?us-ascii?Q?GHuIFi/d6cQlyAVXIWEgv4oGFJ7Kij9575vB22ID4OAYHfqFMNJUKzOYgA+4?=
 =?us-ascii?Q?wJ6uvIlM6OVNbmYmriWc68ISpcjr8O2o6EHDQPf2mY8qwUZHqflG96qBbucQ?=
 =?us-ascii?Q?ymIjJWwua6sIb+yNRJjKJ3tatJZLYCxnzvOG8J/C47JWXfH7/jW6IZF7orEP?=
 =?us-ascii?Q?W28DJRispQBbyM+LkGAZcUu8a5GiEwxyowyxVUxXmu1RyLXFWsq+fY0t0UKV?=
 =?us-ascii?Q?9NNNy/EN+QEoLIwnFS8H5pbHKZvT6D/F5lYyfFZJ6MzdN/vWmxXdV3k1sPNJ?=
 =?us-ascii?Q?a5RPBH8jErD7dLd0HBBMidAw8hAJaue0OcLscCCDDCbQaOjRGqHJbjA/Idy1?=
 =?us-ascii?Q?oDRhESdXzNeO6IkhgX8Pk8uEGSrpg1utOVVqCN4QUUMhfUC+tadl3hMhlRvG?=
 =?us-ascii?Q?ZIrL7t82ANXPQk/pRnHjQC+5RP6mPcnIejJI/Xbq6r0k+kFf1lCbKl0iEqHF?=
 =?us-ascii?Q?gKN+DuSbIHyQG55lwgdfYQ7asOLD+PeRfcuTeDZLkl/lYk1LCgfh5K2J20ZK?=
 =?us-ascii?Q?A53l7Zps7x4Th3NZGlSxXiP2ts12A7tYkgr+XDW6lWjaLszn54WSJSkCc12v?=
 =?us-ascii?Q?ipfBuoTNwWlS5IFuHyoezqV+/0Nk1MBbyN6iA+pq1rTwMkvxZF5qmA+FuwGK?=
 =?us-ascii?Q?9F2/JvFPOIX5CCNJeMUAChYOsbQBNXnDSEJg+hSRlEUZasFWGBMMIQP20+gR?=
 =?us-ascii?Q?00WAeltj6hfeUtjOtARQt/d52TJaHzLKoC9uefBUXlVvOqUZCu7PoiWF03Z9?=
 =?us-ascii?Q?bHyYMbJNqOxYRHrr7LJlk3ba9TMP9vpx2k2ks4U7v7wqB30niW1RraEQ54sv?=
 =?us-ascii?Q?uXLpXnrhzXGIgsbB4e2lYyL88GlUvb6naDEqdZhQtyf0LRY/yn31uast7Gwg?=
 =?us-ascii?Q?Oe0g7uKMbQjBw1BOWHhB8Mw9dKALkJVWlrslnU9h3vEvwYn+kqyd2Er3AcVn?=
 =?us-ascii?Q?KlOSfnl7E3vVVKso8VK4xntEdL0F/3PC9+HW9NMLbG5qK6vNBIKdyS4N5RQw?=
 =?us-ascii?Q?LQoACqh3c4Ep9N1LDoIghPADSJVrWIGFq4V6pf/Lc0i5wvBiqgbASEk4AYOV?=
 =?us-ascii?Q?JdJh3dWT3DAYpCM+Cfsk8AHKZwEBVA2CZqtKbRRKTk10htgLPMI/SUTV3buS?=
 =?us-ascii?Q?osSWpmtgwdpPKMjxwMAvimFoZaEw?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV3PR11MB8603.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(4053099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?t6cVN8aSB+bDfdQiVldL7sMR/6Wsb4lwghCzl0gfrFFUM4soTFy9oD9ulG6a?=
 =?us-ascii?Q?UsaUIlQrowIJ28bOejUkE2/ub2NYP94bqM+14anydiStCX8+NHtBlTexdPHg?=
 =?us-ascii?Q?EtG+XfUNfLy76pXqdnUhGMnxZJ4WtQu/8lp8KLlYc1sDghhRUDsHwUznfG1J?=
 =?us-ascii?Q?Fsv5qsjf/lT0SyAniwSNSFd5GDXTYw23O/WpdzGHOrX5duL/dnUZEPqZiY/y?=
 =?us-ascii?Q?d4jAis25+bplcjzsYeHFV3L9AjYfoWE6cqHcfIbwp/jehPTtvPzzFuiWhwAm?=
 =?us-ascii?Q?fMKzq8hxW9AvnpVNTgymbu+i7JCF1bIEoheMfCkh07ETCZ5srcWMwkzvH40p?=
 =?us-ascii?Q?oAGTvvBxPMUMBMlx1EaR7eb6Cxnooc2z7Uf9EJh7F/+UFZ2/GeUGSOlpKq/T?=
 =?us-ascii?Q?OdfMd3u7OMjo5qWQh0JLgiWK1i/etxrZhlltk1QexZklormuOXhCPMdNEMD7?=
 =?us-ascii?Q?tZdmDHZCGD2Qmwp7077lwElLmvlx9QixVG5zjxna+uMHr667M2D7M5E/Re/R?=
 =?us-ascii?Q?Mp4cu9rXLxvRSQSEkNXXCvMjJ0ejfUIAzhIYCfOf5VD9mI4JaIG0u/hZ0tu3?=
 =?us-ascii?Q?6O5deM5Ew8HybxCUX5FcJasnlqjeSdkM7DKVGF1A7GOMwaKxMyFIXa77MkiA?=
 =?us-ascii?Q?q8FvlzNtzEY8055fHqDxi48wO7VkInpzJlxMACDeQKKvOsUmnHXUwvi3euBz?=
 =?us-ascii?Q?1/I/TK5TNHNo7kDNlwibtvHPDjpYowhgLYbrX2rBwiCQg7DmdZJpvu+DlvUR?=
 =?us-ascii?Q?xezLwnii+M+yIuwJL6ap3Hbi/juVPk1T/NSOzfXgFsu3N8HVykLGImTBq9+S?=
 =?us-ascii?Q?dVpXZMUfYy5P2bHbObEwHYbVEqS8q7bOYy3SVBVRiWB9V1dKihljjL6ETPw2?=
 =?us-ascii?Q?vwIO4gV5BDGBTVXVWTplxvnM2ZcmopBneKqrDfK8MgtO6/eNYnUfcgew1ODm?=
 =?us-ascii?Q?ut8IPxVRXqBMYAyLlcYamuP1vjHQ3aXNkxqd3cZlhEWjsfWY1991GF7EZWOi?=
 =?us-ascii?Q?pmb8WG+4ywiEy0jnOvaqd5OX9ynHd3P3yjMXlYgMfulh13YJROrm4+uAy/k1?=
 =?us-ascii?Q?E0CGYzGTxHdS4FM/5HU1zY2hwsdv4v13vSdbE2IDA+Z5SNKHbq4VAM/KekHZ?=
 =?us-ascii?Q?v5eE2/EyoTqHHysnXk0cJmkouznCZYCKnZKJr7L4nhXEiWKHHcQOaEJuVc7S?=
 =?us-ascii?Q?khmCoJVCcLf2hiYCHpYpDGMWvULzOFf/Ip9I255Fe2lmeJ7++blCt9TvWtm/?=
 =?us-ascii?Q?4DyPXR62Tu/mct0kqzvz6EAM783yhtMpxTgFlROUN7LjOZS+CFvUex99kXU2?=
 =?us-ascii?Q?N4MIMe5WOUIVhX2etRgTVmzQU3BsgWgx8TTK0QU41VFAR/iAEkglHWTSVN8T?=
 =?us-ascii?Q?LlQXq3SVXfy9BGq1XECvZcdKRi4EUvk/8DmifnJBfCB29XzFumz1edYduHyr?=
 =?us-ascii?Q?nYySSMJY4rJ8KWB7Sw2RnDPEmySIHVCDopm7GZ83UTFIPEupWm2SMCajfHxq?=
 =?us-ascii?Q?wyTXoNbGx6gq4/VkuJNN/HkYts9HXeppK8EuVxxQxBWu02Voa8EdM9Fld/r5?=
 =?us-ascii?Q?RSflwdIUkgdsJqz00dMsbs6kng9snjYDtYj3qIh/HugcA/+w7cuLJMtqvc0J?=
 =?us-ascii?Q?9g=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: bd95549b-43cf-433f-9641-08dd8d28f8b3
X-MS-Exchange-CrossTenant-AuthSource: LV3PR11MB8603.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 May 2025 05:35:27.0874
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: FMIE51R3eKTzJK9Y83YmA/c/aP5lNPveR130xtoDUxfFB54Hrp2NiwcmZ/29tgWZTO/AY01b6DBpkqyhK/9lAg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR11MB6222
X-OriginatorOrg: intel.com

--XpV4H1CS+bHWiHcT
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline


Hello,


we think this commit is not the root cause of the "CFI failure", but it
changes the failure's stats:

f1c09a0b6add651e 34f170a590710737f9611231cd7
---------------- ---------------------------
       fail:runs  %reproduction    fail:runs
           |             |             |
          6:6         -100%            :6     dmesg.CFI_failure_at_crypto_acomp_alloc_streams
           :6          100%           6:6     dmesg.CFI_failure_at_sk_filter_trim_cap
          6:6         -100%            :6     dmesg.RIP:crypto_acomp_alloc_streams
           :6          100%           6:6     dmesg.RIP:sk_filter_trim_cap

for comparision, one parent dmesg is attached.

we don't have enough knowledge how this commit is related with this stats change
and our auto-bisect is broken due to this stats change then we failed to bisect
the fbc for dmesg.CFI_failure_at_crypto_acomp_alloc_streams, so we just make out
below report FYI what we observed in our tests.


kernel test robot noticed "CFI_failure_at_sk_filter_trim_cap" on:

commit: 34f170a590710737f9611231cd77b37ea41f707a ("crypto: simd - Include asm/simd.h in internal/simd.h")
https://git.kernel.org/cgit/linux/kernel/git/next/linux-next.git master

in testcase: boot

config: x86_64-randconfig-002-20250506
compiler: clang-20
test machine: qemu-system-x86_64 -enable-kvm -cpu SandyBridge -smp 2 -m 16G

(please refer to attached dmesg/kmsg for entire log/backtrace)



If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <oliver.sang@intel.com>
| Closes: https://lore.kernel.org/oe-lkp/202505071038.a6282b83-lkp@intel.com


The kernel config and materials to reproduce are available at:
https://download.01.org/0day-ci/archive/20250507/202505071038.a6282b83-lkp@intel.com



[   23.316089][  T106] CFI failure at sk_filter_trim_cap+0x160/0x37b (target: 0xffffffffc000065c; expected type: 0xb84d5dc1)
[   23.317710][  T106] Oops: invalid opcode: 0000 [#1] PTI
[   23.318366][  T106] CPU: 0 UID: 0 PID: 106 Comm: systemd-udevd Tainted: G                T   6.15.0-rc1-00123-g34f170a59071 #1 PREEMPT(lazy)  8bf920cabe1e67f84bf21013cd65d8014debb874
[   23.320517][  T106] Tainted: [T]=RANDSTRUCT
[   23.321128][  T106] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.16.2-debian-1.16.2-1 04/01/2014
[   23.322539][  T106] RIP: 0010:sk_filter_trim_cap+0x160/0x37b
[   23.323366][  T106] Code: 00 48 89 54 24 10 83 3d f5 74 f0 01 00 0f 8f 72 01 00 00 48 8d 73 48 4c 8b 5b 30 4c 89 f7 41 ba 3f a2 b2 47 45 03 53 c1 74 02 <0f> 0b 41 ff d3 0f 1f 00 41 89 c4 f6 43 02 08 0f 85 8c 01 00 00 4d
[   23.326044][  T106] RSP: 0018:ffffc900001df660 EFLAGS: 00210292
[   23.326869][  T106] RAX: 0000000000000000 RBX: ffffc9000002d000 RCX: 00000000ffffffff
[   23.327965][  T106] RDX: ffff888163d75330 RSI: ffffc9000002d048 RDI: ffff888163d75300
[   23.328993][  T106] RBP: ffffc900001df6d8 R08: 0000000000000000 R09: 0000000000000000
[   23.330106][  T106] R10: 00000000ca9c6270 R11: ffffffffc000065c R12: ffff888163c86800
[   23.331199][  T106] R13: 0000000000000000 R14: ffff888163d75300 R15: 0000000000000001
[   23.332243][  T106] FS:  0000000000000000(0000) GS:0000000000000000(0063) knlGS:00000000f7917b00
[   23.333475][  T106] CS:  0010 DS: 002b ES: 002b CR0: 0000000080050033
[   23.334327][  T106] CR2: 0000000058461bfc CR3: 00000001622d8000 CR4: 00000000000406f0
[   23.335239][  T106] Call Trace:
[   23.335599][  T106]  <TASK>
[   23.335920][  T106]  ? sk_filter_trim_cap+0x7a/0x37b
[   23.336471][  T106]  netlink_broadcast_filtered+0x1f0/0x47b
[   23.337081][  T106]  netlink_sendmsg+0x30e/0x3c0
[   23.337610][  T106]  __sock_sendmsg+0x92/0xc5
[   23.338098][  T106]  ____sys_sendmsg+0x1b2/0x245
[   23.338616][  T106]  ___sys_sendmsg+0x9f/0x105
[   23.339154][  T106]  __sys_sendmsg+0x95/0x13b
[   23.339723][  T106]  __ia32_compat_sys_socketcall+0x231/0x340
[   23.340507][  T106]  ? __this_cpu_preempt_check+0xd/0x40
[   23.341250][  T106]  ? lockdep_hardirqs_on+0x7e/0x140
[   23.341967][  T106]  ia32_sys_call+0x2e30/0x2ec0
[   23.342612][  T106]  __do_fast_syscall_32+0xcb/0x105
[   23.343329][  T106]  ? find_held_lock+0x4a/0x140
[   23.343988][  T106]  ? __this_cpu_preempt_check+0xd/0x40
[   23.344743][  T106]  ? __this_cpu_preempt_check+0xd/0x40
[   23.345488][  T106]  ? lockdep_hardirqs_on+0x7e/0x140
[   23.346194][  T106]  ? trace_hardirqs_on+0x45/0x80
[   23.346879][  T106]  ? _raw_spin_unlock_irqrestore+0x41/0x80
[   23.347677][  T106]  ? free_to_partial_list+0x14d/0x200
[   23.348421][  T106]  ? slab_free+0x42/0xc5
[   23.348985][  T106]  ? kmem_cache_free+0x99/0x13b
[   23.349687][  T106]  ? putname+0x5b/0x80
[   23.350226][  T106]  ? do_unlinkat+0x20b/0x240
[   23.350797][  T106]  ? __this_cpu_preempt_check+0xd/0x40
[   23.351495][  T106]  ? __this_cpu_preempt_check+0xd/0x40
[   23.352216][  T106]  ? lockdep_hardirqs_on+0x7e/0x140
[   23.352906][  T106]  ? syscall_exit_to_user_mode+0xeb/0x140
[   23.353677][  T106]  ? __do_fast_syscall_32+0xd7/0x105
[   23.354395][  T106]  ? handle_mm_fault+0x2f8/0x700
[   23.355080][  T106]  ? handle_mm_fault+0x36/0x700
[   23.355760][  T106]  ? find_held_lock+0x4a/0x140
[   23.356421][  T106]  ? __this_cpu_preempt_check+0xd/0x40
[   23.357143][  T106]  ? lock_release+0x1aa/0x280
[   23.357801][  T106]  ? preempt_count_add+0x54/0xc0
[   23.358460][  T106]  ? __this_cpu_preempt_check+0xd/0x40
[   23.359150][  T106]  ? lockdep_hardirqs_on+0x7e/0x140
[   23.359837][  T106]  ? irqentry_exit_to_user_mode+0xe1/0x100
[   23.360613][  T106]  do_fast_syscall_32+0x37/0xfb
[   23.361286][  T106]  do_SYSENTER_32+0x1f/0x40
[   23.361969][  T106]  entry_SYSENTER_compat_after_hwframe+0x73/0x7d
[   23.362863][  T106] RIP: 0023:0xf7f80549
[   23.363453][  T106] Code: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 51 52 55 89 e5 0f 34 cd 80 <5d> 5a 59 c3 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90
[   23.366068][  T106] RSP: 002b:00000000ffc59060 EFLAGS: 00200206 ORIG_RAX: 0000000000000066
[   23.367097][  T106] RAX: ffffffffffffffda RBX: 0000000000000010 RCX: 00000000ffc59070
[   23.368151][  T106] RDX: 0000000000000000 RSI: 00000000f7eb9000 RDI: 0000000000000000
[   23.369226][  T106] RBP: 0000000058462880 R08: 0000000000000000 R09: 0000000000000000
[   23.370276][  T106] R10: 0000000000000000 R11: 0000000000200206 R12: 0000000000000000
[   23.371249][  T106] R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
[   23.372246][  T106]  </TASK>
[   23.372654][  T106] Modules linked in: ipv6 autofs4
[   23.373379][  T106] ---[ end trace 0000000000000000 ]---
[   23.439272][  T108] CFI failure at sk_filter_trim_cap+0x160/0x37b (target: 0xffffffffc000065c; expected type: 0xb84d5dc1)

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki


--XpV4H1CS+bHWiHcT
Content-Type: application/x-xz
Content-Disposition: attachment; filename="dmesg-f1c09a0b6a.xz"
Content-Transfer-Encoding: base64

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

--XpV4H1CS+bHWiHcT--
