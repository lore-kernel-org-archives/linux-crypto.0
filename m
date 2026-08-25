Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 663D03DAADC
	for <linux-crypto@vger.kernel.org>; Tue, 25 Aug 2026 22:27:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787696858; cv=none; b=lBzh4OnPag8kuUWzP4FOgb9Xp0lU71j9vZtRTXAuJ46ux2QfVoKB2jjEBp3ZvHe5OFjRO4Mtvd1eOEUkASB6gsntp6RwccNRFjB3sKdF/Pa1Tvmmed8czGmud06JEbhszhV3BmziOQ/uVKGBF94+Zd+gKYwa5DDFSJXIe9tVx3I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787696858; c=relaxed/simple;
	bh=5vU0R5kfNZwgo3nKYBQogGdReMpN2G938d603wG3K5s=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=QtXxsLZeityJfeSKw5b2fnPiCEYTGzWaMPmOnS2kZVSidNvOnXco5821ocysJmB3XYz20SsqiQ3UvRHqQahpjFw3KPq2mnI0ZpzgWBOuKzsDaGnWLsSDf4I02rD7NRsNEKbX9HSQJAzgibHr4OCEtn7YwbUOAIk0xPmsHdo7nWo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NT2YNA5d; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NT2YNA5d"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 140FF1F00ADF
	for <linux-crypto@vger.kernel.org>; Tue, 25 Aug 2026 22:27:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787696857;
	bh=KGq9Hqkpmq5BMeuiGjVK3uoE8FWrIGQL0Y8Z+rn0EbA=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=NT2YNA5d+laDPujqDF78WJG7ISpb4SUmWWOxh7Wtga1QJE/+VOYhFjZjOAdFw3suT
	 BLZTEqdYWWYjdCNMlS3N7T/ItxG42VAEtTbiSuwPeoI7Dl1jzPf34hSL9/iqtRR0HQ
	 yq+0cjnJIccPplE7wIwPvgQ+RSxOuY3CDfBZu30DX0ayhme3R+G+h5VPcTCS0/xAoB
	 WcrvYjuphMU/iKfA+BjIbCgNcKLEvnGfjSJoUJOjTm0SLvl8cFZgtybJHol8ymonGe
	 djEMcArj8cCf0l86VWmXVK1fHrgT4Z+LzzaW36ahoGigyGB8Uo6xDAGLxPiCQfu7gs
	 OAGMDHza1dAgQ==
Received: by mail-ej1-f51.google.com with SMTP id a640c23a62f3a-c250c6a6a6eso41986266b.0
        for <linux-crypto@vger.kernel.org>; Tue, 25 Aug 2026 15:27:37 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+RoA9owegv/mPjt4dW42Ob6s1BMiSnU4yWLKQHrNMDYUjMEEl3QsEPay2KkPiC07L9m133Mn+Ncdwqih34g=@vger.kernel.org
X-Gm-Message-State: AFuF++naw8eg7GlmO+JVwbBL3XLSR8lNv1V6ZF9RdCKesPCUskTu6SAg
	mHuY3agzRrv17LMPsBHtxXwjE8V/65FBQExU7w82lauanYy4LTrtosJ4BFsEUTh8zQuKtAAReon
	wFVl5fMt78cBmVU120bluOmL0pWs/ylY=
X-Received: by 2002:a17:907:3cd6:b0:c25:10a:4020 with SMTP id
 a640c23a62f3a-c250c3087ecmr190496566b.16.1787696855927; Tue, 25 Aug 2026
 15:27:35 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260825220616.3842633-1-usama.arif@linux.dev>
In-Reply-To: <20260825220616.3842633-1-usama.arif@linux.dev>
From: Yosry Ahmed <yosry@kernel.org>
Date: Tue, 25 Aug 2026 15:27:24 -0700
X-Gmail-Original-Message-ID: <CAO9r8zP2FLCN5N3pJR=EiNW2ykF0mwSR8fwMXPXp6SdcPd82jA@mail.gmail.com>
X-Gm-Features: AcwNN1UBpQJwXsuf5YSne3FgQdyyuYCd0VpkQmsvDh5Nsgjv2HBYs2G1N4wAKEE
Message-ID: <CAO9r8zP2FLCN5N3pJR=EiNW2ykF0mwSR8fwMXPXp6SdcPd82jA@mail.gmail.com>
Subject: Re: [PATCH 0/2] crypto: zstd - avoid initializing the workspace twice
To: Usama Arif <usama.arif@linux.dev>
Cc: davem@davemloft.net, dsterba@suse.com, 
	Herbert Xu <herbert@gondor.apana.org.au>, linux-crypto@vger.kernel.org, 
	linux-kernel@vger.kernel.org, terrelln@fb.com, hannes@cmpxchg.org, 
	nphamcs@gmail.com, chengming.zhou@linux.dev, shakeel.butt@linux.dev, 
	kernel-team@meta.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Aug 25, 2026 at 3:06=E2=80=AFPM Usama Arif <usama.arif@linux.dev> w=
rote:
>
> Both zstd_compress() and zstd_decompress() set up the shared per-CPU
> workspace as a C/DStream before walking the request, and then, when the
> first source and destination fragments each span the whole request, hand
> off to zstd_compress_one()/zstd_decompress_one(), which immediately
> overwrite that same ctx->wksp with a CCtx/DCtx. The stream setup is
> discarded without a byte having been processed.
>
> That one-shot path is not a corner case: zswap always takes it when
> storing, and takes it for a load whenever the stored object lies within a
> single zsmalloc page.
>
> These two patches defer the stream initialization to the first walk
> iteration that actually streams, guarded by a flag because that iteration
> can be reached more than once.
>
> A 4 KiB crypto_acomp benchmark [1], twelve runs of nine 30,000-operation
> rounds. Bare metal is an Intel Xeon Platinum 8321HC, turbo off,
> performance governor, pinned to one core; the VM is a one-vCPU KVM guest
> on a faster host.
>
>                   baseline    patched     delta
>   bare metal
>     compress      52,283 ns   51,038 ns   1,245 ns   2.4%
>     decompress     2,317 ns    1,998 ns     319 ns  13.8%
>   one-vCPU KVM
>     compress      16,675 ns   15,050 ns   1,625 ns   9.8%
>     decompress     3,516 ns    2,265 ns   1,251 ns  35.6%

Nice!

>
> The guest numbers are larger because the two CPUID instructions in
> ZSTD_cpuid() become unconditional VM exits there.

I wonder how much benefit we get from just doing CPUID once in
ZSTD_cpuid() and cache the results. There might still be value in
avoiding the overall initialization, but I think ZSTD_cpuid() should
only be executing CPUID once anyway (e.g. in case it's called in other
paths)?

>
> [1] https://gist.github.com/uarif1/5cf02f0e22c23f0d1b3d84348f12914c
>
> Usama Arif (2):
>   crypto: zstd - Avoid redundant cstream initialization
>   crypto: zstd - Avoid redundant dstream initialization
>
>  crypto/zstd.c | 40 ++++++++++++++++++++++++++++------------
>  1 file changed, 28 insertions(+), 12 deletions(-)
>
>
> base-commit: 4b18edbd8e70f7e6860d56370f13244896d0f95c
> --
> 2.53.0-Meta
>
