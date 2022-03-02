Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DA699C433F5
	for <linux-crypto@archiver.kernel.org>; Wed,  2 Mar 2022 00:25:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232559AbiCBA0Q (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 1 Mar 2022 19:26:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230090AbiCBA0Q (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 1 Mar 2022 19:26:16 -0500
Received: from fornost.hmeau.com (helcar.hmeau.com [216.24.177.18])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C2A98CD8B;
        Tue,  1 Mar 2022 16:25:34 -0800 (PST)
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.103.7])
        by fornost.hmeau.com with smtp (Exim 4.92 #5 (Debian))
        id 1nPCmz-0007yo-En; Wed, 02 Mar 2022 11:24:22 +1100
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Wed, 02 Mar 2022 12:24:21 +1200
Date:   Wed, 2 Mar 2022 12:24:21 +1200
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc:     Tianjia Zhang <tianjia.zhang@linux.alibaba.com>,
        "David S. Miller" <davem@davemloft.net>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Gilad Ben-Yossef <gilad@benyossef.com>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        "Markku-Juhani O . Saarinen" <mjos@iki.fi>,
        Jussi Kivilinna <jussi.kivilinna@iki.fi>, x86@kernel.org,
        linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] crypto: sm4 - create SM4 library based on sm4
 generic code
Message-ID: <Yh65NU6TwcvW/VZV@gondor.apana.org.au>
References: <20210610134459.28541-1-tianjia.zhang@linux.alibaba.com>
 <20210610134459.28541-2-tianjia.zhang@linux.alibaba.com>
 <Yh32tEhUgGeSXf/A@zx2c4.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Yh32tEhUgGeSXf/A@zx2c4.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, Mar 01, 2022 at 11:34:28AM +0100, Jason A. Donenfeld wrote:
> >  lib/crypto/Kconfig   |   3 +
> >  lib/crypto/Makefile  |   3 +
> >  lib/crypto/sm4.c     | 184 +++++++++++++++++++++++++++++++++++++++++++
> 
> If this is only used by the crypto API, it does not belong in
> lib/crypto.

Nope there is no such rule.  lib/crypto is fine if you're adding
code that is shared between crypto and arch/*/crypto.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
