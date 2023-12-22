Received: from mail-il1-f178.google.com (mail-il1-f178.google.com [209.85.166.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98411A41
	for <linux-crypto@vger.kernel.org>; Fri, 22 Dec 2023 02:06:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=sifive.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sifive.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sifive.com header.i=@sifive.com header.b="QJ4yyD3e"
Received: by mail-il1-f178.google.com with SMTP id e9e14a558f8ab-35d3846fac9so5697785ab.2
        for <linux-crypto@vger.kernel.org>; Thu, 21 Dec 2023 18:06:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sifive.com; s=google; t=1703210759; x=1703815559; darn=vger.kernel.org;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=IuFAxTItdoyfMfeRzFtU0VjUTmb0ItN1IqlKW1kZ5Fw=;
        b=QJ4yyD3ef+Y0Pa76LPnThGx3lIHP3Db3g4o8ncr8H3pIAnADLSTasyV3uS0Vz2MHS3
         p3YlQoOuei/TWt5mT3EhPVlsDXb2Tr/OfdaNQmoHJ6Tc40FbLA4O3KCY7Sbt/maYg52V
         nWVWqvhQ7VHEJuieY5XKEoVPeHaErPE+E1VgfJ979HaDha6iQhHVW+UQY9M0YOXSukDj
         Y0S1GrxUePhP2FNU/qboV8gXCO3aYWLZv/dGwTrW1s78v4tdFbW9Lhw/2DLCEaEJmy1v
         PkgXBsDUmS4w4vd6XooMcHkY0RgFc9WUtSoGVpuP+BDIfmLznup64geUqx88y2EOAp4h
         uspA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1703210759; x=1703815559;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=IuFAxTItdoyfMfeRzFtU0VjUTmb0ItN1IqlKW1kZ5Fw=;
        b=pnl52kYkhHxHJxy1WDT0uyHZRFRGYPcYpaV1Dk1xFVrREbz1pe2bAyI+hSrYhY+s9X
         DfwrrkYoxCtb/cWBrfxDO2x8kJEXnIkLAtkFMaAQJLeDjZoKtZUNceDOC5RhUOwp8Fyy
         GsA4McAMe6yr/X59XL0kD7zp7i0MODnwARSu0wBlojIPmiy8lczMdmbQFfl8w1oNcs7c
         89MqkhZujFbPcxH9l7S59U3sjzrrjzbjTd9eSqKo6ZdRKlfac0OjEXUBdLCznxlp7N9w
         MVdg8vSNHgrmy/dhX3u4+/GsaJq33FgLSWpo8yPLPFPE7mZQwhHJr+6dsPsodf6Fyd+v
         QAwQ==
X-Gm-Message-State: AOJu0YwzzNYT7V8PQpdIPSHiHV2YZvCsVJ7YwZGoLhMIbcmmlWa9W6Gu
	gqtk+JI/wooWae0yAP286mkGDh53NWekaQ==
X-Google-Smtp-Source: AGHT+IEorKOHVXWcG1+NutXYsHg5KhOdOcXKo46ybfoDbHuBM3+rR4YoX9oK99XNKLC4pPYwnopTJQ==
X-Received: by 2002:a05:6e02:370b:b0:35f:b06f:9c99 with SMTP id ck11-20020a056e02370b00b0035fb06f9c99mr698786ilb.64.1703210758714;
        Thu, 21 Dec 2023 18:05:58 -0800 (PST)
Received: from ?IPv6:2402:7500:5d5:b5a6:112b:fcd:68ec:f43? ([2402:7500:5d5:b5a6:112b:fcd:68ec:f43])
        by smtp.gmail.com with ESMTPSA id k10-20020a63f00a000000b005cd8044c6fesm2226939pgh.23.2023.12.21.18.05.56
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 21 Dec 2023 18:05:58 -0800 (PST)
Content-Type: text/plain;
	charset=utf-8
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 11.5 \(3445.9.7\))
Subject: Re: [PATCH] crypto: riscv - use real assembler for vector crypto
 extensions
From: Jerry Shih <jerry.shih@sifive.com>
In-Reply-To: <20231220065648.253236-1-ebiggers@kernel.org>
Date: Fri, 22 Dec 2023 10:05:54 +0800
Cc: linux-crypto@vger.kernel.org,
 linux-riscv@lists.infradead.org,
 Christoph Muellner <christoph.muellner@vrull.eu>
Content-Transfer-Encoding: quoted-printable
Message-Id: <79C8929B-DDCA-4320-B272-9CE4CAAEA7AC@sifive.com>
References: <20231220065648.253236-1-ebiggers@kernel.org>
To: Eric Biggers <ebiggers@kernel.org>
X-Mailer: Apple Mail (2.3445.9.7)

On Dec 20, 2023, at 14:56, Eric Biggers <ebiggers@kernel.org> wrote:
>=20
> From: Eric Biggers <ebiggers@google.com>
>=20
> LLVM main and binutils master now both fully support v1.0 of the =
RISC-V
> vector crypto extensions.  Therefore, delete riscv.pm and use the real
> assembler mnemonics for the vector crypto instructions.
>=20
> Signed-off-by: Eric Biggers <ebiggers@google.com>
> ---
>=20
> Hi Jerry, this patch applies to your v3 patchset
> =
(https://lore.kernel.org/linux-crypto/20231205092801.1335-1-jerry.shih@sif=
ive.com).
> Can you consider folding it into your patchset?  Thanks!

Thank you for the vector crypto asm mnemonics works.
Do you mean that fold this patch or append this one as the separated =
commit into my next v4 patchset?

> arch/riscv/Kconfig                            |   6 +
> arch/riscv/crypto/Kconfig                     |  16 +-
> .../crypto/aes-riscv64-zvkned-zvbb-zvkg.pl    | 226 +++++------
> arch/riscv/crypto/aes-riscv64-zvkned-zvkb.pl  |  98 ++---
> arch/riscv/crypto/aes-riscv64-zvkned.pl       | 314 +++++++--------
> arch/riscv/crypto/chacha-riscv64-zvkb.pl      |  34 +-
> arch/riscv/crypto/ghash-riscv64-zvkg.pl       |   4 +-
> arch/riscv/crypto/riscv.pm                    | 359 ------------------
> .../sha256-riscv64-zvknha_or_zvknhb-zvkb.pl   | 101 ++---
> .../crypto/sha512-riscv64-zvknhb-zvkb.pl      |  52 +--
> arch/riscv/crypto/sm3-riscv64-zvksh.pl        |  86 ++---
> arch/riscv/crypto/sm4-riscv64-zvksed.pl       |  62 +--
> 12 files changed, 503 insertions(+), 855 deletions(-)
> delete mode 100644 arch/riscv/crypto/riscv.pm
>=20
> diff --git a/arch/riscv/Kconfig b/arch/riscv/Kconfig
> index dc51164b8fd4..7267a6345e32 100644
> --- a/arch/riscv/Kconfig
> +++ b/arch/riscv/Kconfig
> @@ -531,20 +531,26 @@ config RISCV_ISA_V_PREEMPTIVE
> 	  by adding memory on demand for tracking kernel's V-context.
>=20
> config TOOLCHAIN_HAS_ZBB
> 	bool
> 	default y
> 	depends on !64BIT || $(cc-option,-mabi=3Dlp64 =
-march=3Drv64ima_zbb)
> 	depends on !32BIT || $(cc-option,-mabi=3Dilp32 =
-march=3Drv32ima_zbb)
> 	depends on LLD_VERSION >=3D 150000 || LD_VERSION >=3D 23900
> 	depends on AS_HAS_OPTION_ARCH
>=20
> +# This option indicates that the toolchain supports all v1.0 vector =
crypto
> +# extensions, including Zvk*, Zvbb, and Zvbc.  LLVM added all of =
these at once.
> +# binutils added all except Zvkb, then added Zvkb.  So we just check =
for Zvkb.
> +config TOOLCHAIN_HAS_ZVK
> +	def_bool $(as-instr, .option arch$(comma) +zvkb)
> +

Could we rename to other terms like
`TOOLCHAIN_HAS_VECTOR_CRYPTO/TOOLCHAIN_HAS_V_CRYPTO `?
Some ciphers don't use `ZVK*` extensions.

> config RISCV_ISA_ZBB
> 	bool "Zbb extension support for bit manipulation instructions"
> 	depends on TOOLCHAIN_HAS_ZBB
> 	depends on MMU
> 	depends on RISCV_ALTERNATIVE
> 	default y
> 	help
> 	   Adds support to dynamically detect the presence of the ZBB
> 	   extension (basic bit manipulation) and enable its usage.
>=20
> diff --git a/arch/riscv/crypto/Kconfig b/arch/riscv/crypto/Kconfig
> index a5c19532400e..d379f1d0a6b1 100644
> --- a/arch/riscv/crypto/Kconfig
> +++ b/arch/riscv/crypto/Kconfig
> @@ -1,105 +1,105 @@
> # SPDX-License-Identifier: GPL-2.0
>=20
> menu "Accelerated Cryptographic Algorithms for CPU (riscv)"
>=20
> config CRYPTO_AES_RISCV64
> 	tristate "Ciphers: AES"
> -	depends on 64BIT && RISCV_ISA_V
> +	depends on 64BIT && RISCV_ISA_V && TOOLCHAIN_HAS_ZVK
> 	select CRYPTO_ALGAPI
> 	select CRYPTO_LIB_AES
> 	help
> 	  Block ciphers: AES cipher algorithms (FIPS-197)
>=20
> 	  Architecture: riscv64 using:
> 	  - Zvkned vector crypto extension
>=20
> config CRYPTO_AES_BLOCK_RISCV64
> 	tristate "Ciphers: AES, modes: ECB/CBC/CTR/XTS"
> -	depends on 64BIT && RISCV_ISA_V
> +	depends on 64BIT && RISCV_ISA_V && TOOLCHAIN_HAS_ZVK
> 	select CRYPTO_AES_RISCV64
> 	select CRYPTO_SIMD
> 	select CRYPTO_SKCIPHER
> 	help
> 	  Length-preserving ciphers: AES cipher algorithms (FIPS-197)
> 	  with block cipher modes:
> 	  - ECB (Electronic Codebook) mode (NIST SP 800-38A)
> 	  - CBC (Cipher Block Chaining) mode (NIST SP 800-38A)
> 	  - CTR (Counter) mode (NIST SP 800-38A)
> 	  - XTS (XOR Encrypt XOR Tweakable Block Cipher with Ciphertext
> 	    Stealing) mode (NIST SP 800-38E and IEEE 1619)
>=20
> 	  Architecture: riscv64 using:
> 	  - Zvkned vector crypto extension
> 	  - Zvbb vector extension (XTS)
> 	  - Zvkb vector crypto extension (CTR/XTS)
> 	  - Zvkg vector crypto extension (XTS)
>=20
> config CRYPTO_CHACHA_RISCV64
> 	tristate "Ciphers: ChaCha"
> -	depends on 64BIT && RISCV_ISA_V
> +	depends on 64BIT && RISCV_ISA_V && TOOLCHAIN_HAS_ZVK
> 	select CRYPTO_SIMD
> 	select CRYPTO_SKCIPHER
> 	select CRYPTO_LIB_CHACHA_GENERIC
> 	help
> 	  Length-preserving ciphers: ChaCha20 stream cipher algorithm
>=20
> 	  Architecture: riscv64 using:
> 	  - Zvkb vector crypto extension
>=20
> config CRYPTO_GHASH_RISCV64
> 	tristate "Hash functions: GHASH"
> -	depends on 64BIT && RISCV_ISA_V
> +	depends on 64BIT && RISCV_ISA_V && TOOLCHAIN_HAS_ZVK
> 	select CRYPTO_GCM
> 	help
> 	  GCM GHASH function (NIST SP 800-38D)
>=20
> 	  Architecture: riscv64 using:
> 	  - Zvkg vector crypto extension
>=20
> config CRYPTO_SHA256_RISCV64
> 	tristate "Hash functions: SHA-224 and SHA-256"
> -	depends on 64BIT && RISCV_ISA_V
> +	depends on 64BIT && RISCV_ISA_V && TOOLCHAIN_HAS_ZVK
> 	select CRYPTO_SHA256
> 	help
> 	  SHA-224 and SHA-256 secure hash algorithm (FIPS 180)
>=20
> 	  Architecture: riscv64 using:
> 	  - Zvknha or Zvknhb vector crypto extensions
> 	  - Zvkb vector crypto extension
>=20
> config CRYPTO_SHA512_RISCV64
> 	tristate "Hash functions: SHA-384 and SHA-512"
> -	depends on 64BIT && RISCV_ISA_V
> +	depends on 64BIT && RISCV_ISA_V && TOOLCHAIN_HAS_ZVK
> 	select CRYPTO_SHA512
> 	help
> 	  SHA-384 and SHA-512 secure hash algorithm (FIPS 180)
>=20
> 	  Architecture: riscv64 using:
> 	  - Zvknhb vector crypto extension
> 	  - Zvkb vector crypto extension
>=20
> config CRYPTO_SM3_RISCV64
> 	tristate "Hash functions: SM3 (ShangMi 3)"
> -	depends on 64BIT && RISCV_ISA_V
> +	depends on 64BIT && RISCV_ISA_V && TOOLCHAIN_HAS_ZVK
> 	select CRYPTO_HASH
> 	select CRYPTO_SM3
> 	help
> 	  SM3 (ShangMi 3) secure hash function (OSCCA GM/T 0004-2012)
>=20
> 	  Architecture: riscv64 using:
> 	  - Zvksh vector crypto extension
> 	  - Zvkb vector crypto extension
>=20
> config CRYPTO_SM4_RISCV64
> 	tristate "Ciphers: SM4 (ShangMi 4)"
> -	depends on 64BIT && RISCV_ISA_V
> +	depends on 64BIT && RISCV_ISA_V && TOOLCHAIN_HAS_ZVK
> 	select CRYPTO_ALGAPI
> 	select CRYPTO_SM4
> 	help
> 	  SM4 cipher algorithms (OSCCA GB/T 32907-2016,
> 	  ISO/IEC 18033-3:2010/Amd 1:2021)
>=20
> 	  SM4 (GBT.32907-2016) is a cryptographic standard issued by the
> 	  Organization of State Commercial Administration of China =
(OSCCA)
> 	  as an authorized cryptographic algorithms for the use within =
China.
>=20
> diff --git a/arch/riscv/crypto/aes-riscv64-zvkned-zvbb-zvkg.pl =
b/arch/riscv/crypto/aes-riscv64-zvkned-zvbb-zvkg.pl
> index a67d74593860..bc7772a5944a 100644
> --- a/arch/riscv/crypto/aes-riscv64-zvkned-zvbb-zvkg.pl
> +++ b/arch/riscv/crypto/aes-riscv64-zvkned-zvbb-zvkg.pl
> @@ -31,41 +31,41 @@
> # OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, =
INCIDENTAL,
> # SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
> # LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF =
USE,
> # DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON =
ANY
> # THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
> # (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE =
USE
> # OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
>=20
> # - RV64I
> # - RISC-V Vector ('V') with VLEN >=3D 128 && VLEN <=3D 2048
> +# - RISC-V Vector AES block cipher extension ('Zvkned')
> # - RISC-V Vector Bit-manipulation extension ('Zvbb')
> # - RISC-V Vector GCM/GMAC extension ('Zvkg')
> -# - RISC-V Vector AES block cipher extension ('Zvkned')
>=20
> use strict;
> use warnings;
>=20
> use FindBin qw($Bin);
> use lib "$Bin";
> use lib "$Bin/../../perlasm";
> -use riscv;
>=20
> # $output is the last argument if it looks like a file (it has an =
extension)
> # $flavour is the first argument if it doesn't look like a file
> my $output =3D $#ARGV >=3D 0 && $ARGV[$#ARGV] =3D~ m|\.\w+$| ? pop : =
undef;
> my $flavour =3D $#ARGV >=3D 0 && $ARGV[0] !~ m|\.| ? shift : undef;
>=20
> $output and open STDOUT,">$output";
>=20
> my $code=3D<<___;
> .text
> +.option arch, +zvkned, +zvbb, +zvkg
> ___
>=20
> {
> =
##########################################################################=
######
> # void rv64i_zvbb_zvkg_zvkned_aes_xts_encrypt(const unsigned char *in,
> #                                             unsigned char *out, =
size_t length,
> #                                             const AES_KEY *key,
> #                                             unsigned char iv[16],
> #                                             int update_iv)
> my ($INPUT, $OUTPUT, $LENGTH, $KEY, $IV, $UPDATE_IV) =3D ("a0", "a1", =
"a2", "a3", "a4", "a5");
> @@ -98,25 +98,25 @@ sub init_first_round {
>     vle32.v $V24, ($INPUT)
>=20
>     li $T0, 5
>     # We could simplify the initialization steps if we have =
`block<=3D1`.
>     blt $LEN32, $T0, 1f
>=20
>     # Note: We use `vgmul` for GF(2^128) multiplication. The `vgmul` =
uses
>     # different order of coefficients. We should use`vbrev8` to =
reverse the
>     # data when we use `vgmul`.
>     vsetivli zero, 4, e32, m1, ta, ma
> -    @{[vbrev8_v $V0, $V28]}
> +    vbrev8.v $V0, $V28
>     vsetvli zero, $LEN32, e32, m4, ta, ma
>     vmv.v.i $V16, 0
>     # v16: [r-IV0, r-IV0, ...]
> -    @{[vaesz_vs $V16, $V0]}
> +    vaesz.vs $V16, $V0
>=20
>     # Prepare GF(2^128) multiplier [1, x, x^2, x^3, ...] in v8.
>     # We use `vwsll` to get power of 2 multipliers. Current rvv spec =
only
>     # supports `SEW<=3D64`. So, the maximum `VLEN` for this approach =
is `2048`.
>     #   SEW64_BITS * AES_BLOCK_SIZE / LMUL
>     #   =3D 64 * 128 / 4 =3D 2048
>     #
>     # TODO: truncate the vl to `2048` for `vlen>2048` case.
>     slli $T0, $LEN32, 2
>     vsetvli zero, $T0, e32, m1, ta, ma
> @@ -125,53 +125,53 @@ sub init_first_round {
>     # v3: [`0`, `1`, `2`, `3`, ...]
>     vid.v $V3
>     vsetvli zero, $T0, e64, m2, ta, ma
>     # v4: [`1`, 0, `1`, 0, `1`, 0, `1`, 0, ...]
>     vzext.vf2 $V4, $V2
>     # v6: [`0`, 0, `1`, 0, `2`, 0, `3`, 0, ...]
>     vzext.vf2 $V6, $V3
>     slli $T0, $LEN32, 1
>     vsetvli zero, $T0, e32, m2, ta, ma
>     # v8: [1<<0=3D1, 0, 0, 0, 1<<1=3Dx, 0, 0, 0, 1<<2=3Dx^2, 0, 0, 0, =
...]
> -    @{[vwsll_vv $V8, $V4, $V6]}
> +    vwsll.vv $V8, $V4, $V6
>=20
>     # Compute [r-IV0*1, r-IV0*x, r-IV0*x^2, r-IV0*x^3, ...] in v16
>     vsetvli zero, $LEN32, e32, m4, ta, ma
> -    @{[vbrev8_v $V8, $V8]}
> -    @{[vgmul_vv $V16, $V8]}
> +    vbrev8.v $V8, $V8
> +    vgmul.vv $V16, $V8
>=20
>     # Compute [IV0*1, IV0*x, IV0*x^2, IV0*x^3, ...] in v28.
>     # Reverse the bits order back.
> -    @{[vbrev8_v $V28, $V16]}
> +    vbrev8.v $V28, $V16
>=20
>     # Prepare the x^n multiplier in v20. The `n` is the aes-xts block =
number
>     # in a LMUL=3D4 register group.
>     #   n =3D ((VLEN*LMUL)/(32*4)) =3D ((VLEN*4)/(32*4))
>     #     =3D (VLEN/32)
>     # We could use vsetvli with `e32, m1` to compute the `n` number.
>     vsetvli $T0, zero, e32, m1, ta, ma
>     li $T1, 1
>     sll $T0, $T1, $T0
>     vsetivli zero, 2, e64, m1, ta, ma
>     vmv.v.i $V0, 0
>     vsetivli zero, 1, e64, m1, tu, ma
>     vmv.v.x $V0, $T0
>     vsetivli zero, 2, e64, m1, ta, ma
> -    @{[vbrev8_v $V0, $V0]}
> +    vbrev8.v $V0, $V0
>     vsetvli zero, $LEN32, e32, m4, ta, ma
>     vmv.v.i $V20, 0
> -    @{[vaesz_vs $V20, $V0]}
> +    vaesz.vs $V20, $V0
>=20
>     j 2f
> 1:
>     vsetivli zero, 4, e32, m1, ta, ma
> -    @{[vbrev8_v $V16, $V28]}
> +    vbrev8.v $V16, $V28
> 2:
> ___
>=20
>     return $code;
> }
>=20
> # prepare xts enc last block's input(v24) and iv(v28)
> sub handle_xts_enc_last_block {
>     my $code=3D<<___;
>     bnez $TAIL_LENGTH, 2f
> @@ -186,23 +186,23 @@ sub handle_xts_enc_last_block {
>     # setup `x` multiplier with byte-reversed order
>     # 0b00000010 =3D> 0b01000000 (0x40)
>     li $T0, 0x40
>     vsetivli zero, 4, e32, m1, ta, ma
>     vmv.v.i $V28, 0
>     vsetivli zero, 1, e8, m1, tu, ma
>     vmv.v.x $V28, $T0
>=20
>     # IV * `x`
>     vsetivli zero, 4, e32, m1, ta, ma
> -    @{[vgmul_vv $V16, $V28]}
> +    vgmul.vv $V16, $V28
>     # Reverse the IV's bits order back to big-endian
> -    @{[vbrev8_v $V28, $V16]}
> +    vbrev8.v $V28, $V16
>=20
>     vse32.v $V28, ($IV)
> 1:
>=20
>     ret
> 2:
>     # slidedown second to last block
>     addi $VL, $VL, -4
>     vsetivli zero, 4, e32, m4, ta, ma
>     # ciphertext
> @@ -222,22 +222,22 @@ sub handle_xts_enc_last_block {
>     # setup `x` multiplier with byte-reversed order
>     # 0b00000010 =3D> 0b01000000 (0x40)
>     li $T0, 0x40
>     vsetivli zero, 4, e32, m1, ta, ma
>     vmv.v.i $V28, 0
>     vsetivli zero, 1, e8, m1, tu, ma
>     vmv.v.x $V28, $T0
>=20
>     # compute IV for last block
>     vsetivli zero, 4, e32, m1, ta, ma
> -    @{[vgmul_vv $V16, $V28]}
> -    @{[vbrev8_v $V28, $V16]}
> +    vgmul.vv $V16, $V28
> +    vbrev8.v $V28, $V16
>=20
>     # store second to last block
>     vsetvli zero, $TAIL_LENGTH, e8, m1, ta, ma
>     vse8.v $V25, ($OUTPUT)
> ___
>=20
>     return $code;
> }
>=20
> # prepare xts dec second to last block's input(v24) and iv(v29) and
> @@ -258,23 +258,23 @@ sub handle_xts_dec_last_block {
>=20
>     beqz $LENGTH, 3f
>     addi $VL, $VL, -4
>     vsetivli zero, 4, e32, m4, ta, ma
>     # multiplier
>     vslidedown.vx $V16, $V16, $VL
>=20
> 3:
>     # IV * `x`
>     vsetivli zero, 4, e32, m1, ta, ma
> -    @{[vgmul_vv $V16, $V28]}
> +    vgmul.vv $V16, $V28
>     # Reverse the IV's bits order back to big-endian
> -    @{[vbrev8_v $V28, $V16]}
> +    vbrev8.v $V28, $V16
>=20
>     vse32.v $V28, ($IV)
> 1:
>=20
>     ret
> 2:
>     # load second to last block's ciphertext
>     vsetivli zero, 4, e32, m1, ta, ma
>     vle32.v $V24, ($INPUT)
>     addi $INPUT, $INPUT, 16
> @@ -289,32 +289,32 @@ sub handle_xts_dec_last_block {
>=20
>     beqz $LENGTH, 1f
>     # slidedown third to last block
>     addi $VL, $VL, -4
>     vsetivli zero, 4, e32, m4, ta, ma
>     # multiplier
>     vslidedown.vx $V16, $V16, $VL
>=20
>     # compute IV for last block
>     vsetivli zero, 4, e32, m1, ta, ma
> -    @{[vgmul_vv $V16, $V20]}
> -    @{[vbrev8_v $V28, $V16]}
> +    vgmul.vv $V16, $V20
> +    vbrev8.v $V28, $V16
>=20
>     # compute IV for second to last block
> -    @{[vgmul_vv $V16, $V20]}
> -    @{[vbrev8_v $V29, $V16]}
> +    vgmul.vv $V16, $V20
> +    vbrev8.v $V29, $V16
>     j 2f
> 1:
>     # compute IV for second to last block
>     vsetivli zero, 4, e32, m1, ta, ma
> -    @{[vgmul_vv $V16, $V20]}
> -    @{[vbrev8_v $V29, $V16]}
> +    vgmul.vv $V16, $V20
> +    vbrev8.v $V29, $V16
> 2:
> ___
>=20
>     return $code;
> }
>=20
> # Load all 11 round keys to v1-v11 registers.
> sub aes_128_load_key {
>     my $code=3D<<___;
>     vsetivli zero, 4, e32, m1, ta, ma
> @@ -412,138 +412,138 @@ sub aes_256_load_key {
>     addi $KEY, $KEY, 16
>     vle32.v $V15, ($KEY)
> ___
>=20
>     return $code;
> }
>=20
> # aes-128 enc with round keys v1-v11
> sub aes_128_enc {
>     my $code=3D<<___;
> -    @{[vaesz_vs $V24, $V1]}
> -    @{[vaesem_vs $V24, $V2]}
> -    @{[vaesem_vs $V24, $V3]}
> -    @{[vaesem_vs $V24, $V4]}
> -    @{[vaesem_vs $V24, $V5]}
> -    @{[vaesem_vs $V24, $V6]}
> -    @{[vaesem_vs $V24, $V7]}
> -    @{[vaesem_vs $V24, $V8]}
> -    @{[vaesem_vs $V24, $V9]}
> -    @{[vaesem_vs $V24, $V10]}
> -    @{[vaesef_vs $V24, $V11]}
> +    vaesz.vs $V24, $V1
> +    vaesem.vs $V24, $V2
> +    vaesem.vs $V24, $V3
> +    vaesem.vs $V24, $V4
> +    vaesem.vs $V24, $V5
> +    vaesem.vs $V24, $V6
> +    vaesem.vs $V24, $V7
> +    vaesem.vs $V24, $V8
> +    vaesem.vs $V24, $V9
> +    vaesem.vs $V24, $V10
> +    vaesef.vs $V24, $V11
> ___
>=20
>     return $code;
> }
>=20
> # aes-128 dec with round keys v1-v11
> sub aes_128_dec {
>     my $code=3D<<___;
> -    @{[vaesz_vs $V24, $V11]}
> -    @{[vaesdm_vs $V24, $V10]}
> -    @{[vaesdm_vs $V24, $V9]}
> -    @{[vaesdm_vs $V24, $V8]}
> -    @{[vaesdm_vs $V24, $V7]}
> -    @{[vaesdm_vs $V24, $V6]}
> -    @{[vaesdm_vs $V24, $V5]}
> -    @{[vaesdm_vs $V24, $V4]}
> -    @{[vaesdm_vs $V24, $V3]}
> -    @{[vaesdm_vs $V24, $V2]}
> -    @{[vaesdf_vs $V24, $V1]}
> +    vaesz.vs $V24, $V11
> +    vaesdm.vs $V24, $V10
> +    vaesdm.vs $V24, $V9
> +    vaesdm.vs $V24, $V8
> +    vaesdm.vs $V24, $V7
> +    vaesdm.vs $V24, $V6
> +    vaesdm.vs $V24, $V5
> +    vaesdm.vs $V24, $V4
> +    vaesdm.vs $V24, $V3
> +    vaesdm.vs $V24, $V2
> +    vaesdf.vs $V24, $V1
> ___
>=20
>     return $code;
> }
>=20
> # aes-192 enc with round keys v1-v13
> sub aes_192_enc {
>     my $code=3D<<___;
> -    @{[vaesz_vs $V24, $V1]}
> -    @{[vaesem_vs $V24, $V2]}
> -    @{[vaesem_vs $V24, $V3]}
> -    @{[vaesem_vs $V24, $V4]}
> -    @{[vaesem_vs $V24, $V5]}
> -    @{[vaesem_vs $V24, $V6]}
> -    @{[vaesem_vs $V24, $V7]}
> -    @{[vaesem_vs $V24, $V8]}
> -    @{[vaesem_vs $V24, $V9]}
> -    @{[vaesem_vs $V24, $V10]}
> -    @{[vaesem_vs $V24, $V11]}
> -    @{[vaesem_vs $V24, $V12]}
> -    @{[vaesef_vs $V24, $V13]}
> +    vaesz.vs $V24, $V1
> +    vaesem.vs $V24, $V2
> +    vaesem.vs $V24, $V3
> +    vaesem.vs $V24, $V4
> +    vaesem.vs $V24, $V5
> +    vaesem.vs $V24, $V6
> +    vaesem.vs $V24, $V7
> +    vaesem.vs $V24, $V8
> +    vaesem.vs $V24, $V9
> +    vaesem.vs $V24, $V10
> +    vaesem.vs $V24, $V11
> +    vaesem.vs $V24, $V12
> +    vaesef.vs $V24, $V13
> ___
>=20
>     return $code;
> }
>=20
> # aes-192 dec with round keys v1-v13
> sub aes_192_dec {
>     my $code=3D<<___;
> -    @{[vaesz_vs $V24, $V13]}
> -    @{[vaesdm_vs $V24, $V12]}
> -    @{[vaesdm_vs $V24, $V11]}
> -    @{[vaesdm_vs $V24, $V10]}
> -    @{[vaesdm_vs $V24, $V9]}
> -    @{[vaesdm_vs $V24, $V8]}
> -    @{[vaesdm_vs $V24, $V7]}
> -    @{[vaesdm_vs $V24, $V6]}
> -    @{[vaesdm_vs $V24, $V5]}
> -    @{[vaesdm_vs $V24, $V4]}
> -    @{[vaesdm_vs $V24, $V3]}
> -    @{[vaesdm_vs $V24, $V2]}
> -    @{[vaesdf_vs $V24, $V1]}
> +    vaesz.vs $V24, $V13
> +    vaesdm.vs $V24, $V12
> +    vaesdm.vs $V24, $V11
> +    vaesdm.vs $V24, $V10
> +    vaesdm.vs $V24, $V9
> +    vaesdm.vs $V24, $V8
> +    vaesdm.vs $V24, $V7
> +    vaesdm.vs $V24, $V6
> +    vaesdm.vs $V24, $V5
> +    vaesdm.vs $V24, $V4
> +    vaesdm.vs $V24, $V3
> +    vaesdm.vs $V24, $V2
> +    vaesdf.vs $V24, $V1
> ___
>=20
>     return $code;
> }
>=20
> # aes-256 enc with round keys v1-v15
> sub aes_256_enc {
>     my $code=3D<<___;
> -    @{[vaesz_vs $V24, $V1]}
> -    @{[vaesem_vs $V24, $V2]}
> -    @{[vaesem_vs $V24, $V3]}
> -    @{[vaesem_vs $V24, $V4]}
> -    @{[vaesem_vs $V24, $V5]}
> -    @{[vaesem_vs $V24, $V6]}
> -    @{[vaesem_vs $V24, $V7]}
> -    @{[vaesem_vs $V24, $V8]}
> -    @{[vaesem_vs $V24, $V9]}
> -    @{[vaesem_vs $V24, $V10]}
> -    @{[vaesem_vs $V24, $V11]}
> -    @{[vaesem_vs $V24, $V12]}
> -    @{[vaesem_vs $V24, $V13]}
> -    @{[vaesem_vs $V24, $V14]}
> -    @{[vaesef_vs $V24, $V15]}
> +    vaesz.vs $V24, $V1
> +    vaesem.vs $V24, $V2
> +    vaesem.vs $V24, $V3
> +    vaesem.vs $V24, $V4
> +    vaesem.vs $V24, $V5
> +    vaesem.vs $V24, $V6
> +    vaesem.vs $V24, $V7
> +    vaesem.vs $V24, $V8
> +    vaesem.vs $V24, $V9
> +    vaesem.vs $V24, $V10
> +    vaesem.vs $V24, $V11
> +    vaesem.vs $V24, $V12
> +    vaesem.vs $V24, $V13
> +    vaesem.vs $V24, $V14
> +    vaesef.vs $V24, $V15
> ___
>=20
>     return $code;
> }
>=20
> # aes-256 dec with round keys v1-v15
> sub aes_256_dec {
>     my $code=3D<<___;
> -    @{[vaesz_vs $V24, $V15]}
> -    @{[vaesdm_vs $V24, $V14]}
> -    @{[vaesdm_vs $V24, $V13]}
> -    @{[vaesdm_vs $V24, $V12]}
> -    @{[vaesdm_vs $V24, $V11]}
> -    @{[vaesdm_vs $V24, $V10]}
> -    @{[vaesdm_vs $V24, $V9]}
> -    @{[vaesdm_vs $V24, $V8]}
> -    @{[vaesdm_vs $V24, $V7]}
> -    @{[vaesdm_vs $V24, $V6]}
> -    @{[vaesdm_vs $V24, $V5]}
> -    @{[vaesdm_vs $V24, $V4]}
> -    @{[vaesdm_vs $V24, $V3]}
> -    @{[vaesdm_vs $V24, $V2]}
> -    @{[vaesdf_vs $V24, $V1]}
> +    vaesz.vs $V24, $V15
> +    vaesdm.vs $V24, $V14
> +    vaesdm.vs $V24, $V13
> +    vaesdm.vs $V24, $V12
> +    vaesdm.vs $V24, $V11
> +    vaesdm.vs $V24, $V10
> +    vaesdm.vs $V24, $V9
> +    vaesdm.vs $V24, $V8
> +    vaesdm.vs $V24, $V7
> +    vaesdm.vs $V24, $V6
> +    vaesdm.vs $V24, $V5
> +    vaesdm.vs $V24, $V4
> +    vaesdm.vs $V24, $V3
> +    vaesdm.vs $V24, $V2
> +    vaesdf.vs $V24, $V1
> ___
>=20
>     return $code;
> }
>=20
> $code .=3D <<___;
> .p2align 3
> .globl rv64i_zvbb_zvkg_zvkned_aes_xts_encrypt
> .type rv64i_zvbb_zvkg_zvkned_aes_xts_encrypt,\@function
> rv64i_zvbb_zvkg_zvkned_aes_xts_encrypt:
> @@ -578,23 +578,23 @@ aes_xts_enc_128:
>     @{[aes_128_load_key]}
>=20
>     vsetvli $VL, $LEN32, e32, m4, ta, ma
>     j 1f
>=20
> .Lenc_blocks_128:
>     vsetvli $VL, $LEN32, e32, m4, ta, ma
>     # load plaintext into v24
>     vle32.v $V24, ($INPUT)
>     # update iv
> -    @{[vgmul_vv $V16, $V20]}
> +    vgmul.vv $V16, $V20
>     # reverse the iv's bits order back
> -    @{[vbrev8_v $V28, $V16]}
> +    vbrev8.v $V28, $V16
> 1:
>     vxor.vv $V24, $V24, $V28
>     slli $T0, $VL, 2
>     sub $LEN32, $LEN32, $VL
>     add $INPUT, $INPUT, $T0
>     @{[aes_128_enc]}
>     vxor.vv $V24, $V24, $V28
>=20
>     # store ciphertext
>     vsetvli zero, $STORE_LEN32, e32, m4, ta, ma
> @@ -627,23 +627,23 @@ aes_xts_enc_192:
>     @{[aes_192_load_key]}
>=20
>     vsetvli $VL, $LEN32, e32, m4, ta, ma
>     j 1f
>=20
> .Lenc_blocks_192:
>     vsetvli $VL, $LEN32, e32, m4, ta, ma
>     # load plaintext into v24
>     vle32.v $V24, ($INPUT)
>     # update iv
> -    @{[vgmul_vv $V16, $V20]}
> +    vgmul.vv $V16, $V20
>     # reverse the iv's bits order back
> -    @{[vbrev8_v $V28, $V16]}
> +    vbrev8.v $V28, $V16
> 1:
>     vxor.vv $V24, $V24, $V28
>     slli $T0, $VL, 2
>     sub $LEN32, $LEN32, $VL
>     add $INPUT, $INPUT, $T0
>     @{[aes_192_enc]}
>     vxor.vv $V24, $V24, $V28
>=20
>     # store ciphertext
>     vsetvli zero, $STORE_LEN32, e32, m4, ta, ma
> @@ -676,23 +676,23 @@ aes_xts_enc_256:
>     @{[aes_256_load_key]}
>=20
>     vsetvli $VL, $LEN32, e32, m4, ta, ma
>     j 1f
>=20
> .Lenc_blocks_256:
>     vsetvli $VL, $LEN32, e32, m4, ta, ma
>     # load plaintext into v24
>     vle32.v $V24, ($INPUT)
>     # update iv
> -    @{[vgmul_vv $V16, $V20]}
> +    vgmul.vv $V16, $V20
>     # reverse the iv's bits order back
> -    @{[vbrev8_v $V28, $V16]}
> +    vbrev8.v $V28, $V16
> 1:
>     vxor.vv $V24, $V24, $V28
>     slli $T0, $VL, 2
>     sub $LEN32, $LEN32, $VL
>     add $INPUT, $INPUT, $T0
>     @{[aes_256_enc]}
>     vxor.vv $V24, $V24, $V28
>=20
>     # store ciphertext
>     vsetvli zero, $STORE_LEN32, e32, m4, ta, ma
> @@ -760,23 +760,23 @@ aes_xts_dec_128:
>     beqz $LEN32, 2f
>=20
>     vsetvli $VL, $LEN32, e32, m4, ta, ma
>     j 1f
>=20
> .Ldec_blocks_128:
>     vsetvli $VL, $LEN32, e32, m4, ta, ma
>     # load ciphertext into v24
>     vle32.v $V24, ($INPUT)
>     # update iv
> -    @{[vgmul_vv $V16, $V20]}
> +    vgmul.vv $V16, $V20
>     # reverse the iv's bits order back
> -    @{[vbrev8_v $V28, $V16]}
> +    vbrev8.v $V28, $V16
> 1:
>     vxor.vv $V24, $V24, $V28
>     slli $T0, $VL, 2
>     sub $LEN32, $LEN32, $VL
>     add $INPUT, $INPUT, $T0
>     @{[aes_128_dec]}
>     vxor.vv $V24, $V24, $V28
>=20
>     # store plaintext
>     vse32.v $V24, ($OUTPUT)
> @@ -824,23 +824,23 @@ aes_xts_dec_192:
>     beqz $LEN32, 2f
>=20
>     vsetvli $VL, $LEN32, e32, m4, ta, ma
>     j 1f
>=20
> .Ldec_blocks_192:
>     vsetvli $VL, $LEN32, e32, m4, ta, ma
>     # load ciphertext into v24
>     vle32.v $V24, ($INPUT)
>     # update iv
> -    @{[vgmul_vv $V16, $V20]}
> +    vgmul.vv $V16, $V20
>     # reverse the iv's bits order back
> -    @{[vbrev8_v $V28, $V16]}
> +    vbrev8.v $V28, $V16
> 1:
>     vxor.vv $V24, $V24, $V28
>     slli $T0, $VL, 2
>     sub $LEN32, $LEN32, $VL
>     add $INPUT, $INPUT, $T0
>     @{[aes_192_dec]}
>     vxor.vv $V24, $V24, $V28
>=20
>     # store plaintext
>     vse32.v $V24, ($OUTPUT)
> @@ -888,23 +888,23 @@ aes_xts_dec_256:
>     beqz $LEN32, 2f
>=20
>     vsetvli $VL, $LEN32, e32, m4, ta, ma
>     j 1f
>=20
> .Ldec_blocks_256:
>     vsetvli $VL, $LEN32, e32, m4, ta, ma
>     # load ciphertext into v24
>     vle32.v $V24, ($INPUT)
>     # update iv
> -    @{[vgmul_vv $V16, $V20]}
> +    vgmul.vv $V16, $V20
>     # reverse the iv's bits order back
> -    @{[vbrev8_v $V28, $V16]}
> +    vbrev8.v $V28, $V16
> 1:
>     vxor.vv $V24, $V24, $V28
>     slli $T0, $VL, 2
>     sub $LEN32, $LEN32, $VL
>     add $INPUT, $INPUT, $T0
>     @{[aes_256_dec]}
>     vxor.vv $V24, $V24, $V28
>=20
>     # store plaintext
>     vse32.v $V24, ($OUTPUT)
> diff --git a/arch/riscv/crypto/aes-riscv64-zvkned-zvkb.pl =
b/arch/riscv/crypto/aes-riscv64-zvkned-zvkb.pl
> index c3506e5523be..39ce998039a2 100644
> --- a/arch/riscv/crypto/aes-riscv64-zvkned-zvkb.pl
> +++ b/arch/riscv/crypto/aes-riscv64-zvkned-zvkb.pl
> @@ -31,40 +31,40 @@
> # OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, =
INCIDENTAL,
> # SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
> # LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF =
USE,
> # DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON =
ANY
> # THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
> # (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE =
USE
> # OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
>=20
> # - RV64I
> # - RISC-V Vector ('V') with VLEN >=3D 128
> -# - RISC-V Vector Cryptography Bit-manipulation extension ('Zvkb')
> # - RISC-V Vector AES block cipher extension ('Zvkned')
> +# - RISC-V Vector Cryptography Bit-manipulation extension ('Zvkb')
>=20
> use strict;
> use warnings;
>=20
> use FindBin qw($Bin);
> use lib "$Bin";
> use lib "$Bin/../../perlasm";
> -use riscv;
>=20
> # $output is the last argument if it looks like a file (it has an =
extension)
> # $flavour is the first argument if it doesn't look like a file
> my $output =3D $#ARGV >=3D 0 && $ARGV[$#ARGV] =3D~ m|\.\w+$| ? pop : =
undef;
> my $flavour =3D $#ARGV >=3D 0 && $ARGV[0] !~ m|\.| ? shift : undef;
>=20
> $output and open STDOUT,">$output";
>=20
> my $code=3D<<___;
> .text
> +.option arch, +zvkned, +zvkb
> ___
>=20
> =
##########################################################################=
######
> # void rv64i_zvkb_zvkned_ctr32_encrypt_blocks(const unsigned char *in,
> #                                             unsigned char *out, =
size_t length,
> #                                             const void *key,
> #                                             unsigned char ivec[16]);
> {
> my ($INP, $OUTP, $LEN, $KEYP, $IVP) =3D ("a0", "a1", "a2", "a3", =
"a4");
> my ($T0, $T1, $T2, $T3) =3D ("t0", "t1", "t2", "t3");
> @@ -89,25 +89,25 @@ sub init_aes_ctr_input {
>     #   the VLMAX.
>     li $T0, 0b10001000
>     vsetvli $T2, zero, e8, m1, ta, ma
>     vmv.v.x $MASK, $T0
>     # Load IV.
>     # v31:[IV0, IV1, IV2, big-endian count]
>     vsetivli zero, 4, e32, m1, ta, ma
>     vle32.v $V31, ($IVP)
>     # Convert the big-endian counter into little-endian.
>     vsetivli zero, 4, e32, m1, ta, mu
> -    @{[vrev8_v $V31, $V31, $MASK]}
> +    vrev8.v $V31, $V31, $MASK.t
>     # Splat the IV to v16
>     vsetvli zero, $LEN32, e32, m4, ta, ma
>     vmv.v.i $V16, 0
> -    @{[vaesz_vs $V16, $V31]}
> +    vaesz.vs $V16, $V31
>     # Prepare the ctr pattern into v20
>     # v20: [x, x, x, 0, x, x, x, 1, x, x, x, 2, ...]
>     viota.m $V20, $MASK, $MASK.t
>     # v16:[IV0, IV1, IV2, count+0, IV0, IV1, IV2, count+1, ...]
>     vsetvli $VL, $LEN32, e32, m4, ta, mu
>     vadd.vv $V16, $V16, $V20, $MASK.t
> ___
>=20
>     return $code;
> }
> @@ -171,59 +171,59 @@ ctr32_encrypt_blocks_128:
>     ##### AES body
>     j 2f
> 1:
>     vsetvli $VL, $LEN32, e32, m4, ta, mu
>     # Increase ctr in v16.
>     vadd.vx $V16, $V16, $CTR, $MASK.t
> 2:
>     # Prepare the AES ctr input into v24.
>     # The ctr data uses big-endian form.
>     vmv.v.v $V24, $V16
> -    @{[vrev8_v $V24, $V24, $MASK]}
> +    vrev8.v $V24, $V24, $MASK.t
>     srli $CTR, $VL, 2
>     sub $LEN32, $LEN32, $VL
>=20
>     # Load plaintext in bytes into v20.
>     vsetvli $T0, $LEN, e8, m4, ta, ma
>     vle8.v $V20, ($INP)
>     sub $LEN, $LEN, $T0
>     add $INP, $INP, $T0
>=20
>     vsetvli zero, $VL, e32, m4, ta, ma
> -    @{[vaesz_vs $V24, $V1]}
> -    @{[vaesem_vs $V24, $V2]}
> -    @{[vaesem_vs $V24, $V3]}
> -    @{[vaesem_vs $V24, $V4]}
> -    @{[vaesem_vs $V24, $V5]}
> -    @{[vaesem_vs $V24, $V6]}
> -    @{[vaesem_vs $V24, $V7]}
> -    @{[vaesem_vs $V24, $V8]}
> -    @{[vaesem_vs $V24, $V9]}
> -    @{[vaesem_vs $V24, $V10]}
> -    @{[vaesef_vs $V24, $V11]}
> +    vaesz.vs $V24, $V1
> +    vaesem.vs $V24, $V2
> +    vaesem.vs $V24, $V3
> +    vaesem.vs $V24, $V4
> +    vaesem.vs $V24, $V5
> +    vaesem.vs $V24, $V6
> +    vaesem.vs $V24, $V7
> +    vaesem.vs $V24, $V8
> +    vaesem.vs $V24, $V9
> +    vaesem.vs $V24, $V10
> +    vaesef.vs $V24, $V11
>=20
>     # ciphertext
>     vsetvli zero, $T0, e8, m4, ta, ma
>     vxor.vv $V24, $V24, $V20
>=20
>     # Store the ciphertext.
>     vse8.v $V24, ($OUTP)
>     add $OUTP, $OUTP, $T0
>=20
>     bnez $LEN, 1b
>=20
>     ## store ctr iv
>     vsetivli zero, 4, e32, m1, ta, mu
>     # Increase ctr in v16.
>     vadd.vx $V16, $V16, $CTR, $MASK.t
>     # Convert ctr data back to big-endian.
> -    @{[vrev8_v $V16, $V16, $MASK]}
> +    vrev8.v $V16, $V16, $MASK.t
>     vse32.v $V16, ($IVP)
>=20
>     ret
> .size ctr32_encrypt_blocks_128,.-ctr32_encrypt_blocks_128
> ___
>=20
> $code .=3D <<___;
> .p2align 3
> ctr32_encrypt_blocks_192:
>     # Load all 13 round keys to v1-v13 registers.
> @@ -259,61 +259,61 @@ ctr32_encrypt_blocks_192:
>     ##### AES body
>     j 2f
> 1:
>     vsetvli $VL, $LEN32, e32, m4, ta, mu
>     # Increase ctr in v16.
>     vadd.vx $V16, $V16, $CTR, $MASK.t
> 2:
>     # Prepare the AES ctr input into v24.
>     # The ctr data uses big-endian form.
>     vmv.v.v $V24, $V16
> -    @{[vrev8_v $V24, $V24, $MASK]}
> +    vrev8.v $V24, $V24, $MASK.t
>     srli $CTR, $VL, 2
>     sub $LEN32, $LEN32, $VL
>=20
>     # Load plaintext in bytes into v20.
>     vsetvli $T0, $LEN, e8, m4, ta, ma
>     vle8.v $V20, ($INP)
>     sub $LEN, $LEN, $T0
>     add $INP, $INP, $T0
>=20
>     vsetvli zero, $VL, e32, m4, ta, ma
> -    @{[vaesz_vs $V24, $V1]}
> -    @{[vaesem_vs $V24, $V2]}
> -    @{[vaesem_vs $V24, $V3]}
> -    @{[vaesem_vs $V24, $V4]}
> -    @{[vaesem_vs $V24, $V5]}
> -    @{[vaesem_vs $V24, $V6]}
> -    @{[vaesem_vs $V24, $V7]}
> -    @{[vaesem_vs $V24, $V8]}
> -    @{[vaesem_vs $V24, $V9]}
> -    @{[vaesem_vs $V24, $V10]}
> -    @{[vaesem_vs $V24, $V11]}
> -    @{[vaesem_vs $V24, $V12]}
> -    @{[vaesef_vs $V24, $V13]}
> +    vaesz.vs $V24, $V1
> +    vaesem.vs $V24, $V2
> +    vaesem.vs $V24, $V3
> +    vaesem.vs $V24, $V4
> +    vaesem.vs $V24, $V5
> +    vaesem.vs $V24, $V6
> +    vaesem.vs $V24, $V7
> +    vaesem.vs $V24, $V8
> +    vaesem.vs $V24, $V9
> +    vaesem.vs $V24, $V10
> +    vaesem.vs $V24, $V11
> +    vaesem.vs $V24, $V12
> +    vaesef.vs $V24, $V13
>=20
>     # ciphertext
>     vsetvli zero, $T0, e8, m4, ta, ma
>     vxor.vv $V24, $V24, $V20
>=20
>     # Store the ciphertext.
>     vse8.v $V24, ($OUTP)
>     add $OUTP, $OUTP, $T0
>=20
>     bnez $LEN, 1b
>=20
>     ## store ctr iv
>     vsetivli zero, 4, e32, m1, ta, mu
>     # Increase ctr in v16.
>     vadd.vx $V16, $V16, $CTR, $MASK.t
>     # Convert ctr data back to big-endian.
> -    @{[vrev8_v $V16, $V16, $MASK]}
> +    vrev8.v $V16, $V16, $MASK.t
>     vse32.v $V16, ($IVP)
>=20
>     ret
> .size ctr32_encrypt_blocks_192,.-ctr32_encrypt_blocks_192
> ___
>=20
> $code .=3D <<___;
> .p2align 3
> ctr32_encrypt_blocks_256:
>     # Load all 15 round keys to v1-v15 registers.
> @@ -353,63 +353,63 @@ ctr32_encrypt_blocks_256:
>     ##### AES body
>     j 2f
> 1:
>     vsetvli $VL, $LEN32, e32, m4, ta, mu
>     # Increase ctr in v16.
>     vadd.vx $V16, $V16, $CTR, $MASK.t
> 2:
>     # Prepare the AES ctr input into v24.
>     # The ctr data uses big-endian form.
>     vmv.v.v $V24, $V16
> -    @{[vrev8_v $V24, $V24, $MASK]}
> +    vrev8.v $V24, $V24, $MASK.t
>     srli $CTR, $VL, 2
>     sub $LEN32, $LEN32, $VL
>=20
>     # Load plaintext in bytes into v20.
>     vsetvli $T0, $LEN, e8, m4, ta, ma
>     vle8.v $V20, ($INP)
>     sub $LEN, $LEN, $T0
>     add $INP, $INP, $T0
>=20
>     vsetvli zero, $VL, e32, m4, ta, ma
> -    @{[vaesz_vs $V24, $V1]}
> -    @{[vaesem_vs $V24, $V2]}
> -    @{[vaesem_vs $V24, $V3]}
> -    @{[vaesem_vs $V24, $V4]}
> -    @{[vaesem_vs $V24, $V5]}
> -    @{[vaesem_vs $V24, $V6]}
> -    @{[vaesem_vs $V24, $V7]}
> -    @{[vaesem_vs $V24, $V8]}
> -    @{[vaesem_vs $V24, $V9]}
> -    @{[vaesem_vs $V24, $V10]}
> -    @{[vaesem_vs $V24, $V11]}
> -    @{[vaesem_vs $V24, $V12]}
> -    @{[vaesem_vs $V24, $V13]}
> -    @{[vaesem_vs $V24, $V14]}
> -    @{[vaesef_vs $V24, $V15]}
> +    vaesz.vs $V24, $V1
> +    vaesem.vs $V24, $V2
> +    vaesem.vs $V24, $V3
> +    vaesem.vs $V24, $V4
> +    vaesem.vs $V24, $V5
> +    vaesem.vs $V24, $V6
> +    vaesem.vs $V24, $V7
> +    vaesem.vs $V24, $V8
> +    vaesem.vs $V24, $V9
> +    vaesem.vs $V24, $V10
> +    vaesem.vs $V24, $V11
> +    vaesem.vs $V24, $V12
> +    vaesem.vs $V24, $V13
> +    vaesem.vs $V24, $V14
> +    vaesef.vs $V24, $V15
>=20
>     # ciphertext
>     vsetvli zero, $T0, e8, m4, ta, ma
>     vxor.vv $V24, $V24, $V20
>=20
>     # Store the ciphertext.
>     vse8.v $V24, ($OUTP)
>     add $OUTP, $OUTP, $T0
>=20
>     bnez $LEN, 1b
>=20
>     ## store ctr iv
>     vsetivli zero, 4, e32, m1, ta, mu
>     # Increase ctr in v16.
>     vadd.vx $V16, $V16, $CTR, $MASK.t
>     # Convert ctr data back to big-endian.
> -    @{[vrev8_v $V16, $V16, $MASK]}
> +    vrev8.v $V16, $V16, $MASK.t
>     vse32.v $V16, ($IVP)
>=20
>     ret
> .size ctr32_encrypt_blocks_256,.-ctr32_encrypt_blocks_256
> ___
> }
>=20
> print $code;
>=20
> close STDOUT or die "error closing STDOUT: $!";
> diff --git a/arch/riscv/crypto/aes-riscv64-zvkned.pl =
b/arch/riscv/crypto/aes-riscv64-zvkned.pl
> index 1ac84fb660ba..383d5fee4ff2 100644
> --- a/arch/riscv/crypto/aes-riscv64-zvkned.pl
> +++ b/arch/riscv/crypto/aes-riscv64-zvkned.pl
> @@ -41,31 +41,31 @@
> # - RV64I
> # - RISC-V Vector ('V') with VLEN >=3D 128
> # - RISC-V Vector AES block cipher extension ('Zvkned')
>=20
> use strict;
> use warnings;
>=20
> use FindBin qw($Bin);
> use lib "$Bin";
> use lib "$Bin/../../perlasm";
> -use riscv;
>=20
> # $output is the last argument if it looks like a file (it has an =
extension)
> # $flavour is the first argument if it doesn't look like a file
> my $output =3D $#ARGV >=3D 0 && $ARGV[$#ARGV] =3D~ m|\.\w+$| ? pop : =
undef;
> my $flavour =3D $#ARGV >=3D 0 && $ARGV[0] !~ m|\.| ? shift : undef;
>=20
> $output and open STDOUT,">$output";
>=20
> my $code=3D<<___;
> .text
> +.option arch, +zvkned
> ___
>=20
> my ($V0, $V1, $V2, $V3, $V4, $V5, $V6, $V7,
>     $V8, $V9, $V10, $V11, $V12, $V13, $V14, $V15,
>     $V16, $V17, $V18, $V19, $V20, $V21, $V22, $V23,
>     $V24, $V25, $V26, $V27, $V28, $V29, $V30, $V31,
> ) =3D map("v$_",(0..31));
>=20
> # Load all 11 round keys to v1-v11 registers.
> sub aes_128_load_key {
> @@ -171,138 +171,138 @@ sub aes_256_load_key {
>     addi $KEYP, $KEYP, 16
>     vle32.v $V15, ($KEYP)
> ___
>=20
>     return $code;
> }
>=20
> # aes-128 encryption with round keys v1-v11
> sub aes_128_encrypt {
>     my $code=3D<<___;
> -    @{[vaesz_vs $V24, $V1]}     # with round key w[ 0, 3]
> -    @{[vaesem_vs $V24, $V2]}    # with round key w[ 4, 7]
> -    @{[vaesem_vs $V24, $V3]}    # with round key w[ 8,11]
> -    @{[vaesem_vs $V24, $V4]}    # with round key w[12,15]
> -    @{[vaesem_vs $V24, $V5]}    # with round key w[16,19]
> -    @{[vaesem_vs $V24, $V6]}    # with round key w[20,23]
> -    @{[vaesem_vs $V24, $V7]}    # with round key w[24,27]
> -    @{[vaesem_vs $V24, $V8]}    # with round key w[28,31]
> -    @{[vaesem_vs $V24, $V9]}    # with round key w[32,35]
> -    @{[vaesem_vs $V24, $V10]}   # with round key w[36,39]
> -    @{[vaesef_vs $V24, $V11]}   # with round key w[40,43]
> +    vaesz.vs $V24, $V1     # with round key w[ 0, 3]
> +    vaesem.vs $V24, $V2    # with round key w[ 4, 7]
> +    vaesem.vs $V24, $V3    # with round key w[ 8,11]
> +    vaesem.vs $V24, $V4    # with round key w[12,15]
> +    vaesem.vs $V24, $V5    # with round key w[16,19]
> +    vaesem.vs $V24, $V6    # with round key w[20,23]
> +    vaesem.vs $V24, $V7    # with round key w[24,27]
> +    vaesem.vs $V24, $V8    # with round key w[28,31]
> +    vaesem.vs $V24, $V9    # with round key w[32,35]
> +    vaesem.vs $V24, $V10   # with round key w[36,39]
> +    vaesef.vs $V24, $V11   # with round key w[40,43]
> ___
>=20
>     return $code;
> }
>=20
> # aes-128 decryption with round keys v1-v11
> sub aes_128_decrypt {
>     my $code=3D<<___;
> -    @{[vaesz_vs $V24, $V11]}   # with round key w[40,43]
> -    @{[vaesdm_vs $V24, $V10]}  # with round key w[36,39]
> -    @{[vaesdm_vs $V24, $V9]}   # with round key w[32,35]
> -    @{[vaesdm_vs $V24, $V8]}   # with round key w[28,31]
> -    @{[vaesdm_vs $V24, $V7]}   # with round key w[24,27]
> -    @{[vaesdm_vs $V24, $V6]}   # with round key w[20,23]
> -    @{[vaesdm_vs $V24, $V5]}   # with round key w[16,19]
> -    @{[vaesdm_vs $V24, $V4]}   # with round key w[12,15]
> -    @{[vaesdm_vs $V24, $V3]}   # with round key w[ 8,11]
> -    @{[vaesdm_vs $V24, $V2]}   # with round key w[ 4, 7]
> -    @{[vaesdf_vs $V24, $V1]}   # with round key w[ 0, 3]
> +    vaesz.vs $V24, $V11   # with round key w[40,43]
> +    vaesdm.vs $V24, $V10  # with round key w[36,39]
> +    vaesdm.vs $V24, $V9   # with round key w[32,35]
> +    vaesdm.vs $V24, $V8   # with round key w[28,31]
> +    vaesdm.vs $V24, $V7   # with round key w[24,27]
> +    vaesdm.vs $V24, $V6   # with round key w[20,23]
> +    vaesdm.vs $V24, $V5   # with round key w[16,19]
> +    vaesdm.vs $V24, $V4   # with round key w[12,15]
> +    vaesdm.vs $V24, $V3   # with round key w[ 8,11]
> +    vaesdm.vs $V24, $V2   # with round key w[ 4, 7]
> +    vaesdf.vs $V24, $V1   # with round key w[ 0, 3]
> ___
>=20
>     return $code;
> }
>=20
> # aes-192 encryption with round keys v1-v13
> sub aes_192_encrypt {
>     my $code=3D<<___;
> -    @{[vaesz_vs $V24, $V1]}     # with round key w[ 0, 3]
> -    @{[vaesem_vs $V24, $V2]}    # with round key w[ 4, 7]
> -    @{[vaesem_vs $V24, $V3]}    # with round key w[ 8,11]
> -    @{[vaesem_vs $V24, $V4]}    # with round key w[12,15]
> -    @{[vaesem_vs $V24, $V5]}    # with round key w[16,19]
> -    @{[vaesem_vs $V24, $V6]}    # with round key w[20,23]
> -    @{[vaesem_vs $V24, $V7]}    # with round key w[24,27]
> -    @{[vaesem_vs $V24, $V8]}    # with round key w[28,31]
> -    @{[vaesem_vs $V24, $V9]}    # with round key w[32,35]
> -    @{[vaesem_vs $V24, $V10]}   # with round key w[36,39]
> -    @{[vaesem_vs $V24, $V11]}   # with round key w[40,43]
> -    @{[vaesem_vs $V24, $V12]}   # with round key w[44,47]
> -    @{[vaesef_vs $V24, $V13]}   # with round key w[48,51]
> +    vaesz.vs $V24, $V1     # with round key w[ 0, 3]
> +    vaesem.vs $V24, $V2    # with round key w[ 4, 7]
> +    vaesem.vs $V24, $V3    # with round key w[ 8,11]
> +    vaesem.vs $V24, $V4    # with round key w[12,15]
> +    vaesem.vs $V24, $V5    # with round key w[16,19]
> +    vaesem.vs $V24, $V6    # with round key w[20,23]
> +    vaesem.vs $V24, $V7    # with round key w[24,27]
> +    vaesem.vs $V24, $V8    # with round key w[28,31]
> +    vaesem.vs $V24, $V9    # with round key w[32,35]
> +    vaesem.vs $V24, $V10   # with round key w[36,39]
> +    vaesem.vs $V24, $V11   # with round key w[40,43]
> +    vaesem.vs $V24, $V12   # with round key w[44,47]
> +    vaesef.vs $V24, $V13   # with round key w[48,51]
> ___
>=20
>     return $code;
> }
>=20
> # aes-192 decryption with round keys v1-v13
> sub aes_192_decrypt {
>     my $code=3D<<___;
> -    @{[vaesz_vs $V24, $V13]}    # with round key w[48,51]
> -    @{[vaesdm_vs $V24, $V12]}   # with round key w[44,47]
> -    @{[vaesdm_vs $V24, $V11]}   # with round key w[40,43]
> -    @{[vaesdm_vs $V24, $V10]}   # with round key w[36,39]
> -    @{[vaesdm_vs $V24, $V9]}    # with round key w[32,35]
> -    @{[vaesdm_vs $V24, $V8]}    # with round key w[28,31]
> -    @{[vaesdm_vs $V24, $V7]}    # with round key w[24,27]
> -    @{[vaesdm_vs $V24, $V6]}    # with round key w[20,23]
> -    @{[vaesdm_vs $V24, $V5]}    # with round key w[16,19]
> -    @{[vaesdm_vs $V24, $V4]}    # with round key w[12,15]
> -    @{[vaesdm_vs $V24, $V3]}    # with round key w[ 8,11]
> -    @{[vaesdm_vs $V24, $V2]}    # with round key w[ 4, 7]
> -    @{[vaesdf_vs $V24, $V1]}    # with round key w[ 0, 3]
> +    vaesz.vs $V24, $V13    # with round key w[48,51]
> +    vaesdm.vs $V24, $V12   # with round key w[44,47]
> +    vaesdm.vs $V24, $V11   # with round key w[40,43]
> +    vaesdm.vs $V24, $V10   # with round key w[36,39]
> +    vaesdm.vs $V24, $V9    # with round key w[32,35]
> +    vaesdm.vs $V24, $V8    # with round key w[28,31]
> +    vaesdm.vs $V24, $V7    # with round key w[24,27]
> +    vaesdm.vs $V24, $V6    # with round key w[20,23]
> +    vaesdm.vs $V24, $V5    # with round key w[16,19]
> +    vaesdm.vs $V24, $V4    # with round key w[12,15]
> +    vaesdm.vs $V24, $V3    # with round key w[ 8,11]
> +    vaesdm.vs $V24, $V2    # with round key w[ 4, 7]
> +    vaesdf.vs $V24, $V1    # with round key w[ 0, 3]
> ___
>=20
>     return $code;
> }
>=20
> # aes-256 encryption with round keys v1-v15
> sub aes_256_encrypt {
>     my $code=3D<<___;
> -    @{[vaesz_vs $V24, $V1]}     # with round key w[ 0, 3]
> -    @{[vaesem_vs $V24, $V2]}    # with round key w[ 4, 7]
> -    @{[vaesem_vs $V24, $V3]}    # with round key w[ 8,11]
> -    @{[vaesem_vs $V24, $V4]}    # with round key w[12,15]
> -    @{[vaesem_vs $V24, $V5]}    # with round key w[16,19]
> -    @{[vaesem_vs $V24, $V6]}    # with round key w[20,23]
> -    @{[vaesem_vs $V24, $V7]}    # with round key w[24,27]
> -    @{[vaesem_vs $V24, $V8]}    # with round key w[28,31]
> -    @{[vaesem_vs $V24, $V9]}    # with round key w[32,35]
> -    @{[vaesem_vs $V24, $V10]}   # with round key w[36,39]
> -    @{[vaesem_vs $V24, $V11]}   # with round key w[40,43]
> -    @{[vaesem_vs $V24, $V12]}   # with round key w[44,47]
> -    @{[vaesem_vs $V24, $V13]}   # with round key w[48,51]
> -    @{[vaesem_vs $V24, $V14]}   # with round key w[52,55]
> -    @{[vaesef_vs $V24, $V15]}   # with round key w[56,59]
> +    vaesz.vs $V24, $V1     # with round key w[ 0, 3]
> +    vaesem.vs $V24, $V2    # with round key w[ 4, 7]
> +    vaesem.vs $V24, $V3    # with round key w[ 8,11]
> +    vaesem.vs $V24, $V4    # with round key w[12,15]
> +    vaesem.vs $V24, $V5    # with round key w[16,19]
> +    vaesem.vs $V24, $V6    # with round key w[20,23]
> +    vaesem.vs $V24, $V7    # with round key w[24,27]
> +    vaesem.vs $V24, $V8    # with round key w[28,31]
> +    vaesem.vs $V24, $V9    # with round key w[32,35]
> +    vaesem.vs $V24, $V10   # with round key w[36,39]
> +    vaesem.vs $V24, $V11   # with round key w[40,43]
> +    vaesem.vs $V24, $V12   # with round key w[44,47]
> +    vaesem.vs $V24, $V13   # with round key w[48,51]
> +    vaesem.vs $V24, $V14   # with round key w[52,55]
> +    vaesef.vs $V24, $V15   # with round key w[56,59]
> ___
>=20
>     return $code;
> }
>=20
> # aes-256 decryption with round keys v1-v15
> sub aes_256_decrypt {
>     my $code=3D<<___;
> -    @{[vaesz_vs $V24, $V15]}    # with round key w[56,59]
> -    @{[vaesdm_vs $V24, $V14]}   # with round key w[52,55]
> -    @{[vaesdm_vs $V24, $V13]}   # with round key w[48,51]
> -    @{[vaesdm_vs $V24, $V12]}   # with round key w[44,47]
> -    @{[vaesdm_vs $V24, $V11]}   # with round key w[40,43]
> -    @{[vaesdm_vs $V24, $V10]}   # with round key w[36,39]
> -    @{[vaesdm_vs $V24, $V9]}    # with round key w[32,35]
> -    @{[vaesdm_vs $V24, $V8]}    # with round key w[28,31]
> -    @{[vaesdm_vs $V24, $V7]}    # with round key w[24,27]
> -    @{[vaesdm_vs $V24, $V6]}    # with round key w[20,23]
> -    @{[vaesdm_vs $V24, $V5]}    # with round key w[16,19]
> -    @{[vaesdm_vs $V24, $V4]}    # with round key w[12,15]
> -    @{[vaesdm_vs $V24, $V3]}    # with round key w[ 8,11]
> -    @{[vaesdm_vs $V24, $V2]}    # with round key w[ 4, 7]
> -    @{[vaesdf_vs $V24, $V1]}    # with round key w[ 0, 3]
> +    vaesz.vs $V24, $V15    # with round key w[56,59]
> +    vaesdm.vs $V24, $V14   # with round key w[52,55]
> +    vaesdm.vs $V24, $V13   # with round key w[48,51]
> +    vaesdm.vs $V24, $V12   # with round key w[44,47]
> +    vaesdm.vs $V24, $V11   # with round key w[40,43]
> +    vaesdm.vs $V24, $V10   # with round key w[36,39]
> +    vaesdm.vs $V24, $V9    # with round key w[32,35]
> +    vaesdm.vs $V24, $V8    # with round key w[28,31]
> +    vaesdm.vs $V24, $V7    # with round key w[24,27]
> +    vaesdm.vs $V24, $V6    # with round key w[20,23]
> +    vaesdm.vs $V24, $V5    # with round key w[16,19]
> +    vaesdm.vs $V24, $V4    # with round key w[12,15]
> +    vaesdm.vs $V24, $V3    # with round key w[ 8,11]
> +    vaesdm.vs $V24, $V2    # with round key w[ 4, 7]
> +    vaesdf.vs $V24, $V1    # with round key w[ 0, 3]
> ___
>=20
>     return $code;
> }
>=20
> {
> =
##########################################################################=
#####
> # void rv64i_zvkned_cbc_encrypt(const unsigned char *in, unsigned char =
*out,
> #                               size_t length, const AES_KEY *key,
> #                               unsigned char *ivec, const int enc);
> @@ -842,160 +842,160 @@ rv64i_zvkned_encrypt:
> ___
>=20
> $code .=3D <<___;
> .p2align 3
> L_enc_128:
>     vsetivli zero, 4, e32, m1, ta, ma
>=20
>     vle32.v $V1, ($INP)
>=20
>     vle32.v $V10, ($KEYP)
> -    @{[vaesz_vs $V1, $V10]}    # with round key w[ 0, 3]
> +    vaesz.vs $V1, $V10    # with round key w[ 0, 3]
>     addi $KEYP, $KEYP, 16
>     vle32.v $V11, ($KEYP)
> -    @{[vaesem_vs $V1, $V11]}   # with round key w[ 4, 7]
> +    vaesem.vs $V1, $V11   # with round key w[ 4, 7]
>     addi $KEYP, $KEYP, 16
>     vle32.v $V12, ($KEYP)
> -    @{[vaesem_vs $V1, $V12]}   # with round key w[ 8,11]
> +    vaesem.vs $V1, $V12   # with round key w[ 8,11]
>     addi $KEYP, $KEYP, 16
>     vle32.v $V13, ($KEYP)
> -    @{[vaesem_vs $V1, $V13]}   # with round key w[12,15]
> +    vaesem.vs $V1, $V13   # with round key w[12,15]
>     addi $KEYP, $KEYP, 16
>     vle32.v $V14, ($KEYP)
> -    @{[vaesem_vs $V1, $V14]}   # with round key w[16,19]
> +    vaesem.vs $V1, $V14   # with round key w[16,19]
>     addi $KEYP, $KEYP, 16
>     vle32.v $V15, ($KEYP)
> -    @{[vaesem_vs $V1, $V15]}   # with round key w[20,23]
> +    vaesem.vs $V1, $V15   # with round key w[20,23]
>     addi $KEYP, $KEYP, 16
>     vle32.v $V16, ($KEYP)
> -    @{[vaesem_vs $V1, $V16]}   # with round key w[24,27]
> +    vaesem.vs $V1, $V16   # with round key w[24,27]
>     addi $KEYP, $KEYP, 16
>     vle32.v $V17, ($KEYP)
> -    @{[vaesem_vs $V1, $V17]}   # with round key w[28,31]
> +    vaesem.vs $V1, $V17   # with round key w[28,31]
>     addi $KEYP, $KEYP, 16
>     vle32.v $V18, ($KEYP)
> -    @{[vaesem_vs $V1, $V18]}   # with round key w[32,35]
> +    vaesem.vs $V1, $V18   # with round key w[32,35]
>     addi $KEYP, $KEYP, 16
>     vle32.v $V19, ($KEYP)
> -    @{[vaesem_vs $V1, $V19]}   # with round key w[36,39]
> +    vaesem.vs $V1, $V19   # with round key w[36,39]
>     addi $KEYP, $KEYP, 16
>     vle32.v $V20, ($KEYP)
> -    @{[vaesef_vs $V1, $V20]}   # with round key w[40,43]
> +    vaesef.vs $V1, $V20   # with round key w[40,43]
>=20
>     vse32.v $V1, ($OUTP)
>=20
>     ret
> .size L_enc_128,.-L_enc_128
> ___
>=20
> $code .=3D <<___;
> .p2align 3
> L_enc_192:
>     vsetivli zero, 4, e32, m1, ta, ma
>=20
>     vle32.v $V1, ($INP)
>=20
>     vle32.v $V10, ($KEYP)
> -    @{[vaesz_vs $V1, $V10]}
> +    vaesz.vs $V1, $V10
>     addi $KEYP, $KEYP, 16
>     vle32.v $V11, ($KEYP)
> -    @{[vaesem_vs $V1, $V11]}
> +    vaesem.vs $V1, $V11
>     addi $KEYP, $KEYP, 16
>     vle32.v $V12, ($KEYP)
> -    @{[vaesem_vs $V1, $V12]}
> +    vaesem.vs $V1, $V12
>     addi $KEYP, $KEYP, 16
>     vle32.v $V13, ($KEYP)
> -    @{[vaesem_vs $V1, $V13]}
> +    vaesem.vs $V1, $V13
>     addi $KEYP, $KEYP, 16
>     vle32.v $V14, ($KEYP)
> -    @{[vaesem_vs $V1, $V14]}
> +    vaesem.vs $V1, $V14
>     addi $KEYP, $KEYP, 16
>     vle32.v $V15, ($KEYP)
> -    @{[vaesem_vs $V1, $V15]}
> +    vaesem.vs $V1, $V15
>     addi $KEYP, $KEYP, 16
>     vle32.v $V16, ($KEYP)
> -    @{[vaesem_vs $V1, $V16]}
> +    vaesem.vs $V1, $V16
>     addi $KEYP, $KEYP, 16
>     vle32.v $V17, ($KEYP)
> -    @{[vaesem_vs $V1, $V17]}
> +    vaesem.vs $V1, $V17
>     addi $KEYP, $KEYP, 16
>     vle32.v $V18, ($KEYP)
> -    @{[vaesem_vs $V1, $V18]}
> +    vaesem.vs $V1, $V18
>     addi $KEYP, $KEYP, 16
>     vle32.v $V19, ($KEYP)
> -    @{[vaesem_vs $V1, $V19]}
> +    vaesem.vs $V1, $V19
>     addi $KEYP, $KEYP, 16
>     vle32.v $V20, ($KEYP)
> -    @{[vaesem_vs $V1, $V20]}
> +    vaesem.vs $V1, $V20
>     addi $KEYP, $KEYP, 16
>     vle32.v $V21, ($KEYP)
> -    @{[vaesem_vs $V1, $V21]}
> +    vaesem.vs $V1, $V21
>     addi $KEYP, $KEYP, 16
>     vle32.v $V22, ($KEYP)
> -    @{[vaesef_vs $V1, $V22]}
> +    vaesef.vs $V1, $V22
>=20
>     vse32.v $V1, ($OUTP)
>     ret
> .size L_enc_192,.-L_enc_192
> ___
>=20
> $code .=3D <<___;
> .p2align 3
> L_enc_256:
>     vsetivli zero, 4, e32, m1, ta, ma
>=20
>     vle32.v $V1, ($INP)
>=20
>     vle32.v $V10, ($KEYP)
> -    @{[vaesz_vs $V1, $V10]}
> +    vaesz.vs $V1, $V10
>     addi $KEYP, $KEYP, 16
>     vle32.v $V11, ($KEYP)
> -    @{[vaesem_vs $V1, $V11]}
> +    vaesem.vs $V1, $V11
>     addi $KEYP, $KEYP, 16
>     vle32.v $V12, ($KEYP)
> -    @{[vaesem_vs $V1, $V12]}
> +    vaesem.vs $V1, $V12
>     addi $KEYP, $KEYP, 16
>     vle32.v $V13, ($KEYP)
> -    @{[vaesem_vs $V1, $V13]}
> +    vaesem.vs $V1, $V13
>     addi $KEYP, $KEYP, 16
>     vle32.v $V14, ($KEYP)
> -    @{[vaesem_vs $V1, $V14]}
> +    vaesem.vs $V1, $V14
>     addi $KEYP, $KEYP, 16
>     vle32.v $V15, ($KEYP)
> -    @{[vaesem_vs $V1, $V15]}
> +    vaesem.vs $V1, $V15
>     addi $KEYP, $KEYP, 16
>     vle32.v $V16, ($KEYP)
> -    @{[vaesem_vs $V1, $V16]}
> +    vaesem.vs $V1, $V16
>     addi $KEYP, $KEYP, 16
>     vle32.v $V17, ($KEYP)
> -    @{[vaesem_vs $V1, $V17]}
> +    vaesem.vs $V1, $V17
>     addi $KEYP, $KEYP, 16
>     vle32.v $V18, ($KEYP)
> -    @{[vaesem_vs $V1, $V18]}
> +    vaesem.vs $V1, $V18
>     addi $KEYP, $KEYP, 16
>     vle32.v $V19, ($KEYP)
> -    @{[vaesem_vs $V1, $V19]}
> +    vaesem.vs $V1, $V19
>     addi $KEYP, $KEYP, 16
>     vle32.v $V20, ($KEYP)
> -    @{[vaesem_vs $V1, $V20]}
> +    vaesem.vs $V1, $V20
>     addi $KEYP, $KEYP, 16
>     vle32.v $V21, ($KEYP)
> -    @{[vaesem_vs $V1, $V21]}
> +    vaesem.vs $V1, $V21
>     addi $KEYP, $KEYP, 16
>     vle32.v $V22, ($KEYP)
> -    @{[vaesem_vs $V1, $V22]}
> +    vaesem.vs $V1, $V22
>     addi $KEYP, $KEYP, 16
>     vle32.v $V23, ($KEYP)
> -    @{[vaesem_vs $V1, $V23]}
> +    vaesem.vs $V1, $V23
>     addi $KEYP, $KEYP, 16
>     vle32.v $V24, ($KEYP)
> -    @{[vaesef_vs $V1, $V24]}
> +    vaesef.vs $V1, $V24
>=20
>     vse32.v $V1, ($OUTP)
>     ret
> .size L_enc_256,.-L_enc_256
> ___
>=20
> =
##########################################################################=
######
> # void rv64i_zvkned_decrypt(const unsigned char *in, unsigned char =
*out,
> #                           const AES_KEY *key);
> $code .=3D <<___;
> @@ -1020,163 +1020,163 @@ ___
>=20
> $code .=3D <<___;
> .p2align 3
> L_dec_128:
>     vsetivli zero, 4, e32, m1, ta, ma
>=20
>     vle32.v $V1, ($INP)
>=20
>     addi $KEYP, $KEYP, 160
>     vle32.v $V20, ($KEYP)
> -    @{[vaesz_vs $V1, $V20]}    # with round key w[40,43]
> +    vaesz.vs $V1, $V20    # with round key w[40,43]
>     addi $KEYP, $KEYP, -16
>     vle32.v $V19, ($KEYP)
> -    @{[vaesdm_vs $V1, $V19]}   # with round key w[36,39]
> +    vaesdm.vs $V1, $V19   # with round key w[36,39]
>     addi $KEYP, $KEYP, -16
>     vle32.v $V18, ($KEYP)
> -    @{[vaesdm_vs $V1, $V18]}   # with round key w[32,35]
> +    vaesdm.vs $V1, $V18   # with round key w[32,35]
>     addi $KEYP, $KEYP, -16
>     vle32.v $V17, ($KEYP)
> -    @{[vaesdm_vs $V1, $V17]}   # with round key w[28,31]
> +    vaesdm.vs $V1, $V17   # with round key w[28,31]
>     addi $KEYP, $KEYP, -16
>     vle32.v $V16, ($KEYP)
> -    @{[vaesdm_vs $V1, $V16]}   # with round key w[24,27]
> +    vaesdm.vs $V1, $V16   # with round key w[24,27]
>     addi $KEYP, $KEYP, -16
>     vle32.v $V15, ($KEYP)
> -    @{[vaesdm_vs $V1, $V15]}   # with round key w[20,23]
> +    vaesdm.vs $V1, $V15   # with round key w[20,23]
>     addi $KEYP, $KEYP, -16
>     vle32.v $V14, ($KEYP)
> -    @{[vaesdm_vs $V1, $V14]}   # with round key w[16,19]
> +    vaesdm.vs $V1, $V14   # with round key w[16,19]
>     addi $KEYP, $KEYP, -16
>     vle32.v $V13, ($KEYP)
> -    @{[vaesdm_vs $V1, $V13]}   # with round key w[12,15]
> +    vaesdm.vs $V1, $V13   # with round key w[12,15]
>     addi $KEYP, $KEYP, -16
>     vle32.v $V12, ($KEYP)
> -    @{[vaesdm_vs $V1, $V12]}   # with round key w[ 8,11]
> +    vaesdm.vs $V1, $V12   # with round key w[ 8,11]
>     addi $KEYP, $KEYP, -16
>     vle32.v $V11, ($KEYP)
> -    @{[vaesdm_vs $V1, $V11]}   # with round key w[ 4, 7]
> +    vaesdm.vs $V1, $V11   # with round key w[ 4, 7]
>     addi $KEYP, $KEYP, -16
>     vle32.v $V10, ($KEYP)
> -    @{[vaesdf_vs $V1, $V10]}   # with round key w[ 0, 3]
> +    vaesdf.vs $V1, $V10   # with round key w[ 0, 3]
>=20
>     vse32.v $V1, ($OUTP)
>=20
>     ret
> .size L_dec_128,.-L_dec_128
> ___
>=20
> $code .=3D <<___;
> .p2align 3
> L_dec_192:
>     vsetivli zero, 4, e32, m1, ta, ma
>=20
>     vle32.v $V1, ($INP)
>=20
>     addi $KEYP, $KEYP, 192
>     vle32.v $V22, ($KEYP)
> -    @{[vaesz_vs $V1, $V22]}    # with round key w[48,51]
> +    vaesz.vs $V1, $V22    # with round key w[48,51]
>     addi $KEYP, $KEYP, -16
>     vle32.v $V21, ($KEYP)
> -    @{[vaesdm_vs $V1, $V21]}   # with round key w[44,47]
> +    vaesdm.vs $V1, $V21   # with round key w[44,47]
>     addi $KEYP, $KEYP, -16
>     vle32.v $V20, ($KEYP)
> -    @{[vaesdm_vs $V1, $V20]}   # with round key w[40,43]
> +    vaesdm.vs $V1, $V20   # with round key w[40,43]
>     addi $KEYP, $KEYP, -16
>     vle32.v $V19, ($KEYP)
> -    @{[vaesdm_vs $V1, $V19]}   # with round key w[36,39]
> +    vaesdm.vs $V1, $V19   # with round key w[36,39]
>     addi $KEYP, $KEYP, -16
>     vle32.v $V18, ($KEYP)
> -    @{[vaesdm_vs $V1, $V18]}   # with round key w[32,35]
> +    vaesdm.vs $V1, $V18   # with round key w[32,35]
>     addi $KEYP, $KEYP, -16
>     vle32.v $V17, ($KEYP)
> -    @{[vaesdm_vs $V1, $V17]}   # with round key w[28,31]
> +    vaesdm.vs $V1, $V17   # with round key w[28,31]
>     addi $KEYP, $KEYP, -16
>     vle32.v $V16, ($KEYP)
> -    @{[vaesdm_vs $V1, $V16]}   # with round key w[24,27]
> +    vaesdm.vs $V1, $V16   # with round key w[24,27]
>     addi $KEYP, $KEYP, -16
>     vle32.v $V15, ($KEYP)
> -    @{[vaesdm_vs $V1, $V15]}   # with round key w[20,23]
> +    vaesdm.vs $V1, $V15   # with round key w[20,23]
>     addi $KEYP, $KEYP, -16
>     vle32.v $V14, ($KEYP)
> -    @{[vaesdm_vs $V1, $V14]}   # with round key w[16,19]
> +    vaesdm.vs $V1, $V14   # with round key w[16,19]
>     addi $KEYP, $KEYP, -16
>     vle32.v $V13, ($KEYP)
> -    @{[vaesdm_vs $V1, $V13]}   # with round key w[12,15]
> +    vaesdm.vs $V1, $V13   # with round key w[12,15]
>     addi $KEYP, $KEYP, -16
>     vle32.v $V12, ($KEYP)
> -    @{[vaesdm_vs $V1, $V12]}   # with round key w[ 8,11]
> +    vaesdm.vs $V1, $V12   # with round key w[ 8,11]
>     addi $KEYP, $KEYP, -16
>     vle32.v $V11, ($KEYP)
> -    @{[vaesdm_vs $V1, $V11]}   # with round key w[ 4, 7]
> +    vaesdm.vs $V1, $V11   # with round key w[ 4, 7]
>     addi $KEYP, $KEYP, -16
>     vle32.v $V10, ($KEYP)
> -    @{[vaesdf_vs $V1, $V10]}   # with round key w[ 0, 3]
> +    vaesdf.vs $V1, $V10   # with round key w[ 0, 3]
>=20
>     vse32.v $V1, ($OUTP)
>=20
>     ret
> .size L_dec_192,.-L_dec_192
> ___
>=20
> $code .=3D <<___;
> .p2align 3
> L_dec_256:
>     vsetivli zero, 4, e32, m1, ta, ma
>=20
>     vle32.v $V1, ($INP)
>=20
>     addi $KEYP, $KEYP, 224
>     vle32.v $V24, ($KEYP)
> -    @{[vaesz_vs $V1, $V24]}    # with round key w[56,59]
> +    vaesz.vs $V1, $V24    # with round key w[56,59]
>     addi $KEYP, $KEYP, -16
>     vle32.v $V23, ($KEYP)
> -    @{[vaesdm_vs $V1, $V23]}   # with round key w[52,55]
> +    vaesdm.vs $V1, $V23   # with round key w[52,55]
>     addi $KEYP, $KEYP, -16
>     vle32.v $V22, ($KEYP)
> -    @{[vaesdm_vs $V1, $V22]}   # with round key w[48,51]
> +    vaesdm.vs $V1, $V22   # with round key w[48,51]
>     addi $KEYP, $KEYP, -16
>     vle32.v $V21, ($KEYP)
> -    @{[vaesdm_vs $V1, $V21]}   # with round key w[44,47]
> +    vaesdm.vs $V1, $V21   # with round key w[44,47]
>     addi $KEYP, $KEYP, -16
>     vle32.v $V20, ($KEYP)
> -    @{[vaesdm_vs $V1, $V20]}   # with round key w[40,43]
> +    vaesdm.vs $V1, $V20   # with round key w[40,43]
>     addi $KEYP, $KEYP, -16
>     vle32.v $V19, ($KEYP)
> -    @{[vaesdm_vs $V1, $V19]}   # with round key w[36,39]
> +    vaesdm.vs $V1, $V19   # with round key w[36,39]
>     addi $KEYP, $KEYP, -16
>     vle32.v $V18, ($KEYP)
> -    @{[vaesdm_vs $V1, $V18]}   # with round key w[32,35]
> +    vaesdm.vs $V1, $V18   # with round key w[32,35]
>     addi $KEYP, $KEYP, -16
>     vle32.v $V17, ($KEYP)
> -    @{[vaesdm_vs $V1, $V17]}   # with round key w[28,31]
> +    vaesdm.vs $V1, $V17   # with round key w[28,31]
>     addi $KEYP, $KEYP, -16
>     vle32.v $V16, ($KEYP)
> -    @{[vaesdm_vs $V1, $V16]}   # with round key w[24,27]
> +    vaesdm.vs $V1, $V16   # with round key w[24,27]
>     addi $KEYP, $KEYP, -16
>     vle32.v $V15, ($KEYP)
> -    @{[vaesdm_vs $V1, $V15]}   # with round key w[20,23]
> +    vaesdm.vs $V1, $V15   # with round key w[20,23]
>     addi $KEYP, $KEYP, -16
>     vle32.v $V14, ($KEYP)
> -    @{[vaesdm_vs $V1, $V14]}   # with round key w[16,19]
> +    vaesdm.vs $V1, $V14   # with round key w[16,19]
>     addi $KEYP, $KEYP, -16
>     vle32.v $V13, ($KEYP)
> -    @{[vaesdm_vs $V1, $V13]}   # with round key w[12,15]
> +    vaesdm.vs $V1, $V13   # with round key w[12,15]
>     addi $KEYP, $KEYP, -16
>     vle32.v $V12, ($KEYP)
> -    @{[vaesdm_vs $V1, $V12]}   # with round key w[ 8,11]
> +    vaesdm.vs $V1, $V12   # with round key w[ 8,11]
>     addi $KEYP, $KEYP, -16
>     vle32.v $V11, ($KEYP)
> -    @{[vaesdm_vs $V1, $V11]}   # with round key w[ 4, 7]
> +    vaesdm.vs $V1, $V11   # with round key w[ 4, 7]
>     addi $KEYP, $KEYP, -16
>     vle32.v $V10, ($KEYP)
> -    @{[vaesdf_vs $V1, $V10]}   # with round key w[ 0, 3]
> +    vaesdf.vs $V1, $V10   # with round key w[ 0, 3]
>=20
>     vse32.v $V1, ($OUTP)
>=20
>     ret
> .size L_dec_256,.-L_dec_256
> ___
> }
>=20
> $code .=3D <<___;
> L_fail_m1:
> diff --git a/arch/riscv/crypto/chacha-riscv64-zvkb.pl =
b/arch/riscv/crypto/chacha-riscv64-zvkb.pl
> index a76069f62e11..279410d9e062 100644
> --- a/arch/riscv/crypto/chacha-riscv64-zvkb.pl
> +++ b/arch/riscv/crypto/chacha-riscv64-zvkb.pl
> @@ -40,31 +40,31 @@
> # - RV64I
> # - RISC-V Vector ('V') with VLEN >=3D 128
> # - RISC-V Vector Cryptography Bit-manipulation extension ('Zvkb')
>=20
> use strict;
> use warnings;
>=20
> use FindBin qw($Bin);
> use lib "$Bin";
> use lib "$Bin/../../perlasm";
> -use riscv;
>=20
> # $output is the last argument if it looks like a file (it has an =
extension)
> # $flavour is the first argument if it doesn't look like a file
> my $output  =3D $#ARGV >=3D 0 && $ARGV[$#ARGV] =3D~ m|\.\w+$| ? pop   =
: undef;
> my $flavour =3D $#ARGV >=3D 0 && $ARGV[0] !~ m|\.|          ? shift : =
undef;
>=20
> $output and open STDOUT, ">$output";
>=20
> my $code =3D <<___;
> .text
> +.option arch, +zvkb
> ___
>=20
> # void ChaCha20_ctr32_zvkb(unsigned char *out, const unsigned char =
*inp,
> #                          size_t len, const unsigned int key[8],
> #                          const unsigned int counter[4]);
> =
##########################################################################=
######
> my ( $OUTPUT, $INPUT, $LEN, $KEY, $COUNTER ) =3D ( "a0", "a1", "a2", =
"a3", "a4" );
> my ( $T0 ) =3D ( "t0" );
> my ( $CONST_DATA0, $CONST_DATA1, $CONST_DATA2, $CONST_DATA3 ) =3D
>   ( "a5", "a6", "a7", "t1" );
> @@ -88,63 +88,63 @@ sub chacha_quad_round_group {
>     my $code =3D <<___;
>     # a +=3D b; d ^=3D a; d <<<=3D 16;
>     vadd.vv $A0, $A0, $B0
>     vadd.vv $A1, $A1, $B1
>     vadd.vv $A2, $A2, $B2
>     vadd.vv $A3, $A3, $B3
>     vxor.vv $D0, $D0, $A0
>     vxor.vv $D1, $D1, $A1
>     vxor.vv $D2, $D2, $A2
>     vxor.vv $D3, $D3, $A3
> -    @{[vror_vi $D0, $D0, 32 - 16]}
> -    @{[vror_vi $D1, $D1, 32 - 16]}
> -    @{[vror_vi $D2, $D2, 32 - 16]}
> -    @{[vror_vi $D3, $D3, 32 - 16]}
> +    vror.vi $D0, $D0, 32 - 16
> +    vror.vi $D1, $D1, 32 - 16
> +    vror.vi $D2, $D2, 32 - 16
> +    vror.vi $D3, $D3, 32 - 16
>     # c +=3D d; b ^=3D c; b <<<=3D 12;
>     vadd.vv $C0, $C0, $D0
>     vadd.vv $C1, $C1, $D1
>     vadd.vv $C2, $C2, $D2
>     vadd.vv $C3, $C3, $D3
>     vxor.vv $B0, $B0, $C0
>     vxor.vv $B1, $B1, $C1
>     vxor.vv $B2, $B2, $C2
>     vxor.vv $B3, $B3, $C3
> -    @{[vror_vi $B0, $B0, 32 - 12]}
> -    @{[vror_vi $B1, $B1, 32 - 12]}
> -    @{[vror_vi $B2, $B2, 32 - 12]}
> -    @{[vror_vi $B3, $B3, 32 - 12]}
> +    vror.vi $B0, $B0, 32 - 12
> +    vror.vi $B1, $B1, 32 - 12
> +    vror.vi $B2, $B2, 32 - 12
> +    vror.vi $B3, $B3, 32 - 12
>     # a +=3D b; d ^=3D a; d <<<=3D 8;
>     vadd.vv $A0, $A0, $B0
>     vadd.vv $A1, $A1, $B1
>     vadd.vv $A2, $A2, $B2
>     vadd.vv $A3, $A3, $B3
>     vxor.vv $D0, $D0, $A0
>     vxor.vv $D1, $D1, $A1
>     vxor.vv $D2, $D2, $A2
>     vxor.vv $D3, $D3, $A3
> -    @{[vror_vi $D0, $D0, 32 - 8]}
> -    @{[vror_vi $D1, $D1, 32 - 8]}
> -    @{[vror_vi $D2, $D2, 32 - 8]}
> -    @{[vror_vi $D3, $D3, 32 - 8]}
> +    vror.vi $D0, $D0, 32 - 8
> +    vror.vi $D1, $D1, 32 - 8
> +    vror.vi $D2, $D2, 32 - 8
> +    vror.vi $D3, $D3, 32 - 8
>     # c +=3D d; b ^=3D c; b <<<=3D 7;
>     vadd.vv $C0, $C0, $D0
>     vadd.vv $C1, $C1, $D1
>     vadd.vv $C2, $C2, $D2
>     vadd.vv $C3, $C3, $D3
>     vxor.vv $B0, $B0, $C0
>     vxor.vv $B1, $B1, $C1
>     vxor.vv $B2, $B2, $C2
>     vxor.vv $B3, $B3, $C3
> -    @{[vror_vi $B0, $B0, 32 - 7]}
> -    @{[vror_vi $B1, $B1, 32 - 7]}
> -    @{[vror_vi $B2, $B2, 32 - 7]}
> -    @{[vror_vi $B3, $B3, 32 - 7]}
> +    vror.vi $B0, $B0, 32 - 7
> +    vror.vi $B1, $B1, 32 - 7
> +    vror.vi $B2, $B2, 32 - 7
> +    vror.vi $B3, $B3, 32 - 7
> ___
>=20
>     return $code;
> }
>=20
> $code .=3D <<___;
> .p2align 3
> .globl ChaCha20_ctr32_zvkb
> .type ChaCha20_ctr32_zvkb,\@function
> ChaCha20_ctr32_zvkb:
> diff --git a/arch/riscv/crypto/ghash-riscv64-zvkg.pl =
b/arch/riscv/crypto/ghash-riscv64-zvkg.pl
> index a414d77554d2..f18824496573 100644
> --- a/arch/riscv/crypto/ghash-riscv64-zvkg.pl
> +++ b/arch/riscv/crypto/ghash-riscv64-zvkg.pl
> @@ -40,31 +40,31 @@
> # - RV64I
> # - RISC-V Vector ('V') with VLEN >=3D 128
> # - RISC-V Vector GCM/GMAC extension ('Zvkg')
>=20
> use strict;
> use warnings;
>=20
> use FindBin qw($Bin);
> use lib "$Bin";
> use lib "$Bin/../../perlasm";
> -use riscv;
>=20
> # $output is the last argument if it looks like a file (it has an =
extension)
> # $flavour is the first argument if it doesn't look like a file
> my $output =3D $#ARGV >=3D 0 && $ARGV[$#ARGV] =3D~ m|\.\w+$| ? pop : =
undef;
> my $flavour =3D $#ARGV >=3D 0 && $ARGV[0] !~ m|\.| ? shift : undef;
>=20
> $output and open STDOUT,">$output";
>=20
> my $code=3D<<___;
> .text
> +.option arch, +zvkg
> ___
>=20
> =
##########################################################################=
#####
> # void gcm_ghash_rv64i_zvkg(be128 *Xi, const be128 *H, const u8 *inp, =
size_t len)
> #
> # input: Xi: current hash value
> #        H: hash key
> #        inp: pointer to input data
> #        len: length of input data in bytes (multiple of block size)
> # output: Xi: Xi+1 (next hash value Xi)
> @@ -78,21 +78,21 @@ $code .=3D <<___;
> .type gcm_ghash_rv64i_zvkg,\@function
> gcm_ghash_rv64i_zvkg:
>     vsetivli zero, 4, e32, m1, ta, ma
>     vle32.v $vH, ($H)
>     vle32.v $vXi, ($Xi)
>=20
> Lstep:
>     vle32.v $vinp, ($inp)
>     add $inp, $inp, 16
>     add $len, $len, -16
> -    @{[vghsh_vv $vXi, $vH, $vinp]}
> +    vghsh.vv $vXi, $vH, $vinp
>     bnez $len, Lstep
>=20
>     vse32.v $vXi, ($Xi)
>     ret
>=20
> .size gcm_ghash_rv64i_zvkg,.-gcm_ghash_rv64i_zvkg
> ___
> }
>=20
> print $code;
> diff --git a/arch/riscv/crypto/riscv.pm b/arch/riscv/crypto/riscv.pm
> deleted file mode 100644
> index d91ad902ca04..000000000000
> --- a/arch/riscv/crypto/riscv.pm
> +++ /dev/null
> @@ -1,359 +0,0 @@
> -#! /usr/bin/env perl
> -# SPDX-License-Identifier: Apache-2.0 OR BSD-2-Clause
> -#
> -# This file is dual-licensed, meaning that you can use it under your
> -# choice of either of the following two licenses:
> -#
> -# Copyright 2023 The OpenSSL Project Authors. All Rights Reserved.
> -#
> -# Licensed under the Apache License 2.0 (the "License"). You can =
obtain
> -# a copy in the file LICENSE in the source distribution or at
> -# https://www.openssl.org/source/license.html
> -#
> -# or
> -#
> -# Copyright (c) 2023, Christoph M=C3=BCllner =
<christoph.muellner@vrull.eu>
> -# Copyright (c) 2023, Jerry Shih <jerry.shih@sifive.com>
> -# Copyright (c) 2023, Phoebe Chen <phoebe.chen@sifive.com>
> -# All rights reserved.
> -#
> -# Redistribution and use in source and binary forms, with or without
> -# modification, are permitted provided that the following conditions
> -# are met:
> -# 1. Redistributions of source code must retain the above copyright
> -#    notice, this list of conditions and the following disclaimer.
> -# 2. Redistributions in binary form must reproduce the above =
copyright
> -#    notice, this list of conditions and the following disclaimer in =
the
> -#    documentation and/or other materials provided with the =
distribution.
> -#
> -# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
> -# "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
> -# LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS =
FOR
> -# A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE =
COPYRIGHT
> -# OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, =
INCIDENTAL,
> -# SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
> -# LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF =
USE,
> -# DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON =
ANY
> -# THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
> -# (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE =
USE
> -# OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH =
DAMAGE.
> -
> -use strict;
> -use warnings;
> -
> -# Set $have_stacktrace to 1 if we have Devel::StackTrace
> -my $have_stacktrace =3D 0;
> -if (eval {require Devel::StackTrace;1;}) {
> -    $have_stacktrace =3D 1;
> -}
> -
> -my @regs =3D map("x$_",(0..31));
> -# Mapping from the RISC-V psABI ABI mnemonic names to the register =
number.
> -my @regaliases =3D =
('zero','ra','sp','gp','tp','t0','t1','t2','s0','s1',
> -    map("a$_",(0..7)),
> -    map("s$_",(2..11)),
> -    map("t$_",(3..6))
> -);
> -
> -my %reglookup;
> -@reglookup{@regs} =3D @regs;
> -@reglookup{@regaliases} =3D @regs;
> -
> -# Takes a register name, possibly an alias, and converts it to a =
register index
> -# from 0 to 31
> -sub read_reg {
> -    my $reg =3D lc shift;
> -    if (!exists($reglookup{$reg})) {
> -        my $trace =3D "";
> -        if ($have_stacktrace) {
> -            $trace =3D Devel::StackTrace->new->as_string;
> -        }
> -        die("Unknown register ".$reg."\n".$trace);
> -    }
> -    my $regstr =3D $reglookup{$reg};
> -    if (!($regstr =3D~ /^x([0-9]+)$/)) {
> -        my $trace =3D "";
> -        if ($have_stacktrace) {
> -            $trace =3D Devel::StackTrace->new->as_string;
> -        }
> -        die("Could not process register ".$reg."\n".$trace);
> -    }
> -    return $1;
> -}
> -
> -my @vregs =3D map("v$_",(0..31));
> -my %vreglookup;
> -@vreglookup{@vregs} =3D @vregs;
> -
> -sub read_vreg {
> -    my $vreg =3D lc shift;
> -    if (!exists($vreglookup{$vreg})) {
> -        my $trace =3D "";
> -        if ($have_stacktrace) {
> -            $trace =3D Devel::StackTrace->new->as_string;
> -        }
> -        die("Unknown vector register ".$vreg."\n".$trace);
> -    }
> -    if (!($vreg =3D~ /^v([0-9]+)$/)) {
> -        my $trace =3D "";
> -        if ($have_stacktrace) {
> -            $trace =3D Devel::StackTrace->new->as_string;
> -        }
> -        die("Could not process vector register ".$vreg."\n".$trace);
> -    }
> -    return $1;
> -}
> -
> -# Read the vm settings and convert to mask encoding.
> -sub read_mask_vreg {
> -    my $vreg =3D shift;
> -    # The default value is unmasked.
> -    my $mask_bit =3D 1;
> -
> -    if (defined($vreg)) {
> -        my $reg_id =3D read_vreg $vreg;
> -        if ($reg_id =3D=3D 0) {
> -            $mask_bit =3D 0;
> -        } else {
> -            my $trace =3D "";
> -            if ($have_stacktrace) {
> -                $trace =3D Devel::StackTrace->new->as_string;
> -            }
> -            die("The ".$vreg." is not the mask register =
v0.\n".$trace);
> -        }
> -    }
> -    return $mask_bit;
> -}
> -
> -# Vector crypto instructions
> -
> -## Zvbb and Zvkb instructions
> -##
> -## vandn (also in zvkb)
> -## vbrev
> -## vbrev8 (also in zvkb)
> -## vrev8 (also in zvkb)
> -## vclz
> -## vctz
> -## vcpop
> -## vrol (also in zvkb)
> -## vror (also in zvkb)
> -## vwsll
> -
> -sub vbrev8_v {
> -    # vbrev8.v vd, vs2, vm
> -    my $template =3D 0b010010_0_00000_01000_010_00000_1010111;
> -    my $vd =3D read_vreg shift;
> -    my $vs2 =3D read_vreg shift;
> -    my $vm =3D read_mask_vreg shift;
> -    return ".word ".($template | ($vm << 25) | ($vs2 << 20) | ($vd << =
7));
> -}
> -
> -sub vrev8_v {
> -    # vrev8.v vd, vs2, vm
> -    my $template =3D 0b010010_0_00000_01001_010_00000_1010111;
> -    my $vd =3D read_vreg shift;
> -    my $vs2 =3D read_vreg shift;
> -    my $vm =3D read_mask_vreg shift;
> -    return ".word ".($template | ($vm << 25) | ($vs2 << 20) | ($vd << =
7));
> -}
> -
> -sub vror_vi {
> -    # vror.vi vd, vs2, uimm
> -    my $template =3D 0b01010_0_1_00000_00000_011_00000_1010111;
> -    my $vd =3D read_vreg shift;
> -    my $vs2 =3D read_vreg shift;
> -    my $uimm =3D shift;
> -    my $uimm_i5 =3D $uimm >> 5;
> -    my $uimm_i4_0 =3D $uimm & 0b11111;
> -
> -    return ".word ".($template | ($uimm_i5 << 26) | ($vs2 << 20) | =
($uimm_i4_0 << 15) | ($vd << 7));
> -}
> -
> -sub vwsll_vv {
> -    # vwsll.vv vd, vs2, vs1, vm
> -    my $template =3D 0b110101_0_00000_00000_000_00000_1010111;
> -    my $vd =3D read_vreg shift;
> -    my $vs2 =3D read_vreg shift;
> -    my $vs1 =3D read_vreg shift;
> -    my $vm =3D read_mask_vreg shift;
> -    return ".word ".($template | ($vm << 25) | ($vs2 << 20) | ($vs1 =
<< 15) | ($vd << 7));
> -}
> -
> -## Zvbc instructions
> -
> -sub vclmulh_vx {
> -    # vclmulh.vx vd, vs2, rs1
> -    my $template =3D 0b0011011_00000_00000_110_00000_1010111;
> -    my $vd =3D read_vreg shift;
> -    my $vs2 =3D read_vreg shift;
> -    my $rs1 =3D read_reg shift;
> -    return ".word ".($template | ($vs2 << 20) | ($rs1 << 15) | ($vd =
<< 7));
> -}
> -
> -sub vclmul_vx_v0t {
> -    # vclmul.vx vd, vs2, rs1, v0.t
> -    my $template =3D 0b0011000_00000_00000_110_00000_1010111;
> -    my $vd =3D read_vreg shift;
> -    my $vs2 =3D read_vreg shift;
> -    my $rs1 =3D read_reg shift;
> -    return ".word ".($template | ($vs2 << 20) | ($rs1 << 15) | ($vd =
<< 7));
> -}
> -
> -sub vclmul_vx {
> -    # vclmul.vx vd, vs2, rs1
> -    my $template =3D 0b0011001_00000_00000_110_00000_1010111;
> -    my $vd =3D read_vreg shift;
> -    my $vs2 =3D read_vreg shift;
> -    my $rs1 =3D read_reg shift;
> -    return ".word ".($template | ($vs2 << 20) | ($rs1 << 15) | ($vd =
<< 7));
> -}
> -
> -## Zvkg instructions
> -
> -sub vghsh_vv {
> -    # vghsh.vv vd, vs2, vs1
> -    my $template =3D 0b1011001_00000_00000_010_00000_1110111;
> -    my $vd =3D read_vreg shift;
> -    my $vs2 =3D read_vreg shift;
> -    my $vs1 =3D read_vreg shift;
> -    return ".word ".($template | ($vs2 << 20) | ($vs1 << 15) | ($vd =
<< 7));
> -}
> -
> -sub vgmul_vv {
> -    # vgmul.vv vd, vs2
> -    my $template =3D 0b1010001_00000_10001_010_00000_1110111;
> -    my $vd =3D read_vreg shift;
> -    my $vs2 =3D read_vreg shift;
> -    return ".word ".($template | ($vs2 << 20) | ($vd << 7));
> -}
> -
> -## Zvkned instructions
> -
> -sub vaesdf_vs {
> -    # vaesdf.vs vd, vs2
> -    my $template =3D 0b101001_1_00000_00001_010_00000_1110111;
> -    my $vd =3D read_vreg  shift;
> -    my $vs2 =3D read_vreg  shift;
> -    return ".word ".($template | ($vs2 << 20) | ($vd << 7));
> -}
> -
> -sub vaesdm_vs {
> -    # vaesdm.vs vd, vs2
> -    my $template =3D 0b101001_1_00000_00000_010_00000_1110111;
> -    my $vd =3D read_vreg shift;
> -    my $vs2 =3D read_vreg shift;
> -    return ".word ".($template | ($vs2 << 20) | ($vd << 7));
> -}
> -
> -sub vaesef_vs {
> -    # vaesef.vs vd, vs2
> -    my $template =3D 0b101001_1_00000_00011_010_00000_1110111;
> -    my $vd =3D read_vreg  shift;
> -    my $vs2 =3D read_vreg  shift;
> -    return ".word ".($template | ($vs2 << 20) | ($vd << 7));
> -}
> -
> -sub vaesem_vs {
> -    # vaesem.vs vd, vs2
> -    my $template =3D 0b101001_1_00000_00010_010_00000_1110111;
> -    my $vd =3D read_vreg  shift;
> -    my $vs2 =3D read_vreg  shift;
> -    return ".word ".($template | ($vs2 << 20) | ($vd << 7));
> -}
> -
> -sub vaeskf1_vi {
> -    # vaeskf1.vi vd, vs2, uimmm
> -    my $template =3D 0b100010_1_00000_00000_010_00000_1110111;
> -    my $vd =3D read_vreg  shift;
> -    my $vs2 =3D read_vreg  shift;
> -    my $uimm =3D shift;
> -    return ".word ".($template | ($uimm << 15) | ($vs2 << 20) | ($vd =
<< 7));
> -}
> -
> -sub vaeskf2_vi {
> -    # vaeskf2.vi vd, vs2, uimm
> -    my $template =3D 0b101010_1_00000_00000_010_00000_1110111;
> -    my $vd =3D read_vreg shift;
> -    my $vs2 =3D read_vreg shift;
> -    my $uimm =3D shift;
> -    return ".word ".($template | ($vs2 << 20) | ($uimm << 15) | ($vd =
<< 7));
> -}
> -
> -sub vaesz_vs {
> -    # vaesz.vs vd, vs2
> -    my $template =3D 0b101001_1_00000_00111_010_00000_1110111;
> -    my $vd =3D read_vreg  shift;
> -    my $vs2 =3D read_vreg  shift;
> -    return ".word ".($template | ($vs2 << 20) | ($vd << 7));
> -}
> -
> -## Zvknha and Zvknhb instructions
> -
> -sub vsha2ms_vv {
> -    # vsha2ms.vv vd, vs2, vs1
> -    my $template =3D 0b1011011_00000_00000_010_00000_1110111;
> -    my $vd =3D read_vreg shift;
> -    my $vs2 =3D read_vreg shift;
> -    my $vs1 =3D read_vreg shift;
> -    return ".word ".($template | ($vs2 << 20)| ($vs1 << 15 )| ($vd << =
7));
> -}
> -
> -sub vsha2ch_vv {
> -    # vsha2ch.vv vd, vs2, vs1
> -    my $template =3D 0b101110_10000_00000_001_00000_01110111;
> -    my $vd =3D read_vreg shift;
> -    my $vs2 =3D read_vreg shift;
> -    my $vs1 =3D read_vreg shift;
> -    return ".word ".($template | ($vs2 << 20)| ($vs1 << 15 )| ($vd << =
7));
> -}
> -
> -sub vsha2cl_vv {
> -    # vsha2cl.vv vd, vs2, vs1
> -    my $template =3D 0b101111_10000_00000_001_00000_01110111;
> -    my $vd =3D read_vreg shift;
> -    my $vs2 =3D read_vreg shift;
> -    my $vs1 =3D read_vreg shift;
> -    return ".word ".($template | ($vs2 << 20)| ($vs1 << 15 )| ($vd << =
7));
> -}
> -
> -## Zvksed instructions
> -
> -sub vsm4k_vi {
> -    # vsm4k.vi vd, vs2, uimm
> -    my $template =3D 0b1000011_00000_00000_010_00000_1110111;
> -    my $vd =3D read_vreg shift;
> -    my $vs2 =3D read_vreg shift;
> -    my $uimm =3D shift;
> -    return ".word ".($template | ($vs2 << 20) | ($uimm << 15) | ($vd =
<< 7));
> -}
> -
> -sub vsm4r_vs {
> -    # vsm4r.vs vd, vs2
> -    my $template =3D 0b1010011_00000_10000_010_00000_1110111;
> -    my $vd =3D read_vreg shift;
> -    my $vs2 =3D read_vreg shift;
> -    return ".word ".($template | ($vs2 << 20) | ($vd << 7));
> -}
> -
> -## zvksh instructions
> -
> -sub vsm3c_vi {
> -    # vsm3c.vi vd, vs2, uimm
> -    my $template =3D 0b1010111_00000_00000_010_00000_1110111;
> -    my $vd =3D read_vreg shift;
> -    my $vs2 =3D read_vreg shift;
> -    my $uimm =3D shift;
> -    return ".word ".($template | ($vs2 << 20) | ($uimm << 15 ) | ($vd =
<< 7));
> -}
> -
> -sub vsm3me_vv {
> -    # vsm3me.vv vd, vs2, vs1
> -    my $template =3D 0b1000001_00000_00000_010_00000_1110111;
> -    my $vd =3D read_vreg shift;
> -    my $vs2 =3D read_vreg shift;
> -    my $vs1 =3D read_vreg shift;
> -    return ".word ".($template | ($vs2 << 20) | ($vs1 << 15 ) | ($vd =
<< 7));
> -}
> -
> -1;
> diff --git a/arch/riscv/crypto/sha256-riscv64-zvknha_or_zvknhb-zvkb.pl =
b/arch/riscv/crypto/sha256-riscv64-zvknha_or_zvknhb-zvkb.pl
> index b664cd65fbfc..3988e2d8199a 100644
> --- a/arch/riscv/crypto/sha256-riscv64-zvknha_or_zvknhb-zvkb.pl
> +++ b/arch/riscv/crypto/sha256-riscv64-zvknha_or_zvknhb-zvkb.pl
> @@ -33,41 +33,42 @@
> # SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
> # LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF =
USE,
> # DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON =
ANY
> # THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
> # (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE =
USE
> # OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
>=20
> # The generated code of this file depends on the following RISC-V =
extensions:
> # - RV64I
> # - RISC-V Vector ('V') with VLEN >=3D 128
> -# - RISC-V Vector Cryptography Bit-manipulation extension ('Zvkb')
> # - RISC-V Vector SHA-2 Secure Hash extension ('Zvknha' or 'Zvknhb')
> +# - RISC-V Vector Cryptography Bit-manipulation extension ('Zvkb')
>=20
> use strict;
> use warnings;
>=20
> use FindBin qw($Bin);
> use lib "$Bin";
> use lib "$Bin/../../perlasm";
> -use riscv;
>=20
> # $output is the last argument if it looks like a file (it has an =
extension)
> # $flavour is the first argument if it doesn't look like a file
> my $output =3D $#ARGV >=3D 0 && $ARGV[$#ARGV] =3D~ m|\.\w+$| ? pop : =
undef;
> my $flavour =3D $#ARGV >=3D 0 && $ARGV[0] !~ m|\.| ? shift : undef;
>=20
> $output and open STDOUT,">$output";
>=20
> my $code=3D<<___;
> #include <linux/cfi_types.h>
>=20
> +.option arch, +zvknha, +zvkb
> +
> .text
> ___
>=20
> my ($V0, $V1, $V2, $V3, $V4, $V5, $V6, $V7,
>     $V8, $V9, $V10, $V11, $V12, $V13, $V14, $V15,
>     $V16, $V17, $V18, $V19, $V20, $V21, $V22, $V23,
>     $V24, $V25, $V26, $V27, $V28, $V29, $V30, $V31,
> ) =3D map("v$_",(0..31));
>=20
> my $K256 =3D "K256";
> @@ -153,137 +154,137 @@ L_round_loop:
>     # Decrement length by 1
>     add $LEN, $LEN, -1
>=20
>     # Keep the current state as we need it later: H' =3D =
H+{a',b',c',...,h'}.
>     vmv.v.v $V30, $V6
>     vmv.v.v $V31, $V7
>=20
>     # Load the 512-bits of the message block in v1-v4 and perform
>     # an endian swap on each 4 bytes element.
>     vle32.v $V1, ($INP)
> -    @{[vrev8_v $V1, $V1]}
> +    vrev8.v $V1, $V1
>     add $INP, $INP, 16
>     vle32.v $V2, ($INP)
> -    @{[vrev8_v $V2, $V2]}
> +    vrev8.v $V2, $V2
>     add $INP, $INP, 16
>     vle32.v $V3, ($INP)
> -    @{[vrev8_v $V3, $V3]}
> +    vrev8.v $V3, $V3
>     add $INP, $INP, 16
>     vle32.v $V4, ($INP)
> -    @{[vrev8_v $V4, $V4]}
> +    vrev8.v $V4, $V4
>     add $INP, $INP, 16
>=20
>     # Quad-round 0 (+0, Wt from oldest to newest in v1->v2->v3->v4)
>     vadd.vv $V5, $V10, $V1
> -    @{[vsha2cl_vv $V7, $V6, $V5]}
> -    @{[vsha2ch_vv $V6, $V7, $V5]}
> +    vsha2cl.vv $V7, $V6, $V5
> +    vsha2ch.vv $V6, $V7, $V5
>     vmerge.vvm $V5, $V3, $V2, $V0
> -    @{[vsha2ms_vv $V1, $V5, $V4]}  # Generate W[19:16]
> +    vsha2ms.vv $V1, $V5, $V4  # Generate W[19:16]
>=20
>     # Quad-round 1 (+1, v2->v3->v4->v1)
>     vadd.vv $V5, $V11, $V2
> -    @{[vsha2cl_vv $V7, $V6, $V5]}
> -    @{[vsha2ch_vv $V6, $V7, $V5]}
> +    vsha2cl.vv $V7, $V6, $V5
> +    vsha2ch.vv $V6, $V7, $V5
>     vmerge.vvm $V5, $V4, $V3, $V0
> -    @{[vsha2ms_vv $V2, $V5, $V1]}  # Generate W[23:20]
> +    vsha2ms.vv $V2, $V5, $V1  # Generate W[23:20]
>=20
>     # Quad-round 2 (+2, v3->v4->v1->v2)
>     vadd.vv $V5, $V12, $V3
> -    @{[vsha2cl_vv $V7, $V6, $V5]}
> -    @{[vsha2ch_vv $V6, $V7, $V5]}
> +    vsha2cl.vv $V7, $V6, $V5
> +    vsha2ch.vv $V6, $V7, $V5
>     vmerge.vvm $V5, $V1, $V4, $V0
> -    @{[vsha2ms_vv $V3, $V5, $V2]}  # Generate W[27:24]
> +    vsha2ms.vv $V3, $V5, $V2  # Generate W[27:24]
>=20
>     # Quad-round 3 (+3, v4->v1->v2->v3)
>     vadd.vv $V5, $V13, $V4
> -    @{[vsha2cl_vv $V7, $V6, $V5]}
> -    @{[vsha2ch_vv $V6, $V7, $V5]}
> +    vsha2cl.vv $V7, $V6, $V5
> +    vsha2ch.vv $V6, $V7, $V5
>     vmerge.vvm $V5, $V2, $V1, $V0
> -    @{[vsha2ms_vv $V4, $V5, $V3]}  # Generate W[31:28]
> +    vsha2ms.vv $V4, $V5, $V3  # Generate W[31:28]
>=20
>     # Quad-round 4 (+0, v1->v2->v3->v4)
>     vadd.vv $V5, $V14, $V1
> -    @{[vsha2cl_vv $V7, $V6, $V5]}
> -    @{[vsha2ch_vv $V6, $V7, $V5]}
> +    vsha2cl.vv $V7, $V6, $V5
> +    vsha2ch.vv $V6, $V7, $V5
>     vmerge.vvm $V5, $V3, $V2, $V0
> -    @{[vsha2ms_vv $V1, $V5, $V4]}  # Generate W[35:32]
> +    vsha2ms.vv $V1, $V5, $V4  # Generate W[35:32]
>=20
>     # Quad-round 5 (+1, v2->v3->v4->v1)
>     vadd.vv $V5, $V15, $V2
> -    @{[vsha2cl_vv $V7, $V6, $V5]}
> -    @{[vsha2ch_vv $V6, $V7, $V5]}
> +    vsha2cl.vv $V7, $V6, $V5
> +    vsha2ch.vv $V6, $V7, $V5
>     vmerge.vvm $V5, $V4, $V3, $V0
> -    @{[vsha2ms_vv $V2, $V5, $V1]}  # Generate W[39:36]
> +    vsha2ms.vv $V2, $V5, $V1  # Generate W[39:36]
>=20
>     # Quad-round 6 (+2, v3->v4->v1->v2)
>     vadd.vv $V5, $V16, $V3
> -    @{[vsha2cl_vv $V7, $V6, $V5]}
> -    @{[vsha2ch_vv $V6, $V7, $V5]}
> +    vsha2cl.vv $V7, $V6, $V5
> +    vsha2ch.vv $V6, $V7, $V5
>     vmerge.vvm $V5, $V1, $V4, $V0
> -    @{[vsha2ms_vv $V3, $V5, $V2]}  # Generate W[43:40]
> +    vsha2ms.vv $V3, $V5, $V2  # Generate W[43:40]
>=20
>     # Quad-round 7 (+3, v4->v1->v2->v3)
>     vadd.vv $V5, $V17, $V4
> -    @{[vsha2cl_vv $V7, $V6, $V5]}
> -    @{[vsha2ch_vv $V6, $V7, $V5]}
> +    vsha2cl.vv $V7, $V6, $V5
> +    vsha2ch.vv $V6, $V7, $V5
>     vmerge.vvm $V5, $V2, $V1, $V0
> -    @{[vsha2ms_vv $V4, $V5, $V3]}  # Generate W[47:44]
> +    vsha2ms.vv $V4, $V5, $V3  # Generate W[47:44]
>=20
>     # Quad-round 8 (+0, v1->v2->v3->v4)
>     vadd.vv $V5, $V18, $V1
> -    @{[vsha2cl_vv $V7, $V6, $V5]}
> -    @{[vsha2ch_vv $V6, $V7, $V5]}
> +    vsha2cl.vv $V7, $V6, $V5
> +    vsha2ch.vv $V6, $V7, $V5
>     vmerge.vvm $V5, $V3, $V2, $V0
> -    @{[vsha2ms_vv $V1, $V5, $V4]}  # Generate W[51:48]
> +    vsha2ms.vv $V1, $V5, $V4  # Generate W[51:48]
>=20
>     # Quad-round 9 (+1, v2->v3->v4->v1)
>     vadd.vv $V5, $V19, $V2
> -    @{[vsha2cl_vv $V7, $V6, $V5]}
> -    @{[vsha2ch_vv $V6, $V7, $V5]}
> +    vsha2cl.vv $V7, $V6, $V5
> +    vsha2ch.vv $V6, $V7, $V5
>     vmerge.vvm $V5, $V4, $V3, $V0
> -    @{[vsha2ms_vv $V2, $V5, $V1]}  # Generate W[55:52]
> +    vsha2ms.vv $V2, $V5, $V1  # Generate W[55:52]
>=20
>     # Quad-round 10 (+2, v3->v4->v1->v2)
>     vadd.vv $V5, $V20, $V3
> -    @{[vsha2cl_vv $V7, $V6, $V5]}
> -    @{[vsha2ch_vv $V6, $V7, $V5]}
> +    vsha2cl.vv $V7, $V6, $V5
> +    vsha2ch.vv $V6, $V7, $V5
>     vmerge.vvm $V5, $V1, $V4, $V0
> -    @{[vsha2ms_vv $V3, $V5, $V2]}  # Generate W[59:56]
> +    vsha2ms.vv $V3, $V5, $V2  # Generate W[59:56]
>=20
>     # Quad-round 11 (+3, v4->v1->v2->v3)
>     vadd.vv $V5, $V21, $V4
> -    @{[vsha2cl_vv $V7, $V6, $V5]}
> -    @{[vsha2ch_vv $V6, $V7, $V5]}
> +    vsha2cl.vv $V7, $V6, $V5
> +    vsha2ch.vv $V6, $V7, $V5
>     vmerge.vvm $V5, $V2, $V1, $V0
> -    @{[vsha2ms_vv $V4, $V5, $V3]}  # Generate W[63:60]
> +    vsha2ms.vv $V4, $V5, $V3  # Generate W[63:60]
>=20
>     # Quad-round 12 (+0, v1->v2->v3->v4)
>     # Note that we stop generating new message schedule words (Wt, =
v1-13)
>     # as we already generated all the words we end up consuming (i.e., =
W[63:60]).
>     vadd.vv $V5, $V22, $V1
> -    @{[vsha2cl_vv $V7, $V6, $V5]}
> -    @{[vsha2ch_vv $V6, $V7, $V5]}
> +    vsha2cl.vv $V7, $V6, $V5
> +    vsha2ch.vv $V6, $V7, $V5
>=20
>     # Quad-round 13 (+1, v2->v3->v4->v1)
>     vadd.vv $V5, $V23, $V2
> -    @{[vsha2cl_vv $V7, $V6, $V5]}
> -    @{[vsha2ch_vv $V6, $V7, $V5]}
> +    vsha2cl.vv $V7, $V6, $V5
> +    vsha2ch.vv $V6, $V7, $V5
>=20
>     # Quad-round 14 (+2, v3->v4->v1->v2)
>     vadd.vv $V5, $V24, $V3
> -    @{[vsha2cl_vv $V7, $V6, $V5]}
> -    @{[vsha2ch_vv $V6, $V7, $V5]}
> +    vsha2cl.vv $V7, $V6, $V5
> +    vsha2ch.vv $V6, $V7, $V5
>=20
>     # Quad-round 15 (+3, v4->v1->v2->v3)
>     vadd.vv $V5, $V25, $V4
> -    @{[vsha2cl_vv $V7, $V6, $V5]}
> -    @{[vsha2ch_vv $V6, $V7, $V5]}
> +    vsha2cl.vv $V7, $V6, $V5
> +    vsha2ch.vv $V6, $V7, $V5
>=20
>     # H' =3D H+{a',b',c',...,h'}
>     vadd.vv $V6, $V30, $V6
>     vadd.vv $V7, $V31, $V7
>     bnez $LEN, L_round_loop
>=20
>     # Store {f,e,b,a},{h,g,d,c} back to {a,b,c,d},{e,f,g,h}.
>     vsuxei8.v $V6, ($H), $V26
>     vsuxei8.v $V7, ($H2), $V26
>=20
> diff --git a/arch/riscv/crypto/sha512-riscv64-zvknhb-zvkb.pl =
b/arch/riscv/crypto/sha512-riscv64-zvknhb-zvkb.pl
> index 1635b382b523..cab46ccd1fe2 100644
> --- a/arch/riscv/crypto/sha512-riscv64-zvknhb-zvkb.pl
> +++ b/arch/riscv/crypto/sha512-riscv64-zvknhb-zvkb.pl
> @@ -33,42 +33,42 @@
> # SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
> # LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF =
USE,
> # DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON =
ANY
> # THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
> # (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE =
USE
> # OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
>=20
> # The generated code of this file depends on the following RISC-V =
extensions:
> # - RV64I
> # - RISC-V vector ('V') with VLEN >=3D 128
> -# - RISC-V Vector Cryptography Bit-manipulation extension ('Zvkb')
> # - RISC-V Vector SHA-2 Secure Hash extension ('Zvknhb')
> +# - RISC-V Vector Cryptography Bit-manipulation extension ('Zvkb')
>=20
> use strict;
> use warnings;
>=20
> use FindBin qw($Bin);
> use lib "$Bin";
> use lib "$Bin/../../perlasm";
> -use riscv;
>=20
> # $output is the last argument if it looks like a file (it has an =
extension)
> # $flavour is the first argument if it doesn't look like a file
> my $output =3D $#ARGV >=3D 0 && $ARGV[$#ARGV] =3D~ m|\.\w+$| ? pop : =
undef;
> my $flavour =3D $#ARGV >=3D 0 && $ARGV[0] !~ m|\.| ? shift : undef;
>=20
> $output and open STDOUT,">$output";
>=20
> my $code=3D<<___;
> #include <linux/cfi_types.h>
>=20
> .text
> +.option arch, +zvknhb, +zvkb
> ___
>=20
> my ($V0, $V1, $V2, $V3, $V4, $V5, $V6, $V7,
>     $V8, $V9, $V10, $V11, $V12, $V13, $V14, $V15,
>     $V16, $V17, $V18, $V19, $V20, $V21, $V22, $V23,
>     $V24, $V25, $V26, $V27, $V28, $V29, $V30, $V31,
> ) =3D map("v$_",(0..31));
>=20
> my $K512 =3D "K512";
>=20
> @@ -115,99 +115,99 @@ L_round_loop:
>     # Decrement length by 1
>     addi $LEN, $LEN, -1
>=20
>     # Keep the current state as we need it later: H' =3D =
H+{a',b',c',...,h'}.
>     vmv.v.v $V26, $V22
>     vmv.v.v $V28, $V24
>=20
>     # Load the 1024-bits of the message block in v10-v16 and perform =
the endian
>     # swap.
>     vle64.v $V10, ($INP)
> -    @{[vrev8_v $V10, $V10]}
> +    vrev8.v $V10, $V10
>     addi $INP, $INP, 32
>     vle64.v $V12, ($INP)
> -    @{[vrev8_v $V12, $V12]}
> +    vrev8.v $V12, $V12
>     addi $INP, $INP, 32
>     vle64.v $V14, ($INP)
> -    @{[vrev8_v $V14, $V14]}
> +    vrev8.v $V14, $V14
>     addi $INP, $INP, 32
>     vle64.v $V16, ($INP)
> -    @{[vrev8_v $V16, $V16]}
> +    vrev8.v $V16, $V16
>     addi $INP, $INP, 32
>=20
>     .rept 4
>     # Quad-round 0 (+0, v10->v12->v14->v16)
>     vle64.v $V20, ($KT)
>     addi $KT, $KT, 32
>     vadd.vv $V18, $V20, $V10
> -    @{[vsha2cl_vv $V24, $V22, $V18]}
> -    @{[vsha2ch_vv $V22, $V24, $V18]}
> +    vsha2cl.vv $V24, $V22, $V18
> +    vsha2ch.vv $V22, $V24, $V18
>     vmerge.vvm $V18, $V14, $V12, $V0
> -    @{[vsha2ms_vv $V10, $V18, $V16]}
> +    vsha2ms.vv $V10, $V18, $V16
>=20
>     # Quad-round 1 (+1, v12->v14->v16->v10)
>     vle64.v $V20, ($KT)
>     addi $KT, $KT, 32
>     vadd.vv $V18, $V20, $V12
> -    @{[vsha2cl_vv $V24, $V22, $V18]}
> -    @{[vsha2ch_vv $V22, $V24, $V18]}
> +    vsha2cl.vv $V24, $V22, $V18
> +    vsha2ch.vv $V22, $V24, $V18
>     vmerge.vvm $V18, $V16, $V14, $V0
> -    @{[vsha2ms_vv $V12, $V18, $V10]}
> +    vsha2ms.vv $V12, $V18, $V10
>=20
>     # Quad-round 2 (+2, v14->v16->v10->v12)
>     vle64.v $V20, ($KT)
>     addi $KT, $KT, 32
>     vadd.vv $V18, $V20, $V14
> -    @{[vsha2cl_vv $V24, $V22, $V18]}
> -    @{[vsha2ch_vv $V22, $V24, $V18]}
> +    vsha2cl.vv $V24, $V22, $V18
> +    vsha2ch.vv $V22, $V24, $V18
>     vmerge.vvm $V18, $V10, $V16, $V0
> -    @{[vsha2ms_vv $V14, $V18, $V12]}
> +    vsha2ms.vv $V14, $V18, $V12
>=20
>     # Quad-round 3 (+3, v16->v10->v12->v14)
>     vle64.v $V20, ($KT)
>     addi $KT, $KT, 32
>     vadd.vv $V18, $V20, $V16
> -    @{[vsha2cl_vv $V24, $V22, $V18]}
> -    @{[vsha2ch_vv $V22, $V24, $V18]}
> +    vsha2cl.vv $V24, $V22, $V18
> +    vsha2ch.vv $V22, $V24, $V18
>     vmerge.vvm $V18, $V12, $V10, $V0
> -    @{[vsha2ms_vv $V16, $V18, $V14]}
> +    vsha2ms.vv $V16, $V18, $V14
>     .endr
>=20
>     # Quad-round 16 (+0, v10->v12->v14->v16)
>     # Note that we stop generating new message schedule words (Wt, =
v10-16)
>     # as we already generated all the words we end up consuming (i.e., =
W[79:76]).
>     vle64.v $V20, ($KT)
>     addi $KT, $KT, 32
>     vadd.vv $V18, $V20, $V10
> -    @{[vsha2cl_vv $V24, $V22, $V18]}
> -    @{[vsha2ch_vv $V22, $V24, $V18]}
> +    vsha2cl.vv $V24, $V22, $V18
> +    vsha2ch.vv $V22, $V24, $V18
>=20
>     # Quad-round 17 (+1, v12->v14->v16->v10)
>     vle64.v $V20, ($KT)
>     addi $KT, $KT, 32
>     vadd.vv $V18, $V20, $V12
> -    @{[vsha2cl_vv $V24, $V22, $V18]}
> -    @{[vsha2ch_vv $V22, $V24, $V18]}
> +    vsha2cl.vv $V24, $V22, $V18
> +    vsha2ch.vv $V22, $V24, $V18
>=20
>     # Quad-round 18 (+2, v14->v16->v10->v12)
>     vle64.v $V20, ($KT)
>     addi $KT, $KT, 32
>     vadd.vv $V18, $V20, $V14
> -    @{[vsha2cl_vv $V24, $V22, $V18]}
> -    @{[vsha2ch_vv $V22, $V24, $V18]}
> +    vsha2cl.vv $V24, $V22, $V18
> +    vsha2ch.vv $V22, $V24, $V18
>=20
>     # Quad-round 19 (+3, v16->v10->v12->v14)
>     vle64.v $V20, ($KT)
>     # No t1 increment needed.
>     vadd.vv $V18, $V20, $V16
> -    @{[vsha2cl_vv $V24, $V22, $V18]}
> -    @{[vsha2ch_vv $V22, $V24, $V18]}
> +    vsha2cl.vv $V24, $V22, $V18
> +    vsha2ch.vv $V22, $V24, $V18
>=20
>     # H' =3D H+{a',b',c',...,h'}
>     vadd.vv $V22, $V26, $V22
>     vadd.vv $V24, $V28, $V24
>     bnez $LEN, L_round_loop
>=20
>     # Store {f,e,b,a},{h,g,d,c} back to {a,b,c,d},{e,f,g,h}.
>     vsuxei8.v $V22, ($H), $V1
>     vsuxei8.v $V24, ($H2), $V1
>=20
> diff --git a/arch/riscv/crypto/sm3-riscv64-zvksh.pl =
b/arch/riscv/crypto/sm3-riscv64-zvksh.pl
> index 6a2399d3a5cf..c94c99111a71 100644
> --- a/arch/riscv/crypto/sm3-riscv64-zvksh.pl
> +++ b/arch/riscv/crypto/sm3-riscv64-zvksh.pl
> @@ -33,195 +33,195 @@
> # SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
> # LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF =
USE,
> # DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON =
ANY
> # THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
> # (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE =
USE
> # OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
>=20
> # The generated code of this file depends on the following RISC-V =
extensions:
> # - RV64I
> # - RISC-V Vector ('V') with VLEN >=3D 128
> -# - RISC-V Vector Cryptography Bit-manipulation extension ('Zvkb')
> # - RISC-V Vector SM3 Secure Hash extension ('Zvksh')
> +# - RISC-V Vector Cryptography Bit-manipulation extension ('Zvkb')
>=20
> use strict;
> use warnings;
>=20
> use FindBin qw($Bin);
> use lib "$Bin";
> use lib "$Bin/../../perlasm";
> -use riscv;
>=20
> # $output is the last argument if it looks like a file (it has an =
extension)
> # $flavour is the first argument if it doesn't look like a file
> my $output =3D $#ARGV >=3D 0 && $ARGV[$#ARGV] =3D~ m|\.\w+$| ? pop : =
undef;
> my $flavour =3D $#ARGV >=3D 0 && $ARGV[0] !~ m|\.| ? shift : undef;
>=20
> $output and open STDOUT,">$output";
>=20
> my $code=3D<<___;
> #include <linux/cfi_types.h>
>=20
> .text
> +.option arch, +zvksh, +zvkb
> ___
>=20
> =
##########################################################################=
######
> # ossl_hwsm3_block_data_order_zvksh(SM3_CTX *c, const void *p, size_t =
num);
> {
> my ($CTX, $INPUT, $NUM) =3D ("a0", "a1", "a2");
> my ($V0, $V1, $V2, $V3, $V4, $V5, $V6, $V7,
>     $V8, $V9, $V10, $V11, $V12, $V13, $V14, $V15,
>     $V16, $V17, $V18, $V19, $V20, $V21, $V22, $V23,
>     $V24, $V25, $V26, $V27, $V28, $V29, $V30, $V31,
> ) =3D map("v$_",(0..31));
>=20
> $code .=3D <<___;
> SYM_TYPED_FUNC_START(ossl_hwsm3_block_data_order_zvksh)
>     vsetivli zero, 8, e32, m2, ta, ma
>=20
>     # Load initial state of hash context (c->A-H).
>     vle32.v $V0, ($CTX)
> -    @{[vrev8_v $V0, $V0]}
> +    vrev8.v $V0, $V0
>=20
> L_sm3_loop:
>     # Copy the previous state to v2.
>     # It will be XOR'ed with the current state at the end of the =
round.
>     vmv.v.v $V2, $V0
>=20
>     # Load the 64B block in 2x32B chunks.
>     vle32.v $V6, ($INPUT) # v6 :=3D {w7, ..., w0}
>     addi $INPUT, $INPUT, 32
>=20
>     vle32.v $V8, ($INPUT) # v8 :=3D {w15, ..., w8}
>     addi $INPUT, $INPUT, 32
>=20
>     addi $NUM, $NUM, -1
>=20
>     # As vsm3c consumes only w0, w1, w4, w5 we need to slide the input
>     # 2 elements down so we process elements w2, w3, w6, w7
>     # This will be repeated for each odd round.
>     vslidedown.vi $V4, $V6, 2 # v4 :=3D {X, X, w7, ..., w2}
>=20
> -    @{[vsm3c_vi $V0, $V6, 0]}
> -    @{[vsm3c_vi $V0, $V4, 1]}
> +    vsm3c.vi $V0, $V6, 0
> +    vsm3c.vi $V0, $V4, 1
>=20
>     # Prepare a vector with {w11, ..., w4}
>     vslidedown.vi $V4, $V4, 2 # v4 :=3D {X, X, X, X, w7, ..., w4}
>     vslideup.vi $V4, $V8, 4   # v4 :=3D {w11, w10, w9, w8, w7, w6, w5, =
w4}
>=20
> -    @{[vsm3c_vi $V0, $V4, 2]}
> +    vsm3c.vi $V0, $V4, 2
>     vslidedown.vi $V4, $V4, 2 # v4 :=3D {X, X, w11, w10, w9, w8, w7, =
w6}
> -    @{[vsm3c_vi $V0, $V4, 3]}
> +    vsm3c.vi $V0, $V4, 3
>=20
> -    @{[vsm3c_vi $V0, $V8, 4]}
> +    vsm3c.vi $V0, $V8, 4
>     vslidedown.vi $V4, $V8, 2 # v4 :=3D {X, X, w15, w14, w13, w12, =
w11, w10}
> -    @{[vsm3c_vi $V0, $V4, 5]}
> +    vsm3c.vi $V0, $V4, 5
>=20
> -    @{[vsm3me_vv $V6, $V8, $V6]}   # v6 :=3D {w23, w22, w21, w20, =
w19, w18, w17, w16}
> +    vsm3me.vv $V6, $V8, $V6   # v6 :=3D {w23, w22, w21, w20, w19, =
w18, w17, w16}
>=20
>     # Prepare a register with {w19, w18, w17, w16, w15, w14, w13, w12}
>     vslidedown.vi $V4, $V4, 2 # v4 :=3D {X, X, X, X, w15, w14, w13, =
w12}
>     vslideup.vi $V4, $V6, 4   # v4 :=3D {w19, w18, w17, w16, w15, w14, =
w13, w12}
>=20
> -    @{[vsm3c_vi $V0, $V4, 6]}
> +    vsm3c.vi $V0, $V4, 6
>     vslidedown.vi $V4, $V4, 2 # v4 :=3D {X, X, w19, w18, w17, w16, =
w15, w14}
> -    @{[vsm3c_vi $V0, $V4, 7]}
> +    vsm3c.vi $V0, $V4, 7
>=20
> -    @{[vsm3c_vi $V0, $V6, 8]}
> +    vsm3c.vi $V0, $V6, 8
>     vslidedown.vi $V4, $V6, 2 # v4 :=3D {X, X, w23, w22, w21, w20, =
w19, w18}
> -    @{[vsm3c_vi $V0, $V4, 9]}
> +    vsm3c.vi $V0, $V4, 9
>=20
> -    @{[vsm3me_vv $V8, $V6, $V8]}   # v8 :=3D {w31, w30, w29, w28, =
w27, w26, w25, w24}
> +    vsm3me.vv $V8, $V6, $V8   # v8 :=3D {w31, w30, w29, w28, w27, =
w26, w25, w24}
>=20
>     # Prepare a register with {w27, w26, w25, w24, w23, w22, w21, w20}
>     vslidedown.vi $V4, $V4, 2 # v4 :=3D {X, X, X, X, w23, w22, w21, =
w20}
>     vslideup.vi $V4, $V8, 4   # v4 :=3D {w27, w26, w25, w24, w23, w22, =
w21, w20}
>=20
> -    @{[vsm3c_vi $V0, $V4, 10]}
> +    vsm3c.vi $V0, $V4, 10
>     vslidedown.vi $V4, $V4, 2 # v4 :=3D {X, X, w27, w26, w25, w24, =
w23, w22}
> -    @{[vsm3c_vi $V0, $V4, 11]}
> +    vsm3c.vi $V0, $V4, 11
>=20
> -    @{[vsm3c_vi $V0, $V8, 12]}
> +    vsm3c.vi $V0, $V8, 12
>     vslidedown.vi $V4, $V8, 2 # v4 :=3D {x, X, w31, w30, w29, w28, =
w27, w26}
> -    @{[vsm3c_vi $V0, $V4, 13]}
> +    vsm3c.vi $V0, $V4, 13
>=20
> -    @{[vsm3me_vv $V6, $V8, $V6]}   # v6 :=3D {w32, w33, w34, w35, =
w36, w37, w38, w39}
> +    vsm3me.vv $V6, $V8, $V6   # v6 :=3D {w32, w33, w34, w35, w36, =
w37, w38, w39}
>=20
>     # Prepare a register with {w35, w34, w33, w32, w31, w30, w29, w28}
>     vslidedown.vi $V4, $V4, 2 # v4 :=3D {X, X, X, X, w31, w30, w29, =
w28}
>     vslideup.vi $V4, $V6, 4   # v4 :=3D {w35, w34, w33, w32, w31, w30, =
w29, w28}
>=20
> -    @{[vsm3c_vi $V0, $V4, 14]}
> +    vsm3c.vi $V0, $V4, 14
>     vslidedown.vi $V4, $V4, 2 # v4 :=3D {X, X, w35, w34, w33, w32, =
w31, w30}
> -    @{[vsm3c_vi $V0, $V4, 15]}
> +    vsm3c.vi $V0, $V4, 15
>=20
> -    @{[vsm3c_vi $V0, $V6, 16]}
> +    vsm3c.vi $V0, $V6, 16
>     vslidedown.vi $V4, $V6, 2 # v4 :=3D {X, X, w39, w38, w37, w36, =
w35, w34}
> -    @{[vsm3c_vi $V0, $V4, 17]}
> +    vsm3c.vi $V0, $V4, 17
>=20
> -    @{[vsm3me_vv $V8, $V6, $V8]}   # v8 :=3D {w47, w46, w45, w44, =
w43, w42, w41, w40}
> +    vsm3me.vv $V8, $V6, $V8   # v8 :=3D {w47, w46, w45, w44, w43, =
w42, w41, w40}
>=20
>     # Prepare a register with {w43, w42, w41, w40, w39, w38, w37, w36}
>     vslidedown.vi $V4, $V4, 2 # v4 :=3D {X, X, X, X, w39, w38, w37, =
w36}
>     vslideup.vi $V4, $V8, 4   # v4 :=3D {w43, w42, w41, w40, w39, w38, =
w37, w36}
>=20
> -    @{[vsm3c_vi $V0, $V4, 18]}
> +    vsm3c.vi $V0, $V4, 18
>     vslidedown.vi $V4, $V4, 2 # v4 :=3D {X, X, w43, w42, w41, w40, =
w39, w38}
> -    @{[vsm3c_vi $V0, $V4, 19]}
> +    vsm3c.vi $V0, $V4, 19
>=20
> -    @{[vsm3c_vi $V0, $V8, 20]}
> +    vsm3c.vi $V0, $V8, 20
>     vslidedown.vi $V4, $V8, 2 # v4 :=3D {X, X, w47, w46, w45, w44, =
w43, w42}
> -    @{[vsm3c_vi $V0, $V4, 21]}
> +    vsm3c.vi $V0, $V4, 21
>=20
> -    @{[vsm3me_vv $V6, $V8, $V6]}   # v6 :=3D {w55, w54, w53, w52, =
w51, w50, w49, w48}
> +    vsm3me.vv $V6, $V8, $V6   # v6 :=3D {w55, w54, w53, w52, w51, =
w50, w49, w48}
>=20
>     # Prepare a register with {w51, w50, w49, w48, w47, w46, w45, w44}
>     vslidedown.vi $V4, $V4, 2 # v4 :=3D {X, X, X, X, w47, w46, w45, =
w44}
>     vslideup.vi $V4, $V6, 4   # v4 :=3D {w51, w50, w49, w48, w47, w46, =
w45, w44}
>=20
> -    @{[vsm3c_vi $V0, $V4, 22]}
> +    vsm3c.vi $V0, $V4, 22
>     vslidedown.vi $V4, $V4, 2 # v4 :=3D {X, X, w51, w50, w49, w48, =
w47, w46}
> -    @{[vsm3c_vi $V0, $V4, 23]}
> +    vsm3c.vi $V0, $V4, 23
>=20
> -    @{[vsm3c_vi $V0, $V6, 24]}
> +    vsm3c.vi $V0, $V6, 24
>     vslidedown.vi $V4, $V6, 2 # v4 :=3D {X, X, w55, w54, w53, w52, =
w51, w50}
> -    @{[vsm3c_vi $V0, $V4, 25]}
> +    vsm3c.vi $V0, $V4, 25
>=20
> -    @{[vsm3me_vv $V8, $V6, $V8]}   # v8 :=3D {w63, w62, w61, w60, =
w59, w58, w57, w56}
> +    vsm3me.vv $V8, $V6, $V8   # v8 :=3D {w63, w62, w61, w60, w59, =
w58, w57, w56}
>=20
>     # Prepare a register with {w59, w58, w57, w56, w55, w54, w53, w52}
>     vslidedown.vi $V4, $V4, 2 # v4 :=3D {X, X, X, X, w55, w54, w53, =
w52}
>     vslideup.vi $V4, $V8, 4   # v4 :=3D {w59, w58, w57, w56, w55, w54, =
w53, w52}
>=20
> -    @{[vsm3c_vi $V0, $V4, 26]}
> +    vsm3c.vi $V0, $V4, 26
>     vslidedown.vi $V4, $V4, 2 # v4 :=3D {X, X, w59, w58, w57, w56, =
w55, w54}
> -    @{[vsm3c_vi $V0, $V4, 27]}
> +    vsm3c.vi $V0, $V4, 27
>=20
> -    @{[vsm3c_vi $V0, $V8, 28]}
> +    vsm3c.vi $V0, $V8, 28
>     vslidedown.vi $V4, $V8, 2 # v4 :=3D {X, X, w63, w62, w61, w60, =
w59, w58}
> -    @{[vsm3c_vi $V0, $V4, 29]}
> +    vsm3c.vi $V0, $V4, 29
>=20
> -    @{[vsm3me_vv $V6, $V8, $V6]}   # v6 :=3D {w71, w70, w69, w68, =
w67, w66, w65, w64}
> +    vsm3me.vv $V6, $V8, $V6   # v6 :=3D {w71, w70, w69, w68, w67, =
w66, w65, w64}
>=20
>     # Prepare a register with {w67, w66, w65, w64, w63, w62, w61, w60}
>     vslidedown.vi $V4, $V4, 2 # v4 :=3D {X, X, X, X, w63, w62, w61, =
w60}
>     vslideup.vi $V4, $V6, 4   # v4 :=3D {w67, w66, w65, w64, w63, w62, =
w61, w60}
>=20
> -    @{[vsm3c_vi $V0, $V4, 30]}
> +    vsm3c.vi $V0, $V4, 30
>     vslidedown.vi $V4, $V4, 2 # v4 :=3D {X, X, w67, w66, w65, w64, =
w63, w62}
> -    @{[vsm3c_vi $V0, $V4, 31]}
> +    vsm3c.vi $V0, $V4, 31
>=20
>     # XOR in the previous state.
>     vxor.vv $V0, $V0, $V2
>=20
>     bnez $NUM, L_sm3_loop     # Check if there are any more block to =
process
> L_sm3_end:
> -    @{[vrev8_v $V0, $V0]}
> +    vrev8.v $V0, $V0
>     vse32.v $V0, ($CTX)
>     ret
> SYM_FUNC_END(ossl_hwsm3_block_data_order_zvksh)
> ___
> }
>=20
> print $code;
>=20
> close STDOUT or die "error closing STDOUT: $!";
> diff --git a/arch/riscv/crypto/sm4-riscv64-zvksed.pl =
b/arch/riscv/crypto/sm4-riscv64-zvksed.pl
> index 5669a3b38944..1873160aac2f 100644
> --- a/arch/riscv/crypto/sm4-riscv64-zvksed.pl
> +++ b/arch/riscv/crypto/sm4-riscv64-zvksed.pl
> @@ -33,40 +33,40 @@
> # SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
> # LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF =
USE,
> # DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON =
ANY
> # THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
> # (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE =
USE
> # OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
>=20
> # The generated code of this file depends on the following RISC-V =
extensions:
> # - RV64I
> # - RISC-V Vector ('V') with VLEN >=3D 128
> -# - RISC-V Vector Cryptography Bit-manipulation extension ('Zvkb')
> # - RISC-V Vector SM4 Block Cipher extension ('Zvksed')
> +# - RISC-V Vector Cryptography Bit-manipulation extension ('Zvkb')
>=20
> use strict;
> use warnings;
>=20
> use FindBin qw($Bin);
> use lib "$Bin";
> use lib "$Bin/../../perlasm";
> -use riscv;
>=20
> # $output is the last argument if it looks like a file (it has an =
extension)
> # $flavour is the first argument if it doesn't look like a file
> my $output =3D $#ARGV >=3D 0 && $ARGV[$#ARGV] =3D~ m|\.\w+$| ? pop : =
undef;
> my $flavour =3D $#ARGV >=3D 0 && $ARGV[0] !~ m|\.| ? shift : undef;
>=20
> $output and open STDOUT,">$output";
>=20
> my $code=3D<<___;
> .text
> +.option arch, +zvksed, +zvkb
> ___
>=20
> ####
> # int rv64i_zvksed_sm4_set_key(const u8 *user_key, unsigned int =
key_len,
> #			                         u32 *enc_key, u32 =
*dec_key);
> #
> {
> my ($ukey,$key_len,$enc_key,$dec_key)=3D("a0","a1","a2","a3");
> my ($fk,$stride)=3D("a4","a5");
> my ($t0,$t1)=3D("t0","t1");
> @@ -79,36 +79,36 @@ rv64i_zvksed_sm4_set_key:
>     li $t0, 16
>     beq $t0, $key_len, 1f
>     li a0, 1
>     ret
> 1:
>=20
>     vsetivli zero, 4, e32, m1, ta, ma
>=20
>     # Load the user key
>     vle32.v $vukey, ($ukey)
> -    @{[vrev8_v $vukey, $vukey]}
> +    vrev8.v $vukey, $vukey
>=20
>     # Load the FK.
>     la $fk, FK
>     vle32.v $vfk, ($fk)
>=20
>     # Generate round keys.
>     vxor.vv $vukey, $vukey, $vfk
> -    @{[vsm4k_vi $vk0, $vukey, 0]} # rk[0:3]
> -    @{[vsm4k_vi $vk1, $vk0, 1]} # rk[4:7]
> -    @{[vsm4k_vi $vk2, $vk1, 2]} # rk[8:11]
> -    @{[vsm4k_vi $vk3, $vk2, 3]} # rk[12:15]
> -    @{[vsm4k_vi $vk4, $vk3, 4]} # rk[16:19]
> -    @{[vsm4k_vi $vk5, $vk4, 5]} # rk[20:23]
> -    @{[vsm4k_vi $vk6, $vk5, 6]} # rk[24:27]
> -    @{[vsm4k_vi $vk7, $vk6, 7]} # rk[28:31]
> +    vsm4k.vi $vk0, $vukey, 0 # rk[0:3]
> +    vsm4k.vi $vk1, $vk0, 1 # rk[4:7]
> +    vsm4k.vi $vk2, $vk1, 2 # rk[8:11]
> +    vsm4k.vi $vk3, $vk2, 3 # rk[12:15]
> +    vsm4k.vi $vk4, $vk3, 4 # rk[16:19]
> +    vsm4k.vi $vk5, $vk4, 5 # rk[20:23]
> +    vsm4k.vi $vk6, $vk5, 6 # rk[24:27]
> +    vsm4k.vi $vk7, $vk6, 7 # rk[28:31]
>=20
>     # Store enc round keys
>     vse32.v $vk0, ($enc_key) # rk[0:3]
>     addi $enc_key, $enc_key, 16
>     vse32.v $vk1, ($enc_key) # rk[4:7]
>     addi $enc_key, $enc_key, 16
>     vse32.v $vk2, ($enc_key) # rk[8:11]
>     addi $enc_key, $enc_key, 16
>     vse32.v $vk3, ($enc_key) # rk[12:15]
>     addi $enc_key, $enc_key, 16
> @@ -154,50 +154,50 @@ my =
($in,$out,$keys,$stride)=3D("a0","a1","a2","t0");
> my =
($vdata,$vk0,$vk1,$vk2,$vk3,$vk4,$vk5,$vk6,$vk7,$vgen)=3D("v1","v2","v3","=
v4","v5","v6","v7","v8","v9","v10");
> $code .=3D <<___;
> .p2align 3
> .globl rv64i_zvksed_sm4_encrypt
> .type rv64i_zvksed_sm4_encrypt,\@function
> rv64i_zvksed_sm4_encrypt:
>     vsetivli zero, 4, e32, m1, ta, ma
>=20
>     # Load input data
>     vle32.v $vdata, ($in)
> -    @{[vrev8_v $vdata, $vdata]}
> +    vrev8.v $vdata, $vdata
>=20
>     # Order of elements was adjusted in sm4_set_key()
>     # Encrypt with all keys
>     vle32.v $vk0, ($keys) # rk[0:3]
> -    @{[vsm4r_vs $vdata, $vk0]}
> +    vsm4r.vs $vdata, $vk0
>     addi $keys, $keys, 16
>     vle32.v $vk1, ($keys) # rk[4:7]
> -    @{[vsm4r_vs $vdata, $vk1]}
> +    vsm4r.vs $vdata, $vk1
>     addi $keys, $keys, 16
>     vle32.v $vk2, ($keys) # rk[8:11]
> -    @{[vsm4r_vs $vdata, $vk2]}
> +    vsm4r.vs $vdata, $vk2
>     addi $keys, $keys, 16
>     vle32.v $vk3, ($keys) # rk[12:15]
> -    @{[vsm4r_vs $vdata, $vk3]}
> +    vsm4r.vs $vdata, $vk3
>     addi $keys, $keys, 16
>     vle32.v $vk4, ($keys) # rk[16:19]
> -    @{[vsm4r_vs $vdata, $vk4]}
> +    vsm4r.vs $vdata, $vk4
>     addi $keys, $keys, 16
>     vle32.v $vk5, ($keys) # rk[20:23]
> -    @{[vsm4r_vs $vdata, $vk5]}
> +    vsm4r.vs $vdata, $vk5
>     addi $keys, $keys, 16
>     vle32.v $vk6, ($keys) # rk[24:27]
> -    @{[vsm4r_vs $vdata, $vk6]}
> +    vsm4r.vs $vdata, $vk6
>     addi $keys, $keys, 16
>     vle32.v $vk7, ($keys) # rk[28:31]
> -    @{[vsm4r_vs $vdata, $vk7]}
> +    vsm4r.vs $vdata, $vk7
>=20
>     # Save the ciphertext (in reverse element order)
> -    @{[vrev8_v $vdata, $vdata]}
> +    vrev8.v $vdata, $vdata
>     li $stride, -4
>     addi $out, $out, 12
>     vsse32.v $vdata, ($out), $stride
>=20
>     ret
> .size rv64i_zvksed_sm4_encrypt,.-rv64i_zvksed_sm4_encrypt
> ___
> }
>=20
> ####
> @@ -209,50 +209,50 @@ my =
($in,$out,$keys,$stride)=3D("a0","a1","a2","t0");
> my =
($vdata,$vk0,$vk1,$vk2,$vk3,$vk4,$vk5,$vk6,$vk7,$vgen)=3D("v1","v2","v3","=
v4","v5","v6","v7","v8","v9","v10");
> $code .=3D <<___;
> .p2align 3
> .globl rv64i_zvksed_sm4_decrypt
> .type rv64i_zvksed_sm4_decrypt,\@function
> rv64i_zvksed_sm4_decrypt:
>     vsetivli zero, 4, e32, m1, ta, ma
>=20
>     # Load input data
>     vle32.v $vdata, ($in)
> -    @{[vrev8_v $vdata, $vdata]}
> +    vrev8.v $vdata, $vdata
>=20
>     # Order of key elements was adjusted in sm4_set_key()
>     # Decrypt with all keys
>     vle32.v $vk7, ($keys) # rk[31:28]
> -    @{[vsm4r_vs $vdata, $vk7]}
> +    vsm4r.vs $vdata, $vk7
>     addi $keys, $keys, 16
>     vle32.v $vk6, ($keys) # rk[27:24]
> -    @{[vsm4r_vs $vdata, $vk6]}
> +    vsm4r.vs $vdata, $vk6
>     addi $keys, $keys, 16
>     vle32.v $vk5, ($keys) # rk[23:20]
> -    @{[vsm4r_vs $vdata, $vk5]}
> +    vsm4r.vs $vdata, $vk5
>     addi $keys, $keys, 16
>     vle32.v $vk4, ($keys) # rk[19:16]
> -    @{[vsm4r_vs $vdata, $vk4]}
> +    vsm4r.vs $vdata, $vk4
>     addi $keys, $keys, 16
>     vle32.v $vk3, ($keys) # rk[15:11]
> -    @{[vsm4r_vs $vdata, $vk3]}
> +    vsm4r.vs $vdata, $vk3
>     addi $keys, $keys, 16
>     vle32.v $vk2, ($keys) # rk[11:8]
> -    @{[vsm4r_vs $vdata, $vk2]}
> +    vsm4r.vs $vdata, $vk2
>     addi $keys, $keys, 16
>     vle32.v $vk1, ($keys) # rk[7:4]
> -    @{[vsm4r_vs $vdata, $vk1]}
> +    vsm4r.vs $vdata, $vk1
>     addi $keys, $keys, 16
>     vle32.v $vk0, ($keys) # rk[3:0]
> -    @{[vsm4r_vs $vdata, $vk0]}
> +    vsm4r.vs $vdata, $vk0
>=20
>     # Save the ciphertext (in reverse element order)
> -    @{[vrev8_v $vdata, $vdata]}
> +    vrev8.v $vdata, $vdata
>     li $stride, -4
>     addi $out, $out, 12
>     vsse32.v $vdata, ($out), $stride
>=20
>     ret
> .size rv64i_zvksed_sm4_decrypt,.-rv64i_zvksed_sm4_decrypt
> ___
> }
>=20
> $code .=3D <<___;
>=20
> base-commit: bf929f50c3e8266870edc365a62c6d5fe5f66d36
> --=20
> 2.43.0
>=20

