Return-Path: <SRS0=x16Q=X5=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B774AC47404
	for <linux-crypto@archiver.kernel.org>; Fri,  4 Oct 2019 15:44:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8BE792133F
	for <linux-crypto@archiver.kernel.org>; Fri,  4 Oct 2019 15:44:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389891AbfJDPoE (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 4 Oct 2019 11:44:04 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:42578 "EHLO fornost.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389871AbfJDPoE (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 4 Oct 2019 11:44:04 -0400
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.0.7])
        by fornost.hmeau.com with smtp (Exim 4.89 #2 (Debian))
        id 1iGPkM-0001PO-JT; Sat, 05 Oct 2019 01:43:59 +1000
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Sat, 05 Oct 2019 01:43:58 +1000
Date:   Sat, 5 Oct 2019 01:43:58 +1000
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Pascal van Leeuwen <pascalvanl@gmail.com>
Cc:     linux-crypto@vger.kernel.org, antoine.tenart@bootlin.com,
        davem@davemloft.net,
        Pascal van Leeuwen <pvanleeuwen@verimatrix.com>
Subject: Re: [PATCHv4 0/3] crypto: inside-secure: Add support for the
 Chacha20 skcipher and the Chacha20-Poly1305 AEAD suites
Message-ID: <20191004154358.GV5148@gondor.apana.org.au>
References: <1568841958-14622-1-git-send-email-pvanleeuwen@verimatrix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1568841958-14622-1-git-send-email-pvanleeuwen@verimatrix.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, Sep 18, 2019 at 11:25:55PM +0200, Pascal van Leeuwen wrote:
> Extend driver support with chacha20, rfc7539(chacha20,poly1305) and
> rfc7539esp(chacha20,poly1305) ciphers.
> The patchset has been tested with the eip197c_iesb and eip197c_iewxkbc
> configurations on the Xilinx VCU118 development board, including the
> crypto extra tests.
> 
> Note that this patchset applies on top of the earlier submitted
> "Add support for the CBCMAC" series.
> 
> changes since v1:
> - rebased on top of DES library changes done on cryptodev/master
> - fixed crypto/Kconfig so that generic fallback is compiled as well
> 
> changes since v2:
> - made switch entry SAFEXCEL_AES explit and added empty default, as
>   requested by Antoine Tenart. Also needed to make SM4 patches apply.
> 
> changes since v3:
> - for rfc7539 and rfc7539esp, allow more (smaller) AAD lenghts to be
>   handled by the hardware instead of the fallback cipher (this allows
>   running the tcrypt performance tests on the actual hardware)
> 
> Pascal van Leeuwen (3):
>   crypto: inside-secure - Added support for the CHACHA20 skcipher
>   crypto: inside-secure - Add support for the Chacha20-Poly1305 AEAD
>   crypto: Kconfig - Add CRYPTO_CHACHA20POLY1305 to CRYPTO_DEV_SAFEXCEL
> 
>  drivers/crypto/Kconfig                         |   3 +-
>  drivers/crypto/inside-secure/safexcel.c        |   3 +
>  drivers/crypto/inside-secure/safexcel.h        |  11 +
>  drivers/crypto/inside-secure/safexcel_cipher.c | 336 ++++++++++++++++++++++++-
>  4 files changed, 339 insertions(+), 14 deletions(-)

All applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
