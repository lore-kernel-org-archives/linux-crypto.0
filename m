From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: I have a Question about linux asynchronous crypto
Date: Fri, 6 Jan 2012 12:35:38 +1100
Message-ID: <20120106013537.GA6453@gondor.apana.org.au>
References: <alpine.LRH.2.02.1112311013340.31442@well.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: omarapazanadi@gmail.com, linux-crypto@vger.kernel.org
To: Mark Allyn <allyn@well.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.apana.org.au ([209.40.204.226]:47011 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755019Ab2AFBfo (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 5 Jan 2012 20:35:44 -0500
Content-Disposition: inline
In-Reply-To: <alpine.LRH.2.02.1112311013340.31442@well.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Mark Allyn <allyn@well.com> wrote:
> 
> As far as I can see, I agree. The generic implementations all seem to
> be synchronous.

We do have pcrypt which is a wrapper that turns any sync
implementation into an async one by spreading requests across
CPUs.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
