Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F8E739F
	for <linux-crypto@vger.kernel.org>; Wed, 15 Nov 2023 02:02:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="hSfXbXiU"
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.31])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24A14D6
	for <linux-crypto@vger.kernel.org>; Tue, 14 Nov 2023 18:02:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1700013728; x=1731549728;
  h=date:from:to:cc:subject:message-id:in-reply-to:
   mime-version;
  bh=2zEQ5sQbmFRlcI7u2JHK6NQ+gAzCv9v1pB+ihl7DjMs=;
  b=hSfXbXiUgTEuJsWIAlL10AqtJId3bJlfx5M4KIBFs+/e6rkbWzlOoWEV
   X9xkH6dQbShfK48h3be2aObE4qq6j6l+BS6iBjVk8Cw7oLrI8DoSlHA4P
   y3frXr9WCY1XHC2eI7Fkalhv5LWQces+Z45cupa1iAkxvjshztGzRRI+D
   attxFviYcYmRM6fVWfLGtJ5rL1DnfETROTY6MIqJBdsM/Kk8DqiBeN4Sv
   fma30lDc1FyQdqB0KkBcRo4XmaHMMV+QvCFkxSdZHAsdS3WAdOg8QFDI5
   89agiHizGku+ydscBBjClHMBaWFwwkboFcV9SQzs4XW9/x6b0wEqU0Gf4
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10894"; a="455083717"
X-IronPort-AV: E=Sophos;i="6.03,303,1694761200"; 
   d="scan'208";a="455083717"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Nov 2023 18:02:07 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10894"; a="835248818"
