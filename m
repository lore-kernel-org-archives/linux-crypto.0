Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BDDB442C
	for <linux-crypto@vger.kernel.org>; Mon, 11 Aug 2025 18:00:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754935203; cv=none; b=W5hyxnR26qQvA68KcdMELYn6Ye1zY2HAHERdJ37CEnQdsy90MD3U81k6tTXB9xWsWWLcSiiQn34lFN52TeDjLZ2JjdKOzEzeqKycmv44QB2U/BlY1txprrPUtXmAJS0CEp5BsdAdVd1tjJsVz4KEQs5pLwISwj5KK9ux3r+OyYE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754935203; c=relaxed/simple;
	bh=8vzQuetsLXg0HwfWMiIJPMldEAboun02FxWMucqqDRo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VW1yA8M/iefxAeWAJGg0SAy3emrMsSOO6K1MeCSmlHqK0ebx/XO4WCjjzQC49yrDLFnctbsKEa1K8J5nIfeitUzVBEN2yLic8VL4CqLbRU5jjasnqqdA/tBPSrS+0MYfgkt8rW4pUQHQ3zcu2w43lthWOKs7gial/BmQ/aT/u1M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=qi/hjjqd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="qi/hjjqd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D84C8C4CEED;
	Mon, 11 Aug 2025 18:00:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1754935203;
	bh=8vzQuetsLXg0HwfWMiIJPMldEAboun02FxWMucqqDRo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=qi/hjjqdeywoikNc+zBb80o7kjZDg0DKEOZIbfe83oO9PGiYZl0wG5Z+FSEHx8Sbx
	 fS6Nu1//mT2W+SeH3UxEUSLl8bX5ZRZWHJycsABb9Fw9QCgBE8zfiPuG1nrJqo34uw
	 zjmyRiawLIfm/2LAWS2GVD8uk2+ICkgwkQ3/W8iP0+3IzKsX9VmDa9mS0MVhT+A0Pg
	 hgRgu7sp8PitvM4uz06xE+MLmM38fLlVWSegpRom+aHo09eB5PK3shDejhZR6j5qs5
	 BPy7ycTJ50TI+YS4n1MCOPiygtJPyC9Rz6a4KkhMwKtemcq7cSvkVnKHvIZGJetP3p
	 RZ0lE2xyuIosg==
Date: Mon, 11 Aug 2025 10:59:01 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: Ard Biesheuvel <ardb@kernel.org>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>
Subject: Re: [PATCH] lib/crypto: sha: Update Kconfig help for SHA1 and SHA256
Message-ID: <20250811175901.GF1268@sol>
References: <20250731224218.137947-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250731224218.137947-1-ebiggers@kernel.org>

On Thu, Jul 31, 2025 at 03:42:18PM -0700, Eric Biggers wrote:
> Update the help text for CRYPTO_LIB_SHA1 and CRYPTO_LIB_SHA256 to
> reflect the addition of HMAC support, and to be consistent with
> CRYPTO_LIB_SHA512.
> 
> Signed-off-by: Eric Biggers <ebiggers@kernel.org>
> ---
>  lib/crypto/Kconfig | 10 +++++-----
>  1 file changed, 5 insertions(+), 5 deletions(-)

Applied to https://git.kernel.org/pub/scm/linux/kernel/git/ebiggers/linux.git/log/?h=libcrypto-next

- Eric
