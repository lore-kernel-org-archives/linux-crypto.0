Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793371765;
	b=X1QuBpZrFEUWUk4Flb5bImrGTfopLlZ3EJiWo+mPtayfHnlkcQNJJKAh1Igd3lcrhKpH
	 oi2ekszLHQRoCzyhURv+4V7dXzXlabSUJIJnC2Ak0OuPe/PzNUVmhCfqOVpF8BpaSrTXf
	 GXNllckU8Qdr3s6I5ajEUG2AjqN1gYnuLcQPhAHnjK8PyDoRSS/dV4Ao6DKbTc5AVd65r
	 GjmAWNAPOh2AZsC7b/lrnIuP3gQU7vBUawbsRhJkkwyRKDIBSwswbutULGqME+UqUQ+p+
	 4h4ezFVSdllisIt8RrDF89bGSwZKWKjUhUJrSthMAAsFy7eWkAW01sfS6rmyv0X0bSQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793371765;
	h=Received:DKIM-Signature:Received:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Received:MIME-Version:References:In-Reply-To:
	 From:Date:X-Gmail-Original-Message-ID:X-Gm-Features:Message-ID:
	 Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=0TQjte6CqBgM+wFSxhT/bgRaDtwXwwSO4uSgCgPB3OY=;
	b=N+LWdHEb81LvGmunpTvb8RFmn87X/EpCXePOUMPOOuhVdV7kE7dSg20NUc6AIWvBJOG7
	 jycuckXnWDc9+SnBvecUJ65FGuBmzuIXBOx7EPj/yNHaWrVhG9ovBmw6LgCyzRnHeS8WP
	 XCPFQ5OV4fwSSAImJTwKpDp3PHjVnmz9uGgjb8OAw4w4nm3gVMsaO7BjmPBEwRpRausYp
	 cmxKy3bT6YSN+JDqfsOpu9eqy6DKmxFQZ76lfP4tNQL4pcxuAqddLJeiJK0OtmX+VViql
	 oW6ylueTqr4OPSCe7K5eP1ti0WdP1LUUATFvN+guD2FFMUUEaCxAYEVrdApA5NPWNCQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=NA1m8gVY;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32CF1606A31A
	for <linux-crypto@vger.kernel.org>; Fri, 30 Oct 2026 14:49:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=NA1m8gVY
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3A8B1F00A1D
	for <linux-crypto@vger.kernel.org>; Fri, 30 Oct 2026 14:49:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793371764;
	bh=0TQjte6CqBgM+wFSxhT/bgRaDtwXwwSO4uSgCgPB3OY=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=NA1m8gVYHOCdqHGrZ4A/CsTsWNYOnrQL/kvNqYRh855w0eE48qkiEbOD/mUSAQJs8
	 THi9A92uzFqXpL7REevNWMot+i0pxkE0Xz+q3vi9EvINUn3EcRXGZ67OxqbH52OCGj
	 YEqxEc1/aQg9ETlfCD/kkezGO4FD1hN3Al4UcskSYIHPj9LFrLy7b99XqYU4NRSEHD
	 lFunqd0Ki4rXYamLX95N8zKRGOHlg365oDaDLMoe35BHu3j9X+tvaNmY3o6zBj5ImX
	 hTN8QnEdpiUj9nDiIhkAMojiIysBntHAy98ofps5LHCuIWmkrsK3dZP/jqUhOWqi32
	 ofF2caZU1LBfg==
Received: by mail-ej1-f51.google.com with SMTP id a640c23a62f3a-c43fbcb4393so119629266b.0
        for <linux-crypto@vger.kernel.org>; Fri, 30 Oct 2026 07:49:24 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBzSjnMHDko4+883538HOR0mStCO9tkc0R9GLY2YUZKagbLuApD30KSRYkKmAxR2zb4pRRJc10FBMn24VCg=@vger.kernel.org
X-Gm-Message-State: AFq9FYL41myuFOO1T6jPyChlnxb7EUV5ojY88XoGXB0RXhl/lL1a+MfJ
	eVnXT13UFc6VVtFusCnya83Dn4AhKOMFCcRClLTDtCUBlh6NShjlkz5ErMtqNT4lv50xzb2ZjGT
	2U4b2FJx8gOAfu3qYQpXUnovo6N+oJpk=
X-Received: by 2002:a17:906:9f92:b0:c29:4915:83cb with SMTP id
 a640c23a62f3a-c4ca7ab09dbmr235759666b.39.1793371763605; Fri, 30 Oct 2026
 07:49:23 -0700 (PDT)
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261028030503.17923-1-kanchanapsridhar2026@gmail.com>
 <20261028030503.17923-7-kanchanapsridhar2026@gmail.com> <sashiko-outbox-188658@kernel.org>
 <auQhULh1VTh6lWoe@gondor.apana.org.au> <CACpmpodWMtmE0yNVN656K-8fPZgTj_DSZ0J7qxou+5Asoht+4A@mail.gmail.com>
 <auQwWgMbBuo0YEBI@gondor.apana.org.au> <CACpmpodxvQCkQgXUU6pF8d7onxHvHF7sEYCbTkv81WXyyrFiEg@mail.gmail.com>
In-Reply-To: <CACpmpodxvQCkQgXUU6pF8d7onxHvHF7sEYCbTkv81WXyyrFiEg@mail.gmail.com>
From: Yosry Ahmed <yosry@kernel.org>
Date: Fri, 30 Oct 2026 07:49:11 -0700
X-Gmail-Original-Message-ID: <CAO9r8zNvy7ftXsmLnj4qbQYJ5nyQo=hrio4UQvNrpMbwj9YbMg@mail.gmail.com>
X-Gm-Features: AclHuK_VMB6EZ1UVhDMh9oCJ1ZyT4EAf7VOhmffq_u4OhZNJTl7iN40sgLIywfU
Message-ID: <CAO9r8zNvy7ftXsmLnj4qbQYJ5nyQo=hrio4UQvNrpMbwj9YbMg@mail.gmail.com>
Subject: Re: [PATCH v2 6/8] mm: zswap: Store large folios in batches.
To: "Kanchana P. Sridhar" <kanchanapsridhar2026@gmail.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>, sashiko-reviews@lists.linux.dev, 
	hannes@cmpxchg.org, nphamcs@gmail.com, chengming.zhou@linux.dev, 
	akpm@linux-foundation.org, linux-mm@kvack.org, davem@davemloft.net, 
	linux-crypto@vger.kernel.org, rientjes@google.com, willy@infradead.org, 
	senozhatsky@chromium.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Oct 29, 2026 at 11:19=E2=80=AFPM Kanchana P. Sridhar
<kanchanapsridhar2026@gmail.com> wrote:
>
> On Thu, Oct 29, 2026 at 10:51=E2=80=AFPM Herbert Xu <herbert@gondor.apana=
.org.au> wrote:
> >
> > On Thu, Oct 29, 2026 at 10:15:15PM -0700, Kanchana P. Sridhar wrote:
> > >
> > > This is how it is in the current mainline, and has been for as long a=
s
> > > I can remember.. I assumed it was because we need a per-CPU acomp_req
> > > to be allocated for the tfm. Can this be done with a single
> > > crypto_acomp for a given algorithm?
> >
> > The request needs to be per-cpu, but the tfm does not.
>
> Great.. we can save a lot of memory this way.
>
> Yosry, should I go ahead and include this fix in this patch series? I
> am Ok if you want to take this up.

Feel free to send a patch, but I think it doesn't have to be part of the se=
ries.
