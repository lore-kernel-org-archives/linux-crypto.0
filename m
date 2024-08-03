Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B546880C
	for <linux-crypto@vger.kernel.org>; Sat,  3 Aug 2024 00:34:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722645254; cv=none; b=KgsZPlJRAWLOReP+avu3B1a4jWAwn9I2QJCGSkFnClpfNHFA1nFaw60+0L7e7xZn5tFUuJvZheJksIMS4PDOCP/vDGIgYxC4CsM3ukVx55HeErVxS9nBtjtgjj5wbiEOVHjtAZj0kq0KH3AMBkBTlbxZkExTjYinkxDI5i/R798=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722645254; c=relaxed/simple;
	bh=6r4J9yRymYI5G54NUx/GLTYslmvmfTWZPF5pF9t9GMM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JIBtSRaU52FVKlv9cbyhl8a2YPDV+92BhA1XNTYoKn6l6RQFOyaosWX7sVigNEMnwn9TcJMBO1h8xxF+6A7OPhTsnoTAERHlKETt3iIM5mabK0U4yyWTkKknVUFOBXmxh4ocC3D/WV5rnwOGgIi//J9uZ/ToS87J3i3OCuQacQ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1sa2aG-00272z-0p;
	Sat, 03 Aug 2024 08:34:06 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sat, 03 Aug 2024 08:34:05 +0800
Date: Sat, 3 Aug 2024 08:34:05 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Eric Biggers <ebiggers@kernel.org>
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	linux-crypto@vger.kernel.org,
	"David S. Miller" <davem@davemloft.net>,
	Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] crypto: x86/aes-gcm: Disable FPU around
 skcipher_walk_done().
Message-ID: <Zq16_XsbZrmfnc4q@gondor.apana.org.au>
References: <20240802102333.itejxOsJ@linutronix.de>
 <20240802162832.GA1809@sol.localdomain>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240802162832.GA1809@sol.localdomain>

On Fri, Aug 02, 2024 at 09:28:32AM -0700, Eric Biggers wrote:
>
> Note that kfree() lacks a might_sleep(), and its kerneldoc does not say that it
> can sleep.  Have you checked for other instances of this same problem?  It seems
> it would be quite common kernel-wide.  Is it really necessary that kfree() takes
> a sleepable lock on PREEMPT_RT?

Agreed.  kfree() gets called in all sorts of places under softirq
context in the network stack which would presumably have the same
issue.

Please give a bit of context of when kfree started doing this.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
