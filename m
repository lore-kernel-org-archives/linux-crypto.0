Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C493521E0AF;
	Tue,  8 Jul 2025 03:26:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751945209; cv=none; b=aJwBSnOe7nOvqhsBR67zDuViE9M9i8zP9B1acYUUqOuu9CpHhJuNVoc8IUlw5VRa4FmQ/6immaU/nVVxc5D2dtW9vtAz21TCm4dT88UDV5UNP2tkymgY41sJ4CYToauvIpsIXndQD7miFmDnLqY5seDF/27a6iWn36cpkFz+UTQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751945209; c=relaxed/simple;
	bh=uJNHHJPj7T5N6Mu10kh/u/SJoD+/kyAR2ZrQhGRJakU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=F5OS/0/S8jgda5Ke9cJi3tK9X8VKBzwKe2p8ZHg9w69fp3SgPUzmB5wD2NLz0i+37qcGL+sk5LufwE68K2NehngnoGHzKOp4J3S39rGOLLpa+/KfameisPbX69S8Bpm3reucUV5sx6WkMnFJsHM30/OzTS5Lm/KR2R4YUjy9SqQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=oz9jOUNH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="oz9jOUNH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D405C4CEE3;
	Tue,  8 Jul 2025 03:26:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1751945209;
	bh=uJNHHJPj7T5N6Mu10kh/u/SJoD+/kyAR2ZrQhGRJakU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=oz9jOUNHHaWLRjxDbzTYoI6KIkbasBP8zW0CK4y8y+oE29926CAXf6wiipikzscLj
	 t1/RUT/l7psgtxp5NN/kRt5snk603anbFpN9RG5VS1ck2FKPIQaGo+gh74qkEB5VE1
	 lDYF9QlFB4+KF4sjAL0h+nWlBZAaUawnPGjLN6MAR/JoR8wJofuohlEg66r6o9n5Mz
	 5+mxySLjh6xJQ62PHkhbeFFzs84bm6zCl/Ul9MY1YyabF2I7xil+7ONPW3IJJbxKzI
	 DntuY7AD1uwEnMviA4F95VgpSCTN9EFt1q/RseZm0aXxT60lUBcTS+AenZk5G6/T++
	 akOAyqa9aqy5g==
Date: Mon, 7 Jul 2025 20:26:05 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: Ard Biesheuvel <ardb@kernel.org>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	"Jason A . Donenfeld" <Jason@zx2c4.com>
Subject: Re: [PATCH] lib/crypto: sha256: Add tests for HMAC-SHA224 and
 HMAC-SHA256
Message-ID: <20250708032605.GA3821@sol>
References: <20250625071131.1496688-1-ebiggers@kernel.org>
 <CAMj1kXHGgYCEmQDs4CDUDqqK5QO3o2B9NmRfmQ9N-sC-Hu1yOw@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMj1kXHGgYCEmQDs4CDUDqqK5QO3o2B9NmRfmQ9N-sC-Hu1yOw@mail.gmail.com>

On Tue, Jul 08, 2025 at 01:09:17PM +1000, Ard Biesheuvel wrote:
> On Wed, 25 Jun 2025 at 17:12, Eric Biggers <ebiggers@kernel.org> wrote:
> >
> > Now that there's a library API for HMAC-SHA224 and HMAC-SHA256, update
> > sha224_kunit and sha256_kunit to test it.  This mirrors the tests for
> > HMAC-SHA384 and HMAC-SHA512 in sha384_kunit and sha512_kunit.  The test
> > vectors were generated using scripts/crypto/gen-hash-testvecs.py.
> >
> > Signed-off-by: Eric Biggers <ebiggers@kernel.org>
> > ---
> >
> 
> 
> Acked-by: Ard Biesheuvel <ardb@kernel.org>
> 

Thanks!  FYI, the latest version of the tests is in
"[PATCH v4 0/4] KUnit tests for SHA-2 and Poly1305"
(https://lore.kernel.org/linux-crypto/20250706232817.179500-1-ebiggers@kernel.org/).
Sorry for the confusion -- this was an incremental patch, which was
superseded when I started a series for the tests from a clean state.

- Eric
