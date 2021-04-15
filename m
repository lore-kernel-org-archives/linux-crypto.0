Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 48218C433B4
	for <linux-crypto@archiver.kernel.org>; Thu, 15 Apr 2021 13:47:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 146EF613B4
	for <linux-crypto@archiver.kernel.org>; Thu, 15 Apr 2021 13:47:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232759AbhDONry (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 15 Apr 2021 09:47:54 -0400
Received: from mail-co1nam11on2052.outbound.protection.outlook.com ([40.107.220.52]:25495
        "EHLO NAM11-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230056AbhDONrx (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 15 Apr 2021 09:47:53 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=U9mHGsDllSjvLziHzEQ+T+yFgaovw366is+eY54PcdGyw08tCkA70vWqkfe3eQFvbE5nodxS7i34pphz62ik+JgVyXINsSBM8ga9s7ttM709EaUN9+qqpgNA6KF96zvrXnVX31vQzZI6as0lUa297/OyYNyWO8xAlCahfT9UqxBm8WP7bTaGt3AdEa4GLVuNdLGCcDsrwZfG5BNuSCSvSpt2aG+n9Zm3wf+U7AIHzj0DtaH6mbYr1gVRU6YWoiyUf54QpoZw4YIfumzCyBVenJ4ag2HgNhEnsEoCTqdoec2KXGYtVgQi16hbF42HmNYbvLAn+Hlr+6yQJRzRfHKjcQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qSlXBi8ZKEGcOaKqkmDDpj/zhqaoGrYkctiGkeLg9Mo=;
 b=PTSn2puLM5oOMJ/7CKjQdct4uzURAg6o1KmnKLXzfMLMKcGvDWp2vFnE3Cxjq0uUQOUeqtDdpI+J++e87p0gtg3JES0WvUO7gqO+YpjDUAya8X5A/45T5lPbLTg9F0TJI5eSm5laUv6UOkQLXxj5UAvnSvAQhOA/DVnO4Dm9zLYy5WX5aV6NZtLyqMOhUfr27gdcEx6qE5DO5IikYN4UFiqsLZ8e1D47wLR2GlD98/I1cAm+9tkQjWkth1r9Dl2LMrlseQiUM7xD2PsvEMc0yVJrCtGq8bGC/ZOSk2pWmmMlDNu0kM2ooFSrKtb5xIHXc0NBsm53QP4BH/n4vujKJA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qSlXBi8ZKEGcOaKqkmDDpj/zhqaoGrYkctiGkeLg9Mo=;
 b=XQAadPxKZkn50A6418U+H7U8VefQ8VUO04Xld+w+ldJiAIAllKqWoP51iranE1e9+/VPG6RKvd8LGqkFf4QBxoW5n5/7nTJEt1cQwlSP88JlgRBozDrUYo1WetCXjWYcS7EgQc49ToDSfeMxm3QsbmlVjCadq15+BcWAJ6od6KE=
Authentication-Results: amd.com; dkim=none (message not signed)
 header.d=none;amd.com; dmarc=none action=none header.from=amd.com;
Received: from DM5PR12MB1355.namprd12.prod.outlook.com (2603:10b6:3:6e::7) by
 DM6PR12MB4957.namprd12.prod.outlook.com (2603:10b6:5:20d::14) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3933.31; Thu, 15 Apr 2021 13:47:29 +0000
Received: from DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::b914:4704:ad6f:aba9]) by DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::b914:4704:ad6f:aba9%12]) with mapi id 15.20.4042.018; Thu, 15 Apr
 2021 13:47:29 +0000
Subject: Re: [PATCH] crypto: ccp - Make ccp_dev_suspend and ccp_dev_resume
 void functions
To:     Tian Tao <tiantao6@hisilicon.com>, herbert@gondor.apana.org.au,
        davem@davemloft.net
