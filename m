From: Milan Broz <gmazyland-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] ARM: crypto: update NEON AES module to
 latest OpenSSL version
Date: Sat, 28 Feb 2015 23:30:57 +0100
Message-ID: <54F241A1.1060104@gmail.com>
References: <1424935325-14437-1-git-send-email-ard.biesheuvel@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: dm-crypt <dm-crypt-4q3lyFh4P1g@public.gmane.org>, Johannes Ernst <johannes.ernst-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
 nico-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org
To: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, linux-lFZ/pmaqli7XmaaqVzeoHQ@public.gmane.org,
 herbert-lOAM2aK0SrRLBo1qDEOMRrpzq4S04n8Q@public.gmane.org, linux-crypto-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
 linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org
Return-path: <dm-crypt-bounces-4q3lyFh4P1g@public.gmane.org>
In-Reply-To: <1424935325-14437-1-git-send-email-ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
List-Unsubscribe: <http://www.saout.de/mailman/options/dm-crypt>,
 <mailto:dm-crypt-request-4q3lyFh4P1g@public.gmane.org?subject=unsubscribe>
List-Archive: <http://www.saout.de/pipermail/dm-crypt/>
List-Post: <mailto:dm-crypt-4q3lyFh4P1g@public.gmane.org>
List-Help: <mailto:dm-crypt-request-4q3lyFh4P1g@public.gmane.org?subject=help>
List-Subscribe: <http://www.saout.de/mailman/listinfo/dm-crypt>,
 <mailto:dm-crypt-request-4q3lyFh4P1g@public.gmane.org?subject=subscribe>
Errors-To: dm-crypt-bounces-4q3lyFh4P1g@public.gmane.org
Sender: "dm-crypt" <dm-crypt-bounces-4q3lyFh4P1g@public.gmane.org>
List-Id: linux-crypto.vger.kernel.org

On 02/26/2015 08:22 AM, Ard Biesheuvel wrote:
> This updates the bit sliced AES module to the latest version in the
> upstream OpenSSL repository (e620e5ae37bc). This is needed to fix a
> bug in the XTS decryption path, where data chunked in a certain way
> could trigger the ciphertext stealing code, which is not supposed to
> be active in the kernel build (The kernel implementation of XTS only
> supports round multiples of the AES block size of 16 bytes, whereas
> the conformant OpenSSL implementation of XTS supports inputs of
> arbitrary size by applying ciphertext stealing). This is fixed in
> the upstream version by adding the missing #ifndef XTS_CHAIN_TWEAK
> around the offending instructions.
> 
> The upstream code also contains the change applied by Russell to
> build the code unconditionally, i.e., even if __LINUX_ARM_ARCH__ < 7,
> but implemented slightly differently.
> 
> Fixes: e4e7f10bfc40 ("ARM: add support for bit sliced AES using NEON instructions")
> Reported-by: Adrian Kotelba <adrian.kotelba-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> Signed-off-by: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
> ---
> 
> This was found using the tcrypt test code, to which I recently added additional
> chunking modes. However, XTS typically operates on pages or at least on sectors,
> so this bug is unlikely to affect anyone in real life.
> 
> Still, please add cc stable when applying,

Please apply it for stable.

For me, this patch fixed bug reported here
  http://article.gmane.org/gmane.linux.kernel.device-mapper.dm-crypt/7966
  http://www.mail-archive.com/linux-crypto-u79uwXL29TY76Z2rM5mHXA@public.gmane.org/msg13102.html

Cryptsetup uses AF_ALG userspace crypto SKCIPHER interface and on
Raspberry Pi2 with Neon AES implementation it fails to unlock LUKS device
(if XTS and aes-arm-bs module is used).

After applying this patch it works as expected.

I did not have time to check it more in detail (we are always encrypting
the whole sector so this should not happen... but apparently it does.)

Tested-by: Milan Broz <gmazyland-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

Thanks,
Milan

