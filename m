Return-Path: <SRS0=NTKo=2I=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 60706C43603
	for <linux-crypto@archiver.kernel.org>; Wed, 18 Dec 2019 02:31:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 32183218AC
	for <linux-crypto@archiver.kernel.org>; Wed, 18 Dec 2019 02:31:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1576636315;
	bh=+2+lMNPi0U+eT91h2+f6zKMbgaAzj3SClczXbYgB7Zs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=mEdwfy0tgFjEZofiWVnjvIYs2u+5BD3g384IyGPxjwuaqHINB+8yPH4SYxJXHzksx
	 tAekSDx2iFO/JyXLa2Zw+OqIU6/l9/hLhK5rrueX45v5efE94RPtgq2Koj9cWadtZG
	 J9/VyJ9LL/ncd2nr5PTZERpb5CLPooSHtljkJ72o=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726487AbfLRCby (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 17 Dec 2019 21:31:54 -0500
Received: from mail.kernel.org ([198.145.29.99]:52982 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726401AbfLRCby (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 17 Dec 2019 21:31:54 -0500
Received: from sol.localdomain (c-24-5-143-220.hsd1.ca.comcast.net [24.5.143.220])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BDAF921582;
        Wed, 18 Dec 2019 02:31:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576636313;
        bh=+2+lMNPi0U+eT91h2+f6zKMbgaAzj3SClczXbYgB7Zs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=eOQB+UMpOHUqCprQIxk0uKn2kvQDlE27e6hnB8srqbwDRQr9yCDNOgTv5yHcam5Kb
         lj7JkR99XqTAEu2e4vWROlgoDRlIGjqHsibHQSB7OWqEDHTa0Ni549XILIG4Q5jsX7
         VAFHtp8orSL7ZSzZyxzwSk3toRdVkHf3IjrzFObI=
Date:   Tue, 17 Dec 2019 18:31:52 -0800
From:   Eric Biggers <ebiggers@kernel.org>
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc:     linux-crypto@vger.kernel.org, herbert@gondor.apana.org.au,
        Samuel Neves <sneves@dei.uc.pt>,
        Andy Polyakov <appro@openssl.org>
Subject: Re: [PATCH crypto-next v6 2/3] crypto: x86_64/poly1305 - add faster
 implementations
Message-ID: <20191218023152.GA3636@sol.localdomain>
References: <20191217174445.188216-1-Jason@zx2c4.com>
 <20191217174445.188216-3-Jason@zx2c4.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191217174445.188216-3-Jason@zx2c4.com>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, Dec 17, 2019 at 06:44:44PM +0100, Jason A. Donenfeld wrote:
> 
> While this is CRYPTOGAMS code, the originating code for this happens to
> be derived from OpenSSL's commit 4dfe4310c31c4483705991d9a798ce9be1ed1c68.

This doesn't make sense, since there are changes in this patch that are only in
the CRYPTOGAMS version, not in the OpenSSL 4dfe4310c31c version.

> 
> Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
> Co-developed-by: Samuel Neves <sneves@dei.uc.pt>
> Co-developed-by: Andy Polyakov <appro@openssl.org>

Each "Co-developed-by" always needs its own "Signed-off-by".
See Documentation/process/submitting-patches.rst

> diff --git a/arch/x86/crypto/poly1305-x86_64.pl b/arch/x86/crypto/poly1305-x86_64.pl
> new file mode 100644
> index 000000000000..f994855cdbe2
> --- /dev/null
> +++ b/arch/x86/crypto/poly1305-x86_64.pl
> @@ -0,0 +1,4266 @@
> +#!/usr/bin/env perl
> +# SPDX-License-Identifier: GPL-2.0 OR BSD-3-Clause
> +#
> +# Copyright (C) 2017-2018 Samuel Neves <sneves@dei.uc.pt>. All Rights Reserved.
> +# Copyright (C) 2017-2019 Jason A. Donenfeld <Jason@zx2c4.com>. All Rights Reserved.
> +# Copyright (C) 2006-2017 CRYPTOGAMS by <appro@openssl.org>. All Rights Reserved.
> +#
> +# This code is taken from the OpenSSL project but the author, Andy Polyakov,
> +# has relicensed it under the licenses specified in the SPDX header above.
> +# The original headers, including the original license headers, are
> +# included below for completeness.

And this says it's taken from the OpenSSL project, not CRYPTOGAMS.

Also how is this copyright 2006?  The newest date in either the OpenSSL or
CRYPTOGAMS versions is March 2015.

Also, can you elaborate on what changes have been made from version actually
being used in production in OpenSSL, and how those changes were vetted?  You
keep claiming that this implementation is extremely well vetted in comparison to
the kernel's existing implementation, so presumably you have something in mind.

- Eric
