From: "J. Bruce Fields" <bfields@fieldses.org>
Subject: Re: [PATCH] crypto: scatterwalk_copychunks() fails to advance through scatterlist
Date: Tue, 20 Mar 2007 10:17:56 -0400
Message-ID: <20070320141756.GB12165@fieldses.org>
References: <20070319235508.GH29272@fieldses.org> <20070320051656.GA17711@gondor.apana.org.au> <20070320141614.GA12165@fieldses.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: nfsv4@linux-nfs.org, linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.fieldses.org ([66.93.2.214]:36489 "EHLO fieldses.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933439AbXCTOR5 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Tue, 20 Mar 2007 10:17:57 -0400
Content-Disposition: inline
In-Reply-To: <20070320141614.GA12165@fieldses.org>
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Tue, Mar 20, 2007 at 10:16:14AM -0400, J. Bruce Fields wrote:
> On Tue, Mar 20, 2007 at 04:16:56PM +1100, Herbert Xu wrote:
> > Thanks for the patch.  However I still have a question as to why
> > this is happening.
> > 
> > As far as I can see scatterwalk_copychunks is only called in two
> > places.  In both spots it only processes one block of data.  Since
> > we set the maximum block size to PAGE_SIZE/8 I don't see how you
> > can get an offset of zero and still roll over to the next page
> > in scatterwalk_copychunks.
> 
> Are the elements of the scatterlists assumed to always be full pages?  I
> need to encrypt things that look like, for example:
> 
> 	sg[0].page = page1
> 	sg[0].offset = 0
> 	sg[0].length = 5
> 	sg[1].page = page2
> 	sg[1].offset = 0
> 	sg[1].length = 37

(Erm, second should be 27--I did mean this to come out to a multiple of
8....)--b.

> 
> and worse....  I could do this by hand if I had to, but the crypto code,
> if it's not designed to handle this sort of thing, seems very close, so
> I'd rather enhance it than duplicate a lot of this complicated
> scatterlist-traversal stuff.
> 
> --b.
> _______________________________________________
> NFSv4 mailing list
> NFSv4@linux-nfs.org
> http://linux-nfs.org/cgi-bin/mailman/listinfo/nfsv4
