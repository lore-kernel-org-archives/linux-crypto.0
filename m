Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4F169C433E0
	for <linux-crypto@archiver.kernel.org>; Thu,  4 Feb 2021 05:42:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C019864F55
	for <linux-crypto@archiver.kernel.org>; Thu,  4 Feb 2021 05:42:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229752AbhBDFmP (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 4 Feb 2021 00:42:15 -0500
Received: from helcar.hmeau.com ([216.24.177.18]:51580 "EHLO fornost.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229742AbhBDFmP (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 4 Feb 2021 00:42:15 -0500
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.103.7])
        by fornost.hmeau.com with smtp (Exim 4.92 #5 (Debian))
        id 1l7XOO-00022g-Af; Thu, 04 Feb 2021 16:41:25 +1100
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Thu, 04 Feb 2021 16:41:24 +1100
Date:   Thu, 4 Feb 2021 16:41:24 +1100
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Saulo Alessandre <saulo.alessandre@gmail.com>,
        Stefan Berger <stefanb@linux.ibm.com>
Cc:     ardb@kernel.org, daniele.alessandrelli@linux.intel.com,
        davem@davemloft.net, elena.reshetova@intel.com,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        mgross@linux.intel.com, prabhjot.khurana@intel.com,
        wangzhou1@hisilicon.com, xuzaibo@huawei.com, yumeng18@huawei.com
Subject: Re: [PATCH v7 4/7] crypto: add ecc curve and expose them
Message-ID: <20210204054124.GB7229@gondor.apana.org.au>
References: <20210128050354.GA30874@gondor.apana.org.au>
 <20210203180344.2418055-1-saulo.alessandre@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210203180344.2418055-1-saulo.alessandre@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, Feb 03, 2021 at 03:03:44PM -0300, Saulo Alessandre wrote:
>
> In this patch I'm using akcipher allocate like ecdsa(sha1,sha256,...), 
> because the ecdsa algo is generic, and using the curve name and ndigits
> inside vli_mmod_fast to discover the curve, but I agree the correct way
> would be allocate ecdsa-nist-p521(sha1,...) and have all params for the
> curve inside strut ecc_curve, remembering that we have anothers curves 
> incoming, like Edwards.

I'm not sure whether we really should encode hash into the algorithm
name.  This may be something that we can move into setkey instead.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
