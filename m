Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C1E57C54EBE
	for <linux-crypto@archiver.kernel.org>; Mon, 16 Jan 2023 08:10:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232062AbjAPIKc (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 16 Jan 2023 03:10:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232326AbjAPIIH (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 16 Jan 2023 03:08:07 -0500
Received: from formenos.hmeau.com (helcar.hmeau.com [216.24.177.18])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B017524F
        for <linux-crypto@vger.kernel.org>; Mon, 16 Jan 2023 00:06:41 -0800 (PST)
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
        by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1pHKVq-000Pgl-8m; Mon, 16 Jan 2023 16:06:39 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Mon, 16 Jan 2023 16:06:38 +0800
Date:   Mon, 16 Jan 2023 16:06:38 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Ard Biesheuvel <ardb@kernel.org>
Cc:     linux-crypto@vger.kernel.org, Eric Biggers <ebiggers@kernel.org>
Subject: Re: [PATCH v2 0/4] crypto: Accelerated GCM for IPSec on ARM/arm64
Message-ID: <Y8UFjlyFqg+uddZ5@gondor.apana.org.au>
References: <20221214171957.2833419-1-ardb@kernel.org>
 <CAMj1kXG_btjHUVpN9m5NoBdFv=3JWt-piPx_u40KTv70CC-sRQ@mail.gmail.com>
 <Y8TEqNJuEmWE5Tg/@gondor.apana.org.au>
 <CAMj1kXExpt4U64ncX6wSU_0zLNNQGiP3RFGNbAXwpuBjeV=fPg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMj1kXExpt4U64ncX6wSU_0zLNNQGiP3RFGNbAXwpuBjeV=fPg@mail.gmail.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, Jan 16, 2023 at 08:40:09AM +0100, Ard Biesheuvel wrote:
>
> Will you be taking the rest of the series? (patches #2 - #4). Or we
> might defer this to v6.4 entirely it if makes things easier. (The
> other changes really shouldn't go through the ARM tree)

I had assumed they were dependent.  But they do seem to make sense
on their own so yes I can certainly take patches 2-4.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
