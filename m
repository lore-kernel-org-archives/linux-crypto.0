From: Stephan Mueller <smueller@chronox.de>
Subject: Re: [PATCH 5/8] lib/scatterlist: Add sg_len helper
Date: Wed, 09 Sep 2015 19:05:53 +0200
Message-ID: <1630172.czPGaHEriB@tauon.atsec.com>
References: <20150909161454.2828.70445.stgit@tstruk-mobl1> <2341612.XlxYCr8Bse@tauon.atsec.com> <55F06619.6040002@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: herbert@gondor.apana.org.au, linux-crypto@vger.kernel.org,
	qat-linux@intel.com
To: Tadeusz Struk <tadeusz.struk@intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:33840 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751443AbbIIRGF (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Wed, 9 Sep 2015 13:06:05 -0400
In-Reply-To: <55F06619.6040002@intel.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Mittwoch, 9. September 2015, 10:02:17 schrieb Tadeusz Struk:

Hi Tadeusz,

>On 09/09/2015 09:56 AM, Stephan Mueller wrote:
>>>> But in the rsa.c enc/dec/verify/sign functions, there should be such
>>>> check,
>>>> 
>>>> >> I would guess.
>>> >
>>> >There is see line 419:
>>> >return pkey->n ? mpi_get_size(pkey->n) : -EINVAL;
>> 
>> I feel we are not talking about the same issue. I refer to your patch in
>> rsa.c:
>> 
>> +       int src_len = sg_len(req->src), dst_len = sg_len(req->dst);
>> 
>> ===> can be negative according to your statement
>> 
>> ...
>> 
>> +               void *ptr = kmalloc(dst_len, GFP_KERNEL);
>> 
>> ===> with a negative number, I guess we have a problem here.
>
>Yes, sorry, you are right. sg_len() will only return positive numbers or
>zero. rsa.c checks it in all four operations:
>if (unlikely(!pkey->n || !pkey->d || !src_len))

Great, I am not disputing the check for 0, I just want an unsigned int, 
because sg->length is unsigned int too. :-)


Ciao
Stephan
