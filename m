From: Stephan Mueller <smueller@chronox.de>
Subject: Re: tcrypt failing on hmac(crc32)
Date: Wed, 25 May 2016 13:39:46 +0200
Message-ID: <3290175.Rqio6LsW94@tauon.atsec.com>
References: <20160525070752.GB6559@suse.de> <15120183.LV0UqqT84Y@positron.chronox.de> <20160525113610.GM7314@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: linux-crypto@vger.kernel.org
To: Marcus Meissner <meissner@suse.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:34780 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754434AbcEYLjt (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Wed, 25 May 2016 07:39:49 -0400
In-Reply-To: <20160525113610.GM7314@suse.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Mittwoch, 25. Mai 2016, 13:36:10 schrieb Marcus Meissner:

Hi Marcus,

> Hi,
> 
> On Wed, May 25, 2016 at 09:10:31AM +0200, Stephan Mueller wrote:
> > Am Mittwoch, 25. Mai 2016, 09:07:52 schrieb Marcus Meissner:
> > 
> > Hi Marcus,
> > 
> > > Hi,
> > > 
> > > when enabling the testmgr framework and FIPS in 4.6 and 4.4 and running
> > > "modprobe tcrypt"
> > > 
> >         }, {
> >         
> >                 .alg = "hmac(crc32)",
> >                 .test = alg_test_hash,
> > 
> > ...
> > 
> > fips_allowed = 1 missing?
> 
> The kernel was not in FIPS mode, and adding it did not help. :/

Sorry, I read FIPS and implied fips=1 :-)

Ciao
Stephan
