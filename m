Return-Path: <SRS0=USLa=UP=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 52ABCC31E54
	for <linux-crypto@archiver.kernel.org>; Sun, 16 Jun 2019 20:09:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 368D920862
	for <linux-crypto@archiver.kernel.org>; Sun, 16 Jun 2019 20:09:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727435AbfFPUJD (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 16 Jun 2019 16:09:03 -0400
Received: from s3.sipsolutions.net ([144.76.43.62]:49298 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727211AbfFPUJD (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 16 Jun 2019 16:09:03 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <johannes@sipsolutions.net>)
        id 1hcbST-00032L-Uf; Sun, 16 Jun 2019 22:08:58 +0200
Message-ID: <25dc2ee30a6a3eb855611c9fd5f6b2861dd0a518.camel@sipsolutions.net>
Subject: Re: [PATCH] wireless: airo: switch to skcipher interface
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Eric Biggers <ebiggers@kernel.org>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc:     linux-wireless@vger.kernel.org, kvalo@codeaurora.org,
        linux-crypto@vger.kernel.org, herbert@gondor.apana.org.au,
        Ondrej Zary <linux@rainbow-software.org>
Date:   Sun, 16 Jun 2019 22:08:55 +0200
In-Reply-To: <20190616071206.GB698@sol.localdomain> (sfid-20190616_091214_044457_F67F583B)
References: <20190614093603.22771-1-ard.biesheuvel@linaro.org>
         <20190616071206.GB698@sol.localdomain>
         (sfid-20190616_091214_044457_F67F583B)
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-2.fc28) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Sun, 2019-06-16 at 00:12 -0700, Eric Biggers wrote:
> 
> The actual crypto in this driver, on the other hand, looks very outdated and
> broken.  Apparently it's implementing some Cisco proprietary extension to WEP
> that uses a universal hashing based MAC, where the hash key is generated from
> AES-CTR.  But the MAC is only 32 bits, and the universal hash (MMH) is
> implemented incorrectly: there's an off-by-one error in emmh32_final() in the
> code that is supposed to be an optimized version of 'sum % ((1ULL << 32) + 15)'.
> 
> Do we know whether anyone is actually using this, or is this just another old
> driver that's sitting around unused?

I'd guess the latter, though as recent as 2015 Ondrej (CC'ed now)
actually changed something in the driver that wasn't just cleanups ...

Remove at least this weird Cisco WEP-with-AES-key-generation mode? That
must pre-date even TKIP?

johannes

