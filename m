From: Tadeusz Struk <tadeusz.struk@intel.com>
Subject: Re: [PATCH 5/8] lib/scatterlist: Add sg_len helper
Date: Wed, 9 Sep 2015 10:16:16 -0700
Message-ID: <55F06960.90302@intel.com>
References: <20150909161454.2828.70445.stgit@tstruk-mobl1>
 <2341612.XlxYCr8Bse@tauon.atsec.com> <55F06619.6040002@intel.com>
 <1630172.czPGaHEriB@tauon.atsec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Cc: herbert@gondor.apana.org.au, linux-crypto@vger.kernel.org,
	qat-linux@intel.com
To: Stephan Mueller <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:6411 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752102AbbIIRR7 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Wed, 9 Sep 2015 13:17:59 -0400
In-Reply-To: <1630172.czPGaHEriB@tauon.atsec.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 09/09/2015 10:05 AM, Stephan Mueller wrote:
>> Yes, sorry, you are right. sg_len() will only return positive numbers or
>> >zero. rsa.c checks it in all four operations:
>> >if (unlikely(!pkey->n || !pkey->d || !src_len))
> Great, I am not disputing the check for 0, I just want an unsigned int, 
> because sg->length is unsigned int too. :-)

I see, maybe we can check for negative numbers in PF_ALG?
