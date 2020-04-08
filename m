Return-Path: <SRS0=EmbF=5Y=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 81413C2BA1B
	for <linux-crypto@archiver.kernel.org>; Wed,  8 Apr 2020 17:00:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5094C20753
	for <linux-crypto@archiver.kernel.org>; Wed,  8 Apr 2020 17:00:12 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=amdcloud.onmicrosoft.com header.i=@amdcloud.onmicrosoft.com header.b="tZ2Tw77+"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729461AbgDHRAL (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 8 Apr 2020 13:00:11 -0400
Received: from mail-dm6nam10on2083.outbound.protection.outlook.com ([40.107.93.83]:2273
        "EHLO NAM10-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726550AbgDHRAL (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 8 Apr 2020 13:00:11 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fBbOk/oxugbz6xyIHNS4a6RPfjP8UDDan1W+02qWrzluBh28FsPXqr5ookFQnJCU+7ZKYPabtjjJageO2KQqSn8ue/rAHC9svbxjRXjaYAdJBF1EHRGeESvHcnOrN4wxcgvcnGa9fMeCQBk9QQFZ5O3aeXhb2CtPqIy6iIFgY0YyLougJxCN3TFd6Pg3LsskWb+sQEmy9J/2mZIxkgB2Yv9c160d7cUBaCh5lfI4MHIb4rn4w0idArpUyQOnPOssYqPSLpZb1cq51JvQ0lm37tXZ4kaXf5/qXUbdC32sXWXi8BX90aF7mYv3GHdKwwC9IXR59P5rVUccjfNnIFFVnA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4UMtaqoJlOxNwPgl4JcQHv4ZJ8R5FrtPCLp9J5Nskic=;
 b=De7eoTH8p6BQz2Vw8cC70ko4r0sSksjB0SDxUKCXBKtiJzqXK+flEkqxHT45PkWb96DQ2vsDFmvo532NeeqR7Xur/4zxnl1bZVZSUiu3o0fmASQUzT92o8lRNPFiXSeHsVvLBHWxNrvk25/mz4cOSZt2B6ly3Xip8vZaGoEqg/qPoHd4cUEWbEhw9Uot/BGWUuNjvAD23auCCkwBihqDPMMJcS84QTAxBZ872ApZqYLXeWKfDoB4XxI7YT7HzHfU1TdoWXJiZcXxzbXssyCTgPxi2p32uF3G1uDyYQRyxoWgjb2UbVraiFudulmHZnh+ERWYUl3baD6ZXK+WuedIcw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4UMtaqoJlOxNwPgl4JcQHv4ZJ8R5FrtPCLp9J5Nskic=;
 b=tZ2Tw77+eLUvueld24qiT5hUNA3PI6shIASzje5/cZ+q8Rj2hnPLX6eU/71Ud6fDUwP/cf/02WihAdSr2mu65J1KsB/KakFDD/UO/WiGYvs3gkUWzXy/XyCCEOOp9JqVdAHuv+HfwyKFoNtrNuN97GMLVy7JeV7LW98/iqf51T4=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=Thomas.Lendacky@amd.com; 
Received: from DM6PR12MB3163.namprd12.prod.outlook.com (2603:10b6:5:15e::26)
 by DM6PR12MB2985.namprd12.prod.outlook.com (2603:10b6:5:116::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2878.15; Wed, 8 Apr
 2020 17:00:07 +0000
Received: from DM6PR12MB3163.namprd12.prod.outlook.com
 ([fe80::f0f9:a88f:f840:2733]) by DM6PR12MB3163.namprd12.prod.outlook.com
 ([fe80::f0f9:a88f:f840:2733%7]) with mapi id 15.20.2878.022; Wed, 8 Apr 2020
 17:00:07 +0000
Subject: Re: [PATCH] crypto: ccp -- don't "select" CONFIG_DMADEVICES
To:     Arnd Bergmann <arnd@arndb.de>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Ard Biesheuvel <ardb@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Eric Biggers <ebiggers@google.com>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20200408162652.3987688-1-arnd@arndb.de>
From:   Tom Lendacky <thomas.lendacky@amd.com>
Message-ID: <dade39d2-db11-1830-eda0-d39b40f6c3aa@amd.com>
Date:   Wed, 8 Apr 2020 12:00:05 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
In-Reply-To: <20200408162652.3987688-1-arnd@arndb.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SN2PR01CA0046.prod.exchangelabs.com (2603:10b6:800::14) To
 DM6PR12MB3163.namprd12.prod.outlook.com (2603:10b6:5:15e::26)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from office-linux.texastahm.com (67.79.209.213) by SN2PR01CA0046.prod.exchangelabs.com (2603:10b6:800::14) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2900.15 via Frontend Transport; Wed, 8 Apr 2020 17:00:06 +0000
X-Originating-IP: [67.79.209.213]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: dc99dd38-47b6-4d1e-5e39-08d7dbde4a71
X-MS-TrafficTypeDiagnostic: DM6PR12MB2985:
X-Microsoft-Antispam-PRVS: <DM6PR12MB29855D3FB2C7927BBA0396ADECC00@DM6PR12MB2985.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-Forefront-PRVS: 0367A50BB1
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3163.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(10009020)(4636009)(136003)(366004)(376002)(346002)(396003)(39860400002)(81156014)(316002)(52116002)(6512007)(26005)(2906002)(54906003)(66556008)(66476007)(110136005)(66946007)(6506007)(53546011)(31686004)(478600001)(4326008)(8676002)(956004)(2616005)(16526019)(86362001)(81166007)(8936002)(186003)(36756003)(31696002)(6486002)(5660300002);DIR:OUT;SFP:1101;
Received-SPF: None (protection.outlook.com: amd.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ANm3uqECoOYQLIig2GteQfyJCXfBwTkw6obFZdyQ7+MjOGgwWNbKtoEt4DIjF5YKAEzKh5dZBZxnMM4ZsMM7egPl4YBA8qyh7h2eKgpQzYQqQ+NqYDNnOjQc2HoLuZBIkfZPMSvCdhdElkMDT2JTd//DDjIlTfEu3KIkvP0APXh6B1uDJdSPLR6Naojnm4IQYiNTv+GK6H4KXvQZmnvD1GuYtsbKY4Dpdtb1hn4KkVsFf2/qMfH3CL1cMLHF+4ThtVVsAD4Rd59pFpitO4vdF3eridPp9bRbus1hnpCf6aimzPuxiqzqPbBL6M8oxh/Uj7jLjxKE4MaHNjmih7xSGh8RD4uKgh+unfMNAfOcs+vso4aKNrBsfi+SEkPv7nLXy2jQ8kMx4lO9Ojyav6DtbxDoakk5n/DGZa8G9HQlqQ3eu9tMmJw+iafyuy2ul5DC
X-MS-Exchange-AntiSpam-MessageData: 36lbM3KH+CimP+w9Fk/A8SZ94vJrV98HSh6/P0qTn67at5mJ2N55b0qk6bz5W9BQqPCOHRmmjW8ZfCf+Tb5K1XfPAFf0ziC2ifWqqr8JMO/rYFs/fBxk0i7UIvFZN3GZ92Uzd2Lf5lEEg03aLikqZA==
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dc99dd38-47b6-4d1e-5e39-08d7dbde4a71
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Apr 2020 17:00:07.5510
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: KEFLaAcoUfaYajHQqxBw8N/8JnUTwpRicftqlkoUXWjZ3GCHHozd6k2zahVtl65r4gFGPRt4Ue4PhvNCw95jhQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB2985
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 4/8/20 11:26 AM, Arnd Bergmann wrote:
> DMADEVICES is the top-level option for the slave DMA
> subsystem, and should not be selected by device drivers,
> as this can cause circular dependencies such as:
> 
> drivers/net/ethernet/freescale/Kconfig:6:error: recursive dependency detected!
> drivers/net/ethernet/freescale/Kconfig:6:	symbol NET_VENDOR_FREESCALE depends on PPC_BESTCOMM
> drivers/dma/bestcomm/Kconfig:6:	symbol PPC_BESTCOMM depends on DMADEVICES
> drivers/dma/Kconfig:6:	symbol DMADEVICES is selected by CRYPTO_DEV_SP_CCP
> drivers/crypto/ccp/Kconfig:10:	symbol CRYPTO_DEV_SP_CCP depends on CRYPTO
> crypto/Kconfig:16:	symbol CRYPTO is selected by LIBCRC32C
> lib/Kconfig:222:	symbol LIBCRC32C is selected by LIQUIDIO
> drivers/net/ethernet/cavium/Kconfig:65:	symbol LIQUIDIO depends on PTP_1588_CLOCK
> drivers/ptp/Kconfig:8:	symbol PTP_1588_CLOCK is implied by FEC
> drivers/net/ethernet/freescale/Kconfig:23:	symbol FEC depends on NET_VENDOR_FREESCALE
> 
> The LIQUIDIO driver causing this problem is addressed in a
> separate patch, but this change is needed to prevent it from
> happening again.
> 
> Using "depends on DMADEVICES" is what we do for all other
> implementations of slave DMA controllers as well.
> 
> Fixes: b3c2fee5d66b ("crypto: ccp - Ensure all dependencies are specified")
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>

Acked-by: Tom Lendacky <thomas.lendacky@amd.com>

> ---
>   drivers/crypto/ccp/Kconfig | 3 +--
>   1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/drivers/crypto/ccp/Kconfig b/drivers/crypto/ccp/Kconfig
> index e0a8bd15aa74..32268e239bf1 100644
> --- a/drivers/crypto/ccp/Kconfig
> +++ b/drivers/crypto/ccp/Kconfig
> @@ -10,10 +10,9 @@ config CRYPTO_DEV_CCP_DD
>   config CRYPTO_DEV_SP_CCP
>   	bool "Cryptographic Coprocessor device"
>   	default y
> -	depends on CRYPTO_DEV_CCP_DD
> +	depends on CRYPTO_DEV_CCP_DD && DMADEVICES
>   	select HW_RANDOM
>   	select DMA_ENGINE
> -	select DMADEVICES
>   	select CRYPTO_SHA1
>   	select CRYPTO_SHA256
>   	help
> 
