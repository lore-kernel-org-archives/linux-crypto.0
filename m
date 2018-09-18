From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: Re: [PATCH 1/2] cpufeature: avoid warning when compiling with clang
Date: Tue, 18 Sep 2018 08:49:50 -0700
Message-ID: <CAKv+Gu8_WwcOaJnSP6L03ihNg_+GGLyzaRtCcpkFetbACy3rAQ@mail.gmail.com>
References: <20180916043825.23247-1-stefan@agner.ch>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Russell King <linux@armlinux.org.uk>,
        "open list:HARDWARE RANDOM NUMBER GENERATOR CORE"
        <linux-crypto@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
To: Stefan Agner <stefan@agner.ch>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180916043825.23247-1-stefan@agner.ch>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On 15 September 2018 at 21:38, Stefan Agner <stefan@agner.ch> wrote:
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

Acked-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>

> ---
>  include/linux/cpufeature.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/include/linux/cpufeature.h b/include/linux/cpufeature.h
> index 986c06c88d81..84d3c81b5978 100644
> --- a/include/linux/cpufeature.h
> +++ b/include/linux/cpufeature.h
> @@ -45,7 +45,7 @@
>   * 'asm/cpufeature.h' of your favorite architecture.
>   */
>  #define module_cpu_feature_match(x, __initfunc)                        \
> -static struct cpu_feature const cpu_feature_match_ ## x[] =    \
> +static struct cpu_feature const __maybe_unused cpu_feature_match_ ## x[] = \
>         { { .feature = cpu_feature(x) }, { } };                 \
>  MODULE_DEVICE_TABLE(cpu, cpu_feature_match_ ## x);             \
>                                                                 \
> --
> 2.19.0
>
