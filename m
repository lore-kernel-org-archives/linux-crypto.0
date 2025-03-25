Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BF3C339A8;
	Tue, 25 Mar 2025 05:53:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742882030; cv=none; b=aYIsKI4hmjtjT8/L9I/e0fSQIhEsJS237qTL3u6tz4oYKUIyx6F0tI+I2cg6O4WEm7WkgqRy5Wx0fI67EV+kcMch3AmpL8Z8r5zas03L724Goo9DOQJsiVoOnTTpSmi5SZhrSxiRRuAad1bTDT67W649m9znufpKRsMqMlsPI88=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742882030; c=relaxed/simple;
	bh=6Xptlw8ya71JL7APXXrM6z2pvO9T5D3Vw482Q6FbPTA=;
	h=Date:From:To:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=k1yosoXLzWVvdMl20WP14L0yBbQjQjimDmPoSSKQyqmulfzaiE4hBb66b0DAR58zQ02PXVdeH70/AVgevGNFTT59G/3BeBxDfdZnIV0EYSNmyGY+fe+y3CGtV/0gD+Kv42jH/xXg7KNaLrgKkQX+PnUVWFmaQdgBpq9szZFdTHU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=U//Dksmv; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="U//Dksmv"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Transfer-Encoding:Content-Type:MIME-Version
	:References:Message-ID:Subject:To:From:Date:Sender:Reply-To:Cc:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=59BDoJgHTety04n7OSTDXb38rrBqlwtM/LQZnc3q6No=; b=U//DksmvhPCDnLicnj/aZQcYs6
	2M9wIGDDQ9MQCkeVefJ0pgAaUYfDmjGXAbNL4O2/79iYkF17EVbeqtNJPMA58XZf4NbgcrIiAGHMk
	tE35FFqfOy3O+fjPbu2RQ132wjeDZ/q/9B4osH4ecOFTUf8GM9/fsB83s+ZSVkD18Y30bTAL51nAv
	KDqRdStlOvtHRCKoNmeNXbpxLjuJjyzVsXf8kvk0f9O2POgGN8z81Z1NevI29TNi28h7ItbQn4nVZ
	5dL73xt6q2PgOjlUjmB8H15t6IQxW20ajj9tMJWKieCtudPL8vHNf2aIB/tEz7wI3PKuafTmqyMYO
	hpKDJ86g==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1twxE8-009v1T-2c;
	Tue, 25 Mar 2025 13:53:29 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Tue, 25 Mar 2025 13:53:28 +0800
Date: Tue, 25 Mar 2025 13:53:28 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Linus Torvalds <torvalds@linux-foundation.org>,
	"David S. Miller" <davem@davemloft.net>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Subject: [GIT PULL] Crypto Update for 6.15
Message-ID: <Z-JE2HNY-Tj8qwQw@gondor.apana.org.au>
References: <ZJ0RSuWLwzikFr9r@gondor.apana.org.au>
 <ZOxnTFhchkTvKpZV@gondor.apana.org.au>
 <ZUNIBcBJ0VeZRmT9@gondor.apana.org.au>
 <ZZ3F/Pp1pxkdqfiD@gondor.apana.org.au>
 <ZfO6zKtvp2jSO4vF@gondor.apana.org.au>
 <ZkGN64ulwzPVvn6-@gondor.apana.org.au>
 <ZpkdZopjF9/9/Njx@gondor.apana.org.au>
 <ZuetBbpfq5X8BAwn@gondor.apana.org.au>
 <ZzqyAW2HKeIjGnKa@gondor.apana.org.au>
 <Z5Ijqi4uSDU9noZm@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <Z5Ijqi4uSDU9noZm@gondor.apana.org.au>

Hi Linus:

The following changes since commit 2014c95afecee3e76ca4a56956a936e23283f05b:

  Linux 6.14-rc1 (2025-02-02 15:39:26 -0800)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto-2.6.git v6.15-p1 

for you to fetch changes up to 99585c2192cb1ce212876e82ef01d1c98c7f4699:

  crypto: testmgr - Add multibuffer acomp testing (2025-03-22 07:25:19 +0800)

----------------------------------------------------------------
This update includes the following changes:

API:

- Remove legacy compression interface.
- Improve scatterwalk API.
- Add request chaining to ahash and acomp.
- Add virtual address support to ahash and acomp.
- Add folio support to acomp.
- Remove NULL dst support from acomp.

Algorithms:

- Library options are fuly hidden (selected by kernel users only).
- Add Kerberos5 algorithms.
- Add VAES-based ctr(aes) on x86.
- Ensure LZO respects output buffer length on compression.
- Remove obsolete SIMD fallback code path from arm/ghash-ce.

Drivers:

