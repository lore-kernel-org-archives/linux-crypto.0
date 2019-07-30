Return-Path: <SRS0=RABd=V3=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F1110C0650F
	for <linux-crypto@archiver.kernel.org>; Tue, 30 Jul 2019 13:15:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2F9D0206E0
	for <linux-crypto@archiver.kernel.org>; Tue, 30 Jul 2019 13:15:43 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=chronox.de header.i=@chronox.de header.b="Rc+EVXM+"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730471AbfG3NPm (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 30 Jul 2019 09:15:42 -0400
Received: from mo4-p00-ob.smtp.rzone.de ([85.215.255.21]:35543 "EHLO
        mo4-p00-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728361AbfG3NPl (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 30 Jul 2019 09:15:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1564492540;
        s=strato-dkim-0002; d=chronox.de;
        h=References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
        X-RZG-CLASS-ID:X-RZG-AUTH:From:Subject:Sender;
        bh=fZU02WME1j++OukSbwNkJl19Zn/sPwBrDvildaaZZSE=;
        b=Rc+EVXM+9d036TWV2lAhyExbsMeI69njeNFB3kH8cHw2B3CwB6D7blsSKNDRC7L0Cx
        faawPl5YmGhi3uh2xytCLiq9GWToj9rFwivkRSdC9tTl3FCchvwX1YjAI5OgkJatnHEG
        N/1tZVKRfLzgyMUgxi0Xkreqt+qb2kVLVtE41ds8IJrzq17iLoq7d3W6jAgQ8r4Hfzqp
        5tBgfleEP4s+9/JBg/y4UAL9IeiMnrG7x017vRXOiVX1iPc1AHYCP5Ml/mU7PSeaG30m
        KJx7eHFrL0d/Bzjlj47IkNXJgD0HVscH2+b+BNz8d2mA+2tBWK2fw0osqYv+V5O/vdNP
        5/9w==
X-RZG-AUTH: ":P2ERcEykfu11Y98lp/T7+hdri+uKZK8TKWEqNyiHySGSa9k9zT8DNpa83PTIPmPqdrSduCsDXIXJvv70B+GoaBjRKkSTdAk4PGH3"
X-RZG-CLASS-ID: mo00
Received: from tauon.chronox.de
        by smtp.strato.de (RZmta 44.24 AUTH)
        with ESMTPSA id a007f7v6UDFZ0WE
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (curve secp521r1 with 521 ECDH bits, eq. 15360 bits RSA))
        (Client did not present a certificate);
        Tue, 30 Jul 2019 15:15:35 +0200 (CEST)
From:   Stephan Mueller <smueller@chronox.de>
To:     Hans de Goede <hdegoede@redhat.com>
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>,
        Andy Lutomirski <luto@kernel.org>,
        linux-crypto@vger.kernel.org,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: Re: [RFC 3/3] crypto/sha256: Build the SHA256 core separately from the crypto module
Date:   Tue, 30 Jul 2019 15:15:35 +0200
Message-ID: <4384403.bebDo606LH@tauon.chronox.de>
In-Reply-To: <20190730123835.10283-4-hdegoede@redhat.com>
References: <20190730123835.10283-1-hdegoede@redhat.com> <20190730123835.10283-4-hdegoede@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Am Dienstag, 30. Juli 2019, 14:38:35 CEST schrieb Hans de Goede:

Hi Hans,

> From: Andy Lutomirski <luto@kernel.org>
> 
> This just moves code around -- no code changes in this patch.  This
> wil let BPF-based tracing link against the SHA256 core code without
> depending on the crypto core.
> 
> Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>
> Cc: Herbert Xu <herbert@gondor.apana.org.au>
> Signed-off-by: Andy Lutomirski <luto@kernel.org>
> ---
>  crypto/Kconfig                               |   8 +
>  crypto/Makefile                              |   1 +
>  crypto/{sha256_generic.c => sha256_direct.c} | 103 +--------

There is a similar standalone code present for SHA-1 or ChaCha20. However, 
this code lives in lib/.

Thus, shouldn't the SHA-256 core code be moved to lib/ as well?

Ciao
Stephan


