Return-Path: <SRS0=A/Go=3G=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 416FBC33CB1
	for <linux-crypto@archiver.kernel.org>; Fri, 17 Jan 2020 06:40:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 079BD20730
	for <linux-crypto@archiver.kernel.org>; Fri, 17 Jan 2020 06:40:29 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=amdcloud.onmicrosoft.com header.i=@amdcloud.onmicrosoft.com header.b="qg8e6L+j"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728939AbgAQGk2 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 17 Jan 2020 01:40:28 -0500
Received: from mail-mw2nam10on2057.outbound.protection.outlook.com ([40.107.94.57]:1761
        "EHLO NAM10-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727740AbgAQGk2 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 17 Jan 2020 01:40:28 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=giTwVwVg1oldl2SCR8qed7gTqpFYbHoFzpEUdlfcReI4vKGGIdOjeP9X83aHMOyEbituGlOzLFiSXpE3V3tRMpl6b4bQccjsoo0tXhj0FMpM29bHW9Wmto25+D1uXhSPcFr4okdNSG0JfBJbqGnLbr1wyT1GT9hYNF6yVwb0qibGByGEhIwjRyLT7G5FNSUjtsFJ5EiC7T4YrR3xT30tGeg3WTd8Uabz4j0lIf/zetJRtxqUhEOC+OI0v8LBLOUbKTVzhQYwhfzJboXslvQcXLGakrzk8WxpeMgaesPXcc4tR0XB7KlCMDWDEMnCrS7JPm8oaBT2w88EMghk7aV8Ng==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=M7PlYcFP3EEH+lmOdKm6xLjy7fO+3S5nWCyTd4vUZWs=;
 b=UHTl1sADN8wS/qfEyIqV6xQTWZvI0Sqh5bgWMpBJU4zuzOuDeH5WYr/PmrT74z2YSBsnzlkVzjk/AFNlPm/rrSoN8xOc/e0vIepS5coJsjcEqS27/7tvgZIpYwKvxs6eGW/cFT1ZJ+6vRzY5oOTcPMiUmIPRb0Ti0scVwc3aGRputkd/FdYCV5RHCAF6/aS2vqxeO/ATGdxDq7Tc0ZvxDAnR0TrVipJAUkBm9Oi6/E+2u/IXIYrelnNvT5nbsHqkFTZj5soaqcP+AxvNKueTWrOXEk1Oa0/ehYC53raDKwMxiboDZO+7MaPCzz+U4LJNNt+S779iV+Zwtmgpv+ytUQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=M7PlYcFP3EEH+lmOdKm6xLjy7fO+3S5nWCyTd4vUZWs=;
 b=qg8e6L+jd827EplBYKqLUIXQzu8L34TVeIJcapWQ14JHr6ZFaRj48TEGAsisyx4SwPsaip3L8RZaegjILQl12tye11fK5d+1kniWPRe9UqcJSmoV4HjearpB9sKXQlS4vJotRfDMTjZktgbBBzHYcD+dACtFxFwqsbuw0cU28jY=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=Rijo-john.Thomas@amd.com; 
Received: from CY4PR12MB1925.namprd12.prod.outlook.com (10.175.62.7) by
 CY4PR12MB1846.namprd12.prod.outlook.com (10.175.59.151) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2644.18; Fri, 17 Jan 2020 06:40:25 +0000
Received: from CY4PR12MB1925.namprd12.prod.outlook.com
 ([fe80::9be:baba:170f:3e2]) by CY4PR12MB1925.namprd12.prod.outlook.com
 ([fe80::9be:baba:170f:3e2%3]) with mapi id 15.20.2644.023; Fri, 17 Jan 2020
 06:40:24 +0000
Subject: Re: [PATCH][next][V2] tee: fix memory allocation failure checks on
 drv_data and amdtee
To:     Colin King <colin.king@canonical.com>,
        Jens Wiklander <jens.wiklander@linaro.org>,
        Devaraj Rangasamy <Devaraj.Rangasamy@amd.com>,
        Gary R Hook <gary.hook@amd.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        linux-crypto@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20200116154852.84532-1-colin.king@canonical.com>
From:   "Thomas, Rijo-john" <Rijo-john.Thomas@amd.com>
Message-ID: <e6fd526e-316f-539d-9f5e-c039041c4f2e@amd.com>
Date:   Fri, 17 Jan 2020 12:10:14 +0530
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
In-Reply-To: <20200116154852.84532-1-colin.king@canonical.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MAXPR01CA0116.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a00:5d::34) To CY4PR12MB1925.namprd12.prod.outlook.com
 (2603:10b6:903:120::7)