- Add support for PCI device 0x1134 in ccp.
- Add support for rk3588's standalone TRNG in rockchip.
- Add Inside Secure SafeXcel EIP-93 crypto engine support in eip93.
- Fix bugs in tegra uncovered by multi-threaded self-test.
- Fix corner cases in hisilicon/sec2.

Others:

- Add SG_MITER_LOCAL to sg miter.
- Convert ubifs, hibernate and xfrm_ipcomp from legacy API to acomp.
----------------------------------------------------------------

Abel Vesa (1):
      dt-bindings: crypto: qcom-qce: Document the X1E80100 crypto engine

Abhinaba Rakshit (1):
      dt-bindings: crypto: qcom,prng: document QCS615

Akhil R (10):
      crypto: tegra - Use separate buffer for setkey
      crypto: tegra - Do not use fixed size buffers
      crypto: tegra - finalize crypto req on error
      crypto: tegra - check return value for hash do_one_req
      crypto: tegra - Transfer HASH init function to crypto engine
      crypto: tegra - Fix HASH intermediate result handling
      crypto: tegra - Fix CMAC intermediate result handling
      crypto: tegra - Set IV to NULL explicitly for AES ECB
      crypto: tegra - Reserve keyslots to allocate dynamically
      crypto: tegra - Use HMAC fallback when keyslots are full

Ard Biesheuvel (12):
      crypto: lib/chachapoly - Drop dependency on CRYPTO_ALGAPI
      crypto: nx - Migrate to scomp API
      crypto: 842 - drop obsolete 'comp' implementation
      crypto: deflate - drop obsolete 'comp' implementation
      crypto: lz4 - drop obsolete 'comp' implementation
      crypto: lz4hc - drop obsolete 'comp' implementation
      crypto: lzo-rle - drop obsolete 'comp' implementation
      crypto: lzo - drop obsolete 'comp' implementation
      crypto: zstd - drop obsolete 'comp' implementation
      crypto: cavium/zip - drop obsolete 'comp' implementation
      crypto: compress_null - drop obsolete 'comp' implementation
      crypto: remove obsolete 'comp' compression API

Arnd Bergmann (2):
      crypto: bpf - Add MODULE_DESCRIPTION for skcipher
      crypto: lib/Kconfig - hide library options

Bairavi Alagappan (2):
      crypto: qat - set parity error mask for qat_420xx
      crypto: qat - remove access to parity register for QAT GEN4

Christian Marangi (4):
      spinlock: extend guard with spinlock_bh variants
      dt-bindings: crypto: Add Inside Secure SafeXcel EIP-93 crypto engine
      crypto: eip93 - Add Inside Secure SafeXcel EIP-93 crypto engine support
      crypto: inside-secure/eip93 - Correctly handle return of for sg_nents_for_len

Christophe JAILLET (1):
      crypto: virtio - Erase some sensitive memory when it is freed

David Howells (17):
      crypto/krb5: Add API Documentation
      crypto/krb5: Add some constants out of sunrpc headers
      crypto: Add 'krb5enc' hash and cipher AEAD algorithm
      crypto/krb5: Test manager data
      crypto/krb5: Implement Kerberos crypto core
      crypto/krb5: Add an API to query the layout of the crypto section
      crypto/krb5: Add an API to alloc and prepare a crypto object
      crypto/krb5: Add an API to perform requests
      crypto/krb5: Provide infrastructure and key derivation
      crypto/krb5: Implement the Kerberos5 rfc3961 key derivation
      crypto/krb5: Provide RFC3961 setkey packaging functions
      crypto/krb5: Implement the Kerberos5 rfc3961 encrypt and decrypt functions
      crypto/krb5: Implement the Kerberos5 rfc3961 get_mic and verify_mic
      crypto/krb5: Implement the AES enctypes from rfc3962
      crypto/krb5: Implement the AES enctypes from rfc8009
      crypto/krb5: Implement the Camellia enctypes from rfc6803
      crypto/krb5: Implement crypto self-testing

David Sterba (1):
      MAINTAINERS: add myself to co-maintain ZSTD

Devaraj Rangasamy (1):
      crypto: ccp - Add support for PCI device 0x1134

Dionna Glaze (1):
      crypto: ccp - Fix uAPI definitions of PSP errors

Dr. David Alan Gilbert (3):
      crypto: octeontx2 - Remove unused otx2_cpt_print_uc_dbg_info
      crypto: octeontx - Remove unused function otx_cpt_eng_grp_has_eng_type
      async_xor: Remove unused 'async_xor_val'

Dragan Simic (2):
      hwrng: Kconfig - Use tabs as leading whitespace consistently in Kconfig
      hwrng: Kconfig - Move one "tristate" Kconfig description to the usual place

