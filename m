From: Stephan Mueller <smueller@chronox.de>
Subject: Re: [PATCH 4/8] crypto: akcipher - Changes to asymmetric key API
Date: Wed, 09 Sep 2015 21:13:39 +0200
Message-ID: <5958957.yk1vCkpBem@tauon.atsec.com>
References: <20150909161454.2828.70445.stgit@tstruk-mobl1> <12219786.VJTHR804Rs@tauon.atsec.com> <CAOq732KAFJdrb=CV3K2k9yd4Wo5dAUWMCmzyvva+xvT-n8Z46g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: Tadeusz Struk <tadeusz.struk@intel.com>,
	herbert@gondor.apana.org.au, linux-crypto@vger.kernel.org,
	qat-linux@intel.com
To: Andrzej Zaborowski <andrew.zaborowski@intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:33845 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751783AbbIITNo (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Wed, 9 Sep 2015 15:13:44 -0400
In-Reply-To: <CAOq732KAFJdrb=CV3K2k9yd4Wo5dAUWMCmzyvva+xvT-n8Z46g@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Mittwoch, 9. September 2015, 20:53:23 schrieb Andrzej Zaborowski:

Hi Andrzej,
>
>Also a question regarding .get_len: for RSA with padding the minimum
>dest buffer length depends on the input.  What is that call supposed
>to return in that case?

I would guess that the destination buffer minimum size should be RSA size 
minus the minimum padding size. This way, the caller is always sure to get all 
data without error.

Ciao
Stephan
