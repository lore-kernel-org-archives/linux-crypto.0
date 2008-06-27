From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: "deflate" crypto module questions
Date: Fri, 27 Jun 2008 09:19:25 +0800
Message-ID: <20080627011924.GA3245@gondor.apana.org.au>
References: <E1KBsxU-00084C-00@gondolin.me.apana.org.au> <Pine.LNX.4.64.0806261803070.15018@vixen.sonytel.be>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: jmorris@namei.org, linux-crypto@vger.kernel.org
To: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:33138 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750865AbYF0BTb (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 26 Jun 2008 21:19:31 -0400
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0806261803070.15018@vixen.sonytel.be>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, Jun 26, 2008 at 06:07:29PM +0200, Geert Uytterhoeven wrote:
>
> But it also means it's not so easy to avoid allocating the compression buffer
> if you need decompression only. Or am I missing something?

Well there are ways to solve this, e.g., by creating new interfaces
that are compression or decompression only.  What application do
you have in mind?

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