Eric Biggers (25):
      crypto: x86/aes-xts - make the fast path 64-bit specific
      crypto: x86/aes-ctr - rewrite AESNI+AVX optimized CTR and add VAES support
      crypto: x86/aes-xts - change license to Apache-2.0 OR BSD-2-Clause
      crypto: scatterwalk - move to next sg entry just in time
      crypto: scatterwalk - add new functions for skipping data
      crypto: scatterwalk - add new functions for iterating through data
      crypto: scatterwalk - add new functions for copying data
      crypto: scatterwalk - add scatterwalk_get_sglist()
      crypto: skcipher - use scatterwalk_start_at_pos()
      crypto: aegis - use the new scatterwalk functions
      crypto: arm/ghash - use the new scatterwalk functions
      crypto: arm64 - use the new scatterwalk functions
      crypto: nx - use the new scatterwalk functions
      crypto: s390/aes-gcm - use the new scatterwalk functions
      crypto: s5p-sss - use the new scatterwalk functions
      crypto: stm32 - use the new scatterwalk functions
      crypto: x86/aes-gcm - use the new scatterwalk functions
      crypto: x86/aegis - use the new scatterwalk functions
      net/tls: use the new scatterwalk functions
      crypto: skcipher - use the new scatterwalk functions
      crypto: scatterwalk - remove obsolete functions
      crypto: scatterwalk - don't split at page boundaries when !HIGHMEM
      crypto: skcipher - fix mismatch between mapping and unmapping order
      crypto: scatterwalk - simplify map and unmap calling convention
      crypto: lib/chacha - remove unused arch-specific init support

Ethan Carter Edwards (1):
      crypto: artpec6 - change from kzalloc to kcalloc in artpec6_crypto_probe()

Geert Uytterhoeven (1):
      hwrng: Kconfig - Fix indentation of HW_RANDOM_CN10K help text

Giovanni Cabiddu (3):
      crypto: qat - fix object goals in Makefiles
      crypto: qat - reorder objects in qat_common Makefile
      crypto: qat - do not export adf_cfg_services

Herbert Xu (59):
      crypto: inside-secure - Eliminate duplication in top-level Makefile
      crypto: lib/Kconfig - Fix lib built-in failure when arch is modular
      crypto: null - Use spin lock instead of mutex
      crypto: api - Fix larval relookup type and mask
      crypto: skcipher - Set tfm in SYNC_SKCIPHER_REQUEST_ON_STACK
      crypto: skcipher - Zap type in crypto_alloc_sync_skcipher
      crypto: ahash - Only save callback and data in ahash_save_req
      crypto: x86/ghash - Use proper helpers to clone request
      crypto: hash - Add request chaining API
      crypto: tcrypt - Restore multibuffer ahash tests
      crypto: ahash - Add virtual address support
      crypto: ahash - Set default reqsize from ahash_alg
      crypto: skcipher - Use restrict rather than hand-rolling accesses
      crypto: lib/Kconfig - Hide arch options from user
      Merge tag 'crypto-krb5-20250303' of git://git.kernel.org/pub/scm/linux/kernel/git/dhowells/linux-fs.git
      crypto: api - Move struct crypto_type into internal.h
      crypto: lzo - Fix compression buffer overrun
      crypto: iaa - Test the correct request flag
      crypto: acomp - Remove acomp request flags
      crypto: Kconfig - Select LIB generic option
      crypto: scatterwalk - Change scatterwalk_next calling convention
      crypto: scatterwalk - Add memcpy_sglist
      crypto: skcipher - Eliminate duplicate virt.addr field
      crypto: skcipher - Make skcipher_walk src.virt.addr const
      crypto: api - Add cra_type->destroy hook
      crypto: scomp - Remove tfm argument from alloc/free_ctx
      crypto: acomp - Move stream management into scomp layer
      crypto: scomp - Disable BH when taking per-cpu spin lock
      crypto: acomp - Add request chaining and virtual addresses
      crypto: testmgr - Remove NULL dst acomp tests
      lib/scatterlist: Add SG_MITER_LOCAL and use it
      crypto: krb5 - Use SG miter instead of doing it by hand
      crypto: hash - Fix test underflow in shash_ahash_digest
      crypto: scatterwalk - Use nth_page instead of doing it by hand
      crypto: hash - Use nth_page instead of doing it by hand
      crypto: padlock - Use zero page instead of stack buffer
      crypto: nx - Fix uninitialised hv_nxc on error
      xfrm: ipcomp: Call pskb_may_pull in ipcomp_input
      crypto: scomp - Remove support for some non-trivial SG lists
      crypto: iaa - Remove dst_null support
      crypto: qat - Remove dst_null support
      crypto: acomp - Remove dst_free
      crypto: scomp - Add chaining and virtual address support
      crypto: acomp - Add ACOMP_REQUEST_ALLOC and acomp_request_alloc_extra
      crypto: iaa - Use acomp stack fallback
      crypto: acomp - Add async nondma fallback
      crypto: acomp - Add support for folios
      xfrm: ipcomp: Use crypto_acomp interface
      PM: hibernate: Use crypto_acomp interface
      ubifs: Use crypto_acomp interface
      ubifs: Pass folios to acomp
      crypto: scompress - Fix scratch allocation failure handling
      crypto: scompress - Fix incorrect stream freeing
      crypto: api - Call crypto_alg_put in crypto_unregister_alg
      crypto: arm/ghash-ce - Remove SIMD fallback code path
      crypto: hash - Fix synchronous ahash chaining fallback
      crypto: testmgr - Add multibuffer hash testing
      crypto: acomp - Fix synchronous acomp chaining fallback
      crypto: testmgr - Add multibuffer acomp testing

