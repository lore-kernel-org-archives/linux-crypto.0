From: Stephan Mueller <smueller@chronox.de>
Subject: Re: [PATCH 9/14] crypto: tcrypt - Add support for new IV convention
Date: Thu, 09 Jul 2015 09:59:01 +0200
Message-ID: <2007103.oHXJK7Kc2I@tauon.atsec.com>
References: <20150708231330.GA28797@gondor.apana.org.au> <E1ZCyak-0007Zf-No@gondolin.me.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:47936 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752056AbbGIH7H (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Thu, 9 Jul 2015 03:59:07 -0400
In-Reply-To: <E1ZCyak-0007Zf-No@gondolin.me.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Donnerstag, 9. Juli 2015, 07:17:26 schrieb Herbert Xu:

Hi Herbert,

>This patch allows the AEAD speed tests to cope with the new seqiv
>calling convention as well as the old one.
>
>Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

Using your crypto-2.6 tree, this patch fails to apply (and others have hunks 
e.g. patch 8).

Ciao
Stephan
