Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06CEB39EF2A;
	Fri, 18 Sep 2026 03:27:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789702039; cv=none; b=YQVr6zhejVoOwGZN2/DIYNDesrxniPxzgc2fnvoVHOBWMeUXEkYc9t8cjEjVeL3BEA8H7K9YruuTfcFE4RCI6npRrM9pm5VIA8g9YAKM6Dr1tfMNIzxo8aMNp94eIxEM/bte9zielpaJmhP5XPbqgs06jOsTB9qX6sPqzsjscc0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789702039; c=relaxed/simple;
	bh=HLUcEEZ1gb/be4eEzPxL2FsNqrpr+TgkKm+tLunGXYY=;
	h=Content-Type:MIME-Version:Message-Id:In-Reply-To:References:
	 Subject:From:To:Cc:Date; b=l9+uH9pRkqUswvIyp3l8c9WtzTcEKQcyEdmtoRGjDjTXYTUpQnTbtziJT3/7lOR3oDtDfcJhGwbTkTuvqigvsU0q0pHbtfNRhtBYa1u6orlF2LLgmzMviaN+0xJYjf45rrDkpiJz6axoNIqBE5e7GIzKQ1Uic4J/Cz9mQEidb/U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fDjFdCNZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fDjFdCNZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 941201F00893;
	Fri, 18 Sep 2026 03:27:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789702037;
	bh=Dy2W1PJzpBfNsTzNUAOlpWjS58uasqukvqUM5+rueLE=;
	h=In-Reply-To:References:Subject:From:To:Cc:Date;
	b=fDjFdCNZmeY7S2Wb2FKHzbgj00cEAw/NAHv4mW5PxD+D/AmpzOvUB57EnaufNhEMS
	 ckT4oAjdRbgSh3ocMAUmc4xYdQtNjn1MlwdH63u9F1A8TuBijWwVs/ElyMAQ/RQzL5
	 0qeVHHQFwukg6oFkwqJPlyJslGuMibKT3DgLNbKs27NXjxi06hqpDBbs8Nv/5y3AM8
	 /91ER8Dqz5oMeQNGlqgmyF23dkxNLZnW5tGeuL1lF6IaQgZRg7Z55a3A4l2wqXdq3E
	 U1Smn1ipWEM52OZZgknferl4+ruj1iznBDZwF0T14wJ7R9XI3OFEU4gDO96/6/tL6f
	 lGe+8OLg4+8IQ==
Content-Type: multipart/mixed; boundary="===============8624371357129898679=="
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Message-Id: <18a774a95c187e8bcc9080bf5ab32109c265e6fe28777d00f2cf624e9c23530f@mail.kernel.org>
In-Reply-To: <20260918021744.18772-1-ebiggers@kernel.org>
References: <20260918021744.18772-1-ebiggers@kernel.org>
Subject: Re: [PATCH bpf-next v2] bpf: crypto: Use AES-CBC and AES-ECB libraries
From: bot+bpf-ci@kernel.org
To: ebiggers@kernel.org,bpf@vger.kernel.org,vadim.fedorenko@linux.dev,ast@kernel.org,daniel@iogearbox.net,andrii@kernel.org,eddyz87@gmail.com,memxor@gmail.com
Cc: linux-crypto@vger.kernel.org,linux-kernel@vger.kernel.org,martin.lau@linux.dev,song@kernel.org,yonghong.song@linux.dev,jolsa@kernel.org,emil@etsalapatis.com,ihor.solodrai@linux.dev,john.fastabend@gmail.com,kmehltretter@gmail.com,ebiggers@kernel.org,ast@kernel.org,andrii@kernel.org,daniel@iogearbox.net,martin.lau@kernel.org,eddyz87@gmail.com,yonghong.song@linux.dev,mason@kernel.org,ihor.solodrai@linux.dev
Date: Fri, 18 Sep 2026 03:27:16 +0000 (UTC)

--===============8624371357129898679==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

