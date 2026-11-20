Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.128.46
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795216126;
	b=09ya83muYLI/XemvUNk3+G1L3vwZySyVSz89rM3B3G8fVj4Up7Dj6AHoSFd7CGvGoakv
	 1nYJ+MUheLxc+KBR2vI6bPbVipZJyHVSx2jQ548cW0UbTaaxJ+dh925gYmoQCDvdu3BFO
	 0vrKibJi1ZYKB+eiAH/EZxMQbjX54NIwG9Qq9WcQ+fzePG69LK1tAUI+vYysDHuVLwN/2
	 xBQksnzbOKY6z/+0OA2MfX/XkffaHviM4i467hmlcxympcG23JLAHGT87detA3nmcjCng
	 HWDACl7il3CEjL/kWEFdfqQzbjfULS43PgVn5DVsioWXf5Y7FYxZAD7Dtls74Gq07ig==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795216126;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=9LNi0DReitfHRwsgEnJHCKqDlOJr9t9ANMesp8Kcr5k=;
	b=hSuFNwKXoO4GsHM9t/kJbiE+bI9m4UmyJDrKCfqftCRyA/9mYKqPXBxVfQRrWpUfZfwd
	 g89Gy6z9v4UGx0uwiXfjF7u7FG0ta7xMgbSxT58tHpXbBJOWQrrR8lQsvvpCC+iRPejvj
	 ZE3AQES0TPFvyT8+Fr8UmNTAHBxU3xeJmjamD9m3icXshhnK0TIr77BOQ5MGBjWIZOOjB
	 2zMt0hnrdUUvLk3d5v6j7pZoqbIWonVZsrSA1v1ArlMa1y+mTq9DofEEtDwaEyYvWiI9Y
	 UrMvUpmkgiENeLvRvWwGh5yN7KlG1dcH6pJHPz1J6l3zxnBBCADhfmPypBs2qIwhylA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=Vf8PDmzM;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.128.46
Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CD75606A33A
	for <linux-crypto@vger.kernel.org>; Fri, 20 Nov 2026 23:08:46 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 7CD75606A33A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=Vf8PDmzM
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-4a2000d5fb1so8195575e9.1
        for <linux-crypto@vger.kernel.org>; Fri, 20 Nov 2026 15:08:46 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1795216125; cv=none;
        d=google.com; s=arc-20260327;
        b=VYcD3mm/7BHImx9W3uh9MUSDhXZ+d9h8quoC1oHkpBJXjt2YHDe+imBmziSemfu6Fq
         XqqO5U0q6VZicaYCPK7G93tnxRb5RqJAFeWYRrc6ZJ2AQ3mdVH6C34JFO/W0zqFPCQr8
         ATkIHRBK2LcDLLzx3QXofF2MohtQI46F31vnrLVcvAWoWlxqXEDOBDI+eJCFlivnjpcm
         lqvIFzbgCvRgGhI87hiFBY/pLaTsWYDoMAE/4Mpnw8JAQdLDB0B6rAIeXfR42s8Q+zF7
         /9coMYIXMgjj2BRmcrTBYm39NwpGgnoQem/DITuWcyYopc4n5tavXph7+V2vYNy35m+E
         zekQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=9LNi0DReitfHRwsgEnJHCKqDlOJr9t9ANMesp8Kcr5k=;
        fh=ww4caVSBcv2GVzrq9RgOYQwTEcJctsgskgByQaubjAM=;
        b=YDQPxZhUW1MzOvqaLNMWDzs1onUjZpWfl36ErngkhBDG+045qubKZQEr7QvvzWsuHc
         /XQ/mhghyvCtu6HF5yZFKm4ELFibwxy3OWGJnwhW3WY5d+mOFi0iC13nRX44d4dORSQK
         HHZJFcPR/2yJlkXbl5E2LdKaC+PMQiZBxj4zzaN/EPWEB1nPFDlGQwJMdA3dHi1vDMVt
         Mu7GjF6YfMKJMLxc8X86WtKQaFpEitpeoqInL/UE/j1fsAaeX5eRprlpO+13yZkFR3q5
         msKwaT3IxxojjZK1ucY31F0epUeJBKZzXOGW1YkhigiZYHoiN9CybIn37iel7PkrTDZb
         EJ6Q==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795216125; x=1795820925; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=9LNi0DReitfHRwsgEnJHCKqDlOJr9t9ANMesp8Kcr5k=;
        b=Vf8PDmzMDu0k4xnWhO2TNlwrtgqit8MkrARz7ooVrefXRM87uBZXZhWX3ZjZAVVBB0
         wAIlpVYlxqXN+gFTiCdWAE/sKYRJoykiDdgJKYPi2c3WB7yTGlSw+bhpaT+XVKmmokZZ
         jdFhYo6DF4ECifO9JgEComGznLI9jtpeEVUWwnB8YLZD4HQRrq3bIPhGdm4AerV/gj76
         CcTJzHefv8Cg6ITgDOx8caU4/R7q4njdLMWpbDCtKdkHIE5v/hIETvMaBrPzayQxtuDE
         X9nANjAPmc/KHnnG7QIcFTuujU83Hqv++r7LoYVgomdVnYdaIWHsR591isvM8E4zhSsH
         zExA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795216125; x=1795820925;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=9LNi0DReitfHRwsgEnJHCKqDlOJr9t9ANMesp8Kcr5k=;
        b=YZC1g6FLxbgUItqmPwfQEUANZr34fvs+ZEJH7XxNmGwwLPlV9zEB8UGjb9XkBBVQms
         9Kj/64mGt/YR5q1EaHNmWjjuN+XYXnJgAdT3dEVse/PM+2ju0sOrUePh/fIy2+Xsvoen
         zXngoFV7HxzUSHEFc/KhbWv0fnuv7866E442Fh1+bvmokasDfiikzaJ6ugR9DpPMsbUT
         Hse1NZ2SBPv1RpNjsxa4OmRMkcvwUv+PDFtV09XAxFRr57KRB2GxnEDVaqUA1UGwN+I3
         mIr6zxkHCmscJ/NMXDKMim1umoMYKDJUPb7ty9NrV0AHOoJHLHgxjB1O4ADRUYEYzyBB
         P0Gw==
