Return-Path: <SRS0=QtXc=XE=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7685DC00307
	for <linux-crypto@archiver.kernel.org>; Mon,  9 Sep 2019 07:54:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4C63121920
	for <linux-crypto@archiver.kernel.org>; Mon,  9 Sep 2019 07:54:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388501AbfIIHyQ (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 9 Sep 2019 03:54:16 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:32912 "EHLO fornost.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388499AbfIIHyQ (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 9 Sep 2019 03:54:16 -0400
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.0.7])
        by fornost.hmeau.com with smtp (Exim 4.89 #2 (Debian))
        id 1i7EV3-0007e0-Ny; Mon, 09 Sep 2019 17:54:14 +1000
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Mon, 09 Sep 2019 17:54:13 +1000
Date:   Mon, 9 Sep 2019 17:54:13 +1000
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc:     linux-crypto@vger.kernel.org
Subject: Re: [PATCH] crypto: x86/aes-ni - use AES library instead of
 single-use AES cipher
Message-ID: <20190909075413.GF21364@gondor.apana.org.au>
References: <20190904175632.5546-1-ard.biesheuvel@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190904175632.5546-1-ard.biesheuvel@linaro.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, Sep 04, 2019 at 10:56:32AM -0700, Ard Biesheuvel wrote:
> The RFC4106 key derivation code instantiates an AES cipher transform
> to encrypt only a single block before it is freed again. Switch to
> the new AES library which is more suitable for such use cases.
> 
> Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
> ---
>  arch/x86/crypto/aesni-intel_glue.c | 17 ++++++-----------
>  1 file changed, 6 insertions(+), 11 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
