From: David Miller <davem@davemloft.net>
Subject: Re: RSA support into kernel?
Date: Fri, 06 Jul 2007 04:05:33 -0700 (PDT)
Message-ID: <20070706.040533.30182871.davem@davemloft.net>
References: <f8b2ccd40707051548w275a1575oaaddffd40d9a9163@mail.gmail.com>
	<20070706103731.GA10033@2ka.mipt.ru>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: gautam.singaraju@gmail.com, linux-crypto@vger.kernel.org
To: johnpol@2ka.mipt.ru
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:33818
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1755843AbXGFLFM (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 6 Jul 2007 07:05:12 -0400
In-Reply-To: <20070706103731.GA10033@2ka.mipt.ru>
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

From: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Date: Fri, 6 Jul 2007 14:37:31 +0400

> On Thu, Jul 05, 2007 at 03:48:51PM -0700, Gautam Singaraju (gautam.singaraju@gmail.com) wrote:
> > Is there any attempts being made to provide software based RSA
> > cryptographic support in kernel level? I see that 2.6.21 supports
> > Hardware devices such as VIA Padlock ACE. Has anybody had a change to
> > use such a system?
> 
> VIA padlock engine or RSA? The former is heavily used in the wild, but
> why would anyone want to use RSA in the kernel?

Automatic SSL done in-kernel on user data for socket I/O, with
hardware offload from the crypto layer when available.

Solaris has done this for quite some time and it helps a lot for
things like the VIA and Niagara.
