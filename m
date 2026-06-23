Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBF882EEE76;
	Tue, 23 Jun 2026 19:27:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782242838; cv=none; b=PKv6TGhfBAkuiN4QSPbHd2qHsseazd0/MUOQFz37sthD+x4Swkf/HJwUj74jaxWsABpw7Xn+qGY3M97HO4EZlmTWSoJjqUdAWtV0CFAMcyFLNK7y0jUzMkw0TswZZvb4EOUqk8VSA8PW1XTlP5PmyWXEm7dptAI1Kc89CUlVHkY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782242838; c=relaxed/simple;
	bh=2KJfRK22qPHqPlSQ7laJvZzY9EPo8tNFmh5LwYjJVAA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=BnKSnOopW6vnkNLoSDSuxRbtX8pq+NgjWpzCGDEwnjKc7EIFzMpHw2sOH5RN3l0sWn/JyynFNhPMCSe8r69fZNsE9QfnNtyGyW4onQlYrbyxFaA3RgZRi7dKTDKNyZrR0W/lQse2xen2bHXqwbYZJf0ouZ6cMILkrn8oJBHGEWE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bhzsFAv0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bhzsFAv0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 297041F00A3A;
	Tue, 23 Jun 2026 19:27:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782242837;
	bh=Vx0xBhWXoD0/wcgGQZEU4J6SmCb/tDhz6iSTgY8qfFY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=bhzsFAv04xUrIB0db4eztSrtKaxiQZAkcawWuf4KiIsGugIVFXQ4iVjMbEzQi7UuH
	 LHpkBlsXvuKQ662b1AwuyU44ytpVeT6b59Um4mbexEPok8PVPCoBD516PWtpQVBEGm
	 4egsqZ1NaedsXakGLdrsXMLrFXe7I6I7sa9mw67nbUGPcnu6vGGZhLeXHInVqBYRax
	 Vap9RTwNKHNtqrK2Bx92OeynNCCDHZ+dW+Wwp3vhV8aw90QWby7QG1GPU3Nvg+zDxC
	 TIXPCPnYbuXSJSdD8G3HoAMomDelkSMKNTeHBKhUHfoPcYov8/KjMgCjU0h1LoYnNK
	 HAt+C9YWgr2vw==
Date: Tue, 23 Jun 2026 19:27:15 +0000
From: Eric Biggers <ebiggers@kernel.org>
To: Andy Lutomirski <luto@amacapital.net>
Cc: linux-crypto@vger.kernel.org, Herbert Xu <herbert@gondor.apana.org.au>,
	linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
	linux-bluetooth@vger.kernel.org, iwd@lists.linux.dev,
	linux-hardening@vger.kernel.org, Milan Broz <gmazyland@gmail.com>,
	Demi Marie Obenour <demiobenour@gmail.com>
Subject: Re: [PATCH] crypto: af_alg - Add af_alg_restrict sysctl, defaulting
 to 1
Message-ID: <20260623192715.GE1850517@google.com>
References: <20260622234803.6982-1-ebiggers@kernel.org>
 <CALCETrXPj0u=FZ=aFcZAHk3fFZa7rCuPEjx6cOMXmT3sdkC7SA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CALCETrXPj0u=FZ=aFcZAHk3fFZa7rCuPEjx6cOMXmT3sdkC7SA@mail.gmail.com>

On Tue, Jun 23, 2026 at 12:12:24PM -0700, Andy Lutomirski wrote:
> On Mon, Jun 22, 2026 at 4:49 PM Eric Biggers <ebiggers@kernel.org> wrote:
> >
> > AF_ALG is a frequent source of vulnerabilities and a maintenance
> > nightmare.  It exposes far more functionality to userspace than ever
> > should have been exposed, especially to unprivileged processes.  Recent
> > exploits have targeted kernel internal implementation details like
> > "authencesn" that have zero use case for userspace access.
> >
> > Fortunately, AF_ALG is rarely used in practice, as userspace crypto
> > libraries exist.  And when it is used, only some functionality is known
> > to be used, and many users are known to hold capabilities already.
> > iwd for example requires CAP_NET_ADMIN and has a known algorithm list
> > (https://lore.kernel.org/linux-crypto/bcbbef00-5881-421b-8892-7be6c04b832d@gmail.com/).
> >
> > Thus, let's restrict the set of allowed algorithms by default, depending
> > on the capabilities held.
> >
> > Add a sysctl /proc/sys/crypto/af_alg_restrict with meaning:
> >
> >     0: unrestricted
> >     1: limited functionality
> >     2: completely disabled
> >
> > Set the default value to 1, which enables an algorithm allowlist for
> > unprivileged processes and a slightly longer allowlist for privileged
> > processes.
> 
> In our brave new world of containers, this is a bit awkward.  The
> admin is sort of asking two separate questions:
> 
> 1. Is the actual running distro and its privileged components capable
> of working without AF_ALG or with only the parts marked as being
> unprivileged?
> 
> 2. Is the system running contains that need the unprivileged parts?
> (Which is maybe just sha1 for ip?  I really don't know.)
> 
> Should there maybe be two separate options so that all options are
> available?  Or maybe something between 2 and 3 that means "limited
> functionality and privileged modes are completely disabled"?

If we want to offer more settings we could.  I could see this getting
quite complex pretty quickly once everyone weighs in, though.  There's
quite a bit of value in keeping things simple, even if the offered
settings won't be optimal for every case.

- Eric
