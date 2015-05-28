From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v1 3/3] crypto: ccp - Protect against poorly marked end
 of sg list
Date: Thu, 28 May 2015 08:36:12 +0800
Message-ID: <20150528003612.GA2739@gondor.apana.org.au>
References: <20150527094305.GA28142@gondor.apana.org.au>
 <5565D0B2.8070708@amd.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, davem@davemloft.net
To: Tom Lendacky <thomas.lendacky@amd.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:33025 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751395AbbE1AgR (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 27 May 2015 20:36:17 -0400
Content-Disposition: inline
In-Reply-To: <5565D0B2.8070708@amd.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, May 27, 2015 at 09:12:02AM -0500, Tom Lendacky wrote:
>
> >The reason I'm asking is because while this patch fixes your driver
> >everybody else will still crash and burn should something like this
> >happen again.
> 
> A number of other drivers already have similar sg-count functions in
> them.

Perhaps you can help abstract this into a helper that everybody can
call?

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
