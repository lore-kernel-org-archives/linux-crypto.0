Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.208.171
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795218027;
	b=V7lX+I+kvXPT7lVPPMBEgKSMsjP99y1Opak04kVwzFPALALgUwQ5RJgUbIB81+OwbYEA
	 28AV5cDghMrriGkBqZCFWpebEF/xvDtPO62+Fxf4rKTTuWyCM4zC+KUg/xNQJ0S8VaqTI
	 xjWXgkQX5Y0R8oNWP7KBhIK3vphdjGub/JOsE6zkRabhVlaUa9O0629gnLiK+qmtMlsVY
	 9f6ZtHuiM9H9c3cW4OTugs01OG/v8wQdReGDBgbKsfJ1exu0jccaes7MkDASt0VJsWWmW
	 /Mijl0L/aQb7EOgEopgrpHBqQVI/FR/6VBB3uSwmbCuA7AWsdFSlCG+OCEpOZYgJILg==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795218027;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=VXsP6Kzw4Fd0TFm2S4Fc1qx6wAsu/iBIUZpt3s1NHMU=;
	b=5kz2hm/k9m/op/SXfNAsikXvoJAcFK1aNqjqU37HNfbYUxOJzisSmqoLEr2ygAbGFtda
	 ajYBB07pA9krHaFvdDVrN9Noe4oqOPYTKD8r37bUyTH45DSPzKurT8jr0OmpcKhKFCBfx
	 TlRiJwF+IR7HBsmUNOfo9cjiM9tACU0h2wdLpubkwdoS6wxy+cO91fiVhTQ3XfCCcOd3s
	 hhpKK/vZzDjWilOwVQjYHOZa0LXcHQ6qzTLSpXlekddMqwPJkopjrDC0Y8BPt8q7pDqbn
	 s19co6SDFZoTVYwJNrvUn19w0oI7lmLywEXeIjeYS6RVgsErJndD27N2ubcGvrL/0LQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=RE+7Mnls;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.208.171
Received: from mail-lj1-f171.google.com (mail-lj1-f171.google.com [209.85.208.171])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73421606A6A5
	for <linux-crypto@vger.kernel.org>; Fri, 20 Nov 2026 23:40:27 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 73421606A6A5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=RE+7Mnls
Received: by mail-lj1-f171.google.com with SMTP id 38308e7fff4ca-3ae0a5c1715so24693531fa.1
        for <linux-crypto@vger.kernel.org>; Fri, 20 Nov 2026 15:40:27 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1795218026; cv=none;
        d=google.com; s=arc-20260327;
        b=Qfz/eYH7hBPdBsroxvVeIFd/2gtbuSu83zbEH7Yp9LHrHEmnGHiUXhPHHjTGt6+Zcv
         ZsWjva3hHwIy6PzsRWPw3O4EWjI5Q14ElGR0mz9OKc6lL3umlvKJnYSzirTgyqK1Q7Em
         5ukrvjSRlMCMTJ4GlbEjGBn/FIWQcxnPs92MOMaYUn5/DZG9hxOHnsR/39PM13xOxEpG
         /KzzC08e5m+XCwUMiyDhi/w20tAQsM9t4j93IzlTYQmYQmj9C0HnrRQml0WXZAb/q86N
         7BSLbu82dAgdi0Ot5KOU4603HP/emfYne6hSlg+ntwYpvS6GgsIcV4GTL9UOTO0P7YOm
         xi+Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=VXsP6Kzw4Fd0TFm2S4Fc1qx6wAsu/iBIUZpt3s1NHMU=;
        fh=vAioDoUxVoLu59C8V79tjp2X2N+Fe2yg7GRb8Vx764I=;
        b=STngcyoo31xTPwqncc1MimIfwjbinLCVpQr2xCRJ8hs/Bi9HX6wYkinx+6a0O1guJv
         Qi4ONmse2FpnG76b2yW8i0cfeBDjd01EVna5Ofa27bM6Y7eDFC+bPu8L9uEfuTxfQk3k
         pgYznd+Jlt4/Utdz4+aCk7M4o+INBlxt5KK7F4KFCqbc0n6FKtmso51yEW+tblxVnMdC
         nR5S5TFipbi66QTF/kjDRiIvm92ezcd7vXjHycEYIqVslcJ6Pi8op+7BkltMIUyp553/
         9MsPPRitF5f1dDnXkwy0ovl9T0kBJBmKjafIdBcEUoW4N8THfJFfldqQAheX6UzJJUP9
         pPEg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795218026; x=1795822826; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=VXsP6Kzw4Fd0TFm2S4Fc1qx6wAsu/iBIUZpt3s1NHMU=;
        b=RE+7MnlsRLphUloxltXudhTXKXdCfhGSXX0L5oMnOegVyN1NsUwzUN3aB80FwHSsGG
         lIILr8mL7K4108f3SkTyx6wAwI8c3BH7af+gpjlLFqANi/KaDGEMJsaIpriVQP/DUgSW
         RwUzQpIv5fsyeX/Hld+ylvmxpaQyppLeyO+G/JAVYE4FbYyP0ey+ZA+aBjfs/elEykMo
         S+8nB8rMVSC7F2vDazjyoqdFvnebmyQ7CN/zkoEgHsOdWFCmGKGBU4Ubm4BFqpCjJWu6
         daNB6JOaN1OZsg0ry7usSuX3gVygnBCpFpTC9IEMcZJuUSm3zWWYqplsXUte2fRiTxHz
         Vn/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795218026; x=1795822826;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=VXsP6Kzw4Fd0TFm2S4Fc1qx6wAsu/iBIUZpt3s1NHMU=;
        b=ykiSqdahw/ZgqIubqWPsytXMF3btvrKqMvhTgbRLlvIilQ1iinxQ6vgvCOR7YvoFCZ
         eu4Vf/IPIvSheAUsIsdzCWk0pvnYpuv2wYPC4/yDH8jXLkKnyDW1yDNwNfGDgVwFtRWy
         DHQLv8MSPx6ZSS8X7Ig1Js4VyjtmPkjOl9Qi5B1yfjWhxEWxqzh5nWAUTHqhS8RGN+pA
         oq+6fPBUa2LjaljIO4cAekBPR5St6Lt8hI/CBX2gSSMxc3sgXtbuiheHV5zZYPzgcc+c
         o+GASRPtm0rKRFRkDUV0Af1Pb9+X1r7bxpvQIKEtnLxDx22cEIOwJZgqwtmxZ6sbmHdC
         +9MQ==
