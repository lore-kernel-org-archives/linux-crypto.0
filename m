From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH -stable] crypto: ccm - deal with CTR ciphers that honour
 iv_out
Date: Thu, 2 Feb 2017 17:53:52 +0800
Message-ID: <20170202095352.GA4818@gondor.apana.org.au>
References: <1485636005-5192-1-git-send-email-ard.biesheuvel@linaro.org>
 <CAKv+Gu9Em15JVQOo9civMMWOtwBR0R_a+K0P1Y-JOZJU5zPtnw@mail.gmail.com>
 <20170202051300.GA4349@gondor.apana.org.au>
 <CAKv+Gu-fUAofB+_Td=bq=m2KsMoc7V3N+NffW5GTuo4fdCwRTw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:53181 "EHLO
        helcar.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751019AbdBBJyG (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 2 Feb 2017 04:54:06 -0500
Content-Disposition: inline
In-Reply-To: <CAKv+Gu-fUAofB+_Td=bq=m2KsMoc7V3N+NffW5GTuo4fdCwRTw@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, Feb 02, 2017 at 08:01:47AM +0000, Ard Biesheuvel wrote:
>
> You are right: due to its construction, the CCM mode does not care
> about the incremented counter because it clears the counter part of
> the IV before encrypting the MAC. So this is caused by an optimization
> in my code rather than the CCM code being incorrect.

OK so you will send me an update for the ARM64 code, right?

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
