From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] s390/crypto: Fix incorrect ghash icv buffer handling.
Date: Fri, 22 May 2015 11:24:25 +0800
Message-ID: <20150522032425.GA30171@gondor.apana.org.au>
References: <1432195271-3036-1-git-send-email-freude@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org,
	Martin Schwidefsky <schwidefsky@de.ibm.com>,
	Ingo Tuchscherer <ingo.tuchscherer@linux.vnet.ibm.com>,
	Hendrik Brueckner <brueckner@de.ibm.com>,
	Gerald Schaefer <gerald.schaefer@de.ibm.com>,
	Harald Freudenberger <freude@de.ibm.com>,
	Gerald Schaefer <geraldsc@linux.vnet.ibm.com>
To: Harald Freudenberger <freude@linux.vnet.ibm.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:41606 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754656AbbEVDYb (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 21 May 2015 23:24:31 -0400
Content-Disposition: inline
In-Reply-To: <1432195271-3036-1-git-send-email-freude@linux.vnet.ibm.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, May 21, 2015 at 10:01:11AM +0200, Harald Freudenberger wrote:
> Multitheaded tests showed that the icv buffer in the current ghash
> implementation is not handled correctly. A move of this working ghash
> buffer value to the descriptor context fixed this. Code is tested and
> verified with an multithreaded application via af_alg interface.
> 
> Signed-off-by: Harald Freudenberger <freude@linux.vnet.ibm.com>
> Signed-off-by: Gerald Schaefer <geraldsc@linux.vnet.ibm.com>
> Reported-by: Herbert Xu <herbert@gondor.apana.org.au>

Nice work! Patch applied to crypto with stable cc.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
