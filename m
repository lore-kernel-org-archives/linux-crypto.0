Return-Path: <SRS0=pw/0=7L=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8FE95C433DF
	for <linux-crypto@archiver.kernel.org>; Fri, 29 May 2020 06:12:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C2841207D4
	for <linux-crypto@archiver.kernel.org>; Fri, 29 May 2020 06:12:27 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=chronox.de header.i=@chronox.de header.b="mvphTDC3"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725355AbgE2GM1 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 29 May 2020 02:12:27 -0400
Received: from mo4-p00-ob.smtp.rzone.de ([81.169.146.160]:18536 "EHLO
        mo4-p00-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725601AbgE2GM0 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 29 May 2020 02:12:26 -0400
X-Greylist: delayed 363 seconds by postgrey-1.27 at vger.kernel.org; Fri, 29 May 2020 02:12:25 EDT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1590732745;
        s=strato-dkim-0002; d=chronox.de;
        h=References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
        X-RZG-CLASS-ID:X-RZG-AUTH:From:Subject:Sender;
        bh=4UiXOfyw9AcaMuyiipbQNq/6pwIu1x9yEmmCXPJX2s8=;
        b=mvphTDC3Q+xUS7uEaYWTajLXbTdkb/b113yLOqHxdmZQtCAgVlg8+I+yqMsNF/c48/
        CX9V3TALbABoVwY0/NoCsLdpV3Tg50/cxeS1p826ed1+cdqfarEBvyTq45IdFO7QSC+G
        CtJAWm75AWkaMF48K3VgbwIwzqlwOMVbNdXQaICWllhnoi7VddWIxnAYS2BU8/Y81TQE
        +Y2AAsZ+D4XalyX2BN55Mlo8ur6Moobu6d/7Iwsm1n1v+HwaWG3o8Dd1l6j4FnhBwLZM
        SHR1Svm6gTh+TLNOmdnSmme6VAQU85yPmMtRpj95CHGzcSX749AGOYElTeZE3p9JsAvB
        jKtA==
X-RZG-AUTH: ":P2ERcEykfu11Y98lp/T7+hdri+uKZK8TKWEqNyiHySGSa9k9zmgLKehaO2hZDSTWbg/LOA=="
X-RZG-CLASS-ID: mo00
Received: from tauon.chronox.de
        by smtp.strato.de (RZmta 46.9.0 AUTH)
        with ESMTPSA id 20b0f3w4T66J3pE
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
        (Client did not present a certificate);
        Fri, 29 May 2020 08:06:19 +0200 (CEST)
From:   Stephan Mueller <smueller@chronox.de>
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Subject: Re: [PATCH] crypto: algif_skcipher - Cap recv SG list at ctx->used
Date:   Fri, 29 May 2020 08:06:16 +0200
Message-ID: <5727094.zWH9A8GyPn@tauon.chronox.de>
In-Reply-To: <20200529045443.GA475@gondor.apana.org.au>
References: <20200529045443.GA475@gondor.apana.org.au>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Am Freitag, 29. Mai 2020, 06:54:43 CEST schrieb Herbert Xu:

Hi Herbert,

> Somewhere along the line the cap on the SG list length for receive
> was lost.  This patch restores it and removes the subsequent test
> which is now redundant.
> 
> Fixes: 2d97591ef43d ("crypto: af_alg - consolidation of...")
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

Reviewed-by: Stephan Mueller <smueller@chronox.de>

Thanks

Ciao
Stephan


