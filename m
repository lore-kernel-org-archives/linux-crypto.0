Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5093DC38A02
	for <linux-crypto@archiver.kernel.org>; Wed, 26 Oct 2022 01:02:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231259AbiJZBCj (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 25 Oct 2022 21:02:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229544AbiJZBCi (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 25 Oct 2022 21:02:38 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4947DEF598
        for <linux-crypto@vger.kernel.org>; Tue, 25 Oct 2022 18:02:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1666746158; x=1698282158;
  h=message-id:date:subject:to:references:from:in-reply-to:
   content-transfer-encoding:mime-version;
  bh=Br58+RDpx6aEzeHq40JSElMawQeF1El3rOTtJKcpGmY=;
  b=WUH7I0QsidM6eYFl8Avulhx+ffYXg7pInXzO7cCBekyyEslrRajO+Nha
   pZKs9UNg0oueABWUMZgnY9fT73/6XGeKE3xgz6EdeU0mHW8C/FJJrKMcB
   vRdUtVYRINaY0Xz5vhpwthfpWEWyLcJ2fwMLcpl5EGtTMb6kd4hLBp7GR
   kP7RzPslcSU0RtyJNhy23bUN0WaTcp0HihUKf/mC1HMnlA7yWlK+WMicb
   oTQ2lGESL0qb5FjiGydUBx3itvdu8NXlwM9NVcWmYF0HVObUVt1NtO5py
   Z/IUf9CT4u9wDD487g/PKTBRm1CfltIYxPP0qpDt10YLXHPdH6Vs6GiOb
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10511"; a="394141465"
X-IronPort-AV: E=Sophos;i="5.95,213,1661842800"; 
   d="scan'208";a="394141465"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Oct 2022 18:02:37 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10511"; a="582981283"
X-IronPort-AV: E=Sophos;i="5.95,213,1661842800"; 
   d="scan'208";a="582981283"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orsmga003.jf.intel.com with ESMTP; 25 Oct 2022 18:02:37 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Tue, 25 Oct 2022 18:02:37 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Tue, 25 Oct 2022 18:02:36 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Tue, 25 Oct 2022 18:02:36 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.109)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Tue, 25 Oct 2022 18:02:36 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kSnMEiF5YVYe+OlHVldWOi7fXnNosehOwdqtRPpL2lC9r3gb+gQWW6f/GHpMXMHFkqfqD9k1h9DmYAr/SLeXWS+CEnIK7a5H6pVsNnkWZMV/i/kDZ3fduHYQI7Y3492Ez2eMKOaZQ3AZGeLXmHvssNOTtBw747K2JwUZL2/roP9OfyvOAhqfG0Ue/IwEzaQ86uyOKPc3C50NZvmsU9oNnQ2dDVJYod763aiYzMwfgXtLX+lF5PAGeqGcslb1SGUCJwtYjCLR9pWn+TFB5oDREO1yGPO9hF+3XetM4zgGQMKYX1/Y9QAFhh46WUFnvStnmvceUkYfEPfysFUhV9SwCA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JzDKoqNr/+QyH7gT+yrF9FbtUbS7NBHxnncpHEg7duA=;
 b=AUH/aVmKwYHAwaBX+Hh1MD06LSAhg6fBCc87gyUNnUZnBh1nVvew2r+Z9TV42oFSiE9vMpGoqe86NHOCLd+LBeu8kWLX13Bd/h6i8HAyw32gkxR6RGXVnDrJhXJkMxwr6rC4GdblUuHWI+Bzq4RnainZc1dmHfnTizB2Ai0n7LKzLScOdEElsnOwS86cPXv2c/IkYZ/s+tMYOneL1QKEhVLYg1uwMykGKoFX8CKpOGilaFMSGNX8ksIUFXRo/LLigJAgYQetLnOaezUnSgvnIUglrwcdBo4wCyCzvA9uyAWlv7kannxPzLFF1dM4Z4nzZ0Bxb79wzCesAuJxhjlLuQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from MW3PR11MB4764.namprd11.prod.outlook.com (2603:10b6:303:5a::16)
 by MN2PR11MB4759.namprd11.prod.outlook.com (2603:10b6:208:26a::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5746.28; Wed, 26 Oct
 2022 01:02:35 +0000
Received: from MW3PR11MB4764.namprd11.prod.outlook.com
 ([fe80::5970:b188:e18f:7fbb]) by MW3PR11MB4764.namprd11.prod.outlook.com
 ([fe80::5970:b188:e18f:7fbb%4]) with mapi id 15.20.5746.028; Wed, 26 Oct 2022
 01:02:35 +0000
Message-ID: <8a48ce9f-24f9-efef-dc20-4663f709b26e@intel.com>
Date:   Tue, 25 Oct 2022 18:02:32 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.13.1
Subject: Re: [PATCH 0/4] Printing improvements for tcrypt
Content-Language: en-US
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        <linux-crypto@vger.kernel.org>
References: <20221026001521.4222-1-anirudh.venkataramanan@intel.com>
From:   Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>
In-Reply-To: <20221026001521.4222-1-anirudh.venkataramanan@intel.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BYAPR04CA0032.namprd04.prod.outlook.com
 (2603:10b6:a03:40::45) To MW3PR11MB4764.namprd11.prod.outlook.com
 (2603:10b6:303:5a::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MW3PR11MB4764:EE_|MN2PR11MB4759:EE_
X-MS-Office365-Filtering-Correlation-Id: a0911fa6-ad09-4e0d-9301-08dab6edc493
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: RB67Tv8ajaGww9mliUmKLHfSuYArt3S4XXmnQjBemW5esa1NUi3b7NgH/kfozCByNf1SfabIPkpbAcveCHrnHR3+98JdK7WCY7T5h9y3To3Sw3Jze8ovweVhYeh6AmStW/c9Y1y7po0jvAXVVBSJ5rlofkwzZrK8bgBQeiraN2BPuo4DuIL4mmn1wAh9/K7orvy7Rc58JZOUPtlD9+iNxOKO1XK/FZcoZfBAqiCr+LADjEJExH+h7vU7+72l2/tmkXxLQWLPtAUtf6FHHVPFXLamUTbTjXlF+w97iIkGJXLzVP6naEFsy6U8pShUnoAcLaAI0uJoKMjidUBaVCuX8AGTq1nifVcF7PipZgYqsZGOirvehHuJKsVdk0wtR+GjCGRmwUy+HuPwxi6tWnD503fnqGFFvq6zVhK8yav4Ubu6SGIBXfoiANjw2FK9JkTJCxWwtqFQwYfQAYHolq8IQ7muPPILl/k0gZSJgERnI2XoImxsSDHhr/3cdG40SOOL8zC18dYrek5R5yoHBfqRYIQ8TKOd54GhOBSeZu+motwb9OMGK1fzlPkDBNe3T+Xb+hz+IFJAPhQJw6WkFh8OaR3bwBMOEijCUW3wn5ggWtxl7F6NEv6NvicjUa6sLHWvDFO8uci0TJ6LvmBF2ZSVplUtDDZNoNrWea7aP6zETHowUKYD+QTIuxBJH9IO2FNZI9PO3CVCz9XONcoEHu32vNwSaYrO1PuF6So8SueX77+epf7SIKqq/dq/aUAdFUAK0uEsNa4wRx/8eDubGS/IDLUQyX/gIZddIVPglldLhoU=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW3PR11MB4764.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(366004)(396003)(346002)(376002)(39860400002)(136003)(451199015)(41300700001)(38100700002)(6512007)(186003)(26005)(2906002)(31686004)(83380400001)(2616005)(36756003)(82960400001)(8936002)(4744005)(44832011)(5660300002)(6486002)(478600001)(6666004)(86362001)(31696002)(6506007)(53546011)(8676002)(66556008)(66946007)(66476007)(316002)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?bHYxQzUxL0EweG5OaXFpUGlYWXk2aVZiRkd6WEdQREZ3R3dNbDhsOE9kRDRS?=
 =?utf-8?B?ZzA1cENZY09xY2VjdTZjKzgrL1pRa0kzcWVmaFlnRmNuQldya2s0ZlpienFO?=
 =?utf-8?B?a3NrL1dkL0tPM1ZCb1c2YWxCdDFZQmttQnlVdUJvZEJUYlRGSmZFaUhMaTZY?=
 =?utf-8?B?UVd3cDNrck5wQVNBcnJxcG1ZbFJXNENLcGRNanlFd3UvVUYwZWg2eUROZGhv?=
 =?utf-8?B?QS9PYjBISmExd3NyNjBEQjdBUmpUMmJwem1pemwvQ2czUmpZV2NQNDlVbldr?=
 =?utf-8?B?T0JCR2thdW85NWlDK0NIRlk3QUd4Yktjc0hYNm95QnhzV3EwM0Y2QmhRS1hy?=
 =?utf-8?B?a09ZZmhDL3hhdGRtejl5UHBrYWNDQlZGYTU0MHo0WmdnanAzNlU1Y1FNUUc5?=
 =?utf-8?B?UUx6RjRiZmlRaW1xajhWMDh0eDhsS29Na25hZGplc3FNdHdCb0NYaUpEbXNE?=
 =?utf-8?B?bkFJbFdwWUsxVWFJUTJIMmcrY2dPY1VMVk9rckFrRVc5NlNINHd1QUoyVE4w?=
 =?utf-8?B?MEFVTXVId1lpTG1OZWlET2NUVFRQeFlWZytsYnJmczhObFU0WElHeThtcFhO?=
 =?utf-8?B?N3N6b3I1eE9XMGF0ajkyWkI5MkM3ZkNrY2xITDVxaEZuSlVZSFk1cGE0QkFk?=
 =?utf-8?B?ZUVueml1c2pLK0hqNENZdmkwTG94cHVOdlhCNXVDeEtVMlRGbGtmLzBGcjdH?=
 =?utf-8?B?N2xXSXFSUlNxVlhaZzg5TldaY3g5WTh4d2JpVnBoU2JrTG9JU3hIMHNUNkZJ?=
 =?utf-8?B?Q01NQWdhNVZFVm9iRnZaZFluRWs1bXZ2L2w2NlZHS2RBSFlQNktia0NyZXlB?=
 =?utf-8?B?QnQwSktoWElTdUFKVGxyNVJSZVZtbEZQYm45OWVIYUo1VWh6WnlZWHVjZ1VO?=
 =?utf-8?B?QW9IQlp6UXM4cm1xUkQyUG5PNXkwWnlyLzFMOWgyLzJoRmFyb29XbzlQQ25U?=
 =?utf-8?B?ZkZ4TmhmREFTempORkNJZW1hbVpIWWF5MHFsZmJ1eHkxQW4zTnF3TTdDT3c4?=
 =?utf-8?B?UDQ5akJLQVpvOVl0aDhCMFhWUXNWTTRBZFhuU2J2VnhRbWhJZEc5TnluNmNr?=
 =?utf-8?B?NFMzUDRhUzRWRnJwVTcrWVFMSnV1bkt0OVpKZDVGeHc3MXhHSGV4RU95ck1H?=
 =?utf-8?B?RHNYUFVkNUR6MkdXUXhUZkY3bUNGM0tEZFY2b0R6UGxvTStBMlV3cDlFd1ds?=
 =?utf-8?B?RXBHa3hYQVBSRDlPd3E0YVJJMDBibUtZeElLY2l4ajYyWXQvbWZUNDIxRWVH?=
 =?utf-8?B?Yk5zZktwT0NiWVkrcVJWdnJSangvN3ZIZVdlWVl5dE9XMXZRSmtJejdqVGMz?=
 =?utf-8?B?YlNPcE83REJxcU1qOFJkdU1oRVpVcTdSS1RyV1NXQjFsbzV3UUJGeWwzTFRl?=
 =?utf-8?B?c2kvS0llRSs3ZE1sRG5qSXFjL3lRVmFSOHdONXJBamp5RG43YXRqL2dpbkpp?=
 =?utf-8?B?bjBzekVXZDVzQlF3dDBjbUVWcDlWbTlGcDN4aXlTZkcrZHo5QmJkMEQ2K2R5?=
 =?utf-8?B?by9XTStNNEJqakhHZEhGanNUU0FKQ2RCaTZtN1pMc3JHNy9HcXFvL1REU1A4?=
 =?utf-8?B?WlNtNGEvNE1YOWdWSzdmVmhpNDYzSE5xRklSS2t5cGZHOVZEVi9LRE8wZktC?=
 =?utf-8?B?RjBkbU1RRE5MeFJTajJqeTJNaUl5UmxJS2lpYVl3SFVOOStveWFiQmdlOU1K?=
 =?utf-8?B?U0hmTHZkdmV0SDdhZG8yeXN5aUJqeDFtcGV1cFRacWcyWUJJV2xKNkdOUWtj?=
 =?utf-8?B?V056U1ZWVUI4TDgrMDFhaE1rZTdxMnEycDBpUXBkMWdGeURLMG1KcU1OY000?=
 =?utf-8?B?MjFieHpJZEZOVUhmK3YxZnlQN1ozcGI2TE94OFVKR1l0WHJLd1F3aTVVdHJs?=
 =?utf-8?B?YzV1NTd1b2Z4MDBSWlgxZ1VnWURpY3Z1RGVnaStYRlA0OFUwM2RVSDNtdE5F?=
 =?utf-8?B?ZW5TS216THB6S1g5OENkRTVGZ1ZwLzJQd3IwdlUvZ25LdncwcUMyeGtZQzAw?=
 =?utf-8?B?dWJLYVBTMTlJcGN1L0xRTFErbEdFbUx3YVUzZkFuSFlBZ0ZSWlV6ME1jSTlM?=
 =?utf-8?B?anR6NFA4TUhqOFQ5RmlnQk52cDVnZzJkVXl5T1QwN2MrTW1tbi9yUkhSZndx?=
 =?utf-8?B?cmRyejhtTjBYTlI2QWNxL3BoRCtJWHhVN3Bzc0R0dm9uWlc1TXdlZU1lK0NF?=
 =?utf-8?Q?4GXEVNDr2463TiDZmbdq7Jg=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: a0911fa6-ad09-4e0d-9301-08dab6edc493
X-MS-Exchange-CrossTenant-AuthSource: MW3PR11MB4764.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Oct 2022 01:02:34.9105
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hGsROQvAmlWSSatyq592QFivDSwh6krpdzrydjNccQRatlEQr5Qf/+2vqETdWGzDtHaSEJ+CChi4kiqknmSecN/P08FRSBkhW5LjhgOTiZKJk/nh4O9sw9dEMQhWVg3E
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB4759
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 10/25/2022 5:15 PM, Anirudh Venkataramanan wrote:
> The text tcrypt prints to dmesg is a bit inconsistent. This makes it
> difficult to process tcrypt results using scripts. This little series
> makes the prints more consistent.
> 
> Anirudh Venkataramanan (4):
>    crypto: tcrypt - Use pr_cont to print test results
>    crypto: tcrypt - Use pr_info/pr_err
>    crypto: tcrypt - Drop module name from print string
>    crypto: tcrypt - Drop leading newlines from prints
> 
>   crypto/tcrypt.c | 36 +++++++++++++++++-------------------
>   1 file changed, 17 insertions(+), 19 deletions(-)
> 

I generated this series on top of crypto-2.6.git master branch, but I 
believe I should have used crypto-2.6.git tag v6.1-p2 as the base instead.

I will resend v1 with the proper base.

Ani
