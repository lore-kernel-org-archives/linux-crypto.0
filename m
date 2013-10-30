From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [RFC] Unaligned CTR mode tests in crypto/testmgr.h
Date: Wed, 30 Oct 2013 09:54:24 +0800
Message-ID: <20131030015424.GA1855@gondor.apana.org.au>
References: <52704EAB.5000308@ti.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: jussi.kivilinna@mbnet.fi, linux-crypto@vger.kernel.org
To: Joel Fernandes <joelf@ti.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from ringil.hengli.com.au ([178.18.16.133]:39561 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751470Ab3J3Bya (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 29 Oct 2013 21:54:30 -0400
Content-Disposition: inline
In-Reply-To: <52704EAB.5000308@ti.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Joel Fernandes <joelf@ti.com> wrote:
> Hi,
> 
> Some tests such as test 5 in AES CTR mode in crypto/testmgr.h have a unaligned
> input buffer size such as 499 which is not aligned to any > 0 power of 2.
> 
> Due to this, omap-aes driver, and I think atmel-aes too error out when
> encryption is requested for these buffers.
> 
> pr_err("request size is not exact amount of AES blocks\n") or a similar message.
> 
> Is this failure considered a bug? How do we fix it?

Set your alignmask correctly and the crypto API will align the
input buffer for you.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
