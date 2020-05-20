Return-Path: <SRS0=Eyne=7C=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 891DEC433E1
	for <linux-crypto@archiver.kernel.org>; Wed, 20 May 2020 06:03:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 673222084C
	for <linux-crypto@archiver.kernel.org>; Wed, 20 May 2020 06:03:37 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=chronox.de header.i=@chronox.de header.b="J+O4RxtH"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726468AbgETGDg (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 20 May 2020 02:03:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725998AbgETGDf (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 20 May 2020 02:03:35 -0400
Received: from mo6-p00-ob.smtp.rzone.de (mo6-p00-ob.smtp.rzone.de [IPv6:2a01:238:20a:202:5300::5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40115C061A0E
        for <linux-crypto@vger.kernel.org>; Tue, 19 May 2020 23:03:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1589954611;
        s=strato-dkim-0002; d=chronox.de;
        h=References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
        X-RZG-CLASS-ID:X-RZG-AUTH:From:Subject:Sender;
        bh=pSXXxnX23N+Cj33l5NV3fLExfRAIBDF1x9HdRtzBo2c=;
        b=J+O4RxtHqpvIs7iECE4B+Ox7vZhLKEQpNkRoAq/cYrDtakmiEvnxdkNQ04pK/aAwA+
        CnTrvXaPmU8NhSr1O9Pbne7eXAiNtahdt3itsEqWmc8uZs7Fo6rgX/WEi+eTyuDyJBhG
        oDkT87ESOOdJ734tHYR40HS9wx0xRjigJHsiKCdSGHmG86BqB7AXP1rPNNWiaD6SdKUp
        gRoxSXdmBg51FWECaJ33hzDG9boK0PMkR8yPUDC+dk7ppWJRw1TsRgLA5vMaycjDXyiB
        Rm+BgKz+DzndOzP6ivT5ndaBm91G3Z4kYJ1XEqC5QMtI4hhAJrD9s92sdrnSTNDQ1KTG
        B8Dw==
X-RZG-AUTH: ":P2ERcEykfu11Y98lp/T7+hdri+uKZK8TKWEqNyiHySGSa9k9xmwdNnzGHXPbI/Sc5g=="
X-RZG-CLASS-ID: mo00
Received: from tauon.chronox.de
        by smtp.strato.de (RZmta 46.7.0 DYNA|AUTH)
        with ESMTPSA id k09005w4K63O2y2
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
        (Client did not present a certificate);
        Wed, 20 May 2020 08:03:24 +0200 (CEST)
From:   Stephan Mueller <smueller@chronox.de>
To:     Ard Biesheuvel <ardb@kernel.org>
Cc:     linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        ebiggers@kernel.org
Subject: Re: [RFC/RFT PATCH 0/2] crypto: add CTS output IVs for arm64 and testmgr
Date:   Wed, 20 May 2020 08:03:23 +0200
Message-ID: <16565072.6IxHkjxkAd@tauon.chronox.de>
In-Reply-To: <20200519190211.76855-1-ardb@kernel.org>
References: <20200519190211.76855-1-ardb@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Am Dienstag, 19. Mai 2020, 21:02:09 CEST schrieb Ard Biesheuvel:

Hi Ard,

> Stephan reports that the arm64 implementation of cts(cbc(aes)) deviates
> from the generic implementation in what it returns as the output IV. So
> fix this, and add some test vectors to catch other non-compliant
> implementations.
> 
> Stephan, could you provide a reference for the NIST validation tool and
> how it flags this behaviour as non-compliant? Thanks.

The test definition that identified the inconsistent behavior is specified 
with [1]. Note, this testing is intended to become an RFC standard.

To facilitate that testing, NIST offers an internet service, the ACVP server, 
that allows obtaining test vectors and uploading responses. You see the large 
number of concluded testing with [2]. A particular completion of the CTS 
testing I finished yesterday is given in [3]. That particular testing was also 
performed on an ARM system with CE where the issue was detected.

I am performing the testing with [4] that has an extension to test the kernel 
crypto API.

[1] https://github.com/usnistgov/ACVP/blob/master/artifacts/draft-celi-acvp-block-ciph-00.txt#L366

[2] https://csrc.nist.gov/projects/cryptographic-algorithm-validation-program/
validation-search?searchMode=validation&family=1&productType=-1&ipp=25

[3] https://csrc.nist.gov/projects/cryptographic-algorithm-validation-program/
details?validation=32608

[4] https://github.com/smuellerDD/acvpparser
> 
> Cc: Stephan Mueller <smueller@chronox.de>
> 
> Ard Biesheuvel (2):
>   crypto: arm64/aes - align output IV with generic CBC-CTS driver
>   crypto: testmgr - add output IVs for AES-CBC with ciphertext stealing
> 
>  arch/arm64/crypto/aes-modes.S |  2 ++
>  crypto/testmgr.h              | 12 ++++++++++++
>  2 files changed, 14 insertions(+)


Ciao
Stephan


