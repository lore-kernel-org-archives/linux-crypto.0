Received: from mail-ed1-f44.google.com (mail-ed1-f44.google.com [209.85.208.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C311834B68C
	for <linux-crypto@vger.kernel.org>; Mon, 22 Jun 2026 20:21:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782159681; cv=none; b=pLlBsCirZnP/oQxlaKtmm2YDQpw4HX3EMIkG+1ELD3XARBtz+1FWGG36WJZoW5Vl6J6e8kFsvOK3po4nGEke46FTOr6DjsltwzqmHcxocdg5tWZduQCbyYwH2pt7XBATai6OZzagcrdd3WwIdZsdv99P3hDabi2VgNypRDg931k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782159681; c=relaxed/simple;
	bh=nnx1Bky1wAIRaB3zi2foM2fegfU+yLHj+NalW3CIDc0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=hq9ymS95+qDDKWBTGq2Ca6Fyh/rBIZ4fMUUNeOWqvgrvRUkQNd0t01j3iKeSmrLu3ou2QjY5VXTwuQ2dL3PExEBTwMm5VFsRGkq57Oup3NBU4hdux3LeCtMLRY6dWL7oV5g6lAa+tL/i1hHnaAbrxrnMUE0y95DPpBmeKxr1PC8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux.win; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=209.85.208.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux.win
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f44.google.com with SMTP id 4fb4d7f45d1cf-697ad7f663cso2439222a12.1
        for <linux-crypto@vger.kernel.org>; Mon, 22 Jun 2026 13:21:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782159678; x=1782764478;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=jVlFfRpn9UntpPh6Z18ZIlYWvmrIqOtd+zdy9KzVAtA=;
        b=aaAW0fcyIIP+JiXSgMcohPBZVN74VD9h3VlWeybL7N6JA+fJz81iYMGwg78MZlfjvK
         YQN2e2F1KnA2AdW46ul5U4Y9MxSyXnl4ZONWqnwAVQ2nTSO67Cs+DBj6ZLHEshVZbwM9
         sedKKNJS3yWarqoMxg1pHt/ODmDlEHHLudpyTHfVZ6pz8Rfm+aDl1viorigdDFR1NL85
         wk+LNAc9C3Ui+e6H6+a5n31SKNviwljLbAjmzVqZyJL5BdbVFL5zw8x8hTabMLxA4Alr
         z3GWhFsEnzDeqPfTu+ejkVgn7OfnRF/EBcJ5zks3d7I0goZ9p3BHzVY/MyK2Qtvq3J5O
         zl8Q==
X-Forwarded-Encrypted: i=1; AFNElJ97PKXgXRzCru0pzn4ekf4Kr/hGpvNyGn2u3f53T/wpCzF8sCQkaM73Ftpg1lcdp56hyWSuqoORZWFlVF0=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw8V2daowwAeC+ZM20GbOZtKG2AUMRtI9PeIsGOe1nMQqi5cVX7
	r6Y3VYBaHCq71V2VWF0D8AiITuZPROQ93Z2qhw2xXTt7HDtlUqSTHVKjYXGM24AOoZM=
X-Gm-Gg: AfdE7clMpj5N6bHPBjq2QxMiISM6XA+fu1pmudrh6WBQDUZIvxYZGEAUyAo1hLUCWeV
	X3s3qsUhCS3rQwmgWxR8cuN04/0HJfJAiKwNZjY35c8l3539M4v6t5ZUXgD8IgvUPTC5DAx5WQk
	UAf+0K5ylDIFq1EZ4lINrM3qJElZRlgoCkdopHFvO13tIBqRhsXj94Oq5M4yS9OGNsVzVjhN+9/
	zysmmOtk3YFivqurqKGTbYxzGmlQkox6qTownPGDoNUQP2A15ZRfxMkD+yPPFM7h0dW7kDSWQW0
	lu3UOAX9zW6oqQvRzq5blKENa31wJ2C+UZkzsST001lu5f8pQhw9Xg6HF2avpcUfVFPTs48NnvF
	xKs7ZpyAQx2zwKreBaXCXim+mbdD/KVGtPtC0eyoLXkJgw2sKjA0ZMmZDsWcxQoa+XF6VwJYIQj
	Q7n4ip/Qjsg4F8QB7LaXth2h/6PrYcq5z4+QqcY/PORmRcT/+/de5XLA==
X-Received: by 2002:a05:6402:4583:b0:692:4a58:a93 with SMTP id 4fb4d7f45d1cf-696e5221636mr7280142a12.21.1782159678118;
        Mon, 22 Jun 2026 13:21:18 -0700 (PDT)
Received: from mail-ed1-f45.google.com (mail-ed1-f45.google.com. [209.85.208.45])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-697d366f5c8sm449311a12.31.2026.06.22.13.21.16
        for <linux-crypto@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 22 Jun 2026 13:21:17 -0700 (PDT)
Received: by mail-ed1-f45.google.com with SMTP id 4fb4d7f45d1cf-697ad7f663cso2439163a12.1
        for <linux-crypto@vger.kernel.org>; Mon, 22 Jun 2026 13:21:16 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AFNElJ8edVyaASynqOP3diqd4WGliLB3LeGy4SNCwidfmm68LMsYe9+34gAiyk6aJtvZf6f22eQBD4srSkPRM6Y=@vger.kernel.org
X-Received: by 2002:a17:907:a03:b0:c0d:7573:7256 with SMTP id
 a640c23a62f3a-c0d7573740amr435737666b.51.1782159676483; Mon, 22 Jun 2026
 13:21:16 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260502163328.696098-2-bestswngs@gmail.com> <aji3B9a72VEAOu03@gondor.apana.org.au>
 <ajlNCxltXkuWfIw-@kernel.org>
In-Reply-To: <ajlNCxltXkuWfIw-@kernel.org>
From: Ignat Korchagin <ignat@linux.win>
Date: Mon, 22 Jun 2026 21:21:04 +0100
X-Gmail-Original-Message-ID: <CAOs+rJVutdn6vqjSxidx-fA_R8PYsqJbbpMRUW+ijJeXoavCYA@mail.gmail.com>
X-Gm-Features: AVVi8CcdlgikvHr2XETEkUfuG_HaLob-n6pc__1dO-GEG4Nf3-J3r6h8h6TyyI4
Message-ID: <CAOs+rJVutdn6vqjSxidx-fA_R8PYsqJbbpMRUW+ijJeXoavCYA@mail.gmail.com>
Subject: Re: [PATCH v2] asymmetric_keys: check asymmetric_key_ids() for NULL
 before dereference
To: Herbert Xu <herbert@gondor.apana.org.au>, Weiming Shi <bestswngs@gmail.com>
Cc: David Howells <dhowells@redhat.com>, Jarkko Sakkinen <jarkko@kernel.org>, 
	Lukas Wunner <lukas@wunner.de>, "David S . Miller" <davem@davemloft.net>, keyrings@vger.kernel.org, 
	linux-crypto@vger.kernel.org, Xiang Mei <xmei5@asu.edu>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Jun 22, 2026 at 3:56=E2=80=AFPM Jarkko Sakkinen <jarkko@kernel.org>=
 wrote:
>
> On Mon, Jun 22, 2026 at 12:16:07PM +0800, Herbert Xu wrote:
> > On Sat, May 02, 2026 at 09:33:29AM -0700, Weiming Shi wrote:
> > >
> > > diff --git a/crypto/asymmetric_keys/asymmetric_type.c b/crypto/asymme=
tric_keys/asymmetric_type.c
> > > index 16a7ae16593c..22f04656d529 100644
> > > --- a/crypto/asymmetric_keys/asymmetric_type.c
> > > +++ b/crypto/asymmetric_keys/asymmetric_type.c
> > > @@ -109,6 +109,8 @@ struct key *find_asymmetric_key(struct key *keyri=
ng,
> > >     if (id_0 && id_1) {
> > >             const struct asymmetric_key_ids *kids =3D asymmetric_key_=
ids(key);
> > >
> > > +           if (!kids)
> > > +                   goto reject;
> >
> > This check is actually unnecessary because we've already matched
> > the key against the kid so it must be present.
> >
> > I'd get rid of this check or perhaps add a comment instead.
>
> +1
>
> >
> > >             if (!kids->id[1]) {
> > >                     pr_debug("First ID matches, but second is missing=
\n");
> > >                     goto reject;
> > > diff --git a/crypto/asymmetric_keys/restrict.c b/crypto/asymmetric_ke=
ys/restrict.c
> > > index 86292965f493..ccf1084f720e 100644
> > > --- a/crypto/asymmetric_keys/restrict.c
> > > +++ b/crypto/asymmetric_keys/restrict.c
> > > @@ -243,10 +243,14 @@ static int key_or_keyring_common(struct key *de=
st_keyring,
> > >                     if (IS_ERR(key))
> > >                             key =3D NULL;
> > >             } else if (trusted->type =3D=3D &key_type_asymmetric) {
> > > +                   const struct asymmetric_key_ids *kids;
> > >                     const struct asymmetric_key_id **signer_ids;
> > >
> > > -                   signer_ids =3D (const struct asymmetric_key_id **=
)
> > > -                           asymmetric_key_ids(trusted)->id;
> > > +                   kids =3D asymmetric_key_ids(trusted);
> > > +                   if (!kids)
> > > +                           goto skip_trusted;
> >
> > Yes this is definitely buggy.
> >
> > I think it was introduced by these two commits:
> >
> > commit 3c58b2362ba828ee2970c66c6a6fd7b04fde4413
> > Author: David Howells <dhowells@redhat.com>
> > Date:   Tue Oct 9 17:47:46 2018 +0100
> >
> >     KEYS: Implement PKCS#8 RSA Private Key parser [ver #2]
> >
> > and
> >
> > commit 7e3c4d22083f6e7316c5229b6197ca2d5335aa35
> > Author: Mat Martineau <martineau@kernel.org>
> > Date:   Mon Jun 27 16:45:16 2016 -0700
> >
> >     KEYS: Restrict asymmetric key linkage using a specific keychain
> >
> > So the Fixes header should point to them.
>
> +1
>
> >
> > > @@ -290,6 +294,7 @@ static int key_or_keyring_common(struct key *dest=
_keyring,
> > >             }
> > >     }
> > >
> > > +skip_trusted:
> > >     if (check_dest && !key) {
> > >             /* See if the destination has a key that signed this one.=
 */
> > >             key =3D find_asymmetric_key(dest_keyring, sig->auth_ids[0=
],
> >
> > I'm not sure continuing here is a good idea.  Having a private key
> > here makes no sense whatsoever and we should just bail out right
> > away.
> >
> > I would recommend returning an error of some sort if kids is NULL.
> >
> > David/Lukas/Ignat, any opinions?

As I reread the original submission (somehow I never got the V2) it
seems we're restricting a keyring with a private key?! Which indeed
does not make sense.

> I think with a quick skim that you are right. I'll work on this area
> for the next version.
>
> >
> > Thanks,
> > --
> > Email: Herbert Xu <herbert@gondor.apana.org.au>
> > Home Page: http://gondor.apana.org.au/~herbert/
> > PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
>
> Thanks for the review!
>
> BR, Jarkko
>
>
