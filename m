Received: from bmailout2.hostsharing.net (bmailout2.hostsharing.net [83.223.78.240])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D9121426C;
	Mon, 25 Nov 2024 10:38:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=83.223.78.240
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732531135; cv=none; b=pmA/tG7UELpXgoERkn1GmF1a3Hm7g3GE4CEhmnsrsHHfHFXM6X9TtFNlm3hY6sqBpqfcn9Ax5TroERHegkg3y1O+a/zNfCaw01Puaz99f0jSkA/j1P5ZANM1+xNtLctkvZqN2aUYRfJqZuoPVE7IHXoGQlNmIFSMSeM/+oHDxM8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732531135; c=relaxed/simple;
	bh=JWT8VNGvlyicllP7ud4m6A0dzOVugFaPMD+zb8t4peY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ippsn+8d5r+//BWQETmCxZLKYcfuB+uPE/Ntzltr729ummD5BKnNKPTfjyyZxsiRIh8J20+WS0Jv4r+XPZZjCEaWQiV4C8OM4ugb2II1w5rdNeBdhZdRVydxgbM50XSlDHRSh08+963amo1pSVOpTWZblD5VfLJWoIwWdobXydQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=wunner.de; spf=none smtp.mailfrom=h08.hostsharing.net; arc=none smtp.client-ip=83.223.78.240
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=wunner.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=h08.hostsharing.net
Received: from h08.hostsharing.net (h08.hostsharing.net [IPv6:2a01:37:1000::53df:5f1c:0])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256
	 client-signature RSA-PSS (4096 bits) client-digest SHA256)
	(Client CN "*.hostsharing.net", Issuer "RapidSSL TLS RSA CA G1" (verified OK))
	by bmailout2.hostsharing.net (Postfix) with ESMTPS id 6368A28019FDD;
	Mon, 25 Nov 2024 11:29:30 +0100 (CET)
Received: by h08.hostsharing.net (Postfix, from userid 100393)
	id 4BEC84E9246; Mon, 25 Nov 2024 11:29:30 +0100 (CET)
Date: Mon, 25 Nov 2024 11:29:30 +0100
From: Lukas Wunner <lukas@wunner.de>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Ard Biesheuvel <ardb@kernel.org>, Zorro Lang <zlang@redhat.com>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [Bug report] kernel BUG at include/linux/scatterlist.h
Message-ID: <Z0RRiq-BJp8CYdNk@wunner.de>
References: <20241122045106.tzhvm2wrqvttub6k@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
 <CAMj1kXGAuJSdDWvu7D5-PT6mSbNG9FeLObnYmpHeT08eNxaJWQ@mail.gmail.com>
 <Z0A2W1FTTPt9PeI5@gondor.apana.org.au>
 <Z0BCtZi2YJywGJAk@gondor.apana.org.au>
 <Z0NTLDYJQC242GMB@wunner.de>
 <Z0OzDle-VrrXf8rW@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Z0OzDle-VrrXf8rW@gondor.apana.org.au>

On Mon, Nov 25, 2024 at 07:13:18AM +0800, Herbert Xu wrote:
> On Sun, Nov 24, 2024 at 05:24:12PM +0100, Lukas Wunner wrote:
> > Hm, my impression is that this needs to be fixed in arm64's
> > virt_addr_valid() macro.
> 
> Regardless of what happens on arm64, you can't put a virtual
> address into an SG list in general.  It's just not allowed.

The virtual address passed to sg_init_one() is converted to a
physical address with the following call chain:

sg_init_one()
  sg_set_buf()
    sg_set_page(sg, virt_to_page(buf), buflen, offset_in_page(buf))

... where virt_to_page() implicitly does the right thing for
kmalloc'ed addresses ("linear map") versus kernel image addresses
on arm64 (as on other arches):

virt_to_page()
  pfn_to_page(virt_to_pfn())
    __phys_to_pfn(virt_to_phys())
      __virt_to_phys()
        __virt_to_phys_nodebug()
	  __is_lm_address(__x) ? __lm_to_phys(__x) : __kimg_to_phys(__x)

So this all works fine and with the patch I proposed, all crypto
selftests pass in my qemu arm64 VM.

It's just that the virt_addr_valid() check in sg_set_buf() throws
a nonsensical false-positive BUG_ON() on arm64.


> In any case, we don't even need SG lists here since the correct
> interface to use in rsassa-pkcs1.c is crypto_akcipher_sync_encrypt.

crypto_akcipher_sync_encrypt() kmalloc's a buffer and copies from
the kernel's .rodata section to that buffer.  That's why it doesn't
throw the false-positive BUG_ON() on arm64:  virt_addr_valid() is
happy if the virtual address is in the linear map.

Nevertheless, crypto_akcipher_sync_encrypt() likewise passes a virtual
address to sg_init_one(), which is converted to a physical address
in the linear map as shown above.

I deliberately avoided the crypto_akcipher_sync_encrypt() API
in rsassa-pkcs1.c because the extra buffer allocation plus copying
data around impacts performance for no benefit.

There is a benefit of course in that the false-positive BUG_ON()
isn't triggered but that's an arm64 oddity that other major arches
do not exhibit and that should be fixed.

So if you absolutely positively want to use crypto_akcipher_sync_encrypt()
in rsassa-pkcs1.c, I can change that.  But it will come at a performance
cost without apparent benefit.  Are you sure (y/n)?

Thanks,

Lukas
