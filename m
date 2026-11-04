Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.218.46
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793790689;
	b=dSdl8ypM1x2GWJcT+l781U0WALwti8Ws9F64i+V9l5MqTPP9vdxfcKusDwrZaz1EYLr7
	 DOu+nM1IUUHrchEHNXv69ieg/lG9JMgFugr7FP7zko8AuV5LgGCyRnSZBzJo5PoZqeOTd
	 INgt6RQj4tYIfUKFQ0hS9uptfmdKU1/7lTaOjXoSdC4IWYiqaCCrO+FYYJajUgV/eF/Fk
	 G2Inf5Dn6aVpQqv2gGRVkhTImifYpZvr8bhTpDnQgBXLyED85tjPRHFi/IZIByVOnFZq3
	 E87vgpl/3bXWw30KQ1mRFzKAJC61BnBy8dzeFkejuKsPcicQNGemoyOtDGlyJveUCvA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793790689;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:X-Google-Original-From:Date:To:Cc:Subject:Message-ID:References:
	 MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=9dGhPXkF5fybGQPWWCMqIGqZtY7L/k+cbfx9SzNUbl0=;
	b=DNi2vHSi8Z0MN9kqakpQUyIcAnHvNote1ewd7cF2zIcUCTT2KmiZXrh4c8hJfUo4HzK3
	 sRxU1GfCYxzuFwyd888BMfdHPttg/zbzleXTZG1iaYbbdWNLW5WZxr4fcctc2ZJHAMBv6
	 1S/a4mvXtLx8yz4AaEw8/vbXcYYyx9ib27GXPQLbJFiKmnZQJjH2pIIfYl1lF47S+3UQU
	 m3IRHOQhAWhzMLtVbSWSwgLhEGO5Q5mBi41bKuyvPFXxn+Sct4XmcjeHrSD6SgxTANrJ2
	 j4GcnenfjJ8grC9dV93Al11I7J3y2SHRmvEZk5mUvGOyMXkXK5Omvv81nHI/TNCz/Iw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=0e8FYXJx;
	arc=none smtp.remote-ip=209.85.218.46
Received: from mail-ej1-f46.google.com (mail-ej1-f46.google.com [209.85.218.46])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5849606A326
	for <linux-crypto@vger.kernel.org>; Wed,  4 Nov 2026 11:11:28 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org C5849606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=0e8FYXJx
Received: by mail-ej1-f46.google.com with SMTP id a640c23a62f3a-c3f04e0e65fso83055966b.2
        for <linux-crypto@vger.kernel.org>; Wed, 04 Nov 2026 03:11:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793790687; x=1794395487; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:date:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=9dGhPXkF5fybGQPWWCMqIGqZtY7L/k+cbfx9SzNUbl0=;
        b=0e8FYXJxpc02eZ5f5Z3Dy627r9wHcblee3p00UDAVss7m0HHieZ7BNV8ugV7wINDTl
         ahbP/wDIakMygyWdzNmy24SMpvBdrMOWcDTDLB6nfyGOdm8l9hulDVGPeduCDyqmMWAT
         nrpDIY7GWyqY923w2NmqbOhX3OlevSe/Xs5CZakOOb8wR6zxmaaia+dGWSLIqHTb4g1l
         D7pMgrksLKPwHJVEeVN2Fwew3Xugipcs78Yg/HhLvX48/9N7OQ/UZ3DRM4HxtxPsMOou
         Ym4nI7LOsjzSKOCqATVO63v78fZ2r3Pj5/jAjXlzlyKHJd0VHgoTM3ob/3hbQPSJl0ux
         9iAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793790687; x=1794395487;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=9dGhPXkF5fybGQPWWCMqIGqZtY7L/k+cbfx9SzNUbl0=;
        b=o73EdRlzgpy37gjstcG0UBtrdusspfflrLnUJ2QXl0/CkilLElWt7iAP2QlYOTUc7k
         jE730fznOZZZ7iKSvlt2GBGtMRCxzIH4ojh58wTQb2ZrDZeISxNNHTn+G9BuSjdQKUra
         Pc6ZDDVctGPnD0SEstYH/cyLNQEjVQUfvC3wyU2HdmQ70Hl0HxA1ug/wvsdteZ8bugo5
         rxJ8gGH9iLJPzxOTOA8yQA63Qdv7zwDiLiryLuuCwcCoO4ceMUu9C9qxLgfMwLKspEgd
         oFDs7zFQ9rN/YblUWj5QKJZoaaFDO69RttMk0wKfh2j+F+Hgs/eE/aO4I8nc2t+R3l4y
         Ivjg==