X-Forwarded-Encrypted: i=1; AL+hErHuZ09JAsx5Qn2jtlIm8nR7/SfnXs+La4Etbe2oijzsIoPE/bOEojnmlbHH+izRNeRMp4lSihyh3NfBdz8=@vger.kernel.org
X-Gm-Message-State: APuU4Z+LVYvDdGbhkOE454AYrFH3/0kaVm4AwX5KUSkT3EvLIVeefYiX
	vJiXcNzpjpzcHp7Q6czdPOGbLYBoj2OSTZtHERoRvpBDKCzQHHPAEsnSWbSg2RI6UDb++mTgmbK
	jC85gzd5LJsP6dWLvt6Lo+rRUgC9MZFM=
X-Gm-Gg: AYBFou3TomR2X5inKfdBezA8VOw730vvEkRLNgrKoYKgB7Xq4j0y5mWYTiKC6Ad76ZG
	EQWrMCzgFvZiHsyxKPVxqN45Kmxz3lCKx7Cq67XPurjNSaJQ9c3itwb5yGZg6XqLufp/PcW1MgR
	Gm6h34E6fukkSvWVEtAe+4I+e//ebpw54fhWCpV/T6G1LMatGQQ9paz1xXx8CnsMhYOvse/y48K
	ciO6n5rx6gj9Gll8B6ZzRByP2GP0suipYbHkGmnFivuaqH5JyHiJY8ENdRV+otVMD6zZjli8lbX
	U/KRjL1Vaglbg8iDabVU7xabqpVGiFamwo0siqDpgEZbtudx+ZHUDE+Ur+yf1wJpVU7Dc5npALI
	wKHdxNPgpUFtlHzmsXmsuYHFeynHFkAo15jiaJWeHga/xJmPWNtIKfJ/p6Mx9G4zGBvPDGn7hWm
	ohSvhUAsH5F4+FAS8+jCIEk6sdYFAtWPgO1pBZAe5LI5z4wFB2bnAGD7o=
X-Received: by 2002:a05:600d:82e4:b0:4bb:6847:7927 with SMTP id
 5b1f17b1804b1-4bb8882677cmr106256925e9.7.1795216124609; Fri, 20 Nov 2026
 15:08:44 -0800 (PST)
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261120041906.5785-1-kanchanapsridhar2026@gmail.com> <20261120041906.5785-7-kanchanapsridhar2026@gmail.com>
In-Reply-To: <20261120041906.5785-7-kanchanapsridhar2026@gmail.com>
From: Nhat Pham <nphamcs@gmail.com>
Date: Fri, 20 Nov 2026 15:08:33 -0800
X-Gm-Features: Aa3M54oWMWk3u-HStz4cQZgKn2nyeqXit_w2sb7aEXMQD-Dkp35CvqUHYELg-w0
Message-ID: <CAKEwX=Ok9rom97s1GbrdJHNLqQTj-C=iieFHnbtUVY7skO0DGA@mail.gmail.com>
Subject: Re: [PATCH v4 6/8] mm: zswap: Store large folios in batches.
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
> Use batching when storing large folios in zswap. A new constant,
> ZSWAP_MAX_BATCH_SIZE is defined as 4U to support processing batches of
> up to 4 pages at a time while storing large folios. This commit
> modifies the "store single page" approach to "store a batch of pages".
>
> As part of CPU onlining per-CPU acomp_ctx setup, ZSWAP_MAX_BATCH_SIZE
> compression buffers are allocated to eventually be able to compress and
> store ZSWAP_MAX_BATCH_SIZE pages. This happens in subsequent commits.
>
> For existing software compressors, the extra overhead is the
> the extra 'buffers' pointer, 3 additional elements in 'buffers' and 3
> additional 4K space per 'buffers[i]': in all ~12 KB per-CPU on
> x86_64. Only the first buffer is currently used.

It's not a lot but do we need multiple buffers here for all software
compressors? Other than the hardware accelerated compressors,
compression happens sequentially, no?


>
> zswap_store_page() is replaced with zswap_store_pages(), which processes
> a batch of pages and allows for batching optimizations. For now, only
> optimize allocating entries by using batch allocations from the slab
> cache.
>
> Avoid repeatedly calling mem_cgroup_zswap_writeback_enabled() for every
> page and only call it once for the folio, since the entire folio is
> charged to a single memcg. Similarly, obtain the nid once to use during
> each batch store of a folio. To facilitate this, a "struct
> zswap_store_context" is introduced to keep function parameter lists
> concise.

The wb_enabled stuff sounds like sth you can pull into its own patch?

[...]

> -       /*
> -        * We may have had an existing entry that became stale when
> -        * the folio was redirtied and now the new version is being
> -        * swapped out. Get rid of the old.
> -        */
> -       if (old)
> -               zswap_entry_free(old);
> +       for (i =3D 0; i < zc->nr_pages; ++i) {
> +               struct zswap_entry *old, *entry =3D zc->entries[i];
> +
> +               old =3D xa_store(swap_zswap_tree(entry->swpentry),
> +                              swp_offset(entry->swpentry),
> +                              entry, GFP_KERNEL);

This range is guaranteed to be contiguous and always belong to the
same zswap tree right? Why are we not using xas API here?

(Or maybe we can do this as follow-up/in a different patch?)
