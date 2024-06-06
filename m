Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A50F138384;
	Thu,  6 Jun 2024 05:28:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717651683; cv=none; b=JzaGb47ExJsGRaEBU3cpERlp1EVzz6BTmxnPM8X9bObXS2Ao5BxwPOmIsQ4QYQDYX4klTy0zAP4bvmKNqFBPCo758aNsnNjlKY8hjrLZLFwhoBtB967Ud+73peOBcX3vOFNphmgcF9ztRsVJE6fQAl8815Iosw7FQ18zy9akb9s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717651683; c=relaxed/simple;
	bh=eENIBCPHkm00GMg6HuX97VGHvgr6QRp4HKMNEJaCIpM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Q49P5QrOYc+viGoEOB9iNEUw977JAznYnq1qK8MJtexrGbI4mBFsmP/wGFI5U/hxS2F79rOH2wqVjWWdBdtYmFfqeRw/Uc0LcvTAzVv9Ga73ab++eKvXJzuqdhFZ5zkb/oJfAMMgo9PkbMubXUrYP2uIMw3J+SUAzVUG7UPu0ow=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fHGaWook; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fHGaWook"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB61CC2BD10;
	Thu,  6 Jun 2024 05:28:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1717651683;
	bh=eENIBCPHkm00GMg6HuX97VGHvgr6QRp4HKMNEJaCIpM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=fHGaWookzEB1nl4KqrzDbHt8insomG1TZAd8kABfrnhMBGYiN7+jvSri0J4T25XP0
	 8QqHddMAum8flEVCEVuA89TnTUEzbbE0RlIjlx6M4F30epGEGHmJAJ280aqZz3OEaW
	 MjC3rD673jDehWZFsZrfTHcFaekKQ4cZCrvmd2/sfeBQyCUoNeOlRaGcVubHslXfRI
	 LbGwHJCfPx3Bot+WkIKeZ0PCl7wlzrVJiXmEUkNm8HoPHxgRy7IPipNgfFt6za4KJF
	 FbKGJOsKRc4STSuUd9sRvQOuXjfVsQpqgGN8Pgm21pU7IKxYsDa64+YTRr6djm2xS1
	 NVDODtslsuwYQ==
Date: Wed, 5 Jun 2024 22:28:01 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Steffen Klassert <steffen.klassert@secunet.com>, netdev@vger.kernel.org,
	linux-crypto@vger.kernel.org, fsverity@lists.linux.dev,
	dm-devel@lists.linux.dev, x86@kernel.org,
	linux-arm-kernel@lists.infradead.org,
	Ard Biesheuvel <ardb@kernel.org>,
	Sami Tolvanen <samitolvanen@google.com>,
	Bart Van Assche <bvanassche@acm.org>
Subject: Re: [PATCH v4 6/8] fsverity: improve performance by using
 multibuffer hashing
Message-ID: <20240606052801.GA324380@sol.localdomain>
References: <20240603183731.108986-1-ebiggers@kernel.org>
 <20240603183731.108986-7-ebiggers@kernel.org>
 <Zl7gYOMyscYDKZ8_@gondor.apana.org.au>
 <20240604184220.GC1566@sol.localdomain>
 <ZmAthcxC8V3V3sm3@gondor.apana.org.au>
 <ZmAuTceqwZlRJqHx@gondor.apana.org.au>
 <ZmAz8-glRX2wl13D@gondor.apana.org.au>
 <20240605191410.GB1222@sol.localdomain>
 <ZmEYJQFHQRFKC5JM@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZmEYJQFHQRFKC5JM@gondor.apana.org.au>

On Thu, Jun 06, 2024 at 10:00:05AM +0800, Herbert Xu wrote:
> On Wed, Jun 05, 2024 at 12:14:10PM -0700, Eric Biggers wrote:
> > 
> > This would at most apply to AH, not to ESP.  Is AH commonly used these days?
> 
> No AH is completely useless.  However, this applies perfectly to
> ESP, in conjunction with authenc.  Obviously we would need to add
> request linking to authenc (AEAD) as well so that it can pass it
> along to sha.
> 
> BTW, does any of this interleaving apply to AES? If so we should
> explore adding request linking to skcipher as well.
> 

With AES, interleaving would only help with non-parallelizable modes such as CBC
encryption.  Anyone who cares about IPsec performance should of course be using
AES-GCM, which is parallelizable.  Especially since my other patch
https://lore.kernel.org/linux-crypto/20240602222221.176625-2-ebiggers@kernel.org/
is making AES-GCM twice as fast...

With hashing we unfortunately don't have the luxury of there being widely used
and accepted parallelizable algorithms.  In particular, all the SHAs are
serialized.  So that's why interleaving makes sense there.

In any case, it seems that what you're asking for at this point is far beyond
the scope of this patchset.

- Eric
