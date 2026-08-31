Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C770F1F3BA2;
	Mon, 31 Aug 2026 20:29:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788208145; cv=none; b=hJLLLHCKsUer7kvYTV03yc278kFX4pfJee5/J/EqZ5jagTa1Z61xRQVmciIxBuwAbGCjQ1rJoYL5bvRFfgCjYnMfc8kbVWCYwzs1LWUTy0nmG0l2nB0xr5CHW3ADH3UahMklb/7wI+GsS7VqqwZp80DR0ATGCbCIPGE7zLTIDCw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788208145; c=relaxed/simple;
	bh=a+GIM92rmgJeACBp1RoLsF/SPCU68ZuoZrXn/Nz71x8=;
	h=Content-Type:MIME-Version:Message-Id:In-Reply-To:References:
	 Subject:From:To:Cc:Date; b=VAAvzS7lD89qh+e+ExMLBGCHjXrfxsiZNVabhci0RgMD5ZStTMvjp9eJDxNa6eHruTzp8zjrgE+s3+6ZGRok9wXETFNNsyzaQ9Xq22VhFotER2AIyOp+UI3k3TsW9rHuZWCl6LubHuJ1Z5oBXRbpjUwyDzvkO+rh0Syk2orDlgo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hxPE8hRo; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hxPE8hRo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A23FD1F000E9;
	Mon, 31 Aug 2026 20:29:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788208143;
	bh=wW/xUMPshJh+BjnoH/KxQ2ctdTr8ercnNXnopyZGx30=;
	h=In-Reply-To:References:Subject:From:To:Cc:Date;
	b=hxPE8hRoJ2HsM/zvd6zs/2yhix+aWMoxDNTSsSp25NZkGy9/HMxeC26BsZNQrui1r
	 k+78JSwPuFeUVHQzDbu3pAZX1GAkQQta+Wdrh1lVVCNa7OOmDdCe15vw8EbCw9vTxW
	 +tuN362zr1n8ebVGC+0NL9/HxfUQt/gMikudy/TddVxSRq0Fh+86Tzu1IZrTL4kDyE
	 QPtG3NTkMCs1TT+aGjEWOyVjihHPGFcsedBwesLEP1vIuuIrafaOl5xTizJD1zHYAf
	 0AQLgrZwZn47JRAQcTQaVdPHcNLz/osnS3lGGU7eE0cBhYlahWw3qjqNz7YzMKtihg
	 2aXZ4lD3NyuVg==
Content-Type: multipart/mixed; boundary="===============1722735103380655568=="
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Message-Id: <f829962635d9d46dc01bea9d7777a8099af30f79068d978e8e8bb5cd85f014f1@mail.kernel.org>
In-Reply-To: <20260831192139.94895-1-ebiggers@kernel.org>
References: <20260831192139.94895-1-ebiggers@kernel.org>
Subject: Re: [PATCH bpf-next] bpf: crypto: Use AES-CBC and AES-ECB libraries
From: bot+bpf-ci@kernel.org
To: ebiggers@kernel.org,bpf@vger.kernel.org,vadim.fedorenko@linux.dev,ast@kernel.org,daniel@iogearbox.net,andrii@kernel.org,eddyz87@gmail.com,memxor@gmail.com
Cc: linux-crypto@vger.kernel.org,linux-kernel@vger.kernel.org,martin.lau@linux.dev,song@kernel.org,yonghong.song@linux.dev,jolsa@kernel.org,emil@etsalapatis.com,ihor.solodrai@linux.dev,john.fastabend@gmail.com,kmehltretter@gmail.com,ebiggers@kernel.org,ast@kernel.org,andrii@kernel.org,daniel@iogearbox.net,martin.lau@kernel.org,eddyz87@gmail.com,yonghong.song@linux.dev,mason@kernel.org,ihor.solodrai@linux.dev
Date: Mon, 31 Aug 2026 20:29:02 +0000 (UTC)

--===============1722735103380655568==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

> BPF crypto was implemented using the lskcipher API, which doesn't seem
> to be going anywhere.  lskcipher supports only "arc4", "cbc(aes)",
> "ecb(aes)", and only with unoptimized implementations.

The claim that lskcipher supports only these three specific algorithm
names is not accurate. The cbc and ecb templates in crypto/cbc.c and
crypto/ecb.c instantiate lskcipher interfaces for any plain cipher
algorithm, not just AES:

