Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21A143F482E;
	Thu, 16 Jul 2026 13:34:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.16
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784208881; cv=fail; b=Pb4Zr43qFbLyZ8RTdOyGu5mS+X2TBjdzsBFfYGzEdnxzZuOb2dTXnmYm9G3hPqo8MSXXQ2ipD7csMghVq8ZE3klvxbdtMeOqFxU7rkaQ3hd1GYjMa0rCPJF0/PfQwOCcO60py2N8Ep8YJGRI01wxZ5y/Ho+GrtKvDis433jB+Zo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784208881; c=relaxed/simple;
	bh=fGGqcjNN/FPdyXK5/gURxkSyQ2BDCYig0/7IWAnn49A=;
	h=Date:From:To:CC:Subject:Message-ID:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=bYEPGibLCF89N+VmGNL+lyfYMG4Rfp+Fb4vRck45OKN4fdqk+fMvUAOfayOgTABvsvBWRk74to8u3QnYh1uqnM/qxO34sXaMxcLitVXQtc8vvGc1KqV5IGqMnqzWFf3FtlFH+6P5bhGh3CP9UGm40rFe4TxbcCZWTL3ohom2do0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Pg+kNqTI; arc=fail smtp.client-ip=192.198.163.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Pg+kNqTI"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1784208879; x=1815744879;
  h=date:from:to:cc:subject:message-id:in-reply-to:
   mime-version;
  bh=fGGqcjNN/FPdyXK5/gURxkSyQ2BDCYig0/7IWAnn49A=;
  b=Pg+kNqTIbLedY5743aiJbsOxttYcQQl1RQUlIBQ5TK1pzh7NWaG1BDfr
   IV4YPmYALvp8PSnDWHICamX7HRENeVRnovi0R0jWTwkPkFY0KRk/D34Q3
   SMd6c/VLa1IpJ7OGXReEVtDPf24DLszs2HbsZrdmGWQyiMZqOn5Zn7Vtx
   PCo/o2eoAApOw0w1te5K0ezy+yjPtORd83Ver4CaeweCxzBwkDlLGGJHf
   eTP7GrLV+OYz2qWW74VqutfE2I8ch/aJzZeE087qByCMA/i6Ykyg+DMfi
   pqKR6Yb2cJ8tO1mNBRihFrHnUk/l6aenJtDMjEdDcKkVY3a8RoaE4f6tM
   Q==;
X-CSE-ConnectionGUID: 5iE7KVGnSGOUcLjtpc2X6Q==
X-CSE-MsgGUID: XK+Umns1QviJSzLEgaiHUw==
X-IronPort-AV: E=McAfee;i="6800,10657,11847"; a="72399794"
X-IronPort-AV: E=Sophos;i="6.25,167,1779174000"; 
   d="scan'208";a="72399794"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Jul 2026 06:34:38 -0700
X-CSE-ConnectionGUID: HtKIummiT0O4qxRgcsbShQ==
X-CSE-MsgGUID: I3SCzp8LTy2HgApCsSkPEw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,167,1779174000"; 
   d="scan'208";a="260093107"
Received: from fmsmsx902.amr.corp.intel.com ([10.18.126.91])
  by orviesa003.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Jul 2026 06:34:38 -0700
Received: from FMSMSX903.amr.corp.intel.com (10.18.126.92) by
 fmsmsx902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43; Thu, 16 Jul 2026 06:34:37 -0700
Received: from fmsedg901.ED.cps.intel.com (10.1.192.143) by
 FMSMSX903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43 via Frontend Transport; Thu, 16 Jul 2026 06:34:37 -0700
