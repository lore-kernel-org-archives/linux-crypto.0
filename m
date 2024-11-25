Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE8F31922D8;
	Mon, 25 Nov 2024 10:38:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732531089; cv=none; b=WsQLZv91WAL/m6IL+SGmGE3OqaIh6rgIzzF1dRwK6PeewmyZxkNatg787wtvtVF8Tug/LqxP/kHncLQZ7w3y6nao/ZpxnnaFd0V39o9EQ0X+k3vxAdFuINKvEoSAi1+ze/j0Jf+BY+b5mtJmadUYCW2AMZ2R3EThaUR9quEYcSk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732531089; c=relaxed/simple;
	bh=VlZlsNE/Dy7IPdkqKCbXfQxWys+nXDukgkksonZo//k=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JTco9ZlSFp2XhSw/k+iOwe6eukf0CQHMF6ZGWN00QJMx76sXtsFhmP2vArZaMLhOm5Q0wZ6g/re6xNrsK7R3oTG3OdKBq0cKfH8E+CFvU6+RZcwPPp9Ts1UaIM5HtRcVGS25evGT9JyIl0LX9fp8GVAjcEioDaIAvxoAEShWeCg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=Xd8IKu6L; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="Xd8IKu6L"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=FUTaddpw9DQy3Ko98dppdGXimZPVJgQrfgtFNgKA05M=; b=Xd8IKu6LsrikToEfqmMyjkVSL8
	q7kq2wLUFgCgML1CGGTXr+WWh4OtMTNGo/pP7KMTZ9gVlwFuMVCSrfB9SXVdyzhZ56JhWCYRAZSNn
	RNqueogGhB+bHrdQMvDJD13AO+C8lla8+k4vR3kG2VGSnog7msUDAaPc0Y2oxB94VUHguu8tUNYQK
	QlvbfqNQIcmEOLr/AQckkvEx34w9SmUI1O9nVZv6VTBg9162zXXtniXi3kKTCmnpuBEeT91eGgA6t
	GLm4+QeOzzTFst9hoXtOYcV9qZEXSGBaPPz3vgL4RQOespU/CwRQgsOgApd1DR1p3U9a29CNcxK6d
	GVW9bQXA==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1tFWTa-001WIy-1I;
	Mon, 25 Nov 2024 18:37:55 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Mon, 25 Nov 2024 18:37:54 +0800
Date: Mon, 25 Nov 2024 18:37:54 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Lukas Wunner <lukas@wunner.de>
Cc: Ard Biesheuvel <ardb@kernel.org>, Zorro Lang <zlang@redhat.com>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [Bug report] kernel BUG at include/linux/scatterlist.h
Message-ID: <Z0RTgsb5Va9psaIs@gondor.apana.org.au>
References: <20241122045106.tzhvm2wrqvttub6k@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
 <CAMj1kXGAuJSdDWvu7D5-PT6mSbNG9FeLObnYmpHeT08eNxaJWQ@mail.gmail.com>
 <Z0A2W1FTTPt9PeI5@gondor.apana.org.au>
 <Z0BCtZi2YJywGJAk@gondor.apana.org.au>
 <Z0NTLDYJQC242GMB@wunner.de>
 <Z0OzDle-VrrXf8rW@gondor.apana.org.au>
 <Z0RRiq-BJp8CYdNk@wunner.de>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Z0RRiq-BJp8CYdNk@wunner.de>

On Mon, Nov 25, 2024 at 11:29:30AM +0100, Lukas Wunner wrote:
>
> crypto_akcipher_sync_encrypt() kmalloc's a buffer and copies from
> the kernel's .rodata section to that buffer.  That's why it doesn't
> throw the false-positive BUG_ON() on arm64:  virt_addr_valid() is
> happy if the virtual address is in the linear map.

That's the whole point, only kmalloced addresses are allowed for
SG lists.  You cannot place an arbitrary virtual address into an
SG list, it's just broken.

> I deliberately avoided the crypto_akcipher_sync_encrypt() API
> in rsassa-pkcs1.c because the extra buffer allocation plus copying
> data around impacts performance for no benefit.

This is temporary.  The idea is to convert the akcipher software
implementations over to use virtual addresses directly so that no
unnecessary copy occurs.  Have a look at what I did with ahash:

https://lore.kernel.org/linux-crypto/bffef4bab1bf250bd64a3d02de53eb1fd047a96e.1730021644.git.herbert@gondor.apana.org.au/

This is what I'd like to do with akcipher as well.

Longer term there is potentially another unnecessary copy if you
go from a kmalloced virtual address to an akcipher hardware driver,
but we could eliminate that by adding a flag to indicate that the
virtual address is safe for use within an SG list.

> So if you absolutely positively want to use crypto_akcipher_sync_encrypt()
> in rsassa-pkcs1.c, I can change that.  But it will come at a performance
> cost without apparent benefit.  Are you sure (y/n)?

Yes.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