> diff --git a/kernel/bpf/Kconfig b/kernel/bpf/Kconfig
> index d7d25477ef481..a44ecfa3e9ef5 100644
> --- a/kernel/bpf/Kconfig
> +++ b/kernel/bpf/Kconfig
> @@ -91,6 +91,15 @@ config BPF_UNPRIV_DEFAULT_OFF
>
>  	  If you are unsure how to answer this question, answer Y.
>
> +config BPF_CRYPTO
> +	def_bool y
> +	depends on BPF_SYSCALL
> +	depends on CRYPTO_LIB_AES_CBC
> +	depends on CRYPTO_LIB_AES_ECB
> +	help
> +	  Provide the kfuncs needed for BPF programs to encrypt and decrypt
> +	  data. The supported algorithms are AES-CBC and AES-ECB.
> +
>  source "kernel/bpf/preload/Kconfig"
>
>  config BPF_LSM

[ ... ]

> diff --git a/kernel/bpf/Makefile b/kernel/bpf/Makefile
> index 9a92c348bbda6..c1f9b0d3468d3 100644
> --- a/kernel/bpf/Makefile
> +++ b/kernel/bpf/Makefile
> @@ -58,9 +58,7 @@ obj-$(CONFIG_BPF_SYSCALL) += cpumask.o
>  # semantics within pahole are revisited accordingly.
>  obj-${CONFIG_BPF_LSM} += bpf_lsm_proto.o bpf_lsm.o
>  endif
> -ifneq ($(CONFIG_CRYPTO),)
> -obj-$(CONFIG_BPF_SYSCALL) += crypto.o
> -endif
> +obj-$(CONFIG_BPF_CRYPTO) += crypto.o
>  obj-$(CONFIG_BPF_PRELOAD) += preload/
>
>  obj-$(CONFIG_BPF_SYSCALL) += relo_core.o

Does this change create a mismatch with kernel/bpf/verifier.c?

The build condition for kernel/bpf/crypto.o changes from CONFIG_CRYPTO to
CONFIG_BPF_CRYPTO, but kernel/bpf/verifier.c still gates the matching BTF
id on CONFIG_CRYPTO:

    BTF_SET_START(rcu_protected_types)
    ...
    #ifdef CONFIG_CRYPTO
    BTF_ID(struct, bpf_crypto_ctx)
    #endif
    ...
    BTF_SET_END(rcu_protected_types)

The two conditions can now diverge:

1. CONFIG_CRYPTO=y/m but BPF_CRYPTO=n: struct bpf_crypto_ctx is defined
only in kernel/bpf/crypto.c, which is no longer compiled, so
resolve_btfids emits 'WARN: resolve_btfids: unresolved symbol
bpf_crypto_ctx' and leaves a bogus id 0 in rcu_protected_types.

2. BPF_CRYPTO=y but CONFIG_CRYPTO=n: crypto.o and its kfuncs are built,
but the BTF_ID is compiled out, so bpf_crypto_ctx is not in
rcu_protected_types. rcu_protected_object() then returns false, and
btf_ld_kptr_type() tags a bpf_crypto_ctx kptr loaded from a map as
PTR_UNTRUSTED instead of MEM_RCU. bpf_crypto_ctx_acquire() and
bpf_crypto_encrypt/decrypt then reject that pointer, so the documented
create -> kptr_xchg into map -> acquire pattern stops verifying.

Should verifier.c's #ifdef be updated to CONFIG_BPF_CRYPTO?


> diff --git a/kernel/bpf/crypto.c b/kernel/bpf/crypto.c
> index 51f89cecefb4d..59eaa285aacc5 100644
> --- a/kernel/bpf/crypto.c
> +++ b/kernel/bpf/crypto.c

[ ... ]

> @@ -36,94 +30,53 @@ struct bpf_crypto_params {
>  	u32 authsize;
>  };
>
> -static LIST_HEAD(bpf_crypto_types);
> -static DECLARE_RWSEM(bpf_crypto_types_sem);
> +enum bpf_crypto_algo_id {
> +	BPF_ALGO_AES_CBC,
> +	BPF_ALGO_AES_ECB,
> +};

