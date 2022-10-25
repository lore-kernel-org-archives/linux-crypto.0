Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 92908C38A2D
	for <linux-crypto@archiver.kernel.org>; Tue, 25 Oct 2022 05:32:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229491AbiJYFcc (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 25 Oct 2022 01:32:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229597AbiJYFcb (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 25 Oct 2022 01:32:31 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B1B410F8A3
        for <linux-crypto@vger.kernel.org>; Mon, 24 Oct 2022 22:32:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B877661746
        for <linux-crypto@vger.kernel.org>; Tue, 25 Oct 2022 05:32:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0957C433D7;
        Tue, 25 Oct 2022 05:32:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666675950;
        bh=eoUq+qDRD06XalwYr/1zr8rSnoH2yIwW4iIoE6ZSenw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=f6w/bAdKmyY8rvfGv+EX/Z/MkZIvCnTXwo1IjtBQOWNyqV7RpCFCmfnYuTSTVFHHw
         tMTr5Jk2XSmzDvgg8F/ZFyYbLKA5Y9SQud4oIGwZUZAyItKFcxs8rx3JPyko/iBB9g
         f9R9zb/vznKLqy1pAGCVbYtxvcgy0NRRC4ovwjFLv2BUsxpEJE28uBbqwMzkhcfvWZ
         Mz5A0C+q5ZyUje2oYyfBfjIkGKhpe3lyaHrr4qH7DkywMmumMzKR2tIVJ4MNWXtAWn
         fgbOtnDIunZyb8hyr/Lz+LOOpml2R83SCX3NVB7lNzvF2o9BbnH7HKcRcEXYugQDyY
         jfNUd45rBJm1w==
Date:   Mon, 24 Oct 2022 22:32:28 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Ard Biesheuvel <ardb@kernel.org>
Cc:     linux-crypto@vger.kernel.org, herbert@gondor.apana.org.au,
        keescook@chromium.org, jason@zx2c4.com, nikunj@amd.com
Subject: Re: [PATCH v4 3/3] crypto: aesgcm - Provide minimal library
 implementation
Message-ID: <Y1d07G+jIeGron7E@sol.localdomain>
References: <20221024063052.109148-1-ardb@kernel.org>
 <20221024063052.109148-4-ardb@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221024063052.109148-4-ardb@kernel.org>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, Oct 24, 2022 at 08:30:52AM +0200, Ard Biesheuvel wrote:
> The former concern is addressed trivially, given that the function call
> API uses 32-bit signed types for the input lengths. It is still up to
> the caller to avoid IV reuse in general, but this is not something we
> can police at the implementation level.

This doesn't seem to have been any note left about this in the code itself.
Sizes are usually size_t, so if another type is used intentionally, that should
be carefully documented.

Also, does it really need to be signed?

> +int __must_check aesgcm_decrypt(const struct aesgcm_ctx *ctx, u8 *dst,
> +				const u8 *src, int crypt_len, const u8 *assoc,
> +				int assoc_len, const u8 iv[GCM_AES_IV_SIZE],
> +				const u8 *authtag);

This returns 0 or -EBADMSG, which is inconsistent with
chacha20poly1305_decrypt() which returns a bool.  It would be nice if the
different algorithms would use consistent conventions.

-  Eric
