From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 1/2] tcrypt: Added salsa20-generic speed test
Date: Fri, 7 Dec 2007 17:09:36 +0800
Message-ID: <20071207090936.GA8428@gondor.apana.org.au>
References: <fd3e431c0712051111j5f142292u831f803a53612d8f@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Linux Crypto <linux-crypto@vger.kernel.org>
To: Tan Swee Heng <thesweeheng@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:2538 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750986AbXLGJJj (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 7 Dec 2007 04:09:39 -0500
Content-Disposition: inline
In-Reply-To: <fd3e431c0712051111j5f142292u831f803a53612d8f@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, Dec 06, 2007 at 03:11:35AM +0800, Tan Swee Heng wrote:
> This patch adds a simple speed test for salsa20-generic.
> Usage: modprobe tcrypt mode=206
> 
> Signed-of-by: Tan Swee Heng <thesweeheng@gmail.com>

Applied to cryptodev.
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
