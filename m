Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792683297;
	b=owyNVro3bwxW/DnqAi3j47xjPRRhPGKa4RXiRiaDW88AzfVcoEdZVx1Gn7n7+OP2NexE
	 w9mwlzwy5TESkPFpxUt57C1zfXdPbH/C9klMcoFQzIF7K7cHTDQimT5G0apM65U12Pnsn
	 OEZqIu1QwbE5wv89Ek2MhvQFswbEft2lHcgs2mUGCZAOWwxdiD6oWccwfQhInuakW+XlV
	 uhtHdDsOb7exW9Q+F4FfMZJm28TpAWLpOnnU8eolMH8bunuAQ2HBDxJUahLLFk6u4lP/G
	 EofemcTbrhQm0ctabH+P9RFc0l6F1vy9d9KrND7EM2pdVcjUWy0qkRLr+TnS9XuOVQA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792683297;
	h=Received:DKIM-Signature:Received:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Received:MIME-Version:References:In-Reply-To:
	 From:Date:X-Gmail-Original-Message-ID:X-Gm-Features:Message-ID:
	 Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=XU+1Xu6Ic+cCmwqZl6X3dsTo05EzJQUM/Qh7OBA1YMo=;
	b=2k7pimB1Pi8k4IjD4BEfrGhI4PqUJcq2521Qatg8bAnva3RDQbu3+ivAqK9ftsYOC7ta
	 KfJVQ88D1NbeRiYGAlwJGcovMsj3XsBDXWHRCszL28s0mX9kK1OvaSfRzEsrJaRSwY9BY
	 yjHNLTr7hf9MhGOg/jt2wvSFqoc6Vne8qBKmKaZKt90yOcsG6/b4V4GMEL4zxl1q4tMQV
	 2xQVGqdy+T8V6Vn05MiNI4JM7vLFDR2ugJrXJ9y83n9IpCY9ET2aYQE9ZqJICLGz0klml
	 CUcOM3mpPpkI7EfxTGraP1Uj8eGANC0NM+ZJUSdpGdX42pPrTVYPcGg1gnHfQMkBjNw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=nXEM4jb4;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 891C9606A324
	for <linux-crypto@vger.kernel.org>; Thu, 22 Oct 2026 15:34:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=nXEM4jb4
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41D2C1F031E3
	for <linux-crypto@vger.kernel.org>; Thu, 22 Oct 2026 15:34:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792683297;
	bh=XU+1Xu6Ic+cCmwqZl6X3dsTo05EzJQUM/Qh7OBA1YMo=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=nXEM4jb4x91hA6g2oPH9+gj5iw1zh7+UiP1ovTc0VXERNDtNwokstWvTR9+UuRgnI
	 BA8IKE/1y24Hta2uiqu9T+UxtmmcFtehu+wYOPFDYZsfXZtv2dMJq1wzPkUB2JyTS0
	 3pjzHo+3RIP4BHC0/4X4zvo2lBshjUsnqyGt4sm8vLyTauwpNe+X5EIn8EpyNdHkxZ
	 5EkfUTVOyKDG1uUjTU4/GBPa8cnhM0rh+SxvxvaTxUKOGyCx1nHlUh6ojj/EB05bda
	 xHjpN78VNWTIdBF7W6P1jWHHRXEuKJ8MkW2Jiafu6V8TRByHoMBSWuTNH3ZsBW1Z7M
	 AgT2SCJZg/ggg==
Received: by mail-qk1-f175.google.com with SMTP id af79cd13be357-93f1cf92c9eso201229185a.0
        for <linux-crypto@vger.kernel.org>; Thu, 22 Oct 2026 08:34:57 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvByC2QpZR0hKHHLpImElnK0XoJpvqgrH27O4bjb1amDNR4SxfnkK1PobEbsjebvNgPXhGNEYeotGVX3ljlY=@vger.kernel.org
X-Gm-Message-State: AFq9FYIHClzMMXwm1Sj74LY5K8pX8yWipY8Bwwvl6nx1sP/KeBAbTQR0
	iAJNAJw9f2zBEAO/YujspDzeJ6jstbBgTOzs3rQ5xnq5UQKjjeL4trG8J7xHJGxXXVDY6DDXU72
	WIXK05se9pG2kNKZIwQ2PnjxWbv4Ba4c=