Received: from CH4PR04CU002.outbound.protection.outlook.com (40.107.201.41) by
 edgegateway.intel.com (192.55.55.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43; Thu, 16 Jul 2026 06:34:37 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=coOYdmzVy2Rf/UayHeV+NQeabcrobFuHiVUebq1yw8JC7uvWhgjYItcFYde9dUuqr2xnbGe1/glz9fOA+uX2SqI5258x03Vcb0DIcRyKSYv3HrP/EACn9GmdYY8oNLee2rQSiEZbsCVGHOQ5+Suctldt4zNyokuokAN3tc4P194TNOY1319hWpG5xe+tjjPeyWFY9J1/0BzckRPFoVQ4lnRihuE0WwsJzEiHbr+giBNcSeQDC5QaQIG/IgheSSuuWU849Sywa97WDON2296qBplfOGuxcrTANSUcRmTzSinUxiKGExfjFxDwPZ6hboh9svGPFPRxd+E0qVFJ/QtvLQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nUCIoS9U0n3lxrUoa1oNWt/8nq0ASK6qL0PP1ZaLF/Q=;
 b=o7dd0D9vw3zlC+Po0yZZtYP659LPihmPFWfAyxxc4t43CpBh+IOIGKEDL5tY1YhP1j7AbtTvxvTzJBUMtnkTuJ+yWpsVW8OyE1Vh6mcg6xVrRlcjB5U22fnpSYTlkrjG1926sQG5phmhDUegQF5yHkDPnK7cJbUfLLAVwuAHrYkcxde4Et+lhpzuWRNXlBHpZq6EU5ZiExVpjDPOAYTKz8F0NfBK24YcaQiGlsRFECpOjgSBs2fVmKcvUi4ut6Y1Ih6JwjKZKhkabK3g2KbU+sHeCH0zRgvkIIS9Un59tU39Jsm74MBhOLvlkmw4iPy1xpr83no2LPhAXuL48yqq3A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH0PR11MB5832.namprd11.prod.outlook.com (2603:10b6:510:141::7)
 by PH3PPF1BAF94C4A.namprd11.prod.outlook.com (2603:10b6:518:1::d0d) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.223.12; Thu, 16 Jul
 2026 13:34:29 +0000
Received: from PH0PR11MB5832.namprd11.prod.outlook.com
 ([fe80::106e:78dd:4c96:d707]) by PH0PR11MB5832.namprd11.prod.outlook.com
 ([fe80::106e:78dd:4c96:d707%5]) with mapi id 15.21.0223.011; Thu, 16 Jul 2026
 13:34:29 +0000
Date: Thu, 16 Jul 2026 21:34:21 +0800
From: kernel test robot <oliver.sang@intel.com>
To: Leonid Ravich <lravich@amazon.com>
CC: <oe-lkp@lists.linux.dev>, <lkp@intel.com>, <linux-raid@vger.kernel.org>,
	<dm-devel@lists.linux.dev>, <linux-crypto@vger.kernel.org>,
	<linux-block@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<herbert@gondor.apana.org.au>, <davem@davemloft.net>, <ebiggers@kernel.org>,
	<snitzer@kernel.org>, <mpatocka@redhat.com>, <axboe@kernel.dk>,
	<oliver.sang@intel.com>
Subject: Re: [PATCH v5 4/5] dm crypt: batch a bio segment's sectors via dun()
Message-ID: <202607161535.5e935cc3-lkp@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20260630083431.2772-5-lravich@amazon.com>
X-ClientProxiedBy: TPYP295CA0024.TWNP295.PROD.OUTLOOK.COM
 (2603:1096:7d0:a::13) To PH0PR11MB5832.namprd11.prod.outlook.com
 (2603:10b6:510:141::7)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR11MB5832:EE_|PH3PPF1BAF94C4A:EE_
X-MS-Office365-Filtering-Correlation-Id: beb73170-a510-45a2-2416-08dee33ef63b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7416014|23010399003|22082099003|18002099003|3023799007|10067099003|11063799006|56012099006;
X-Microsoft-Antispam-Message-Info: 34tS34rJ3XCclEmeiXWiNOGhCR9Grl+4S0+rQEH4U3zMleoj0aBYPd68zDaP0i0lYKpXgs73HFKN+rmrAhSy35eq/axFAD6GKx/+uQyiOrIwej9rPEY5UlJEcgyGD/60HlHTuzV3F8Mnw5lZtqx+bR0jd0Gk/nlwaVbWd38Ksl24qfxqefqL05NHPYZRp5fsmKCDFopi8xya4OHt+bfNQATK/Q7JKTPj3jVRQf1LFMwHwvTQzCbMbTQYHK++jv+upRl1r4g7WTYVq/a9rm6CKzjLd/K6jZ00YThUbGgsb1DE5wxv4VX5SDpHr7DAK5KEKfDmxICttOX8utaaqkapKn0ymM4Js9fXcL0/2xT76hh3hXfD757J1xPF2ccrN5ckhuNRFDEJd+NAd4AuBZ6/xmzzJ1IcS/4jgbsJxWKF6UhCvWlb4cTUA0LJBbNd2QjRkOHlV7OySYRMlfOLwHh9+KAWB0/M7q/6UliwvNG7RCh6GYcP5MfUj0dDHW8SGZKR/9V/h989jtoz/461GcW6om4/LHZ4FjxUcv64/plEVzJ3YZhLfnDWR+c6B86hytuK3voxF8U/1d5yt3V+PT27N2KINIRpTvMijWZfCkbwFQUcV22Vs9S7EbZUvvg+/j5d
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB5832.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014)(23010399003)(22082099003)(18002099003)(3023799007)(10067099003)(11063799006)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?gvon/XS2uJxePCm/mjDakd/Qpz8VJkcAvaHhe8/vvu6eTYg/KcQ/qZ5H7Gre?=
 =?us-ascii?Q?98Gz17S6huHx55wHLT4FN4Iwuw+sATw3wHWuvrvxyj/W1yCFUL30w6HoxwMG?=
 =?us-ascii?Q?rpUcPh/fWh35cpI9mROpBaobDH8NahhroQN8qD2PpcTBZIS4csCjNnJN9IwW?=
 =?us-ascii?Q?mBw3CNkyiE6+db9L1XIyfDLVHfgUJKX5HM1IRveIntIACeig3eXqc/rcCFNq?=
 =?us-ascii?Q?Cwvv/WkJi+HZLBasGZ5tKC7HZFwE3clr7rEvLOAm93e9HThflJmPtU32kIUV?=
 =?us-ascii?Q?QD/YHxsGf8YzJn0pj9rSoH0PFARmkq+DzRuJ0urek+CR15jZ28fLZkSsDGy7?=
 =?us-ascii?Q?in3jDZCuSajQp7FQbD+hK3sISqc8IRtA5JTa/XmKEuqL0PjqQtR/foqe7IH9?=
 =?us-ascii?Q?acumYrKrvI2pIB1ANRL3/QHVVdD/US4bQMnWAAYl1kGTBzchp31EcMtPWiNh?=
 =?us-ascii?Q?jX5+HpviX2r7LNjCHNR3U7NTPXLI8Iff7VmyeUUK/5BePJREA1+/XugvGiQd?=
 =?us-ascii?Q?CrIp8oegk3utAQCVv8mp9J26jHVutHZQaz7lO72GxgkGdXqYKolv9thM0jbw?=
 =?us-ascii?Q?mM3RBbyIPBVLelCdJo1mFrRUGghQx86VvaQxvSiOFTSNay4trXVsQRZ70n75?=
 =?us-ascii?Q?b+DWvLZw8Vo4u9MY39gLH0F4CJl6ObYH+Uetywt4hDOuUOt2ue0JbMRb8qrm?=
 =?us-ascii?Q?LPXtMjROj6AMZotzB5qsFGHR5JNUdHTY1U1urHIxj7IPA0NSHFURLrsC6RC4?=
 =?us-ascii?Q?fn1WZhjWeYpPbBXn5YmR/dRwUjEoisGLYeNAWVjiMrMD2ShyScZ34Do7ON/S?=
 =?us-ascii?Q?xcksNaaR0ik2MwYBBxQObFFBuSM1zVbqLnbhI6b0YYhcKR7gkjCBCf6pdFOM?=
 =?us-ascii?Q?rAbvejYO/S+CoPUICw5ax3LoF/CuDtxzNLhnhKaNHQmI4ton2X+Yi3Y7XoGV?=
 =?us-ascii?Q?pNKMyKvih36zJQYGhIPOgDF0x3AoeYMG5IEtN2DlXiZSFKLHz5mNm5I48mLP?=
 =?us-ascii?Q?Ob+4c1ng+ERplf700uO54sXvWjSHDZThAyVI5E7YY4QgfBR9t4L6OjLGLf4g?=
 =?us-ascii?Q?USdfKJXh3Iu24yvCZL00ZvhCyySUWvkMBp86QQhe/HSFp9hY/PbTQDnD2QwA?=
 =?us-ascii?Q?k/oK0bEQedA23YWw1CiBg6z3FR0CBo+pTCAeKeQeVPLpGd53c9cVB0YaYwxm?=
 =?us-ascii?Q?iohD9dD9NWxRYmeohu8LtMdiAOIBK5ITtf9eIG8zKP2wFMcWIP8VZKcqT/wV?=
 =?us-ascii?Q?oBC5pglUr6aaUuoBvGRqrqEzFedNHJuletrm8rFz/3fINnNGgdVbGxIvayi6?=
 =?us-ascii?Q?LA/3xGp6mUn4bYWfxA4j9yc3ErJqLAUMQdW1YUUmk9C2QgAF4bTD1+YloGDl?=
 =?us-ascii?Q?bgz77g3OlPcPxA/cE0eI5x4d374uURxUi5VmHorD7L7BDG03vQxuxdJH+1PV?=
 =?us-ascii?Q?j7zzuOLfiJ/x23pef7SUVfjx38E8j/CBKTknoZ8qdGS9Lggar5RiihweeNT9?=
 =?us-ascii?Q?lPDOSHM5wN/4gN14YuIa9QWP7NGab+zmcy/Jc0JO8hKastOdBH/BlLqXSbv+?=
 =?us-ascii?Q?Vnx2Abtz8UuE8cxw0TwIm6hP61bMARhH6okg+tznVg0jx3YA65AWi+WCdemt?=
 =?us-ascii?Q?qlQO6skGQ3dUjFnFLGCv88DVDP/oUs2bClwirGYbnlV8vB9XMd8cuAMZ6RCR?=
 =?us-ascii?Q?59Ma9H60ZZocUtHKjSmRKr+SNliDNOqcu2dZpyrMBKfhFTkJiTffBddw/KZ+?=
 =?us-ascii?Q?x663vYsxUg=3D=3D?=
