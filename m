From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: algif - Mark sgl end at the end of data
Date: Tue, 2 Dec 2014 22:33:30 +0800
Message-ID: <20141202143330.GA26049@gondor.apana.org.au>
References: <20141128184036.11421.36028.stgit@tstruk-mobl1>
 <20141201144026.GA18008@gondor.apana.org.au>
 <547C80F5.6000006@intel.com>
 <20141201150010.GA18277@gondor.apana.org.au>
 <547C8324.4000801@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, davem@davemloft.net
To: Tadeusz Struk <tadeusz.struk@intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.apana.org.au ([209.40.204.226]:36001 "EHLO
	helcar.apana.org.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751424AbaLBOdg (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 2 Dec 2014 09:33:36 -0500
Content-Disposition: inline
In-Reply-To: <547C8324.4000801@intel.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, Dec 01, 2014 at 07:03:00AM -0800, Tadeusz Struk wrote:
> 
> Ok, I can look at the data, but do you think the idea with marking the
> end of data in TX sgl is worthwhile or should I just forget about it.
> Another question is - is an sgl with lots of empty buffers a valid input
> from an algorithm implementation point of view?

I think marking the end is useful.  How about doing the marking
and unmarking whenever sgl->cur is updated?

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
