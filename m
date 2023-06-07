Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 584C1C7EE23
	for <linux-crypto@archiver.kernel.org>; Wed,  7 Jun 2023 08:01:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233580AbjFGIBa (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 7 Jun 2023 04:01:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48684 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233416AbjFGIB2 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 7 Jun 2023 04:01:28 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4978C184
        for <linux-crypto@vger.kernel.org>; Wed,  7 Jun 2023 01:01:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1686124887; x=1717660887;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=Zs4C6CdET5Lhu7g057NEHTxBW+Ax/S79NF9rurm26+Q=;
  b=acjc3Xw2EgM5hrAwfnQ8NlMHzf9EdAiXALLmNoR/h6hfgDUkAiaUTMR/
   g4GZAcAHGo2FKjdkT6hxzOLXrvCSJhWWkqc/HgDZ6d2IWGwSWhSuxb290
   dzJ2r7J7j1+sODhWHnGwNAoGaiqzpzou4xibcf+/eXNxo3Bga6GKQcBZi
   qX5RrjR+wrXsuhTtFfa66f+DGSajDOq+NilKoEM0ylwhSnGu3BLORb2x+
   rSy06sSgM2lnqfjmwGLaApSCU29vAAIo9n0xAF2CToCunOPVT1g0q+hS4
   wv+cQvPJCeNxupeQIxfqaMQKqfcu3U1Zwv5QIHgVqq/OegBK9V7unN8x9
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10733"; a="443285278"
X-IronPort-AV: E=Sophos;i="6.00,223,1681196400"; 
   d="scan'208";a="443285278"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Jun 2023 01:01:24 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10733"; a="833565106"
X-IronPort-AV: E=Sophos;i="6.00,223,1681196400"; 
   d="scan'208";a="833565106"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orsmga004.jf.intel.com with ESMTP; 07 Jun 2023 01:01:23 -0700
Received: from orsmsx603.amr.corp.intel.com (10.22.229.16) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Wed, 7 Jun 2023 01:01:23 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Wed, 7 Jun 2023 01:01:23 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.173)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Wed, 7 Jun 2023 01:01:23 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BmnrhjT110a18KvzcJDicoNk6FX1kBLJXYdk8WxPeqvdsA81eKFt9qJYJZU6zAmIR9OlFnyFQToQaijhSnUyMYt2Fc4urQsOszYNN+d6+rxeI/JB793gW81bnIAKNgxrKwZjUC8zYcgsqIkESFPlf2CjCJBtwhZAO+GE8Uz9NfAzGyNnrl2B4tIXTvi+l9VegNi3OJnT6CiDhaTz4NFEfPLNVEyvhV/5slL4+IB09sC0fOHl6B4ByPQu0Ffo+A+Eb0r7aUSlBDsWxjiuXkgTRGKOhLyLkIwwQ4teDQcTZrmabbdNOPWo1UOy7/AmJXfaWFUxBDZjdITOM+VkO+2UFw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=aRzMo0/73dIdIie7qsOTMmhNdfzq8s0BgpL+H3UCxzQ=;
 b=QbcXnr260khtgHUqiPnVA/5YInqMz7ODTZ3X5sR+w5vzkXa5YlGOB6l6LtCwNHKXNBrvL1eGDYsrSuF4f9oAoB23iJsg8xVqG5EPtLuPXvD7p6E+ewKL1LkfMVnkUNw0ER7tE05JmdHXlYIv0fqJwdczpcWahaDOECWqpqjtd22XG9cIu9NDMhHtjmDXQwNyyH/eHRmZYUlbkar0w0dWS0+b6GXbOaKz+3Z2eMpG3DcdRcnQY7W+wHCe8sAh1COyq79OPglicd01pwXs6KxaDjBIiWoypjowhck8vWZ1lW7EqG2M3hjDPWOkGEfwcZG3VagGKwfVHxAWRjix3Eq95A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CY5PR11MB6366.namprd11.prod.outlook.com (2603:10b6:930:3a::8)
 by IA0PR11MB7380.namprd11.prod.outlook.com (2603:10b6:208:430::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.33; Wed, 7 Jun
 2023 08:01:21 +0000
Received: from CY5PR11MB6366.namprd11.prod.outlook.com
 ([fe80::955a:2397:1402:c329]) by CY5PR11MB6366.namprd11.prod.outlook.com
 ([fe80::955a:2397:1402:c329%3]) with mapi id 15.20.6455.030; Wed, 7 Jun 2023
 08:01:21 +0000
Date:   Wed, 7 Jun 2023 09:01:15 +0100
From:   Giovanni Cabiddu <giovanni.cabiddu@intel.com>
To:     <herbert@gondor.apana.org.au>
CC:     <linux-crypto@vger.kernel.org>, <qat-linux@intel.com>
Subject: Re: [PATCH 0/2] crypto: qat - unmap buffers before free
Message-ID: <ZIA5S8G+j1Q1x4nE@gcabiddu-mobl1.ger.corp.intel.com>
References: <20230601101000.18293-1-giovanni.cabiddu@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20230601101000.18293-1-giovanni.cabiddu@intel.com>
Organization: Intel Research and Development Ireland Ltd - Co. Reg. #308263 -
 Collinstown Industrial Park, Leixlip, County Kildare - Ireland
X-ClientProxiedBy: LO6P123CA0042.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:2fe::13) To CY5PR11MB6366.namprd11.prod.outlook.com
 (2603:10b6:930:3a::8)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY5PR11MB6366:EE_|IA0PR11MB7380:EE_
