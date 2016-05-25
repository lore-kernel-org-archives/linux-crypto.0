From: Marcus Meissner <meissner@suse.de>
Subject: Re: tcrypt failing on hmac(crc32)
Date: Wed, 25 May 2016 15:05:28 +0200
Message-ID: <20160525130528.GA30676@suse.de>
References: <20160525070752.GB6559@suse.de>
 <15120183.LV0UqqT84Y@positron.chronox.de>
 <20160525113610.GM7314@suse.de>
 <3290175.Rqio6LsW94@tauon.atsec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: Stephan Mueller <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:47191 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751028AbcEYNFa (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Wed, 25 May 2016 09:05:30 -0400
Content-Disposition: inline
In-Reply-To: <3290175.Rqio6LsW94@tauon.atsec.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, May 25, 2016 at 01:39:46PM +0200, Stephan Mueller wrote:
> Am Mittwoch, 25. Mai 2016, 13:36:10 schrieb Marcus Meissner:
> 
> Hi Marcus,
> 
> > Hi,
> > 
> > On Wed, May 25, 2016 at 09:10:31AM +0200, Stephan Mueller wrote:
> > > Am Mittwoch, 25. Mai 2016, 09:07:52 schrieb Marcus Meissner:
> > > 
> > > Hi Marcus,
> > > 
> > > > Hi,
> > > > 
> > > > when enabling the testmgr framework and FIPS in 4.6 and 4.4 and running
> > > > "modprobe tcrypt"
> > > > 
> > >         }, {
> > >         
> > >                 .alg = "hmac(crc32)",
> > >                 .test = alg_test_hash,
> > > 
> > > ...
> > > 
> > > fips_allowed = 1 missing?
> > 
> > The kernel was not in FIPS mode, and adding it did not help. :/
> 
> Sorry, I read FIPS and implied fips=1 :-)

I think we are running in a precondition

        ds = salg->digestsize;		// is CHKSUM_DIGEST_SIZE == 4 for CRC32
        ss = salg->statesize;		// ? cant find it
        alg = &salg->base; 		// base.cra_blocksize seems CHKSUM_BLOCKSIZE == 1
        if (ds > alg->cra_blocksize ||
            ss < alg->cra_blocksize)
                goto out_put_alg;

	4 > 1 ... so EINVAL return.

If this is the case, hmac(crc32) might be kind of non-sensical?

Ciao, Marcus
