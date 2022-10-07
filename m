Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 46BEAC433F5
	for <linux-crypto@archiver.kernel.org>; Fri,  7 Oct 2022 15:31:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229964AbiJGPbA (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 7 Oct 2022 11:31:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230039AbiJGPa7 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 7 Oct 2022 11:30:59 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03FF88263A
        for <linux-crypto@vger.kernel.org>; Fri,  7 Oct 2022 08:30:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B2285B82369
        for <linux-crypto@vger.kernel.org>; Fri,  7 Oct 2022 15:30:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BEAAAC433C1;
        Fri,  7 Oct 2022 15:30:54 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
        dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="Ac0lfxJM"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
        t=1665156653;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=LvctwWh59x04o6QvggrjHW4fwKOToje16pPaZcjYBSc=;
        b=Ac0lfxJMtAn39FVFvj7IRdU9t/ZWzSWuuilczXKgyhS1H1FOMEw0VyKQRYA9uLSE2sGlp8
        yUx2Kt3GUYAX0SwIaD81ymxP8mTCWxf1o14/FQMzr/C88aAL33kFznh5yPHDj5qkI81JnL
        SMG7gJmCkFSnyF7pIQhB68MuF6wdwnc=
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 4f44fcbf (TLSv1.3:TLS_AES_256_GCM_SHA384:256:NO);
        Fri, 7 Oct 2022 15:30:53 +0000 (UTC)
Date:   Fri, 7 Oct 2022 17:30:52 +0200
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
To:     Ard Biesheuvel <ardb@kernel.org>
Cc:     linux-crypto@vger.kernel.org, herbert@gondor.apana.org.au,
        ebiggers@kernel.org, keescook@chromium.org,
        "Nikunj A. Dadhania" <nikunj@amd.com>
Subject: Re: [PATCH] crypto: gcm - Provide minimal library implementation
Message-ID: <Y0BGLKzJ1tzuYgxf@zx2c4.com>
References: <20221007152105.3057788-1-ardb@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20221007152105.3057788-1-ardb@kernel.org>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

I haven't looked at this in depth yet, but one thing jumped out:

On Fri, Oct 07, 2022 at 05:21:05PM +0200, Ard Biesheuvel wrote:
> Implement a minimal library version of GCM based on the existing library
>  include/crypto/gcm.h |  61 ++
>  lib/crypto/gcm.c     | 714 ++++++++++++++++++++
> +void gcm_encrypt(const struct gcm_ctx *ctx, u8 *dst, const u8 *src,
> +		 int crypt_len, const u8 *assoc, int assoc_len,
> +		 const u8 iv[GCM_AES_IV_SIZE], u8 *authtag);

This should probably all be aes_gcm, aes-gcm.[ch] LIB_AES_GCM and so
forth, since GCM is something that works with different block ciphers.

Jason
