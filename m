Received: from mail-qv1-f48.google.com (mail-qv1-f48.google.com [209.85.219.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF1692AE90;
	Mon,  2 Dec 2024 19:15:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733166946; cv=none; b=r1tNL88F5GSzNxuyMdVtIZbyks1vspzwehbJ5gJdFFhcpTDUpJMJhrRGj1RWnsz5P40XCxO4iE0GJi0ZS/bNy1WMPAnmUjO/yCkxMzU/icX/vFqOtdtMoUsrZXOk1+1UEhdp7yF/wAN/z+E67BNAjti28lvZckVrilNrJ7UccPc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733166946; c=relaxed/simple;
	bh=GfvbK2H5Ei/tZvSuw88s+DwAkP+/ww4Mo/JKZ7Qqi+A=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=JnfyPNnOiSq+s8t7OuLpMdBc+OoT4yCFa1tVuq+riz8yz9WkDxEMOPSLK9XuJI6ZvJXfVaPYfUtx7P2aDaS2ijVcg7NVLGakU2GX6cL3ugqRReSwKugFwgGJTOmavN0cHDvImtHhuGKdJHjnv0xx3fHTJVHAGF0SzG29wbh1d7k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=dIrhwWSU; arc=none smtp.client-ip=209.85.219.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="dIrhwWSU"
Received: by mail-qv1-f48.google.com with SMTP id 6a1803df08f44-6d87f00f786so42039946d6.1;
        Mon, 02 Dec 2024 11:15:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1733166944; x=1733771744; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8OMOD2rDakyh80oc7mNHohE/CVBfukWJ+S3JCKqTN3Y=;
        b=dIrhwWSUfY21NUBMuR9qU6Ffv3cyXsclY7rPyw247FH12kzUXW0JJftrx2jH0h2mod
         Eezgocc+Sxyb4ZtiKQ+RnGDzFhlw4Ke32lssa8XH01YIpZ/pxpu8C3mmSISbCUzdG8v8
         T0xiu2cnj7iLOTP0N1WRw1XCG5AijtQHgy7eGGl8SjmtvmwCBc52Lax+rhfNFx+tXfuy
         z9K3eUWyFCuZFTZda+INkv9HSZyLSqCKNHP4pwT3NHqcYJPCf7GWgytQs+T6SxYKx9b5
         TiEwVo5pBSPIp7iKpz749mEZXV4uUNT2AttPS/vFxvwxFaUTg5s+P7Pv8J/Kqreoayoh
         Ntrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733166944; x=1733771744;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=8OMOD2rDakyh80oc7mNHohE/CVBfukWJ+S3JCKqTN3Y=;
        b=wu5Wydt269I4KilgVb0lZmwuRBBpcLkRpEIItMwikcna7nlUexHKeT7P61A2ZVOIla
         fDgp3ZPK7gqTgcSn2qSt546POT30zIxArn22c28FRVuTNbZ6c2kCQ/SooYWYvecn7hBq
         kNQHc7fmLHR1FWgGD8VQKvWnl4JGIayietdXdr6rt7gXKJdRbMU9yDp3bz97aBYxLXS6
         5Z55DZ7mNiLXXTOeaSaPbzz9BKsWub9oKH7TWyPkqO1kTTAo+7lSUjlUpXhTd+hGt1Hj
         fLLBXJO/mu2qqRzCWmPDW6q+jTMngAZrZ3GELyoH8v7DP1nFQDQOJFqJUGJCF/iQvTmM
         J+NQ==
X-Forwarded-Encrypted: i=1; AJvYcCUU7kgkqSm1aRWxBVw06DmZQvPYN8Y3Np/hk8/eCpyqpQ5tE0s+xor58DrOY9KtA4uojt3/eDeyC/eRejg=@vger.kernel.org
X-Gm-Message-State: AOJu0Yzdm0dlfQIRkQ5OSaS9mZAyFj8jEu0fQjqNb6N0/8D052goEROe
	P5mqj7QTnyASUsuZ8ZJ84/M18E7ea0rrtnt7CPMJQFH7ObicoYF9IDb6p5066EdL8lnVwyzZohx
	9eslG/3YAwpV3YO28K6x2Nk9askLpaQpb
X-Gm-Gg: ASbGncuUMT6MWA2PFQCVmUKMnfH56Ro494WhfDxs5MeTSOo2ZpprG99GXWWlOMYsbw5
	IPCTEqLxZZu51xKC1ypH39zwL2pbqmWg63zlPem2/8kuVZ3U=
X-Google-Smtp-Source: AGHT+IFtCNuf3VmVRwyPv6TRhZiJS92nc7GwpzeaIJ2TJEySVzQWw8rpn1quJVR+oU4wqwEGjyTvvHZ+Sss8mbPfUDg=
X-Received: by 2002:a05:6214:2aac:b0:6d8:a967:8387 with SMTP id
 6a1803df08f44-6d8a967859amr52741866d6.1.1733166943785; Mon, 02 Dec 2024
 11:15:43 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20241123070127.332773-1-kanchana.p.sridhar@intel.com> <20241123070127.332773-10-kanchana.p.sridhar@intel.com>
In-Reply-To: <20241123070127.332773-10-kanchana.p.sridhar@intel.com>
From: Nhat Pham <nphamcs@gmail.com>
Date: Mon, 2 Dec 2024 11:15:33 -0800
Message-ID: <CAKEwX=PmKWH4Z4Py9Jti9fcD6qCYJBBRrDF48qdmo8-i+LzzfA@mail.gmail.com>
Subject: Re: [PATCH v4 09/10] mm: zswap: Allocate pool batching resources if
 the crypto_alg supports batching.
To: Kanchana P Sridhar <kanchana.p.sridhar@intel.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, hannes@cmpxchg.org, 
	yosryahmed@google.com, chengming.zhou@linux.dev, usamaarif642@gmail.com, 
	ryan.roberts@arm.com, ying.huang@intel.com, 21cnbao@gmail.com, 
	akpm@linux-foundation.org, linux-crypto@vger.kernel.org, 
	herbert@gondor.apana.org.au, davem@davemloft.net, clabbe@baylibre.com, 
	ardb@kernel.org, ebiggers@google.com, surenb@google.com, 
	kristen.c.accardi@intel.com, wajdi.k.feghali@intel.com, 
	vinodh.gopal@intel.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Nov 22, 2024 at 11:01=E2=80=AFPM Kanchana P Sridhar
<kanchana.p.sridhar@intel.com> wrote:
>
> This patch does the following:
>
> 1) Modifies the definition of "struct crypto_acomp_ctx" to represent a
>    configurable number of acomp_reqs and buffers. Adds a "nr_reqs" to
>    "struct crypto_acomp_ctx" to contain the nr of resources that will be
>    allocated in the cpu onlining code.
>
> 2) The zswap_cpu_comp_prepare() cpu onlining code will detect if the
>    crypto_acomp created for the pool (in other words, the zswap compressi=
on
>    algorithm) has registered an implementation for batch_compress() and
>    batch_decompress(). If so, it will set "nr_reqs" to
>    SWAP_CRYPTO_BATCH_SIZE and allocate these many reqs/buffers, and set
>    the acomp_ctx->nr_reqs accordingly. If the crypto_acomp does not suppo=
rt
>    batching, "nr_reqs" defaults to 1.
>
> 3) Adds a "bool can_batch" to "struct zswap_pool" that step (2) will set =
to
>    true if the batching API are present for the crypto_acomp.

Why do we need this "can_batch" field? IIUC, this can be determined
from the compressor internal fields itself, no?

acomp_has_async_batching(acomp);

Is this just for convenience, or is this actually an expensive thing to com=
pute?

>
> SWAP_CRYPTO_BATCH_SIZE is set to 8, which will be the IAA compress batchi=
ng

I like a sane default value as much as the next guy, but this seems a
bit odd to me:

1. The placement of this constant/default value seems strange to me.
This is a compressor-specific value no? Why are we enforcing this
batching size at the zswap level, and uniformly at that? What if we
introduce a new batch compression algorithm...? Or am I missing
something, and this is a sane default for other compressors too?

2. Why is this value set to 8? Experimentation? Could you add some
justification in documentation?
