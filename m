From: Stephan Mueller <smueller@chronox.de>
Subject: Re: [PATCH 5/8] lib/scatterlist: Add sg_len helper
Date: Wed, 09 Sep 2015 18:49:42 +0200
Message-ID: <10154642.J7V5DfJoyx@tauon.atsec.com>
References: <20150909161454.2828.70445.stgit@tstruk-mobl1> <1973388.rNzrp31mTc@tauon.atsec.com> <55F0626C.3050306@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: herbert@gondor.apana.org.au, linux-crypto@vger.kernel.org,
	qat-linux@intel.com
To: Tadeusz Struk <tadeusz.struk@intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:33830 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753581AbbIIQtr (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Wed, 9 Sep 2015 12:49:47 -0400
In-Reply-To: <55F0626C.3050306@intel.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Mittwoch, 9. September 2015, 09:46:36 schrieb Tadeusz Struk:

Hi Tadeusz,

>On 09/09/2015 09:39 AM, Stephan Mueller wrote:
>>> No, because it can return -EINVAL if you call it before you set the key.
>> 
>> I see.
>> 
>> But, shouldn't there be an overflow check? Maybe not here, but in the cases
>> where the function is invoked. There is a kmalloc(src_len) without a check
>> for negative values.
>
>Right, but because testmgr.c calls setkey before this I skipped the check.

But in the rsa.c enc/dec/verify/sign functions, there should be such check, I 
would guess.


Ciao
Stephan
