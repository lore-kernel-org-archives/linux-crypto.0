Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793059285;
	b=tFJBiT0Plvje1rXjzrASFxYxulS94ZOUJRyOYvSP76eXAysdhzWLTUp57ZrVTc3vsqR7
	 u6nPNbA16gTmzqaLf10Nb3/ZCv/sfAP73ldtMfIBPDZfkT1PAe7nyMjbZZKNdxENQvbYV
	 jFSUcJAGLbU7/pPynM2i/MPHv9HZKGoSfqQ8t03esFMZ8/ygPMoil9CzwyoipEcmtMEQv
	 4bWBzYm+VdEpvQtrpFwBkZJwLnZV9oG3qCSvFzxFsz8eEzzeJU6G/eXoERyfWorgNeu1/
	 CdqVJWfvFC9WrIanIVtcV7oF+XD1GR9Xuf5E8UuyvbW1WDzWD2tfItARO2AGwWnodfA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793059285;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=0LRJqBrRZu8I7CaiJXMHZVTdIs/++2cjuvZ3KSCYX24=;
	b=w5jhnkKTBJ7512ZH9NWwxEG8v4RHpe2IUSUzhCNrHb4ncmJOcQrajsMqMDcwjKkQ3Eyo
	 ce9mFqr8nGwJW2hBfgxyvyqr5iJO4VoWZUh45OXwvni8pcCgMaTDGi+VIzHiG/H9w4SQi
	 oppPxd9n2r6X5aSY5GBL1EjEh00CQJKInKYpS7NRIdadd3MHH6QOZr9i37vKhTvzsmNwC
	 2BbtXKKNzEnOXxRP4z++IkEv98noJgVXraVVfr0zS7hAmLtXW4Dt+z2DDqSWdRRVEHpRr
	 t3ChATGn9pQsBRBVgFtwwO19IabKh1KWumVpS4seIeAh9PW6vM18HroSdHvEQpc2Xkw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=lGHGuc5d;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with UTF8SMTPS id 41EC7606A31A;
	Tue, 27 Oct 2026 00:01:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=lGHGuc5d
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 464D81F031E0;
	Tue, 27 Oct 2026 00:01:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793059284;
	bh=0LRJqBrRZu8I7CaiJXMHZVTdIs/++2cjuvZ3KSCYX24=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=lGHGuc5dcRkAffdeH2WdifKM6MiqYDJ94AyVLlffNPp+eUdT5k+99mhaU+/bhy4Re
	 n4+j6x8DIQM4lkKLxXBYDJJ7aL3M3nCU7SaAXSiyP6dhH4P5cyeavBR8QM2fKDBDc3
	 RGUwUYtZoVFcAjH+wDEzgcBHLgbzoFs4NZhstuExzdEBLuXC9pL5G533krFDJ2ODri
	 QbS1TcKVy8ZIHm90MqubYovU3DvzElKK8+zK5mEO1QGE7g4ZOU0xKYNAZoZsHSPeab
	 /FCCwXrim3GvhhLoQMaKOxlxGla2WfbijmjWTuGclw9oaaMlDWoHdHHDFqj16G665C
	 KQNJuk4czJiyw==
Date: Tue, 27 Oct 2026 02:01:21 +0200
From: Jarkko Sakkinen <jarkko@kernel.org>
To: Eric Biggers <ebiggers@kernel.org>
Cc: David Howells <dhowells@redhat.com>, keyrings@vger.kernel.org,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Benjamin Marzinski <bmarzins@redhat.com>,
	"Theodore Y. Ts'o" <tytso@mit.edu>, Thomas Graf <tgraf@suug.ch>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Andrew Morton <akpm@linux-foundation.org>,
	Paul Moore <paul@paul-moore.com>, James Morris <jmorris@namei.org>,
	"Serge E. Hallyn" <serge@hallyn.com>, Shuah Khan <shuah@kernel.org>,
	Christian Brauner <brauner@kernel.org>,
	"open list:DEVICE-MAPPER (LVM)" <dm-devel@lists.linux.dev>,
	open list <linux-kernel@vger.kernel.org>,
	"open list:FSVERITY: READ-ONLY FILE-BASED AUTHENTICITY PRO..." <fsverity@lists.linux.dev>,
	"open list:RHASHTABLE" <linux-crypto@vger.kernel.org>,
	"open list:SECURITY SUBSYSTEM" <linux-security-module@vger.kernel.org>,
	"open list:KERNEL SELFTEST FRAMEWORK" <linux-kselftest@vger.kernel.org>
Subject: Re: [PATCH v3 4/6] KEYS: Introduce keyring_is_empty()
Message-ID: <at_p0VD-PsPmIq-u@kernel.org>
References: <20261025001105.1824178-1-jarkko@kernel.org>
 <20261025001105.1824178-5-jarkko@kernel.org>
 <20261026235528.GA2395@quark>
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
In-Reply-To: <20261026235528.GA2395@quark>

On Mon, Oct 26, 2026 at 04:55:28PM -0700, Eric Biggers wrote:
> On Sun, Oct 25, 2026 at 03:10:12AM +0300, Jarkko Sakkinen wrote:
> > +/**
> > + * keyring_is_empty - Check whether a keyring contains any links
> > + * @keyring: The keyring to check.
> > + */
> 
> "contains any links" => "contains no links"?  Or even just "is empty".
> Otherwise it sounds backwards.
> 
> Note that another "is the keyring empty" check just showed up in
> mainline in kernel/bpf/keys.c.  So a new version of this patch will be
> needed to update that one too.
> 
> Otherwise this patch looks good.

I'll fix that up. Related, bpf_keyring_lookup() also needs to be
addressed now that I have it in my tree. 

> 
> - Eric

Br, Jarkko
