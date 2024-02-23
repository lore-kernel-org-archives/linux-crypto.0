Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D10EC26289
	for <linux-crypto@vger.kernel.org>; Fri, 23 Feb 2024 12:37:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708691857; cv=none; b=D79FZXrv/8x7kaRRSFqGFng5CSBDyXTNZXQOiqE/vq3rlJGTpcyJXaBeqgiiMDVyY3jJnUzJVmHX7IITGCEK1DJL1oGi+Yy5BP+4zOUgM9fE8I9pYvNAyOQePfBnH4YJZWhxn/J9OaWjFzl7lbNPnm8UQzhqNsLOtVbHlnARjiA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708691857; c=relaxed/simple;
	bh=O1zC8r7V6+O4MffyTvM8dyHXLziaWg/Z/ZkIrH+gk5o=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Ar+VyfbMUoq2+sBhvx5sERCyQ83/xT41lgezBCh1nwCAX3ex2djXwprRHWw4MVCQPBbdItHcosoa5z0UiDYtfO6ov6pN4XKwaL42asFTROn23cH8hNJIQ2o1SOjY8fv4zc6Rq8pJ9n0VVlT3rBy7W4DkYzn1T93vke8ob6mosLI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=eH/F6IyI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="eH/F6IyI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9A92C43390
	for <linux-crypto@vger.kernel.org>; Fri, 23 Feb 2024 12:37:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1708691856;
	bh=O1zC8r7V6+O4MffyTvM8dyHXLziaWg/Z/ZkIrH+gk5o=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=eH/F6IyINd+TcuusqP88c0UNO9iBBqOzF056Uipq4cgLmk/3CwSCHBGc4gbpzrDpt
	 bj8vS2krgEKmFhosCIAScJthF96238+KGNYrhwUj9DEgAze8GG4aXd1L6p0LT/LKsV
	 FhUp6r1fR8e2uYPKQD4t+XeCaeR0dC4lK1CV525sdQORHCMSh115jhdtBGo9xdNDhw
	 1ZUmQZ9WO/FuR11E6HRVequRV1Oku5bppZ/t8T4AmVPSXR2mStERYQTJNpIpeNAiYK
	 sbkqL8w25qVZ7AcyMhG6rCgjAFx8mkshvwpD5nDHz3+EgvpYNTzHrGEoPa529rYm5F
	 w/9tYmr9Y4nGg==
Received: by mail-lj1-f169.google.com with SMTP id 38308e7fff4ca-2d2533089f6so7576401fa.1
        for <linux-crypto@vger.kernel.org>; Fri, 23 Feb 2024 04:37:35 -0800 (PST)
X-Gm-Message-State: AOJu0YxiecE51w3WVyuKvcJI0dBQdYibnYfZP/5c0nlTf1bRaO2QS4UE
	Q0G9rNktclfBmFzSm5fA9p/Otj3uW15yT57vBOrrpuEmphZ1mx7xiaEMvP00a6wHEEWGFZoCxOT
	kL2CxhDjH+9G0a21GmLz9XVuLvXE=
X-Google-Smtp-Source: AGHT+IF5Mc0Sg1aI0seeLQxURBTQI6xRYelAJC0HMNEbW/CHz4JwAQ+e/R6u8xNoRRtMcpyIE5kHDXSwamTZUEXAlTs=
X-Received: by 2002:a2e:b0dc:0:b0:2d2:6002:c239 with SMTP id
 g28-20020a2eb0dc000000b002d26002c239mr1141146ljl.3.1708691852813; Fri, 23 Feb
 2024 04:37:32 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240223090334.167519-1-ebiggers@kernel.org>
In-Reply-To: <20240223090334.167519-1-ebiggers@kernel.org>
From: Ard Biesheuvel <ardb@kernel.org>
Date: Fri, 23 Feb 2024 13:37:19 +0100
X-Gmail-Original-Message-ID: <CAMj1kXG4AyVi2N+30LAL93bkU8OqTwceuY+FZSkRaMEBgX1VyQ@mail.gmail.com>
Message-ID: <CAMj1kXG4AyVi2N+30LAL93bkU8OqTwceuY+FZSkRaMEBgX1VyQ@mail.gmail.com>
Subject: Re: [RFC PATCH] crypto: remove CONFIG_CRYPTO_STATS
To: Eric Biggers <ebiggers@kernel.org>
Cc: linux-crypto@vger.kernel.org, Corentin Labbe <clabbe@baylibre.com>
Content-Type: text/plain; charset="UTF-8"