J. Neuschäfer (1):
      dt-bindings: crypto: Convert fsl,sec-2.0 to YAML

Jack Xu (3):
      crypto: qat - remove unused members in suof structure
      crypto: qat - remove redundant FW image size check
      crypto: qat - optimize allocations for fw authentication

Kristen Carlson Accardi (1):
      MAINTAINERS: Add Vinicius Gomes to MAINTAINERS for IAA Crypto

Krzysztof Kozlowski (2):
      crypto: drivers - Use str_enable_disable-like helpers
      dt-bindings: rng: rockchip,rk3588-rng: Drop unnecessary status from example

Lukas Wunner (8):
      crypto: sig - Prepare for algorithms with variable signature size
      crypto: ecdsa - Harden against integer overflows in DIV_ROUND_UP()
      crypto: virtio - Fix kernel-doc of virtcrypto_dev_stop()
      crypto: virtio - Simplify RSA key size caching
      crypto: virtio - Drop superfluous ctx->tfm backpointer
      crypto: virtio - Drop superfluous [as]kcipher_ctx pointer
      crypto: virtio - Drop superfluous [as]kcipher_req pointer
      MAINTAINERS: Add Lukas & Ignat & Stefan for asymmetric keys

Martin Kaiser (1):
      hwrng: imx-rngc - add runtime pm

Małgorzata Mielnik (1):
      crypto: qat - refactor service parsing logic

Nathan Chancellor (1):
      crypto: tegra - Fix format specifier in tegra_sha_prep_cmd()

Nicolas Frattaroli (6):
      dt-bindings: reset: Add SCMI reset IDs for RK3588
      dt-bindings: rng: add binding for Rockchip RK3588 RNG
      hwrng: rockchip - store dev pointer in driver struct
      hwrng: rockchip - eliminate some unnecessary dereferences
      hwrng: rockchip - add support for rk3588's standalone TRNG
      MAINTAINERS: add Nicolas Frattaroli to rockchip-rng maintainers

Rob Herring (Arm) (1):
      dt-bindings: crypto: inside-secure,safexcel: Allow dma-coherent

Shashank Gupta (1):
      crypto: octeontx2 - suppress auth failure screaming due to negative tests

Suman Kumar Chakraborty (3):
      crypto: qat - set command ids as reserved
      crypto: qat - add macro to write 64-bit values to registers
      crypto: qat - introduce fuse array

Sven Schwermer (1):
      crypto: mxs-dcp - Only set OTP_KEY bit for OTP key

Tanya Agarwal (1):
      lib: 842: Improve error handling in sw842_compress()

Thorsten Blum (5):
      crypto: skcipher - use str_yes_no() helper in crypto_skcipher_show()
      crypto: ahash - use str_yes_no() helper in crypto_ahash_show()
      crypto: bcm - set memory to zero only once
      crypto: aead - use str_yes_no() helper in crypto_aead_show()
      crypto: essiv - Replace memcpy() + NUL-termination with strscpy()

Tom Lendacky (1):
      crypto: ccp - Fix check for the primary ASP device

Wenkai Lin (3):
      crypto: hisilicon/sec2 - fix for aead auth key length
      crypto: hisilicon/sec2 - fix for aead authsize alignment
      crypto: hisilicon/sec2 - fix for sec spec check

