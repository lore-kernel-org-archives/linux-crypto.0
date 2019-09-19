Return-Path: <SRS0=4UkV=XO=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4DCFFC49ED7
	for <linux-crypto@archiver.kernel.org>; Thu, 19 Sep 2019 13:45:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2F57B21D79
	for <linux-crypto@archiver.kernel.org>; Thu, 19 Sep 2019 13:45:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389340AbfISNpT (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 19 Sep 2019 09:45:19 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:34376 "EHLO fornost.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387417AbfISNpT (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 19 Sep 2019 09:45:19 -0400
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.0.7])
        by fornost.hmeau.com with smtp (Exim 4.89 #2 (Debian))
        id 1iAwkG-0008DZ-6e; Thu, 19 Sep 2019 23:45:17 +1000
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Thu, 19 Sep 2019 23:45:13 +1000
Date:   Thu, 19 Sep 2019 23:45:13 +1000
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Horia Geanta <horia.geanta@nxp.com>
Cc:     Andrey Smirnov <andrew.smirnov@gmail.com>,
        Leonard Crestez <leonard.crestez@nxp.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        Chris Healy <cphealy@gmail.com>,
        Lucas Stach <l.stach@pengutronix.de>,
        Iuliana Prodan <iuliana.prodan@nxp.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Abel Vesa <abel.vesa@nxp.com>
Subject: Re: [PATCH 12/12] crypto: caam - change JR device ownership scheme
Message-ID: <20190919134512.GA29320@gondor.apana.org.au>
References: <20190904023515.7107-1-andrew.smirnov@gmail.com>
 <20190904023515.7107-13-andrew.smirnov@gmail.com>
 <VI1PR04MB7023A7EC91599A537CB6A487EEB30@VI1PR04MB7023.eurprd04.prod.outlook.com>
 <CAHQ1cqEkdUJGxUnRQbJSG9L32yC0HVmddzi4GyOkVfq2uvJOMQ@mail.gmail.com>
 <VI1PR0402MB3485F8B3E4F73EB62A70DBDF98890@VI1PR0402MB3485.eurprd04.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <VI1PR0402MB3485F8B3E4F73EB62A70DBDF98890@VI1PR0402MB3485.eurprd04.prod.outlook.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, Sep 19, 2019 at 11:19:22AM +0000, Horia Geanta wrote:
>
> What should a driver do when:
> -user tries to unbind it AND
> -there are tfms referencing algorithms registered by this driver
> 
> 1. If driver tries to unregister the algorithms during its .remove()
> callback, then this BUG_ON is hit:
> 
> int crypto_unregister_alg(struct crypto_alg *alg)
> {
> [...]
>         BUG_ON(refcount_read(&alg->cra_refcnt) != 1);

You must not unregister the algorithm until it's no longer in use.
Normally we enforce this using module reference counts.

For hardware devices that need to be unregistered without unloading
the module at the same time, you will need your own reference
counting to determine when unregistration can be carried out.  But
it must be carefully done so that it is not racy.

> 2. If driver exits without unregistering the algorithms,
> next time one of the tfms referencing those algorithms will be used
> bad things will happen.

Well remember hardware devices can always go away (e.g., dead
or unplugged) so the driver must do something sensible when that
happens.  If this happened on a live tfm then further operations
should ideally fail and any outstanding requests should also fail
in a timely manner.

> 3. There is no mechanism in crypto core for notifying users
> to stop using a tfm.

For software implementations we use the module reference count
as the mechanism to signal that an algorithm is going away.  In
particular try_module_get (and consequently crypto_mod_get) will
fail when the module is being unregistered.

We should extend this to cover hardware devices.  Perhaps we can
introduce a callback in crypto_alg that crypto_mod_get can invoke
which would then fail if the device is going away (or has gone away).

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
