From: "Kabir Ahsan-r9aahw" <Ahsan.Kabir@freescale.com>
Subject: RE: Openswan 2.4.9 - tasklet or workqueue ?
Date: Tue, 11 Sep 2007 12:19:03 -0700
Message-ID: <351763BE49AC8743AFCCF925821FF6BE01CCB6AC@az33exm22.fsl.freescale.net>
References: <20070827224021.GA23450@securecomputing.com> <440337.35301.qm@web62504.mail.re1.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Cc: <linux-crypto@vger.kernel.org>
To: "Eran Ben-Avi" <eranpublic@yahoo.com>,
	"David McCullough" <David_Mccullough@securecomputing.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from de01egw02.freescale.net ([192.88.165.103]:36476 "EHLO
	de01egw02.freescale.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750796AbXIKTTJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 11 Sep 2007 15:19:09 -0400
Received: from de01smr01.freescale.net (de01smr01.freescale.net [10.208.0.31])
	by de01egw02.freescale.net (8.12.11/de01egw02) with ESMTP id l8BJJ4Ks003102
	for <linux-crypto@vger.kernel.org>; Tue, 11 Sep 2007 12:19:05 -0700 (MST)
Received: from az33exm22.fsl.freescale.net (az33exm22.am.freescale.net [10.64.32.10])
	by de01smr01.freescale.net (8.13.1/8.13.0) with ESMTP id l8BJJ4sB002036
	for <linux-crypto@vger.kernel.org>; Tue, 11 Sep 2007 14:19:04 -0500 (CDT)
Content-class: urn:content-classes:message
In-Reply-To: <440337.35301.qm@web62504.mail.re1.yahoo.com>
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

We can also do direct function call of ipsec_xsm or ipsec_rsm instead of using tasklet. 

-----Original Message-----
From: linux-crypto-owner@vger.kernel.org [mailto:linux-crypto-owner@vger.kernel.org] On Behalf Of Eran Ben-Avi
Sent: Thursday, August 30, 2007 2:58 AM
To: David McCullough
Cc: linux-crypto@vger.kernel.org
Subject: Re: Openswan 2.4.9 - tasklet or workqueue ?


--- David McCullough
<David_Mccullough@securecomputing.com> wrote:

> 
> 
> 
> Jivin Eran Ben-Avi lays it down ...
> > Hi,
> > 
> > I tested IPSec(tunnel mode) routing performance
> between 2 GbE ports using packet generator(SMARTBIT)  on ARM 500MHz 
> with latest OCF patched on
> Openswan2.4.9 and I noticed the callback functions are using 
> workqueue.
> > Since RX was performed in NAPI mode with higher
> priority then TX (in workqueue), the callback function(in ipsec_ocf.c) 
> was starved with zero routing.
> > The problem was solved after I switched to use
> tasklet instead of the workqueue.
> > Is there a room for updating next OCF release ?
> 
> Sure,  send in a patch. This is against
> ocf-linux-20070727 right ?
Yes.
Can you please estimate when next release will be ready?

Thanks. 

> 
> Cheers,
> Davidm
> 
> --
> David McCullough, 
> david_mccullough@securecomputing.com,   Ph:+61
> 734352815
> Secure Computing - SnapGear  http://www.uCdot.org 
> http://www.cyberguard.com
> -
> To unsubscribe from this list: send the line "unsubscribe 
> linux-crypto" in the body of a message to majordomo@vger.kernel.org 
> More majordomo info at http://vger.kernel.org/majordomo-info.html
> 



       
____________________________________________________________________________________
Got a little couch potato? 
Check out fun summer activities for kids.
http://search.yahoo.com/search?fr=oni_on_mail&p=summer+activities+for+kids&cs=bz 
