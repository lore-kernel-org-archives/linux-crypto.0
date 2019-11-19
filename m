Return-Path: <SRS0=Veu2=ZL=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 31086C432C0
	for <linux-crypto@archiver.kernel.org>; Tue, 19 Nov 2019 15:10:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EEB0E2231C
	for <linux-crypto@archiver.kernel.org>; Tue, 19 Nov 2019 15:10:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=amdcloud.onmicrosoft.com header.i=@amdcloud.onmicrosoft.com header.b="q8YISj22"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727682AbfKSPKb (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 19 Nov 2019 10:10:31 -0500
Received: from mail-eopbgr680063.outbound.protection.outlook.com ([40.107.68.63]:60037
        "EHLO NAM04-BN3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726637AbfKSPKb (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 19 Nov 2019 10:10:31 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dtD7jOu9Df2xPMjnlwb7DghZdo0Uxss1A2LSeLx2UVQTg9ofgPrOtlft6jBQM+UIA2TvqLt8q1pVyB8vObgMyxIe8dhxVi5wuH14iMKOp2A8i3/IUInikysOe3BMvi68ICTlkSPNp7b47rtq/nz8pp0cDCozkzkZszM9ZNFGJobj1DV2itoIja4CSbBql4h1AVHKYN+5nGTHgOQG2Gv0FqUBKeofr916yoDtiMQrf9YRzRbE0mQf0/lzN/rzpGKteZ47tTdiDbIfRTqf81bOkNc+qsfPmz08Oj0sE2vvuhpUTL71Fne42pSUBGGJK9fkIhfmKqN7ALR/UntrAq/BPw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DGdrwiYPevZ130DghTXfIZKFzGVnqr/r4IKtW6O/J5s=;
 b=enyBHc1n0B1f5KOVqmwvzyMt3Cam4y1Jy8hv11pZJrDy5yLU7868dhqII7TDE+ZzpmpUHMntjbraweurxFIonvbMfQd9LcWgsI9ggcZPbvbbQKkd7jwz4jMaFGGjAwiK/Fdh+D2UgaMRa5WtP5JGWl6gDcMt3dHr04hYY2/VranVjMuxcg1uxoFAhEGADaEEe6zo9ynT1ZgHtKVtgO3OyB6lt2uOhfe3gkaqrAL4A66JnxtTNp+PrbIA/7iBM98TPiJdS+P7PQiwreILUI2LJ5KiZmJDRrQRZF+KJoaOhynVKPwPPE/jPaVFvUn4F94W0neiExbYj1YYZyJv10w56Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DGdrwiYPevZ130DghTXfIZKFzGVnqr/r4IKtW6O/J5s=;
 b=q8YISj220YNa6iUqw9RP/UPPMknpjW2NOXi0OCkq6+GAKvqo9mUk6iA9sbbiw82t5QozCKGYSFaE1A4JtM9rQmyQiLGkV1R5uWGOzAGeJAr5hzKwVIk8r9kadFssGf5oJOZzV8XtZBwqKk5TqAj7v3SRAhW8KCxgvOfcaqkCWXg=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=Gary.Hook@amd.com; 
Received: from CY4PR12MB1448.namprd12.prod.outlook.com (10.172.71.140) by
 CY4PR12MB1317.namprd12.prod.outlook.com (10.168.166.139) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2451.26; Tue, 19 Nov 2019 15:10:28 +0000
Received: from CY4PR12MB1448.namprd12.prod.outlook.com
 ([fe80::4436:923:b008:9205]) by CY4PR12MB1448.namprd12.prod.outlook.com
 ([fe80::4436:923:b008:9205%5]) with mapi id 15.20.2451.031; Tue, 19 Nov 2019
 15:10:28 +0000
Subject: Re: [PATCH 01/12] crypto: add helper function for akcipher_request
To:     Iuliana Prodan <iuliana.prodan@nxp.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Horia Geanta <horia.geanta@nxp.com>,
        Aymen Sghaier <aymen.sghaier@nxp.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-imx <linux-imx@nxp.com>
References: <1574029845-22796-1-git-send-email-iuliana.prodan@nxp.com>
 <1574029845-22796-2-git-send-email-iuliana.prodan@nxp.com>
From:   Gary R Hook <gary.hook@amd.com>
Message-ID: <1ebec89d-92f6-8273-fc77-67f97c85a6a1@amd.com>
Date:   Tue, 19 Nov 2019 09:10:26 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
In-Reply-To: <1574029845-22796-2-git-send-email-iuliana.prodan@nxp.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SN1PR12CA0079.namprd12.prod.outlook.com
 (2603:10b6:802:21::14) To CY4PR12MB1448.namprd12.prod.outlook.com
 (2603:10b6:910:f::12)
MIME-Version: 1.0
X-Originating-IP: [165.204.77.1]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: b2164e91-3248-49c1-ed50-08d76d029c57
X-MS-TrafficTypeDiagnostic: CY4PR12MB1317:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <CY4PR12MB13174EDEDB275F71CEBDD3DAFD4C0@CY4PR12MB1317.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:519;
X-Forefront-PRVS: 022649CC2C
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(4636009)(366004)(396003)(376002)(136003)(346002)(39860400002)(199004)(189003)(50466002)(6246003)(23676004)(66946007)(2906002)(6116002)(5660300002)(11346002)(65806001)(476003)(66476007)(186003)(3846002)(66556008)(316002)(305945005)(58126008)(36756003)(486006)(446003)(65956001)(230700001)(6506007)(53546011)(386003)(7736002)(66066001)(6512007)(478600001)(47776003)(110136005)(6436002)(54906003)(31686004)(52116002)(76176011)(2486003)(81156014)(81166006)(26005)(8676002)(2616005)(229853002)(25786009)(8936002)(6486002)(14454004)(99286004)(31696002)(14444005)(86362001)(4326008);DIR:OUT;SFP:1101;SCL:1;SRVR:CY4PR12MB1317;H:CY4PR12MB1448.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
Received-SPF: None (protection.outlook.com: amd.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Tb9kiL9wnTvHzpDTZf8prK0AnYy1mivJCD/Zh6w4SA6+Fe3SL+eSqAtYYt4YRvubM5C1Qj1o8knbCna5xsn8kjXasixAXJyJ/7oaVQvO4p0I2+gTPJy2pJjnAnyBmz7fAHQblvvjMoqJLnFPErN2nB4HDVR9kl4FUwGnUbHRLLtEfbzoMWNSvM1w09vSIAgXuHnSyPrGmUXUqSW56NNXCTx19xfLo5RHq5pWpE/Wjo2vxBhl0orXTgg5xVA86bUAjJRr4xddO2E3nTIqT52pTtTb5RdKpV1mXnBB3C84NJ1rJK/BbA0cb5xXeg4y16RGOUi0XGZhcqcm8etJXfc16rUfIzYKmqxExRRNsU3nBR4jtdRd63MfRJOZCAQWU8l+y0ZRceeWhWMGtPbdjae3RbBzqAx+OPTsmEQUedLDXCUAwKwd+Q4WA7W6cMSH3O94
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b2164e91-3248-49c1-ed50-08d76d029c57
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Nov 2019 15:10:27.9643
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Ss1KqsEEhpRssnfYhmT/6gwm49hIvsPbHU1D54UMtRbOMP0zCBYRgp1ITs/FSDAA
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR12MB1317
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 11/17/19 4:30 PM, Iuliana Prodan wrote:
> Add akcipher_request_cast function to get an akcipher_request struct from
> a crypto_async_request struct.
> 
> Remove this function from ccp driver.
> 
> Signed-off-by: Iuliana Prodan <iuliana.prodan@nxp.com>

Acked-by: Gary R Hook <gary.hook@amd.com>

> ---
>   drivers/crypto/ccp/ccp-crypto-rsa.c | 6 ------
>   include/crypto/akcipher.h           | 6 ++++++
>   2 files changed, 6 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/crypto/ccp/ccp-crypto-rsa.c b/drivers/crypto/ccp/ccp-crypto-rsa.c
> index 649c91d..3ab659d 100644
> --- a/drivers/crypto/ccp/ccp-crypto-rsa.c
> +++ b/drivers/crypto/ccp/ccp-crypto-rsa.c
> @@ -19,12 +19,6 @@
>   
>   #include "ccp-crypto.h"
>   
> -static inline struct akcipher_request *akcipher_request_cast(
> -	struct crypto_async_request *req)
> -{
> -	return container_of(req, struct akcipher_request, base);
> -}
> -
>   static inline int ccp_copy_and_save_keypart(u8 **kpbuf, unsigned int *kplen,
>   					    const u8 *buf, size_t sz)
>   {
> diff --git a/include/crypto/akcipher.h b/include/crypto/akcipher.h
> index 6924b09..4365edd 100644
> --- a/include/crypto/akcipher.h
> +++ b/include/crypto/akcipher.h
> @@ -170,6 +170,12 @@ static inline struct crypto_akcipher *crypto_akcipher_reqtfm(
>   	return __crypto_akcipher_tfm(req->base.tfm);
>   }
>   
> +static inline struct akcipher_request *akcipher_request_cast(
> +	struct crypto_async_request *req)
> +{
> +	return container_of(req, struct akcipher_request, base);
> +}
> +
>   /**
>    * crypto_free_akcipher() - free AKCIPHER tfm handle
>    *
> 

