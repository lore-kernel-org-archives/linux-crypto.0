Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.208.48
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793900274;
	b=Rb2mIY2NDTzqV5G1d0XQdhWaVHapnx6WVQFbnlNDQukNcYIkiJDOfEk0xYHu56WhGBzB
	 sw0Za91U3ELmR5kYYnLA1xG3OIDXv4KGchNGKUZRsRLfqEbbDVMVtWm/HzljO/VPmw/1j
	 1k6A66k5B70mcZs3MCkALbFp2e/fxeT/5VFqAvo+5JfwWw9rdyCRdgQIzpEXh8M3ay/xq
	 0Xj4WHiZa5loLcMqhr8b9NM4m34VFozJyUr6LB1qSUctYBYkOHtc3DsqW1I94kOFQZPn9
	 1+kY8A9fd1rv48LlMGl7w5OKKdQspG1dyyM5IeNORQGTTt4XeLj3sFbgXnyPweLWVEw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793900274;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:X-Google-Original-From:Date:To:Cc:Subject:Message-ID:References:
	 MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=I/9VHkQVwisO5bupjKzX692XjiMS3IZKTYKgohOq9P0=;
	b=vPTjkD3BOITeBgmby5+Zbkua2o3o8Fk/nU2h8IZ/Yt4w0LcmjCRZOTdIATKerb/noMpN
	 0YByH35N3X3ODOZ1Fv/T90mQ7vSCUz30aIvD5eCSEWoC3u9laH1s/TPQc57JxLt8px0QK
	 nGtq1Zg+lPiQHRziDG5oOuRG3b0uU4/2wfisGMU3ozA7vkcF/IspDerMOfDJds1jwW3Su
	 lS1UszAB7tJA2W8LXmcMe+D/GwGQeWxSc60OUAxwbHW3cdvcN8rfKLjOEtlhO8xdFuKLr
	 N2kDoE588PrXd3163ad3Ajq2vNJ8BvoGBWXwGV1MxEEd3P+Rzs7mzZNrCUb0zoTjDdA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=rtW9JhWR;
	arc=none smtp.remote-ip=209.85.208.48
Received: from mail-ed1-f48.google.com (mail-ed1-f48.google.com [209.85.208.48])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5E1B606A326
	for <linux-crypto@vger.kernel.org>; Thu,  5 Nov 2026 17:37:53 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D5E1B606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=rtW9JhWR
Received: by mail-ed1-f48.google.com with SMTP id 4fb4d7f45d1cf-6b47c1a3c74so2804874a12.3
        for <linux-crypto@vger.kernel.org>; Thu, 05 Nov 2026 09:37:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793900272; x=1794505072; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:date:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=I/9VHkQVwisO5bupjKzX692XjiMS3IZKTYKgohOq9P0=;
        b=rtW9JhWRKUehWAWBFJ67ewxZw5Sq5AhUkrmHEUH3E9xFpX2UZZEkcUkuiY0OXLiVso
         OvhBRgL2naJls/kePq+fHAMp05e7EuLmEzNHdMXYWf5cl26qeQMstIAAPpfohQ/tyLJK
         D2A9ITOnDfhb0hFaf3UvqqlV+4z7c5VzqSnG0HfJVhc1/2Yl5EovgXB3OeVnUKU8XXAQ
         9JJWaB5U4MlNr5hYUDqG5E6avjxl/dPr6VvsorTfUQ2QXiqULLgByCg3l6m7ywbSUQqT
         mAIyuL3AnkcP+4Mr1vkl4PPOwa4aIGT6i2Pqt9Jgyi0/bL+ZVNDMO4AXbGfBqgbjwRA0
         LhxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793900272; x=1794505072;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=I/9VHkQVwisO5bupjKzX692XjiMS3IZKTYKgohOq9P0=;
        b=VvujnaEBTaXQxH2ce5H3/rTxey+4WNJVKJlxiPEdmgwaEPdUFvKCbfz6kCtx6bvtPU
         lpOck8MMp2ffeFAVl5eQu1IvDxnwxiJ1ldzaxWHA5IZmZbFM3bRrXlMftsOGrR2Rfe0S
         pxitWr4ij2z1J8Ck1b3r0SRxnsllUQcz1k4rlq44X88u78vzQsCNUGlEysYhqYsf+7Td
         brR+LhlA6UHmSq/koVG+VxBSImqA/hiT1SZD1ta0+HKvRd/BAXfGV9lQ36S/KQobEDX+
         iFfHie7i9NnE5g9X0t/ynA2es1yU6AVUWssAqqtPdnx7xe7p+kewvCBkHtNG5q0Umd1m
         ChPA==
X-Forwarded-Encrypted: i=1; AKwUvByv/QuevUS6iWa0N4WHJQeXtoRhSsvV8Xrf/wNrFDkcdQO8IrdkpfcuKc0Gz1Lwa4YT+NNbjd/NxXDlDJ0=@vger.kernel.org
X-Gm-Message-State: APuU4Z+6kP+DksyhEAI/NiFXaJ6KYEjLEGullpBNGMOyFOwIixO842/P
	SxHBZIXX8ARkuAET6S5ebeOPhcfo5KyK7nKTektfLacymwv0I4bhJkSB
