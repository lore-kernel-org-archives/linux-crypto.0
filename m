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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2490FC433B4
	for <linux-crypto@archiver.kernel.org>; Wed, 21 Apr 2021 13:50:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E9E2960C3E
	for <linux-crypto@archiver.kernel.org>; Wed, 21 Apr 2021 13:50:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242848AbhDUNup (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 21 Apr 2021 09:50:45 -0400
Received: from mail-co1nam11on2067.outbound.protection.outlook.com ([40.107.220.67]:64144
        "EHLO NAM11-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S242847AbhDUNun (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 21 Apr 2021 09:50:43 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RdvhgBqLSRF6EpxP4bRC8XniFep77wNnH7b8lr4+aRFIAGuahq2VeF6Tv4T09YTiyZnHneUiETbW9V6bq99aEhzqDQCSA4LsdAhy8FJw8DyA5tCKmlCUfW5TTe5TmcqNVUPwsne9Mh1SfrNZs0TvBTuRrPTjNPgrPHVYOS7F7wkebnN783PP+53Rsiwk5oXwI61mfq4aakxaB/S/TZrnemrTsiP0AlZf3A0vHt/W8ORzqFYcqxkFzYJ0YDLfuOzCJcfEmMgeETnVC0SihYYPEx4jmYu2/ypGyOx1wxrFgv/cKNr/WS5Mc0TO8RtAIIXFKlC9IDopaQ/FuuNJPqgrQQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dmIS/bT5IERJ9yJXflrq5C4UNJs7NXNienclIJJo1lQ=;
 b=XU/jYDSE31pP3xMWJGRovZto7GGNhrlM+TG1CtCsjm6vbDb1v48zyOGQIQxUB750Col1WEH0F6upNzmP/1UsgMEtrVCb8MYiNhsmOX0U+PtbPqbBX2AmaAoG6SJIHGNmqtg+9OSFZhBSUprOofo/fZAEmEG9GoLCe+GrrKovSVjddjVPEX7Fk3O5L7zHCUGiUIJz5m4DcUeQn/CbmQVLQXXzfA0EOPmKD7RGxlR7cajibkcPZk3q9QGqBGEpDa/MEZ5trrxCM3BHWtP8G2LOki8+30W3GUwmdwVoXbW6Vw3+udZXhmTQXn6ZVvMnvD8FP+gsXKdtxE8qoSjaFLfoQA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dmIS/bT5IERJ9yJXflrq5C4UNJs7NXNienclIJJo1lQ=;
 b=yfzdhVhdBZ2SV5wKO22hT5BuY+099oTxnhvzaPrqOrs6oxZmcxfNwgOfzZtjqsi0PsYWpmBQuFir58JDjEEv0B/8+3Z6HJS1mIkVluXVmoYlsfhvopFvBnfLsRS7SSvQTtML+p25pDBK/1IKobE7kZ0eBvB9xClZYBkgvH048MI=
Authentication-Results: amd.com; dkim=none (message not signed)
 header.d=none;amd.com; dmarc=none action=none header.from=amd.com;
Received: from DM5PR12MB1355.namprd12.prod.outlook.com (2603:10b6:3:6e::7) by
 DM6PR12MB4337.namprd12.prod.outlook.com (2603:10b6:5:2a9::12) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4042.16; Wed, 21 Apr 2021 13:50:09 +0000
Received: from DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::b914:4704:ad6f:aba9]) by DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::b914:4704:ad6f:aba9%12]) with mapi id 15.20.4042.024; Wed, 21 Apr
 2021 13:50:09 +0000
Subject: Re: [PATCH v2] crypto: ccp - Make ccp_dev_suspend and ccp_dev_resume
 void functions
To:     Tian Tao <tiantao6@hisilicon.com>, herbert@gondor.apana.org.au,
        davem@davemloft.net
