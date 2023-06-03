Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3DEC6C77B7A
	for <linux-crypto@archiver.kernel.org>; Sat,  3 Jun 2023 08:24:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229658AbjFCIYX (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 3 Jun 2023 04:24:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229722AbjFCIYW (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 3 Jun 2023 04:24:22 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18801E56
        for <linux-crypto@vger.kernel.org>; Sat,  3 Jun 2023 01:24:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1685780660; x=1717316660;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=bTmHxS5gWAum0zYENv0I1/xlacN07HIgXDCrsgATVLA=;
  b=hfebDDbRJI4jrJxsGG16kgEisrJlsXbjPDMMlbEvWazTRsTxLvUFyLoK
   zIH9iakjkSWrNkk66eE5cIr5Rm1DCgiuZuWynlYLUY4gKgkw/UvyRCL7/
   tuOXXzFKyc4UPTr3MxF7UD9f6K0upu2uD2u1AY5y5YF4/q63khpkpWlFa
   RKFw12mvVH0Cs1sJAd6PFPECfAaEosS41aYvRb/Rnd454yH5DjmVkm1Nm
   l2U5XPjsJCSR0LeqSqypw2/Cv0wTj5524CoTSeVNAHA2QuHgqPayRqQwN
   791wV1tirX7kQ8hCd6UlbFGVxM8v+dV/dUuFN/ZvmSMhqDWjwsHt/EsA5
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10729"; a="359358447"
X-IronPort-AV: E=Sophos;i="6.00,215,1681196400"; 
   d="scan'208";a="359358447"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Jun 2023 01:24:19 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10729"; a="685566655"
X-IronPort-AV: E=Sophos;i="6.00,215,1681196400"; 
   d="scan'208";a="685566655"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orsmga006.jf.intel.com with ESMTP; 03 Jun 2023 01:24:18 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Sat, 3 Jun 2023 01:24:17 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Sat, 3 Jun 2023 01:24:17 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.109)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Sat, 3 Jun 2023 01:24:17 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ppqz1r0JgumRMPycOvOTi5R4CVc+4Xsp6Ihb7yWONE8EVxrnsjNnLCYyycBgWtg/Eue9utzdLTWIXeS7xOsnL5pee1biGhgA9uY8To6SR0VDYcKFpT7e2NqXjUspPPPj8Zj8eDHTv7pEejeLDn7aFJkNDDzZ+MkyG+R5KcohGI6kwnE8dVYL8P/rVzTu7B44RKWjwqZ/NV8A0rUmasNhq+jyeMcoTLCvFEG7X1o1sDOwcYcOc0Q982RBGblEGnD03AtBR3aeSNxuH51vn0+ddhwtgju+joBEZPnQwshxbU1OCdQSnFNO71G0ZsUOOJoWAOjA/g13PLM1L3ElTPfDkg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NAiVoBHGw9ywMwuKMYRoVIpGLcWn1nP0zwG6ilS/rX8=;
 b=dbgjJYreqpmRdr7A9FK3mgmQuEQPz9Wn15IK+Y+/Cr6MHch+0MjjDOTLMSFG3Z/f+9UOT2dux1mExwEGA9R3WJMytPSQ/yGfAZ6UNYCgRThIm6mmi9vemHXbqw7SoAvysNlawzocgLhkoWBHtq9FpEY2jIaTr8hDSO0bVPXbYIPdZOLin695PVn+JFZSrq1cJrnIuf+cdMZpMG3sukoi4PwkoNUEcPg9jP8sBYWUcYHAO7gsNEYq2Dvg7mdOLxLGaJVGuGNC4VSMEe6WX92R9k3B2nOLDOle52fLzFxkBUO/pZ+GJ3IbirGxpV0zqGr+Z/bP1d76Buq2huyF/YiKtA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CY5PR11MB6366.namprd11.prod.outlook.com (2603:10b6:930:3a::8)
 by CY8PR11MB6939.namprd11.prod.outlook.com (2603:10b6:930:59::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.28; Sat, 3 Jun
 2023 08:24:15 +0000
Received: from CY5PR11MB6366.namprd11.prod.outlook.com
 ([fe80::db49:ca8a:d7b0:8714]) by CY5PR11MB6366.namprd11.prod.outlook.com
 ([fe80::db49:ca8a:d7b0:8714%7]) with mapi id 15.20.6433.018; Sat, 3 Jun 2023
 08:24:15 +0000
Date:   Sat, 3 Jun 2023 09:24:04 +0100
From:   Giovanni Cabiddu <giovanni.cabiddu@intel.com>
To:     kernel test robot <lkp@intel.com>
CC:     Damian Muszynski <damian.muszynski@intel.com>,
        <oe-kbuild-all@lists.linux.dev>, <linux-crypto@vger.kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>, <qat-linux@intel.com>
Subject: Re: [herbert-cryptodev-2.6:master 45/47]
 drivers/crypto/intel/qat/qat_dh895xcc/adf_drv.c:69:9: error: implicit
 declaration of function 'adf_dbgfs_exit'; did you mean 'adf_dbgfs_init'?
Message-ID: <ZHr4pBcuYGkDvtUd@gcabiddu-mobl1.ger.corp.intel.com>
References: <202306030654.5t4qkyN1-lkp@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <202306030654.5t4qkyN1-lkp@intel.com>
Organization: Intel Research and Development Ireland Ltd - Co. Reg. #308263 -
 Collinstown Industrial Park, Leixlip, County Kildare - Ireland
X-ClientProxiedBy: LO4P265CA0087.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:2bd::18) To CY5PR11MB6366.namprd11.prod.outlook.com
 (2603:10b6:930:3a::8)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY5PR11MB6366:EE_|CY8PR11MB6939:EE_
X-MS-Office365-Filtering-Correlation-Id: 2b15b657-c298-4421-8dd7-08db640beacb
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Gk/d7VAZR/7fsRa0W4l04ExqG9W7+dkYY1eHVsuSxPdwIU4yqY+yOfCoTV3aHVlPKVRRiERWvUivebkIxy8SyVKc0qLcBkNRH4HBB7nPojcm5XXjpq2rDYWpcijbCD6svvY4iY1Sa3DMFurmsPs3jYPILnMUOhpTRiAMNP2FoNgJj9GswqxFl/gC2mVJZkNsWuc2/SQj30Cwr/frzIThrexh6OFjPsWeuJ2VfFi54rewXiND6yLdSG7w+/UTq6cSVmoixhDh+wAtGU8N/kjZvfdYILKjdFjq7WMS4/N9qWnqBlidJi1gGCM3Wtt9RFKoeggnZ4YE4y7VAe+Oy8wJMWcWlpJjVbgZ0O9Q0SYKifVSm+ulWUR3DlZaC1vFR6UDH8WoVbMMcRYNgScQDOPCmkX1FALeqUzEoOX/v9Ce4Qu+RYlcDmo42bW0SFDqrvBkeGVrXtg97uN2fovmpVXrYKlYrLTvTC3reOjWzoECNlkg3SF/Cx/fwN6WhklgNxYbwqOAw9iAWatXhfAed2qnqj3AQbZ+iV7hSwumF3f8qNoR9QCBnyewFu7ZmrEbqxuZx2X1KhIlixyCZplD/2EIfg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR11MB6366.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(366004)(136003)(39860400002)(396003)(376002)(346002)(451199021)(83380400001)(2906002)(86362001)(38100700002)(82960400001)(966005)(6486002)(41300700001)(316002)(6666004)(36916002)(5660300002)(8676002)(8936002)(6862004)(54906003)(478600001)(66556008)(66946007)(66476007)(6636002)(4326008)(6512007)(6506007)(26005)(186003)(107886003)(44832011);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?oh0p6ysbTpm96f0aAT9FAZuMX4CROelBIhDAlg6qBvlnjetIkjDCtMF7/9CI?=
 =?us-ascii?Q?FrBVGrEK5xpWlMaLSduLgRaCn9P30KVpOaVK5BaZRfxrl6IITL0FKDFowJhh?=
 =?us-ascii?Q?ahupbhLSZVb1vzlPU7h0XZEm26U+4otFP/dRzmwTIVIATiWxghwCo3FaD5g9?=
 =?us-ascii?Q?qQqz5NAQPHWXsHUW8oqVzBDFRhDsf7uTDzRaCi2ikXfw4j9K5h+FGCYDXA/E?=
 =?us-ascii?Q?Lh9Txe1DpGExCX2Ni0ZQJ2SoPnA4n2ukqFO7X6v+0FRqQQIWYQ49YRMpza1j?=
 =?us-ascii?Q?xOmjtmrkU++wi9gtNdD7zBcRBqLc2oZEkhqDvBTup881rtL2hHdfQUXqlD/H?=
 =?us-ascii?Q?JIa/g3iVWpe5zIB2MWvrWe3ixX8xN/oNSDSwEWQ/ZKAmGnat258g5keBI1Qs?=
 =?us-ascii?Q?Psn2eoo06AiD09Gxpy21tlHV2SmU+/4uhFql8ifR5Zx+QAfqdl4X2pAxy/D1?=
 =?us-ascii?Q?fCIZz3uZ/zlwRjKVoqD6CWRhk9lJJDq8tkiFWlmzjKdFhNZWVvegSiqthWwl?=
 =?us-ascii?Q?bgRpG5KEVjXMv3PFE5DeRZ6xqA7Lz/QDwAM/VUd2c4SD9QrMkXXni1kKYHMD?=
 =?us-ascii?Q?CT8acvHI0GkG6SoolNXNcJ2hVVjZCN4bGR8Z4s2yzFxy+zASXp7x+bxumyIa?=
 =?us-ascii?Q?LU5TIPZXVCsuU4DL1NkDKNmwATazw5nOwBFmBSwx4WkaeEuQLPt7q2cthhlx?=
 =?us-ascii?Q?0louAhPxRJZ/bnTkAqZQgrqRpWJEskA33WPDHWNZ5neyHOn2AWwsFwDQh2pr?=
 =?us-ascii?Q?0/jNciFHJJLCUPSYU/mDZs7mflzwdWuqewvQf0UZPKjpYVQaSuN4pjBPVTmH?=
 =?us-ascii?Q?F4RnWJtJvPovlskeb5u7lszoiNxJzYqaWeGtzdPLhCJ9CGVyXLtQ/wdxApua?=
 =?us-ascii?Q?m0CEgCkxi/1dPuJSX3XAU+UQGu6AFhT6Hg+50P9LZ+LlPfBmnBolu4AfRbaF?=
 =?us-ascii?Q?HrNF10mTaDUFkoHiNR76quQCpA1XHNCFzzrkrWnCvkzYDoG0vnIutE6E565N?=
 =?us-ascii?Q?d70C7D6N71FOQDwZ+u+EisjyWFhdVoB0i6eBTTU6P5WB9D3oYpIITDotr16S?=
 =?us-ascii?Q?FRvql/AMB+AzdYqh/bN/gO4pjZMtjOzy0NSevmKQ7Kk+iQquf79F/7jqifl7?=
 =?us-ascii?Q?8wVMENp58mUe9Pc+j2pHUzADSS8MS6yxuNOpH4nchQi59NaVDLaz3uh3a1gl?=
 =?us-ascii?Q?FyF5qn5fkOC+dhL27IGepBmfeRVquj4S01NlLv+gbeJCE0SHcdTmGWVIzvt5?=
 =?us-ascii?Q?Wfq5Nev5dKrWgWaiM58VxkgpOmjwpR5Rr31VeARbkyPu7LuCFGf4192tuCFO?=
 =?us-ascii?Q?MFnuCOakugSm5NIHYYKnCTb9F0uuKN1rZBZF2UfilA7s6eMmGVojsMs9ilbw?=
 =?us-ascii?Q?XOgqLK8AlbKNpVIo3ZH9MlSumvNl6ky28OF8AxmxpNSxetganbDQ4TP1+3g6?=
 =?us-ascii?Q?xmxLp2En+sTRdAcA+p+GDifuVf2/tiK9xlpEaZGQcPChc+5AlBMniX5AuU7H?=
 =?us-ascii?Q?Ph5A9MNqPdAe7yYOqxEpOkHs11+2DeW50kpxoC/9UgpAhZEh9MfGlnnajQdA?=
 =?us-ascii?Q?q3JMB4YljpnVSPA3I4LSlgXhpn+o05HD7rDvuLHhtDoe96qEyTqzm9nc6aYG?=
 =?us-ascii?Q?4g=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 2b15b657-c298-4421-8dd7-08db640beacb
X-MS-Exchange-CrossTenant-AuthSource: CY5PR11MB6366.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Jun 2023 08:24:15.2356
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: t47nfA4qStSTiJ82Fs+vZIJOiNtUuhnwVlpWWf0f2PAZ0pYBFRdaO4VtQCmaLT4S+Oig0QwNHDSNZ5aoCV56RC1lWB/seGn6UC5xB13sRsc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR11MB6939
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Sat, Jun 03, 2023 at 06:58:35AM +0800, kernel test robot wrote:
> tree:   https://git.kernel.org/pub/scm/linux/kernel/git/herbert/cryptodev-2.6.git master
> head:   1d217fa26680b074dbb44f6183f971a5304eaf8b
> commit: 9260db6640a61ebba5348ceae7fa26307d9d5b0e [45/47] crypto: qat - move dbgfs init to separate file
> config: parisc-randconfig-r005-20230531 (https://download.01.org/0day-ci/archive/20230603/202306030654.5t4qkyN1-lkp@intel.com/config)
> compiler: hppa-linux-gcc (GCC) 12.3.0
> reproduce (this is a W=1 build):
>         mkdir -p ~/bin
>         wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
>         chmod +x ~/bin/make.cross
>         # https://git.kernel.org/pub/scm/linux/kernel/git/herbert/cryptodev-2.6.git/commit/?id=9260db6640a61ebba5348ceae7fa26307d9d5b0e
>         git remote add herbert-cryptodev-2.6 https://git.kernel.org/pub/scm/linux/kernel/git/herbert/cryptodev-2.6.git
>         git fetch --no-tags herbert-cryptodev-2.6 master
>         git checkout 9260db6640a61ebba5348ceae7fa26307d9d5b0e
>         # save the config file
>         mkdir build_dir && cp config build_dir/.config
>         COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-12.3.0 ~/bin/make.cross W=1 O=build_dir ARCH=parisc olddefconfig
>         COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-12.3.0 ~/bin/make.cross W=1 O=build_dir ARCH=parisc SHELL=/bin/bash drivers/crypto/intel/qat/qat_c3xxxvf/ drivers/crypto/intel/qat/qat_c62x/ drivers/crypto/intel/qat/qat_dh895xcc/ fs/
> 
> If you fix the issue, kindly add following tag where applicable
> | Reported-by: kernel test robot <lkp@intel.com>
> | Closes: https://lore.kernel.org/oe-kbuild-all/202306030654.5t4qkyN1-lkp@intel.com/
> 
> All errors (new ones prefixed by >>):
> 
>    drivers/crypto/intel/qat/qat_dh895xcc/adf_drv.c: In function 'adf_cleanup_accel':
> >> drivers/crypto/intel/qat/qat_dh895xcc/adf_drv.c:69:9: error: implicit declaration of function 'adf_dbgfs_exit'; did you mean 'adf_dbgfs_init'? [-Werror=implicit-function-declaration]
>       69 |         adf_dbgfs_exit(accel_dev);
>          |         ^~~~~~~~~~~~~~
>          |         adf_dbgfs_init
>    cc1: some warnings being treated as errors
adf_dbgfs.h is not defining adf_dbgfs_exit() when CONFIG_DEBUG_FS=n.

My bad. I thought I had a build with CONFIG_DEBUG_FS=n in my flow but I
just realized it is not working as expected (CONFIG_DEBUG_FS was forced
to y).

Sending a fix...

Regards,

-- 
Giovanni
