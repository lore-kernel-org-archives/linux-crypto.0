Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792707598;
	b=X0lNzt4NPYq0CO/V8qfzHhHQTQ44Czn4jBYeN7krQC64m2XQ0oQpn3K4KdPQTLhPoFd5
	 553LgrnSURlBVyFfU7Z85MlMMyGzpHq07k3cgvkTlSzGOPNniHtqcyv+mEEozNO9uR6uV
	 skMpbHS5mnq0ATBhoa7yuNItDo5zQNtQqIcW8rhnARQWRccn7PPN566B/edN3CY5qaVp9
	 ges73atMCDLhfQNkA8BFP/6vx3fOqBUUJmYBK0c9OVvn7mMs5zJxFXdffQUQNmysMMTrk
	 YGDPSrdLQNlUqDjHvYESUN9z9PstdTNeBHPBUjHuvYC67Mh1yscofREIXkrZLiPy9YA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792707598;
	h=Received:DKIM-Signature:Received:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Received:MIME-Version:References:In-Reply-To:
	 From:Date:X-Gmail-Original-Message-ID:X-Gm-Features:Message-ID:
	 Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=ZWgLZl94yfWWHBwe8ZSS9sK2vaYD91ERYkHK7zkpQtw=;
	b=W1UioW7QNvGlBDm5dIXyVCECOrBIhyNla/3uwvwPJBPirzTtK0eYfgZrtAvErHE/YJsB
	 UQ3Xeh78XlivR/j9UkYaAY83SZ5ESDhZhLLscv5+JAuBx0/cRhKVPbheGoL0wuCRZ1mhj
	 28PgcD/PRAsoC55JUZpEJGpO+ENB1JxVfU35wjbAzdqIqYoJ0cY2UoosaeyScBgelGZGt
	 hhlnlGmUxxHc0JCIEBKigqoQjh7ZRqy/EpOCQkCrNbnFARZn4XpOlaTt1nu8HXpTVtBIU
	 MsoZZ2tQ81w4gjvCTS7/WoDKxf6Pcn+90qTmwdMkJcqU4U8oau9V1LdiOFXZ3WQlAgA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=G5T8AON7;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B562E606A31A
	for <linux-crypto@vger.kernel.org>; Thu, 22 Oct 2026 22:19:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=G5T8AON7
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5737E1F031E4
	for <linux-crypto@vger.kernel.org>; Thu, 22 Oct 2026 22:19:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792707597;
	bh=ZWgLZl94yfWWHBwe8ZSS9sK2vaYD91ERYkHK7zkpQtw=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=G5T8AON76TT8gpbtQKF1JmSrAGG4M04UAl1w44ScxNRfkcmxSCfhB7F6cwnZMhdCO
	 GAhukxyV0WSYVhpoOqtgeBhLi0Zrn0Yatc48REFP4fyQKaGekhsGhgaUS9GuQ/MKPq
	 p8ARJPktwuv1Psg6ZwYHKeAOKhBV6rw0bVEQY3c1EVLqam9PYAHYc9JexIFE4PUJPj
	 dq+yfp0eVzJO4f2kkv9JlEIHWhMASTAge/qL7i1hs/j2C7ZTmhtha/zSK99l11vaGd
	 Er2n1t8jFBibCZz4/vOM6NM7uv5z6+Ha9uJSGTengjCvjcNjAdj701gdyP4F63OIHx
	 WI4YS4cw1ZNXg==
Received: by mail-ej1-f45.google.com with SMTP id a640c23a62f3a-c4203bbb1e9so44941866b.3
        for <linux-crypto@vger.kernel.org>; Thu, 22 Oct 2026 15:19:57 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBxX68O1ewY5MlRGw4LN85LE2WUYwzMKpvOBXCH6N0pPKL6SPBTd7OIj+1a9XuadOw1kgnea/BCjnSVSqX4=@vger.kernel.org
X-Gm-Message-State: AFq9FYJr6SDKAlm3DlPbNUbP1UOJsgp5qWpSYBNPPzT+C666+SasrIZ+
	guyOp3N0mCPo33eOX7+JDiXdedYtQvcWXlv6kLan12q3mhSnVQRmQTCM5++1dUTr/kM43JyXRYH
	ig95cZH1RS693o8/CgCPUcD7p4nDJW8c=
