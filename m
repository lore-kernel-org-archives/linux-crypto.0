Return-Path: <SRS0=9dQ/=YS=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AAD1CCA9EA0
	for <linux-crypto@archiver.kernel.org>; Fri, 25 Oct 2019 15:19:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 86EFD21D7F
	for <linux-crypto@archiver.kernel.org>; Fri, 25 Oct 2019 15:19:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2440631AbfJYPTe (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 25 Oct 2019 11:19:34 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:35742 "EHLO deadmen.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2440617AbfJYPTd (ORCPT <rfc822;linux-crypto@vger.kernel.orG>);
        Fri, 25 Oct 2019 11:19:33 -0400
Received: from gondobar.mordor.me.apana.org.au ([192.168.128.4] helo=gondobar)
        by deadmen.hmeau.com with esmtps (Exim 4.89 #2 (Debian))
        id 1iO1ND-0001gL-Ss; Fri, 25 Oct 2019 23:19:31 +0800
Received: from herbert by gondobar with local (Exim 4.89)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1iO1ND-0007oT-HU; Fri, 25 Oct 2019 23:19:31 +0800
Date:   Fri, 25 Oct 2019 23:19:31 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc:     linux-crypto@vger.kernel.org, Eric Biggers <ebiggers@google.com>
Subject: Re: [PATCH] crypto: powerpc/spe-xts - implement support for
 ciphertext stealing
Message-ID: <20191025151931.m3tbnqdjp37dd4o6@gondor.apana.org.au>
References: <20191015081412.5295-1-ard.biesheuvel@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191015081412.5295-1-ard.biesheuvel@linaro.org>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, Oct 15, 2019 at 10:14:12AM +0200, Ard Biesheuvel wrote:
> Add the logic to deal with input sizes that are not a round multiple
> of the AES block size, as described by the XTS spec. This brings the
> SPE implementation in line with other kernel drivers that have been
> updated recently to take this into account.
> 
> Cc: Eric Biggers <ebiggers@google.com>
> Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
> ---
> This applies onto Eric's series 'crypto: powerpc - convert SPE AES algorithms
> to skcipher API', which helpfully contained instructions how to run this code
> under QEMU, allowing me to test the changes below.
> 
>  arch/powerpc/crypto/aes-spe-glue.c | 81 +++++++++++++++++++-
>  1 file changed, 79 insertions(+), 2 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
