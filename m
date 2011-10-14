From: Nick Bowler <nbowler@elliptictech.com>
Subject: Re: [PATCH] crypto: ghash: Avoid null pointer dereference if no key
 is set.
Date: Fri, 14 Oct 2011 13:13:58 -0400
Message-ID: <20111014171358.GA15626@elliptictech.com>
References: <1318603040-1360-1-git-send-email-nbowler@elliptictech.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Herbert Xu <herbert@gondor.hengli.com.au>,
	"David S. Miller" <davem@davemloft.net>
To: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.elliptictech.com ([209.217.122.41]:50950 "EHLO
	mail.ellipticsemi.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933334Ab1JNRN7 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 14 Oct 2011 13:13:59 -0400
Content-Disposition: inline
In-Reply-To: <1318603040-1360-1-git-send-email-nbowler@elliptictech.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 2011-10-14 10:37 -0400, Nick Bowler wrote:
> The ghash_update function passes a pointer to gf128mul_4k_lle which will
> be NULL if ghash_setkey is not called or if the most recent call to
> ghash_setkey failed to allocate memory.  This causes an oops.  Fix this
> up by returning an error code in the null case.
> 
> This is trivially triggered from unpriviliged userspace through the
> AF_ALG interface by simply writing to the socket without setting a key.

It looks like this can also happen in ghash_final if an evil user calls
setkey, update with a length that's not a multiple of the block size,
then setkey again (this time failing due to an allocation failure) then
final.  Thus, I suppose that final needs the same check.

v2 forthcoming...
-- 
Nick Bowler, Elliptic Technologies (http://www.elliptictech.com/)
