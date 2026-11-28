Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795826600;
	b=PJbPK+4Bd460fBnApRsbfYGAJQbFjb030bn8b8gPrL2jMAB7W5IuwMikL/tPqn1u1OPk
	 Exe8hl2Pf5TSBeuiLpjFgGrfoM2B0NrVz7VzYxeCwralp9SOCVI5c8ob9wwS2wrNxgANV
	 7xJ/PcKGXje+qQr9O7jGoyeFm2bd8PtmWP4Xr/yuz7Me+8EZKpUQXgva/UpYu0lznmZRN
	 GTKYXKmUKx36TmdMDkk/ZzBaLZL6aWrLcNqZx2fxueqzL9as0eNlWQB/iXmdSzCh3BWaa
	 tIPYkGW2zKULT4qX57UIpXwI50DQroU14ydAftfRNUkguhSFUL9P4+GjqxnVm56NNCA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795826600;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=GFNyH0Ir4kVCvrZZWUN3b3y+Hhr3cHiie3fTLT72VVg=;
	b=5A+AMNKB4mYVm+TVOacoYCe7ON79ktaDa8GKovmYr3POtTSueUbV5jydQqltvigAGJQ+
	 qDI97mlURPjwRrjnkRszk/Q29l5xXlBJQmZKQx60gGMZF0h+ee3zi9FodljhqM7wj3P5f
	 yAxRzJNjiAJqqC/Y+K0PX17MSKjiZvcGWOGEUqMrsNltP4O6tt2kXiNnSKm9clKx2dRGf
	 JSnErV521l4wlNyFMiKLBY5OJAEobDEzPx0kPn3EHdGwFR0LeTRpTXzXoQA7jq15PnKzv
	 kdrIYS8JTz8PkSJXa/10bIcXAHB+zxEeZ8bGhea22ApsCXW+TwsFNyGZw5UrJUhBCOg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=VyEGnqmY;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with UTF8SMTPS id A0011606A31C;
	Sat, 28 Nov 2026 00:43:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=VyEGnqmY
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 84F131F00893;
	Sat, 28 Nov 2026 00:43:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795826600;
	bh=GFNyH0Ir4kVCvrZZWUN3b3y+Hhr3cHiie3fTLT72VVg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=VyEGnqmYPetw/50oz5XSjsTb4xi26lMs43Venrqj/HUi95seUUqVD0uzK9hWHnikT
	 wM2+usQQChXcmo2je9Dk+oIU/OHuQHymSsx9MS6vyNbyCmGwqFAeflmPnuUj4fnwSU
	 AE+hNJb5JLlh+foTdAxRPHTxwNAXU+8UDdfpTKCd+QQsQeJuxftROt5GlZnClHsY+W
	 NqS0RyUehuYWXz/roswvNCvYvIov7uvf+KEKMRHVGN6ASi1SD1h8OlwkQSg0Gy97h5
	 IHOlZcwkv2mVhwd8faWKe9QAauXdix2kby+VdUvM+hDAdTneFfoe1KzwqBQxK4lYA1
	 kY0RDpASwkwwg==
Date: Sat, 28 Nov 2026 02:43:16 +0200
From: Jarkko Sakkinen <jarkko@kernel.org>
To: Eric Biggers <ebiggers@kernel.org>
Cc: keyrings@vger.kernel.org, dm-devel@lists.linux.dev,
	linux-crypto@vger.kernel.org, linux-doc@vger.kernel.org,
	linux-integrity@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-security-module@vger.kernel.org,
	Ahmad Fatoum <a.fatoum@pengutronix.de>,
	Alasdair Kergon <agk@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Benjamin Marzinski <bmarzins@redhat.com>,
	David Gstir <david@sigma-star.at>,
	David Howells <dhowells@redhat.com>,
	David Laight <david.laight.linux@gmail.com>,
	"David S. Miller" <davem@davemloft.net>,
	David Woodhouse <dwmw2@infradead.org>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Ignat Korchagin <ignat@linux.win>,
	James Bottomley <James.Bottomley@hansenpartnership.com>,
	James Morris <jmorris@namei.org>,
	James Prestwood <prestwoj@gmail.com>,
	Jason Gunthorpe <jgg@ziepe.ca>, Jonathan Corbet <corbet@lwn.net>,
	Jonathan McDowell <noodles@meta.com>,
	Lukas Wunner <lukas@wunner.de>,
	Marek =?iso-8859-1?Q?Beh=FAn?= <kabel@kernel.org>,
	Mike Snitzer <snitzer@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Mimi Zohar <zohar@linux.ibm.com>, Paul Moore <paul@paul-moore.com>,
	Peter Huewe <peterhuewe@gmx.de>,
	Randy Dunlap <rdunlap@infradead.org>,
	"Serge E. Hallyn" <serge@hallyn.com>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Sumit Garg <sumit.garg@kernel.org>
