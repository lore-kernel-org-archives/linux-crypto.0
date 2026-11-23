Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795395502;
	b=AYvxbdBqUz8MTbJRrHjJWB86kJt2ga+66c+xBqXaqepIHtGWIMbt5qst7JjkycJ6PN4L
	 seA6QWYg9p+BgT00psGxWzyZIvI3v7kNb5a+CEyWqLXK4h4Uikhlj+vWU76zbjrEF14te
	 ckahvs0DAaOSvdbYGns1R3mnfAJtCkHsMeNboMyxR9qYDmzv5m76wYk1+WuDVRJgGdCww
	 mKY31V1HYsufWoIe1w+jWSifv0QFG6X1x4gk2SxtF3VVVim7hhmNwBxNc8giDtptBLqpz
	 jhfs7+XKcYkQyFTQUHrR0nwhK1YTVG5H1yc442Gl2KLO2scEFv0TFLWBftA2/XG/kTA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795395502;
	h=Received:DKIM-Signature:Content-Type:MIME-Version:Message-Id:
	 In-Reply-To:References:Subject:From:To:Cc:Date;
	bh=hbouXR7A5A9JB/YPIb4FbPqutrjb1MEa6hNYonOAAzQ=;
	b=qPUUWlw6/UHPy4LQ5sIgd/0NrX0L0Nj4rNbOZWXHncStC+N56cn5hvX6o9BpFQZCtrso
	 VLvFlwYfk6ptYhv4KipyfpjkeO7MvRWKOInZaW1IGcebY1fDCudAIHAhGCjEjT3fufV/U
	 rwwLqoG5qN7a591FMPFcAvC/Ky8EAomE4p57HZNLm703tmray/jrv2qr/xywo4XCotjch
	 6ZcXL/WY34IUf9PKKEqYNigGexbRUN9Q+GlyEngXrQPwOyVicG8zA9Q3YLqckXC1N76t4
	 +mzhRGKSQkkRLvJF/1xhzf1S/RCrT7n/W2pGA8vl5I1PForzo5z/gHVaROl9pWCcofA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=NYpOkrDw;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A9E7606A335;
	Mon, 23 Nov 2026 00:58:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=NYpOkrDw
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C0271F000C6;
	Mon, 23 Nov 2026 00:58:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795395502;
	bh=hbouXR7A5A9JB/YPIb4FbPqutrjb1MEa6hNYonOAAzQ=;
	h=In-Reply-To:References:Subject:From:To:Cc:Date;
	b=NYpOkrDwMmFcrk9uE09Oqzkjyh1DRlxlzO8GXgR+s5aqfn3C9QfCHZwzP/gUsSLPO
	 P7aomuIMtDjrz13moeRxLVvL44B5ylMCovfrdykdUBG11TaYNrDt/MdKPHpxL4Q7t4
	 QyhjrQtMLREM0y/ajr48Oi4gTFNl//I2hK/Jg8huIISIkvlASaxebdUstat6QpAHl2
	 wlUqVvfcQhXW9cyDLnvGyLyD7kIedv6xv55t7cYQ0T0p/9h1P5xLONfSFREeVLfJe/
	 shIB1vT6zYXT/LGDCPOLRUy7x91Ma5wZauLEOzfx5tEEF7Hdw9NYKnOrmKeFDrdvy3
	 5EDnjkphtwe/A==
Content-Type: multipart/mixed; boundary="===============5078455097996705914=="
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Message-Id: <9adaadb2bd9667d049d68e9e4ed3dc4cf6204174b365029bd8422aeb759c2d11@mail.kernel.org>
In-Reply-To: <20261122-bpf-rhtab-irqs-disabled-v2-1-207aedcc2215@columbia.edu>
References: <20261122-bpf-rhtab-irqs-disabled-v2-1-207aedcc2215@columbia.edu>
Subject: Re: [PATCH bpf v2 1/4] rhashtable: Add trylock_irqsoff for callers that can't spin
From: bot+bpf-ci@kernel.org
To: mt4022@columbia.edu,ast@kernel.org,daniel@iogearbox.net,andrii@kernel.org,yatsenko@meta.com,herbert@gondor.apana.org.au,akpm@linux-foundation.org,shuah@kernel.org
Cc: tgraf@suug.ch,eddyz87@gmail.com,memxor@gmail.com,martin.lau@linux.dev,song@kernel.org,yonghong.song@linux.dev,jolsa@kernel.org,emil@etsalapatis.com,ihor.solodrai@linux.dev,bpf@vger.kernel.org,linux-crypto@vger.kernel.org,linux-kernel@vger.kernel.org,linux-kselftest@vger.kernel.org,tz2294@columbia.edu,mt4022@columbia.edu,ast@kernel.org,andrii@kernel.org,daniel@iogearbox.net,martin.lau@kernel.org,eddyz87@gmail.com,yonghong.song@linux.dev,mason@kernel.org,ihor.solodrai@linux.dev
Date: Mon, 23 Nov 2026 00:58:19 +0000 (UTC)

--===============5078455097996705914==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

> rhashtable: Add trylock_irqsoff for callers that can't spin

TL;DR: Nits only: documentation gaps. The new -EBUSY return isn't in the
remove kernel-doc, and the member doc omits UP always returning -EBUSY with
IRQs off.

> diff --git a/include/linux/rhashtable-types.h b/include/linux/rhashtable-types.h
> --- a/include/linux/rhashtable-types.h
> +++ b/include/linux/rhashtable-types.h
> @@ -52,6 +52,8 @@ typedef int (*rht_obj_cmpfn_t)(struct rhashtable_compare_arg *arg,
>   * @min_size: Minimum size while shrinking
>   * @insecure_elasticity: Set to true to disable chain length checks
>   * @automatic_shrinking: Enable automatic shrinking of tables
> + * @trylock_irqsoff: With irqs disabled insert and remove don't spin on
> + *		     the bucket lock and return -EBUSY

This isn't a bug, but should this member doc also say that on UP without
CONFIG_DEBUG_SPINLOCK these calls always return -EBUSY when IRQs are
disabled?  Only the commit message mentions it.

[ ... ]

> diff --git a/include/linux/rhashtable.h b/include/linux/rhashtable.h
> --- a/include/linux/rhashtable.h
> +++ b/include/linux/rhashtable.h

[ ... ]

> @@ -1066,7 +1094,8 @@ static __always_inline int __rhashtable_remove_fast_one(
>  	if (!bkt)
>  		return -ENOENT;
>  	pprev = NULL;
> -	flags = rht_lock(tbl, bkt);
> +	if (!rht_lock_or_busy(tbl, bkt, params, &flags))
> +		return -EBUSY;

This isn't a bug, but rhashtable_remove_fast() and rhltable_remove() can now
return -EBUSY through this path, and their kernel-doc still says:

 * Returns zero on success, -ENOENT if the entry could not be found.

Should the Returns lines mention -EBUSY when params.trylock_irqsoff is set?

[ ... ]

---
AI reviewed your patch. Please fix the bug or email reply why it's not a bug.
See: https://github.com/kernel-patches/vmtest/blob/master/ci/claude/README.md

CI run summary: https://github.com/kernel-patches/bpf/actions/runs/45090312341
--===============5078455097996705914==--
