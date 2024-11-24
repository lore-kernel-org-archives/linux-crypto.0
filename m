Received: from bmailout1.hostsharing.net (bmailout1.hostsharing.net [83.223.95.100])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E919E188736;
	Sun, 24 Nov 2024 16:24:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=83.223.95.100
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732465462; cv=none; b=l52YTQk+aSX01IjmXNMs/Zj8Rs68we1acNhI68bhepfkf3l3MM1AuuTEqX1OqVZnnmpEJgp86TN3uqSjAN9igpxNgbS9+vMQzj1xYtsn9RZfrE4K/EORrPNCJsF1fiV9ZTeCSNhXivljTzqwfiGjaZjhoJYUD2zUcHT/13gyNrU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732465462; c=relaxed/simple;
	bh=n8UtkbesUTNAKh8DiugbPBPDU/cllq2PReDQanB7Blo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=PxYfA9pPAIEbPhOuCZtLN1NGjxNW59kZAa0F+XTo9rMqR3+PC+EmJG6u8ZEWo/dBqlhFkRjtAv3/C7iyDA7Re3Gn+SVMNwIQ2ziz5BUKAaA5pKF10erbakwjwO9Q48jMrYVdNL2GZUQ0hspQSYiy5WjM9dujJWCfJNko4JI9wVc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=wunner.de; spf=none smtp.mailfrom=h08.hostsharing.net; arc=none smtp.client-ip=83.223.95.100
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=wunner.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=h08.hostsharing.net
Received: from h08.hostsharing.net (h08.hostsharing.net [IPv6:2a01:37:1000::53df:5f1c:0])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256
	 client-signature RSA-PSS (4096 bits) client-digest SHA256)
	(Client CN "*.hostsharing.net", Issuer "RapidSSL TLS RSA CA G1" (verified OK))
	by bmailout1.hostsharing.net (Postfix) with ESMTPS id 25A6F3000C77A;
	Sun, 24 Nov 2024 17:24:12 +0100 (CET)
Received: by h08.hostsharing.net (Postfix, from userid 100393)
	id 0979F6C31D5; Sun, 24 Nov 2024 17:24:12 +0100 (CET)
Date: Sun, 24 Nov 2024 17:24:12 +0100
From: Lukas Wunner <lukas@wunner.de>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Ard Biesheuvel <ardb@kernel.org>, Zorro Lang <zlang@redhat.com>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [Bug report] kernel BUG at include/linux/scatterlist.h
Message-ID: <Z0NTLDYJQC242GMB@wunner.de>
References: <20241122045106.tzhvm2wrqvttub6k@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
 <CAMj1kXGAuJSdDWvu7D5-PT6mSbNG9FeLObnYmpHeT08eNxaJWQ@mail.gmail.com>
 <Z0A2W1FTTPt9PeI5@gondor.apana.org.au>
 <Z0BCtZi2YJywGJAk@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Z0BCtZi2YJywGJAk@gondor.apana.org.au>

On Fri, Nov 22, 2024 at 04:37:09PM +0800, Herbert Xu wrote:
> On Fri, Nov 22, 2024 at 03:44:27PM +0800, Herbert Xu wrote:
> > 
> > This is a bug in the API/driver.  Users should not be expected to know
> > what kind of a virtual pointer is acceptable.
> > 
> > In this particular case, rsassa-pkcs1.c should be fixed to use the
> > crypto_akcipher_sync_encrypt interface.
> 
> Lukas, could you please take a look at this regression?

Hm, my impression is that this needs to be fixed in arm64's
virt_addr_valid() macro.

Let's see what arm64 maintainers have to say about it:

https://lore.kernel.org/r/90667b2b7f773308318261f96ebefd1a67133c4c.1732464395.git.lukas@wunner.de/

Thanks,

Lukas
