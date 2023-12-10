Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="YYe1OPx3"
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.151])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6BE6EB3
	for <linux-crypto@vger.kernel.org>; Sun, 10 Dec 2023 05:53:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1702216400; x=1733752400;
  h=date:from:to:cc:subject:message-id:in-reply-to:
   mime-version;
  bh=4cB4FA5IL1V2HlVvxg4tJkatmdeRtfDxXOacKZgApuU=;
  b=YYe1OPx3AJiciQLlVJrE/Yc7BwCEtjg8hi2A8dFSzlIRhcT+kAe3OU0q
   0PoF0iasOn/c1qZOSmP/6f0BSYIeFtzwF/TJ9UJBQcuE6imM2JV/96P81
   0xADlI24sn+Mjb48B6792JbzLOoUG9R44/8ONoknZGwq9q16ltf5dNJuB
   6UPKOoYhy2+iE8268llBbI5OCH31HDfUCmRWj5P70FF/xiZWXO5aEfnZ/
   1ud7jd6laMn/KnyeE5/lcFHJ4Ry12wURE/y63CrVre/JIGELG3teW4ksP
   x3ue6RINVdp0YWNxVPQ29GFHHWjcpfVJHooky8+AFONn/AC6apHf0uLFA
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10920"; a="374714384"
X-IronPort-AV: E=Sophos;i="6.04,265,1695711600"; 
   d="scan'208";a="374714384"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Dec 2023 05:53:20 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10920"; a="801673923"
