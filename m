Return-Path: <SRS0=J/bj=DC=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 73C82C4363D
	for <linux-crypto@archiver.kernel.org>; Fri, 25 Sep 2020 08:15:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 24BE6208A9
	for <linux-crypto@archiver.kernel.org>; Fri, 25 Sep 2020 08:15:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727685AbgIYIP1 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 25 Sep 2020 04:15:27 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:53270 "EHLO fornost.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727063AbgIYIP1 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 25 Sep 2020 04:15:27 -0400
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.0.7])
        by fornost.hmeau.com with smtp (Exim 4.92 #5 (Debian))
        id 1kLisp-0007C0-Ty; Fri, 25 Sep 2020 18:15:13 +1000
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Fri, 25 Sep 2020 18:15:11 +1000
Date:   Fri, 25 Sep 2020 18:15:11 +1000
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Nicolas Toromanoff <nicolas.toromanoff@st.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Ard Biesheuvel <ardb@kernel.org>, linux-crypto@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] crypto: stm32/crc32 - Avoid lock if hardware is
 already used
Message-ID: <20200925081511.GG6381@gondor.apana.org.au>
References: <20200916063344.15054-1-nicolas.toromanoff@st.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200916063344.15054-1-nicolas.toromanoff@st.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, Sep 16, 2020 at 08:33:44AM +0200, Nicolas Toromanoff wrote:
> If STM32 CRC device is already in use, calculate CRC by software.
> 
> This will release CPU constraint for a concurrent access to the
> hardware, and avoid masking irqs during the whole block processing.
> 
> Fixes: 7795c0baf5ac ("crypto: stm32/crc32 - protect from concurrent accesses")
> 
> Signed-off-by: Nicolas Toromanoff <nicolas.toromanoff@st.com>
> ---
> v2: select CRC32 and not (CRYPTO_CRC32 and CRYPTO_CRC32C) in Kconfig
> ---
>  drivers/crypto/stm32/Kconfig       |  1 +
>  drivers/crypto/stm32/stm32-crc32.c | 15 ++++++++++++---
>  2 files changed, 13 insertions(+), 3 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
