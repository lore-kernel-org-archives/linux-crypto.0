Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4E8B0C433B4
	for <linux-crypto@archiver.kernel.org>; Wed, 14 Apr 2021 22:48:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1B65561029
	for <linux-crypto@archiver.kernel.org>; Wed, 14 Apr 2021 22:48:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233544AbhDNWso (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 14 Apr 2021 18:48:44 -0400
Received: from mail-dm6nam11on2067.outbound.protection.outlook.com ([40.107.223.67]:23392
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232276AbhDNWsm (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 14 Apr 2021 18:48:42 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JyvLYoKMeFcuDkqQBfLy3qmxZ367gCKFVlTW9wFN5oe3iPl3wd3b3k6QtgWcFKnVHhDs4NzPguAWOkHr3Q8maUhhgqH145znn/p0+TpoNLkCxFGkT3GlTzn/kM4G5AsrF0HozbESx4O8sQcWZytaDyfwzr8LAWE/BjrWdsg/uroNUbiMquKUTuKGGGuOzduv/zaQOvos7mj/oospQoYlTL8xEZ0G5CR6x9QhdgJUoL1lSqTUO7y2Cow9T4beB5Q0puRGmuH05mWyut3AHSxcN7MJTpIhFLrtzUJYVB0VH2JKbIgM/Xl6pM8chylfjvUN2yMD77FtyYCERTWH9RQTvA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Dv1LxNfBya9qpX+CAeFYpZ6KAQ6nQRLYrM1n3Lj2sPM=;
 b=HXkWG4IBK6/OaGYtp9OkxeERKEV8RFiC1mQb2VdtUx+ksaq7FqIUTnfJtCDqCNuQzyeYgUwGK3qUnOhf+etumnnlIPPsYhlX1fpS6hHeCDMMLIZp8r5akrWWNiN6qRXv7dQ3DVO+LpHn9ARHOLX6tgRaJT6+RJZ/Kfh9R2YrNYexs81ilw1JBrtWDyibmpkqxrlvbJkR21WPcYD1dJd4xQpi2IhuZvp4JIi8LGRSjOiuwIPH7W9bpC8LEpqCTdXMxV4H7vMl/fybHo5sXmCSXYYSuh6gnC8JS9hbTi7UsawD4zjwRxGcdo7Alnkiqfisfp/5AsrWQxpdPGnX3D0WHw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Dv1LxNfBya9qpX+CAeFYpZ6KAQ6nQRLYrM1n3Lj2sPM=;
 b=Mrjb1anxYvGOftvdJ1MWfP0hsP2u1ATtvjy+u9UrapNMH3zd4RG94F/Z0vtH5d/ri2aHI8y7oGUEV+XqSsfvsGsC0oS+DpT0+BxsDQjShr0WNfa5ShK0Md5hWzlCZt9FraXl8UtMM2RKNkd9P5P/CLYOvsxW32dsEl49jok6r6M=
Authentication-Results: amd.com; dkim=none (message not signed)
 header.d=none;amd.com; dmarc=none action=none header.from=amd.com;
Received: from DM5PR12MB1355.namprd12.prod.outlook.com (2603:10b6:3:6e::7) by
 DM6PR12MB4058.namprd12.prod.outlook.com (2603:10b6:5:21d::16) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4042.16; Wed, 14 Apr 2021 22:48:18 +0000
Received: from DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::b914:4704:ad6f:aba9]) by DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::b914:4704:ad6f:aba9%12]) with mapi id 15.20.4020.022; Wed, 14 Apr
 2021 22:48:18 +0000
Subject: Re: [PATCH] crypto: ccp - Fix to return the correct return value
To:     Tian Tao <tiantao6@hisilicon.com>, herbert@gondor.apana.org.au,
        davem@davemloft.net
