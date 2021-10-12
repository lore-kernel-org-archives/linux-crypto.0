Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9B921C433FE
	for <linux-crypto@archiver.kernel.org>; Tue, 12 Oct 2021 02:18:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8241D60C41
	for <linux-crypto@archiver.kernel.org>; Tue, 12 Oct 2021 02:18:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231652AbhJLCUx (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 11 Oct 2021 22:20:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231665AbhJLCUw (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 11 Oct 2021 22:20:52 -0400
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91D50C06161C;
        Mon, 11 Oct 2021 19:18:51 -0700 (PDT)
Received: by mail-pj1-x102a.google.com with SMTP id ls18-20020a17090b351200b001a00250584aso755993pjb.4;
        Mon, 11 Oct 2021 19:18:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id;
        bh=t6cTT3Lets2qCZJ6yoPuMJXToevhV5p9SGzVR+zI2lY=;
        b=TmGWzh2k+ljQdJ5F/pvTA4Ezsj90Vddu/Ko7WS+u1rSpl6TtV/2iGLaxl16JwMS5JW
         2NEB9yQeGQ9KaGZliIsJ2hRjxW74t/MmQOaQhxLYO3WYPO1v68/SXPT9qfPKSoyYbweI
         QeFpqiQPbJIF1NGSsB1ze226mJTJhw/odyeEKAD3Qk72jtYAciKL0LlLTezp7HgTgbhw
         zKE4Jhwl+PZpKZtdctN1Cjq2jaGXAJSbRvwMqu7w5uMqyeCLa4z8cQTQs5ICM9uBQ2de
         JCRvehxfXbeRnZYiPh/VNdxUTC4ukbLZ5cNkjFZ1pxeoSFjUrl9NBP5Y4APYtTyaRAkm
         NMPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=t6cTT3Lets2qCZJ6yoPuMJXToevhV5p9SGzVR+zI2lY=;
        b=ggOookxGZYRi4Qw+0gqkuJUn9rzeSOGmXvFumMyBEIHvSmqpgDDZ3u+gAStE4HmD9d
         FT9pc4hjmboQ+bGGsPFQxH8B72pwZF9NLUVdlFHIcGZ8ngKXiB4qMSiuq85MT7XLfVSw
         BIEVbPuP0Bs9OLe8+xbf6GoudVL4ubPOCCpQp77M4P92CnLOqBahdtc5neWjZqGwkBNa
         pgJhw8mKODIVFv6JhAjxDPDIvRaVe78SEsr8Ao+NZfof+8qGUYKHEUu9/hcL/LclFB6R
         tgqmvHIxby4hqqH9VVVYmLy5llyxagT3yUoU6NN9O3v2Yj9OTnNtj302aQCqzluRLtIJ
         +S2g==
X-Gm-Message-State: AOAM530xARucdfe2cE0dqrnB/4INtzLv5BXCRy5OxkCo2JJ2X3SqOLfu
        b9DGVZ9s+On7YMLJMNlMfDe2X3bNOiA=
X-Google-Smtp-Source: ABdhPJzTN6JWNeW71vi9e6fL+sSY/FMxxaTVCkDqq2WTJi9C3Yrj7PbSohz8pQgxX2CWgGPeWXFhpg==
X-Received: by 2002:a17:90a:47:: with SMTP id 7mr2972395pjb.46.1634005130652;
        Mon, 11 Oct 2021 19:18:50 -0700 (PDT)
Received: from localhost.localdomain ([162.14.23.249])
        by smtp.gmail.com with ESMTPSA id l207sm8963835pfd.199.2021.10.11.19.18.48
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 11 Oct 2021 19:18:50 -0700 (PDT)
From:   Hongbo Li <herbert.tencent@gmail.com>
To:     linux-crypto@vger.kernel.org, herbert@gondor.apana.org.au,
        herberthbli@tencent.com
Cc:     linux-kernel@vger.kernel.org, Hongbo Li <herbert.tencent@gmail.com>
Subject: [PATCH v3 0/5] crypto: add eddsa support for x509
Date:   Tue, 12 Oct 2021 10:17:51 +0800
Message-Id: <1634005076-17534-1-git-send-email-herbert.tencent@gmail.com>
X-Mailer: git-send-email 1.8.3.1
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

This series of patches add support for x509 cert signed by eddsa,
which is described in RFC8032 [1], currently ed25519 only.

Curve25519 is an elliptic curve used for key agreement(ECDH).
It is a Montgomery curve.

Edwards25519 is a twisted Edwards curve and birationally equivalent
to Curve25519, the birational maps are described in rfc7748 section 4.1.[2]
Ed25519 is a Digital Signature Algorithm over Edwards25519.

The kernel's curve25519 code is used for ECDH, such as set_secret(),
generate_public_key() and compute_shared_secret(), these are useless
for eddsa, and can not be reused, eddsa do the verification on the
given public key and signature.

According to RFC8032 section 4 [3], there're two variants: PureEdDSA and
HashEdDSA. These patches support PureEdDSA which named Ed25519.

Patch1 exports some mpi common functions.

Patch2 makes x509 layer support eddsa.

Patch3 moves some common code in sm2 to separate files. These code is also
       used by eddsa.

Patch4 is the implementation of eddsa verification according to RFC8032
       section 5.1.7 [4].

Patch5 adds test vector for eddsa.

Test by the following script:

keyctl newring test @u

while :; do
    certfile="cert.der"

    openssl req \
            -x509 \
            -newkey ED25519 \
            -keyout key.pem \
            -days 365 \
            -subj '/CN=test' \
            -nodes \
            -outform der \
            -out ${certfile} 2>/dev/null

    exp=0
    id=$(keyctl padd asymmetric testkey %keyring:test < "${certfile}")
    rc=$?
    if [ $rc -ne $exp ]; then
        case "$exp" in
            0) echo "Error: Could not load ed25519 certificate $certfile!";
        esac
        exit 1
    else
        case "$rc" in
            0) printf "load ed25519 cert keyid: %-10s\n" $id;
        esac
    fi
