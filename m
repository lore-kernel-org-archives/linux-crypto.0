From: Stefan Agner <stefan@agner.ch>
Subject: Re: [PATCH 1/5] crypto: arm/aes-ce - enable module autoloading based
 on CPU feature bits
Date: Sun, 09 Sep 2018 23:21:23 -0700
Message-ID: <f68937805ccdbdd296118ee6871fa25e@agner.ch>
References: <1495362220-30044-1-git-send-email-ard.biesheuvel@linaro.org>
 <1495362220-30044-2-git-send-email-ard.biesheuvel@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 herbert@gondor.apana.org.au
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <1495362220-30044-2-git-send-email-ard.biesheuvel@linaro.org>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
List-Id: linux-crypto.vger.kernel.org

Hi Ard,

On 21.05.2017 03:23, Ard Biesheuvel wrote:
> Make the module autoloadable by tying it to the CPU feature bit that
> describes whether the optional instructions it relies on are implemented
> by the current CPU.
> 

This leads to a compiler warning when compiling multi_v7_defconfig/ARM32
using Clang 6.0.1:

arch/arm/crypto/aes-ce-glue.c:450:1: warning: variable
'cpu_feature_match_AES' is not needed and will not
      be emitted [-Wunneeded-internal-declaration]
module_cpu_feature_match(AES, aes_init);

./include/linux/cpufeature.h:48:33: note: expanded from macro
'module_cpu_feature_match'
static struct cpu_feature const cpu_feature_match_ ## x[] =     \

<scratch space>:83:1: note: expanded from here
cpu_feature_match_AES
^
1 warning generated.

Do you happen to have an idea how to alleviate?

--
Stefan


> Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
> ---
>  arch/arm/crypto/aes-ce-glue.c | 6 ++----
>  1 file changed, 2 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/arm/crypto/aes-ce-glue.c b/arch/arm/crypto/aes-ce-glue.c
> index 883b84d828c5..0f966a8ca1ce 100644
> --- a/arch/arm/crypto/aes-ce-glue.c
> +++ b/arch/arm/crypto/aes-ce-glue.c
> @@ -14,6 +14,7 @@
>  #include <crypto/aes.h>
>  #include <crypto/internal/simd.h>
>  #include <crypto/internal/skcipher.h>
> +#include <linux/cpufeature.h>
>  #include <linux/module.h>
>  #include <crypto/xts.h>
>  
> @@ -425,9 +426,6 @@ static int __init aes_init(void)
>  	int err;
>  	int i;
>  
> -	if (!(elf_hwcap2 & HWCAP2_AES))
> -		return -ENODEV;
> -
>  	err = crypto_register_skciphers(aes_algs, ARRAY_SIZE(aes_algs));
>  	if (err)
>  		return err;
> @@ -451,5 +449,5 @@ static int __init aes_init(void)
>  	return err;
>  }
>  
> -module_init(aes_init);
> +module_cpu_feature_match(AES, aes_init);
>  module_exit(aes_exit);
