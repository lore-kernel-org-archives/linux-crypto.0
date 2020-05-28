Return-Path: <SRS0=ep2G=7K=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=FAKE_REPLY_C,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0E09AC433DF
	for <linux-crypto@archiver.kernel.org>; Thu, 28 May 2020 07:33:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EA9932145D
	for <linux-crypto@archiver.kernel.org>; Thu, 28 May 2020 07:33:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725839AbgE1Hd6 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 28 May 2020 03:33:58 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:35218 "EHLO fornost.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725811AbgE1Hd6 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 28 May 2020 03:33:58 -0400
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.0.7])
        by fornost.hmeau.com with smtp (Exim 4.92 #5 (Debian))
        id 1jeD2z-0000me-Rz; Thu, 28 May 2020 17:33:50 +1000
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Thu, 28 May 2020 17:33:49 +1000
Date:   Thu, 28 May 2020 17:33:49 +1000
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Ard Biesheuvel <ardb@kernel.org>
Cc:     linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        ebiggers@kernel.org, ardb@kernel.org, smueller@chronox.de
Subject: Re: [RFC/RFT PATCH 0/2] crypto: add CTS output IVs for arm64 and
 testmgr
Message-ID: <20200528073349.GA32566@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200519190211.76855-1-ardb@kernel.org>
X-Newsgroups: apana.lists.os.linux.cryptoapi
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Ard Biesheuvel <ardb@kernel.org> wrote:
> Stephan reports that the arm64 implementation of cts(cbc(aes)) deviates
> from the generic implementation in what it returns as the output IV. So
> fix this, and add some test vectors to catch other non-compliant
> implementations.
> 
> Stephan, could you provide a reference for the NIST validation tool and
> how it flags this behaviour as non-compliant? Thanks.

I think our CTS and XTS are both broken with respect to af_alg.

The reason we use output IVs in general is to support chaining
which is required by algif_skcipher to break up large requests
into smaller ones.

For CTS and XTS that simply doesn't work.  So we should fix this
by changing algif_skcipher to not do chaining (and hence drop
support for large requests like algif_aead) for algorithms like
CTS/XTS.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
