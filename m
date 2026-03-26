Received: from outpost1.zedat.fu-berlin.de (outpost1.zedat.fu-berlin.de [130.133.4.66])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22A4324634F;
	Thu, 26 Mar 2026 21:51:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=130.133.4.66
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774561869; cv=none; b=CMW+ZapdpOXMRQKH80HBJNuyMtRHHW+2hn8bTMwvlkYZjX4cF2e2t+XdvzfOO6J/sJZTeBnr+h7TgB3mDJsMO6SyePl80Oi/BoXom4mZRc3IrNn85gcduS8IOVZZk8WpER6013WVOo5Zb+Avqgf5UWReRZnr5sE15omKwTLm+oc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774561869; c=relaxed/simple;
	bh=JIsE8mZXSBSnw3btTBH1yhw7CfOJRenL/+5MjUo+8kg=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=owxsmJTmkt/iBmnSvBJ/Rjd5x5n3to4gJy+1Gv6PxyHjJVygDKy2afy7WmcwIB813Gsy/mgXnNT5rEQ4e4d4RoV2c34FtXF/1fIhpKDBHcP9EXIt8xZaDpAEB65c0cA8oT+/TcNT5BxK4VaBYuinrEIMbRn4pf8vx6yLsm7KE7E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=physik.fu-berlin.de; spf=pass smtp.mailfrom=zedat.fu-berlin.de; dkim=pass (2048-bit key) header.d=fu-berlin.de header.i=@fu-berlin.de header.b=aReQNPQ3; arc=none smtp.client-ip=130.133.4.66
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=physik.fu-berlin.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zedat.fu-berlin.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fu-berlin.de header.i=@fu-berlin.de header.b="aReQNPQ3"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=fu-berlin.de; s=fub01; h=MIME-Version:Content-Transfer-Encoding:
	Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:From:
	Reply-To:Subject:Date:Message-ID:To:Cc:MIME-Version:Content-Type:
	Content-Transfer-Encoding:Content-ID:Content-Description:In-Reply-To:
	References; bh=pAoptWm0FRGT8qZC/KWbCD/tew/2HHHEg6sNfTm9Ngs=; t=1774561865;
	x=1775166665; b=aReQNPQ3fX5J+WeyzRq+pOpbfS7QigTe/kHmnnrOfb6/sqt8n5eEw3kk7lAAX
	MRNyTBdBTqpNnQb4vjy6SgZyhlMTBAeOe3il93t3VJrGJtnbmxvXK6bY6I67XxkoXwdhuNyAatKs5
	mTuFKAQwWaYLR1AvOZuhPMKUtxV8AYpFTIWBW1L4L0F1XfjQLc6BC2k7pCL5uj7tPGmh9wyXNGgV3
	JoEv9b2Ud4Cnr25r8i7dWYDOqI7mXV9D9vc8uIRp/dKiDUM0ivbmibFsMrYvYGDBTlvj+xdhSAP46
	t+V+JBMwnCpg3z4CPAAcV3zwYvfSo1F34s9rm2J4G46lf4ObGw==;
Received: from inpost2.zedat.fu-berlin.de ([130.133.4.69])
          by outpost.zedat.fu-berlin.de (Exim 4.99)
          with esmtps (TLS1.3)
          tls TLS_AES_256_GCM_SHA384
          (envelope-from <glaubitz@zedat.fu-berlin.de>)
          id 1w5sbW-00000000p2b-0p4v; Thu, 26 Mar 2026 22:51:02 +0100
Received: from p5dc55f29.dip0.t-ipconnect.de ([93.197.95.41] helo=suse-laptop.fritz.box)
          by inpost2.zedat.fu-berlin.de (Exim 4.99)
          with esmtpsa (TLS1.3)
          tls TLS_AES_256_GCM_SHA384
          (envelope-from <glaubitz@physik.fu-berlin.de>)
          id 1w5sbV-000000016EX-45CJ; Thu, 26 Mar 2026 22:51:02 +0100
Message-ID: <fc5a80f3579d642a9f792a33b0f7ef6101838f83.camel@physik.fu-berlin.de>
Subject: Re: [PATCH] lib/crypto: sparc: Drop optimized MD5 code
From: John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>
To: Eric Biggers <ebiggers@kernel.org>, linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Ard Biesheuvel <ardb@kernel.org>, "Jason A
 . Donenfeld" <Jason@zx2c4.com>, Herbert Xu <herbert@gondor.apana.org.au>,
 sparclinux@vger.kernel.org
Date: Thu, 26 Mar 2026 22:51:01 +0100
In-Reply-To: <20260326203341.60393-1-ebiggers@kernel.org>
References: <20260326203341.60393-1-ebiggers@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.58.3 
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Original-Sender: glaubitz@physik.fu-berlin.de
X-ZEDAT-Hint: PO

On Thu, 2026-03-26 at 13:33 -0700, Eric Biggers wrote:
> MD5 is obsolete.  Continuing to maintain architecture-optimized
> implementations of MD5 is unnecessary and risky.  It diverts resources
> from the modern algorithms that are actually important.

Why is it risky? That makes no sense. I also don't see how it diverts
resources as no one is forced to work on the code.

SPARC is an architecture used by hobbyists and in space these days (in
the form of Leon). I don't think any other kernel developer will have
to take a look at it.

Adrian

--=20
 .''`.  John Paul Adrian Glaubitz
: :' :  Debian Developer
`. `'   Physicist
  `-    GPG: 62FF 8A75 84E0 2956 9546  0006 7426 3B37 F5B5 F913
