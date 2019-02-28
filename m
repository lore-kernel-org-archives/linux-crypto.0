Return-Path: <SRS0=8Gy4=RD=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED,USER_AGENT_NEOMUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9DFB4C43381
	for <linux-crypto@archiver.kernel.org>; Thu, 28 Feb 2019 06:38:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6D9BB218AE
	for <linux-crypto@archiver.kernel.org>; Thu, 28 Feb 2019 06:38:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725938AbfB1Gip (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 28 Feb 2019 01:38:45 -0500
Received: from orcrist.hmeau.com ([104.223.48.154]:40090 "EHLO
        deadmen.hmeau.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725862AbfB1Gip (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 28 Feb 2019 01:38:45 -0500
Received: from gondobar.mordor.me.apana.org.au ([192.168.128.4] helo=gondobar)
        by deadmen.hmeau.com with esmtps (Exim 4.89 #2 (Debian))
        id 1gzFL9-00060p-VN; Thu, 28 Feb 2019 14:38:44 +0800
Received: from herbert by gondobar with local (Exim 4.89)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1gzFL8-0001vr-Aq; Thu, 28 Feb 2019 14:38:42 +0800
Date:   Thu, 28 Feb 2019 14:38:42 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     linux-crypto@vger.kernel.org,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 0/2] crypto: arm64/chacha - fix for big endian
Message-ID: <20190228063842.mlrlklxzro4u4m4r@gondor.apana.org.au>
References: <20190223065408.6279-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190223065408.6279-1-ebiggers@kernel.org>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, Feb 22, 2019 at 10:54:06PM -0800, Eric Biggers wrote:
> I ran the crypto self-tests on big endian arm and arm64 kernels in QEMU.
> The arm64 implementation of ChaCha (and XChaCha) is failing, so this
> series fixes it.
> 
> Please consider sending to Linus for v5.0 if there's time, as this fixes
> commits that are new in v5.0.
> 
> Eric Biggers (2):
>   crypto: arm64/chacha - fix chacha_4block_xor_neon() for big endian
>   crypto: arm64/chacha - fix hchacha_block_neon() for big endian
> 
>  arch/arm64/crypto/chacha-neon-core.S | 20 ++++++++++++++++++--
>  1 file changed, 18 insertions(+), 2 deletions(-)

All applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