X-Forwarded-Encrypted: i=1; AL+hErGWYZEFHgeql3+UCE1/RtRjPbREE8I5IWoGm005jYuTKCnKBqhvXRtGSHDqx4QEE/rL6LeWaAP3tW2hQQw=@vger.kernel.org
X-Gm-Message-State: APuU4Z8hUNi8wFq4o77JykveavlrlyVjgYyAnoZf6zypp/GKWaCfa1y+
	vic/iOBJJ/vNL/P02rePRZsDuJPdC/XAZxGhwMFtqgPNGqb3DohyMDOU0uUEDFoQNaM03+OCw16
	ihzP5qOttjTpHRiTGE9l8JrgvJ5N4H28=
X-Gm-Gg: AZFdTZeseq2Gpsb62JIJ+wXFugTSMFLOs/HNt3IRxs3LjJ0yGBr7NY8AvcHXfNg0UHU
	rMVZngzD2KrkfFSJr7xxaPLW8QtzrKPp0QrrMeB3fvP9I/q5sfLp9TWz+GyB42UiX8Enb50HXG1
	4P5eVT3xjFUl6wHPUIil3i0B0qDfzP2F0zMm7F9OowHp87cTQUyVgN9YjENBX/ijMDLQBMn8nsT
	pce1NaQiGXWyIsCL38NoVEDFxBeW8mt/oqZZUQ82cMU1iECML4h0Kqd1PcdbmLxcvOFACHcoDfs
	6Bn2MIfv8Rd5Oj9spxAWTsZmk643Vtx4w0CmWBG1vksI8dzgId6YLbnkz9XH9AINJPR1+gzTWVc
	mps4JQ6RSuyDfTxnUrfBETkS2ckTKM8oGX4Ek7Oyz/uuXjnt/UY9BF3/1FME=
X-Received: by 2002:a2e:9fc2:0:b0:3ae:c43:d892 with SMTP id
 38308e7fff4ca-3ae7b71b82fmr14829431fa.1.1795218025362; Fri, 20 Nov 2026
 15:40:25 -0800 (PST)
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261120041906.5785-1-kanchanapsridhar2026@gmail.com>
 <20261120041906.5785-7-kanchanapsridhar2026@gmail.com> <CAKEwX=Ok9rom97s1GbrdJHNLqQTj-C=iieFHnbtUVY7skO0DGA@mail.gmail.com>
