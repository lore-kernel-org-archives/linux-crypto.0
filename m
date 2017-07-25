From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: FW: [PATCH V6 5/7] crypto: AES CBC multi-buffer glue code
Date: Tue, 25 Jul 2017 10:17:42 +0800
Message-ID: <20170725021742.GA4151@gondor.apana.org.au>
References: <1498609575-6217-1-git-send-email-megha.dey@linux.intel.com>
 <1498609575-6217-6-git-send-email-megha.dey@linux.intel.com>
 <20170718054142.GA4764@gondor.apana.org.au>
 <da15ba80-a3b1-0d79-47ea-5528c0d12b20@linux.intel.com>
 <1500427139.32379.0.camel@megha-Z97X-UD7-TH>
 <20170719070217.GA9374@gondor.apana.org.au>
 <C440BA31B54DCD4AAC682D2365C8FEE703DEC4CE@ORSMSX111.amr.corp.intel.com>
 <1500944996.3305.2.camel@megha-Z97X-UD7-TH>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: Megha Dey <megha.dey@linux.intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from orcrist.hmeau.com ([104.223.48.154]:39324 "EHLO
        deadmen.hmeau.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755392AbdGYCRv (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 24 Jul 2017 22:17:51 -0400
Content-Disposition: inline
In-Reply-To: <1500944996.3305.2.camel@megha-Z97X-UD7-TH>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, Jul 24, 2017 at 06:09:56PM -0700, Megha Dey wrote:
>
> Under the skcipher interface, if both the outer and inner alg are async,
> there should not be any problem right? Currently I do not see any
> existing algorithms have both algorithms async.

That's because the purpose of cryptd is to turn a sync algorithm
into an async one.

Your mcryptd is completely different.  We already went through
this discussion for sha1-mb.  This is no different.  You should
choose the type that fits your circumstances.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