X-Received: by 2002:a17:906:9f8b:b0:c43:6d40:4f84 with SMTP id
 a640c23a62f3a-c46a8d5e426mr93984966b.4.1792707596230; Thu, 22 Oct 2026
 15:19:56 -0700 (PDT)
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
 <CAO9r8zOtFTuPm_aR8wrzYsxzNGKQ9pUy76g0eNk_HsPmi6YW-A@mail.gmail.com>
In-Reply-To: <CAO9r8zOtFTuPm_aR8wrzYsxzNGKQ9pUy76g0eNk_HsPmi6YW-A@mail.gmail.com>
From: Yosry Ahmed <yosry@kernel.org>
Date: Thu, 22 Oct 2026 15:19:45 -0700
X-Gmail-Original-Message-ID: <CAO9r8zP2cNFQ=CW4LZ0ttXtr3Q2PLs4A=rgMDZoSo=JVNuYpKA@mail.gmail.com>
X-Gm-Features: AclHuK8jTz73VDjeomuMASBJUg8buDlto1wF_KsKwup243lKYN2RVWgimlLIvpQ
Message-ID: <CAO9r8zP2cNFQ=CW4LZ0ttXtr3Q2PLs4A=rgMDZoSo=JVNuYpKA@mail.gmail.com>
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

On Thu, Oct 22, 2026 at 8:34=E2=80=AFAM Yosry Ahmed <yosry@kernel.org> wrot=
e:
>
> On Thu, Oct 22, 2026 at 1:14=E2=80=AFAM Herbert Xu <herbert@gondor.apana.=
org.au> wrote:
> >
> > On Wed, Oct 21, 2026 at 08:56:25PM +0000, Suseendran Bhaskaran wrote:
> > > In the acomp/scomp compression interface, callers pass a bounded
> > > destination buffer and rely on the return code to distinguish a
> > > destination buffer overflow (incompressible input) from genuine
> > > compressor failures (such as invalid parameters, uninitialized state,=
 or
> > > hardware errors).
> > >
> > > While the multi-segment streaming path in zstd_compress(),
> > > crypto/deflate.c, and lib/842/842_compress.c returns -ENOSPC when the
> > > destination buffer runs out of space, the single-buffer path
> > > zstd_compress_one() (taken when input and output are contiguous singl=
e
> > > pages, such as in zswap) as well as lz4, lz4hc, lzo, and lzo-rle retu=
rn
> > > -EINVAL instead of -ENOSPC on destination buffer overflow.
> > >
> > > For users such as zswap, which reduced its per-CPU compression buffer=
 to
> > > a single page in commit 0b1bf60c324a ("mm/zswap: reduce the size of t=
he
> > > compression buffer to a single page"), incompressible pages typically
> > > overflow the PAGE_SIZE destination buffer due to compressor header/to=
ken
> > > overhead. Because these compressors return -EINVAL rather than -ENOSP=
C,
> > > zswap cannot distinguish a destination buffer overflow from a compres=
sor
> > > failure, causing broken debugfs error accounting (reject_compress_fai=
l
> > > vs. reject_compress_poor) or masking real compressor errors.
> > >
> > > Update zstd_compress_one(), lz4, lz4hc, lzo, and lzo-rle to return
> > > -ENOSPC when the compressed output overflows the destination buffer,
> > > matching the streaming path in zstd_compress(), deflate, and 842.
> > >
> > > Fixes: f5ad93ffb541 ("crypto: zstd - convert to acomp")
> > > Signed-off-by: Suseendran Bhaskaran <suseendranb@google.com>
> > > ---
> > >  crypto/lz4.c     | 2 +-
> > >  crypto/lz4hc.c   | 2 +-
> > >  crypto/lzo-rle.c | 2 +-
> > >  crypto/lzo.c     | 2 +-
> > >  crypto/zstd.c    | 5 ++++-
> > >  5 files changed, 8 insertions(+), 5 deletions(-)
> >
> > I can take this patch through the cryptodev tree.  Is that OK with
> > you Yosry?
>
> Thanks Herbert. I think we should wait to see how patch #2 turns out.
> If I understand correctly, as of now patch #2 keys off -ENOSPC to make
> a behavioral change in zswap, so the zswap patch would need to land
> *after* this patch. Unless you want to fast track this to Linus right
> away?

Patch 2 will be re-sent separately, so please feel free to take this
patch as-is. Thanks!
