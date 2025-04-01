Received: from mail-qv1-f54.google.com (mail-qv1-f54.google.com [209.85.219.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D197E1F1538;
	Tue,  1 Apr 2025 11:13:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743506015; cv=none; b=f/ct/+VNsWC3ak2e+SD6AuHaWM3BqA4JPE2N4UTPPzJtQ/ac9koktRau4jqkSO1ebzV178Zo6LW2Z1vIcMZPLkdS3HSPzuG5L2ycDBOqZnvd34mrUBchKu2X/aFKOIkexachb4IL6I5Yun2JNa/3A9dew1dohW9S00hJ1Ia+y3A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743506015; c=relaxed/simple;
	bh=zec2RCMRClZzaBv/89qRA4s9VgNbDdJvUtT/oGpfa0M=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=MszKzXHeTQRzNndG2cLaGGfSgVLXJjvsGcHJAD0F3q1LQCKPKhab93ytE2rLk0mtmc5M1eWlm5lKz1Ap0IQ1+aU+eUo+ZRPNUrAi4iWDlnhrhPIGjpCr3DUxD9YJyk7u9std69/JzRf09Lhm4Hkcm6pBwZs9DQqN4LB8XH8ZkCU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=UYMc9aDN; arc=none smtp.client-ip=209.85.219.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="UYMc9aDN"
Received: by mail-qv1-f54.google.com with SMTP id 6a1803df08f44-6e8f6970326so49384666d6.0;
        Tue, 01 Apr 2025 04:13:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1743506013; x=1744110813; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=RhXqDSYOjOxsXszNE/hmSOtQ7jPTUIhg+8zdDPCBQfc=;
        b=UYMc9aDNiwqovMueI62zukva+vdV56t4tZk4gwcthpu+qF5b+LyWqLWrXMOhnr9xqU
         ajTuUOZ70kIbvLL+2/6JsCCXZxBbsNHX1VOd1gDSOkHPCkNqQSRNmvEZsjC982ec+DxT
         eJtCEfaFmIX1LiO3WE7YrieXDv8ozhU8ckgBAg3jQEKktlKuz7OcVng0Y/DLFiT8vR/B
         NxDiMiW8HqyF9E0S62QHoREoUVaIWNRUh0QloQjqYm7mqjJ0zugaqUymPfwF5o1Ke1Ex
         cxx1Uc8aSVnZJm8xPyVQa9FyOMPitQOqIMmAwEJD6XJbIJRPy6eWJpwYZ3tUFYetCo/o
         /Atw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743506013; x=1744110813;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=RhXqDSYOjOxsXszNE/hmSOtQ7jPTUIhg+8zdDPCBQfc=;
        b=d3qINMwkB5OKYZYPBUPrz0S2tEck85sM/IzhgF7Guvj+BI92JVvMCZydfx2+gP3HlW
         Eu5bocx99c9J1lhnRZF2hJ00ye0TVH6uGhWzoNrI6DVGYwFP5ygYt/ZQ9DLRVNFGY7dt
         9fLw052c9ODJ1mHcepqGjuBXlHdWQjnm90DTTFvIDncqkxzbrQxdIXoY6MWzsMSbc3sS
         obdeR/qDhpCYlF06e4ojX9Dpm0muMOoFidY1AEg9j8FsxIX7NYsZHbcaw1lxz9n6kbDo
         2AwI8UiTCmko90NNJSOqgrmMAlhDMLku8PKj9pJ5LbXxd23Vw4qSbgygE/tFe9yH6TTZ
         qdLA==
X-Forwarded-Encrypted: i=1; AJvYcCVfs3ho3ObqNMALh6oKgZvdRHjS66d5UP8xS6otl5R838MVmvwGEVL3dhBGa7NsYd+W8qT4hkr9YM4F@vger.kernel.org, AJvYcCWmLPNYHJdnc6r67+FkIocT5gAZVvhqH23FvVryJVv9xrroce4lFNbwgmmKft07Z4schiDkaI7PfveV+GYL@vger.kernel.org, AJvYcCXTZwdDJ6R2dQ5RIJpLNxONGT9gbKf6CdQWDVqw9S1JM/4unCk8Gm+STscC0GR34zjxRTJAEVsZyHIrBPnQ@vger.kernel.org
X-Gm-Message-State: AOJu0YyCuxkyaQmOKMFszQQKrsQ1DsIZcQ8kaOHDq6DPzrewlnGsgP3q
	/f9net6aKv4K2EdLqyD0dNWDhzJoLPhmeS2oUr2+y5W7F3MxzU4+U+DGXhfdsuVk8kWmdpxdRz2
	p4gna2wovwZfcRox2I51z9uqG7Ug=
X-Gm-Gg: ASbGncueGdnHqaRp9I0ZPpvbJEgHJZr4ZCYufcrPQKx1sPVvUGqdNoKEz86pY6fLhtO
	mtYLXizNlH6wv8LP1uI8QFuzHqGdtDM18/x+E2j0wqcvtrRS0afmvaqbzM6CwzN/MgtTvLs/imM
	hlyNJaThLj9nHNddkJXe2TuZk4
X-Google-Smtp-Source: AGHT+IHo5fEJFngga4+GOhfC2NhUrJuj08Wu097yQz8MreDqZ8dmYQnArSlhZCL4U3YiLwUMSk6CWpiamq4vswZAjMU=
X-Received: by 2002:a05:6214:1301:b0:6e8:e828:820d with SMTP id
 6a1803df08f44-6eed6226e16mr263447586d6.36.1743506012761; Tue, 01 Apr 2025
 04:13:32 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250114123935.18346-1-ansuelsmth@gmail.com> <20250114123935.18346-4-ansuelsmth@gmail.com>
 <Z-vFkUmd6vgciU6V@gondor.apana.org.au>
In-Reply-To: <Z-vFkUmd6vgciU6V@gondor.apana.org.au>
From: "Christian Marangi (Ansuel)" <ansuelsmth@gmail.com>
Date: Tue, 1 Apr 2025 13:13:21 +0200
X-Gm-Features: AQ5f1JrMsiz9OVJ4AuViP6vrfqHG0abox8RT085aKR8cHOMDja2lm3-nBFW-_go
Message-ID: <CA+_ehUy0qHfQseVv4D4BbZa+wHKTCvY9dVNfUtcDF3x7XHss0Q@mail.gmail.com>
Subject: Re: [PATCH v11 3/3] crypto: Add Inside Secure SafeXcel EIP-93 crypto
 engine support
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: "David S. Miller" <davem@davemloft.net>, Rob Herring <robh@kernel.org>, 
	Krzysztof Kozlowski <krzk+dt@kernel.org>, Conor Dooley <conor+dt@kernel.org>, 
	Antoine Tenart <atenart@kernel.org>, Peter Zijlstra <peterz@infradead.org>, 
	Ingo Molnar <mingo@redhat.com>, Will Deacon <will@kernel.org>, Waiman Long <longman@redhat.com>, 
	Boqun Feng <boqun.feng@gmail.com>, Nathan Chancellor <nathan@kernel.org>, 
	Nick Desaulniers <ndesaulniers@google.com>, Bill Wendling <morbo@google.com>, 
	Justin Stitt <justinstitt@google.com>, linux-crypto@vger.kernel.org, 
	devicetree@vger.kernel.org, linux-kernel@vger.kernel.org, 
	llvm@lists.linux.dev, upstream@airoha.com, 
	Richard van Schagen <vschagen@icloud.com>
Content-Type: text/plain; charset="UTF-8"

Il giorno mar 1 apr 2025 alle ore 12:53 Herbert Xu
<herbert@gondor.apana.org.au> ha scritto:
>
> On Tue, Jan 14, 2025 at 01:36:36PM +0100, Christian Marangi wrote:
> >
> > +static void eip93_hash_export_sa_state(struct ahash_request *req,
> > +                                    struct eip93_hash_export_state *state)
> > +{
> > +     struct eip93_hash_reqctx *rctx = ahash_request_ctx_dma(req);
> > +     struct sa_state *sa_state = &rctx->sa_state;
> > +
> > +     /*
> > +      * EIP93 have special handling for state_byte_cnt in sa_state.
> > +      * Even if a zero packet is passed (and a BADMSG is returned),
> > +      * state_byte_cnt is incremented to the digest handled (with the hash
> > +      * primitive). This is problematic with export/import as EIP93
> > +      * expect 0 state_byte_cnt for the very first iteration.
> > +      */
> > +     if (!rctx->len)
> > +             memset(state->state_len, 0, sizeof(u32) * 2);
>
> I don't understand when this can occur.  As far as I can see,
> zero-length packets are never passed to the hardware for hashing.
>

I did some extra check on this and you are right. This was a leftover
(and discovery) when we were discussing on how to correctly
implement import/export.

My initial idea was to send a zero packet on export to sync and wait
for DMA to finish. But this was scrapped in favor of -EINPROGRESS
in the update function (that wasn't aware of possible)

If you are ok I can send a patch to drop this (and maybe leave the
comment just to document this strange finding)

What do you think?

> > +     else
> > +             memcpy(state->state_len, sa_state->state_byte_cnt,
> > +                    sizeof(u32) * 2);
>
> I need to know the endianness of state_byte_cnt, which I presume
> is the number of bytes that have been hashed into the partial
> hash state.

It's LE.

>
> I need this because I'm changing the export format of all ahash
> algorithms to match that of the generic implementation.  This is
> so that you can seamlessly switch between an async ahash and its
> sync fallback.
>
