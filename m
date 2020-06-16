Return-Path: <SRS0=4Aj0=75=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BA464C433E0
	for <linux-crypto@archiver.kernel.org>; Tue, 16 Jun 2020 17:43:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 96AA9214DB
	for <linux-crypto@archiver.kernel.org>; Tue, 16 Jun 2020 17:43:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1592329424;
	bh=gzAeBmKVrMYFzSDDe8o9ZYmBI8WNGHOFnai6AYK27f8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=F6CGMqLsg59BxbZHrkZNXHakGCHt746VA8HduwqyYgL120LnVIrXF1WtfFzAAsIXf
	 CO8LDkoIswR+HXusmE3ElJMkN3QOPixwRAqb4eKHtAdyMfujpEo6OdSFEETj1xsSZO
	 4WavS9sFav2U81PUsVQCD7nhjQxMXei19YL64TZ8=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729771AbgFPRnn (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 16 Jun 2020 13:43:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:51864 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727083AbgFPRnm (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 16 Jun 2020 13:43:42 -0400
Received: from gmail.com (unknown [104.132.1.76])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B0839214D8;
        Tue, 16 Jun 2020 17:43:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592329422;
        bh=gzAeBmKVrMYFzSDDe8o9ZYmBI8WNGHOFnai6AYK27f8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=JfSzCoLuzeVB7nj1LoFcayYIBA1hHzEu38gLncAzrO2fksTP8AhEAKhY7flOLAhfE
         /ZRmgeSUjO5SSazfBbH105AXcqSkYy/TO1bnU3qrXqjxikNEHYIPhaLCqmhl1g832t
         2XowfrW82T8/eFmfnyuma/KithmCNBmLCuqqujVk=
Date:   Tue, 16 Jun 2020 10:43:40 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Mikulas Patocka <mpatocka@redhat.com>
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        Mike Snitzer <msnitzer@redhat.com>,
        linux-kernel@vger.kernel.org, dm-devel@redhat.com,
        linux-crypto@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Milan Broz <mbroz@redhat.com>
Subject: Re: [dm-devel] [PATCH 3/4] crypto: set the flag
 CRYPTO_ALG_ALLOCATES_MEMORY
Message-ID: <20200616174340.GC207319@gmail.com>
References: <alpine.LRH.2.02.2006091259250.30590@file01.intranet.prod.int.rdu2.redhat.com>
 <20200610010450.GA6449@gondor.apana.org.au>
 <alpine.LRH.2.02.2006100756270.27811@file01.intranet.prod.int.rdu2.redhat.com>
 <20200610121106.GA23137@gondor.apana.org.au>
 <alpine.LRH.2.02.2006161052540.28052@file01.intranet.prod.int.rdu2.redhat.com>
 <alpine.LRH.2.02.2006161102020.28052@file01.intranet.prod.int.rdu2.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LRH.2.02.2006161102020.28052@file01.intranet.prod.int.rdu2.redhat.com>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, Jun 16, 2020 at 11:02:20AM -0400, Mikulas Patocka wrote:
> Set the flag CRYPTO_ALG_ALLOCATES_MEMORY in the crypto drivers that
> allocate memory.
> 
> Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
> 
> ---
>  drivers/crypto/allwinner/sun8i-ce/sun8i-ce-core.c |    8 +-
>  drivers/crypto/allwinner/sun8i-ss/sun8i-ss-core.c |    8 +-
>  drivers/crypto/amlogic/amlogic-gxl-core.c         |    4 -
>  drivers/crypto/axis/artpec6_crypto.c              |   20 +++--
>  drivers/crypto/bcm/cipher.c                       |   38 +++++-----
>  drivers/crypto/caam/caamalg.c                     |    4 -
>  drivers/crypto/caam/caamalg_qi.c                  |    4 -
>  drivers/crypto/caam/caamalg_qi2.c                 |    6 -
>  drivers/crypto/caam/caamhash.c                    |    2 
>  drivers/crypto/cavium/cpt/cptvf_algs.c            |   12 +--
>  drivers/crypto/cavium/nitrox/nitrox_aead.c        |    4 -
>  drivers/crypto/cavium/nitrox/nitrox_skcipher.c    |   16 ++--
>  drivers/crypto/ccp/ccp-crypto-aes-cmac.c          |    1 
>  drivers/crypto/ccp/ccp-crypto-aes-galois.c        |    1 
>  drivers/crypto/ccp/ccp-crypto-aes-xts.c           |    1 
>  drivers/crypto/ccp/ccp-crypto-aes.c               |    2 
>  drivers/crypto/ccp/ccp-crypto-des3.c              |    1 
>  drivers/crypto/ccp/ccp-crypto-sha.c               |    1 
>  drivers/crypto/chelsio/chcr_algo.c                |    6 -
>  drivers/crypto/hisilicon/sec/sec_algs.c           |   16 ++--
>  drivers/crypto/hisilicon/sec2/sec_crypto.c        |    4 -
>  drivers/crypto/inside-secure/safexcel_cipher.c    |   47 +++++++++++++
>  drivers/crypto/inside-secure/safexcel_hash.c      |   18 +++++
>  drivers/crypto/ixp4xx_crypto.c                    |    6 +
>  drivers/crypto/marvell/cesa/cipher.c              |   12 +--
>  drivers/crypto/marvell/cesa/hash.c                |    6 +
>  drivers/crypto/marvell/octeontx/otx_cptvf_algs.c  |   30 ++++----
>  drivers/crypto/n2_core.c                          |    2 
>  drivers/crypto/picoxcell_crypto.c                 |   17 ++++
>  drivers/crypto/qat/qat_common/qat_algs.c          |   12 +--
>  drivers/crypto/qce/sha.c                          |    2 
>  drivers/crypto/qce/skcipher.c                     |    1 
>  drivers/crypto/talitos.c                          |   78 +++++++++++-----------
>  drivers/crypto/virtio/virtio_crypto_algs.c        |    2 
>  drivers/crypto/xilinx/zynqmp-aes-gcm.c            |    1 
>  35 files changed, 248 insertions(+), 145 deletions(-)

It would be helpful if there was a pointer to where the memory allocation
happens in each driver.

- Eric
