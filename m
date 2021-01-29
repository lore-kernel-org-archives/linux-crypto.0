Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8B676C433E9
	for <linux-crypto@archiver.kernel.org>; Fri, 29 Jan 2021 01:35:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4B66964E0B
	for <linux-crypto@archiver.kernel.org>; Fri, 29 Jan 2021 01:35:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231687AbhA2Bfq (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 28 Jan 2021 20:35:46 -0500
Received: from helcar.hmeau.com ([216.24.177.18]:54642 "EHLO fornost.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229627AbhA2Bfp (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 28 Jan 2021 20:35:45 -0500
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.103.7])
        by fornost.hmeau.com with smtp (Exim 4.92 #5 (Debian))
        id 1l5IgX-00088d-43; Fri, 29 Jan 2021 12:34:54 +1100
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Fri, 29 Jan 2021 12:34:52 +1100
Date:   Fri, 29 Jan 2021 12:34:52 +1100
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Stefan Berger <stefanb@linux.vnet.ibm.com>
Cc:     keyrings@vger.kernel.org, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, patrick@puiterwijk.org,
        Stefan Berger <stefanb@linux.ibm.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH v4 1/3] crypto: Add support for ECDSA signature
 verification
Message-ID: <20210129013452.GA3129@gondor.apana.org.au>
References: <20210128001412.822048-1-stefanb@linux.vnet.ibm.com>
 <20210128001412.822048-2-stefanb@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210128001412.822048-2-stefanb@linux.vnet.ibm.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, Jan 27, 2021 at 07:14:10PM -0500, Stefan Berger wrote:
> From: Stefan Berger <stefanb@linux.ibm.com>
> 
> Add support for parsing the parameters of a NIST P256 or NIST P192 key.
> Enable signature verification using these keys.
> 
> Signed-off-by: Stefan Berger <stefanb@linux.ibm.com>
> Cc: Herbert Xu <herbert@gondor.apana.org.au>
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: linux-crypto@vger.kernel.org
> ---
>  crypto/Makefile            |   9 +-
>  crypto/ecc.c               | 279 +++++++++++++++++++++++++++++++++++++
>  crypto/ecc.h               |   2 +
>  crypto/ecdsasignature.asn1 |   4 +
>  4 files changed, 293 insertions(+), 1 deletion(-)
>  create mode 100644 crypto/ecdsasignature.asn1

Hi Stefan:

I forgot to cc you on the other thread at

https://lore.kernel.org/linux-crypto/20210128103908.GA32495@gondor.apana.org.au/T/#u

Whatever we decide there would be applicable to your scenario too.
Please join the discussion on that thread.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