X-Forwarded-Encrypted: i=1; AKwUvBw7lKX/VDpQl5wYw8deHtdfj1gs5gj5lTl1wF5AlHgnXJxVzDhMSmb5kp953nVBgceK95e3nX1CsQfqgOk=@vger.kernel.org
X-Gm-Message-State: APuU4Z+tbmkpNBb/xCCJl0rPfJmpB1EXc5YpiaOanvKCzGKB4tIc5eRp
	fMkF17S+Vid2dIBKModx61mHATfEdrjSWAtct+6F2A5Ezl6+Yt2rVqZ3
X-Gm-Gg: AYBFou18RGedYS7MOWkHnMqs2R62nq+ErnfhqWmfIV1R96850T+t4Ot5JrvwrDIKB27
	29Ldppw/4ncu8RV+i8+oJAqSBvR33Msy983rZOvg6lbJIJp+jg8vQ20u64Qc+04GMFvgscFlzbP
	teVwbNBf0wSMImm98HrAyolZPgZopRs4zvtz65HmffgBIkZwaPa2u3yhV87ZVwH7jkqXHoitnoB
	AzL0WU5grEC1TnnNPAIwAT+GaaogWjIJ5WMOVFHHvoQRaNW387/Mpfmf0VkBRymeOKJTDVH6z51
	0nYptbFB0N6vS2ZNKzHvd0ypF1BhP2jCI6KbWL5F/lCVnJ0YH0YRT4iip/JnxPUGiG5zQArQrHt
	DcaIAg/dxLHc0nUCDR+LTXKFwbz+S6XP9jd+9A8jD9UvzUQN63aAgQqK90Ts9wrD/RX+JPK/YeS
	sCNj4aQpAc/dC5u8OIWhaoXTEy64kMqP3UfDZxIxAMrXYjdzUS9jDk4skPF6lhUf4X4uI4RaGUv
	wglXfoAyJTU2QgQbvl/8YoMzVX354qWV3WYjGLhMtdWXjJJaM7KUom/Y0iZLPmbq6llQylywYtx
	7g40FCaR+EITgQ==
X-Received: by 2002:a17:907:980c:b0:c40:36ca:9d1b with SMTP id a640c23a62f3a-c4ca7aaffdfmr1376456066b.40.1793790686850;
        Wed, 04 Nov 2026 03:11:26 -0800 (PST)
Received: from milan ([2001:9b1:d5a0:a500::24b])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c4d0e4a4bb5sm55813666b.80.2026.11.04.03.11.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Nov 2026 03:11:26 -0800 (PST)
From: Uladzislau Rezki <urezki@gmail.com>
X-Google-Original-From: Uladzislau Rezki <urezki@milan>
Date: Wed, 4 Nov 2026 12:11:24 +0100
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
	"Liam R. Howlett (Google)" <liam@infradead.org>,
	Davidlohr Bueso <dave@stgolabs.net>,
	Uladzislau Rezki <urezki@gmail.com>, Michal Hocko <mhocko@suse.com>,
	Baoquan He <bhe@redhat.com>,
	Alexander Potapenko <glider@google.com>,
	Andrey Ryabinin <ryabinin.a.a@gmail.com>,
	Marco Elver <elver@google.com>, Michal Hocko <mhocko@kernel.org>,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Thomas Graf <tgraf@suug.ch>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, maple-tree@lists.infradead.org,
	Lorenzo Stoakes <ljs@kernel.org>, Chris Mason <mason@kernel.org>,
	Alice Ryhl <aliceryhl@google.com>,
	Andrew Ballance <andrewjballance@gmail.com>, stable@vger.kernel.org,
	"David Hildenbrand (Arm)" <david@kernel.org>
