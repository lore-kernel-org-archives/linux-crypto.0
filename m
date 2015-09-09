From: Tadeusz Struk <tadeusz.struk@intel.com>
Subject: Re: [PATCH 5/8] lib/scatterlist: Add sg_len helper
Date: Wed, 9 Sep 2015 10:02:17 -0700
Message-ID: <55F06619.6040002@intel.com>
References: <20150909161454.2828.70445.stgit@tstruk-mobl1>
 <10154642.J7V5DfJoyx@tauon.atsec.com> <55F0639C.5070806@intel.com>
 <2341612.XlxYCr8Bse@tauon.atsec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Cc: herbert@gondor.apana.org.au, linux-crypto@vger.kernel.org,
	qat-linux@intel.com
To: Stephan Mueller <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:63899 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751957AbbIIRE4 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Wed, 9 Sep 2015 13:04:56 -0400
In-Reply-To: <2341612.XlxYCr8Bse@tauon.atsec.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 09/09/2015 09:56 AM, Stephan Mueller wrote:
>>> But in the rsa.c enc/dec/verify/sign functions, there should be such check,
>>> >> I would guess.
>> >
>> >There is see line 419:
>> >return pkey->n ? mpi_get_size(pkey->n) : -EINVAL;
> I feel we are not talking about the same issue. I refer to your patch in 
> rsa.c:
> 
> +       int src_len = sg_len(req->src), dst_len = sg_len(req->dst);
> 
> ===> can be negative according to your statement
> 
> ...
> 
> +               void *ptr = kmalloc(dst_len, GFP_KERNEL);
> 
> ===> with a negative number, I guess we have a problem here.

Yes, sorry, you are right. sg_len() will only return positive numbers or zero.
rsa.c checks it in all four operations:
if (unlikely(!pkey->n || !pkey->d || !src_len)) 
