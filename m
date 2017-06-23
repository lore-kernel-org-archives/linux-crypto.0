From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: encrypt_done called from interrupt context on rk3288 crypto
 driver
Date: Fri, 23 Jun 2017 16:37:17 +0800
Message-ID: <20170623083717.GA30234@gondor.apana.org.au>
References: <CAELSAVav4OQD1eTqtOey8_oZQPCBieO-HQQg1CaC23VmfD4KWQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Zain Wang <zain.wang@rock-chips.com>, linux-crypto@vger.kernel.org
To: Emil Karlson <jekarlson@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from orcrist.hmeau.com ([104.223.48.154]:35992 "EHLO
        deadmen.hmeau.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751231AbdFWIhi (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 23 Jun 2017 04:37:38 -0400
Content-Disposition: inline
In-Reply-To: <CAELSAVav4OQD1eTqtOey8_oZQPCBieO-HQQg1CaC23VmfD4KWQ@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, May 25, 2017 at 10:38:13PM +0300, Emil Karlson wrote:
> Greetings
> 
> It seems to me that rk3288 crypto driver calls encrypt_done from
> interrupt context which causes runtime tests to fail.

Zain, can you please take a look at this?

It is illegal to call the completion function from hardirq context.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
