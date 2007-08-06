From: "Ronen Shitrit" <rshitrit@marvell.com>
Subject: RE: status of async crypto
Date: Mon, 6 Aug 2007 12:00:13 +0300
Message-ID: <B9FFC3F97441D04093A504CEA31B7C4101AA3805@msilexch01.marvell.com>
References: <B9FFC3F97441D04093A504CEA31B7C4101AA34D2@msilexch01.marvell.com> <20070805151546.GC32132@2ka.mipt.ru>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Cc: "Evgeniy Polyakov" <johnpol@2ka.mipt.ru>
To: <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from shoshil.marvell.com ([199.203.130.250]:17335 "EHLO
	il.marvell.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754263AbXHFJBD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 6 Aug 2007 05:01:03 -0400
Content-class: urn:content-classes:message
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Wow, I thought that there was more progress ...

BTW:
I know that the OCF support the OpenSWAN, does it also support the KLIPS
by now?
I also noticed that the Acrypto have a patch to support KLIPS, does it
also support the OpenSWAN?

Regards
Ronen Shitrit


> -----Original Message-----
> From: Evgeniy Polyakov [mailto:johnpol@2ka.mipt.ru]
> Sent: Sunday, August 05, 2007 6:16 PM
> To: Ronen Shitrit
> Cc: linux-crypto@vger.kernel.org
> Subject: Re: status of async crypto
> 
> On Sun, Aug 05, 2007 at 01:50:48PM +0300, Ronen Shitrit
> (rshitrit@marvell.com) wrote:
> > I saw that the current code support async crypto for the dm-crypt,
does
> > it
> > also support async crypto for the klips?
> > Is there any support for using the async crypto from the OpenSSL
engine
> > library?
> > I saw that the async crypto support block cipher, does it also
support
> > digest operations?
> > Can it support encryption + authentication (lets say AES-SHA1) as
one
> > operation?
> > Is there any Documentation available? (I guess not)
> 
> No for all above.
> 
> > What is the todo list for further development of the async crypto
> > support?
> 
> New drivers and extending functionality if required. Some work is
being
> done in this area, although not that fast.
> 
> --
> 	Evgeniy Polyakov