Subject: Re: [PATCH v5 00/17] KEYS: trusted: asymmetric keys
Message-ID: <awojpAZ81dakxfQY@kernel.org>
References: <20261127055602.2357884-1-jarkko@kernel.org>
 <20261127193133.GE8300@quark>
 <awnrj-s1qL0Bw0nI@kernel.org>
 <awnugO__1DBkLlFe@kernel.org>
 <awn3tIYuqM-J1tXz@kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <awn3tIYuqM-J1tXz@kernel.org>

On Fri, Nov 27, 2026 at 11:35:53PM +0200, Jarkko Sakkinen wrote:
> On Fri, Nov 27, 2026 at 10:56:37PM +0200, Jarkko Sakkinen wrote:
> > On Fri, Nov 27, 2026 at 10:44:03PM +0200, Jarkko Sakkinen wrote:
> > > On Fri, Nov 27, 2026 at 11:31:33AM -0800, Eric Biggers wrote:
> > > > On Fri, Nov 27, 2026 at 07:55:45AM +0200, Jarkko Sakkinen wrote:
> > > > > OVERVIEW
> > > > > ========
> > > > > 
> > > > > Extend TPM 2.0 trusted keys to load ASN.1 TPMKey [1] asymmetric keys
> > > > > (OID_TPMLoadableKey, 2.23.133.10.1.3) and expose keyctl pkey-operations
> > > > > directly on key_type_trusted. In addition there are some TPMKey
> > > > > interoperability fixes.
> > > > > 
> > > > > I.e. this my old series with a twist: instead of introducing a separate
> > > > > subtype for asymmetric keys, factor out pkey-operations into a separate
> > > > > CONFIG_KEYCTL_PKEY-feature, and wire asymmetric operations to
> > > > > key_type_trusted.
> > > > > 
> > > > > This work was originally derived from [3], is direct offspring of [2],
> > > > > and folds in the prerequisite tpm2-sessions and tpm-buf cleanups from
> > > > > [4].
> > > > > 
> > > > > [1] https://www.hansenpartnership.com/draft-bottomley-tpm2-keys.html
> > > > > [2] https://lore.kernel.org/linux-integrity/20240520184727.22038-1-jarkko@kernel.org/
> > > > > [3] https://lore.kernel.org/all/20200518172704.29608-1-prestwoj@gmail.com/
> > > > > [4] https://lore.kernel.org/linux-integrity/20261116005105.1573016-1-jarkko@kernel.org/
> > > > 
> > > > Could you describe the motivation for these changes here?  And also
> > > > include more context directly, for people who aren't already familiar
> > > > with all the earlier patches linked to above.
> > > > 
> > > > Also, this series is missing a base-commit, and I don't know how to
> > > > apply it for review.
> > > 
> > > Sure, I'll do that if this moves forward.
> > > 
> > > The feature allows to provision an external key so that private portion
> > > is secured by TPM, and used for e.g., signing and authentication. One
> > > example of a program that might use this is iwd.
> > > 
> > > First, a parent is needed.
> > > 
> > > 0x40000001 (Owner) primary following TCG H-2 ECC P-256 template:
> > > 
> > > 	tpm2_createprimary -C o -g sha256 -G ecc256:null:aes128cfb \
> > >       		-a "fixedtpm|fixedparent|sensitivedataorigin|userwithauth|noda|restricted|decrypt" \
> > >       		-c primary.ctx
> > > 
> > >     	tpm2_import -C primary.ctx -G ecc -i key.pem -u key.pub -r key.priv
> > >     	tpm2_encodeobject -C primary.ctx -u key.pub -r key.priv -o key.tpm.pem
> > >     	tpm2_flushcontext primary.ctx
> > > 	
> > > Alternatively, a persistent handle can be used. This follows TPMKey
> > > specification recommendations.
> > > 
> > > Then external key can be imported an used as follows:
> > > 
> > > 	openssl ecparam -name prime256v1 -genkey -noout -out key.pem
> > >     	openssl pkey -in key.pem -pubout -out pub.pem
> > >  	openssl asn1parse -in key.tpm.pem -out key.tpm.der -noout
> > >     	HEX=$(xxd -p -c 0 key.tpm.der)
> > >     	TPM_KEY=$(keyctl add trusted tpm-key "load $HEX" @u)
> > >     	keyctl pkey_query "$TPM_KEY" 0 enc=x962 hash=sha256
> > > 
> > > 	echo "secret sauce" > plain.txt
> > > 	openssl dgst -sha256 -binary -out plain.sha256 plain.txt
> > > 	keyctl pkey_sign "$TPM_KEY" 0 plain.sha256 enc=x962 hash=sha256 > plain.sig
> > > 
> > > > 
> > > > - Eric
> > > 
> > > Another document that is source for what should be supported is:
> > > 
> > > https://datatracker.ietf.org/doc/draft-woodhouse-cert-best-practice/
> > > 
> > > Althought, I'm not sure how relevant this is anymore.
> > 
> > One other thing in addition to decoupling pkey operations that could be
> > done as part of this would be to modularize the documentation, and use
> > rst file at Documentation/ to include the snippets.
> > 
> > I left documentation part a bit stub as I started considering whether
> > to do this or not. I.e., do it like some of the GPU drivers manage
> > documentation.
> > 
> > With all these backends it's getting messy.
> 
> For tying in PCRs or system state in general it would be best to
> implement policy command intepreter, which is a blob than can be
> supplied with TPMKey. It's not a big leap from this.
> 
> It could be also used for regular trusted keys and benefit over
> special parameters would be that it keeps the keyctl interface
> backend agnostic (as e.g., PCRs bindings come with the data).