X-IronPort-AV: E=Sophos;i="6.03,303,1694761200"; 
   d="scan'208";a="835248818"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmsmga004.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 14 Nov 2023 18:02:07 -0800
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.34; Tue, 14 Nov 2023 18:02:06 -0800
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.34 via Frontend Transport; Tue, 14 Nov 2023 18:02:06 -0800
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.101)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.34; Tue, 14 Nov 2023 18:02:05 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SgkSx/rXLFsH2N+9woHrqTT3EPr1BTEzNcUme1d0fkwMPiGP1WDe1pjKntQ8chE1oQ5sckW4zcdfP9YVAArragaSKaQY6SdKZl01DXtyKtxKoRxsD1e+6VzaxA3gdYsPCCjc+BGkVrv2aWQxril5HKpR1VS6dm93xkt+SMpNwh7kqufIrluAZK2iLRzjd9A17ZTvthJ2myq60zCECkS8YKE0Bq2Ofc4VTDZmQQJg7x0YdPytDODYSVKiE7St3z6Jqk/n2lC9+ulW39qp326TT+cd/xReZ5pUHgy+COdznVoWUH6RPe4wWBgYX5YkP2bL/B9rOaj0j/w0xMHz4YBfGw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=oKbI0j6pc/rdAO3cP0b9jc3CKq61IFwO5KJBUEY6ghc=;
 b=OGAj9wmLIyNZZZzVRbG2FHPcu9sKWnt6gvS7lgWQRcLHjIaWuHMiZr+A/iEgutUckWKPwh6WZSSnQrrpB0cM56vIxrv0e38B2maSE5Aci5Ri+nEhSWv9UAhr3FYxgikgdhZBuLPHX7oaxI70H22KFRszQni78VjoZnU/87F3kM5ZEJx0KgeKOBgQY7rxrpXdy5zDMhvJYAopIiZY053l4tDezPhsgkPXbzz3M7zJlSKWuziVWsHutZK68S0eqtMtvO6+8LYY1K5WSuP7Jq+MP9AJK26itcBFygx9BtETRx1OnSwtwe1h0h1ObVcMpfZtTfG5dfbGFC9Ba1ukmSDaag==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CY5PR11MB6392.namprd11.prod.outlook.com (2603:10b6:930:37::15)
 by MW3PR11MB4521.namprd11.prod.outlook.com (2603:10b6:303:55::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7002.17; Wed, 15 Nov
 2023 02:02:03 +0000
Received: from CY5PR11MB6392.namprd11.prod.outlook.com
 ([fe80::15d3:7425:a09e:1c86]) by CY5PR11MB6392.namprd11.prod.outlook.com
 ([fe80::15d3:7425:a09e:1c86%4]) with mapi id 15.20.6933.028; Wed, 15 Nov 2023
 02:02:03 +0000
Date: Wed, 15 Nov 2023 09:57:21 +0800
From: kernel test robot <yujie.liu@intel.com>
To: Pavitrakumar M <pavitrakumarm@vayavyalabs.com>,
	<herbert@gondor.apana.org.au>, <linux-crypto@vger.kernel.org>
CC: <oe-kbuild-all@lists.linux.dev>, <manjunath.hadli@vayavyalabs.com>,
	Pavitrakumar M <pavitrakumarm@vayavyalabs.com>, shwetar
	<shwetar@vayavyalabs.com>, Ruud Derwig <Ruud.Derwig@synopsys.com>
Subject: Re: [PATCH 4/4] Enable Driver compilation in crypto Kconfig and
 Makefile file
Message-ID: <202311141830.g6TK9OTS-lkp@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20231114050525.471854-5-pavitrakumarm@vayavyalabs.com>
X-ClientProxiedBy: SG2PR02CA0036.apcprd02.prod.outlook.com
 (2603:1096:3:18::24) To CY5PR11MB6392.namprd11.prod.outlook.com
 (2603:10b6:930:37::15)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY5PR11MB6392:EE_|MW3PR11MB4521:EE_
X-MS-Office365-Filtering-Correlation-Id: 5a612835-6630-495e-2371-08dbe57edc6f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: d7TGKmK9Xt/lQpRTOkOLXrHpqB4AfegLbXTZYQwQAf30C3zqXtb+Jo1wl4a8+gTYZwQJd99CpKSusS2UpU6B70f4uAkthC+VZB/6P2/Q0Yns4TYX8XwWtgP86Ie87OOscaCEzT9EnKXbeoxK/zOeBa0sFUkO4yKz0Doyu818VLwyXUAk/ybeuKssBUwKYzfMY7fwSX2wW1920ab/Gjp+0+H3h/eiO7yGFIHlyXc4kbVzfkOd3THqmMag40bTUANGTJDPh3lkoSVT5Rotu6eI/+Ntl4HVR4jr/EchJxVGyAV3YV/j4f6w8LVdljTRY77cAHboWOwVAuLJOCjAqc9WUz4kmG+u4oqN7i5GhlfEUvdHEh1rPjufdd54uNYch1KME1PPJX77UunHKBFSIBsSReIiUfKdY30gHoAIb0LKclsBezC2eWtEXfWU3F/Y3cSIjCcyYmj7f4mlVkdgRFVOgdU4eDwrhUpTkmlCZktIK17aRga3n0juD+73stfFVvjX4umzDYFte9oYGASMe4ujytltWhzQcegHVLLQvcC8P+Pztn1iIdcrXI1exBgYHP65qUZRYk5yOYs3QbxTkdhcVXmjLl/TnRY9E/8ExCNXJxOcGsO8j4Cx/99NPZ+7dUKGEJOUZCCfz3/pmqA3wCfv5Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR11MB6392.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376002)(39860400002)(346002)(366004)(396003)(136003)(230173577357003)(230922051799003)(230273577357003)(64100799003)(451199024)(1800799009)(186009)(6486002)(966005)(66556008)(54906003)(66476007)(66946007)(1076003)(5660300002)(478600001)(316002)(8936002)(8676002)(4326008)(6666004)(6506007)(6512007)(41300700001)(86362001)(82960400001)(83380400001)(2616005)(36756003)(38100700002)(30864003)(26005)(2906002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?2Sia1DnT63hhT+zaKqo04NshXRI4aQGlY8q5z+zjmfLRt/xv3KgiDBsQCYUk?=
 =?us-ascii?Q?OOsShCDNQbviANDm163WvDU1evgh34NSlCOnSb7b9k4XG6QRRzhiTFo4uJ1n?=
 =?us-ascii?Q?i1lXFL4Q60faTDSlQdAgLzfqGBFfcjR0Z6d5IqiL3p7nAXIbstv84xcLvCAS?=
 =?us-ascii?Q?IBtAC/ZGoCgSWx3HaLoiYwRIxddpDPLB7E2ZD57PZ/L5x4pB/21Ry+mQv1A7?=
 =?us-ascii?Q?LNb7z0Ugygsq6LbuoiEfCI0vpa40rPoD5Jki7yem6jdxkLWGnQadQTVekNPc?=
 =?us-ascii?Q?fo/TEz5G+GzqADeZjVLNm+TedfrhISQBjEL/0FwSuksbKUhODPsqU3EeiVrg?=
 =?us-ascii?Q?xMzrKp6jWACPB3GhhcrwiDLfLbZosvNdBcbZg2id6FxKpuBgV1qhdUEyFQ+h?=
 =?us-ascii?Q?VSvbZU+LutKLPwV3IY4NdKcKkx/WrB11WADps5tiBSkRuoahrhL5DI4mCZP/?=
 =?us-ascii?Q?h73f6cr4lzYZPvaxN3G23sVSTT6eYnTlV4+jUYZRXdkrZ2opKaSZD2zWVLtH?=
 =?us-ascii?Q?3sWO3JW9bEDjYFy8Z8nPCt/PduHyNjQ9z0Ee7VqGuvSnlQzAfp0Z6y2B09OV?=
 =?us-ascii?Q?zzjwFojDdnyxDlaMycsKPz4nr7O7Gci6p9KSrrmn5kNAs2uA8mvb7ryOmKoB?=
 =?us-ascii?Q?lN548+4HC5AiW/mUT7kwMaIY9tgOIEU+lJwBGBWhANxLEm6UoATdUU03nbfB?=
 =?us-ascii?Q?2zLSk5ZqX2ImmCy7JbC6Xa76t63jxRH6NeG7PWJK2GFmKWwmJPiCinLtDSZX?=
 =?us-ascii?Q?7YiH9d4svr8HsCp6AJ0NjfvAwX2udI7TgH3q9GF+LCnyDenPMZZVUFPf9cIv?=
 =?us-ascii?Q?xx+mR7E0Eaj81tXIgRs59I9ihpYDy/yTk6/oWglgTXhk/fXb/AqLLD4bgpwY?=
 =?us-ascii?Q?eXXvfNTPkP9z2WXjdhpAZuXf4ShQ6iSXuPbGypOPbik1j5T4TPKRpjkMroZP?=
 =?us-ascii?Q?e26fubtoX9R2QzzRug+OvLBb8/1gd470h11nuZyNpUgEeBddfloBW8XCzfZ7?=
 =?us-ascii?Q?m41yvAxnr6VBY9ZyBH6mX1eOM4ZQDmxcV6mT7aVtk7edRSY1J8RrTXju5ol5?=
 =?us-ascii?Q?iU8ygkQBItGkPmNGFsJMIDAuOngC2NFOwrcXO8rFsjaCKE+G7NDjyhxlPc6r?=
 =?us-ascii?Q?XGAa/LAhPqFM9V7SmvweYKtrf0nw5367cnYKUFSJWkyqaQu/1qPwB4e0Bjd3?=
 =?us-ascii?Q?F0zMgB/f4oL4NPS50SMvWKItmZDJp/y1cR5642gBWaV2nKMmNd3JWu8dhXYV?=
 =?us-ascii?Q?l+LWDqaP8DftzGqFvfDPUy2tWnGryVtQTiYKUuBqLTp4u1oIE+jB+xtuncUU?=
 =?us-ascii?Q?P9on/HA8gNObcpU8UY8p5Mv5sazO2+EraENx5vA89xcbHn2uLagumR6a9Vmy?=
 =?us-ascii?Q?Tz0obNCp8VausB9RlVesQPUuqCp7yjsqkGQgoPaQ79l2h0F8ZjkTe2wIxIqR?=
 =?us-ascii?Q?Gb0zhx5CbBJfNyhBYj+3sb5P52cDDaHhmlnOk/IXfpvT/Vp3NZwGG2o9odTr?=
 =?us-ascii?Q?L0M0ng405Hklub17GvuqyR5wvyiNj9Yunn+ocn38dZk/ASP6V3Ky7XD3dImX?=
 =?us-ascii?Q?gk9+kzACR3PfGmE4MLEINPcfBPMxTN6k38aGJ1gh?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 5a612835-6630-495e-2371-08dbe57edc6f
X-MS-Exchange-CrossTenant-AuthSource: CY5PR11MB6392.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Nov 2023 02:02:03.3607
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1eghzLcs7SLYkPGPuTi5rpesiElaDMZIdMawD4Qfb7pytshg1xX+XGLP63twHvmhL2dzm1j5cuGLg6I/WOLlnA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR11MB4521
X-OriginatorOrg: intel.com

Hi Pavitrakumar,

kernel test robot noticed the following build errors:

[auto build test ERROR on herbert-cryptodev-2.6/master]
[also build test ERROR on herbert-crypto-2.6/master linus/master v6.7-rc1]
[cannot apply to xilinx-xlnx/master next-20231114]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Pavitrakumar-M/Add-SPACC-driver-to-Linux-kernel/20231114-143618
base:   https://git.kernel.org/pub/scm/linux/kernel/git/herbert/cryptodev-2.6.git master
patch link:    https://lore.kernel.org/r/20231114050525.471854-5-pavitrakumarm%40vayavyalabs.com
patch subject: [PATCH 4/4] Enable Driver compilation in crypto Kconfig and Makefile file
config: csky-randconfig-001-20231114 (https://download.01.org/0day-ci/archive/20231114/202311141830.g6TK9OTS-lkp@intel.com/config)
compiler: csky-linux-gcc (GCC) 13.2.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20231114/202311141830.g6TK9OTS-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <yujie.liu@intel.com>
| Closes: https://lore.kernel.org/r/202311141830.g6TK9OTS-lkp@intel.com/

All error/warnings (new ones prefixed by >>):

>> drivers/crypto/dwc-spacc/spacc_skcipher.c:87:5: warning: no previous prototype for 'spacc_skcipher_fallback' [-Wmissing-prototypes]
      87 | int spacc_skcipher_fallback(unsigned char *name, struct skcipher_request *req,
         |     ^~~~~~~~~~~~~~~~~~~~~~~
   drivers/crypto/dwc-spacc/spacc_skcipher.c: In function 'spacc_cipher_cb':
>> drivers/crypto/dwc-spacc/spacc_skcipher.c:131:18: warning: variable 'rc' set but not used [-Wunused-but-set-variable]
     131 |         int err, rc;
         |                  ^~
   drivers/crypto/dwc-spacc/spacc_skcipher.c: At top level:
>> drivers/crypto/dwc-spacc/spacc_skcipher.c:155:5: warning: no previous prototype for 'spacc_cipher_init_dma' [-Wmissing-prototypes]
     155 | int spacc_cipher_init_dma(struct device *dev, struct skcipher_request *req)
         |     ^~~~~~~~~~~~~~~~~~~~~
>> drivers/crypto/dwc-spacc/spacc_skcipher.c:179:5: warning: no previous prototype for 'spacc_cipher_cra_init' [-Wmissing-prototypes]
     179 | int spacc_cipher_cra_init(struct crypto_tfm *tfm)
         |     ^~~~~~~~~~~~~~~~~~~~~
>> drivers/crypto/dwc-spacc/spacc_skcipher.c:210:5: warning: no previous prototype for 'spacc_cipher_setkey' [-Wmissing-prototypes]
     210 | int spacc_cipher_setkey(struct crypto_skcipher *tfm, const u8 *key,
         |     ^~~~~~~~~~~~~~~~~~~
>> drivers/crypto/dwc-spacc/spacc_skcipher.c:283:5: warning: no previous prototype for 'spacc_cipher_process' [-Wmissing-prototypes]
     283 | int spacc_cipher_process(struct skcipher_request *req, int enc_dec)
         |     ^~~~~~~~~~~~~~~~~~~~
   drivers/crypto/dwc-spacc/spacc_skcipher.c: In function 'spacc_cipher_process':
>> drivers/crypto/dwc-spacc/spacc_skcipher.c:293:13: warning: variable 'ivsize' set but not used [-Wunused-but-set-variable]
     293 |         int ivsize;
         |             ^~~~~~
   drivers/crypto/dwc-spacc/spacc_skcipher.c: At top level:
>> drivers/crypto/dwc-spacc/spacc_skcipher.c:473:5: warning: no previous prototype for 'spacc_cipher_encrypt' [-Wmissing-prototypes]
     473 | int spacc_cipher_encrypt(struct skcipher_request *req)
         |     ^~~~~~~~~~~~~~~~~~~~
>> drivers/crypto/dwc-spacc/spacc_skcipher.c:487:5: warning: no previous prototype for 'spacc_cipher_decrypt' [-Wmissing-prototypes]
     487 | int spacc_cipher_decrypt(struct skcipher_request *req)
         |     ^~~~~~~~~~~~~~~~~~~~
   drivers/crypto/dwc-spacc/spacc_skcipher.c: In function 'probe_ciphers':
>> drivers/crypto/dwc-spacc/spacc_skcipher.c:533:59: warning: '%s' directive output may be truncated writing up to 5299 bytes into a region of size 128 [-Wformat-truncation=]
     533 |         snprintf(calg->cra_name, sizeof(calg->cra_name), "%s", mode->name);
         |                                                           ^~
   In function 'spacc_init_calg',
       inlined from 'spacc_register_cipher' at drivers/crypto/dwc-spacc/spacc_skcipher.c:549:2,
       inlined from 'probe_ciphers' at drivers/crypto/dwc-spacc/spacc_skcipher.c:596:11:
   drivers/crypto/dwc-spacc/spacc_skcipher.c:533:9: note: 'snprintf' output between 1 and 5300 bytes into a destination of size 128
     533 |         snprintf(calg->cra_name, sizeof(calg->cra_name), "%s", mode->name);
         |         ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   drivers/crypto/dwc-spacc/spacc_skcipher.c: In function 'probe_ciphers':
   drivers/crypto/dwc-spacc/spacc_skcipher.c:535:25: warning: '%s' directive output may be truncated writing up to 5299 bytes into a region of size 122 [-Wformat-truncation=]
     535 |                  "spacc-%s", mode->name);
         |                         ^~
   In function 'spacc_init_calg',
       inlined from 'spacc_register_cipher' at drivers/crypto/dwc-spacc/spacc_skcipher.c:549:2,
       inlined from 'probe_ciphers' at drivers/crypto/dwc-spacc/spacc_skcipher.c:596:11:
   drivers/crypto/dwc-spacc/spacc_skcipher.c:534:9: note: 'snprintf' output between 7 and 5306 bytes into a destination of size 128
     534 |         snprintf(calg->cra_driver_name, sizeof(calg->cra_driver_name),
         |         ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
     535 |                  "spacc-%s", mode->name);
         |                  ~~~~~~~~~~~~~~~~~~~~~~~
--
>> drivers/crypto/dwc-spacc/spacc_core.c:1113:5: warning: no previous prototype for 'spacc_sgs_to_ddt' [-Wmissing-prototypes]
    1113 | int spacc_sgs_to_ddt(struct device *dev,
         |     ^~~~~~~~~~~~~~~~
>> drivers/crypto/dwc-spacc/spacc_core.c:1179:5: warning: no previous prototype for 'modify_scatterlist' [-Wmissing-prototypes]
    1179 | int modify_scatterlist(struct scatterlist *src, struct scatterlist *dst,
         |     ^~~~~~~~~~~~~~~~~~
>> drivers/crypto/dwc-spacc/spacc_core.c:1215:5: warning: no previous prototype for 'spacc_sg_to_ddt' [-Wmissing-prototypes]
    1215 | int spacc_sg_to_ddt(struct device *dev, struct scatterlist *sg,
         |     ^~~~~~~~~~~~~~~
>> drivers/crypto/dwc-spacc/spacc_core.c:2991:12: warning: 'spacc_load_skp' defined but not used [-Wunused-function]
    2991 | static int spacc_load_skp(struct spacc_device *spacc, uint32_t *key, int keysz,
         |            ^~~~~~~~~~~~~~
>> drivers/crypto/dwc-spacc/spacc_core.c:2849:13: warning: 'spacc_set_secure_mode' defined but not used [-Wunused-function]
    2849 | static void spacc_set_secure_mode(struct spacc_device *spacc, int src, int dst,
         |             ^~~~~~~~~~~~~~~~~~~~~
>> drivers/crypto/dwc-spacc/spacc_core.c:974:26: warning: 'names' defined but not used [-Wunused-const-variable=]
     974 | static const char *const names[] = {
         |                          ^~~~~
   In file included from <command-line>:
   In function 'spacc_sg_chain',
       inlined from 'fixup_sg' at drivers/crypto/dwc-spacc/spacc_core.c:1105:4,
       inlined from 'spacc_sgs_to_ddt' at drivers/crypto/dwc-spacc/spacc_core.c:1132:16:
>> include/linux/compiler_types.h:425:45: error: call to '__compiletime_assert_235' declared with attribute error: BUILD_BUG_ON failed: IS_ENABLED(CONFIG_DEBUG_SG)
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
>> include/linux/compiler_types.h:425:45: error: call to '__compiletime_assert_235' declared with attribute error: BUILD_BUG_ON failed: IS_ENABLED(CONFIG_DEBUG_SG)
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
--
>> drivers/crypto/dwc-spacc/spacc_ahash.c:499:5: warning: no previous prototype for 'do_shash' [-Wmissing-prototypes]
     499 | int do_shash(unsigned char *name, unsigned char *result,
         |     ^~~~~~~~
   drivers/crypto/dwc-spacc/spacc_ahash.c: In function 'spacc_hash_final':
>> drivers/crypto/dwc-spacc/spacc_ahash.c:1007:13: warning: variable 'err' set but not used [-Wunused-but-set-variable]
    1007 |         int err;
         |             ^~~
   drivers/crypto/dwc-spacc/spacc_ahash.c: In function 'probe_hashes':
>> drivers/crypto/dwc-spacc/spacc_ahash.c:177:59: warning: '%s' directive output may be truncated writing up to 8479 bytes into a region of size 128 [-Wformat-truncation=]
     177 |         snprintf(calg->cra_name, sizeof(calg->cra_name), "%s", mode->name);
         |                                                           ^~
   In function 'spacc_init_calg',
       inlined from 'spacc_register_hash' at drivers/crypto/dwc-spacc/spacc_ahash.c:1164:2,
       inlined from 'probe_hashes' at drivers/crypto/dwc-spacc/spacc_ahash.c:1211:9:
   drivers/crypto/dwc-spacc/spacc_ahash.c:177:9: note: 'snprintf' output between 1 and 8480 bytes into a destination of size 128
     177 |         snprintf(calg->cra_name, sizeof(calg->cra_name), "%s", mode->name);
         |         ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   drivers/crypto/dwc-spacc/spacc_ahash.c: In function 'probe_hashes':
   drivers/crypto/dwc-spacc/spacc_ahash.c:179:25: warning: '%s' directive output may be truncated writing up to 8479 bytes into a region of size 122 [-Wformat-truncation=]
     179 |                  "spacc-%s", mode->name);
         |                         ^~
   In function 'spacc_init_calg',
       inlined from 'spacc_register_hash' at drivers/crypto/dwc-spacc/spacc_ahash.c:1164:2,
       inlined from 'probe_hashes' at drivers/crypto/dwc-spacc/spacc_ahash.c:1211:9:
   drivers/crypto/dwc-spacc/spacc_ahash.c:178:9: note: 'snprintf' output between 7 and 8486 bytes into a destination of size 128
     178 |         snprintf(calg->cra_driver_name, sizeof(calg->cra_driver_name),
         |         ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
     179 |                  "spacc-%s", mode->name);
         |                  ~~~~~~~~~~~~~~~~~~~~~~~
--
>> drivers/crypto/dwc-spacc/spacc_interrupt.c:188:6: warning: no previous prototype for 'spacc_disable_int' [-Wmissing-prototypes]
     188 | void spacc_disable_int (struct spacc_device *spacc)
         |      ^~~~~~~~~~~~~~~~~
>> drivers/crypto/dwc-spacc/spacc_interrupt.c:194:13: warning: no previous prototype for 'spacc_irq_handler' [-Wmissing-prototypes]
     194 | irqreturn_t spacc_irq_handler(int irq, void *dev)
         |             ^~~~~~~~~~~~~~~~~
--
   drivers/crypto/dwc-spacc/spacc_hal.c: In function 'pdu_get_version':
>> drivers/crypto/dwc-spacc/spacc_hal.c:19:28: warning: variable 'ver' set but not used [-Wunused-but-set-variable]
      19 |         unsigned long tmp, ver;
         |                            ^~~
   drivers/crypto/dwc-spacc/spacc_hal.c: At top level:
>> drivers/crypto/dwc-spacc/spacc_hal.c:374:5: warning: no previous prototype for 'pdu_sg_to_ddt' [-Wmissing-prototypes]
     374 | int pdu_sg_to_ddt(struct scatterlist *sg, int sg_count, struct pdu_ddt *ddt)
         |     ^~~~~~~~~~~~~
--
   drivers/crypto/dwc-spacc/spacc_aead.c: In function 'spacc_aead_init_dma':
>> drivers/crypto/dwc-spacc/spacc_aead.c:256:31: warning: variable 'buf' set but not used [-Wunused-but-set-variable]
     256 |                         char *buf = sg_virt(req->src);
         |                               ^~~


vim +/__compiletime_assert_235 +425 include/linux/compiler_types.h

eb5c2d4b45e3d2d5 Will Deacon 2020-07-21  411  
eb5c2d4b45e3d2d5 Will Deacon 2020-07-21  412  #define _compiletime_assert(condition, msg, prefix, suffix) \
eb5c2d4b45e3d2d5 Will Deacon 2020-07-21  413  	__compiletime_assert(condition, msg, prefix, suffix)
eb5c2d4b45e3d2d5 Will Deacon 2020-07-21  414  
eb5c2d4b45e3d2d5 Will Deacon 2020-07-21  415  /**
eb5c2d4b45e3d2d5 Will Deacon 2020-07-21  416   * compiletime_assert - break build and emit msg if condition is false
eb5c2d4b45e3d2d5 Will Deacon 2020-07-21  417   * @condition: a compile-time constant condition to check
eb5c2d4b45e3d2d5 Will Deacon 2020-07-21  418   * @msg:       a message to emit if condition is false
eb5c2d4b45e3d2d5 Will Deacon 2020-07-21  419   *
eb5c2d4b45e3d2d5 Will Deacon 2020-07-21  420   * In tradition of POSIX assert, this macro will break the build if the
eb5c2d4b45e3d2d5 Will Deacon 2020-07-21  421   * supplied condition is *false*, emitting the supplied error message if the
eb5c2d4b45e3d2d5 Will Deacon 2020-07-21  422   * compiler has support to do so.
eb5c2d4b45e3d2d5 Will Deacon 2020-07-21  423   */
eb5c2d4b45e3d2d5 Will Deacon 2020-07-21  424  #define compiletime_assert(condition, msg) \
eb5c2d4b45e3d2d5 Will Deacon 2020-07-21 @425  	_compiletime_assert(condition, msg, __compiletime_assert_, __COUNTER__)
eb5c2d4b45e3d2d5 Will Deacon 2020-07-21  426  

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

