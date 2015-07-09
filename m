From: Stephan Mueller <smueller@chronox.de>
Subject: Re: [PATCH 12/14] crypto: nx - Use new IV convention
Date: Thu, 09 Jul 2015 08:19:45 +0200
Message-ID: <2029636.zIROss5U0I@tauon.atsec.com>
References: <20150708231330.GA28797@gondor.apana.org.au> <E1ZCyap-0007ag-GT@gondolin.me.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
	"Leonidas S. Barbosa" <leosilva@linux.vnet.ibm.com>,
	Fionnuala Gunter <fin@linux.vnet.ibm.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:47928 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750791AbbGIGTw (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Thu, 9 Jul 2015 02:19:52 -0400
In-Reply-To: <E1ZCyap-0007ag-GT@gondolin.me.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Donnerstag, 9. Juli 2015, 07:17:31 schrieb Herbert Xu:

Hi Herbert,

>This patch converts rfc4106 to the new calling convention where
>the IV is now part of the AD and needs to be skipped.  This patch
>also makes use of type-safe AEAD functions where possible.
>
>Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

This patch fails to apply on your current kernel tree.

Ciao
Stephan
