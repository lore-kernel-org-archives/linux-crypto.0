Return-Path: <SRS0=xlya=UL=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 79BA8C31E46
	for <linux-crypto@archiver.kernel.org>; Wed, 12 Jun 2019 15:42:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4F52421734
	for <linux-crypto@archiver.kernel.org>; Wed, 12 Jun 2019 15:42:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1560354178;
	bh=FbKMGPiOg/+uKaQDYU3EJtrgMxGrwlzqTPjGSfDrFxo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=GcIDEqxff1opp6KbKeW5ToHBbyJ3HMZUjRGLIFIm+5/yQ2gPjmi4sBbxfMGMgwy4c
	 jRROqeKtRlCirCVfTrb57AHTy2wl8E1o5qOW7BN5WwQ4hVK5a2VhI2FAY7RfNEG8K9
	 RDkL+mUSd8KVnXTYlGsxAX4UlrVyCUcntVJ61j30=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2440106AbfFLPm5 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 12 Jun 2019 11:42:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:46910 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2440092AbfFLPm5 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 12 Jun 2019 11:42:57 -0400
Received: from sol.localdomain (c-24-5-143-220.hsd1.ca.comcast.net [24.5.143.220])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D2663215EA;
        Wed, 12 Jun 2019 15:42:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560354177;
        bh=FbKMGPiOg/+uKaQDYU3EJtrgMxGrwlzqTPjGSfDrFxo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=gFCw+o0QbpLkRk3e0Yy8MryfgdL8jtBu3zbhexKKFECGXHhd6P324iT1BxrIlT/m+
         7Ui72qoqHASnr/axLkSlCOSELXKoqDDKTIAKuX7l6PUl/+zOmBv11cFP1dkOpvqZvk
         nu3ZXp1CT7MWiO31wQIgrMHbmP30SOMqXofFMBL0=
Date:   Wed, 12 Jun 2019 08:42:55 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc:     linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [PATCH v4 4/7] net/lib80211: move TKIP handling to ARC4 library
 code
Message-ID: <20190612154255.GB680@sol.localdomain>
References: <20190611230938.19265-1-ard.biesheuvel@linaro.org>
 <20190611230938.19265-5-ard.biesheuvel@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190611230938.19265-5-ard.biesheuvel@linaro.org>
User-Agent: Mutt/1.12.0 (2019-05-25)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, Jun 12, 2019 at 01:09:35AM +0200, Ard Biesheuvel wrote:
> The crypto API abstraction is not very useful for invoking ciphers
> directly, especially in the case of arc4, which only has a generic
> implementation in C. So let's invoke the library code directly.
> 
> Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
> ---
>  net/wireless/lib80211_crypt_tkip.c | 48 +++++++-------------
>  1 file changed, 17 insertions(+), 31 deletions(-)
> 

Doesn't net/wireless/Kconfig also need to be updated to add 'select
CRYPTO_LIB_ARC4' to LIB80211_CRYPT_TKIP, like you did for LIB80211_CRYPT_WEP?

- Eric