> 
> Thanks,
> Ard.
> 
> 
>  arch/arm/crypto/aesbs-core.S_shipped | 12 ++++++++----
>  arch/arm/crypto/bsaes-armv7.pl       | 12 ++++++++----
>  2 files changed, 16 insertions(+), 8 deletions(-)
> 
> diff --git a/arch/arm/crypto/aesbs-core.S_shipped b/arch/arm/crypto/aesbs-core.S_shipped
> index 71e5fc7cfb18..1d1800f71c5b 100644
> --- a/arch/arm/crypto/aesbs-core.S_shipped
> +++ b/arch/arm/crypto/aesbs-core.S_shipped
> @@ -58,14 +58,18 @@
>  # define VFP_ABI_FRAME	0
>  # define BSAES_ASM_EXTENDED_KEY
>  # define XTS_CHAIN_TWEAK
> -# define __ARM_ARCH__	7
> +# define __ARM_ARCH__ __LINUX_ARM_ARCH__
> +# define __ARM_MAX_ARCH__ 7
>  #endif
>  
>  #ifdef __thumb__
>  # define adrl adr
>  #endif
>  
> -#if __ARM_ARCH__>=7
> +#if __ARM_MAX_ARCH__>=7
> +.arch	armv7-a
> +.fpu	neon
> +
>  .text
>  .syntax	unified 	@ ARMv7-capable assembler is expected to handle this
>  #ifdef __thumb2__
> @@ -74,8 +78,6 @@
>  .code   32
>  #endif
>  
> -.fpu	neon
> -
>  .type	_bsaes_decrypt8,%function
>  .align	4
>  _bsaes_decrypt8:
> @@ -2095,9 +2097,11 @@ bsaes_xts_decrypt:
>  	vld1.8	{q8}, [r0]			@ initial tweak
>  	adr	r2, .Lxts_magic
>  
> +#ifndef	XTS_CHAIN_TWEAK
>  	tst	r9, #0xf			@ if not multiple of 16
>  	it	ne				@ Thumb2 thing, sanity check in ARM
>  	subne	r9, #0x10			@ subtract another 16 bytes
> +#endif
>  	subs	r9, #0x80
>  
>  	blo	.Lxts_dec_short
> diff --git a/arch/arm/crypto/bsaes-armv7.pl b/arch/arm/crypto/bsaes-armv7.pl
> index be068db960ee..a4d3856e7d24 100644
> --- a/arch/arm/crypto/bsaes-armv7.pl
> +++ b/arch/arm/crypto/bsaes-armv7.pl
> @@ -701,14 +701,18 @@ $code.=<<___;
>  # define VFP_ABI_FRAME	0
>  # define BSAES_ASM_EXTENDED_KEY
>  # define XTS_CHAIN_TWEAK
> -# define __ARM_ARCH__	7
> +# define __ARM_ARCH__ __LINUX_ARM_ARCH__
> +# define __ARM_MAX_ARCH__ 7
>  #endif
>  
>  #ifdef __thumb__
>  # define adrl adr
>  #endif
>  
> -#if __ARM_ARCH__>=7
> +#if __ARM_MAX_ARCH__>=7
> +.arch	armv7-a
> +.fpu	neon
> +
>  .text
>  .syntax	unified 	@ ARMv7-capable assembler is expected to handle this
>  #ifdef __thumb2__
> @@ -717,8 +721,6 @@ $code.=<<___;
>  .code   32
>  #endif
>  
> -.fpu	neon
> -
>  .type	_bsaes_decrypt8,%function
>  .align	4
>  _bsaes_decrypt8:
> @@ -2076,9 +2078,11 @@ bsaes_xts_decrypt:
>  	vld1.8	{@XMM[8]}, [r0]			@ initial tweak
>  	adr	$magic, .Lxts_magic
>  
> +#ifndef	XTS_CHAIN_TWEAK
>  	tst	$len, #0xf			@ if not multiple of 16
>  	it	ne				@ Thumb2 thing, sanity check in ARM
>  	subne	$len, #0x10			@ subtract another 16 bytes
> +#endif
>  	subs	$len, #0x80
>  
>  	blo	.Lxts_dec_short
> 

_______________________________________________
dm-crypt mailing list
dm-crypt-4q3lyFh4P1g@public.gmane.org
http://www.saout.de/mailman/listinfo/dm-crypt
