From: Herbert Xu <herbert-lOAM2aK0SrRLBo1qDEOMRrpzq4S04n8Q@public.gmane.org>
Subject: Re: Doing crypto in small stack buffers (bluetooth vs vmalloc-stack
 crash, etc)
Date: Wed, 22 Jun 2016 08:42:14 +0800
Message-ID: <20160622004214.GA27134@gondor.apana.org.au>
References: <CALCETrVJzzKkRsSbgsUmVd_+ArKEgoRSVdG1tVp7CXzFoPyVgA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-bluetooth-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	Johan Hedberg <johan.hedberg-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
	Gustavo Padovan <gustavo-THi1TnShQwVAfugRpC6u6w@public.gmane.org>,
	Marcel Holtmann <marcel-kz+m5ild9QBg9hUCZPvPmw@public.gmane.org>,
	linux-crypto-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	"David S. Miller" <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>,
	"linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
To: Andy Lutomirski <luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Return-path: <linux-bluetooth-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CALCETrVJzzKkRsSbgsUmVd_+ArKEgoRSVdG1tVp7CXzFoPyVgA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-bluetooth-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-crypto.vger.kernel.org

On Tue, Jun 21, 2016 at 10:43:40AM -0700, Andy Lutomirski wrote:
>
> Is there a straightforward way that bluetooth and, potentially, other
> drivers can just do synchronous crypto in a small buffer specified by
> its virtual address?  The actual cryptography part of the crypto code
> already works this way, but I can't find an API for it.

Yes, single block users should use crypto_cipher_encrypt_one, an
example would be drivers/md/dm-crypt.c.

Cheers,
-- 
Email: Herbert Xu <herbert-lOAM2aK0SrRLBo1qDEOMRrpzq4S04n8Q@public.gmane.org>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