X-Exchange-RoutingPolicyChecked: HlEsVL0sTG09ABEEVAxUdeLb/w9+5VCBd4sLBpyPiHu5r6IzlUc7FUreMfqJnFKIVOKnR+k3VxtLAFSXXrVA3wkEbGtgXpf5Y1oy/JCgRNsAEWlW/xv7ZxXrYvRRCeoSAzl0jaYPe689X1zr4vlBCeiPig+yE8QfmhS32ag6yZ0ZsW9XVxpL7gk8SG01SsUwHvwlAK5cNtS6yHJHhFhit1XJAAlhwVr6JeP1cOQYwAhl7aXh8R5FOmHpXLpOO0SgYmxmkuStnNUf8QhohDR1LKaS+R7w+hPVDL9WLg1jPQ75JXITkSUiaLTJPPBCq1VO3N4tcwBx5pcYZK4YBXue/A==
X-MS-Exchange-CrossTenant-Network-Message-Id: beb73170-a510-45a2-2416-08dee33ef63b
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB5832.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jul 2026 13:34:29.4567
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0ybMuf+llNB4UD2UWylzOPDlNkGUFAOqhbh/l1LZ/nCen1Y/1XNe1N73R0vJ2y/cKL4chy+NB1plz3W0vOJ7dw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH3PPF1BAF94C4A
X-OriginatorOrg: intel.com


