From: Stephan Mueller <smueller@chronox.de>
Subject: Re: [PATCH 2/3] crypto: algif_akcipher user space interface
Date: Thu, 23 Jul 2015 00:29:48 +0200
Message-ID: <2141479.AxYfgguRCx@tachyon.chronox.de>
References: <3908391.JkjAozYBaW@tachyon.chronox.de> <7336837.Ud0PiFKhfA@tachyon.chronox.de> <55B01375.3040007@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: herbert@gondor.apana.org.au, linux-crypto@vger.kernel.org
To: Tadeusz Struk <tadeusz.struk@intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:47998 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751154AbbGVWaA (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Wed, 22 Jul 2015 18:30:00 -0400
In-Reply-To: <55B01375.3040007@intel.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Mittwoch, 22. Juli 2015, 15:04:37 schrieb Tadeusz Struk:

Hi Tadeusz,

> On 07/22/2015 11:55 AM, Stephan Mueller wrote:
> > I concur with you. But we have only two options:
> > 
> > - either use SGLs which the current akcipher API does not do
> > 
> > - or do a memcpy of the sendpage data into the internal buffer
> 
> I would memcpy it here. Both the current software and QAT implementations
> do not support SGL so we'll end up memcpy it anyway.
> 
> > As the sendpage already has a speed penalty, I did not like the latter
> > one.
> > Based on my measurements for AEAD, Hash and skicpher, sendpage starts to
> > become faster than sendmsg with input buffers > 8 to 16 kBytes (sendpage
> > as at least 4 syscalls where sendmsg uses only two).
> > 
> > As our current akcipher API does not reach the mentioned limit, I opted to
> > require one sendpage call.
> > 
> > But if we change the akcipher API to SGLs, I will lift that limit.
> 
> As you said - the preferred way of invoking this would be sendmsg with data
> instead of splice. This is only to make splice happy in case the data is
> not in a contiguous buffer.

Good point.

I am waiting for Herbert for the decision on changing the akcipher to SGL. 
Based on that decision I either implement your suggestion (if we leave linear 
buffers) or I will go with preparing the SGL setup.

-- 
Ciao
Stephan
