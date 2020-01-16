Return-Path: <SRS0=he+G=3F=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8BDF1C33CB1
	for <linux-crypto@archiver.kernel.org>; Thu, 16 Jan 2020 10:58:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5E80E20730
	for <linux-crypto@archiver.kernel.org>; Thu, 16 Jan 2020 10:58:55 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=amdcloud.onmicrosoft.com header.i=@amdcloud.onmicrosoft.com header.b="Zr5NYVN4"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726045AbgAPK6y (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 16 Jan 2020 05:58:54 -0500
Received: from mail-mw2nam10on2069.outbound.protection.outlook.com ([40.107.94.69]:16923
        "EHLO NAM10-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725800AbgAPK6y (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 16 Jan 2020 05:58:54 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=J07uo289QU58HU+pYJNwNTk/Nyx+wPdydWxTGEBdiiuKRmthKsHqHA5gMOdIRv5uTzl2dlz7Grf6vKSdPI2dvOC6qUJCaicEDV5xZbL3Ed7wrT8/5lWpY+F5rkHHOmGacaEhpofJ0fuvCYvDjyehh6Nn3hnhHuU0QvK4rzmDObuLVjq3VSn/aibE3ZJjJ0HFFP0E/GNThtmRYoh7KURNmm4DSz3xZJnK6+usgVjUVgXXAWrEB0qSHrQPxRHM/674YtNEM66fJ6tpKEiIFHM7J3ZcZySNNQO6MPpCUwRXo191YRzLeuy4mey5ofu/t8JjuXRQjSTWBKKa0VWhni7CvA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HGAG+slMqjyAWdX8XkdmD1ChjaZBeRgZdoGenTW0mPE=;
 b=bOT5HWuVDqo4f3Z8IxpjwvXYob1grI/E9BUVa014II1w4V38tQv7duwUwNtuC+4zewAtP3sai+f93ymVW99EO1bhSH6GWWXiWITL3Kv8ZrP/lIn8GwTW0yN7qx53+jaN7YPfXPvA1Om1pV05f/LBgRzNCiFdhVnGrJpUtkaJcqjsgy9u2h9298oy9dq0obuwZb7SJHph5n7Z1ygYRnS+X6PVTMJOVT9OxVoq4A0/yTkHC+2iJWoT3a/+8nRC7mdTDcgr5kbm7exi1ud9IIW2wgrQRXEg/JawD4UnZmJY1hhJ1sEK8jUv+aPjJny24xBptquyWiySJ6AIjCfQJX44GA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HGAG+slMqjyAWdX8XkdmD1ChjaZBeRgZdoGenTW0mPE=;
 b=Zr5NYVN4qr/i5Z/+NLHkxhhxClro1y/Xi9seND2ufvbW1iSmGcoqtDC6Bk/Kqy3xTKcM+pju5A1yImyXYMAPperjzSxf5+e9dQIY5ZEE1dW4TDrXG9QS4abtfPZ8FWf7kd0VmC7TbmBKqst2uuY8EXbyJyRRcMW3TwQi/u/Hdow=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=Rijo-john.Thomas@amd.com; 
Received: from CY4PR12MB1925.namprd12.prod.outlook.com (10.175.62.7) by
 CY4PR12MB1783.namprd12.prod.outlook.com (10.175.62.145) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2644.20; Thu, 16 Jan 2020 10:58:50 +0000
Received: from CY4PR12MB1925.namprd12.prod.outlook.com
 ([fe80::9be:baba:170f:3e2]) by CY4PR12MB1925.namprd12.prod.outlook.com
 ([fe80::9be:baba:170f:3e2%3]) with mapi id 15.20.2644.015; Thu, 16 Jan 2020
 10:58:50 +0000
Subject: Re: [PATCH][next][resend] tee: fix memory allocation failure checks
 on drv_data and amdtee
To:     Colin King <colin.king@canonical.com>,
        Jens Wiklander <jens.wiklander@linaro.org>,
        Gary R Hook <gary.hook@amd.com>,
        Devaraj Rangasamy <Devaraj.Rangasamy@amd.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        tee-dev@lists.linaro.org, linux-crypto@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20200116094954.54476-1-colin.king@canonical.com>
From:   "Thomas, Rijo-john" <Rijo-john.Thomas@amd.com>
Message-ID: <b90be612-a08d-86f8-3419-8988289147ad@amd.com>
Date:   Thu, 16 Jan 2020 16:28:38 +0530
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
In-Reply-To: <20200116094954.54476-1-colin.king@canonical.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MA1PR01CA0119.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a00:35::13) To CY4PR12MB1925.namprd12.prod.outlook.com
 (2603:10b6:903:120::7)
MIME-Version: 1.0
Received: from [10.138.134.82] (165.204.156.251) by MA1PR01CA0119.INDPRD01.PROD.OUTLOOK.COM (2603:1096:a00:35::13) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2644.19 via Frontend Transport; Thu, 16 Jan 2020 10:58:47 +0000
X-Originating-IP: [165.204.156.251]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 2410e713-b888-42ae-377c-08d79a73117b
X-MS-TrafficTypeDiagnostic: CY4PR12MB1783:|CY4PR12MB1783:
X-LD-Processed: 3dd8961f-e488-4e60-8e11-a82d994e183d,ExtAddr
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <CY4PR12MB17833F1138C862D15E2706BCCF360@CY4PR12MB1783.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4125;
X-Forefront-PRVS: 02843AA9E0
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(4636009)(376002)(396003)(39860400002)(366004)(346002)(136003)(189003)(199004)(52116002)(26005)(16526019)(31686004)(66556008)(66476007)(66946007)(86362001)(186003)(110136005)(36756003)(5660300002)(316002)(16576012)(81156014)(8936002)(8676002)(31696002)(53546011)(81166006)(6486002)(478600001)(6666004)(2616005)(956004)(2906002)(4326008);DIR:OUT;SFP:1101;SCL:1;SRVR:CY4PR12MB1783;H:CY4PR12MB1925.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
Received-SPF: None (protection.outlook.com: amd.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: hM0QzSEpgiAd1Cnjjvnig/WGWriNbF6RBlEV8gGdHvYYU13saiUMER3Gs6/GoiImMdMivfkFQVYDbL6kKpqFu2HbQSjBV8S4WElqbWLFp/CHPSDO4v3oPCBGG3h8irSsBiBIsuhaWidWqUatebiNlXq5wVmkeUkonFzmBm+4WOUQa8JolovZIGFNuQpotzcIoDA9ZNeGEJ0eE8C14lCRS88UjA4eNzrsutCnJMFbmtG/NP74Gn7Ed1vur4LGnSo0fcLgIhx4Gawy7dSEzNjtNYy4+lYGz+R+RUa2FDT6PcSory04PQdUDb+2GApdY7bi3IB6BqrMoMDVhLa2OC/YUpYeQUGxWjCHZDLYL9YoOt5MllwNEyulpciAlhefymaZa5QA6oGbJqoqZpuvAnXV5JP3oUlogieE0L1/ZbMVOB/JID4eryenyAAC9TUvxLZQ
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2410e713-b888-42ae-377c-08d79a73117b
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jan 2020 10:58:50.3138
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8MN/EU9bCbkYovv3H4AGHmZaquytUlIoluME/p4nG5Xi5bnikgni1ZjLHeEHqNIF5Y+qKLZOTe+KwpSZnPR1Zg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR12MB1783
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi Colin,

On 16/01/20 3:19 pm, Colin King wrote:
> From: Colin Ian King <colin.king@canonical.com>
> 
> Currently the memory allocation failure checks on drv_data and
> amdtee are using IS_ERR rather than checking for a null pointer.
> Fix these checks to use the conventional null pointer check.
> 

This patch does not apply cleanly to current cryptodev-2.6 tree.
Request you to pull and rebase the patch to current cryptodev-2.6 tree,
build and then submit.

Thanks,
Rijo

> Addresses-Coverity: ("Dereference null return")
> Fixes: 757cc3e9ff1d ("tee: add AMD-TEE driver")
> Signed-off-by: Colin Ian King <colin.king@canonical.com>
> ---
>  drivers/tee/amdtee/core.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/tee/amdtee/core.c b/drivers/tee/amdtee/core.c
> index 9d0cee1c837f..5fda810c79dc 100644
> --- a/drivers/tee/amdtee/core.c
> +++ b/drivers/tee/amdtee/core.c
> @@ -444,11 +444,11 @@ static int __init amdtee_driver_init(void)
>  		goto err_fail;
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
