Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 42EA9C76196
	for <linux-crypto@archiver.kernel.org>; Fri,  7 Apr 2023 11:57:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235576AbjDGL5W (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 7 Apr 2023 07:57:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232209AbjDGL5V (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 7 Apr 2023 07:57:21 -0400
Received: from mo4-p01-ob.smtp.rzone.de (mo4-p01-ob.smtp.rzone.de [85.215.255.50])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BCDFA49CE
        for <linux-crypto@vger.kernel.org>; Fri,  7 Apr 2023 04:57:18 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1680868630; cv=none;
    d=strato.com; s=strato-dkim-0002;
    b=rGASV16ouEygYAuEBxmC5A8RuBIsUNcxNbYzxJ6NqF3GV14r7vvFfZWoQ6uUoz/m/X
    B3QU5tRBbDwpOSro4dkeaN3Rafhr8Mw53nw0DbuU4bVVT5d9zGPOqoYUM/zKargcu6mU
    p4laGr087evUbq8KISGqbxeIvI9FveM5nbOld3Ek3uClcIW7yFcFDHkhJEzot8SCGre9
    CNfBK8eDFVy4Fk9ZF/W9kaZrdDQ6BNWaGHT9GMeA8+0NNIFfRoqEwJnaUaZq9Qh0OLUJ
    JmS4UPbJ39S/BSVXwsvIR1vSMxRocPlgOk6D3pPOviA10TvLOxXqAh973VRGgLOcJRrv
    Wz5A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; t=1680868630;
    s=strato-dkim-0002; d=strato.com;
    h=Message-ID:Date:Subject:Cc:To:From:Cc:Date:From:Subject:Sender;
    bh=ApmdAJYpsCv/5T/UcEditewzDgxqXXiJO08Id+kh4WU=;
    b=P1F/waW3T+9LGXZMiGmWynpvO/UuE+TBdvXeSqmNi6C/TnaBB0hkPZZjKfdkZiJ/fS
    PzrhxBJYV/fsyVgV2ufppdMIfhiwdYA73gvkyRt6pI72sIwWON14d1gAHJcoQRM5Rc1r
    l3ZiTmWRScFSYs4+vDJ+lmgF5RC4aB7Is0HTXfgjMPcndkMvE/XKrhG9jHUnnk2va766
    hCt0DtmTIexvF0fBaIMLgPUP/9tkAZtuwCJW5NjWVjxWE7LMUIS+AIFPbSC+phk7TzMY
    l82wmMwMHQ/ow9JFq+avfKLdszulyLp5RnZn6qyFdzvNvsz/RwRUM+357i2YhsFZUTxg
    9BWA==
ARC-Authentication-Results: i=1; strato.com;
    arc=none;
    dkim=none
X-RZG-CLASS-ID: mo01
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1680868630;
    s=strato-dkim-0002; d=chronox.de;
    h=Message-ID:Date:Subject:Cc:To:From:Cc:Date:From:Subject:Sender;
    bh=ApmdAJYpsCv/5T/UcEditewzDgxqXXiJO08Id+kh4WU=;
    b=TsGVM51t/SDB+HsO/jvVVunks928IR1EtNgY4lmJFU0m4bugpUQ1BgawyF8E3GX8qB
    rR3UIb2NLntKedaiQWqztShaVTdQ9Z30/oHEUsQUalm4agvNK1XkVHzOch/EUvREnvwl
    sG17f/QOi+N357RMN5G0GaYbOFKYsNiRB8zVwwsnCZIsNafnyqxuAtv/24zETiUKuiTJ
    2T37U00xq2De5xd1cimB0ECJOpRnXIktoGlHYb/+6UOXI2IHfJmzSzhxuASJkC3dS/hH
    UH0CWK634/S+nElg23bfeX+1rktpgTF4TJAfZqz8QJZBYA6SX3yiZwIQ6ro59XDQB1Od
    T2RQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; t=1680868630;
    s=strato-dkim-0003; d=chronox.de;
    h=Message-ID:Date:Subject:Cc:To:From:Cc:Date:From:Subject:Sender;
    bh=ApmdAJYpsCv/5T/UcEditewzDgxqXXiJO08Id+kh4WU=;
    b=Med2DHtKXuhp9oieHpIVYT9ixccTiHMvf6tpkGvKIStYdsdgjZKz6I+GXgdH1/Wc3d
    nZjZRh6I9+YRbcKy4CBw==
X-RZG-AUTH: ":P2ERcEykfu11Y98lp/T7+hdri+uKZK8TKWEqNyiHySGSa9k9y2gdNk2TvDz0d0u0OAA="
Received: from positron.chronox.de
    by smtp.strato.de (RZmta 49.4.0 AUTH)
    with ESMTPSA id ta02b6z37BvAFUX
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
        (Client did not present a certificate);
    Fri, 7 Apr 2023 13:57:10 +0200 (CEST)
From:   Stephan =?ISO-8859-1?Q?M=FCller?= <smueller@chronox.de>
To:     linux-crypto@vger.kernel.org, herbert@gondor.apana.org.au
Cc:     Vladis Dronov <vdronov@redhat.com>,
        Marcelo Cerri <marcelo.cerri@canonical.com>
Subject: [PATCH 0/2] crypto: jitter - SHA-3 conditioner and test interface
Date:   Fri, 07 Apr 2023 13:52:11 +0200
Message-ID: <2684670.mvXUDI8C0e@positron.chronox.de>
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




