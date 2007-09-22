From: Herbert Xu <herbert.xu@redhat.com>
Subject: Re: [PATCH 1/1]: CTR mode implementation
Date: Sat, 22 Sep 2007 09:17:25 +0800
Message-ID: <20070922011725.GD17022@gondor.apana.org.au>
References: <200708301614.l7UGEj44031217@faith.austin.ibm.com> <20070919130615.GA20468@gondor.apana.org.au> <1190242276.15699.996.camel@faith.austin.ibm.com> <20070920081920.GA31211@gondor.apana.org.au> <1190420102.2477.53.camel@faith.austin.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, tgraf@suug.ch
To: Joy Latten <latten@austin.ibm.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:2654 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754211AbXIVBRk (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 21 Sep 2007 21:17:40 -0400
Content-Disposition: inline
In-Reply-To: <1190420102.2477.53.camel@faith.austin.ibm.com>
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Fri, Sep 21, 2007 at 07:15:02PM -0500, Joy Latten wrote:
>
> > I suggest that you make these parameters to your CTR template.
> > So instead of requesting for "ctr(aes)", you could request for
> > "ctr(aes, 4, 8)" where 4 is the length of the nonce in the
> > counter block and 8 is the length of the IV.  The counter
> > itself would then be calculated as block_size - 4 - 8.
> > 
> Ok, pretty much had this coded up when it dawned on me
> maybe I should include the nonce as parameter too.
> Whenever you use ctr, it is a given you need the nonce.
> Couldn't the user of the api, separate the nonce from 
> the key and pass it in the template? It would solve
> my problem about sometimes the keylen is bigger than 
> max-key-length for the algorithm with the additional bytes 
> for nonce. So, I could pass in ctr(aes, nonce, noncesize, ivsize).
> Let me know if this sounds ok or did I miss something important?

It would be awkward to have the actual nonce as a parameter
because for IPsec at least it's negotiated through the same
process as the encryption key.

More importantly, for the same "ctr(aes, 4, 8)" tuple, there
are many users (each SA would need two) while for if you
include the actual nonce then each tuple would be used by just
one SA.

> Ok, I get it. Thanks. :-)
> I will try using the original IV as you first suggested.

Sorry, my suggestion doesn't actually work because the IV's
size is smaller than the block size :) Putting it on the stack
should be fine though.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
