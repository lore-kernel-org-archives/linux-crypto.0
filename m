Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 03CD1C4361A
	for <linux-crypto@archiver.kernel.org>; Wed, 12 May 2021 21:08:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DCA8361457
	for <linux-crypto@archiver.kernel.org>; Wed, 12 May 2021 21:08:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237322AbhELVIH (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 12 May 2021 17:08:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:53932 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1384947AbhELUFr (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 12 May 2021 16:05:47 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 07D4C613FB;
        Wed, 12 May 2021 20:04:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620849879;
        bh=KV/kbZd31J8snv17/g8BAEhBEHm7mAyytVKpZqg3zA0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=inc5AvJgcd9lavh0t/B/EzghYuDxnl7fL46NWCRgeeCX+fOBqrignfUptxNfGL8Eh
         YA5AEAHGbu6swO4mKkEiDRp3WZDo8PZ93qISy+1i2oQh31ZRIGxg+Na0rZIMdoPck4
         UD2VaiKq+YFruaRas2sSuAjUngZ34OgFXJW4yJJoRitM3lrB1EkF+inxNwBIZlw7TS
         6PA7XQaTN4ejeor5yFGLR5cZFI+ssWDJS5HkZQdnMUL48eMC7feJuW8MUzpvJubK4Z
         bqAGPhrGSSxM2bALvhos0Ek6JRJFszpGFDGj3y+kr4lNCZC3qYnXJfKN4+0w2TlGj2
         2fQr64TW/u7Kw==
Date:   Wed, 12 May 2021 13:04:37 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Ard Biesheuvel <ardb@kernel.org>
Cc:     linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        herbert@gondor.apana.org.au, will@kernel.org,
        kernel-team@android.com
Subject: Re: [PATCH v3 1/7] crypto: handle zero sized AEAD inputs correctly
Message-ID: <YJw01Z3oxwY5Sfpa@gmail.com>
References: <20210512184439.8778-1-ardb@kernel.org>
 <20210512184439.8778-2-ardb@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210512184439.8778-2-ardb@kernel.org>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, May 12, 2021 at 08:44:33PM +0200, Ard Biesheuvel wrote:
> There are corner cases where skcipher_walk_aead_[en|de]crypt() may be
> invoked with a zero sized input, which is not rejected by the walker
> code, but results in the skcipher_walk structure to not be fully
> initialized. This will leave stale values in its page and buffer
> members, which will be subsequently passed to kfree() or free_page() by
> skcipher_walk_done(), resulting in a crash if those routines fail to
> identify them as in valid inputs.
> 
> Fix this by setting page and buffer to NULL even if the size of the
> input is zero.
> 
> Signed-off-by: Ard Biesheuvel <ardb@kernel.org>

Is this fixing an existing bug, or only a bug that got exposed by this patchset?
It would be helpful to make that clear (and if it fixes an existing bug, include
a Fixes tag).

Also, skcipher_walk_virt() doesn't set page and buffer to NULL, as it is
currently expected that skcipher_walk_done() is only called when
walk.nbytes != 0.  Is something different for skcipher_walk_aead_[en|de]crypt()?

- Eric
