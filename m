Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 45590C38142
	for <linux-crypto@archiver.kernel.org>; Wed,  1 Feb 2023 16:42:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231977AbjBAQmN (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 1 Feb 2023 11:42:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231896AbjBAQmL (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 1 Feb 2023 11:42:11 -0500
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4BF337AE4A
        for <linux-crypto@vger.kernel.org>; Wed,  1 Feb 2023 08:42:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1675269730; x=1706805730;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=eiuqy4pZ6lMlYRI34dG5fSryuWmvRUWwA0fdV4DL0bI=;
  b=iOtM2A6USihqKINI6RSP9dIofK0ONfy7jiYZ/Z4Gf6U9LxDrEpUXHY6N
   NGwRa2NdmTlSBiXeZ8g3sR2U93r4w13yTXuiRykvseMpx0KWC0vWRsMUl
   wTX0ODcpwsASwSD0rmCTtwTIkcfFIO/1YgvgtRZFKzQOT7CCJrJG8bPOm
   rq0JRTzmQ9XN7BtnY3epk3MeFV/75WBKD/3g7Bjp2TOvzW/T5aW8vqV4z
   vC0nDH4+TOcv+W+jz5p1VSyT6r6tDaCNnm+nR9CTIhj0ZCJv1EA+zMqek
   oXE/3Lxykb1Za02y95t4UxYhd++emdNGIZ0iJiuGZ0eTBSQT9jkNRSl5i
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10608"; a="308537685"
X-IronPort-AV: E=Sophos;i="5.97,263,1669104000"; 
   d="scan'208";a="308537685"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Feb 2023 08:42:09 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10608"; a="697317140"
X-IronPort-AV: E=Sophos;i="5.97,263,1669104000"; 
   d="scan'208";a="697317140"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orsmga001.jf.intel.com with ESMTP; 01 Feb 2023 08:42:08 -0800
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Wed, 1 Feb 2023 08:42:08 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Wed, 1 Feb 2023 08:42:07 -0800
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Wed, 1 Feb 2023 08:42:07 -0800
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (104.47.73.170)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Wed, 1 Feb 2023 08:42:07 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RYejFqTnk+2W6r07dF/8WJdkFPQgfeG4LfvMpraxJ5CtiUTipIwDLg4Qc/jP46OTXfyd8jmAq/2+uAmoVBC20xofYaT4LvzLUVLXcjW502pViOeRX4URiOjEvgfiF3V4FMEkS4DyEDMH875msEyWF7JVBwMbaONn66LzMbgAcU411osnqbOr4q/EFXNZcQz+xzFbOCeplrvUSiAIgsEuzbmJxnMmVIi00yIIV+uUy0XrDZXAzfnaBWvgSbW4IJ6bSWmCXUKyaJv1Tt/Kwr+yu/JXGUYeJcy8Gtb/eGcT97ayjeqreyhYZAKIdranwdUMfCOGwMoADhPf799go9XiNA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZCPPfaBeMYy/sBM12Ymf2knXBqD0zQCUzu4X6tBvxSs=;
 b=OeJtEHYrZ3dMUPG62PNC7GPuWWNlzz8ItzNw+MyrPHGsIpb5tJhefGHdyxRBCFPnXrwyqitfMlSHr9WIpTQhZHYkRqyLUY4yXMTP4Y1NsjEl+wGw8TGd3JPRWP3GQqSeKI4YHo+vFQanUr5SvIYNmyhx5Fpz832nuSFVLwa3lJ/WVItwZUFJNE2UxBQYRv4CxDUCt4/U24gQPLgJvZcAEzQRfJl+HXvolUMJOM3Ke3kIgqvCgkyXQ+hAnFcykNn0IUv0p/s/hlJexyGdpWxih/wlisreTjQqBYChhbdUYQweOAqhXvGHHLISxCmIneLFkZYdIaaVoUTdh1x15nvd+A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CY5PR11MB6366.namprd11.prod.outlook.com (2603:10b6:930:3a::8)
 by DS7PR11MB7805.namprd11.prod.outlook.com (2603:10b6:8:ea::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.24; Wed, 1 Feb
 2023 16:42:06 +0000
Received: from CY5PR11MB6366.namprd11.prod.outlook.com
 ([fe80::4b3:1ff:221:2525]) by CY5PR11MB6366.namprd11.prod.outlook.com
 ([fe80::4b3:1ff:221:2525%6]) with mapi id 15.20.6064.024; Wed, 1 Feb 2023
 16:42:06 +0000
Date:   Wed, 1 Feb 2023 16:41:55 +0000
From:   Giovanni Cabiddu <giovanni.cabiddu@intel.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>
CC:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Tudor Ambarus <tudor.ambarus@microchip.com>,
        Jesper Nilsson <jesper.nilsson@axis.com>,
        Lars Persson <lars.persson@axis.com>,
        <linux-arm-kernel@axis.com>,
        Raveendra Padasalagi <raveendra.padasalagi@broadcom.com>,
        George Cherian <gcherian@marvell.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        John Allen <john.allen@amd.com>,
        Ayush Sawal <ayush.sawal@chelsio.com>,
        Kai Ye <yekai13@huawei.com>,
        Longfang Liu <liulongfang@huawei.com>,
        Antoine Tenart <atenart@kernel.org>,
        Corentin Labbe <clabbe@baylibre.com>,
        Boris Brezillon <bbrezillon@kernel.org>,
        Arnaud Ebalard <arno@natisbad.org>,
        Srujana Challa <schalla@marvell.com>, <qat-linux@intel.com>,
        Thara Gopinath <thara.gopinath@gmail.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        Vladimir Zapolskiy <vz@mleia.com>
Subject: Re: [PATCH 1/32] crypto: api - Add scaffolding to change completion
 function signature
Message-ID: <Y9qWUyUzNpOu1kF9@gcabiddu-mobl1.ger.corp.intel.com>
References: <Y9jKmRsdHsIwfFLo@gondor.apana.org.au>
 <E1pMlaL-005vdz-D5@formenos.hmeau.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <E1pMlaL-005vdz-D5@formenos.hmeau.com>
Organization: Intel Research and Development Ireland Ltd - Co. Reg. #308263 -
 Collinstown Industrial Park, Leixlip, County Kildare - Ireland
X-ClientProxiedBy: LO4P265CA0207.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:318::20) To CY5PR11MB6366.namprd11.prod.outlook.com
 (2603:10b6:930:3a::8)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY5PR11MB6366:EE_|DS7PR11MB7805:EE_
X-MS-Office365-Filtering-Correlation-Id: b7760c16-0666-4388-9f9c-08db047340da
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: DRX1u4JNIC1y9saYrd+FRh8rHG0SpsbJNkupqK7eS3ru5eLsbqcLp1+4aJh/ixjJ0YnfvSneT5EcEBAJT/9H2t9n1JcPgXctqMgAX7+tDXFydTkbtews332MQjxnDB1CHnMAIsjkq3jx4fzw+iZBS8vS//eI3Kmv8pReE7NmyXv6NBcZBKgwAL4f0spKd1Ze2sAYVCDNi2HTDWgD4lm6ZhHZmc2QhldSlI7niak4H2RXT7G+A595lwaH7vLxoc3TAmBw114xePirwm3peDBAJPuW3ZwAge0L3Qw/9XTMC3HBlOXNH3TCjmbAFrEKvqD5Qk2soAdAnMrL91YTRBbHO6BOUKsjDcaxA6EpgY8ST7kKxyuincEKWUiYQ3A1aAa6qH7PQSVij/k1yxLjv1baS7+rElPjn6TDZsfEMv3POtZ9MAom7YDXqMY3L+CCdXT48cCzyisABV0yv++5hdXcecIVVgDyHkkMElqIgnKV6FUb0wz/KOpufyWrZ2mY32BmOxy1YvYTLr129Qkf/lbO+l5UrTwgPbt7b1unGznLXO2RWMEiLIaZlLTDiacfrU/8JbpFskMdRad3CkUYBaRw1Sn3dVmj+ztYqC7ZwDLBRWef3BXZS8JFxFekpUJTM+C+nH8B4P5h29BUDjwfQWW4Lg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR11MB6366.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(396003)(346002)(136003)(366004)(376002)(39860400002)(451199018)(7416002)(5660300002)(6506007)(186003)(44832011)(26005)(6512007)(82960400001)(4744005)(6666004)(38100700002)(316002)(54906003)(6486002)(478600001)(6916009)(66476007)(66556008)(36916002)(83380400001)(2906002)(86362001)(4326008)(8676002)(66946007)(8936002)(41300700001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?n5TuQ60dxqUVuMyV226t2NMFdB+c9HcErzJMeqS+PRQfko2AulCBk7pf/sAe?=
 =?us-ascii?Q?gaHLDW8MdPiP8jXzDaf3CCNrW9DrL9kGSreogPPDNtkralPpPlYQuEy5SqVg?=
 =?us-ascii?Q?R8r3ME/HmzflfVDGCwP1/oeOondClUOCt2yvcjBmv6KpVPbhncE7YbphbpZ8?=
 =?us-ascii?Q?OJzklmiO/Xn55sWP8aRpYocMJg4TJSgz/tpSpMVxtVy6O9J7v+8VOsQc+6Tm?=
 =?us-ascii?Q?TqjJQyod/WEvQsG8x8Ta7SN77K6le7nugZix40V+dXISdiNgJ8q1QrNAxPHQ?=
 =?us-ascii?Q?kLhrLIzHNuxQc3tFNKwCbL9uu3zJuiup9RcS5QfbhtZ1/n8BEtG4cF9d/LqU?=
 =?us-ascii?Q?VOmt3zNAqiEC3BgSn8c5NFMh1efgPJaQkhdn/APAP4nXjZo5E1vYcsjBya3C?=
 =?us-ascii?Q?TirWUIdsR0HaiXGR5mBiRrt8+fcF4gnPUWo1GjQ2EvWhIq1aNgSJN/nHaqIT?=
 =?us-ascii?Q?ggnCYSmR+wsufik2IfN9K+TFieDoVkbuoCeotHjht83TOWOBJL8SDxxUj0wr?=
 =?us-ascii?Q?/1TI4BfS+uwFVqRTYU0OjgBw2kQiSFh7PrpvA7uc2smTgQ8ZKcuMt+UPnQp8?=
 =?us-ascii?Q?NirRaEgINHpMTG+MCQWdXaYBjDyI742P4YceM27qZ6qtSEzzyVlrzB7rzAQB?=
 =?us-ascii?Q?luldrxWGZyYsymgW1fyGzUwNtD+jHELd6LZHDAMGFeCcX+rkTgAeCGl5HRxb?=
 =?us-ascii?Q?Z3TvxDIzs0keNYhALyO+FiR39yZzEkZXZo4s5FNa31BYb7nTvePBEFlOYfJ7?=
 =?us-ascii?Q?wswYxi+dnwZsd8Jia4BwMdkTrF/pq/lxB2m0hGdujh57c+mqgeNyuvuXJRlj?=
 =?us-ascii?Q?wvdNwkcLvlleE+v34dq5YTMu1x+j5pYyqOv8CZUpE5asVa5pkK2G5P4XvnSg?=
 =?us-ascii?Q?JsBNsyZ5NVFS0aD1KAplkNKCHU7s7hTu6KIx7JN56pzAsKhAYTpmVx7JTR8Y?=
 =?us-ascii?Q?lfZuCwm943p1gdSG4blJDRCyQu5IqXcyUKmjuIdobeibo5u6xYzrGKooO/kY?=
 =?us-ascii?Q?CndAyE2BA1oTPJjWqPenWRGAMTxfwayrU49DBy2wk9lA7E5OSrmWp0ZhYeGi?=
 =?us-ascii?Q?HBLei20wNuRy1//Db7kYZRp9IjhiAcZ2+90B90n5rirhisD9SQHbe4xFE/QA?=
 =?us-ascii?Q?0Lmb2tKYyldN9RiTx2C2shBWDC8r242tLh7EG7t/USo1A8uZGvMTLLzhD2GA?=
 =?us-ascii?Q?qHLBFyVQyeg0mV5TgLbiZnsS0JThxHXiNj90VxMyxPosulrr/ISls0hETDZX?=
 =?us-ascii?Q?u4JPeUI5pDIERDbDZvKCiXO+zT3RLhMNDqw4whbncoZb9Eq5WYcx6rFMdLqU?=
 =?us-ascii?Q?UonLH5ilztLnTuB5BntJrZdoyoVxBABq9efwIRYQm7xzEcLWb/CnHCnW54/m?=
 =?us-ascii?Q?AnpI0XP4jqTK2OVlRg5vdC/voxCgZ80ZOo0pukS26DTruk9CPNXFqhF7SWmL?=
 =?us-ascii?Q?/LWOH2eIgsrHHhmLm6jjwjDkSdAVXUqNY42aArWdVKPCDqFLd0wze0em++hj?=
 =?us-ascii?Q?SUeeuOILrK82iE4sg1VGZBt+2Tz1aspPjFTjWUSc1lte1l2O/yt28WjE82zg?=
 =?us-ascii?Q?vHAmLqy3gQrvnR5F1tCxCgFCVVa+T7C+kxjzQwQlShBelnkWwEZZo6CPDVQu?=
 =?us-ascii?Q?wA=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: b7760c16-0666-4388-9f9c-08db047340da
X-MS-Exchange-CrossTenant-AuthSource: CY5PR11MB6366.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Feb 2023 16:42:06.1063
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: LckYAVEEg+T9c92r4v9rQ/pQFXqVAzIUzqM85dqEndYL6Th7JQgZJKbnCjZ20BsYL1bELDSTDRYa70mK6vAa4ECDMfNc1mtq2LSu6WsMPls=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR11MB7805
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, Jan 31, 2023 at 04:01:45PM +0800, Herbert Xu wrote:
> The crypto completion function currently takes a pointer to a
> struct crypto_async_request object.  However, in reality the API
> does not allow the use of any part of the object apart from the
> data field.  For example, ahash/shash will create a fake object
> on the stack to pass along a different data field.
> 
> This leads to potential bugs where the user may try to dereference
> or otherwise use the crypto_async_request object.
> 
> This patch adds some temporary scaffolding so that the completion
> function can take a void * instead.  Once affected users have been
> converted this can be removed.
> 
> The helper crypto_request_complete will remain even after the
> conversion is complete.  It should be used instead of calling
> the completion functino directly.
Typo
/s/functino/function

> 
> Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Reviewed-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>

