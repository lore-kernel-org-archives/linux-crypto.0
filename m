Return-Path: <SRS0=xlya=UL=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 362EDC31E46
	for <linux-crypto@archiver.kernel.org>; Wed, 12 Jun 2019 19:21:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0660E20B7C
	for <linux-crypto@archiver.kernel.org>; Wed, 12 Jun 2019 19:21:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727496AbfFLTVq (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 12 Jun 2019 15:21:46 -0400
Received: from s3.sipsolutions.net ([144.76.43.62]:55108 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727443AbfFLTVq (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 12 Jun 2019 15:21:46 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <johannes@sipsolutions.net>)
        id 1hb8oX-0006v6-EC; Wed, 12 Jun 2019 21:21:41 +0200
Message-ID: <5fc4b94a1b4abe6b79ce7e20ddf26e762f1b687d.camel@sipsolutions.net>
Subject: Re: [PATCH v5 0/7] crypto: rc4 cleanup
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        linux-crypto@vger.kernel.org
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Biggers <ebiggers@google.com>
Date:   Wed, 12 Jun 2019 21:21:39 +0200
In-Reply-To: <20190612161959.30478-1-ard.biesheuvel@linaro.org> (sfid-20190612_182005_417614_E8F05E5C)
References: <20190612161959.30478-1-ard.biesheuvel@linaro.org>
         (sfid-20190612_182005_417614_E8F05E5C)
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-2.fc28) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, 2019-06-12 at 18:19 +0200, Ard Biesheuvel wrote:
> This is a follow-up to, and supersedes [0], which moved some WEP code from
> the cipher to the skcipher interface, in order to reduce the use of the bare
> cipher interface in non-crypto subsystem code.
> 
> Since using the skcipher interface to invoke the generic C implementation of
> an algorithm that is known at compile time is rather pointless, this series
> moves those users to a new arc4 library interface instead, which is based on
> the existing code.
> 
> Along the way, the arc4 cipher implementation is removed entirely, and only
> the ecb(arc4) code is preserved, which is used in a number of places in the
> kernel, and is known to be used by at least 'iwd' from user space via the
> algif_skcipher API.

[...]

Looks good to me.

Reviewed-by: Johannes Berg <johannes@sipsolutions.net>

(most closely the first 4 patches)

How do you want to handle merging this? I guess keeping all the patches
together would be good. I have no objection to the mac80211/lib80211
patches going through any arbitrary tree, this code is hardly ever
touched, so highly unlikely to lead to conflicts.

johannes


