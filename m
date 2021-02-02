Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 91275C433DB
	for <linux-crypto@archiver.kernel.org>; Tue,  2 Feb 2021 05:11:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3BAC364ED5
	for <linux-crypto@archiver.kernel.org>; Tue,  2 Feb 2021 05:11:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229846AbhBBFK7 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 2 Feb 2021 00:10:59 -0500
Received: from helcar.hmeau.com ([216.24.177.18]:43878 "EHLO fornost.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229466AbhBBFK7 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 2 Feb 2021 00:10:59 -0500
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.103.7])
        by fornost.hmeau.com with smtp (Exim 4.92 #5 (Debian))
        id 1l6nwy-0001Da-3d; Tue, 02 Feb 2021 16:10:05 +1100
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Tue, 02 Feb 2021 16:10:03 +1100
Date:   Tue, 2 Feb 2021 16:10:03 +1100
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Saulo Alessandre <saulo.alessandre@gmail.com>
Cc:     linux-crypto@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Vitaly Chikunov <vt@altlinux.org>,
        Tianjia Zhang <tianjia.zhang@linux.alibaba.com>,
        Saulo Alessandre <saulo.alessandre@tse.jus.br>
Subject: Re: [PATCH v2 4/4] ecdsa: implements ecdsa signature verification
Message-ID: <20210202051003.GA27641@gondor.apana.org.au>
References: <20210129212535.2257493-1-saulo.alessandre@gmail.com>
 <20210129212535.2257493-5-saulo.alessandre@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210129212535.2257493-5-saulo.alessandre@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, Jan 29, 2021 at 06:25:35PM -0300, Saulo Alessandre wrote:
> From: Saulo Alessandre <saulo.alessandre@tse.jus.br>
> 
> * Documentation/admin-guide/module-signing.rst
>   - Documents how to generate certificate and signature for (ECDSA).
> 
> * crypto/Kconfig
>   - ECDSA added into kernel Public-key cryptography section.
> 
> * crypto/Makefile
>    - add ECDSA objects and asn1 params to compile.
> 
> * crypto/ecdsa.c
>   - Elliptical Curve DSA verify implementation
> 
> * crypto/ecdsa_params.asn1
>   - Elliptical Curve DSA verify definitions
> 
> * crypto/ecdsa_signature.asn1
>   - Elliptical Curve DSA asn.1 parameters
> 
> * crypto/testmgr.c
>   - test_akcipher_one - modified to reflect the real code call for nist code;
>   - alg_test_descs - added ecdsa vector for test;
> 
> * crypto/testmgr.h
>   - ecdsa_tv_template - added to test ecdsa implementation;
> ---
>  Documentation/admin-guide/module-signing.rst |  10 +
>  crypto/Kconfig                               |  12 +
>  crypto/Makefile                              |   7 +
>  crypto/ecdsa.c                               | 509 +++++++++++++++++++
>  crypto/ecdsa_params.asn1                     |   1 +
>  crypto/ecdsa_signature.asn1                  |   6 +
>  crypto/testmgr.c                             |  17 +-
>  crypto/testmgr.h                             |  78 +++
>  8 files changed, 638 insertions(+), 2 deletions(-)
>  create mode 100644 crypto/ecdsa.c
>  create mode 100644 crypto/ecdsa_params.asn1
>  create mode 100644 crypto/ecdsa_signature.asn1

Please join the existing thread on this:

https://lore.kernel.org/linux-crypto/20210128050354.GA30874@gondor.apana.org.au/

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
