Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4AC87C6FD20
	for <linux-crypto@archiver.kernel.org>; Fri, 24 Mar 2023 18:00:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230192AbjCXSAg (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 24 Mar 2023 14:00:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230271AbjCXSAV (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 24 Mar 2023 14:00:21 -0400
X-Greylist: delayed 188 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Fri, 24 Mar 2023 10:59:46 PDT
Received: from mo6-p01-ob.smtp.rzone.de (mo6-p01-ob.smtp.rzone.de [IPv6:2a01:238:400:200::6])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B45AF6A69
        for <linux-crypto@vger.kernel.org>; Fri, 24 Mar 2023 10:59:45 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1679680464; cv=none;
    d=strato.com; s=strato-dkim-0002;
    b=rjG5c6qWJlUMmSAoXREPm6CoOBz1V7kv9W7guURiiOQ7nKIoUoeGU6II/ZG6BR0MJS
    rNTiMwOuZo4GUMvKvjB1ybLfElxIqmOhYI+5syNDcuobR1nDxGJBMT59aRI0fN50uCFo
    4rfteaUDwrA0N/BTsbnkrwtQet/8Y96lEZ/x9TjFyetUFWm0NQtIC09jh51uaimgGx4D
    iduqXSTLxua1vzmY4lnbIbGlUWVIXCpm78EnOAMy4EUf4/Z3svP96wtvItzRJg08vryU
    Ot/8R9p9Q/s9GGEI6TpfD3O50htako8LzZ3favTJy+yDVO0wpxTi0s+lDvpeacvZBY9Y
    AXOg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; t=1679680464;
    s=strato-dkim-0002; d=strato.com;
    h=References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Cc:Date:
    From:Subject:Sender;
    bh=ZOPcHtxej7oKghsbdwptXG8IEp4edVV6ICuEYqB/eG8=;
    b=RllOsiqOcGmy9Nq1S0P7sYS1guBmNbb9L+dIaK2CYzqT4ymM6e89AkC6ZtHyYLm0mK
    D/WF222ublqmH7BORqwubHfM2np1Jmz5U/TIdrN/LCws0YdRcZoJF2UQ1D1674JHTBvW
    KwHLNhOLQfB0xeLIzIKP1xM2PEen24NUkcxSqkRGEs6At+QdLGtlUeBl1XM//b0yetNS
    VWbqPXxjSWccoDYgEbr2mw85hzlsTXDEOqtDJxh8IFPCl8reNWVwTt5xdCFaRzF1iCdk
    ATzpsRKJRuH7RUNmp6Pre1Pb3uHqh933n9HDfSGXbpKn9bWDb+e716cXuQzY6AAdgxEq
    IyEQ==
ARC-Authentication-Results: i=1; strato.com;
    arc=none;
    dkim=none
X-RZG-CLASS-ID: mo01
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1679680464;
    s=strato-dkim-0002; d=chronox.de;
    h=References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Cc:Date:
    From:Subject:Sender;
    bh=ZOPcHtxej7oKghsbdwptXG8IEp4edVV6ICuEYqB/eG8=;
    b=nzOGczDe3bNqeT/890HIEUx1uS28SKeIUsyy/ShKxe9SGDD2IrrKi4JTrQyPIQkdFj
    gAC773pDq7a0Sr4urdl8PdSTQBXPlOvswjBb6ElBvHKmfYfNi4TAsluy6yBdABecAEQb
    v0DsfO3Jt0MSUHS17IChCR2e/krvxg7odg0LkiB7MWEr8RghIEdA7von7tb6ZTo4z1e3
    wjNaRO3KTy/7WSBagZu1odaoU/li52RtP0469paVXDfzIWxxF3OHUiscoOFQXiuVro6R
    e1y1XSpZM2Dfr5dwTXcKZ5eG0PTvXWIRGnKo2zw/v8UaLuL4100IgyPohQoeOcLZ+h5C
    WjJg==
X-RZG-AUTH: ":P2ERcEykfu11Y98lp/T7+hdri+uKZK8TKWEqNyiHySGSa9k9y2gdNk2TvDr2d0uyvAg="
Received: from tauon.chronox.de
    by smtp.strato.de (RZmta 49.3.1 DYNA|AUTH)
    with ESMTPSA id u24edez2OHsOeWH
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
        (Client did not present a certificate);
    Fri, 24 Mar 2023 18:54:24 +0100 (CET)
From:   Stephan Mueller <smueller@chronox.de>
To:     Vladis Dronov <vdronov@redhat.com>
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        linux-crypto@vger.kernel.org, Vladis Dronov <vdronov@redhat.com>
Subject: Re: [PATCH v3] Jitter RNG - Permanent and Intermittent health errors
Date:   Fri, 24 Mar 2023 18:54:23 +0100
Message-ID: <7502351.DBV9aYCCVu@tauon.chronox.de>
In-Reply-To: <20230324174709.21533-1-vdronov@redhat.com>
References: <5915902.lOV4Wx5bFT@positron.chronox.de>
 <20230324174709.21533-1-vdronov@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="iso-8859-1"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Am Freitag, 24. M=E4rz 2023, 18:47:09 CET schrieb Vladis Dronov:

Hi Vladis,

> Hi,
> Aaaand I would suggest the following smallest fix, just a comment update:
>=20
> +        * If the kernel was booted with fips=3D2, it implies that
>=20
> change to:
>=20
> +        * If the kernel was booted with fips=3D1, it implies that

Thank you very much. I have fixed it in my local copy, but will wait for=20
another bit in case there are other reports.
>=20
> Otherwise,
> Reviewed-by: Vladis Dronov <vdronov@redhat.com>

Thanks, added.
>=20
> Best regards,
> Vladis


Ciao
Stephan


