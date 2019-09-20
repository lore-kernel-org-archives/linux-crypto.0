Return-Path: <SRS0=j/4y=XP=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3FFB3C49ED7
	for <linux-crypto@archiver.kernel.org>; Fri, 20 Sep 2019 13:03:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1873F208C3
	for <linux-crypto@archiver.kernel.org>; Fri, 20 Sep 2019 13:03:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727004AbfITNDd (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 20 Sep 2019 09:03:33 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:34610 "EHLO fornost.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726996AbfITNDd (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 20 Sep 2019 09:03:33 -0400
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.0.7])
        by fornost.hmeau.com with smtp (Exim 4.89 #2 (Debian))
        id 1iBIZF-0007tI-SV; Fri, 20 Sep 2019 23:03:22 +1000
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Fri, 20 Sep 2019 23:03:20 +1000
Date:   Fri, 20 Sep 2019 23:03:20 +1000
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Laurent Vivier <lvivier@redhat.com>
Cc:     linux-kernel@vger.kernel.org, Amit Shah <amit@kernel.org>,
        linux-crypto@vger.kernel.org, Matt Mackall <mpm@selenic.com>
Subject: Re: [PATCH] hw_random: don't wait on add_early_randomness()
Message-ID: <20190920130319.GA23697@gondor.apana.org.au>
References: <20190917095450.11625-1-lvivier@redhat.com>
 <20190917124018.GA32437@gondor.apana.org.au>
 <784e2129-0692-6e55-481d-4319cef9694c@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <784e2129-0692-6e55-481d-4319cef9694c@redhat.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, Sep 17, 2019 at 03:02:26PM +0200, Laurent Vivier wrote:
> On 17/09/2019 14:40, Herbert Xu wrote:
> > On Tue, Sep 17, 2019 at 11:54:50AM +0200, Laurent Vivier wrote:
> >> add_early_randomness() is called by hwrng_register() when the
> >> hardware is added. If this hardware and its module are present
> >> at boot, and if there is no data available the boot hangs until
> >> data are available and can't be interrupted.
> >>
> >> To avoid that, call rng_get_data() in non-blocking mode (wait=0)
> >> from add_early_randomness().
> >>
> >> Signed-off-by: Laurent Vivier <lvivier@redhat.com>
> >> ---
> >>  drivers/char/hw_random/core.c | 2 +-
> >>  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > Please provide more context in your patch description such as which
> > driver actually causes a hang here.
> 
> I can add in the next version:
> 
> "For instance, in the case of virtio-rng, in some cases the host can be
> not able to provide enough entropy for all the guests.
> 
> We can have two easy ways to reproduce the problem but they rely on
> misconfiguration of the hypervisor or the egd daemon:
> 
> - if virtio-rng device is configured to connect to the egd daemon of the
> host but when the virtio-rng driver asks for data the daemon is not
> connected,
> 
> - if virtio-rng device is configured to connect to the egd daemon of the
> host but the egd daemon doesn't provide data.
> 
> The guest kernel will hang at boot until the virtio-rng driver provides
> enough data."

Patch applied with this addition.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
