Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 104B4C433F5
	for <linux-crypto@archiver.kernel.org>; Fri, 26 Nov 2021 05:34:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358716AbhKZFh5 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 26 Nov 2021 00:37:57 -0500
Received: from helcar.hmeau.com ([216.24.177.18]:57162 "EHLO deadmen.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235633AbhKZFfz (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 26 Nov 2021 00:35:55 -0500
Received: from gondobar.mordor.me.apana.org.au ([192.168.128.4] helo=gondobar)
        by deadmen.hmeau.com with esmtp (Exim 4.92 #5 (Debian))
        id 1mqTqk-0008Rv-Ks; Fri, 26 Nov 2021 13:32:42 +0800
Received: from herbert by gondobar with local (Exim 4.92)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1mqTqk-0004aV-Hn; Fri, 26 Nov 2021 13:32:42 +0800
Date:   Fri, 26 Nov 2021 13:32:42 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Stephan =?iso-8859-1?Q?M=FCller?= <smueller@chronox.de>
Cc:     linux-crypto@vger.kernel.org
Subject: Re: [PATCH] crypto: RSA - limit key size to 2048 in FIPS mode
Message-ID: <20211126053242.GG17477@gondor.apana.org.au>
References: <25197881.1r3eYUQgxm@positron.chronox.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <25197881.1r3eYUQgxm@positron.chronox.de>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Sun, Nov 21, 2021 at 03:31:27PM +0100, Stephan Müller wrote:
> FIPS disallows RSA with keys < 2048 bits. Thus, the kernel should
> consider the enforcement of this limit.
> 
> Signed-off-by: Stephan Mueller <smueller@chronox.de>
> ---
>  crypto/rsa.c | 4 ++++
>  1 file changed, 4 insertions(+)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
