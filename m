Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BE27334375
	for <linux-crypto@vger.kernel.org>; Fri, 12 Sep 2025 21:15:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757711702; cv=none; b=neQBKSxlqEs2yk4pMflF35ywlRDS/227xQS9FlRz/5n1zdUnqAN54wME5N/vYVIbCcV54JUmB4nEG0AilUpsgbDu6bAEAOUZ/OHYKVxAX92ao3qgKNRLKOCJy+bwQE0yXv6dkvXJO2UVdrFRcZvfiIxeQr0T18co/CxTQM3VYrs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757711702; c=relaxed/simple;
	bh=BOVUAiC7L7uGyMy4Htrs40wCLw+QaPe8irlE0apVa9U=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=V+YYcWnbnOWpA29WKZhxeuQYBQK3I+sxvGVXUwcePDY+80SeGbXcHVBUInW0u7tHllI139L5zBpLMwJ2ifYmTAS6/P6NSZphMD18An9Fp1ib1axglINgCtaEicq3aqUIpRaytwlTzpx5XQsJXq2/zBawhv9O18ZRpg1ZOZGw7U4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MsBvyikR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MsBvyikR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 391CAC4CEF8
	for <linux-crypto@vger.kernel.org>; Fri, 12 Sep 2025 21:15:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1757711702;
	bh=BOVUAiC7L7uGyMy4Htrs40wCLw+QaPe8irlE0apVa9U=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=MsBvyikRsC+miKr3CmrqnwECIOEcD0UZH5TnHHxoJUxOckPcez/BmSzwXKKVu0j5u
	 /lSDVerL0o9rZbhBUO/pKQsM1Lh0y2v7Z8pFr8r61gn23F9jV+nKIOXgpzxQaS2HFH
	 /Qu+Afsz6LnVvMIrrO0/p620TvvRHTLRwLS0UT/odmncXNT9HTBgy+CQXC8kd7eLiy
	 siganrcB1Zc1/qCnzvX89+smGSOMYsAPZLOxTHcUFPBl2DF08+pX/pF1rRR/gXhXSB
	 ZGz70oaHkjyMBC2TK9eJGYhxKD6gozk/mG3AiSk9UrP48/bto7mXnorRgHGTa2N0Kk
	 7glevfNj2907A==
Received: by mail-pl1-f173.google.com with SMTP id d9443c01a7336-25669596955so22538155ad.0
        for <linux-crypto@vger.kernel.org>; Fri, 12 Sep 2025 14:15:02 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCWXdgwmSc4zVyLFT5jzB/0dG2bIcfNaHD6eVMxLIZ05yqWeDzedtHJ5vv7SPJefv86hCf3mAIygBx0aAvE=@vger.kernel.org
X-Gm-Message-State: AOJu0YzQGLtMLoNLPrQT26wAPDD/NR2sbuiWR2GILTOVSGHWfr5KFJGG
	aR58C/SuLMgdTRhH1XpvcCr6lQVKbdvIW5QrgIrTcyNiitv1D5zjSQVXwXUguSWtBhvbl4cxeWW
	ly2Za+WDK4M8B71Wi7Qv3BOxRYqyEfeo=
X-Google-Smtp-Source: AGHT+IH4TSct/tSPvFi34kJ8hocuL2dt5tlTyPL3ZHZsH2MAnZSz8HbOd7xFLua8gGaJCt//qTp1JX8U63ahSfWq/xU=
X-Received: by 2002:a17:902:e806:b0:24d:9c86:5e53 with SMTP id
 d9443c01a7336-25d2528c33fmr66417755ad.2.1757711701856; Fri, 12 Sep 2025
 14:15:01 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250911225356.2678-1-wufan@kernel.org> <aMQcnoETIt4t4Tqz@wunner.de>
