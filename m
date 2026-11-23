Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795396440;
	b=WlbruDO/uIp19qK1fqd3U9JsYMVZe9gFuMoNWxmoLkI1kLMoQ+n2QU1jphBHL4khm4Ft
	 wOuUi5KPpg7VDDjnZC2M8pSDAR79KNJm1hn3WheY2j+ljjhbeKo97MGVTY+wDl7tOU0Re
	 nchfTaaZBG23a2NtTTypFawWKwHB2XYQY9GxvwLBGb0kB0e/DsB3aDVxIdG6CQj9IdaQD
	 SfFNX9qr0yifmm3MiNO5fo977I+Z5+OWVUHTq4kjbsdcqdzAzpkllWcDy5eFsdm8Ha7Uu
	 6MCTbVxGPNbNxD5cxN077Xe51QRiAjDq1YSq095pGTNezyXepIcq8zUj04u9e0c7CQw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795396440;
	h=Received:DKIM-Signature:Content-Type:MIME-Version:Message-Id:
	 In-Reply-To:References:Subject:From:To:Cc:Date;
	bh=wOmSSxBUHRnLgd4e6+O9z5R2jz4T0d7JhRnt5K045pM=;
	b=gVKa+bBlMNAXdlUvIMOZcGjt39fWB7Gk0rRInA+HpAz0Tt46IScdVBpxkfWBCl+YeQD7
	 cMl5ED04OjpJaedwEkxJHfKGGM9k/2VuKoHQtSwv+dOggvjEova5CmWjthZqeL44MLZp/
	 a9md64NGy1VLLjkA+DvWLhzvHD0PbnBtOPnIDEtHtKPyhU1Yvve9NeK0i+KUMuihR0l9m
	 LFJzhSnRyBVjrZf3dTAYJXNHQdwnCqX2nsv/qC1/N9xACy0EFhxem+EhecUvAC05i0pFe
	 YNzdDFWcT5Wm3sEv44RGsFA4diZU+Ryl0R7HmlPid9vZAlMwbJtUkqoA13KvXrczPDA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=FN9NMEdt;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 481D6606A31A;
	Mon, 23 Nov 2026 01:14:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=FN9NMEdt
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16DD91F000C6;
	Mon, 23 Nov 2026 01:13:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795396439;
	bh=wOmSSxBUHRnLgd4e6+O9z5R2jz4T0d7JhRnt5K045pM=;
	h=In-Reply-To:References:Subject:From:To:Cc:Date;
	b=FN9NMEdtMJA9GH5kpjH71QHTkf8sRJGmZ+SAQ9Dtpe344cU2Los23ZDyOjM043uRu
	 gskmUdWAEA6Khpseovipvoo4GxT4JuAWfTSIYG496lGMPZZ1l8KmfCsvPAFTtHsLt0
	 tr7sVDxw1Y/VlxaomGz0GBAyxGDZZpsKvyTIwnptX48pfpAAdyyeTM/SFazRT/nO7v
	 IB7K+9r0KChFNtEVTbvdfnZ2ODKLmohSDTiUR7LJqP+W2bcqvn2jC6AsyuvUlzeNv4
	 rBsYW9yNJCm8mhHJeUI6TFYrXYoOWxwpOdaIPtPaFYl3WzhyKT335+LQ51Bs5oIeYv
	 fqgqpdNIHO5Jg==