done

Best Regards
Hongbo

[1] https://datatracker.ietf.org/doc/html/rfc8032
[2] https://datatracker.ietf.org/doc/html/rfc7748#section-4.1
[3] https://datatracker.ietf.org/doc/html/rfc8032#section-4
[4] https://datatracker.ietf.org/doc/html/rfc8032#section-5.1.7

v1->v2:
  -fix the warning "warning: no previous prototype"
   reported-by: kernel test robot <lkp@intel.com>
  -add more comments about these patches

v2->v3:
  -remove the v2-0001-crypto-fix-a-memory-leak-in-sm2.patch and
   v2-0002-lib-mpi-use-kcalloc-in-mpi_resize.patch from patch series,
   because they have been merged into kernel.

Hongbo Li (5):
  lib/mpi: export some common function
  x509: add support for eddsa
  crypto: move common code in sm2 to ec_mpi.c and ec_mpi.h
  crypto: ed25519 cert verification
  crypto: add eddsa test vector

 crypto/Kconfig                            |  15 ++
 crypto/Makefile                           |   4 +
 crypto/asymmetric_keys/public_key.c       |  73 ++++++-
 crypto/asymmetric_keys/x509_cert_parser.c |  14 +-
 crypto/asymmetric_keys/x509_public_key.c  |   4 +-
 crypto/ec_mpi.c                           |  82 ++++++++
 crypto/ec_mpi.h                           |  37 ++++
 crypto/eddsa.c                            | 326 ++++++++++++++++++++++++++++++
 crypto/sm2.c                              |  98 +--------
 crypto/testmgr.c                          |   6 +
 crypto/testmgr.h                          |  32 +++
 include/linux/oid_registry.h              |   1 +
 lib/mpi/mpi-add.c                         |   4 +-
 13 files changed, 589 insertions(+), 107 deletions(-)
 create mode 100644 crypto/ec_mpi.c
 create mode 100644 crypto/ec_mpi.h
 create mode 100644 crypto/eddsa.c

-- 
1.8.3.1

