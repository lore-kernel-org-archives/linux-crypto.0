Return-Path: <SRS0=bFfa=QW=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED,USER_AGENT_NEOMUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6AEDBC10F02
	for <linux-crypto@archiver.kernel.org>; Fri, 15 Feb 2019 05:24:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3917A21B1C
	for <linux-crypto@archiver.kernel.org>; Fri, 15 Feb 2019 05:24:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726803AbfBOFYz (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 15 Feb 2019 00:24:55 -0500
Received: from orcrist.hmeau.com ([104.223.48.154]:41784 "EHLO
        deadmen.hmeau.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726336AbfBOFYy (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 15 Feb 2019 00:24:54 -0500
Received: from gondobar.mordor.me.apana.org.au ([192.168.128.4] helo=gondobar)
        by deadmen.hmeau.com with esmtps (Exim 4.89 #2 (Debian))
        id 1guVzY-0004i4-Mg; Fri, 15 Feb 2019 13:24:52 +0800
Received: from herbert by gondobar with local (Exim 4.89)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1guVzY-0002J7-Ib; Fri, 15 Feb 2019 13:24:52 +0800
Date:   Fri, 15 Feb 2019 13:24:52 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Iuliana Prodan <iuliana.prodan@nxp.com>
Cc:     Horia Geanta <horia.geanta@nxp.com>,
        Aymen Sghaier <aymen.sghaier@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-imx <linux-imx@nxp.com>
Subject: Re: [PATCH 0/4] crypto: caam - add ecb mode support
Message-ID: <20190215052452.nl7ggrtpd4aiup52@gondor.apana.org.au>
References: <1549633810-10380-1-git-send-email-iuliana.prodan@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1549633810-10380-1-git-send-email-iuliana.prodan@nxp.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, Feb 08, 2019 at 03:50:06PM +0200, Iuliana Prodan wrote:
> This patch set adds ecb mode support for aes, des, 3des and arc4 ciphers.
> skcipher implementation is reused, making sure to handle the no IV case.
> 
> While here:
> -fix a DMA API issue where initial src/dst_nents are used instead of nents
> returned by dma_map_sg()
> -export arc4 defines in a common header
> -update cbc des and 3des to check for weak keys 
> 
> Iuliana Prodan (4):
>   crypto: caam - use mapped_{src,dst}_nents for job descriptor
>   crypto: export arc4 defines
>   crypto: caam - add ecb(*) support
>   crypto: caam - weak key checking for cbc des, 3des
> 
>  crypto/arc4.c                      |   5 +-
>  drivers/crypto/bcm/cipher.h        |   4 +-
>  drivers/crypto/caam/Kconfig        |   1 +
>  drivers/crypto/caam/caamalg.c      | 215 ++++++++++++++++++++++++++++---------
>  drivers/crypto/caam/caamalg_desc.c |  18 ++--
>  drivers/crypto/caam/compat.h       |   1 +
>  include/crypto/arc4.h              |  13 +++
>  7 files changed, 195 insertions(+), 62 deletions(-)
>  create mode 100644 include/crypto/arc4.h

All applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
