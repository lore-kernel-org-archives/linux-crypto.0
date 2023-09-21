Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 285EEE7D0A2
	for <linux-crypto@archiver.kernel.org>; Thu, 21 Sep 2023 19:02:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230249AbjIUTCr (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 21 Sep 2023 15:02:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230466AbjIUTCP (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 21 Sep 2023 15:02:15 -0400
Received: from mo4-p01-ob.smtp.rzone.de (mo4-p01-ob.smtp.rzone.de [81.169.146.164])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3BD3D5B425
        for <linux-crypto@vger.kernel.org>; Thu, 21 Sep 2023 10:50:12 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1695297007; cv=none;
    d=strato.com; s=strato-dkim-0002;
    b=oQr4UuGd8BWqie7aw+GNiHbred43iPOwCGt6lC3y+Uv6pekcKnCHtN3gai5ngtkmB1
    k7VinWdJ2S+nMQYUd0hXefffhBnR1xc1IFPgHAsrNKPqwWpTmGhgcFjwDABh1oURFPEK
    QEHvJWLUCkYyoc5aVYjE7mckpQm+JTQhj92ZerxxMnVvIjzJxLICzWzpTk3/fSibM2so
    s7gr8TRJ+ZJeszb0/PUNhkXHe/g0T545lTE6ndcm7PzwyqOpgOkQ+mZ0AytbQ6YXHEc9
    wtYivvXUEtBGnJOHQfPV7N/fCjoEnB/sKvF3AqbcrqQi5MVwqBbwAaRKEVLCknnjIH2h
    uIjQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; t=1695297007;
    s=strato-dkim-0002; d=strato.com;
    h=Message-ID:Date:Subject:Cc:To:From:Cc:Date:From:Subject:Sender;
    bh=Y7oc1e7VzpHy9j44QZCh3LbJh161ylUkNpGdYaBapss=;
    b=AUUVAP0Ji6Wmk36qO49B6ZWzE2Y7w3ifY3U09c6L3XAg00xQbeVnRm/jAnhg6WWnd/
    7ypeBfsHIrF9/a3Njt+jsqjgxuBYF9EnErgJ5zzXGPg30VDQTW/WmhY+7nX1YXvlBbvC
    n9CnSedP+YMLCyt/DkzYu0SthUdPyJV70yYjeQZkkXdl90pAKZGpsoBHjYHAp4RiSpOq
    C3c/LrzigseRWVdfFzodcHgpdKRoV1lKFEVYMPsMFYC4/X44RKucknttTo9w8m/t0PLc
    sqoDaMCgfjJaKA82gvKNHGsMU6uHeLC6Slx/QUl7rT4UHCnJOfvcdwwQ6H5i461Bk8eC
    lPcg==
ARC-Authentication-Results: i=1; strato.com;
    arc=none;
    dkim=none
X-RZG-CLASS-ID: mo01
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1695297007;
    s=strato-dkim-0002; d=chronox.de;
    h=Message-ID:Date:Subject:Cc:To:From:Cc:Date:From:Subject:Sender;
    bh=Y7oc1e7VzpHy9j44QZCh3LbJh161ylUkNpGdYaBapss=;
    b=aZO01IRqzXib+u2Nn0p9e4A/CquGMGFm/XQ/jM2YNjyU9YUnlZISGdP+VkfywHEVTa
    BM6FG4r1+ZIxNU1TJ/BvD+671/DynQoCpEGc60dNhFUyuEW8JefyjBpJiUQLJPEqwUSZ
    Xzbc/txS8XCu/6+lHD4ADfuj4Jqgi2mMX/9YdSlsb31+fBZGQWWf5XCubLzIaoJVod2B
    OHwxtA2hKdYEOEo3Sg1hNAqHIieYjlc5qXHVUjdsG9hao3SKHi2oPE5bxOXrf1nfpMGW
    uPtVVVNJZJV+MCn40YrwMtopgqQ7n8RQ56ie47JeOxDcIZajqNWEDTfbVzLuizqTXni6
    Sc7Q==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; t=1695297007;
    s=strato-dkim-0003; d=chronox.de;
    h=Message-ID:Date:Subject:Cc:To:From:Cc:Date:From:Subject:Sender;
    bh=Y7oc1e7VzpHy9j44QZCh3LbJh161ylUkNpGdYaBapss=;
    b=eEYRuey8CZxpxBjICEPezGtRxXlqxdOUQDoWLc27yotnaRqC9pKWo/PcjOwZQiqJ4a
    PtZ8Ly823xV7bm29WGBA==
X-RZG-AUTH: ":P2ERcEykfu11Y98lp/T7+hdri+uKZK8TKWEqNyiHySGSa9k9yGwdNoa/n6V4wJnv+Q=="
Received: from positron.chronox.de
    by smtp.strato.de (RZmta 49.8.2 AUTH)
    with ESMTPSA id u045efz8LBo68te
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
        (Client did not present a certificate);
    Thu, 21 Sep 2023 13:50:06 +0200 (CEST)
From:   Stephan =?ISO-8859-1?Q?M=FCller?= <smueller@chronox.de>
To:     herbert@gondor.apana.org.au
Cc:     linux-crypto@vger.kernel.org, "Ospan, Abylay" <aospan@amazon.com>
Subject: [PATCH 0/3] crypto: jitter - Offer compile-time options
Date:   Thu, 21 Sep 2023 13:47:32 +0200
Message-ID: <2700818.mvXUDI8C0e@positron.chronox.de>
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

Hi,

the following patchset offers a set of compile-time options to
accommodate different hardware with different entropy rates implied
in their timers. This allows configuring the Jitter RNG in systems
which exhibits insufficient entropy with the default parameters. The
default parameters defined by the patches, however, are identical to
the existing code and thus do not alter the Jitter RNG behavior.

The first patch sets the state by allowing the configuration of
different oversampling rates. The second patch allows the configuration
of different memory sizes and the third allows the configuration
of differnet oversampling rates.

The update of the power up test with the first patch also addresses
reports that the Jitter RNG did not initialize due to it detected
insufficient entropy.

Stephan Mueller (3):
  crypto: jitter - add RCT/APT support for different OSRs
  crypto: jitter - Allow configuration of memory size
  crypto: jitter - Allow configuration of oversampling rate

 crypto/Kconfig               |  60 +++++++++
 crypto/jitterentropy-kcapi.c |  17 ++-
 crypto/jitterentropy.c       | 249 ++++++++++++++++++-----------------
 crypto/jitterentropy.h       |   5 +-
 4 files changed, 207 insertions(+), 124 deletions(-)

-- 
2.42.0




