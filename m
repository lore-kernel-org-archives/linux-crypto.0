Return-Path: <SRS0=mRc+=YG=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AD312C4360C
	for <linux-crypto@archiver.kernel.org>; Sun, 13 Oct 2019 18:56:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 78AFA206B7
	for <linux-crypto@archiver.kernel.org>; Sun, 13 Oct 2019 18:56:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1570992980;
	bh=Y9kxwWDyqUSoQ1/hVR+Wp28960MjO8KOIQpmQnogB4U=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=m0pxg9k5lJZFC62BrOnWw9BeobeXa/zCN3IPy/RrIWx18L5FjraMHofkjjqL+Au3F
	 xLbo1iR09mRHDMRxMQJlwkHeKPooN3JcNy1w+mC00LLYil8UmX1/i2WVp+Gz8CguHn
	 KCAAuD+Q9Q8hdkgqWhu3gq42Y1u5P8B/v1nORGsc=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729374AbfJMS4T (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 13 Oct 2019 14:56:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:44148 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729355AbfJMS4T (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 13 Oct 2019 14:56:19 -0400
Received: from sol.localdomain (c-24-5-143-220.hsd1.ca.comcast.net [24.5.143.220])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A38DA205F4;
        Sun, 13 Oct 2019 18:56:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570992977;
        bh=Y9kxwWDyqUSoQ1/hVR+Wp28960MjO8KOIQpmQnogB4U=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=R2olzMavVH+qC0T7OxCVESf//NIWEs0WcIaxqnE2ZkfIwTB2CPZ/t7H/X0YNV56Dm
         worBxqumuIPcpXaJZouxzD++jtL/s0ymNr8YVo+hcV0nABuPn9JUqkfmmOP8pSpZRp
         yh0tDzAh0MGSsALO20cMgczJ1Qa65crdzi8UagkI=
Date:   Sun, 13 Oct 2019 11:56:16 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc:     "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
        <linux-crypto@vger.kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        linuxppc-dev <linuxppc-dev@lists.ozlabs.org>,
        Breno =?iso-8859-1?Q?Leit=E3o?= <leitao@debian.org>,
        Nayna Jain <nayna@linux.ibm.com>,
        Paulo Flabiano Smorigo <pfsmorigo@gmail.com>
Subject: Re: [PATCH 0/4] crypto: nx - convert to skcipher API
Message-ID: <20191013185616.GA10007@sol.localdomain>
Mail-Followup-To: Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" <linux-crypto@vger.kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        linuxppc-dev <linuxppc-dev@lists.ozlabs.org>,
        Breno =?iso-8859-1?Q?Leit=E3o?= <leitao@debian.org>,
        Nayna Jain <nayna@linux.ibm.com>,
        Paulo Flabiano Smorigo <pfsmorigo@gmail.com>
References: <20191013043918.337113-1-ebiggers@kernel.org>
 <CAKv+Gu8nN48aWoeW-aA_1OA_s8Qw0nUbyg+GCZ9DsUA3tDNprg@mail.gmail.com>
 <CAKv+Gu-PEemQvXv=kqxfqb4RvmpdU2h7TZHKps2FKTBUTKFehQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKv+Gu-PEemQvXv=kqxfqb4RvmpdU2h7TZHKps2FKTBUTKFehQ@mail.gmail.com>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Sun, Oct 13, 2019 at 05:31:31PM +0200, Ard Biesheuvel wrote:
> On Sun, 13 Oct 2019 at 08:29, Ard Biesheuvel <ard.biesheuvel@linaro.org> wrote:
> >
> > On Sun, 13 Oct 2019 at 06:40, Eric Biggers <ebiggers@kernel.org> wrote:
> > >
> > > This series converts the PowerPC Nest (NX) implementations of AES modes
> > > from the deprecated "blkcipher" API to the "skcipher" API.  This is
> > > needed in order for the blkcipher API to be removed.
> > >
> > > This patchset is compile-tested only, as I don't have this hardware.
> > > If anyone has this hardware, please test this patchset with
> > > CONFIG_CRYPTO_MANAGER_EXTRA_TESTS=y.
> > >
> > > Eric Biggers (4):
> > >   crypto: nx - don't abuse blkcipher_desc to pass iv around
> > >   crypto: nx - convert AES-ECB to skcipher API
> > >   crypto: nx - convert AES-CBC to skcipher API
> > >   crypto: nx - convert AES-CTR to skcipher API
> > >
> > >  drivers/crypto/nx/nx-aes-cbc.c | 81 ++++++++++++++-----------------
> > >  drivers/crypto/nx/nx-aes-ccm.c | 40 ++++++----------
> > >  drivers/crypto/nx/nx-aes-ctr.c | 87 +++++++++++++++-------------------
> > >  drivers/crypto/nx/nx-aes-ecb.c | 76 +++++++++++++----------------
> > >  drivers/crypto/nx/nx-aes-gcm.c | 24 ++++------
> > >  drivers/crypto/nx/nx.c         | 64 ++++++++++++++-----------
> > >  drivers/crypto/nx/nx.h         | 19 ++++----
> > >  7 files changed, 176 insertions(+), 215 deletions(-)
> > >
> >
> > Hi Eric,
> >
> > Thanks for taking this on. I'll look in more detail at these patches
> > during the week. In the meantime, I may have a stab at converting ccp,
> > virtio-crypto and omap aes/des myself, since i have the hardware to
> > test those.
> >
> 
> OK, I got a bit carried away, and converted a bunch of platforms in
> drivers/crypto (build tested only, except for the virtio driver)
> 
> crypto: qce - switch to skcipher API
> crypto: rockchip - switch to skcipher API
> crypto: stm32 - switch to skcipher API
> crypto: sahara - switch to skcipher API
> crypto: picoxcell - switch to skcipher API
> crypto: mediatek - switch to skcipher API
> crypto: mxs - switch to skcipher API
> crypto: ixp4xx - switch to skcipher API
> crypto: hifn - switch to skcipher API
> crypto: chelsio - switch to skcipher API
> crypto: cavium/cpt - switch to skcipher API
> crypto: nitrox - remove cra_type reference to ablkcipher
> crypto: bcm-spu - switch to skcipher API
> crypto: atmel-tdes - switch to skcipher API
> crypto: atmel-aes - switch to skcipher API
> crypto: s5p - switch to skcipher API
> crypto: ux500 - switch to skcipher API
> crypto: omap - switch to skcipher API
> crypto: virtio - switch to skcipher API
> crypto: virtio - deal with unsupported input sizes
> crypto: virtio - implement missing support for output IVs
> crypto: ccp - switch from ablkcipher to skcipher
> 
> https://git.kernel.org/pub/scm/linux/kernel/git/ardb/linux.git/log/?h=ablkcipher-removal
> 
> I pushed the branch to kernelci, so hopefully we'll get some automated
> results, but I think only a small subset of these are boot tested atm.

Awesome, thanks for doing this!  I was just planning to do "blkcipher" for now,
but your patches will take care of almost all of "ablkcipher" too.

A few things I noticed from quickly skimming through your patches:

"ecb-des3-omap", "cbc-des3-omap", "atmel-ecb-tdes", "atmel-cbc-tdes", and
"atmel-ofb-tdes" had their min and/or max key size incorrectly changed to 8
(DES_BLOCK_SIZE or DES3_EDE_BLOCK_SIZE) rather than left as 24
(DES3_EDE_KEY_SIZE or 3*DES_KEY_SIZE).

cra_blocksize for "atmel-cfb64-aes" was changed from CFB64_BLOCK_SIZE to
AES_BLOCKSIZE.  Intentional?

cra_blocksize for "stm32-ctr-aes" and for "cfb-aes-mtk" was changed from 1 to
AES_BLOCK_SIZE.  Intentional?

CRYPTO_ALG_NEED_FALLBACK was added to "cbc-des-picoxcell" and "ecb-des-picoxcell".
Intentional?

In drivers/crypto/ixp4xx_crypto.c, .walksize was set on "rfc3686(ctr(aes))"
rather than .chunksize.  Intentional?

In drivers/crypto/qce/, CRYPTO_ALG_TYPE_ABLKCIPHER should be replaced with
CRYPTO_ALG_TYPE_SKCIPHER.

In drivers/crypto/stm32/, could rename crypto_algs[] to skcipher_algs[].

Thanks!

- Eric
