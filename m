Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 094863D561
	for <linux-crypto@vger.kernel.org>; Sun, 25 Jan 2026 00:19:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.128.46
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769300371; cv=pass; b=nbmJnQ1XKq4WYZazltEOaKqD0TySiC/dIHV10hoJlLDnAR+d5P2uweQTYBOW0IvFgF4yeUdenCNWHjinLv8ZDR+fypJmv+EU4nDIBdIkP6wWQvOnig5Zd/HqcyRI69Hho6gzbDkc4FmzyMlqGq8Eyd0wqbKL/wlAUZLwTbndkhA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769300371; c=relaxed/simple;
	bh=If3fkU4YA4+MSsxYXa/lyK9BrLCbxbAeIY/q+H3wkxM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=FP1RVz+Bds+BH6MyAHkKfic+zQg/Du2h5qki0la4k+JPCgLJNoQsvkTLKoI6iRwHpz5yP8yjkgXLrntgwY0qp44CLLmYlbfqLi+yDJCszcBy/6LytwBFjTeFQimVPEXvBFsyfzYvSIMZqt7ZMYOZAy94ocJB/R5FeUdo1XkHgVk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=jEriKacV; arc=pass smtp.client-ip=209.85.128.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="jEriKacV"
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-47eddddcdcfso20124185e9.1
        for <linux-crypto@vger.kernel.org>; Sat, 24 Jan 2026 16:19:29 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1769300368; cv=none;
        d=google.com; s=arc-20240605;
        b=HQlusUeyTkX6ZRC5CH9GS8fe6b/0H0I32vOmaUYt+/Y2yY5Fsc01zSYRxChR+TeTkR
         /GufawJquZMJxKm+f83syo7dQIi9cwqmGdCXvhq0UZdvVe/DlXWLgMUeaZ7mlcNhvCVi
         SFLBCsgM9rHqmmP/QJn0WQecfEkzFyEoBCSrsiigx//bmj7XziY1IR4P9PoAQ3hy5WrH
         rsN8y68JdfwZUqQ/Yz73ew1za6sM/JviSbo5VBbxznHkHBqoyhDUUN405h9aNvzBISmV
         Zlf0Pgogp5TmP7XBKkfKwyOJwNxYNmd50jYmXMXVLr1QoaggRMs8abEb4v+z8hcxLInQ
         DBag==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=/cWk0M9f08GlkKjx4FmxOL3406KPYNW++Cx0SwVE/qw=;
        fh=SvoOADREIMDAuvqjRiqoOJUnUFGGV61ORGl3zjhnBNs=;
        b=OqSGv5yHdL3jzgBJ9jfPMtzLPPHl0TONiDiBB8EjEXzX1ViF8tm15o+hXjn0ZS1xH1
         rXfZO6+DRCzxhEsV/QrweUd3WCKN7f413q9TV+ybEsNpIneEeZt6/7CZDttOs55jveCk
         jpCeEibKXGO6p/DnHXWlqRvp0nFY9cAPhpJ7MTkuCV+tmnTdgitZ1ViHDFpDHrSKqzHA
         0b2fAayJxsVP3Qbo7ra9IwHmRFtwt1fDHjdTuZ0vs7dfxMqYIxBXj99xTIZBc+Xj1hdF
         dX7Iay+BxodvyDfkYP8LTfKYTyZD9iVkhFZyINuRc8m4hyoI27NURc31HQF9w5doRrwX
         YmVg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1769300368; x=1769905168; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/cWk0M9f08GlkKjx4FmxOL3406KPYNW++Cx0SwVE/qw=;
        b=jEriKacVJTI7Qv7KgOLtEBJcAv05zn6E8yhcP06r846B/37d9fi9XF+7GpFJAdqeDU
         x2pPwcLiUfuhZ2b/ZckwA2m0zZuDzHCYmnEBe4XOZBsXusJzvC776paS9NFkIrBQ93Cw
         iKJM9g9mPUhyRU+FOPofXJ5X21wyGF8orbBfiUZI19mGVga+jsKEaQKuToF+ys1orwyW
         0v3UXk4jbnYyxVJI5dF3JNxWER06OCjYjQpPIxwUod5yDPTn6Yr4WNRtjsqqpQFQxdxl
         AbKRfS+8tDAMsVMhlb04UdjXhhFMP8jUQvNGoaLQsa5ERAQ7VnmmtBriVlQ+nJ3mwEYw
         aUow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769300368; x=1769905168;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=/cWk0M9f08GlkKjx4FmxOL3406KPYNW++Cx0SwVE/qw=;
        b=gjz4hLZNIsRTuAGybeANQ4IcjiWw2qsmlsrExS82O2oTW8tcUZOrgedQcdINlqrUJS
         lPP9XaY+U2aIUFXkhf11GK7oBHsnhkvXbAs7luwv1p8HZxZkF2LGk7jZ8OKC6Lp+xFRQ
         PlHL39oTJOmWflo873xkfIh1KY/VZh0dootfppJiL3tPpnM13wBIAjpjwmySn8o+rP5k
         tLWapj3n+lOdQsJ6iPkJsMwYsC6NeahUY9t8oROBdUGeSffn6jaI3KHnTymjFwXIUBAY
         PYCwwPWSvLDmygxyTVprId3UhbWfkIihYqqssnq9jDUIcx89LsxsWMEJ+HZcpSpo5mRR
         TIPQ==
