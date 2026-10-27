Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793069779;
	b=ihWjj9QOwjJPr2J6mI1TfQ7+G9bCmIpt9iNzp6Xya0Kl1SRQXPT7qh0V4GLE2qoV6h5Q
	 1YSy6X3qzuy/iUTRzeugr+FKIvyTSNQghmIFOqT2LApC9afi8TtCpIAMTnRV9N2EktrAg
	 w1oowqfJsSQRIIyBITBzhgjSsBG2XO77v76wfQvyyZTXpsMAllBa1ABZ7vXuB2oadi6+0
	 3xCOWwAf2qb91Z/eKzAypNvLt70bZqxT0A4s3au1DoyxfChRU5zShhCK87M90WD6ojuhA
	 ELJjw4pslfFjkLNoP9y8P37qc3WqG/O60wxiwVi/9wTS1NmHEIoeKmLeSHDg5s5+QyQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793069779;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=5+bSpsav9ajafaOjuuZVYt9mGy8UVMJPb0ab7VCbVbc=;
	b=Rt8jHm9ZHpz50w6tR74b5JGYVQnRKl3RCDD5pF7GS4AZ0/BdjnYNyGPWff89MeAQoTV3
	 fQjshXYmAPotX7rgtu27ETceGdaxDmZVvriFolW3NnpGpjqT/i4n1P48FfZkJZwB03dBa
	 baoAs8oeUL47BuL3linAh1E65cqKXy/3+ySOboyKbKJi4fxuLdeFXPQdMYDV/Jpnp6iKW
	 lQtW/wCEYddtv6jM5vrTZYcAFANUEsk3cZjgA8wUVFmcDLr4q0Y4mFCqR6U6rdeWmetrG
	 X6ns4VVrAXp2rvJ8SkxanXeRaiPyHik1VA1RnAgTs4pW+PnRm91PLz6shpIst2weLMA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="FjEN/xs0";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with UTF8SMTPS id 39C3D606A31A;
	Tue, 27 Oct 2026 02:56:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=FjEN/xs0
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 49A8D1F031E1;
	Tue, 27 Oct 2026 02:56:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793069778;
	bh=5+bSpsav9ajafaOjuuZVYt9mGy8UVMJPb0ab7VCbVbc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=FjEN/xs0y+W++/4yOCkNK/IMavx5di/a6GysOHnwyFk5gua1YUUaBr2RxDv9dNlFD
	 WSgI/i6qVzf/VZnxO1mXeos5moZLNI6XWUHpwQ9+TYT1cC/vwf94CMD9qT11wRp5Rz
	 IgipH2c3GanRIRErcU+wcu/noMXHqnwQTblJlPu3FaEGCQCrE5SB+cOEQ7U++69AMf
	 bAERp14c4QkkTB7+4wuCidam58llkY+bhA4iFH/TGwHyAuJSMtoTYxxLtyr5zuyKU8
	 pykMH4+wavbXRXobvr4SIRWNJamWZksIoeZUL0DOebn6+bHnYztudTd/KoGUpMD5F7
	 5HvKEh0VslKEg==
Date: Tue, 27 Oct 2026 04:56:14 +0200
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
Message-ID: <auASzrhH1Q0linVB@kernel.org>
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
> How about replacing 'struct keyring_link *edit[2]' with a named struct?
> It's kind of hard to remember what [0] and [1] are.

I'll look go through rest of the comments later but since it is two vs
one with using named struct (David propose named struct) let's go with
that.

I.e., along the lines of:

	struct keyring_edit {
		struct keyring_link *new;
		struct keyring_link *old;
	};

> 
> - Eric

Br, Jarkko