Hello,

kernel test robot noticed "RIP:alg_test.cold" on:

commit: 89bd605959ed9145ac2906d1cc4357b71eee9d3b ("[PATCH v5 4/5] dm crypt: batch a bio segment's sectors via dun()")
url: https://github.com/intel-lab-lkp/linux/commits/Leonid-Ravich/crypto-skcipher-add-per-request-data_unit_size/20260701-185738
patch link: https://lore.kernel.org/all/20260630083431.2772-5-lravich@amazon.com/
patch subject: [PATCH v5 4/5] dm crypt: batch a bio segment's sectors via dun()

in testcase: kunit
version: 
with following parameters:

	group: group-00



config: x86_64-rhel-9.4-kunit
compiler: gcc-14
test machine: 10 threads 1 sockets Intel(R) Core Ultra Series 3 @ 3.20GHz (Panther Lake) with 16G memory

(please refer to attached dmesg/kmsg for entire log/backtrace)



If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <oliver.sang@intel.com>
| Closes: https://lore.kernel.org/oe-lkp/202607161535.5e935cc3-lkp@intel.com



kern  :warn  : [  136.442332] [   T2675] ------------[ cut here ]------------
kern  :warn  : [  136.442345] [   T2675] alg: self-tests for cbc(aes) using cbc-aes-aesni failed (rc=-110)
kern  :warn  : [  136.442348] [   T2675] WARNING: crypto/testmgr.c:6087 at alg_test.cold+0x9c/0xb1, CPU#5: cryptomgr_test/2675
kern  :warn  : [  136.442364] [   T2675] Modules linked in: dun
kern  :warn  : [  136.442373] [   T2675] CPU: 5 UID: 0 PID: 2675 Comm: cryptomgr_test Not tainted 7.1.0-rc3+ #1 PREEMPT(lazy)
kern  :warn  : [  136.442382] [   T2675] Hardware name: Intel Corporation Panther Lake Client Platform/PTL-UH LP5 T3 RVP1, BIOS PTLPFWI1.R00.3332.D01.2508190102 08/19/2025
kern  :warn  : [  136.442389] [   T2675] RIP: 0010:alg_test.cold (testmgr.c:6087 (discriminator 1))
kern  :warn  : [  136.442395] [   T2675] Code: 89 de 48 c7 c7 e0 44 93 84 e8 9b c2 fb ff 41 83 fc fe 0f 84 b1 e8 43 01 48 8d 3d 7a 80 85 05 48 8b 54 24 08 44 89 e1 48 89 de <67> 48 0f b9 3a e9 95 e8 43 01 48 8b 14 24 b8 ff ff 37 00 48 c1 e0
All code
========
   0:	89 de                	mov    %ebx,%esi
   2:	48 c7 c7 e0 44 93 84 	mov    $0xffffffff849344e0,%rdi
   9:	e8 9b c2 fb ff       	call   0xfffffffffffbc2a9
   e:	41 83 fc fe          	cmp    $0xfffffffe,%r12d
  12:	0f 84 b1 e8 43 01    	je     0x143e8c9
  18:	48 8d 3d 7a 80 85 05 	lea    0x585807a(%rip),%rdi        # 0x5858099
  1f:	48 8b 54 24 08       	mov    0x8(%rsp),%rdx
  24:	44 89 e1             	mov    %r12d,%ecx
  27:	48 89 de             	mov    %rbx,%rsi
  2a:*	67 48 0f b9 3a       	ud1    (%edx),%rdi		<-- trapping instruction
  2f:	e9 95 e8 43 01       	jmp    0x143e8c9
  34:	48 8b 14 24          	mov    (%rsp),%rdx
  38:	b8 ff ff 37 00       	mov    $0x37ffff,%eax
  3d:	48                   	rex.W
  3e:	c1                   	.byte 0xc1
  3f:	e0                   	.byte 0xe0

