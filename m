Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793581438;
	b=zdrJFfvG8zVXAlkk+m+n9BTY9yAmdvOa55hpuD1Hq9zhrJz2qeudN8Ht8bNgcpqaukM3
	 tj8rh0bQwIrHUfPGufp3NJ7hv/3YKBjt2wWZXmW5wWKPYu9Ufrh+sT2dXbSEQpJvlLv/n
	 jz2dmqol9tsedi6+KAYJFocpPHpiOqgkyqreTZBl89WEg9vYpcmi6Ko3tcuqh1S/YShro
	 RsvDLG//s8r4E1rMXvqFuIl09SGi3wjcUBOSrJif40O5kYXlSoGmTaLFR8REr9kbBYegQ
	 8g3Wb8m5s0eH4cj1hxhryIgptG4yvuobTxaD15W4d66RbCUM1ifRXmzdicjitgeyp6g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793581438;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=tiqvUFApBtrjWzOoPS6UoIbR2Mx+2HrDlZ832ZIExp4=;
	b=xTebceZTdmOqlSGsLr1G+J6LJ9eFPvgt+v4GlUdnaFJ927d2jgZFLM6/m4dZ1GxcP02L
	 mMgJw5UNePTLaDmGbPW7BBoR/YPBG+XZDGCbiBre7p3/JgTW9EOHJz59p6q+VBmQbgWU+
	 nH0C8GZie4EjGvRuZ3ZMu0EI/g0dV6OCls9ODItIElffpo0CadafNGFA8oF2+1tVYLZ6s
	 68qcWNI/Ov3Kuf0rTIwqUVfAfdBxsEKlE4sRF73h10Nrep8xaScU8EaAYeBF7/gYte7g6
	 v2hUDWYznnsyIMMzgOCSNj1s8yZBI/oKwxP/+f5YkKsgh2EgjMDnrmh2HZWEBENL2LA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=RdjC8+Bw;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with UTF8SMTPS id E427E606A324;
	Mon,  2 Nov 2026 01:03:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=RdjC8+Bw
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id E3DB21F000C1;
	Mon,  2 Nov 2026 01:03:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793581437;
	bh=tiqvUFApBtrjWzOoPS6UoIbR2Mx+2HrDlZ832ZIExp4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=RdjC8+BwTm1JBgN1Klb5fYXv3qO1oaeEhpqPBFtg5K9GDz4z5DqRCkVAlW0E7jkXw
	 4C3a+THsUUOT22Z+bS5APVIUyaQw1tLQIDzAG96FkubICVxINoUgZTtglG9UKdkrCX
	 nMzc4iNzkVSZ6259eLH5rz5sQrkCM1SLOOCtnoZeQ5gyWYHp5WGWh57UCNEnEFAgXd
	 Xbmad4CoI4PWbunFS4BeNEVCuReDNbEGxSAnznMqmOvFJwoKSSE9fSaB5HN0f0Ra1h
	 nDr1Z6l+FNgwm6ZDpToM+sTYBzNFZ2yr+ogcIsTViun3O320BurhtuA6F07mw4cFga
	 WNHUnleUdRpCg==
Date: Mon, 2 Nov 2026 03:03:53 +0200
From: Jarkko Sakkinen <jarkko@kernel.org>
To: Eric Biggers <ebiggers@kernel.org>
Cc: David Howells <dhowells@redhat.com>, keyrings@vger.kernel.org,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Lukas Wunner <lukas@wunner.de>, Ignat Korchagin <ignat@linux.win>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Paul Moore <paul@paul-moore.com>, James Morris <jmorris@namei.org>,
	"Serge E. Hallyn" <serge@hallyn.com>,
	"open list:ASYMMETRIC KEYS" <linux-crypto@vger.kernel.org>,
	open list <linux-kernel@vger.kernel.org>,
	"open list:SECURITY SUBSYSTEM" <linux-security-module@vger.kernel.org>
Subject: Re: [PATCH v4 2/3] KEYS: Replace assoc_array with rhashtable
Message-ID: <aufheZ9mR0rWqicW@kernel.org>
References: <20261029232437.2581640-1-jarkko@kernel.org>
 <20261029232437.2581640-3-jarkko@kernel.org>
 <20261101232149.GC2689@quark>
 <aufTcqW-DTB9Ofai@kernel.org>
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
In-Reply-To: <aufTcqW-DTB9Ofai@kernel.org>

On Mon, Nov 02, 2026 at 02:04:07AM +0200, Jarkko Sakkinen wrote:
> > The commit message should mention explicitly whether there are any
> > userspace-visible behavior changes or not.
> > 
> > KEYCTL_READ now outputs in insertion order, not hash order, right?  And
> > likewise for the search order of sibling keyrings.  Those differences
> > should be fine, but they should be mentioned.  Any other changes?
> 
> Keyrings are prepended, keys are appended, and while linking a key a
> match with type, description and domain retains its place.
> 
> Right now any other major changes don't come to mind but yeah that
> can be broken down a bit.

key_unlink(), keyring_clear(), keyring_revoke(), and keyring_gc() don't
allocate memory.

That is worth of mentioning too probably as it is in favor of this
change.

And because rhashtable_destroy() can sleep queue_rcu_work() is used
instead of call_rcu().

Hmm... and rhashtable_insert_fast() can cause transient -EBUSY, which
is probably acceptable.

Br, Jarkko
