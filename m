Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DBD741D10A;
	Wed, 22 Jul 2026 16:20:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784737243; cv=none; b=Its2Z1rRimNuq9oQdwvwsY5aJUjylY4QjlNr9fgOg7W+KBiUdcq+UB+8ErsGg9A7rHFdW1Eb05P4d4z+FTM+uGkNcLFYDf2KI4hYDnZEu+JUwB0T6y8tGouOs1ZAfzyy24gDdrVnk4Gj7eSeSbDgM+lXvqK6rb906Hcmn/5sm1U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784737243; c=relaxed/simple;
	bh=ko1nD3riK0WkNrw9/nLRc62E2PQBCo3M4PL8aYTl7/0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=EzQjef/Xvxu7HUtE6YD4yJ3edJn0NW67ZtSHuMr7IUIhBFBDVvKUoA97jf/pxxi5kJSBlB9HRXpUxSZSAB8Z8z+qgoxwt/FnNGMTtsMY4SNFdRb5qM93ojTbHWQkMgZROYqAz5vnr2iHfKsa5MSzUvJxiosp+8fEa1/WVMh30O8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XFRfUPAB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XFRfUPAB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 830351F000E9;
	Wed, 22 Jul 2026 16:20:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784737242;
	bh=1Exwl0AsGwf6M6S13oTNWhmNyTBsKTiqZ5UEvnNJspo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=XFRfUPABWpzjJ7fOkBcKIqJ4BWV+1eBvjFuNRgixzas8vrIhpRievAN+vHwpRM9tG
	 RfgbtQd3Bu08Vv4/ka0sxj+j+psYSiVNox2dCK5uXC0oJ9L0nM1Wugrpi2YutCqSSJ
	 doFwvVXvqg4TrXdU67FEBE4Srxo8uJxwCynncGWgDm3/dcCbqqKcMm/EYDiZGB3yK+
	 C9PNJNsepyuoWb1EeN+6hxnUwxSL9HVeLYQ5rxr1STHBu8xDsWO1te4hVGdz9rQZyU
	 BTKfcGrAOtxZYe3xH5y6ZHcdKjWy3P3bkSvEIke5NKhzbRYmnBHnHRRXrJklq7l99l
	 yuquli/u/mWbw==
Date: Wed, 22 Jul 2026 16:20:40 +0000
From: Eric Biggers <ebiggers@kernel.org>
To: Bartosz Golaszewski <brgl@kernel.org>
Cc: Demi Marie Obenour <demiobenour@gmail.com>,
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Russell King <linux@armlinux.org.uk>,
	"David S. Miller" <davem@davemloft.net>,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	linux-crypto@vger.kernel.org, linux-arm-msm@vger.kernel.org,
	stable@vger.kernel.org
Subject: Re: [PATCH v2] drivers/crypto: Mark QCE as BROKEN
Message-ID: <20260722162040.GC2794619@google.com>
References: <20260712-qce-broken-v2-1-b2dfff47f7f5@gmail.com>
 <alnlaCXmoLRAlr96@gondor.apana.org.au>
 <20260721082501.6128-1-bartosz.golaszewski@oss.qualcomm.com>
 <c826b73d-6307-4237-a065-b7a8487350ce@gmail.com>
 <CAMRc=Me55rUmjjR+ZzdWd2ss9JJMZzJch0zKd4GqONBjCzFMYQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMRc=Me55rUmjjR+ZzdWd2ss9JJMZzJch0zKd4GqONBjCzFMYQ@mail.gmail.com>

On Wed, Jul 22, 2026 at 01:33:51AM -0700, Bartosz Golaszewski wrote:
> > Also, what can the current driver do that cannot be done better using
> > software crypto?  I understand that you have future plans to add more
> > features to the driver, but those are not relevant to this discussion.
> >
> 
> We can offload crypto operations to the QCE saving CPU cycles but more
> importantly, the QCE provides HW based isolation which some vendors care
> about.

Do you have any concrete proof of anyone using this with a specific
Linux kernel feature and actually getting a benefit from it?

Just for some additional context, I've been on the Android team for many
years and have worked with lots of companies shipping Android devices
with Qualcomm SoCs.  I also upstreamed the support for the
Qualcomm Inline Crypto Engine (ICE)
(https://lore.kernel.org/all/20200710072013.177481-6-ebiggers@kernel.org/
https://lore.kernel.org/linux-mmc/20210126001456.382989-9-ebiggers@kernel.org/),
which is what people actually use and isn't the same as QCE.

The only times the Linux QCE driver has ever come up is when someone
used it accidentally and it destroyed their performance (due to the
20-60x slower performance than the CPU) or caused a filesystem hang.

These issues get reported to me -- sometimes even from Qualcomm
themselves!  It's kind of annoying.

(Fortunately it's also quite rare, since the vast majority of people
just ignore QCE and don't make the mistake of using it in Linux.)

As far as I can tell, what actually works and what people actually use
in Linux on Qualcomm SoCs is:

- The Qualcomm Inline Crypto Engine (ICE) for storage encryption

- The ARMv8 Crypto Extensions everywhere else, e.g. dm-verity

> These are future plans, yes. But right now we do have active users of this
> IP

Just because it may be used by the Arm secure world doesn't mean it is
useful in Linux.

- Eric
