Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A64B0C54EE9
	for <linux-crypto@archiver.kernel.org>; Fri, 16 Sep 2022 10:49:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231226AbiIPKtc (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 16 Sep 2022 06:49:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232263AbiIPKtJ (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 16 Sep 2022 06:49:09 -0400
Received: from fornost.hmeau.com (helcar.hmeau.com [216.24.177.18])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B613B285E
        for <linux-crypto@vger.kernel.org>; Fri, 16 Sep 2022 03:28:21 -0700 (PDT)
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.103.7])
        by fornost.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1oZ8YJ-005GjF-Qr; Fri, 16 Sep 2022 20:26:33 +1000
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Fri, 16 Sep 2022 18:26:31 +0800
Date:   Fri, 16 Sep 2022 18:26:31 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Taehee Yoo <ap420073@gmail.com>
Cc:     linux-crypto@vger.kernel.org, davem@davemloft.net,
        tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com,
        jussi.kivilinna@iki.fi, elliott@hpe.com
Subject: Re: [PATCH v3 2/3] crypto: aria-avx: add AES-NI/AVX/x86_64/GFNI
 assembler implementation of aria cipher
Message-ID: <YyRPVxdZSAqvAXoL@gondor.apana.org.au>
References: <20220905094503.25651-1-ap420073@gmail.com>
 <20220905094503.25651-3-ap420073@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220905094503.25651-3-ap420073@gmail.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, Sep 05, 2022 at 09:45:02AM +0000, Taehee Yoo wrote:
>
> +struct aria_avx_ops aria_ops;

This creates a new sparse warning:

  CHECK   ../arch/x86/crypto/aria_aesni_avx_glue.c                                                                                                                                                                                                                                                                                                                                                                                        ../arch/x86/crypto/aria_aesni_avx_glue.c:34:21: warning: symbol 'aria_ops' was not declared. Should it be static?

Please fix.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
