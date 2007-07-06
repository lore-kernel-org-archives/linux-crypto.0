From: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Subject: Re: RSA support into kernel?
Date: Fri, 6 Jul 2007 16:10:51 +0400
Message-ID: <20070706121050.GA9721@2ka.mipt.ru>
References: <f8b2ccd40707051548w275a1575oaaddffd40d9a9163@mail.gmail.com> <20070706103731.GA10033@2ka.mipt.ru> <20070706.040533.30182871.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=koi8-r
Cc: gautam.singaraju@gmail.com, linux-crypto@vger.kernel.org
To: David Miller <davem@davemloft.net>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from relay.2ka.mipt.ru ([194.85.82.65]:52476 "EHLO 2ka.mipt.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759587AbXGFMLF (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Fri, 6 Jul 2007 08:11:05 -0400
Content-Disposition: inline
In-Reply-To: <20070706.040533.30182871.davem@davemloft.net>
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Fri, Jul 06, 2007 at 04:05:33AM -0700, David Miller (davem@davemloft.net) wrote:
> From: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
> Date: Fri, 6 Jul 2007 14:37:31 +0400
> 
> > On Thu, Jul 05, 2007 at 03:48:51PM -0700, Gautam Singaraju (gautam.singaraju@gmail.com) wrote:
> > > Is there any attempts being made to provide software based RSA
> > > cryptographic support in kernel level? I see that 2.6.21 supports
> > > Hardware devices such as VIA Padlock ACE. Has anybody had a change to
> > > use such a system?
> > 
> > VIA padlock engine or RSA? The former is heavily used in the wild, but
> > why would anyone want to use RSA in the kernel?
> 
> Automatic SSL done in-kernel on user data for socket I/O, with
> hardware offload from the crypto layer when available.
> 
> Solaris has done this for quite some time and it helps a lot for
> things like the VIA and Niagara.

I.e. for userspace stuff? That is obviously the right usage, but Linux
cryptoapi does not have userspace interface, so was my question.
Actually I was several times already asked after acrypto was closed, how
userspace can use new hardware drivers, and frankly I do not know what
the best userspace API would look like (in one of the projects I already 
used all three methods one-by-one and failed to determine the best). 
Simple char device read/write or ioctl, or blocking/nonblocking syscall 
over file descriptor, or anything else?

-- 
	Evgeniy Polyakov
