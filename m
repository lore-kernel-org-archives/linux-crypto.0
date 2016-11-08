From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: gf128mul - remove dead gf128mul_64k_lle code
Date: Tue, 8 Nov 2016 20:04:40 +0800
Message-ID: <20161108120440.GA5222@gondor.apana.org.au>
References: <CA+cSK10Q4aLK+uXtRwWuUR4_vuZZWaVadPpofNpWf9G=QkGSyg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: Alex Cope <alexcope@google.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:38956 "EHLO
        helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752894AbcKHMEu (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 8 Nov 2016 07:04:50 -0500
Content-Disposition: inline
In-Reply-To: <CA+cSK10Q4aLK+uXtRwWuUR4_vuZZWaVadPpofNpWf9G=QkGSyg@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Alex Cope <alexcope@google.com> wrote:
> This code is unlikely to be useful in the future because transforms
> don't know how often keys will be changed, new algorithms are unlikely
> to use lle representation, and tables should be replaced with
> carryless multiplication instructions when available.
> 
> Signed-off-by: Alex Cope <alexcope@google.com>

Your patch doesn't apply.  Please fix it and resubmit.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
