From: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
Subject: Re: [PATCHv2] arm: crypto: Add optimized SHA-256/224
Date: Tue, 24 Mar 2015 13:27:02 +0100
Message-ID: <20150324122702.GJ14457@ns203013.ovh.net>
References: <20150316154835.GA31336@google.com>
 <20150323135009.GB820@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: herbert@gondor.apana.org.au, ard.biesheuvel@linaro.org,
 linux-crypto@vger.kernel.org, Andy Polyakov <appro@openssl.org>,
 davem@davemloft.net, linux-arm-kernel@lists.infradead.org
To: Sami Tolvanen <samitolvanen@google.com>
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
Content-Disposition: inline
In-Reply-To: <20150323135009.GB820@google.com>
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

On 13:50 Mon 23 Mar     , Sami Tolvanen wrote:
> Add Andy Polyakov's optimized assembly and NEON implementations for
> SHA-256/224.
> 
> The sha256-armv4.pl script for generating the assembly code is from
> OpenSSL commit 2ecd32a1f8f0643ae7b38f59bbaf9f0d6ef326fe.
> 
> Compared to sha256-generic these implementations have the following
> tcrypt speed improvements on Motorola Nexus 6 (Snapdragon 805):
> 
>   bs    b/u      sha256-neon  sha256-asm
>   16    16       x1.32        x1.19
>   64    16       x1.27        x1.15
>   64    64       x1.36        x1.20
>   256   16       x1.22        x1.11
>   256   64       x1.36        x1.19
>   256   256      x1.59        x1.23
>   1024  16       x1.21        x1.10
>   1024  256      x1.65        x1.23
>   1024  1024     x1.76        x1.25
>   2048  16       x1.21        x1.10
>   2048  256      x1.66        x1.23
>   2048  1024     x1.78        x1.25
>   2048  2048     x1.79        x1.25
>   4096  16       x1.20        x1.09
>   4096  256      x1.66        x1.23
>   4096  1024     x1.79        x1.26
>   4096  4096     x1.82        x1.26
>   8192  16       x1.20        x1.09
>   8192  256      x1.67        x1.23
>   8192  1024     x1.80        x1.26
>   8192  4096     x1.85        x1.28
>   8192  8192     x1.85        x1.27
> 
> Where bs refers to block size and b/u to bytes per update.
> 
> Signed-off-by: Sami Tolvanen <samitolvanen@google.com>
> Cc: Andy Polyakov <appro@openssl.org>
> 
> ---
> Changes since v1:
>   Rebased to Herbert's cryptodev tree
>   Include sha256-armv4.pl and use it to generate sha256-core.S
>   Add integer-only assembly version as sha256-asm
>   Add support for SHA-224 to the glue code
>   Change priority for sha256/224-ce to 300
> 
> ---
>  arch/arm/crypto/Kconfig               |    7 
>  arch/arm/crypto/Makefile              |    8 
>  arch/arm/crypto/sha2-ce-glue.c        |    4 
>  arch/arm/crypto/sha256-armv4.pl       |  713 ++++++
>  arch/arm/crypto/sha256-core.S_shipped | 2775 ++++++++++++++++++++++++
>  arch/arm/crypto/sha256_glue.c         |  246 ++
>  arch/arm/crypto/sha256_glue.h         |   23 
>  arch/arm/crypto/sha256_neon_glue.c    |  172 +
>  8 files changed, 3945 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/arm/crypto/Kconfig b/arch/arm/crypto/Kconfig
> index d63f319..458729d 100644
> --- a/arch/arm/crypto/Kconfig
> +++ b/arch/arm/crypto/Kconfig
> @@ -46,6 +46,13 @@ config CRYPTO_SHA2_ARM_CE
>  	  SHA-256 secure hash standard (DFIPS 180-2) implemented
>  	  using special ARMv8 Crypto Extensions.
>  
> +config CRYPTO_SHA256_ARM
> +	tristate "SHA-224/256 digest algorithm (ARM-asm and NEON)"
> +	select CRYPTO_HASH
> +	help
> +	  SHA-256 secure hash standard (DFIPS 180-2) implemented
> +	  using optimized ARM assembler and NEON, when available.
> +
>  config CRYPTO_SHA512_ARM_NEON
>  	tristate "SHA384 and SHA512 digest algorithm (ARM NEON)"
>  	depends on KERNEL_MODE_NEON
> diff --git a/arch/arm/crypto/Makefile b/arch/arm/crypto/Makefile
> index 9a273bd..ef46e89 100644
> --- a/arch/arm/crypto/Makefile
> +++ b/arch/arm/crypto/Makefile
> @@ -7,6 +7,7 @@ obj-$(CONFIG_CRYPTO_AES_ARM_BS) += aes-arm-bs.o
>  obj-$(CONFIG_CRYPTO_AES_ARM_CE) += aes-arm-ce.o
>  obj-$(CONFIG_CRYPTO_SHA1_ARM) += sha1-arm.o
>  obj-$(CONFIG_CRYPTO_SHA1_ARM_NEON) += sha1-arm-neon.o
> +obj-$(CONFIG_CRYPTO_SHA256_ARM) += sha256-arm.o
>  obj-$(CONFIG_CRYPTO_SHA512_ARM_NEON) += sha512-arm-neon.o
>  obj-$(CONFIG_CRYPTO_SHA1_ARM_CE) += sha1-arm-ce.o
>  obj-$(CONFIG_CRYPTO_SHA2_ARM_CE) += sha2-arm-ce.o
> @@ -16,6 +17,8 @@ aes-arm-y	:= aes-armv4.o aes_glue.o
>  aes-arm-bs-y	:= aesbs-core.o aesbs-glue.o
>  sha1-arm-y	:= sha1-armv4-large.o sha1_glue.o
>  sha1-arm-neon-y	:= sha1-armv7-neon.o sha1_neon_glue.o
> +sha256-arm-neon-$(CONFIG_KERNEL_MODE_NEON) := sha256_neon_glue.o
> +sha256-arm-y	:= sha256-core.o sha256_glue.o $(sha256-arm-neon-y)
>  sha512-arm-neon-y := sha512-armv7-neon.o sha512_neon_glue.o
>  sha1-arm-ce-y	:= sha1-ce-core.o sha1-ce-glue.o
>  sha2-arm-ce-y	:= sha2-ce-core.o sha2-ce-glue.o
> @@ -28,4 +31,7 @@ quiet_cmd_perl = PERL    $@
>  $(src)/aesbs-core.S_shipped: $(src)/bsaes-armv7.pl
>  	$(call cmd,perl)
>  
> -.PRECIOUS: $(obj)/aesbs-core.S
> +$(src)/sha256-core.S_shipped: $(src)/sha256-armv4.pl
> +	$(call cmd,perl)
> +
> +.PRECIOUS: $(obj)/aesbs-core.S $(obj)/sha256-core.S
> diff --git a/arch/arm/crypto/sha2-ce-glue.c b/arch/arm/crypto/sha2-ce-glue.c
> index 9ffe8ad..0449eca 100644
> --- a/arch/arm/crypto/sha2-ce-glue.c
> +++ b/arch/arm/crypto/sha2-ce-glue.c
> @@ -163,7 +163,7 @@ static struct shash_alg algs[] = { {
>  	.base			= {
>  		.cra_name		= "sha224",
>  		.cra_driver_name	= "sha224-ce",
> -		.cra_priority		= 200,
> +		.cra_priority		= 300,
>  		.cra_flags		= CRYPTO_ALG_TYPE_SHASH,
>  		.cra_blocksize		= SHA256_BLOCK_SIZE,
>  		.cra_module		= THIS_MODULE,
> @@ -180,7 +180,7 @@ static struct shash_alg algs[] = { {
>  	.base			= {
>  		.cra_name		= "sha256",
>  		.cra_driver_name	= "sha256-ce",
> -		.cra_priority		= 200,
> +		.cra_priority		= 300,
>  		.cra_flags		= CRYPTO_ALG_TYPE_SHASH,
>  		.cra_blocksize		= SHA256_BLOCK_SIZE,
>  		.cra_module		= THIS_MODULE,
> diff --git a/arch/arm/crypto/sha256-armv4.pl b/arch/arm/crypto/sha256-armv4.pl
> new file mode 100644
> index 0000000..4fee74d
> --- /dev/null
> +++ b/arch/arm/crypto/sha256-armv4.pl
> @@ -0,0 +1,713 @@
> +#!/usr/bin/env perl
> +
> +# ====================================================================
> +# Written by Andy Polyakov <appro@openssl.org> for the OpenSSL
> +# project. The module is, however, dual licensed under OpenSSL and
> +# CRYPTOGAMS licenses depending on where you obtain it. For further
> +# details see http://www.openssl.org/~appro/cryptogams/.
> +#
> +# Permission to use under GPL terms is granted.
> +# ====================================================================
> +
> +# SHA256 block procedure for ARMv4. May 2007.
> +
> +# Performance is ~2x better than gcc 3.4 generated code and in "abso-
> +# lute" terms is ~2250 cycles per 64-byte block or ~35 cycles per
> +# byte [on single-issue Xscale PXA250 core].
> +
> +# July 2010.
> +#
> +# Rescheduling for dual-issue pipeline resulted in 22% improvement on
> +# Cortex A8 core and ~20 cycles per processed byte.
> +
> +# February 2011.
> +#
> +# Profiler-assisted and platform-specific optimization resulted in 16%
> +# improvement on Cortex A8 core and ~15.4 cycles per processed byte.
> +
> +# September 2013.
> +#
> +# Add NEON implementation. On Cortex A8 it was measured to process one
> +# byte in 12.5 cycles or 23% faster than integer-only code. Snapdragon
> +# S4 does it in 12.5 cycles too, but it's 50% faster than integer-only
> +# code (meaning that latter performs sub-optimally, nothing was done
> +# about it).
> +
> +# May 2014.
> +#
> +# Add ARMv8 code path performing at 2.0 cpb on Apple A7.
> +
> +while (($output=shift) && ($output!~/^\w[\w\-]*\.\w+$/)) {}
> +open STDOUT,">$output";
> +
> +$ctx="r0";	$t0="r0";
> +$inp="r1";	$t4="r1";
> +$len="r2";	$t1="r2";
> +$T1="r3";	$t3="r3";
> +$A="r4";
> +$B="r5";
> +$C="r6";
> +$D="r7";
> +$E="r8";
> +$F="r9";
> +$G="r10";
> +$H="r11";
> +@V=($A,$B,$C,$D,$E,$F,$G,$H);
> +$t2="r12";
> +$Ktbl="r14";
> +
> +@Sigma0=( 2,13,22);
> +@Sigma1=( 6,11,25);
> +@sigma0=( 7,18, 3);
> +@sigma1=(17,19,10);
> +
> +sub BODY_00_15 {
> +my ($i,$a,$b,$c,$d,$e,$f,$g,$h) = @_;
> +
> +$code.=<<___ if ($i<16);
> +#if __ARM_ARCH__>=7
> +	@ ldr	$t1,[$inp],#4			@ $i
> +# if $i==15
> +	str	$inp,[sp,#17*4]			@ make room for $t4
> +# endif
> +	eor	$t0,$e,$e,ror#`$Sigma1[1]-$Sigma1[0]`
> +	add	$a,$a,$t2			@ h+=Maj(a,b,c) from the past
> +	eor	$t0,$t0,$e,ror#`$Sigma1[2]-$Sigma1[0]`	@ Sigma1(e)
> +	rev	$t1,$t1
> +#else
> +	@ ldrb	$t1,[$inp,#3]			@ $i
> +	add	$a,$a,$t2			@ h+=Maj(a,b,c) from the past
> +	ldrb	$t2,[$inp,#2]
> +	ldrb	$t0,[$inp,#1]
> +	orr	$t1,$t1,$t2,lsl#8
> +	ldrb	$t2,[$inp],#4
> +	orr	$t1,$t1,$t0,lsl#16
> +# if $i==15
> +	str	$inp,[sp,#17*4]			@ make room for $t4
> +# endif
> +	eor	$t0,$e,$e,ror#`$Sigma1[1]-$Sigma1[0]`
> +	orr	$t1,$t1,$t2,lsl#24
> +	eor	$t0,$t0,$e,ror#`$Sigma1[2]-$Sigma1[0]`	@ Sigma1(e)
> +#endif
> +___
> +$code.=<<___;
> +	ldr	$t2,[$Ktbl],#4			@ *K256++
> +	add	$h,$h,$t1			@ h+=X[i]
> +	str	$t1,[sp,#`$i%16`*4]
> +	eor	$t1,$f,$g
> +	add	$h,$h,$t0,ror#$Sigma1[0]	@ h+=Sigma1(e)
> +	and	$t1,$t1,$e
> +	add	$h,$h,$t2			@ h+=K256[i]
> +	eor	$t1,$t1,$g			@ Ch(e,f,g)
> +	eor	$t0,$a,$a,ror#`$Sigma0[1]-$Sigma0[0]`
> +	add	$h,$h,$t1			@ h+=Ch(e,f,g)
> +#if $i==31
> +	and	$t2,$t2,#0xff
> +	cmp	$t2,#0xf2			@ done?
> +#endif
> +#if $i<15
> +# if __ARM_ARCH__>=7
> +	ldr	$t1,[$inp],#4			@ prefetch
> +# else
> +	ldrb	$t1,[$inp,#3]
> +# endif
> +	eor	$t2,$a,$b			@ a^b, b^c in next round
> +#else
> +	ldr	$t1,[sp,#`($i+2)%16`*4]		@ from future BODY_16_xx
> +	eor	$t2,$a,$b			@ a^b, b^c in next round
> +	ldr	$t4,[sp,#`($i+15)%16`*4]	@ from future BODY_16_xx
> +#endif
> +	eor	$t0,$t0,$a,ror#`$Sigma0[2]-$Sigma0[0]`	@ Sigma0(a)
> +	and	$t3,$t3,$t2			@ (b^c)&=(a^b)
> +	add	$d,$d,$h			@ d+=h
> +	eor	$t3,$t3,$b			@ Maj(a,b,c)
> +	add	$h,$h,$t0,ror#$Sigma0[0]	@ h+=Sigma0(a)
> +	@ add	$h,$h,$t3			@ h+=Maj(a,b,c)
> +___
> +	($t2,$t3)=($t3,$t2);
> +}
> +
> +sub BODY_16_XX {
> +my ($i,$a,$b,$c,$d,$e,$f,$g,$h) = @_;
> +
> +$code.=<<___;
> +	@ ldr	$t1,[sp,#`($i+1)%16`*4]		@ $i
> +	@ ldr	$t4,[sp,#`($i+14)%16`*4]
> +	mov	$t0,$t1,ror#$sigma0[0]
> +	add	$a,$a,$t2			@ h+=Maj(a,b,c) from the past
> +	mov	$t2,$t4,ror#$sigma1[0]
> +	eor	$t0,$t0,$t1,ror#$sigma0[1]
> +	eor	$t2,$t2,$t4,ror#$sigma1[1]
> +	eor	$t0,$t0,$t1,lsr#$sigma0[2]	@ sigma0(X[i+1])
> +	ldr	$t1,[sp,#`($i+0)%16`*4]
> +	eor	$t2,$t2,$t4,lsr#$sigma1[2]	@ sigma1(X[i+14])
> +	ldr	$t4,[sp,#`($i+9)%16`*4]
> +
> +	add	$t2,$t2,$t0
> +	eor	$t0,$e,$e,ror#`$Sigma1[1]-$Sigma1[0]`	@ from BODY_00_15
> +	add	$t1,$t1,$t2
> +	eor	$t0,$t0,$e,ror#`$Sigma1[2]-$Sigma1[0]`	@ Sigma1(e)
> +	add	$t1,$t1,$t4			@ X[i]
> +___
> +	&BODY_00_15(@_);
> +}
> +
> +$code=<<___;
> +#ifndef __KERNEL__
> +# include "arm_arch.h"
> +#else
> +# define __ARM_ARCH__ __LINUX_ARM_ARCH__
> +# define __ARM_MAX_ARCH__ 7
I'm not sure this will work for kernel that is for older arm
> +#endif
> +
> +.text
> +#if __ARM_ARCH__<7
> +.code	32
> +#else
> +.syntax unified
> +# ifdef __thumb2__
> +.thumb
> +# else
> +.code   32
> +# endif
> +#endif
> +
> +.type	K256,%object
> +.align	5
> +K256:
> +.word	0x428a2f98,0x71374491,0xb5c0fbcf,0xe9b5dba5
> +.word	0x3956c25b,0x59f111f1,0x923f82a4,0xab1c5ed5
> +.word	0xd807aa98,0x12835b01,0x243185be,0x550c7dc3
> +.word	0x72be5d74,0x80deb1fe,0x9bdc06a7,0xc19bf174
> +.word	0xe49b69c1,0xefbe4786,0x0fc19dc6,0x240ca1cc
> +.word	0x2de92c6f,0x4a7484aa,0x5cb0a9dc,0x76f988da
> +.word	0x983e5152,0xa831c66d,0xb00327c8,0xbf597fc7
> +.word	0xc6e00bf3,0xd5a79147,0x06ca6351,0x14292967
> +.word	0x27b70a85,0x2e1b2138,0x4d2c6dfc,0x53380d13
> +.word	0x650a7354,0x766a0abb,0x81c2c92e,0x92722c85
> +.word	0xa2bfe8a1,0xa81a664b,0xc24b8b70,0xc76c51a3
> +.word	0xd192e819,0xd6990624,0xf40e3585,0x106aa070
> +.word	0x19a4c116,0x1e376c08,0x2748774c,0x34b0bcb5
> +.word	0x391c0cb3,0x4ed8aa4a,0x5b9cca4f,0x682e6ff3
> +.word	0x748f82ee,0x78a5636f,0x84c87814,0x8cc70208
> +.word	0x90befffa,0xa4506ceb,0xbef9a3f7,0xc67178f2
> +.size	K256,.-K256
> +.word	0				@ terminator
> +#if __ARM_MAX_ARCH__>=7 && !defined(__KERNEL__)
> +.LOPENSSL_armcap:
> +.word	OPENSSL_armcap_P-sha256_block_data_order
> +#endif
> +.align	5
> +
> +.global	sha256_block_data_order
> +.type	sha256_block_data_order,%function
> +sha256_block_data_order:
> +#if __ARM_ARCH__<7
> +	sub	r3,pc,#8		@ sha256_block_data_order
> +#else
> +	adr	r3,sha256_block_data_order
> +#endif
> +#if __ARM_MAX_ARCH__>=7 && !defined(__KERNEL__)
> +	ldr	r12,.LOPENSSL_armcap
> +	ldr	r12,[r3,r12]		@ OPENSSL_armcap_P
> +	tst	r12,#ARMV8_SHA256
> +	bne	.LARMv8
> +	tst	r12,#ARMV7_NEON
> +	bne	.LNEON
> +#endif
> +	add	$len,$inp,$len,lsl#6	@ len to point at the end of inp
> +	stmdb	sp!,{$ctx,$inp,$len,r4-r11,lr}
> +	ldmia	$ctx,{$A,$B,$C,$D,$E,$F,$G,$H}
> +	sub	$Ktbl,r3,#256+32	@ K256
> +	sub	sp,sp,#16*4		@ alloca(X[16])
> +.Loop:
> +# if __ARM_ARCH__>=7
> +	ldr	$t1,[$inp],#4
> +# else
> +	ldrb	$t1,[$inp,#3]
> +# endif
> +	eor	$t3,$B,$C		@ magic
> +	eor	$t2,$t2,$t2
> +___
> +for($i=0;$i<16;$i++)	{ &BODY_00_15($i,@V); unshift(@V,pop(@V)); }
> +$code.=".Lrounds_16_xx:\n";
> +for (;$i<32;$i++)	{ &BODY_16_XX($i,@V); unshift(@V,pop(@V)); }
> +$code.=<<___;
> +#if __ARM_ARCH__>=7
> +	ite	eq			@ Thumb2 thing, sanity check in ARM
> +#endif
> +	ldreq	$t3,[sp,#16*4]		@ pull ctx
> +	bne	.Lrounds_16_xx
> +
> +	add	$A,$A,$t2		@ h+=Maj(a,b,c) from the past
> +	ldr	$t0,[$t3,#0]
> +	ldr	$t1,[$t3,#4]
> +	ldr	$t2,[$t3,#8]
> +	add	$A,$A,$t0
> +	ldr	$t0,[$t3,#12]
> +	add	$B,$B,$t1
> +	ldr	$t1,[$t3,#16]
> +	add	$C,$C,$t2
> +	ldr	$t2,[$t3,#20]
> +	add	$D,$D,$t0
> +	ldr	$t0,[$t3,#24]
> +	add	$E,$E,$t1
> +	ldr	$t1,[$t3,#28]
> +	add	$F,$F,$t2
> +	ldr	$inp,[sp,#17*4]		@ pull inp
> +	ldr	$t2,[sp,#18*4]		@ pull inp+len
> +	add	$G,$G,$t0
> +	add	$H,$H,$t1
> +	stmia	$t3,{$A,$B,$C,$D,$E,$F,$G,$H}
> +	cmp	$inp,$t2
> +	sub	$Ktbl,$Ktbl,#256	@ rewind Ktbl
> +	bne	.Loop
> +
> +	add	sp,sp,#`16+3`*4	@ destroy frame
> +#if __ARM_ARCH__>=5
> +	ldmia	sp!,{r4-r11,pc}
> +#else
> +	ldmia	sp!,{r4-r11,lr}
> +	tst	lr,#1
> +	moveq	pc,lr			@ be binary compatible with V4, yet
> +	bx	lr			@ interoperable with Thumb ISA:-)
> +#endif
> +.size	sha256_block_data_order,.-sha256_block_data_order
> +___
> +######################################################################
> +# NEON stuff
> +#
> +{{{
> +my @X=map("q$_",(0..3));
> +my ($T0,$T1,$T2,$T3,$T4,$T5)=("q8","q9","q10","q11","d24","d25");
> +my $Xfer=$t4;
> +my $j=0;
> +
> +sub Dlo()   { shift=~m|q([1]?[0-9])|?"d".($1*2):"";     }
> +sub Dhi()   { shift=~m|q([1]?[0-9])|?"d".($1*2+1):"";   }
> +
> +sub AUTOLOAD()          # thunk [simplified] x86-style perlasm
> +{ my $opcode = $AUTOLOAD; $opcode =~ s/.*:://; $opcode =~ s/_/\./;
> +  my $arg = pop;
> +    $arg = "#$arg" if ($arg*1 eq $arg);
> +    $code .= "\t$opcode\t".join(',',@_,$arg)."\n";
> +}
> +
> +sub Xupdate()
> +{ use integer;
> +  my $body = shift;
> +  my @insns = (&$body,&$body,&$body,&$body);
> +  my ($a,$b,$c,$d,$e,$f,$g,$h);
> +
> +	&vext_8		($T0,@X[0],@X[1],4);	# X[1..4]
> +	 eval(shift(@insns));
> +	 eval(shift(@insns));
> +	 eval(shift(@insns));
> +	&vext_8		($T1,@X[2],@X[3],4);	# X[9..12]
> +	 eval(shift(@insns));
> +	 eval(shift(@insns));
> +	 eval(shift(@insns));
> +	&vshr_u32	($T2,$T0,$sigma0[0]);
> +	 eval(shift(@insns));
> +	 eval(shift(@insns));
> +	&vadd_i32	(@X[0],@X[0],$T1);	# X[0..3] += X[9..12]
> +	 eval(shift(@insns));
> +	 eval(shift(@insns));
> +	&vshr_u32	($T1,$T0,$sigma0[2]);
> +	 eval(shift(@insns));
> +	 eval(shift(@insns));
> +	&vsli_32	($T2,$T0,32-$sigma0[0]);
> +	 eval(shift(@insns));
> +	 eval(shift(@insns));
> +	&vshr_u32	($T3,$T0,$sigma0[1]);
> +	 eval(shift(@insns));
> +	 eval(shift(@insns));
> +	&veor		($T1,$T1,$T2);
> +	 eval(shift(@insns));
> +	 eval(shift(@insns));
> +	&vsli_32	($T3,$T0,32-$sigma0[1]);
> +	 eval(shift(@insns));
> +	 eval(shift(@insns));
> +	  &vshr_u32	($T4,&Dhi(@X[3]),$sigma1[0]);
> +	 eval(shift(@insns));
> +	 eval(shift(@insns));
> +	&veor		($T1,$T1,$T3);		# sigma0(X[1..4])
> +	 eval(shift(@insns));
> +	 eval(shift(@insns));
> +	  &vsli_32	($T4,&Dhi(@X[3]),32-$sigma1[0]);
> +	 eval(shift(@insns));
> +	 eval(shift(@insns));
> +	  &vshr_u32	($T5,&Dhi(@X[3]),$sigma1[2]);
> +	 eval(shift(@insns));
> +	 eval(shift(@insns));
> +	&vadd_i32	(@X[0],@X[0],$T1);	# X[0..3] += sigma0(X[1..4])
> +	 eval(shift(@insns));
> +	 eval(shift(@insns));
> +	  &veor		($T5,$T5,$T4);
> +	 eval(shift(@insns));
> +	 eval(shift(@insns));
> +	  &vshr_u32	($T4,&Dhi(@X[3]),$sigma1[1]);
> +	 eval(shift(@insns));
> +	 eval(shift(@insns));
> +	  &vsli_32	($T4,&Dhi(@X[3]),32-$sigma1[1]);
> +	 eval(shift(@insns));
> +	 eval(shift(@insns));
> +	  &veor		($T5,$T5,$T4);		# sigma1(X[14..15])
> +	 eval(shift(@insns));
> +	 eval(shift(@insns));
> +	&vadd_i32	(&Dlo(@X[0]),&Dlo(@X[0]),$T5);# X[0..1] += sigma1(X[14..15])
> +	 eval(shift(@insns));
> +	 eval(shift(@insns));
> +	  &vshr_u32	($T4,&Dlo(@X[0]),$sigma1[0]);
> +	 eval(shift(@insns));
> +	 eval(shift(@insns));
> +	  &vsli_32	($T4,&Dlo(@X[0]),32-$sigma1[0]);
> +	 eval(shift(@insns));
> +	 eval(shift(@insns));
> +	  &vshr_u32	($T5,&Dlo(@X[0]),$sigma1[2]);
> +	 eval(shift(@insns));
> +	 eval(shift(@insns));
> +	  &veor		($T5,$T5,$T4);
> +	 eval(shift(@insns));
> +	 eval(shift(@insns));
> +	  &vshr_u32	($T4,&Dlo(@X[0]),$sigma1[1]);
> +	 eval(shift(@insns));
> +	 eval(shift(@insns));
> +	&vld1_32	("{$T0}","[$Ktbl,:128]!");
> +	 eval(shift(@insns));
> +	 eval(shift(@insns));
> +	  &vsli_32	($T4,&Dlo(@X[0]),32-$sigma1[1]);
> +	 eval(shift(@insns));
> +	 eval(shift(@insns));
> +	  &veor		($T5,$T5,$T4);		# sigma1(X[16..17])
> +	 eval(shift(@insns));
> +	 eval(shift(@insns));
> +	&vadd_i32	(&Dhi(@X[0]),&Dhi(@X[0]),$T5);# X[2..3] += sigma1(X[16..17])
> +	 eval(shift(@insns));
> +	 eval(shift(@insns));
> +	&vadd_i32	($T0,$T0,@X[0]);
> +	 while($#insns>=2) { eval(shift(@insns)); }
> +	&vst1_32	("{$T0}","[$Xfer,:128]!");
> +	 eval(shift(@insns));
> +	 eval(shift(@insns));
> +
> +	push(@X,shift(@X));		# "rotate" X[]
> +}
> +
> +sub Xpreload()
> +{ use integer;
> +  my $body = shift;
> +  my @insns = (&$body,&$body,&$body,&$body);
> +  my ($a,$b,$c,$d,$e,$f,$g,$h);
> +
> +	 eval(shift(@insns));
> +	 eval(shift(@insns));
> +	 eval(shift(@insns));
> +	 eval(shift(@insns));
> +	&vld1_32	("{$T0}","[$Ktbl,:128]!");
> +	 eval(shift(@insns));
> +	 eval(shift(@insns));
> +	 eval(shift(@insns));
> +	 eval(shift(@insns));
> +	&vrev32_8	(@X[0],@X[0]);
> +	 eval(shift(@insns));
> +	 eval(shift(@insns));
> +	 eval(shift(@insns));
> +	 eval(shift(@insns));
> +	&vadd_i32	($T0,$T0,@X[0]);
> +	 foreach (@insns) { eval; }	# remaining instructions
> +	&vst1_32	("{$T0}","[$Xfer,:128]!");
> +
> +	push(@X,shift(@X));		# "rotate" X[]
> +}
> +
> +sub body_00_15 () {
> +	(
> +	'($a,$b,$c,$d,$e,$f,$g,$h)=@V;'.
> +	'&add	($h,$h,$t1)',			# h+=X[i]+K[i]
> +	'&eor	($t1,$f,$g)',
> +	'&eor	($t0,$e,$e,"ror#".($Sigma1[1]-$Sigma1[0]))',
> +	'&add	($a,$a,$t2)',			# h+=Maj(a,b,c) from the past
> +	'&and	($t1,$t1,$e)',
> +	'&eor	($t2,$t0,$e,"ror#".($Sigma1[2]-$Sigma1[0]))',	# Sigma1(e)
> +	'&eor	($t0,$a,$a,"ror#".($Sigma0[1]-$Sigma0[0]))',
> +	'&eor	($t1,$t1,$g)',			# Ch(e,f,g)
> +	'&add	($h,$h,$t2,"ror#$Sigma1[0]")',	# h+=Sigma1(e)
> +	'&eor	($t2,$a,$b)',			# a^b, b^c in next round
> +	'&eor	($t0,$t0,$a,"ror#".($Sigma0[2]-$Sigma0[0]))',	# Sigma0(a)
> +	'&add	($h,$h,$t1)',			# h+=Ch(e,f,g)
> +	'&ldr	($t1,sprintf "[sp,#%d]",4*(($j+1)&15))	if (($j&15)!=15);'.
> +	'&ldr	($t1,"[$Ktbl]")				if ($j==15);'.
> +	'&ldr	($t1,"[sp,#64]")			if ($j==31)',
> +	'&and	($t3,$t3,$t2)',			# (b^c)&=(a^b)
> +	'&add	($d,$d,$h)',			# d+=h
> +	'&add	($h,$h,$t0,"ror#$Sigma0[0]");'.	# h+=Sigma0(a)
> +	'&eor	($t3,$t3,$b)',			# Maj(a,b,c)
> +	'$j++;	unshift(@V,pop(@V)); ($t2,$t3)=($t3,$t2);'
> +	)
> +}
> +
> +$code.=<<___;
> +#if __ARM_MAX_ARCH__>=7
this will be compile on armv4 but gcc will not allow it

we need to drop the neon code for older non v7 build

Best Regards,
J.
