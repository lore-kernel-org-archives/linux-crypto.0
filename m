Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1CD17CA0FE2
	for <linux-crypto@archiver.kernel.org>; Tue,  5 Sep 2023 16:20:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244783AbjIEQUZ (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 5 Sep 2023 12:20:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354314AbjIEKlc (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 5 Sep 2023 06:41:32 -0400
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E011199;
        Tue,  5 Sep 2023 03:41:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1693910489; x=1725446489;
  h=date:from:to:cc:subject:message-id:
   content-transfer-encoding:mime-version;
  bh=P7PT+TjivkSQxFH4lsFAmrAuaPkuLMh7mWrYlXX7Q5c=;
  b=gVBCkbQ1r+PQI8+DeTcRaYAKe8Bvj4D8k1GaaT1sZeLRzWIqT9o2hWsg
   Tfkt8HjPMunPVMlcOZfPImPfoBqd2oSVo0x8ch6+OvYnI7Nr77NqnWbuf
   hpT6wcWAEhvEwm97H9H+opdXPbglyhuFale99nEcmKJgUI24FTPnc5Cmu
   q8o9BttKdhr8uXUa3JC/qQtALgowh7zqBLB7HOr+WDOoI37DYE9OCE9sB
   Xr4iTv/qoKFFbltihLHFL3CbtDJ1WZD+sx+b7O210e1XZD1wSA0Daj9pt
   B6Sqqkkl0J66DFB1Hm96sZuN2V2wWsBRhmHJL8s4twj1Yixwzt/UL/B0G
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10823"; a="361791710"
X-IronPort-AV: E=Sophos;i="6.02,229,1688454000"; 
   d="scan'208";a="361791710"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Sep 2023 03:41:28 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10823"; a="741063363"
X-IronPort-AV: E=Sophos;i="6.02,229,1688454000"; 
   d="scan'208";a="741063363"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orsmga002.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 05 Sep 2023 03:41:28 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Tue, 5 Sep 2023 03:41:28 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Tue, 5 Sep 2023 03:41:27 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27 via Frontend Transport; Tue, 5 Sep 2023 03:41:27 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.101)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.27; Tue, 5 Sep 2023 03:41:27 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ecj2owj1KF5FmL2W6wbnW7Rqx5S7ZXtk5yxbvmWKKXTNIpqVm8eta9n3uMtpS/8vJo1mwmlOfRKWsRbePpU8vfnpeANLweSmFG2a6XMcbO4y7Q7d4D8SAmvUZ9U9kPo34aPa8d/s2LtI6rtnyvJHVeyvdmie0QH5Nii0ireKnOYSjxfaNqVHk/EZesmIG50EPy7Vd7f8Vsyobi9UvYjNH/mmOjdPXWVeghiCtKpFF/tZJbdLPirsvTxn5SuoHT3UhIzk16YgeLAVRXRuHCQKluQpR54LH/4nCU2qmD+Ae5X71LUZF+I5ttJY1af/831lY1enTzlSIDFp8VxfrOzSSg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NSpOuBnlp+/XlQb3XTqL8qeLlNgLkhY/JsoUeyDhIo4=;
 b=XH0O0yvx4+vB09YHqKx+xIGPxpxOhQO0N3+k+oVN2VpoL7LlHNl8LYeR4zCjbcavZHoAv1Ewu28+tDkYlV/HcyEIvjCZWLX7u1zwLZSXB8YYxIEzjP+ZfSYx7lrRbWmJpCOfjMMoqYdGgwrZ9UNvSSAX0hKk34grBIT8DigAWFNIIshYCvLrStQIgESOZevyK7VxI41wcQi5HMoV8hGZWOsQEFw8tEJDvr6aPU3HbxmgrpESBNdi+eJDcl4GkNwYundhNCd9qf4BcuFj8+WBROG2NEa8BEDGvdSHhzQqw88TNo6b4r6t1eevo8TqFh6foIFpd5TjGt1Eto0Ijgr5sw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CY5PR11MB6366.namprd11.prod.outlook.com (2603:10b6:930:3a::8)
 by IA0PR11MB7696.namprd11.prod.outlook.com (2603:10b6:208:403::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6745.28; Tue, 5 Sep
 2023 10:41:25 +0000
Received: from CY5PR11MB6366.namprd11.prod.outlook.com
 ([fe80::f8a8:855c:2d19:9ac1]) by CY5PR11MB6366.namprd11.prod.outlook.com
 ([fe80::f8a8:855c:2d19:9ac1%6]) with mapi id 15.20.6745.030; Tue, 5 Sep 2023
 10:41:24 +0000
Date:   Tue, 5 Sep 2023 11:41:14 +0100
From:   Giovanni Cabiddu <giovanni.cabiddu@intel.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        Sasha Levin <sashal@kernel.org>, <linux-crypto@vger.kernel.org>
CC:     <qat-linux@intel.com>, <stable@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Bug in rsa-pkcs1pad in 6.1 and 5.15
Message-ID: <ZPcFyp4jdE3uSeqW@gcabiddu-mobl1.ger.corp.intel.com>
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Organization: Intel Research and Development Ireland Ltd - Co. Reg. #308263 -
 Collinstown Industrial Park, Leixlip, County Kildare - Ireland
X-ClientProxiedBy: DBBPR09CA0006.eurprd09.prod.outlook.com
 (2603:10a6:10:c0::18) To CY5PR11MB6366.namprd11.prod.outlook.com
 (2603:10b6:930:3a::8)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY5PR11MB6366:EE_|IA0PR11MB7696:EE_
X-MS-Office365-Filtering-Correlation-Id: ba70726d-fd68-45c8-ba65-08dbadfca6d8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: TvO4cZeR80vJwwaqe1S23Jk2OGm0MtzoEWlPLQyaLz4WbL/XHm+VUj4yMV1YFQerfpOLicYbJzPftZRldwtRjEkVzvatzTTJzx3AwHmmIz5ptKmr4so8N+QVYnB2jB76A7U4aU0OpjX0hn+iyLXLJxeRvzddlUhier0rtLSJ/VYElBJGgc9W6L9MXNZ6X9SdmEdya1kEv5pbw0PFiWPVOej3WhrV/LjKO6kviruMCgLrSncn4ikKEBflYFIL9wu4MRv5qq8xI0wRvFyhia4k1+mrSn7vgdPHuPaTobgirFu/yx44nMlEokZCfAn5Z67qjHfb4WRBS1LaZcKtQxqOOfDuo1opTGLb4QuBMxP3m8u/7SABXQvcb6WDs3psLlpqCdCotb74/7MxmFjrKVuoZl8QnC+bNipgTNvyRRFvufFhFAFYG7sqNgAt/fRxlSq58qBpNZlUxIkWZ7AyzUiCykNBUX9XYVMbTz6w2uVmsvQ1KofOM4MgUEaqFzGOzTfKYzSpo7CYJ21l4e0hOrdmGIwJcu3W1NOPWvHpPeMds0Dav/a0sdCASabHhFHMKrjTclk854h7iov0QQdWbhsteqqasnZqoeH52iJafqdlPtc=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR11MB6366.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(346002)(39860400002)(376002)(366004)(396003)(136003)(451199024)(186009)(1800799009)(83380400001)(82960400001)(44832011)(5660300002)(86362001)(41300700001)(38100700002)(66556008)(26005)(66946007)(66476007)(478600001)(6506007)(110136005)(6666004)(966005)(6512007)(4326008)(8676002)(8936002)(316002)(6486002)(2906002)(36916002)(473944003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?eEdVM0FXU01IcnRrVTR6SW16WVV6TUF3aG5OMjNwK3NvWHZoMmxVdnpEUGRu?=
 =?utf-8?B?VEZqVnkxMlVRbGxwZE5Ib0l6VjkreXNXUE5MOUJNWU1BZVRwSDV0eWlQYTI2?=
 =?utf-8?B?VDVOWmRRQVBpeGZMRktoMHFvaUEvMERDRjAwUXF3RGE4NzljdTdtdDNzM25o?=
 =?utf-8?B?V1gzZUl0UDlaS2pxZklaR3k5UVNXM0ZDTjQ1SzcwQm1XOEN5QzVQdWR1UWpU?=
 =?utf-8?B?bWQxMjQrY2lEOGpCdTdraWxoZlhBK1FWRmgxZER6RmlGcTFnRmpZZlpJMGVu?=
 =?utf-8?B?MjRuQ1ZTNG9UN3FGT0FiUEE3bmZ0dVh0VWt2ak45dkEwZ0dqQ3BhdmdBdDlw?=
 =?utf-8?B?UjVPb1NMYm8vcFFPdGZiMVBXNkhVWmp5YTZPbWtPeVJIMVhyM253MVNvY2RH?=
 =?utf-8?B?QXYyOGVMRG1jaFNaYnFXbWJXRzJvTWJ0VVFsYXNmc1k4Mjg2NzlyckpjTGEr?=
 =?utf-8?B?cXdmam9NSEFOZG03TjlxM1NXeXN4My9WK0xWQjRrSVN6TFRiT2FQb3dDRWhU?=
 =?utf-8?B?WHhoUGc5MkZHZm5KT3IyalpjYUhSV2JrbTQwdy81VlhmaXFiaGMyc29YZ0dN?=
 =?utf-8?B?NHVyUm0zRE5xN21ENk5qdmt2dGMrdHErbUJOemliZXdHdmVsTk5zR3BlTkVn?=
 =?utf-8?B?Z1JDbW9nSzEwb216aTdOYWFwWlFOSGpVUmVvQXZwV3gxekN1Z2hzdEJuSWFm?=
 =?utf-8?B?Rm9TNEpoSjdwRnpRVzdhTUVwSDRrVXpkWnpGeWJFbWFNWENlYlZFQnpmZE1R?=
 =?utf-8?B?aEVtb3laaytza1hTLzNMOHluaVpYOGhlaUU1SXIwR040SmRINzZmTjZxUFFM?=
 =?utf-8?B?SzZXMmFYdzlWanZvSDhiV29zNStzWmVCNmtHTkV6U05uSElCNiszKzI2OXlY?=
 =?utf-8?B?WERsNm00dmVuck5YNmFYa21CT0t1K3BIY0dOaDh2R000TFNIT0VLdFExOVpJ?=
 =?utf-8?B?aEx6dVVWaEdtSEJSVU92b1VMQTV2TmFQeE1Gamp6N0VtaFRLMkQxSXg5TTY5?=
 =?utf-8?B?MmRTMGppUTBuWlh1ZWtIai8zbXMyZ3FzUmVZVUpYMDcyY2RUcmtDSmhvdnVr?=
 =?utf-8?B?TnJUb2l6SHpNeHVDWGwyVjFiWEpzVU5OeEFRbXIxVE9vWHkwbDBvZ0g3dWRx?=
 =?utf-8?B?R1hEenV5NzlBS0svb0tQeVc0dzFZeThVdmppRjM4R2I1eHF5cWRwODNKQjMw?=
 =?utf-8?B?VnBQU1N0Y1NXM2NQTktDZEUxZ0c1T3hzcGxVNjIvajNadFZqQzNVQXN2SUU2?=
 =?utf-8?B?K0lOY0lCWEFXc2V3ZG52UHRhNUEvRDhiREpFUm1CVExoOW8rd29OYnVkelI2?=
 =?utf-8?B?ZytrVytaSnV1UzNHb1IzbElPbmNoTkZ1dGliNm5NNHVMUFdLcFFuNk0xZW0r?=
 =?utf-8?B?WUJ2clRQL3R4d3VMMitMUTI1NUtjRkt4amxESGxWU01HcURyZDF6TDd2SXFm?=
 =?utf-8?B?K0wzZEFBM0VqaVpJVlBlVjFBeWJOa2pFTG9YSXRoNDM3aFE3KzNOdnFHRWw0?=
 =?utf-8?B?V0VJVGwyV0t1VFA2RmZrcGtDbVgzdWh0WE5hRU52NWRVby9hbHVxSGFycXZF?=
 =?utf-8?B?T2RxY2R3WlNLc2R6RjhkU1hyVktnTTlqbnhBb2RWcmFJRHFvd21GVkRDeW5M?=
 =?utf-8?B?ckk4cWxodkFqZlk1SGtnUG9QaUx3bVdXYm56Z0tlTGdMdkpSQTcyU1BJeUhR?=
 =?utf-8?B?eFBRbUplM1RZUnovNnpuNHNJMTJoOXJLaFk2Vkw5N2xpVGRWWCtrWnhiQmdl?=
 =?utf-8?B?K0hEcUtwbDFIbTdJdmRIUDNXeUlRSHA1UGdJWGg1eEhFcWFqOWczWnVEclhx?=
 =?utf-8?B?c3FoQnNXMEY0dnpzNE5LL0ZpaHlrUnlCMTJGZ2paZE9UaHpmMlhHaWFtQmFG?=
 =?utf-8?B?Rm5ZbUdKNGNtR0JJUFFqWjZpakpweXAvOVlPaUFqY003SWp4dlZPNTZidVJa?=
 =?utf-8?B?czVoRHljRjhObUxVQ0RHQllxYWxZUmN2R3BVOWRJSjlpZXZmZVRKeGFXZ3BV?=
 =?utf-8?B?Wlg2d0FGaEVrZjE4THdJTHljS0swM2JLSWhJVzdvMXFIM0NuYjVyaVlLTGFM?=
 =?utf-8?B?YisrNS9BamF1bnBlQnhnSW9SbElGM2I5dlpyQ01JNlFRWkR5bGY2QXVlY2Rm?=
 =?utf-8?B?V1RlU1ZkTVRKOFFOa3Y0SnhoRGxwZGIrT3laVm1WUE5sV1lqQXZjK2dFckNS?=
 =?utf-8?B?M2c9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: ba70726d-fd68-45c8-ba65-08dbadfca6d8
X-MS-Exchange-CrossTenant-AuthSource: CY5PR11MB6366.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Sep 2023 10:41:24.6562
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: nWlLo07LQ3HB8zPIxe4jVAOTymClig6UJnjkalY9pnVe8v57GeGWWYPu8lRLcYoyw1zxVWhDWunIpJqBK+0xso1JAmawGayk64G/csg4j24=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR11MB7696
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

There is a missing backport in the stables 6.1.x and 5.15.x that
combined with a backported patch as a dependency in the QAT driver
causes a kernel crash at boot under certain conditions.

In 6.1/5.15, the function pkcs1pad_create() in rsa-pkcs1pad.c [1] sets the
reqsize of its akcipher_instance using the value in the akcipher_alg of
the selected akcipher implementation. This assumes that the reqsize
field has been set for the akcipher implementation when the akcipher_alg
has been instantiated. The reqsize field is then used to allocate to
allocate memory for pkcs1pad requests.

In commit 80e62ad58db0 ("crypto: qat - Use helper to set reqsize"), the
reqsize for the rsa implementation in the QAT driver is moved from being
set in the akcipher_alg to being set when the tfm is initialized. This
means that the implementation of rsa-pkcs1pad won’t allocate any space
for the akcipher request when using the QAT driver.

This issue occurs only when CONFIG_CRYPTO_MANAGER_DISABLE_TESTS is not
set. When the crypto self-test is run, the correct value of the reqsize
is stored in the akcipher_alg in the qat driver by the first call to
akcipher_set_reqsize() and then when pkcs1pad_create() is executed, it
finds the correct value.

Options:
  1. Cherry-pick 5b11d1a360ea ("crypto: rsa-pkcs1pad - Use helper to set
     reqsize") to both 6.1.x and 5.15.x trees.
  2. Revert upstream commit 80e62ad58db0 ("crypto: qat - Use helper
     to set reqsize").
     In 6.1 revert da1729e6619c414f34ce679247721603ebb957dc
     In 5.15 revert 3894f5880f968f81c6f3ed37d96bdea01441a8b7

Option #1 is preferred as the same problem might be impacting other
akcipher implementations besides QAT. Option #2 is just specific to the
QAT driver.

@Herbert, can you have a quick look in case I missed something? I tried
both options in 6.1.51 and they appear to resolve the problem.

Thanks,

[1] https://elixir.bootlin.com/linux/v6.1.51/source/crypto/rsa-pkcs1pad.c#L673

-- 
Giovanni
