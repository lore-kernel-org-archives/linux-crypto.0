From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 5/5] camellia: de-unrolling, 64bit-ization
Date: Thu, 8 Nov 2007 21:30:20 +0800
Message-ID: <20071108133019.GD17186@gondor.apana.org.au>
References: <200710251243.58701.vda.linux@googlemail.com> <200710251248.29746.vda.linux@googlemail.com> <20071106142314.GE24423@gondor.apana.org.au> <200711071322.52630.vda.linux@googlemail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org,
	Noriaki TAKAMIYA <takamiya@po.ntts.co.jp>
To: Denys Vlasenko <vda.linux@googlemail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:3505 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754025AbXKHNa2 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 8 Nov 2007 08:30:28 -0500
Content-Disposition: inline
In-Reply-To: <200711071322.52630.vda.linux@googlemail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Wed, Nov 07, 2007 at 01:22:52PM +0000, Denys Vlasenko wrote:
>
> *I* am happy with 5% speed sacrifice. I'm afraid other people won't be.

I'd like to hear the opinion of the author.

Takamiya-san, what do you think about this change?

Thanks,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
