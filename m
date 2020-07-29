Return-Path: <SRS0=Hj06=BI=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 02637C433E0
	for <linux-crypto@archiver.kernel.org>; Wed, 29 Jul 2020 19:26:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CB6902082E
	for <linux-crypto@archiver.kernel.org>; Wed, 29 Jul 2020 19:26:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=chronox.de header.i=@chronox.de header.b="lHCfd2YG"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726365AbgG2T0b (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 29 Jul 2020 15:26:31 -0400
Received: from mo4-p00-ob.smtp.rzone.de ([85.215.255.20]:31290 "EHLO
        mo4-p00-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726391AbgG2T0b (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 29 Jul 2020 15:26:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1596050786;
        s=strato-dkim-0002; d=chronox.de;
        h=References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
        X-RZG-CLASS-ID:X-RZG-AUTH:From:Subject:Sender;
        bh=XsHiVjq90JWhvljrAQsxUaGqLyylaSzk3ZU4RBNsFuM=;
        b=lHCfd2YGwz9j37EszteieQI+Y53RFyyv6xV6WJlqqVIct8hmPhhqVlTZL1aE9pTrSH
        tgYh0s3p/A696wTtmG1a3ohdmo5MmuWmEMt1KsEpyz5QhXsSr5Mjw5mH45ucONcefPxw
        l0W3/DNz9wi+FE9tuXR8zc4GwUozWwkmuUvQ/+H+nWs/yt1lBUKlWJZ8v/nO4BWSuGQm
        uD2D+i+VkmJWj7HljNykGC3Y86nWXqyT/zPDusiL85BMQ4yqqFeG5/3szO2gEm5oSa41
        OSc+D00t9Oxvjwz7RRwlIumLnOScws/uWown+UtS1tFqG1a0F1jGVCPMUKgy2sRtTkz0
        Su0Q==
X-RZG-AUTH: ":P2ERcEykfu11Y98lp/T7+hdri+uKZK8TKWEqNyiHySGSa9k9xmwdNnzHHXDbLvSf24qr"
X-RZG-CLASS-ID: mo00
Received: from positron.chronox.de
        by smtp.strato.de (RZmta 46.10.5 DYNA|AUTH)
        with ESMTPSA id y0546bw6TJQLFrz
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
        (Client did not present a certificate);
        Wed, 29 Jul 2020 21:26:21 +0200 (CEST)
From:   Stephan =?ISO-8859-1?Q?M=FCller?= <smueller@chronox.de>
To:     linux-crypto@vger.kernel.org, Elena Petrova <lenaptr@google.com>
Cc:     Elena Petrova <lenaptr@google.com>,
        Eric Biggers <ebiggers@kernel.org>,
        Ard Biesheuvel <ardb@kernel.org>,
        Jeffrey Vander Stoep <jeffv@google.com>
Subject: Re: [PATCH v4] crypto: af_alg - add extra parameters for DRBG interface
Date:   Wed, 29 Jul 2020 21:26:20 +0200
Message-ID: <2540335.mvXUDI8C0e@positron.chronox.de>
In-Reply-To: <20200729154501.2461888-1-lenaptr@google.com>
References: <20200728173603.GD4053562@gmail.com> <20200729154501.2461888-1-lenaptr@google.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Am Mittwoch, 29. Juli 2020, 17:45:01 CEST schrieb Elena Petrova:

Hi Elena,

> Extend the user-space RNG interface:
>   1. Add entropy input via ALG_SET_DRBG_ENTROPY setsockopt option;
>   2. Add additional data input via sendmsg syscall.
>=20
> This allows DRBG to be tested with test vectors, for example for the
> purpose of CAVP testing, which otherwise isn't possible.
>=20
> To prevent erroneous use of entropy input, it is hidden under
> CRYPTO_USER_API_CAVP_DRBG config option and requires CAP_SYS_ADMIN to
> succeed.
>=20
> Signed-off-by: Elena Petrova <lenaptr@google.com>

Acked-by: Stephan M=FCller <smueller@chronox.de>

Ciao
Stephan


