Return-Path: <SRS0=Ux5j=YQ=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7C728CA9EA0
	for <linux-crypto@archiver.kernel.org>; Wed, 23 Oct 2019 03:12:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3F7CF21906
	for <linux-crypto@archiver.kernel.org>; Wed, 23 Oct 2019 03:12:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1571800359;
	bh=BxUK91/M+YWCaDkNl/CLZhfosu+hGHtgWdkVtNETawc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=aWdWabt/Di0iaB94lbtGLpnvjNG2Jw//eqn8GN2hw704BWAE4/jh9NTmBWuvWeh0K
	 kZ2VBbaXCQkCvdzxYvQ2Wgi3qEl0GOVTUDxagAwmVaWmMaJdFmM8xa3DJK6ws2QIRu
	 j+DCviYJB2zier6XZcQ4NrWwuwt3XFBv7YAXsgRw=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729666AbfJWDMi (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 22 Oct 2019 23:12:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:47718 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727403AbfJWDMi (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 22 Oct 2019 23:12:38 -0400
Received: from sol.localdomain (c-24-5-143-220.hsd1.ca.comcast.net [24.5.143.220])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D8463214B2;
        Wed, 23 Oct 2019 03:12:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1571800358;
        bh=BxUK91/M+YWCaDkNl/CLZhfosu+hGHtgWdkVtNETawc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=f6mh52GtyNeFXsUl+M9Mcj5IrdtcqGEiKoP7HBh3RdR64b7GLml6zbmCtTXhiY/Gg
         IVjb1xYjZD2zQIc5XZLrWllhmuWd7NCM9c/Rv+BoE978/GlZ4IyOVDeAZxHRrPCI0X
         YBIsBaN9SKRTNuQ91hzrjXCnolGyY8cFfkx+tnyQ=
Date:   Tue, 22 Oct 2019 20:12:36 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc:     linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>,
        David Miller <davem@davemloft.net>,
        "Jason A . Donenfeld" <Jason@zx2c4.com>,
        Samuel Neves <sneves@dei.uc.pt>, Arnd Bergmann <arnd@arndb.de>,
        Andy Lutomirski <luto@kernel.org>,
        Martin Willi <martin@strongswan.org>,
        Rene van Dorst <opensource@vdorst.com>,
        David Sterba <dsterba@suse.com>
Subject: Re: [PATCH v4 02/35] crypto: chacha - move existing library code
 into lib/crypto
Message-ID: <20191023031236.GD4278@sol.localdomain>
Mail-Followup-To: Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>,
        David Miller <davem@davemloft.net>,
        "Jason A . Donenfeld" <Jason@zx2c4.com>,
        Samuel Neves <sneves@dei.uc.pt>, Arnd Bergmann <arnd@arndb.de>,
        Andy Lutomirski <luto@kernel.org>,
        Martin Willi <martin@strongswan.org>,
        Rene van Dorst <opensource@vdorst.com>,
        David Sterba <dsterba@suse.com>
References: <20191017190932.1947-1-ard.biesheuvel@linaro.org>
 <20191017190932.1947-3-ard.biesheuvel@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191017190932.1947-3-ard.biesheuvel@linaro.org>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, Oct 17, 2019 at 09:08:59PM +0200, Ard Biesheuvel wrote:
> diff --git a/lib/crypto/libchacha.c b/lib/crypto/libchacha.c
> new file mode 100644
> index 000000000000..7b4b97811f71
> --- /dev/null
> +++ b/lib/crypto/libchacha.c
> @@ -0,0 +1,35 @@
> +// SPDX-License-Identifier: GPL-2.0-or-later
> +/*
> + * The "hash function" used as the core of the ChaCha stream cipher (RFC7539)
> + *
> + * Copyright (C) 2015 Martin Willi
> + */

This new file actually contains the ChaCha stream cipher, not the ChaCha core.
So this file comment is incorrect.

- Eric
