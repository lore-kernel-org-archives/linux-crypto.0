Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7A2A8005E;
	Fri, 19 Apr 2024 11:04:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713524648; cv=none; b=SUNeZDckJE2BCy6WwMfXPMZru1KBU06qUkzLGA3lFpbq961WwQdohKxg0UgWZHZnyS8zlL2HcbMEPB3AzeNq4Xoy7II0WQ0aqF4g7Y4cXIf9nGF6SEQoG4mXLQzq/+kiF41rx3Xvp1BzX9WYoF5n/FZNlf0ljsOicMexbK6nUKk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713524648; c=relaxed/simple;
	bh=M7P3XyB7/DWC66Xwuz9WozSWgLRzwKjY/6zlNfx9arU=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To; b=OWiBBKRjC7Jk3MebLOgsH6yerftILNYClz4DRYl9FfEuG8vY0AG435TW9Bglrm6Zx8RKinE5MD2hK9A+AF3NhWhpiDTd/FsPaQmqcQS0WpOCStzdWuSxZ68isT1Y9iKjxBcr3saQ4gnJ8S522fqGv2GFwJwGNWF+54um+nHR7tU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
	id 1rxm2E-003sag-Ez; Fri, 19 Apr 2024 19:04:03 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 19 Apr 2024 19:04:20 +0800
Date: Fri, 19 Apr 2024 19:04:20 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Eric Biggers <ebiggers@kernel.org>
Cc: linux-crypto@vger.kernel.org, x86@kernel.org,
	linux-kernel@vger.kernel.org, chang.seok.bae@intel.com
Subject: Re: [PATCH] crypto: x86/aes-xts - handle CTS encryption more
 efficiently
Message-ID: <ZiJPtK+cVWBXPn67@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240412154559.91807-1-ebiggers@kernel.org>
X-Newsgroups: apana.lists.os.linux.cryptoapi,apana.lists.os.linux.kernel

Eric Biggers <ebiggers@kernel.org> wrote:
> From: Eric Biggers <ebiggers@google.com>
> 
> When encrypting a message whose length isn't a multiple of 16 bytes,
> encrypt the last full block in the main loop.  This works because only
> decryption uses the last two tweaks in reverse order, not encryption.
> 
> This improves the performance of decrypting messages whose length isn't
> a multiple of the AES block length, shrinks the size of
> aes-xts-avx-x86_64.o by 5.0%, and eliminates two instructions (a test
> and a not-taken conditional jump) when encrypting a message whose length
> *is* a multiple of the AES block length.
> 
> While it's not super useful to optimize for ciphertext stealing given
> that it's rarely needed in practice, the other two benefits mentioned
> above make this optimization worthwhile.
> 
> Signed-off-by: Eric Biggers <ebiggers@google.com>
> ---
> arch/x86/crypto/aes-xts-avx-x86_64.S | 53 +++++++++++++++-------------
> 1 file changed, 29 insertions(+), 24 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
