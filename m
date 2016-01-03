From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v2] crypto: algif_skcipher - Require setkey before
 accept(2)
Date: Sun, 3 Jan 2016 09:31:26 +0800
Message-ID: <20160103013126.GA30385@gondor.apana.org.au>
References: <CACT4Y+YOwOfRHOwJ=FA9aaL2cZ-PRhTvd_mCzxx2nnN_L3tygw@mail.gmail.com>
 <5687BA0F.3020104@gmail.com>
 <5687E19E.2070801@gmail.com>
 <1647086.cdlVYfuqk1@myon.chronox.de>
 <56883096.1020009@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Stephan Mueller <smueller@chronox.de>,
	Dmitry Vyukov <dvyukov@google.com>, syzkaller@googlegroups.com,
	davem@davemloft.net, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org, kcc@google.com, glider@google.com,
	edumazet@google.com, sasha.levin@oracle.com, keescook@google.com
To: Milan Broz <gmazyland@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <56883096.1020009@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Sat, Jan 02, 2016 at 09:18:30PM +0100, Milan Broz wrote:
>
> But I cannot change thousands of cryptsetup installations that are actively using that code.
> This is clear userspace breakage which should not happen this way.

I'll try to add some compatibility code for your case, assuming
your modus operandi is accept(2) followed by a single setkey before
proceeding to encryption/decryption.

> (Moreover it still doesn't work for cipher_null that has min/max key size 0.)

Setkey works just fine on cipher_null.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