In-Reply-To: <aMQcnoETIt4t4Tqz@wunner.de>
From: Fan Wu <wufan@kernel.org>
Date: Fri, 12 Sep 2025 14:14:49 -0700
X-Gmail-Original-Message-ID: <CAKtyLkExV9dqMWa5j9O5n8oTHXh8McwVbjjCm6L9L=eFsH3HNw@mail.gmail.com>
X-Gm-Features: Ac12FXwPTvg-iY8dF1E-xu7is_6OF3tOvQMHMmC3HmDvvM293tyy6qI799494CQ
Message-ID: <CAKtyLkExV9dqMWa5j9O5n8oTHXh8McwVbjjCm6L9L=eFsH3HNw@mail.gmail.com>
Subject: Re: [PATCH] KEYS: X.509: Fix Basic Constraints CA flag parsing
To: Lukas Wunner <lukas@wunner.de>
Cc: wufan@kernel.org, dhowells@redhat.com, ignat@cloudflare.com, 
	herbert@gondor.apana.org.au, davem@davemloft.net, jarkko@kernel.org, 
	zohar@linux.ibm.com, eric.snowberg@oracle.com, keyrings@vger.kernel.org, 
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Sep 12, 2025 at 6:14=E2=80=AFAM Lukas Wunner <lukas@wunner.de> wrot=
e:
>
> On Thu, Sep 11, 2025 at 10:53:56PM +0000, wufan@kernel.org wrote:
> > Fix the X.509 Basic Constraints CA flag parsing to correctly handle
> > the ASN.1 DER encoded structure. The parser was incorrectly treating
> > the length field as the boolean value.
> >
> > According to ITU-T X.690 section 8.2, a BOOLEAN is encoded as:
> >
> > Tag (0x01), Length (0x01), Value (0x00 for FALSE, non-zero for TRUE)
> >
> > The basicConstraints extension with CA:TRUE is encoded as:
> >
> >   SEQUENCE (0x30) | Length | BOOLEAN (0x01) | Length (0x01) | Value (0x=
FF)
> >                              ^-- v[2]         ^-- v[3]        ^-- v[4]
> >
> > The parser was checking v[3] (the length field, always 0x01) instead
> > of v[4] (the actual boolean value, 0xFF for TRUE).
>
> Excellent catch!  How did you find it?
>

Unrelated context, I was exploring the possibility of adding Extended
Key Usage (EKU) support and noticed this code didn't look quite right.

> > +++ b/crypto/asymmetric_keys/x509_cert_parser.c
> > @@ -623,7 +625,7 @@ int x509_process_extension(void *context, size_t hd=
rlen,
> >               if (v[0] !=3D (ASN1_CONS_BIT | ASN1_SEQ))
> >                       return -EBADMSG;
> >               if (vlen < 2)
> >                       return -EBADMSG;
> >               if (v[1] !=3D vlen - 2)
> >                       return -EBADMSG;
> > -             if (vlen >=3D 4 && v[1] !=3D 0 && v[2] =3D=3D ASN1_BOOL &=
& v[3] =3D=3D 1)
> > +             if (vlen >=3D 5 && v[1] !=3D 0 && v[2] =3D=3D ASN1_BOOL &=
& v[3] =3D=3D 1 && v[4] !=3D 0)
> >                       ctx->cert->pub->key_eflags |=3D 1 << KEY_EFLAG_CA=
;
> >               return 0;
> >       }
>
> Your patch is correct, however the conditions ...
>
>   vlen >=3D 5 && v[1] !=3D 0 && v[2] =3D=3D ASN1_BOOL && v[3] =3D=3D 1
>
> ... all check well-formedness of the BasicConstraints object,
> so it seems if any of those checks fails, -EBADMSG should be returned.
>
> The check "if (vlen < 2)" could be changed to "if (vlen < 5)" because
> 5 bytes seems to be the minimum size of a well-formed BasicConstraints
> object.  Then the "vlen >=3D 5" and "v[1] !=3D 0" checks can be dropped.
>

Actually, we need to be careful here. OpenSSL produces
BasicConstraints with CA:FALSE as just an empty SEQUENCE:

06 03 55 1d 13 | 01 01 ff | 04 02 | 30 00
[----OID------] [critical] [OCTET] [empty SEQ]

-Fan

> Up to you whether to respin this patch or make those changes in
> a separate patch on top.  And up to Herbert whether to take this
> patch as is or wait for a respin.
>
> Reviewed-by: Lukas Wunner <lukas@wunner.de>
>
> I note that parsing the v[] array is quite error-prone and it
> might have been better to either declare a packed struct for the
> BasicConstraints object with human-readable member names,
> or create a separate ASN.1 module for it.
>
> Thanks,
>
> Lukas
>
