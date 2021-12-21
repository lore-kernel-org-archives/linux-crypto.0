Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 482FBC433F5
	for <linux-crypto@archiver.kernel.org>; Tue, 21 Dec 2021 10:52:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236785AbhLUKw4 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 21 Dec 2021 05:52:56 -0500
Received: from helcar.hmeau.com ([216.24.177.18]:58368 "EHLO fornost.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229761AbhLUKw4 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 21 Dec 2021 05:52:56 -0500
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.103.7])
        by fornost.hmeau.com with smtp (Exim 4.92 #5 (Debian))
        id 1mzclG-0007Ej-Sk; Tue, 21 Dec 2021 21:52:52 +1100
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Tue, 21 Dec 2021 21:52:50 +1100
Date:   Tue, 21 Dec 2021 21:52:50 +1100
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Ard Biesheuvel <ardb@kernel.org>, linux-crypto@vger.kernel.org,
        Sabrina Dubroca <sd@queasysnail.net>
Subject: Re: x86 AES crypto alignment
Message-ID: <YcGyAiGPKjFhna9x@gondor.apana.org.au>
References: <20211207113252.162701ed@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20211208044037.GA11399@gondor.apana.org.au>
 <20211207212907.6e91821b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20211220150343.4e12a4d2@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20211220161125.78bc4d66@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20211220165251.400813dc@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211220165251.400813dc@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, Dec 20, 2021 at 04:52:51PM -0800, Jakub Kicinski wrote:
>
> Something like this?
> 
> ---->8-----------
> 
> From: Jakub Kicinski <kuba@kernel.org>
> Date: Mon, 20 Dec 2021 16:29:26 -0800
> Subject: [PATCH] x86/aesni: don't require alignment

You need to send the patch with a new Subject line as otherwise
patchwork will ignore it.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
