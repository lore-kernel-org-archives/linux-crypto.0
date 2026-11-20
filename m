Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.221.47
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795214783;
	b=dGFO0gJOgIj+W51wx02MJoNCn6kdj7EtwH02Lrs/uaHUEFe9k3IBSsWRXVCTiMgneC/f
	 qi0Ku5NpMDfBQ4t1HiDSWM6uySQCgfHIWfFBWd1svpGcOCyUxTHMVJagFKIAxADzW5gZ1
	 wZmbaKPeEm5rP8y6Z3W+LQQIK//Pub9wN9Tpj94gzPDzM1Ngt4xkRCoadJFTi6QhTVj/q
	 Gn2JlKvusy/OQhKdGv3FQpLtn/7vYO/huWD5MzpvuIdTBf/lFI27O2964FfQGoyS+S5qB
	 OCGrHgK/UaP0aEEU7KfAkZmULwm58lgAluzfjkVlPuhWAfLphwWGmuS3fbid7wISQfQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795214783;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=1eGqv/h9Aum9cuRfzP0GxawnzKTcJHSd17/iuLvj8io=;
	b=WxQsQQK+qEFrIAtglFTwzaoqNlW4glGDq/UOjQkyiagdIk2eXpvTuqQyyxBqJhgUEmGI
	 MeuOtb0qVA1eqrEwHMBg5wufrjEi66a5HDWXmrbah2lJBfcNLqVnjwcGS9EpUV/vpPFUD
	 BE/aWWRswebd99z8AumnKJI8L2CfgGbLZn/cT7HSqpWeh4ZDRMzuJK54SrXd1JAm+PMwW
	 xWrKgWBKMTeZxxsPoShlV6Zp0pTzGWrLrz4N4xvCwL8bCuGFdhOdAleDU1JWJpL1YCjce
	 nxH2IT3XPcrzgE2HNX6uMpj/e1pFxZzFgCo6XgRxfo5gbBor1Yj5kf0JTxFR5EKmEuA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=JXxtM6ef;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.221.47
