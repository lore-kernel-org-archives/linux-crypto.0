From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH/RFC] crypto: compress - Return produced bytes in
	crypto_{,de}compress_{update,final}() (was: Re: [PATCH/RFC] crypto:
	compress - Add comp_request.total_out
Date: Tue, 21 Apr 2009 08:09:09 +0800
Message-ID: <20090421000909.GA11875@gondor.apana.org.au>
References: <1235569394-15217-6-git-send-email-Geert.Uytterhoeven@sonycom.com> <1235569394-15217-7-git-send-email-Geert.Uytterhoeven@sonycom.com> <20090307104637.GB8731@gondor.apana.org.au> <49B36A18.5030506@lougher.demon.co.uk> <alpine.LRH.2.00.0903111830540.1040@vixen.sonytel.be> <alpine.LRH.2.00.0903171345040.7595@vixen.sonytel.be> <alpine.LRH.2.00.0903241729540.4446@vixen.sonytel.be> <20090420060313.GA891@gondor.apana.org.au> <alpine.LRH.2.00.0904200925290.11211@vixen.sonytel.be> <49ED090F.4050503@lougher.demon.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: Phillip Lougher <phillip@lougher.demon.co.uk>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:34660 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751142AbZDUAJQ (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 20 Apr 2009 20:09:16 -0400
Content-Disposition: inline
In-Reply-To: <49ED090F.4050503@lougher.demon.co.uk>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Apr 21, 2009 at 12:45:19AM +0100, Phillip Lougher wrote:
>
> Herbert, are the other cryto API patches in linux-next (or any other
> git repository)?

They should be in Linus's tree.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
