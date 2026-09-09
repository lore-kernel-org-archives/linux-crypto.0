Received: from ms.lwn.net (ms.lwn.net [45.79.88.28])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D2D2556BB3;
	Wed,  9 Sep 2026 13:22:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.79.88.28
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788960135; cv=none; b=hQdsQ9NwbkzJvU/9OTqF5hCqR9skeA0MqE6XF7EVn6W6l0+uIEFdbz1iUUrdTv10yXpGoN1IJTbmtdm5wE8KpBwPlgLdmn7gR3rNsdfwMzk64tdZBOYxPwfrKfNFbsproJkl5CBKj0ah8nBYMSBc90uiOH5+7vifsA+6W2VRqkI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788960135; c=relaxed/simple;
	bh=RekfKfcW3lBm83OBnxS1x6kHsii/XZI6qREEBvgR3yU=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=eYTh0G7KLSALMPXvKOyQkKAo9K4Yqqp3SOs3i/+oR98h3+ZjalFz32IHNdl0Wg6hnJb6Zl3Pm4mAnBWzWedJvzRxFP5jFLw7VzBfi7EbmiLNuzoNsUfXhPg6XP1BaKnoBd7VFx8BRXpY/WROHvmflh3njDdABuEH2zHSUIoU4EE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lwn.net; spf=pass smtp.mailfrom=lwn.net; dkim=pass (2048-bit key) header.d=lwn.net header.i=@lwn.net header.b=cv2mbJT7; arc=none smtp.client-ip=45.79.88.28
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lwn.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lwn.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=lwn.net header.i=@lwn.net header.b="cv2mbJT7"
DKIM-Filter: OpenDKIM Filter v2.11.0 ms.lwn.net 734AB408EC
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=lwn.net; s=20201203;
	t=1788960132; bh=56CUGci1S6UaR9USh5UuDTlSGJUgi1rO3RZLLOOXpjI=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=cv2mbJT7ixffkqVva2v2IFJmWH27Mfn6smqm+6swqXlzynkDTcKqXFIcr98EazY4N
	 EmLc2iERFaenQ75Sr00VhzCc2q7UDMlWbho4LAsDfND/Pee6EcRbJlD4wX0VRfCWZH
	 ENDd48ZDybSBUtNIKWENsL7B7+xWHfdlma6hwgHqPWbY7uQQ1h/HAQVBvsdP8EKQFn
	 ih+ulrvUgrJReyy8er7t0XMqMBRUIKmBu/lTOkE58NdISmqqFw7qCqGS43ujAL0OiB
	 y1IYWIbyo9t8vDo+2gMBOMzTOVWiYEAOsgTlXm0lsI10ii3FHZbcyyU6ZknQ7e/t6b
	 afuA9jMQ8wpTQ==
Received: from localhost (unknown [IPv6:2601:280:4600:814::1fe])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by ms.lwn.net (Postfix) with ESMTPSA id 734AB408EC;
	Wed,  9 Sep 2026 13:22:12 +0000 (UTC)
From: Jonathan Corbet <corbet@lwn.net>
To: Thomas Huth <thuth@redhat.com>, Eric Biggers <ebiggers@kernel.org>,
 Herbert Xu <herbert@gondor.apana.org.au>, "David S. Miller"
 <davem@davemloft.net>, "Jason A. Donenfeld" <Jason@zx2c4.com>, Ard
 Biesheuvel <ardb@kernel.org>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org, Thomas
 Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, Borislav
 Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, Shuah
 Khan <skhan@linuxfoundation.org>, Randy Dunlap <rdunlap@infradead.org>,
 linux-doc@vger.kernel.org
Subject: Re: [PATCH v2 13/13] lib/crypto: Add documentation about
 zeroization of key and context data
In-Reply-To: <20260909115455.157093-14-thuth@redhat.com>
References: <20260909115455.157093-1-thuth@redhat.com>
 <20260909115455.157093-14-thuth@redhat.com>
Date: Wed, 09 Sep 2026 07:22:11 -0600
Message-ID: <87bja6muf0.fsf@trenco.lwn.net>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

Thomas Huth <thuth@redhat.com> writes:

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

One nit...

> diff --git a/Documentation/crypto/libcrypto-zeroization.rst b/Documentation/crypto/libcrypto-zeroization.rst
> new file mode 100644
> index 0000000000000..ba9b05320ad53
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
> +
> +.. contents::
> +
> +Overview
> +--------
> +
> +Cryptographic key material and intermediate state (such as HMAC contexts) must
> +be zeroized after use to prevent sensitive data from lingering on the stack or
> +heap, where it could be leaked through memory disclosure vulnerabilities,
> +crash dumps, or cold-boot attacks.
> +
> +For memory that has been allocated with kmalloc() or a similar function,
> +kfree_sensitive() should be used instead of kfree() to release the memory.
> +
> +For other cases, the kernel provides ``memzero_explicit()`` for clearing the
> +memory.  Unlike plain ``memset()``, ``memzero_explicit()`` is guaranteed not
> +to be optimized away by the compiler, even when the memory being cleared
> +appears to be dead.

Don't mark up function names, just say memzero_explicit().  The
automarkup code will then do the right thing, including cross-references
when the functions have kerneldoc documentation.

Thanks,

jon