MIME-Version: 1.0
Received: from [10.138.134.82] (165.204.156.251) by MAXPR01CA0116.INDPRD01.PROD.OUTLOOK.COM (2603:1096:a00:5d::34) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2644.18 via Frontend Transport; Fri, 17 Jan 2020 06:40:22 +0000
X-Originating-IP: [165.204.156.251]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 552964ac-aac8-40df-98a1-08d79b1821b9
X-MS-TrafficTypeDiagnostic: CY4PR12MB1846:|CY4PR12MB1846:
X-LD-Processed: 3dd8961f-e488-4e60-8e11-a82d994e183d,ExtAddr
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <CY4PR12MB18461BD949484F38CD2509BACF310@CY4PR12MB1846.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5236;
X-Forefront-PRVS: 0285201563
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(4636009)(39860400002)(396003)(136003)(376002)(346002)(366004)(199004)(189003)(31696002)(478600001)(5660300002)(66476007)(316002)(26005)(66946007)(66556008)(53546011)(6486002)(4326008)(6666004)(2616005)(2906002)(86362001)(16526019)(8936002)(52116002)(186003)(8676002)(16576012)(81166006)(110136005)(81156014)(36756003)(956004)(31686004);DIR:OUT;SFP:1101;SCL:1;SRVR:CY4PR12MB1846;H:CY4PR12MB1925.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
Received-SPF: None (protection.outlook.com: amd.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: /0RLqTyl3TLlJUFIG1FRC6QZ6zB9voM1lMHXGJh8koPhslvSwFZRa4Fg2BH6kL7/m9ltLdda4/80jNKRz8I1Mqatt1cHqL/wUfhphPjzGDDvz4POqTrgeUm4gRlv47LqD7s3k5tfqcGfEho+kxE72kkgDtrcpcBsP9h0HEH1A4hmlhLwhFUq/B8V5hR9q9Zi3fBWw3d3Aa6i0UiJvZGg9o88QqqCuV4Ck8D1n9ZOYL0G7mx+nXs2myBVUtvIm+PFWa3fT8Plikag8xLV+tiPlFmKTJV2Gmxo6h2aoSNUc3ZCh9AxN0IiR41oODo2rwp4wlkwEkYgXIHDnJJa3czPDwY/Ganqy13X5T9ioQ5n45GUpWZLEGVy0w3EKXPxIqamcsWA+UbRCEaAKGrPtr0nSTbVgE9t95dplLTpgUBOb1uI/xm8mUemXTJuxMAI08KE
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 552964ac-aac8-40df-98a1-08d79b1821b9
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Jan 2020 06:40:24.7124
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7EWVShPJ3Lny2JN33yytohBNqTP4mef6Y2hRfDpaf6lamZ4ZRrCsWEKI3u/KRxHwJjRYrKOYnC9O3ue1+LL1+Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR12MB1846
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org



On 16/01/20 9:18 pm, Colin King wrote:
> From: Colin Ian King <colin.king@canonical.com>
> 
> Currently the memory allocation failure checks on drv_data and
> amdtee are using IS_ERR rather than checking for a null pointer.
> Fix these checks to use the conventional null pointer check.
> 
> Addresses-Coverity: ("Dereference null return")
> Fixes: 757cc3e9ff1d ("tee: add AMD-TEE driver")
> Signed-off-by: Colin Ian King <colin.king@canonical.com>

Reviewed-by: Rijo Thomas <Rijo-john.Thomas@amd.com>

Thanks,
Rijo

> ---
> V2: update to apply against cryptodev-2.6 tree tip
> ---
>  drivers/tee/amdtee/core.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/tee/amdtee/core.c b/drivers/tee/amdtee/core.c
> index be8937eb5d43..6370bb55f512 100644
> --- a/drivers/tee/amdtee/core.c
> +++ b/drivers/tee/amdtee/core.c
> @@ -446,11 +446,11 @@ static int __init amdtee_driver_init(void)
>  	}
>  
>  	drv_data = kzalloc(sizeof(*drv_data), GFP_KERNEL);
> -	if (IS_ERR(drv_data))
> +	if (!drv_data)
>  		return -ENOMEM;
>  
>  	amdtee = kzalloc(sizeof(*amdtee), GFP_KERNEL);
> -	if (IS_ERR(amdtee)) {
> +	if (!amdtee) {
>  		rc = -ENOMEM;
>  		goto err_kfree_drv_data;
>  	}
> 
