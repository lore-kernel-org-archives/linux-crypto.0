From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: Status of shash
Date: Tue, 12 Jan 2010 22:20:07 +1100
Message-ID: <20100112112007.GA31628@gondor.apana.org.au>
References: <1262106017.2726.27.camel@ec>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: Emanuele Cesena <emanuele.cesena@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:56340 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751317Ab0ALLUL (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 12 Jan 2010 06:20:11 -0500
Content-Disposition: inline
In-Reply-To: <1262106017.2726.27.camel@ec>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Emanuele Cesena <emanuele.cesena@gmail.com> wrote:
> 
> In fact I don't need async, while I'd like export/import functions.

If you are processing a large (i.e., > 1000 bytes) amount of data,
then you should use the async interface.  Otherwise the sync
interface should be good enough.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
