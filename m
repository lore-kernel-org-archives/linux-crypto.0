Received: from mail-yw1-f176.google.com (mail-yw1-f176.google.com [209.85.128.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5ED0242A97
	for <linux-crypto@vger.kernel.org>; Tue,  7 May 2024 04:20:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715055610; cv=none; b=M/LaJ7HUVgE7jgVxPNag0iwxtMxQdPTLBZELSGUy8n19Q1xGRrOfnQiy+vs1PfLjseipuT3quSa1GRsmbeCiK90HfhCCgjE9ylrAF+pKBXZ/nfFnrqcagptZGLagMY/q/iVDuEq/EdBOL/1TQf6m1xi8E1vhUheYygkFitu7B9U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715055610; c=relaxed/simple;
	bh=7jFYBX93lPII7WWJ20GNsWg9Jty5hZkCmJWWElMOmck=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=mge2yDp09G7l28PKaVl62h1TDkRqD35MPWl2PE6+nFljayF3+arenkGXOQ8xohbKn1qBINmj4CCualnube2uewJE4xAIdmRnb6bYAxSS3TzEl/6WxPtaT+lc5X0lHidwv4xnBKjsigW0e7+MWNVJgTzsRk6VlS88SvN89ve7pdg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=vayavyalabs.com; spf=pass smtp.mailfrom=vayavyalabs.com; dkim=pass (1024-bit key) header.d=vayavyalabs.com header.i=@vayavyalabs.com header.b=J2vZI3b8; arc=none smtp.client-ip=209.85.128.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=vayavyalabs.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=vayavyalabs.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=vayavyalabs.com header.i=@vayavyalabs.com header.b="J2vZI3b8"
Received: by mail-yw1-f176.google.com with SMTP id 00721157ae682-61b62005f38so28509937b3.2
        for <linux-crypto@vger.kernel.org>; Mon, 06 May 2024 21:20:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=vayavyalabs.com; s=google; t=1715055608; x=1715660408; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wjW97QSBWDvTIplxhYWZ8DZ+VoQ28QSXWBur6UjSQqg=;
        b=J2vZI3b8YNZUbOjRaLqnSsVR6n6OjS2hVgCJ0YKfjoKLmwJbIKk+isltTGRmlcRhC1
         R1whm8MmL+PlwE6YFqGInA21NNaSE2RIookvVXgm56iKdfVpkqbIuYwGCZ6CRRvgvM6p
         dILt+Vh5YzmZ+oZXE2v0XsjX4t3EsATQ7lqG8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715055608; x=1715660408;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=wjW97QSBWDvTIplxhYWZ8DZ+VoQ28QSXWBur6UjSQqg=;
        b=qJkYsK5sfFH7CM79NcjVTT23TVn+Yx4AnlDkRpjefW3XJyDglOpkWjYtwMarwNNCcY
         9LVON01IN99nUrIxyy8KzUqSb8qk4tL2zQM/5pJEyMW2TOZEjLh6h24W/LGUzhGo7Wl+
         cmcNc9gg7P8A2m1eWWtWGLKKn39fyauwiRpvaOTvwEu3RapqP1BxVE8BgjLu3KEH6Y4U
         ZDtzsf1ER8j/rh7/0/HM7oy+8c9JdP2CdpTWUlCy/LH1+Y1xYRAhAIdT1gHtp8N35t4c
         miIUWOMw4bJx1d+Co7NKirq4iRlOWu1eV544Sa4NPle0w754iui4KG1YSYelFFiqX0mf
         moFA==
X-Gm-Message-State: AOJu0YxhnQRc1OpAh/lkE1E8cc0b4x9u1TxGNSS6D6iXXRSKqQE4WF34
	AsqUn8N5veondV9rHAScLuG76Vxps0sOUlyPfTMM78TF34yA8pISMerrr5xSXcdrnzHLrB10oAc
	PgU5WveDc9BU9luwoBMnzCSO6ndLMNkywYN9/Gw==
X-Google-Smtp-Source: AGHT+IFH8VXUQAvtIF0BCKz0wxqNHkNdUV/lDjA+M+OMpzb2TEBkpzojxOEolknNaLRP5aPGyA0GuWirlo6ctxtC/6Q=
X-Received: by 2002:a0d:ec09:0:b0:614:7146:ea93 with SMTP id
 q9-20020a0dec09000000b006147146ea93mr11328857ywn.25.1715055608360; Mon, 06
 May 2024 21:20:08 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240426042544.3545690-1-pavitrakumarm@vayavyalabs.com>
 <20240426042544.3545690-4-pavitrakumarm@vayavyalabs.com> <ZjS8fQE5No1rDygF@gondor.apana.org.au>
In-Reply-To: <ZjS8fQE5No1rDygF@gondor.apana.org.au>
From: Pavitrakumar Managutte <pavitrakumarm@vayavyalabs.com>
Date: Tue, 7 May 2024 09:49:57 +0530
Message-ID: <CALxtO0m2wC3=yP5zE3_2nboVBVRVuhwuHx9Pdfj25wynky3E-A@mail.gmail.com>
Subject: Re: [PATCH v3 3/7] Add SPAcc ahash support
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: linux-crypto@vger.kernel.org, Ruud.Derwig@synopsys.com, 
	manjunath.hadli@vayavyalabs.com, bhoomikak@vayavyalabs.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Herbert,
  Yes, we have enabled the CRYPTO_MANAGER_EXTRA_TESTS and
all tests are passing with the default 100 iterations. We bumped
the iterations to 500 and verified that as well for all our algos.

About the export function, yes its hash state that's present inside
"spacc_crypto_ctx".
which also holds the intermediate digest. The SPAcc IP supports
multiple hashes,
ciphers and aeads. We use the same context structure across all algos. Do l=
et me
know if that needs to be modified.

Warm regards,
PK







On Fri, May 3, 2024 at 3:59=E2=80=AFPM Herbert Xu <herbert@gondor.apana.org=
.au> wrote:
>
> On Fri, Apr 26, 2024 at 09:55:40AM +0530, Pavitrakumar M wrote:
> .
> > +static int spacc_hash_export(struct ahash_request *req, void *out)
> > +{
> > +     const struct spacc_crypto_reqctx *ctx =3D ahash_request_ctx(req);
> > +
> > +     memcpy(out, ctx, sizeof(*ctx));
> > +
> > +     return 0;
> > +}
>
> Did you test this with CRYPTO_MANAGER_EXTRA_TESTS enabled?
>
> When a hash exports its state, it's meant to write out the actual
> partial hash state, not a bunch of kernel pointers.
>
> Cheers,
> --
> Email: Herbert Xu <herbert@gondor.apana.org.au>
> Home Page: http://gondor.apana.org.au/~herbert/
> PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
