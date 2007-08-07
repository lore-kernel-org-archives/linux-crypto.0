From: "Ronen Shitrit" <rshitrit@marvell.com>
Subject: RE: status of async crypto
Date: Tue, 7 Aug 2007 10:14:35 +0300
Message-ID: <B9FFC3F97441D04093A504CEA31B7C4101AA3B33@msilexch01.marvell.com>
References: <B9FFC3F97441D04093A504CEA31B7C4101AA34D2@msilexch01.marvell.com> <20070805151546.GC32132@2ka.mipt.ru>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Cc: <linux-crypto@vger.kernel.org>
To: "Herbert Xu" <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from shoshil.marvell.com ([199.203.130.250]:10461 "EHLO
	il.marvell.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753817AbXHGHQl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 7 Aug 2007 03:16:41 -0400
Content-class: urn:content-classes:message
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Hi Herbert

I found a mailing thread discussing "combined mode algorithms", I think
that this is the main missing link for good async support.

Are you planning that this combined alg mode will support the async API?
Is there any progress on this direction?

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
