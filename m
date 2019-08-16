Return-Path: <SRS0=FgZY=WM=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2E218C3A59C
	for <linux-crypto@archiver.kernel.org>; Fri, 16 Aug 2019 10:22:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 86BE420644
	for <linux-crypto@archiver.kernel.org>; Fri, 16 Aug 2019 10:22:52 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=chronox.de header.i=@chronox.de header.b="IXMjB7y9"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727093AbfHPKWv (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 16 Aug 2019 06:22:51 -0400
Received: from mo4-p01-ob.smtp.rzone.de ([85.215.255.54]:8902 "EHLO
        mo4-p01-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727092AbfHPKWv (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 16 Aug 2019 06:22:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1565950967;
        s=strato-dkim-0002; d=chronox.de;
        h=References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
        X-RZG-CLASS-ID:X-RZG-AUTH:From:Subject:Sender;
        bh=QiyRZBfcO0+IQvexnI8yZrDpG2eQxw6YceEbwDoBGxw=;
        b=IXMjB7y9GycOm7g6YOH1p9g76zRXizal2I7bx45fsmZCUlxlamratYBbVVaZRnV66U
        GrgJ/jNqu+rSXN1iPULc8GPfvUAwk/7b2ep81ykLqhs5lG7/01S6TUh9UjnraTsmwuhY
        sHqjwxK048cG5IhEORcdxEnKQXCTCEsN7qFGX9P7xkwFJdK6aYUFWgVl/TdbvBNFAem+
        8lIjz5ebzNNCn4yTGmr6cIXhyD0c84369HtuwXfokLwsjCDzpd88GVGMAr4K489FOUWd
        KUS4osMJFTrouw28oykRUjKJ//vb3JQrO7cDY+saNhsPLPD3XnH/jsy2a4zOFMwM76si
        PdtQ==
X-RZG-AUTH: ":P2ERcEykfu11Y98lp/T7+hdri+uKZK8TKWEqNyiHySGSa9k9xmwdNnzGHXPZIvSfYak+"
X-RZG-CLASS-ID: mo00
Received: from tauon.chronox.de
        by smtp.strato.de (RZmta 44.26.1 DYNA|AUTH)
        with ESMTPSA id u073a8v7GAMWIHn
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (curve secp521r1 with 521 ECDH bits, eq. 15360 bits RSA))
        (Client did not present a certificate);
        Fri, 16 Aug 2019 12:22:32 +0200 (CEST)
From:   Stephan Mueller <smueller@chronox.de>
To:     Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc:     linux-crypto@vger.kernel.org, herbert@gondor.apana.org.au,
        ebiggers@kernel.org
Subject: Re: [RFC/RFT PATCH] crypto: aes/xts - implement support for ciphertext stealing
Date:   Fri, 16 Aug 2019 12:22:32 +0200
Message-ID: <2570709.znztaGfihb@tauon.chronox.de>
In-Reply-To: <20190816101021.7837-1-ard.biesheuvel@linaro.org>
References: <20190816101021.7837-1-ard.biesheuvel@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Am Freitag, 16. August 2019, 12:10:21 CEST schrieb Ard Biesheuvel:

Hi Ard,

> Align the x86 code with the generic XTS template, which now supports
> ciphertext stealing as described by the IEEE XTS-AES spec P1619.

After applying the patch, the boot is successful even with the extra tests.
> 
> Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>

Tested-by: Stephan Mueller <smueller@chronox.de>

Ciao
Stephan


