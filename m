Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8C964C05027
	for <linux-crypto@archiver.kernel.org>; Tue, 14 Feb 2023 08:50:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232109AbjBNIuR (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 14 Feb 2023 03:50:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232086AbjBNIuJ (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 14 Feb 2023 03:50:09 -0500
Received: from formenos.hmeau.com (167-179-156-38.a7b39c.syd.nbn.aussiebb.net [167.179.156.38])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08B5E1EBD1
        for <linux-crypto@vger.kernel.org>; Tue, 14 Feb 2023 00:50:05 -0800 (PST)
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
        by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1pRr0h-00Ay4A-FX; Tue, 14 Feb 2023 16:50:00 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Tue, 14 Feb 2023 16:49:59 +0800
Date:   Tue, 14 Feb 2023 16:49:59 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Taehee Yoo <ap420073@gmail.com>
Cc:     linux-crypto@vger.kernel.org, davem@davemloft.net, x86@kernel.org,
        erhard_f@mailbox.org
Subject: Re: [PATCH] crypto: x86/aria-avx - fix using avx2 instructions
Message-ID: <Y+tLN7jRWEUF52Js@gondor.apana.org.au>
References: <20230210181541.2895144-1-ap420073@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230210181541.2895144-1-ap420073@gmail.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, Feb 10, 2023 at 06:15:41PM +0000, Taehee Yoo wrote:
> vpbroadcastb and vpbroadcastd are not AVX instructions.
> But the aria-avx assembly code contains these instructions.
> So, kernel panic will occur if the aria-avx works on AVX2 unsupported
> CPU.
> 
> vbroadcastss, and vpshufb are used to avoid using vpbroadcastb in it.
> Unfortunately, this change reduces performance by about 5%.
> Also, vpbroadcastd is simply replaced by vmovdqa in it.
> 
> Fixes: ba3579e6e45c ("crypto: aria-avx - add AES-NI/AVX/x86_64/GFNI assembler implementation of aria cipher")
> Reported-by: Herbert Xu <herbert@gondor.apana.org.au>
> Reported-by: Erhard F. <erhard_f@mailbox.org>
> Signed-off-by: Taehee Yoo <ap420073@gmail.com>
> ---
> 
> My CPU supports AVX2.
> So, I disabled AVX2 with QEMU.
> In the VM, lscpu doesn't show AVX2, but kernel panic didn't occur.
> Therefore, I couldn't reproduce kernel panic.
> I will really appreciate it if someone test this patch.
> 
>  arch/x86/crypto/aria-aesni-avx-asm_64.S | 134 +++++++++++++++++-------
>  1 file changed, 94 insertions(+), 40 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
