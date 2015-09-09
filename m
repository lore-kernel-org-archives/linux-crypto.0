From: Stephan Mueller <smueller@chronox.de>
Subject: Re: [PATCH 5/8] lib/scatterlist: Add sg_len helper
Date: Wed, 09 Sep 2015 18:56:31 +0200
Message-ID: <2341612.XlxYCr8Bse@tauon.atsec.com>
References: <20150909161454.2828.70445.stgit@tstruk-mobl1> <10154642.J7V5DfJoyx@tauon.atsec.com> <55F0639C.5070806@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: herbert@gondor.apana.org.au, linux-crypto@vger.kernel.org,
	qat-linux@intel.com
To: Tadeusz Struk <tadeusz.struk@intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:33836 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754560AbbIIQ4g (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Wed, 9 Sep 2015 12:56:36 -0400
In-Reply-To: <55F0639C.5070806@intel.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Mittwoch, 9. September 2015, 09:51:40 schrieb Tadeusz Struk:

Hi Tadeusz,

>On 09/09/2015 09:49 AM, Stephan Mueller wrote:
>>>> >> But, shouldn't there be an overflow check? Maybe not here, but in the
>>>> >> cases
>>>> >> where the function is invoked. There is a kmalloc(src_len) without a
>>>> >> check
>>>> >> for negative values.
>>> >
>>> >Right, but because testmgr.c calls setkey before this I skipped the
>>> >check.
>> 
>> But in the rsa.c enc/dec/verify/sign functions, there should be such check,
>> I would guess.
>
>There is see line 419:
>return pkey->n ? mpi_get_size(pkey->n) : -EINVAL;

I feel we are not talking about the same issue. I refer to your patch in 
rsa.c:

+       int src_len = sg_len(req->src), dst_len = sg_len(req->dst);

===> can be negative according to your statement

...

+               void *ptr = kmalloc(dst_len, GFP_KERNEL);

===> with a negative number, I guess we have a problem here.


Ciao
Stephan