[ ... ]

>  /**
>   * struct bpf_crypto_ctx - refcounted BPF crypto context structure
> - * @type:	The pointer to bpf crypto type
> - * @tfm:	The pointer to instance of crypto API struct.
> - * @siv_len:    Size of IV and state storage for cipher
> + * @algo:	The crypto algorithm ID
> + * @key:	The crypto key
>   * @rcu:	The RCU head used to free the crypto context with RCU safety.
>   * @usage:	Object reference counter. When the refcount goes to 0, the
>   *		memory is released back to the BPF allocator, which provides
>   *		RCU safety.
>   */
>  struct bpf_crypto_ctx {
> -	const struct bpf_crypto_type *type;
> -	void *tfm;
> -	u32 siv_len;
> +	enum bpf_crypto_algo_id algo;
> +	union {
> +		struct aes_key aes;
> +	} key;
>  	struct rcu_head rcu;
>  	refcount_t usage;
>  };

Does moving the AES key into struct bpf_crypto_ctx make it readable by BPF
programs?

Previously the key lived inside the crypto_lskcipher tfm, reachable only
through void *tfm. A BPF program holding the ctx could read that field's
numeric value but had no way to dereference it (void * yields a scalar,
and bpf_probe_read_kernel() is gated behind perfmon_capable() and is not
available to tc/xdp/sk_skb program types).

Now the expanded key is a field of the struct: key.aes is a struct
aes_key, whose struct aes_enckey prefix contains union aes_enckey_arch k
(u32 rndkeys[AES_MAX_KEYLENGTH_U32], include/crypto/aes.h:97-116). The AES
key schedule is trivially invertible, so reading those words recovers the
original key.

The read is permitted by the verifier. bpf_crypto_ctx_create() is
KF_ACQUIRE, so R0 is PTR_TO_BTF_ID for struct bpf_crypto_ctx, and struct
bpf_crypto_ctx is in vmlinux BTF (it is named in BTF_ID(struct,
bpf_crypto_ctx) for the dtor list). In check_ptr_to_btf_access() the
program-type hook that could restrict access is applied to writes only:

kernel/bpf/verifier.c:6124
    if (env->ops->btf_struct_access && !type_is_alloc(reg->type) &&
        atype == BPF_WRITE) {
        ...
        ret = env->ops->btf_struct_access(...);
    } else {
        ...
        ret = btf_struct_access(...);
    }

So a BPF_READ of ctx->key.aes.k.rndkeys[i] goes through the default
btf_struct_access() (kernel/bpf/btf.c:7410), which resolves
scalar/array members and permits the load. No field of bpf_crypto_ctx is
marked opaque.

Concrete path: bpf_crypto_ctx_create()'s kernel-doc states the ctx "must
either be embedded in a map as a kptr, or freed with
bpf_crypto_ctx_release()". Program A (holding the secret key) creates the
ctx and stores it as a kptr in a pinned map; program B (e.g. SEC("tc"),
needing only CAP_BPF+CAP_NET_ADMIN, as in
tools/testing/selftests/bpf/progs/crypto_sanity.c:80) obtains it with
bpf_crypto_ctx_acquire() and reads the round keys out into a ringbuf.

Before this patch B could only use the ctx to encrypt/decrypt; it could
not extract the key. The commit message does not mention key storage or
BTF visibility. If the exposure is intentional it deserves a sentence in
the changelog; otherwise the key needs to live behind an indirection (e.g.
a separately-allocated struct pointed to by a void *) as it effectively
did before.


---
AI reviewed your patch. Please fix the bug or email reply why it's not a bug.
See: https://github.com/kernel-patches/vmtest/blob/master/ci/claude/README.md

CI run summary: https://github.com/kernel-patches/bpf/actions/runs/35300286004
--===============8624371357129898679==--
