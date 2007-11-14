From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [camellia-oss:00952] Re: [PATCH 5/5] camellia: de-unrolling, 64bit-ization
Date: Wed, 14 Nov 2007 22:14:16 +0800
Message-ID: <20071114141416.GA15085@gondor.apana.org.au>
References: <200711131534.33521.vda.linux@googlemail.com> <20071113.194952.229187981.davem@davemloft.net> <200711132230.47844.vda.linux@googlemail.com> <200711140015.19887.vda.linux@googlemail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: David Miller <davem@davemloft.net>, takamiya@po.ntts.co.jp,
	linux-crypto@vger.kernel.org
To: Denys Vlasenko <vda.linux@googlemail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:2955 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754056AbXKNOOg (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 14 Nov 2007 09:14:36 -0500
Content-Disposition: inline
In-Reply-To: <200711140015.19887.vda.linux@googlemail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Wed, Nov 14, 2007 at 12:15:19AM -0700, Denys Vlasenko wrote:
>
>     Use alternative key setup implementation with mostly 64-bit ops
>     if BITS_PER_LONG >= 64. Both much smaller and much faster.

Can we please not have two versions of the same algorithm in C?
They're a pain to maintain and test.

Where performance is paramount you could look at doing an assembly
version.  Unlike two C versions at least that can be easily tested
by someone who has access to the platform in question.

Thanks,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
