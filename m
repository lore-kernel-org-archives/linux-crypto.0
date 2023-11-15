Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3A9C39B
	for <linux-crypto@vger.kernel.org>; Wed, 15 Nov 2023 02:05:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="YpzWXC5N"
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.100])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E58DCED
	for <linux-crypto@vger.kernel.org>; Tue, 14 Nov 2023 18:05:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1700013910; x=1731549910;
  h=date:from:to:cc:subject:message-id:in-reply-to:
   mime-version;
  bh=ge7QSOq2DyburCLd3v9W+MKSpsvY8nwJtUOru7a1qzs=;
  b=YpzWXC5NfzwRjtQrwAkmkTXXAvcCjX2gIjO6HLj9dYPTD3TgUFtSjQI6
   veMSD/NXNCOnVVvr3yQBcDFA3/iME7I4nbOA7+w6sGoDW55bOnEXGCTdN
   TS+gmSWP1Xe23U7eTQoxrommI8ytjDP3QU0OBD6XEZrRG4yItjxw25rLB
   fBs06iFb2YjiLxxmYIoW4EY7lFpEUixl4qckmTRWYT2ZMXE4Z0ry9rEP+
   derzVnnxiKroKdUOrPHJsa1tNSSnT8xQRvPe+Z10xe6c0YhU8XG6/j6x8
   biLLqem9CUudmdQSDiFh5CnvNupi6REY9c4dMlVoH0N//XR54o9do5t6n
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10894"; a="457292274"
X-IronPort-AV: E=Sophos;i="6.03,303,1694761200"; 
   d="scan'208";a="457292274"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Nov 2023 18:05:08 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.03,303,1694761200"; 
   d="scan'208";a="6260366"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by fmviesa002.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 14 Nov 2023 18:05:04 -0800
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.34; Tue, 14 Nov 2023 18:05:03 -0800
Received: from orsmsx602.amr.corp.intel.com (10.22.229.15) by
 ORSMSX612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.34; Tue, 14 Nov 2023 18:05:02 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.34 via Frontend Transport; Tue, 14 Nov 2023 18:05:02 -0800
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.168)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.34; Tue, 14 Nov 2023 18:05:01 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SSJGLcTIPslcJ3HZCO3YqVzhL1LbehL5LDVn1/K+Ea5sBszgxNHY0O6+j/UeTSikgOm9r6Iohe3gq72tGboY6o7+b1My3dUEqT8HAnRASL8vXjsaSzyJnDwyi+R7m7ZUxVY5Ju4gkfjb+eVGfld4Fl5bbn1GUHDnCwI0kxbZ2CXe0jh5xT+YeNyEmNvpwbcMf3wzD5fNH8TK8PN8uW/SGk8kYTwEo5wVYrUApqOloX21kRwdPQnSyMhVanDsFkmRpw+jXlqQ239jdbVBZt3gMTzCh78sDBiNfzAJmSh6leI7RGgyFYjM2wOqjxEv+2LT82xSx0Oy8jD0oNFOL0hMdA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=oNMetVUGVLjzwHt2FWr7jtgu43T0oaA5wFWJiBA1BPw=;
 b=m/Ggl3uQIcrgydCNr+kbyDE5RhgorVCd10rykc0oUERiqcsY9ipk8IjgI+ZQQGP+c4DzlqePABEncxew85J3Lh71j7o2dk9SukyPErRonJsSLZ+I7AAF4OWtGExNcDDuDxISpOjoJrwPA3fV9UlX0ruevnXHZKK47WGGdvr/uiddWiv2pGSc0PFGC4IPd+9Zam7u4TdG/vuY/pst4WdGIx6rs/zCO0VKV8k8IvBRv7beeLOOUpjFl2qGRceoSqC4Efx69911dF5AXOo5DGKsejtmJMNZL636S7LRKX48E3AngwXBSqMdYD7k1x8I5gtnV5UE5AKiCQcE6MmV1wGb6w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CY5PR11MB6392.namprd11.prod.outlook.com (2603:10b6:930:37::15)
 by LV2PR11MB6045.namprd11.prod.outlook.com (2603:10b6:408:17b::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6977.31; Wed, 15 Nov
 2023 02:04:58 +0000
Received: from CY5PR11MB6392.namprd11.prod.outlook.com
 ([fe80::15d3:7425:a09e:1c86]) by CY5PR11MB6392.namprd11.prod.outlook.com
 ([fe80::15d3:7425:a09e:1c86%4]) with mapi id 15.20.6933.028; Wed, 15 Nov 2023
 02:04:58 +0000
Date: Wed, 15 Nov 2023 10:00:17 +0800
From: kernel test robot <yujie.liu@intel.com>
To: Pavitrakumar M <pavitrakumarm@vayavyalabs.com>,
	<herbert@gondor.apana.org.au>, <linux-crypto@vger.kernel.org>
CC: <oe-kbuild-all@lists.linux.dev>, <manjunath.hadli@vayavyalabs.com>,
	Pavitrakumar M <pavitrakumarm@vayavyalabs.com>, shwetar
	<shwetar@vayavyalabs.com>, Ruud Derwig <Ruud.Derwig@synopsys.com>
Subject: Re: [PATCH 4/4] Enable Driver compilation in crypto Kconfig and
 Makefile file
Message-ID: <202311142123.lwAnyUEZ-lkp@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20231114050525.471854-5-pavitrakumarm@vayavyalabs.com>
X-ClientProxiedBy: SI1PR02CA0019.apcprd02.prod.outlook.com
 (2603:1096:4:1f4::15) To CY5PR11MB6392.namprd11.prod.outlook.com
 (2603:10b6:930:37::15)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY5PR11MB6392:EE_|LV2PR11MB6045:EE_
X-MS-Office365-Filtering-Correlation-Id: 79f43055-0014-4275-35b9-08dbe57f4508
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: TC53a8e0Ky4fTr+nUjWdqWqSmLb+25sw+HEPW5CdsZjpOgxOQ+jWf4Y/W+P/6RFPp3C1vp/YLbiu0AYoKh1+A93wgDiwcrJddeDjj7AkP/I1Qe2W8CK4yxVde+WAkDRXfHuE61vtLmUC7JGX9zD6EPhm1c9M6wtuDezKtGmNrmwXzseRMH4+7UI1sEsBepp5oJ8CTCR+AqjAnDTXtbJ/ON2ROG+Ep2CTSmV1boP+7kn1qPX5AfzmxwpbCRa7O2uJENAV4BFJN7lGp3GHN08q6abHCrMPvMgOsrciAsomBWNbXihQlhn3CXlJ6eAXZV1OwKSqWisgjYlQ6wgjgpyQIlwEyD85aNpvnyXwRHinl7K3r5ZbHk0Co2B0PaD7ZogjBAaxqg6wqBJqDyRfLAyPYFl10bdKvWe3qFQjcbK1e8gDVNJnm7b/5kdNA7fbbCbeMBWZ8wru+tmLED9RPKZpgiVD6dWSoSwiCopZE20YBhNjP8+RLoJ8Bpk3GY/wNxYrd9eB/70ExmTBEXCmSC2xrBoKoRdOW+LRFlt8p+uxbvUoH+x1b3PUnJR16fuTNBT+SAby6Q1rtD1lRxE9sfaX+GSN46uEwj9I5xOK8Dcu+2Nq/JzNpND7PhzJegHmCBIbh8EqPoPSzfG5mL1C3w32Fg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR11MB6392.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(346002)(136003)(39860400002)(376002)(396003)(366004)(230273577357003)(230922051799003)(230173577357003)(64100799003)(451199024)(1800799009)(186009)(86362001)(66899024)(83380400001)(38100700002)(66476007)(82960400001)(66946007)(316002)(66556008)(54906003)(8936002)(36756003)(6666004)(6512007)(2616005)(1076003)(26005)(478600001)(6486002)(966005)(41300700001)(4001150100001)(30864003)(2906002)(6506007)(4326008)(8676002)(5660300002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?/heg2xgzeqdET77U9KmuOdDjdYuziKdDNlEUcWerb+ogYHrTgpey9xr7gk9U?=
 =?us-ascii?Q?LYhVk5f7uebZ6cTKrzNM5ASSsxs0Yh8b5AEmg8q+bs6s7eFRruwc694qWrIA?=
 =?us-ascii?Q?ZABBu00Ezq8kQ1Fbm6QJlRyLZntwQkbcAihKA4pQR/KEbOdywRq+11kRJlOP?=
 =?us-ascii?Q?K1dQd2OZLwlW9Sm5UWzRiFt9ezfHnWT8KnzFxNStIbI0H+Ui9ic6lg8mZm1U?=
 =?us-ascii?Q?DP/soBkZaL3sAzImyCvSB/dKO4Ee2GFfE667hYxC2WwnUhjxwJlcm0UnWY3w?=
 =?us-ascii?Q?1KBZDUzECoyX+laY+y5chrdZGqRBQ88JACzwkSJ5jiXdRnshQRbg4yafY2f/?=
 =?us-ascii?Q?WRUQ0OaoYGMfARiyF/FR2cwRb4H8lXkZptJKwYkVo6KRLCNBmFE19+SKqXSX?=
 =?us-ascii?Q?L7v+oCm3nu0cDOL3yQ1NoOymUICoi4j0NmTheSO+10sQICJjH1EG3Z+uSKyC?=
 =?us-ascii?Q?Tzi/sRM6Hm9zFDZmqPqtSRUKckGW4eohkSotjK03qKqOYgzkl6qiZtwfgtja?=
 =?us-ascii?Q?L3lqoVCGY994nRcsuKoXTXw8i9fXSfG+lFbia6d7zLZSNANRBtCqc0lJBlQT?=
 =?us-ascii?Q?r8FyleAEPVLpfrwcxEzXq4HZW4/GdERD8j0m0rr8PF6ZwHxEi+3QWv4c10Ae?=
 =?us-ascii?Q?Pnc3TZXwgr5cgK698dV/dwf9+ruagaQKpU9jME6ufA8TgVayCPzA0ICKw4ZU?=
 =?us-ascii?Q?SUBWw5ezVufDwXfenRICy08cmxeeCpk+UJp2+PWtNqQNWwSDqoJfJBlQNwxw?=
 =?us-ascii?Q?o5rwTpPnl4WJHzUb2dO9VI9aMDFP8u+xRa5+613gh6FkUgIyySrawI17GMWX?=
 =?us-ascii?Q?AWoLqPAOGAG6nLQG3temT7s7ksuCKrv1W91zqieE/kWKNqgHqBdIofvxgqlM?=
 =?us-ascii?Q?fg/T4oLPY8sZsc9mexfycuB6ubq3ZdOhdiWDVJla38mJS/90KWf1lDDy2CFO?=
 =?us-ascii?Q?bZ0Q6W9KOXgaRJW6RXqxfH8ks33R0jWRy9LP30svUAvcU4Vxfc95Ii9u4AvA?=
 =?us-ascii?Q?Svpi//7lByvaE6NRUjm1cHxXhQWKvux2leKutqM6KZvALi5K4lCcdkOGKs4c?=
 =?us-ascii?Q?gmEfhYNVE9OHwqovKPWHV5dPQmax9Fgv7jJWqi9s2AUlySOtVeXFZat76QOW?=
 =?us-ascii?Q?/7YcTu7MXkq4Zy26Dbdg3FFZ7ikHbQyJr5Q2Ws5LC94a9pDMAsyKWgREh4Qr?=
 =?us-ascii?Q?I3V4uwKlKr+ebhJsa9ntYn9ieIpDoKquRqPG6+YDRpQrVlaRk1b01gaVGnn5?=
 =?us-ascii?Q?aPrBhpStpV4HWOUKephS1Q8fmi24oZolet4BY/gIR117S/mHoYKvuRyU611M?=
 =?us-ascii?Q?ZW5F0le/m4mXzWBARw89DwChDtN87FbUd7wU5NgWwlAN3f34Fwpsn//4jpCM?=
 =?us-ascii?Q?4jYM9MzfhYkwQ4prAYpurJMQZxaP5tTUd/+JEcMkqpSRgn5D4RZdaSgd8bBO?=
 =?us-ascii?Q?bllmM9vVfifJ6VGx0hC3KYpDsDDsSqg+h8lM4/vK5u1A5QfJdIS+k5B5zrnu?=
 =?us-ascii?Q?n8870v4Z+99/3sLLwn81kNwR/t8pp7IO90E7ZRZNj132tbdPFadkyO+T/AlO?=
 =?us-ascii?Q?wCaqdDxGn/ZX5rnYVJyruC2+CbBCiXWEUZ2W6ygy?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 79f43055-0014-4275-35b9-08dbe57f4508
X-MS-Exchange-CrossTenant-AuthSource: CY5PR11MB6392.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Nov 2023 02:04:58.7922
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qPfmWvjHfjwil0bsyzUAZMXDzg9oKbOyh1dfA0KZSAlU4gQ6X+Du1EuSHjMMww+qxsqTzUzZEJbqx1gSIw92nA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV2PR11MB6045
X-OriginatorOrg: intel.com

Hi Pavitrakumar,

kernel test robot noticed the following build warnings:

[auto build test WARNING on herbert-cryptodev-2.6/master]
[also build test WARNING on herbert-crypto-2.6/master linus/master v6.7-rc1]
[cannot apply to xilinx-xlnx/master next-20231114]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Pavitrakumar-M/Add-SPACC-driver-to-Linux-kernel/20231114-143618
base:   https://git.kernel.org/pub/scm/linux/kernel/git/herbert/cryptodev-2.6.git master
patch link:    https://lore.kernel.org/r/20231114050525.471854-5-pavitrakumarm%40vayavyalabs.com
patch subject: [PATCH 4/4] Enable Driver compilation in crypto Kconfig and Makefile file
config: mips-allyesconfig (https://download.01.org/0day-ci/archive/20231114/202311142123.lwAnyUEZ-lkp@intel.com/config)
compiler: mips-linux-gcc (GCC) 13.2.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20231114/202311142123.lwAnyUEZ-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <yujie.liu@intel.com>
| Closes: https://lore.kernel.org/r/202311142123.lwAnyUEZ-lkp@intel.com/

All warnings (new ones prefixed by >>):

   drivers/crypto/dwc-spacc/spacc_core.c:1113:5: warning: no previous prototype for 'spacc_sgs_to_ddt' [-Wmissing-prototypes]
    1113 | int spacc_sgs_to_ddt(struct device *dev,
         |     ^~~~~~~~~~~~~~~~
   drivers/crypto/dwc-spacc/spacc_core.c:1179:5: warning: no previous prototype for 'modify_scatterlist' [-Wmissing-prototypes]
    1179 | int modify_scatterlist(struct scatterlist *src, struct scatterlist *dst,
         |     ^~~~~~~~~~~~~~~~~~
   drivers/crypto/dwc-spacc/spacc_core.c:1215:5: warning: no previous prototype for 'spacc_sg_to_ddt' [-Wmissing-prototypes]
    1215 | int spacc_sg_to_ddt(struct device *dev, struct scatterlist *sg,
         |     ^~~~~~~~~~~~~~~
   drivers/crypto/dwc-spacc/spacc_core.c: In function 'spacc_fini':
   drivers/crypto/dwc-spacc/spacc_core.c:2565:9: error: implicit declaration of function 'vfree'; did you mean 'kvfree'? [-Werror=implicit-function-declaration]
    2565 |         vfree(spacc->ctx);
         |         ^~~~~
         |         kvfree
   drivers/crypto/dwc-spacc/spacc_core.c: In function 'spacc_init':
   drivers/crypto/dwc-spacc/spacc_core.c:2744:22: error: implicit declaration of function 'vmalloc'; did you mean 'kvmalloc'? [-Werror=implicit-function-declaration]
    2744 |         spacc->ctx = vmalloc(sizeof(struct spacc_ctx) *
         |                      ^~~~~~~
         |                      kvmalloc
>> drivers/crypto/dwc-spacc/spacc_core.c:2744:20: warning: assignment to 'struct spacc_ctx *' from 'int' makes pointer from integer without a cast [-Wint-conversion]
    2744 |         spacc->ctx = vmalloc(sizeof(struct spacc_ctx) *
         |                    ^
>> drivers/crypto/dwc-spacc/spacc_core.c:2750:20: warning: assignment to 'struct spacc_job *' from 'int' makes pointer from integer without a cast [-Wint-conversion]
    2750 |         spacc->job = vmalloc(sizeof(struct spacc_job) * SPACC_MAX_JOBS);
         |                    ^
   drivers/crypto/dwc-spacc/spacc_core.c: At top level:
   drivers/crypto/dwc-spacc/spacc_core.c:2991:12: warning: 'spacc_load_skp' defined but not used [-Wunused-function]
    2991 | static int spacc_load_skp(struct spacc_device *spacc, uint32_t *key, int keysz,
         |            ^~~~~~~~~~~~~~
   drivers/crypto/dwc-spacc/spacc_core.c:2849:13: warning: 'spacc_set_secure_mode' defined but not used [-Wunused-function]
    2849 | static void spacc_set_secure_mode(struct spacc_device *spacc, int src, int dst,
         |             ^~~~~~~~~~~~~~~~~~~~~
   drivers/crypto/dwc-spacc/spacc_core.c:974:26: warning: 'names' defined but not used [-Wunused-const-variable=]
     974 | static const char *const names[] = {
         |                          ^~~~~
   In file included from <command-line>:
   In function 'spacc_sg_chain',
       inlined from 'fixup_sg' at drivers/crypto/dwc-spacc/spacc_core.c:1105:4,
       inlined from 'spacc_sgs_to_ddt' at drivers/crypto/dwc-spacc/spacc_core.c:1132:16:
   include/linux/compiler_types.h:425:45: error: call to '__compiletime_assert_354' declared with attribute error: BUILD_BUG_ON failed: IS_ENABLED(CONFIG_DEBUG_SG)
     425 |         _compiletime_assert(condition, msg, __compiletime_assert_, __COUNTER__)
         |                                             ^
   include/linux/compiler_types.h:406:25: note: in definition of macro '__compiletime_assert'
     406 |                         prefix ## suffix();                             \
         |                         ^~~~~~
   include/linux/compiler_types.h:425:9: note: in expansion of macro '_compiletime_assert'
     425 |         _compiletime_assert(condition, msg, __compiletime_assert_, __COUNTER__)
         |         ^~~~~~~~~~~~~~~~~~~
   include/linux/build_bug.h:39:37: note: in expansion of macro 'compiletime_assert'
      39 | #define BUILD_BUG_ON_MSG(cond, msg) compiletime_assert(!(cond), msg)
         |                                     ^~~~~~~~~~~~~~~~~~
   include/linux/build_bug.h:50:9: note: in expansion of macro 'BUILD_BUG_ON_MSG'
      50 |         BUILD_BUG_ON_MSG(condition, "BUILD_BUG_ON failed: " #condition)
         |         ^~~~~~~~~~~~~~~~
   drivers/crypto/dwc-spacc/spacc_core.c:1072:9: note: in expansion of macro 'BUILD_BUG_ON'
    1072 |         BUILD_BUG_ON(IS_ENABLED(CONFIG_DEBUG_SG));
         |         ^~~~~~~~~~~~
   In function 'spacc_sg_chain',
       inlined from 'fixup_sg' at drivers/crypto/dwc-spacc/spacc_core.c:1105:4,
       inlined from 'spacc_sg_to_ddt' at drivers/crypto/dwc-spacc/spacc_core.c:1222:15:
   include/linux/compiler_types.h:425:45: error: call to '__compiletime_assert_354' declared with attribute error: BUILD_BUG_ON failed: IS_ENABLED(CONFIG_DEBUG_SG)
     425 |         _compiletime_assert(condition, msg, __compiletime_assert_, __COUNTER__)
         |                                             ^
   include/linux/compiler_types.h:406:25: note: in definition of macro '__compiletime_assert'
     406 |                         prefix ## suffix();                             \
         |                         ^~~~~~
   include/linux/compiler_types.h:425:9: note: in expansion of macro '_compiletime_assert'
     425 |         _compiletime_assert(condition, msg, __compiletime_assert_, __COUNTER__)
         |         ^~~~~~~~~~~~~~~~~~~
   include/linux/build_bug.h:39:37: note: in expansion of macro 'compiletime_assert'
      39 | #define BUILD_BUG_ON_MSG(cond, msg) compiletime_assert(!(cond), msg)
         |                                     ^~~~~~~~~~~~~~~~~~
   include/linux/build_bug.h:50:9: note: in expansion of macro 'BUILD_BUG_ON_MSG'
      50 |         BUILD_BUG_ON_MSG(condition, "BUILD_BUG_ON failed: " #condition)
         |         ^~~~~~~~~~~~~~~~
   drivers/crypto/dwc-spacc/spacc_core.c:1072:9: note: in expansion of macro 'BUILD_BUG_ON'
    1072 |         BUILD_BUG_ON(IS_ENABLED(CONFIG_DEBUG_SG));
         |         ^~~~~~~~~~~~
   cc1: some warnings being treated as errors


vim +2744 drivers/crypto/dwc-spacc/spacc_core.c

188d801c0d4bbe Pavitrakumar M 2023-11-14  2568  
188d801c0d4bbe Pavitrakumar M 2023-11-14  2569  int spacc_init(void *baseaddr, struct spacc_device *spacc,
188d801c0d4bbe Pavitrakumar M 2023-11-14  2570  	       struct pdu_info *info)
188d801c0d4bbe Pavitrakumar M 2023-11-14  2571  {
188d801c0d4bbe Pavitrakumar M 2023-11-14  2572  	unsigned long id;
188d801c0d4bbe Pavitrakumar M 2023-11-14  2573  	char version_string[3][16] = { "SPACC", "SPACC-PDU" };
188d801c0d4bbe Pavitrakumar M 2023-11-14  2574  	char idx_string[2][16] = { "(Normal Port)", "(Secure Port)" };
188d801c0d4bbe Pavitrakumar M 2023-11-14  2575  	char dma_type_string[4][16] = {"Unknown", "Scattergather", "Linear",
188d801c0d4bbe Pavitrakumar M 2023-11-14  2576  		"Unknown"};
188d801c0d4bbe Pavitrakumar M 2023-11-14  2577  
188d801c0d4bbe Pavitrakumar M 2023-11-14  2578  	if (!baseaddr) {
188d801c0d4bbe Pavitrakumar M 2023-11-14  2579  		pr_err("ERR: baseaddr is NULL\n");
188d801c0d4bbe Pavitrakumar M 2023-11-14  2580  		return -1;
188d801c0d4bbe Pavitrakumar M 2023-11-14  2581  	}
188d801c0d4bbe Pavitrakumar M 2023-11-14  2582  	if (!spacc) {
188d801c0d4bbe Pavitrakumar M 2023-11-14  2583  		pr_err("ERR: spacc is NULL\n");
188d801c0d4bbe Pavitrakumar M 2023-11-14  2584  		return -1;
188d801c0d4bbe Pavitrakumar M 2023-11-14  2585  	}
188d801c0d4bbe Pavitrakumar M 2023-11-14  2586  
188d801c0d4bbe Pavitrakumar M 2023-11-14  2587  	memset(spacc, 0, sizeof(*spacc));
188d801c0d4bbe Pavitrakumar M 2023-11-14  2588  	spin_lock_init(&spacc->lock);
188d801c0d4bbe Pavitrakumar M 2023-11-14  2589  	spin_lock_init(&spacc->ctx_lock);
188d801c0d4bbe Pavitrakumar M 2023-11-14  2590  
188d801c0d4bbe Pavitrakumar M 2023-11-14  2591  	/* assign the baseaddr*/
188d801c0d4bbe Pavitrakumar M 2023-11-14  2592  	spacc->regmap = baseaddr;
188d801c0d4bbe Pavitrakumar M 2023-11-14  2593  
188d801c0d4bbe Pavitrakumar M 2023-11-14  2594  	/* version info*/
188d801c0d4bbe Pavitrakumar M 2023-11-14  2595  	spacc->config.version     = info->spacc_version.version;
188d801c0d4bbe Pavitrakumar M 2023-11-14  2596  	spacc->config.pdu_version = (info->pdu_config.major << 4) |
188d801c0d4bbe Pavitrakumar M 2023-11-14  2597  		info->pdu_config.minor;
188d801c0d4bbe Pavitrakumar M 2023-11-14  2598  	spacc->config.project     = info->spacc_version.project;
188d801c0d4bbe Pavitrakumar M 2023-11-14  2599  	spacc->config.is_pdu      = info->spacc_version.is_pdu;
188d801c0d4bbe Pavitrakumar M 2023-11-14  2600  	spacc->config.is_qos      = info->spacc_version.qos;
188d801c0d4bbe Pavitrakumar M 2023-11-14  2601  
188d801c0d4bbe Pavitrakumar M 2023-11-14  2602  	/* misc*/
188d801c0d4bbe Pavitrakumar M 2023-11-14  2603  	spacc->config.is_partial        = info->spacc_version.partial;
188d801c0d4bbe Pavitrakumar M 2023-11-14  2604  	spacc->config.num_ctx           = info->spacc_config.num_ctx;
188d801c0d4bbe Pavitrakumar M 2023-11-14  2605  	spacc->config.ciph_page_size    = 1U <<
188d801c0d4bbe Pavitrakumar M 2023-11-14  2606  		info->spacc_config.ciph_ctx_page_size;
188d801c0d4bbe Pavitrakumar M 2023-11-14  2607  	spacc->config.hash_page_size    = 1U <<
188d801c0d4bbe Pavitrakumar M 2023-11-14  2608  		info->spacc_config.hash_ctx_page_size;
188d801c0d4bbe Pavitrakumar M 2023-11-14  2609  	spacc->config.dma_type          = info->spacc_config.dma_type;
188d801c0d4bbe Pavitrakumar M 2023-11-14  2610  	spacc->config.idx               = info->spacc_version.vspacc_idx;
188d801c0d4bbe Pavitrakumar M 2023-11-14  2611  	spacc->config.cmd0_fifo_depth   = info->spacc_config.cmd0_fifo_depth;
188d801c0d4bbe Pavitrakumar M 2023-11-14  2612  	spacc->config.cmd1_fifo_depth   = info->spacc_config.cmd1_fifo_depth;
188d801c0d4bbe Pavitrakumar M 2023-11-14  2613  	spacc->config.cmd2_fifo_depth   = info->spacc_config.cmd2_fifo_depth;
188d801c0d4bbe Pavitrakumar M 2023-11-14  2614  	spacc->config.stat_fifo_depth   = info->spacc_config.stat_fifo_depth;
188d801c0d4bbe Pavitrakumar M 2023-11-14  2615  	spacc->config.fifo_cnt          = 1;
188d801c0d4bbe Pavitrakumar M 2023-11-14  2616  
188d801c0d4bbe Pavitrakumar M 2023-11-14  2617  	spacc->config.is_ivimport = info->spacc_version.ivimport;
188d801c0d4bbe Pavitrakumar M 2023-11-14  2618  
188d801c0d4bbe Pavitrakumar M 2023-11-14  2619  	/* ctrl register map*/
188d801c0d4bbe Pavitrakumar M 2023-11-14  2620  	if (spacc->config.version <= 0x4E)
188d801c0d4bbe Pavitrakumar M 2023-11-14  2621  		spacc->config.ctrl_map = spacc_ctrl_map[SPACC_CTRL_VER_0];
188d801c0d4bbe Pavitrakumar M 2023-11-14  2622  	else if (spacc->config.version <= 0x60)
188d801c0d4bbe Pavitrakumar M 2023-11-14  2623  		spacc->config.ctrl_map = spacc_ctrl_map[SPACC_CTRL_VER_1];
188d801c0d4bbe Pavitrakumar M 2023-11-14  2624  	else
188d801c0d4bbe Pavitrakumar M 2023-11-14  2625  		spacc->config.ctrl_map = spacc_ctrl_map[SPACC_CTRL_VER_2];
188d801c0d4bbe Pavitrakumar M 2023-11-14  2626  
188d801c0d4bbe Pavitrakumar M 2023-11-14  2627  	spacc->job_next_swid            = 0;
188d801c0d4bbe Pavitrakumar M 2023-11-14  2628  	spacc->wdcnt                    = 0;
188d801c0d4bbe Pavitrakumar M 2023-11-14  2629  	spacc->config.wd_timer          = SPACC_WD_TIMER_INIT;
188d801c0d4bbe Pavitrakumar M 2023-11-14  2630  
188d801c0d4bbe Pavitrakumar M 2023-11-14  2631  	/* version 4.10 uses IRQ,
188d801c0d4bbe Pavitrakumar M 2023-11-14  2632  	 * above uses WD and we don't support below 4.00
188d801c0d4bbe Pavitrakumar M 2023-11-14  2633  	 */
188d801c0d4bbe Pavitrakumar M 2023-11-14  2634  	if (spacc->config.version < 0x40) {
188d801c0d4bbe Pavitrakumar M 2023-11-14  2635  		pr_err("ERR: Unsupported SPAcc version\n");
188d801c0d4bbe Pavitrakumar M 2023-11-14  2636  		return -EIO;
188d801c0d4bbe Pavitrakumar M 2023-11-14  2637  	} else if (spacc->config.version < 0x4B) {
188d801c0d4bbe Pavitrakumar M 2023-11-14  2638  		spacc->op_mode                  = SPACC_OP_MODE_IRQ;
188d801c0d4bbe Pavitrakumar M 2023-11-14  2639  	} else {
188d801c0d4bbe Pavitrakumar M 2023-11-14  2640  		spacc->op_mode                  = SPACC_OP_MODE_WD;
188d801c0d4bbe Pavitrakumar M 2023-11-14  2641  	}
188d801c0d4bbe Pavitrakumar M 2023-11-14  2642  
188d801c0d4bbe Pavitrakumar M 2023-11-14  2643  	/* set threshold and enable irq
188d801c0d4bbe Pavitrakumar M 2023-11-14  2644  	 * on 4.11 and newer cores we can derive this
188d801c0d4bbe Pavitrakumar M 2023-11-14  2645  	 * from the HW reported depths.
188d801c0d4bbe Pavitrakumar M 2023-11-14  2646  	 */
188d801c0d4bbe Pavitrakumar M 2023-11-14  2647  	if (spacc->config.stat_fifo_depth == 1)
188d801c0d4bbe Pavitrakumar M 2023-11-14  2648  		spacc->config.ideal_stat_level = 1;
188d801c0d4bbe Pavitrakumar M 2023-11-14  2649  	else if (spacc->config.stat_fifo_depth <= 4)
188d801c0d4bbe Pavitrakumar M 2023-11-14  2650  		spacc->config.ideal_stat_level = spacc->config.stat_fifo_depth
188d801c0d4bbe Pavitrakumar M 2023-11-14  2651  			- 1;
188d801c0d4bbe Pavitrakumar M 2023-11-14  2652  	else if (spacc->config.stat_fifo_depth <= 8)
188d801c0d4bbe Pavitrakumar M 2023-11-14  2653  		spacc->config.ideal_stat_level = spacc->config.stat_fifo_depth
188d801c0d4bbe Pavitrakumar M 2023-11-14  2654  			- 2;
188d801c0d4bbe Pavitrakumar M 2023-11-14  2655  	else
188d801c0d4bbe Pavitrakumar M 2023-11-14  2656  		spacc->config.ideal_stat_level = spacc->config.stat_fifo_depth
188d801c0d4bbe Pavitrakumar M 2023-11-14  2657  			- 4;
188d801c0d4bbe Pavitrakumar M 2023-11-14  2658  
188d801c0d4bbe Pavitrakumar M 2023-11-14  2659  	/* determine max PROClen value */
188d801c0d4bbe Pavitrakumar M 2023-11-14  2660  	writel(0xFFFFFFFF, spacc->regmap + SPACC_REG_PROC_LEN);
188d801c0d4bbe Pavitrakumar M 2023-11-14  2661  	spacc->config.max_msg_size = readl(spacc->regmap + SPACC_REG_PROC_LEN);
188d801c0d4bbe Pavitrakumar M 2023-11-14  2662  
188d801c0d4bbe Pavitrakumar M 2023-11-14  2663  	/* read config info*/
188d801c0d4bbe Pavitrakumar M 2023-11-14  2664  	if (spacc->config.is_pdu) {
188d801c0d4bbe Pavitrakumar M 2023-11-14  2665  		pr_debug("PDU:\n");
188d801c0d4bbe Pavitrakumar M 2023-11-14  2666  		pr_debug("   MAJOR      : %u\n", info->pdu_config.major);
188d801c0d4bbe Pavitrakumar M 2023-11-14  2667  		pr_debug("   MINOR      : %u\n", info->pdu_config.minor);
188d801c0d4bbe Pavitrakumar M 2023-11-14  2668  	}
188d801c0d4bbe Pavitrakumar M 2023-11-14  2669  	id = readl(spacc->regmap + SPACC_REG_ID);
188d801c0d4bbe Pavitrakumar M 2023-11-14  2670  	pr_debug("SPACC ID: (%08lx)\n", (unsigned long)id);
188d801c0d4bbe Pavitrakumar M 2023-11-14  2671  	pr_debug("   MAJOR      : %x\n", info->spacc_version.major);
188d801c0d4bbe Pavitrakumar M 2023-11-14  2672  	pr_debug("   MINOR      : %x\n", info->spacc_version.minor);
188d801c0d4bbe Pavitrakumar M 2023-11-14  2673  	pr_debug("   QOS        : %x\n", info->spacc_version.qos);
188d801c0d4bbe Pavitrakumar M 2023-11-14  2674  	pr_debug("   IVIMPORT   : %x\n", spacc->config.is_ivimport);
188d801c0d4bbe Pavitrakumar M 2023-11-14  2675  
188d801c0d4bbe Pavitrakumar M 2023-11-14  2676  	if (spacc->config.version >= 0x48)
188d801c0d4bbe Pavitrakumar M 2023-11-14  2677  		pr_debug("   TYPE       : %lx (%s)\n", SPACC_ID_TYPE(id),
188d801c0d4bbe Pavitrakumar M 2023-11-14  2678  			version_string[SPACC_ID_TYPE(id) & 3]);
188d801c0d4bbe Pavitrakumar M 2023-11-14  2679  
188d801c0d4bbe Pavitrakumar M 2023-11-14  2680  	pr_debug("   AUX        : %x\n", info->spacc_version.qos);
188d801c0d4bbe Pavitrakumar M 2023-11-14  2681  	pr_debug("   IDX        : %lx %s\n", SPACC_ID_VIDX(id),
188d801c0d4bbe Pavitrakumar M 2023-11-14  2682  		spacc->config.is_secure ?
188d801c0d4bbe Pavitrakumar M 2023-11-14  2683  		(idx_string[spacc->config.is_secure_port & 1]) : "");
188d801c0d4bbe Pavitrakumar M 2023-11-14  2684  	pr_debug("   PARTIAL    : %x\n", info->spacc_version.partial);
188d801c0d4bbe Pavitrakumar M 2023-11-14  2685  	pr_debug("   PROJECT    : %x\n", info->spacc_version.project);
188d801c0d4bbe Pavitrakumar M 2023-11-14  2686  	if (spacc->config.version >= 0x48)
188d801c0d4bbe Pavitrakumar M 2023-11-14  2687  		id = readl(spacc->regmap + SPACC_REG_CONFIG);
188d801c0d4bbe Pavitrakumar M 2023-11-14  2688  	else
188d801c0d4bbe Pavitrakumar M 2023-11-14  2689  		id = 0xFFFFFFFF;
188d801c0d4bbe Pavitrakumar M 2023-11-14  2690  
188d801c0d4bbe Pavitrakumar M 2023-11-14  2691  	pr_debug("SPACC CFG: (%08lx)\n", id);
188d801c0d4bbe Pavitrakumar M 2023-11-14  2692  	pr_debug("   CTX CNT    : %u\n", info->spacc_config.num_ctx);
188d801c0d4bbe Pavitrakumar M 2023-11-14  2693  	pr_debug("   VSPACC CNT : %u\n", info->spacc_config.num_vspacc);
188d801c0d4bbe Pavitrakumar M 2023-11-14  2694  	pr_debug("   CIPH SZ    : %-3lu bytes\n", 1UL <<
188d801c0d4bbe Pavitrakumar M 2023-11-14  2695  			info->spacc_config.ciph_ctx_page_size);
188d801c0d4bbe Pavitrakumar M 2023-11-14  2696  	pr_debug("   HASH SZ    : %-3lu bytes\n", 1UL <<
188d801c0d4bbe Pavitrakumar M 2023-11-14  2697  			info->spacc_config.hash_ctx_page_size);
188d801c0d4bbe Pavitrakumar M 2023-11-14  2698  	pr_debug("   DMA TYPE   : %u (%s)\n", info->spacc_config.dma_type,
188d801c0d4bbe Pavitrakumar M 2023-11-14  2699  		dma_type_string[info->spacc_config.dma_type & 3]);
188d801c0d4bbe Pavitrakumar M 2023-11-14  2700  	pr_debug("   MAX PROCLEN: %lu bytes\n", (unsigned
188d801c0d4bbe Pavitrakumar M 2023-11-14  2701  				long)spacc->config.max_msg_size);
188d801c0d4bbe Pavitrakumar M 2023-11-14  2702  	pr_debug("   FIFO CONFIG :\n");
188d801c0d4bbe Pavitrakumar M 2023-11-14  2703  	pr_debug("      CMD0 DEPTH: %d\n", spacc->config.cmd0_fifo_depth);
188d801c0d4bbe Pavitrakumar M 2023-11-14  2704  	if (spacc->config.is_qos) {
188d801c0d4bbe Pavitrakumar M 2023-11-14  2705  		pr_debug("      CMD1 DEPTH: %d\n",
188d801c0d4bbe Pavitrakumar M 2023-11-14  2706  			spacc->config.cmd1_fifo_depth);
188d801c0d4bbe Pavitrakumar M 2023-11-14  2707  		pr_debug("      CMD2 DEPTH: %d\n",
188d801c0d4bbe Pavitrakumar M 2023-11-14  2708  			spacc->config.cmd2_fifo_depth);
188d801c0d4bbe Pavitrakumar M 2023-11-14  2709  	}
188d801c0d4bbe Pavitrakumar M 2023-11-14  2710  	pr_debug("      STAT DEPTH: %d\n", spacc->config.stat_fifo_depth);
188d801c0d4bbe Pavitrakumar M 2023-11-14  2711  
188d801c0d4bbe Pavitrakumar M 2023-11-14  2712  	if (spacc->config.dma_type == SPACC_DMA_DDT) {
188d801c0d4bbe Pavitrakumar M 2023-11-14  2713  		writel(0x1234567F, baseaddr + SPACC_REG_DST_PTR);
188d801c0d4bbe Pavitrakumar M 2023-11-14  2714  		writel(0xDEADBEEF, baseaddr + SPACC_REG_SRC_PTR);
188d801c0d4bbe Pavitrakumar M 2023-11-14  2715  		if (((readl(baseaddr + SPACC_REG_DST_PTR)) !=
188d801c0d4bbe Pavitrakumar M 2023-11-14  2716  					(0x1234567F & SPACC_DST_PTR_PTR)) ||
188d801c0d4bbe Pavitrakumar M 2023-11-14  2717  		    ((readl(baseaddr + SPACC_REG_SRC_PTR)) !=
188d801c0d4bbe Pavitrakumar M 2023-11-14  2718  		     (0xDEADBEEF & SPACC_SRC_PTR_PTR))) {
188d801c0d4bbe Pavitrakumar M 2023-11-14  2719  			pr_err("ERR: Failed to set pointers\n");
188d801c0d4bbe Pavitrakumar M 2023-11-14  2720  			goto ERR;
188d801c0d4bbe Pavitrakumar M 2023-11-14  2721  		}
188d801c0d4bbe Pavitrakumar M 2023-11-14  2722  	}
188d801c0d4bbe Pavitrakumar M 2023-11-14  2723  
188d801c0d4bbe Pavitrakumar M 2023-11-14  2724  	/* zero the IRQ CTRL/EN register
188d801c0d4bbe Pavitrakumar M 2023-11-14  2725  	 * (to make sure we're in a sane state)
188d801c0d4bbe Pavitrakumar M 2023-11-14  2726  	 */
188d801c0d4bbe Pavitrakumar M 2023-11-14  2727  	writel(0, spacc->regmap + SPACC_REG_IRQ_CTRL);
188d801c0d4bbe Pavitrakumar M 2023-11-14  2728  	writel(0, spacc->regmap + SPACC_REG_IRQ_EN);
188d801c0d4bbe Pavitrakumar M 2023-11-14  2729  	writel(0xFFFFFFFF, spacc->regmap + SPACC_REG_IRQ_STAT);
188d801c0d4bbe Pavitrakumar M 2023-11-14  2730  
188d801c0d4bbe Pavitrakumar M 2023-11-14  2731  	/* init cache*/
188d801c0d4bbe Pavitrakumar M 2023-11-14  2732  	memset(&spacc->cache, 0, sizeof(spacc->cache));
188d801c0d4bbe Pavitrakumar M 2023-11-14  2733  	writel(0, spacc->regmap + SPACC_REG_SRC_PTR);
188d801c0d4bbe Pavitrakumar M 2023-11-14  2734  	writel(0, spacc->regmap + SPACC_REG_DST_PTR);
188d801c0d4bbe Pavitrakumar M 2023-11-14  2735  	writel(0, spacc->regmap + SPACC_REG_PROC_LEN);
188d801c0d4bbe Pavitrakumar M 2023-11-14  2736  	writel(0, spacc->regmap + SPACC_REG_ICV_LEN);
188d801c0d4bbe Pavitrakumar M 2023-11-14  2737  	writel(0, spacc->regmap + SPACC_REG_ICV_OFFSET);
188d801c0d4bbe Pavitrakumar M 2023-11-14  2738  	writel(0, spacc->regmap + SPACC_REG_PRE_AAD_LEN);
188d801c0d4bbe Pavitrakumar M 2023-11-14  2739  	writel(0, spacc->regmap + SPACC_REG_POST_AAD_LEN);
188d801c0d4bbe Pavitrakumar M 2023-11-14  2740  	writel(0, spacc->regmap + SPACC_REG_IV_OFFSET);
188d801c0d4bbe Pavitrakumar M 2023-11-14  2741  	writel(0, spacc->regmap + SPACC_REG_OFFSET);
188d801c0d4bbe Pavitrakumar M 2023-11-14  2742  	writel(0, spacc->regmap + SPACC_REG_AUX_INFO);
188d801c0d4bbe Pavitrakumar M 2023-11-14  2743  
188d801c0d4bbe Pavitrakumar M 2023-11-14 @2744  	spacc->ctx = vmalloc(sizeof(struct spacc_ctx) *
188d801c0d4bbe Pavitrakumar M 2023-11-14  2745  			spacc->config.num_ctx);
188d801c0d4bbe Pavitrakumar M 2023-11-14  2746  	if (!spacc->ctx) {
188d801c0d4bbe Pavitrakumar M 2023-11-14  2747  		pr_err("ERR: Out of memory for ctx\n");
188d801c0d4bbe Pavitrakumar M 2023-11-14  2748  		goto ERR;
188d801c0d4bbe Pavitrakumar M 2023-11-14  2749  	}
188d801c0d4bbe Pavitrakumar M 2023-11-14 @2750  	spacc->job = vmalloc(sizeof(struct spacc_job) * SPACC_MAX_JOBS);
188d801c0d4bbe Pavitrakumar M 2023-11-14  2751  	if (!spacc->job) {
188d801c0d4bbe Pavitrakumar M 2023-11-14  2752  		pr_err("ERR: Out of memory for job\n");
188d801c0d4bbe Pavitrakumar M 2023-11-14  2753  		goto ERR;
188d801c0d4bbe Pavitrakumar M 2023-11-14  2754  	}
188d801c0d4bbe Pavitrakumar M 2023-11-14  2755  
188d801c0d4bbe Pavitrakumar M 2023-11-14  2756  	/* initialize job_idx and lookup table */
188d801c0d4bbe Pavitrakumar M 2023-11-14  2757  	spacc_job_init_all(spacc);
188d801c0d4bbe Pavitrakumar M 2023-11-14  2758  
188d801c0d4bbe Pavitrakumar M 2023-11-14  2759  	/* initialize contexts */
188d801c0d4bbe Pavitrakumar M 2023-11-14  2760  	spacc_ctx_init_all(spacc);
188d801c0d4bbe Pavitrakumar M 2023-11-14  2761  
188d801c0d4bbe Pavitrakumar M 2023-11-14  2762  	/* autodetect and set string size setting*/
188d801c0d4bbe Pavitrakumar M 2023-11-14  2763  	if (spacc->config.version == 0x61 || spacc->config.version >= 0x65)
188d801c0d4bbe Pavitrakumar M 2023-11-14  2764  		spacc_xof_stringsize_autodetect(spacc);
188d801c0d4bbe Pavitrakumar M 2023-11-14  2765  
188d801c0d4bbe Pavitrakumar M 2023-11-14  2766  	return CRYPTO_OK;
188d801c0d4bbe Pavitrakumar M 2023-11-14  2767  ERR:
188d801c0d4bbe Pavitrakumar M 2023-11-14  2768  	spacc_fini(spacc);
188d801c0d4bbe Pavitrakumar M 2023-11-14  2769  	pr_err("ERR: Crypto Failed\n");
188d801c0d4bbe Pavitrakumar M 2023-11-14  2770  	return -EIO;
188d801c0d4bbe Pavitrakumar M 2023-11-14  2771  }
188d801c0d4bbe Pavitrakumar M 2023-11-14  2772  

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