Cc:     linux-crypto@vger.kernel.org, John Allen <john.allen@amd.com>
References: <1618535202-11397-1-git-send-email-tiantao6@hisilicon.com>
From:   Tom Lendacky <thomas.lendacky@amd.com>
Message-ID: <105b9d35-7fd0-cd8e-ee24-a9824fe0ae1a@amd.com>
Date:   Wed, 21 Apr 2021 08:50:06 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
In-Reply-To: <1618535202-11397-1-git-send-email-tiantao6@hisilicon.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [67.79.209.213]
X-ClientProxiedBy: SA0PR11CA0097.namprd11.prod.outlook.com
 (2603:10b6:806:d1::12) To DM5PR12MB1355.namprd12.prod.outlook.com
 (2603:10b6:3:6e::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from office-linux.texastahm.com (67.79.209.213) by SA0PR11CA0097.namprd11.prod.outlook.com (2603:10b6:806:d1::12) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.22 via Frontend Transport; Wed, 21 Apr 2021 13:50:08 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6307b7fb-3f9e-4de2-4656-08d904cc60c7
X-MS-TrafficTypeDiagnostic: DM6PR12MB4337:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR12MB43378F99F8EE01A5342B05F5EC479@DM6PR12MB4337.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5236;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: JBz/U3BzFmcKazNNh3ILYW94xgA1DVBsHweDPVnkFYpsPcJeNkJpcpUhx1iS3DsXcMXNeeFtzDgepylrvju+9EAfXDfs1bhaNRO0ZraQu+AlBaBlyu+9hl5iBjTWSsd2sAzYkuZni9nmxqfdPNFwc4LRjbvR443FLHjCytEhcB8DVQLNmeZPguldyPOAf5LF1YYcyYwl8tBydGco+Z38ZBknEh8aYp/xQoU/C9aZKmT8sUP3VIZxXcGLM/oTGEf4nv/xRX1ZjGXbIVEVZn7HiByX5jBSahL/qlZekMLASUTesFb+aCd9NGQVfiLzxO2YKCTrJvduHEk3MeBTOVBOCcVmFZ/hQ4F4nYi64rX6+iefUlH1teCXK+WQZ1lkLXNg57IjtJIzgvT727aBFm5Q2WORMk/YjnBdDCwoj8KwzqDbnPQdpvIxmtuoQAis7HdepZL6PxP9ATnhXSoLaqpWravWkFKwz1NONKvkDvfb+hEmOAuBiEB40XPLApI3nBYWVxofS+i3GxwIqJqMhRWkQGbBtdXM3Ydvpf2dx8h+Dz2cvQxA9zxCWpLs02LzoL4RvKppxKcBce4FRjEDDET94akSjd3wdYoIPjFqfpTvRr3K0NeP03Qwp/N50wR1cHvwFvY1QTUtz1ellN78HMVwhhHTuRUMqRbcPK8GbQsB45dBXOFLEL8I8QvtIVAYxQjH
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR12MB1355.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39850400004)(366004)(376002)(136003)(346002)(396003)(38100700002)(6486002)(31686004)(8676002)(6512007)(956004)(53546011)(5660300002)(6506007)(8936002)(26005)(2906002)(66946007)(66476007)(86362001)(36756003)(316002)(83380400001)(186003)(478600001)(2616005)(66556008)(4326008)(31696002)(16526019)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?NGhlWldRYlRwQ05qM2xEcVFMdGhwL1hvRDI5dVhZQktjNFN4Mk8zeHllQ1Ez?=
 =?utf-8?B?c2hRcnMyUVMyMWdFUUJGdHNCVHZGV0tsRmpPa0hyM00wYUt3ZDNmc0dNOHJO?=
 =?utf-8?B?MEJEK05ESmgvSXhyRHZYRy9IcERUN29BcklOS2dCWEV4bHhvQ2dZamJMUnZz?=
 =?utf-8?B?SGVMTnM3QWtDTk94dUN5YThJemVzbWlPSFRGMjlxYW1GZmdHVm1YdmpESmtq?=
 =?utf-8?B?eDhqS0puOWJOUHcxRGE0ZzZGdStCZVFwRHVQSXQvSkVHcGdzTWZ1Qmo5ZkE5?=
 =?utf-8?B?ZEhuNzRaa2NLYVNFc1BxQnQ0M1A5cG5qeiswRjAyOHVsYzFHc3VvZ2VvYzhS?=
 =?utf-8?B?aW9HdVB1cHc1TVk0dTh2SHdPRHBGZWN0RlJ1TnFaeXpnTG9pSUpGdDlhYzUz?=
 =?utf-8?B?TVplMnk2SmpKVjdXRXE2N1p0cFFzeFIxWlA5Zzc5UThZYSt0WUtzYlY5QWs4?=
 =?utf-8?B?TTMyTmI3Q243YkxVY1NzT01nMDNvQVNwUm8wSHpyNlBYTkNhUGRZakFZMmNj?=
 =?utf-8?B?RG5Na3d1dVVjWGZXbDlSK1NUOFFncXoxWGFPM2NKemtXQ1BCT0Zxd0pSNDIv?=
 =?utf-8?B?RkZTWEo0Q1BkT28xeVRyRzBPU3hTQlFRU1RibG1DN1ZnU2NEWFF1RjBqbStq?=
 =?utf-8?B?aWQ1MHhQT2VRdDFySHh2OFJYeHA5RkEydmdERFJjVTg4UVc1aXNZREtiZThq?=
 =?utf-8?B?c0txejlkbS9acmt6VEdiYjJCUy8xYVlTV3F6Y2lBeExTY21obTllSDkrcEQ2?=
 =?utf-8?B?OXJKTDNINWIwZjBYZVMrdHc4M3NUYVd5REtHRXl0Vk45UWJENkJMNzRsb0lk?=
 =?utf-8?B?TWtQQkIwMVBvb3h1QnFMRHFpcHVYMTRMcGlCNHdwT0lyNy9YWWhmV2pjMERE?=
 =?utf-8?B?OXNXb2gyNHRkaHJaWVIzQWRoNHU3RzBRVGs1OHJKYk1HUFlwRU1ZNkZGNlNu?=
 =?utf-8?B?L2ZidXJPR2EvZkt2K2RubW5zdFNmcWRvZGNnN3JuL3ZRaUI1TDl4NGg0S2J6?=
 =?utf-8?B?VkFMYTJETmZ3angzZlVkckp2b2xidGlOb1RDL2VQN1JPRGdjNjBvcGh4bFN6?=
 =?utf-8?B?OUMwM05JQ2Eva1VYZmtmS3pYZDRJZlAxRVZLZUpUWE5iUWJsMjROaFJaTjJY?=
 =?utf-8?B?Y0NoODhpcEFwelhmeGVtcGJQV0pNdXJBNVoyNlZyWEoyR0FQdzI0cEVlTFJ0?=
 =?utf-8?B?TzAwMGhpMEZYc00rbXhQSXBwSkVmMEV6bUFmMDEyVnY3UEVZcHNjR3dDKzlC?=
 =?utf-8?B?aUtqZXdROWtCQXNlUTlod2pUejJkMHdIdEJIVEVEakxtOHBJR1NpT3ozN3JC?=
 =?utf-8?B?MU9QZVpsN2FVcEVKcUU1MXpEUjd2Z294YkJReC9pdVN0YUdIdC9VeU9KQm1q?=
 =?utf-8?B?VmdwZEdody9lZCtXUDRoTStDNzZtdkQxQjd3RzY0YkNGdFUrdlRmWDJLYnlm?=
 =?utf-8?B?RnViVjc2bnBwS0J5RGFTc1JuVkQraUlCQzlQWU9OaVRrOUhVc2N1c0JlZysw?=
 =?utf-8?B?Q3FCSkhQQnAybVlSQ2RLb3hZRFNYNjY4bU83VmF2UDdoWGNnMkx5RjlGRVZL?=
 =?utf-8?B?cGswNXE2TWdVdjd2WW1wVlhmOWtWVkZGYkNEeUVSVWdpYythOXc2S2ROUHEw?=
 =?utf-8?B?T0ZQVmthcGlwZzdHRllCeVp4RFdidmt4RlpxVUhnVnB1UGR5QVltZDVkZU5U?=
 =?utf-8?B?ZUZJZUlxOFk4RkhHZGFEbi9CSDYzSko2alNHeVhxeGo2TlZIUzdhM0dvMVVR?=
 =?utf-8?Q?N/gIxjv79vqz9ZiqAZn+qDleCWOPfkkrlGAXfHw?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6307b7fb-3f9e-4de2-4656-08d904cc60c7
