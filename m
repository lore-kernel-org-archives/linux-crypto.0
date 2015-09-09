From: Tadeusz Struk <tadeusz.struk@intel.com>
Subject: Re: [PATCH 4/8] crypto: akcipher - Changes to asymmetric key API
Date: Wed, 9 Sep 2015 12:35:43 -0700
Message-ID: <55F08A0F.9060302@intel.com>
References: <20150909161454.2828.70445.stgit@tstruk-mobl1>
 <12219786.VJTHR804Rs@tauon.atsec.com>
 <CAOq732KAFJdrb=CV3K2k9yd4Wo5dAUWMCmzyvva+xvT-n8Z46g@mail.gmail.com>
 <5958957.yk1vCkpBem@tauon.atsec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Cc: herbert@gondor.apana.org.au, linux-crypto@vger.kernel.org,
	qat-linux@intel.com
To: Stephan Mueller <smueller@chronox.de>,
	Andrzej Zaborowski <andrew.zaborowski@intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:32543 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751390AbbIIThh (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Wed, 9 Sep 2015 15:37:37 -0400
In-Reply-To: <5958957.yk1vCkpBem@tauon.atsec.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 09/09/2015 12:13 PM, Stephan Mueller wrote:
>> >Also a question regarding .get_len: for RSA with padding the minimum
>> >dest buffer length depends on the input.  What is that call supposed
>> >to return in that case?
> I would guess that the destination buffer minimum size should be RSA size 
> minus the minimum padding size. This way, the caller is always sure to get all 
> data without error.

I think it should always be the size of modulo.
