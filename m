From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] padata: allow caller to control queue length
Date: Tue, 18 Apr 2017 18:47:57 +0800
Message-ID: <20170418104757.GA640@gondor.apana.org.au>
References: <CAHmME9qDrq-ZvuE0weLFLKAz2qTyNtC53K4+Tc0JBCvBZ9O-5A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: steffen.klassert@secunet.com, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org
To: "Jason A. Donenfeld" <Jason@zx2c4.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from [198.176.57.175] ([198.176.57.175]:52492 "EHLO
        deadmen.hmeau.com" rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751164AbdDRKs6 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 18 Apr 2017 06:48:58 -0400
Content-Disposition: inline
In-Reply-To: <CAHmME9qDrq-ZvuE0weLFLKAz2qTyNtC53K4+Tc0JBCvBZ9O-5A@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Jason A. Donenfeld <Jason@zx2c4.com> wrote:
> On Fri, Apr 14, 2017 at 9:57 AM, Steffen Klassert
> <steffen.klassert@secunet.com> wrote:
>> Why do we need this? As long as we don't have a user that needs a
>> different limit, this patch adds just some useless code.
> 
> My [not-yet-mainlined] code wants it.

Well then you should submit this along with your code that uses
it.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
