Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E6EAFEB64D9
	for <linux-crypto@archiver.kernel.org>; Mon, 10 Jul 2023 10:23:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230340AbjGJKX1 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 10 Jul 2023 06:23:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230064AbjGJKX1 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 10 Jul 2023 06:23:27 -0400
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E493594;
        Mon, 10 Jul 2023 03:23:22 -0700 (PDT)
Received: by mail-pl1-x632.google.com with SMTP id d9443c01a7336-1b9d9cbcc70so1918275ad.0;
        Mon, 10 Jul 2023 03:23:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1688984601; x=1689589401;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=gYP2oWKwpGOXF3gV9wx85l1HhBMYJx0BpeXr6oBux0s=;
        b=EJYUqlWTVoCvlErini+i5t+RO+70VyZYNmqjGO2hkLVg3c419s6BVBkuZVfDDtOo/M
         IQERf7ZynzFsIzRLurkjcBsmQoVGTyjNXFGso5tnGMXF0LPE8neLGAyXDQPoNQTLNR0J
         ndktOzuBYrAYeEOiXkmBCaB33yXNr4wPOCzxn0hDBIXqZ46E1qze+HeI06+zjzUs9tu3
         e7V2LMF6uS6h5pUcT3IwtbvNEKtMEO0od9qvIKUy9EtNt1PnPtfwPGPTuKwrdf+gzSBp
         cHCbA+rp5weNWFS4A0/XQI+et1QbuRVFaH5MbKP8WwWoVL/jooVJYYi4qU0l9Qf6AJnp
         nYmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1688984601; x=1689589401;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=gYP2oWKwpGOXF3gV9wx85l1HhBMYJx0BpeXr6oBux0s=;
        b=Jro+tF+vHdu7WFM2PGpnf7blqB1M6sA3aHjYwriEMXez3pgJWYPdNSCeAt0COdhicH
         dJAQf929ZbEBQ3pIMIWMN6yygwMA6LE5C2mK7TYtAVvSVdgmTxy+Q8eFmfXAQTFY1WKO
         KfXkdHFai3xAe9ALzDK/1F2lqtrArMl3gEjF5l3pjBgzdEppqjyhLlk16tJxSGSkJ5uQ
         J/bOfBYxf4Vusd/pFEu75n9q0RUOedEEfbhzNUPEmQtKgmLIQE59FxpPQI9teH125qOX
         Ov1cao/0R1VsKnHjsGQeqzJEX1jsZqOgyEyrNlvmSb/tBJRmZO5Ij8zQ78EiFktAd0K/
         jMfg==
X-Gm-Message-State: ABy/qLYdBzVlL5D3KxqOK1jnNSzZW70Y6uelg6x5Rfbtsa/4K4PRAJ64
        AiR36mzKE5/cTVO+F06VZTfjsvlMkc3yaUfn
X-Google-Smtp-Source: APBJJlFEhjGCfMce/+E/qYSulVNW83uVugXINUUBvPGoo4EsWajDf6oelw7kh6WYg7ou6pZVxafa8A==
X-Received: by 2002:a17:902:da92:b0:1b3:d8ac:8db3 with SMTP id j18-20020a170902da9200b001b3d8ac8db3mr15565140plx.6.1688984601091;
        Mon, 10 Jul 2023 03:23:21 -0700 (PDT)
Received: from ip-172-30-47-114.us-west-2.compute.internal (ec2-54-68-170-188.us-west-2.compute.amazonaws.com. [54.68.170.188])
        by smtp.gmail.com with ESMTPSA id d5-20020a170902cec500b001b5656b0bf9sm7901984plg.286.2023.07.10.03.23.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 Jul 2023 03:23:20 -0700 (PDT)
From:   FUJITA Tomonori <fujita.tomonori@gmail.com>
To:     rust-for-linux@vger.kernel.org, linux-crypto@vger.kernel.org
Cc:     alex.gaynor@gmail.com, herbert@gondor.apana.org.au,
        ebiggers@kernel.org, benno.lossin@proton.me
Subject: [PATCH v2 0/3] Rust abstractions for Crypto API
Date:   Mon, 10 Jul 2023 19:22:22 +0900
Message-Id: <20230710102225.155019-1-fujita.tomonori@gmail.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

This patchset adds minimum Rust abstractions for Crypto API; message
digest and random number generator.

I'm trying to upstream network and crypto abstractions separately so
v2 has only crypto stuff.

Changes since v1 [1]:
- ShashDesc::new() returns the initialized object.
- checks the length of buffer.
- fix a compile error without CONFIG_CRYPTO.
- adds RNG support.
- drops network code.
- updates the CRYPTO API entry.

[1] https://lore.kernel.org/netdev/010101881db036fb-2fb6981d-e0ef-4ad1-83c3-54d64b6d93b3-000000@us-west-2.amazonses.com/T/

FUJITA Tomonori (3):
  rust: crypto abstractions for synchronous message digest API
  rust: crypto abstractions for random number generator API
  MAINTAINERS: add Rust crypto abstractions files to the CRYPTO API
    entry

 MAINTAINERS                     |   2 +
 rust/bindings/bindings_helper.h |   2 +
 rust/helpers.c                  |  38 ++++++++++
 rust/kernel/crypto.rs           |   6 ++
 rust/kernel/crypto/hash.rs      | 128 ++++++++++++++++++++++++++++++++
 rust/kernel/crypto/rng.rs       | 101 +++++++++++++++++++++++++
 rust/kernel/lib.rs              |   2 +
 7 files changed, 279 insertions(+)
 create mode 100644 rust/kernel/crypto.rs
 create mode 100644 rust/kernel/crypto/hash.rs
 create mode 100644 rust/kernel/crypto/rng.rs

-- 
2.34.1

