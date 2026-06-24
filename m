Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D80573B14A6;
	Wed, 24 Jun 2026 22:34:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782340457; cv=none; b=RQI9DExK2NKby4KryO1wK0IY0a07E54+ozOFn9sk4grCr8u6h7J0d4dFrevTqOvnjubTarW2XlQIL6CGFFZoIaom5VtFQwqGxdWcbkPXvCcA+JOjL3vDbJx/YBpU1twUUjN864UzQArMun11JL8YyX25ElY+m1bL9vqQ4jNojLE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782340457; c=relaxed/simple;
	bh=1xYfMIQLZVLQSJOpCqv2rGBG5C158bbLWtzVgDkHZ9w=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=h2Xq6bq8yB+Xlopa8awHXhWjpv1RllkRbPJ3yfM0VlIx3LdEKxDvqPNj5idVKfckH6PLiXxQX8gJYvqz9B7vPRndAu7b5PFTfRV3UznwepoJkHf3Zyxkz6JU0c2SInkh03nlZxBQ6df+bhM29oVvAlhmyOcCeLJHprv0UqGSXF0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=h+Q7KlOB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="h+Q7KlOB"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 000941F000E9;
	Wed, 24 Jun 2026 22:34:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782340456;
	bh=qCC77mxJi+tQbiiAcgCmlCi8nB1S3LQ9jAvjLxXU2IA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=h+Q7KlOB1lt4xHVeYlwAm97nrLUkdiDBd6rstbb04W859AI5VyU4XzwfwUkEnHNOW
	 LuEllE6JHp7k8DK8UJIe+n0Fz3X6Uug+kbrz5wZ4BzO0pShzK115y5nSYeseywjs4A
	 v1nIaDlw4mXXWvqLGCtW/zQRdKGlP4L5JBsKXxKt6vqiRcbzSO+kLeLWIBvKkmTM7a
	 jQwbNVLDxgrttzbWU7Gi2y1hpR1zS5lLm2H3x8TmoUzMoo0eqD+H7iPFlJ/bwoaKbS
	 pevsrovUVqVV6TE+A27dxxFNcejXqdiA4npguLLGFw/Cz9AWmwWe675KdJrpW9tPpt
	 1GrK47XAJV9ug==
Date: Thu, 25 Jun 2026 01:34:13 +0300
From: Jarkko Sakkinen <jarkko@kernel.org>
To: Ignat Korchagin <ignat@linux.win>
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	Weiming Shi <bestswngs@gmail.com>,
	David Howells <dhowells@redhat.com>, Lukas Wunner <lukas@wunner.de>,
	"David S . Miller" <davem@davemloft.net>, keyrings@vger.kernel.org,
	linux-crypto@vger.kernel.org, Xiang Mei <xmei5@asu.edu>
Subject: Re: [PATCH v2] asymmetric_keys: check asymmetric_key_ids() for NULL
 before dereference
Message-ID: <ajxbQetuHtpOD15l@kernel.org>
References: <20260502163328.696098-2-bestswngs@gmail.com>
 <aji3B9a72VEAOu03@gondor.apana.org.au>
 <ajlNCxltXkuWfIw-@kernel.org>
 <CAOs+rJVutdn6vqjSxidx-fA_R8PYsqJbbpMRUW+ijJeXoavCYA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAOs+rJVutdn6vqjSxidx-fA_R8PYsqJbbpMRUW+ijJeXoavCYA@mail.gmail.com>