On Fri, 23 Feb 2024 at 10:06, Eric Biggers <ebiggers@kernel.org> wrote:
>
> From: Eric Biggers <ebiggers@google.com>
>
> Remove support for the "Crypto usage statistics" feature
> (CONFIG_CRYPTO_STATS).  This feature does not appear to have ever been
> used, and it is harmful because it significantly reduces performance and
> is a large maintenance burden.
>
> Covering each of these points in detail:
>
> 1. Feature is not being used
>
> Since these generic crypto statistics are only readable using netlink,
> it's fairly straightforward to look for programs that use them.  I'm
> unable to find any evidence that any such programs exist.  For example,
> Debian Code Search returns no hits except the kernel header and kernel
> code itself and translations of the kernel header:
> https://codesearch.debian.net/search?q=CRYPTOCFGA_STAT&literal=1&perpkg=1
>
> The patch series that added this feature in 2018
> (https://lore.kernel.org/linux-crypto/1537351855-16618-1-git-send-email-clabbe@baylibre.com/)
> said "The goal is to have an ifconfig for crypto device."  This doesn't
> appear to have happened.
>
> It's not clear that there is real demand for crypto statistics.  Just
> because the kernel provides other types of statistics such as I/O and
> networking statistics and some people find those useful does not mean
> that crypto statistics are useful too.
>
> Further evidence that programs are not using CONFIG_CRYPTO_STATS is that
> it was able to be disabled in RHEL and Fedora as a bug fix
> (https://gitlab.com/redhat/centos-stream/src/kernel/centos-stream-9/-/merge_requests/2947).
>
> Even further evidence comes from the fact that there are and have been
> bugs in how the stats work, but they were never reported.  For example,
> before Linux v6.7 hash stats were double-counted in most cases.
>
> There has also never been any documentation for this feature, so it
> might be hard to use even if someone wanted to.
>
> 2. CONFIG_CRYPTO_STATS significantly reduces performance
>
> Enabling CONFIG_CRYPTO_STATS significantly reduces the performance of
> the crypto API, even if no program ever retrieves the statistics.  This
> primarily affects systems with large number of CPUs.  For example,
> https://bugs.launchpad.net/ubuntu/+source/linux/+bug/2039576 reported
> that Lustre client encryption performance improved from 21.7GB/s to
> 48.2GB/s by disabling CONFIG_CRYPTO_STATS.
>
> It can be argued that this means that CONFIG_CRYPTO_STATS should be
> optimized with per-cpu counters similar to many of the networking
> counters.  But no one has done this in 5+ years.  This is consistent
> with the fact that the feature appears to be unused, so there seems to
> be little interest in improving it as opposed to just disabling it.
>
> It can be argued that because CONFIG_CRYPTO_STATS is off by default,
> performance doesn't matter.  But Linux distros tend to error on the side
> of enabling options.  The option is enabled in Ubuntu and Arch Linux,
> and until recently was enabled in RHEL and Fedora (see above).  So, even
> just having the option available is harmful to users.
>
> 3. CONFIG_CRYPTO_STATS is a large maintenance burden
>
> There are over 1000 lines of code associated with CONFIG_CRYPTO_STATS,
> spread among 32 files.  It significantly complicates much of the
> implementation of the crypto API.  After the initial submission, many
> fixes and refactorings have consumed effort of multiple people to keep
> this feature "working".  We should be spending this effort elsewhere.
>
> Cc: Corentin Labbe <clabbe@baylibre.com>
> Signed-off-by: Eric Biggers <ebiggers@google.com>

I appreciate the effort that went into creating this, in an attempt to
contribute something useful. However, I agree with every point in
Eric's analysis, and so I also feel it would be better to retire it.

Acked-by: Ard Biesheuvel <ardb@kernel.org>


> ---
>  arch/s390/configs/debug_defconfig            |   1 -
>  arch/s390/configs/defconfig                  |   1 -
>  crypto/Kconfig                               |  20 ---
>  crypto/Makefile                              |   2 -
>  crypto/acompress.c                           |  47 +----
>  crypto/aead.c                                |  84 +--------
>  crypto/ahash.c                               |  63 +------
>  crypto/akcipher.c                            |  31 ----
>  crypto/compress.h                            |   5 -
>  crypto/{crypto_user_base.c => crypto_user.c} |  10 +-
>  crypto/crypto_user_stat.c                    | 176 -------------------
>  crypto/hash.h                                |  30 ----
>  crypto/kpp.c                                 |  30 ----
>  crypto/lskcipher.c                           |  73 +-------
>  crypto/rng.c                                 |  44 +----
>  crypto/scompress.c                           |   8 +-
>  crypto/shash.c                               |  75 +-------
>  crypto/sig.c                                 |  13 --
>  crypto/skcipher.c                            |  86 +--------
>  crypto/skcipher.h                            |  10 --
>  include/crypto/acompress.h                   |  90 +---------
>  include/crypto/aead.h                        |  21 ---
>  include/crypto/akcipher.h                    |  78 +-------
>  include/crypto/algapi.h                      |   3 -
>  include/crypto/hash.h                        |  22 ---
>  include/crypto/internal/acompress.h          |   7 +-
>  include/crypto/internal/cryptouser.h         |  16 --
>  include/crypto/internal/scompress.h          |   8 +-
>  include/crypto/kpp.h                         |  58 +-----
>  include/crypto/rng.h                         |  51 +-----
>  include/crypto/skcipher.h                    |  25 ---
>  include/uapi/linux/cryptouser.h              |  28 +--
>  32 files changed, 77 insertions(+), 1139 deletions(-)
>  rename crypto/{crypto_user_base.c => crypto_user.c} (98%)
>  delete mode 100644 crypto/crypto_user_stat.c
>  delete mode 100644 include/crypto/internal/cryptouser.h
>
> diff --git a/arch/s390/configs/debug_defconfig b/arch/s390/configs/debug_defconfig
> index cae2dd34fbb49..063f0c11087dd 100644
> --- a/arch/s390/configs/debug_defconfig
> +++ b/arch/s390/configs/debug_defconfig
> @@ -759,21 +759,20 @@ CONFIG_CRYPTO_XCBC=m
>  CONFIG_CRYPTO_CRC32=m
>  CONFIG_CRYPTO_842=m
>  CONFIG_CRYPTO_LZ4=m
>  CONFIG_CRYPTO_LZ4HC=m
>  CONFIG_CRYPTO_ZSTD=m
>  CONFIG_CRYPTO_ANSI_CPRNG=m
>  CONFIG_CRYPTO_USER_API_HASH=m
>  CONFIG_CRYPTO_USER_API_SKCIPHER=m
>  CONFIG_CRYPTO_USER_API_RNG=m
>  CONFIG_CRYPTO_USER_API_AEAD=m
> -CONFIG_CRYPTO_STATS=y
>  CONFIG_CRYPTO_CRC32_S390=y
>  CONFIG_CRYPTO_SHA512_S390=m
>  CONFIG_CRYPTO_SHA1_S390=m
>  CONFIG_CRYPTO_SHA256_S390=m
>  CONFIG_CRYPTO_SHA3_256_S390=m
>  CONFIG_CRYPTO_SHA3_512_S390=m
>  CONFIG_CRYPTO_GHASH_S390=m
>  CONFIG_CRYPTO_AES_S390=m
>  CONFIG_CRYPTO_DES_S390=m
>  CONFIG_CRYPTO_CHACHA_S390=m
> diff --git a/arch/s390/configs/defconfig b/arch/s390/configs/defconfig
> index 42b988873e544..ab608ce768b7b 100644
> --- a/arch/s390/configs/defconfig
> +++ b/arch/s390/configs/defconfig
> @@ -745,21 +745,20 @@ CONFIG_CRYPTO_XCBC=m
>  CONFIG_CRYPTO_CRC32=m
>  CONFIG_CRYPTO_842=m
>  CONFIG_CRYPTO_LZ4=m
>  CONFIG_CRYPTO_LZ4HC=m
>  CONFIG_CRYPTO_ZSTD=m
>  CONFIG_CRYPTO_ANSI_CPRNG=m
>  CONFIG_CRYPTO_USER_API_HASH=m
>  CONFIG_CRYPTO_USER_API_SKCIPHER=m
>  CONFIG_CRYPTO_USER_API_RNG=m
>  CONFIG_CRYPTO_USER_API_AEAD=m
> -CONFIG_CRYPTO_STATS=y
>  CONFIG_CRYPTO_CRC32_S390=y
>  CONFIG_CRYPTO_SHA512_S390=m
>  CONFIG_CRYPTO_SHA1_S390=m
>  CONFIG_CRYPTO_SHA256_S390=m
>  CONFIG_CRYPTO_SHA3_256_S390=m
>  CONFIG_CRYPTO_SHA3_512_S390=m
>  CONFIG_CRYPTO_GHASH_S390=m
>  CONFIG_CRYPTO_AES_S390=m
>  CONFIG_CRYPTO_DES_S390=m
>  CONFIG_CRYPTO_CHACHA_S390=m
> diff --git a/crypto/Kconfig b/crypto/Kconfig
> index 7d156c75f15f2..4980b1ceb21f6 100644
> --- a/crypto/Kconfig
> +++ b/crypto/Kconfig
> @@ -1448,40 +1448,20 @@ config CRYPTO_USER_API_AEAD
>
>  config CRYPTO_USER_API_ENABLE_OBSOLETE
>         bool "Obsolete cryptographic algorithms"
>         depends on CRYPTO_USER_API
>         default y
>         help
>           Allow obsolete cryptographic algorithms to be selected that have
>           already been phased out from internal use by the kernel, and are
>           only useful for userspace clients that still rely on them.
>
> -config CRYPTO_STATS
> -       bool "Crypto usage statistics"
> -       depends on CRYPTO_USER
> -       help
> -         Enable the gathering of crypto stats.
> -
> -         Enabling this option reduces the performance of the crypto API.  It
> -         should only be enabled when there is actually a use case for it.
> -
> -         This collects data sizes, numbers of requests, and numbers
> -         of errors processed by:
> -         - AEAD ciphers (encrypt, decrypt)
> -         - asymmetric key ciphers (encrypt, decrypt, verify, sign)
> -         - symmetric key ciphers (encrypt, decrypt)
> -         - compression algorithms (compress, decompress)
> -         - hash algorithms (hash)
> -         - key-agreement protocol primitives (setsecret, generate
> -           public key, compute shared secret)
> -         - RNG (generate, seed)
> -
>  endmenu
>
>  config CRYPTO_HASH_INFO
>         bool
>
>  if !KMSAN # avoid false positives from assembly
>  if ARM
>  source "arch/arm/crypto/Kconfig"
>  endif
>  if ARM64
> diff --git a/crypto/Makefile b/crypto/Makefile
> index 408f0a1f9ab91..de9a3312a2c84 100644
> --- a/crypto/Makefile
> +++ b/crypto/Makefile
> @@ -62,22 +62,20 @@ ecdsa_generic-y += ecdsasignature.asn1.o
>  obj-$(CONFIG_CRYPTO_ECDSA) += ecdsa_generic.o
>
>  crypto_acompress-y := acompress.o
>  crypto_acompress-y += scompress.o
>  obj-$(CONFIG_CRYPTO_ACOMP2) += crypto_acompress.o
>
>  cryptomgr-y := algboss.o testmgr.o
>
>  obj-$(CONFIG_CRYPTO_MANAGER2) += cryptomgr.o
>  obj-$(CONFIG_CRYPTO_USER) += crypto_user.o
> -crypto_user-y := crypto_user_base.o
> -crypto_user-$(CONFIG_CRYPTO_STATS) += crypto_user_stat.o
>  obj-$(CONFIG_CRYPTO_CMAC) += cmac.o
>  obj-$(CONFIG_CRYPTO_HMAC) += hmac.o
>  obj-$(CONFIG_CRYPTO_VMAC) += vmac.o
>  obj-$(CONFIG_CRYPTO_XCBC) += xcbc.o
>  obj-$(CONFIG_CRYPTO_NULL2) += crypto_null.o
>  obj-$(CONFIG_CRYPTO_MD4) += md4.o
>  obj-$(CONFIG_CRYPTO_MD5) += md5.o
>  obj-$(CONFIG_CRYPTO_RMD160) += rmd160.o
>  obj-$(CONFIG_CRYPTO_SHA1) += sha1_generic.o
>  obj-$(CONFIG_CRYPTO_SHA256) += sha256_generic.o
> diff --git a/crypto/acompress.c b/crypto/acompress.c
> index 1c682810a484d..484a865b23cd8 100644
> --- a/crypto/acompress.c
> +++ b/crypto/acompress.c
> @@ -18,21 +18,21 @@
>  #include <net/netlink.h>
>
>  #include "compress.h"
>
>  struct crypto_scomp;
>
>  static const struct crypto_type crypto_acomp_type;
>
>  static inline struct acomp_alg *__crypto_acomp_alg(struct crypto_alg *alg)
>  {
> -       return container_of(alg, struct acomp_alg, calg.base);
> +       return container_of(alg, struct acomp_alg, base);
>  }
>
>  static inline struct acomp_alg *crypto_acomp_alg(struct crypto_acomp *tfm)
>  {
>         return __crypto_acomp_alg(crypto_acomp_tfm(tfm)->__crt_alg);
>  }
>
>  static int __maybe_unused crypto_acomp_report(
>         struct sk_buff *skb, struct crypto_alg *alg)
>  {
> @@ -86,57 +86,28 @@ static int crypto_acomp_init_tfm(struct crypto_tfm *tfm)
>  static unsigned int crypto_acomp_extsize(struct crypto_alg *alg)
>  {
>         int extsize = crypto_alg_extsize(alg);
>
>         if (alg->cra_type != &crypto_acomp_type)
>                 extsize += sizeof(struct crypto_scomp *);
>
>         return extsize;
>  }
>
> -static inline int __crypto_acomp_report_stat(struct sk_buff *skb,
> -                                            struct crypto_alg *alg)
> -{
> -       struct comp_alg_common *calg = __crypto_comp_alg_common(alg);
> -       struct crypto_istat_compress *istat = comp_get_stat(calg);
> -       struct crypto_stat_compress racomp;
> -
> -       memset(&racomp, 0, sizeof(racomp));
> -
> -       strscpy(racomp.type, "acomp", sizeof(racomp.type));
> -       racomp.stat_compress_cnt = atomic64_read(&istat->compress_cnt);
> -       racomp.stat_compress_tlen = atomic64_read(&istat->compress_tlen);
> -       racomp.stat_decompress_cnt =  atomic64_read(&istat->decompress_cnt);
> -       racomp.stat_decompress_tlen = atomic64_read(&istat->decompress_tlen);
> -       racomp.stat_err_cnt = atomic64_read(&istat->err_cnt);
> -
> -       return nla_put(skb, CRYPTOCFGA_STAT_ACOMP, sizeof(racomp), &racomp);
> -}
> -
> -#ifdef CONFIG_CRYPTO_STATS
> -int crypto_acomp_report_stat(struct sk_buff *skb, struct crypto_alg *alg)
> -{
> -       return __crypto_acomp_report_stat(skb, alg);
> -}
> -#endif
> -
>  static const struct crypto_type crypto_acomp_type = {
>         .extsize = crypto_acomp_extsize,
>         .init_tfm = crypto_acomp_init_tfm,
>  #ifdef CONFIG_PROC_FS
>         .show = crypto_acomp_show,
>  #endif
>  #if IS_ENABLED(CONFIG_CRYPTO_USER)
>         .report = crypto_acomp_report,
> -#endif
> -#ifdef CONFIG_CRYPTO_STATS
> -       .report_stat = crypto_acomp_report_stat,
>  #endif
>         .maskclear = ~CRYPTO_ALG_TYPE_MASK,
>         .maskset = CRYPTO_ALG_TYPE_ACOMPRESS_MASK,
>         .type = CRYPTO_ALG_TYPE_ACOMPRESS,
>         .tfmsize = offsetof(struct crypto_acomp, base),
>  };
>
>  struct crypto_acomp *crypto_alloc_acomp(const char *alg_name, u32 type,
>                                         u32 mask)
>  {
> @@ -175,38 +146,26 @@ void acomp_request_free(struct acomp_req *req)
>
>         if (req->flags & CRYPTO_ACOMP_ALLOC_OUTPUT) {
>                 acomp->dst_free(req->dst);
>                 req->dst = NULL;
>         }
>
>         __acomp_request_free(req);
>  }
>  EXPORT_SYMBOL_GPL(acomp_request_free);
>
> -void comp_prepare_alg(struct comp_alg_common *alg)
> -{
> -       struct crypto_istat_compress *istat = comp_get_stat(alg);
> -       struct crypto_alg *base = &alg->base;
> -
> -       base->cra_flags &= ~CRYPTO_ALG_TYPE_MASK;
> -
> -       if (IS_ENABLED(CONFIG_CRYPTO_STATS))
> -               memset(istat, 0, sizeof(*istat));
> -}
> -
>  int crypto_register_acomp(struct acomp_alg *alg)
>  {
> -       struct crypto_alg *base = &alg->calg.base;
> -
> -       comp_prepare_alg(&alg->calg);
> +       struct crypto_alg *base = &alg->base;
>
>         base->cra_type = &crypto_acomp_type;
> +       base->cra_flags &= ~CRYPTO_ALG_TYPE_MASK;
>         base->cra_flags |= CRYPTO_ALG_TYPE_ACOMPRESS;
>
>         return crypto_register_alg(base);
>  }
>  EXPORT_SYMBOL_GPL(crypto_register_acomp);
>
>  void crypto_unregister_acomp(struct acomp_alg *alg)
>  {
>         crypto_unregister_alg(&alg->base);
>  }
> diff --git a/crypto/aead.c b/crypto/aead.c
> index 54906633566a2..0e75a69189df4 100644
> --- a/crypto/aead.c
> +++ b/crypto/aead.c
> @@ -13,29 +13,20 @@
>  #include <linux/init.h>
>  #include <linux/kernel.h>
>  #include <linux/module.h>
>  #include <linux/slab.h>
>  #include <linux/seq_file.h>
>  #include <linux/string.h>
>  #include <net/netlink.h>
>
>  #include "internal.h"
>
> -static inline struct crypto_istat_aead *aead_get_stat(struct aead_alg *alg)
> -{
> -#ifdef CONFIG_CRYPTO_STATS
> -       return &alg->stat;
> -#else
> -       return NULL;
> -#endif
> -}
> -
>  static int setkey_unaligned(struct crypto_aead *tfm, const u8 *key,
>                             unsigned int keylen)
>  {
>         unsigned long alignmask = crypto_aead_alignmask(tfm);
>         int ret;
>         u8 *buffer, *alignbuffer;
>         unsigned long absize;
>
>         absize = keylen + alignmask;
>         buffer = kmalloc(absize, GFP_ATOMIC);
> @@ -83,76 +74,42 @@ int crypto_aead_setauthsize(struct crypto_aead *tfm, unsigned int authsize)
>                 err = crypto_aead_alg(tfm)->setauthsize(tfm, authsize);
>                 if (err)
>                         return err;
>         }
>
>         tfm->authsize = authsize;
>         return 0;
>  }
>  EXPORT_SYMBOL_GPL(crypto_aead_setauthsize);
>
> -static inline int crypto_aead_errstat(struct crypto_istat_aead *istat, int err)
> -{
> -       if (!IS_ENABLED(CONFIG_CRYPTO_STATS))
> -               return err;
> -
> -       if (err && err != -EINPROGRESS && err != -EBUSY)
> -               atomic64_inc(&istat->err_cnt);
> -
> -       return err;
> -}
> -
>  int crypto_aead_encrypt(struct aead_request *req)
>  {
>         struct crypto_aead *aead = crypto_aead_reqtfm(req);
> -       struct aead_alg *alg = crypto_aead_alg(aead);
> -       struct crypto_istat_aead *istat;
> -       int ret;
> -
> -       istat = aead_get_stat(alg);
> -
> -       if (IS_ENABLED(CONFIG_CRYPTO_STATS)) {
> -               atomic64_inc(&istat->encrypt_cnt);
> -               atomic64_add(req->cryptlen, &istat->encrypt_tlen);
> -       }
>
>         if (crypto_aead_get_flags(aead) & CRYPTO_TFM_NEED_KEY)
> -               ret = -ENOKEY;
> -       else
> -               ret = alg->encrypt(req);
> +               return -ENOKEY;
>
> -       return crypto_aead_errstat(istat, ret);
> +       return crypto_aead_alg(aead)->encrypt(req);
>  }
>  EXPORT_SYMBOL_GPL(crypto_aead_encrypt);
>
>  int crypto_aead_decrypt(struct aead_request *req)
>  {
>         struct crypto_aead *aead = crypto_aead_reqtfm(req);
> -       struct aead_alg *alg = crypto_aead_alg(aead);
> -       struct crypto_istat_aead *istat;
> -       int ret;
> -
> -       istat = aead_get_stat(alg);
> -
> -       if (IS_ENABLED(CONFIG_CRYPTO_STATS)) {
> -               atomic64_inc(&istat->encrypt_cnt);
> -               atomic64_add(req->cryptlen, &istat->encrypt_tlen);
> -       }
>
>         if (crypto_aead_get_flags(aead) & CRYPTO_TFM_NEED_KEY)
> -               ret = -ENOKEY;
> -       else if (req->cryptlen < crypto_aead_authsize(aead))
> -               ret = -EINVAL;
> -       else
> -               ret = alg->decrypt(req);
> +               return -ENOKEY;
> +
> +       if (req->cryptlen < crypto_aead_authsize(aead))
> +               return -EINVAL;
>
> -       return crypto_aead_errstat(istat, ret);
> +       return crypto_aead_alg(aead)->decrypt(req);
>  }
>  EXPORT_SYMBOL_GPL(crypto_aead_decrypt);
>
>  static void crypto_aead_exit_tfm(struct crypto_tfm *tfm)
>  {
>         struct crypto_aead *aead = __crypto_aead_cast(tfm);
>         struct aead_alg *alg = crypto_aead_alg(aead);
>
>         alg->exit(aead);
>  }
> @@ -208,52 +165,29 @@ static void crypto_aead_show(struct seq_file *m, struct crypto_alg *alg)
>         seq_printf(m, "geniv        : <none>\n");
>  }
>
>  static void crypto_aead_free_instance(struct crypto_instance *inst)
>  {
>         struct aead_instance *aead = aead_instance(inst);
>
>         aead->free(aead);
>  }
>
> -static int __maybe_unused crypto_aead_report_stat(
> -       struct sk_buff *skb, struct crypto_alg *alg)
> -{
> -       struct aead_alg *aead = container_of(alg, struct aead_alg, base);
> -       struct crypto_istat_aead *istat = aead_get_stat(aead);
> -       struct crypto_stat_aead raead;
> -
> -       memset(&raead, 0, sizeof(raead));
> -
> -       strscpy(raead.type, "aead", sizeof(raead.type));
> -
> -       raead.stat_encrypt_cnt = atomic64_read(&istat->encrypt_cnt);
> -       raead.stat_encrypt_tlen = atomic64_read(&istat->encrypt_tlen);
> -       raead.stat_decrypt_cnt = atomic64_read(&istat->decrypt_cnt);
> -       raead.stat_decrypt_tlen = atomic64_read(&istat->decrypt_tlen);
> -       raead.stat_err_cnt = atomic64_read(&istat->err_cnt);
> -
> -       return nla_put(skb, CRYPTOCFGA_STAT_AEAD, sizeof(raead), &raead);
> -}
> -
>  static const struct crypto_type crypto_aead_type = {
>         .extsize = crypto_alg_extsize,
>         .init_tfm = crypto_aead_init_tfm,
>         .free = crypto_aead_free_instance,
>  #ifdef CONFIG_PROC_FS
>         .show = crypto_aead_show,
>  #endif
>  #if IS_ENABLED(CONFIG_CRYPTO_USER)
>         .report = crypto_aead_report,
> -#endif
> -#ifdef CONFIG_CRYPTO_STATS
> -       .report_stat = crypto_aead_report_stat,
>  #endif
>         .maskclear = ~CRYPTO_ALG_TYPE_MASK,
>         .maskset = CRYPTO_ALG_TYPE_MASK,
>         .type = CRYPTO_ALG_TYPE_AEAD,
>         .tfmsize = offsetof(struct crypto_aead, base),
>  };
>
>  int crypto_grab_aead(struct crypto_aead_spawn *spawn,
>                      struct crypto_instance *inst,
>                      const char *name, u32 type, u32 mask)
> @@ -270,37 +204,33 @@ struct crypto_aead *crypto_alloc_aead(const char *alg_name, u32 type, u32 mask)
>  EXPORT_SYMBOL_GPL(crypto_alloc_aead);
>
>  int crypto_has_aead(const char *alg_name, u32 type, u32 mask)
>  {
>         return crypto_type_has_alg(alg_name, &crypto_aead_type, type, mask);
>  }
>  EXPORT_SYMBOL_GPL(crypto_has_aead);
>
>  static int aead_prepare_alg(struct aead_alg *alg)
>  {
> -       struct crypto_istat_aead *istat = aead_get_stat(alg);
>         struct crypto_alg *base = &alg->base;
>
>         if (max3(alg->maxauthsize, alg->ivsize, alg->chunksize) >
>             PAGE_SIZE / 8)
>                 return -EINVAL;
>
>         if (!alg->chunksize)
>                 alg->chunksize = base->cra_blocksize;
>
>         base->cra_type = &crypto_aead_type;
>         base->cra_flags &= ~CRYPTO_ALG_TYPE_MASK;
>         base->cra_flags |= CRYPTO_ALG_TYPE_AEAD;
>
> -       if (IS_ENABLED(CONFIG_CRYPTO_STATS))
> -               memset(istat, 0, sizeof(*istat));
> -
>         return 0;
>  }
>
>  int crypto_register_aead(struct aead_alg *alg)
>  {
>         struct crypto_alg *base = &alg->base;
>         int err;
>
>         err = aead_prepare_alg(alg);
>         if (err)
> diff --git a/crypto/ahash.c b/crypto/ahash.c
> index 0ac83f7f701df..bcd9de009a91b 100644
> --- a/crypto/ahash.c
> +++ b/crypto/ahash.c
> @@ -20,36 +20,20 @@
>  #include <linux/sched.h>
>  #include <linux/slab.h>
>  #include <linux/seq_file.h>
>  #include <linux/string.h>
>  #include <net/netlink.h>
>
>  #include "hash.h"
>
>  #define CRYPTO_ALG_TYPE_AHASH_MASK     0x0000000e
>
> -static inline struct crypto_istat_hash *ahash_get_stat(struct ahash_alg *alg)
> -{
> -       return hash_get_stat(&alg->halg);
> -}
> -
> -static inline int crypto_ahash_errstat(struct ahash_alg *alg, int err)
> -{
> -       if (!IS_ENABLED(CONFIG_CRYPTO_STATS))
> -               return err;
> -
> -       if (err && err != -EINPROGRESS && err != -EBUSY)
> -               atomic64_inc(&ahash_get_stat(alg)->err_cnt);
> -
> -       return err;
> -}
> -
>  /*
>   * For an ahash tfm that is using an shash algorithm (instead of an ahash
>   * algorithm), this returns the underlying shash tfm.
>   */
>  static inline struct crypto_shash *ahash_to_shash(struct crypto_ahash *tfm)
>  {
>         return *(struct crypto_shash **)crypto_ahash_ctx(tfm);
>  }
>
>  static inline struct shash_desc *prepare_shash_desc(struct ahash_request *req,
> @@ -337,89 +321,61 @@ static void ahash_restore_req(struct ahash_request *req, int err)
>                        crypto_ahash_digestsize(crypto_ahash_reqtfm(req)));
>
>         req->priv = NULL;
>
>         kfree_sensitive(subreq);
>  }
>
>  int crypto_ahash_update(struct ahash_request *req)
>  {
>         struct crypto_ahash *tfm = crypto_ahash_reqtfm(req);
> -       struct ahash_alg *alg;
>
>         if (likely(tfm->using_shash))
>                 return shash_ahash_update(req, ahash_request_ctx(req));
>
> -       alg = crypto_ahash_alg(tfm);
> -       if (IS_ENABLED(CONFIG_CRYPTO_STATS))
> -               atomic64_add(req->nbytes, &ahash_get_stat(alg)->hash_tlen);
> -       return crypto_ahash_errstat(alg, alg->update(req));
> +       return crypto_ahash_alg(tfm)->update(req);
>  }
>  EXPORT_SYMBOL_GPL(crypto_ahash_update);
>
>  int crypto_ahash_final(struct ahash_request *req)
>  {
>         struct crypto_ahash *tfm = crypto_ahash_reqtfm(req);
> -       struct ahash_alg *alg;
>
>         if (likely(tfm->using_shash))
>                 return crypto_shash_final(ahash_request_ctx(req), req->result);
>
> -       alg = crypto_ahash_alg(tfm);
> -       if (IS_ENABLED(CONFIG_CRYPTO_STATS))
> -               atomic64_inc(&ahash_get_stat(alg)->hash_cnt);
> -       return crypto_ahash_errstat(alg, alg->final(req));
> +       return crypto_ahash_alg(tfm)->final(req);
>  }
>  EXPORT_SYMBOL_GPL(crypto_ahash_final);
>
>  int crypto_ahash_finup(struct ahash_request *req)
>  {
>         struct crypto_ahash *tfm = crypto_ahash_reqtfm(req);
> -       struct ahash_alg *alg;
>
>         if (likely(tfm->using_shash))
>                 return shash_ahash_finup(req, ahash_request_ctx(req));
>
> -       alg = crypto_ahash_alg(tfm);
> -       if (IS_ENABLED(CONFIG_CRYPTO_STATS)) {
> -               struct crypto_istat_hash *istat = ahash_get_stat(alg);
> -
> -               atomic64_inc(&istat->hash_cnt);
> -               atomic64_add(req->nbytes, &istat->hash_tlen);
> -       }
> -       return crypto_ahash_errstat(alg, alg->finup(req));
> +       return crypto_ahash_alg(tfm)->finup(req);
>  }
>  EXPORT_SYMBOL_GPL(crypto_ahash_finup);
>
>  int crypto_ahash_digest(struct ahash_request *req)
>  {
>         struct crypto_ahash *tfm = crypto_ahash_reqtfm(req);
> -       struct ahash_alg *alg;
> -       int err;
>
>         if (likely(tfm->using_shash))
>                 return shash_ahash_digest(req, prepare_shash_desc(req, tfm));
>
> -       alg = crypto_ahash_alg(tfm);
> -       if (IS_ENABLED(CONFIG_CRYPTO_STATS)) {
> -               struct crypto_istat_hash *istat = ahash_get_stat(alg);
> -
> -               atomic64_inc(&istat->hash_cnt);
> -               atomic64_add(req->nbytes, &istat->hash_tlen);
> -       }
> -
>         if (crypto_ahash_get_flags(tfm) & CRYPTO_TFM_NEED_KEY)
> -               err = -ENOKEY;
> -       else
> -               err = alg->digest(req);
> +               return -ENOKEY;
>
> -       return crypto_ahash_errstat(alg, err);
> +       return crypto_ahash_alg(tfm)->digest(req);
>  }
>  EXPORT_SYMBOL_GPL(crypto_ahash_digest);
>
>  static void ahash_def_finup_done2(void *data, int err)
>  {
>         struct ahash_request *areq = data;
>
>         if (err == -EINPROGRESS)
>                 return;
>
> @@ -564,38 +520,29 @@ static void crypto_ahash_show(struct seq_file *m, struct crypto_alg *alg)
>  static void crypto_ahash_show(struct seq_file *m, struct crypto_alg *alg)
>  {
>         seq_printf(m, "type         : ahash\n");
>         seq_printf(m, "async        : %s\n", alg->cra_flags & CRYPTO_ALG_ASYNC ?
>                                              "yes" : "no");
>         seq_printf(m, "blocksize    : %u\n", alg->cra_blocksize);
>         seq_printf(m, "digestsize   : %u\n",
>                    __crypto_hash_alg_common(alg)->digestsize);
>  }
>
> -static int __maybe_unused crypto_ahash_report_stat(
> -       struct sk_buff *skb, struct crypto_alg *alg)
> -{
> -       return crypto_hash_report_stat(skb, alg, "ahash");
> -}
> -
>  static const struct crypto_type crypto_ahash_type = {
>         .extsize = crypto_ahash_extsize,
>         .init_tfm = crypto_ahash_init_tfm,
>         .free = crypto_ahash_free_instance,
>  #ifdef CONFIG_PROC_FS
>         .show = crypto_ahash_show,
>  #endif
>  #if IS_ENABLED(CONFIG_CRYPTO_USER)
>         .report = crypto_ahash_report,
> -#endif
> -#ifdef CONFIG_CRYPTO_STATS
> -       .report_stat = crypto_ahash_report_stat,
>  #endif
>         .maskclear = ~CRYPTO_ALG_TYPE_MASK,
>         .maskset = CRYPTO_ALG_TYPE_AHASH_MASK,
>         .type = CRYPTO_ALG_TYPE_AHASH,
>         .tfmsize = offsetof(struct crypto_ahash, base),
>  };
>
>  int crypto_grab_ahash(struct crypto_ahash_spawn *spawn,
>                       struct crypto_instance *inst,
>                       const char *name, u32 type, u32 mask)
> diff --git a/crypto/akcipher.c b/crypto/akcipher.c
> index 52813f0b19e4e..e0ff5f4dda6d6 100644
> --- a/crypto/akcipher.c
> +++ b/crypto/akcipher.c
> @@ -63,56 +63,29 @@ static int crypto_akcipher_init_tfm(struct crypto_tfm *tfm)
>         return 0;
>  }
>
>  static void crypto_akcipher_free_instance(struct crypto_instance *inst)
>  {
>         struct akcipher_instance *akcipher = akcipher_instance(inst);
>
>         akcipher->free(akcipher);
>  }
>
> -static int __maybe_unused crypto_akcipher_report_stat(
> -       struct sk_buff *skb, struct crypto_alg *alg)
> -{
> -       struct akcipher_alg *akcipher = __crypto_akcipher_alg(alg);
> -       struct crypto_istat_akcipher *istat;
> -       struct crypto_stat_akcipher rakcipher;
> -
> -       istat = akcipher_get_stat(akcipher);
> -
> -       memset(&rakcipher, 0, sizeof(rakcipher));
> -
> -       strscpy(rakcipher.type, "akcipher", sizeof(rakcipher.type));
> -       rakcipher.stat_encrypt_cnt = atomic64_read(&istat->encrypt_cnt);
> -       rakcipher.stat_encrypt_tlen = atomic64_read(&istat->encrypt_tlen);
> -       rakcipher.stat_decrypt_cnt = atomic64_read(&istat->decrypt_cnt);
> -       rakcipher.stat_decrypt_tlen = atomic64_read(&istat->decrypt_tlen);
> -       rakcipher.stat_sign_cnt = atomic64_read(&istat->sign_cnt);
> -       rakcipher.stat_verify_cnt = atomic64_read(&istat->verify_cnt);
> -       rakcipher.stat_err_cnt = atomic64_read(&istat->err_cnt);
> -
> -       return nla_put(skb, CRYPTOCFGA_STAT_AKCIPHER,
> -                      sizeof(rakcipher), &rakcipher);
> -}
> -
>  static const struct crypto_type crypto_akcipher_type = {
>         .extsize = crypto_alg_extsize,
>         .init_tfm = crypto_akcipher_init_tfm,
>         .free = crypto_akcipher_free_instance,
>  #ifdef CONFIG_PROC_FS
>         .show = crypto_akcipher_show,
>  #endif
>  #if IS_ENABLED(CONFIG_CRYPTO_USER)
>         .report = crypto_akcipher_report,
> -#endif
> -#ifdef CONFIG_CRYPTO_STATS
> -       .report_stat = crypto_akcipher_report_stat,
>  #endif
>         .maskclear = ~CRYPTO_ALG_TYPE_MASK,
>         .maskset = CRYPTO_ALG_TYPE_AHASH_MASK,
>         .type = CRYPTO_ALG_TYPE_AKCIPHER,
>         .tfmsize = offsetof(struct crypto_akcipher, base),
>  };
>
>  int crypto_grab_akcipher(struct crypto_akcipher_spawn *spawn,
>                          struct crypto_instance *inst,
>                          const char *name, u32 type, u32 mask)
> @@ -124,29 +97,25 @@ EXPORT_SYMBOL_GPL(crypto_grab_akcipher);
>
>  struct crypto_akcipher *crypto_alloc_akcipher(const char *alg_name, u32 type,
>                                               u32 mask)
>  {
>         return crypto_alloc_tfm(alg_name, &crypto_akcipher_type, type, mask);
>  }
>  EXPORT_SYMBOL_GPL(crypto_alloc_akcipher);
>
>  static void akcipher_prepare_alg(struct akcipher_alg *alg)
>  {
> -       struct crypto_istat_akcipher *istat = akcipher_get_stat(alg);
>         struct crypto_alg *base = &alg->base;
>
>         base->cra_type = &crypto_akcipher_type;
>         base->cra_flags &= ~CRYPTO_ALG_TYPE_MASK;
>         base->cra_flags |= CRYPTO_ALG_TYPE_AKCIPHER;
> -
> -       if (IS_ENABLED(CONFIG_CRYPTO_STATS))
> -               memset(istat, 0, sizeof(*istat));
>  }
>
>  static int akcipher_default_op(struct akcipher_request *req)
>  {
>         return -ENOSYS;
>  }
>
>  static int akcipher_default_set_key(struct crypto_akcipher *tfm,
>                                      const void *key, unsigned int keylen)
>  {
> diff --git a/crypto/compress.h b/crypto/compress.h
> index 19f65516d699c..23ea43810810c 100644
> --- a/crypto/compress.h
> +++ b/crypto/compress.h
> @@ -5,22 +5,17 @@
>   * Copyright 2015 LG Electronics Inc.
>   * Copyright (c) 2016, Intel Corporation
>   * Copyright (c) 2023 Herbert Xu <herbert@gondor.apana.org.au>
>   */
>  #ifndef _LOCAL_CRYPTO_COMPRESS_H
>  #define _LOCAL_CRYPTO_COMPRESS_H
>
>  #include "internal.h"
>
>  struct acomp_req;
> -struct comp_alg_common;
>  struct sk_buff;
>
>  int crypto_init_scomp_ops_async(struct crypto_tfm *tfm);
>  struct acomp_req *crypto_acomp_scomp_alloc_ctx(struct acomp_req *req);
>  void crypto_acomp_scomp_free_ctx(struct acomp_req *req);
>
> -int crypto_acomp_report_stat(struct sk_buff *skb, struct crypto_alg *alg);
> -
> -void comp_prepare_alg(struct comp_alg_common *alg);
> -
>  #endif /* _LOCAL_CRYPTO_COMPRESS_H */
> diff --git a/crypto/crypto_user_base.c b/crypto/crypto_user.c
> similarity index 98%
> rename from crypto/crypto_user_base.c
> rename to crypto/crypto_user.c
> index 3fa20f12989f7..6c571834e86ad 100644
> --- a/crypto/crypto_user_base.c
> +++ b/crypto/crypto_user.c
> @@ -11,36 +11,35 @@
>  #include <linux/cryptouser.h>
>  #include <linux/sched.h>
>  #include <linux/security.h>
>  #include <net/netlink.h>
>  #include <net/net_namespace.h>
>  #include <net/sock.h>
>  #include <crypto/internal/skcipher.h>
>  #include <crypto/internal/rng.h>
>  #include <crypto/akcipher.h>
>  #include <crypto/kpp.h>
> -#include <crypto/internal/cryptouser.h>
>
>  #include "internal.h"
>
>  #define null_terminated(x)     (strnlen(x, sizeof(x)) < sizeof(x))
>
>  static DEFINE_MUTEX(crypto_cfg_mutex);
>
>  struct crypto_dump_info {
>         struct sk_buff *in_skb;
>         struct sk_buff *out_skb;
>         u32 nlmsg_seq;
>         u16 nlmsg_flags;
>  };
>
> -struct crypto_alg *crypto_alg_match(struct crypto_user_alg *p, int exact)
> +static struct crypto_alg *crypto_alg_match(struct crypto_user_alg *p, int exact)
>  {
>         struct crypto_alg *q, *alg = NULL;
>
>         down_read(&crypto_alg_sem);
>
>         list_for_each_entry(q, &crypto_alg_list, cra_list) {
>                 int match = 0;
>
>                 if (crypto_is_larval(q))
>                         continue;
> @@ -380,20 +379,27 @@ static int crypto_add_alg(struct sk_buff *skb, struct nlmsghdr *nlh,
>  }
>
>  static int crypto_del_rng(struct sk_buff *skb, struct nlmsghdr *nlh,
>                           struct nlattr **attrs)
>  {
>         if (!netlink_capable(skb, CAP_NET_ADMIN))
>                 return -EPERM;
>         return crypto_del_default_rng();
>  }
>
> +static int crypto_reportstat(struct sk_buff *in_skb, struct nlmsghdr *in_nlh,
> +                            struct nlattr **attrs)
> +{
> +       /* No longer supported */
> +       return -ENOTSUPP;
> +}
> +
>  #define MSGSIZE(type) sizeof(struct type)
>
>  static const int crypto_msg_min[CRYPTO_NR_MSGTYPES] = {
>         [CRYPTO_MSG_NEWALG      - CRYPTO_MSG_BASE] = MSGSIZE(crypto_user_alg),
>         [CRYPTO_MSG_DELALG      - CRYPTO_MSG_BASE] = MSGSIZE(crypto_user_alg),
>         [CRYPTO_MSG_UPDATEALG   - CRYPTO_MSG_BASE] = MSGSIZE(crypto_user_alg),
>         [CRYPTO_MSG_GETALG      - CRYPTO_MSG_BASE] = MSGSIZE(crypto_user_alg),
>         [CRYPTO_MSG_DELRNG      - CRYPTO_MSG_BASE] = 0,
>         [CRYPTO_MSG_GETSTAT     - CRYPTO_MSG_BASE] = MSGSIZE(crypto_user_alg),
>  };
> diff --git a/crypto/crypto_user_stat.c b/crypto/crypto_user_stat.c
> deleted file mode 100644
> index d4f3d39b51376..0000000000000
> --- a/crypto/crypto_user_stat.c
> +++ /dev/null
> @@ -1,176 +0,0 @@
> -// SPDX-License-Identifier: GPL-2.0
> -/*
> - * Crypto user configuration API.
> - *
> - * Copyright (C) 2017-2018 Corentin Labbe <clabbe@baylibre.com>
> - *
> - */
> -
> -#include <crypto/algapi.h>
> -#include <crypto/internal/cryptouser.h>
> -#include <linux/errno.h>
> -#include <linux/kernel.h>
> -#include <linux/module.h>
> -#include <linux/string.h>
> -#include <net/netlink.h>
> -#include <net/sock.h>
> -
> -#define null_terminated(x)     (strnlen(x, sizeof(x)) < sizeof(x))
> -
> -struct crypto_dump_info {
> -       struct sk_buff *in_skb;
> -       struct sk_buff *out_skb;
> -       u32 nlmsg_seq;
> -       u16 nlmsg_flags;
> -};
> -
> -static int crypto_report_cipher(struct sk_buff *skb, struct crypto_alg *alg)
> -{
> -       struct crypto_stat_cipher rcipher;
> -
> -       memset(&rcipher, 0, sizeof(rcipher));
> -
> -       strscpy(rcipher.type, "cipher", sizeof(rcipher.type));
> -
> -       return nla_put(skb, CRYPTOCFGA_STAT_CIPHER, sizeof(rcipher), &rcipher);
> -}
> -
> -static int crypto_report_comp(struct sk_buff *skb, struct crypto_alg *alg)
> -{
> -       struct crypto_stat_compress rcomp;
> -
> -       memset(&rcomp, 0, sizeof(rcomp));
> -
> -       strscpy(rcomp.type, "compression", sizeof(rcomp.type));
> -
> -       return nla_put(skb, CRYPTOCFGA_STAT_COMPRESS, sizeof(rcomp), &rcomp);
> -}
> -
> -static int crypto_reportstat_one(struct crypto_alg *alg,
> -                                struct crypto_user_alg *ualg,
> -                                struct sk_buff *skb)
> -{
> -       memset(ualg, 0, sizeof(*ualg));
> -
> -       strscpy(ualg->cru_name, alg->cra_name, sizeof(ualg->cru_name));
> -       strscpy(ualg->cru_driver_name, alg->cra_driver_name,
> -               sizeof(ualg->cru_driver_name));
> -       strscpy(ualg->cru_module_name, module_name(alg->cra_module),
> -               sizeof(ualg->cru_module_name));
> -
> -       ualg->cru_type = 0;
> -       ualg->cru_mask = 0;
> -       ualg->cru_flags = alg->cra_flags;
> -       ualg->cru_refcnt = refcount_read(&alg->cra_refcnt);
> -
> -       if (nla_put_u32(skb, CRYPTOCFGA_PRIORITY_VAL, alg->cra_priority))
> -               goto nla_put_failure;
> -       if (alg->cra_flags & CRYPTO_ALG_LARVAL) {
> -               struct crypto_stat_larval rl;
> -
> -               memset(&rl, 0, sizeof(rl));
> -               strscpy(rl.type, "larval", sizeof(rl.type));
> -               if (nla_put(skb, CRYPTOCFGA_STAT_LARVAL, sizeof(rl), &rl))
> -                       goto nla_put_failure;
> -               goto out;
> -       }
> -
> -       if (alg->cra_type && alg->cra_type->report_stat) {
> -               if (alg->cra_type->report_stat(skb, alg))
> -                       goto nla_put_failure;
> -               goto out;
> -       }
> -
> -       switch (alg->cra_flags & (CRYPTO_ALG_TYPE_MASK | CRYPTO_ALG_LARVAL)) {
> -       case CRYPTO_ALG_TYPE_CIPHER:
> -               if (crypto_report_cipher(skb, alg))
> -                       goto nla_put_failure;
> -               break;
> -       case CRYPTO_ALG_TYPE_COMPRESS:
> -               if (crypto_report_comp(skb, alg))
> -                       goto nla_put_failure;
> -               break;
> -       default:
> -               pr_err("ERROR: Unhandled alg %d in %s\n",
> -                      alg->cra_flags & (CRYPTO_ALG_TYPE_MASK | CRYPTO_ALG_LARVAL),
> -                      __func__);
> -       }
> -
> -out:
> -       return 0;
> -
> -nla_put_failure:
> -       return -EMSGSIZE;
> -}
> -
> -static int crypto_reportstat_alg(struct crypto_alg *alg,
> -                                struct crypto_dump_info *info)
> -{
> -       struct sk_buff *in_skb = info->in_skb;
> -       struct sk_buff *skb = info->out_skb;
> -       struct nlmsghdr *nlh;
> -       struct crypto_user_alg *ualg;
> -       int err = 0;
> -
> -       nlh = nlmsg_put(skb, NETLINK_CB(in_skb).portid, info->nlmsg_seq,
> -                       CRYPTO_MSG_GETSTAT, sizeof(*ualg), info->nlmsg_flags);
> -       if (!nlh) {
> -               err = -EMSGSIZE;
> -               goto out;
> -       }
> -
> -       ualg = nlmsg_data(nlh);
> -
> -       err = crypto_reportstat_one(alg, ualg, skb);
> -       if (err) {
> -               nlmsg_cancel(skb, nlh);
> -               goto out;
> -       }
> -
> -       nlmsg_end(skb, nlh);
> -
> -out:
> -       return err;
> -}
> -
> -int crypto_reportstat(struct sk_buff *in_skb, struct nlmsghdr *in_nlh,
> -                     struct nlattr **attrs)
> -{
> -       struct net *net = sock_net(in_skb->sk);
> -       struct crypto_user_alg *p = nlmsg_data(in_nlh);
> -       struct crypto_alg *alg;
> -       struct sk_buff *skb;
> -       struct crypto_dump_info info;
> -       int err;
> -
> -       if (!null_terminated(p->cru_name) || !null_terminated(p->cru_driver_name))
> -               return -EINVAL;
> -
> -       alg = crypto_alg_match(p, 0);
> -       if (!alg)
> -               return -ENOENT;
> -
> -       err = -ENOMEM;
> -       skb = nlmsg_new(NLMSG_DEFAULT_SIZE, GFP_ATOMIC);
> -       if (!skb)
> -               goto drop_alg;
> -
> -       info.in_skb = in_skb;
> -       info.out_skb = skb;
> -       info.nlmsg_seq = in_nlh->nlmsg_seq;
> -       info.nlmsg_flags = 0;
> -
> -       err = crypto_reportstat_alg(alg, &info);
> -
> -drop_alg:
> -       crypto_mod_put(alg);
> -
> -       if (err) {
> -               kfree_skb(skb);
> -               return err;
> -       }
> -
> -       return nlmsg_unicast(net->crypto_nlsk, skb, NETLINK_CB(in_skb).portid);
> -}
> -
> -MODULE_LICENSE("GPL");
> diff --git a/crypto/hash.h b/crypto/hash.h
> index 93f6ba0df263e..cf9aee07f77d4 100644
> --- a/crypto/hash.h
> +++ b/crypto/hash.h
> @@ -1,48 +1,18 @@
>  /* SPDX-License-Identifier: GPL-2.0-or-later */
>  /*
>   * Cryptographic API.
>   *
>   * Copyright (c) 2023 Herbert Xu <herbert@gondor.apana.org.au>
>   */
>  #ifndef _LOCAL_CRYPTO_HASH_H
>  #define _LOCAL_CRYPTO_HASH_H
>
>  #include <crypto/internal/hash.h>
> -#include <linux/cryptouser.h>
>
>  #include "internal.h"
>
> -static inline struct crypto_istat_hash *hash_get_stat(
> -       struct hash_alg_common *alg)
> -{
> -#ifdef CONFIG_CRYPTO_STATS
> -       return &alg->stat;
> -#else
> -       return NULL;
> -#endif
> -}
> -
> -static inline int crypto_hash_report_stat(struct sk_buff *skb,
> -                                         struct crypto_alg *alg,
> -                                         const char *type)
> -{
> -       struct hash_alg_common *halg = __crypto_hash_alg_common(alg);
> -       struct crypto_istat_hash *istat = hash_get_stat(halg);
> -       struct crypto_stat_hash rhash;
> -
> -       memset(&rhash, 0, sizeof(rhash));
> -
> -       strscpy(rhash.type, type, sizeof(rhash.type));
> -
> -       rhash.stat_hash_cnt = atomic64_read(&istat->hash_cnt);
> -       rhash.stat_hash_tlen = atomic64_read(&istat->hash_tlen);
> -       rhash.stat_err_cnt = atomic64_read(&istat->err_cnt);
> -
> -       return nla_put(skb, CRYPTOCFGA_STAT_HASH, sizeof(rhash), &rhash);
> -}
> -
>  extern const struct crypto_type crypto_shash_type;
>
>  int hash_prepare_alg(struct hash_alg_common *alg);
>
>  #endif /* _LOCAL_CRYPTO_HASH_H */
> diff --git a/crypto/kpp.c b/crypto/kpp.c
> index 33d44e59387ff..ecc63a1a948df 100644
> --- a/crypto/kpp.c
> +++ b/crypto/kpp.c
> @@ -59,55 +59,29 @@ static int crypto_kpp_init_tfm(struct crypto_tfm *tfm)
>         return 0;
>  }
>
>  static void crypto_kpp_free_instance(struct crypto_instance *inst)
>  {
>         struct kpp_instance *kpp = kpp_instance(inst);
>
>         kpp->free(kpp);
>  }
>
> -static int __maybe_unused crypto_kpp_report_stat(
> -       struct sk_buff *skb, struct crypto_alg *alg)
> -{
> -       struct kpp_alg *kpp = __crypto_kpp_alg(alg);
> -       struct crypto_istat_kpp *istat;
> -       struct crypto_stat_kpp rkpp;
> -
> -       istat = kpp_get_stat(kpp);
> -
> -       memset(&rkpp, 0, sizeof(rkpp));
> -
> -       strscpy(rkpp.type, "kpp", sizeof(rkpp.type));
> -
> -       rkpp.stat_setsecret_cnt = atomic64_read(&istat->setsecret_cnt);
> -       rkpp.stat_generate_public_key_cnt =
> -               atomic64_read(&istat->generate_public_key_cnt);
> -       rkpp.stat_compute_shared_secret_cnt =
> -               atomic64_read(&istat->compute_shared_secret_cnt);
> -       rkpp.stat_err_cnt = atomic64_read(&istat->err_cnt);
> -
> -       return nla_put(skb, CRYPTOCFGA_STAT_KPP, sizeof(rkpp), &rkpp);
> -}
> -
>  static const struct crypto_type crypto_kpp_type = {
>         .extsize = crypto_alg_extsize,
>         .init_tfm = crypto_kpp_init_tfm,
>         .free = crypto_kpp_free_instance,
>  #ifdef CONFIG_PROC_FS
>         .show = crypto_kpp_show,
>  #endif
>  #if IS_ENABLED(CONFIG_CRYPTO_USER)
>         .report = crypto_kpp_report,
> -#endif
> -#ifdef CONFIG_CRYPTO_STATS
> -       .report_stat = crypto_kpp_report_stat,
>  #endif
>         .maskclear = ~CRYPTO_ALG_TYPE_MASK,
>         .maskset = CRYPTO_ALG_TYPE_MASK,
>         .type = CRYPTO_ALG_TYPE_KPP,
>         .tfmsize = offsetof(struct crypto_kpp, base),
>  };
>
>  struct crypto_kpp *crypto_alloc_kpp(const char *alg_name, u32 type, u32 mask)
>  {
>         return crypto_alloc_tfm(alg_name, &crypto_kpp_type, type, mask);
> @@ -124,29 +98,25 @@ int crypto_grab_kpp(struct crypto_kpp_spawn *spawn,
>  EXPORT_SYMBOL_GPL(crypto_grab_kpp);
>
>  int crypto_has_kpp(const char *alg_name, u32 type, u32 mask)
>  {
>         return crypto_type_has_alg(alg_name, &crypto_kpp_type, type, mask);
>  }
>  EXPORT_SYMBOL_GPL(crypto_has_kpp);
>
>  static void kpp_prepare_alg(struct kpp_alg *alg)
>  {
> -       struct crypto_istat_kpp *istat = kpp_get_stat(alg);
>         struct crypto_alg *base = &alg->base;
>
>         base->cra_type = &crypto_kpp_type;
>         base->cra_flags &= ~CRYPTO_ALG_TYPE_MASK;
>         base->cra_flags |= CRYPTO_ALG_TYPE_KPP;
> -
> -       if (IS_ENABLED(CONFIG_CRYPTO_STATS))
> -               memset(istat, 0, sizeof(*istat));
>  }
>
>  int crypto_register_kpp(struct kpp_alg *alg)
>  {
>         struct crypto_alg *base = &alg->base;
>
>         kpp_prepare_alg(alg);
>         return crypto_register_alg(base);
>  }
>  EXPORT_SYMBOL_GPL(crypto_register_kpp);
> diff --git a/crypto/lskcipher.c b/crypto/lskcipher.c
> index 0b6dd8aa21f2e..0a800292ca4e3 100644
> --- a/crypto/lskcipher.c
> +++ b/crypto/lskcipher.c
> @@ -22,39 +22,20 @@ static inline struct crypto_lskcipher *__crypto_lskcipher_cast(
>  {
>         return container_of(tfm, struct crypto_lskcipher, base);
>  }
>
>  static inline struct lskcipher_alg *__crypto_lskcipher_alg(
>         struct crypto_alg *alg)
>  {
>         return container_of(alg, struct lskcipher_alg, co.base);
>  }
>
> -static inline struct crypto_istat_cipher *lskcipher_get_stat(
> -       struct lskcipher_alg *alg)
> -{
> -       return skcipher_get_stat_common(&alg->co);
> -}
> -
> -static inline int crypto_lskcipher_errstat(struct lskcipher_alg *alg, int err)
> -{
> -       struct crypto_istat_cipher *istat = lskcipher_get_stat(alg);
> -
> -       if (!IS_ENABLED(CONFIG_CRYPTO_STATS))
> -               return err;
> -
> -       if (err)
> -               atomic64_inc(&istat->err_cnt);
> -
> -       return err;
> -}
> -
>  static int lskcipher_setkey_unaligned(struct crypto_lskcipher *tfm,
>                                       const u8 *key, unsigned int keylen)
>  {
>         unsigned long alignmask = crypto_lskcipher_alignmask(tfm);
>         struct lskcipher_alg *cipher = crypto_lskcipher_alg(tfm);
>         u8 *buffer, *alignbuffer;
>         unsigned long absize;
>         int ret;
>
>         absize = keylen + alignmask;
> @@ -140,64 +121,43 @@ static int crypto_lskcipher_crypt_unaligned(
>  }
>
>  static int crypto_lskcipher_crypt(struct crypto_lskcipher *tfm, const u8 *src,
>                                   u8 *dst, unsigned len, u8 *iv,
>                                   int (*crypt)(struct crypto_lskcipher *tfm,
>                                                const u8 *src, u8 *dst,
>                                                unsigned len, u8 *iv,
>                                                u32 flags))
>  {
>         unsigned long alignmask = crypto_lskcipher_alignmask(tfm);
> -       struct lskcipher_alg *alg = crypto_lskcipher_alg(tfm);
> -       int ret;
>
>         if (((unsigned long)src | (unsigned long)dst | (unsigned long)iv) &
> -           alignmask) {
> -               ret = crypto_lskcipher_crypt_unaligned(tfm, src, dst, len, iv,
> -                                                      crypt);
> -               goto out;
> -       }
> +           alignmask)
> +               return crypto_lskcipher_crypt_unaligned(tfm, src, dst, len, iv,
> +                                                       crypt);
>
> -       ret = crypt(tfm, src, dst, len, iv, CRYPTO_LSKCIPHER_FLAG_FINAL);
> -
> -out:
> -       return crypto_lskcipher_errstat(alg, ret);
> +       return crypt(tfm, src, dst, len, iv, CRYPTO_LSKCIPHER_FLAG_FINAL);
>  }
>
>  int crypto_lskcipher_encrypt(struct crypto_lskcipher *tfm, const u8 *src,
>                              u8 *dst, unsigned len, u8 *iv)
>  {
>         struct lskcipher_alg *alg = crypto_lskcipher_alg(tfm);
>
> -       if (IS_ENABLED(CONFIG_CRYPTO_STATS)) {
> -               struct crypto_istat_cipher *istat = lskcipher_get_stat(alg);
> -
> -               atomic64_inc(&istat->encrypt_cnt);
> -               atomic64_add(len, &istat->encrypt_tlen);
> -       }
> -
>         return crypto_lskcipher_crypt(tfm, src, dst, len, iv, alg->encrypt);
>  }
>  EXPORT_SYMBOL_GPL(crypto_lskcipher_encrypt);
>
>  int crypto_lskcipher_decrypt(struct crypto_lskcipher *tfm, const u8 *src,
>                              u8 *dst, unsigned len, u8 *iv)
>  {
>         struct lskcipher_alg *alg = crypto_lskcipher_alg(tfm);
>
> -       if (IS_ENABLED(CONFIG_CRYPTO_STATS)) {
> -               struct crypto_istat_cipher *istat = lskcipher_get_stat(alg);
> -
> -               atomic64_inc(&istat->decrypt_cnt);
> -               atomic64_add(len, &istat->decrypt_tlen);
> -       }
> -
>         return crypto_lskcipher_crypt(tfm, src, dst, len, iv, alg->decrypt);
>  }
>  EXPORT_SYMBOL_GPL(crypto_lskcipher_decrypt);
>
>  static int crypto_lskcipher_crypt_sg(struct skcipher_request *req,
>                                      int (*crypt)(struct crypto_lskcipher *tfm,
>                                                   const u8 *src, u8 *dst,
>                                                   unsigned len, u8 *ivs,
>                                                   u32 flags))
>  {
> @@ -315,54 +275,29 @@ static int __maybe_unused crypto_lskcipher_report(
>
>         rblkcipher.blocksize = alg->cra_blocksize;
>         rblkcipher.min_keysize = skcipher->co.min_keysize;
>         rblkcipher.max_keysize = skcipher->co.max_keysize;
>         rblkcipher.ivsize = skcipher->co.ivsize;
>
>         return nla_put(skb, CRYPTOCFGA_REPORT_BLKCIPHER,
>                        sizeof(rblkcipher), &rblkcipher);
>  }
>
> -static int __maybe_unused crypto_lskcipher_report_stat(
> -       struct sk_buff *skb, struct crypto_alg *alg)
> -{
> -       struct lskcipher_alg *skcipher = __crypto_lskcipher_alg(alg);
> -       struct crypto_istat_cipher *istat;
> -       struct crypto_stat_cipher rcipher;
> -
> -       istat = lskcipher_get_stat(skcipher);
> -
> -       memset(&rcipher, 0, sizeof(rcipher));
> -
> -       strscpy(rcipher.type, "cipher", sizeof(rcipher.type));
> -
> -       rcipher.stat_encrypt_cnt = atomic64_read(&istat->encrypt_cnt);
> -       rcipher.stat_encrypt_tlen = atomic64_read(&istat->encrypt_tlen);
> -       rcipher.stat_decrypt_cnt =  atomic64_read(&istat->decrypt_cnt);
> -       rcipher.stat_decrypt_tlen = atomic64_read(&istat->decrypt_tlen);
> -       rcipher.stat_err_cnt =  atomic64_read(&istat->err_cnt);
> -
> -       return nla_put(skb, CRYPTOCFGA_STAT_CIPHER, sizeof(rcipher), &rcipher);
> -}
> -
>  static const struct crypto_type crypto_lskcipher_type = {
>         .extsize = crypto_alg_extsize,
>         .init_tfm = crypto_lskcipher_init_tfm,
>         .free = crypto_lskcipher_free_instance,
>  #ifdef CONFIG_PROC_FS
>         .show = crypto_lskcipher_show,
>  #endif
>  #if IS_ENABLED(CONFIG_CRYPTO_USER)
>         .report = crypto_lskcipher_report,
> -#endif
> -#ifdef CONFIG_CRYPTO_STATS
> -       .report_stat = crypto_lskcipher_report_stat,
>  #endif
>         .maskclear = ~CRYPTO_ALG_TYPE_MASK,
>         .maskset = CRYPTO_ALG_TYPE_MASK,
>         .type = CRYPTO_ALG_TYPE_LSKCIPHER,
>         .tfmsize = offsetof(struct crypto_lskcipher, base),
>  };
>
>  static void crypto_lskcipher_exit_tfm_sg(struct crypto_tfm *tfm)
>  {
>         struct crypto_lskcipher **ctx = crypto_tfm_ctx(tfm);
> diff --git a/crypto/rng.c b/crypto/rng.c
> index 279dffdebf598..9d8804e464226 100644
> --- a/crypto/rng.c
> +++ b/crypto/rng.c
> @@ -23,44 +23,38 @@
>
>  #include "internal.h"
>
>  static DEFINE_MUTEX(crypto_default_rng_lock);
>  struct crypto_rng *crypto_default_rng;
>  EXPORT_SYMBOL_GPL(crypto_default_rng);
>  static int crypto_default_rng_refcnt;
>
>  int crypto_rng_reset(struct crypto_rng *tfm, const u8 *seed, unsigned int slen)
>  {
> -       struct rng_alg *alg = crypto_rng_alg(tfm);
>         u8 *buf = NULL;
>         int err;
>
> -       if (IS_ENABLED(CONFIG_CRYPTO_STATS))
> -               atomic64_inc(&rng_get_stat(alg)->seed_cnt);
> -
>         if (!seed && slen) {
>                 buf = kmalloc(slen, GFP_KERNEL);
> -               err = -ENOMEM;
>                 if (!buf)
> -                       goto out;
> +                       return -ENOMEM;
>
>                 err = get_random_bytes_wait(buf, slen);
>                 if (err)
> -                       goto free_buf;
> +                       goto out;
>                 seed = buf;
>         }
>
> -       err = alg->seed(tfm, seed, slen);
> -free_buf:
> -       kfree_sensitive(buf);
> +       err = crypto_rng_alg(tfm)->seed(tfm, seed, slen);
>  out:
> -       return crypto_rng_errstat(alg, err);
> +       kfree_sensitive(buf);
> +       return err;
>  }
>  EXPORT_SYMBOL_GPL(crypto_rng_reset);
>
>  static int crypto_rng_init_tfm(struct crypto_tfm *tfm)
>  {
>         return 0;
>  }
>
>  static unsigned int seedsize(struct crypto_alg *alg)
>  {
> @@ -84,52 +78,28 @@ static int __maybe_unused crypto_rng_report(
>  }
>
>  static void crypto_rng_show(struct seq_file *m, struct crypto_alg *alg)
>         __maybe_unused;
>  static void crypto_rng_show(struct seq_file *m, struct crypto_alg *alg)
>  {
>         seq_printf(m, "type         : rng\n");
>         seq_printf(m, "seedsize     : %u\n", seedsize(alg));
>  }
>
> -static int __maybe_unused crypto_rng_report_stat(
> -       struct sk_buff *skb, struct crypto_alg *alg)
> -{
> -       struct rng_alg *rng = __crypto_rng_alg(alg);
> -       struct crypto_istat_rng *istat;
> -       struct crypto_stat_rng rrng;
> -
> -       istat = rng_get_stat(rng);
> -
> -       memset(&rrng, 0, sizeof(rrng));
> -
> -       strscpy(rrng.type, "rng", sizeof(rrng.type));
> -
> -       rrng.stat_generate_cnt = atomic64_read(&istat->generate_cnt);
> -       rrng.stat_generate_tlen = atomic64_read(&istat->generate_tlen);
> -       rrng.stat_seed_cnt = atomic64_read(&istat->seed_cnt);
> -       rrng.stat_err_cnt = atomic64_read(&istat->err_cnt);
> -
> -       return nla_put(skb, CRYPTOCFGA_STAT_RNG, sizeof(rrng), &rrng);
> -}
> -
>  static const struct crypto_type crypto_rng_type = {
>         .extsize = crypto_alg_extsize,
>         .init_tfm = crypto_rng_init_tfm,
>  #ifdef CONFIG_PROC_FS
>         .show = crypto_rng_show,
>  #endif
>  #if IS_ENABLED(CONFIG_CRYPTO_USER)
>         .report = crypto_rng_report,
> -#endif
> -#ifdef CONFIG_CRYPTO_STATS
> -       .report_stat = crypto_rng_report_stat,
>  #endif
>         .maskclear = ~CRYPTO_ALG_TYPE_MASK,
>         .maskset = CRYPTO_ALG_TYPE_MASK,
>         .type = CRYPTO_ALG_TYPE_RNG,
>         .tfmsize = offsetof(struct crypto_rng, base),
>  };
>
>  struct crypto_rng *crypto_alloc_rng(const char *alg_name, u32 type, u32 mask)
>  {
>         return crypto_alloc_tfm(alg_name, &crypto_rng_type, type, mask);
> @@ -192,33 +162,29 @@ int crypto_del_default_rng(void)
>  out:
>         mutex_unlock(&crypto_default_rng_lock);
>
>         return err;
>  }
>  EXPORT_SYMBOL_GPL(crypto_del_default_rng);
>  #endif
>
>  int crypto_register_rng(struct rng_alg *alg)
>  {
> -       struct crypto_istat_rng *istat = rng_get_stat(alg);
>         struct crypto_alg *base = &alg->base;
>
>         if (alg->seedsize > PAGE_SIZE / 8)
>                 return -EINVAL;
>
>         base->cra_type = &crypto_rng_type;
>         base->cra_flags &= ~CRYPTO_ALG_TYPE_MASK;
>         base->cra_flags |= CRYPTO_ALG_TYPE_RNG;
>
> -       if (IS_ENABLED(CONFIG_CRYPTO_STATS))
> -               memset(istat, 0, sizeof(*istat));
> -
>         return crypto_register_alg(base);
>  }
>  EXPORT_SYMBOL_GPL(crypto_register_rng);
>
>  void crypto_unregister_rng(struct rng_alg *alg)
>  {
>         crypto_unregister_alg(&alg->base);
>  }
>  EXPORT_SYMBOL_GPL(crypto_unregister_rng);
>
> diff --git a/crypto/scompress.c b/crypto/scompress.c
> index b108a30a76001..9cda4ef84a9bb 100644
> --- a/crypto/scompress.c
> +++ b/crypto/scompress.c
> @@ -241,37 +241,33 @@ void crypto_acomp_scomp_free_ctx(struct acomp_req *req)
>  }
>
>  static const struct crypto_type crypto_scomp_type = {
>         .extsize = crypto_alg_extsize,
>         .init_tfm = crypto_scomp_init_tfm,
>  #ifdef CONFIG_PROC_FS
>         .show = crypto_scomp_show,
>  #endif
>  #if IS_ENABLED(CONFIG_CRYPTO_USER)
>         .report = crypto_scomp_report,
> -#endif
> -#ifdef CONFIG_CRYPTO_STATS
> -       .report_stat = crypto_acomp_report_stat,
>  #endif
>         .maskclear = ~CRYPTO_ALG_TYPE_MASK,
>         .maskset = CRYPTO_ALG_TYPE_MASK,
>         .type = CRYPTO_ALG_TYPE_SCOMPRESS,
>         .tfmsize = offsetof(struct crypto_scomp, base),
>  };
>
>  int crypto_register_scomp(struct scomp_alg *alg)
>  {
> -       struct crypto_alg *base = &alg->calg.base;
> -
> -       comp_prepare_alg(&alg->calg);
> +       struct crypto_alg *base = &alg->base;
>
>         base->cra_type = &crypto_scomp_type;
> +       base->cra_flags &= ~CRYPTO_ALG_TYPE_MASK;
>         base->cra_flags |= CRYPTO_ALG_TYPE_SCOMPRESS;
>
>         return crypto_register_alg(base);
>  }
>  EXPORT_SYMBOL_GPL(crypto_register_scomp);
>
>  void crypto_unregister_scomp(struct scomp_alg *alg)
>  {
>         crypto_unregister_alg(&alg->base);
>  }
> diff --git a/crypto/shash.c b/crypto/shash.c
> index c3f7f6a252803..0ffe671b519e1 100644
> --- a/crypto/shash.c
> +++ b/crypto/shash.c
> @@ -9,32 +9,20 @@
>  #include <linux/cryptouser.h>
>  #include <linux/err.h>
>  #include <linux/kernel.h>
>  #include <linux/module.h>
>  #include <linux/seq_file.h>
>  #include <linux/string.h>
>  #include <net/netlink.h>
>
>  #include "hash.h"
>
> -static inline struct crypto_istat_hash *shash_get_stat(struct shash_alg *alg)
> -{
> -       return hash_get_stat(&alg->halg);
> -}
> -
> -static inline int crypto_shash_errstat(struct shash_alg *alg, int err)
> -{
> -       if (IS_ENABLED(CONFIG_CRYPTO_STATS) && err)
> -               atomic64_inc(&shash_get_stat(alg)->err_cnt);
> -       return err;
> -}
> -
>  int shash_no_setkey(struct crypto_shash *tfm, const u8 *key,
>                     unsigned int keylen)
>  {
>         return -ENOSYS;
>  }
>  EXPORT_SYMBOL_GPL(shash_no_setkey);
>
>  static void shash_set_needkey(struct crypto_shash *tfm, struct shash_alg *alg)
>  {
>         if (crypto_shash_alg_needs_key(alg))
> @@ -54,104 +42,64 @@ int crypto_shash_setkey(struct crypto_shash *tfm, const u8 *key,
>         }
>
>         crypto_shash_clear_flags(tfm, CRYPTO_TFM_NEED_KEY);
>         return 0;
>  }
>  EXPORT_SYMBOL_GPL(crypto_shash_setkey);
>
>  int crypto_shash_update(struct shash_desc *desc, const u8 *data,
>                         unsigned int len)
>  {
> -       struct shash_alg *shash = crypto_shash_alg(desc->tfm);
> -       int err;
> -
> -       if (IS_ENABLED(CONFIG_CRYPTO_STATS))
> -               atomic64_add(len, &shash_get_stat(shash)->hash_tlen);
> -
> -       err = shash->update(desc, data, len);
> -
> -       return crypto_shash_errstat(shash, err);
> +       return crypto_shash_alg(desc->tfm)->update(desc, data, len);
>  }
>  EXPORT_SYMBOL_GPL(crypto_shash_update);
>
>  int crypto_shash_final(struct shash_desc *desc, u8 *out)
>  {
> -       struct shash_alg *shash = crypto_shash_alg(desc->tfm);
> -       int err;
> -
> -       if (IS_ENABLED(CONFIG_CRYPTO_STATS))
> -               atomic64_inc(&shash_get_stat(shash)->hash_cnt);
> -
> -       err = shash->final(desc, out);
> -
> -       return crypto_shash_errstat(shash, err);
> +       return crypto_shash_alg(desc->tfm)->final(desc, out);
>  }
>  EXPORT_SYMBOL_GPL(crypto_shash_final);
>
>  static int shash_default_finup(struct shash_desc *desc, const u8 *data,
>                                unsigned int len, u8 *out)
>  {
>         struct shash_alg *shash = crypto_shash_alg(desc->tfm);
>
>         return shash->update(desc, data, len) ?:
>                shash->final(desc, out);
>  }
>
>  int crypto_shash_finup(struct shash_desc *desc, const u8 *data,
>                        unsigned int len, u8 *out)
>  {
> -       struct crypto_shash *tfm = desc->tfm;
> -       struct shash_alg *shash = crypto_shash_alg(tfm);
> -       int err;
> -
> -       if (IS_ENABLED(CONFIG_CRYPTO_STATS)) {
> -               struct crypto_istat_hash *istat = shash_get_stat(shash);
> -
> -               atomic64_inc(&istat->hash_cnt);
> -               atomic64_add(len, &istat->hash_tlen);
> -       }
> -
> -       err = shash->finup(desc, data, len, out);
> -
> -       return crypto_shash_errstat(shash, err);
> +       return crypto_shash_alg(desc->tfm)->finup(desc, data, len, out);
>  }
>  EXPORT_SYMBOL_GPL(crypto_shash_finup);
>
>  static int shash_default_digest(struct shash_desc *desc, const u8 *data,
>                                 unsigned int len, u8 *out)
>  {
>         struct shash_alg *shash = crypto_shash_alg(desc->tfm);
>
>         return shash->init(desc) ?:
>                shash->finup(desc, data, len, out);
>  }
>
>  int crypto_shash_digest(struct shash_desc *desc, const u8 *data,
>                         unsigned int len, u8 *out)
>  {
>         struct crypto_shash *tfm = desc->tfm;
> -       struct shash_alg *shash = crypto_shash_alg(tfm);
> -       int err;
> -
> -       if (IS_ENABLED(CONFIG_CRYPTO_STATS)) {
> -               struct crypto_istat_hash *istat = shash_get_stat(shash);
> -
> -               atomic64_inc(&istat->hash_cnt);
> -               atomic64_add(len, &istat->hash_tlen);
> -       }
>
>         if (crypto_shash_get_flags(tfm) & CRYPTO_TFM_NEED_KEY)
> -               err = -ENOKEY;
> -       else
> -               err = shash->digest(desc, data, len, out);
> +               return -ENOKEY;
>
> -       return crypto_shash_errstat(shash, err);
> +       return crypto_shash_alg(desc->tfm)->digest(desc, data, len, out);
>  }
>  EXPORT_SYMBOL_GPL(crypto_shash_digest);
>
>  int crypto_shash_tfm_digest(struct crypto_shash *tfm, const u8 *data,
>                             unsigned int len, u8 *out)
>  {
>         SHASH_DESC_ON_STACK(desc, tfm);
>         int err;
>
>         desc->tfm = tfm;
> @@ -258,38 +206,29 @@ static void crypto_shash_show(struct seq_file *m, struct crypto_alg *alg)
>         __maybe_unused;
>  static void crypto_shash_show(struct seq_file *m, struct crypto_alg *alg)
>  {
>         struct shash_alg *salg = __crypto_shash_alg(alg);
>
>         seq_printf(m, "type         : shash\n");
>         seq_printf(m, "blocksize    : %u\n", alg->cra_blocksize);
>         seq_printf(m, "digestsize   : %u\n", salg->digestsize);
>  }
>
> -static int __maybe_unused crypto_shash_report_stat(
> -       struct sk_buff *skb, struct crypto_alg *alg)
> -{
> -       return crypto_hash_report_stat(skb, alg, "shash");
> -}
> -
>  const struct crypto_type crypto_shash_type = {
>         .extsize = crypto_alg_extsize,
>         .init_tfm = crypto_shash_init_tfm,
>         .free = crypto_shash_free_instance,
>  #ifdef CONFIG_PROC_FS
>         .show = crypto_shash_show,
>  #endif
>  #if IS_ENABLED(CONFIG_CRYPTO_USER)
>         .report = crypto_shash_report,
> -#endif
> -#ifdef CONFIG_CRYPTO_STATS
> -       .report_stat = crypto_shash_report_stat,
>  #endif
>         .maskclear = ~CRYPTO_ALG_TYPE_MASK,
>         .maskset = CRYPTO_ALG_TYPE_MASK,
>         .type = CRYPTO_ALG_TYPE_SHASH,
>         .tfmsize = offsetof(struct crypto_shash, base),
>  };
>
>  int crypto_grab_shash(struct crypto_shash_spawn *spawn,
>                       struct crypto_instance *inst,
>                       const char *name, u32 type, u32 mask)
> @@ -343,35 +282,31 @@ struct crypto_shash *crypto_clone_shash(struct crypto_shash *hash)
>                         return ERR_PTR(err);
>                 }
>         }
>
>         return nhash;
>  }
>  EXPORT_SYMBOL_GPL(crypto_clone_shash);
>
>  int hash_prepare_alg(struct hash_alg_common *alg)
>  {
> -       struct crypto_istat_hash *istat = hash_get_stat(alg);
>         struct crypto_alg *base = &alg->base;
>
>         if (alg->digestsize > HASH_MAX_DIGESTSIZE)
>                 return -EINVAL;
>
>         /* alignmask is not useful for hashes, so it is not supported. */
>         if (base->cra_alignmask)
>                 return -EINVAL;
>
>         base->cra_flags &= ~CRYPTO_ALG_TYPE_MASK;
>
> -       if (IS_ENABLED(CONFIG_CRYPTO_STATS))
> -               memset(istat, 0, sizeof(*istat));
> -
>         return 0;
>  }
>
>  static int shash_prepare_alg(struct shash_alg *alg)
>  {
>         struct crypto_alg *base = &alg->halg.base;
>         int err;
>
>         if (alg->descsize > HASH_MAX_DESCSIZE)
>                 return -EINVAL;
> diff --git a/crypto/sig.c b/crypto/sig.c
> index 224c470192977..7645bedf3a1fd 100644
> --- a/crypto/sig.c
> +++ b/crypto/sig.c
> @@ -38,41 +38,28 @@ static void __maybe_unused crypto_sig_show(struct seq_file *m,
>  static int __maybe_unused crypto_sig_report(struct sk_buff *skb,
>                                             struct crypto_alg *alg)
>  {
>         struct crypto_report_akcipher rsig = {};
>
>         strscpy(rsig.type, "sig", sizeof(rsig.type));
>
>         return nla_put(skb, CRYPTOCFGA_REPORT_AKCIPHER, sizeof(rsig), &rsig);
>  }
>
> -static int __maybe_unused crypto_sig_report_stat(struct sk_buff *skb,
> -                                                struct crypto_alg *alg)
> -{
> -       struct crypto_stat_akcipher rsig = {};
> -
> -       strscpy(rsig.type, "sig", sizeof(rsig.type));
> -
> -       return nla_put(skb, CRYPTOCFGA_STAT_AKCIPHER, sizeof(rsig), &rsig);
> -}
> -
>  static const struct crypto_type crypto_sig_type = {
>         .extsize = crypto_alg_extsize,
>         .init_tfm = crypto_sig_init_tfm,
>  #ifdef CONFIG_PROC_FS
>         .show = crypto_sig_show,
>  #endif
>  #if IS_ENABLED(CONFIG_CRYPTO_USER)
>         .report = crypto_sig_report,
> -#endif
> -#ifdef CONFIG_CRYPTO_STATS
> -       .report_stat = crypto_sig_report_stat,
>  #endif
>         .maskclear = ~CRYPTO_ALG_TYPE_MASK,
>         .maskset = CRYPTO_ALG_TYPE_SIG_MASK,
>         .type = CRYPTO_ALG_TYPE_SIG,
>         .tfmsize = offsetof(struct crypto_sig, base),
>  };
>
>  struct crypto_sig *crypto_alloc_sig(const char *alg_name, u32 type, u32 mask)
>  {
>         return crypto_alloc_tfm(alg_name, &crypto_sig_type, type, mask);
> diff --git a/crypto/skcipher.c b/crypto/skcipher.c
> index bc70e159d27df..ceed7f33a67ba 100644
> --- a/crypto/skcipher.c
> +++ b/crypto/skcipher.c
> @@ -82,39 +82,20 @@ static inline u8 *skcipher_get_spot(u8 *start, unsigned int len)
>
>         return max(start, end_page);
>  }
>
>  static inline struct skcipher_alg *__crypto_skcipher_alg(
>         struct crypto_alg *alg)
>  {
>         return container_of(alg, struct skcipher_alg, base);
>  }
>
> -static inline struct crypto_istat_cipher *skcipher_get_stat(
> -       struct skcipher_alg *alg)
> -{
> -       return skcipher_get_stat_common(&alg->co);
> -}
> -
> -static inline int crypto_skcipher_errstat(struct skcipher_alg *alg, int err)
> -{
> -       struct crypto_istat_cipher *istat = skcipher_get_stat(alg);
> -
> -       if (!IS_ENABLED(CONFIG_CRYPTO_STATS))
> -               return err;
> -
> -       if (err && err != -EINPROGRESS && err != -EBUSY)
> -               atomic64_inc(&istat->err_cnt);
> -
> -       return err;
> -}
> -
>  static int skcipher_done_slow(struct skcipher_walk *walk, unsigned int bsize)
>  {
>         u8 *addr;
>
>         addr = (u8 *)ALIGN((unsigned long)walk->buffer, walk->alignmask + 1);
>         addr = skcipher_get_spot(addr, bsize);
>         scatterwalk_copychunks(addr, &walk->out, bsize,
>                                (walk->flags & SKCIPHER_WALK_PHYS) ? 2 : 1);
>         return 0;
>  }
> @@ -647,61 +628,39 @@ int crypto_skcipher_setkey(struct crypto_skcipher *tfm, const u8 *key,
>
>         crypto_skcipher_clear_flags(tfm, CRYPTO_TFM_NEED_KEY);
>         return 0;
>  }
>  EXPORT_SYMBOL_GPL(crypto_skcipher_setkey);
>
>  int crypto_skcipher_encrypt(struct skcipher_request *req)
>  {
>         struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
>         struct skcipher_alg *alg = crypto_skcipher_alg(tfm);
> -       int ret;
> -
> -       if (IS_ENABLED(CONFIG_CRYPTO_STATS)) {
> -               struct crypto_istat_cipher *istat = skcipher_get_stat(alg);
> -
> -               atomic64_inc(&istat->encrypt_cnt);
> -               atomic64_add(req->cryptlen, &istat->encrypt_tlen);
> -       }
>
>         if (crypto_skcipher_get_flags(tfm) & CRYPTO_TFM_NEED_KEY)
> -               ret = -ENOKEY;
> -       else if (alg->co.base.cra_type != &crypto_skcipher_type)
> -               ret = crypto_lskcipher_encrypt_sg(req);
> -       else
> -               ret = alg->encrypt(req);
> -
> -       return crypto_skcipher_errstat(alg, ret);
> +               return -ENOKEY;
> +       if (alg->co.base.cra_type != &crypto_skcipher_type)
> +               return crypto_lskcipher_encrypt_sg(req);
> +       return alg->encrypt(req);
>  }
>  EXPORT_SYMBOL_GPL(crypto_skcipher_encrypt);
>
>  int crypto_skcipher_decrypt(struct skcipher_request *req)
>  {
>         struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
>         struct skcipher_alg *alg = crypto_skcipher_alg(tfm);
> -       int ret;
> -
> -       if (IS_ENABLED(CONFIG_CRYPTO_STATS)) {
> -               struct crypto_istat_cipher *istat = skcipher_get_stat(alg);
> -
> -               atomic64_inc(&istat->decrypt_cnt);
> -               atomic64_add(req->cryptlen, &istat->decrypt_tlen);
> -       }
>
>         if (crypto_skcipher_get_flags(tfm) & CRYPTO_TFM_NEED_KEY)
> -               ret = -ENOKEY;
> -       else if (alg->co.base.cra_type != &crypto_skcipher_type)
> -               ret = crypto_lskcipher_decrypt_sg(req);
> -       else
> -               ret = alg->decrypt(req);
> -
> -       return crypto_skcipher_errstat(alg, ret);
> +               return -ENOKEY;
> +       if (alg->co.base.cra_type != &crypto_skcipher_type)
> +               return crypto_lskcipher_decrypt_sg(req);
> +       return alg->decrypt(req);
>  }
>  EXPORT_SYMBOL_GPL(crypto_skcipher_decrypt);
>
>  static int crypto_lskcipher_export(struct skcipher_request *req, void *out)
>  {
>         struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
>         u8 *ivs = skcipher_request_ctx(req);
>
>         ivs = PTR_ALIGN(ivs, crypto_skcipher_alignmask(tfm) + 1);
>
> @@ -839,54 +798,29 @@ static int __maybe_unused crypto_skcipher_report(
>
>         rblkcipher.blocksize = alg->cra_blocksize;
>         rblkcipher.min_keysize = skcipher->min_keysize;
>         rblkcipher.max_keysize = skcipher->max_keysize;
>         rblkcipher.ivsize = skcipher->ivsize;
>
>         return nla_put(skb, CRYPTOCFGA_REPORT_BLKCIPHER,
>                        sizeof(rblkcipher), &rblkcipher);
>  }
>
> -static int __maybe_unused crypto_skcipher_report_stat(
> -       struct sk_buff *skb, struct crypto_alg *alg)
> -{
> -       struct skcipher_alg *skcipher = __crypto_skcipher_alg(alg);
> -       struct crypto_istat_cipher *istat;
> -       struct crypto_stat_cipher rcipher;
> -
> -       istat = skcipher_get_stat(skcipher);
> -
> -       memset(&rcipher, 0, sizeof(rcipher));
> -
> -       strscpy(rcipher.type, "cipher", sizeof(rcipher.type));
> -
> -       rcipher.stat_encrypt_cnt = atomic64_read(&istat->encrypt_cnt);
> -       rcipher.stat_encrypt_tlen = atomic64_read(&istat->encrypt_tlen);
> -       rcipher.stat_decrypt_cnt =  atomic64_read(&istat->decrypt_cnt);
> -       rcipher.stat_decrypt_tlen = atomic64_read(&istat->decrypt_tlen);
> -       rcipher.stat_err_cnt =  atomic64_read(&istat->err_cnt);
> -
> -       return nla_put(skb, CRYPTOCFGA_STAT_CIPHER, sizeof(rcipher), &rcipher);
> -}
> -
>  static const struct crypto_type crypto_skcipher_type = {
>         .extsize = crypto_skcipher_extsize,
>         .init_tfm = crypto_skcipher_init_tfm,
>         .free = crypto_skcipher_free_instance,
>  #ifdef CONFIG_PROC_FS
>         .show = crypto_skcipher_show,
>  #endif
>  #if IS_ENABLED(CONFIG_CRYPTO_USER)
>         .report = crypto_skcipher_report,
> -#endif
> -#ifdef CONFIG_CRYPTO_STATS
> -       .report_stat = crypto_skcipher_report_stat,
>  #endif
>         .maskclear = ~CRYPTO_ALG_TYPE_MASK,
>         .maskset = CRYPTO_ALG_TYPE_SKCIPHER_MASK,
>         .type = CRYPTO_ALG_TYPE_SKCIPHER,
>         .tfmsize = offsetof(struct crypto_skcipher, base),
>  };
>
>  int crypto_grab_skcipher(struct crypto_skcipher_spawn *spawn,
>                          struct crypto_instance *inst,
>                          const char *name, u32 type, u32 mask)
> @@ -928,36 +862,32 @@ struct crypto_sync_skcipher *crypto_alloc_sync_skcipher(
>  EXPORT_SYMBOL_GPL(crypto_alloc_sync_skcipher);
>
>  int crypto_has_skcipher(const char *alg_name, u32 type, u32 mask)
>  {
>         return crypto_type_has_alg(alg_name, &crypto_skcipher_type, type, mask);
>  }
>  EXPORT_SYMBOL_GPL(crypto_has_skcipher);
>
>  int skcipher_prepare_alg_common(struct skcipher_alg_common *alg)
>  {
> -       struct crypto_istat_cipher *istat = skcipher_get_stat_common(alg);
>         struct crypto_alg *base = &alg->base;
>
>         if (alg->ivsize > PAGE_SIZE / 8 || alg->chunksize > PAGE_SIZE / 8 ||
>             alg->statesize > PAGE_SIZE / 2 ||
>             (alg->ivsize + alg->statesize) > PAGE_SIZE / 2)
>                 return -EINVAL;
>
>         if (!alg->chunksize)
>                 alg->chunksize = base->cra_blocksize;
>
>         base->cra_flags &= ~CRYPTO_ALG_TYPE_MASK;
>
> -       if (IS_ENABLED(CONFIG_CRYPTO_STATS))
> -               memset(istat, 0, sizeof(*istat));
> -
>         return 0;
>  }
>
>  static int skcipher_prepare_alg(struct skcipher_alg *alg)
>  {
>         struct crypto_alg *base = &alg->base;
>         int err;
>
>         err = skcipher_prepare_alg_common(&alg->co);
>         if (err)
> diff --git a/crypto/skcipher.h b/crypto/skcipher.h
> index 16c9484360dab..703651367dd87 100644
> --- a/crypto/skcipher.h
> +++ b/crypto/skcipher.h
> @@ -3,26 +3,16 @@
>   * Cryptographic API.
>   *
>   * Copyright (c) 2023 Herbert Xu <herbert@gondor.apana.org.au>
>   */
>  #ifndef _LOCAL_CRYPTO_SKCIPHER_H
>  #define _LOCAL_CRYPTO_SKCIPHER_H
>
>  #include <crypto/internal/skcipher.h>
>  #include "internal.h"
>
> -static inline struct crypto_istat_cipher *skcipher_get_stat_common(
> -       struct skcipher_alg_common *alg)
> -{
> -#ifdef CONFIG_CRYPTO_STATS
> -       return &alg->stat;
> -#else
> -       return NULL;
> -#endif
> -}
> -
>  int crypto_lskcipher_encrypt_sg(struct skcipher_request *req);
>  int crypto_lskcipher_decrypt_sg(struct skcipher_request *req);
>  int crypto_init_lskcipher_ops_sg(struct crypto_tfm *tfm);
>  int skcipher_prepare_alg_common(struct skcipher_alg_common *alg);
>
>  #endif /* _LOCAL_CRYPTO_SKCIPHER_H */
> diff --git a/include/crypto/acompress.h b/include/crypto/acompress.h
> index 574cffc90730f..d042c90e09076 100644
> --- a/include/crypto/acompress.h
> +++ b/include/crypto/acompress.h
> @@ -49,49 +49,20 @@ struct acomp_req {
>   * @base:              Common crypto API algorithm data structure
>   */
>  struct crypto_acomp {
>         int (*compress)(struct acomp_req *req);
>         int (*decompress)(struct acomp_req *req);
>         void (*dst_free)(struct scatterlist *dst);
>         unsigned int reqsize;
>         struct crypto_tfm base;
>  };
>
> -/*
> - * struct crypto_istat_compress - statistics for compress algorithm
> - * @compress_cnt:      number of compress requests
> - * @compress_tlen:     total data size handled by compress requests
> - * @decompress_cnt:    number of decompress requests
> - * @decompress_tlen:   total data size handled by decompress requests
> - * @err_cnt:           number of error for compress requests
> - */
> -struct crypto_istat_compress {
> -       atomic64_t compress_cnt;
> -       atomic64_t compress_tlen;
> -       atomic64_t decompress_cnt;
> -       atomic64_t decompress_tlen;
> -       atomic64_t err_cnt;
> -};
> -
> -#ifdef CONFIG_CRYPTO_STATS
> -#define COMP_ALG_COMMON_STATS struct crypto_istat_compress stat;
> -#else
> -#define COMP_ALG_COMMON_STATS
> -#endif
> -
> -#define COMP_ALG_COMMON {                      \
> -       COMP_ALG_COMMON_STATS                   \
> -                                               \
> -       struct crypto_alg base;                 \
> -}
> -struct comp_alg_common COMP_ALG_COMMON;
> -
>  /**
>   * DOC: Asynchronous Compression API
>   *
>   * The Asynchronous Compression API is used with the algorithms of type
>   * CRYPTO_ALG_TYPE_ACOMPRESS (listed as type "acomp" in /proc/crypto)
>   */
>
>  /**
>   * crypto_alloc_acomp() -- allocate ACOMPRESS tfm handle
>   * @alg_name:  is the cra_name / name or cra_driver_name / driver name of the
> @@ -125,37 +96,25 @@ struct crypto_acomp *crypto_alloc_acomp(const char *alg_name, u32 type,
>   *             of an error, PTR_ERR() returns the error code.
>   */
>  struct crypto_acomp *crypto_alloc_acomp_node(const char *alg_name, u32 type,
>                                         u32 mask, int node);
>
>  static inline struct crypto_tfm *crypto_acomp_tfm(struct crypto_acomp *tfm)
>  {
>         return &tfm->base;
>  }
>
> -static inline struct comp_alg_common *__crypto_comp_alg_common(
> -       struct crypto_alg *alg)
> -{
> -       return container_of(alg, struct comp_alg_common, base);
> -}
> -
>  static inline struct crypto_acomp *__crypto_acomp_tfm(struct crypto_tfm *tfm)
>  {
>         return container_of(tfm, struct crypto_acomp, base);
>  }
>
> -static inline struct comp_alg_common *crypto_comp_alg_common(
> -       struct crypto_acomp *tfm)
> -{
> -       return __crypto_comp_alg_common(crypto_acomp_tfm(tfm)->__crt_alg);
> -}
> -
>  static inline unsigned int crypto_acomp_reqsize(struct crypto_acomp *tfm)
>  {
>         return tfm->reqsize;
>  }
>
>  static inline void acomp_request_set_tfm(struct acomp_req *req,
>                                          struct crypto_acomp *tfm)
>  {
>         req->base.tfm = crypto_acomp_tfm(tfm);
>  }
> @@ -248,84 +207,39 @@ static inline void acomp_request_set_params(struct acomp_req *req,
>         req->src = src;
>         req->dst = dst;
>         req->slen = slen;
>         req->dlen = dlen;
>
>         req->flags &= ~CRYPTO_ACOMP_ALLOC_OUTPUT;
>         if (!req->dst)
>                 req->flags |= CRYPTO_ACOMP_ALLOC_OUTPUT;
>  }
>
> -static inline struct crypto_istat_compress *comp_get_stat(
> -       struct comp_alg_common *alg)
> -{
> -#ifdef CONFIG_CRYPTO_STATS
> -       return &alg->stat;
> -#else
> -       return NULL;
> -#endif
> -}
> -
> -static inline int crypto_comp_errstat(struct comp_alg_common *alg, int err)
> -{
> -       if (!IS_ENABLED(CONFIG_CRYPTO_STATS))
> -               return err;
> -
> -       if (err && err != -EINPROGRESS && err != -EBUSY)
> -               atomic64_inc(&comp_get_stat(alg)->err_cnt);
> -
> -       return err;
> -}
> -
>  /**
>   * crypto_acomp_compress() -- Invoke asynchronous compress operation
>   *
>   * Function invokes the asynchronous compress operation
>   *
>   * @req:       asynchronous compress request
>   *
>   * Return:     zero on success; error code in case of error
>   */
>  static inline int crypto_acomp_compress(struct acomp_req *req)
>  {
> -       struct crypto_acomp *tfm = crypto_acomp_reqtfm(req);
> -       struct comp_alg_common *alg;
> -
> -       alg = crypto_comp_alg_common(tfm);
> -
> -       if (IS_ENABLED(CONFIG_CRYPTO_STATS)) {
> -               struct crypto_istat_compress *istat = comp_get_stat(alg);
> -
> -               atomic64_inc(&istat->compress_cnt);
> -               atomic64_add(req->slen, &istat->compress_tlen);
> -       }
> -
> -       return crypto_comp_errstat(alg, tfm->compress(req));
> +       return crypto_acomp_reqtfm(req)->compress(req);
>  }
>
>  /**
>   * crypto_acomp_decompress() -- Invoke asynchronous decompress operation
>   *
>   * Function invokes the asynchronous decompress operation
>   *
>   * @req:       asynchronous compress request
>   *
>   * Return:     zero on success; error code in case of error
>   */
>  static inline int crypto_acomp_decompress(struct acomp_req *req)
>  {
> -       struct crypto_acomp *tfm = crypto_acomp_reqtfm(req);
> -       struct comp_alg_common *alg;
> -
> -       alg = crypto_comp_alg_common(tfm);
> -
> -       if (IS_ENABLED(CONFIG_CRYPTO_STATS)) {
> -               struct crypto_istat_compress *istat = comp_get_stat(alg);
> -
> -               atomic64_inc(&istat->decompress_cnt);
> -               atomic64_add(req->slen, &istat->decompress_tlen);
> -       }
> -
> -       return crypto_comp_errstat(alg, tfm->decompress(req));
> +       return crypto_acomp_reqtfm(req)->decompress(req);
>  }
>
>  #endif
> diff --git a/include/crypto/aead.h b/include/crypto/aead.h
> index 51382befbe37a..0e8a416386780 100644
> --- a/include/crypto/aead.h
> +++ b/include/crypto/aead.h
> @@ -94,55 +94,38 @@ struct aead_request {
>         unsigned int cryptlen;
>
>         u8 *iv;
>
>         struct scatterlist *src;
>         struct scatterlist *dst;
>
>         void *__ctx[] CRYPTO_MINALIGN_ATTR;
>  };
>
> -/*
> - * struct crypto_istat_aead - statistics for AEAD algorithm
> - * @encrypt_cnt:       number of encrypt requests
> - * @encrypt_tlen:      total data size handled by encrypt requests
> - * @decrypt_cnt:       number of decrypt requests
> - * @decrypt_tlen:      total data size handled by decrypt requests
> - * @err_cnt:           number of error for AEAD requests
> - */
> -struct crypto_istat_aead {
> -       atomic64_t encrypt_cnt;
> -       atomic64_t encrypt_tlen;
> -       atomic64_t decrypt_cnt;
> -       atomic64_t decrypt_tlen;
> -       atomic64_t err_cnt;
> -};
> -
>  /**
>   * struct aead_alg - AEAD cipher definition
>   * @maxauthsize: Set the maximum authentication tag size supported by the
>   *              transformation. A transformation may support smaller tag sizes.
>   *              As the authentication tag is a message digest to ensure the
>   *              integrity of the encrypted data, a consumer typically wants the
>   *              largest authentication tag possible as defined by this
>   *              variable.
>   * @setauthsize: Set authentication size for the AEAD transformation. This
>   *              function is used to specify the consumer requested size of the
>   *              authentication tag to be either generated by the transformation
>   *              during encryption or the size of the authentication tag to be
>   *              supplied during the decryption operation. This function is also
>   *              responsible for checking the authentication tag size for
>   *              validity.
>   * @setkey: see struct skcipher_alg
>   * @encrypt: see struct skcipher_alg
>   * @decrypt: see struct skcipher_alg
> - * @stat: statistics for AEAD algorithm
>   * @ivsize: see struct skcipher_alg
>   * @chunksize: see struct skcipher_alg
>   * @init: Initialize the cryptographic transformation object. This function
>   *       is used to initialize the cryptographic transformation object.
>   *       This function is called only once at the instantiation time, right
>   *       after the transformation context was allocated. In case the
>   *       cryptographic hardware has some special requirements which need to
>   *       be handled by software, this function shall check for the precise
>   *       requirement of the transformation and put any software fallbacks
>   *       in place.
> @@ -155,24 +138,20 @@ struct crypto_istat_aead {
>   */
>  struct aead_alg {
>         int (*setkey)(struct crypto_aead *tfm, const u8 *key,
>                       unsigned int keylen);
>         int (*setauthsize)(struct crypto_aead *tfm, unsigned int authsize);
>         int (*encrypt)(struct aead_request *req);
>         int (*decrypt)(struct aead_request *req);
>         int (*init)(struct crypto_aead *tfm);
>         void (*exit)(struct crypto_aead *tfm);
>
> -#ifdef CONFIG_CRYPTO_STATS
> -       struct crypto_istat_aead stat;
> -#endif
> -
>         unsigned int ivsize;
>         unsigned int maxauthsize;
>         unsigned int chunksize;
>
>         struct crypto_alg base;
>  };
>
>  struct crypto_aead {
>         unsigned int authsize;
>         unsigned int reqsize;
> diff --git a/include/crypto/akcipher.h b/include/crypto/akcipher.h
> index 31c111bebb688..18a10cad07aaa 100644
> --- a/include/crypto/akcipher.h
> +++ b/include/crypto/akcipher.h
> @@ -47,40 +47,20 @@ struct akcipher_request {
>   *
>   * @reqsize:   Request context size required by algorithm implementation
>   * @base:      Common crypto API algorithm data structure
>   */
>  struct crypto_akcipher {
>         unsigned int reqsize;
>
>         struct crypto_tfm base;
>  };
>
> -/*
> - * struct crypto_istat_akcipher - statistics for akcipher algorithm
> - * @encrypt_cnt:       number of encrypt requests
> - * @encrypt_tlen:      total data size handled by encrypt requests
> - * @decrypt_cnt:       number of decrypt requests
> - * @decrypt_tlen:      total data size handled by decrypt requests
> - * @verify_cnt:                number of verify operation
> - * @sign_cnt:          number of sign requests
> - * @err_cnt:           number of error for akcipher requests
> - */
> -struct crypto_istat_akcipher {
> -       atomic64_t encrypt_cnt;
> -       atomic64_t encrypt_tlen;
> -       atomic64_t decrypt_cnt;
> -       atomic64_t decrypt_tlen;
> -       atomic64_t verify_cnt;
> -       atomic64_t sign_cnt;
> -       atomic64_t err_cnt;
> -};
> -
>  /**
>   * struct akcipher_alg - generic public key algorithm
>   *
>   * @sign:      Function performs a sign operation as defined by public key
>   *             algorithm. In case of error, where the dst_len was insufficient,
>   *             the req->dst_len will be updated to the size required for the
>   *             operation
>   * @verify:    Function performs a complete verify operation as defined by
>   *             public key algorithm, returning verification status. Requires
>   *             digest value as input parameter.
> @@ -103,41 +83,36 @@ struct crypto_istat_akcipher {
>   *             This function is used to initialize the cryptographic
>   *             transformation object. This function is called only once at
>   *             the instantiation time, right after the transformation context
>   *             was allocated. In case the cryptographic hardware has some
>   *             special requirements which need to be handled by software, this
>   *             function shall check for the precise requirement of the
>   *             transformation and put any software fallbacks in place.
>   * @exit:      Deinitialize the cryptographic transformation object. This is a
>   *             counterpart to @init, used to remove various changes set in
>   *             @init.
> - * @stat:      Statistics for akcipher algorithm
>   *
>   * @base:      Common crypto API algorithm data structure
>   */
>  struct akcipher_alg {
>         int (*sign)(struct akcipher_request *req);
>         int (*verify)(struct akcipher_request *req);
>         int (*encrypt)(struct akcipher_request *req);
>         int (*decrypt)(struct akcipher_request *req);
>         int (*set_pub_key)(struct crypto_akcipher *tfm, const void *key,
>                            unsigned int keylen);
>         int (*set_priv_key)(struct crypto_akcipher *tfm, const void *key,
>                             unsigned int keylen);
>         unsigned int (*max_size)(struct crypto_akcipher *tfm);
>         int (*init)(struct crypto_akcipher *tfm);
>         void (*exit)(struct crypto_akcipher *tfm);
>
> -#ifdef CONFIG_CRYPTO_STATS
> -       struct crypto_istat_akcipher stat;
> -#endif
> -
>         struct crypto_alg base;
>  };
>
>  /**
>   * DOC: Generic Public Key API
>   *
>   * The Public Key API is used with the algorithms of type
>   * CRYPTO_ALG_TYPE_AKCIPHER (listed as type "akcipher" in /proc/crypto)
>   */
>
> @@ -295,89 +270,52 @@ static inline void akcipher_request_set_crypt(struct akcipher_request *req,
>   *
>   * @tfm:       AKCIPHER tfm handle allocated with crypto_alloc_akcipher()
>   */
>  static inline unsigned int crypto_akcipher_maxsize(struct crypto_akcipher *tfm)
>  {
>         struct akcipher_alg *alg = crypto_akcipher_alg(tfm);
>
>         return alg->max_size(tfm);
>  }
>
> -static inline struct crypto_istat_akcipher *akcipher_get_stat(
> -       struct akcipher_alg *alg)
> -{
> -#ifdef CONFIG_CRYPTO_STATS
> -       return &alg->stat;
> -#else
> -       return NULL;
> -#endif
> -}
> -
> -static inline int crypto_akcipher_errstat(struct akcipher_alg *alg, int err)
> -{
> -       if (!IS_ENABLED(CONFIG_CRYPTO_STATS))
> -               return err;
> -
> -       if (err && err != -EINPROGRESS && err != -EBUSY)
> -               atomic64_inc(&akcipher_get_stat(alg)->err_cnt);
> -
> -       return err;
> -}
> -
>  /**
>   * crypto_akcipher_encrypt() - Invoke public key encrypt operation
>   *
>   * Function invokes the specific public key encrypt operation for a given
>   * public key algorithm
>   *
>   * @req:       asymmetric key request
>   *
>   * Return: zero on success; error code in case of error
>   */
>  static inline int crypto_akcipher_encrypt(struct akcipher_request *req)
>  {
>         struct crypto_akcipher *tfm = crypto_akcipher_reqtfm(req);
> -       struct akcipher_alg *alg = crypto_akcipher_alg(tfm);
>
> -       if (IS_ENABLED(CONFIG_CRYPTO_STATS)) {
> -               struct crypto_istat_akcipher *istat = akcipher_get_stat(alg);
> -
> -               atomic64_inc(&istat->encrypt_cnt);
> -               atomic64_add(req->src_len, &istat->encrypt_tlen);
> -       }
> -
> -       return crypto_akcipher_errstat(alg, alg->encrypt(req));
> +       return crypto_akcipher_alg(tfm)->encrypt(req);
>  }
>
>  /**
>   * crypto_akcipher_decrypt() - Invoke public key decrypt operation
>   *
>   * Function invokes the specific public key decrypt operation for a given
>   * public key algorithm
>   *
>   * @req:       asymmetric key request
>   *
>   * Return: zero on success; error code in case of error
>   */
>  static inline int crypto_akcipher_decrypt(struct akcipher_request *req)
>  {
>         struct crypto_akcipher *tfm = crypto_akcipher_reqtfm(req);
> -       struct akcipher_alg *alg = crypto_akcipher_alg(tfm);
>
> -       if (IS_ENABLED(CONFIG_CRYPTO_STATS)) {
> -               struct crypto_istat_akcipher *istat = akcipher_get_stat(alg);
> -
> -               atomic64_inc(&istat->decrypt_cnt);
> -               atomic64_add(req->src_len, &istat->decrypt_tlen);
> -       }
> -
> -       return crypto_akcipher_errstat(alg, alg->decrypt(req));
> +       return crypto_akcipher_alg(tfm)->decrypt(req);
>  }
>
>  /**
>   * crypto_akcipher_sync_encrypt() - Invoke public key encrypt operation
>   *
>   * Function invokes the specific public key encrypt operation for a given
>   * public key algorithm
>   *
>   * @tfm:       AKCIPHER tfm handle allocated with crypto_alloc_akcipher()
>   * @src:       source buffer
> @@ -415,51 +353,43 @@ int crypto_akcipher_sync_decrypt(struct crypto_akcipher *tfm,
>   * Function invokes the specific public key sign operation for a given
>   * public key algorithm
>   *
>   * @req:       asymmetric key request
>   *
>   * Return: zero on success; error code in case of error
>   */
>  static inline int crypto_akcipher_sign(struct akcipher_request *req)
>  {
>         struct crypto_akcipher *tfm = crypto_akcipher_reqtfm(req);
> -       struct akcipher_alg *alg = crypto_akcipher_alg(tfm);
>
> -       if (IS_ENABLED(CONFIG_CRYPTO_STATS))
> -               atomic64_inc(&akcipher_get_stat(alg)->sign_cnt);
> -
> -       return crypto_akcipher_errstat(alg, alg->sign(req));
> +       return crypto_akcipher_alg(tfm)->sign(req);
>  }
>
>  /**
>   * crypto_akcipher_verify() - Invoke public key signature verification
>   *
>   * Function invokes the specific public key signature verification operation
>   * for a given public key algorithm.
>   *
>   * @req:       asymmetric key request
>   *
>   * Note: req->dst should be NULL, req->src should point to SG of size
>   * (req->src_size + req->dst_size), containing signature (of req->src_size
>   * length) with appended digest (of req->dst_size length).
>   *
>   * Return: zero on verification success; error code in case of error.
>   */
>  static inline int crypto_akcipher_verify(struct akcipher_request *req)
>  {
>         struct crypto_akcipher *tfm = crypto_akcipher_reqtfm(req);
> -       struct akcipher_alg *alg = crypto_akcipher_alg(tfm);
> -
> -       if (IS_ENABLED(CONFIG_CRYPTO_STATS))
> -               atomic64_inc(&akcipher_get_stat(alg)->verify_cnt);
>
> -       return crypto_akcipher_errstat(alg, alg->verify(req));
> +       return crypto_akcipher_alg(tfm)->verify(req);
>  }
>
>  /**
>   * crypto_akcipher_set_pub_key() - Invoke set public key operation
>   *
>   * Function invokes the algorithm specific set key function, which knows
>   * how to decode and interpret the encoded key and parameters
>   *
>   * @tfm:       tfm handle
>   * @key:       BER encoded public key, algo OID, paramlen, BER encoded
> diff --git a/include/crypto/algapi.h b/include/crypto/algapi.h
> index 7a4a71af653fa..156de41ca760a 100644
> --- a/include/crypto/algapi.h
> +++ b/include/crypto/algapi.h
> @@ -54,23 +54,20 @@ struct scatterlist;
>  struct seq_file;
>  struct sk_buff;
>
>  struct crypto_type {
>         unsigned int (*ctxsize)(struct crypto_alg *alg, u32 type, u32 mask);
>         unsigned int (*extsize)(struct crypto_alg *alg);
>         int (*init_tfm)(struct crypto_tfm *tfm);
>         void (*show)(struct seq_file *m, struct crypto_alg *alg);
>         int (*report)(struct sk_buff *skb, struct crypto_alg *alg);
>         void (*free)(struct crypto_instance *inst);
> -#ifdef CONFIG_CRYPTO_STATS
> -       int (*report_stat)(struct sk_buff *skb, struct crypto_alg *alg);
> -#endif
>
>         unsigned int type;
>         unsigned int maskclear;
>         unsigned int maskset;
>         unsigned int tfmsize;
>  };
>
>  struct crypto_instance {
>         struct crypto_alg alg;
>
> diff --git a/include/crypto/hash.h b/include/crypto/hash.h
> index 5d61f576cfc86..0014bdd81ab7d 100644
> --- a/include/crypto/hash.h
> +++ b/include/crypto/hash.h
> @@ -16,59 +16,38 @@ struct crypto_ahash;
>
>  /**
>   * DOC: Message Digest Algorithm Definitions
>   *
>   * These data structures define modular message digest algorithm
>   * implementations, managed via crypto_register_ahash(),
>   * crypto_register_shash(), crypto_unregister_ahash() and
>   * crypto_unregister_shash().
>   */
>
> -/*
> - * struct crypto_istat_hash - statistics for has algorithm
> - * @hash_cnt:          number of hash requests
> - * @hash_tlen:         total data size hashed
> - * @err_cnt:           number of error for hash requests
> - */
> -struct crypto_istat_hash {
> -       atomic64_t hash_cnt;
> -       atomic64_t hash_tlen;
> -       atomic64_t err_cnt;
> -};
> -
> -#ifdef CONFIG_CRYPTO_STATS
> -#define HASH_ALG_COMMON_STAT struct crypto_istat_hash stat;
> -#else
> -#define HASH_ALG_COMMON_STAT
> -#endif
> -
>  /*
>   * struct hash_alg_common - define properties of message digest
> - * @stat: Statistics for hash algorithm.
>   * @digestsize: Size of the result of the transformation. A buffer of this size
>   *             must be available to the @final and @finup calls, so they can
>   *             store the resulting hash into it. For various predefined sizes,
>   *             search include/crypto/ using
>   *             git grep _DIGEST_SIZE include/crypto.
>   * @statesize: Size of the block for partial state of the transformation. A
>   *            buffer of this size must be passed to the @export function as it
>   *            will save the partial state of the transformation into it. On the
>   *            other side, the @import function will load the state from a
>   *            buffer of this size as well.
>   * @base: Start of data structure of cipher algorithm. The common data
>   *       structure of crypto_alg contains information common to all ciphers.
>   *       The hash_alg_common data structure now adds the hash-specific
>   *       information.
>   */
>  #define HASH_ALG_COMMON {              \
> -       HASH_ALG_COMMON_STAT            \
> -                                       \
>         unsigned int digestsize;        \
>         unsigned int statesize;         \
>                                         \
>         struct crypto_alg base;         \
>  }
>  struct hash_alg_common HASH_ALG_COMMON;
>
>  struct ahash_request {
>         struct crypto_async_request base;
>
> @@ -236,21 +215,20 @@ struct shash_alg {
>         int (*clone_tfm)(struct crypto_shash *dst, struct crypto_shash *src);
>
>         unsigned int descsize;
>
>         union {
>                 struct HASH_ALG_COMMON;
>                 struct hash_alg_common halg;
>         };
>  };
>  #undef HASH_ALG_COMMON
> -#undef HASH_ALG_COMMON_STAT
>
>  struct crypto_ahash {
>         bool using_shash; /* Underlying algorithm is shash, not ahash */
>         unsigned int statesize;
>         unsigned int reqsize;
>         struct crypto_tfm base;
>  };
>
>  struct crypto_shash {
>         unsigned int descsize;
> diff --git a/include/crypto/internal/acompress.h b/include/crypto/internal/acompress.h
> index 4ac46bafba9d7..475e60a9f9ea9 100644
> --- a/include/crypto/internal/acompress.h
> +++ b/include/crypto/internal/acompress.h
> @@ -24,37 +24,32 @@
>   *             the instantiation time, right after the transformation context
>   *             was allocated. In case the cryptographic hardware has some
>   *             special requirements which need to be handled by software, this
>   *             function shall check for the precise requirement of the
>   *             transformation and put any software fallbacks in place.
>   * @exit:      Deinitialize the cryptographic transformation object. This is a
>   *             counterpart to @init, used to remove various changes set in
>   *             @init.
>   *
>   * @reqsize:   Context size for (de)compression requests
> - * @stat:      Statistics for compress algorithm
>   * @base:      Common crypto API algorithm data structure
> - * @calg:      Cmonn algorithm data structure shared with scomp
>   */
>  struct acomp_alg {
>         int (*compress)(struct acomp_req *req);
>         int (*decompress)(struct acomp_req *req);
>         void (*dst_free)(struct scatterlist *dst);
>         int (*init)(struct crypto_acomp *tfm);
>         void (*exit)(struct crypto_acomp *tfm);
>
>         unsigned int reqsize;
>
> -       union {
> -               struct COMP_ALG_COMMON;
> -               struct comp_alg_common calg;
> -       };
> +       struct crypto_alg base;
>  };
>
>  /*
>   * Transform internal helpers.
>   */
>  static inline void *acomp_request_ctx(struct acomp_req *req)
>  {
>         return req->__ctx;
>  }
>
> diff --git a/include/crypto/internal/cryptouser.h b/include/crypto/internal/cryptouser.h
> deleted file mode 100644
> index fd54074332f50..0000000000000
> --- a/include/crypto/internal/cryptouser.h
> +++ /dev/null
> @@ -1,16 +0,0 @@
> -/* SPDX-License-Identifier: GPL-2.0 */
> -#include <linux/cryptouser.h>
> -#include <net/netlink.h>
> -
> -struct crypto_alg *crypto_alg_match(struct crypto_user_alg *p, int exact);
> -
> -#ifdef CONFIG_CRYPTO_STATS
> -int crypto_reportstat(struct sk_buff *in_skb, struct nlmsghdr *in_nlh, struct nlattr **attrs);
> -#else
> -static inline int crypto_reportstat(struct sk_buff *in_skb,
> -                                   struct nlmsghdr *in_nlh,
> -                                   struct nlattr **attrs)
> -{
> -       return -ENOTSUPP;
> -}
> -#endif
> diff --git a/include/crypto/internal/scompress.h b/include/crypto/internal/scompress.h
> index 858fe3965ae34..5a75f2db18cef 100644
> --- a/include/crypto/internal/scompress.h
> +++ b/include/crypto/internal/scompress.h
> @@ -20,38 +20,32 @@ struct crypto_scomp {
>         struct crypto_tfm base;
>  };
>
>  /**
>   * struct scomp_alg - synchronous compression algorithm
>   *
>   * @alloc_ctx: Function allocates algorithm specific context
>   * @free_ctx:  Function frees context allocated with alloc_ctx
>   * @compress:  Function performs a compress operation
>   * @decompress:        Function performs a de-compress operation
> - * @stat:      Statistics for compress algorithm
>   * @base:      Common crypto API algorithm data structure
> - * @calg:      Cmonn algorithm data structure shared with acomp
>   */
>  struct scomp_alg {
>         void *(*alloc_ctx)(struct crypto_scomp *tfm);
>         void (*free_ctx)(struct crypto_scomp *tfm, void *ctx);
>         int (*compress)(struct crypto_scomp *tfm, const u8 *src,
>                         unsigned int slen, u8 *dst, unsigned int *dlen,
>                         void *ctx);
>         int (*decompress)(struct crypto_scomp *tfm, const u8 *src,
>                           unsigned int slen, u8 *dst, unsigned int *dlen,
>                           void *ctx);
> -
> -       union {
> -               struct COMP_ALG_COMMON;
> -               struct comp_alg_common calg;
> -       };
> +       struct crypto_alg base;
>  };
>
>  static inline struct scomp_alg *__crypto_scomp_alg(struct crypto_alg *alg)
>  {
>         return container_of(alg, struct scomp_alg, base);
>  }
>
>  static inline struct crypto_scomp *__crypto_scomp_tfm(struct crypto_tfm *tfm)
>  {
>         return container_of(tfm, struct crypto_scomp, base);
> diff --git a/include/crypto/kpp.h b/include/crypto/kpp.h
> index 1988e24a0d1db..2d9c4de57b694 100644
> --- a/include/crypto/kpp.h
> +++ b/include/crypto/kpp.h
> @@ -44,34 +44,20 @@ struct kpp_request {
>   * @reqsize:           Request context size required by algorithm
>   *                     implementation
>   * @base:      Common crypto API algorithm data structure
>   */
>  struct crypto_kpp {
>         unsigned int reqsize;
>
>         struct crypto_tfm base;
>  };
>
> -/*
> - * struct crypto_istat_kpp - statistics for KPP algorithm
> - * @setsecret_cnt:             number of setsecrey operation
> - * @generate_public_key_cnt:   number of generate_public_key operation
> - * @compute_shared_secret_cnt: number of compute_shared_secret operation
> - * @err_cnt:                   number of error for KPP requests
> - */
> -struct crypto_istat_kpp {
> -       atomic64_t setsecret_cnt;
> -       atomic64_t generate_public_key_cnt;
> -       atomic64_t compute_shared_secret_cnt;
> -       atomic64_t err_cnt;
> -};
> -
>  /**
>   * struct kpp_alg - generic key-agreement protocol primitives
>   *
>   * @set_secret:                Function invokes the protocol specific function to
>   *                     store the secret private key along with parameters.
>   *                     The implementation knows how to decode the buffer
>   * @generate_public_key: Function generate the public key to be sent to the
>   *                     counterpart. In case of error, where output is not big
>   *                     enough req->dst_len will be updated to the size
>   *                     required
> @@ -80,37 +66,32 @@ struct crypto_istat_kpp {
>   *                     In case of error, where output is not big enough,
>   *                     req->dst_len will be updated to the size required
>   * @max_size:          Function returns the size of the output buffer
>   * @init:              Initialize the object. This is called only once at
>   *                     instantiation time. In case the cryptographic hardware
>   *                     needs to be initialized. Software fallback should be
>   *                     put in place here.
>   * @exit:              Undo everything @init did.
>   *
>   * @base:              Common crypto API algorithm data structure
> - * @stat:              Statistics for KPP algorithm
>   */
>  struct kpp_alg {
>         int (*set_secret)(struct crypto_kpp *tfm, const void *buffer,
>                           unsigned int len);
>         int (*generate_public_key)(struct kpp_request *req);
>         int (*compute_shared_secret)(struct kpp_request *req);
>
>         unsigned int (*max_size)(struct crypto_kpp *tfm);
>
>         int (*init)(struct crypto_kpp *tfm);
>         void (*exit)(struct crypto_kpp *tfm);
>
> -#ifdef CONFIG_CRYPTO_STATS
> -       struct crypto_istat_kpp stat;
> -#endif
> -
>         struct crypto_alg base;
>  };
>
>  /**
>   * DOC: Generic Key-agreement Protocol Primitives API
>   *
>   * The KPP API is used with the algorithm type
>   * CRYPTO_ALG_TYPE_KPP (listed as type "kpp" in /proc/crypto)
>   */
>
> @@ -284,109 +265,76 @@ enum {
>   *
>   * @type:      define type of secret. Each kpp type will define its own
>   * @len:       specify the len of the secret, include the header, that
>   *             follows the struct
>   */
>  struct kpp_secret {
>         unsigned short type;
>         unsigned short len;
>  };
>
> -static inline struct crypto_istat_kpp *kpp_get_stat(struct kpp_alg *alg)
> -{
> -#ifdef CONFIG_CRYPTO_STATS
> -       return &alg->stat;
> -#else
> -       return NULL;
> -#endif
> -}
> -
> -static inline int crypto_kpp_errstat(struct kpp_alg *alg, int err)
> -{
> -       if (!IS_ENABLED(CONFIG_CRYPTO_STATS))
> -               return err;
> -
> -       if (err && err != -EINPROGRESS && err != -EBUSY)
> -               atomic64_inc(&kpp_get_stat(alg)->err_cnt);
> -
> -       return err;
> -}
> -
>  /**
>   * crypto_kpp_set_secret() - Invoke kpp operation
>   *
>   * Function invokes the specific kpp operation for a given alg.
>   *
>   * @tfm:       tfm handle
>   * @buffer:    Buffer holding the packet representation of the private
>   *             key. The structure of the packet key depends on the particular
>   *             KPP implementation. Packing and unpacking helpers are provided
>   *             for ECDH and DH (see the respective header files for those
>   *             implementations).
>   * @len:       Length of the packet private key buffer.
>   *
>   * Return: zero on success; error code in case of error
>   */
>  static inline int crypto_kpp_set_secret(struct crypto_kpp *tfm,
>                                         const void *buffer, unsigned int len)
>  {
> -       struct kpp_alg *alg = crypto_kpp_alg(tfm);
> -
> -       if (IS_ENABLED(CONFIG_CRYPTO_STATS))
> -               atomic64_inc(&kpp_get_stat(alg)->setsecret_cnt);
> -
> -       return crypto_kpp_errstat(alg, alg->set_secret(tfm, buffer, len));
> +       return crypto_kpp_alg(tfm)->set_secret(tfm, buffer, len);
>  }
>
>  /**
>   * crypto_kpp_generate_public_key() - Invoke kpp operation
>   *
>   * Function invokes the specific kpp operation for generating the public part
>   * for a given kpp algorithm.
>   *
>   * To generate a private key, the caller should use a random number generator.
>   * The output of the requested length serves as the private key.
>   *
>   * @req:       kpp key request
>   *
>   * Return: zero on success; error code in case of error
>   */
>  static inline int crypto_kpp_generate_public_key(struct kpp_request *req)
>  {
>         struct crypto_kpp *tfm = crypto_kpp_reqtfm(req);
> -       struct kpp_alg *alg = crypto_kpp_alg(tfm);
> -
> -       if (IS_ENABLED(CONFIG_CRYPTO_STATS))
> -               atomic64_inc(&kpp_get_stat(alg)->generate_public_key_cnt);
>
> -       return crypto_kpp_errstat(alg, alg->generate_public_key(req));
> +       return crypto_kpp_alg(tfm)->generate_public_key(req);
>  }
>
>  /**
>   * crypto_kpp_compute_shared_secret() - Invoke kpp operation
>   *
>   * Function invokes the specific kpp operation for computing the shared secret
>   * for a given kpp algorithm.
>   *
>   * @req:       kpp key request
>   *
>   * Return: zero on success; error code in case of error
>   */
>  static inline int crypto_kpp_compute_shared_secret(struct kpp_request *req)
>  {
>         struct crypto_kpp *tfm = crypto_kpp_reqtfm(req);
> -       struct kpp_alg *alg = crypto_kpp_alg(tfm);
> -
> -       if (IS_ENABLED(CONFIG_CRYPTO_STATS))
> -               atomic64_inc(&kpp_get_stat(alg)->compute_shared_secret_cnt);
>
> -       return crypto_kpp_errstat(alg, alg->compute_shared_secret(req));
> +       return crypto_kpp_alg(tfm)->compute_shared_secret(req);
>  }
>
>  /**
>   * crypto_kpp_maxsize() - Get len for output buffer
>   *
>   * Function returns the output buffer size required for a given key.
>   * Function assumes that the key is already set in the transformation. If this
>   * function is called without a setkey or with a failed setkey, you will end up
>   * in a NULL dereference.
>   *
> diff --git a/include/crypto/rng.h b/include/crypto/rng.h
> index 6abe5102e5fb1..5ac4388f50e13 100644
> --- a/include/crypto/rng.h
> +++ b/include/crypto/rng.h
> @@ -8,72 +8,53 @@
>
>  #ifndef _CRYPTO_RNG_H
>  #define _CRYPTO_RNG_H
>
>  #include <linux/atomic.h>
>  #include <linux/container_of.h>
>  #include <linux/crypto.h>
>
>  struct crypto_rng;
>
> -/*
> - * struct crypto_istat_rng: statistics for RNG algorithm
> - * @generate_cnt:      number of RNG generate requests
> - * @generate_tlen:     total data size of generated data by the RNG
> - * @seed_cnt:          number of times the RNG was seeded
> - * @err_cnt:           number of error for RNG requests
> - */
> -struct crypto_istat_rng {
> -       atomic64_t generate_cnt;
> -       atomic64_t generate_tlen;
> -       atomic64_t seed_cnt;
> -       atomic64_t err_cnt;
> -};
> -
>  /**
>   * struct rng_alg - random number generator definition
>   *
>   * @generate:  The function defined by this variable obtains a
>   *             random number. The random number generator transform
>   *             must generate the random number out of the context
>   *             provided with this call, plus any additional data
>   *             if provided to the call.
>   * @seed:      Seed or reseed the random number generator.  With the
>   *             invocation of this function call, the random number
>   *             generator shall become ready for generation.  If the
>   *             random number generator requires a seed for setting
>   *             up a new state, the seed must be provided by the
>   *             consumer while invoking this function. The required
>   *             size of the seed is defined with @seedsize .
>   * @set_ent:   Set entropy that would otherwise be obtained from
>   *             entropy source.  Internal use only.
> - * @stat:      Statistics for rng algorithm
>   * @seedsize:  The seed size required for a random number generator
>   *             initialization defined with this variable. Some
>   *             random number generators does not require a seed
>   *             as the seeding is implemented internally without
>   *             the need of support by the consumer. In this case,
>   *             the seed size is set to zero.
>   * @base:      Common crypto API algorithm data structure.
>   */
>  struct rng_alg {
>         int (*generate)(struct crypto_rng *tfm,
>                         const u8 *src, unsigned int slen,
>                         u8 *dst, unsigned int dlen);
>         int (*seed)(struct crypto_rng *tfm, const u8 *seed, unsigned int slen);
>         void (*set_ent)(struct crypto_rng *tfm, const u8 *data,
>                         unsigned int len);
>
> -#ifdef CONFIG_CRYPTO_STATS
> -       struct crypto_istat_rng stat;
> -#endif
> -
>         unsigned int seedsize;
>
>         struct crypto_alg base;
>  };
>
>  struct crypto_rng {
>         struct crypto_tfm base;
>  };
>
>  extern struct crypto_rng *crypto_default_rng;
> @@ -137,69 +118,39 @@ static inline struct rng_alg *crypto_rng_alg(struct crypto_rng *tfm)
>   * crypto_free_rng() - zeroize and free RNG handle
>   * @tfm: cipher handle to be freed
>   *
>   * If @tfm is a NULL or error pointer, this function does nothing.
>   */
>  static inline void crypto_free_rng(struct crypto_rng *tfm)
>  {
>         crypto_destroy_tfm(tfm, crypto_rng_tfm(tfm));
>  }
>
> -static inline struct crypto_istat_rng *rng_get_stat(struct rng_alg *alg)
> -{
> -#ifdef CONFIG_CRYPTO_STATS
> -       return &alg->stat;
> -#else
> -       return NULL;
> -#endif
> -}
> -
> -static inline int crypto_rng_errstat(struct rng_alg *alg, int err)
> -{
> -       if (!IS_ENABLED(CONFIG_CRYPTO_STATS))
> -               return err;
> -
> -       if (err && err != -EINPROGRESS && err != -EBUSY)
> -               atomic64_inc(&rng_get_stat(alg)->err_cnt);
> -
> -       return err;
> -}
> -
>  /**
>   * crypto_rng_generate() - get random number
>   * @tfm: cipher handle
>   * @src: Input buffer holding additional data, may be NULL
>   * @slen: Length of additional data
>   * @dst: output buffer holding the random numbers
>   * @dlen: length of the output buffer
>   *
>   * This function fills the caller-allocated buffer with random
>   * numbers using the random number generator referenced by the
>   * cipher handle.
>   *
>   * Return: 0 function was successful; < 0 if an error occurred
>   */
>  static inline int crypto_rng_generate(struct crypto_rng *tfm,
>                                       const u8 *src, unsigned int slen,
>                                       u8 *dst, unsigned int dlen)
>  {
> -       struct rng_alg *alg = crypto_rng_alg(tfm);
> -
> -       if (IS_ENABLED(CONFIG_CRYPTO_STATS)) {
> -               struct crypto_istat_rng *istat = rng_get_stat(alg);
> -
> -               atomic64_inc(&istat->generate_cnt);
> -               atomic64_add(dlen, &istat->generate_tlen);
> -       }
> -
> -       return crypto_rng_errstat(alg,
> -                                 alg->generate(tfm, src, slen, dst, dlen));
> +       return crypto_rng_alg(tfm)->generate(tfm, src, slen, dst, dlen);
>  }
>
>  /**
>   * crypto_rng_get_bytes() - get random number
>   * @tfm: cipher handle
>   * @rdata: output buffer holding the random numbers
>   * @dlen: length of the output buffer
>   *
>   * This function fills the caller-allocated buffer with random numbers using the
>   * random number generator referenced by the cipher handle.
> diff --git a/include/crypto/skcipher.h b/include/crypto/skcipher.h
> index c8857d7bdb37f..74d47e23374e6 100644
> --- a/include/crypto/skcipher.h
> +++ b/include/crypto/skcipher.h
> @@ -57,71 +57,46 @@ struct crypto_skcipher {
>  };
>
>  struct crypto_sync_skcipher {
>         struct crypto_skcipher base;
>  };
>
>  struct crypto_lskcipher {
>         struct crypto_tfm base;
>  };
>
> -/*
> - * struct crypto_istat_cipher - statistics for cipher algorithm
> - * @encrypt_cnt:       number of encrypt requests
> - * @encrypt_tlen:      total data size handled by encrypt requests
> - * @decrypt_cnt:       number of decrypt requests
> - * @decrypt_tlen:      total data size handled by decrypt requests
> - * @err_cnt:           number of error for cipher requests
> - */
> -struct crypto_istat_cipher {
> -       atomic64_t encrypt_cnt;
> -       atomic64_t encrypt_tlen;
> -       atomic64_t decrypt_cnt;
> -       atomic64_t decrypt_tlen;
> -       atomic64_t err_cnt;
> -};
> -
> -#ifdef CONFIG_CRYPTO_STATS
> -#define SKCIPHER_ALG_COMMON_STAT struct crypto_istat_cipher stat;
> -#else
> -#define SKCIPHER_ALG_COMMON_STAT
> -#endif
> -
>  /*
>   * struct skcipher_alg_common - common properties of skcipher_alg
>   * @min_keysize: Minimum key size supported by the transformation. This is the
>   *              smallest key length supported by this transformation algorithm.
>   *              This must be set to one of the pre-defined values as this is
>   *              not hardware specific. Possible values for this field can be
>   *              found via git grep "_MIN_KEY_SIZE" include/crypto/
>   * @max_keysize: Maximum key size supported by the transformation. This is the
>   *              largest key length supported by this transformation algorithm.
>   *              This must be set to one of the pre-defined values as this is
>   *              not hardware specific. Possible values for this field can be
>   *              found via git grep "_MAX_KEY_SIZE" include/crypto/
>   * @ivsize: IV size applicable for transformation. The consumer must provide an
>   *         IV of exactly that size to perform the encrypt or decrypt operation.
>   * @chunksize: Equal to the block size except for stream ciphers such as
>   *            CTR where it is set to the underlying block size.
>   * @statesize: Size of the internal state for the algorithm.
> - * @stat: Statistics for cipher algorithm
>   * @base: Definition of a generic crypto algorithm.
>   */
>  #define SKCIPHER_ALG_COMMON {          \
>         unsigned int min_keysize;       \
>         unsigned int max_keysize;       \
>         unsigned int ivsize;            \
>         unsigned int chunksize;         \
>         unsigned int statesize;         \
>                                         \
> -       SKCIPHER_ALG_COMMON_STAT        \
> -                                       \
>         struct crypto_alg base;         \
>  }
>  struct skcipher_alg_common SKCIPHER_ALG_COMMON;
>
>  /**
>   * struct skcipher_alg - symmetric key cipher definition
>   * @setkey: Set key for the transformation. This function is used to either
>   *         program a supplied key into the hardware or store the key in the
>   *         transformation context for programming it later. Note that this
>   *         function does modify the transformation context. This function can
> diff --git a/include/uapi/linux/cryptouser.h b/include/uapi/linux/cryptouser.h
> index 5730c67f0617c..e163670d60f7d 100644
> --- a/include/uapi/linux/cryptouser.h
> +++ b/include/uapi/linux/cryptouser.h
> @@ -47,106 +47,114 @@ enum crypto_attr_type_t {
>         CRYPTOCFGA_REPORT_LARVAL,       /* struct crypto_report_larval */
>         CRYPTOCFGA_REPORT_HASH,         /* struct crypto_report_hash */
>         CRYPTOCFGA_REPORT_BLKCIPHER,    /* struct crypto_report_blkcipher */
>         CRYPTOCFGA_REPORT_AEAD,         /* struct crypto_report_aead */
>         CRYPTOCFGA_REPORT_COMPRESS,     /* struct crypto_report_comp */
>         CRYPTOCFGA_REPORT_RNG,          /* struct crypto_report_rng */
>         CRYPTOCFGA_REPORT_CIPHER,       /* struct crypto_report_cipher */
>         CRYPTOCFGA_REPORT_AKCIPHER,     /* struct crypto_report_akcipher */
>         CRYPTOCFGA_REPORT_KPP,          /* struct crypto_report_kpp */
>         CRYPTOCFGA_REPORT_ACOMP,        /* struct crypto_report_acomp */
> -       CRYPTOCFGA_STAT_LARVAL,         /* struct crypto_stat */
> -       CRYPTOCFGA_STAT_HASH,           /* struct crypto_stat */
> -       CRYPTOCFGA_STAT_BLKCIPHER,      /* struct crypto_stat */
> -       CRYPTOCFGA_STAT_AEAD,           /* struct crypto_stat */
> -       CRYPTOCFGA_STAT_COMPRESS,       /* struct crypto_stat */
> -       CRYPTOCFGA_STAT_RNG,            /* struct crypto_stat */
> -       CRYPTOCFGA_STAT_CIPHER,         /* struct crypto_stat */
> -       CRYPTOCFGA_STAT_AKCIPHER,       /* struct crypto_stat */
> -       CRYPTOCFGA_STAT_KPP,            /* struct crypto_stat */
> -       CRYPTOCFGA_STAT_ACOMP,          /* struct crypto_stat */
> +       CRYPTOCFGA_STAT_LARVAL,         /* No longer supported */
> +       CRYPTOCFGA_STAT_HASH,           /* No longer supported */
> +       CRYPTOCFGA_STAT_BLKCIPHER,      /* No longer supported */
> +       CRYPTOCFGA_STAT_AEAD,           /* No longer supported */
> +       CRYPTOCFGA_STAT_COMPRESS,       /* No longer supported */
> +       CRYPTOCFGA_STAT_RNG,            /* No longer supported */
> +       CRYPTOCFGA_STAT_CIPHER,         /* No longer supported */
> +       CRYPTOCFGA_STAT_AKCIPHER,       /* No longer supported */
> +       CRYPTOCFGA_STAT_KPP,            /* No longer supported */
> +       CRYPTOCFGA_STAT_ACOMP,          /* No longer supported */
>         __CRYPTOCFGA_MAX
>
>  #define CRYPTOCFGA_MAX (__CRYPTOCFGA_MAX - 1)
>  };
>
>  struct crypto_user_alg {
>         char cru_name[CRYPTO_MAX_NAME];
>         char cru_driver_name[CRYPTO_MAX_NAME];
>         char cru_module_name[CRYPTO_MAX_NAME];
>         __u32 cru_type;
>         __u32 cru_mask;
>         __u32 cru_refcnt;
>         __u32 cru_flags;
>  };
>
> +/* No longer supported, do not use. */
>  struct crypto_stat_aead {
>         char type[CRYPTO_MAX_NAME];
>         __u64 stat_encrypt_cnt;
>         __u64 stat_encrypt_tlen;
>         __u64 stat_decrypt_cnt;
>         __u64 stat_decrypt_tlen;
>         __u64 stat_err_cnt;
>  };
>
> +/* No longer supported, do not use. */
>  struct crypto_stat_akcipher {
>         char type[CRYPTO_MAX_NAME];
>         __u64 stat_encrypt_cnt;
>         __u64 stat_encrypt_tlen;
>         __u64 stat_decrypt_cnt;
>         __u64 stat_decrypt_tlen;
>         __u64 stat_verify_cnt;
>         __u64 stat_sign_cnt;
>         __u64 stat_err_cnt;
>  };
>
> +/* No longer supported, do not use. */
>  struct crypto_stat_cipher {
>         char type[CRYPTO_MAX_NAME];
>         __u64 stat_encrypt_cnt;
>         __u64 stat_encrypt_tlen;
>         __u64 stat_decrypt_cnt;
>         __u64 stat_decrypt_tlen;
>         __u64 stat_err_cnt;
>  };
>
> +/* No longer supported, do not use. */
>  struct crypto_stat_compress {
>         char type[CRYPTO_MAX_NAME];
>         __u64 stat_compress_cnt;
>         __u64 stat_compress_tlen;
>         __u64 stat_decompress_cnt;
>         __u64 stat_decompress_tlen;
>         __u64 stat_err_cnt;
>  };
>
> +/* No longer supported, do not use. */
>  struct crypto_stat_hash {
>         char type[CRYPTO_MAX_NAME];
>         __u64 stat_hash_cnt;
>         __u64 stat_hash_tlen;
>         __u64 stat_err_cnt;
>  };
>
> +/* No longer supported, do not use. */
>  struct crypto_stat_kpp {
>         char type[CRYPTO_MAX_NAME];
>         __u64 stat_setsecret_cnt;
>         __u64 stat_generate_public_key_cnt;
>         __u64 stat_compute_shared_secret_cnt;
>         __u64 stat_err_cnt;
>  };
>
> +/* No longer supported, do not use. */
>  struct crypto_stat_rng {
>         char type[CRYPTO_MAX_NAME];
>         __u64 stat_generate_cnt;
>         __u64 stat_generate_tlen;
>         __u64 stat_seed_cnt;
>         __u64 stat_err_cnt;
>  };
>
> +/* No longer supported, do not use. */
>  struct crypto_stat_larval {
>         char type[CRYPTO_MAX_NAME];
>  };
>
>  struct crypto_report_larval {
>         char type[CRYPTO_MAX_NAME];
>  };
>
>  struct crypto_report_hash {
>         char type[CRYPTO_MAX_NAME];
>
> base-commit: 7d42e097607c4d246d99225bf2b195b6167a210c
> --
> 2.43.2
>
>