Content-Type: multipart/mixed; boundary="===============7245609043603540761=="
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Message-Id: <ef9a71b38c0ce6eb0a5112debcb242e7b52694ab5284c7a589e5952c299b3b68@mail.kernel.org>
In-Reply-To: <20261122-bpf-rhtab-irqs-disabled-v2-3-207aedcc2215@columbia.edu>
References: <20261122-bpf-rhtab-irqs-disabled-v2-3-207aedcc2215@columbia.edu>
Subject: Re: [PATCH bpf v2 3/4] bpf: Don't spin on rhtab bucket locks with IRQs disabled
From: bot+bpf-ci@kernel.org
To: mt4022@columbia.edu,ast@kernel.org,daniel@iogearbox.net,andrii@kernel.org,yatsenko@meta.com,herbert@gondor.apana.org.au,akpm@linux-foundation.org,shuah@kernel.org
Cc: tgraf@suug.ch,eddyz87@gmail.com,memxor@gmail.com,martin.lau@linux.dev,song@kernel.org,yonghong.song@linux.dev,jolsa@kernel.org,emil@etsalapatis.com,ihor.solodrai@linux.dev,bpf@vger.kernel.org,linux-crypto@vger.kernel.org,linux-kernel@vger.kernel.org,linux-kselftest@vger.kernel.org,tz2294@columbia.edu,mt4022@columbia.edu,ast@kernel.org,andrii@kernel.org,daniel@iogearbox.net,martin.lau@kernel.org,eddyz87@gmail.com,yonghong.song@linux.dev,mason@kernel.org,ihor.solodrai@linux.dev
Date: Mon, 23 Nov 2026 01:13:57 +0000 (UTC)

--===============7245609043603540761==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

> bpf: Don't spin on rhtab bucket locks with IRQs disabled

TL;DR: On CONFIG_SMP=n kernels without DEBUG_SPINLOCK, setting trylock_irqsoff
on rhtab may make every new-key insert and delete fail with -EBUSY when IRQs
are disabled, even if the bucket is unlocked, contrary to the commit message.

> diff --git a/kernel/bpf/hashtab.c b/kernel/bpf/hashtab.c
> --- a/kernel/bpf/hashtab.c
> +++ b/kernel/bpf/hashtab.c
> @@ -2983,6 +2983,7 @@ struct bpf_rhtab {
>  static const struct rhashtable_params rhtab_params = {
>  	.head_offset = offsetof(struct rhtab_elem, node),
>  	.key_offset  = offsetof(struct rhtab_elem, data),
> +	.trylock_irqsoff = true,
>  };

On CONFIG_SMP=n kernels without CONFIG_DEBUG_SPINLOCK, can this make every
insert of a new key and every delete fail with -EBUSY whenever the caller
has IRQs disabled, even when no CPU holds the bucket lock?

rht_lock_or_busy() does this:

    if (!params.trylock_irqsoff || !irqs_disabled()) {
        *flags = rht_lock(tbl, bkt);
        return true;
    }
    /* bit_spin_trylock() always succeeds on UP without DEBUG_SPINLOCK */
    if (!IS_ENABLED(CONFIG_SMP) && !IS_ENABLED(CONFIG_DEBUG_SPINLOCK))
        return false;

The check happens before any test of the bucket, so
__rhashtable_insert_fast() returns ERR_PTR(-EBUSY) and
__rhashtable_remove_fast_one() returns -EBUSY every time.
rhtab_map_update_elem() then frees the new element and returns -EBUSY, and
rhtab_delete_elem() returns -EBUSY.  Updates of existing keys still work,
because rhtab_map_update_existing() takes no lock.

Programs running with IRQs disabled (int3-based kprobes, perf_event
programs, tracepoint, fentry and struct_ops programs in IRQs-off regions,
hardirq context) could insert and delete on UP before this patch, since
bit_spin_lock() only disables preemption there and never spins.  Most
programs ignore the helper's return value, so the failure may go
unnoticed.

The commit message says these operations "now fail with -EBUSY when the
bucket is locked, by this CPU or another one, and work as before
otherwise".  Is that accurate on such kernels?

Only the earlier rhashtable patch mentions the UP behaviour ("On UP
without DEBUG_SPINLOCK the lock bit isn't kept, so these callers always
get -EBUSY there").  Could this patch state that limitation too, or could
the lock bit be kept on UP for trylock_irqsoff tables so that rhtab fails
only when the bucket is actually held?


---
AI reviewed your patch. Please fix the bug or email reply why it's not a bug.
See: https://github.com/kernel-patches/vmtest/blob/master/ci/claude/README.md

CI run summary: https://github.com/kernel-patches/bpf/actions/runs/45090312341
--===============7245609043603540761==--
