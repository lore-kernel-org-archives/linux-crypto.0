Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C0C9CC4338F
	for <linux-crypto@archiver.kernel.org>; Fri, 23 Jul 2021 16:20:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A864A60EB5
	for <linux-crypto@archiver.kernel.org>; Fri, 23 Jul 2021 16:20:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229698AbhGWPjy (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 23 Jul 2021 11:39:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:58146 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230190AbhGWPjx (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 23 Jul 2021 11:39:53 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E1BCE60E0C;
        Fri, 23 Jul 2021 16:20:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627057227;
        bh=BSKEbzYJ66nESAtFQf4aOIwr905oWBJvxJpIr0z1g3s=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=GVmllpAWocCrBtift0p+Xav1Nur5S1QohOppiS7Il6MoIUre++paxiWkznrF62hYn
         +wSEWuTuSGzJqjtZ56EPJQJIDZaNmFy+9Wq6/N9ggn7gdVUdzBSBUQs1iXXKT3u8wO
         HsPzGynBBgFcFw0kahkmTNiPeITH2JcJkeEdJN+3fYyksdsHhOXCia1nh11VCbWSSJ
         4ylfhErQrIcOBJ8jPQbu7Vit9VAvwz34LTHyO4u7p3F0R/AqlBVNwJFg3aS40VlGaL
         5+5YIBZ4Pefa9peotRTAoCgpO0nv5EZ4SODH++VDGe/vFN7TYhHX6ifufw42vBitw/
         zZ74xSs4vqApw==
Date:   Fri, 23 Jul 2021 09:20:25 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Thara Gopinath <thara.gopinath@linaro.org>
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        linux-crypto@vger.kernel.org
Subject: Re: Extending CRYPTO_ALG_OPTIONAL_KEY for cipher algorithms
Message-ID: <YPrsScKf/YlKmNfU@gmail.com>
References: <f04c8f1d-db85-c9e1-1717-4ca98b7c8c35@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f04c8f1d-db85-c9e1-1717-4ca98b7c8c35@linaro.org>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, Jul 23, 2021 at 06:13:50AM -0400, Thara Gopinath wrote:
> Hi
> 
> I have a requirement where the keys for the crypto cipher algorithms are
> already programmed in the h/w pipes/channels and thus the ->encrypt()
> and ->decrypt() can be called without set_key being called first.
> I see that CRYPTO_ALG_OPTIONAL_KEY has been added to take care of
> such requirements for CRC-32. My question is can the usage of this flag
> be extended for cipher and other crypto algorithms as well. Can setting of
> this flag indicate that the algorithm can be used without calling set_key
> first and then the individual drivers can handle cases where
> both h/w keys and s/w keys need to be supported.

CRYPTO_ALG_OPTIONAL_KEY isn't meant for this use case, but rather for algorithms
that have both keyed and unkeyed versions such as BLAKE2b and BLAKE2s, and also
for algorithms where the "key" isn't actually a key but rather is an initial
value that has a default value, such as CRC-32 and xxHash.

It appears that that the case you're asking about is handled by using a
different algorithm name, e.g. see the "paes" algorithms in
drivers/crypto/ccree/cc_cipher.c.

- Eric
