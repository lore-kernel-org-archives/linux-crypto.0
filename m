From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 0/3] Fix crypto/vmx/p8_ghash memory corruption
Date: Mon, 10 Oct 2016 10:16:48 +0800
Message-ID: <20161010021648.GA32312@gondor.apana.org.au>
References: <1475080931-7926-1-git-send-email-marcelo.cerri@canonical.com>
 <20161003150725.GF10133@gallifrey>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: Marcelo Cerri <marcelo.cerri@canonical.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:56417 "EHLO
        helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751488AbcJJCQw (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 9 Oct 2016 22:16:52 -0400
Content-Disposition: inline
In-Reply-To: <20161003150725.GF10133@gallifrey>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, Oct 03, 2016 at 12:07:25PM -0300, Marcelo Cerri wrote:
> Hi Herbert,
> 
> Sorry for bothering you. I noticed you included two of the patches in
> the crypto-2.6 repository and the remaining one in cryptodev-2.6. Is
> that right? I thought all 3 patches would be included in the cruptodev
> repository.

I wanted the first two to go to stable as well so that's why
I split them up.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
