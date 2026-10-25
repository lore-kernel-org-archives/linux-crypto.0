Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792944526;
	b=0ZcLHVWfx86XUPWq8lYbGRyZtTwJd55HLKE4PylKGMo0k0UT87QyrEVSf5FMkpsXCW8V
	 TkCk6nghh39tQgLsu30q68XE+cbOSizN1z39/64u6Rb5hVIbF4/DRDdg4ZgvsPVT5fakG
	 uEu+titUX/1pnXvil0kxRbClnRgkdt6xnoNh5nP1MSzK4kOKDMnHyQhZvaJNr/ng61z3h
	 z+YzlRmYBhIE21m9xJ1OgAZx0MkQfW5CteBdXJGRRqkHiaexnicnGeEhImr2CLTqOr2hx
	 fNK0TWqEBY/VCCxmjvALNmeoA7+jaBqH/iLPdMuJoqVQeYXDyIXIn2Bc9EUOyBKb08w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792944526;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=wifr5zzTF3TQvz2Xh3p1HaEnvfYwiN/Xzggl3UWS6p0=;
	b=LGTIpTaHR3CX2mVj3eEFigxFSr8QRlaqZH5kfbgKdUuz19rAU1GmWGbRddcXZhYrYvSn
	 Xku8vaIfnKZvIiV+qO+OSz/8CiThA/+HdXzH6VWYozMeFmmr41i6dQXEv3oDh/lAJoiF4
	 9iS00PKlUlJ0CePalqTHUTvc4gWm89d1OLk8ZOY8gKEbcs195UYzDaOW5TOQHFU+eDjrv
	 YEZeTagTmWgT5rj9TWk06KiWCdhcROOQYjeNNRAgKZgiukfjokR8g40KxDH9LJVEr5U86
	 Aav5pBnOHzUzI8Q0JlKdJaEzyxZzb426ZZFIQwgSTAp8XOebUXdxwnWx+GCzR9+opUQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=WutzxoRC;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with UTF8SMTPS id 10926606A31A;
	Sun, 25 Oct 2026 16:08:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=WutzxoRC
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 2F1631F01829;
	Sun, 25 Oct 2026 16:08:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792944525;
	bh=wifr5zzTF3TQvz2Xh3p1HaEnvfYwiN/Xzggl3UWS6p0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=WutzxoRCxsJJQfowOaNs/6+EdJZosVcaJMVQtyTqTXI9JPKt8whZ8MUruQLSVqi3j
	 rPFd+C4reX68R3jV6mRkReOwUejzdL9axq4jRrvATbMdPBahlZPi9YbuZ1r08GlQZd
	 mVWUCutFwQd3oJ6MBtxM352ILoVDfQBm9xetUBF4iQbPW3zyrW9SRcCzB2t7EhGMs1
	 pQCHU809MbYa0pA5NZD6o4TygdlarGlK2mupdSvPwMWRpYM5vQWsoQeggdSKSRJmRY
	 6JDEe9HunHWJHz2561gwFxJ+b3NG2e3DGNflQdqUV6FH7kuSHUF8Z4Ex1yYQhdJebt
	 pyKh/tUmEo1Bg==
Date: Sun, 25 Oct 2026 18:08:41 +0200
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
Message-ID: <at4pidcRs9cs52pZ@kernel.org>
References: <20261025001105.1824178-1-jarkko@kernel.org>
 <20261025001105.1824178-6-jarkko@kernel.org>
 <sashiko-outbox-183965@kernel.org>
 <at15GLaxaMgRONYJ@kernel.org>
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
In-Reply-To: <at15GLaxaMgRONYJ@kernel.org>

On Sun, Oct 25, 2026 at 05:35:56AM +0200, Jarkko Sakkinen wrote:
> On Sun, Oct 25, 2026 at 01:05:06AM +0000, sashiko-bot@kernel.org wrote:
> > kernel/bpf/keys.c:bpf_lookup_keyring() {
> > 	struct bpf_key *bkey;
> > 
> > 	if (!bpf_keyring)
> > 		return NULL;
> > 	if (!READ_ONCE(bpf_keyring->keys.nr_leaves_on_tree) ||
> > 	    !READ_ONCE(bpf_keyring->restrict_link))
> > 		return NULL;
> > 	...
> > }
> > 
> > Should bpf_lookup_keyring() be updated to call keyring_is_empty(bpf_keyring)
> > instead?
> 
> I don't have this file in my tree and git grep nr_leaves_on_tree gives
> nothing.

It's in linux-next.

Br, Jarkko
