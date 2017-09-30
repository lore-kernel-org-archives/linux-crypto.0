From: Brijesh Singh <brijesh.singh@amd.com>
Subject: Re: [PATCH] crypto: ccp: Build the AMD secure processor driver only
 with AMD CPU support
Date: Sat, 30 Sep 2017 09:06:26 -0500
Message-ID: <97fbfa26-48df-419d-cd41-1a34e6c5eff3@amd.com>
References: <20170929151607.zn4lmdkyn25sczfg@pd.tnic>
 <20170929162322.47553-1-brijesh.singh@amd.com>
 <20170930083054.eeblfi65qpz2xop7@pd.tnic>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Cc: brijesh.singh@amd.com, Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Gary Hook <gary.hook@amd.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        linux-crypto@vger.kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
To: Borislav Petkov <bp@suse.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170930083054.eeblfi65qpz2xop7@pd.tnic>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org



On 9/30/17 3:30 AM, Borislav Petkov wrote:
...

> From: Borislav Petkov <bp@suse.de>
>
> This is AMD-specific hardware so present it in Kconfig only when AMD
> CPU support is enabled.
>
> Signed-off-by: Borislav Petkov <bp@suse.de>
> Cc: Brijesh Singh <brijesh.singh@amd.com>
> Cc: Tom Lendacky <thomas.lendacky@amd.com>
> Cc: Gary Hook <gary.hook@amd.com>
> Cc: Herbert Xu <herbert@gondor.apana.org.au>
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: linux-crypto@vger.kernel.org
> ---
>  drivers/crypto/ccp/Kconfig | 1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/drivers/crypto/ccp/Kconfig b/drivers/crypto/ccp/Kconfig
> index 627f3e61dcac..f58a6521270b 100644
> --- a/drivers/crypto/ccp/Kconfig
> +++ b/drivers/crypto/ccp/Kconfig
> @@ -1,5 +1,6 @@
>  config CRYPTO_DEV_CCP_DD
>  	tristate "Secure Processor device driver"
> +	depends on CPU_SUP_AMD

Please note that ccp.ko is built on both x86 and aarch64 (AMD Seattle)
architectures. I have not looked into details but I thought CPU_SUP_AMD
is x64 specific config. I will look into it and verify that we don't
break AMD Seattle platform builds.

>  	default m
>  	help
>  	  Provides AMD Secure Processor device driver.
