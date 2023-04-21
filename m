Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A03B5C77B75
	for <linux-crypto@archiver.kernel.org>; Fri, 21 Apr 2023 06:12:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230155AbjDUGLe (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 21 Apr 2023 02:11:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51144 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233213AbjDUGLb (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 21 Apr 2023 02:11:31 -0400
Received: from mo4-p01-ob.smtp.rzone.de (mo4-p01-ob.smtp.rzone.de [81.169.146.164])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5D962111
        for <linux-crypto@vger.kernel.org>; Thu, 20 Apr 2023 23:10:04 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1682057363; cv=none;
    d=strato.com; s=strato-dkim-0002;
    b=iHtKW3lWTECEGEvXCnPZ6rbA6YEJja9sdI6+a0aewS7EzcttaQDiLRkj3PKGFPoLHh
    oWrF6ZHdHTgz56oDYcQKHz/b9tzq2JkOf+g3nKjU1kh16Qpo++44Dk21MLgEdfV64dw9
    5/YF6Tz0FYjsW3biqvyQV1SW92oPr1qHh396jUpSRT60jZ515xixijId01o0C3MVOMKR
    gooUGRjIeigwqDXCuqcSLIdCRhAw7zZSbmx8xq4S1kymPTacABt+S43X8/NoxHakDnOf
    bzLAGtMYGp3sd1tdlTGk0/UmagJmLU/m7Tibw58alHRD+v/1Q5UqnGtsVoS08x5SbIyO
    jSwQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; t=1682057363;
    s=strato-dkim-0002; d=strato.com;
    h=References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Cc:Date:
    From:Subject:Sender;
    bh=AYdqUTVg07JzH3M+rkQ0c2tb1ZzKKUteItTGXwK8d1o=;
    b=kU1jI105wEuPwYj0B11xj41hHeSg3WVsF3GizFidq7YFrfh+NoXdN3pQ4Ni90QcWY5
    UF1InSb1GdONBpzth6w8g1ZEe78dK6Dri2mWuNpR63e+elQUyaO1kfNJplmfJxSqvSs2
    C+FA9kypRN9hXONBgiapPbZWGpjAUsW4GGxCy1OTTD/g8cFxDqJnPodCDpd/1StZlUE7
    B8aMYo9zDKPzQR4DYlh3U8TlDbdBpyWGuiVABLfaPFyE1pA7GfBH+/O9ewFaImzWjsiY
    C/nt3eoZett8b6YDrOaWYnYnOCRCo0eJA9sUl5aPVBOQYDXoiEadqGb9e5WS3dPoEYQz
    XJNg==
ARC-Authentication-Results: i=1; strato.com;
    arc=none;
    dkim=none
X-RZG-CLASS-ID: mo01
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1682057363;
    s=strato-dkim-0002; d=chronox.de;
    h=References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Cc:Date:
    From:Subject:Sender;
    bh=AYdqUTVg07JzH3M+rkQ0c2tb1ZzKKUteItTGXwK8d1o=;
    b=sRS1c0IrfSgC6lhO3++mPYY3VXXECye8/Vkw7/pv8ifqlqNCMm+SRY8Zt6txrDhJKA
    mGy62Z/ZoNPIH6BR7b0DRTgmd2qc5ag3NcB1kj+l54+UyyVd7ix3N3wt9pQ+7WNzSHnc
    I35rr4J1p+5r8m3IRbxTYHw9NqY6XvJi72RAZbyoaElB4X0D5A+xxFOPC7sfQDHj0di6
    SB+XguVwr3kA5f6IV3fgNj5b1mv1QkFzw67h/b/fg6jggsQ7ti47kzEwvovb2ECGONup
    vHCl2Rx6F7JdOeKefNmHwRRt3/GjB5Zn6C7Mahk9gZ/6cgyXaL5wwyhjxUyp5kVYFeAO
    T8hw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; t=1682057363;
    s=strato-dkim-0003; d=chronox.de;
    h=References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Cc:Date:
    From:Subject:Sender;
    bh=AYdqUTVg07JzH3M+rkQ0c2tb1ZzKKUteItTGXwK8d1o=;
    b=vVsC4XBWwWshcUpUqXwfqALcVtVp7+yoFYfLveDbH6l6JMm9RTOH7ljTLktibCsXGD
    5/8F+AZ6qaTcNPhC9RBg==
X-RZG-AUTH: ":P2ERcEykfu11Y98lp/T7+hdri+uKZK8TKWEqNyiHySGSa9k9y2gdNk2TvDz1d0q2fA=="
Received: from positron.chronox.de
    by smtp.strato.de (RZmta 49.4.0 AUTH)
    with ESMTPSA id ta02b6z3L69NCIJ
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
        (Client did not present a certificate);
    Fri, 21 Apr 2023 08:09:23 +0200 (CEST)
From:   Stephan =?ISO-8859-1?Q?M=FCller?= <smueller@chronox.de>
To:     linux-crypto@vger.kernel.org, herbert@gondor.apana.org.au
Cc:     Vladis Dronov <vdronov@redhat.com>,
        Marcelo Cerri <marcelo.cerri@canonical.com>
Subject: [PATCH v3 0/2] crypto: jitter - SHA-3 conditioner and test interface
Date:   Fri, 21 Apr 2023 08:07:39 +0200
Message-ID: <2687238.mvXUDI8C0e@positron.chronox.de>
In-Reply-To: <4825604.31r3eYUQgx@positron.chronox.de>
References: <2684670.mvXUDI8C0e@positron.chronox.de>
 <4825604.31r3eYUQgx@positron.chronox.de>
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

The patch set replaces the LFSR conditioning function of the Jitter RNG
with SHA-3 256. This change requires also a new test interface to
analyze the raw unconditioned noise data.

Albeit the test interface can be used directly with dd, a small helper
tool is provided at [1] which can be used to perform the collection
of raw entropy. The analysis of the data can be done with your favorite
tool. Or you may use the helper in [2] which uses the NIST SP800-90B
tool for entropy rate measurement.

[1] https://github.com/smuellerDD/jitterentropy-library/tree/master/tests/raw-entropy/recording_runtime_kernelspace

[2] https://github.com/smuellerDD/jitterentropy-library/tree/master/tests/raw-entropy/validation-runtime-kernel

Changes v3:

- fix jent_kcapi_init: error code for jent_entropy_collector_alloc now
  properly cleans up the state

- fix jent_kcapi_init: initialize lock at the beginning as it is used in
  error code path function jent_kcapi_cleanup

- editorial change: update description in MODULE_PARM_DESC in patch 0002

Changes v2:

- fix use-after-free by switching shash_desc_zero and crypto_free_shash
  in jent_mod_init reported by kernel-test-robot

Stephan Mueller (2):
  crypto: jitter - replace LFSR with SHA3-256
  crypto: jitter - add interface for gathering of raw entropy

 crypto/Kconfig                 |  21 +++
 crypto/Makefile                |   1 +
 crypto/jitterentropy-kcapi.c   | 190 ++++++++++++++++++---
 crypto/jitterentropy-testing.c | 294 +++++++++++++++++++++++++++++++++
 crypto/jitterentropy.c         | 145 ++++++----------
 crypto/jitterentropy.h         |  20 ++-
 6 files changed, 551 insertions(+), 120 deletions(-)
 create mode 100644 crypto/jitterentropy-testing.c

-- 
2.40.0




