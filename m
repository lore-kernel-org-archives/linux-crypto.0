From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 1/2] cpufeature: avoid warning when compiling with clang
Date: Fri, 21 Sep 2018 13:46:31 +0800
Message-ID: <20180921054631.m573qaxoqhql3juj@gondor.apana.org.au>
References: <20180916043825.23247-1-stefan@agner.ch>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: davem@davemloft.net, ard.biesheuvel@linaro.org,
        linux@armlinux.org.uk, linux-crypto@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
To: Stefan Agner <stefan@agner.ch>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180916043825.23247-1-stefan@agner.ch>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Sat, Sep 15, 2018 at 09:38:24PM -0700, Stefan Agner wrote:
> The table id (second) argument to MODULE_DEVICE_TABLE is often
> referenced otherwise. This is not the case for CPU features. This
> leads to warnings when building the kernel with Clang:
>   arch/arm/crypto/aes-ce-glue.c:450:1: warning: variable
>     'cpu_feature_match_AES' is not needed and will not be emitted
>     [-Wunneeded-internal-declaration]
>   module_cpu_feature_match(AES, aes_init);
>   ^
> 
> Avoid warnings by using __maybe_unused, similar to commit 1f318a8bafcf
> ("modules: mark __inittest/__exittest as __maybe_unused").
> 
> Fixes: 67bad2fdb754 ("cpu: add generic support for CPU feature based module autoloading")
> Signed-off-by: Stefan Agner <stefan@agner.ch>
> ---
>  include/linux/cpufeature.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

All applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
