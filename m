From: rsnel@cube.dyndns.org
Subject: Re: LRW implementation, please comment
Date: Fri, 1 Sep 2006 10:55:14 +0200
Message-ID: <20060901085514.GA4821@cube.dyndns.org>
References: <11570279761772-git-send-email-rsnel@cube.dyndns.org> <20060901035225.GA9547@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from smtp-vbr17.xs4all.nl ([194.109.24.37]:33289 "EHLO
	smtp-vbr17.xs4all.nl") by vger.kernel.org with ESMTP
	id S932449AbWIAIze (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Fri, 1 Sep 2006 04:55:34 -0400
To: Herbert Xu <herbert@gondor.apana.org.au>
Content-Disposition: inline
In-Reply-To: <20060901035225.GA9547@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Hello,

On Fri, Sep 01, 2006 at 01:52:25PM +1000, Herbert Xu wrote:
> On Thu, Aug 31, 2006 at 02:39:30PM +0200, Rik Snel wrote:
> > This is an attempt at implementing LRW for the new blockcipher API.
> > Please review, test and comment. 
> 
> Thanks a lot for doing this.  It looks good to me.

That's good to hear.

> There are a few style (see Documentation/CodingStyle) issues.  It would
> be good if you can fix them up before I apply the patches.

Can you give some examples about what I missed from CodingStyle?
(I just reread it and I think my patch adheres pretty well to those
rules: tabs=8, K&R bracing, don't pollute global namespace etc...)

> Could you also convert the test vectors to use tcrypt.h/tcrypt.c?

Yes, I just didn't know what tcrypt.[ch] was for, otherwise I would have put
those vectors there in the first place. The last testvector, however,
won't fit because it is an entire 512 byte sector. (which is not that
bad, because alle narrow blocks (16 bytes) are encrypted independently,
no realistic testvector of a wide block cipher mode would fit. (ABL uses
blocks of any size, say 512 bytes, and if 1 bit changes in the plaintext
block, the whole cypher block will be affected) I will propose something
to fix that if ABL is finished.

Greetings,

Rik.

-- 
Nothing is ever a total loss; it can always serve as a bad example.
