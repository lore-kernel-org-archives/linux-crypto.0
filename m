Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C5AD4C4332F
	for <linux-crypto@archiver.kernel.org>; Mon,  6 Nov 2023 10:09:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229922AbjKFKJB (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 6 Nov 2023 05:09:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39206 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229974AbjKFKJB (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 6 Nov 2023 05:09:01 -0500
Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3266CFA;
        Mon,  6 Nov 2023 02:08:58 -0800 (PST)
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
        by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1qzwX7-00EXgv-7O; Mon, 06 Nov 2023 18:08:38 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Mon, 06 Nov 2023 18:08:44 +0800
Date:   Mon, 6 Nov 2023 18:08:44 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     "Gonglei (Arei)" <arei.gonglei@huawei.com>
Cc:     Halil Pasic <pasic@linux.ibm.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        Marc Hartmayer <mhartmay@linux.ibm.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "pizhenwei@bytedance.com" <pizhenwei@bytedance.com>,
        Cornelia Huck <cohuck@redhat.com>
Subject: Re: [PATCH] crypto: virtio-crypto: call finalize with bh disabled
Message-ID: <ZUi7LNhFFAumgRZ2@gondor.apana.org.au>
References: <1914739e2de14ed396e5674aa2d4766c@huawei.com>
 <20230926184158.4ca2c0c3.pasic@linux.ibm.com>
 <adb0c5f790dc408887f9d98548373919@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <adb0c5f790dc408887f9d98548373919@huawei.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, Nov 02, 2023 at 01:01:09PM +0000, Gonglei (Arei) wrote:
>
> > So I think the core of this question is: Can we call crypto_finalize_request() in
> > the upper half of the interrupt?

The finalize path originates from the network stack.  So the conditions
are the same as that of the network stack receive side.  That means
hard IRQ paths are unacceptable but softirq is OK.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
