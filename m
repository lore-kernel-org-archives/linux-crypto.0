Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 20EA9ECAAA1
	for <linux-crypto@archiver.kernel.org>; Fri,  9 Sep 2022 09:08:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231159AbiIIJID (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 9 Sep 2022 05:08:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232035AbiIIJHt (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 9 Sep 2022 05:07:49 -0400
Received: from fornost.hmeau.com (helcar.hmeau.com [216.24.177.18])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 909DC5727F;
        Fri,  9 Sep 2022 02:07:45 -0700 (PDT)
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.103.7])
        by fornost.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1oWZzB-002oDK-H4; Fri, 09 Sep 2022 19:07:42 +1000
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Fri, 09 Sep 2022 17:07:41 +0800
Date:   Fri, 9 Sep 2022 17:07:41 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Ignat Korchagin <ignat@cloudflare.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-team@cloudflare.com
Subject: Re: [PATCH v2] crypto: akcipher - default implementation for setting
 a private key
Message-ID: <YxsCXdftDX2OPJ9r@gondor.apana.org.au>
References: <20220831183706.1600-1-ignat@cloudflare.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220831183706.1600-1-ignat@cloudflare.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, Aug 31, 2022 at 07:37:06PM +0100, Ignat Korchagin wrote:
> Changes from v1:
>   * removed the default implementation from set_pub_key: it is assumed that
>     an implementation must always have this callback defined as there are
>     no use case for an algorithm, which doesn't need a public key
> 
> Many akcipher implementations (like ECDSA) support only signature
> verifications, so they don't have all callbacks defined.
> 
> Commit 78a0324f4a53 ("crypto: akcipher - default implementations for
> request callbacks") introduced default callbacks for sign/verify
> operations, which just return an error code.
> 
> However, these are not enough, because before calling sign the caller would
> likely call set_priv_key first on the instantiated transform (as the
> in-kernel testmgr does). This function does not have a default stub, so the
> kernel crashes, when trying to set a private key on an akcipher, which
> doesn't support signature generation.
> 
> I've noticed this, when trying to add a KAT vector for ECDSA signature to
> the testmgr.
> 
> With this patch the testmgr returns an error in dmesg (as it should)
> instead of crashing the kernel NULL ptr dereference.
> 
> Fixes: 78a0324f4a53 ("crypto: akcipher - default implementations for request callbacks")
> Signed-off-by: Ignat Korchagin <ignat@cloudflare.com>
> ---
>  crypto/akcipher.c | 8 ++++++++
>  1 file changed, 8 insertions(+)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
