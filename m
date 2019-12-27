Return-Path: <SRS0=+KeW=2R=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CE02CC2D0C6
	for <linux-crypto@archiver.kernel.org>; Fri, 27 Dec 2019 18:38:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9A53E20722
	for <linux-crypto@archiver.kernel.org>; Fri, 27 Dec 2019 18:38:00 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=amdcloud.onmicrosoft.com header.i=@amdcloud.onmicrosoft.com header.b="f37vQhl4"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726379AbfL0Sh4 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 27 Dec 2019 13:37:56 -0500
Received: from mail-dm6nam11on2041.outbound.protection.outlook.com ([40.107.223.41]:55427
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726495AbfL0Sh4 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 27 Dec 2019 13:37:56 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Pg5pL8s/ORtIhGzPt07LYEufXxxnGnMmeylI9kWC4CCnkApbIGND1f7BZcS8+6rQQ6SPBdzYBd8VO7/7DtgpMjfvLcBSoM8vVZRNQ1ZkrEUL4UECgSzdEbVYDKx1E2jsGPn3fb/s20Kdy7FaT8zn+iRkLgtVdOtYU3237rB7ItT1tnx6Y4dtC3mIABiQ7RB+DSD6yDZ/4eClzdfdaUAgiZqTXZyu+p3oVnOTdudLkJ8nRPuAkR9nRst75JMhzXBt9C8p1vmvOsHlkFyBHg3ZkpwXhX29bGjLngaJTl4ap1dejpqcGt5rA3ANYESYYhA4Oic8l8on/IzWMzdPgrOTQw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cFW62oQQ+AJC3k+/rW9SADvIfCC8hXFBjSeWaMQ6gYs=;
 b=a6JVwrHfT9rKqRKvP+rQ3NSOZgjxAl8EvZmFTLueN/GkmAmesbQ164jEfNuIkixitZdG/oG7qQPIPRGj+HrBZkZj1SM7saHwLDF1pV/Q32bDewSf65x++xaZX+QsAvYlqdXvoilEqr2Azqvbwvt9mav4PPgOXdsO14/IMxzbh8Z9ycuK72T3sei9Thq3p86jaE+/cfUSw8x3n8xkQ0uEuX5A7GtGxwCXE//2qj7hU0poAtGLuGo9cEA4ZD/fiLwwGvN1F/keQ9tV/ubkqZtMKMa9hpkM4QRpcBxbRMtljOan0jCf+CrPYOdtiR526e1as0X8VBxHTIMn2ePg0t9xPg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cFW62oQQ+AJC3k+/rW9SADvIfCC8hXFBjSeWaMQ6gYs=;
 b=f37vQhl4Ine5KvIkT7tw4Ji31lLFdeccgvbujCPpgziUazv8jAGWarErGleWrgMPpLNE2Wc2CgVnwT1vKgt89CTbXviVks0vzBrpid/MpReHqWKkiX8s4m2hUllDMvjpafDS32sCVtYdLmknGxpa+M85Jnmj/cXpDzCoDWHyVQA=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=Gary.Hook@amd.com; 
Received: from BN8PR12MB2916.namprd12.prod.outlook.com (20.179.66.155) by
 BN8PR12MB3217.namprd12.prod.outlook.com (20.179.67.158) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2581.12; Fri, 27 Dec 2019 18:37:52 +0000
Received: from BN8PR12MB2916.namprd12.prod.outlook.com
 ([fe80::45d0:ec5c:7480:8029]) by BN8PR12MB2916.namprd12.prod.outlook.com
 ([fe80::45d0:ec5c:7480:8029%5]) with mapi id 15.20.2559.017; Fri, 27 Dec 2019
 18:37:52 +0000
Subject: Re: [PATCH 3/4] tee: amdtee: check TEE status during driver
 initialization
To:     Rijo Thomas <Rijo-john.Thomas@amd.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>,
        linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
        tee-dev@lists.linaro.org
Cc:     Nimesh Easow <Nimesh.Easow@amd.com>,
        Devaraj Rangasamy <Devaraj.Rangasamy@amd.com>,
        Jens Wiklander <jens.wiklander@linaro.org>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Gary Hook <gary.hook@amd.com>
References: <cover.1577423898.git.Rijo-john.Thomas@amd.com>
 <7510087f2b8cffab083184dfefca183a6b73471a.1577423898.git.Rijo-john.Thomas@amd.com>
From:   Gary R Hook <ghook@amd.com>
Message-ID: <67839c5e-32e5-a69b-5dc6-bbbdf8559bf5@amd.com>
Date:   Fri, 27 Dec 2019 12:37:49 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
In-Reply-To: <7510087f2b8cffab083184dfefca183a6b73471a.1577423898.git.Rijo-john.Thomas@amd.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SN4PR0701CA0018.namprd07.prod.outlook.com
 (2603:10b6:803:28::28) To BN8PR12MB2916.namprd12.prod.outlook.com
 (2603:10b6:408:6a::27)
MIME-Version: 1.0
Received: from [4.3.2.105] (47.220.193.178) by SN4PR0701CA0018.namprd07.prod.outlook.com (2603:10b6:803:28::28) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2581.11 via Frontend Transport; Fri, 27 Dec 2019 18:37:51 +0000
X-Originating-IP: [47.220.193.178]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: e4e62de7-a268-482c-f21b-08d78afbe164
X-MS-TrafficTypeDiagnostic: BN8PR12MB3217:|BN8PR12MB3217:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BN8PR12MB32179AF7E0B660EC65BAC4A4FD2A0@BN8PR12MB3217.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2150;
X-Forefront-PRVS: 0264FEA5C3
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(4636009)(366004)(346002)(396003)(39860400002)(376002)(136003)(189003)(199004)(66946007)(66556008)(66476007)(110136005)(16576012)(54906003)(956004)(6706004)(6486002)(478600001)(4326008)(52116002)(186003)(2616005)(31696002)(5660300002)(8936002)(2906002)(81166006)(36756003)(8676002)(81156014)(316002)(26005)(53546011)(31686004)(16526019)(78286006)(84106002);DIR:OUT;SFP:1101;SCL:1;SRVR:BN8PR12MB3217;H:BN8PR12MB2916.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
Received-SPF: None (protection.outlook.com: amd.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ll38DgdXA0pj746YKVIoxTKFs6ZJb80mvy4pRA5uVE7rnO/+vmEetbV5IL3j5+NHe3RgFcUZOFC/0fZit04C/BoEzh3S4tDW1WAmA4/Md8thT1Q9HTkmELm/4a0hBAfqXWHCgHXFbjQGwRAXlsimy9WhgNF0z95UlacoYNJzj5xba5v3md0va2RtPuIY0zsOWg23LgOVx/H1NfEGA/v5yrwKqxSE5+kgeTTF95O5QT4wF6MsdEFpK4DwzRJhQN6GMQFAq/0iKJQRFE3WNEnXhfwDU/bbzNqGfaHM7jIL/uWM3LsOlh3WdTkkmUhbugMn+9uIUjZyfxfTHqjkkNcSKSqaw3eyy1rMqh+TnPhJDzbu3HbQNFaDcbUGHtCezAD8Nz/U61/gEvjAI/iw7YoV/SC6Kyn5mLQuFBBTHTOVydbKpbiLiCz1DCLTwKxsj2hyQ+XGZ2r5f7gd3NX492W7bA0agdwhc520rzIHGBjzouF0xq0pMf9F1m3JU3HA9o3cxKQsLrrxKgptYf6ekPcEcw==
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e4e62de7-a268-482c-f21b-08d78afbe164
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Dec 2019 18:37:52.3745
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: SN6SAeeKpkJfgOvJDvNPGzHBRELfqHyqjaUBJeLHondxKK51DgjPv3uRx4Yki6Vg
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR12MB3217
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 12/26/19 11:24 PM, Rijo Thomas wrote:
> The AMD-TEE driver should check if TEE is available before
> registering itself with TEE subsystem. This ensures that
> there is a TEE which the driver can talk to before proceeding
> with tee device node allocation.
> 
> Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>
> Cc: Tom Lendacky <thomas.lendacky@amd.com>
> Acked-by: Jens Wiklander <jens.wiklander@linaro.org>
> Co-developed-by: Devaraj Rangasamy <Devaraj.Rangasamy@amd.com>
> Signed-off-by: Devaraj Rangasamy <Devaraj.Rangasamy@amd.com>
> Signed-off-by: Rijo Thomas <Rijo-john.Thomas@amd.com>

Reviewed-by: Gary R Hook <gary.hook@amd.com>

> ---
>   drivers/crypto/ccp/tee-dev.c | 11 +++++++++++
>   drivers/tee/amdtee/core.c    |  6 ++++++
>   include/linux/psp-tee.h      | 18 ++++++++++++++++++
>   3 files changed, 35 insertions(+)
> 
> diff --git a/drivers/crypto/ccp/tee-dev.c b/drivers/crypto/ccp/tee-dev.c
> index 555c8a7..5e697a9 100644
> --- a/drivers/crypto/ccp/tee-dev.c
> +++ b/drivers/crypto/ccp/tee-dev.c
> @@ -362,3 +362,14 @@ int psp_tee_process_cmd(enum tee_cmd_id cmd_id, void *buf, size_t len,
>   	return 0;
>   }
>   EXPORT_SYMBOL(psp_tee_process_cmd);
> +
> +int psp_check_tee_status(void)
> +{
> +	struct psp_device *psp = psp_get_master_device();
> +
> +	if (!psp || !psp->tee_data)
> +		return -ENODEV;
> +
> +	return 0;
> +}
> +EXPORT_SYMBOL(psp_check_tee_status);
> diff --git a/drivers/tee/amdtee/core.c b/drivers/tee/amdtee/core.c
> index dd360f3..9d0cee1 100644
> --- a/drivers/tee/amdtee/core.c
> +++ b/drivers/tee/amdtee/core.c
> @@ -16,6 +16,7 @@
>   #include <linux/firmware.h>
>   #include "amdtee_private.h"
>   #include "../tee_private.h"
> +#include <linux/psp-tee.h>
>   
>   static struct amdtee_driver_data *drv_data;
>   static DEFINE_MUTEX(session_list_mutex);
> @@ -438,6 +439,10 @@ static int __init amdtee_driver_init(void)
>   	struct tee_shm_pool *pool = ERR_PTR(-EINVAL);
>   	int rc;
>   
> +	rc = psp_check_tee_status();
> +	if (rc)
> +		goto err_fail;
> +
>   	drv_data = kzalloc(sizeof(*drv_data), GFP_KERNEL);
>   	if (IS_ERR(drv_data))
>   		return -ENOMEM;
> @@ -485,6 +490,7 @@ static int __init amdtee_driver_init(void)
>   	kfree(drv_data);
>   	drv_data = NULL;
>   
> +err_fail:
>   	pr_err("amd-tee driver initialization failed\n");
>   	return rc;
>   }
> diff --git a/include/linux/psp-tee.h b/include/linux/psp-tee.h
> index 63bb221..cb0c95d 100644
> --- a/include/linux/psp-tee.h
> +++ b/include/linux/psp-tee.h
> @@ -62,6 +62,19 @@ enum tee_cmd_id {
>   int psp_tee_process_cmd(enum tee_cmd_id cmd_id, void *buf, size_t len,
>   			u32 *status);
>   
> +/**
> + * psp_check_tee_status() - Checks whether there is a TEE which a driver can
> + * talk to.
> + *
> + * This function can be used by AMD-TEE driver to query if there is TEE with
> + * which it can communicate.
> + *
> + * Returns:
> + * 0          if the device has TEE
> + * -%ENODEV   if there is no TEE available
> + */
> +int psp_check_tee_status(void);
> +
>   #else /* !CONFIG_CRYPTO_DEV_SP_PSP */
>   
>   static inline int psp_tee_process_cmd(enum tee_cmd_id cmd_id, void *buf,
> @@ -69,5 +82,10 @@ static inline int psp_tee_process_cmd(enum tee_cmd_id cmd_id, void *buf,
>   {
>   	return -ENODEV;
>   }
> +
> +static inline int psp_check_tee_status(void)
> +{
> +	return -ENODEV;
> +}
>   #endif /* CONFIG_CRYPTO_DEV_SP_PSP */
>   #endif /* __PSP_TEE_H_ */
> 

