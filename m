From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: Question About Asymmetric Crypto
Date: Fri, 11 Dec 2009 14:31:59 +0800
Message-ID: <20091211063159.GA29051@gondor.apana.org.au>
References: <EC64E4604C8024438259B683BB2514E10780B3A772@SC-VEXCH1.marvell.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, dlv@marvell.com
To: Leo Yan <leoy@marvell.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:42871 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757305AbZLKGb4 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 11 Dec 2009 01:31:56 -0500
Content-Disposition: inline
In-Reply-To: <EC64E4604C8024438259B683BB2514E10780B3A772@SC-VEXCH1.marvell.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Leo Yan <leoy@marvell.com> wrote:
> 
> So question is: Does Linux CryptoAPI will be a general crypto engine accelerator framework for Linux platform, or just only dedicated for Linux Kernel?
> Like the thread has discussed, http://osdir.com/ml/linux.kernel.cryptoapi/2007/msg00307.html,
> Some guys think that nobody wants to use RSA in the kernel, but if Linux CryptoAPI wants support user space (As Herbert has mentioned it in the September's conference), then the scenario is changing.
> For example, if the browsers use the OpenSSL, and OpenSSL can call the Linux CryptoAPI to get the HW acceleration, and eventually optimize its performance.

I have nothing against having asymmetric crypto per se.  However,
until the user-space API exists there is no point in adding any
asymmetric infrastructure in the kernel as we have no in-kernel
users for them.

So please help in creating the user-space API first.

Thanks,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
