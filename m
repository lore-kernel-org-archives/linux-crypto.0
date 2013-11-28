From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: s390 - Fix aes-xts parameter corruption
Date: Thu, 28 Nov 2013 22:26:21 +0800
Message-ID: <20131128142621.GE32124@gondor.apana.org.au>
References: <1384877567-23593-1-git-send-email-gerald.schaefer@de.ibm.com>
 <20131122145756.387d7638@vbox-ubuntu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org,
	Martin Schwidefsky <schwidefsky@de.ibm.com>,
	Ingo Tuchscherer <ingo.tuchscherer@linux.vnet.ibm.com>,
	Harald Freudenberger <freude@linux.vnet.ibm.com>
To: Gerald Schaefer <gerald.schaefer@de.ibm.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from ringil.hengli.com.au ([178.18.16.133]:48447 "EHLO
	ringil.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751271Ab3K1O0X (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 28 Nov 2013 09:26:23 -0500
Content-Disposition: inline
In-Reply-To: <20131122145756.387d7638@vbox-ubuntu>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, Nov 22, 2013 at 02:57:56PM +0100, Gerald Schaefer wrote:
> On Tue, 19 Nov 2013 17:12:47 +0100
> Gerald Schaefer <gerald.schaefer@de.ibm.com> wrote:
> 
> > Some s390 crypto algorithms incorrectly use the crypto_tfm structure
> > to store private data. As the tfm can be shared among multiple
> > threads, this can result in data corruption.
> > 
> > This patch fixes aes-xts by moving the xts and pcc parameter blocks
> > from the tfm onto the stack (48 + 96 bytes).
> > 
> > Signed-off-by: Gerald Schaefer <gerald.schaefer@de.ibm.com>
> > ---
> >  arch/s390/crypto/aes_s390.c | 31 +++++++++++++++++--------------
> >  1 file changed, 17 insertions(+), 14 deletions(-)

Patch applied.

> Herbert, could you please add Cc: stable@vger.kernel.org to this?

Sure.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
