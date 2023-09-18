Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 713E4CD13DA
	for <linux-crypto@archiver.kernel.org>; Mon, 18 Sep 2023 15:35:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229534AbjIRPez (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 18 Sep 2023 11:34:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229699AbjIRPeb (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 18 Sep 2023 11:34:31 -0400
Received: from mail-lf1-x12a.google.com (mail-lf1-x12a.google.com [IPv6:2a00:1450:4864:20::12a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE3E21731
        for <linux-crypto@vger.kernel.org>; Mon, 18 Sep 2023 08:32:40 -0700 (PDT)
Received: by mail-lf1-x12a.google.com with SMTP id 2adb3069b0e04-502e7d66c1eso7244652e87.1
        for <linux-crypto@vger.kernel.org>; Mon, 18 Sep 2023 08:32:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sigma-star.at; s=google; t=1695050980; x=1695655780; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=VFchyKYZaSrX7EMCsBGCn2uZcmTzjow+NxNlenZjDxg=;
        b=vS+Uj/0VqGh8hawGLF+NaUITCll8GzMd9Qr8rVc6Qzi7uDDAWYhKGRuimp0PWDwlQr
         2x/UCLmV4lP48chVOyyXIFklCfGxOT/sDO8/hUzUxQIdLW0lll+GSEBA6Ki+H76evEgF
         yiV4ZKeE5l7pxKszWoh1HU4U13wRnXv35XKol1HOwqbsW3x796ofoE4iQy4V+gE2GMAN
         odOaSQU8GlETNdmmL1ovvad1L4ZDYo+UIknlv9ftl8LUjAstVHogXpukwWn++sZa0Ptu
         eYJARZ6g1wZcCMQklgMGz/4f5lImPq4RTkDo4T5nC+vv+TpYO6V+5vVuar+LYcsn8E+i
         Pv+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695050980; x=1695655780;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=VFchyKYZaSrX7EMCsBGCn2uZcmTzjow+NxNlenZjDxg=;
        b=ojeUCJpJqbb7dVaMactyL3rSvhuSEuPcQ5pAilcy3atpFLvxoAX/7hjmqJzurzRgUW
         dfJqQlZJRChMU2eeOg8j9TnSyu44oqLj5M7eItrxeqV/DG3I83ShPKEjo6Z4TKwMJbjR
         OglNRXJ4EFEk8Rh08cOvej2lWtTKiyb3JEhO1H1A7Wn8xmjV+f9lA2gMJmdKN62oinvZ
         iIso/xMMg3dNBLX6cD/EC++eKG9+sw/Pax8geAz6ZTp6T0usuqd4AjF14xbpzKua3Bht
         Uny7O0AvnKtAxZeFxOhl8nqWccrFEbYFXIey4fot4SfUSnTQFZM9VmnybkVikzQVoVkb
         9hqg==
X-Gm-Message-State: AOJu0YxqH4zHcpTm3wDB0VzrSvxndxvfV5OSJ4SwmzRSJ/nik+Nc7XlJ
        sD62Ic1nbGJoB7xd3pHJ6BqkVjwIzIRMMSDHpK1T/Q==
X-Google-Smtp-Source: AGHT+IGZY9EAv9fq5jtqbWievBVWv5LiwqHR3LyOgh3sgu5FxK83H5apmVz53SdQ15aJu5RB2fhOsg==
X-Received: by 2002:a05:6402:28ac:b0:530:8d55:9c69 with SMTP id eg44-20020a05640228ac00b005308d559c69mr8040854edb.11.1695046714597;
        Mon, 18 Sep 2023 07:18:34 -0700 (PDT)
Received: from localhost ([82.150.214.1])
        by smtp.gmail.com with UTF8SMTPSA id f23-20020a056402161700b00525503fac84sm6031869edv.25.2023.09.18.07.18.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 18 Sep 2023 07:18:34 -0700 (PDT)
From:   David Gstir <david@sigma-star.at>
To:     Mimi Zohar <zohar@linux.ibm.com>,
        James Bottomley <jejb@linux.ibm.com>,
        Jarkko Sakkinen <jarkko@kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Cc:     David Gstir <david@sigma-star.at>, Shawn Guo <shawnguo@kernel.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        Fabio Estevam <festevam@gmail.com>,
        NXP Linux Team <linux-imx@nxp.com>,
        Ahmad Fatoum <a.fatoum@pengutronix.de>,
        sigma star Kernel Team <upstream+dcp@sigma-star.at>,
        David Howells <dhowells@redhat.com>,
        Li Yang <leoyang.li@nxp.com>, Paul Moore <paul@paul-moore.com>,
        James Morris <jmorris@namei.org>,
        "Serge E. Hallyn" <serge@hallyn.com>,
        "Paul E. McKenney" <paulmck@kernel.org>,
        Randy Dunlap <rdunlap@infradead.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Tejun Heo <tj@kernel.org>,
        "Steven Rostedt (Google)" <rostedt@goodmis.org>,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-integrity@vger.kernel.org, keyrings@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linuxppc-dev@lists.ozlabs.org,
        linux-security-module@vger.kernel.org
Subject: [PATCH v3 0/3] DCP as trusted keys backend
Date:   Mon, 18 Sep 2023 16:18:22 +0200
Message-ID: <20230918141826.8139-1-david@sigma-star.at>
X-Mailer: git-send-email 2.42.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

This is a revival of the previous patch set submitted by Richard Weinberger:
https://lore.kernel.org/linux-integrity/20210614201620.30451-1-richard@nod.at/

v2 is here:
https://lore.kernel.org/keyrings/20230912111115.24274-1-david@sigma-star.at/

v2 -> v3:
- Addressed review comments from Jarkko Sakkinen
v1 -> v2:
- Revive and rebase to latest version
- Include review comments from Ahmad Fatoum

The Data CoProcessor (DCP) is an IP core built into many NXP SoCs such
as i.mx6ull.

Similar to the CAAM engine used in more powerful SoCs, DCP can AES-
encrypt/decrypt user data using a unique, never-disclosed,
device-specific key. Unlike CAAM though, it cannot directly wrap and
unwrap blobs in hardware. As DCP offers only the bare minimum feature
set and a blob mechanism needs aid from software. A blob in this case
is a piece of sensitive data (e.g. a key) that is encrypted and
authenticated using the device-specific key so that unwrapping can only
be done on the hardware where the blob was wrapped.

This patch series adds a DCP based, trusted-key backend and is similar
in spirit to the one by Ahmad Fatoum [0] that does the same for CAAM.
It is of interest for similar use cases as the CAAM patch set, but for
lower end devices, where CAAM is not available.

Because constructing and parsing the blob has to happen in software,
we needed to decide on a blob format and chose the following:

struct dcp_blob_fmt {
	__u8 fmt_version;
	__u8 blob_key[AES_KEYSIZE_128];
	__u8 nonce[AES_KEYSIZE_128];
	__le32 payload_len;
	__u8 payload[];
} __packed;

The `fmt_version` is currently 1.

The encrypted key is stored in the payload area. It is AES-128-GCM
encrypted using `blob_key` and `nonce`, GCM auth tag is attached at
the end of the payload (`payload_len` does not include the size of
the auth tag).

The `blob_key` itself is encrypted in AES-128-ECB mode by DCP using
the OTP or UNIQUE device key. A new `blob_key` and `nonce` are generated
randomly, when sealing/exporting the DCP blob.

This patchset was tested with dm-crypt on an i.MX6ULL board.

[0] https://lore.kernel.org/keyrings/20220513145705.2080323-1-a.fatoum@pengutronix.de/

David Gstir (3):
  crypto: mxs-dcp: Add support for hardware provided keys
  KEYS: trusted: Introduce support for NXP DCP-based trusted keys
  doc: trusted-encrypted: add DCP as new trust source

 .../admin-guide/kernel-parameters.txt         |  13 +
 .../security/keys/trusted-encrypted.rst       |  85 +++++
 MAINTAINERS                                   |   9 +
 drivers/crypto/mxs-dcp.c                      | 104 +++++-
 include/keys/trusted_dcp.h                    |  11 +
 include/soc/fsl/dcp.h                         |  17 +
 security/keys/trusted-keys/Kconfig            |   9 +-
 security/keys/trusted-keys/Makefile           |   2 +
 security/keys/trusted-keys/trusted_core.c     |   6 +-
 security/keys/trusted-keys/trusted_dcp.c      | 311 ++++++++++++++++++
 10 files changed, 554 insertions(+), 13 deletions(-)
 create mode 100644 include/keys/trusted_dcp.h
 create mode 100644 include/soc/fsl/dcp.h
 create mode 100644 security/keys/trusted-keys/trusted_dcp.c

-- 
2.35.3