crypto/cbc.c:crypto_cbc_create() calls lskcipher_alloc_instance_simple()
crypto/ecb.c:crypto_ecb_create() calls lskcipher_alloc_instance_simple()

So cbc(<any-cipher>) and ecb(<any-cipher>) are valid lskcipher
algorithms. The kernel includes about 14 plain cipher algorithms besides
AES, including sm4, des, des3_ede, camellia, twofish, aria, blowfish,
cast5, cast6, serpent, seed, khazad, anubis, tea, and xtea.

The pre-patch code passed params->algo directly to
crypto_alloc_lskcipher() with no whitelist, so a BPF program could use
cbc(sm4), cbc(des3_ede), ecb(camellia), or ecb(twofish).

After this patch, bpf_crypto_find_algo() only matches the two-entry
table with cbc(aes) and ecb(aes), so all non-AES cbc/ecb modes now fail.

The changelog justifies dropping ARC4 but does not mention that this
also drops support for all non-AES block ciphers. Should the commit
message explicitly state that non-AES cbc()/ecb() support is being
removed, or should the characterization of lskcipher's scope be
corrected?

Additionally, the error code for an unsupported algorithm changes from
-EOPNOTSUPP (old has_algo failure path) to -ENOENT (new
bpf_crypto_find_algo() path), which is a visible behavior change for
existing BPF programs that inspect errno.

[ ... ]

> diff --git a/kernel/bpf/Kconfig b/kernel/bpf/Kconfig
> index eb3de35734f09..822599b42be2e 100644
> --- a/kernel/bpf/Kconfig
> +++ b/kernel/bpf/Kconfig
> @@ -87,6 +87,15 @@ config BPF_UNPRIV_DEFAULT_OFF
>
>  	  If you are unsure how to answer this question, answer Y.
>
> +config BPF_CRYPTO
> +	def_bool y
> +	depends on BPF_SYSCALL
> +	select CRYPTO_LIB_AES_CBC
> +	select CRYPTO_LIB_AES_ECB
> +	help
> +	  Provide the kfuncs needed for BPF programs to encrypt and decrypt
> +	  data. The supported algorithms are AES-CBC and AES-ECB.
> +

The def_bool y makes BPF_CRYPTO invisible and unconditionally enabled
whenever CONFIG_BPF_SYSCALL=y, so the AES library code is always linked
with no opt-out.

Before this patch, kernel/bpf/Makefile gated crypto.o on:

  ifneq ($(CONFIG_CRYPTO),)
  obj-$(CONFIG_BPF_SYSCALL) += crypto.o
  endif

so a CONFIG_BPF_SYSCALL=y, CONFIG_CRYPTO=n kernel previously built
neither the BPF crypto kfuncs nor any AES code. Now the AES
key-schedule, CBC, and ECB library code is unconditionally present.

This is particularly notable given that the commit message says AES-ECB
"isn't appropriate in new systems and should be dropped" yet it is now
unconditionally linked into every BPF_SYSCALL kernel.

Should this be a user-selectable option with a prompt like "bool 'BPF
crypto kfuncs'" so it can be disabled, or is the intent really to make
it always-on?

[ ... ]

> diff --git a/crypto/bpf_crypto_skcipher.c b/crypto/bpf_crypto_skcipher.c
> deleted file mode 100644
> index a88798d3e8c87..0000000000000
> --- a/crypto/bpf_crypto_skcipher.c
> +++ /dev/null
> @@ -1,83 +0,0 @@
[ ... ]
> -static void *bpf_crypto_lskcipher_alloc_tfm(const char *algo)
> -{
> -	return crypto_alloc_lskcipher(algo, 0, 0);
> -}

Deleting this file removes the last in-tree caller of
crypto_alloc_lskcipher(). After this patch, the symbol only exists at
its definition and export in crypto/lskcipher.c, with no remaining
callers anywhere in the tree.

Given the premise that the lskcipher API "doesn't seem to be going
anywhere," should crypto_alloc_lskcipher() be removed in a follow-up, or
left as an exported API with zero users?

[ ... ]

