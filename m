From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: LRW implementation, please comment
Date: Fri, 1 Sep 2006 20:37:07 +1000
Message-ID: <20060901103707.GA17110@gondor.apana.org.au>
References: <11570279761772-git-send-email-rsnel@cube.dyndns.org> <20060901035225.GA9547@gondor.apana.org.au> <20060901085514.GA4821@cube.dyndns.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:24847 "EHLO
	arnor.apana.org.au") by vger.kernel.org with ESMTP id S1751444AbWIAKhF
	(ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Fri, 1 Sep 2006 06:37:05 -0400
To: rsnel@cube.dyndns.org
Content-Disposition: inline
In-Reply-To: <20060901085514.GA4821@cube.dyndns.org>
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Fri, Sep 01, 2006 at 10:55:14AM +0200, rsnel@cube.dyndns.org wrote:
> 
> Can you give some examples about what I missed from CodingStyle?
> (I just reread it and I think my patch adheres pretty well to those
> rules: tabs=8, K&R bracing, don't pollute global namespace etc...)

It's only a few spots:

* Space before * for pointers, e.g., (u64 *) instead of (u64*).
* There is one line near the end b128ops.h that starts with spaces.
* Some lines terminate with spaces.

The last two issues can be caught if you test your patch with

git apply --check --whitespace=error-all diff

> Yes, I just didn't know what tcrypt.[ch] was for, otherwise I would have put
> those vectors there in the first place. The last testvector, however,
> won't fit because it is an entire 512 byte sector. (which is not that
> bad, because alle narrow blocks (16 bytes) are encrypted independently,
> no realistic testvector of a wide block cipher mode would fit. (ABL uses
> blocks of any size, say 512 bytes, and if 1 bit changes in the plaintext
> block, the whole cypher block will be affected) I will propose something
> to fix that if ABL is finished.

Feel free to extend the tcrypt cipher test buffer to 512 bytes.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
