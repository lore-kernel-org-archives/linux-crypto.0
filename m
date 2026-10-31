Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793444253;
	b=bab1MS6HlKwFAR0mnkcqgF+D8tZBrRH4jHvv6E7uWNQf4EW7KUQiVvC3fKmA+M3yCZV+
	 fmouAt/0Tq73kymrztW7tt+eV1icYMeY6UxFGoOMCY7WcMOAX0zvXgU57W/sHj5KIqgB/
	 TvI0yBn8iTjt14tbwKPg/0Yr1wxvl4PTmWFWoebzWeUYrCXxC9bcT+myHTBOd4CtfcGRr
	 05Lnn7/+SzI1Yf/YEAv/nqOVfCvZfmL+nYmKqivbXQz74TAYpd39QX6LZa6ifrksPjfO+
	 DOW9svxu7VDfPgWMQ4ERRMtBgnrqhYgzx9Zpu0VCxFgLrmoixiz6tDqQqhNHnGt9+0g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793444253;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=LiOepWnZL+dUarf0QgRNqFGHI/GzvhTs/Awt0LC75IQ=;
	b=YxE6JqHmXCkR4INCZa1VT0/7O8jcA8FjYbf1g+gFqnHSEihsS/S4RAqfcc1B/BUvZGIv
	 I65EXECtT/ZaxQn8/I9C+zpzvABCsfNp+q4iv1MgMX77G+DzuFm85+WjJYINqGJHHErrN
	 WyEKaKNg35DKEkPuB/19c7mX86K+yqYxBNP8qQE4YWA5RdsmBu9SFjuGCbKjW94JrUntO
	 a0VNvfwlGU14f8DEv+FbIGeC8HTPbIY3RX4HGlttHXg84vSlWtMWF793j1AR1NltZcOvu
	 6xHAHMc+AGh9P1PyvyEg7jtQIhdZChjTq2ToI5s9imRxv4sVeg1ZsqyKv/lRz+jWDdw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=SQZP4xbG;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34129606A31A;
	Sat, 31 Oct 2026 10:57:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=SQZP4xbG
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C47511F000C1;
	Sat, 31 Oct 2026 10:57:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793444252;
	bh=LiOepWnZL+dUarf0QgRNqFGHI/GzvhTs/Awt0LC75IQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=SQZP4xbGXeK+6+epyCgPSe9HLokUtmmLtqMJcuXRkK5xKL3WXGtRavp5u2On3USon
	 1fCldTH8/tLdyxDVc7zoGRWxboAj0PxWqn9uscm9zyQLel3mtwMYJW/dwS2fgxKJWr
	 +107sWXLkOUHBBoqqB17h+KlrlpVdGarB0ZXXUxk=
Date: Sat, 31 Oct 2026 11:57:25 +0100
From: Greg KH <gregkh@linuxfoundation.org>
To: Eric Biggers <ebiggers@kernel.org>
Cc: Jeremy.Jean@oss.cyber.gouv.fr, Jason@zx2c4.com, stable@vger.kernel.org,
	linux-crypto@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] lib/crypto: arm64: Fix lost Poly1305
 carry when resuming NEON" failed to apply to 6.12-stable tree
Message-ID: <2026103156-underfoot-spender-b534@gregkh>
References: <2026102137-contently-unshaven-7da4@gregkh>
 <20261021154806.GA1879@quark>
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
In-Reply-To: <20261021154806.GA1879@quark>

On Wed, Oct 21, 2026 at 08:48:06AM -0700, Eric Biggers wrote:
> [+Cc linux-crypto@vger.kernel.org]
> 
> On Wed, Oct 21, 2026 at 04:40:37PM +0200, gregkh@linuxfoundation.org wrote:
> > 
> > The patch below does not apply to the 6.12-stable tree.
> > If someone wants it applied there, or to any other stable or longterm
> > tree, then please email the backport, including the original git commit
> > id to <stable@vger.kernel.org>.
> 
> It's a clean cherry-pick, as git detects the rename of
> poly1305-armv8.pl.  So there should be no need to require this to be
> resent.  Also, missing Cc to linux-crypto.

For both of these, we have explained in the past why that is the case.

For the cherry-pick issue, we use quilt for the stable trees because it
can handle adding/moving/deleting things in any order, like is required
here.  Using a git tree does not.  So cherry-pick is not part of our
backport process because it's just not possible.

To make it possible, at each commit we would have to keep a local copy
of the current patches in a git tree, and then generate the new commit
from that, pull it out of that tree, apply it to the quilt tree, and
then go and regenerate the git tree (if needed).  In short, a mess and
would slow us down even more.

So yes, renames for "simple" things are a pain at times, it's just part
of the process.  Luckily Sasha's bot catch them quickly and provide a
backport easily in a day or so, so if you want, just rely on that.

For cc: the mailing list, no, we don't do that as it would make things
SO much noiser, and for some patches, a total mess.  We cc: everyone
involved in the original patch based on the info in the commit itself.
That's a policy decision we aren't going to change at this point in time
and attempting to add it for only one subsystem like you have asked for
here is going to be a mess.

If you care about these types of failures, just set up a lei filter to
catch them as we post these failures in public, that way no additional
mail needs to be sent.

thanks,

greg k-h
