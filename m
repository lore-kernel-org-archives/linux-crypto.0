Received: from bmailout1.hostsharing.net (bmailout1.hostsharing.net [83.223.95.100])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7EAA158208;
	Fri, 29 Nov 2024 07:54:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=83.223.95.100
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732866881; cv=none; b=lOyWYjgoCCCONy6DJp11gIo39XgDOzDY8lh5OrCqhx+eC896Ifzbl/q2op4x+GH1gtGbkoI72u0ArVOrXClAdAw3W6toJGLRhWYiRa/6DRWeSVj/CRE2XsY31+p83UsdGJSJfPHwY9npQ0NeEV6f7Z34ylwmP8vycmylmMMT/iI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732866881; c=relaxed/simple;
	bh=JaJRL2qlucYu7qlJeg/jT+yPWuSXG8UIn6zT19ZHliU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kUIN0LNdshJ3+1SWQkkI0BsCj4gpP+h3jnRtJm66tyn2YF8MP0tE1j22QJ5eNRd7sVAg98mkLNKvsYoIWctLaQ0WXbuL6Ud4x3NYq4mfJYpZQKz3EqG7kJrx3Xq495KrHZ5gcaHGVPczkm87YP+uwzkPsmttAO4nDtdqBpSx7d8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=wunner.de; spf=none smtp.mailfrom=h08.hostsharing.net; arc=none smtp.client-ip=83.223.95.100
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=wunner.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=h08.hostsharing.net
Received: from h08.hostsharing.net (h08.hostsharing.net [83.223.95.28])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256
	 client-signature RSA-PSS (4096 bits) client-digest SHA256)
	(Client CN "*.hostsharing.net", Issuer "RapidSSL TLS RSA CA G1" (verified OK))
	by bmailout1.hostsharing.net (Postfix) with ESMTPS id C383E30002AC2;
	Fri, 29 Nov 2024 08:54:35 +0100 (CET)
Received: by h08.hostsharing.net (Postfix, from userid 100393)
	id A00D0331C41; Fri, 29 Nov 2024 08:54:35 +0100 (CET)
Date: Fri, 29 Nov 2024 08:54:35 +0100
From: Lukas Wunner <lukas@wunner.de>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Ard Biesheuvel <ardb@kernel.org>, Zorro Lang <zlang@redhat.com>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [Bug report] kernel BUG at include/linux/scatterlist.h
Message-ID: <Z0lzOw7mQGuPrXlD@wunner.de>
References: <20241122045106.tzhvm2wrqvttub6k@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
 <CAMj1kXGAuJSdDWvu7D5-PT6mSbNG9FeLObnYmpHeT08eNxaJWQ@mail.gmail.com>
 <Z0A2W1FTTPt9PeI5@gondor.apana.org.au>
 <Z0BCtZi2YJywGJAk@gondor.apana.org.au>
 <Z0NTLDYJQC242GMB@wunner.de>
 <Z0OzDle-VrrXf8rW@gondor.apana.org.au>
 <Z0RRiq-BJp8CYdNk@wunner.de>
 <Z0RTgsb5Va9psaIs@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Z0RTgsb5Va9psaIs@gondor.apana.org.au>

On Mon, Nov 25, 2024 at 06:37:54PM +0800, Herbert Xu wrote:
> On Mon, Nov 25, 2024 at 11:29:30AM +0100, Lukas Wunner wrote:
> > I deliberately avoided the crypto_akcipher_sync_encrypt() API
> > in rsassa-pkcs1.c because the extra buffer allocation plus copying
> > data around impacts performance for no benefit.
> 
> This is temporary.  The idea is to convert the akcipher software
> implementations over to use virtual addresses directly so that no
> unnecessary copy occurs.  Have a look at what I did with ahash:
> 
> https://lore.kernel.org/linux-crypto/bffef4bab1bf250bd64a3d02de53eb1fd047a96e.1730021644.git.herbert@gondor.apana.org.au/
> 
> This is what I'd like to do with akcipher as well.
> 
> Longer term there is potentially another unnecessary copy if you
> go from a kmalloced virtual address to an akcipher hardware driver,
> but we could eliminate that by adding a flag to indicate that the
> virtual address is safe for use within an SG list.

I'm proposing an optimized approach which auto-detects whether
duplicating into the linear map is actually necessary:

https://lore.kernel.org/r/3de5d373c86dcaa5abc36f501c1398c4fbf05f2f.1732865109.git.lukas@wunner.de/

I reckon that aside of selftests, duplicating is almost never needed.

Let me know if you have any objections.  My apologies for being
stubborn and rebellious and not always following what I'm told.

Thanks,

Lukas