Received: from mail-wr1-f47.google.com (mail-wr1-f47.google.com [209.85.221.47])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2EE8D606A686
	for <linux-crypto@vger.kernel.org>; Fri, 20 Nov 2026 22:46:21 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 2EE8D606A686
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=JXxtM6ef
Received: by mail-wr1-f47.google.com with SMTP id ffacd0b85a97d-49a92144733so754384f8f.0
        for <linux-crypto@vger.kernel.org>; Fri, 20 Nov 2026 14:46:20 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1795214779; cv=none;
        d=google.com; s=arc-20260327;
        b=FRNIUIHIbbCGTbk1/zoLQzdkDDpprlVH+HWSxHLKWR1zo71LDiZi8/tGaEtotAPcDm
         fGPReDIGjuTxAkEKpR6tDjlqPvWPFo5Siz4RGKNyIDOv7Of+OnbMHlsQH0h/MWbH4OyF
         2Iq9EwqFuAx5wBK9jeWjKGizd2IuUISLcOCfhexpne3NleiKLmh9C1yxjqyS4CQ9rKmc
         gtR1znrAx0UuC9jR7VeFsrfVq+9U+8Y6MuDc6c+5MRsNWnl0cPGrMEK0pfnN9jHYAwIA
         kwwzOw6s3OvUlUSMexTSrGAvJrjUEksqPvqsWUPnlVSpB8eDXdkh1eQbP9/lsWl57WfZ
         A0Pw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=1eGqv/h9Aum9cuRfzP0GxawnzKTcJHSd17/iuLvj8io=;
        fh=dE1/JwJ30OWuFg80nLx3NRY5PUWNYnvHwT7TDkk3l5Q=;
        b=RZAH+dYDNpDjoFKfWECh++/hO0ZxXRWBJltAk5n/f2/M8EH0MmxZ0klKIcisdOa+bZ
         flO3nbSterb7bHMuYEpYlVh0Mvymhkt1wTXUX9VmkTWr1UFgdk79rCdhUp8pR68Aym8J
         JQv+ss2ASMkntEvapgAtoVpBkm71bbE6884p2JrtR+NMYT5yPWwKLLaKpsvWekeBOgtm
         raeOYl5x4SOzVhvtgm1HLwvlTr16KV0tkjLl9sGkubY3bgRZVV2h6nQ3aBRwg8EQKhB/
         zlEQRpDJMYHR/v+VtuJV/LlsS71tQsX58C1mv546BhNfNoH8JBwiZUaasDLJFOlcqxZJ
         XfVg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795214779; x=1795819579; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=1eGqv/h9Aum9cuRfzP0GxawnzKTcJHSd17/iuLvj8io=;
        b=JXxtM6efpKMYh8NcFlNlL34CJqOtSLgN0aveDnBAqRyYx68pSiVD49Kqm7kSotGC3A
         bl6gLnNe00THoito6CQZkQMQt1u4ySRnZ1A8jaCgU2hdnoRnS35H49m7AEc7z1z1YxRc
         6jhTyPc752y+2RBneI36Y9oTtZlkyfa5o2jsXktBaQyITQV/2bE0jVbWT4Q/5RtCjpll
         V5GPzrHPA13DZzPlSau1N4f3O7v1j8+cTCxFXN23g4CVhp9+3O0657IzM9Sb1ll6FVgw
         ek/qsRXgbfq274lmJrVv+Fzk9q1rrEbEc0jhsrlEq/iSzFMwnqx5WP1t14puP8BXsukr
         gMWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795214779; x=1795819579;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=1eGqv/h9Aum9cuRfzP0GxawnzKTcJHSd17/iuLvj8io=;
        b=kC0QMUknosSclnF2M3CZwbgn4Y2HSDMH/2rccAg55NJUO29BzL/lOWDSH6fX+XjS4V
         Lq1orTHc+87PRIz1R9qjJTDXWJyatoFJtLAsUxvJd2CyGwihc7f4RqnUqhutNTUkTxli
         SG+TUnqjl+9gP3rt5azVX26Ty2wT7SzCAstxDeUhR59y0TMb3/BOQifcG8v0DNLXjPgu
         qOlHoUUY9rvFuPiPADb3WUamBJbotjyQc+Yx2h7uK870ce9S0ou93S1ypFq3BbrT4dtM
         ADQWTQ0qdy7ELOgJsTHNcCei2sp1kiY5J4IKUD7W9+nkvAk6DIQCM1jUZVkuFGL1n1aW
         xTpw==
X-Forwarded-Encrypted: i=1; AL+hErHvFjZ03pkK2IUqGDbpJ7idEexfOD4pir+d90sjxcAgZkTiEr3EclXF7sz99DawBZROL2W0xU1xgsOMaCA=@vger.kernel.org
X-Gm-Message-State: APuU4Z/b/9dW0hanW63nLhJCA2YzDkURH4mkLdFdV5CZ7455bu17WFLy
	ymyWYfi0IWRUOVSAIQt/VOnxOpA+airlvbw+OirJLIhAzsNq0zj1+sWuTr5TZoS0m/Gv02liAI7
	00MheifAgN69OBQDbuB/lWmLmHsMvZeE=
X-Gm-Gg: AZFdTZe8EnjSJ4CewN4H4Qx7gVq5MezCSjCrCWfm6+2JiEEk+Cr8eK4/+InNKzTAmHL
	R+eCDHedAx250I1kNe1UbDxmd6meLw5YIeanJV1CNsln5D1B0quAIiiK1JSnbQKYP3eslbl6F+Z
	a3hhd6eTZl6ySt9LvlUnACxhUJazCST6/cHc2LYJEW7SDR6909NCaYFPKLJpwdpZD0RSIEnDxrg
	LO/IrDDHztKtDz9IFlnpNl3SutJGHSDi/IYxxqWliKTXUv5vQ/4DJOqP/YF8bRIAdy6LlrqRDY8
	QgmrHuqWwm5Ft4dmk4dJJEoGY7SI7jMCrk8Jg8g/Qt80H2xxHzuJWoLJWuY9gAmglEs8R26SaZd
	h4b3bBoBNt4Vfm+CwXbE9VAqTIud4hBbZgCxY2bgZ1c/L8N4ozbOlBVr2dqbc4jfwqoJhJkebsm
	AR92TLIS9qlLDRqhJb3TfcEUpzCZfZ3VasXtDH7S3vuygemLpZ0tH18Ac=
