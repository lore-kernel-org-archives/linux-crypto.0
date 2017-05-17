From: Matthias Kaehlcke <mka@chromium.org>
Subject: Re: [PATCH] crypto: arm64/sha - avoid non-standard inline asm tricks
Date: Wed, 17 May 2017 11:10:13 -0700
Message-ID: <20170517181013.GF141096@google.com>
References: <20170426161132.11311-1-ard.biesheuvel@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Cc: linux-crypto@vger.kernel.org, herbert@gondor.apana.org.au
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-pf0-f170.google.com ([209.85.192.170]:35003 "EHLO
        mail-pf0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752764AbdEQSKP (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 17 May 2017 14:10:15 -0400
Received: by mail-pf0-f170.google.com with SMTP id n23so11149077pfb.2
        for <linux-crypto@vger.kernel.org>; Wed, 17 May 2017 11:10:15 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <20170426161132.11311-1-ard.biesheuvel@linaro.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

El Wed, Apr 26, 2017 at 05:11:32PM +0100 Ard Biesheuvel ha dit:

> Replace the inline asm which exports struct offsets as ELF symbols
> with proper const variables exposing the same values. This works
> around an issue with Clang which does not interpret the "i" (or "I")
> constraints in the same way as GCC.
> 
> Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
> ---
>  arch/arm64/crypto/sha1-ce-core.S |  6 ++++--
>  arch/arm64/crypto/sha1-ce-glue.c | 11 +++--------
>  arch/arm64/crypto/sha2-ce-core.S |  6 ++++--
>  arch/arm64/crypto/sha2-ce-glue.c | 13 +++++--------
>  4 files changed, 16 insertions(+), 20 deletions(-)

Herbert, do you plan to pick this up?

Thanks

Matthias
