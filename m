Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 471B9C433EF
	for <linux-crypto@archiver.kernel.org>; Tue, 11 Jan 2022 08:04:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348784AbiAKIET (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 11 Jan 2022 03:04:19 -0500
Received: from mo4-p01-ob.smtp.rzone.de ([81.169.146.165]:41523 "EHLO
        mo4-p01-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231561AbiAKIET (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 11 Jan 2022 03:04:19 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1641888258;
    s=strato-dkim-0002; d=chronox.de;
    h=Message-ID:Date:Subject:Cc:To:From:Cc:Date:From:Subject:Sender;
    bh=RyC/DE9ZHWl69YCzntvZRz+LaUB0zPr483mjGfr4JNQ=;
    b=kTYUJadF7rBDAuyGjswbbhee9vjmDwjAP557WKyoSCyHuVD3cPXt6/XToPiTGar4LW
    r7dham6p+nkqAFtk/LNHzeHT5H9leD6+1C4QHmMHus8KYWaZYf5QDY8CQT6UwMRbOp5v
    Deu06MSIvaBlRpt5jmnxSqDgOc86ue66aptMf43JQQ+b1C5EOtmY0oCdH87LPtb5iaSQ
    MNU2kN9iRnJwAAaS3C5QGIM5zSfmS2DImQ9ifre0j3YnhWpLF6iKH1KjYqjeFCLoOggq
    ZAuC2G/Gn/pkRD+KSpak2AYRC+K8VMzHmRQ5vcJNig+xh7GbcOOBipKEPc09ARuPcJ+V
    fyVg==
Authentication-Results: strato.com;
    dkim=none
X-RZG-AUTH: ":P2ERcEykfu11Y98lp/T7+hdri+uKZK8TKWEqNyiHySGSa9k9xmwdNnzGHXPaIvSbY0c="
X-RZG-CLASS-ID: mo00
Received: from positron.chronox.de
    by smtp.strato.de (RZmta 47.37.6 DYNA|AUTH)
    with ESMTPSA id t60e2cy0B84HGpx
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
        (Client did not present a certificate);
    Tue, 11 Jan 2022 09:04:17 +0100 (CET)
From:   Stephan =?ISO-8859-1?Q?M=FCller?= <smueller@chronox.de>
To:     herbert@gondor.apana.org.au
Cc:     linux-crypto@vger.kernel.org
Subject: CRYPTO_NOLOAD
Date:   Tue, 11 Jan 2022 09:04:16 +0100
Message-ID: <2191439.vFx2qVVIhK@positron.chronox.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi Herbert,

I am experimenting with additional flags like CRYPTO_NOLOAD. When I allocate 
an skcipher with this flag (crypto_alloc_skcipher("name", 0, CRYPTO_NOLOAD)), 
a loading of new modules is performed, in particular for subordinated algos 
(e.g. I try to load ctr(aes) which then in turn tries to resolve the AESNI 
implementation which in turn loads the cryptd() implementation).

The reason for this is function crypto_find_alg which clears out all flags 
that are not in maskset or maskclear.

For skcipher, this is defined as 

        .maskclear = ~CRYPTO_ALG_TYPE_MASK,
        .maskset = CRYPTO_ALG_TYPE_MASK,

Thus, the CRYPTO_NOLOAD flag is removed. How would I be able to allocate an 
algorithm without attempting to load modules?

Or phrasing the question differently: is there an issue to add CRYPTO_NOLOAD 
to the .maskclear and .maskset definitions, which would allocate the 
subordinate algos also with the NOLOAD flag?

Thanks a lot
Stephan


