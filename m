From: Marcel Holtmann <marcel@holtmann.org>
Subject: Re: [RFC PATCH] crypto: RSA padding transform
Date: Fri, 30 Oct 2015 17:35:46 +0900
Message-ID: <E8E1521C-0D05-402E-B1C0-E204ED5BF28C@holtmann.org>
References: <1441494029-6765-1-git-send-email-andrew.zaborowski@intel.com> <CAOq732JmhBh7kqDH1mMhUz1MXz9zJSx1jaqdBMjgDVvtraSrrQ@mail.gmail.com> <55ED9FDC.60602@intel.com> <1807044.IVByMVeBDE@tauon.atsec.com> <CAOq732LoTvUzDTM7vRHU3QCHeuL0vD4Bh24kqB0R8i0yCQdsJw@mail.gmail.com>
Mime-Version: 1.0 (Mac OS X Mail 9.1 \(3096.5\))
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: Stephan Mueller <smueller@chronox.de>,
	Tadeusz Struk <tadeusz.struk@intel.com>,
	linux-crypto@vger.kernel.org
To: Andrzej Zaborowski <andrew.zaborowski@intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from senator.holtmann.net ([87.106.208.187]:58432 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932637AbbJ3Ifv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 30 Oct 2015 04:35:51 -0400
In-Reply-To: <CAOq732LoTvUzDTM7vRHU3QCHeuL0vD4Bh24kqB0R8i0yCQdsJw@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Andrzej,

>>> I can see now that with all these padding schemes there will be more buffer
>>> copied on top of this, so I wonder if it still make sense.
>>> Herbert?
>> 
>> When the padding stuff comes into play, I think the SGL approach avoids
>> memcpy() invocations.
>> 
>> For example, Andrzej's approach currently is to copy the *entire* source data
>> into a buffer where the padding is added.
>> 
>> With SGLs, Andrzej only needs a buffer with the padding (which I would think
>> could even reside on the stack, provided some bounds checks are done), and
>> modify the SGL by preprending the padding buffer to the SGL with the source
>> data.
> 
> Yes, in the case of the padding schemes, using sgl's would actually
> save a memcpy both on encrypt/sign and decrypt/verify.  Whether it'd
> actually help I'm not sure -- the number of pointers you need to
> touch, etc. may add up to around 128/256 bytes of memory access
> anyway.

I think we have akcipher patches using sgl now. Would it make sense to update this patch against them.

Regards

Marcel