Not the prettiest script but this is current version of the smoke
test that I've used to test this:

#!/bin/sh
# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2024-2026 Jarkko Sakkinen <jarkko@kernel.org>
#
# Cross-verification test for TPM2 asymmetric trusted keys.

set -e

WORK=$(mktemp -d)
persistent_handle=
TPM2_KEY=
X509_KEY=
cleanup()
{
  rc=$?
  if [ -n "$TPM2_KEY" ]; then
    keyctl unlink "$TPM2_KEY" @s >/dev/null 2>&1 || true
  fi
  if [ -n "$X509_KEY" ]; then
    keyctl unlink "$X509_KEY" @s >/dev/null 2>&1 || true
  fi
  rm -rf "$WORK"
  if [ -n "$persistent_handle" ]; then
    tpm2sh delete "$persistent_handle" || true
  fi
  exit "$rc"
}
trap cleanup EXIT

openssl ecparam -genkey -name prime256v1 -noout -out "$WORK/ec_key.pem"

handle=$(tpm2sh create-primary ecc-nist-p256:sha256)
tpm2sh evict "$handle" 81000001
persistent_handle=81000001

tpm2sh import --loadable 81000001 \
  -I "$WORK/ec_key.pem" \
  -O "$WORK/tpm2_key.pem"
openssl asn1parse -inform pem -in "$WORK/tpm2_key.pem" \
  -noout -out "$WORK/tpm2_key.der"
TPM2_HEX=$(od -An -tx1 "$WORK/tpm2_key.der" | tr -d ' \n')

openssl req -new -x509 -key "$WORK/ec_key.pem" \
  -out "$WORK/cert.pem" -days 1 \
  -subj "/CN=tpm2_asymmetric_test" -sha256
openssl x509 -in "$WORK/cert.pem" -outform der -out "$WORK/cert.der"

TPM2_KEY=$(keyctl add trusted "tpm2_asymmetric" "load $TPM2_HEX" @s)
X509_KEY=$(keyctl padd asymmetric "x509_ecdsa" @s < "$WORK/cert.der")

keyctl pkey_query "$TPM2_KEY" 0 enc=x962 hash=sha256 >/dev/null

printf "tpm2 asymmetric cross-verification test data" > "$WORK/testdata"
openssl dgst -sha256 -binary "$WORK/testdata" > "$WORK/hash.bin"

keyctl pkey_sign "$TPM2_KEY" 0 "$WORK/hash.bin" enc=x962 hash=sha256 \
  > "$WORK/sig_tpm.der"
keyctl pkey_verify "$X509_KEY" 0 "$WORK/hash.bin" "$WORK/sig_tpm.der" \
  enc=x962 hash=sha256
echo "PASS: TPM2 key signed, X.509 key verified"

openssl dgst -sha256 -sign "$WORK/ec_key.pem" \
  -out "$WORK/sig_sw.der" "$WORK/testdata"
keyctl pkey_verify "$TPM2_KEY" 0 "$WORK/hash.bin" "$WORK/sig_sw.der" \
  enc=x962 hash=sha256
echo "PASS: OpenSSL signed, TPM2 key verified"

I should add RSA signing/encryption test to this tho (which is working but
test cases are missing).

Perhaps this could be used to derive a kselftest.

Br, Jarkko
