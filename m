From: Megha Dey <megha.dey@linux.intel.com>
Subject: Re: FW: [PATCH V6 5/7] crypto: AES CBC multi-buffer glue code
Date: Tue, 25 Jul 2017 19:13:29 -0700
Message-ID: <1501035209.2503.2.camel@megha-Z97X-UD7-TH>
References: <1498609575-6217-1-git-send-email-megha.dey@linux.intel.com>
         <1498609575-6217-6-git-send-email-megha.dey@linux.intel.com>
         <20170718054142.GA4764@gondor.apana.org.au>
         <da15ba80-a3b1-0d79-47ea-5528c0d12b20@linux.intel.com>
         <1500427139.32379.0.camel@megha-Z97X-UD7-TH>
         <20170719070217.GA9374@gondor.apana.org.au>
         <C440BA31B54DCD4AAC682D2365C8FEE703DEC4CE@ORSMSX111.amr.corp.intel.com>
         <1500944996.3305.2.camel@megha-Z97X-UD7-TH>
         <20170725021742.GA4151@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:17405 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751427AbdGZCBl (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 25 Jul 2017 22:01:41 -0400
In-Reply-To: <20170725021742.GA4151@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, 2017-07-25 at 10:17 +0800, Herbert Xu wrote:
> On Mon, Jul 24, 2017 at 06:09:56PM -0700, Megha Dey wrote:
> >
> > Under the skcipher interface, if both the outer and inner alg are async,
> > there should not be any problem right? Currently I do not see any
> > existing algorithms have both algorithms async.
> 
> That's because the purpose of cryptd is to turn a sync algorithm
> into an async one.
> 
> Your mcryptd is completely different.  We already went through
> this discussion for sha1-mb.  This is no different.  You should
> choose the type that fits your circumstances.

I have updated the inner algorithm to also be async in v7 patch series.
> 
> Cheers,
