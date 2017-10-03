From: Brijesh Singh <brijesh.singh@amd.com>
Subject: Re: [Part2 PATCH v4 05/29] crypto: ccp: Add Platform Security
 Processor (PSP) device support
Date: Tue, 3 Oct 2017 11:19:48 -0500
Message-ID: <cb8f574d-6077-74f1-7bb9-9d23c8a06cd2@amd.com>
References: <20170919204627.3875-1-brijesh.singh@amd.com>
 <20170919204627.3875-6-brijesh.singh@amd.com>
 <20170929151607.zn4lmdkyn25sczfg@pd.tnic>
 <1fc76eee-f25b-cd38-cc8d-0404ec94cf79@amd.com>
 <20170930161104.452sia6a5y5duyn4@pd.tnic>
 <55879570-04d7-a627-5f4b-b94f1604ece5@amd.com>
 <20171003161718.mabp74olsxbmpewv@pd.tnic>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Cc: brijesh.singh@amd.com, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Gary Hook <gary.hook@amd.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        linux-crypto@vger.kernel.org
To: Borislav Petkov <bp@suse.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-dm3nam03on0084.outbound.protection.outlook.com ([104.47.41.84]:32798
        "EHLO NAM03-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1750820AbdJCQT4 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 3 Oct 2017 12:19:56 -0400
In-Reply-To: <20171003161718.mabp74olsxbmpewv@pd.tnic>
Content-Language: en-US
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>



On 10/03/2017 11:17 AM, Borislav Petkov wrote:
...

> 
> No, please add my patch below to your set for the CRYPTO_DEV_CCP_DD
> dependency as it is a separate thing. Your patch should concentrate only
> on adding the PSP and its dependencies.
> 

Sure, I will include your patch in my series. thanks


> ---
> From: Borislav Petkov <bp@suse.de>
> Date: Sat, 30 Sep 2017 10:06:27 +0200
> Subject: [PATCH] crypto: ccp: Build the AMD secure processor driver only with
>   AMD CPU support
> 
> This is AMD-specific hardware so present it in Kconfig only when AMD
> CPU support is enabled or on ARM64 where it is also used.
> 
> Signed-off-by: Borislav Petkov <bp@suse.de>
> Cc: Brijesh Singh <brijesh.singh@amd.com>
> Cc: Tom Lendacky <thomas.lendacky@amd.com>
> Cc: Gary Hook <gary.hook@amd.com>
> Cc: Herbert Xu <herbert@gondor.apana.org.au>
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: linux-crypto@vger.kernel.org
> ---
>   drivers/crypto/ccp/Kconfig | 1 +
>   1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/crypto/ccp/Kconfig b/drivers/crypto/ccp/Kconfig
> index 627f3e61dcac..f19f57162225 100644
> --- a/drivers/crypto/ccp/Kconfig
> +++ b/drivers/crypto/ccp/Kconfig
> @@ -1,5 +1,6 @@
>   config CRYPTO_DEV_CCP_DD
>   	tristate "Secure Processor device driver"
> +	depends on CPU_SUP_AMD || ARM64
>   	default m
>   	help
>   	  Provides AMD Secure Processor device driver.
> 