X-Forwarded-Encrypted: i=1; AJvYcCVTa2il659EsVEZtE+FBZ3m7Rfhlle/8A/Mx/mLzBvOBoYRXQSixeG15pJ0lczPb6BtB86HqNKyfkS52B8=@vger.kernel.org
X-Gm-Message-State: AOJu0YyOqNv1yP8+rhwvvAj1i5d8wMSBw1MDt0V6PImVAuYXVE//ylHO
	NkDWxB26ieDXXtfgL4aehBl8/6bj9iFcpt5Ssi5DYPGQjHKy8XCN2iQsVIlDblikLVoEAF6x7B+
	hRnsEXcyXxhw7xZ82RM1curKGXe0ahWc=
X-Gm-Gg: AZuq6aK234+sM47DLRK1fY0ktmZiYpgB91lzdazr4EPcgMl937Wun6HTiDAHlgEkbn9
	jLjcFVysV67feMjGt6d4NVkAiOuwshm4dOKMyBJQ9jBDazuV9MLn/Vl6gjFU6a3F+K4avqkmTUm
	3OahjojHPXB58t8Z0IopyO+KhZtd1AoP/L8rn5SWbWu/mUcBmTLtAoP9qxmzr6E40rGnf/RY3UF
	aMQtglspIYss8n40Yox+IZl+2BpvEMcr6zWrQiOe6wSjbDH+oE+mFs0rkqcphHDPOA9w/kSCa9x
	T0jhfFpVdk0KgEsDwcrJNoHjd86rlsGblNZvHw0Xq4tPslEB21PuiicSzY2ipobNOHMIqb0NSDQ
	Ge2l3U9Wm6et5mw==
X-Received: by 2002:a05:600c:1e0f:b0:47e:e807:a042 with SMTP id
 5b1f17b1804b1-4805ce50189mr4505125e9.15.1769300368107; Sat, 24 Jan 2026
 16:19:28 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260124174349.16861-1-git@danielhodges.dev> <20260124174349.16861-5-git@danielhodges.dev>
In-Reply-To: <20260124174349.16861-5-git@danielhodges.dev>
From: Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date: Sat, 24 Jan 2026 16:19:17 -0800
X-Gm-Features: AZwV_QjrseQV1Yh7RsryydskQrmIxIwJ1Lh1IXL8EzEcg7C91ASKKQZu5jxevv0
Message-ID: <CAADnVQJQsC0cQZPJpyofY4Othi5+j7xjAY+xbNRkX0p9wA7Khg@mail.gmail.com>
Subject: Re: [PATCH bpf-next v6 4/4] selftests/bpf: Add tests for signature
 verification kfuncs
To: Daniel Hodges <git@danielhodges.dev>
Cc: bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>, 
	Andrii Nakryiko <andrii@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>, 
	Vadim Fedorenko <vadim.fedorenko@linux.dev>, Song Liu <song@kernel.org>, 
	Mykyta Yatsenko <yatsenko@meta.com>, Martin KaFai Lau <martin.lau@linux.dev>, Eduard <eddyz87@gmail.com>, 
	Hao Luo <haoluo@google.com>, Jiri Olsa <jolsa@kernel.org>, 
	John Fastabend <john.fastabend@gmail.com>, KP Singh <kpsingh@kernel.org>, 
	Stanislav Fomichev <sdf@fomichev.me>, Yonghong Song <yonghong.song@linux.dev>, 
	Herbert Xu <herbert@gondor.apana.org.au>, "David S. Miller" <davem@davemloft.net>, 
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, 
	"open list:KERNEL SELFTEST FRAMEWORK" <linux-kselftest@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, Jan 24, 2026 at 9:44=E2=80=AFAM Daniel Hodges <git@danielhodges.dev=
> wrote:
>
> Add tests for the signature verification kfuncs:
>
> 1. test_ecdsa_verify_valid_signature: Verifies that a valid ECDSA
>    signature over a known message hash is correctly verified using
>    the P-256 curve with a test vector.
>
> 2. test_ecdsa_verify_invalid_signature: Verifies that an invalid
>    signature (with modified r component) is correctly rejected.
>
> 3. test_ecdsa_size_queries: Tests the bpf_sig_keysize(),
>    bpf_sig_digestsize(), and bpf_sig_maxsize() kfuncs to ensure
>    they return valid positive values for a P-256 ECDSA context.
>
> 4. test_ecdsa_on_hash_ctx: Tests that calling bpf_sig_verify on
>    a hash context fails with -EINVAL due to type mismatch.
>
> 5. test_ecdsa_keysize_on_hash_ctx: Tests that calling bpf_sig_keysize
>    on a hash context fails with -EINVAL due to type mismatch.
>
> 6. test_ecdsa_zero_len_msg: Tests that zero-length message is rejected.
>
> 7. test_ecdsa_zero_len_sig: Tests that zero-length signature is rejected.
>
> The test uses the p1363(ecdsa-nist-p256) algorithm with a known
> NIST P-256 test vector for reliable and reproducible testing.
>
> Signed-off-by: Daniel Hodges <git@danielhodges.dev>
> ---
>  MAINTAINERS                                   |   2 +
>  .../selftests/bpf/prog_tests/sig_verify.c     | 163 ++++++++++
>  .../selftests/bpf/progs/crypto_common.h       |   6 +
>  .../testing/selftests/bpf/progs/sig_verify.c  | 286 ++++++++++++++++++
>  4 files changed, 457 insertions(+)
>  create mode 100644 tools/testing/selftests/bpf/prog_tests/sig_verify.c
>  create mode 100644 tools/testing/selftests/bpf/progs/sig_verify.c

It's a v6 already, but your new selftests are still failing in CI.

Error: #385 sig_verify
Error: #385/1 sig_verify/verify_valid_signature
Error: #385/3 sig_verify/size_queries
Error: #385/6 sig_verify/zero_len_msg
Error: #385/7 sig_verify/zero_len_sig

Please make sure CI is green before submitting v7.
No one is reviewing the patches when they don't pass their own tests.

pw-bot: cr
