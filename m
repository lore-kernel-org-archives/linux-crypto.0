Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2240DC4332F
	for <linux-crypto@archiver.kernel.org>; Fri, 25 Nov 2022 10:23:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230116AbiKYKXl (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 25 Nov 2022 05:23:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230053AbiKYKXk (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 25 Nov 2022 05:23:40 -0500
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87DDE209AE
        for <linux-crypto@vger.kernel.org>; Fri, 25 Nov 2022 02:23:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669371819; x=1700907819;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=SEciqe32X7qD+jWBKc67nYO4ZunfZ4CReimnROzN5WE=;
  b=asjWCRntJWjW8NO3DO1iAu5+CWkvfd9BC32jUGTeZexNEy02l04wbxL1
   goxoIfE1cDeFTDZBcG3ErcfhA/Ehv/Cp5USCGMC4vRr1CS5zih7AgJi30
   xj3dPCcpvpSCQtc8uWh9Gcy9pvsbdsWgwRICW1amO7QKPViG1iv+3lUM9
   /vOQOJyfM3vWB/aWW/Qw5z/7hCsD2nqvsmU9Gdkb4LgmSyCd6cT35KIJJ
   ZI8fUY84c038R7zsvysFAd2Zy9Pxj+b5R7MbmNz92TS9OWkk1pjPz6Zga
   9t61intqAxK3scLw4R1DWKQXzAbQXfJx3LHW2+C+4lr1TANsQp8vYVqJR
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10541"; a="312092266"
X-IronPort-AV: E=Sophos;i="5.96,193,1665471600"; 
   d="scan'208";a="312092266"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Nov 2022 02:23:39 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10541"; a="636535052"
X-IronPort-AV: E=Sophos;i="5.96,193,1665471600"; 
   d="scan'208";a="636535052"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orsmga007.jf.intel.com with ESMTP; 25 Nov 2022 02:23:38 -0800
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Fri, 25 Nov 2022 02:23:38 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Fri, 25 Nov 2022 02:23:37 -0800
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Fri, 25 Nov 2022 02:23:37 -0800
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.107)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Fri, 25 Nov 2022 02:23:37 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fHinxQtjSlYjkO3qNvCwVuF+Od2ArAx91od9/rrwpQIXmr6jn/AnYSE2gMw6cTmcG1BHHq9kw+k+0D+G2VJtZD7kZJB5ITxVCxX2GiAXPNTusSgdls48jGzK7P0u7XKxtrZkJfUHPWeg4iC3yn6tZci7qAcItr8H2H4hzIjxw9QU1qwXyHeMUGJm0g1kAkYnjcZWals4Y5DcrEm8SZDo6yYA3N2fH3d8LHsCZOmpF6dOENS3v+JsYPIQBgIuRpLREnILscGoTAhGVIzD3Fn7BiNKQQXcjLJWRhtXNQtt+uhAZ+dm5xJkHPc01qxMzb56EyA6k3CI/tOQv1ifh+9Syw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gZayLiJS2hHNRuQp7AmwVQzl2Qx38m8fAuQteLezjgs=;
 b=obrWycgpesArYM961RGvNAcxNPnsZmFOcVY8DZEuOBxzXi14Jq4D+dJqXWenL2Z5EL7kcTeYdcA/JL/o1JxCE6Jue0icFJR1eU7VkM4LYvLtVL5dqOKWKhYmjtocDvIA/BJIcQ9opXXh9K7VL4rpwf1hIvmJhHbqesjEwZ2snpf0AIKMAhtzdu9FJcN5keYB8c9JZfhsZqUPc2XTjFDZzKCbtI00TMlf9CZ5J7UtGThsqm67Y7c0EWsaWi/EUVstIVyI207e/j3I+HQQ012uOok1w+bXS1oA3z6d749C//ZkeZzCYUmlzubOxvNEzikNaceynX2gvTd1ffN4lJ9X7Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CY5PR11MB6366.namprd11.prod.outlook.com (2603:10b6:930:3a::8)
 by DM4PR11MB6550.namprd11.prod.outlook.com (2603:10b6:8:b4::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5857.20; Fri, 25 Nov
 2022 10:23:35 +0000
Received: from CY5PR11MB6366.namprd11.prod.outlook.com
 ([fe80::7b39:df5f:fe4e:f158]) by CY5PR11MB6366.namprd11.prod.outlook.com
 ([fe80::7b39:df5f:fe4e:f158%8]) with mapi id 15.20.5857.019; Fri, 25 Nov 2022
 10:23:35 +0000
Date:   Fri, 25 Nov 2022 10:23:28 +0000
From:   Giovanni Cabiddu <giovanni.cabiddu@intel.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>
CC:     <linux-crypto@vger.kernel.org>, <qat-linux@intel.com>,
        Vlad Dronov <vdronov@redhat.com>
Subject: Re: [PATCH v2 11/11] crypto: qat - add resubmit logic for
 decompression
Message-ID: <Y4CXoOc0uH6njPCO@gcabiddu-mobl1.ger.corp.intel.com>
References: <20221123121032.71991-1-giovanni.cabiddu@intel.com>
 <20221123121032.71991-12-giovanni.cabiddu@intel.com>
 <Y4BKgx2axzqsjWch@gondor.apana.org.au>
 <Y4CO3O21Kx/Ywi6S@gcabiddu-mobl1.ger.corp.intel.com>
 <Y4CRBasSFNhXywKj@gondor.apana.org.au>
 <Y4CTLD7BdfFt5T5X@gcabiddu-mobl1.ger.corp.intel.com>
 <Y4CT61fknX5aNvpa@gondor.apana.org.au>
 <Y4CVjUAvXx9AIBBa@gcabiddu-mobl1.ger.corp.intel.com>
 <Y4CXAXUnfBHcj4sa@gondor.apana.org.au>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <Y4CXAXUnfBHcj4sa@gondor.apana.org.au>
Organization: Intel Research and Development Ireland Ltd - Co. Reg. #308263 -
 Collinstown Industrial Park, Leixlip, County Kildare - Ireland
X-ClientProxiedBy: FR3P281CA0096.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:a1::8) To CY5PR11MB6366.namprd11.prod.outlook.com
 (2603:10b6:930:3a::8)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY5PR11MB6366:EE_|DM4PR11MB6550:EE_
X-MS-Office365-Filtering-Correlation-Id: cb1a6d1a-2c00-4f14-f5ef-08dacecf1c31
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 4ZRhiNa/MsNdj08vkmJBB5dxHoFXTZkK6HQ1BsxxlmS6SyXg2I9d151SKW89Pm3y0GgR5VXudc0iEw6eB/WTrP9RI+3oOfjXTFa2qANoAG9BTJfy5KlT1aYoJbWlhCfEW+9ZqWtMOq5SiddxgfeM/fIsBBbrUqvUM0ue3NGSkiomAZ++YQ+nBW055wsUw5PK/DcqmxmJRZAMYFm6iZcLPpKj9fCtoaCASEVsRTBOdndVQ7x/CVK5r9p03rAoB+pjVSkFSz5Fb6yeQ1vamndGVuWmteI9ZLNGN0TsyHjaxyM3yAe5cBwdovNfa7wQowt7H9qhRj8+HPbt7+FhiEKFM0rIQugyEX7Dh2mqgnN7Fb/lBctfBtqbIK0oQp8FkEhSRpZIyyorI/kDPBBY+a8fcC9VDJcbFnGewu96SiSJSdWhTlvxUoxodIsyPxtClwzQiiqU7EV795dWw7xL6qaJiHpBJV8F7xhAGKiMcIg7OzhhCxlf2LcoGfuBioWKhhCgj3FzHGTE2wKPVX7TcDJGUTh5qFpTMzK0TDo7Wc8RV6tTAKc6mzomxrpWswv3hCLQcFCkjYryawzvk5w02ZRhsRQAjYRekw/I+bXL4olcbFoLW3qBrEHmbHNQugkqo9dtzTQqfk7stWdYK3oh1l4wDg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR11MB6366.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(346002)(366004)(396003)(136003)(376002)(39860400002)(451199015)(478600001)(2906002)(186003)(86362001)(66476007)(66556008)(4326008)(8676002)(66946007)(83380400001)(6506007)(26005)(6512007)(6666004)(36916002)(6916009)(316002)(6486002)(38100700002)(41300700001)(8936002)(4744005)(44832011)(5660300002)(82960400001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?iLgxasr3h/5hfxYQdLFw1UgYj5I7IQSig8qjSGb8vPnWd+Tw0E5OYpABX5Cc?=
 =?us-ascii?Q?q6fBKVmdZpYZP+7DF7Oi7NsiSHYd8voU0PoeMBLe7ejYG9sHh0OcQEmLC4g2?=
 =?us-ascii?Q?yZwv/u8+VbMNcVZ2SFyJFvxrrEeYkB231ZWU4PjSihQYCAGAVuOlzwuyG4Qf?=
 =?us-ascii?Q?BoqqsOKXw9rsg5frTE8rHLtvB1TXE07piZRqM0GSTcWH0AkUnZXM2w4xt1vt?=
 =?us-ascii?Q?kBreMV2byn+ITOgdiXiQv0Q3qbaVhE4uISH2THUcvZ9GtT5FadQism5ocofw?=
 =?us-ascii?Q?0ZMQGonQlWoYaipu91Ncf3F84s0felKHYfY/kQSqVWJ1oAqDkdhlS8LxwoMX?=
 =?us-ascii?Q?RmYq55fVXDfdfbDnn3MKPn5lS9+XazX/3R8GCfQw159YUUQKjg/2lwkhj3qw?=
 =?us-ascii?Q?+47qA00TiIUfpfO35kYbkkBK+8QJYp1M/wHqt+hi50T261VZLvTAoTq1b3S/?=
 =?us-ascii?Q?B3wCYFYR+bUdtwqdNjhYQ1sLJhNelPEpG8kfGu2mRw9a/U9qEJ1hpL1Vj+je?=
 =?us-ascii?Q?b3Hg46JnvQRR93Vdi9tymJMEWsfdw+mChVp5Oq9U5lIK2gf6sNzLtK/vG/1M?=
 =?us-ascii?Q?9cZQ+BKhRIdjV0vxqKQmltQ8gK7Ig9ABpwGFmPt3+gwDb/+6Yq1HvJ7kbd1e?=
 =?us-ascii?Q?FU4RabFtDsjOPIAGC/PDVRW77zUojm4T130r1OaR54HqdRVNNEwlzTNOaQc+?=
 =?us-ascii?Q?0F3/PwxkrlsouA/8ytxMt9zK5kHNhPWek/7RO9o45i7hTWDxhNabvLyUio/v?=
 =?us-ascii?Q?5xoclcjnmd92YAT7Vv6YF7DN5P0aYc2CauRceslTS4hhE10P+gcomK4hQG0H?=
 =?us-ascii?Q?j84tDTyXC/Mg1G9gYyw/0CWVmzZL+yQs3DCVPCvggTfKOo9qMA9Z9NGGkwCZ?=
 =?us-ascii?Q?glaAHHxO+Abh7u6vwOqa3B07cT7aAzjgFIxtBcpwDEmUNM4EMgcJZvKvcFAx?=
 =?us-ascii?Q?eKLBhOGMCtWSoSj9WqjQ2oJjWNr6HEtVX6XVITY/W/OAjQ8UL3bJmX89k5qx?=
 =?us-ascii?Q?yFkFJPUNock715+sBxQztPtoWPY2ES/MMqYGTlpfjBOBn8Ep/C++KkU6p8TT?=
 =?us-ascii?Q?DgDM8YiVOekBUiTnOFqMkkPv4Ku3ykTEQD7smce67Es/E3qBKYe0Hu+6pk7r?=
 =?us-ascii?Q?d1ga9CT6KPIZmjVBYwNxUpjXz+cHo/3S9V204gwH7dGa6uaqopbPmjKNqBMF?=
 =?us-ascii?Q?3pCSyS0PCkAZrfEAjX9+dtl5nPVPiQGqfI/gs9+B6YVKN1/8Rv+UsVzfrXb/?=
 =?us-ascii?Q?s4op4wwJ9tHvwmChOCtusq8hXZrASBT8myrh17ZzEk1jZ8MyQ9i/DNhp1NSi?=
 =?us-ascii?Q?DBteJPVzNqy4kb6yQJgWn2XDpSuJ0RtVaQRvQ2esDjT1fqc5nuuLKpfMwbck?=
 =?us-ascii?Q?laEwiGhrr5x5kyNk3SJVcyMQcXr4EW5w1/zDwzdA3TRnO9rtK2IqGKnsBmnC?=
 =?us-ascii?Q?NqejUk4GxMOMzLfkIWzkWajGit2pbKe/NfKO/lhSMQt48ElemEDIzZy8ClYy?=
 =?us-ascii?Q?sFRdo+5TRAD13pU+NYnIgnGwauVR00UFJtynNvcpwQo0d9wsRysLHkDR2hWP?=
 =?us-ascii?Q?ypRX3mbrii0+5ZHxEp1H+Rg3iUz7mN5ZPQZm84Y8Yn3V9dgHj932BWhLKIna?=
 =?us-ascii?Q?6g=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: cb1a6d1a-2c00-4f14-f5ef-08dacecf1c31
X-MS-Exchange-CrossTenant-AuthSource: CY5PR11MB6366.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Nov 2022 10:23:35.4040
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: E0BHLEXL9ouT9DMpCDt0kFzTt3TTPEdYmjEQR8kZeX8Xs3R1Q4zhKHVF7ljxxufeGWARIfdBYqahHeqJuKs7gnH0cVjHZFMwoc4efrs131A=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB6550
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, Nov 25, 2022 at 06:20:49PM +0800, Herbert Xu wrote:
> On Fri, Nov 25, 2022 at 10:14:37AM +0000, Giovanni Cabiddu wrote:
> >
> > diff --git a/include/crypto/acompress.h b/include/crypto/acompress.h
> > index cb3d6b1c655d..bc16e0208169 100644
> > --- a/include/crypto/acompress.h
> > +++ b/include/crypto/acompress.h
> > @@ -11,6 +11,7 @@
> >  #include <linux/crypto.h>
> > 
> >  #define CRYPTO_ACOMP_ALLOC_OUTPUT      0x00000001
> > +#define CRYPTO_ACOMP_NULL_DST_LIMIT    131072
> 
> How about simply
> 
> 	CRYPTO_ACOMP_DST_MAX
> 
> Even if it isn't enforced strictly, this is basically the ceiling
> on how much effort we are willing to spend on decompressing the
> input.
That's perfect.

Thanks,

-- 
Giovanni
