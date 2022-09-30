Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1108EC4332F
	for <linux-crypto@archiver.kernel.org>; Fri, 30 Sep 2022 06:16:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230280AbiI3GQW (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 30 Sep 2022 02:16:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229975AbiI3GPv (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 30 Sep 2022 02:15:51 -0400
Received: from fornost.hmeau.com (helcar.hmeau.com [216.24.177.18])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41BD86CF78;
        Thu, 29 Sep 2022 23:15:50 -0700 (PDT)
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.103.7])
        by fornost.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1oe9JF-00A56G-OI; Fri, 30 Sep 2022 16:15:42 +1000
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Fri, 30 Sep 2022 14:15:41 +0800
Date:   Fri, 30 Sep 2022 14:15:41 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Dominik Brodowski <linux@dominikbrodowski.net>
Cc:     "Jason A. Donenfeld" <Jason@zx2c4.com>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] hw_random: core: start hwrng kthread also for
 untrusted sources
Message-ID: <YzaJjfhy4hq4U84l@gondor.apana.org.au>
References: <CAHmME9oVKzJtAaBmtrrUT1n2f0_41wu2VF295ONKV3WUotbYxw@mail.gmail.com>
 <20220920142159.2789273-1-Jason@zx2c4.com>
 <YyxqQwsnIab/eunL@owl.dominikbrodowski.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YyxqQwsnIab/eunL@owl.dominikbrodowski.net>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, Sep 22, 2022 at 03:59:31PM +0200, Dominik Brodowski wrote:
> Start the hwrng kthread even if the hwrng source has a quality setting
> of zero. Then, every crng reseed interval, one batch of data from this
> zero-quality hwrng source will be mixed into the CRNG pool.
> 
> This patch is based on the assumption that data from a hwrng source
> will not actively harm the CRNG state. Instead, many hwrng sources
> (such as TPM devices), even though they are assigend a quality level of
> zero, actually provide some entropy, which is good enough to mix into
> the CRNG pool every once in a while.
> 
> Cc: Herbert Xu <herbert@gondor.apana.org.au>
> Cc: Jason A. Donenfeld <Jason@zx2c4.com>
> Signed-off-by: Dominik Brodowski <linux@dominikbrodowski.net>
> ---
> Thanks to Jason for splitting my v1 into two parts, as per Herbert's
> request. In comparison to v2, I've updated (and shortened) the commit
> message.

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
