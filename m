From: Tadeusz Struk <tadeusz.struk@intel.com>
Subject: Re: [PATCH 2/3] crypto: algif_akcipher user space interface
Date: Wed, 22 Jul 2015 15:04:37 -0700
Message-ID: <55B01375.3040007@intel.com>
References: <3908391.JkjAozYBaW@tachyon.chronox.de> <1537904.OY6iC43nQX@tachyon.chronox.de> <55AFBE4B.8080805@intel.com> <7336837.Ud0PiFKhfA@tachyon.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Cc: herbert@gondor.apana.org.au, linux-crypto@vger.kernel.org
To: Stephan Mueller <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga14.intel.com ([192.55.52.115]:64531 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753496AbbGVWFN (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Wed, 22 Jul 2015 18:05:13 -0400
In-Reply-To: <7336837.Ud0PiFKhfA@tachyon.chronox.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 07/22/2015 11:55 AM, Stephan Mueller wrote:
> I concur with you. But we have only two options:
> 
> - either use SGLs which the current akcipher API does not do
> 
> - or do a memcpy of the sendpage data into the internal buffer

I would memcpy it here. Both the current software and QAT implementations 
do not support SGL so we'll end up memcpy it anyway.
 
> 
> As the sendpage already has a speed penalty, I did not like the latter one. 
> Based on my measurements for AEAD, Hash and skicpher, sendpage starts to 
> become faster than sendmsg with input buffers > 8 to 16 kBytes (sendpage as at 
> least 4 syscalls where sendmsg uses only two).
> 
> As our current akcipher API does not reach the mentioned limit, I opted to 
> require one sendpage call.
> 
> But if we change the akcipher API to SGLs, I will lift that limit.

As you said - the preferred way of invoking this would be sendmsg with data instead
of splice. This is only to make splice happy in case the data is not in a contiguous
buffer.
Thanks,
T
