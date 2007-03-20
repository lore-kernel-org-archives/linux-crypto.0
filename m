From: "J. Bruce Fields" <bfields@fieldses.org>
Subject: Re: [PATCH] crypto: scatterwalk_copychunks() fails to advance through scatterlist
Date: Tue, 20 Mar 2007 17:17:51 -0400
Message-ID: <20070320211751.GC16930@fieldses.org>
References: <20070319235508.GH29272@fieldses.org> <20070320051656.GA17711@gondor.apana.org.au> <20070320141614.GA12165@fieldses.org> <20070320205421.GA23929@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, nfsv4@linux-nfs.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.fieldses.org ([66.93.2.214]:38687 "EHLO fieldses.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751291AbXCTVRy (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Tue, 20 Mar 2007 17:17:54 -0400
Content-Disposition: inline
In-Reply-To: <20070320205421.GA23929@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Wed, Mar 21, 2007 at 07:54:21AM +1100, Herbert Xu wrote:
> On Tue, Mar 20, 2007 at 10:16:14AM -0400, J. Bruce Fields wrote:
> > 
> > Are the elements of the scatterlists assumed to always be full pages?  I
> 
> Definitely not.
> 
> > need to encrypt things that look like, for example:
> > 
> > 	sg[0].page = page1
> > 	sg[0].offset = 0
> > 	sg[0].length = 5
> > 	sg[1].page = page2
> > 	sg[1].offset = 0
> > 	sg[1].length = 37
> 
> OK I see what you mean now.  I'll apply your patch.

Thanks!

By the way, the commit that I believe introduced this regression did two
or three different things at once--I spent some time staring at it and
can't say I really understand the change.  That's probably just me!  But
would it be possible to split up these patches fine enough that people
inexperienced with this code would have a better chance of understanding
what's going on?

There's so many potential corner cases to handle here, I know I'd want
to tread very carefully....

(And did the crypto testing module use to have some tests for buffers
that were fragmented in odd ways, or was I imagining that?  I'd be happy
to help come up with some test cases if it'd be useful.)

--b.
