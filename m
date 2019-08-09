Return-Path: <SRS0=Ue/q=WF=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3C59CC433FF
	for <linux-crypto@archiver.kernel.org>; Fri,  9 Aug 2019 06:19:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1541C208C3
	for <linux-crypto@archiver.kernel.org>; Fri,  9 Aug 2019 06:19:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405584AbfHIGTF (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 9 Aug 2019 02:19:05 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:37422 "EHLO fornost.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725920AbfHIGTF (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 9 Aug 2019 02:19:05 -0400
Received: from gondolin.me.apana.org.au ([192.168.0.6] helo=gondolin.hengli.com.au)
        by fornost.hmeau.com with esmtps (Exim 4.89 #2 (Debian))
        id 1hvyEw-0007Mx-6c; Fri, 09 Aug 2019 16:19:02 +1000
Received: from herbert by gondolin.hengli.com.au with local (Exim 4.80)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1hvyEv-0002p9-CJ; Fri, 09 Aug 2019 16:19:01 +1000
Date:   Fri, 9 Aug 2019 16:19:01 +1000
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Iuliana Prodan <iuliana.prodan@nxp.com>
Cc:     Horia Geanta <horia.geanta@nxp.com>,
        Aymen Sghaier <aymen.sghaier@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-imx <linux-imx@nxp.com>
Subject: Re: [PATCH v5 00/14] crypto: caam - fixes for kernel v5.3
Message-ID: <20190809061901.GL10392@gondor.apana.org.au>
References: <1564578495-9883-1-git-send-email-iuliana.prodan@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1564578495-9883-1-git-send-email-iuliana.prodan@nxp.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, Jul 31, 2019 at 04:08:01PM +0300, Iuliana Prodan wrote:
> The series solves:
> - the failures found with fuzz testing;
> - resources clean-up on caampkc/caamrng exit path.
> 
> The first 10 patches solve the issues found with
> CONFIG_CRYPTO_MANAGER_EXTRA_TESTS enabled.
> They modify the drivers to provide a valid error (and not the hardware
> error ID) to the user, via completion callbacks.
> They check key length, assoclen, authsize and input size to solve the
> fuzz tests that expect -EINVAL to be returned when these values are
> not valid.
> 
> The next 4 patches check the algorithm registration for caampkc
> module and unregister it only if the registration was successful.
> Also, on caampkc/caamrng, the exit point function is executed only if the
> registration was successful to avoid double freeing of resources in case
> the initialization function failed.
> 
> This patch depends on series:
> https://patchwork.kernel.org/project/linux-crypto/list/?series=153441
> 
> Changes since v4:
> - use, newly renamed, helper aes function, to validate keylen.
> 
> Horia Geantă (5):
>   crypto: caam/qi - fix error handling in ERN handler
>   crypto: caam - fix return code in completion callbacks
>   crypto: caam - update IV only when crypto operation succeeds
>   crypto: caam - keep both virtual and dma key addresses
>   crypto: caam - fix MDHA key derivation for certain user key lengths
> 
> Iuliana Prodan (9):
>   crypto: caam - check key length
>   crypto: caam - check authsize
>   crypto: caam - check assoclen
>   crypto: caam - check zero-length input
>   crypto: caam - update rfc4106 sh desc to support zero length input
>   crypto: caam - free resources in case caam_rng registration failed
>   crypto: caam - execute module exit point only if necessary
>   crypto: caam - unregister algorithm only if the registration succeeded
>   crypto: caam - change return value in case CAAM has no MDHA
> 
>  drivers/crypto/caam/Kconfig         |   2 +
>  drivers/crypto/caam/caamalg.c       | 227 +++++++++++++++----------
>  drivers/crypto/caam/caamalg_desc.c  |  47 ++++--
>  drivers/crypto/caam/caamalg_desc.h  |   2 +-
>  drivers/crypto/caam/caamalg_qi.c    | 225 +++++++++++++++----------
>  drivers/crypto/caam/caamalg_qi2.c   | 320 +++++++++++++++++++++++-------------
>  drivers/crypto/caam/caamhash.c      | 114 ++++++++-----
>  drivers/crypto/caam/caamhash_desc.c |   5 +-
>  drivers/crypto/caam/caamhash_desc.h |   2 +-
>  drivers/crypto/caam/caampkc.c       |  80 ++++++---
>  drivers/crypto/caam/caamrng.c       |  17 +-
>  drivers/crypto/caam/desc_constr.h   |  34 ++--
>  drivers/crypto/caam/error.c         |  61 ++++---
>  drivers/crypto/caam/error.h         |   2 +-
>  drivers/crypto/caam/key_gen.c       |  14 +-
>  drivers/crypto/caam/qi.c            |  10 +-
>  drivers/crypto/caam/regs.h          |   1 +
>  17 files changed, 748 insertions(+), 415 deletions(-)

All applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
