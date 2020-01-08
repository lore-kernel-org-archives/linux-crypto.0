Return-Path: <SRS0=xmdE=25=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C195FC33C9B
	for <linux-crypto@archiver.kernel.org>; Wed,  8 Jan 2020 07:03:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9733A2077B
	for <linux-crypto@archiver.kernel.org>; Wed,  8 Jan 2020 07:03:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=amdcloud.onmicrosoft.com header.i=@amdcloud.onmicrosoft.com header.b="sTmrIvem"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726276AbgAHHDx (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 8 Jan 2020 02:03:53 -0500
Received: from mail-eopbgr770051.outbound.protection.outlook.com ([40.107.77.51]:11648
        "EHLO NAM02-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726079AbgAHHDx (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 8 Jan 2020 02:03:53 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ih/mPthNnhrkM2tzJXoxHPcQA4WChnq5NzTqLkjfPcE6vJP483U5w/9oGe3kXVfMZLlNV/730tpPH4Vk40ouuFwIAx2aR6P4UqzJJYDBdDSk5eIBiuE69Rbeg+1nhJVnCYGYn4xJo5WeaJvkGzbXq/RMc5a7iXPYvOT90U+C5sYW4Tmepxer+L+fGvtixgkNpsbpPRt5BgPCQIMwfLHK1hV2P1NiZfvmVXz+G6fial3Pnni7JxAVuaDbM9SbF5RZly4um1ahLL/WRA8F2YyyMwzQHGOHfCaC91okWQ/fIcsQ7s0VMmqzApYZpz23wsmZ1Ye9iRBKRZRZWi0hRR8tiw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=j41qF1+hLtEV+4ccB2oV3859/aVT6qDeQErygfdK7ac=;
 b=EYTARfcRC1QC0I0/olN2v3tRQJYjJkblCNMQMCZ1Mq22kmYTOpMP00otN+TbRYD5rI5SUKCSKC0qcClrtgVWd+GNt+kbTWva8vEVk+42butzUKL6P4dFt0qRGK38GThZacT590cpLCGWvULqBIF6z7citH8M5pRuC5vFF2cSj1T6slUQYq6mpNSQFo1KtOpMPyZQYSLfaTcv1LHQcHtZaH/fIS1uq3/rdqAWYbj2g1sMjZlEd5pHU/oOSNmwqDym+EIOcQE+kKFtW36U9w2eTRzL81AH9xXjy8Dg/a/AeUFVYVcib4iX9Hj5qn5R2VDs1h120D+JjcU/1kTkc7Qhzw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=j41qF1+hLtEV+4ccB2oV3859/aVT6qDeQErygfdK7ac=;
 b=sTmrIvem7Ir3BBCisZ/zsLpck9xAqERsVWa38TqntNj2o9b1tS4svq6CAci+EADIIiBVhpTHDNNoBsT/26qEmNz4imyAvZngYUcDI9pcsa/gq6qa9L9ELqlfIj1r+1CvnhWbcLal0fCxte9b+0ydPhQWdTXnskiT/KFd93qsrwA=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=Rijo-john.Thomas@amd.com; 
Received: from CY4PR12MB1925.namprd12.prod.outlook.com (10.175.62.7) by
 CY4PR12MB1557.namprd12.prod.outlook.com (10.172.69.23) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2602.13; Wed, 8 Jan 2020 07:03:48 +0000
Received: from CY4PR12MB1925.namprd12.prod.outlook.com
 ([fe80::9be:baba:170f:3e2]) by CY4PR12MB1925.namprd12.prod.outlook.com
 ([fe80::9be:baba:170f:3e2%3]) with mapi id 15.20.2602.016; Wed, 8 Jan 2020
 07:03:47 +0000
Subject: Re: [PATCH][next] tee: fix memory allocation failure checks on
 drv_data and amdtee
To:     Colin King <colin.king@canonical.com>,
        Jens Wiklander <jens.wiklander@linaro.org>,
        Devaraj Rangasamy <Devaraj.Rangasamy@amd.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Gary R Hook <gary.hook@amd.com>, tee-dev@lists.linaro.org,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20200107143601.105321-1-colin.king@canonical.com>
From:   "Thomas, Rijo-john" <Rijo-john.Thomas@amd.com>
Message-ID: <747f9c93-7465-99aa-0b91-a05fd64c7d1f@amd.com>
Date:   Wed, 8 Jan 2020 12:33:08 +0530
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
In-Reply-To: <20200107143601.105321-1-colin.king@canonical.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MA1PR01CA0078.INDPRD01.PROD.OUTLOOK.COM (2603:1096:a00::18)
 To CY4PR12MB1925.namprd12.prod.outlook.com (2603:10b6:903:120::7)
MIME-Version: 1.0
Received: from [10.138.134.82] (165.204.156.251) by MA1PR01CA0078.INDPRD01.PROD.OUTLOOK.COM (2603:1096:a00::18) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2602.12 via Frontend Transport; Wed, 8 Jan 2020 07:03:45 +0000
X-Originating-IP: [165.204.156.251]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: bc1ea619-ab58-4c72-d567-08d79408e84d
X-MS-TrafficTypeDiagnostic: CY4PR12MB1557:|CY4PR12MB1557:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <CY4PR12MB1557FB714FF49BE43189CDEACF3E0@CY4PR12MB1557.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3044;
X-Forefront-PRVS: 02760F0D1C
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(4636009)(366004)(136003)(346002)(39860400002)(376002)(396003)(189003)(199004)(16576012)(81166006)(8676002)(316002)(81156014)(8936002)(110136005)(186003)(16526019)(31696002)(4326008)(86362001)(26005)(36756003)(66946007)(5660300002)(66476007)(53546011)(66556008)(6486002)(31686004)(6666004)(52116002)(478600001)(2906002)(2616005)(956004);DIR:OUT;SFP:1101;SCL:1;SRVR:CY4PR12MB1557;H:CY4PR12MB1925.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
Received-SPF: None (protection.outlook.com: amd.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: TriQ7SV4XFNIHz+qLVgQvYPsIT/eEw1T9jzAjHfRTKrHgFaeSOH8BwcBzuVuSdwlc5jNLRxKamZTcU5LYe3tdc2zVL/Gx3FkBPsMtYGv/hfXsBU3/3W8vEwSZ8ASQMU+yqJSgqTwVWBLHPcjQmO3OweVhfqvWb7qKuVlI+Ims4feEbDHWVoXxKRbVU0xBmiznw9E9x2brsHpg0tea0BHNKWB+f0ijOQ5q8lcHMFVEbhjwTdgmJnwbEzzZnbahqIk5eVs/B8n4jVqO30QsiV3+ySRWkyvVLPp83QdjIlEkq7UNxp4V3Ex9XF94Bi7Y1pkwyonF25TKhzYjrWfgE8SKKPx1DB4D2/u6x03s9FvPJL/6yIyhFM+0mDQRj9cpy/DluoudYhs4F75JI2moyrFtfw/Nlfn5bRxRiGPu2cwaphxod0FZLe9mrAcgfwchuWg
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bc1ea619-ab58-4c72-d567-08d79408e84d
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Jan 2020 07:03:47.8297
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xWGquLv59fe939Cx2otjDoF9Pk/KWn05SHOg8e6zpieihYL7LbRa3Otvq9UOdp9rvCyln3ClB0BhDB6CKDLFvA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR12MB1557
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

+linux-crypto

On 07/01/20 8:06 pm, Colin King wrote:
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
