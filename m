From: David McCullough <David_Mccullough@securecomputing.com>
Subject: Re: Openswan 2.4.9 - tasklet or workqueue ?
Date: Fri, 31 Aug 2007 08:44:48 +1000
Message-ID: <20070830224448.GA11140@securecomputing.com>
References: <20070827224021.GA23450@securecomputing.com> <440337.35301.qm@web62504.mail.re1.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, ocf-linux-users@lists.sourceforge.net
To: Eran Ben-Avi <eranpublic@yahoo.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rex.snapgear.com ([203.143.235.140]:52016 "EHLO
	cyberguard.com.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758417AbXH3Wjt (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 30 Aug 2007 18:39:49 -0400
Content-Disposition: inline
In-Reply-To: <440337.35301.qm@web62504.mail.re1.yahoo.com>
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org


Jivin Eran Ben-Avi lays it down ...
> 
> --- David McCullough
> <David_Mccullough@securecomputing.com> wrote:
> 
> > 
> > 
> > 
> > Jivin Eran Ben-Avi lays it down ...
> > > Hi,
> > > 
> > > I tested IPSec(tunnel mode) routing performance
> > between 2 GbE ports using packet generator(SMARTBIT)
> >  on ARM 500MHz with latest OCF patched on
> > Openswan2.4.9 and I noticed the callback functions
> > are using workqueue.
> > > Since RX was performed in NAPI mode with higher
> > priority then TX (in workqueue), the callback
> > function(in ipsec_ocf.c) was starved with zero
> > routing.
> > > The problem was solved after I switched to use
> > tasklet instead of the workqueue.
> > > Is there a room for updating next OCF release ?
> > 
> > Sure,  send in a patch. This is against
> > ocf-linux-20070727 right ?
>
> Yes.
> Can you please estimate when next release will be
> ready?

When there is a need,  I can turn it around in a day or so.
I could also post a patch that is current much more quickly
if you would prefer ?

Cheers,
Davidm

-- 
David McCullough,  david_mccullough@securecomputing.com,   Ph:+61 734352815
Secure Computing - SnapGear  http://www.uCdot.org http://www.cyberguard.com
