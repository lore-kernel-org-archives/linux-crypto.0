From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: padlock - Add SHA-1/256 module for VIA Nano
Date: Tue, 22 Mar 2011 16:52:34 +0800
Message-ID: <20110322085233.GA23594@gondor.apana.org.au>
References: <C4F7CD9A92DBFF48AD8779355CD4D7890A02F3@exchsg04.s3graphics.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, davem@davemloft.net
To: BrillyWu@viatech.com.cn
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.apana.org.au ([209.40.204.226]:51816 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751597Ab1CVIwh (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 22 Mar 2011 04:52:37 -0400
Content-Disposition: inline
In-Reply-To: <C4F7CD9A92DBFF48AD8779355CD4D7890A02F3@exchsg04.s3graphics.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Mar 22, 2011 at 02:10:13PM +0800, BrillyWu@viatech.com.cn wrote:
> Add new SHA-1/256 module that never needs any fallback and just calls
> the
> PadLock hardware instruction supported from VIA Nano processors to
> implement
> the "update" and "final" function. 
> They are respectively named "sha1_alg_nano" and "sha256_alg_nano", and
> will
> be used on any VIA Nano processor or the later ones. On VIA C7 CPU, the
> "sha1_alg"
> and "sha256_alg" modules will still be used as before.
>  
> Signed-off-by: BrillyWu<brillywu@viatech.com.cn>
> Signed-off-by: KaryJin<karyjin@viatech.com.cn>

Very nice :) I'll apply the patch.

Thanks!
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