X-Received: by 2002:a05:620a:2a08:b0:93a:c102:1123 with SMTP id
 af79cd13be357-93f57fa19edmr1039679785a.15.1792683296623; Thu, 22 Oct 2026
 08:34:56 -0700 (PDT)
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261021205626.3286270-1-suseendranb@google.com>
 <20261021205626.3286270-2-suseendranb@google.com> <atnFygk8xsQ-8Mj5@gondor.apana.org.au>
In-Reply-To: <atnFygk8xsQ-8Mj5@gondor.apana.org.au>
From: Yosry Ahmed <yosry@kernel.org>
Date: Thu, 22 Oct 2026 08:34:43 -0700
X-Gmail-Original-Message-ID: <CAO9r8zOtFTuPm_aR8wrzYsxzNGKQ9pUy76g0eNk_HsPmi6YW-A@mail.gmail.com>
X-Gm-Features: AclHuK9hNd1VMCyShZK7DRDesHpC0FNMFn7GHNLvz60HgwBJpHACrRofH5TH57I
Message-ID: <CAO9r8zOtFTuPm_aR8wrzYsxzNGKQ9pUy76g0eNk_HsPmi6YW-A@mail.gmail.com>
Subject: Re: [PATCH 1/2] crypto: return -ENOSPC on compression destination overflow
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Suseendran Bhaskaran <suseendranb@google.com>, Andrew Morton <akpm@linux-foundation.org>, 
	"David S . Miller" <davem@davemloft.net>, Johannes Weiner <hannes@cmpxchg.org>, Nhat Pham <nphamcs@gmail.com>, 
	Chengming Zhou <chengming.zhou@linux.dev>, Nick Terrell <terrelln@fb.com>, 
	David Sterba <dsterba@suse.com>, SJ Park <sj@kernel.org>, Chris Li <chrisl@kernel.org>, 
	Giovanni Cabiddu <giovanni.cabiddu@intel.com>, 
	Suman Kumar Chakraborty <suman.kumar.chakraborty@intel.com>, linux-crypto@vger.kernel.org, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Oct 22, 2026 at 1:14=E2=80=AFAM Herbert Xu <herbert@gondor.apana.or=
g.au> wrote:
>
> On Wed, Oct 21, 2026 at 08:56:25PM +0000, Suseendran Bhaskaran wrote:
> > In the acomp/scomp compression interface, callers pass a bounded
> > destination buffer and rely on the return code to distinguish a
> > destination buffer overflow (incompressible input) from genuine
> > compressor failures (such as invalid parameters, uninitialized state, o=
r
> > hardware errors).
> >
> > While the multi-segment streaming path in zstd_compress(),
> > crypto/deflate.c, and lib/842/842_compress.c returns -ENOSPC when the
> > destination buffer runs out of space, the single-buffer path
> > zstd_compress_one() (taken when input and output are contiguous single
> > pages, such as in zswap) as well as lz4, lz4hc, lzo, and lzo-rle return
> > -EINVAL instead of -ENOSPC on destination buffer overflow.
> >
> > For users such as zswap, which reduced its per-CPU compression buffer t=
o
> > a single page in commit 0b1bf60c324a ("mm/zswap: reduce the size of the
> > compression buffer to a single page"), incompressible pages typically
> > overflow the PAGE_SIZE destination buffer due to compressor header/toke=
n
> > overhead. Because these compressors return -EINVAL rather than -ENOSPC,
> > zswap cannot distinguish a destination buffer overflow from a compresso=
r
> > failure, causing broken debugfs error accounting (reject_compress_fail
> > vs. reject_compress_poor) or masking real compressor errors.
> >
> > Update zstd_compress_one(), lz4, lz4hc, lzo, and lzo-rle to return
> > -ENOSPC when the compressed output overflows the destination buffer,
> > matching the streaming path in zstd_compress(), deflate, and 842.
> >
> > Fixes: f5ad93ffb541 ("crypto: zstd - convert to acomp")
> > Signed-off-by: Suseendran Bhaskaran <suseendranb@google.com>
> > ---
> >  crypto/lz4.c     | 2 +-
> >  crypto/lz4hc.c   | 2 +-
> >  crypto/lzo-rle.c | 2 +-
> >  crypto/lzo.c     | 2 +-
> >  crypto/zstd.c    | 5 ++++-
> >  5 files changed, 8 insertions(+), 5 deletions(-)
>
> I can take this patch through the cryptodev tree.  Is that OK with
> you Yosry?

Thanks Herbert. I think we should wait to see how patch #2 turns out.
If I understand correctly, as of now patch #2 keys off -ENOSPC to make
a behavioral change in zswap, so the zswap patch would need to land
*after* this patch. Unless you want to fast track this to Linus right
away?