Cc:     linux-crypto@vger.kernel.org, John Allen <john.allen@amd.com>
References: <1618391864-55601-1-git-send-email-tiantao6@hisilicon.com>
From:   Tom Lendacky <thomas.lendacky@amd.com>
Message-ID: <ab70b5f7-6501-f6be-c879-29f764780b1a@amd.com>
Date:   Wed, 14 Apr 2021 17:48:15 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
In-Reply-To: <1618391864-55601-1-git-send-email-tiantao6@hisilicon.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [67.79.209.213]
X-ClientProxiedBy: SA0PR11CA0088.namprd11.prod.outlook.com
 (2603:10b6:806:d2::33) To DM5PR12MB1355.namprd12.prod.outlook.com
 (2603:10b6:3:6e::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from office-linux.texastahm.com (67.79.209.213) by SA0PR11CA0088.namprd11.prod.outlook.com (2603:10b6:806:d2::33) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4042.16 via Frontend Transport; Wed, 14 Apr 2021 22:48:16 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7565d96c-8a05-4559-4daa-08d8ff9764f8
X-MS-TrafficTypeDiagnostic: DM6PR12MB4058:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR12MB4058E394C9723294A784F4EEEC4E9@DM6PR12MB4058.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4125;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: VZpW+M5EIOn2HJ0I2Idgq4W+8+2y0SsFkcxeyDznGyIt6vYLo5iTwetrtn/Sgk0WWKSSOVaiDfl6Ne0MAHjTDdzDt5hfo7YB/vdfbZ6aVPpUujKRgSti+vsFCMks3Ao1pXdNhksAE0sh8B2PPLz2lhnzw7AJTdz6ngHLRkX8lL4BGJ2Us+pDJCMi2uo7VLSMZhRFf39Pm6sr6stlz/sRtmzes5Ek+Tfnnidh0kb7BKF53blQWi+QenfjzaEyM9C/uxnJvGW3rPsnAEzMQabTeLpf0eUYn0P/sHAlKT8JcD5Gl/ZhbgUp6qt6Zm7RUaS/HHGyGopAwOo8KmvmQIfuwbcYujZs42e0AtFk8om4GBqwIiONKR4/45TSSy3zomGP6GHCTvl7t+s1Q4wPYmcszePievnS6dZO+hleGMxBACl9cDUicf0agGcnPyqdO0NaV6txrfLxzYfO7J56AXahSnDYA98ZGRB/+kmsm+OtX6k6bLxlm4Yi1BvIV/mGSsbN+zBuFjOdVD5oWrsTqFQxE7nD7CxOsEEBZXUWm7W6Wa4k1BBjACaYBIQyJI6hYOoLYiKCsPhClYk35sxDPwMzsvcdBYE+fgxT/+xt9CyC8jVWQQiRLezgwxTvDY60T6qAMYHK7ZX6w0xMlY5p355ufpmRyBieQHqwXC8S6ZF8jNMDDzB/V29x1tB9PBld8Cq2
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR12MB1355.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(39860400002)(366004)(376002)(136003)(396003)(5660300002)(26005)(478600001)(83380400001)(36756003)(31696002)(186003)(8936002)(316002)(6512007)(4326008)(31686004)(956004)(66556008)(66476007)(66946007)(2906002)(6486002)(8676002)(38100700002)(53546011)(6506007)(16526019)(86362001)(2616005)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?bGUwZHRhdXVKaEdUMWEyTzdIamNhZDVoNEYrNzBOZ3VOenlrbFA4MmJ3OG1u?=
 =?utf-8?B?TEV0SWZKcW1oZzM1OS84aTNyOVBKbldNZWZjbUVCb3dycnNUUlRqUkV6V1Ix?=
 =?utf-8?B?UXFsWEgrZE5DVGRzWXkxNVU3RHAzSnZkZE10aW1GMHJuMzlnbXlXUjk3YjZD?=
 =?utf-8?B?Y2dqSjhLZWlwQkdUb1RuVElVWmpybzhSWitDakFKNlQ3Q1YwUkQ5SERaOEVz?=
 =?utf-8?B?TWhxcHR3NmtwYTVkZ3YxRDFHM2hRdXU0WlBpTlUvL3pzQkVDOUdJV0NtaDhR?=
 =?utf-8?B?eFlJL002Z1BtYzU3WSsrcWo4YXhEeUQ2dTVuaU1Tbzltd3Fkdk1RVlYydGk0?=
 =?utf-8?B?cFllVnhmZ09STjN0UFIraVJydzkxemlBTW45a05XSGN6QlRHL2Z3eEZLR3Bx?=
 =?utf-8?B?RTdNMzdRclZZeDE5ZC9wMmNBVHB1dEU1OTVucCtaRXJPTlRqQzJKV3E1SVNM?=
 =?utf-8?B?TzkwSWVGRWk5dTFKM0FMVFFGa21Qcy9MbUt3b0xOc3A4ZVBib284OUcvMFZa?=
 =?utf-8?B?MVJRYlFITzZFMGtCOWZuVDdKRDFUa1RDUkF3V0JBRzZmQ3p0T1lqaGYzNjBs?=
 =?utf-8?B?UW00elMxMWFsSEU3cXIyZ2x3NC84WENkeFBMTmZ6ZDl4T294d2JxZTFycXdV?=
 =?utf-8?B?M05HTDNGZ2phajc5aXdYRDM3WlVIeTVST0JJa040ekJPbzVTY2JkSHQyNjg3?=
 =?utf-8?B?eHRMSnRCNTBrZHlRTDNWRE9kT1MzMTdZeUN5aW5JalNhdUYrN2UycDFqQnBX?=
 =?utf-8?B?WUxLdjhOYkEyVDZZVUIrYXdnVzUzWWxyTXlKNWFmQ2lHdEZEcUxON0dPVUk3?=
 =?utf-8?B?OUE4TDZ6VnRWaTBXTE51NEVIR0gyTW56WVZZV0dkWGNSaTdQdGZBUC9HYlNn?=
 =?utf-8?B?c1EzZ0VUQVkxRHI4M01yMmx5Q28vL0dUUnFkZm00N2lkT09qVkFwM3h5K0JN?=
 =?utf-8?B?R1lGTlVpQ2d2Z2xaNnNzYndaTmk3U0RVMUxKMUJiUGVVVktwN0UxR3hrbDBr?=
 =?utf-8?B?RVoycHdOMldGZGtIRjh6US9Qc3RzR3pkSVZwOVVIalBhU2lPLzZrQi8wMjNV?=
 =?utf-8?B?RkRPWDk0Nk9xZ2F4MmVYSTdidkhsSGFYcWhTNklLQ1hFY2hnZ0NONDMzekIy?=
 =?utf-8?B?eTNGWVQ3MHNBaS9LL3QxVnNHODVXV0N5Tml2eXAybTcrVVZ1NzQrM1VCV3hS?=
 =?utf-8?B?Qm1NOHprcHkxTzQ1WmVSSmFHTmlCWHJyeFQyWFFaUXNuQmVROXVhK1lESFRv?=
 =?utf-8?B?NklGNkR5akVlL0ZJMDBJVERiTkRCL3JVNjRic1BRSEpTZlJLeGFEd3d1ZUdn?=
 =?utf-8?B?RTBnZVdkenRPYmVWemR6NWoyVDlnVFA5SW5JUlJ3OVZ6cHJ3bEJnUHB6K1JH?=
 =?utf-8?B?bjVCMWhZWSs2by9KUGV3VWZESTZsUUI4d0cvWFc0ZW52UG5DZXIwZXRUTnJY?=
 =?utf-8?B?L2lvVUE4dGxVallXWlFnRU4zSk4weTJKZVhXNkVBQ1k0R3hHcVZSQmM5bGMv?=
 =?utf-8?B?b255RDJybS9XYytkb2JodHF1SEx1TnBWTithQkpkengveCtCYkdDL09mNWFy?=
 =?utf-8?B?blZWa09zU3dKVnRKbGd0SkVzWFA0TEVHVkRWbmVyWk1rbzdVWG56cnlwdi9O?=
 =?utf-8?B?M2czY01HYVJjZUQ2YmtaT0xKOG1wbTJLTlMzSkk1Y0NLeTRoU0o4M0JYRVdS?=
 =?utf-8?B?dHBQQWdoOGdpUWdpWGhxSE42WFRWWCtieVdJNllUdGxDaDQ3LzlrbXlCbVNZ?=
 =?utf-8?Q?AynoARC7/0XqP0DpB2NozMbZe7wFOtVOWD6RP4P?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7565d96c-8a05-4559-4daa-08d8ff9764f8
X-MS-Exchange-CrossTenant-AuthSource: DM5PR12MB1355.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Apr 2021 22:48:17.9690
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: uJ2kuTFFo0SAo0aW2L4Kxv9c8GSbxAYUzTrz0k+yE/ogBcfYI53HiusIOluqh8bH9hVGMBREv+aHtjB1Fn6xXQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4058
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 4/14/21 4:17 AM, Tian Tao wrote:
> ccp_dev_suspend and ccp_dev_resume return 0 on error, which causes
> ret to equal 0 in sp_suspend and sp_resume, making the if condition
> impossible to use.

Why do you think that is an error and why do you think it should return
-ENXIO? Since ccp_dev_suspend() and ccp_dev_resume() only return 0 it
might be a more appropriate fix to have these be void functions and
eliminate the if condition in sp_suspend() and sp_resume().

Thanks,
Tom

> 
> Signed-off-by: Tian Tao <tiantao6@hisilicon.com>
> ---
>  drivers/crypto/ccp/ccp-dev.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/crypto/ccp/ccp-dev.c b/drivers/crypto/ccp/ccp-dev.c
> index 0971ee6..6f2af7b 100644
> --- a/drivers/crypto/ccp/ccp-dev.c
> +++ b/drivers/crypto/ccp/ccp-dev.c
> @@ -556,7 +556,7 @@ int ccp_dev_suspend(struct sp_device *sp)
>  
>  	/* If there's no device there's nothing to do */
>  	if (!ccp)
> -		return 0;
> +		return -ENXIO;
>  
>  	spin_lock_irqsave(&ccp->cmd_lock, flags);
>  
> @@ -584,7 +584,7 @@ int ccp_dev_resume(struct sp_device *sp)
>  
>  	/* If there's no device there's nothing to do */
>  	if (!ccp)
> -		return 0;
> +		return -ENXIO;
>  
>  	spin_lock_irqsave(&ccp->cmd_lock, flags);
>  
> 
