Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4638D28E5F3
	for <linux-crypto@vger.kernel.org>; Mon, 15 Sep 2025 22:07:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757974051; cv=none; b=onX7vvywNc/3t9+5xuhkodZ5OMsXijH6Qazer95DY19pCXfXLMzqS05iIRjcUwU6hWcbseIjO9Jx+7iqM/8X7/W0j1Wc9cv19K6Jm4MbaLAozW+DEpQ15RV+MCnH4M0bhHasZvW+rbYBLrMkLiWjyh6PhLheQxnSzMoSXwqS7P0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757974051; c=relaxed/simple;
	bh=d+tkkxdikcjfH2KX3bzG9VUQrcUd+bY8JRGwe40aXKk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=XnhOzoFJjXiQXTUUmLm42wnQ9MCM0EfjvjzGMgpZpn30tYw1ygWXFhtuvXm19KSx2CPDGE6naSZSp3NSRNxTGy13p+US7TIHyIfVlxb9Pd1w7P+hrmhL2XpcvkEXd1qVq3fj0ZBJdW92ArBDLrO1jjQpc0+/nqu9NoqNjrhODJY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=r6u9SWIZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="r6u9SWIZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 624FCC4CEF9;
	Mon, 15 Sep 2025 22:07:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1757974050;
	bh=d+tkkxdikcjfH2KX3bzG9VUQrcUd+bY8JRGwe40aXKk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=r6u9SWIZKa9atL1xs6+zQW0xwkG8NB0PkD8+1HhT5xAAWPvejwMSnh3FiI7y1xyZi
	 JugII4rFjaQBmA+MDrwfwRy8JVo9128cOiHsnldfPeVWRgd+SWjN1QVJH2ejoDO9uj
	 aTo3FQ6jY05D1SikLleaoPU3Bo/dIYl4oJe7h2LgmMhHAQgxUX5BXSOFyuy6AUvNpS
	 CNZGjKf2zp6+wHxIcvyXXCzcADoLhKAVz6johL5OBv0a1DuzHNmFGsjfF9aKuYQIyM
	 LC/s3LDztTfsrwJFfdsDRGNyuQP2JCqc8Gki1H8P+PUfc/2IM8jL9f8OLmzYXKK3b1
	 qGxo9Rwa5Jj7A==
Date: Mon, 15 Sep 2025 17:07:27 -0500
From: Eric Biggers <ebiggers@kernel.org>
To: David Howells <dhowells@redhat.com>
Cc: linux-crypto@vger.kernel.org
Subject: Re: SHAKE256 support
Message-ID: <20250915220727.GA286751@quark>
References: <2767539.1757969506@warthog.procyon.org.uk>
 <2768235.1757970013@warthog.procyon.org.uk>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2768235.1757970013@warthog.procyon.org.uk>

On Mon, Sep 15, 2025 at 10:00:13PM +0100, David Howells wrote:
> David Howells <dhowells@redhat.com> wrote:
> 
> > I don't suppose you happen to have SHAKE128 and SHAKE256 support lurking up
> > your sleeve for lib/crypto/sha512.c?
> 
> Actually, I assuming that lib/crypto/sha512.c is SHA-3, but I guess it might
> actually be SHA-2.  I don't think it actually says in the file.

lib/crypto/sha512.c contains implementations of SHA-384 and SHA-512,
which are part of SHA-2.  The SHA-3 equivalents are SHA3-384 and
SHA3-512.

We should move the SHA-3 code into lib/crypto/, just as I've done for
SHA-1 and SHA-2.  I just haven't gotten to it yet.  Nor have I
implemented SHAKE support, which would be new.

Contributions appreciated!

- Eric
