Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0A91AC433EF
	for <linux-crypto@archiver.kernel.org>; Fri, 29 Oct 2021 13:48:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DB3396117A
	for <linux-crypto@archiver.kernel.org>; Fri, 29 Oct 2021 13:48:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230523AbhJ2NvI (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 29 Oct 2021 09:51:08 -0400
Received: from mail-mw2nam12on2089.outbound.protection.outlook.com ([40.107.244.89]:62560
        "EHLO NAM12-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231510AbhJ2NvE (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 29 Oct 2021 09:51:04 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=U6Hau0YnfFBIeWgUz07FlkUnyvrC/OnWOtZSux4NSeWaF+sFU17rcv2ExFacnvuv0PFnCtMrfwi9Rkk07gPW3SOtpCpacJ+qMyptP6N7bfkndiWinOpEcYhIQBidLp0USW4Us7GoJQIYj1pD43UMcLRBj9WrCbGhC/ZU2GbWRKdHVLuD7OF7fX7/cG55sxWrtZf6IhavP+G83se8qZqXfWFz9lRUxBFYqYYIZNxPMF3iKaoV+P2dXXBlr+NzOGv5bsHprOckR70q3pzl7IzClDNcyezOSyn2Y9iISwFPf+sfndH2Wn+fl4ozQr804Dd2M6Lu3bpvHaQbFt9GLhd28w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qmNwobOzje0/haRVxIxaCNH0f9K/qXOEMndlKy/NKck=;
 b=U0Etp5LJUD0yPwED/l/CnN8PQdyvS85rXCW5Bvet0Wh9VAxqQuKD/5CD5PFi7Q8hbeZehHjlFIHM+vd8FVzi5XWfQYKPSsHobMJb21LhnOzQf7MpKb/zVOtOTKSxqHn/FxuhAnwkDCh4+CzWn3/33mYFubdOvhCFw1f6s3IrEUeHP94qWVzbqIrtFDa7B5ertAI4PhoQk1wP4iguoCceXYr3HmDxBHVULH61pSUImiKHpwgrY0K4pUmd4nVEfRWT1cRUM3deqyUdehSfyWmYbfl4o0It1l64IVPd047rcAeCtuwcNt5vTVNT7/Z7pdiFJckYH8Ea2IpReE7jU5IDLw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qmNwobOzje0/haRVxIxaCNH0f9K/qXOEMndlKy/NKck=;
 b=Wtunrr95JrvHVuuGNk0EA1BtWGb4gwFxcgFgfjJjCn+4CkAtTJWAEIeK/iXfoqT6d+gADzDon8BkGtH3X6QhDaGAViUQg1RCGNFjWcdGtJtmQd+vcy9H2oUrfPs2yZymdj15cYb7/Frr+nLvaqqjUbrKhyQbP+fA/KVnG0gv7ts=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5229.namprd12.prod.outlook.com (2603:10b6:5:398::12)
 by DM8PR12MB5463.namprd12.prod.outlook.com (2603:10b6:8:27::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4649.14; Fri, 29 Oct
 2021 13:48:34 +0000
Received: from DM4PR12MB5229.namprd12.prod.outlook.com
 ([fe80::a87d:568d:994f:c5f9]) by DM4PR12MB5229.namprd12.prod.outlook.com
 ([fe80::a87d:568d:994f:c5f9%8]) with mapi id 15.20.4649.015; Fri, 29 Oct 2021
 13:48:34 +0000
Subject: Re: [PATCH 3/4] crypto: ccp - Refactor out sev_fw_alloc()
To:     Peter Gonda <pgonda@google.com>
Cc:     David Rientjes <rientjes@google.com>,
        Brijesh Singh <brijesh.singh@amd.com>,
        Marc Orr <marcorr@google.com>, Joerg Roedel <jroedel@suse.de>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        John Allen <john.allen@amd.com>,
        "David S. Miller" <davem@davemloft.net>,
        Paolo Bonzini <pbonzini@redhat.com>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20211028175749.1219188-1-pgonda@google.com>
 <20211028175749.1219188-4-pgonda@google.com>
From:   Tom Lendacky <thomas.lendacky@amd.com>
Message-ID: <d3235e92-e29a-3b52-540d-4a49ce53389b@amd.com>
Date:   Fri, 29 Oct 2021 08:48:32 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
In-Reply-To: <20211028175749.1219188-4-pgonda@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SA9PR13CA0081.namprd13.prod.outlook.com
 (2603:10b6:806:23::26) To DM4PR12MB5229.namprd12.prod.outlook.com
 (2603:10b6:5:398::12)
MIME-Version: 1.0
Received: from office-ryzen.texastahm.com (67.79.209.213) by SA9PR13CA0081.namprd13.prod.outlook.com (2603:10b6:806:23::26) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4669.4 via Frontend Transport; Fri, 29 Oct 2021 13:48:33 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 932aff4c-7fc2-498f-774e-08d99ae2cd2a
X-MS-TrafficTypeDiagnostic: DM8PR12MB5463:
X-Microsoft-Antispam-PRVS: <DM8PR12MB546398CB2A0E959E1FD33EAFEC879@DM8PR12MB5463.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: vCk5I8KHHAWbC4XBiAH/ABVQ4FzoWhAikwjDD0qYUtgsJMqcVB/pc9oRbPLwngst88W+bRBaanCXroiZrgZIY1cUvWEgJsYCI1zYXAsr7vrpMwmBi7PSC/bVFro2Zy+5WJjJZ1IhERrVyuGlTgYRzZlaihdUYOPH5kLcEW05eahr3gedTh3fUslrwxEsIELlD1RnOyN553HaMV4/heRPZN9DYD8DOSeyJOJm+qYYq3KonYo1yeFswcMRb0DRyu9/QTmJ6pNtUddUcH1+vpsYqGl3c1T4W8HzKcUyVx5pYF26lgInevDnwsBL2/yrR0ROOCrCegTR2GcIyeAFVjsFNhLNEsjE3zGgAidjXuXP7MJHpwp410WJCnSeFonJX+DuuL90wDXd1Xp3ziA6hLVI6el7KMU6d1vFmzdvEc/j6/k/CaGnVAzvY4tKKWnGVMbs+a1qY7V7USjrz6sO4zrf/lx9ito4x+ee88w4Gn3CGv76xt3jWiZiuUWqhD8ZJGwCspxfQAmYLvnj5tjxwSxZ6zueAnmgrZc6SgGS56/K2s7QaR6WXbwtA0H71INn//oLRaI95tlsAqa4rm/xDP4QMicSHVcgGuceNzY62a47Y+foc+89EkI0yHYniJfq+gbpExq8AqdeGeQuOWOQfnXNOi7BPujov//9YzrLoBnGKrD8CWV6ttJvczCXfGOjODaOb46FQgTktX/3VpmmICWQ7PPqm2eV7QaJl/wljm3PPjZ53fFSHImpT2WeuLYerNzU
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5229.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(2616005)(53546011)(26005)(6506007)(2906002)(186003)(83380400001)(66946007)(6916009)(31696002)(66476007)(86362001)(8676002)(956004)(508600001)(6512007)(4326008)(54906003)(36756003)(6486002)(66556008)(5660300002)(316002)(38100700002)(31686004)(8936002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?WHNRQkFnSUNuT3hLZzFRcVEvMzVGQ05RYUhPODVkYlZ0SnhpZjV2aEZuMmsw?=
 =?utf-8?B?YjgrVDlqRXlPcWhhQ3NKVFRiemRLZDJjdVVRd1BrbUlIVUtSTzlENVlBL0Jl?=
 =?utf-8?B?K1dWUjN2ZVhtYnRIRE92WFZWWkxiVUxhY0xkYVZEWkhIdzlqN1NYbXduNEtE?=
 =?utf-8?B?K1M5alNTOE4xclFQT3U5OGc2MjNzS2ZXNG1xMWo3bXVhR29OZ3g0Zi9Zdkdp?=
 =?utf-8?B?VFppQkdXWmFrQ0FFOEZpNlN6bG02Vnd6M2poMDhTRWY4WmZmM2FqNTVweHNo?=
 =?utf-8?B?Vi9YY0g0d0NEMXQ2OElBa0VDMk5nMko5Rjdya2l2NUdhNUR1NlR0elZGbGRW?=
 =?utf-8?B?OHdsMUR3RTU5NkdBNHVYTkJNcmlvemhBUDVqMkFzdTgvTmNTR2NYSElQemE3?=
 =?utf-8?B?dmlPa3pjejZuaFc2QVkvRStzSWJTanFZdnV3SVpKM3p0VGQrSXZhblRPOTZ0?=
 =?utf-8?B?ZlRtZWV1YmtSVkh0L2tKSmZWRkFLQTN3dDN5eEhla1VMZUY0b1dXY2hlR2cw?=
 =?utf-8?B?NElZUTBFYlVSV1l0Ny9xc1B5Vk1TY1JKVXBWRGVPZ1lFMk5YTm1lVmlkUXpo?=
 =?utf-8?B?QXNDMGkvWkRKemFpRjNTRkdHcDl4SDB5NDkxUmwybUNIUWw1eFV0UDZPUzBm?=
 =?utf-8?B?VWhUOFhOWlMxWEVWNTdaK3FEb1U3UmxOT2ZmcFdoSVFQaXZxMEtCTHc0Tkt1?=
 =?utf-8?B?SmNIRlAycm9CRXppN0t1Z2QzNVkyemhSMk9NNVl2VEJDalBJN0I4cXFYSnRN?=
 =?utf-8?B?ZVRZeFZJU0R5YmFxR2Y0RzJTNzIvdFJQb1A1NzBqRFVXckdrT0pBV29XRzY1?=
 =?utf-8?B?R1V1U1lvYWprUjEwMzBBNTFOalFSWGRBbnVaYWkrWVNMdE9HaTJOY3FaMWRh?=
 =?utf-8?B?VmxETDIyMWJwUW1WMVFhSUZTUmR4c0xxUEV2aENhL04xZmM4WVJCbU9wSWFJ?=
 =?utf-8?B?S084blJWUlU0SkkwcGl4emhJVzNBVDNpWDNEenFKRTFRcEE5L2h1TUZ3VGYv?=
 =?utf-8?B?YVZ6TW90OW9ZRjRxQW4rc2Y2dEluMlFGTkFOcVgyRzlXT2gvSy9pUlkrNE5I?=
 =?utf-8?B?UlBmdGJVZDlEa1hzVHc1dGY2Vm1wOWRhOUlSUkUvNmxVaWdERjluaDlBaXRi?=
 =?utf-8?B?b0tQL1UxdDFHWWZmSjdJaU1BWVVmWVVPQWpTcnVJOU8xMENsSCtQUWk0TVly?=
 =?utf-8?B?T3A2R3ZrY2F0eXVvTjdJc3RlSlpNMm9lUG15NDQ0YisyZUxhMkNuVXdEYkgv?=
 =?utf-8?B?NENGeS82TUlVZXNHRDlZTTNtZk5YWUJqdHNpSlNGOSt2WFZvbHVkYXJxSmhD?=
 =?utf-8?B?UnpHZ1lLYnpZbWQ0RnR6cmgrVHlIbDI2elVCVGo3YXF5cC9HbklVOFlLTTVH?=
 =?utf-8?B?RldMOUYwTDRPaU10SWFpaWk4bFRJTFQySFpFU3poaGdvVzBYcGtSdHBHazZJ?=
 =?utf-8?B?R1pPOXJqQlEzdUV0bVdUOEpGaVRjV2VJY2paazhPVGpGdnhlNzkxSWwyYUpy?=
 =?utf-8?B?M2g5NE45ODBGaFQyUGY0RURRZTg4UzdkMDJjT0VLQzV0MXQ3b21mQlpzcXM5?=
 =?utf-8?B?SlR4blFuMjdqUWNZZ2tDaXdCL3ljWC93RWdlRGVxZXpyWHluMjhlSUFKckM5?=
 =?utf-8?B?MGJGd2VId1lLdmFhUXZCekRoMk1peWtEbC9CN2t6ZTlZdUdpbWJzQnI2UVd4?=
 =?utf-8?B?WjhWMWFkSW9VTlBhRUZTcncxWU9TT1dUYmtoSXYxUTF2T3ArZ0JaWmFYRUNJ?=
 =?utf-8?B?YkNNU0l0YTNqYWU3dzhiQmZxNUtPekhTdFpNMGhQSFI4VWx4MFRrUGRhQlQz?=
 =?utf-8?B?bjRyMDh0ZU16dWRQNDVEWFBFd1VacmpKUjVGOHBOdTNpY1RLdDFRZDNsNTMr?=
 =?utf-8?B?QW5tTml1NFAySTIvc0d1dUtIZldja1ZHOUk0TFA5SDdNRHFjU2I5UDBSZmJh?=
 =?utf-8?B?ZUlIYkpWamVyQXZCUmcwcjl1WjA4dTVqTnVPMVkrTVVJOEJoV2lGd3I5QXMx?=
 =?utf-8?B?UDN5MUp2K3VrOTl2ZVFtSTNVV3c1L2dyL1llckNIY3RtMUtoQW9kTjVPams5?=
 =?utf-8?B?cEcycjB4SWJKSnJvRVBoRDJsVWZpQmVZZHQrNWVIU0phU2Z6OXFUeWhWQnow?=
 =?utf-8?B?WVpFS3BQSUk2ZmR4c1pFQm9SYis4SkliamNVbkxLNDNZZTZPSHgwbHBHU1BB?=
 =?utf-8?Q?eUPHMJ07pVAcZMPQvP6TfLM=3D?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 932aff4c-7fc2-498f-774e-08d99ae2cd2a
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5229.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Oct 2021 13:48:34.6607
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hasbIZ45hXuCMdSm/5TWgST75n7bkp/grvLQ5wMzCmP+Ks4wjQhXrjDhz2wg2WtSRKZrS8XoI+AKJAK4GXCe6A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM8PR12MB5463
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 10/28/21 12:57 PM, Peter Gonda wrote:
> Creates a helper function sev_fw_alloc() which can be used to allocate
> aligned memory regions for use by the PSP firmware. Currently only used
> for the SEV-ES TMR region but will be used for the SEV_INIT_EX NV memory
> region.
> 
> Signed-off-by: Peter Gonda <pgonda@google.com>
> Acked-by: David Rientjes <rientjes@google.com>
> Cc: Tom Lendacky <thomas.lendacky@amd.com>
> Cc: Brijesh Singh <brijesh.singh@amd.com>
> Cc: Marc Orr <marcorr@google.com>
> Cc: Joerg Roedel <jroedel@suse.de>
> Cc: Herbert Xu <herbert@gondor.apana.org.au>
> Cc: David Rientjes <rientjes@google.com>
> Cc: John Allen <john.allen@amd.com>
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: Paolo Bonzini <pbonzini@redhat.com> (
> Cc: linux-crypto@vger.kernel.org
> Cc: linux-kernel@vger.kernel.org
> ---
>   drivers/crypto/ccp/sev-dev.c | 24 +++++++++++++++++-------
>   1 file changed, 17 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
> index e4bc833949a0..b568ae734857 100644
> --- a/drivers/crypto/ccp/sev-dev.c
> +++ b/drivers/crypto/ccp/sev-dev.c
> @@ -141,6 +141,21 @@ static int sev_cmd_buffer_len(int cmd)
>   	return 0;
>   }
>   
> +static void *sev_fw_alloc(unsigned long len)
> +{
> +	const int order = get_order(len);

This should be an unsigned int to match the function definition, but is 
probably not needed given the comment below.

> +	struct page *page;
> +
> +	if (order > MAX_ORDER-1)
> +		return NULL;

I believe alloc_pages() already does this check (and provides a warning 
unless requested not to), so this check isn't needed.

> +
> +	page = alloc_pages(GFP_KERNEL, order);

Without the above check, you can just replace the 'order' variable with 
'get_order(len)'.

Thanks,
Tom

> +	if (!page)
> +		return NULL;
> +
> +	return page_address(page);
> +}
> +
>   static int __sev_do_cmd_locked(int cmd, void *data, int *psp_ret)
>   {
>   	struct psp_device *psp = psp_master;
> @@ -1076,7 +1091,6 @@ EXPORT_SYMBOL_GPL(sev_issue_cmd_external_user);
>   void sev_pci_init(void)
>   {
>   	struct sev_device *sev = psp_master->sev_data;
> -	struct page *tmr_page;
>   	int error = 0, rc;
>   
>   	if (!sev)
> @@ -1092,14 +1106,10 @@ void sev_pci_init(void)
>   		sev_get_api_version();
>   
>   	/* Obtain the TMR memory area for SEV-ES use */
> -	tmr_page = alloc_pages(GFP_KERNEL, get_order(SEV_ES_TMR_SIZE));
> -	if (tmr_page) {
> -		sev_es_tmr = page_address(tmr_page);
> -	} else {
> -		sev_es_tmr = NULL;
> +	sev_es_tmr = sev_fw_alloc(SEV_ES_TMR_SIZE);
> +	if (!sev_es_tmr)
>   		dev_warn(sev->dev,
>   			 "SEV: TMR allocation failed, SEV-ES support unavailable\n");
> -	}
>   
>   	/* Initialize the platform */
>   	rc = sev_platform_init(&error);
> 
