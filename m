From: Stephan Mueller <smueller@chronox.de>
Subject: Re: [PATCH] crypto: user - re-add size check for CRYPTO_MSG_GETALG
Date: Thu, 23 Jun 2016 16:46:26 +0200
Message-ID: <2228963.xKdNI3on4m@tauon.atsec.com>
References: <1466620177-10998-1-git-send-email-minipli@googlemail.com> <20160623104357.GA10350@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: Mathias Krause <minipli@googlemail.com>,
	"David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org,
	Steffen Klassert <steffen.klassert@secunet.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:38072 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750874AbcFWOqd (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Thu, 23 Jun 2016 10:46:33 -0400
In-Reply-To: <20160623104357.GA10350@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Donnerstag, 23. Juni 2016, 18:43:57 schrieb Herbert Xu:

Hi Herbert,

> On Wed, Jun 22, 2016 at 08:29:37PM +0200, Mathias Krause wrote:
> > Commit 9aa867e46565 ("crypto: user - Add CRYPTO_MSG_DELRNG")
> > accidentally removed the minimum size check for CRYPTO_MSG_GETALG
> > netlink messages. This allows userland to send a truncated
> > CRYPTO_MSG_GETALG message as short as a netlink header only making
> > crypto_report() operate on uninitialized memory by accessing data
> > beyond the end of the netlink message.
> > 
> > Fix this be re-adding the minimum required size of CRYPTO_MSG_GETALG
> > messages to the crypto_msg_min[] array.
> > 
> > Fixes: 9aa867e46565 ("crypto: user - Add CRYPTO_MSG_DELRNG")
> > Cc: stable@vger.kernel.org	# v4.2
> > Signed-off-by: Mathias Krause <minipli@googlemail.com>
> > Cc: Steffen Klassert <steffen.klassert@secunet.com>
> > ---
> > This should go on top of crypto-2.6/master.
> 
> Patch applied to crypto.  Thanks!

Please revert my patch eed1e1afd8d542d9644534c1b712599b5d680007 as requested 
by Matthias.


Ciao
Stephan
