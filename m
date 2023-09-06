Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2D632EB8FD9
	for <linux-crypto@archiver.kernel.org>; Wed,  6 Sep 2023 14:32:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238628AbjIFOcW (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 6 Sep 2023 10:32:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230103AbjIFOcV (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 6 Sep 2023 10:32:21 -0400
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F5E610F8;
        Wed,  6 Sep 2023 07:32:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1694010737; x=1725546737;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=Ji8xLMwcXpBEMBLXKU/keszS5ppuQuFY+krzuj0nwxU=;
  b=EbgmeHD/0QoRJ5YykiHVm9II5YyA3NF/iPeXHXQbQCUgAuqZhLXaE5NM
   +hN66CcFC20FTWrWppQjt4ivRAarTD2X3enCtrWQ61epqZnIDuKKh1K9w
   mPLKXvqrgUGd5zxEBBgruZ4XizGbqPsOCzJIaLrYap9evD9NegE8hG7L+
   CwpWef/cK9khA6WoXJdKMZZ+CnZSv3A6TyF+axNlO3/d5tSmaBXvvlLml
   5B+kRCjFhE09ymGG+CR55ZtXHGJ7Zi+etxv6e7oDRqIt39XDqa6VVnhRb
   KVSPfUF8LD5H4yv7D71kBqGOwZhRM8Ru4sheOd3/0mHHQZQYV2uBEhd5f
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10825"; a="362111060"
X-IronPort-AV: E=Sophos;i="6.02,232,1688454000"; 
   d="scan'208";a="362111060"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Sep 2023 07:31:17 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10825"; a="884731484"
X-IronPort-AV: E=Sophos;i="6.02,232,1688454000"; 
   d="scan'208";a="884731484"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmsmga001.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 06 Sep 2023 07:31:05 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.32; Wed, 6 Sep 2023 07:31:15 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Wed, 6 Sep 2023 07:31:15 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27 via Frontend Transport; Wed, 6 Sep 2023 07:31:15 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.104)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.27; Wed, 6 Sep 2023 07:31:14 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LGLwCQ0IFT0LzKvNGd8k/sWuem8V3eINpdV6ez/KzPuXUz0+gWSB8GIyvt3FLcyCQEbvqP2zf81Xjp3yDhHgecOEBZWApnPzyUrw0BR4KP+EDgGyroApM8cF8QVHqGd2NZm8yJcS2H9IZarc8uYXTJQhWJy4Vn9+nDf8pxeQZf0Feai/uk4Pu+iLpuHFuP8A4ou69DuEdNZMhaioB1FGRyu2dvoM45sOPo2ftga6i3FcTgt/maTGDBQeQQ31vS5OKWFHuQCTXrufcaLY/b2IVVt/sIn7pIB1QyU5fVxnom3jS2USeGN6ou8gjcQPxL1iFOCi8KHN6iknMJHShQnQRA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZTJEZXe1bIhbwI52BzR0/xC2zh0T35b32ei6yWJvghg=;
 b=dqXXnfWXYSL0JGwmbw8SC0GU7Q4bJuKY3vlAAvqONRFtJc3OcUXrNSLy2IJQfgVdaDQvjsf2vlhzSmYaVo9VfmX2wp7BZrxfWyyQPnxCX+one15FF2k/4vlKAPP/2TJ3u1XuIQ8LowlLdQPknw9QJHBH/qtkpHTM+3VDp50ZQNJbD+3m0O+XTjwan4/YhxuxbrO2sBAPcRFuE9IzPM9WtafhbdC1T7CL6c6AebWIIhJhmP1j5aeBUsEwW78PnQHw/HHL5KdYPBdVYrIY2ClySdK0HkmM511oMFJ3oOh5HXn6MwI6/CH0ZVx9bOdwgPyG58Jo/stiUmw+Thy6PQp9PQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CY5PR11MB6366.namprd11.prod.outlook.com (2603:10b6:930:3a::8)
 by BL1PR11MB5270.namprd11.prod.outlook.com (2603:10b6:208:313::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6745.34; Wed, 6 Sep
 2023 14:31:11 +0000
Received: from CY5PR11MB6366.namprd11.prod.outlook.com
 ([fe80::f8a8:855c:2d19:9ac1]) by CY5PR11MB6366.namprd11.prod.outlook.com
 ([fe80::f8a8:855c:2d19:9ac1%6]) with mapi id 15.20.6745.034; Wed, 6 Sep 2023
 14:31:09 +0000
Date:   Wed, 6 Sep 2023 15:30:56 +0100
From:   Giovanni Cabiddu <giovanni.cabiddu@intel.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>, <stable@vger.kernel.org>
CC:     Sasha Levin <sashal@kernel.org>, <linux-crypto@vger.kernel.org>,
        <qat-linux@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: Bug in rsa-pkcs1pad in 6.1 and 5.15
Message-ID: <ZPiNIBvrpVz61doJ@gcabiddu-mobl1.ger.corp.intel.com>
References: <ZPcFyp4jdE3uSeqW@gcabiddu-mobl1.ger.corp.intel.com>
 <ZPhAyty1r8ASyr+F@gondor.apana.org.au>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <ZPhAyty1r8ASyr+F@gondor.apana.org.au>
Organization: Intel Research and Development Ireland Ltd - Co. Reg. #308263 -
 Collinstown Industrial Park, Leixlip, County Kildare - Ireland
X-ClientProxiedBy: LO4P123CA0368.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:18e::13) To CY5PR11MB6366.namprd11.prod.outlook.com
 (2603:10b6:930:3a::8)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY5PR11MB6366:EE_|BL1PR11MB5270:EE_
X-MS-Office365-Filtering-Correlation-Id: c4074704-710b-40dd-1d17-08dbaee5e99c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: gnrhibOE6tu8Tth4PEhHOE8PLoTag38SsaKne9vgebST0z2KbXklNhLUIY4f4T5xtwR9SjIdP8u5j40q2Pbp+/BAvYW0gJlEUbaQESyscqI0AxTr/tFCX9zUkZMARd1WKUXrr6qlpFbi42rSxWR+sPjgDSzCaQmm3tFxaCcnkWhQGutjUAelZYXtZk408WqPx7mBDWSDFcpS6uXbcCUBq6Njwn5r64m5yPG/I99coBG7ulhUUV21fb7yGpLu50i7/idjYPXyn1yOE5+g7Xenp18gS77tSoC6s/yukSY8QUzaKjuaWqUcYCIJnxqF2OjUf2FAEtxrcXz33DfsyAYS+Bn45RSSz0ZhZcR527gkp1Y0IWUDTEPzb8vhRR1OYU+4I4KCk3uX4sB6flAyTtPyRIpK12Hjhb7xaKj0+SnutEDe2MDUe218ufU6+hVzIuGCBqXtbtKpHQS00zh5WM0LIccv8m9BRQ6nh5/NVmhbfcUPeTGGvGTF4jyqvBtXM3fC1noGNBfD6+fI9+fkvcyc0uulFEp0p34OJXWUgXF5aOgAFJLetO6J656HZTy39PgHMBIGeZWwSaecsk13F6faBf4qrGuLiTDH+NCk9KFb8fPRjci9P8VT1b6NuhO9oaqm
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR11MB6366.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(39860400002)(396003)(376002)(366004)(136003)(346002)(451199024)(186009)(1800799009)(36916002)(6486002)(6506007)(6666004)(6512007)(83380400001)(2906002)(478600001)(26005)(41300700001)(66476007)(66556008)(44832011)(54906003)(8936002)(316002)(66946007)(4326008)(5660300002)(82960400001)(86362001)(38100700002)(8676002)(473944003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?7V7GBcXpWr/LFPnO+r8fFTMaflIJ9UZornYpNJ4MLwm7A404+OWalfMhtiO2?=
 =?us-ascii?Q?HQl9evZv4aHXIBoP7F8DffraApFgiKVhQ1JdXu1sSxcmGhWbY0OBEeyXakPC?=
 =?us-ascii?Q?TFduyKhY4jVcawP0a66vvndTGO4fnhTe3gdw7zZVAd5UMdWDfvcNEPgDFY8V?=
 =?us-ascii?Q?f8C+WaZ07tB/7hzOsGMdP8/eU2qLnC9aKO7ULJxb0DN+Q3tT/4a2xWep9DK6?=
 =?us-ascii?Q?eTBLqPUi/ZCulacTCS9sjLcDGuoPJLG8EmJPBVfCxE5mJ8voT+SQMS+qsRGD?=
 =?us-ascii?Q?xMe4Hv0hQLqXYEZRZOBoW66fOjK9/WhrcwTSY3bFXCpCzsCI6D/ZfR91/mAg?=
 =?us-ascii?Q?iMogh70pWiZoOGDaaI1sXWmJXZUN3B4YVLkYiVXFIguF+TZc6hlqJaNOD5sz?=
 =?us-ascii?Q?qxDASw5V5K+qe1KlsD1TNgOYpSqtI/SqXSDpwQFeY+MsBbHDMrW+XhVGFWSa?=
 =?us-ascii?Q?gmycxU1nhKHoXmrzLBXLFo7DajetFRXzfmJc4p5BPydynl34xnRmKzGO3LYK?=
 =?us-ascii?Q?XRVjolre/+WE5wJD1O/mJUfGK93ehhd0gSuGBuYPJsbjrahP84Yu9/MUpPaS?=
 =?us-ascii?Q?YYzQGJnqMoqhns6A7ynjVrSdcC+YTuhzz9JhRsPSjWX+D4eSco7uIp5dTXoQ?=
 =?us-ascii?Q?RRYKHfRru/wdgKcV9sArBZrwOgzO/kOwlj9GQ031X+b1Al5nSfVtOCUEsHuU?=
 =?us-ascii?Q?GXJ6ix0FdBk8L/XqURhZlY6OmMLHnWiJOt0mPAbtBCDSoXKOjMENfkMXLenv?=
 =?us-ascii?Q?46EH8OA+SKtOTxOLxdUiVHTt61VDpTid0RqvmXaZ0qQ91llZdROvGBLCxT3u?=
 =?us-ascii?Q?zfC9Dd6kVMQBcAVUEL2CQU1DEtY6MLy0v5W3RFGQpDtBZh5YrNQqSlvRc5ns?=
 =?us-ascii?Q?SoWG7ltg5Xj1uGrW3EQE2BZ1XCYwwtZ3HXstSBGiabjToO8q57V4tHUR0eV7?=
 =?us-ascii?Q?nNym9ZZSc/WffuR0iY3WdWEk2SXcvZU/8JmHp6b0KkOMm/CbXCJoebwUx1HX?=
 =?us-ascii?Q?9JhLJaeEX5LEmwaGlR2xzQqS0QQTGLiaIPfS44kgbWnpO7xJLg3lhT2zy1V8?=
 =?us-ascii?Q?0+r0rVITsD42+X0o7HVoN72JJUG8bFVhw/F3rukOwAjDpLIQh92ny7p2EjWQ?=
 =?us-ascii?Q?DCxkZX39JnZbqqECcFgaNW+DdUmQw5Y+lHK2GIpKSaJ1ZWFBgh9emN9DE20O?=
 =?us-ascii?Q?HbzS3Jfq0ECPOd8GH2lQVyRrI2HM1tLJ5wFvwzp82Vj5wke3YlNL/LU7DoUE?=
 =?us-ascii?Q?eRfUE6wPOZDIyOpqrjTuakdf0haezLiHAq1Q+YnIJVUr/CDS3QTFQHBWRlWo?=
 =?us-ascii?Q?MCb/MOG56r/mae7MpYy6HeCgntCDmAhA+vdSM2x8574Dbpe+utLOHZ5BTf0n?=
 =?us-ascii?Q?5b1EtTJtIZxFF++2YgoV0rKsrQKa5DL9Vwi1iq5Nk5rdDasXkbnvpLsNUMI+?=
 =?us-ascii?Q?cpnNQWSZWbyftJI5xFbDlGM5AvzUYzHq5LogOiK9D6Il8aGcNQeejOXLVafQ?=
 =?us-ascii?Q?/KqxnJyoVaO4LXFozGkrXJBm1XQ2wcdbJ3TDSpBlRERbRuDdXQ2NXScyMw/r?=
 =?us-ascii?Q?HUTdCj0b9he0BH/La29dwpYXY6lYFlh4T0FyDdEENMvp5ETSTY+RCd8cMzBC?=
 =?us-ascii?Q?/g=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: c4074704-710b-40dd-1d17-08dbaee5e99c
X-MS-Exchange-CrossTenant-AuthSource: CY5PR11MB6366.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Sep 2023 14:31:09.4818
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: p8Mm8G2LeKR8U8fDvPGA7hITYv0d1ZnhqW/qQ46C6sKZqkuiau+mmXSrJ9XNQbObiFvrDeZNV5Ftw/rZIaMWfzmKqdHBE+WhmpTLBnfVGzg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR11MB5270
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, Sep 06, 2023 at 05:05:14PM +0800, Herbert Xu wrote:
> On Tue, Sep 05, 2023 at 11:41:14AM +0100, Giovanni Cabiddu wrote:
> >
> > Options:
> >   1. Cherry-pick 5b11d1a360ea ("crypto: rsa-pkcs1pad - Use helper to set
> >      reqsize") to both 6.1.x and 5.15.x trees.
> >   2. Revert upstream commit 80e62ad58db0 ("crypto: qat - Use helper
> >      to set reqsize").
> >      In 6.1 revert da1729e6619c414f34ce679247721603ebb957dc
> >      In 5.15 revert 3894f5880f968f81c6f3ed37d96bdea01441a8b7
> > 
> > Option #1 is preferred as the same problem might be impacting other
> > akcipher implementations besides QAT. Option #2 is just specific to the
> > QAT driver.
> > 
> > @Herbert, can you have a quick look in case I missed something? I tried
> > both options in 6.1.51 and they appear to resolve the problem.
> 
> Yes I think backporting the rsa-pkcs1pad would be the best way
> forward.
Thanks Herbert.

Adding stable to the TO list. Would it be possible to cherry-pick the
following upstream commit

    5b11d1a360ea ("crypto: rsa-pkcs1pad - Use helper to set reqsize")

to both the 6.1.x and 5.15.x trees?

Thanks,

-- 
Giovanni

