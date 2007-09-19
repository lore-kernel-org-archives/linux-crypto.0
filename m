From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] an XTS blockcipher mode implementation without partial blocks
Date: Wed, 19 Sep 2007 20:24:31 +0800
Message-ID: <20070919122431.GC19866@gondor.apana.org.au>
References: <11890910223906-git-send-email-rsnel@cube.dyndns.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, christoph.sievers@gmail.com
To: Rik Snel <rsnel@cube.dyndns.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:3477 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758981AbXISMYi (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 19 Sep 2007 08:24:38 -0400
Content-Disposition: inline
In-Reply-To: <11890910223906-git-send-email-rsnel@cube.dyndns.org>
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Thu, Sep 06, 2007 at 05:03:42PM +0200, Rik Snel wrote:
> XTS currently considered to be the successor of the LRW mode by the IEEE1619
> workgroup. LRW was discarded, because it was not secure if the encyption key
> itself is encrypted with LRW.
> 
> XTS does not have this problem. The implementation is pretty straightforward,
> a new function was added to gf128mul to handle GF(128) elements in ble format.
> Four testvectors from the specification
> 	http://grouper.ieee.org/groups/1619/email/pdf00086.pdf
> were added, and they verify on my system.
> 
> Signed-off-by: Rik Snel <rsnel@cube.dyndns.org>

Nice work.  Thanks Rik!
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