Code starting with the faulting instruction
===========================================
   0:	67 48 0f b9 3a       	ud1    (%edx),%rdi
   5:	e9 95 e8 43 01       	jmp    0x143e89f
   a:	48 8b 14 24          	mov    (%rsp),%rdx
   e:	b8 ff ff 37 00       	mov    $0x37ffff,%eax
  13:	48                   	rex.W
  14:	c1                   	.byte 0xc1
  15:	e0                   	.byte 0xe0
kern  :warn  : [  136.442404] [   T2675] RSP: 0018:ffffc9000219fce0 EFLAGS: 00010293
kern  :warn  : [  136.442411] [   T2675] RAX: 0000000000000041 RBX: ffff888474e11480 RCX: 00000000ffffff92
kern  :warn  : [  136.442416] [   T2675] RDX: ffff888474e11400 RSI: ffff888474e11480 RDI: ffffffff86abc5a0
kern  :warn  : [  136.442421] [   T2675] RBP: 1ffff92000433fa5 R08: 0000000000000000 R09: fffffbfff0b2b848
kern  :warn  : [  136.442426] [   T2675] R10: 0000000000000003 R11: fefefefefefefeff R12: 00000000ffffff92
kern  :warn  : [  136.442431] [   T2675] R13: dffffc0000000000 R14: 0000000000000069 R15: 0000000000000027
kern  :warn  : [  136.442436] [   T2675] FS:  0000000000000000(0000) GS:ffff88848572b000(0000) knlGS:0000000000000000
kern  :warn  : [  136.442442] [   T2675] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
kern  :warn  : [  136.442446] [   T2675] CR2: 00007fc9e48120ac CR3: 000000047c074001 CR4: 0000000108770ef0
kern  :warn  : [  136.442451] [   T2675] PKRU: 55555554
kern  :warn  : [  136.442455] [   T2675] Call Trace:
kern  :warn  : [  136.442458] [   T2675]  <TASK>
kern  :warn  : [  136.442464] [   T2675]  ? __pfx_alg_test (linux/crypto.h:449)
kern  :warn  : [  136.442470] [   T2675]  ? kasan_save_track (kasan/common.c:78)
kern  :warn  : [  136.442477] [   T2675]  ? _raw_spin_lock_irqsave (linux/instrumented.h:55 linux/atomic/atomic-instrumented.h:1301 asm-generic/qspinlock.h:111 linux/spinlock.h:187 linux/spinlock_api_smp.h:133 locking/spinlock.c:166)
kern  :warn  : [  136.442483] [   T2675]  ? __pfx__raw_spin_lock_irqsave (locking/spinlock.c:273)
kern  :warn  : [  136.442489] [   T2675]  ? __pfx_cryptomgr_test (usercopy_64.c:?)
kern  :warn  : [  136.442496] [   T2675]  ? kthread_affine_node (kthread.c:377)
kern  :warn  : [  136.442501] [   T2675]  ? __kthread_parkme (linux/instrumented.h:82 asm-generic/bitops/instrumented-non-atomic.h:141 kthread.c:272)
kern  :warn  : [  136.442508] [   T2675]  ? __pfx_cryptomgr_test (usercopy_64.c:?)
kern  :warn  : [  136.442513] [   T2675]  cryptomgr_test (algboss.c:179)
kern  :warn  : [  136.442519] [   T2675]  kthread (kthread.c:436)
kern  :warn  : [  136.442523] [   T2675]  ? recalc_sigpending (linux/instrumented.h:97 asm-generic/bitops/instrumented-atomic.h:41 linux/thread_info.h:109 signal.c:181)
kern  :warn  : [  136.442530] [   T2675]  ? __pfx_kthread (linux/list.h:381 (discriminator 2))
kern  :warn  : [  136.442534] [   T2675]  ret_from_fork (x86/kernel/process.c:158)
kern  :warn  : [  136.442541] [   T2675]  ? __pfx_ret_from_fork (x86/include/asm/entry-common.h:54)
kern  :warn  : [  136.442547] [   T2675]  ? switch_fpu (linux/instrumented.h:82 asm-generic/bitops/instrumented-non-atomic.h:141 linux/thread_info.h:133 linux/sched.h:2069 x86/include/asm/fpu/sched.h:34)
kern  :warn  : [  136.442553] [   T2675]  ? __switch_to (x86/kernel/process_64.c:403 x86/kernel/process_64.c:663)
kern  :warn  : [  136.442558] [   T2675]  ? __pfx_kthread (linux/list.h:381 (discriminator 2))
kern  :warn  : [  136.442563] [   T2675]  ret_from_fork_asm (x86/entry/entry_64.S:245)
kern  :warn  : [  136.442570] [   T2675]  </TASK>
kern  :warn  : [  136.442573] [   T2675] ---[ end trace 0000000000000000 ]---
kern  :err   : [  136.442580] [   T2675] alg: Unexpected test result for cbc-aes-aesni: -110


The kernel config and materials to reproduce are available at:
https://download.01.org/0day-ci/archive/20260716/202607161535.5e935cc3-lkp@intel.com



-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

