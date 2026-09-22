Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B53F2F361E;
	Tue, 22 Sep 2026 05:07:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790053647; cv=none; b=uxqGzUjQDuA2FAvfnePJJIZNAysGHq7QHDffSAN4qX8J6mDzZ7vHQaj/kK8O1uHikD1/ql2HEfIHmLDywFUEGXJPa1z5qOLWqtXGEWmJanEm9HisTIxj/yWR+UJi5BXAHg/2UV/c/Heqk6CNbd8rBbTbccoVqK4Vy+784fQlRlw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790053647; c=relaxed/simple;
	bh=sjbDoWKEUEHVNkG3NOt3DuPlx9rK3aMVhzLwa2NJJYY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jisXNpOVvebig7Oh4Gpz6vTdJJvYPcLHr4f/o+yNU8M6RA6skwn7sbQiZfLDBdLPxTM7OJIKHwoMeJP68/yJ7APqpX5h6YNNIgaGtg5Uf8DFimg8trSoiFw42T7f2IGo4TLL4OK/7p5x3AoYI1PJQNFGFzO+gYXrThoAaP8jNaQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=CRT0G2Cq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CRT0G2Cq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 653681F000FF;
	Tue, 22 Sep 2026 05:07:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790053645;
	bh=kd7CjQmdmHn87w994K+PIbPON99KOZaOEujJNVw6QnE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=CRT0G2CqJSiIVg/QCFrAggOMzz6Iu2UzzzKJ4ipgSMGvakZ+cH73BEzwkyDgp1Dal
	 nwKZHEvdBYIQPeezSRQbSWwWNUKedTH/cYQJXrzyv4GV38BqyA1zGZY96+G5812uyd
	 RpdgzWsLWWp37B3uC3SsERHFS4cjmX/2X71THerMSwVdHCif71q4VRrmdB6KbE8sm8
	 BaHvvFypOveyj4ir6rLsaBkoA6zQUFOmoBAVgwGbwKXiq9zRlfRInp/HVQJV/X5IF6
	 PYUWxeM/njr0qeTLRmYD1FTwGLiGQIUCejpnbjUD09epAz5OtO5qCu/XaTaJMF6xZg
	 yKHlpAy81g3jQ==
Date: Mon, 21 Sep 2026 22:07:23 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc: bpf@vger.kernel.org, Vadim Fedorenko <vadim.fedorenko@linux.dev>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Andrii Nakryiko <andrii@kernel.org>,
	Eduard Zingerman <eddyz87@gmail.com>,
	Kumar Kartikeya Dwivedi <memxor@gmail.com>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	Martin KaFai Lau <martin.lau@linux.dev>, Song Liu <song@kernel.org>,
	Yonghong Song <yonghong.song@linux.dev>,
	Jiri Olsa <jolsa@kernel.org>,
	Emil Tsalapatis <emil@etsalapatis.com>,
	Ihor Solodrai <ihor.solodrai@linux.dev>,
	John Fastabend <john.fastabend@gmail.com>,
	Karl Mehltretter <kmehltretter@gmail.com>
Subject: Re: [PATCH bpf-next v3] bpf: crypto: Use AES-CBC and AES-ECB
 libraries
Message-ID: <20260922050723.GA14616@sol>
References: <20260922040413.28885-1-ebiggers@kernel.org>
 <DLLKN9WTMVHD.1601DUU5LBVAB@gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DLLKN9WTMVHD.1601DUU5LBVAB@gmail.com>

On Tue, Sep 22, 2026 at 04:48:02AM +0000, Alexei Starovoitov wrote:
> On Mon, Sep 21, 2026 at 09:04 PM Eric Biggers <ebiggers@kernel.org> wrote:
> > +config BPF_CRYPTO
> > +	def_bool y
> > +	depends on BPF_SYSCALL
> > +	depends on CRYPTO_LIB_AES_CBC
> > +	depends on CRYPTO_LIB_AES_ECB
> 
> This will break the build with CRYPTO_AES=m.

No, the new implementation only calls library code.  And if that library
code isn't built-in, then this just doesn't get built at all, as per the
'depends on' lines.

I'm not sure what you expected.  This could be a tristate, but that
would mean it would be its own module, which doesn't seem conventional
for kfuncs.

> >  struct bpf_crypto_ctx {
> > -	const struct bpf_crypto_type *type;
> > -	void *tfm;
> > -	u32 siv_len;
> > +	enum bpf_crypto_algo_id algo;
> > +	void *key;
> 
> No need for this. The bot was wrong.
> Reading any field of struct bpf_crypto_ctx requires CAP_PERFMON.

Okay, it sounded like a weird BPF quirk where the type system was being
used to enforce a security boundary.  But if it's not needed, then
that's helpful.  I'll go back to the original struct embedding.

- Eric
