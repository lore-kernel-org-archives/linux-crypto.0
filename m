Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A5999C04FF3
	for <linux-crypto@archiver.kernel.org>; Mon, 24 May 2021 21:46:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 89BA561413
	for <linux-crypto@archiver.kernel.org>; Mon, 24 May 2021 21:46:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233855AbhEXVsK (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 24 May 2021 17:48:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:49032 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233353AbhEXVsJ (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 24 May 2021 17:48:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0919F613FC;
        Mon, 24 May 2021 21:46:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1621892801;
        bh=1RUpzx4qV06/oeotNt0xJiGBMPVJNhRCtiteIVtj0ck=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=H+k5wdLQgW9QAN5M2OYczvI9SH1+LzBQpMuxnPzqsq6qyI+gl+v1JiKkA2pUaORWB
         rUIyz9R9JLVikQJuaIre5GMnDaf12GuuylmN3QAgw+5JBOj4RjWjooNCWL0MKvSK86
         BnSeNB+IJs5cK0s1l8jfGCCuLW9YO1/brQZQVJoeTBKDO6DxY7/avLmK9ij0gxm3sL
         D2IhRewtHdb5gEF7Wla0ZwTNt5DoRg950Txtfbviz7qMvGRFZ/1L00RU9u9wt+wIuw
         tQbXuzH/dmwp0h2l0oN6fMePWZnwNPwtJavJh6BTPT85qKDIQT9gXETJxDxiLe6TbK
         Ym4yPhpXXIMgQ==
Date:   Mon, 24 May 2021 14:46:39 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Ard Biesheuvel <ardb@kernel.org>
Cc:     linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        herbert@gondor.apana.org.au, will@kernel.org,
        kernel-team@android.com
Subject: Re: [PATCH v5 2/5] crypto: arm64/aes-neonbs - stop using SIMD helper
 for skciphers
Message-ID: <YKwev/vic+V+PAW+@gmail.com>
References: <20210521102053.66609-1-ardb@kernel.org>
 <20210521102053.66609-3-ardb@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210521102053.66609-3-ardb@kernel.org>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, May 21, 2021 at 12:20:50PM +0200, Ard Biesheuvel wrote:
> Calls into the skcipher API can only occur from contexts where the SIMD
> unit is available, so there is no need for the SIMD helper.
> 
> Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
> ---
>  arch/arm64/crypto/Kconfig           |   2 -
>  arch/arm64/crypto/aes-neonbs-glue.c | 122 ++------------------
>  2 files changed, 9 insertions(+), 115 deletions(-)

Reviewed-by: Eric Biggers <ebiggers@google.com>
