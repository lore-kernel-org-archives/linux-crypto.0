From: Alexey Dobriyan <adobriyan@gmail.com>
Subject: Re: crypto_remove_spawns: BUG: unable to handle kernel NULL
 pointer dereference at 0000000000000018
Date: Wed, 17 Feb 2010 21:31:09 +0200
Message-ID: <20100217193109.GB5256@x200>
References: <20100214174507.GA8688@x200>
 <20100215052729.GA17156@gondor.apana.org.au>
 <b6fcc0a1002142347n1aff4326p3275e70b0ecea0e3@mail.gmail.com>
 <20100215081155.GA18566@gondor.apana.org.au>
 <b6fcc0a1002150014j43415772mea21790c0667a32b@mail.gmail.com>
 <20100216120203.GA32264@gondor.apana.org.au>
 <20100216193139.GA5512@x200>
 <20100217003735.GB11975@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: davem@davemloft.net, linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-qy0-f200.google.com ([209.85.221.200]:52174 "EHLO
	mail-qy0-f200.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754416Ab0BQTbK (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 17 Feb 2010 14:31:10 -0500
Received: by qyk38 with SMTP id 38so2247036qyk.1
        for <linux-crypto@vger.kernel.org>; Wed, 17 Feb 2010 11:31:08 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <20100217003735.GB11975@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Feb 17, 2010 at 08:37:35AM +0800, Herbert Xu wrote:
> On Tue, Feb 16, 2010 at 09:31:39PM +0200, Alexey Dobriyan wrote:
> >
> > Which codepath exactly?
> 
> When a spawn is created the instance associated with it will have
> a zero-initialised cra_users entry.
> 
> > BTW, CBC or AES aren't used, just loaded.
> 
> Can you boot without aes/cbc loaded and see if it gets automatically
> loaded? PF_KEY users tend to load all possible algorithms when
> they start up.

AES and CBC are indeed loaded even if not used.

xfrm4_tunnel            1701  0
tunnel4                 2319  1 xfrm4_tunnel
ipcomp                  2063  0
xfrm_ipcomp             5154  1 ipcomp
xfrm4_mode_tunnel       1861  0
deflate                 2033  0
zlib_deflate           21231  1 deflate
zlib_inflate           18334  1 deflate
aes_generic            26652  0
des_generic            16263  0
cbc                     2945  0
sha1_generic            2223  0
md5                     4161  0
hmac                    3041  0
cryptomgr             105876  0
aead                    6474  1 cryptomgr
pcompress               1767  1 cryptomgr
crypto_null             2910  0
crypto_blkcipher       12080  3 cbc,cryptomgr,crypto_null
crypto_hash            15857  5
sha1_generic,md5,hmac,cryptomgr,crypto_null
crypto_algapi          16753  11
deflate,aes_generic,des_generic,cbc,hmac,cryptomgr,aead,pcompress,crypto_null,crypto_blkcipher,crypto_hash
af_key                 30024  0


Race started to become even less reproducible, so I can't confirm your patch quickly. :-(
