Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D65D3C433EF
	for <linux-crypto@archiver.kernel.org>; Fri, 15 Oct 2021 11:19:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BADBE60EFF
	for <linux-crypto@archiver.kernel.org>; Fri, 15 Oct 2021 11:19:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238437AbhJOLVT (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 15 Oct 2021 07:21:19 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:56096 "EHLO deadmen.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238441AbhJOLVT (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 15 Oct 2021 07:21:19 -0400
Received: from gondobar.mordor.me.apana.org.au ([192.168.128.4] helo=gondobar)
        by deadmen.hmeau.com with esmtp (Exim 4.92 #5 (Debian))
        id 1mbLF2-00089v-CR; Fri, 15 Oct 2021 19:19:12 +0800
Received: from herbert by gondobar with local (Exim 4.92)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1mbLEz-0006mb-HX; Fri, 15 Oct 2021 19:19:09 +0800
Date:   Fri, 15 Oct 2021 19:19:09 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Ovidiu Panait <ovidiu.panait@windriver.com>
Cc:     linux-crypto@vger.kernel.org, bbrezillon@kernel.org,
        arno@natisbad.org, schalla@marvell.com
Subject: Re: [PATCH] crypto: octeontx2: set assoclen in aead_do_fallback()
Message-ID: <20211015111909.GB26012@gondor.apana.org.au>
References: <20211010163642.1383329-1-ovidiu.panait@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211010163642.1383329-1-ovidiu.panait@windriver.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Sun, Oct 10, 2021 at 04:36:42PM +0000, Ovidiu Panait wrote:
> Currently, in case of aead fallback, no associated data info is set in the
> fallback request. To fix this, call aead_request_set_ad() to pass the assoclen.
> 
> Fixes: 6f03f0e8b6c8 ("crypto: octeontx2 - register with linux crypto framework")
> Signed-off-by: Ovidiu Panait <ovidiu.panait@windriver.com>
> ---
>  drivers/crypto/marvell/octeontx2/otx2_cptvf_algs.c | 1 +
>  1 file changed, 1 insertion(+)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
