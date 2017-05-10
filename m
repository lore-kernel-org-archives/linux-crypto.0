From: Mike Snitzer <snitzer@redhat.com>
Subject: need to pick a solution for dm-crypt IV generation and do it! [was:
 Re: dm: submit stacked requests in irq enabled context]
Date: Wed, 10 May 2017 10:45:25 -0400
Message-ID: <20170510144525.GA5608@redhat.com>
References: <a66b6e17-a8c4-3465-fc2e-c3114abe0ca7@codeaurora.org>
 <dee12838-7b43-2fdd-0644-41c10ecf9148@codeaurora.org>
 <20170509155555.GB2572@localhost.localdomain>
 <20170510071733.GA24980@infradead.org>
 <39356321-b39b-98c7-f52b-ffd19d6dfc69@codeaurora.org>
 <CAOtvUMcjULAOZYQ3K_XDvxcFoFJJjX-wxF6e6Y1+-r67tS_Y7g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Neeraj Soni <neersoni@codeaurora.org>,
        Christoph Hellwig <hch@infradead.org>,
        Keith Busch <keith.busch@intel.com>, dm-devel@redhat.com,
        Alasdair Kergon <agk@redhat.com>,
        Ondrej Mosnacek <omosnace@redhat.com>,
        Milan Broz <gmazyland@gmail.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        linux-crypto@vger.kernel.org
To: Gilad Ben-Yossef <gilad@benyossef.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:59886 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751267AbdEJOpa (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 10 May 2017 10:45:30 -0400
Content-Disposition: inline
In-Reply-To: <CAOtvUMcjULAOZYQ3K_XDvxcFoFJJjX-wxF6e6Y1+-r67tS_Y7g@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, May 10 2017 at  9:37am -0400,
Gilad Ben-Yossef <gilad@benyossef.com> wrote:

> On Wed, May 10, 2017 at 11:49 AM, Neeraj Soni <neersoni@codeaurora.org> wrote:
> > Hi Keith,
> >
> > Request based dm (dm-req-crypt) is being used for Disk Encryption solution
> > in Android used by Google. Also as i mentioned reverting this fix  improves
> > the RR/RW numbers so this proves the request based dm is coming into path
> > and is being used.
> 
> Sadly, that is an out of tree module.
> 
> Does it still use Qcom specific APIs in its implementation (qcrypto_* funcs)?
> It did the last time I've checked - and the driver that implements
> those is not upstream either...
> 
> It makes it difficult to help - which is a shame since I am interested
> in enabling higher performance
> of dm-crypt when using HW based crypto transformation myself.

I have absolutely no interest in request-based dm-crypt.  It is a hack
to work-around limitations in crypto IV generation.

If "google" is foolish enough to deploy out-of-tree request-based
dm-crypt in their android kernel then they are easily capable of
reverting the commit in question to prop up their short-cited decision.

The correct way forward is to follow through with the crypto work
discussed here (pick a solution to implement and make it happen):
https://www.redhat.com/archives/dm-devel/2017-March/msg00044.html
and here:
https://www.redhat.com/archives/dm-devel/2017-March/msg00053.html
and here:
https://www.redhat.com/archives/dm-devel/2017-April/msg00132.html

Mike
