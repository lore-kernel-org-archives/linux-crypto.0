Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F0D0FC04A95
	for <linux-crypto@archiver.kernel.org>; Tue, 25 Oct 2022 12:53:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232568AbiJYMw7 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 25 Oct 2022 08:52:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232571AbiJYMwB (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 25 Oct 2022 08:52:01 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D11A315FF8
        for <linux-crypto@vger.kernel.org>; Tue, 25 Oct 2022 05:49:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3C9656190E
        for <linux-crypto@vger.kernel.org>; Tue, 25 Oct 2022 12:49:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A084BC43470
        for <linux-crypto@vger.kernel.org>; Tue, 25 Oct 2022 12:49:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666702151;
        bh=pn5WWsG1lQ2xaUHJwXQ9SZKo6QxRqX9z+SXjmgXixcs=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=t+KHtLRjdLlWfhrr9Q2yQouRsOg4ETNK1ksIA2JbBoUNuiT2Km9RUs/E5hv0O91n/
         A+mBABPZMhdpevR6lHaAPRhcSTrGufwzoruLLXPN1M4C/5gPMyV6+X8ok2wNXjG6z3
         VBY7DB5Qakw3OXitNLIBIhpIoNgjbpdmfQQ1K36ZAEK5IrgUEK3IsPoKv4w1y0E9Ge
         0gx+I/LpD87b2IvGDEOhULWJDHFe1ODxoTtEH0VUWfipAux0CxSkZvcXxFp9bDzxv/
         0oa+HTRhK+otTlIBCplhozfQ7dHsDYxLol+6gy8fGOtNt83qvXnqtcN8h/eL724gdu
         L9K3UQ3nkerlw==
Received: by mail-lf1-f52.google.com with SMTP id bp15so21681227lfb.13
        for <linux-crypto@vger.kernel.org>; Tue, 25 Oct 2022 05:49:11 -0700 (PDT)
X-Gm-Message-State: ACrzQf14TAqf6sdM2cRL9tES5+ZbLmxbf/fYE7jGcH9lk0IGeJunOyJ8
        Ka8q6+24KrcIoJNzgXNs/Jj+dRAAeRCbUrS4rg8=
X-Google-Smtp-Source: AMsMyM5GCKmayR9NRp+uYusbAnNCAOyFWswpu8M05PAh1gm645eBe/kUDqWfaXx41QayaPzxxblonU2WxGZ4Q/aj3Is=
X-Received: by 2002:ac2:4c47:0:b0:4a2:c07b:4b62 with SMTP id
 o7-20020ac24c47000000b004a2c07b4b62mr12946385lfk.426.1666702149638; Tue, 25
 Oct 2022 05:49:09 -0700 (PDT)
MIME-Version: 1.0
References: <20221024063052.109148-1-ardb@kernel.org> <20221024063052.109148-4-ardb@kernel.org>
 <Y1d07G+jIeGron7E@sol.localdomain>
In-Reply-To: <Y1d07G+jIeGron7E@sol.localdomain>
From:   Ard Biesheuvel <ardb@kernel.org>
Date:   Tue, 25 Oct 2022 14:48:57 +0200
X-Gmail-Original-Message-ID: <CAMj1kXFcaZLq98OVkov6g7xo43z1dj2Q1v9pt_ESYED6++pV0Q@mail.gmail.com>
Message-ID: <CAMj1kXFcaZLq98OVkov6g7xo43z1dj2Q1v9pt_ESYED6++pV0Q@mail.gmail.com>
Subject: Re: [PATCH v4 3/3] crypto: aesgcm - Provide minimal library implementation
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     linux-crypto@vger.kernel.org, herbert@gondor.apana.org.au,
        keescook@chromium.org, jason@zx2c4.com, nikunj@amd.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, 25 Oct 2022 at 07:32, Eric Biggers <ebiggers@kernel.org> wrote:
>
> On Mon, Oct 24, 2022 at 08:30:52AM +0200, Ard Biesheuvel wrote:
> > The former concern is addressed trivially, given that the function call
> > API uses 32-bit signed types for the input lengths. It is still up to
> > the caller to avoid IV reuse in general, but this is not something we
> > can police at the implementation level.
>
> This doesn't seem to have been any note left about this in the code itself.
> Sizes are usually size_t, so if another type is used intentionally, that should
> be carefully documented.
>
> Also, does it really need to be signed?
>

I'll add a comment in the code where the counter increment occurs.

Using int is easier because I can use signed comparison with 0 to
decide whether we are done. We don't need the range so unless someone
feels using unsigned int is essential here, I am going to leave it as
is.


> > +int __must_check aesgcm_decrypt(const struct aesgcm_ctx *ctx, u8 *dst,
> > +                             const u8 *src, int crypt_len, const u8 *assoc,
> > +                             int assoc_len, const u8 iv[GCM_AES_IV_SIZE],
> > +                             const u8 *authtag);
>
> This returns 0 or -EBADMSG, which is inconsistent with
> chacha20poly1305_decrypt() which returns a bool.  It would be nice if the
> different algorithms would use consistent conventions.
>

I'll change that.
