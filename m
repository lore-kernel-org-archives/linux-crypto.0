Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 123E8C433E0
	for <linux-crypto@archiver.kernel.org>; Thu, 14 Jan 2021 06:47:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D10E123977
	for <linux-crypto@archiver.kernel.org>; Thu, 14 Jan 2021 06:47:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726081AbhANGrG (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 14 Jan 2021 01:47:06 -0500
Received: from helcar.hmeau.com ([216.24.177.18]:42158 "EHLO fornost.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725989AbhANGrG (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 14 Jan 2021 01:47:06 -0500
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.103.7])
        by fornost.hmeau.com with smtp (Exim 4.92 #5 (Debian))
        id 1kzwOk-00087W-LM; Thu, 14 Jan 2021 17:46:23 +1100
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Thu, 14 Jan 2021 17:46:22 +1100
Date:   Thu, 14 Jan 2021 17:46:22 +1100
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Ard Biesheuvel <ardb@kernel.org>
Cc:     linux-crypto@vger.kernel.org, Megha Dey <megha.dey@intel.com>,
        Eric Biggers <ebiggers@google.com>
Subject: Re: [PATCH v2 0/5] crypto: gcm-aes-ni cleanups
Message-ID: <20210114064622.GB12584@gondor.apana.org.au>
References: <20210104155550.6359-1-ardb@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210104155550.6359-1-ardb@kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, Jan 04, 2021 at 04:55:45PM +0100, Ard Biesheuvel wrote:
> Clean up some issues and peculiarities in the gcm(aes-ni) driver.
> 
> Changes since v1:
> - fix sleep while atomic issue reported by Eric
> - add patch to get rid of indirect calls, to avoid taking the retpoline
>   performance hit
> 
> Cc: Megha Dey <megha.dey@intel.com>
> Cc: Eric Biggers <ebiggers@google.com>
> Cc: Herbert Xu <herbert@gondor.apana.org.au>
> 
> Ard Biesheuvel (5):
>   crypto: x86/gcm-aes-ni - prevent misaligned buffers on the stack
>   crypto: x86/gcm-aes-ni - drop unused asm prototypes
>   crypto: x86/gcm-aes-ni - clean up mapping of associated data
>   crypto: x86/gcm-aes-ni - refactor scatterlist processing
>   crypto: x86/gcm-aes-ni - replace function pointers with static
>     branches
> 
>  arch/x86/crypto/aesni-intel_glue.c | 321 ++++++++------------
>  1 file changed, 121 insertions(+), 200 deletions(-)

All applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
