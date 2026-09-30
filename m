Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13D9F4CEE6B;
	Wed, 30 Sep 2026 20:14:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790799278; cv=none; b=C9OWv9CSpTEUjbr5813KLRXJveMzcfBvnfJe+dRvxp8cVLsyx6XWciR8ZVuftkr3TD2PBQop3f60CLohvhM87u2htBhqfEEzqN/sAxzxMpawc5aCGgEqkLbEZdRBvpzAeD9ab0rtf0a5nWpfp1OJMfWWPZBqfQnTZ4iPo0V/GgA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790799278; c=relaxed/simple;
	bh=jBh29V7lXWDaQ1OWFYNzYZPO+3CDjuUVa1CxNBSUIyc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=asNItaz7pB92I3M+UQK6sboJjj1GRzT8E2cb/rWypNi8JyBIzmLtAFyNiTfj8F8shxtIu0YYdwixcHKsNoy0311NQtOM3vdPsKz1Vza4lihWw1+HL+x72NfJBvuY02+QwxOoLSxCcsHOsOHrvhH5RHucGji8OsnoFsFdAKOblXQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Wm8rj2Mc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Wm8rj2Mc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 080141F000FF;
	Wed, 30 Sep 2026 20:14:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790799276;
	bh=Jh9wopEdiGr68kmPZd9LyAO78ha3dVq5Jg4mF7rTlfI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Wm8rj2McmLUtm0s5iraBnwgg/RBLC2Wh9hYWgLS3F+pyiBXUqpZ2bQfNHQQk7ghIr
	 YlmEkwd9QmLrZlLChWZ9oVBQIpEi1xX2nLj/qZIDkqY+Gfb3aneNTC3bsbNF39/1Vr
	 bx7dKdDkTeHaVlEVCM9FHVYdkN+utAR9BObz17+EhFJ3nOMx8TX6BWO+i5IBt9s1/q
	 P4Ud0G5IG+7mkJBUTHXE/lRlzq/EKcRWMJQvp2s14LFcZBKwtkfVqd3De8eXgo+pTH
	 lzoHcJ6NADdZFcToiV16BdZ722vMMlJ9s6CV2gncbtUWYEyIAPQavb7StmrQ+Ih9HK
	 gOaA99QE8djeg==
Date: Wed, 30 Sep 2026 20:14:34 +0000
From: Eric Biggers <ebiggers@kernel.org>
To: Thomas Huth <thuth@redhat.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	"Jason A. Donenfeld" <Jason@zx2c4.com>,
	Ard Biesheuvel <ardb@kernel.org>, Borislav Petkov <bp@alien8.de>,
	Jonathan Corbet <corbet@lwn.net>, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@kernel.org>,
	Ingo Molnar <mingo@redhat.com>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Randy Dunlap <rdunlap@infradead.org>, linux-doc@vger.kernel.org
Subject: Re: [PATCH v4 13/13] lib/crypto: Add documentation about zeroization
 of key and context data
Message-ID: <20260930201434.GA61218@google.com>
References: <20260916095022.604354-1-thuth@redhat.com>
 <20260916095022.604354-14-thuth@redhat.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260916095022.604354-14-thuth@redhat.com>

On Wed, Sep 16, 2026 at 11:50:15AM +0200, Thomas Huth wrote:
> +What to zeroize
> +---------------
> +
> +The following types of structures hold sensitive material and should be
> +zeroized after use:
> +
> +- **Key structures** (e.g. ``struct aes_key``, ``struct hmac_sha256_key``):
> +  contain expanded round keys or prepared key material.
> +
> +- **HMAC/MAC context structures** (e.g. ``struct hmac_sha256_ctx``,
> +  ``struct aes_cmac_ctx``): contain inner and outer hash states derived from
> +  the key.
> +
> +- **Hash context structures** (e.g. ``struct sha256_ctx``): may contain
> +  sensitive data being hashed.
> +
> +Not all of these require explicit cleanup by callers.  Many ``..._final()``
> +functions already zeroize their context internally (see `Automatic vs. manual
> +zeroization`_ below).

This should mention that the raw key that the key struct was prepared
from needs to be zeroized as well.  Every in-kernel user of a keyed
algorithm has to deal with this problem, as to "prepare" a key, you need
to have the key already in the first place (whether it's passed in from
userspace, or derived from some other key, or something else).

Zeroizing a 'struct aes_key' for example is kind of useless if the
actual raw AES key is still in memory somewhere.

Any interest in sending a follow-up patch that clarifies this?  It
really should clarify that users of cryptography in the kernel should
apply zeroization to the full flow of their keys through the system
including system calls, key derivation, key preparation, etc.

- Eric