X-IronPort-AV: E=Sophos;i="6.04,265,1695711600"; 
   d="scan'208";a="801673923"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by orsmga008.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 10 Dec 2023 05:53:19 -0800
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Sun, 10 Dec 2023 05:53:19 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Sun, 10 Dec 2023 05:53:19 -0800
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.41) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Sun, 10 Dec 2023 05:53:18 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oAQtpuC5av1gV0A1f2vbZx/TJ9v4327UWMhQudNxr2HPmUAjxR3io/A36ks6+9Ue1NAM9PvNmPQbXe21AqFg0mq6aOpQqJuv+0+5GmPalLSzkzsRBBuesq6/hcW67VaCOeh30l2jeTBYzDQHa6PaOm0XhE1pjdaHCj74GwejiM57HkbuA6Q6os5K7GS8KUWOldiQwnlhCeImFBsWl4kYxY6zqELkTOz6GuxO7sO7+zTdvovXGoX3q/yizkcG1kZmHETO3rNADCHASId1aj4bGMBguH93fhybAAuCp/NoG+K906BhttLZXmEjRijX9Vlx0khMTVmjdKc5/N1D7c4BhQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=q00S9QzoXCYSDLz368QWP4kI1U4LqhF5OZWqKz0K4kk=;
 b=JRYRcWxkkBORE0Bw6KU72vUGYr5ndMAVM5dc/808u5t2gxe5v+SZVMU85Icn0XOaWubrkSndAJWWEagJcx15vkiy8TDOsO/n4HAIn6kHzX/UHwWs1JM2NMwbCyMsJ1EqHcTsLAuIZFqQpSZRUJMEFOK+tp1Uh9G/sd1VnqF7uHYraQ8btrHjgEWiCnaXcFQrhuIQ3HhrtUTXuArZAzmtr6t/l5QmrSs2mdmO8kGReDtE918Zj0HjEITnykI/biKRzK00KRfg0AvfsPbvnL0cdnk8dID/JbS8ngrludd3I19v9thyKSyOFvQiZ1n367Nme67oYlLAoIUVJN58Ui4xRA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from LV3PR11MB8603.namprd11.prod.outlook.com (2603:10b6:408:1b6::9)
 by PH8PR11MB8061.namprd11.prod.outlook.com (2603:10b6:510:250::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7068.30; Sun, 10 Dec
 2023 13:53:16 +0000
Received: from LV3PR11MB8603.namprd11.prod.outlook.com
 ([fe80::1236:9a2e:5acd:a7f]) by LV3PR11MB8603.namprd11.prod.outlook.com
 ([fe80::1236:9a2e:5acd:a7f%3]) with mapi id 15.20.7068.031; Sun, 10 Dec 2023
 13:53:15 +0000
Date: Sun, 10 Dec 2023 21:53:06 +0800
From: kernel test robot <oliver.sang@intel.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
CC: <oe-lkp@lists.linux.dev>, <lkp@intel.com>, <linux-crypto@vger.kernel.org>,
	<ltp@lists.linux.it>, Eric Biggers <ebiggers@kernel.org>, Ard Biesheuvel
	<ardb@kernel.org>, Vadim Fedorenko <vadfed@meta.com>, <oliver.sang@intel.com>
Subject: Re: [v3 PATCH 4/4] crypto: algif_skcipher - Fix stream cipher
 chaining
Message-ID: <202312101716.7cbf38c4-oliver.sang@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <E1r9H1M-00612B-10@formenos.hmeau.com>
X-ClientProxiedBy: SI2PR01CA0028.apcprd01.prod.exchangelabs.com
 (2603:1096:4:192::21) To LV3PR11MB8603.namprd11.prod.outlook.com
 (2603:10b6:408:1b6::9)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV3PR11MB8603:EE_|PH8PR11MB8061:EE_
X-MS-Office365-Filtering-Correlation-Id: 83b89251-4fb8-433c-5e41-08dbf9875b31
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?GSQYYdU/7MwCT+TtObph3UNBydKkeJvscGY2SNT/5uiVTYz/2Qurgu2qlhTy?=
 =?us-ascii?Q?QpNXlEiTg4sv1v7lnit2382lRqaq40jsUBWfbBVajlVNWy5KzTZANFoSu1Nx?=
 =?us-ascii?Q?8Vrt3RMla+CGT9gPQ8f3lVOaCAXAanqFDEit7mRgMGQe9rZJZV2WbNqLuxNG?=
 =?us-ascii?Q?oxfGbuzFtSAUxBgfmhQMitsYZsBifY5r9CfnYPEXyJX9XqMP6gPorHwTyiiu?=
 =?us-ascii?Q?uoYE0ADXyizP2Dsvv+2soti0NgJ0Cnf57SHXUZ+ZN8QSsbxczldDHbwYGtPg?=
 =?us-ascii?Q?OF6/CdBETuATf6UuPI7qrzVbZQTj0zEpKKcYMpkgwgXhMBd544gHqwaVmOJJ?=
 =?us-ascii?Q?cz9oRizc6DvIOQ1bIXp7dLQfgJO64qmar+5d+HE9xfvvFe3qFOuRl4Te/RyC?=
 =?us-ascii?Q?aM1KjPGooTepBiEblrm3z16JHE8aIED5rQXABNNO5DmvLRlshv/Z4k0EGnJf?=
 =?us-ascii?Q?aJJ5s0lgWOWPayfRw56GKTAxJ5tgzQiGUgp8yz599/c3g88JbaLhJxPehGGM?=
 =?us-ascii?Q?Zno8znblt+XyBXqxHTA74fUE6y3u0W9qHcelT9z+qnPaOI0ua/VjB8uEDvIl?=
 =?us-ascii?Q?bL9VtEQvNbZ8kLkgdwQHW1KHVDYVH+jljbaglpD7tpfodC1PdgJTMb53tAYl?=
 =?us-ascii?Q?SQYM+nHjhxYPXAk6txQ5ENGHiaW+GTE4X/rB7EpK7DZyP8bek0PaZYxCsZmp?=
 =?us-ascii?Q?zwi1oyyZKztz1bpYQrc7GxfdvX8EWuGbujL6NqwiYMj4rz0MlER9W6EHzWBZ?=
 =?us-ascii?Q?60l9Zx4hRrQUgnhiwRr+L8FrzNlw0A2roWZwyNmA9XAyMrW4ErpMtImYciT3?=
 =?us-ascii?Q?tWwtUNHRuJBtkE/5nr03P/yyIt5S0FDd7/PPmcMcM7AxX1gEHfRzmMkRLTrd?=
 =?us-ascii?Q?4B9aK+cwf/rRrsh3t7FsvLl5/fSFAKwv+hggD4tSqucC9ucJb7AyKxNa5U05?=
 =?us-ascii?Q?yO+Ft/jFO0gq1OveVl6yT9r3cLf9X7qBVVq4bj5Z7+HfBRlXTIBnTXpzKbA/?=
 =?us-ascii?Q?Llh2DD/QKf1ZhmFmuapyvvKkFmKYUu5qHStGyurzaaZWuylh+M/h9tRpI36G?=
 =?us-ascii?Q?ayymFz3pxgK/YPASxcgDahhygBRQ+xwz0GUUXF6fz0iHfBrLL4WL91vvOiyh?=
 =?us-ascii?Q?OFubLz5svFH6S0Q0vMLxawRQMr9wbbSsnCPswaTNcIJiCjp2jY45iHBSqGJf?=
 =?us-ascii?Q?HCNnkkFUB8LZsYknT7RruYyjOm1x0g0k+grI8GKv8I+uM7b204EFUnQjCXY?=
 =?us-ascii?Q?=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:9;SRV:;IPV:NLI;SFV:SPM;H:LV3PR11MB8603.namprd11.prod.outlook.com;PTR:;CAT:OSPM;SFS:(13230031)(396003)(346002)(376002)(366004)(39860400002)(136003)(230922051799003)(230273577357003)(230173577357003)(451199024)(1800799012)(186009)(64100799003)(83380400001)(2906002)(478600001)(41300700001)(82960400001)(66556008)(66476007)(54906003)(6916009)(66946007)(966005)(6486002)(45080400002)(316002)(38100700002)(6666004)(86362001)(4326008)(8936002)(8676002)(6506007)(6512007)(36756003)(5660300002)(1076003)(107886003)(26005)(2616005);DIR:OUT;SFP:1501;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?AYvtr+Cyci4oRTEHEgHX7meU2d8+4jK6ouo2bThsRMtnDEQPmJy40YDly1n7?=
 =?us-ascii?Q?3bSGYMpJVs2CQgUO6Q8Hx6v595AIvPyK2KIB1XuzfQYedAyfFhw9nKBfJx0/?=
 =?us-ascii?Q?iIzi0nLOFj7R4QZIB4cuWLEiESfBYwncARYDMJtKxovFK9xMJNTprw834hAG?=
 =?us-ascii?Q?c2MQVkFuiwMieFZqlNuSD+P4T7aYFp3GBRodiHDc0PAbb3AzhzOEpts2meZM?=
 =?us-ascii?Q?oiYPmvrCzV+pi1TLwwhREIE7Ne2wphN9J6O9sy++/7ZwxcmCQ/UD1GV7W9jl?=
 =?us-ascii?Q?+4XePz1s0+QpVmA1GxxP4N0gFiVqo11IdwglUU6wMZRF4xLaq8ZxeCsrsWll?=
 =?us-ascii?Q?vQ3mymcTJ2db2IGKoUVTTtTQD+33EIui2MGju5AO/2GoMCHLROJXhj82dTqm?=
 =?us-ascii?Q?qTkj6RzmHKnMA7ndd15NIMBi9hsbt9LK934+NXTmUTYwxeVbnH+Z8MRrUwDk?=
 =?us-ascii?Q?+rqjVI5XHoPGHVya2w69jwUyRnP0jCPj6S3wZjes08MxwEdgyimssqmXdBuc?=
 =?us-ascii?Q?9MxzeYa9zjp4gQ22f4xrDhyLuTctNGc9RSwXp+ex3oJTEaZl0lTytxcUd046?=
 =?us-ascii?Q?xYRxtI3oaXdxy2bpZ8THHfcZWCDj2uunMzU+UutF1pfG5Ri4hJ0SOg3NGm5U?=
 =?us-ascii?Q?jcD+mxtPz9ibpqopU8sKGF/98PYckuYNE8fAgyPkrOw1dH14ox6+ySX+4kRr?=
 =?us-ascii?Q?kTj0Y/ZDZiTddEkkbriR6tW6t+ccIMKjPiBhC+kr6KR/WzkTYP9U9YeAdrq7?=
 =?us-ascii?Q?ZOd+x21u+ZEnHOtibnforz2eucBPMkVBySj3n4dwr4/9L4ZWF8KAR+6ki8ny?=
 =?us-ascii?Q?NWCw5y5MBqXu0ma6wrSp4i0X1fzm+ZKB39+3eScq36HVDQHqhSeOQc9BSpsH?=
 =?us-ascii?Q?A5ZEXF5K8y74zt6W82CWkOHtw248TbKBVF50IWxd6yGPDvva/nhUvnfMJ1jg?=
 =?us-ascii?Q?GVIyvnaTqmdhCe7w2B0enAA08wHP45/dMzS+qP7ZXRg6ON00Dt3M4V3oEndM?=
 =?us-ascii?Q?Bc28Q5eKPNpvBdkrekVbY93BKgx4pS2tVedFW2etJNw/7Nw9j5iPkkZv1jlc?=
 =?us-ascii?Q?NDvAchZCpEUIhxR3i1DEWn0KG/IjqfAdMEnYB4qL9c3yzf31iC2aZQfZkawH?=
 =?us-ascii?Q?U87rGRO7ZXwGYF4Gb8JIP0FvZhnLw6MMKIZrIevtUF4unORIopATHeILbaxS?=
 =?us-ascii?Q?xr2ivi9sl2yok43KVwoAXc1rhO8zBLqNJgwi1B5aErSHA5BAMNS1DdlZ1JM0?=
 =?us-ascii?Q?EC38WQWifMyZtspASk/sXiVA8mGICF+okDiZ7V15s/rP7b9CiiB2L+v3+x6l?=
 =?us-ascii?Q?ZGDAYvvhFPJtzwp+5Kx/xtgKNqxRZTNpBLhtrO2sgZW2E8fObulocJu4jWPc?=
 =?us-ascii?Q?wWyFuUU9lQabMU1hW8WpOfp56ATantoUFFZbg2JfaupXok+3IV8oQwa0XCQv?=
 =?us-ascii?Q?ruTTG6f6gJ1KlPOos524H5Rr/AN0hrSrmtjWpiZE79njYSaOFA37xmeB4NdS?=
 =?us-ascii?Q?gsoWPz43ghSfLHoRHFk3/5dznnDFb2iQuPuc9qXs530vimSUZeW++AZBua1W?=
 =?us-ascii?Q?rY7V8REEFcTExrjj306v6bMjQ+ERzT2y5GdfBajR?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 83b89251-4fb8-433c-5e41-08dbf9875b31
X-MS-Exchange-CrossTenant-AuthSource: LV3PR11MB8603.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Dec 2023 13:53:15.3109
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: oaHHSfmOgK8p0jejCYktcHsjN2VVAbYCjdnFfZ8MvIxI6YdWkzE5JJIzCt3JMENqg3PGEpnDswSwKtwC6q+oGQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR11MB8061
X-OriginatorOrg: intel.com



Hello,

kernel test robot noticed "WARNING:at_net/core/sock.c:#sock_kzfree_s" on:

commit: 29531d406c4f2b0f07b1d9eb4e24f5ac6b44bc05 ("[v3 PATCH 4/4] crypto: algif_skcipher - Fix stream cipher chaining")
url: https://github.com/intel-lab-lkp/linux/commits/Herbert-Xu/crypto-skcipher-Add-internal-state-support/20231202-123508
base: https://git.kernel.org/cgit/linux/kernel/git/herbert/cryptodev-2.6.git master
patch link: https://lore.kernel.org/all/E1r9H1M-00612B-10@formenos.hmeau.com/
patch subject: [v3 PATCH 4/4] crypto: algif_skcipher - Fix stream cipher chaining

in testcase: ltp
version: ltp-x86_64-14c1f76-1_20230715
with following parameters:

	test: crypto



compiler: gcc-12
test machine: 8 threads 1 sockets Intel(R) Core(TM) i7-3770K CPU @ 3.50GHz (Ivy Bridge) with 16G memory

(please refer to attached dmesg/kmsg for entire log/backtrace)



If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <oliver.sang@intel.com>
| Closes: https://lore.kernel.org/oe-lkp/202312101716.7cbf38c4-oliver.sang@intel.com



kern  :warn  : [  242.028749] ------------[ cut here ]------------
kern  :warn  : [  242.029073] WARNING: CPU: 3 PID: 3733 at net/core/sock.c:2697 sock_kzfree_s+0x38/0x40
kern  :warn  : [  242.030906] Modules linked in: sm4_generic sm4 vmac poly1305_generic libpoly1305 poly1305_x86_64 chacha_generic chacha_x86_64 libchacha chacha20poly1305 sm3_generic sm3 netconsole btrfs blake2b_generic xor raid6_pq zstd_compress libcrc32c intel_rapl_msr intel_rapl_common x86_pkg_temp_thermal sd_mod intel_powerclamp t10_pi coretemp crc64_rocksoft_generic crc64_rocksoft crc64 kvm_intel sg ipmi_devintf ipmi_msghandler i915 kvm irqbypass crct10dif_pclmul crc32_pclmul crc32c_intel ghash_clmulni_intel sha512_ssse3 rapl drm_buddy mxm_wmi intel_gtt intel_cstate ahci drm_display_helper firewire_ohci libahci ttm i2c_i801 firewire_core intel_uncore drm_kms_helper crc_itu_t libata lpc_ich video i2c_smbus wmi binfmt_misc drm fuse ip_tables
kern  :warn  : [  242.032427] CPU: 3 PID: 3733 Comm: af_alg05 Not tainted 6.7.0-rc1-00040-g29531d406c4f #1
kern  :warn  : [  242.033686] Hardware name:  /DZ77BH-55K, BIOS BHZ7710H.86A.0097.2012.1228.1346 12/28/2012
kern  :warn  : [  242.033949] RIP: 0010:sock_kzfree_s+0x38/0x40
kern  :warn  : [  242.034146] Code: 55 89 d5 53 48 89 fb 48 89 f7 e8 53 8b 82 fe 48 8d bb 48 01 00 00 be 04 00 00 00 e8 22 ad 97 fe f0 29 ab 48 01 00 00 5b 5d c3 <0f> 0b c3 0f 1f 44 00 00 f3 0f 1e fa 0f 1f 44 00 00 55 53 48 89 fb
kern  :warn  : [  242.034731] RSP: 0018:ffffc900011bfde8 EFLAGS: 00010246
kern  :warn  : [  242.034997] RAX: dffffc0000000000 RBX: ffff8881ad1d5000 RCX: 1ffff110377659a3
kern  :warn  : [  242.035308] RDX: 0000000000000000 RSI: 0000000000000000 RDI: ffff8881ad1d5000
kern  :warn  : [  242.035614] RBP: ffff8881bbb2cd00 R08: 0000000000000001 R09: ffffed1035a3aa29
kern  :warn  : [  242.035913] R10: ffff8881ad1d514b R11: ffffffff83a0009f R12: ffff8881ad1d3048
kern  :warn  : [  242.036153] R13: ffff8881a7c089a0 R14: ffff8881ad1d3048 R15: ffff88840eb21900
kern  :warn  : [  242.036455] FS:  00007f207e42c740(0000) GS:ffff888348180000(0000) knlGS:0000000000000000
kern  :warn  : [  242.036732] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
kern  :warn  : [  242.036985] CR2: 00007f89c0a5c2f0 CR3: 0000000403ede005 CR4: 00000000001706f0
kern  :warn  : [  242.037288] Call Trace:
kern  :warn  : [  242.037496]  <TASK>
kern  :warn  : [  242.037651]  ? __warn+0xcd/0x260
kern  :warn  : [  242.037828]  ? sock_kzfree_s+0x38/0x40
kern  :warn  : [  242.038013]  ? report_bug+0x267/0x2d0
kern  :warn  : [  242.038199]  ? handle_bug+0x3c/0x70
kern  :warn  : [  242.038461]  ? exc_invalid_op+0x17/0x40
kern  :warn  : [  242.038644]  ? asm_exc_invalid_op+0x1a/0x20
kern  :warn  : [  242.038854]  ? entry_SYSCALL_64_after_hwframe+0x63/0x6b
kern  :warn  : [  242.039131]  ? sock_kzfree_s+0x38/0x40
kern  :warn  : [  242.039391]  skcipher_sock_destruct+0x1af/0x280
kern  :warn  : [  242.039657]  __sk_destruct+0x46/0x4e0
kern  :warn  : [  242.039862]  af_alg_release+0x90/0xc0
kern  :warn  : [  242.040074]  __sock_release+0xa0/0x250
kern  :warn  : [  242.040435]  sock_close+0x15/0x20
kern  :warn  : [  242.040650]  __fput+0x213/0xad0
kern  :warn  : [  242.040846]  __x64_sys_close+0x7d/0xd0
kern  :warn  : [  242.041044]  do_syscall_64+0x3f/0xe0
kern  :warn  : [  242.041260]  entry_SYSCALL_64_after_hwframe+0x63/0x6b
kern  :warn  : [  242.041496] RIP: 0033:0x7f207e527780
kern  :warn  : [  242.042582] Code: 0d 00 00 00 eb b2 e8 ef f6 01 00 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 80 3d 61 1e 0e 00 00 74 17 b8 03 00 00 00 0f 05 <48> 3d 00 f0 ff ff 77 48 c3 0f 1f 80 00 00 00 00 48 83 ec 18 89 7c
kern  :warn  : [  242.043051] RSP: 002b:00007ffef7aefff8 EFLAGS: 00000202 ORIG_RAX: 0000000000000003
kern  :warn  : [  242.043430] RAX: ffffffffffffffda RBX: 0000000000000005 RCX: 00007f207e527780
kern  :warn  : [  242.043766] RDX: 000055dda9c55b00 RSI: 00007ffef7aefad0 RDI: 0000000000000005
kern  :warn  : [  242.044067] RBP: 00007ffef7af2ff0 R08: 0000000000000000 R09: 00007ffef7aeff20
kern  :warn  : [  242.044415] R10: 00007ffef7aefae6 R11: 0000000000000202 R12: 00007f207e42c6c0
kern  :warn  : [  242.044763] R13: 00007ffef7af0000 R14: 000055dda9c6b01e R15: 0000000000000000
kern  :warn  : [  242.045069]  </TASK>
kern  :warn  : [  242.045310] ---[ end trace 0000000000000000 ]---



The kernel config and materials to reproduce are available at:
https://download.01.org/0day-ci/archive/20231210/202312101716.7cbf38c4-oliver.sang@intel.com



-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