Subject: Re: [PATCH 4/4] rhashtable: fix vmalloc() deadlock in atomic rehash
Message-ID: <ausS3LQNkdc6lBy3@milan>
References: <auMbCuecFeRmBFSK@pc636>
 <jfvq7vkx73vzp2ukq6nwnb3v3g2ezdcyppba4oa5lpzmz6ls6t@akc46gonndgy>
 <urkgmijyytg3rrislm5fdzmfggqavzpiry23f6lpkqonvy2tqx@d56stj3eixfa>
 <auaFhOa5EBz4gJwK@gondor.apana.org.au>
 <xdzcyoou73blpfdlgy47i2ktrcsffnclerzojpgrxphid54gjc@nicdcvzqx447>
 <auqtTjXhD8is-y9f@gondor.apana.org.au>
 <CAHk-=wiE0KG+jkhmJWifXuAVivtB63WCWtdEpGAex7-T0SHd2g@mail.gmail.com>
 <aurAxRpCwzeyXeVj@gondor.apana.org.au>
 <CAHk-=wgPvbYRcKpQ8WTH-EYZRgMG0KSH+cZxY5-Hyf+X7JjWsw@mail.gmail.com>
 <aurJZ81qnbiHH_P1@gondor.apana.org.au>
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aurJZ81qnbiHH_P1@gondor.apana.org.au>

Hello, Herbert!

> >
> > None of that says why.  It only repeats what I already said: it seems
> > to be due to kmsan doing bad things.
> 
> Fair enough.
> 
> When I was told that folks needed vmalloc under GFP_ATOMIC I didn't
> question it any further:
> 
> https://lore.kernel.org/all/aeiHkG7X_dieMdw5@milan/
> 
> Looking back, it does look like it was never explained who these
> folks are.
> 
> Ulazislau, so who needs vmalloc GFP_ATOMIC support in the kernel?
> Or is it only used by out-of-kernel code?
>
There are users in kernel. For example:

drivers/GPU
    /* Allocate the file in vmalloc memory, it's likely to be big */
    iter.start = __vmalloc(file_size, GFP_NOWAIT);

AMD-GPU:
    kvzalloc(size, GFP_NOWAIT);
    kvzalloc_objs(struct amdgpu_coredump_ring, GFP_NOWAIT);
    kvzalloc(ring->ring_size, GFP_NOWAIT);

Virtio ring-testing:
    (alloc_ring(0)), gfpflags_allow_blocking(0) does not allow blocking.

net/ipv4/udp.c:
    err = bpf_iter_udp_realloc_batch(iter, batch_sks, GFP_NOWAIT);

etc...

Apart of above, the obvious user of GFP_ATOMIC is the bridge forwarding
database. The br_fdb_add_local() holds br->hash_lock with bottom halves
disabled, on rehash event it invokes rhashtable_insert_rehash() to allocate
a new bucket table with GFP_ATOMIC | __GFP_NOWARN. In that scenario kvmalloc()
can fallback to vmalloc().

This path runs and exists because syzbot hit the old in_interrupt() check
there, leading to 04aa71da5f3 ("mm/vmalloc: do not trigger BUG() on BH
disabled context").

The vmalloc() fallback improves the chance of completing the insert on
the spot to minimize -ENOMEM hit rate thus minimize queuing the
irq_work_queue(&ht->run_irq_work) to retry allocation in process context.

According to XFS code and comments it wants non-blocking support for
kvmalloc().

But indeed the v4 cover letter didn't name a consumer. The bridge
report came later.

--
Uladzislau Rezki
