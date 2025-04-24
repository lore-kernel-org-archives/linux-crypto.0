Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E356F7F9;
	Thu, 24 Apr 2025 00:57:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745456246; cv=none; b=NRwxGsouBh9uMvB7i/U74aHrrfFx1flPd0T/i/UVbJrYh9Bg0wK7U94g/qVZHZlpK3skNpSTXi/NBbI1fJPvGs6wwXUMOjYnGtQZOf8NAMNId1nurO6HakYwJmgu2lmqfIhh802lsqhGnacyKUeBmhGsdeu7Gf7Y+5QDQjjIvtg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745456246; c=relaxed/simple;
	bh=twNrkgTQH31gK1fJFkA/E0nmLZE3WNKozOwHMS7H+9M=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HQJ2PDIFtcZaOnxEs6PueHHu9JQTaCgl4mdgm5mjCN0IGNnY/6cDywNzx6oEL1uylmWWCzrLqObzTfhXP/iKsFsyDTUGiF8xahVJkInAbRCfHuYKIP0TW3Jt4Dvadrcm5kT8sISEC4L5VsyHFBj8Suc7MQHGzo592lPJUIkQ3O8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=O/OOlBpf; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="O/OOlBpf"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=EV+pGXit6jruqR5l0B3y9qAw5ucfY7EZKsVJtMM02YA=; b=O/OOlBpf5y/wJvYuHV5rZkXU2b
	D6/ugZiCsZZ0ysPEYMbomGQoM1W1RXeE/Ha1kFSotMusyfPFdTs+6EFCoqASCERKG1EnLaLkUIQ0I
	fUaYnKpd/tT+UjCowkgKXDwtf5yPszqbf9Gwe7tLrgcFKDFenCrD6xvfOXNnX9mM5ZFYVVLVDFUCR
	JfsxXcOar2gPRWw4yREiOAfkhn3447qAzfwYLk1uhUY8tG+qr4l9gzb0qQA+A8OLND+Yrb03Ea9Px
	kCSBtfwwFxA+faVCtZynkLXQ4YKI6bdmPtzLZE2UdXpp+jatniHP7fyvXjvKeIkyK+a3K8iWBR0fR
	e9MQoz3g==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1u7ktG-000Y0u-1h;
	Thu, 24 Apr 2025 08:56:35 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Thu, 24 Apr 2025 08:56:34 +0800
Date: Thu, 24 Apr 2025 08:56:34 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Arnd Bergmann <arnd@kernel.org>
Cc: "David S. Miller" <davem@davemloft.net>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
	Arnd Bergmann <arnd@arndb.de>, "H. Peter Anvin" <hpa@zytor.com>,
	Uros Bizjak <ubizjak@gmail.com>, Eric Biggers <ebiggers@kernel.org>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] crypto: x86/sha256 - Include asm/fpu/api.h directly
Message-ID: <aAmMQl7MNwhP8aPl@gondor.apana.org.au>
References: <20250423162548.2072707-1-arnd@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250423162548.2072707-1-arnd@kernel.org>

On Wed, Apr 23, 2025 at 06:25:45PM +0200, Arnd Bergmann wrote:
> From: Arnd Bergmann <arnd@arndb.de>
> 
> This was previously included through another header, but now causes
> a build failure in some configurations:
> 
> arch/x86/crypto/sha256_ssse3_glue.c:63:2: error: call to undeclared function 'kernel_fpu_begin'; ISO C99 and later do not support implicit function declarations [-Wimplicit-function-declaration]
>    63 |         kernel_fpu_begin();
>       |         ^
> arch/x86/crypto/sha256_ssse3_glue.c:65:2: error: call to undeclared function 'kernel_fpu_end'; ISO C99 and later do not support implicit function declarations [-Wimplicit-function-declaration]
>    65 |         kernel_fpu_end();
>       |         ^
> 
> Include the header directly to make it build again.
> 
> Fixes: 8e7547473875 ("crypto: x86/sha256 - Use API partial block handling")
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> ---
>  arch/x86/crypto/sha256_ssse3_glue.c | 2 ++
>  1 file changed, 2 insertions(+)

Sorry, I had pushed out the wrong tree.  It should be fixed in
cryptodev already:

https://git.kernel.org/pub/scm/linux/kernel/git/herbert/cryptodev-2.6.git/commit/?id=eba187a6e7141a1166a68c4d27b4ee5a27670b3b

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
