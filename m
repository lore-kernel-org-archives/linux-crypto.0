From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 09/11] crypto: remove LZO fallback from crypto 842
Date: Wed, 8 Apr 2015 22:48:42 +0800
Message-ID: <20150408144842.GA30895@gondor.apana.org.au>
References: <1428428070-17803-1-git-send-email-ddstreet@ieee.org>
 <1428428070-17803-10-git-send-email-ddstreet@ieee.org>
 <20150408141600.GA30338@gondor.apana.org.au>
 <CALZtONC0WWkfaRs+0SNHaDQ1DhT+1ekgk0YXsQBi_2NRoP1e8Q@mail.gmail.com>
 <20150408143831.GA30762@gondor.apana.org.au>
 <CALZtONAZenUKxJdzOFXe1hBxGCASO_GsVfG9vtKWBe5EwcftmA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "David S. Miller" <davem@davemloft.net>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Benjamin Herrenschmidt <benh@kernel.crashing.org>,
	Paul Mackerras <paulus@samba.org>,
	Seth Jennings <sjennings@variantweb.net>,
	Robert Jennings <rob@pochix.net>, linux-crypto@vger.kernel.org,
	"linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
	linux-kernel <linux-kernel@vger.kernel.org>
To: Dan Streetman <ddstreet@ieee.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CALZtONAZenUKxJdzOFXe1hBxGCASO_GsVfG9vtKWBe5EwcftmA@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Wed, Apr 08, 2015 at 10:45:45AM -0400, Dan Streetman wrote:
>
> Ok I'll see if I can include a sw compression implementation.

That would be great!

> ah ok, so you mean it can still be a crypto_comp interface, just move
> its location and/or merge it into nx-842.c?

Oh yes of course.  There is nothing wrong with it exporting this
via the crypto API.  It's just in an unusual spot for a driver.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
