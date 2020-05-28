Return-Path: <SRS0=ep2G=7K=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A654BC433E0
	for <linux-crypto@archiver.kernel.org>; Thu, 28 May 2020 06:56:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 80F7A208E4
	for <linux-crypto@archiver.kernel.org>; Thu, 28 May 2020 06:56:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725939AbgE1G46 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 28 May 2020 02:56:58 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:34948 "EHLO fornost.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725308AbgE1G45 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 28 May 2020 02:56:57 -0400
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.0.7])
        by fornost.hmeau.com with smtp (Exim 4.92 #5 (Debian))
        id 1jeCRj-0008Jc-Vh; Thu, 28 May 2020 16:55:21 +1000
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Thu, 28 May 2020 16:55:19 +1000
Date:   Thu, 28 May 2020 16:55:19 +1000
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     "stern@rowland.harvard.edu" <stern@rowland.harvard.edu>
Cc:     "Sverdlin, Alexander (Nokia - DE/Ulm)" <alexander.sverdlin@nokia.com>,
        "dinghao.liu@zju.edu.cn" <dinghao.liu@zju.edu.cn>,
        "kjlu@umn.edu" <kjlu@umn.edu>, "mpm@selenic.com" <mpm@selenic.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "ben.dooks@codethink.co.uk" <ben.dooks@codethink.co.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "arnd@arndb.de" <arnd@arndb.de>,
        "allison@lohutok.net" <allison@lohutok.net>,
        "yuehaibing@huawei.com" <yuehaibing@huawei.com>,
        "rfontana@redhat.com" <rfontana@redhat.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: Re: [PATCH] hwrng: ks-sa - fix runtime pm imbalance on error
Message-ID: <20200528065519.GA26960@gondor.apana.org.au>
References: <20200520132957.18776-1-dinghao.liu@zju.edu.cn>
 <ab400cba7523e69b15360b0928cb8fa8b9432d86.camel@nokia.com>
 <20200520164556.GC11084@rowland.harvard.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200520164556.GC11084@rowland.harvard.edu>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, May 20, 2020 at 12:45:56PM -0400, stern@rowland.harvard.edu wrote:
> On Wed, May 20, 2020 at 03:42:17PM +0000, Sverdlin, Alexander (Nokia - DE/Ulm) wrote:
> > Hello Dinghao,
> > 
> > On Wed, 2020-05-20 at 21:29 +0800, Dinghao Liu wrote:
> > > pm_runtime_get_sync() increments the runtime PM usage counter even
> > > the call returns an error code. Thus a pairing decrement is needed
> > > on the error handling path to keep the counter balanced.
> > 
> > I believe, this is the wrong place for such kind of fix.
> > pm_runtime_get_sync() has obviously a broken semantics with regards to
> > your observation but no other driver does what you propose.
> 
> Look again.  For example, see what usb_autoresume_device() in 
> drivers/usb/core/driver.c does.

However, there seems to be some disagreement as to what to do
when pm_runtime_get_sync fails.  Your driver chooses to call
put_sync while others prefer pm_runtime_put_noidle (e.g., see
drivers/base/power/runtime.c).

This API does seem to be in a bit of a mess.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
