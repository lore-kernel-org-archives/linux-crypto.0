Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECE5D363090;
	Wed, 23 Sep 2026 03:20:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790133624; cv=none; b=BzhN572wHtav3LcEvjR7aMC2LetOufcbXi4zQ7HpD+mBOFpMIrDz4zRzeAGGGXet2PP3p1KGvsNgZ0PagJnuars7xdIrD96A4mBUxIWEnD/nWuzLdZ0PkRXSMLq7dDbF7MmYmpwvkvuwgD2/pc8W99ygbf5c3C/xbSaT+BDQEpo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790133624; c=relaxed/simple;
	bh=UIFSKd3unESHsf8JD/moI6uRSDoY65cBg8gEjW7NJ7c=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=r/odb8bnFzgSUmxSbZKujTmEKxEDzwinU94Y9VoBu3sXpjkw70ihq/3zq64cBbF11Lfw6Isu/eyZRYVodR0y/HlGDjt+RC3cRfQab8DIY0EiZBVKT1XAvojL2SomPC2g5TjuGfcKJ5aKsMJrISvV4p+y9SEvhkenDd/1+t5K7vI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fnnZtmEZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fnnZtmEZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C19501F000FF;
	Wed, 23 Sep 2026 03:20:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790133622;
	bh=YsipP+xmOsrYr/10xUyvkzMflfM8DLrfOfD2O+p04U0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=fnnZtmEZmkqbqKfHYzpeMvZROAN+uWzfmSAUMfgphQFp0Vxo0PNcGcsQBQjXb3N7H
	 eR4emFsiT2Zy4UC632dycYhsg/91y9XGfMPOHiugYBEdDOwzsmGgp2KFwiLmxY77n4
	 rreEpZNZK5ayVVANzBsXB+mTwuQloKDEevpXu777G7WLTv/qtbzJlZvS9E8YR7Xny4
	 LQi9E6aT7maflV4F0Fab/qG5YWLMcRQ4h3DTf3ODNiuyHSVY98ezmA1jEIV0OhpqAT
	 GZHtQat8DWqKf8LaaAOpHmdH/W0Pjkr21uNnM+c5nuOt7x9Q8kHPZHxVEsPbOoDKta
	 axucrgAk7M66w==
Date: Tue, 22 Sep 2026 20:20:20 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: Thomas Huth <thuth@redhat.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	"Jason A. Donenfeld" <Jason@zx2c4.com>,
	Ard Biesheuvel <ardb@kernel.org>, Borislav Petkov <bp@alien8.de>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>,
	Dave Hansen <dave.hansen@linux.intel.com>
Subject: Re: [PATCH v4 00/13] libcrypto: Provide more __cleanup functions for
 zeroizing data
Message-ID: <20260923032020.GA42709@sol>
References: <20260916095022.604354-1-thuth@redhat.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260916095022.604354-1-thuth@redhat.com>

On Wed, Sep 16, 2026 at 11:50:02AM +0200, Thomas Huth wrote:
> Code that uses crypto-related structures (containing keys or context data)
> should zeroize their local structures on the stack after use to avoid
> leaking this sensitive material via the stack when the function returns.
> Using the __cleanup() marker is a very elegant way to assert that the
> data is zeroized without having to painfully verify that each early return
> in a function might miss it.
> 
> Thus this series introduces zeroization functions for many crypto-related
> structures that can be used with __cleanup(). The series focuses on the
> introduction of the functions - most call sights will be adjusted to use
> these new functions in separate patch series later (since each subsystem
> needs separate review from the corresponding maintainer).
> 
> Note there is one minor ugliness in the patch "Compile purgatory with
> -D__NO_FORTIFY":  Since sha2.h is also used in the x86 purgatory code,
> and that code ships with its own implementation of string functions, we
> have to compile the x86 purgatory with -D__NO_FORTIFY now to be able
> to include <linux/string.h> in sha2.h.
> 

Applied to https://git.kernel.org/pub/scm/linux/kernel/git/ebiggers/linux.git/log/?h=libcrypto-next

- Eric
