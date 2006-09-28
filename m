From: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Subject: Re: [ACRYPTO] New asynchronous crypto layer (acrypto) release.
Date: Thu, 28 Sep 2006 17:35:28 +0400
Message-ID: <20060928133528.GA19030@2ka.mipt.ru>
References: <20060928120826.GA18063@2ka.mipt.ru> <451BCCDF.5000201@ciphirelabs.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=koi8-r
Cc: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from relay.2ka.mipt.ru ([194.85.82.65]:63441 "EHLO 2ka.mipt.ru")
	by vger.kernel.org with ESMTP id S1751889AbWI1Nfk (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 28 Sep 2006 09:35:40 -0400
To: Andreas Jellinghaus <aj@ciphirelabs.com>
Content-Disposition: inline
In-Reply-To: <451BCCDF.5000201@ciphirelabs.com>
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Thu, Sep 28, 2006 at 03:23:43PM +0200, Andreas Jellinghaus (aj@ciphirelabs.com) wrote:
> >I'm pleased to announce asynchronous crypto layer (acrypto) [1] release 
> >for 2.6.18 kernel tree. Acrypto allows to handle crypto requests 
> >asynchronously in hardware.
> >
> >Combined patchset includes:
> > * acrypto core
> > * IPsec ESP4 port to acrypto
> > * dm-crypt port to acrypto
> 
> so I should be able to replace a plain 2.6.18 kernel with one
> with this patchset and use dm-crypt'ed partitions (e.g. swap,
> encrypted root filesystem) as usual without further changes?

Yes.

> Did anyone test this with success?

Except me, I think...
That code was used for OCF dm-crypt port some time ago (I recall it was
Marvell), so the whole base is not limited by acrypto only.

I can only say that there are users out there which use acrypto without
pointing exact names naturally. I agree that it does not sound very 
strong, but actually I'm not going to convince someone, I just establish
a fact.

> Regards, Andreas

-- 
	Evgeniy Polyakov
