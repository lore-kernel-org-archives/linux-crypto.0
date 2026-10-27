Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793070033;
	b=1t3hTL25RSFnUC1WDxnlcKdOVIgQ/9tupQICYeMxB5LogDjTrvrcwchyB6NIMFWPlNxk
	 +BF8X/T5LZagC4Rp+I3a+KOi/VliaUOEVCohI8xXjb7fwwMA+Avrz6RJWFO9UHf2IYRQR
	 8lwy5UZWeyA6rba+c+4OTE2b+5Yp1tg4xPy9ldzO7ayNvHASUXovAWFq25cQr4XTNNlHh
	 G+N0ybHaBAepLymtIvQtAO7gebXmwkiaVViILHoNH8wftts2lI6aAUMZwxi7YLRAvaaKH
	 8vHkyGxVDvmTkMYfaQuQ3spzDdjYLN7uqTAvGgVXGxh3TRMZWH0bdCL+6XPWANsVzsA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793070033;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=lKhTX8jV992cZSDtvu50HbQH6/3y4kmCt2rxZs7+nY0=;
	b=A9nVj2RBvUFbOdOd9mJpiLCG4Ev3a03hN2P1J39wApFQrXeTiD6bqXmXOMAZOuviqrfb
	 FUenz0k0NHoDAAECn7EFMq7gUt+nN3H6G2hWQH2kTrJy+spyKUrXHv/n2Im1zdrSq8iwY
	 hmARHtiRvPML1MmUp8iUzREfaaRPCtLAa1pTTveiRK5Dm6CBy1hkEKsAUxXzQe+P27V6z
	 v4u01nfcw9VcdXuI7Opy1E+4UajDfa/Yc3ms6EWz2d6Jev5EAa/RGvT8pZVO9MfrkkPL8
	 I3EDOsQ7yxT14sZOaAb37Q32UPqonc1Dje7POkDhOf4rXEp2tgNiYGAvNj4eP3GsXhw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=JEzxD8SD;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with UTF8SMTPS id 6A295606A31A;
	Tue, 27 Oct 2026 03:00:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=JEzxD8SD
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 7D8081F01828;
	Tue, 27 Oct 2026 03:00:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793070033;
	bh=lKhTX8jV992cZSDtvu50HbQH6/3y4kmCt2rxZs7+nY0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=JEzxD8SDw3FOluxtjErzlh/xaF0pqAsQucbE8RAUUpQc00O38s9HVD+CyJFXjSWUG
	 0eDEgLnkvnsxWII7h03f1JoH/28QV4xpL2lgZcUqVgfli9vwT+2BRJIe9UO/QWPQU3
	 a2XNMWDRflCXueResgDKryjdv+aUSiXW4z9F8cQ/jdQLMEs5RUecf2T0x1ClSJL3aS
	 L7Ed9RJeCUhbLdoe3RGxrcdZMVFnD62SyxlAyNxT78lkn10IKPB7LALaP3/1rUwnz2
	 XCjHe2HFXnIBl+w1LU8wuEp/0lUB88i5Ni5iOi1y6ikc2HMXihZ2lft2xmvnjUJWxa
	 6g2FkxMY3TqpA==
Date: Tue, 27 Oct 2026 05:00:29 +0200
From: Jarkko Sakkinen <jarkko@kernel.org>
To: Eric Biggers <ebiggers@kernel.org>
Cc: David Howells <dhowells@redhat.com>, keyrings@vger.kernel.org,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Thomas Graf <tgraf@suug.ch>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Paul Moore <paul@paul-moore.com>, James Morris <jmorris@namei.org>,
	"Serge E. Hallyn" <serge@hallyn.com>,
	open list <linux-kernel@vger.kernel.org>,
	"open list:RHASHTABLE" <linux-crypto@vger.kernel.org>,
	"open list:SECURITY SUBSYSTEM" <linux-security-module@vger.kernel.org>
Subject: Re: [PATCH v3 5/6] KEYS: Replace assoc_array with rhashtable
Message-ID: <auATzQtE17gPccOG@kernel.org>
References: <20261025001105.1824178-1-jarkko@kernel.org>
 <20261025001105.1824178-6-jarkko@kernel.org>
 <20261027012952.GC2395@quark>
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
In-Reply-To: <20261027012952.GC2395@quark>

On Mon, Oct 26, 2026 at 06:29:52PM -0700, Eric Biggers wrote:
> As I suggested before, I think the hash field (here and in struct key)
> should be changed to u32, since that is all that is used now.  Also, the
> SipHash value can just be truncated from 64 bits to 32 instead of
> "folded".  Also, the pointers can be used directly in the computation
> once again, now that they're no longer needed for the assoc_array key.
> (And that means the domain_id and type_id can be removed.)
> 
> Are those simplifications planned for follow-up commits, maybe?

No this is my bad. I'll fix it for the next version.

Sorry about this.

Br, Jarkko
