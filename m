Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6BEC39B975;
	Mon, 31 Aug 2026 21:59:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788213581; cv=none; b=HhWpwFCasdJDOy2UXODDKNqqijedVMT5PvBa67RdZVrpesBqBxsABiNkVJ5ws6Fd4O3G4W+43fz1ZOCqhWZqj4LZQlCQkz7Zp9itAJle0em/m9ciJeyUOJ8DOC4kl525BH2+PUJN2VNcB4Y8TdTfqdHKNysM/YXLx/BCqb0oS2k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788213581; c=relaxed/simple;
	bh=Y59h2EGY4kybVXop6CEY+jxcl0LHE/nEkxfNAxizyNg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GddOXGnxzXc7rd4NIkaJ3pd8u0wVoYZehvQ6L9yJ4oOyH0pkWkuS9VhjxCR5RuyRiTkMi1/1TWvYaFe3gFQX9DeccxX6OmhVe8JZDxrjVJGsSyoNbR2mQcgq2T7/Qj0yVBYTwy24LkUwA9mRbZMZaEjT/jfs8qhKxRI04sN28hA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ALjLiBbE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ALjLiBbE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E17681F000E9;
	Mon, 31 Aug 2026 21:59:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788213579;
	bh=7oBBbPRZyknQtgGnwOUbCimrOFqDP35x+yOSikOrOos=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=ALjLiBbEvJbGG7wunWi+DvsOrjCwev7TiqV2RYCBP5XlXer9bTECK2+TiPWUBdgwI
	 Ctrzj44/t4ajEPspYi8f7K2KY7RrDF4j9L8i/3njFPbT+pDX56WS2Co9UzkwumUNAl
	 7RUmtg1/jxENK5/cKhyxfQd0YN5aW1/pWXCn7wE2DXUr5G3RwbqtqcEb6yt/WLv5N0
	 ZHQHyZ0lEH41Y6hGsa1/OyewnKaNdhcDILuPFrgIvuhnaLaUIecTreNE+qy02Tj1wD
	 bd93vDzc/qAaRsaj09w00y/0+gjCJXnuqg9ohO86qvJBRGaC2F2ewuE9RYvMfgJaNp
	 6qi7K+EyOiEkw==
Date: Mon, 31 Aug 2026 14:59:37 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: bot+bpf-ci@kernel.org
Cc: bpf@vger.kernel.org, vadim.fedorenko@linux.dev, ast@kernel.org,
	daniel@iogearbox.net, andrii@kernel.org, eddyz87@gmail.com,
	memxor@gmail.com, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org, martin.lau@linux.dev, song@kernel.org,
	yonghong.song@linux.dev, jolsa@kernel.org, emil@etsalapatis.com,
	ihor.solodrai@linux.dev, john.fastabend@gmail.com,
	kmehltretter@gmail.com, martin.lau@kernel.org, mason@kernel.org
Subject: Re: [PATCH bpf-next] bpf: crypto: Use AES-CBC and AES-ECB libraries
Message-ID: <20260831215937.GG86114@quark>
References: <20260831192139.94895-1-ebiggers@kernel.org>
 <f829962635d9d46dc01bea9d7777a8099af30f79068d978e8e8bb5cd85f014f1@mail.kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f829962635d9d46dc01bea9d7777a8099af30f79068d978e8e8bb5cd85f014f1@mail.kernel.org>

On Mon, Aug 31, 2026 at 08:29:02PM +0000, bot+bpf-ci@kernel.org wrote:
> The claim that lskcipher supports only these three specific algorithm
> names is not accurate. The cbc and ecb templates in crypto/cbc.c and
> crypto/ecb.c instantiate lskcipher interfaces for any plain cipher
> algorithm, not just AES:
> 
> crypto/cbc.c:crypto_cbc_create() calls lskcipher_alloc_instance_simple()
> crypto/ecb.c:crypto_ecb_create() calls lskcipher_alloc_instance_simple()
> 
> So cbc(<any-cipher>) and ecb(<any-cipher>) are valid lskcipher
> algorithms. The kernel includes about 14 plain cipher algorithms besides
> AES, including sm4, des, des3_ede, camellia, twofish, aria, blowfish,
> cast5, cast6, serpent, seed, khazad, anubis, tea, and xtea.
> 
> The pre-patch code passed params->algo directly to
> crypto_alloc_lskcipher() with no whitelist, so a BPF program could use
> cbc(sm4), cbc(des3_ede), ecb(camellia), or ecb(twofish).
> 
> After this patch, bpf_crypto_find_algo() only matches the two-entry
> table with cbc(aes) and ecb(aes), so all non-AES cbc/ecb modes now fail.
> 
> The changelog justifies dropping ARC4 but does not mention that this
> also drops support for all non-AES block ciphers. Should the commit
> message explicitly state that non-AES cbc()/ecb() support is being
> removed, or should the characterization of lskcipher's scope be
> corrected?

I'll update the commit message to clarify that other block ciphers are
dropped as well.

