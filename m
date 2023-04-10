Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 093CDC76196
	for <linux-crypto@archiver.kernel.org>; Mon, 10 Apr 2023 21:16:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229722AbjDJVQr (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 10 Apr 2023 17:16:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55708 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229507AbjDJVQr (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 10 Apr 2023 17:16:47 -0400
Received: from mo4-p01-ob.smtp.rzone.de (mo4-p01-ob.smtp.rzone.de [85.215.255.54])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F4CD1BFD
        for <linux-crypto@vger.kernel.org>; Mon, 10 Apr 2023 14:16:45 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1681161398; cv=none;
    d=strato.com; s=strato-dkim-0002;
    b=YaXeqHEVzp8c8KcyQFbSM/ha8yNc/0irJMrOfjo4H3brUN4ImYgKf6yX/3kI07++dQ
    kZRJkNhO+lUuEiyFwzi6w+fW4IfwCwPqXVEYtPPW8OWlWMs8m35PKSYYqStRDjAd1o9z
    AhdlujjCCeMlwNTFl+nndqU2wqOT2MJXX+ctifOKfrl97exxU+eMx+3KXvwfDRH9/DTF
    9HexuBzOpeoUiyhOQjQWhCwMxWL5KUU4s0iRmkL0cRd2XTpY1LyiJLwihNQv+TAVLHro
    vLIfSgsctWzKU/vSb/AgbO86WhkPFofHM+1IkJVrh0zDYiPckRHPiMt9IIDfM5bdnxHl
    KkCg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; t=1681161398;
    s=strato-dkim-0002; d=strato.com;
    h=References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Cc:Date:
    From:Subject:Sender;
    bh=UrMK//V+W+veA5rpynBv5B4YNVCC8Q98AtfvyqYOmyU=;
    b=bkhkSC/KMBUfcUkWyUkucp5ayFlp2hC26lfJspUdeGVgXlQgVukneg3xhH0GmKsjs8
    /ak37JnSMrAZ5WihG/agNgk8XBsbglfeYcy7GkKohNiDUNZZQICOVS04Vi1fIAz6G6ZE
    DtVqYJ2zwBxgDxWgMR7hVsqdjiZqCbUncbc9snqMSy30lTSvaID+EI4iFZvtC63zo5VW
    ASp9GkAsKqSNNYSoUJ0kClSRe2PpusFWCIDp7olZ5yV3qCj6e/gVgkBRqUxZuIg92R9G
    NGAYQBK47iTd+Cff4mQPCqAgekMfckol/pESS8P2ztKmSe6+qcgu19/0B3JZWDJ3BBg8
    CXcQ==
ARC-Authentication-Results: i=1; strato.com;
    arc=none;
    dkim=none
X-RZG-CLASS-ID: mo01
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1681161398;
    s=strato-dkim-0002; d=chronox.de;
    h=References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Cc:Date:
    From:Subject:Sender;
    bh=UrMK//V+W+veA5rpynBv5B4YNVCC8Q98AtfvyqYOmyU=;
    b=eUh3nzORnV8IR4GXEW+LPuF7f5xVxw/bnyrW5Z/AzSYBOsQepRbVfgGKeu83FW23II
    PQsBX/lgabablmYMYSd3LCi+6gvnF+hyYEbxx9DkT7aO3XL96Fm27moh/miSHofpyB2Q
    JU9SwOq6k67eJIHPT5IPXvuxZFoo/0MyhK0njOuuGz1OdYMg1GzfvEwajtqHNafEg7qf
    9TOMUhU7Bv2R21DQkCfj4aV1GrAn+LvTrt1wJETtIq6TA37ohgxZqZeP9BdxBzaHKZpi
    7Rv53/UZlgVlAyurskJvX1auDlDdF7Nn0qdQ4dkpUwi7yzDitE/B6CY/YmAKz+IvlT9d
    qTSg==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; t=1681161398;
    s=strato-dkim-0003; d=chronox.de;
    h=References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Cc:Date:
    From:Subject:Sender;
    bh=UrMK//V+W+veA5rpynBv5B4YNVCC8Q98AtfvyqYOmyU=;
    b=HX1kqTSoyb/Qe8/qGH2IzjuKn/EALaFoHGJkT40Sx42OL8Bp2pYsbYizDmx3cUMpI/
    iehnx/nh+aexix8ZYVAg==
X-RZG-AUTH: ":P2ERcEykfu11Y98lp/T7+hdri+uKZK8TKWEqNyiHySGSa9k9x24dNoX176cDw2h2is1y"
Received: from positron.chronox.de
    by smtp.strato.de (RZmta 49.4.0 DYNA|AUTH)
    with ESMTPSA id ta02b6z3ALGbLML
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
        (Client did not present a certificate);
    Mon, 10 Apr 2023 23:16:37 +0200 (CEST)
From:   Stephan =?ISO-8859-1?Q?M=FCller?= <smueller@chronox.de>
To:     linux-crypto@vger.kernel.org, herbert@gondor.apana.org.au
Cc:     Vladis Dronov <vdronov@redhat.com>,
        Marcelo Cerri <marcelo.cerri@canonical.com>
Subject: [PATCH v2 0/2] crypto: jitter - SHA-3 conditioner and test interface
Date:   Mon, 10 Apr 2023 22:53:59 +0200
Message-ID: <4825604.31r3eYUQgx@positron.chronox.de>
In-Reply-To: <2684670.mvXUDI8C0e@positron.chronox.de>
References: <2684670.mvXUDI8C0e@positron.chronox.de>
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

Changes v2:

- fix use-after-free by switching shash_desc_zero and crypto_free_shash
  in jent_mod_init reported by kernel-test-robot

Stephan Mueller (2):
  crypto: jitter - replace LFSR with SHA3-256
  crypto: jitter - add interface for gathering of raw entropy

 crypto/Kconfig                 |  21 +++
 crypto/Makefile                |   1 +
 crypto/jitterentropy-kcapi.c   | 186 ++++++++++++++++++---
 crypto/jitterentropy-testing.c | 294 +++++++++++++++++++++++++++++++++
 crypto/jitterentropy.c         | 145 ++++++----------
 crypto/jitterentropy.h         |  20 ++-
 6 files changed, 547 insertions(+), 120 deletions(-)
 create mode 100644 crypto/jitterentropy-testing.c

-- 
2.40.0




