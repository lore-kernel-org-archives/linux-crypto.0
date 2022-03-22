Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BF6DFC433F5
	for <linux-crypto@archiver.kernel.org>; Tue, 22 Mar 2022 05:55:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236788AbiCVF5Q (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 22 Mar 2022 01:57:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236725AbiCVF5P (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 22 Mar 2022 01:57:15 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DBC77FE7
        for <linux-crypto@vger.kernel.org>; Mon, 21 Mar 2022 22:55:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6BF6661419
        for <linux-crypto@vger.kernel.org>; Tue, 22 Mar 2022 05:55:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C148C340EC;
        Tue, 22 Mar 2022 05:55:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647928547;
        bh=gLdUkKAlmiTpQrG3mdMRpMilDdB2wIrUAvBUdPsop88=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=meSEzYHAsLhC1lnCXqWZIGTEwL3JW9h62JM8hzlXYYprHm+tXAhbPEJYaLFCFltOq
         trweziUaaBJgOuLFzxrZObRSpd2fMUV0jc2SToGIXlAVE9xYhyXJKtUlhZpCR70r2b
         S36oUYWZ7gADTxtaEes/jwBNigpWMIs1efGnlyoH9MvW/HvQrFriGOw4bM6ridMxOT
         Fr23oMu4r9X2FsOjeeBEkBc4+NhNcqFXR/xQZduDp+/pR5BhCXprcUV7033JXtxsOf
         7G90YS+vQQad4XZDqNAWRRDY2tXG3lOgfC8h4yoCmWCWH8Yc5A347SAlZd55B1G2Xp
         1ngpfb3qUDeLw==
Date:   Mon, 21 Mar 2022 22:55:45 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Nathan Huckleberry <nhuck@google.com>
Cc:     linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        linux-arm-kernel@lists.infradead.org,
        Paul Crowley <paulcrowley@google.com>,
        Sami Tolvanen <samitolvanen@google.com>,
        Ard Biesheuvel <ardb@kernel.org>
Subject: Re: [PATCH v3 2/8] crypto: polyval - Add POLYVAL support
Message-ID: <Yjlk4WHNZqFSSY/n@sol.localdomain>
References: <20220315230035.3792663-1-nhuck@google.com>
 <20220315230035.3792663-3-nhuck@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220315230035.3792663-3-nhuck@google.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, Mar 15, 2022 at 11:00:29PM +0000, Nathan Huckleberry wrote:
> Add support for POLYVAL, an ε-Δ-universal hash function similar to
> GHASH.  POLYVAL is used as a component to implement HCTR2 mode.
> 
> POLYVAL is implemented as an shash algorithm.  The implementation is
> modified from ghash-generic.c.
> 
> More information on POLYVAL can be found in the HCTR2 paper:
> https://eprint.iacr.org/2021/1441.pdf
> 
> Signed-off-by: Nathan Huckleberry <nhuck@google.com>

Generally looks good, feel free to add:

	Reviewed-by: Eric Biggers <ebiggers@google.com>

But, I think you should mention that POLYVAL is originally from AES-GCM-SIV (RFC
8452).  It's true that the kernel doesn't implement AES-GCM-SIV currently, but
it's still important to mention.  Both the commit message and comment in
crypto/polyval-generic.c should mention this, IMO.  As-is, the only hint of this
in this patch is the comment above the test vectors.

Your explanation about how POLYVAL can be implemented on top of GHASH is also a
bit incomplete.  Linking to
https://datatracker.ietf.org/doc/html/rfc8452#appendix-A would be helpful.

- Eric