In-Reply-To: <CAKEwX=Ok9rom97s1GbrdJHNLqQTj-C=iieFHnbtUVY7skO0DGA@mail.gmail.com>
From: "Kanchana P. Sridhar" <kanchanapsridhar2026@gmail.com>
Date: Fri, 20 Nov 2026 15:40:13 -0800
X-Gm-Features: Aa3M54osVsiYW3ZTm9lfCyqxR5ht3NZx9SXV3Yfo9go8drjU5olk5SDW1EIK3-g
Message-ID: <CACpmpocBaeKVVN7VSm7g4dN+TXoRC-ywjzJ2H2g39BQSp5pd2A@mail.gmail.com>
Subject: Re: [PATCH v4 6/8] mm: zswap: Store large folios in batches.
To: Nhat Pham <nphamcs@gmail.com>
Cc: hannes@cmpxchg.org, yosry@kernel.org, chengming.zhou@linux.dev, 
	akpm@linux-foundation.org, linux-mm@kvack.org, herbert@gondor.apana.org.au, 
	davem@davemloft.net, linux-crypto@vger.kernel.org, 
	linux-kernel@vger.kernel.org, rientjes@google.com, willy@infradead.org, 
	senozhatsky@chromium.org, 
	"Kanchana P. Sridhar" <kanchanapsridhar2026@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Nov 20, 2026 at 3:08=E2=80=AFPM Nhat Pham <nphamcs@gmail.com> wrote=
:
>
> On Thu, Nov 19, 2026 at 8:19=E2=80=AFPM Kanchana P. Sridhar
> <kanchanapsridhar2026@gmail.com> wrote:
> >
> > Use batching when storing large folios in zswap. A new constant,
> > ZSWAP_MAX_BATCH_SIZE is defined as 4U to support processing batches of
> > up to 4 pages at a time while storing large folios. This commit
> > modifies the "store single page" approach to "store a batch of pages".
> >
> > As part of CPU onlining per-CPU acomp_ctx setup, ZSWAP_MAX_BATCH_SIZE
> > compression buffers are allocated to eventually be able to compress and
> > store ZSWAP_MAX_BATCH_SIZE pages. This happens in subsequent commits.
> >
> > For existing software compressors, the extra overhead is the
> > the extra 'buffers' pointer, 3 additional elements in 'buffers' and 3
> > additional 4K space per 'buffers[i]': in all ~12 KB per-CPU on
> > x86_64. Only the first buffer is currently used.
>
> It's not a lot but do we need multiple buffers here for all software
> compressors? Other than the hardware accelerated compressors,
> compression happens sequentially, no?

That's true, compression happens sequentially. However, multiple
buffers here helps software compressors because it allows the
"batch-centric" compute and lean working set concept, which results in
the sys time improvements (cache locality, fewer cache evictions).
Hence, I think multiple buffers here benefit latency.

>
>
> >
> > zswap_store_page() is replaced with zswap_store_pages(), which processe=
s
> > a batch of pages and allows for batching optimizations. For now, only
> > optimize allocating entries by using batch allocations from the slab
> > cache.
> >
> > Avoid repeatedly calling mem_cgroup_zswap_writeback_enabled() for every
> > page and only call it once for the folio, since the entire folio is
> > charged to a single memcg. Similarly, obtain the nid once to use during
> > each batch store of a folio. To facilitate this, a "struct
> > zswap_store_context" is introduced to keep function parameter lists
> > concise.
>
> The wb_enabled stuff sounds like sth you can pull into its own patch?

Do you mean we should obtain wb_enabled status once and pass it to
zswap_store_page(), and factor this into a patch before patch 6 in
this series? Sure, I can do this.

>
> [...]
>
> > -       /*
> > -        * We may have had an existing entry that became stale when
> > -        * the folio was redirtied and now the new version is being
> > -        * swapped out. Get rid of the old.
> > -        */
> > -       if (old)
> > -               zswap_entry_free(old);
> > +       for (i =3D 0; i < zc->nr_pages; ++i) {
> > +               struct zswap_entry *old, *entry =3D zc->entries[i];
> > +
> > +               old =3D xa_store(swap_zswap_tree(entry->swpentry),
> > +                              swp_offset(entry->swpentry),
> > +                              entry, GFP_KERNEL);
>
> This range is guaranteed to be contiguous and always belong to the
> same zswap tree right? Why are we not using xas API here?
>
> (Or maybe we can do this as follow-up/in a different patch?)

Great point. I was looking into this based on your earlier comment,
and was studying the repercussions of obtaining the xa_lock once,
followed by __xa_store() or xas() API, but still needed to figure out
a few things, hence tabled this for a subsequent patch:

 - Impact on zswap loads from being locked out for significantly more
time, potentially causing page fault handling errors.
 - Impact of holding the xa_lock for 4 entries at a time during zswap
stores: would it result in errors due to the task blocked in an atomic
path.
 - Ascertaining if the assumption is true: contiguous range of offsets
is guaranteed to always belong to the same xarray.
 - Comprehend tree rebalancing with xas approach, would it change the
above assumption.

This seemed to require some more focus, and deserving of a patch of
its own. I agree, we should pursue this in a follow-up patch.

Thanks,
Kanchana
