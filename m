From: Stephan Mueller <smueller@chronox.de>
Subject: Re: [PATCH 2/2] crypto: kpp - Add DH software implementation
Date: Wed, 13 Apr 2016 11:23:27 +0200
Message-ID: <3007460.XDCGCz3pFQ@tauon.atsec.com>
References: <1460457556-3117-1-git-send-email-salvatore.benedetto@intel.com> <365125038.ZIqeO5uAXD@tauon.atsec.com> <309B30E91F5E2846B79BD9AA9711D0318E80ED@IRSMSX102.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
To: "Benedetto, Salvatore" <salvatore.benedetto@intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:34454 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932614AbcDMJXb (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Wed, 13 Apr 2016 05:23:31 -0400
In-Reply-To: <309B30E91F5E2846B79BD9AA9711D0318E80ED@IRSMSX102.ger.corp.intel.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Mittwoch, 13. April 2016, 09:07:38 schrieb Benedetto, Salvatore:

Hi Salvatore,
> 
> I don't see any particular benefit in replacing this check with a lower
> boundary check only. Values other than those listed are very unlikely.
> Anyway, if you feel so strong about it and other people think the same I'm
> OK with either check :-) Either case shouldn't harm.

The kernel is not supposed to policy user decisions. It is only there to 
perform operations. It is allowed to enforce policies to cover known 
weaknesses though (hence the check for the lower boundary).

So, if a user wants to use 2040 bit DH keys, what reason has the kernel to 
object?

Note, with the advancements of quantum computers is may be likely that we all 
want to use very large keys for asymmetric ciphers in the not too distant 
future.

Ciao
Stephan
