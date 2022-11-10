Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 67857C4332F
	for <linux-crypto@archiver.kernel.org>; Thu, 10 Nov 2022 03:19:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232282AbiKJDTS (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 9 Nov 2022 22:19:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230120AbiKJDTS (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 9 Nov 2022 22:19:18 -0500
Received: from formenos.hmeau.com (helcar.hmeau.com [216.24.177.18])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 077B8286E4
        for <linux-crypto@vger.kernel.org>; Wed,  9 Nov 2022 19:19:14 -0800 (PST)
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
        by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1osy5G-00CP95-UH; Thu, 10 Nov 2022 11:19:08 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Thu, 10 Nov 2022 11:19:07 +0800
Date:   Thu, 10 Nov 2022 11:19:07 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Taehee Yoo <ap420073@gmail.com>
Cc:     linux-crypto@vger.kernel.org, davem@davemloft.net,
        tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com, hpa@zytor.com,
        kirill.shutemov@linux.intel.com, richard@nod.at,
        viro@zeniv.linux.org.uk,
        sathyanarayanan.kuppuswamy@linux.intel.com, jpoimboe@kernel.org,
        elliott@hpe.com, x86@kernel.org, jussi.kivilinna@iki.fi
Subject: Re: [PATCH v3 1/4] crypto: aria: add keystream array into struct
 aria_ctx
Message-ID: <Y2xtqyk72p5ylzAG@gondor.apana.org.au>
References: <20221106143627.30920-1-ap420073@gmail.com>
 <20221106143627.30920-2-ap420073@gmail.com>
 <Y2jGTvgHnu4QZV+D@gondor.apana.org.au>
 <51ed3735-24f0-eef0-0ca6-908c4581d143@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51ed3735-24f0-eef0-0ca6-908c4581d143@gmail.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, Nov 09, 2022 at 10:16:58PM +0900, Taehee Yoo wrote:
.
> I have encountered kernel panic(stack-out-of-bounds) while using the reqctx
> instead of the tfm.
> 
> cryptd is used when simd drivers are used.
> cryptd_skcipher_encrypt() internally doesn't allocate a request ctx of a
> child, instead, it uses stack memory with SYNC_SKCIPHER_REQUEST_ON_STACK.
> It retains only 384 bytes for child request ctx even if a child set a large
> reqsize value with crypto_skcipher_set_reqsize().
> aria-avx2 needs 512 bytes and aria-avx512 needs 1024 bytes.
> So, stack-out-of-bounds occurs.

That's not good.  Let me look into this.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
