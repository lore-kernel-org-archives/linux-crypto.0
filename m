Return-Path: <SRS0=+KeW=2R=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E9A8AC2D0C6
	for <linux-crypto@archiver.kernel.org>; Fri, 27 Dec 2019 10:39:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C3EA820882
	for <linux-crypto@archiver.kernel.org>; Fri, 27 Dec 2019 10:39:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726365AbfL0KjJ (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 27 Dec 2019 05:39:09 -0500
Received: from helcar.hmeau.com ([216.24.177.18]:60284 "EHLO deadmen.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726354AbfL0KjJ (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 27 Dec 2019 05:39:09 -0500
Received: from gondobar.mordor.me.apana.org.au ([192.168.128.4] helo=gondobar)
        by deadmen.hmeau.com with esmtps (Exim 4.89 #2 (Debian))
        id 1ikn1P-0007QA-RF; Fri, 27 Dec 2019 18:39:07 +0800
Received: from herbert by gondobar with local (Exim 4.89)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1ikn1P-0005p1-LO; Fri, 27 Dec 2019 18:39:07 +0800
Date:   Fri, 27 Dec 2019 18:39:07 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Eneas U de Queiroz <cotequeiroz@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org
Subject: Re: Subject: [PATCH 0/6] crypto: QCE hw-crypto fixes
Message-ID: <20191227103907.x3sy3dg57yhx2vbz@gondor.apana.org.au>
References: <20191220190218.28884-1-cotequeiroz@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191220190218.28884-1-cotequeiroz@gmail.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, Dec 20, 2019 at 04:02:12PM -0300, Eneas U de Queiroz wrote:
> I've been trying to make the Qualcomm Crypto Engine work with GCM-mode
> AES.  I fixed some bugs, and added an option to build only hashes or
> skciphers, as the VPN performance increases if you leave some of that to
> the CPU.
> 
> A discussion about this can be found here:
> https://github.com/openwrt/openwrt/pull/2518
> 
> I'm using openwrt to test this, and there's no support for kernel 5.x
> yet.  So I have backported the recent skcipher updates, and tested this
> with 4.19. I don't have the hardware with me, but I have run-tested
> everything, working remotely.
> 
> All of the skciphers directly implemented by the driver work.  They pass
> the tcrypt tests, and also some tests from userspace using AF_ALG:
> https://github.com/cotequeiroz/afalg_tests
> 
> However, I can't get gcm(aes) to work.  When setting the gcm-mode key,
> it sets the ctr(aes) key, then encrypt a block of zeroes, and uses that
> as the ghash key.  The driver fails to perform that encryption.  I've
> dumped the input and output data, and they apparently are not touched by
> the QCE.  The IV, which written to a buffer appended to the results sg
> list gets updated, but the results themselves are not.  I'm not sure
> what goes wrong, if it is a DMA/cache problem, memory alignment, or
> whatever.
> 
> If I take 'be128 hash' out of the 'data' struct, and kzalloc them
> separately in crypto_gcm_setkey (crypto/gcm.c), it encrypts the data
> just fine--perhaps the payload and the request struct can't be in the
> same page?
> 
> However, it still fails during decryption of the very first tcrypt test
> vector (I'm testing with the AF_ALG program, using the same vectors as
> the kernel), in the final encryption to compute the authentication tag,
> in the same fashion as it did in 'crypto_gcm_setkey'.  What this case
> has in common with the ghash key above is the input data, a single block
> of zeroes, so this may be a hardware bug.  However, if I perform the
> same encryption using the AF_ALG test, it completes OK.
> 
> I am not experienced enough with the Linux Kernel, or with the ARM
> architecture to wrap this up on my own, so I need some pointers to what
> to try next.
> 
> To come up a working setup, I am passing any AES requests whose length
> is less than or equal to one AES block to the fallback skcipher.  This
> hack is not a part of this series, but I can send it if there's any
> interest in it.
> 
> Anyway, the patches in this series are complete enough on their own.
> With the exception of the last patch, they're all bugfixes.
> 
> Cheers,
> 
> Eneas
> 
> Eneas U de Queiroz (6):
>   crypto: qce - fix ctr-aes-qce block, chunk sizes
>   crypto: qce - fix xts-aes-qce key sizes
>   crypto: qce - save a sg table slot for result buf
>   crypto: qce - update the skcipher IV
>   crypto: qce - initialize fallback only for AES
>   crypto: qce - allow building only hashes/ciphers
> 
>  drivers/crypto/Kconfig        |  63 ++++++++-
>  drivers/crypto/qce/Makefile   |   7 +-
>  drivers/crypto/qce/common.c   | 244 ++++++++++++++++++----------------
>  drivers/crypto/qce/core.c     |   4 +
>  drivers/crypto/qce/dma.c      |   6 +-
>  drivers/crypto/qce/dma.h      |   3 +-
>  drivers/crypto/qce/skcipher.c |  41 ++++--
>  7 files changed, 229 insertions(+), 139 deletions(-)

All applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
