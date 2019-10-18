Return-Path: <SRS0=BhDJ=YL=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0C19FCA9EA1
	for <linux-crypto@archiver.kernel.org>; Fri, 18 Oct 2019 08:05:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D5C492089C
	for <linux-crypto@archiver.kernel.org>; Fri, 18 Oct 2019 08:05:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2395411AbfJRIFQ (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 18 Oct 2019 04:05:16 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:37370 "EHLO fornost.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727888AbfJRIFQ (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 18 Oct 2019 04:05:16 -0400
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.0.7])
        by fornost.hmeau.com with smtp (Exim 4.89 #2 (Debian))
        id 1iLNG2-0001wy-NK; Fri, 18 Oct 2019 19:05:11 +1100
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Fri, 18 Oct 2019 19:05:10 +1100
Date:   Fri, 18 Oct 2019 19:05:10 +1100
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     linux-crypto@vger.kernel.org, sparclinux@vger.kernel.org,
        "David S . Miller" <davem@davemloft.net>
Subject: Re: [RFT PATCH 0/3] crypto: sparc - convert to skcipher API
Message-ID: <20191018080510.GJ25128@gondor.apana.org.au>
References: <20191012043850.340957-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191012043850.340957-1-ebiggers@kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, Oct 11, 2019 at 09:38:47PM -0700, Eric Biggers wrote:
> This series converts the glue code for the SPARC64 crypto opcodes
> implementations of AES, Camellia, DES, and 3DES modes from the
> deprecated "blkcipher" API to the "skcipher" API.  This is needed in
> order for the blkcipher API to be removed.
> 
> I've compiled this patchset, and the conversion is very similar to that
> which has been done for many other crypto drivers.  But I don't have the
> hardware to test it, nor are SPARC64 crypto opcodes supported by QEMU.
> So I really need someone with the hardware to test it.  You can do so by
> setting:
> 
> CONFIG_CRYPTO_AES_SPARC64=y
> CONFIG_CRYPTO_CAMELLIA_SPARC64=y
> CONFIG_CRYPTO_DES_SPARC64=y
> # CONFIG_CRYPTO_MANAGER_DISABLE_TESTS is not set
> CONFIG_DEBUG_KERNEL=y
> CONFIG_CRYPTO_MANAGER_EXTRA_TESTS=y
> CONFIG_CRYPTO_AES=y
> CONFIG_CRYPTO_CAMELLIA=y
> CONFIG_CRYPTO_DES=y
> CONFIG_CRYPTO_CBC=y
> CONFIG_CRYPTO_CTR=y
> CONFIG_CRYPTO_ECB=y
> 
> Then boot and check for crypto self-test failures by running
> 'dmesg | grep alg'.
> 
> If there are test failures, please also check whether they were already
> failing prior to this patchset.
> 
> Eric Biggers (3):
>   crypto: sparc/aes - convert to skcipher API
>   crypto: sparc/camellia - convert to skcipher API
>   crypto: sparc/des - convert to skcipher API
> 
>  arch/sparc/crypto/aes_glue.c      | 310 +++++++++----------
>  arch/sparc/crypto/camellia_glue.c | 217 ++++++-------
>  arch/sparc/crypto/des_glue.c      | 499 ++++++++++++++----------------
>  crypto/Kconfig                    |   5 +-
>  4 files changed, 468 insertions(+), 563 deletions(-)

All applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
