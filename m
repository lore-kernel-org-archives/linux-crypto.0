Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9A4E10F5
	for <linux-crypto@vger.kernel.org>; Wed, 15 Nov 2023 02:03:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="BMwSVNLA"
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.100])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41F21DA
	for <linux-crypto@vger.kernel.org>; Tue, 14 Nov 2023 18:03:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1700013813; x=1731549813;
  h=date:from:to:cc:subject:message-id:in-reply-to:
   mime-version;
  bh=uFiTzspUT255vZ1F9pkykVSRnszhap58MDKBjV4Xtzw=;
  b=BMwSVNLA+XXMR/9/beF4yGT6LP9OpZww6Z86bySdS/2LqR6oGbMjKKN3
   BvCri2jCbOvAn05SB+qaXfsQ89jK3fnt/1K2bnB8iVug0ATyG2930luWY
   J2zT6vxC853U8Li+Wu4j8NwysSpEvlXARmipuic2Mj1jn+Qa1+NRoX+me
   RwnMxAubv2vPFRvyP70PGEW3xmwRKl8s43QzoBwjMiIaEavzZ8DY/WK3U
   2rI3AnrSf/wDMJ50t/d+AYMoOVLobBqiCthtbCCnLq3bSUOk9pl4wH9Kh
   s5PcYDNLITWat0QDBgLPTvHDsu3srMnTstHYL0BjNkUQ9rs9E6K0cbzIB
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10894"; a="457291947"
X-IronPort-AV: E=Sophos;i="6.03,303,1694761200"; 
   d="scan'208";a="457291947"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Nov 2023 18:03:32 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.03,303,1694761200"; 
   d="scan'208";a="6259680"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by fmviesa002.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 14 Nov 2023 18:03:31 -0800
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.34; Tue, 14 Nov 2023 18:03:30 -0800
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.34 via Frontend Transport; Tue, 14 Nov 2023 18:03:30 -0800
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.101)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.34; Tue, 14 Nov 2023 18:03:30 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UyYuIGr7GJsl4J03lhEtuQK4/XexDmiOaYW0mZNnEr0tVWsk0PuuUl2uEicFaCCpEe0tKdvMDpe50uRCDP6qM7VUe7Ap9ryBJyBL4riJpBntdC2A+REOUnpdyeoYXLoVWuwQwY79FFkLLQO5rajVlEwjMbV8cGyx3L2aJ2/omwnKlw11pXCTHPQpko46tzOrGDBITKVBNzWcC3ECDcf3Y80CgDuGxIssk2GVHe3eUJc+b5mnNSzvAkX1ZV5EM0DbMB63cGawkFXY3g+3k3EQVN2ghNnT6D0g9ZSzXIfby0sQ4cgcxd8JV7nfF7z19b05ktzVaiEfLI2bmiHc20rTvA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=V7Jf1fior4+Cv27m6IH30bJ6HLn8OB/LOUX5mLaNObQ=;
 b=EgzrWAZQCNigg0X0VW22H3HaEH8SaiMeMMLJGAkeWAEhJ+5i0LlhNdpm0GSUW4I/Citx4rE1z1zpiHuV+1ceo7iYJNx8WYUpmvk9UxQbghKzqjyIb0imEn2xwQmCMl5SKx0InXRFy6L5LKvrYfaAvH7qXMOAtZwsqys3RVQEqymeN2HqYP0yyNprNKRu3wQWi4EAd66s53SNfah0bk1xckRzOa7NbZooxMSn719m52Vv+h9TnuqrpG5QMnxP7Oi81OrfOalntazj9OfabZaAJWrCH7IGoRBPQLcJfDl5HZo+PwROvwRcjfP2PBPguGxWDsCssD6/855lJcWw/d+R8Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CY5PR11MB6392.namprd11.prod.outlook.com (2603:10b6:930:37::15)
 by LV2PR11MB6045.namprd11.prod.outlook.com (2603:10b6:408:17b::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6977.31; Wed, 15 Nov
 2023 02:03:28 +0000
Received: from CY5PR11MB6392.namprd11.prod.outlook.com
 ([fe80::15d3:7425:a09e:1c86]) by CY5PR11MB6392.namprd11.prod.outlook.com
 ([fe80::15d3:7425:a09e:1c86%4]) with mapi id 15.20.6933.028; Wed, 15 Nov 2023
 02:03:28 +0000
Date: Wed, 15 Nov 2023 09:58:46 +0800
From: kernel test robot <yujie.liu@intel.com>
To: Pavitrakumar M <pavitrakumarm@vayavyalabs.com>,
	<herbert@gondor.apana.org.au>, <linux-crypto@vger.kernel.org>
CC: <oe-kbuild-all@lists.linux.dev>, <manjunath.hadli@vayavyalabs.com>,
	Pavitrakumar M <pavitrakumarm@vayavyalabs.com>, shwetar
	<shwetar@vayavyalabs.com>, Ruud Derwig <Ruud.Derwig@synopsys.com>
Subject: Re: [PATCH 4/4] Enable Driver compilation in crypto Kconfig and
 Makefile file
Message-ID: <202311141906.Ai9VGcKQ-lkp@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20231114050525.471854-5-pavitrakumarm@vayavyalabs.com>
X-ClientProxiedBy: SGAP274CA0016.SGPP274.PROD.OUTLOOK.COM (2603:1096:4:b6::28)
 To CY5PR11MB6392.namprd11.prod.outlook.com (2603:10b6:930:37::15)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY5PR11MB6392:EE_|LV2PR11MB6045:EE_
X-MS-Office365-Filtering-Correlation-Id: ddf6898b-8367-4841-6715-08dbe57f0f01
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: CMNSbv+FgzNbbkgknQjGkw5ThyWnPQXA75/hdjJDtyv70VjCx/7CGkYwvM4cfAdmgw1T5FTmk51PdPtAmIkHyE7XOxugsiSPGgAKucKuQ09iEh1Pq/3yEfggV+xjWdCjziE99cQePB5iN6xjXiJb/QoZCU6X1MoKdJDtlD3qRMRAXeTjJUfb+7UtrPuzYLpTqvgZJlMv7cMGkAUm19Hnp9HwDn3LaJjo8RHYjfhiYwmKr6pXxHc5Kg1untuf8VQvjk+7TBRLdQ6v1996D/uqUNvvlCE5uMyE5tRR7kHPb6S5T0tNAzmBy/B/FKVbjZ1ntE1N3bHTu4H00KYrWtzDYXDNdsQcNDQ+S4qNFh+o9U2drOL30AwKX8sQ2C3TwysoF8tX2pYCEk6T9MLPnQm/N3B+o6oDMUMX1PzbwLay3iTnxnZlIlYP74H+QLMHi0CQxlrhBxxDU8Hw9hP7ljDD5hq3AtnVYhGGe4B+Cz/WysBB/uUDDaabJDYKJLixbXg4SIrtXgaiL7LueJBiqV7dQmAIIK3DQEaviLvmStObp0b9kbfs5BC9TefOJw6wIu3NkUOO1ScBo9t90pzCG74vgA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR11MB6392.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(346002)(136003)(39860400002)(376002)(396003)(366004)(230922051799003)(64100799003)(451199024)(1800799009)(186009)(86362001)(83380400001)(38100700002)(66476007)(82960400001)(66946007)(316002)(66556008)(54906003)(8936002)(36756003)(6666004)(6512007)(2616005)(1076003)(26005)(478600001)(6486002)(966005)(41300700001)(4001150100001)(2906002)(6506007)(4326008)(8676002)(5660300002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?SpausN2cFtBXXzHgykGSzY8qUWuwR3ZjBNDUg7lmIdy31/bMUjGPHe/fxrua?=
 =?us-ascii?Q?GYyJDTlfDh7sdDRzOoq/toV4EdlvlLE1ueSjcyccHahUdbRmIEiKox27qWAC?=
 =?us-ascii?Q?ZtbYDwZKMPeTdIozVKGha2R7RQUHrd1dHeglMK9jjo+281b1P1cf1kOiIPvo?=
 =?us-ascii?Q?HU4se9USOEPxDuSacohVXAdrm5APbweOvRM1I7F+CE/rPYa285Vz7BY44Oyh?=
 =?us-ascii?Q?Td+Q+MU3qS5lKdsI5DYAsWLD0bZEVXGSVP1BqY75pLDTXD80WijirfOkfsQa?=
 =?us-ascii?Q?tqUVgOxewjOBdZPCn6dYDNkzVj2CoWkgAH6e8koOdjDpifA1HdBJyzx2zs2g?=
 =?us-ascii?Q?xzxTdN4MSqObIlDw1I8zQWF3KCw9Zw05O1DS1sjSAGdv2Ky0tcb545wMdy36?=
 =?us-ascii?Q?G8sYKkkxkx6lL+YfwVmV7lHLwW4vjE6z/aZh68CkkxGkKYtXznOrlQ04E+L6?=
 =?us-ascii?Q?xxJlY6864jiIS9V4mgQOtkJk5643ALPlYRnPn1GB7uCAEk5M0jFBNdU7buvO?=
 =?us-ascii?Q?idpaN7LhnjrhHNCBV0jf8LXKUlyWsobEuYTJvl8CNZ4a0twC1YpJnmPsY35b?=
 =?us-ascii?Q?eJd6/MvHFtpaK1MaN8dTS2Ea883zFJCeHy1g3aLL/b5pqKDmDoFIMZ3XPA/u?=
 =?us-ascii?Q?9/sWQaSX0XXi3Zt2aNe44ZaQ6uucI98WaZRi9LutMlwE5n2lTV5PuxcFwKTS?=
 =?us-ascii?Q?eCw0EwqhRw/ZcAN41Offliz6hP9YmzkJHx0Dv4M/Ti475eO2/W++BZuj3GFB?=
 =?us-ascii?Q?w9hu2wOOJDRF68fGk1lnbnFOwQY6YzGaUDt9Rek2683rzcMEddJs/8rEZict?=
 =?us-ascii?Q?n9cIlv8kSzDJyRlfWIT3yrOUYswxc5/4q3gbmXKiZn9Vqjp075HdFO6pPpyt?=
 =?us-ascii?Q?9vIMv6lkrsTSfL9KJm1HMlQmBQOEQbaXW4aGxkBpLvQgBHEAcGnaSsTmZTd/?=
 =?us-ascii?Q?yZwimD/YD1wTiRfL79uO/k2tTKL4Epi9YOJeoYGuTczLiD8tO02w9UNFT1Bd?=
 =?us-ascii?Q?uknJejs1ldAar8WTquCJlK5rZi2OWZP5qxwz6ZB3VPaWxSQ7XfgM1Ja2pc7U?=
 =?us-ascii?Q?oiX5gJG0JsX3eO5+bzfRXJDxb2/5JEDdj2LJPl9cWBkdunKuNgqkckPgOyOF?=
 =?us-ascii?Q?yQvdQfq8wfeaVo1MIvHls0NBlamPIYHtEdBYVwRmng/BwbAGV79i8bDoL+Bl?=
 =?us-ascii?Q?I5buAUT0Q/yrYCRFRk2f0Twshv3NZEXFuj8aINXbWbl9N3r1pdPihfU4jRRl?=
 =?us-ascii?Q?i0f9qkUwjzRRaYTES6vr7tWuDcw4IhSgnAMUawwARyIbfBCcCS1XLv2udML1?=
 =?us-ascii?Q?uesodhl8rUmQCDNMOfDAD7lu9IQbWvz/JTCUWRAQBv8uy8WpQ0tmaSo7pp42?=
 =?us-ascii?Q?BOMxFzLfW2LGXz2dUryshqinm1wqxG0RVrnblp0xUU6l5ZJUJLGzsynIGb5g?=
 =?us-ascii?Q?5qVE6xKjgj0uDXuvWu2pEZ3vQpn2VFUGNR7kmF5uAG8Lu6JxetQCGpl9+JF3?=
 =?us-ascii?Q?PLQyHlDQ3tcuq9WSu57Zv43wxaM2AxbGOnaIrkBui6SVmTw+H1iwBT4vEL9G?=
 =?us-ascii?Q?LgAoEfkStKTaeSWE+b7rB5BwoKmkfD644C42WmqG?=
X-MS-Exchange-CrossTenant-Network-Message-Id: ddf6898b-8367-4841-6715-08dbe57f0f01
X-MS-Exchange-CrossTenant-AuthSource: CY5PR11MB6392.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Nov 2023 02:03:28.1288
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ZmbcOE94gNaTJD1CzoZB3pmOBp2T6Qrbg9vqeUOcgGHptVU4uB37l9Yz1uyrrwB9ZJjJ3BSAe4hZsZ3RauUjUQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV2PR11MB6045
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
config: microblaze-defconfig (https://download.01.org/0day-ci/archive/20231114/202311141906.Ai9VGcKQ-lkp@intel.com/config)
compiler: microblaze-linux-gcc (GCC) 13.2.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20231114/202311141906.Ai9VGcKQ-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <yujie.liu@intel.com>
| Closes: https://lore.kernel.org/r/202311141906.Ai9VGcKQ-lkp@intel.com/

All errors (new ones prefixed by >>):

   microblaze-linux-ld: drivers/crypto/dwc-spacc/spacc_ahash.o: in function `zero_message_process':
>> drivers/crypto/dwc-spacc/spacc_ahash.c:427:(.text+0x284): undefined reference to `sm3_zero_message_hash'


vim +427 drivers/crypto/dwc-spacc/spacc_ahash.c

188d801c0d4bbe Pavitrakumar M 2023-11-14  417  
188d801c0d4bbe Pavitrakumar M 2023-11-14  418  static int zero_message_process(struct ahash_request *req)
188d801c0d4bbe Pavitrakumar M 2023-11-14  419  {
188d801c0d4bbe Pavitrakumar M 2023-11-14  420  	struct crypto_ahash *tfm = crypto_ahash_reqtfm(req);
188d801c0d4bbe Pavitrakumar M 2023-11-14  421  	int digest_sz = crypto_ahash_digestsize(tfm);
188d801c0d4bbe Pavitrakumar M 2023-11-14  422  	const struct spacc_alg *salg = spacc_tfm_ahash(&tfm->base);
188d801c0d4bbe Pavitrakumar M 2023-11-14  423  
188d801c0d4bbe Pavitrakumar M 2023-11-14  424  	switch (salg->mode->id) {
188d801c0d4bbe Pavitrakumar M 2023-11-14  425  	case CRYPTO_MODE_HASH_SM3:
188d801c0d4bbe Pavitrakumar M 2023-11-14  426  	case CRYPTO_MODE_HMAC_SM3:
188d801c0d4bbe Pavitrakumar M 2023-11-14 @427  		memcpy(req->result, sm3_zero_message_hash, digest_sz);
188d801c0d4bbe Pavitrakumar M 2023-11-14  428  		break;
188d801c0d4bbe Pavitrakumar M 2023-11-14  429  
188d801c0d4bbe Pavitrakumar M 2023-11-14  430  	case CRYPTO_MODE_HMAC_SHA224:
188d801c0d4bbe Pavitrakumar M 2023-11-14  431  	case CRYPTO_MODE_HASH_SHA224:
188d801c0d4bbe Pavitrakumar M 2023-11-14  432  		memcpy(req->result, sha224_zero_message_hash, digest_sz);
188d801c0d4bbe Pavitrakumar M 2023-11-14  433  		break;
188d801c0d4bbe Pavitrakumar M 2023-11-14  434  
188d801c0d4bbe Pavitrakumar M 2023-11-14  435  	case CRYPTO_MODE_HMAC_SHA256:
188d801c0d4bbe Pavitrakumar M 2023-11-14  436  	case CRYPTO_MODE_HASH_SHA256:
188d801c0d4bbe Pavitrakumar M 2023-11-14  437  		memcpy(req->result, sha256_zero_message_hash, digest_sz);
188d801c0d4bbe Pavitrakumar M 2023-11-14  438  		break;
188d801c0d4bbe Pavitrakumar M 2023-11-14  439  
188d801c0d4bbe Pavitrakumar M 2023-11-14  440  	case CRYPTO_MODE_HMAC_SHA384:
188d801c0d4bbe Pavitrakumar M 2023-11-14  441  	case CRYPTO_MODE_HASH_SHA384:
188d801c0d4bbe Pavitrakumar M 2023-11-14  442  		memcpy(req->result, sha384_zero_message_hash, digest_sz);
188d801c0d4bbe Pavitrakumar M 2023-11-14  443  		break;
188d801c0d4bbe Pavitrakumar M 2023-11-14  444  
188d801c0d4bbe Pavitrakumar M 2023-11-14  445  	case CRYPTO_MODE_HMAC_SHA512:
188d801c0d4bbe Pavitrakumar M 2023-11-14  446  	case CRYPTO_MODE_HASH_SHA512:
188d801c0d4bbe Pavitrakumar M 2023-11-14  447  		memcpy(req->result, sha512_zero_message_hash, digest_sz);
188d801c0d4bbe Pavitrakumar M 2023-11-14  448  		break;
188d801c0d4bbe Pavitrakumar M 2023-11-14  449  
188d801c0d4bbe Pavitrakumar M 2023-11-14  450  	case CRYPTO_MODE_HMAC_MD5:
188d801c0d4bbe Pavitrakumar M 2023-11-14  451  	case CRYPTO_MODE_HASH_MD5:
188d801c0d4bbe Pavitrakumar M 2023-11-14  452  		memcpy(req->result, md5_zero_message_hash, digest_sz);
188d801c0d4bbe Pavitrakumar M 2023-11-14  453  		break;
188d801c0d4bbe Pavitrakumar M 2023-11-14  454  
188d801c0d4bbe Pavitrakumar M 2023-11-14  455  	case CRYPTO_MODE_HMAC_SHA1:
188d801c0d4bbe Pavitrakumar M 2023-11-14  456  	case CRYPTO_MODE_HASH_SHA1:
188d801c0d4bbe Pavitrakumar M 2023-11-14  457  		memcpy(req->result, sha1_zero_message_hash, digest_sz);
188d801c0d4bbe Pavitrakumar M 2023-11-14  458  		break;
188d801c0d4bbe Pavitrakumar M 2023-11-14  459  
188d801c0d4bbe Pavitrakumar M 2023-11-14  460  	case CRYPTO_MODE_MAC_XCBC:
188d801c0d4bbe Pavitrakumar M 2023-11-14  461  		memcpy(req->result, xcbc_aes_zero_message_hash, digest_sz);
188d801c0d4bbe Pavitrakumar M 2023-11-14  462  		break;
188d801c0d4bbe Pavitrakumar M 2023-11-14  463  
188d801c0d4bbe Pavitrakumar M 2023-11-14  464  	case CRYPTO_MODE_MAC_CMAC:
188d801c0d4bbe Pavitrakumar M 2023-11-14  465  		memcpy(req->result, cmac_aes_zero_message_hash, digest_sz);
188d801c0d4bbe Pavitrakumar M 2023-11-14  466  		break;
188d801c0d4bbe Pavitrakumar M 2023-11-14  467  
188d801c0d4bbe Pavitrakumar M 2023-11-14  468  	case CRYPTO_MODE_HASH_SHA3_224:
188d801c0d4bbe Pavitrakumar M 2023-11-14  469  		memcpy(req->result, sha3_224_zero_message_hash, digest_sz);
188d801c0d4bbe Pavitrakumar M 2023-11-14  470  		break;
188d801c0d4bbe Pavitrakumar M 2023-11-14  471  
188d801c0d4bbe Pavitrakumar M 2023-11-14  472  	case CRYPTO_MODE_HASH_SHA3_256:
188d801c0d4bbe Pavitrakumar M 2023-11-14  473  		memcpy(req->result, sha3_256_zero_message_hash, digest_sz);
188d801c0d4bbe Pavitrakumar M 2023-11-14  474  		break;
188d801c0d4bbe Pavitrakumar M 2023-11-14  475  
188d801c0d4bbe Pavitrakumar M 2023-11-14  476  	case CRYPTO_MODE_HASH_SHA3_384:
188d801c0d4bbe Pavitrakumar M 2023-11-14  477  		memcpy(req->result, sha3_384_zero_message_hash, digest_sz);
188d801c0d4bbe Pavitrakumar M 2023-11-14  478  		break;
188d801c0d4bbe Pavitrakumar M 2023-11-14  479  
188d801c0d4bbe Pavitrakumar M 2023-11-14  480  	case CRYPTO_MODE_HASH_SHA3_512:
188d801c0d4bbe Pavitrakumar M 2023-11-14  481  		memcpy(req->result, sha3_512_zero_message_hash, digest_sz);
188d801c0d4bbe Pavitrakumar M 2023-11-14  482  		break;
188d801c0d4bbe Pavitrakumar M 2023-11-14  483  
188d801c0d4bbe Pavitrakumar M 2023-11-14  484  	case CRYPTO_MODE_MAC_MICHAEL:
188d801c0d4bbe Pavitrakumar M 2023-11-14  485  		memcpy(req->result, michael_mic_zero_message_hash, digest_sz);
188d801c0d4bbe Pavitrakumar M 2023-11-14  486  		break;
188d801c0d4bbe Pavitrakumar M 2023-11-14  487  
188d801c0d4bbe Pavitrakumar M 2023-11-14  488  	case CRYPTO_MODE_MAC_SM4_XCBC:
188d801c0d4bbe Pavitrakumar M 2023-11-14  489  		memcpy(req->result, sm4_xcbc128_zero_message_hash, digest_sz);
188d801c0d4bbe Pavitrakumar M 2023-11-14  490  		break;
188d801c0d4bbe Pavitrakumar M 2023-11-14  491  
188d801c0d4bbe Pavitrakumar M 2023-11-14  492  	default:
188d801c0d4bbe Pavitrakumar M 2023-11-14  493  		return -EINVAL;
188d801c0d4bbe Pavitrakumar M 2023-11-14  494  	}
188d801c0d4bbe Pavitrakumar M 2023-11-14  495  
188d801c0d4bbe Pavitrakumar M 2023-11-14  496  	return 0;
188d801c0d4bbe Pavitrakumar M 2023-11-14  497  }
188d801c0d4bbe Pavitrakumar M 2023-11-14  498  

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