X-MS-Exchange-CrossTenant-AuthSource: DM5PR12MB1355.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Apr 2021 13:50:09.4777
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Tp43Y4ma/+CN+xhe1GHinWzeuzND3cpiSPyQFwkCAfkJJI8vamnnWRuYQ0alWEUsp4Lxr2Hjj9WMLrH53vAc6w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4337
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 4/15/21 8:06 PM, Tian Tao wrote:
> Since ccp_dev_suspend() and ccp_dev_resume() only return 0 which causes
> ret to equal 0 in sp_suspend and sp_resume, making the if condition
> impossible to use. it might be a more appropriate fix to have these be
> void functions and eliminate the if condition in sp_suspend() and
> sp_resume().
> 
> Signed-off-by: Tian Tao <tiantao6@hisilicon.com>
> Cc: Herbert Xu <herbert@gondor.apana.org.au>
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: Tom Lendacky <thomas.lendacky@amd.com>

Acked-by: Tom Lendacky <thomas.lendacky@amd.com>

And please copy the maintainers associated with the files being patched
should you submit more patches in the future.

Thanks,
Tom

> ---
> v2: handle the case that didn't define CONFIG_CRYPTO_DEV_SP_CCP.
> ---
>  drivers/crypto/ccp/ccp-dev.c | 12 ++++--------
>  drivers/crypto/ccp/sp-dev.c  | 12 ++----------
>  drivers/crypto/ccp/sp-dev.h  | 15 ++++-----------
>  3 files changed, 10 insertions(+), 29 deletions(-)
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
> index 0218d06..20377e6 100644
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
>  
>  #else	/* !CONFIG_CRYPTO_DEV_SP_CCP */
>  
> @@ -144,15 +144,8 @@ static inline int ccp_dev_init(struct sp_device *sp)
>  	return 0;
>  }
>  static inline void ccp_dev_destroy(struct sp_device *sp) { }
> -
> -static inline int ccp_dev_suspend(struct sp_device *sp)
> -{
> -	return 0;
> -}
> -static inline int ccp_dev_resume(struct sp_device *sp)
> -{
> -	return 0;
> -}
> +static inline void ccp_dev_suspend(struct sp_device *sp) { }
> +static inline void ccp_dev_resume(struct sp_device *sp) { }
>  #endif	/* CONFIG_CRYPTO_DEV_SP_CCP */
>  
>  #ifdef CONFIG_CRYPTO_DEV_SP_PSP
> 
