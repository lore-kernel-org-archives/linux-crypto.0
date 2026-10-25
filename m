Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792899357;
	b=BDMeJ2c39+ljoDtvIbrApVbOtJ9F+lr/2VzkgIcm5qGLmazOQGkr7nbcwae2T5QmS+no
	 xEnRREOktQTJuDMMU8Rp9ziCMhJRvnUTcXDor0OSHqETnMoVQJnzlItz8RC0/wH9nzO9c
	 GCtva2FUxRE4Ig2cOrVZuOugIFuSlmT0v5yjcO7dQH/pTIXBUW+MyWzhdpCDvfaaDAVyi
	 Bb/j5f2tAawVteBylkJUN+poiKtgKYWiE6vM6incAm7PFMOo5uK2laL8T3XNMfn+nifE7
	 j99Y/aOOvS6v5fQ3+6IXHNsVKGQuVOQTqq7eKLbGSbAqWkmX1t0SHhFzgSNWPnCjn0g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792899357;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=FmXgbLb2eu8UPTUou9likIbWaqH/8wlcxMjDZS1qE9I=;
	b=vkd46Ts28D5QDILkVDTFG90ufjscWKqJg/Amah2sC46AcrQWM6DIXATxytgGxs+wzl1s
	 t5yR7Egpj38b0XcF+KBTQlNO+Y1btg4qBdk6cja8CY4lqV3VgUzS/C2wNHDNs+W/hcCYW
	 zGIdDW0awMFIDF4cZRZREvaqvPeayKWS0lAvr9m4Vf3xmgl6372SbfCh9YnJZUOSZKxcK
	 vBKkc0kEflK6CP91gsHeHP0G/CQo3jEeZvio/4EhebKf5KIhEj/xVVXI7NTFtrWaNXNzX
	 FbiqiimqjFvXVyFw3Z8xeI+lVWJEooErzZ0gtFcAK/MstaZcT0aTmp98NGGEAhN2Yzw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=mlv76WgW;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with UTF8SMTPS id AA0B3606A31A;
	Sun, 25 Oct 2026 03:35:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=mlv76WgW
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id AAE111F01825;
	Sun, 25 Oct 2026 03:35:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792899356;
	bh=FmXgbLb2eu8UPTUou9likIbWaqH/8wlcxMjDZS1qE9I=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=mlv76WgWT11G9JPvasaYbsQKatT0HIr15I6dvLZpPbUNeWA+6xhoOIaHseueBBiI9
	 zrk0XSCZ1VDqXAkwhvJ7ngGuFUrgazUa5vFH1r8d63MojpS8vVxKd0s6a4f2bUjDoz
	 Wpd2pGjsob9UnuMZvsxKJnQMRl9TybjG3GS4lFrxIGz04DTFSwXIYjbuRmAaUijUYz
	 OyWE5rD33zpx7b1zQSgP5RaI59Du7aUgtMiaCM6O851cA7BSpNz76itDqvFwJ40v70
	 oDg2YiopLbVIjmaV8mBqyGKlZWpHaw6+rj/juZsKUxrZ3mLtTngjYMhxnNzkO3FIh3
	 VEzACdb8YesPg==
Date: Sun, 25 Oct 2026 05:35:52 +0200
From: Jarkko Sakkinen <jarkko@kernel.org>
To: sashiko-reviews@lists.linux.dev
Cc: David Howells <dhowells@redhat.com>, keyrings@vger.kernel.org,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Eric Biggers <ebiggers@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Thomas Graf <tgraf@suug.ch>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Paul Moore <paul@paul-moore.com>, James Morris <jmorris@namei.org>,
	"Serge E. Hallyn" <serge@hallyn.com>,
	"open list:RHASHTABLE" <linux-crypto@vger.kernel.org>,
	"open list:SECURITY SUBSYSTEM" <linux-security-module@vger.kernel.org>
Subject: Re: [PATCH v3 5/6] KEYS: Replace assoc_array with rhashtable
Message-ID: <at15GLaxaMgRONYJ@kernel.org>
References: <20261025001105.1824178-1-jarkko@kernel.org>
 <20261025001105.1824178-6-jarkko@kernel.org>
 <sashiko-outbox-183965@kernel.org>
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
In-Reply-To: <sashiko-outbox-183965@kernel.org>

On Sun, Oct 25, 2026 at 01:05:06AM +0000, sashiko-bot@kernel.org wrote:
> kernel/bpf/keys.c:bpf_lookup_keyring() {
> 	struct bpf_key *bkey;
> 
> 	if (!bpf_keyring)
> 		return NULL;
> 	if (!READ_ONCE(bpf_keyring->keys.nr_leaves_on_tree) ||
> 	    !READ_ONCE(bpf_keyring->restrict_link))
> 		return NULL;
> 	...
> }
> 
> Should bpf_lookup_keyring() be updated to call keyring_is_empty(bpf_keyring)
> instead?

I don't have this file in my tree and git grep nr_leaves_on_tree gives
nothing.

Br, Jarkko