> Additionally, the error code for an unsupported algorithm changes from
> -EOPNOTSUPP (old has_algo failure path) to -ENOENT (new
> bpf_crypto_find_algo() path), which is a visible behavior change for
> existing BPF programs that inspect errno.

I'll change it to EOPNOTSUPP.

> > +config BPF_CRYPTO
> > +	def_bool y
> > +	depends on BPF_SYSCALL
> > +	select CRYPTO_LIB_AES_CBC
> > +	select CRYPTO_LIB_AES_ECB
> > +	help
> > +	  Provide the kfuncs needed for BPF programs to encrypt and decrypt
> > +	  data. The supported algorithms are AES-CBC and AES-ECB.
> > +
> 
> The def_bool y makes BPF_CRYPTO invisible and unconditionally enabled
> whenever CONFIG_BPF_SYSCALL=y, so the AES library code is always linked
> with no opt-out.
> 
> Before this patch, kernel/bpf/Makefile gated crypto.o on:
> 
>   ifneq ($(CONFIG_CRYPTO),)
>   obj-$(CONFIG_BPF_SYSCALL) += crypto.o
>   endif
> 
> so a CONFIG_BPF_SYSCALL=y, CONFIG_CRYPTO=n kernel previously built
> neither the BPF crypto kfuncs nor any AES code. Now the AES
> key-schedule, CBC, and ECB library code is unconditionally present.
> 
> This is particularly notable given that the commit message says AES-ECB
> "isn't appropriate in new systems and should be dropped" yet it is now
> unconditionally linked into every BPF_SYSCALL kernel.
> 
> Should this be a user-selectable option with a prompt like "bool 'BPF
> crypto kfuncs'" so it can be disabled, or is the intent really to make
> it always-on?

Almost every kernel has CRYPTO and CRYPTO_SKCIPHER2 enabled anyway, and
CRYPTO_SKCIPHER2 also enables ECB support.  So the change isn't actually
as drastic as the bot implies, but I'd be glad to give BPF_CRYPTO a
prompt if the BPF folks are okay with that.

> Deleting this file removes the last in-tree caller of
> crypto_alloc_lskcipher(). After this patch, the symbol only exists at
> its definition and export in crypto/lskcipher.c, with no remaining
> callers anywhere in the tree.
> 
> Given the premise that the lskcipher API "doesn't seem to be going
> anywhere," should crypto_alloc_lskcipher() be removed in a follow-up, or
> left as an exported API with zero users?

Yes, lskcipher should be deleted in a follow-up series.

> Does this code have a double-fetch issue? The function now uses the
> caller-supplied 'int *err' out-parameter as its own internal success
> flag: every failure path stores into *err, then the 'if (*err)' at the
> 'out:' label re-reads it to decide whether to free ctx and fail.
> 
> The 'err' parameter is classified by the verifier as KF_ARG_PTR_TO_MEM,
> so a BPF program can legally pass a pointer into a shared map value
> rather than its own stack. That makes the store followed by the reload a
> double fetch of concurrently-writable memory.
> 
> The pre-patch version never read *err - it used distinct error labels
> and returned NULL unconditionally on error, so the failure decision
> could not be influenced by the caller.
> 
> If the reload observes 0 because another CPU zeroed the map value
> between the store and the load, the function takes the success path for
> a create that actually failed. For instance, if aes_preparekey() returns
> -EINVAL from aes_check_keylen() before assigning enc_key->len and
> enc_key->nrounds, the kzalloc'ed key stays all-zero with nrounds == 0.
> 
> A later bpf_crypto_encrypt()/bpf_crypto_decrypt() on that ctx reaches
> aes_encrypt_generic()/aes_decrypt_generic(), which compute 'int n =
> nrounds - 1' (= -1) and then run 'do { ... } while (--n);', reading 16
> bytes past the round-key pointer per iteration for roughly 2^32
> iterations - an unbounded out-of-bounds read and unrecoverable soft
> lockup.
> 
> The reload can also mis-handle the -ENOENT path from
> bpf_crypto_find_algo(), returning a ctx whose algo is uninitialized
> (BPF_ALGO_AES_CBC == 0) with no key.
> 
> Could this be fixed by using a local 'int ret' for the internal flow and
> assigning '*err = ret' exactly once?

I'll change it to use a local variable.

> > @@ -86,23 +83,17 @@ struct bpf_crypto_ctx {
> >   * As crypto API functions use GFP_KERNEL allocations, this function can
> >   * only be used in sleepable BPF programs.
> 
> The kernel-doc for bpf_crypto_ctx_create() still justifies the
> KF_SLEEPABLE requirement with "As crypto API functions use GFP_KERNEL
> allocations."
> 
> This patch removes every crypto API call from the function
> (crypto_alloc_lskcipher()/crypto_lskcipher_setkey() are gone). The body
> now only does kzalloc_obj(), bpf_crypto_find_algo(), and
> aes_preparekey(), and the AES library is documented as usable in "Any
> context".
> 
> The conclusion still holds because kzalloc_obj() uses GFP_KERNEL, not
> because of the crypto API. Could the comment be updated to reflect the
> actual reason for the sleepable restriction after this refactoring?

I'll update the comment.

- Eric