> diff --git a/kernel/bpf/crypto.c b/kernel/bpf/crypto.c
> index 51f89cecefb4d..8cdc16f9b374a 100644
> --- a/kernel/bpf/crypto.c
> +++ b/kernel/bpf/crypto.c
[ ... ]
> @@ -146,7 +99,6 @@ __bpf_kfunc struct bpf_crypto_ctx *
>  bpf_crypto_ctx_create(const struct bpf_crypto_params *params, u32 params__sz,
>  		      int *err)
>  {
> -	const struct bpf_crypto_type *type;
>  	struct bpf_crypto_ctx *ctx;
>
>  	if (!params || params->reserved[0] || params->reserved[1] ||
> @@ -155,69 +107,40 @@ bpf_crypto_ctx_create(const struct bpf_crypto_params *params, u32 params__sz,
>  		return NULL;
>  	}
>
[ ... ]
> +	ctx = kzalloc_obj(*ctx);
> +	if (!ctx) {
> +		*err = -ENOMEM;
> +		return NULL;
> +	}
> +
> +	if (!bpf_crypto_find_algo(params, &ctx->algo)) {
> +		*err = -ENOENT;
> +		goto out;
> +	}
> +
> +	switch (ctx->algo) {
> +	case BPF_ALGO_AES_CBC:
> +	case BPF_ALGO_AES_ECB:
> +		if (params->authsize)
> +			*err = -EOPNOTSUPP;
> +		else
> +			*err = aes_preparekey(&ctx->key.aes, params->key,
> +					      params->key_len);
> +		break;
> +	default:
> +		WARN_ON(1);
> +		*err = -ENOENT;
> +		break;
> +	}
> +
> +out:
> +	if (*err) {
> +		kfree_sensitive(ctx);
> +		return NULL;
> +	}
> +
>  	refcount_set(&ctx->usage, 1);
> -
>  	return ctx;
>  }

Does this code have a double-fetch issue? The function now uses the
caller-supplied 'int *err' out-parameter as its own internal success
flag: every failure path stores into *err, then the 'if (*err)' at the
'out:' label re-reads it to decide whether to free ctx and fail.

The 'err' parameter is classified by the verifier as KF_ARG_PTR_TO_MEM,
so a BPF program can legally pass a pointer into a shared map value
rather than its own stack. That makes the store followed by the reload a
double fetch of concurrently-writable memory.

The pre-patch version never read *err - it used distinct error labels
and returned NULL unconditionally on error, so the failure decision
could not be influenced by the caller.

If the reload observes 0 because another CPU zeroed the map value
between the store and the load, the function takes the success path for
a create that actually failed. For instance, if aes_preparekey() returns
-EINVAL from aes_check_keylen() before assigning enc_key->len and
enc_key->nrounds, the kzalloc'ed key stays all-zero with nrounds == 0.

A later bpf_crypto_encrypt()/bpf_crypto_decrypt() on that ctx reaches
aes_encrypt_generic()/aes_decrypt_generic(), which compute 'int n =
nrounds - 1' (= -1) and then run 'do { ... } while (--n);', reading 16
bytes past the round-key pointer per iteration for roughly 2^32
iterations - an unbounded out-of-bounds read and unrecoverable soft
lockup.

The reload can also mis-handle the -ENOENT path from
bpf_crypto_find_algo(), returning a ctx whose algo is uninitialized
(BPF_ALGO_AES_CBC == 0) with no key.

Could this be fixed by using a local 'int ret' for the internal flow and
assigning '*err = ret' exactly once?

[ ... ]

> @@ -86,23 +83,17 @@ struct bpf_crypto_ctx {
>   * As crypto API functions use GFP_KERNEL allocations, this function can
>   * only be used in sleepable BPF programs.

The kernel-doc for bpf_crypto_ctx_create() still justifies the
KF_SLEEPABLE requirement with "As crypto API functions use GFP_KERNEL
allocations."

This patch removes every crypto API call from the function
(crypto_alloc_lskcipher()/crypto_lskcipher_setkey() are gone). The body
now only does kzalloc_obj(), bpf_crypto_find_algo(), and
aes_preparekey(), and the AES library is documented as usable in "Any
context".

The conclusion still holds because kzalloc_obj() uses GFP_KERNEL, not
because of the crypto API. Could the comment be updated to reflect the
actual reason for the sleepable restriction after this refactoring?


---
AI reviewed your patch. Please fix the bug or email reply why it's not a bug.
See: https://github.com/kernel-patches/vmtest/blob/master/ci/claude/README.md

CI run summary: https://github.com/kernel-patches/bpf/actions/runs/33431341694
--===============1722735103380655568==--
