From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: s390 - fix des and des3_ede ctr concurrency issue
Date: Thu, 30 Jan 2014 22:10:36 +0800
Message-ID: <20140130141036.GA30437@gondor.apana.org.au>
References: <1390392093-5002-1-git-send-email-freude@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org,
	Martin Schwidefsky <schwidefsky@de.ibm.com>,
	Ingo Tuchscherer <ingo.tuchscherer@linux.vnet.ibm.com>,
	Gerald Schaefer <gerald.schaefer@de.ibm.com>,
	Harald Freudenberger <freude@de.ibm.com>
To: Harald Freudenberger <freude@linux.vnet.ibm.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from ringil.hengli.com.au ([178.18.16.133]:54993 "EHLO
	ringil.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753729AbaA3OKr (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 30 Jan 2014 09:10:47 -0500
Content-Disposition: inline
In-Reply-To: <1390392093-5002-1-git-send-email-freude@linux.vnet.ibm.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Jan 22, 2014 at 01:01:33PM +0100, Harald Freudenberger wrote:
> In s390 des and 3des ctr mode there is one preallocated page
> used to speed up the en/decryption. This page is not protected
> against concurrent usage and thus there is a potential of data
> corruption with multiple threads.
> 
> The fix introduces locking/unlocking the ctr page and a slower
> fallback solution at concurrency situations.
> 
> Cc: stable@vger.kernel.org
> Signed-off-by: Harald Freudenberger <freude@linux.vnet.ibm.com>

All three patches applied to crypto.  Thanks for fixing these
bugs.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
