From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: padlock - Add SHA-1/256 module for VIA Nano
Date: Sun, 27 Mar 2011 10:46:14 +0800
Message-ID: <20110327024614.GA23197@gondor.apana.org.au>
References: <C4F7CD9A92DBFF48AD8779355CD4D7890A02F3@exchsg04.s3graphics.com> <20110322085233.GA23594@gondor.apana.org.au> <20110323132718.GA4567@gondor.apana.org.au> <C4F7CD9A92DBFF48AD8779355CD4D7890A047C@exchsg04.s3graphics.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, davem@davemloft.net
To: BrillyWu@viatech.com.cn
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.apana.org.au ([209.40.204.226]:45134 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752203Ab1C0CqU (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sat, 26 Mar 2011 22:46:20 -0400
Content-Disposition: inline
In-Reply-To: <C4F7CD9A92DBFF48AD8779355CD4D7890A047C@exchsg04.s3graphics.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, Mar 24, 2011 at 09:46:45AM +0800, BrillyWu@viatech.com.cn wrote:
> Thanks for your guide, it's just my mailer's malfunction. 
> I have made a test and it can work now. Please check it.
> 
> Add new SHA-1/256 module that never needs any fallback and just calls the
> PadLock hardware instruction supported from VIA Nano processors to implement
> the "update" and "final" function. 
> They are respectively named "sha1_alg_nano" and "sha256_alg_nano", and will
> be used on any VIA Nano processor or the later ones. On VIA C7 CPU, the "sha1_alg"
> and "sha256_alg" modules will still be used as before.
>  
> Signed-off-by: BrillyWu<brillywu@viatech.com.cn>
> Signed-off-by: KaryJin<karyjin@viatech.com.cn>

Patch applied.  Thanks!
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
