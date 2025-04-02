Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B75E32E337B;
	Wed,  2 Apr 2025 03:14:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743563655; cv=none; b=bkWKnapH7UHpz6d4Zeobl8nCkLGG2PEZ/HzaSOjMBjKpfMNQAGz49/4Bxwhs1DHio6erh+RmF6RQEXy5VVxPGUjbkKibJPA8IKjaIqmKQwJ7vdtBp5OijFsxOvNYXsz8/6SNJcxX+lBBzPuot7xhNI539FkkavHcwjV/PplqDXA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743563655; c=relaxed/simple;
	bh=dW/9AqOkv7nqUOT8PURcNrY3ZuOQUO4Mo8Yspr0Lij0=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To; b=TfQ4+5pp5zLmTTpPF5kkuAY5CKciIFaYDS0VUJEvP+VrkK5rHqS+x2xOMKMvkTv1R3XNWoEu0H9bzCtELmmN6q0q5XA/z7waLVUrb8adBCkmt7z3geTHEdlPPDKt9f+4zbddF4O9aavZn5o1xAg/CoDjUDTjcCZaaTarYx4Vbdo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=qr8YFjVR; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="qr8YFjVR"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:Message-ID:Subject:Cc:To:
	From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:References:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=gNeEL0d+lyYAxNXEQO5+lZpHvir6kaPuY8AoPuxw5AE=; b=qr8YFjVRwRtRMro2FOQlZdjgpe
	dEat6wbg8/jQCTStGmetA8ls1tFjyE1nG+/I8hO4GKb6F4j48DEQKEZH9Ju4kxmcNYyV4hTALon+t
	O7mFvp3PEneVRKptEaAO5AUNiuBn6eaoUxHetti8ylXA1a9gX/K+R77+9vIY+OG3l8KXXM+7F+ata
	Vuz8/MGB7E9XYbGiu4I36UgRZ6VH57NDhZ392nBIHZzVwtoaNllF56aE3tYybbF5zQHMw93LxylWO
	z3nUv2Om71fi5wNuPncpwkAl74AYV7lDE8vteqs7fmx6N514hYtFInpqqSsPUvPADp5N0yOramnQd
	zTJ7HUGg==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1tzoYJ-00C16f-0p;
	Wed, 02 Apr 2025 11:14:08 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Wed, 02 Apr 2025 11:14:07 +0800
Date: Wed, 2 Apr 2025 11:14:07 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Eric Biggers <ebiggers@kernel.org>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	x86@kernel.org, Ard Biesheuvel <ardb@kernel.org>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Danny Tsen <dtsen@linux.ibm.com>
Subject: Re: [PATCH v2 0/9] crypto: x86 - stop using the SIMD helper
Message-ID: <Z-yrf_9D2rV1Q136@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250402002420.89233-1-ebiggers@kernel.org>
X-Newsgroups: apana.lists.os.linux.cryptoapi,apana.lists.os.linux.kernel

Eric Biggers <ebiggers@kernel.org> wrote:
>
> Stop wrapping skcipher and aead algorithms with the crypto simd helper
> (crypto/simd.c).  The only purpose of doing so was to work around x86
> not always supporting kernel-mode FPU in softirqs.  Specifically, if a
> hardirq interrupted a task context kernel-mode FPU section and then a
> softirqs were run at the end of that hardirq, those softirqs could not
> use kernel-mode FPU.  This has now been fixed.  In combination with the
> fact that the skcipher and aead APIs only support task and softirq
> contexts, these can now just use kernel-mode FPU unconditionally on x86.

Nice work!

So which platform still needs the simd wrapper? I believe arm/arm64
have both been fixed but we haven't finished removing the legacy
simd code yet? Ard, would you be able to spare some cycles and
finish the removal of simd on arm?

Darn, it looks like powerpc has just started using the simd wrapper
so we need to fix it first before we can completely eliminate simd.

Michael/Danny, any chance you guys could implement something similar
to what's been done on arm/x86 and make simd usable in softirqs?

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
