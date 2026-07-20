Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9450E4499B1;
	Mon, 20 Jul 2026 18:01:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784570520; cv=none; b=LA0qsQv+aJEh1EwN+ISYTKdWW1pE6zqbJVwy8/HY4WH/L6S38vaAIgSjhm0d/lWGoEgw/3odX+o8DVHS/NkzTkUalVdpTqMY4gFUxjS7ztqHhyj57GpJjQCb2Y9oCFiCqOq6+qnhwLCOH8MGGNNa6ah+hcxEaSsfwyfWJTmfkDA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784570520; c=relaxed/simple;
	bh=DztG7WNUFbZGcpLhD21UaVWs67VFPnnZRwqdOvKGBlA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=EflfjjyS4eI0rs2f2CNlFUV1lXqpAJMN/2wNF8xNFHkKe1Ji/U1fphtXZEbzW4v6Df9BB1bYqLkekwSNneOn7L6MHlY5ih93nTriowqceNXqFsiftMjfW6XOzZweVlAc52IqbVgfTYAgdBx5tmhzEKMpkVRiG2TEsYtMRVkUnFA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=IU+o/504; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="IU+o/504"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E73501F000E9;
	Mon, 20 Jul 2026 18:01:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784570518;
	bh=JvggE97+RAeFFa2wedcGT7yIkF0cAkJTmx9xGaVH200=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=IU+o/504PHBiSe8Dk/rRp4wXz6gEc5JYTFPAMzfhBekD62LFoa0iiyzfMlMI1hAAR
	 KGTP8FMrL0psXCseSTFahrQBe5GcOoYdx+XspgL5IY77GEhXPlDeKWfEzofHdpatgT
	 DSQP9he6kIcD0Try1qHv5G758Bjc0ev+PyjuaqdYqMvxeQcczKoH/+l+Jf9nh7N9bC
	 CHJPx7Uy7I16f0J+VLlTnReAuzgVHBBELJfwqT98rDiZM5O02p68T5ki6mYndU1GQR
	 D1b0eve9KkFnGYuUoal2PMnAol/ic1e1N3NWc4FZWcV/zt5jjraRRaaTCExbBYpQ1r
	 LiCjqBH9hvJJg==
Date: Mon, 20 Jul 2026 11:01:56 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Ard Biesheuvel <ardb@kernel.org>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Thomas Huth <thuth@redhat.com>
Subject: Re: [PATCH v2 00/13] Library APIs for AES encryption modes
Message-ID: <20260720180156.GG1865@quark>
References: <20260715221153.246410-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260715221153.246410-1-ebiggers@kernel.org>

On Wed, Jul 15, 2026 at 03:11:40PM -0700, Eric Biggers wrote:
> Eric Biggers (13):
>   crypto: xts - Split out __xts_verify_key() helper
>   lib/crypto: aes: Add ECB support
>   lib/crypto: aes: Add CBC and CBC-CTS support
>   lib/crypto: aes: Add CTR and XCTR support
>   lib/crypto: aes: Add XTS support
>   lib/crypto: aes: Add GCM support
>   lib/crypto: aes: Add CCM support
>   crypto: aes - Add ECB support using library
>   crypto: aes - Add CBC and CBC-CTS support using library
>   crypto: aes - Add CTR and XCTR support using library
>   crypto: aes - Add XTS support using library
>   crypto: aes - Add GCM support using library
>   crypto: aes - Add CCM support using library

Applied to https://git.kernel.org/pub/scm/linux/kernel/git/ebiggers/linux.git/log/?h=libcrypto-next

But as always, more reviews and acks would be greatly appreciated.

- Eric
