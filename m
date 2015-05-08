From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 10/10] drivers/crypto/nx: add hardware 842 crypto comp alg
Date: Fri, 8 May 2015 10:32:34 +0800
Message-ID: <20150508023234.GB7803@gondor.apana.org.au>
References: <1428428070-17803-1-git-send-email-ddstreet@ieee.org>
 <1430931066-4536-1-git-send-email-ddstreet@ieee.org>
 <1430931066-4536-11-git-send-email-ddstreet@ieee.org>
 <20150507031238.GC29395@gondor.apana.org.au>
 <CALZtONBBoy=sM8Qt43-_k8BWTwSKA3FaJg9JMfJHzJ3wh5+kvQ@mail.gmail.com>
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
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:47586 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751253AbbEHCdE (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 7 May 2015 22:33:04 -0400
Content-Disposition: inline
In-Reply-To: <CALZtONBBoy=sM8Qt43-_k8BWTwSKA3FaJg9JMfJHzJ3wh5+kvQ@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, May 07, 2015 at 11:06:06AM -0400, Dan Streetman wrote:
> 
> The crypto 842-nx has (significant) code in it to handle any alignment
> and length input buffers, to match them to what the driver requires.
> Would it be better to move that into the crypto code, so that any
> crypto compression hw driver can request buffers be specifically
> aligned/sized?  I did have to use a header on each compressed buffer
> that needed re-alignment or re-sizing, so maybe it's not appropriate
> for common crypto compression code.

Yes we could certainly move this logic into the crypto layer, as
we do for ciphers and hashes.

But as you say we could make the next guy who writes a comp driver
do this :)

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