X-Received: by 2002:a05:6000:4813:b0:490:2033:1477 with SMTP id
 ffacd0b85a97d-4abb917a9eemr8798576f8f.56.1795214779042; Fri, 20 Nov 2026
 14:46:19 -0800 (PST)
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261120041906.5785-1-kanchanapsridhar2026@gmail.com> <20261120041906.5785-6-kanchanapsridhar2026@gmail.com>
In-Reply-To: <20261120041906.5785-6-kanchanapsridhar2026@gmail.com>
From: Nhat Pham <nphamcs@gmail.com>
Date: Fri, 20 Nov 2026 14:46:06 -0800
X-Gm-Features: Aa3M54o22x-4wryDrkjAa-WgAkVk_I6WmUJ-pJSJHTNjra4aQw1mQAmQSzWMpFQ
Message-ID: <CAKEwX=P7To+AV9X3cXLCcuw5yoigdB8w5Ns9c9mDxJf+u5k8xA@mail.gmail.com>
Subject: Re: [PATCH v4 5/8] mm: zswap: Store the folio's node id in the zswap_entry.
To: "Kanchana P. Sridhar" <kanchanapsridhar2026@gmail.com>
Cc: hannes@cmpxchg.org, yosry@kernel.org, chengming.zhou@linux.dev, 
	akpm@linux-foundation.org, linux-mm@kvack.org, herbert@gondor.apana.org.au, 
	davem@davemloft.net, linux-crypto@vger.kernel.org, 
	linux-kernel@vger.kernel.org, rientjes@google.com, willy@infradead.org, 
	senozhatsky@chromium.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Nov 19, 2026 at 8:19=E2=80=AFPM Kanchana P. Sridhar
<kanchanapsridhar2026@gmail.com> wrote:
>
> When storing a folio in zswap, save the folio's node id in the zswap
> entry instead of relying on the zswap_entry being allocated on the same
> node. This enables optimizations such as batch allocation of zswap
> entries for large folios using kmem_cache_alloc_bulk() that does not
> support specifying a node id.
>
> Accordingly, replace the SLUB allocation in zswap_entry_cache_alloc() to
> be node-agnostic.
>
> The size of the zswap_entry remains unchanged as 'referenced' is lumped
> in with the 'length' (as it doesn't need a full unsigned int anyway).
> A build time assertion checks for the zswap_entry's 'length' bitfield
> being large enough to represent PAGE_SIZE, which can be 256KB on some
> architectures.
>
> Suggested-by: Nhat Pham <nphamcs@gmail.com>
> Suggested-by: Yosry Ahmed <yosry.ahmed@linux.dev>
> Signed-off-by: Kanchana P Sridhar <kanchana.p.sridhar@intel.com>
> Signed-off-by: Kanchana P. Sridhar <kanchanapsridhar2026@gmail.com>

LGTM for the most part:

Acked-by: Nhat Pham <nphamcs@gmail.com>

> ---
> + * nid - NUMA node id of the page for which this is the zswap entry.

Maybe "NUMA node id of the original page of this zswap entry"?

>   * handle - zsmalloc allocation handle that stores the compressed page d=
ata
>   * objcg - the obj_cgroup that the compressed memory is charged to
>   * lru - handle to the pool's lru used to evict pages.
>   */
>  struct zswap_entry {
>         swp_entry_t swpentry;
> -       unsigned int length;
> -       bool referenced;
> -       u8 pool_idx;
> +       struct {
> +               unsigned int length:ZSWAP_MAX_COMPR_LENGTH_SHIFT;

I could have sworn we agreed to just inline this macro.

(btw how many bits do we still have here? )
