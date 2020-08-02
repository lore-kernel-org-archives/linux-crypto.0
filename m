Return-Path: <SRS0=/mkk=BM=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 956AAC433DF
	for <linux-crypto@archiver.kernel.org>; Sun,  2 Aug 2020 18:29:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CA6462065E
	for <linux-crypto@archiver.kernel.org>; Sun,  2 Aug 2020 18:29:14 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=chronox.de header.i=@chronox.de header.b="A1AEdXZU"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726163AbgHBS3O (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 2 Aug 2020 14:29:14 -0400
Received: from mo4-p00-ob.smtp.rzone.de ([85.215.255.22]:10294 "EHLO
        mo4-p00-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725917AbgHBS3N (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 2 Aug 2020 14:29:13 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1596392949;
        s=strato-dkim-0002; d=chronox.de;
        h=References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
        X-RZG-CLASS-ID:X-RZG-AUTH:From:Subject:Sender;
        bh=2NEjcRTj85kAAf1x/mTVx2JMX5a/v0WFkm/vzxr7gAQ=;
        b=A1AEdXZUxXsG+UW8F4PX+i3A7jEXyHI39SsBLIzsv9lTVr4oXF1w3XVJ0Aqk4ONuIY
        Q2boyUqpWwNvmiKhzZeShfm1APrWvOdPr7PY20m1ODZQtLyZCxqr4ecTD2Oz5luTjYEq
        97M/craFyHfML1DxkYGZmVOTahbYhRq3xyAgXt6W3ntNrfc9M/rOoiYJkqQfqLKZrNon
        MQtUk7VqGbhcPj/UjUqh7AO2Cki4lIYMaU50Rij4OH5dre0cVCidygjO+fuUtwvpWbP/
        bdIP/hWrZBQMBDdrHLVdakM3ZBZ1/Jt83C67rbbTKTCteE9flxothRnPH4ERlqOPRy+i
        tgHg==
X-RZG-AUTH: ":P2ERcEykfu11Y98lp/T7+hdri+uKZK8TKWEqNyiHySGSa9k9xmwdNnzGHXPZJPSfIqEh"
X-RZG-CLASS-ID: mo00
Received: from tauon.chronox.de
        by smtp.strato.de (RZmta 46.10.5 DYNA|AUTH)
        with ESMTPSA id y0546bw72IT6VJ4
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
        (Client did not present a certificate);
        Sun, 2 Aug 2020 20:29:06 +0200 (CEST)
From:   Stephan Mueller <smueller@chronox.de>
To:     herbert@gondor.apana.org.au, davem@davemloft.net, trix@redhat.com
Cc:     linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        Tom Rix <trix@redhat.com>
Subject: Re: [PATCH] crypto: drbg: check blocklen is non zero
Date:   Sun, 02 Aug 2020 20:29:05 +0200
Message-ID: <9904643.2WqB4rESCP@tauon.chronox.de>
In-Reply-To: <20200802171247.16558-1-trix@redhat.com>
References: <20200802171247.16558-1-trix@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Am Sonntag, 2. August 2020, 19:12:47 CEST schrieb trix@redhat.com:

Hi Tom,

> From: Tom Rix <trix@redhat.com>
> 
> Clang static analysis reports this error
> 
> crypto/drbg.c:441:40: warning: Division by zero
>         padlen = (inputlen + sizeof(L_N) + 1) % (drbg_blocklen(drbg));
>                  ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~^~~~~~~~~~~~~~~~~~~~~~~
> 
> When drbg_bocklen fails it returns 0.
> 
> 	if (drbg && drbg->core)
> 		return drbg->core->blocklen_bytes;
> 	return 0;
> 
> In many places in drbg_ctr_df drbg_bocklen is assumed to be non zero.
> So turn the assumption into a check.
> 
> Fixes: 541af946fe13 ("crypto: drbg - SP800-90A Deterministic Random Bit
> Generator")
> 
> Signed-off-by: Tom Rix <trix@redhat.com>

Thank you.

Reviewed-by: Stephan Mueller <smueller@chronox.de>

Ciao
Stephan


