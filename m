Return-Path: <SRS0=+KeW=2R=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DCC02C2D0C6
	for <linux-crypto@archiver.kernel.org>; Fri, 27 Dec 2019 18:37:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9FB3B206CB
	for <linux-crypto@archiver.kernel.org>; Fri, 27 Dec 2019 18:37:28 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=amdcloud.onmicrosoft.com header.i=@amdcloud.onmicrosoft.com header.b="ELJvFend"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726527AbfL0Sh2 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 27 Dec 2019 13:37:28 -0500
Received: from mail-dm6nam11on2041.outbound.protection.outlook.com ([40.107.223.41]:6095
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726379AbfL0Sh1 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 27 Dec 2019 13:37:27 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EyXIU3c1mKSY21QQA7KAIh5sVNT8xoMOEueKXLoCmHRuCHPxzhSoRmpp4JqvtAA/E7umU3eGSUPATmhulqoiA3nlGFrNuZhSSnktsi3Cs9YTwNAZh9blHtOnkWwonHpeQVR4mE88y1+4jIyxs4N6gXai0UvihvYbSe7xWyymwUZ2t2kN3U8/THcu8SAChvfAlus35tf3cszzXWUcS0AuGCA85Gt0z7x7YCCZuvWqGPcNBoL00MqyNTvvkzDuG2QqJCaXaeMEXsADvL4B+BCErrRGUeZIbtsmSTJtndiT/u5zPy2lpaLiK7M+TDXzpKxkwBqGq9whloqn/yokqaL51g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8854fDKXuI85I3FJ5/M68M5V548PYPZawdyFZxFQSfU=;
 b=eO7h5J5wF/5NEu1cOvnHMdAbsroJR8xqUhC4JxbTDezmILYuPATBLsEbL2Z32zw+o5GPOVScKw17UDMI+JRJ4DZeTPprpxEMlJqrathXUqxsjUWijDIbt13eDA6vTg6Reeohw85L3AoGbbK4V3co66Z9nbVRycnTwIvj61WGgxFewZYqOnsmjbhax879WghnVPunU0zumGVgZcyuNiewIHutUtXuJp0BSE4xALNAhkdriH6R41Cz2Y9verIKeEsWYYFqyOvHQlFO9UQoi0mx1qwANA6FByum5sR5yYXzhA2bnXVVrGal5rTeg4FM3LW6Z7i5RcISDaSAfTcLMsY1gA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8854fDKXuI85I3FJ5/M68M5V548PYPZawdyFZxFQSfU=;
 b=ELJvFendP01WmBfUlaBqB/z1iZKUnlXxx67iQCVm7zZv5WSYcT69uMbgJtjvyUe9hwGtugPHN8venpQ4F1na24P4FTegPJQA4+9MK7VFKjV8dHSUMWwNDuMtrmKktr/Re3A5oSwby6Ej+/jOeb7cbtzcOwfcVNOBnq55l+zl5DE=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=Gary.Hook@amd.com; 
Received: from BN8PR12MB2916.namprd12.prod.outlook.com (20.179.66.155) by
 BN8PR12MB3217.namprd12.prod.outlook.com (20.179.67.158) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2581.12; Fri, 27 Dec 2019 18:37:23 +0000
Received: from BN8PR12MB2916.namprd12.prod.outlook.com
 ([fe80::45d0:ec5c:7480:8029]) by BN8PR12MB2916.namprd12.prod.outlook.com
 ([fe80::45d0:ec5c:7480:8029%5]) with mapi id 15.20.2559.017; Fri, 27 Dec 2019
 18:37:23 +0000
Subject: Re: [PATCH 1/4] tee: allow compilation of tee subsystem for AMD CPUs
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
 <515ebade213492080b97ed6426c82a0fe22c03ab.1577423898.git.Rijo-john.Thomas@amd.com>
From:   Gary R Hook <ghook@amd.com>
Message-ID: <13954c4f-378f-a31c-2ee4-2ab0aea632e0@amd.com>
Date:   Fri, 27 Dec 2019 12:37:20 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
In-Reply-To: <515ebade213492080b97ed6426c82a0fe22c03ab.1577423898.git.Rijo-john.Thomas@amd.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SN4PR0701CA0020.namprd07.prod.outlook.com
 (2603:10b6:803:28::30) To BN8PR12MB2916.namprd12.prod.outlook.com
 (2603:10b6:408:6a::27)
MIME-Version: 1.0
Received: from [4.3.2.105] (47.220.193.178) by SN4PR0701CA0020.namprd07.prod.outlook.com (2603:10b6:803:28::30) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2581.12 via Frontend Transport; Fri, 27 Dec 2019 18:37:22 +0000
X-Originating-IP: [47.220.193.178]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 375a0d84-b487-4709-2517-08d78afbd01c
X-MS-TrafficTypeDiagnostic: BN8PR12MB3217:|BN8PR12MB3217:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BN8PR12MB3217DD3C601FF476AE089AD4FD2A0@BN8PR12MB3217.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1332;
X-Forefront-PRVS: 0264FEA5C3
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(4636009)(366004)(346002)(396003)(39860400002)(376002)(136003)(189003)(199004)(66946007)(66556008)(66476007)(110136005)(16576012)(54906003)(956004)(6706004)(6486002)(478600001)(4326008)(52116002)(186003)(2616005)(31696002)(5660300002)(8936002)(2906002)(81166006)(36756003)(8676002)(81156014)(316002)(26005)(53546011)(31686004)(16526019)(78286006)(84106002);DIR:OUT;SFP:1101;SCL:1;SRVR:BN8PR12MB3217;H:BN8PR12MB2916.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
Received-SPF: None (protection.outlook.com: amd.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: dwCashLZmH/JI0ApHiw0wVubIAY3z1GOWAfrNDeaWAiFtYlM37MMAMVWsRPYpYq361Gbt0j++2oKq87HXKQGCSLTJmbztroqHcjMIlCHJZ/I2vchgvdKf1B/pXPruOswlYLRZIJxYjFkdMBrafZyTruZQ6GF+1TOISlI3lvtt2AVRF9/TZy9qhNVNlO3xu6s4Uohnmud5bnj9FB15HQF1qvKLAMn34xf5JZ6yOndJ3Uy0bwF1LhLPZ1hVVhP3PXgLOfPID/gG8gBqhAZv9n60UdZ/M+hA7q/iflfZOKXyy6TFoscfllUQ7rqoZc5qc2vlOXlLV2uRsxthJf75ijYECLu7r/idQsgPZRf1OxXJSY1KUUjyGh75fHKafgNzc/PaAv9ALXueyy3GAdScm618a1ECJw/GXbCd2dQ/ABDXLWHVeKIrb31m+KZj9FujFcr0DUFmzP/ekuNjtYsueT4UyRr2P2vEBQOxADes0zZKo+ZF9Sb2boEK8PeflpFEOpmmX40od9XStKQUGG2XkiL7g==
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 375a0d84-b487-4709-2517-08d78afbd01c
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Dec 2019 18:37:23.4641
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6YtsAvdRxvZ5Zjtyy7E2kd6Wr2yOUcNc+iMqRu8f2paFkyxQ+obdKuNrXh+biM5V
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR12MB3217
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 12/26/19 11:24 PM, Rijo Thomas wrote:
> Allow compilation of tee subsystem for AMD's CPUs which have a dedicated
> AMD Secure Processor for Trusted Execution Environment (TEE).
> 
> Acked-by: Jens Wiklander <jens.wiklander@linaro.org>
> Co-developed-by: Devaraj Rangasamy <Devaraj.Rangasamy@amd.com>
> Signed-off-by: Devaraj Rangasamy <Devaraj.Rangasamy@amd.com>
> Signed-off-by: Rijo Thomas <Rijo-john.Thomas@amd.com>

Reviewed-by: Gary R Hook <gary.hook@amd.com>

> ---
>   drivers/tee/Kconfig | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/tee/Kconfig b/drivers/tee/Kconfig
> index 676ffcb..4f3197d 100644
> --- a/drivers/tee/Kconfig
> +++ b/drivers/tee/Kconfig
> @@ -2,7 +2,7 @@
>   # Generic Trusted Execution Environment Configuration
>   config TEE
>   	tristate "Trusted Execution Environment support"
> -	depends on HAVE_ARM_SMCCC || COMPILE_TEST
> +	depends on HAVE_ARM_SMCCC || COMPILE_TEST || CPU_SUP_AMD
>   	select DMA_SHARED_BUFFER
>   	select GENERIC_ALLOCATOR
>   	help
> 

