From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] hw_random: Make explicit that max >= 32 always
Date: Mon, 21 Nov 2016 22:55:42 +0800
Message-ID: <20161121145541.GB6730@gondor.apana.org.au>
References: <20161118173010.5448-1-prasannatsmkumar@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: mpm@selenic.com, daniel.thompson@linaro.org,
        linux-crypto@vger.kernel.org
To: PrasannaKumar Muralidharan <prasannatsmkumar@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:60818 "EHLO
        helcar.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1754079AbcKUOz4 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 21 Nov 2016 09:55:56 -0500
Content-Disposition: inline
In-Reply-To: <20161118173010.5448-1-prasannatsmkumar@gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, Nov 18, 2016 at 11:00:10PM +0530, PrasannaKumar Muralidharan wrote:
> As hw_random core calls ->read with max > 32 or more, make it explicit.
> Also remove checks involving 'max' being less than 8.
> 
> Signed-off-by: PrasannaKumar Muralidharan <prasannatsmkumar@gmail.com>

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
