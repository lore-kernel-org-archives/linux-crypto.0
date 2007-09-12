From: David McCullough <David_Mccullough@securecomputing.com>
Subject: Re: Openswan 2.4.9 - tasklet or workqueue ?
Date: Wed, 12 Sep 2007 22:13:42 +1000
Message-ID: <20070912121342.GG26940@securecomputing.com>
References: <20070827224021.GA23450@securecomputing.com> <440337.35301.qm@web62504.mail.re1.yahoo.com> <351763BE49AC8743AFCCF925821FF6BE01CCB6AC@az33exm22.fsl.freescale.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Eran Ben-Avi <eranpublic@yahoo.com>, linux-crypto@vger.kernel.org,
	ocf-linux-users@lists.sourceforge.net
To: Kabir Ahsan-r9aahw <Ahsan.Kabir@freescale.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rex.snapgear.com ([203.143.235.140]:41253 "EHLO
	cyberguard.com.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S967345AbXILMHj (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 12 Sep 2007 08:07:39 -0400
Content-Disposition: inline
In-Reply-To: <351763BE49AC8743AFCCF925821FF6BE01CCB6AC@az33exm22.fsl.freescale.net>
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org


Jivin Kabir Ahsan-r9aahw lays it down ...
> We can also do direct function call of ipsec_xsm or ipsec_rsm instead
> of using tasklet. 

Care to come up with something that still works for 2.4 but it targetted
more at 2.6 ?  I wasn't all the happy with the double function thing
going on there,

Cheers,
Davidm


> -----Original Message-----
> From: linux-crypto-owner@vger.kernel.org [mailto:linux-crypto-owner@vger.kernel.org] On Behalf Of Eran Ben-Avi
> Sent: Thursday, August 30, 2007 2:58 AM
> To: David McCullough
> Cc: linux-crypto@vger.kernel.org
> Subject: Re: Openswan 2.4.9 - tasklet or workqueue ?
> 
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
> > between 2 GbE ports using packet generator(SMARTBIT)  on ARM 500MHz 
> > with latest OCF patched on
> > Openswan2.4.9 and I noticed the callback functions are using 
> > workqueue.
> > > Since RX was performed in NAPI mode with higher
> > priority then TX (in workqueue), the callback function(in ipsec_ocf.c) 
> > was starved with zero routing.
> > > The problem was solved after I switched to use
> > tasklet instead of the workqueue.
> > > Is there a room for updating next OCF release ?
> > 
> > Sure,  send in a patch. This is against
> > ocf-linux-20070727 right ?
> Yes.
> Can you please estimate when next release will be ready?
> 
> Thanks. 
> 
> > 
> > Cheers,
> > Davidm
> > 
> > --
> > David McCullough, 
> > david_mccullough@securecomputing.com,   Ph:+61
> > 734352815
> > Secure Computing - SnapGear  http://www.uCdot.org 
> > http://www.cyberguard.com
> > -
> > To unsubscribe from this list: send the line "unsubscribe 
> > linux-crypto" in the body of a message to majordomo@vger.kernel.org 
> > More majordomo info at http://vger.kernel.org/majordomo-info.html
> > 
> 
> 
> 
>        
> ____________________________________________________________________________________
> Got a little couch potato? 
> Check out fun summer activities for kids.
> http://search.yahoo.com/search?fr=oni_on_mail&p=summer+activities+for+kids&cs=bz 
> 

-- 
David McCullough,  david_mccullough@securecomputing.com,   Ph:+61 734352815
Secure Computing - SnapGear  http://www.uCdot.org http://www.cyberguard.com