X-MS-Office365-Filtering-Correlation-Id: e6e03f40-2572-421c-73ce-08db672d61af
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Iyco/pUqk9uPygx1Z8iaTlPsteE/bTVDyDqRnb/PM7VKsimUUEfSBCNe2VpYFOTFd7/kiDiFEi0uN4PxO3hlaw+m7X1LyNsWY1j36Iv5KJJ/ixh5/2mQkHMO3Tb0OiiqqxZ/uaUZEw3CmgCrooC5Gpgqxj6boj5XrJ/B8mwsA1qnxC/qUqFsaVEbkxDDPI2LAbN1YSMWpn5tfOSDtHRHRpEJQysq2V+UXYNg+9drhOuMIy1uhkGFM5F8tnibuDOZ4LTQsHHQ6ZEkS3hjCEqsuJK1dQc0VrcrjuYWYQ5hX/W59FdQ+Pal4qy7Yu9Od5MKXt7RaL1QRcVa6gNOcHNDWNUOCBWGemp5cKtyMutuiyTaXr1CJtySvkgi1nxh5WarW9JKmqzlQ1/R3/znVEQQ1D9mfQyTHVTchJLmNgX3lsZSE+GBiyzAWWrCX3rMqPx+F+YTorP/DTp28lsqzECtk2ALJKiDvpWEcHdb5dsBHQ6pKi00OKioyDEE80BxhzW1Qg0A2kG/UO4u+wodRaT2fSbifx9cJ5Uk20mThwQEbhGm99Nzywr+kLlDxjLWkPvNeHuJT0tpFevWaCg0A9XpC2/BHR9RwQPp0H4L9sTySYw=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR11MB6366.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(396003)(346002)(366004)(376002)(39860400002)(136003)(451199021)(4744005)(2906002)(478600001)(86362001)(38100700002)(41300700001)(8936002)(8676002)(5660300002)(82960400001)(316002)(44832011)(6916009)(66556008)(4326008)(66476007)(66946007)(83380400001)(6506007)(6512007)(26005)(186003)(107886003)(6486002)(36916002)(6666004)(67856001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?N9yVTIX5S9bA+obFNPPs7VBOKfmAb9trvDXXEc/wtVlxf4Ej5UV780DM9Yuu?=
 =?us-ascii?Q?TuJcZ103sQWFIgZphHqp6ybNok+fQBk7RE+3BrNZWir9/pHi7wXYZvhIIqn9?=
 =?us-ascii?Q?U0EPiRLbnbjfP/TdT3s49BQn82BEdMRiBGGb7RBk3bPqAyNl23DbB5aM4dkf?=
 =?us-ascii?Q?LHtcE2iflIit9cObfX4fE23sTc9U4wI7Ct0260ARLCFFvM7d97d08IdZ0Ksx?=
 =?us-ascii?Q?qMZxF6QueEGcde1l0ikNNdbhOUtrWWAMd7dCQlYWwGWYGaUhgnsgQ+Z8Z9ku?=
 =?us-ascii?Q?BG7FJurjeaL7W7aai5p0jugZffgs/9R1s9/zrqdUDj1+8UXJXSbYaq3Te/WP?=
 =?us-ascii?Q?2LtDjv37LpKXGFtuVu7UnVsZoehDlyJVUJ2kLLFIuyCOR45ucuusQrTPESnT?=
 =?us-ascii?Q?llGSowvelYxkACm921btF/PJNDs/5WDyGse6EXUAw45jbvTWChKWiCYogvAj?=
 =?us-ascii?Q?HPfkYHDr/fxEtdpe5vKxz3S4MUkypsMNjrskU0MxrxlAsPU9iMmbCbt1uy/2?=
 =?us-ascii?Q?r5IAXyb4JYz5tyn0vKsE6S1F77/wMpYuFbiOqHWwg940uzmva2rWfUjg6aik?=
 =?us-ascii?Q?1pU95ibIBTPT/XK/q8YKdFRXVzJBgJlBC2sJ4qtJUeR98qpzg2akGzZemyFc?=
 =?us-ascii?Q?h6JcRn8uHvMxVOxBDjk3HWJ9nb1BDUanv2w4mT8fpYdJ3M0/V7VDHa8WFz+Q?=
 =?us-ascii?Q?QqCTMiB9/0TzDdU/t+DfmA85wkaT605VzjXSxvfO9v+wdX2NzI12FiO8bN0V?=
 =?us-ascii?Q?KI3raYnUtnLmYhWndMpnWI+2XgNK2f7S+1WLJUdZH75m+4oBZ63ViLHL9NmM?=
 =?us-ascii?Q?n/F6iv8/1iXA05940ejAUHeH9cxKzd2B0UnJvNAf2skYXGJfayICaIizgev4?=
 =?us-ascii?Q?eE4+/AUBacJTbbzgjKCO7p9TeT7G5QN/SxJFoQlvCIvhce+JA8tBzVUu1sSa?=
 =?us-ascii?Q?egunxaVVQfEmlndtIOVmuKQbeBALHdC8b2y3VkyUpr515HB2hQ1X+fxBl7Nv?=
 =?us-ascii?Q?hqkwrVakRR2mahVYXEB6hyFrXyS5NFbu+e2pIzcqaPRiEQ9V+nAdyt6PZjF0?=
 =?us-ascii?Q?2Abyw0vW8PkxsVvIouNzL96NleBqq2kV/W6MMqkWFaSzC/8qXVSwIXq8bw7y?=
 =?us-ascii?Q?/46oJ3KawmJc04GsX0ynSZVrVt1g/knztNAGAlUAlMDWKcyXLjc4OCpJ3C7Y?=
 =?us-ascii?Q?KrLKZ44HWs95B7Iq65xGk5+UW41+3nuF7M3wNn44c3DKbk3tmw/yNNdOwyu5?=
 =?us-ascii?Q?kpw9rXlLG+CbSS0niN/tTufLF5b5Q8t3lkCIKdtaVD57Q3lgSJvbEfxy+BPi?=
 =?us-ascii?Q?/UND9PHWbNsz5Wj+2CX/3MLxKaGy53foWKcRT8iA62394PpJm7Qnli4ZeZQ0?=
 =?us-ascii?Q?/+He4zD5nyEQ4Ni5NndDZGn6JOwPyzMIBODtM29qBOVZ0J1I5VNqKWDI4Eet?=
 =?us-ascii?Q?gASO+yzUO2vARqUS5iZmaiOhei6M4GMqix34Fms5tOa+GEJyOsm1bYSusVj+?=
 =?us-ascii?Q?saUlLf53FwwCvQqa0HPy9tA1DJNwMszbu7xhxoZUoMvsv6t2vwlbqlWxyBjF?=
 =?us-ascii?Q?rk2H2hHtTkEOBfIpJWx1zsJBm333iARjP5Jbytc9tcbOLuH+YO4Ab3YB48JM?=
 =?us-ascii?Q?1Q=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: e6e03f40-2572-421c-73ce-08db672d61af
X-MS-Exchange-CrossTenant-AuthSource: CY5PR11MB6366.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Jun 2023 08:01:21.4038
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 711CdY/+oyUjzFPHxq2q3VZ684hyYgy5vN73+EDw7NObhf8VhBdnhFH8f0SAr7mLMerMngb0cnZqFC/kgzVjAg+1thYoq5qCC5iCzOePxdg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR11MB7380
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi Herbert,

On Thu, Jun 01, 2023 at 11:09:58AM +0100, Giovanni Cabiddu wrote:
> The callbacks functions for RSA and DH free the memory allocated for the
> source and destination buffers before unmapping it.
> This sequence is not correct.
> 
> Change the cleanup sequence to unmap the buffers before freeing them.
> 
> Hareshx Sankar Raj (2):
>   crypto: qat - unmap buffer before free for DH
>   crypto: qat - unmap buffers before free for RSA
> 
>  .../crypto/intel/qat/qat_common/qat_asym_algs.c    | 14 ++++++--------
>  1 file changed, 6 insertions(+), 8 deletions(-)
Just in case you haven't seen it. There is a RESEND for the same set with
an additional Reviewed-by tag.

Regards,

-- 
Giovanni
