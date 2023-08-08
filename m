Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 59989C001B0
	for <linux-crypto@archiver.kernel.org>; Tue,  8 Aug 2023 19:18:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235939AbjHHTSL (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 8 Aug 2023 15:18:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236203AbjHHTR0 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 8 Aug 2023 15:17:26 -0400
X-Greylist: delayed 3516 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Tue, 08 Aug 2023 09:40:35 PDT
Received: from mo4-p00-ob.smtp.rzone.de (mo4-p00-ob.smtp.rzone.de [81.169.146.163])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A9AE3BCC8
        for <linux-crypto@vger.kernel.org>; Tue,  8 Aug 2023 09:40:35 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1691483998; cv=none;
    d=strato.com; s=strato-dkim-0002;
    b=DGAx9Cg3QA8tEJjjzbCxulKVwFbHTJl8DjXbf6pTlNYiLPR1HWrWnjkNJjGinLUjGT
    7twAkVnLRcSpoIg4iNL5C+FxltN4vQsT0NG/MX/EEZBw/l1r4P6pJCzo4aRQ+ykn1+H1
    N8MiM4WR11FW+3VYmf+xrmo28TfjCPSuoGat6CLMbyqhCcRJ1VHPxJUx6qQoKetp1rjM
    QWbUxBMzqgbFycChv78kK6PNiwhIWIcJscnrpLRmuMlf4VgglBB8suFmFAh1iwU3LqQP
    aUJl0ukMX1gjURYR2IQBgSFUgS3q0XPwBfuGNVRnM0xd2UQoo1Q6aIh9NXXmrqCZ0MaY
    KXnw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; t=1691483998;
    s=strato-dkim-0002; d=strato.com;
    h=References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Cc:Date:
    From:Subject:Sender;
    bh=MEWdpSEg5cjw5OnSUaYt561TSc8HMKFnFxpWpiCKcnA=;
    b=nQiIq51Q3Q4NXEtiB23AXvM0N5TfkNv3Dye5r2XvjdX002/fCJ3HCw3XTEtoGnj+dL
    ON/MvUykjcf9lH78So0R0E9AvL7Ei/n5jQdR37kiFF2R//aPCLelrsRysUY44vAIgGCb
    Eckgu/7dK0hQUUJVYRDcLrfllsYvAW2NtlavALOz/3+I7nQZPnNOSp7BUTnKYzvbousz
    JJf8tuMpLwunHwykw5fjGOaI+esOEOCnC47Y9pQrV6m4M1SuVJpfPpCnYpg5w0R1S6LB
    i1eQKLgNo89HJ0gfXpHSWp3u3E2WmppAmT36T0NIbLqkR91uooSiqb10YL55m/Yf6Fzt
    wtew==
ARC-Authentication-Results: i=1; strato.com;
    arc=none;
    dkim=none
X-RZG-CLASS-ID: mo00
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1691483998;
    s=strato-dkim-0002; d=chronox.de;
    h=References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Cc:Date:
    From:Subject:Sender;
    bh=MEWdpSEg5cjw5OnSUaYt561TSc8HMKFnFxpWpiCKcnA=;
    b=AWn6TSTCFcq6apUDoZsmQy5E4x5xTFKO3fkqmitvg0AfmpBCuBzcpoLUeJu62oSrno
    +cLkS9b9siCI8sAgcz152Aps109aUjALDb1czzIsNzvrIgB3XWDMrgmswBmqqnzO+S5U
    sZv/qaFmtgxfMehPkTFWjki4UeleEABTTXsLJAFbi84uFOAYgpNowyk1cmTXMW8FptUJ
    GYB1sdXLHyO9v5lhw28JAZdi3RQdt3Ep4BKHuG0Wi8sLkXcqGR7c5y28PXpiNVmnXHZw
    18c3cGwq37BMSsDRsJjqmh6yA0p6ltlk5dfZMKaZVPyr7+owZSYxqrv6bLaA771VqQ1l
    vlZQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; t=1691483998;
    s=strato-dkim-0003; d=chronox.de;
    h=References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Cc:Date:
    From:Subject:Sender;
    bh=MEWdpSEg5cjw5OnSUaYt561TSc8HMKFnFxpWpiCKcnA=;
    b=XVQNNA7T6hPvxOq/CQxreRTcXATAZldUpc1wmefYsn9jNnuPiodxzN4VaN7iQBiJvm
    viJ+nA3svPkZGrHsrvAQ==
X-RZG-AUTH: ":P2ERcEykfu11Y98lp/T7+hdri+uKZK8TKWEqNyiHySGSa9k9zT8DNpa83PXIbWPoyRDMA5OO2eg1c8O18guOvxN66+Sp0Pjdjtw="
Received: from positron.chronox.de
    by smtp.strato.de (RZmta 49.6.6 AUTH)
    with ESMTPSA id N24d58z788duEM0
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
        (Client did not present a certificate);
    Tue, 8 Aug 2023 10:39:56 +0200 (CEST)
From:   Stephan =?ISO-8859-1?Q?M=FCller?= <smueller@chronox.de>
To:     linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Joachim Vandersmissen <git@jvdsn.com>
Cc:     Joachim Vandersmissen <git@jvdsn.com>
Subject: Re: [PATCH] Add clarifying comments to Jitter Entropy RCT cutoff values.
Date:   Tue, 08 Aug 2023 10:37:55 +0200
Message-ID: <12260853.O9o76ZdvQC@positron.chronox.de>
In-Reply-To: <20230806191903.83423-1-git@jvdsn.com>
References: <20230806191903.83423-1-git@jvdsn.com>
MIME-Version: 1.0
Autocrypt: addr=smueller@chronox.de;
 keydata=
 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
 kBFBHm+xdudNab2U0OpfqrWerOw3WcGd2
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Am Sonntag, 6. August 2023, 21:19:03 CEST schrieb Joachim Vandersmissen:

Hi Joachim,

> The RCT cutoff values are correct, but they don't exactly match the ones
> one would expect when computing them using the formula in SP800-90B. This
> discrepancy is due to the fact that the Jitter Entropy RCT starts at 1. To
> avoid any confusion by future reviewers, add some comments and explicitly
> subtract 1 from the "correct" cutoff values in the definitions.
> 
> Signed-off-by: Joachim Vandersmissen <git@jvdsn.com>

Reviewed-by: Stephan Mueller <smueller@chronox.de>

Ciao
Stephan


