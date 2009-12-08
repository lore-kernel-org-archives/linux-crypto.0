From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: question about fragmentation of large packets
Date: Tue, 8 Dec 2009 20:58:46 +0800
Message-ID: <20091208125846.GA30136@gondor.apana.org.au>
References: <311e0d1f0912080454q6099cc4cq5b23617364bf9633@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: avital sela <avitalsela95@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:42707 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754498AbZLHM6m (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 8 Dec 2009 07:58:42 -0500
Content-Disposition: inline
In-Reply-To: <311e0d1f0912080454q6099cc4cq5b23617364bf9633@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Dec 08, 2009 at 02:54:43PM +0200, avital sela wrote:
> Hello,
> 
> I am testing a AES HW crypto driver I wrote. I test by setting up a
> tunnel between the board and a Linux server and pinging packets from
> the board to the server.
> With my driver loaded everything works fine with small packets but
> large packets (>1500) fail (100% packet loss).
> I added some debug code to the standard crypto/cbc.c and noticed that
> when I ping using -s1500 the encryption (aes-cbc) gets broken up to 3
> chuncks
> sized 1456 , 16, 64.  I also noticed that the iv for each of the
> chunks is different.
> Questions:
> 1. Why are there 3 chunks with these sizes? Is this related to the
> crypto subsystem or the  ipsec one?

The chunks 1456/64 is a product of the TCP stack.  16 is the IV
added on by IPsec.

> 2. How is the iv computed between each subsequent chunk?

The last cipher (encrypted) block of a chunk should be used as
the IV for the next chunk.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
