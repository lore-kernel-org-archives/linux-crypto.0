From: Stephan Mueller <smueller@chronox.de>
Subject: Re: [PATCH 12/14] crypto: nx - Use new IV convention
Date: Thu, 09 Jul 2015 09:07:51 +0200
Message-ID: <1909056.vXiC6IPPsr@tauon.atsec.com>
References: <20150708231330.GA28797@gondor.apana.org.au> <2029636.zIROss5U0I@tauon.atsec.com> <20150709065615.GB32698@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
	"Leonidas S. Barbosa" <leosilva@linux.vnet.ibm.com>,
	Fionnuala Gunter <fin@linux.vnet.ibm.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:47932 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752594AbbGIHH6 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Thu, 9 Jul 2015 03:07:58 -0400
In-Reply-To: <20150709065615.GB32698@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Donnerstag, 9. Juli 2015, 14:56:15 schrieb Herbert Xu:

Hi Herbert,

>On Thu, Jul 09, 2015 at 08:19:45AM +0200, Stephan Mueller wrote:
>> Am Donnerstag, 9. Juli 2015, 07:17:31 schrieb Herbert Xu:
>> 
>> Hi Herbert,
>> 
>> >This patch converts rfc4106 to the new calling convention where
>> >the IV is now part of the AD and needs to be skipped.  This patch
>> >also makes use of type-safe AEAD functions where possible.
>> >
>> >Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
>> 
>> This patch fails to apply on your current kernel tree.
>
>You need to pull in the crypto-2.6 tree to apply it.

Ok, will try. When is which tree used?
>
>Cheers,


Ciao
Stephan
