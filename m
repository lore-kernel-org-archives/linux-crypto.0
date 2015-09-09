From: Stephan Mueller <smueller@chronox.de>
Subject: Re: [PATCH 5/8] lib/scatterlist: Add sg_len helper
Date: Wed, 09 Sep 2015 19:37:20 +0200
Message-ID: <6136404.9S42barCz4@tauon.atsec.com>
References: <20150909161454.2828.70445.stgit@tstruk-mobl1> <1630172.czPGaHEriB@tauon.atsec.com> <55F06960.90302@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: herbert@gondor.apana.org.au, linux-crypto@vger.kernel.org,
	qat-linux@intel.com
To: Tadeusz Struk <tadeusz.struk@intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:33842 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750819AbbIIRhc (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Wed, 9 Sep 2015 13:37:32 -0400
In-Reply-To: <55F06960.90302@intel.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Mittwoch, 9. September 2015, 10:16:16 schrieb Tadeusz Struk:

Hi Tadeusz,

>On 09/09/2015 10:05 AM, Stephan Mueller wrote:
>>> Yes, sorry, you are right. sg_len() will only return positive numbers or
>>> 
>>> >zero. rsa.c checks it in all four operations:
>>> >if (unlikely(!pkey->n || !pkey->d || !src_len))
>> 
>> Great, I am not disputing the check for 0, I just want an unsigned int,
>> because sg->length is unsigned int too. :-)
>
>I see, maybe we can check for negative numbers in PF_ALG?

My request for turning the implementation of sg_len and the callers of it to 
use unsigned int is simply to avoid overflows of the counter.

Note, I usually am very zealous about using the correct data types, especially 
with integers. I have seen way to many security related bugs by overflowing a 
signed integer.

Surely, PF_ALG will ensure that user space will only provide buffers up to a 
max number (PAGE_SIZE * ALG_MAX_PAGES is the maximum user space can provide at 
all considering my current user space approach). So, we have at most 65536 
bytes from user space in one request. This boundary is to allow at most 
ALG_MAX_PAGES individual SGL members (i.e. at most ALG_MAX_PAGES individual 
calls to splice) but also tries to squeeze the data coming with sendmsg into 
one page. But, surely we can discuss these limits once I post algif_akcipher.

Considering that, I do not feel that the code we discuss here should have a 
check for the maximum size of the SGL.


Ciao
Stephan