X-Gm-Gg: AYBFou2C2IgdQrdS03Z1pfvnOW9kQAJyQL8+gw3Lj9Lx03vqR66fIB72aVKmCL1VKlS
	6yaOsYP6p9DQmmTrzflmhn7c+SqoqUZKyveWlBKK3Na4fuORnbLr5EaCIcLKZjO/56ZVElstDTh
	ruS5x4acyBqQJNx+P6qccB2+CVa1bC5NSlgS0Izi0DBSNR7Gp0y6NUs+aYQf9oybZ7CFRmBAXS1
	lxTVIQae1+UB7eR++IrXVFbf/mMXTxXwFhglYzj1hiEVMHDaXtugsRdKyUkizDqUTmYMOXFgBdE
	NLxxgXM4Ud1cNn8mdbLDp0pqaWBKhNx3BqMxXMVob5MLELrI/vfNm6zu6KMwRc5x2GbUXvPzBk8
	Dnyx4WD2UEbPjdwXRifQHRRBOq5pH9hdB1hvdwYxVFg8GYUNf/kT8BNIqWcB+i978wonn1aKzct
	UeVZUvLRRAtFCZ3MpnQGZGbKuzVmpXeMoYjZwMGb9+vSUFlEnvRtDLwhDMz5k/yssAf4VVf05Yi
	TfwngRF/R4lrocXbGRd8pTKd6dDHk1rnVhHDZrI6U63KPwKsgRpD10EYUTEPdiU9o9H
X-Received: by 2002:aa7:d281:0:b0:6b5:916f:938c with SMTP id 4fb4d7f45d1cf-6b5916f94c8mr459489a12.41.1793900272060;
        Thu, 05 Nov 2026 09:37:52 -0800 (PST)
Received: from milan ([2001:9b1:d5a0:a500::24b])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-6b5876145a9sm494548a12.36.2026.11.05.09.37.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Nov 2026 09:37:51 -0800 (PST)
From: Uladzislau Rezki <urezki@gmail.com>
X-Google-Original-From: Uladzislau Rezki <urezki@milan>
Date: Thu, 5 Nov 2026 18:37:49 +0100
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	Uladzislau Rezki <urezki@gmail.com>,
	"Liam R. Howlett (Google)" <liam@infradead.org>,
	Davidlohr Bueso <dave@stgolabs.net>, Michal Hocko <mhocko@suse.com>,
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
Message-ID: <auy-7TvVzJ-VCrG4@milan>
References: <auaFhOa5EBz4gJwK@gondor.apana.org.au>
 <xdzcyoou73blpfdlgy47i2ktrcsffnclerzojpgrxphid54gjc@nicdcvzqx447>
 <auqtTjXhD8is-y9f@gondor.apana.org.au>
 <CAHk-=wiE0KG+jkhmJWifXuAVivtB63WCWtdEpGAex7-T0SHd2g@mail.gmail.com>
 <aurAxRpCwzeyXeVj@gondor.apana.org.au>
 <CAHk-=wgPvbYRcKpQ8WTH-EYZRgMG0KSH+cZxY5-Hyf+X7JjWsw@mail.gmail.com>
 <aurJZ81qnbiHH_P1@gondor.apana.org.au>
 <ausS3LQNkdc6lBy3@milan>
 <auxDm_YO4oACA_d2@gondor.apana.org.au>
 <CAHk-=whXvVO6a5AreZu3LPBj_wjpzUanwhvu8WqWP2q7g5S7Vw@mail.gmail.com>
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
In-Reply-To: <CAHk-=whXvVO6a5AreZu3LPBj_wjpzUanwhvu8WqWP2q7g5S7Vw@mail.gmail.com>

On Thu, Nov 05, 2026 at 08:22:52AM -0800, Linus Torvalds wrote:
> On Thu, 5 Nov 2026 at 00:51, Herbert Xu <herbert@gondor.apana.org.au> wrote:
> >
> > On Wed, Nov 04, 2026 at 12:11:24PM +0100, Uladzislau Rezki wrote:
> > >
> > > There are users in kernel. For example:
> >
> > Thanks for the list.
> >
> > > drivers/GPU
> > >     /* Allocate the file in vmalloc memory, it's likely to be big */
> > >     iter.start = __vmalloc(file_size, GFP_NOWAIT);
> > >
> > > AMD-GPU:
> > >     kvzalloc(size, GFP_NOWAIT);
> > >     kvzalloc_objs(struct amdgpu_coredump_ring, GFP_NOWAIT);
> > >     kvzalloc(ring->ring_size, GFP_NOWAIT);
> >
> > These appear to be executing out of process context without spin
> > locks so they're not really GFP_ATOMIC.
> 
> Historically, GFP_ATOMIC and GFP_NOWAIT have been largely the same
> except for GFP_ATOMIC eating into reserves.
> 
> But I wonder if we might be able to soften that a bit, or add a new
> form, because it looks like the AMD-GPU case at least doesn't really
> care about any kind of "don't sleep", what it really just wants is an
> "optimistic allocation" - try to get the memory, but don't spend
> effort on freeing things if there is not enough memort.
> 
> The AMD code in question literally has a comment that says
> 
>         /* Dump ring content if memory allocation succeeds. */
> 
> so while it's possible that it has some atomicity requirements, it
> doesn't look that way to me from a very quick look.
> 
> The etnaviv case looks to be the exact same thing: it is definitely
> called in normal process context (that code takes a mutex lock around
> it all).
> 
> So those two cases really don't looke like they are about "atomicity" at all.
> 
> > > net/ipv4/udp.c:
> > >     err = bpf_iter_udp_realloc_batch(iter, batch_sks, GFP_NOWAIT);
> >
> > This looks buggy in exactly the same way as rhashtable.  It's
> > called under spin_lock_bh, and the same lock can be taken on
> > the softirq path on another CPU.
> 
> Yeah, that case is definitely actually atomic and holds a lock. Not great.
> 
> Is there any way to limit the vmalloc() case to the actuall atomic one
> and just fail when it needs to busy-wait?
>
Probably it is not easy. vmalloc() takes several locks including
during page-table setup.

Probably the simplest option is to return NULL for non-blocking vmalloc()
allocations when BH are disabled. That would address the reported
rhashtable deadlock.

--
Uladzislau Rezki
