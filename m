Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04FF814E2E9;
	Fri, 30 Aug 2024 17:51:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725040317; cv=none; b=MG6KmruHkZfiCwhxfW2tZVl7ldzE3ebpXiMVVj8UhkrQ6umnNZsoEH/x9G2XJTBGciehsDS/apfsfMgsWCs4y4WlpCyhcWFXrq7I46ztTERyrmrRjsHdRLRFntUpP5enK4mjZVgnXTsN8RHHaX8lYJ/RJGULzsx09TS/XhRlMh8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725040317; c=relaxed/simple;
	bh=uWhMmjJ50H1qYWLeYvBQd6Nv7WH9zgHdxdtD0x/kJv8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GbdOMHFlWjFPbzDxnnR33T+su+XS18wjor7mZmdgvUSUyYb/uxRc6ytj0NYD5QCNhVmlHMWayjrbxacvjkE+Qsitg+n/Lk/fypBiY3ik9Qgs3p1MyCfF7c96SuL+SNNHXcTk8NSNBwTvghCaxJDfXIfMGaLuUwGOUlUH5DCJZng=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lRgzNm8+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lRgzNm8+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F24AC4CEC2;
	Fri, 30 Aug 2024 17:51:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1725040316;
	bh=uWhMmjJ50H1qYWLeYvBQd6Nv7WH9zgHdxdtD0x/kJv8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=lRgzNm8+2G8pziDOMsiYugWgkPs3lXCnFeOZogB2bmerJAFS9ATZvAU8Z0LncZdq8
	 +Y9jqkfu43WNnJ9SzKGrlfsatf6adScShb6fEHaLPjljMxUEc6jXfMYMv/eQcJE2sw
	 zBAtitYvz+WV/aUZjNrXJZ3+IJ7xVsGEg9gY6QGfWBSvVslPRuTNq9is9BkxQtccTC
	 Y/evok2+IS081uo4qn941Gc87BEoBnsvLznvdeY8eyaVh6qx5kuG5jkzPG3qyV1gMS
	 frgFuWmkUbGn6t6HK68/vUqeV3fBNdtl6Ku79+5H4S0L7w77k4C/Y/CBpSkwjtcbUQ
	 Y0PvzhYWctVPQ==
Date: Fri, 30 Aug 2024 10:51:54 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: kernel test robot <oliver.sang@intel.com>, oe-lkp@lists.linux.dev,
	lkp@intel.com, linux-crypto@vger.kernel.org, ltp@lists.linux.it,
	Linus Torvalds <torvalds@linux-foundation.org>,
	"Russell King (Oracle)" <linux@armlinux.org.uk>,
	Horia =?utf-8?Q?Geant=C4=83?= <horia.geanta@nxp.com>,
	Ard Biesheuvel <ardb@kernel.org>,
	"David S. Miller" <davem@davemloft.net>
Subject: Re: [v3 PATCH 3/3] crypto: simd - Do not call crypto_alloc_tfm
 during registration
Message-ID: <20240830175154.GA48019@sol.localdomain>
References: <ZrbTUk6DyktnO7qk@gondor.apana.org.au>
 <202408161634.598311fd-oliver.sang@intel.com>
 <ZsBJs_C6GdO_qgV7@gondor.apana.org.au>
 <ZsBJ5H4JExArHGVw@gondor.apana.org.au>
 <ZsBKG0la0m69Dyq3@gondor.apana.org.au>
 <20240827184839.GD2049@sol.localdomain>
 <Zs6SiBOdasO9Thd1@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Zs6SiBOdasO9Thd1@gondor.apana.org.au>

On Wed, Aug 28, 2024 at 10:59:20AM +0800, Herbert Xu wrote:
> On Tue, Aug 27, 2024 at 11:48:39AM -0700, Eric Biggers wrote:
> > On Sat, Aug 17, 2024 at 02:58:35PM +0800, Herbert Xu wrote:
> > > Algorithm registration is usually carried out during module init,
> > > where as little work as possible should be carried out.  The SIMD
> > > code violated this rule by allocating a tfm, this then triggers a
> > > full test of the algorithm which may dead-lock in certain cases.
> > > 
> > > SIMD is only allocating the tfm to get at the alg object, which is
> > > in fact already available as it is what we are registering.  Use
> > > that directly and remove the crypto_alloc_tfm call.
> > > 
> > > Also remove some obsolete and unused SIMD API.
> > > 
> > > Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
> > > ---
> > >  arch/arm/crypto/aes-ce-glue.c     |  2 +-
> > >  arch/arm/crypto/aes-neonbs-glue.c |  2 +-
> > >  crypto/simd.c                     | 76 ++++++-------------------------
> > >  include/crypto/internal/simd.h    | 12 +----
> > >  4 files changed, 19 insertions(+), 73 deletions(-)
> > > 
> > 
> > I'm getting a test failure with this series applied:
> > 
> > [    0.383128] alg: aead: failed to allocate transform for gcm_base(ctr(aes-generic),ghash-generic): -2
> > [    0.383500] alg: self-tests for gcm(aes) using gcm_base(ctr(aes-generic),ghash-generic) failed (rc=-2)
> > 
> > This is on x86_64 with CONFIG_CRYPTO_MANAGER_EXTRA_TESTS=y.
> 
> Could you please send me your config file?
> 
> Thanks,

