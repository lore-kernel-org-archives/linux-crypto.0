Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 48385EB64D8
	for <linux-crypto@archiver.kernel.org>; Thu, 22 Jun 2023 11:07:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229504AbjFVLHA (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 22 Jun 2023 07:07:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57256 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230293AbjFVLGv (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 22 Jun 2023 07:06:51 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82A121BFE
        for <linux-crypto@vger.kernel.org>; Thu, 22 Jun 2023 04:06:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1687432010; x=1718968010;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=KQbgpioZAE4a1gM7lUyoqe6RGeuI4TORR2tC3Hcv/D4=;
  b=TgyB0xAMIXTFhwfQ2VEMuiHdO0vRvk/E1A1n6rvKMLx3saAPWwF8iYU8
   aYCltfTbqSjaJJtstGVjDUnWm7k5uIlU7VA3k3L4sc16vpRDBMvPnoxSN
   JfZ0G9VRDJFjDx+2vYimUVo5Tm/HV2KjeovVOHawdfDEp3lQoGW6L6CEr
   60YxlhGS/D5VtewCLRDRkjW+QB7awL6AZBlofLNNdEVkElPxaY9JHvjMV
   xFTsKzyChBf/VMEiYrY8MU/WFBnbpf1Y0ySX9H/K6J5R6Hs+y8zSe9VKT
   eF7dYd9Ou7lHCF0vshJ+wCdDoe9k+mE28ndqcXQlmk2+kemdHIWIvU9Ij
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10748"; a="340794513"
X-IronPort-AV: E=Sophos;i="6.00,263,1681196400"; 
   d="scan'208";a="340794513"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jun 2023 04:06:49 -0700
X-IronPort-AV: E=McAfee;i="6600,9927,10748"; a="749231053"
X-IronPort-AV: E=Sophos;i="6.00,263,1681196400"; 
   d="scan'208";a="749231053"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orsmga001.jf.intel.com with ESMTP; 22 Jun 2023 04:06:48 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Thu, 22 Jun 2023 04:06:49 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Thu, 22 Jun 2023 04:06:48 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Thu, 22 Jun 2023 04:06:48 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.169)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Thu, 22 Jun 2023 04:06:47 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SceQzw9Wzuj6xBVrjrHYJc9mnDPLPYKujO1w5td/BshcrXUUWRPF78qXWcSUvJLcsu8enLRUcZkrmUC8vIdx1V82g1mEsnd88e8MKWxVGTzE0klYLZP030jFSrTzjr9dgoqV9J0lLyiyOTRvKixdzhwg29oAxDuJHKgsfKPu+G40VLQO2T33LTzFIwtxBeEZrhzubr0Hj2vDUqasm3owQws+TX5rv9VJ58MIOTuwjI8OOdEEJEZYTcjtPKBPg1e9PHETpQ93OmI1hPFeKxK0ptrMqhlJ+NXbhdkdGVh8pDI1kSdtMXDs5z951ueT34rkOOC0g3CKFpnia+H7ZQ2HFQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=iGBQMVy9wMOCw8Xl5/u46+oWpJFWqIKzekO3kNdUARk=;
 b=FEIx+T6zuOo11aCr9hxmAvUbR2xgO5v3okg0Xp7J++upFxEKSEnZYzxTnCleiaukEERe7m6Bzo2kDRQSwXSLML9jw9o5H3s1uKW7YQ+IabeAnbtvvT6ecFuJz+IjsEidCFieb2Zj3YmNYs8hhGhGwR4YJNdift4Z9QMkQyH4Wyhm36Are5YD2YSshx7PimktzydCjFsw/jhlHK2zlRqoOtr0To6rctG/jxLPDRtoJ2FSqEZ1xOg8HoXczcFvJDtJijjRBw4x2AOfeRtbFQjgGRiilyqt5LTUJOE0h+fxa5bxzotIqU1Aw3HgDP74fL7QASe1jKcOkFOPelQea/gWqQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from BYAPR11MB3734.namprd11.prod.outlook.com (2603:10b6:a03:fe::29)
 by SA2PR11MB5179.namprd11.prod.outlook.com (2603:10b6:806:112::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6521.23; Thu, 22 Jun
 2023 11:06:45 +0000
Received: from BYAPR11MB3734.namprd11.prod.outlook.com
 ([fe80::13c9:30fe:b45f:6bcb]) by BYAPR11MB3734.namprd11.prod.outlook.com
 ([fe80::13c9:30fe:b45f:6bcb%4]) with mapi id 15.20.6521.024; Thu, 22 Jun 2023
 11:06:45 +0000
Date:   Thu, 22 Jun 2023 13:06:34 +0200
From:   Damian Muszynski <damian.muszynski@intel.com>
To:     <herbert@gondor.apana.org.au>
CC:     <linux-crypto@vger.kernel.org>, <qat-linux@intel.com>,
        Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: Re: [PATCH v2 0/5] crypto: qat - add heartbeat feature
Message-ID: <ZJQrOkNCoRl3UPZy@dmuszyns-mobl.ger.corp.intel.com>
References: <20230620130823.27004-1-damian.muszynski@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20230620130823.27004-1-damian.muszynski@intel.com>
Organization: Intel Technology Poland sp. z o.o. - ul. Slowackiego 173,
 80-298 Gdansk - KRS 101882 - NIP 957-07-52-316
X-ClientProxiedBy: FR3P281CA0006.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:1d::16) To BYAPR11MB3734.namprd11.prod.outlook.com
 (2603:10b6:a03:fe::29)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BYAPR11MB3734:EE_|SA2PR11MB5179:EE_
X-MS-Office365-Filtering-Correlation-Id: c2821c58-8ab5-40c3-ad43-08db7310c434
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: F2pElWI5yhd9MPP9xug7p/XbMdP9aGPzsbO/nNXCafuDSaTuHn4iQe9FGzYkvTc+AMgzCrwSeVWNv34jlVl+3gIl1eoCKWzzKFV2B/Iz+pLqJGH7N+OjaHiE5I4igNefqPt4TPtAimkZqcwCD+0W6swKoVWxtH693A5CLTspAENZD2Ozk/jhnBQkBTAnYaAX2yl1F+zF3Pg0ahJeNwliIUOJVVhijdsQlIqypDc2fj+35+hIds+4rGyWIOlUwM+GjPSiPvRKc4Ugu9mxjCHSu9fgx0HRd+JnKNOAJXWJwU91SqL1hgLsvpkBvuPoX66VJdTJ3eDVOncbGMozVntwSofAv79EC0ElOBqx/7f3gLkxQTSt6ArKxWvmRQsBg/XtFd2S7NXyNRy2wa7uBhpIDEj2WbNAOaSHDy2iSCWS5L7U2UY8Xb+uSbx2+pxPOTDlYJ7S4IYzFVJkdpfaKN4PxfeA3cMV6jvvRN7XqzZ/h7hQUONTDNaryA1j+982kUJtacGH2RfD+/oHGEmMOrcytpOh4MOXayhicg5iwK+zb+7qio6yYv5BF+g/5ByRRtpO
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR11MB3734.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(346002)(396003)(366004)(39860400002)(136003)(376002)(451199021)(36916002)(38100700002)(82960400001)(86362001)(4326008)(41300700001)(8676002)(6486002)(44832011)(5660300002)(26005)(8936002)(53546011)(6506007)(478600001)(83380400001)(186003)(2906002)(316002)(66946007)(6666004)(54906003)(66476007)(6916009)(6512007)(66556008);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?kXRQDDk5c0YIWDzb2xL0Of9HzauWkPrj6v+30c8Eib9L9mgJiFbq4mgtkHe3?=
 =?us-ascii?Q?/VFl64hGM8meP4xracgGQgzaQrP+0BNp20Pu/PqorTt1aRy/hozgLsfF4RuN?=
 =?us-ascii?Q?yDKcl4QjxQIzYiR5bxbzQlp7FYap3HT9hii9q+JnIOOUTD1RPUbc0igxYKiX?=
 =?us-ascii?Q?DSOF8Dc5jkkcWbAqymjkKvmssjHJeDc2NQKDbBKmXdhpV6lh05iq+oOlBS2v?=
 =?us-ascii?Q?fpgczxM7/U543XQm26VMYB9twN3lnYtsCrZG2XFXaUJ2JqTRt30zaeVJ8f8H?=
 =?us-ascii?Q?Bo5VypH3dG3B8DPS0SH4OV+Xsm4TwZSl6qIZCx0zfEJQ6EoPy4SICvBk2hQ1?=
 =?us-ascii?Q?C3lYpJRim0MiSF7gyeMONIiVlI9FdPRuUlM1A3ojWGjerDOljGvqv+cDeSiv?=
 =?us-ascii?Q?wezAjVwXiDn+egwFXwy/IXso8ptGWZUOlFLtDsb/p2cWo4sfbIWYPmQRyBtD?=
 =?us-ascii?Q?ia4bpX2Xueqdn+JMJUNoSQYwE8lMjLtdaTxsp7+DktuiOUnWX7zNDVP6cQR6?=
 =?us-ascii?Q?+1LjUwK98txRIFX+ifrZMkAuE0MzUfyOaCwwTb2P5x+2NvSqm3OpbzG8dHu5?=
 =?us-ascii?Q?VS0FAhXoTEXYbhCB8MDv2Ma75X/9FlTMzrTjGA0LzmS+oXIFXbSv3a9u5sj6?=
 =?us-ascii?Q?oFJuAkxK7OL5ocGS7i+DUIAju/0gdC0EwCXP/fmkMujiAaiU9aO5blGFTZ5B?=
 =?us-ascii?Q?VtChEcwM9kieLtrDXF1xpoa8qF/R6N3niDvC46eUo0z1GE3HnV1Gr443CYtW?=
 =?us-ascii?Q?z1U6deI+25dLSZ/BpK7z2zA3EDnyPWGpSnsekFLpRglZ//gGv4LgjTmU7060?=
 =?us-ascii?Q?wzbCeVfsImvRbayrK9pzHJ2R99ztUGhuZtv+ALQ1VOBFYOky/XlADgfO4Ijc?=
 =?us-ascii?Q?IECfcU3FhqFz4ZGiHhb5MvNfvh8AtUGyZ+poTChAMPr+fJOVRAViPKaJv0BC?=
 =?us-ascii?Q?R0yDd3OWIfHncjD6etrdtMqxsxcPqsoF9Jisn73epAXLnudHVDgBJ3nqFFn2?=
 =?us-ascii?Q?cBVoj88iA+AA45fcPK+uGAyY4zj6BBVcbscZja0iXM9t3ctMa6SrMPFH6mPc?=
 =?us-ascii?Q?GentGMZLfDVmmZ+Cd6ZayvTGWvqKm6UrASenhZ88x6rY4ZrPYiRcDImg2rHO?=
 =?us-ascii?Q?PWZ4IH2EQOUVJy0fCfXtfyrMCyk1iWylFWwXOAAZHedPg6RG44RWeSXlcOVL?=
 =?us-ascii?Q?0TdkMSiFuWjPEoZWuJWlgBq0ZEHDM6R0YEfqZCtFIvZwSJshJfPsfTqBVr35?=
 =?us-ascii?Q?DN3hjXapa8n2b/rUPmxfUqXUZTi6KqCQsnpijFskyPwAC6CNRvdwE1SLCiEV?=
 =?us-ascii?Q?sy6vO2zclbFCAUWDPC+fI0+kDWyxd0mTkQUBAs388Z9yUIcqE/C4XK4cbqTg?=
 =?us-ascii?Q?l53lLnSym5J8ikL7n86n8OuZJriTR4EFm3FW4BE9lVdnAPSBLIbnRc3uWk5W?=
 =?us-ascii?Q?R0r1OeoQAYFSt1qNN7NjE06TG1ZU3tHOqmAaF/GGtYj2BzmxIzbvYOLnf2YZ?=
 =?us-ascii?Q?tdfWrTBHZJ7tef7zGLQXBIsQZmjWzeLBBN98WuScx5LPTcIkpBrE9A/rE8zE?=
 =?us-ascii?Q?d0EFj8xNDWux1BlXOBSeW9OjPbivtjhN/Uv5PTiReeMi8jA/9bJDlmodfBuB?=
 =?us-ascii?Q?Lw=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: c2821c58-8ab5-40c3-ad43-08db7310c434
X-MS-Exchange-CrossTenant-AuthSource: BYAPR11MB3734.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Jun 2023 11:06:45.4157
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: z4Q4rckGO1od/CquYt66XpHc4RCJre1VGTC9jzlkyW4U9Hs6VJ6duDplQ2d99nkevV6gMVrTbQlwad8+gDU40IV2jhrogsKGViY5mgWcK0g=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR11MB5179
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi Herbert,

On 2023-06-20 at 15:08:18 +0200, Damian Muszynski wrote:
> This set introduces support for the QAT heartbeat feature. It allows
> detection whenever device firmware or acceleration unit will hang.
> We're adding this feature to allow our clients having a tool with
> they could verify if all of the Quick Assist hardware resources are
> healthy and operational.
> 
> QAT device firmware periodically writes counters to a specified physical
> memory location. A pair of counters per thread is incremented at
> the start and end of the main processing loop within the firmware.
> Checking for Heartbeat consists of checking the validity of the pair
> of counter values for each thread. Stagnant counters indicate
> a firmware hang.
> 
> The first patch adds timestamp synchronization with the firmware.
> The second patch removes historical and never used HB definitions.
> Patch no. 3 is implementing the hardware clock frequency measuring
> interface.
> The fourth introduces the main heartbeat implementation with the debugfs
> interface.
> The last patch implements an algorithm that allows the code to detect
> which version of heartbeat API is used at the currently loaded firmware.
> 
> Signed-off-by: Damian Muszynski <damian.muszynski@intel.com>
> Reviewed-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
> Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

Unfortunately, with this set we found another build issue on 32 bit architectures.
Please ignore this version. I will send the fixed one today. 

>> ld: drivers/crypto/intel/qat/qat_common/adf_clock.o: in function `measure_clock':
>> drivers/crypto/intel/qat/qat_common/adf_clock.c:87: undefined reference to `__udivdi3'

Sorry for the noise.

---
Best Regards,
Damian Muszynski
