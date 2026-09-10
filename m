Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39F92489FDA;
	Thu, 10 Sep 2026 15:09:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789052950; cv=none; b=tw+WxOUs/uuVHGG3HbdXiYQc/4aKOfqIy730VM4tRznG+Il1H/wxZcuIHdBxY+uhFrzPzSKDNkv+Qha4GXpOSIh8lqrohNfEFdqVBOEZv21P2y5kuN8WjdyOeQA//1+ZZDe8QvRoG6xUM45JZe6HPmUhqZHvSnNzX10YE6NcSxM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789052950; c=relaxed/simple;
	bh=8HB14MvdFmkHRUTTsBGAm9PIq6Mxc9lmyHmpfkhwwJo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=nYP7gBZwozWYsFzFvF2MC7miKvCiNQ/D971Ga7uCsnWlhCD4Hf7uGxX6/thUHWCytjj8bgtK11I3BdlYlk/mEytSILBrzgsHAFWF5nEI3BdyXfZksaMrsXQKTKvSn1FyUM+d0kmUmeGTRNDMzqHSGqg0YPzU7gK1E+i92uo5Ywo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kZSZaMkN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kZSZaMkN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 509261F00898;
	Thu, 10 Sep 2026 15:09:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789052943;
	bh=ag5kdB5nVoUMpWa4wv9K4ZCNqIybIgFc6wNvxV8nHo4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=kZSZaMkNXfmYCFviLz1CkkSHLEDNHi+7bsOg0CdjAG91pRURgcZMRmjNU/77Y/+ao
	 z6FfynS+DaBH8jHzSu3O5TMiyyuBSffs2aXguhhXh2fg/cTsdEBKdAgwd8UHsERF4b
	 3qPRjdXaJ8AlrYNSWdESunxelg5ZBCPsreqjnB2E/7ZUHu+hF2g75/rli/QcAT042d
	 H90uEMqtY+pJwfFsC8rYQh7JOJWq8sZCQCgXSx96jtfpdKca+NfDvibGvkA1YcnvSH
	 Wb7GIBTx1eZbED2Nhot3Xoa5W8jJpPdaBKGYshohp9FOcVzso7hsh5uc63XPNtJvSC
	 TJmODUmNWIYIg==
Date: Thu, 10 Sep 2026 10:09:00 -0500
From: Eric Biggers <ebiggers@kernel.org>
To: Thomas Huth <thuth@redhat.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	"Jason A. Donenfeld" <Jason@zx2c4.com>,
	Ard Biesheuvel <ardb@kernel.org>, Jonathan Corbet <corbet@lwn.net>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Randy Dunlap <rdunlap@infradead.org>, linux-doc@vger.kernel.org
Subject: Re: [PATCH v3 13/13] lib/crypto: Add documentation about zeroization
 of key and context data
Message-ID: <20260910150900.GC5719@quark>
References: <20260910124138.417439-1-thuth@redhat.com>
 <20260910124138.417439-14-thuth@redhat.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260910124138.417439-14-thuth@redhat.com>

On Thu, Sep 10, 2026 at 02:41:32PM +0200, Thomas Huth wrote:
> Add a central document about zeroization in libcrypto so we don't
> have to repeat this information in the individual kernel docs of
> the zeroization functions all over the place.
> 
> Signed-off-by: Thomas Huth <thuth@redhat.com>
> ---
>  .../crypto/libcrypto-zeroization.rst          | 129 ++++++++++++++++++
>  Documentation/crypto/libcrypto.rst            |   1 +
>  2 files changed, 130 insertions(+)
>  create mode 100644 Documentation/crypto/libcrypto-zeroization.rst
> 
> diff --git a/Documentation/crypto/libcrypto-zeroization.rst b/Documentation/crypto/libcrypto-zeroization.rst
> new file mode 100644
> index 0000000000000..2a12417e335a3
> --- /dev/null
> +++ b/Documentation/crypto/libcrypto-zeroization.rst
> @@ -0,0 +1,129 @@
> +.. SPDX-License-Identifier: GPL-2.0-or-later
> +
> +Crypto Key Zeroization
> +======================
> +
> +This document describes the conventions for zeroizing crypto structures in the
> +kernel.

There should be a note about why it's being called "zeroizing" and not
just "zeroing".  Something like:

    Note: the kernel follows traditional cryptographic terminology by using
    the term "zeroizing" to mean erasing sensitive parameters to prevent
    their disclosure if the system is later compromised.  This distinguishes
    it from zeroing memory for other purposes such as initialization.

> +These helpers should include kernel-doc comments following the standard
> +conventions::
> +
> +    /**
> +     * hmac_sha256_zeroize_ctx() - Zeroize an hmac_sha256_ctx structure
> +     * @ctx: The hmac_sha256_ctx context to zeroize
> +     */

We might as well have these kerneldoc comments, but I don't it's helpful
to repeat them here in this Documentation/ file like this.  It's just
another thing that could get out of sync.

> +Using __cleanup for automatic zeroization
> +-----------------------------------------
> +
> +The preferred way to zeroize stack-allocated key and context structures is
> +with the __cleanup() attribute.  This ensures zeroization happens on all
> +exit paths, including error returns and early exits.

Could use a (minimal) code example.

- Eric