Cc:     linux-crypto@vger.kernel.org, John Allen <john.allen@amd.com>
References: <1618466627-17596-1-git-send-email-tiantao6@hisilicon.com>
From:   Tom Lendacky <thomas.lendacky@amd.com>
Message-ID: <3fca4c8e-19b4-a128-5bf4-4b231cb1f750@amd.com>
Date:   Thu, 15 Apr 2021 08:47:26 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
In-Reply-To: <1618466627-17596-1-git-send-email-tiantao6@hisilicon.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [67.79.209.213]
X-ClientProxiedBy: SN4PR0201CA0020.namprd02.prod.outlook.com
 (2603:10b6:803:2b::30) To DM5PR12MB1355.namprd12.prod.outlook.com
 (2603:10b6:3:6e::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from office-linux.texastahm.com (67.79.209.213) by SN4PR0201CA0020.namprd02.prod.outlook.com (2603:10b6:803:2b::30) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4042.16 via Frontend Transport; Thu, 15 Apr 2021 13:47:28 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 2223e36b-02df-4ddc-e34e-08d9001502e0
X-MS-TrafficTypeDiagnostic: DM6PR12MB4957:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR12MB495714486585C70EE1F63FCDEC4D9@DM6PR12MB4957.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:751;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: mC24u3TqRdIL2RxL2kSbdE4Qp/AbvEGtylxJ5omrZB9tUtInZwhCx0ZOu1bEYS18mLPpYKLSCjDi6Cd45FRAbWYTllXqRAwb/23KW194KgFJGC0a8YHSQeeNvLGxvS6vvyoh2P0mBCpNyS9+EPch5c1roKUtl2tLkR7WKd1JTd9jTfvHJjgiBzLSTVPgfva2fGtLD0ajTxJ57itzXQPj06OzishT11nSQO6HuKSoHTiSm1PFULLTKygexNV9jBO/nqVplNq1svGMnrDeubLYgolXlSV7hkge3+/E5D72WvbxuuxZaFkBSN/jxgYbNf9cdBWRhb1UKlx8/oUxOq+bd26BaCF0ZDUh8qBweIktn4ZxOxn9itR7lD6bQHlF7JH0pMGUBO/QOYSSjtko7FXsOhEe5PBFUPmEi5WR9sIWRH5UewH6iZobDnFaoWZGPt6dRk3+VA5vJM/aylbaoO5HQpPqIWZBkkCZ9NQRleJw+fVea0eTxfeN2WkURsdu7mmFV8HBIDWYjH7eYarDMo9CJArcZYMibMna9p/Rqjc5s9UvqbH4yGGvWcSqk3hbFkx2GxYHqX+NmbUos57XF+F7WwtwktnwW3VOwAv3AeU7sZf50GJmSZrPvHs+I3zuYsgJra+zi6QLFMA+xJu2zrlRC5nfDrJzeksuKJOeJFEfjfXDyrtG4V0dh2dRxX1kisYm
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR12MB1355.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(366004)(396003)(39860400002)(346002)(376002)(83380400001)(26005)(956004)(31696002)(5660300002)(16526019)(31686004)(2906002)(6512007)(478600001)(2616005)(66476007)(186003)(8676002)(8936002)(86362001)(6486002)(66946007)(66556008)(6506007)(4326008)(36756003)(316002)(53546011)(38100700002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?bldtNVZIelZLYzYxVytreStIeGRINHJ3RFVGM2Y4VDIxZmM4NG1zWjVGS3lS?=
 =?utf-8?B?dXRhNEN6VDhsRlJHb2tEWkIzYld0Sk4xeThTbk5vN2dTYjRQSDc3UllvZ0hY?=
 =?utf-8?B?eEs3aWxKd0llZjBxSkFsWkliRzdDMlpEdmRLdlBGQlpwKzNEY2sxWjNNbEM5?=
 =?utf-8?B?NXMreHMwWkZmUVJCcFRXMkxMR29Cc3JoZnFRcTRvOFU1bm83ajYvWGdyM1BL?=
 =?utf-8?B?MlowS3lTS3paSDZONGNnaFZoZjdRSVNBTURxZnd3aE0zNVlvMmpoSXk0QnF3?=
 =?utf-8?B?SisxczM1VGhIcGloSUlydjNiMGlSK3BiNmxpcnBRYXNTOTZSZWIvd3pCRzJE?=
 =?utf-8?B?WFlhcjVHeDNmdXluTnYvQmZMVktoWW5FTjFEb2cyYnM3RVBNVGJIdzQ1NFha?=
 =?utf-8?B?MzlXZW9OODRFaGhlaENrcUpmOWdGUWJEWXZVY0JyL29RenVvcXZSRmt6ak9N?=
 =?utf-8?B?ZnRrZ1lkeE9NeW04ZXZYN2lYbU4yejBGZEwra3hSdzV1ZGh4ZW1VU3hSZElh?=
 =?utf-8?B?a0lGWldNeVZPTXBLL3lYVDE2UVFXRUtmZnBFNiszSVhjV2JMYjVlTEMxVEh0?=
 =?utf-8?B?enExK1lDbHhHSTVBYU50N1FBYkU0ZzNhNUR6bmZXZHdRaTZUakhHM0RWdlpG?=
 =?utf-8?B?c2dVSHl6N1lIVnF3SktKNkRVZ2VEUmFpeGFlWTZ1TVNYMDlhSndIZG9YUUxF?=
 =?utf-8?B?dDlob09CMkNleTRTSmJKdDh6VkdtY2FjcDBFTUZVZlI0RjRDcitKNSs3ZSt0?=
 =?utf-8?B?RGZUNnVlajI5ZmRMVXluOUFtK2xRdHV6N2ZuVFgxOS8vUy9weTJGNW1SZnlm?=
 =?utf-8?B?SVNraC9vbTlqQ1FlQWdob1QxVUlQRDJKbUUwNE9Ibk9nR28xTUhURFZ3MEhO?=
 =?utf-8?B?c0Z6ckhoNUYxemE3T3NHaWY0cDc2UTZQQURFYkluL1hhSmk3dlByeXYrMHB1?=
 =?utf-8?B?bENyWEhqWTJpdm1vVkpqenlkRWxlWktiNEI0QVpWSlhTKzJqT2xJd1cvbmZs?=
 =?utf-8?B?RkpBSHRtbGk3RUJvbEFxeDhhUFhYeDR6bk5OMkNRYU9ZRXZSNUlINzFZemVX?=
 =?utf-8?B?WDlscEJSMlhyTjFHRUpiMmNCQ3dHKyt3SlArRWplcDExbk80QkcvMjJRTm1D?=
 =?utf-8?B?T251SlAvZ3FJS1dWbG1IREZsNFBpSUN4U21RZXdONG1NQ2tkdzVWUGdaOG5u?=
 =?utf-8?B?dlh3T2FPWEpvYjBQTnRISUxEZCtnVUd6T2hTbTRZaUIrTW9zaHdEM0txdzV6?=
 =?utf-8?B?Z3daOXFOVlJjbmcwb3d3QlJ4VHVBMDZCWUVoUnU3OHJwL0grbHNLVFoxSUVh?=
 =?utf-8?B?TmowZThQaGZqbGJaem5YdVh0NHc4TnQ3QVZtWXRENU9DeS9BelcvRG1TNjVW?=
 =?utf-8?B?bDJIQzZjVkxZOFNtMVBHUEU2WTZPNXhjQnpqN1JoUzR6L0Y2RjBxN1Q1ZmJl?=
 =?utf-8?B?aTdhUlUyZUNtYUwweTBNa25wYmlTd0UzVXhhZWxGdFB2RlpTOWJEN1NuaTEr?=
 =?utf-8?B?aEg1SjB1aDV2MGYvMTkydWJWNkhlSkJma3RscmRVS1BYYnJwQjFBNktuNFJC?=
 =?utf-8?B?VDNmSUxzcmo4UmFLdUVQK3Q0a0NBWm52UDN6VUJ0djdjVVhTZjMralU0aEpu?=
 =?utf-8?B?RWFkaEJQYkFrdWpqT2hlanV2emNwY09OcngvV2F6dktjT3ZNRHBjaGpFU1Zw?=
 =?utf-8?B?UDZMVEVJUFcybkV3VVZVb0haMjM2ekFyamRQUkt0NGJMUjhWcmhJSDh4amUv?=
 =?utf-8?Q?xqsmD7bCMGdYN8JjffC4vHWDI0DVYLoCbA1sWWY?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2223e36b-02df-4ddc-e34e-08d9001502e0
X-MS-Exchange-CrossTenant-AuthSource: DM5PR12MB1355.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Apr 2021 13:47:29.4210
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: cP1xkH8aQ6ZKrgDhxO92n8K5Jg53dC0Rf1ZVDpj2TlCs0nM1Re0yQR/ZWzXRMlu/YyH1UD+Tkaq2XxCRbMzomQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4957
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 4/15/21 1:03 AM, Tian Tao wrote:
> Since ccp_dev_suspend() and ccp_dev_resume() only return 0 which causes
> ret to equal 0 in sp_suspend and sp_resume, making the if condition
> impossible to use. it might be a more appropriate fix to have these be
> void functions and eliminate the if condition in sp_suspend() and
> sp_resume().
> 
> Signed-off-by: Tian Tao <tiantao6@hisilicon.com>

Your patch subject should have had a v2 in it, e.g. [PATCH v2]

And please Cc: the other maintainer, who I've added via cc.

> ---
>  drivers/crypto/ccp/ccp-dev.c | 12 ++++--------
>  drivers/crypto/ccp/sp-dev.c  | 12 ++----------
>  drivers/crypto/ccp/sp-dev.h  |  4 ++--
>  3 files changed, 8 insertions(+), 20 deletions(-)
> 
> diff --git a/drivers/crypto/ccp/ccp-dev.c b/drivers/crypto/ccp/ccp-dev.c
> index 0971ee6..6777582 100644
> --- a/drivers/crypto/ccp/ccp-dev.c
> +++ b/drivers/crypto/ccp/ccp-dev.c
> @@ -548,7 +548,7 @@ bool ccp_queues_suspended(struct ccp_device *ccp)
>  	return ccp->cmd_q_count == suspended;
>  }
>  
> -int ccp_dev_suspend(struct sp_device *sp)
> +void ccp_dev_suspend(struct sp_device *sp)
>  {
>  	struct ccp_device *ccp = sp->ccp_data;
>  	unsigned long flags;
> @@ -556,7 +556,7 @@ int ccp_dev_suspend(struct sp_device *sp)
>  
>  	/* If there's no device there's nothing to do */
>  	if (!ccp)
> -		return 0;
> +		return;
>  
>  	spin_lock_irqsave(&ccp->cmd_lock, flags);
>  
> @@ -572,11 +572,9 @@ int ccp_dev_suspend(struct sp_device *sp)
>  	while (!ccp_queues_suspended(ccp))
>  		wait_event_interruptible(ccp->suspend_queue,
>  					 ccp_queues_suspended(ccp));
> -
> -	return 0;
>  }
>  
> -int ccp_dev_resume(struct sp_device *sp)
> +void ccp_dev_resume(struct sp_device *sp)
>  {
>  	struct ccp_device *ccp = sp->ccp_data;
>  	unsigned long flags;
> @@ -584,7 +582,7 @@ int ccp_dev_resume(struct sp_device *sp)
>  
>  	/* If there's no device there's nothing to do */
>  	if (!ccp)
> -		return 0;
> +		return;
>  
>  	spin_lock_irqsave(&ccp->cmd_lock, flags);
>  
> @@ -597,8 +595,6 @@ int ccp_dev_resume(struct sp_device *sp)
>  	}
>  
>  	spin_unlock_irqrestore(&ccp->cmd_lock, flags);
> -
> -	return 0;
>  }
>  
>  int ccp_dev_init(struct sp_device *sp)
> diff --git a/drivers/crypto/ccp/sp-dev.c b/drivers/crypto/ccp/sp-dev.c
> index 6284a15..7eb3e46 100644
> --- a/drivers/crypto/ccp/sp-dev.c
> +++ b/drivers/crypto/ccp/sp-dev.c
> @@ -213,12 +213,8 @@ void sp_destroy(struct sp_device *sp)
>  
>  int sp_suspend(struct sp_device *sp)
>  {
> -	int ret;
> -
>  	if (sp->dev_vdata->ccp_vdata) {
> -		ret = ccp_dev_suspend(sp);
> -		if (ret)
> -			return ret;
> +		ccp_dev_suspend(sp);
>  	}
>  
>  	return 0;
> @@ -226,12 +222,8 @@ int sp_suspend(struct sp_device *sp)
>  
>  int sp_resume(struct sp_device *sp)
>  {
> -	int ret;
> -
>  	if (sp->dev_vdata->ccp_vdata) {
> -		ret = ccp_dev_resume(sp);
> -		if (ret)
> -			return ret;
> +		ccp_dev_resume(sp);
>  	}
>  
>  	return 0;
> diff --git a/drivers/crypto/ccp/sp-dev.h b/drivers/crypto/ccp/sp-dev.h
> index 0218d06..e6e9f9d 100644
> --- a/drivers/crypto/ccp/sp-dev.h
> +++ b/drivers/crypto/ccp/sp-dev.h
> @@ -134,8 +134,8 @@ struct sp_device *sp_get_psp_master_device(void);
>  int ccp_dev_init(struct sp_device *sp);
>  void ccp_dev_destroy(struct sp_device *sp);
>  
> -int ccp_dev_suspend(struct sp_device *sp);
> -int ccp_dev_resume(struct sp_device *sp);
> +void ccp_dev_suspend(struct sp_device *sp);
> +void ccp_dev_resume(struct sp_device *sp);

You should also change the static inline versions of these functions below
in the #else path.

Thanks,
Tom

>  
>  #else	/* !CONFIG_CRYPTO_DEV_SP_CCP */
>  
> 
