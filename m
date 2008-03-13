From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: small patch queue
Date: Thu, 13 Mar 2008 19:23:59 +0800
Message-ID: <20080313112359.GA8361@gondor.apana.org.au>
References: <1200700935-3844-1-git-send-email-sebastian@breakpoint.cc> <20080311133238.GA19847@gondor.apana.org.au> <20080312171813.GA7255@Chamillionaire.breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: Sebastian Siewior <linux-crypto@ml.breakpoint.cc>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:56916 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752318AbYCMLYD (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 13 Mar 2008 07:24:03 -0400
Content-Disposition: inline
In-Reply-To: <20080312171813.GA7255@Chamillionaire.breakpoint.cc>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Mar 12, 2008 at 06:18:13PM +0100, Sebastian Siewior wrote:
>
> Something like 1.7 MB/sec on dm-crypt if I remember correctly. It was
> faster than software.
> I thing there is no need for polling because the geode has an interrupt. 

OK then async is definitely the way to go.

Thanks,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