On Mon, Jun 22, 2026 at 09:21:04PM +0100, Ignat Korchagin wrote:
> On Mon, Jun 22, 2026 at 3:56 PM Jarkko Sakkinen <jarkko@kernel.org> wrote:
> >
> > On Mon, Jun 22, 2026 at 12:16:07PM +0800, Herbert Xu wrote:
> > > On Sat, May 02, 2026 at 09:33:29AM -0700, Weiming Shi wrote:
> > > >
> > > > diff --git a/crypto/asymmetric_keys/asymmetric_type.c b/crypto/asymmetric_keys/asymmetric_type.c
> > > > index 16a7ae16593c..22f04656d529 100644
> > > > --- a/crypto/asymmetric_keys/asymmetric_type.c
> > > > +++ b/crypto/asymmetric_keys/asymmetric_type.c
> > > > @@ -109,6 +109,8 @@ struct key *find_asymmetric_key(struct key *keyring,
> > > >     if (id_0 && id_1) {
> > > >             const struct asymmetric_key_ids *kids = asymmetric_key_ids(key);
> > > >
> > > > +           if (!kids)
> > > > +                   goto reject;
> > >
> > > This check is actually unnecessary because we've already matched
> > > the key against the kid so it must be present.
> > >
> > > I'd get rid of this check or perhaps add a comment instead.
> >
> > +1
> >
> > >
> > > >             if (!kids->id[1]) {
> > > >                     pr_debug("First ID matches, but second is missing\n");
> > > >                     goto reject;
> > > > diff --git a/crypto/asymmetric_keys/restrict.c b/crypto/asymmetric_keys/restrict.c
> > > > index 86292965f493..ccf1084f720e 100644
> > > > --- a/crypto/asymmetric_keys/restrict.c
> > > > +++ b/crypto/asymmetric_keys/restrict.c
> > > > @@ -243,10 +243,14 @@ static int key_or_keyring_common(struct key *dest_keyring,
> > > >                     if (IS_ERR(key))
> > > >                             key = NULL;
> > > >             } else if (trusted->type == &key_type_asymmetric) {
> > > > +                   const struct asymmetric_key_ids *kids;
> > > >                     const struct asymmetric_key_id **signer_ids;
> > > >
> > > > -                   signer_ids = (const struct asymmetric_key_id **)
> > > > -                           asymmetric_key_ids(trusted)->id;
> > > > +                   kids = asymmetric_key_ids(trusted);
> > > > +                   if (!kids)
> > > > +                           goto skip_trusted;
> > >
> > > Yes this is definitely buggy.
> > >
> > > I think it was introduced by these two commits:
> > >
> > > commit 3c58b2362ba828ee2970c66c6a6fd7b04fde4413
> > > Author: David Howells <dhowells@redhat.com>
> > > Date:   Tue Oct 9 17:47:46 2018 +0100
> > >
> > >     KEYS: Implement PKCS#8 RSA Private Key parser [ver #2]
> > >
> > > and
> > >
> > > commit 7e3c4d22083f6e7316c5229b6197ca2d5335aa35
> > > Author: Mat Martineau <martineau@kernel.org>
> > > Date:   Mon Jun 27 16:45:16 2016 -0700
> > >
> > >     KEYS: Restrict asymmetric key linkage using a specific keychain
> > >
> > > So the Fixes header should point to them.
> >
> > +1
> >
> > >
> > > > @@ -290,6 +294,7 @@ static int key_or_keyring_common(struct key *dest_keyring,
> > > >             }
> > > >     }
> > > >
> > > > +skip_trusted:
> > > >     if (check_dest && !key) {
> > > >             /* See if the destination has a key that signed this one. */
> > > >             key = find_asymmetric_key(dest_keyring, sig->auth_ids[0],
> > >
> > > I'm not sure continuing here is a good idea.  Having a private key
> > > here makes no sense whatsoever and we should just bail out right
> > > away.
> > >
> > > I would recommend returning an error of some sort if kids is NULL.
> > >
> > > David/Lukas/Ignat, any opinions?
> 
> As I reread the original submission (somehow I never got the V2) it
> seems we're restricting a keyring with a private key?! Which indeed
> does not make sense.
> 
> > I think with a quick skim that you are right. I'll work on this area
> > for the next version.

BTW I was writing two emails simulatenously this last sentence was for 
private email discussion.

> >
> > >
> > > Thanks,
> > > --
> > > Email: Herbert Xu <herbert@gondor.apana.org.au>
> > > Home Page: http://gondor.apana.org.au/~herbert/
> > > PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
> >
> > Thanks for the review!

And this.

> >
> > BR, Jarkko
> >
> >

+1's were for the discussion. Sorry, I should not multitask with
emails...

BR, Jarkko
