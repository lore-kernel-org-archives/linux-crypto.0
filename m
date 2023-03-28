Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E1EA2C76195
	for <linux-crypto@archiver.kernel.org>; Tue, 28 Mar 2023 08:04:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229728AbjC1IEa (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 28 Mar 2023 04:04:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56044 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229501AbjC1IE3 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 28 Mar 2023 04:04:29 -0400
Received: from mo4-p00-ob.smtp.rzone.de (mo4-p00-ob.smtp.rzone.de [81.169.146.162])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28B9E12F
        for <linux-crypto@vger.kernel.org>; Tue, 28 Mar 2023 01:04:27 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1679990661; cv=none;
    d=strato.com; s=strato-dkim-0002;
    b=sMZ6QzO1ZJleEDtBN5taOVA/cep4+5/d0B6s2oHMTu5efEyamDl5UVfPLblR6Mk/fg
    r9CvvQiuQe6AG+63zFHfnc2jHrRlnGQ4Ccvv86FJIv5MRcwKU4VTayW/YOBqNJOEcFsL
    x3h/UmUbn2xjB0ljiOGrC8+fCmcohmTpMe/tlBdm3dMi+VuiaZVJxhVMqcbTrJz7xOyc
    LdakVPHTHQwVjcRgJccQe3e2Pc3yGQns2goz2oEGnKg6xMYVDENDLbI9gAsFD3xJWvpK
    AmORfSXuCdYHk7K0Unlpb5N0VvC3SF+8+G/9zo5pVhvLz2n2UiD+SVQQGYWS4cFqq6gD
    4jNA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; t=1679990661;
    s=strato-dkim-0002; d=strato.com;
    h=References:In-Reply-To:Message-ID:Date:Subject:To:From:Cc:Date:From:
    Subject:Sender;
    bh=ZVr+GBseoUw7mQIsJmBJ7iRh/RojZKBlyaxOMmlUPCE=;
    b=YOHNBkBw8Pbascq3Ayi7XwBBy9F5wHzAduN+BzLgSoowCdc0MT4paLYqaT1KWXUBtO
    gWJwkTjTUABuydxHuN6uVprKuOvKoe4f8DSQY8SWnDGmsW4TYW0dqlcYssAVl7zhI9Zb
    VODXXb+BhU4kN8MsYvmo7PzjBA8NH2GRfIXs1mA/xkt25qZ0gBQJB44R2kzCmo/ELObe
    emDzTRsOGoeBLX2c4zhqlhYGWngMafAYVLZmekDU4XT30Sef9s/uoO7wy3Q5vMQr4BTC
    4u9cEH5u/xbwq/u+NmSUT9OMUXbHylBNw3iBDJ/DdcQCY+lsQjCpCDKNERCtKrM0xza3
    HRhg==
ARC-Authentication-Results: i=1; strato.com;
    arc=none;
    dkim=none
X-RZG-CLASS-ID: mo00
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1679990661;
    s=strato-dkim-0002; d=chronox.de;
    h=References:In-Reply-To:Message-ID:Date:Subject:To:From:Cc:Date:From:
    Subject:Sender;
    bh=ZVr+GBseoUw7mQIsJmBJ7iRh/RojZKBlyaxOMmlUPCE=;
    b=PcxBA7o3mu3XEap6mVwpZ4pkm5wn75ge0J61hEFtRooL5v0hLo2BYD5r1VeZqYNEk5
    uuDESLQx6+QLGRWet9as9z2epVAzUOUyoRFSyZM0sBxLA2jZTBKjMH1DMJz/hlh+hkIt
    jq/L8JeQwVcGQz6u84mTxFluUZSxOGKxmk+nk13M95yFaUF6mnd/LrEhSuxMss40lUhS
    BCxRBR5GzlXRRr7gfhjotYt9Wu8Y1SOyv+493gh7MIg4lgslQlLOScSRJm1RDl2BSs9d
    w6G8GJQ1rEIhCMUMbMgeux0Id1DSMXWqo24Yz0q0Bx+aQfNTTmZQE5KMIjPKTGtG8r+w
    kadw==
X-RZG-AUTH: ":P2ERcEykfu11Y98lp/T7+hdri+uKZK8TKWEqNyiHySGSa9k9y2gdNk2TvDz1d0+/iw=="
Received: from tauon.chronox.de
    by smtp.strato.de (RZmta 49.3.1 AUTH)
    with ESMTPSA id u24edez2S84LphG
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
        (Client did not present a certificate);
    Tue, 28 Mar 2023 10:04:21 +0200 (CEST)
From:   Stephan Mueller <smueller@chronox.de>
To:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: drbg - Only fail when jent is unavailable in FIPS mode
Date:   Tue, 28 Mar 2023 10:04:20 +0200
Message-ID: <1802483.TS1nA93jg2@tauon.chronox.de>
In-Reply-To: <ZCJgez22L30w5B0L@gondor.apana.org.au>
References: <ZCJgez22L30w5B0L@gondor.apana.org.au>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="iso-8859-1"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Am Dienstag, 28. M=E4rz 2023, 05:35:23 CEST schrieb Herbert Xu:

Hi Herbert,

> When jent initialisation fails for any reason other than ENOENT,
> the entire drbg fails to initialise, even when we're not in FIPS
> mode.  This is wrong because we can still use the kernel RNG when
> we're not in FIPS mode.
>=20
> Change it so that it only fails when we are in FIPS mode.

Reviewed-by: Stephan Mueller <smueller@chronox.de>

Ciao
Stephan


