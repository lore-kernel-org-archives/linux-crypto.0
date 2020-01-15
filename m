Return-Path: <SRS0=cdcO=3E=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C6FB2C32771
	for <linux-crypto@archiver.kernel.org>; Wed, 15 Jan 2020 03:55:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8895524671
	for <linux-crypto@archiver.kernel.org>; Wed, 15 Jan 2020 03:55:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="jA6stuCO"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729078AbgAODzY (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 14 Jan 2020 22:55:24 -0500
Received: from mail-pl1-f196.google.com ([209.85.214.196]:34575 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729077AbgAODzX (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 14 Jan 2020 22:55:23 -0500
Received: by mail-pl1-f196.google.com with SMTP id c9so961287plo.1
        for <linux-crypto@vger.kernel.org>; Tue, 14 Jan 2020 19:55:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=y5NISFHF0HgNkns5FjEleQVJsu3+QkUvrpVK9YCpsK8=;
        b=jA6stuCOaFn8GN2fQLRS+AljcjeiE9/LX2fqcgYGw5vWoqOKIyuttP1/QpQTLj/5dR
         qUrqAP0aXZ3AhSN0acE/OS5/FWjOtu/lW5S6wN0k7ndmIWxZje1A5qhpyNLKkiKPum6n
         Fqin4PweBcblfxZIoyEsFjW4pYswBRtS541L0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=y5NISFHF0HgNkns5FjEleQVJsu3+QkUvrpVK9YCpsK8=;
        b=bBh3iz43Vk8MaNMPUzlzhgCyxIg0jbR5KBYYeh5B8L1cMwsOYtvz2mXUd7606Q0h2d
         qK6Hwvm4Zh9yF3Hngja0zxeddM4k0PDw4rIkPUPEHgMOZXIReMEemN+Z7TuCAal79PBB
         bii12/DWNnF/pdvw9DCnUQCrU3zrAnvROfrT+5v5N/fQU1t7hskUUfYvomUxi4F8qVSw
         eXP2Gwi060Co/T5pRxnYSxFOIzQ0EknWewTZnmO9j6wm0eKYEfgpf/sU2OG8ukIxUVOC
         QvbxjG3w1RKHUZ2akW6+UySok13XiW5p3IFvZ5p/hFVtwizedhAP4v20EW6Y9WvQ+vbH
         2UjA==
X-Gm-Message-State: APjAAAUIpJoNReV6JEYq//hv/xOHpJEGpqk3xEChKr3qjH7Q2HVrchPV
        uyE+t1UfxYhDA0QC5VVXYm0FFg==
X-Google-Smtp-Source: APXvYqwxO6xHulA0X6HjztkpLG8pHpqM4seIlo1qn868JQWom5430H6M/ei27Usrbt863qVByBK9CQ==
X-Received: by 2002:a17:902:a986:: with SMTP id bh6mr7361439plb.340.1579060522691;
        Tue, 14 Jan 2020 19:55:22 -0800 (PST)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id x7sm20349195pfp.93.2020.01.14.19.55.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Jan 2020 19:55:21 -0800 (PST)
Date:   Tue, 14 Jan 2020 19:55:20 -0800
From:   Kees Cook <keescook@chromium.org>
To:     Eric Biggers <ebiggers@kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>
Cc:     linux-kernel@vger.kernel.org, x86@kernel.org,
        linux-crypto@vger.kernel.org,
        Sami Tolvanen <samitolvanen@google.com>
Subject: Re: [PATCH v2] crypto, x86/sha: Eliminate casts on asm
 implementations
Message-ID: <202001141954.BABC753247@keescook>
References: <202001141825.8CD52D0@keescook>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <202001141825.8CD52D0@keescook>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, Jan 14, 2020 at 06:28:48PM -0800, Kees Cook wrote:
> In order to avoid CFI function prototype mismatches, this removes the
> casts on assembly implementations of sha1/256/512 accelerators. The
> safety checks from BUILD_BUG_ON() remain.
> 
> Additionally, this renames various arguments for clarity, as suggested
> by Eric Biggers.
> 
> Signed-off-by: Kees Cook <keescook@chromium.org>
> ---
> I'm calling this v2 since it's now stand-alone. I think I caught
> everything now...
> v2: clean up more comments (ebiggers)
> v1: https://lore.kernel.org/lkml/20191122030620.GD32523@sol.localdomain/

Gah, I built the wrong tree before sending this. This patch has a
mistake; I will send a v3 with corrections.

-Kees

> ---
>  arch/x86/crypto/sha1_avx2_x86_64_asm.S |  6 +--
>  arch/x86/crypto/sha1_ssse3_asm.S       | 14 ++++--
>  arch/x86/crypto/sha1_ssse3_glue.c      | 68 +++++++++++---------------
>  arch/x86/crypto/sha256-avx-asm.S       |  4 +-
>  arch/x86/crypto/sha256-avx2-asm.S      |  4 +-
>  arch/x86/crypto/sha256-ssse3-asm.S     |  6 ++-
>  arch/x86/crypto/sha256_ssse3_glue.c    | 34 ++++++-------
>  arch/x86/crypto/sha512-avx-asm.S       | 11 +++--
>  arch/x86/crypto/sha512-avx2-asm.S      | 11 +++--
>  arch/x86/crypto/sha512-ssse3-asm.S     | 13 +++--
>  arch/x86/crypto/sha512_ssse3_glue.c    | 31 ++++++------
>  11 files changed, 101 insertions(+), 101 deletions(-)
> 
> diff --git a/arch/x86/crypto/sha1_avx2_x86_64_asm.S b/arch/x86/crypto/sha1_avx2_x86_64_asm.S
> index 6decc85ef7b7..1e594d60afa5 100644
> --- a/arch/x86/crypto/sha1_avx2_x86_64_asm.S
> +++ b/arch/x86/crypto/sha1_avx2_x86_64_asm.S
> @@ -62,11 +62,11 @@
>   *Visit http://software.intel.com/en-us/articles/
>   *and refer to improving-the-performance-of-the-secure-hash-algorithm-1/
>   *
> - *Updates 20-byte SHA-1 record in 'hash' for even number of
> - *'num_blocks' consecutive 64-byte blocks
> + *Updates 20-byte SHA-1 record at start of 'state', from 'input', for
> + *even number of 'blocks' consecutive 64-byte blocks.
>   *
>   *extern "C" void sha1_transform_avx2(
> - *	int *hash, const char* input, size_t num_blocks );
> + *	struct sha1_state *state, const u8* input, int blocks );
>   */
>  
>  #include <linux/linkage.h>
> diff --git a/arch/x86/crypto/sha1_ssse3_asm.S b/arch/x86/crypto/sha1_ssse3_asm.S
> index 5d03c1173690..12e2d19d7402 100644
> --- a/arch/x86/crypto/sha1_ssse3_asm.S
> +++ b/arch/x86/crypto/sha1_ssse3_asm.S
> @@ -457,9 +457,13 @@ W_PRECALC_SSSE3
>  	movdqu	\a,\b
>  .endm
>  
> -/* SSSE3 optimized implementation:
> - *  extern "C" void sha1_transform_ssse3(u32 *digest, const char *data, u32 *ws,
> - *                                       unsigned int rounds);
> +/*
> + * SSSE3 optimized implementation:
> + *
> + * extern "C" void sha1_transform_ssse3(struct sha1_state *state,
> + *					const u8 *data, int blocks);
> + *
> + * Note that struct sha1_state is assumed to begin with u32 state[5].
>   */
>  SHA1_VECTOR_ASM     sha1_transform_ssse3
>  
> @@ -545,8 +549,8 @@ W_PRECALC_AVX
>  
>  
>  /* AVX optimized implementation:
> - *  extern "C" void sha1_transform_avx(u32 *digest, const char *data, u32 *ws,
> - *                                     unsigned int rounds);
> + *  extern "C" void sha1_transform_avx(struct sha1_state *state,
> + *				       const u8 *data, int blocks);
>   */
>  SHA1_VECTOR_ASM     sha1_transform_avx
>  
> diff --git a/arch/x86/crypto/sha1_ssse3_glue.c b/arch/x86/crypto/sha1_ssse3_glue.c
> index 639d4c2fd6a8..f7c8d043f6c1 100644
> --- a/arch/x86/crypto/sha1_ssse3_glue.c
> +++ b/arch/x86/crypto/sha1_ssse3_glue.c
> @@ -27,11 +27,8 @@
>  #include <crypto/sha1_base.h>
>  #include <asm/simd.h>
>  
> -typedef void (sha1_transform_fn)(u32 *digest, const char *data,
> -				unsigned int rounds);
> -
>  static int sha1_update(struct shash_desc *desc, const u8 *data,
> -			     unsigned int len, sha1_transform_fn *sha1_xform)
> +			     unsigned int len, sha1_block_fn *sha1_xform)
>  {
>  	struct sha1_state *sctx = shash_desc_ctx(desc);
>  
> @@ -39,48 +36,47 @@ static int sha1_update(struct shash_desc *desc, const u8 *data,
>  	    (sctx->count % SHA1_BLOCK_SIZE) + len < SHA1_BLOCK_SIZE)
>  		return crypto_sha1_update(desc, data, len);
>  
> -	/* make sure casting to sha1_block_fn() is safe */
> +	/*
> +	 * Make sure struct sha1_state begins directly with the SHA1
> +	 * 160-bit internal state, as this is what the asm functions expect.
> +	 */
>  	BUILD_BUG_ON(offsetof(struct sha1_state, state) != 0);
>  
>  	kernel_fpu_begin();
> -	sha1_base_do_update(desc, data, len,
> -			    (sha1_block_fn *)sha1_xform);
> +	sha1_base_do_update(desc, data, len, sha1_xform);
>  	kernel_fpu_end();
>  
>  	return 0;
>  }
>  
>  static int sha1_finup(struct shash_desc *desc, const u8 *data,
> -		      unsigned int len, u8 *out, sha1_transform_fn *sha1_xform)
> +		      unsigned int len, u8 *out, sha1_block_fn *sha1_xform)
>  {
>  	if (!crypto_simd_usable())
>  		return crypto_sha1_finup(desc, data, len, out);
>  
>  	kernel_fpu_begin();
>  	if (len)
> -		sha1_base_do_update(desc, data, len,
> -				    (sha1_block_fn *)sha1_xform);
> -	sha1_base_do_finalize(desc, (sha1_block_fn *)sha1_xform);
> +		sha1_base_do_update(desc, data, len, sha1_xform);
> +	sha1_base_do_finalize(desc, sha1_xform);
>  	kernel_fpu_end();
>  
>  	return sha1_base_finish(desc, out);
>  }
>  
> -asmlinkage void sha1_transform_ssse3(u32 *digest, const char *data,
> -				     unsigned int rounds);
> +asmlinkage void sha1_transform_ssse3(struct sha1_state *state,
> +				     const u8 *data, int blocks);
>  
>  static int sha1_ssse3_update(struct shash_desc *desc, const u8 *data,
>  			     unsigned int len)
>  {
> -	return sha1_update(desc, data, len,
> -			(sha1_transform_fn *) sha1_transform_ssse3);
> +	return sha1_update(desc, data, len, sha1_transform_ssse3);
>  }
>  
>  static int sha1_ssse3_finup(struct shash_desc *desc, const u8 *data,
>  			      unsigned int len, u8 *out)
>  {
> -	return sha1_finup(desc, data, len, out,
> -			(sha1_transform_fn *) sha1_transform_ssse3);
> +	return sha1_finup(desc, data, len, out, sha1_transform_ssse3);
>  }
>  
>  /* Add padding and return the message digest. */
> @@ -119,21 +115,19 @@ static void unregister_sha1_ssse3(void)
>  }
>  
>  #ifdef CONFIG_AS_AVX
> -asmlinkage void sha1_transform_avx(u32 *digest, const char *data,
> -				   unsigned int rounds);
> +asmlinkage void sha1_transform_avx(struct sha1_state *state,
> +				   const u8 *data, int blocks);
>  
>  static int sha1_avx_update(struct shash_desc *desc, const u8 *data,
>  			     unsigned int len)
>  {
> -	return sha1_update(desc, data, len,
> -			(sha1_transform_fn *) sha1_transform_avx);
> +	return sha1_update(desc, data, len, sha1_transform_avx);
>  }
>  
>  static int sha1_avx_finup(struct shash_desc *desc, const u8 *data,
>  			      unsigned int len, u8 *out)
>  {
> -	return sha1_finup(desc, data, len, out,
> -			(sha1_transform_fn *) sha1_transform_avx);
> +	return sha1_finup(desc, data, len, out, sha1_transform_avx);
>  }
>  
>  static int sha1_avx_final(struct shash_desc *desc, u8 *out)
> @@ -190,8 +184,8 @@ static inline void unregister_sha1_avx(void) { }
>  #if defined(CONFIG_AS_AVX2) && (CONFIG_AS_AVX)
>  #define SHA1_AVX2_BLOCK_OPTSIZE	4	/* optimal 4*64 bytes of SHA1 blocks */
>  
> -asmlinkage void sha1_transform_avx2(u32 *digest, const char *data,
> -				    unsigned int rounds);
> +asmlinkage void sha1_transform_avx2(struct sha1_state *state,
> +				    const u8 *data, int blocks);
>  
>  static bool avx2_usable(void)
>  {
> @@ -203,28 +197,26 @@ static bool avx2_usable(void)
>  	return false;
>  }
>  
> -static void sha1_apply_transform_avx2(u32 *digest, const char *data,
> -				unsigned int rounds)
> +static void sha1_apply_transform_avx2(struct sha1_state *state,
> +				      const u8 *data, int blocks)
>  {
>  	/* Select the optimal transform based on data block size */
>  	if (rounds >= SHA1_AVX2_BLOCK_OPTSIZE)
> -		sha1_transform_avx2(digest, data, rounds);
> +		sha1_transform_avx2(state, data, blocks);
>  	else
> -		sha1_transform_avx(digest, data, rounds);
> +		sha1_transform_avx(state, data, blocks);
>  }
>  
>  static int sha1_avx2_update(struct shash_desc *desc, const u8 *data,
>  			     unsigned int len)
>  {
> -	return sha1_update(desc, data, len,
> -		(sha1_transform_fn *) sha1_apply_transform_avx2);
> +	return sha1_update(desc, data, len, sha1_apply_transform_avx2);
>  }
>  
>  static int sha1_avx2_finup(struct shash_desc *desc, const u8 *data,
>  			      unsigned int len, u8 *out)
>  {
> -	return sha1_finup(desc, data, len, out,
> -		(sha1_transform_fn *) sha1_apply_transform_avx2);
> +	return sha1_finup(desc, data, len, out, sha1_apply_transform_avx2);
>  }
>  
>  static int sha1_avx2_final(struct shash_desc *desc, u8 *out)
> @@ -267,21 +259,19 @@ static inline void unregister_sha1_avx2(void) { }
>  #endif
>  
>  #ifdef CONFIG_AS_SHA1_NI
> -asmlinkage void sha1_ni_transform(u32 *digest, const char *data,
> -				   unsigned int rounds);
> +asmlinkage void sha1_ni_transform(struct sha1_state *digest, const u8 *data,
> +				  int rounds);
>  
>  static int sha1_ni_update(struct shash_desc *desc, const u8 *data,
>  			     unsigned int len)
>  {
> -	return sha1_update(desc, data, len,
> -		(sha1_transform_fn *) sha1_ni_transform);
> +	return sha1_update(desc, data, len, sha1_ni_transform);
>  }
>  
>  static int sha1_ni_finup(struct shash_desc *desc, const u8 *data,
>  			      unsigned int len, u8 *out)
>  {
> -	return sha1_finup(desc, data, len, out,
> -		(sha1_transform_fn *) sha1_ni_transform);
> +	return sha1_finup(desc, data, len, out, sha1_ni_transform);
>  }
>  
>  static int sha1_ni_final(struct shash_desc *desc, u8 *out)
> diff --git a/arch/x86/crypto/sha256-avx-asm.S b/arch/x86/crypto/sha256-avx-asm.S
> index 22e14c8dd2e4..fcbc30f58c38 100644
> --- a/arch/x86/crypto/sha256-avx-asm.S
> +++ b/arch/x86/crypto/sha256-avx-asm.S
> @@ -341,8 +341,8 @@ a = TMP_
>  .endm
>  
>  ########################################################################
> -## void sha256_transform_avx(void *input_data, UINT32 digest[8], UINT64 num_blks)
> -## arg 1 : pointer to digest
> +## void sha256_transform_avx(state sha256_state *state, const u8 *data, int blocks)
> +## arg 1 : pointer to state
>  ## arg 2 : pointer to input data
>  ## arg 3 : Num blocks
>  ########################################################################
> diff --git a/arch/x86/crypto/sha256-avx2-asm.S b/arch/x86/crypto/sha256-avx2-asm.S
> index 519b551ad576..499d9ec129de 100644
> --- a/arch/x86/crypto/sha256-avx2-asm.S
> +++ b/arch/x86/crypto/sha256-avx2-asm.S
> @@ -520,8 +520,8 @@ STACK_SIZE	= _RSP      + _RSP_SIZE
>  .endm
>  
>  ########################################################################
> -## void sha256_transform_rorx(void *input_data, UINT32 digest[8], UINT64 num_blks)
> -## arg 1 : pointer to digest
> +## void sha256_transform_rorx(struct sha256_state *state, const u8 *data, int blocks)
> +## arg 1 : pointer to state
>  ## arg 2 : pointer to input data
>  ## arg 3 : Num blocks
>  ########################################################################
> diff --git a/arch/x86/crypto/sha256-ssse3-asm.S b/arch/x86/crypto/sha256-ssse3-asm.S
> index 69cc2f91dc4c..ddfa863b4ee3 100644
> --- a/arch/x86/crypto/sha256-ssse3-asm.S
> +++ b/arch/x86/crypto/sha256-ssse3-asm.S
> @@ -347,8 +347,10 @@ a = TMP_
>  .endm
>  
>  ########################################################################
> -## void sha256_transform_ssse3(void *input_data, UINT32 digest[8], UINT64 num_blks)
> -## arg 1 : pointer to digest
> +## void sha256_transform_ssse3(struct sha256_state *state, const u8 *data,
> +##			       int blocks);
> +## arg 1 : pointer to state
> +##	   (struct sha256_state is assumed to begin with u32 state[8])
>  ## arg 2 : pointer to input data
>  ## arg 3 : Num blocks
>  ########################################################################
> diff --git a/arch/x86/crypto/sha256_ssse3_glue.c b/arch/x86/crypto/sha256_ssse3_glue.c
> index f9aff31fe59e..03ad657c04bd 100644
> --- a/arch/x86/crypto/sha256_ssse3_glue.c
> +++ b/arch/x86/crypto/sha256_ssse3_glue.c
> @@ -41,12 +41,11 @@
>  #include <linux/string.h>
>  #include <asm/simd.h>
>  
> -asmlinkage void sha256_transform_ssse3(u32 *digest, const char *data,
> -				       u64 rounds);
> -typedef void (sha256_transform_fn)(u32 *digest, const char *data, u64 rounds);
> +asmlinkage void sha256_transform_ssse3(struct sha256_state *state,
> +				       const u8 *data, int blocks);
>  
>  static int _sha256_update(struct shash_desc *desc, const u8 *data,
> -			  unsigned int len, sha256_transform_fn *sha256_xform)
> +			  unsigned int len, sha256_block_fn *sha256_xform)
>  {
>  	struct sha256_state *sctx = shash_desc_ctx(desc);
>  
> @@ -54,28 +53,29 @@ static int _sha256_update(struct shash_desc *desc, const u8 *data,
>  	    (sctx->count % SHA256_BLOCK_SIZE) + len < SHA256_BLOCK_SIZE)
>  		return crypto_sha256_update(desc, data, len);
>  
> -	/* make sure casting to sha256_block_fn() is safe */
> +	/*
> +	 * Make sure struct sha256_state begins directly with the SHA256
> +	 * 256-bit internal state, as this is what the asm functions expect.
> +	 */
>  	BUILD_BUG_ON(offsetof(struct sha256_state, state) != 0);
>  
>  	kernel_fpu_begin();
> -	sha256_base_do_update(desc, data, len,
> -			      (sha256_block_fn *)sha256_xform);
> +	sha256_base_do_update(desc, data, len, sha256_xform);
>  	kernel_fpu_end();
>  
>  	return 0;
>  }
>  
>  static int sha256_finup(struct shash_desc *desc, const u8 *data,
> -	      unsigned int len, u8 *out, sha256_transform_fn *sha256_xform)
> +	      unsigned int len, u8 *out, sha256_block_fn *sha256_xform)
>  {
>  	if (!crypto_simd_usable())
>  		return crypto_sha256_finup(desc, data, len, out);
>  
>  	kernel_fpu_begin();
>  	if (len)
> -		sha256_base_do_update(desc, data, len,
> -				      (sha256_block_fn *)sha256_xform);
> -	sha256_base_do_finalize(desc, (sha256_block_fn *)sha256_xform);
> +		sha256_base_do_update(desc, data, len, sha256_xform);
> +	sha256_base_do_finalize(desc, sha256_xform);
>  	kernel_fpu_end();
>  
>  	return sha256_base_finish(desc, out);
> @@ -145,8 +145,8 @@ static void unregister_sha256_ssse3(void)
>  }
>  
>  #ifdef CONFIG_AS_AVX
> -asmlinkage void sha256_transform_avx(u32 *digest, const char *data,
> -				     u64 rounds);
> +asmlinkage void sha256_transform_avx(struct sha256_state *state,
> +				     const u8 *data, int blocks);
>  
>  static int sha256_avx_update(struct shash_desc *desc, const u8 *data,
>  			 unsigned int len)
> @@ -227,8 +227,8 @@ static inline void unregister_sha256_avx(void) { }
>  #endif
>  
>  #if defined(CONFIG_AS_AVX2) && defined(CONFIG_AS_AVX)
> -asmlinkage void sha256_transform_rorx(u32 *digest, const char *data,
> -				      u64 rounds);
> +asmlinkage void sha256_transform_rorx(struct sha256_state *state,
> +				      const u8 *data, int blocks);
>  
>  static int sha256_avx2_update(struct shash_desc *desc, const u8 *data,
>  			 unsigned int len)
> @@ -307,8 +307,8 @@ static inline void unregister_sha256_avx2(void) { }
>  #endif
>  
>  #ifdef CONFIG_AS_SHA256_NI
> -asmlinkage void sha256_ni_transform(u32 *digest, const char *data,
> -				   u64 rounds); /*unsigned int rounds);*/
> +asmlinkage void sha256_ni_transform(struct sha256_state *digest,
> +				    const u8 *data, int rounds);
>  
>  static int sha256_ni_update(struct shash_desc *desc, const u8 *data,
>  			 unsigned int len)
> diff --git a/arch/x86/crypto/sha512-avx-asm.S b/arch/x86/crypto/sha512-avx-asm.S
> index 3704ddd7e5d5..90ea945ba5e6 100644
> --- a/arch/x86/crypto/sha512-avx-asm.S
> +++ b/arch/x86/crypto/sha512-avx-asm.S
> @@ -271,11 +271,12 @@ frame_size = frame_GPRSAVE + GPRSAVE_SIZE
>  .endm
>  
>  ########################################################################
> -# void sha512_transform_avx(void* D, const void* M, u64 L)
> -# Purpose: Updates the SHA512 digest stored at D with the message stored in M.
> -# The size of the message pointed to by M must be an integer multiple of SHA512
> -# message blocks.
> -# L is the message length in SHA512 blocks
> +# void sha512_transform_avx(sha512_state *state, const u8 *data, int blocks)
> +# Purpose: Updates the SHA512 digest stored at "state" with the message
> +# stored in "data".
> +# The size of the message pointed to by "data" must be an integer multiple
> +# of SHA512 message blocks.
> +# "blocks" is the message length in SHA512 blocks
>  ########################################################################
>  SYM_FUNC_START(sha512_transform_avx)
>  	cmp $0, msglen
> diff --git a/arch/x86/crypto/sha512-avx2-asm.S b/arch/x86/crypto/sha512-avx2-asm.S
> index 80d830e7ee09..3dd886b14e7d 100644
> --- a/arch/x86/crypto/sha512-avx2-asm.S
> +++ b/arch/x86/crypto/sha512-avx2-asm.S
> @@ -563,11 +563,12 @@ frame_size = frame_GPRSAVE + GPRSAVE_SIZE
>  .endm
>  
>  ########################################################################
> -# void sha512_transform_rorx(void* D, const void* M, uint64_t L)#
> -# Purpose: Updates the SHA512 digest stored at D with the message stored in M.
> -# The size of the message pointed to by M must be an integer multiple of SHA512
> -#   message blocks.
> -# L is the message length in SHA512 blocks
> +# void sha512_transform_rorx(sha512_state *state, const u8 *data, int blocks)
> +# Purpose: Updates the SHA512 digest stored at "state" with the message
> +# stored in "data".
> +# The size of the message pointed to by "data" must be an integer multiple
> +# of SHA512 message blocks.
> +# "blocks" is the message length in SHA512 blocks
>  ########################################################################
>  SYM_FUNC_START(sha512_transform_rorx)
>  	# Allocate Stack Space
> diff --git a/arch/x86/crypto/sha512-ssse3-asm.S b/arch/x86/crypto/sha512-ssse3-asm.S
> index 838f984e95d9..7946a1bee85b 100644
> --- a/arch/x86/crypto/sha512-ssse3-asm.S
> +++ b/arch/x86/crypto/sha512-ssse3-asm.S
> @@ -269,11 +269,14 @@ frame_size = frame_GPRSAVE + GPRSAVE_SIZE
>  .endm
>  
>  ########################################################################
> -# void sha512_transform_ssse3(void* D, const void* M, u64 L)#
> -# Purpose: Updates the SHA512 digest stored at D with the message stored in M.
> -# The size of the message pointed to by M must be an integer multiple of SHA512
> -#   message blocks.
> -# L is the message length in SHA512 blocks.
> +## void sha512_transform_ssse3(struct sha512_state *state, const u8 *data,
> +##			       int blocks);
> +# (struct sha512_state is assumed to begin with u64 state[8])
> +# Purpose: Updates the SHA512 digest stored at "state" with the message
> +# stored in "data".
> +# The size of the message pointed to by "data" must be an integer multiple
> +# of SHA512 message blocks.
> +# "blocks" is the message length in SHA512 blocks.
>  ########################################################################
>  SYM_FUNC_START(sha512_transform_ssse3)
>  
> diff --git a/arch/x86/crypto/sha512_ssse3_glue.c b/arch/x86/crypto/sha512_ssse3_glue.c
> index 458356a3f124..1c444f41037c 100644
> --- a/arch/x86/crypto/sha512_ssse3_glue.c
> +++ b/arch/x86/crypto/sha512_ssse3_glue.c
> @@ -39,13 +39,11 @@
>  #include <crypto/sha512_base.h>
>  #include <asm/simd.h>
>  
> -asmlinkage void sha512_transform_ssse3(u64 *digest, const char *data,
> -				       u64 rounds);
> -
> -typedef void (sha512_transform_fn)(u64 *digest, const char *data, u64 rounds);
> +asmlinkage void sha512_transform_ssse3(struct sha512_state *state,
> +				       const u8 *data, int blocks);
>  
>  static int sha512_update(struct shash_desc *desc, const u8 *data,
> -		       unsigned int len, sha512_transform_fn *sha512_xform)
> +		       unsigned int len, sha512_block_fn *sha512_xform)
>  {
>  	struct sha512_state *sctx = shash_desc_ctx(desc);
>  
> @@ -53,28 +51,29 @@ static int sha512_update(struct shash_desc *desc, const u8 *data,
>  	    (sctx->count[0] % SHA512_BLOCK_SIZE) + len < SHA512_BLOCK_SIZE)
>  		return crypto_sha512_update(desc, data, len);
>  
> -	/* make sure casting to sha512_block_fn() is safe */
> +	/*
> +	 * Make sure struct sha512_state begins directly with the SHA512
> +	 * 512-bit internal state, as this is what the asm functions expect.
> +	 */
>  	BUILD_BUG_ON(offsetof(struct sha512_state, state) != 0);
>  
>  	kernel_fpu_begin();
> -	sha512_base_do_update(desc, data, len,
> -			      (sha512_block_fn *)sha512_xform);
> +	sha512_base_do_update(desc, data, len, sha512_xform);
>  	kernel_fpu_end();
>  
>  	return 0;
>  }
>  
>  static int sha512_finup(struct shash_desc *desc, const u8 *data,
> -	      unsigned int len, u8 *out, sha512_transform_fn *sha512_xform)
> +	      unsigned int len, u8 *out, sha512_block_fn *sha512_xform)
>  {
>  	if (!crypto_simd_usable())
>  		return crypto_sha512_finup(desc, data, len, out);
>  
>  	kernel_fpu_begin();
>  	if (len)
> -		sha512_base_do_update(desc, data, len,
> -				      (sha512_block_fn *)sha512_xform);
> -	sha512_base_do_finalize(desc, (sha512_block_fn *)sha512_xform);
> +		sha512_base_do_update(desc, data, len, sha512_xform);
> +	sha512_base_do_finalize(desc, sha512_xform);
>  	kernel_fpu_end();
>  
>  	return sha512_base_finish(desc, out);
> @@ -144,8 +143,8 @@ static void unregister_sha512_ssse3(void)
>  }
>  
>  #ifdef CONFIG_AS_AVX
> -asmlinkage void sha512_transform_avx(u64 *digest, const char *data,
> -				     u64 rounds);
> +asmlinkage void sha512_transform_avx(struct sha512_state *state,
> +				     const u8 *data, int blocks);
>  static bool avx_usable(void)
>  {
>  	if (!cpu_has_xfeatures(XFEATURE_MASK_SSE | XFEATURE_MASK_YMM, NULL)) {
> @@ -225,8 +224,8 @@ static inline void unregister_sha512_avx(void) { }
>  #endif
>  
>  #if defined(CONFIG_AS_AVX2) && defined(CONFIG_AS_AVX)
> -asmlinkage void sha512_transform_rorx(u64 *digest, const char *data,
> -				      u64 rounds);
> +asmlinkage void sha512_transform_rorx(struct sha512_state *state,
> +				      const u8 *data, int blocks);
>  
>  static int sha512_avx2_update(struct shash_desc *desc, const u8 *data,
>  		       unsigned int len)
> -- 
> 2.20.1
> 
> 
> -- 
> Kees Cook

-- 
Kees Cook