lizhi (1):
      crypto: hisilicon/hpre - adapt ECDH for high-performance cores

 Documentation/crypto/architecture.rst              |   2 -
 Documentation/crypto/index.rst                     |   1 +
 Documentation/crypto/krb5.rst                      | 262 +++++++
 .../devicetree/bindings/crypto/fsl,sec2.0.yaml     | 144 ++++
 .../devicetree/bindings/crypto/fsl-sec2.txt        |  65 --
 .../crypto/inside-secure,safexcel-eip93.yaml       |  67 ++
 .../bindings/crypto/inside-secure,safexcel.yaml    |   2 +
 .../devicetree/bindings/crypto/qcom,prng.yaml      |   1 +
 .../devicetree/bindings/crypto/qcom-qce.yaml       |   1 +
 .../bindings/rng/rockchip,rk3588-rng.yaml          |  59 ++
 MAINTAINERS                                        |  39 +
 arch/arm/crypto/Kconfig                            |  10 +-
 arch/arm/crypto/aes-ce-glue.c                      |   2 +-
 arch/arm/crypto/chacha-glue.c                      |  10 +-
 arch/arm/crypto/ghash-ce-glue.c                    | 213 +----
 arch/arm64/crypto/Kconfig                          |   6 +-
 arch/arm64/crypto/aes-ce-ccm-glue.c                |  20 +-
 arch/arm64/crypto/aes-neonbs-glue.c                |   3 +-
 arch/arm64/crypto/chacha-neon-glue.c               |  10 +-
 arch/arm64/crypto/ghash-ce-glue.c                  |  17 +-
 arch/arm64/crypto/sm4-ce-ccm-glue.c                |  27 +-
 arch/arm64/crypto/sm4-ce-gcm-glue.c                |  31 +-
 arch/mips/crypto/Kconfig                           |   7 +-
 arch/mips/crypto/chacha-glue.c                     |  10 +-
 arch/powerpc/crypto/Kconfig                        |   7 +-
 arch/powerpc/crypto/aes-gcm-p10-glue.c             |   6 +-
 arch/powerpc/crypto/aes_ctr.c                      |   2 +-
 arch/powerpc/crypto/chacha-p10-glue.c              |  10 +-
 arch/riscv/crypto/Kconfig                          |   1 -
 arch/s390/crypto/Kconfig                           |   3 +-
 arch/s390/crypto/aes_s390.c                        |  45 +-
 arch/s390/crypto/chacha-glue.c                     |   8 +-
 arch/sparc/crypto/aes_glue.c                       |   2 +-
 arch/x86/crypto/Kconfig                            |  11 +-
 arch/x86/crypto/Makefile                           |   2 +-
 arch/x86/crypto/aegis128-aesni-glue.c              |   9 +-
 arch/x86/crypto/aes-ctr-avx-x86_64.S               | 592 ++++++++++++++
 arch/x86/crypto/aes-xts-avx-x86_64.S               |  55 +-
 arch/x86/crypto/aes_ctrby8_avx-x86_64.S            | 597 --------------
 arch/x86/crypto/aesni-intel_glue.c                 | 461 +++++------
 arch/x86/crypto/chacha_glue.c                      |  10 +-
 arch/x86/crypto/des3_ede_glue.c                    |   2 +-
 arch/x86/crypto/ghash-clmulni-intel_glue.c         |  23 +-
 crypto/842.c                                       |  70 +-
 crypto/Kconfig                                     |  16 +
 crypto/Makefile                                    |   5 +-
 crypto/acompress.c                                 | 276 ++++++-
 crypto/aead.c                                      |   5 +-
 crypto/aegis128-core.c                             |   9 +-
 crypto/ahash.c                                     | 601 +++++++++++---
 crypto/algapi.c                                    |   5 +-
 crypto/api.c                                       |  31 +-
 crypto/asymmetric_keys/public_key.c                |   9 +-
 crypto/async_tx/async_xor.c                        |  26 -
 crypto/bpf_crypto_skcipher.c                       |   1 +
 crypto/chacha_generic.c                            |   4 +-
 crypto/compress.c                                  |  32 -
 crypto/compress.h                                  |   2 -
 crypto/crypto_null.c                               |  68 +-
 crypto/crypto_user.c                               |  16 -
 crypto/ctr.c                                       |  10 +-
 crypto/deflate.c                                   |  62 +-
 crypto/ecc.c                                       |   2 +-
 crypto/ecdsa-p1363.c                               |   2 +-
 crypto/ecdsa-x962.c                                |   4 +-
 crypto/essiv.c                                     |   3 +-
 crypto/internal.h                                  |  20 +-
 crypto/krb5/Kconfig                                |  26 +
 crypto/krb5/Makefile                               |  18 +
 crypto/krb5/internal.h                             | 247 ++++++
 crypto/krb5/krb5_api.c                             | 452 +++++++++++
 crypto/krb5/krb5_kdf.c                             | 145 ++++
 crypto/krb5/rfc3961_simplified.c                   | 792 +++++++++++++++++++
 crypto/krb5/rfc3962_aes.c                          | 115 +++
 crypto/krb5/rfc6803_camellia.c                     | 237 ++++++
 crypto/krb5/rfc8009_aes2.c                         | 362 +++++++++
 crypto/krb5/selftest.c                             | 544 +++++++++++++
 crypto/krb5/selftest_data.c                        | 291 +++++++
 crypto/krb5enc.c                                   | 504 ++++++++++++
 crypto/lrw.c                                       |   2 +-
 crypto/lz4.c                                       |  65 +-
 crypto/lz4hc.c                                     |  70 +-
 crypto/lzo-rle.c                                   |  76 +-
 crypto/lzo.c                                       |  76 +-
 crypto/pcbc.c                                      |  28 +-
 crypto/proc.c                                      |   3 -
 crypto/rsassa-pkcs1.c                              |   2 +-
 crypto/scatterwalk.c                               | 126 ++-
 crypto/scompress.c                                 | 279 ++++---
 crypto/skcipher.c                                  | 151 ++--
 crypto/tcrypt.c                                    | 231 ++++++
 crypto/testmgr.c                                   | 505 ++++++------
 crypto/testmgr.h                                   | 351 +++++++++
 crypto/xctr.c                                      |   2 +-
 crypto/xts.c                                       |   2 +-
 crypto/zstd.c                                      |  60 +-
 drivers/char/hw_random/Kconfig                     |  21 +-
 drivers/char/hw_random/imx-rngc.c                  |  69 +-
 drivers/char/hw_random/rockchip-rng.c              | 254 +++++-
 drivers/crypto/Kconfig                             |   1 +
 drivers/crypto/Makefile                            |   2 +-
 drivers/crypto/axis/artpec6_crypto.c               |   4 +-
 drivers/crypto/bcm/cipher.c                        |  27 +-
 drivers/crypto/bcm/spu2.c                          |   3 +-
 drivers/crypto/caam/caamalg_qi2.c                  |   3 +-
 drivers/crypto/cavium/zip/zip_crypto.c             |  46 +-
 drivers/crypto/cavium/zip/zip_crypto.h             |  17 +-
 drivers/crypto/cavium/zip/zip_main.c               |  50 +-
 drivers/crypto/ccp/sp-pci.c                        |  16 +-
 drivers/crypto/hisilicon/hpre/hpre_crypto.c        |   7 +
 drivers/crypto/hisilicon/sec2/sec.h                |   1 -
 drivers/crypto/hisilicon/sec2/sec_crypto.c         | 125 ++-
 drivers/crypto/inside-secure/Makefile              |   1 +
 drivers/crypto/inside-secure/eip93/Kconfig         |  20 +
 drivers/crypto/inside-secure/eip93/Makefile        |   5 +
 drivers/crypto/inside-secure/eip93/eip93-aead.c    | 711 +++++++++++++++++
 drivers/crypto/inside-secure/eip93/eip93-aead.h    |  38 +
 drivers/crypto/inside-secure/eip93/eip93-aes.h     |  16 +
 drivers/crypto/inside-secure/eip93/eip93-cipher.c  | 413 ++++++++++
 drivers/crypto/inside-secure/eip93/eip93-cipher.h  |  60 ++
 drivers/crypto/inside-secure/eip93/eip93-common.c  | 822 +++++++++++++++++++
 drivers/crypto/inside-secure/eip93/eip93-common.h  |  24 +
 drivers/crypto/inside-secure/eip93/eip93-des.h     |  16 +
 drivers/crypto/inside-secure/eip93/eip93-hash.c    | 866 +++++++++++++++++++++
 drivers/crypto/inside-secure/eip93/eip93-hash.h    |  82 ++
 drivers/crypto/inside-secure/eip93/eip93-main.c    | 501 ++++++++++++
 drivers/crypto/inside-secure/eip93/eip93-main.h    | 151 ++++
 drivers/crypto/inside-secure/eip93/eip93-regs.h    | 335 ++++++++
 drivers/crypto/intel/iaa/iaa_crypto_main.c         | 164 +---
 drivers/crypto/intel/qat/qat_420xx/Makefile        |   2 +-
 .../crypto/intel/qat/qat_420xx/adf_420xx_hw_data.c |  19 +-
 drivers/crypto/intel/qat/qat_420xx/adf_drv.c       |   2 +-
 drivers/crypto/intel/qat/qat_4xxx/Makefile         |   2 +-
 .../crypto/intel/qat/qat_4xxx/adf_4xxx_hw_data.c   |  13 +-
 drivers/crypto/intel/qat/qat_4xxx/adf_drv.c        |   2 +-
 drivers/crypto/intel/qat/qat_c3xxx/Makefile        |   2 +-
 .../crypto/intel/qat/qat_c3xxx/adf_c3xxx_hw_data.c |   4 +-
 drivers/crypto/intel/qat/qat_c3xxx/adf_drv.c       |   2 +-
 drivers/crypto/intel/qat/qat_c3xxxvf/Makefile      |   2 +-
 drivers/crypto/intel/qat/qat_c62x/Makefile         |   2 +-
 .../crypto/intel/qat/qat_c62x/adf_c62x_hw_data.c   |   4 +-
 drivers/crypto/intel/qat/qat_c62x/adf_drv.c        |   4 +-
 drivers/crypto/intel/qat/qat_c62xvf/Makefile       |   2 +-
 drivers/crypto/intel/qat/qat_common/Makefile       |  68 +-
 .../intel/qat/qat_common/adf_accel_devices.h       |  23 +-
 .../crypto/intel/qat/qat_common/adf_cfg_services.c | 167 +++-
 .../crypto/intel/qat/qat_common/adf_cfg_services.h |  28 +-
 .../crypto/intel/qat/qat_common/adf_cfg_strings.h  |   6 +-
 .../crypto/intel/qat/qat_common/adf_gen2_hw_data.c |   2 +-
 .../crypto/intel/qat/qat_common/adf_gen4_config.c  |  15 +-
 .../crypto/intel/qat/qat_common/adf_gen4_hw_data.c |  54 +-
 .../crypto/intel/qat/qat_common/adf_gen4_hw_data.h |   1 +
 drivers/crypto/intel/qat/qat_common/adf_gen4_ras.c |  59 +-
 drivers/crypto/intel/qat/qat_common/adf_sysfs.c    |  22 +-
 .../crypto/intel/qat/qat_common/icp_qat_fw_comp.h  |   4 +-
 drivers/crypto/intel/qat/qat_common/icp_qat_uclo.h |  10 -
 drivers/crypto/intel/qat/qat_common/qat_bl.c       | 159 ----
 drivers/crypto/intel/qat/qat_common/qat_bl.h       |   6 -
 .../crypto/intel/qat/qat_common/qat_comp_algs.c    |  85 +-
 drivers/crypto/intel/qat/qat_common/qat_comp_req.h |  10 -
 drivers/crypto/intel/qat/qat_common/qat_uclo.c     |  38 +-
 drivers/crypto/intel/qat/qat_dh895xcc/Makefile     |   2 +-
 .../intel/qat/qat_dh895xcc/adf_dh895xcc_hw_data.c  |   6 +-
 drivers/crypto/intel/qat/qat_dh895xcc/adf_drv.c    |   2 +-
 drivers/crypto/intel/qat/qat_dh895xccvf/Makefile   |   2 +-
 drivers/crypto/marvell/Kconfig                     |   4 +-
 drivers/crypto/marvell/octeontx/otx_cptpf_ucode.c  |  16 +-
 drivers/crypto/marvell/octeontx/otx_cptpf_ucode.h  |   2 -
 .../crypto/marvell/octeontx2/otx2_cptpf_ucode.c    | 100 +--
 .../crypto/marvell/octeontx2/otx2_cptpf_ucode.h    |   1 -
 .../crypto/marvell/octeontx2/otx2_cptvf_reqmgr.c   |   7 +-
 drivers/crypto/mxs-dcp.c                           |   8 +-
 drivers/crypto/nx/nx-842.c                         |  33 +-
 drivers/crypto/nx/nx-842.h                         |  15 +-
 drivers/crypto/nx/nx-aes-ccm.c                     |  16 +-
 drivers/crypto/nx/nx-aes-gcm.c                     |  17 +-
 drivers/crypto/nx/nx-common-powernv.c              |  31 +-
 drivers/crypto/nx/nx-common-pseries.c              |  70 +-
 drivers/crypto/nx/nx.c                             |  34 +-
 drivers/crypto/nx/nx.h                             |   3 -
 drivers/crypto/padlock-sha.c                       |   4 +-
 drivers/crypto/s5p-sss.c                           |  38 +-
 drivers/crypto/stm32/stm32-cryp.c                  |  34 +-
 drivers/crypto/tegra/tegra-se-aes.c                | 401 ++++++----
 drivers/crypto/tegra/tegra-se-hash.c               | 287 ++++---
 drivers/crypto/tegra/tegra-se-key.c                |  29 +-
 drivers/crypto/tegra/tegra-se-main.c               |  16 +-
 drivers/crypto/tegra/tegra-se.h                    |  39 +-
 .../crypto/virtio/virtio_crypto_akcipher_algs.c    |  41 +-
 drivers/crypto/virtio/virtio_crypto_core.c         |   6 +-
 drivers/crypto/virtio/virtio_crypto_mgr.c          |   2 +-
 .../crypto/virtio/virtio_crypto_skcipher_algs.c    |  17 +-
 fs/ubifs/compress.c                                | 208 ++++-
 fs/ubifs/file.c                                    |  74 +-
 fs/ubifs/journal.c                                 |  11 +-
 fs/ubifs/ubifs.h                                   |  26 +-
 include/crypto/acompress.h                         | 382 ++++++++-
 include/crypto/algapi.h                            |  33 +-
 include/crypto/authenc.h                           |   2 +
 include/crypto/chacha.h                            |  11 +-
 include/crypto/ctr.h                               |   2 +-
 include/crypto/hash.h                              |  72 +-
 include/crypto/internal/acompress.h                |  85 +-
 include/crypto/internal/hash.h                     |  15 +
 include/crypto/internal/scompress.h                |  18 +-
 include/crypto/internal/skcipher.h                 |  40 +-
 include/crypto/krb5.h                              | 160 ++++
 include/crypto/scatterwalk.h                       | 234 ++++--
 include/crypto/sig.h                               |   5 +-
 include/crypto/skcipher.h                          |  19 +-
 include/dt-bindings/reset/rockchip,rk3588-cru.h    |  41 +-
 include/linux/async_tx.h                           |   5 -
 include/linux/crypto.h                             |  83 +-
 include/linux/lzo.h                                |   8 +
 include/linux/math.h                               |  12 +
 include/linux/scatterlist.h                        |   1 +
 include/linux/spinlock.h                           |  13 +
 include/net/ipcomp.h                               |  13 +-
 include/uapi/linux/psp-sev.h                       |  21 +-
 kernel/power/hibernate.c                           |   5 +-
 kernel/power/swap.c                                |  58 +-
 lib/842/842_compress.c                             |   2 +
 lib/crypto/Kconfig                                 |  45 +-
 lib/crypto/chacha20poly1305.c                      |   7 +-
 lib/lzo/Makefile                                   |   2 +-
 lib/lzo/lzo1x_compress.c                           | 102 ++-
 lib/lzo/lzo1x_compress_safe.c                      |  18 +
 lib/scatterlist.c                                  |  12 +-
 net/tls/tls_device_fallback.c                      |  31 +-
 net/xfrm/xfrm_algo.c                               |   7 +-
 net/xfrm/xfrm_ipcomp.c                             | 479 ++++++------
 security/keys/Kconfig                              |   2 +-
 tools/testing/crypto/chacha20-s390/test-cipher.c   |   4 +-
 233 files changed, 14511 insertions(+), 4726 deletions(-)
 create mode 100644 Documentation/crypto/krb5.rst
 create mode 100644 Documentation/devicetree/bindings/crypto/fsl,sec2.0.yaml
 delete mode 100644 Documentation/devicetree/bindings/crypto/fsl-sec2.txt
 create mode 100644 Documentation/devicetree/bindings/crypto/inside-secure,safexcel-eip93.yaml
 create mode 100644 Documentation/devicetree/bindings/rng/rockchip,rk3588-rng.yaml
 create mode 100644 arch/x86/crypto/aes-ctr-avx-x86_64.S
 delete mode 100644 arch/x86/crypto/aes_ctrby8_avx-x86_64.S
 delete mode 100644 crypto/compress.c
 create mode 100644 crypto/krb5/Kconfig
 create mode 100644 crypto/krb5/Makefile
 create mode 100644 crypto/krb5/internal.h
 create mode 100644 crypto/krb5/krb5_api.c
 create mode 100644 crypto/krb5/krb5_kdf.c
 create mode 100644 crypto/krb5/rfc3961_simplified.c
 create mode 100644 crypto/krb5/rfc3962_aes.c
 create mode 100644 crypto/krb5/rfc6803_camellia.c
 create mode 100644 crypto/krb5/rfc8009_aes2.c
 create mode 100644 crypto/krb5/selftest.c
 create mode 100644 crypto/krb5/selftest_data.c
 create mode 100644 crypto/krb5enc.c
 create mode 100644 drivers/crypto/inside-secure/eip93/Kconfig
 create mode 100644 drivers/crypto/inside-secure/eip93/Makefile
 create mode 100644 drivers/crypto/inside-secure/eip93/eip93-aead.c
 create mode 100644 drivers/crypto/inside-secure/eip93/eip93-aead.h
 create mode 100644 drivers/crypto/inside-secure/eip93/eip93-aes.h
 create mode 100644 drivers/crypto/inside-secure/eip93/eip93-cipher.c
 create mode 100644 drivers/crypto/inside-secure/eip93/eip93-cipher.h
 create mode 100644 drivers/crypto/inside-secure/eip93/eip93-common.c
 create mode 100644 drivers/crypto/inside-secure/eip93/eip93-common.h
 create mode 100644 drivers/crypto/inside-secure/eip93/eip93-des.h
 create mode 100644 drivers/crypto/inside-secure/eip93/eip93-hash.c
 create mode 100644 drivers/crypto/inside-secure/eip93/eip93-hash.h
 create mode 100644 drivers/crypto/inside-secure/eip93/eip93-main.c
 create mode 100644 drivers/crypto/inside-secure/eip93/eip93-main.h
 create mode 100644 drivers/crypto/inside-secure/eip93/eip93-regs.h
 create mode 100644 include/crypto/krb5.h
 create mode 100644 lib/lzo/lzo1x_compress_safe.c

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