Given below in defconfig form, use 'make olddefconfig' to apply.  The failures
are nondeterministic and sometimes there are different ones, for example:

[    0.358017] alg: skcipher: failed to allocate transform for cbc(twofish-generic): -2
[    0.358365] alg: self-tests for cbc(twofish) using cbc(twofish-generic) failed (rc=-2)
[    0.358535] alg: skcipher: failed to allocate transform for cbc(camellia-generic): -2
[    0.358918] alg: self-tests for cbc(camellia) using cbc(camellia-generic) failed (rc=-2)
[    0.371533] alg: skcipher: failed to allocate transform for xts(ecb(aes-generic)): -2
[    0.371922] alg: self-tests for xts(aes) using xts(ecb(aes-generic)) failed (rc=-2)

Modules are not enabled, maybe that matters (I haven't checked yet).

CONFIG_SYSVIPC=y
CONFIG_POSIX_MQUEUE=y
CONFIG_NO_HZ=y
CONFIG_HIGH_RES_TIMERS=y
CONFIG_IKCONFIG=y
CONFIG_IKCONFIG_PROC=y
CONFIG_CGROUPS=y
CONFIG_USER_NS=y
CONFIG_BLK_DEV_INITRD=y
CONFIG_SMP=y
CONFIG_X86_X2APIC=y
CONFIG_HYPERVISOR_GUEST=y
CONFIG_PARAVIRT=y
CONFIG_MCORE2=y
CONFIG_NR_CPUS=48
CONFIG_NUMA=y
CONFIG_HZ_300=y
# CONFIG_RANDOMIZE_BASE is not set
CONFIG_IA32_EMULATION=y
CONFIG_JUMP_LABEL=y
CONFIG_NET=y
CONFIG_PACKET=y
CONFIG_PACKET_DIAG=y
CONFIG_UNIX=y
CONFIG_UNIX_DIAG=y
CONFIG_INET=y
CONFIG_PCI=y
CONFIG_PCI_MSI=y
CONFIG_DEVTMPFS=y
CONFIG_BLK_DEV_LOOP=y
CONFIG_VIRTIO_BLK=y
CONFIG_NETDEVICES=y
CONFIG_VIRTIO_NET=y
CONFIG_SERIAL_8250=y
CONFIG_SERIAL_8250_CONSOLE=y
CONFIG_SERIAL_8250_NR_UARTS=32
CONFIG_SERIAL_8250_RUNTIME_UARTS=32
CONFIG_HW_RANDOM_VIRTIO=y
CONFIG_VIRT_DRIVERS=y
CONFIG_VIRTIO_PCI=y
CONFIG_VIRTIO_MMIO=y
CONFIG_EXT4_FS=y
CONFIG_EXT4_FS_POSIX_ACL=y
CONFIG_EXT4_FS_SECURITY=y
CONFIG_AUTOFS_FS=y
CONFIG_TMPFS=y
CONFIG_TMPFS_POSIX_ACL=y
CONFIG_CRYPTO_USER=y
# CONFIG_CRYPTO_MANAGER_DISABLE_TESTS is not set
CONFIG_CRYPTO_MANAGER_EXTRA_TESTS=y
CONFIG_CRYPTO_PCRYPT=y
CONFIG_CRYPTO_DH_RFC7919_GROUPS=y
CONFIG_CRYPTO_ECDH=y
CONFIG_CRYPTO_ECDSA=y
CONFIG_CRYPTO_ECRDSA=y
CONFIG_CRYPTO_CURVE25519=y
CONFIG_CRYPTO_AES_TI=y
CONFIG_CRYPTO_ANUBIS=y
CONFIG_CRYPTO_BLOWFISH=y
CONFIG_CRYPTO_CAMELLIA=y
CONFIG_CRYPTO_DES=y
CONFIG_CRYPTO_FCRYPT=y
CONFIG_CRYPTO_KHAZAD=y
CONFIG_CRYPTO_SEED=y
CONFIG_CRYPTO_TEA=y
CONFIG_CRYPTO_TWOFISH=y
CONFIG_CRYPTO_ADIANTUM=y
CONFIG_CRYPTO_ARC4=y
CONFIG_CRYPTO_HCTR2=y
CONFIG_CRYPTO_KEYWRAP=y
CONFIG_CRYPTO_LRW=y
CONFIG_CRYPTO_PCBC=y
CONFIG_CRYPTO_AEGIS128=y
CONFIG_CRYPTO_SEQIV=y
CONFIG_CRYPTO_ECHAINIV=y
CONFIG_CRYPTO_ESSIV=y
CONFIG_CRYPTO_BLAKE2B=y
CONFIG_CRYPTO_MD4=y
CONFIG_CRYPTO_RMD160=y
CONFIG_CRYPTO_SM3_GENERIC=y
CONFIG_CRYPTO_VMAC=y
CONFIG_CRYPTO_WP512=y
CONFIG_CRYPTO_XXHASH=y
CONFIG_CRYPTO_CRC32=y
CONFIG_CRYPTO_DEFLATE=y
CONFIG_CRYPTO_LZO=y
CONFIG_CRYPTO_842=y
CONFIG_CRYPTO_LZ4=y
CONFIG_CRYPTO_LZ4HC=y
CONFIG_CRYPTO_ZSTD=y
CONFIG_CRYPTO_ANSI_CPRNG=y
CONFIG_CRYPTO_DRBG_HASH=y
CONFIG_CRYPTO_DRBG_CTR=y
CONFIG_CRYPTO_USER_API_HASH=y
CONFIG_CRYPTO_USER_API_SKCIPHER=y
CONFIG_CRYPTO_USER_API_RNG=y
CONFIG_CRYPTO_USER_API_RNG_CAVP=y
CONFIG_CRYPTO_USER_API_AEAD=y
CONFIG_CRYPTO_CURVE25519_X86=y
CONFIG_CRYPTO_AES_NI_INTEL=y
CONFIG_CRYPTO_BLOWFISH_X86_64=y
CONFIG_CRYPTO_CAMELLIA_AESNI_AVX2_X86_64=y
CONFIG_CRYPTO_CAST5_AVX_X86_64=y
CONFIG_CRYPTO_CAST6_AVX_X86_64=y
CONFIG_CRYPTO_DES3_EDE_X86_64=y
CONFIG_CRYPTO_SERPENT_SSE2_X86_64=y
CONFIG_CRYPTO_SERPENT_AVX2_X86_64=y
CONFIG_CRYPTO_SM4_AESNI_AVX2_X86_64=y
CONFIG_CRYPTO_TWOFISH_AVX_X86_64=y
CONFIG_CRYPTO_ARIA_GFNI_AVX512_X86_64=y
CONFIG_CRYPTO_CHACHA20_X86_64=y
CONFIG_CRYPTO_AEGIS128_AESNI_SSE2=y
CONFIG_CRYPTO_NHPOLY1305_SSE2=y
CONFIG_CRYPTO_NHPOLY1305_AVX2=y
CONFIG_CRYPTO_BLAKE2S_X86=y
CONFIG_CRYPTO_POLYVAL_CLMUL_NI=y
CONFIG_CRYPTO_POLY1305_X86_64=y
CONFIG_CRYPTO_SHA1_SSSE3=y
CONFIG_CRYPTO_SHA256_SSSE3=y
CONFIG_CRYPTO_SHA512_SSSE3=y
CONFIG_CRYPTO_SM3_AVX_X86_64=y
CONFIG_CRYPTO_GHASH_CLMUL_NI_INTEL=y
CONFIG_CRYPTO_CRC32C_INTEL=y
CONFIG_CRYPTO_CRC32_PCLMUL=y
CONFIG_CRYPTO_CRCT10DIF_PCLMUL=y
CONFIG_CRYPTO_DEV_PADLOCK=y
CONFIG_CRYPTO_DEV_PADLOCK_AES=y
CONFIG_CRYPTO_DEV_PADLOCK_SHA=y
CONFIG_CRYPTO_DEV_CCP=y
CONFIG_CRYPTO_DEV_NITROX_CNN55XX=y
CONFIG_CRYPTO_DEV_QAT_DH895xCC=y
CONFIG_CRYPTO_DEV_QAT_C3XXX=y
CONFIG_CRYPTO_DEV_QAT_C62X=y
CONFIG_CRYPTO_DEV_QAT_4XXX=y
CONFIG_CRYPTO_DEV_QAT_DH895xCCVF=y
CONFIG_CRYPTO_DEV_QAT_C3XXXVF=y
CONFIG_CRYPTO_DEV_QAT_C62XVF=y
CONFIG_CRYPTO_DEV_VIRTIO=y
CONFIG_CRYPTO_DEV_SAFEXCEL=y
CONFIG_CRYPTO_DEV_AMLOGIC_GXL=y
CONFIG_CRYPTO_DEV_AMLOGIC_GXL_DEBUG=y
CONFIG_CRYPTO_LIB_CURVE25519=y
CONFIG_CRYPTO_LIB_CHACHA20POLY1305=y
CONFIG_CRC_CCITT=y
CONFIG_CRC_T10DIF=y
CONFIG_CRC64_ROCKSOFT=y
CONFIG_CRC_ITU_T=y
CONFIG_CRC32_SELFTEST=y
CONFIG_CRC32_SLICEBY4=y
CONFIG_CRC4=y
CONFIG_CRC7=y
CONFIG_LIBCRC32C=y
CONFIG_PRINTK_TIME=y
CONFIG_DEBUG_KERNEL=y
CONFIG_DEBUG_FS=y
CONFIG_PANIC_TIMEOUT=5
CONFIG_UNWINDER_FRAME_POINTER=y
