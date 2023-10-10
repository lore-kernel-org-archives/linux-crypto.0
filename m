Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C4F69CD98C6
	for <linux-crypto@archiver.kernel.org>; Tue, 10 Oct 2023 21:25:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344063AbjJJVZq (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 10 Oct 2023 17:25:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343941AbjJJVZp (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 10 Oct 2023 17:25:45 -0400
Received: from smtp-relay-internal-0.canonical.com (smtp-relay-internal-0.canonical.com [185.125.188.122])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A48A994
        for <linux-crypto@vger.kernel.org>; Tue, 10 Oct 2023 14:25:43 -0700 (PDT)
Received: from mail-pl1-f199.google.com (mail-pl1-f199.google.com [209.85.214.199])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-0.canonical.com (Postfix) with ESMTPS id C267E3F231
        for <linux-crypto@vger.kernel.org>; Tue, 10 Oct 2023 21:25:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1696973138;
        bh=4UvItTACB+h7HBV2ug6VBd/ji6l7lMzN70Cv1HLypsg=;
        h=From:To:Cc:Subject:Date:Message-Id:MIME-Version;
        b=sm5He0OYV60PLj3ngvt0TcDQmF1CYL/mjpsimEJpizp+e/tirBGPuuznwTbZhcl9b
         DhttDb1SOY8bpLFYun3cUteYb3+IZrt8/e7vr1C96NqDp17yV1bhsYIG1QSFg5ahsO
         a0x/cLyZHKWCy9dIwe/BRLru3Vkf7z3iRwI96xLlWcpRuRfurhBBytUuHV7BibgW/6
         Pj1fcyBaheQCJNW09vVN3ghl6bsjLl8/GcrDUijfk7iV4GVVAUfMvtU7FTp3bLdpOi
         lZ8wahns1UUwEhTDnFf03tfs+aeRYT4dufZZI2xfkal3FpXA6AzyYNnFdkzyDitqi4
         i7tYZWeo35C/w==
Received: by mail-pl1-f199.google.com with SMTP id d9443c01a7336-1c9b94edb1dso9854465ad.2
        for <linux-crypto@vger.kernel.org>; Tue, 10 Oct 2023 14:25:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696973137; x=1697577937;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=4UvItTACB+h7HBV2ug6VBd/ji6l7lMzN70Cv1HLypsg=;
        b=AZ8sx23XEr545F/Y/h2IhnHAifi51lMWQYRswqj5DtVJeEgEiS0VtQRbEqHadNfMsc
         sk+CvZdrR40f4yNADpqzcudMhReMzDE2MkaVl0zlktPhz4bLNGvX5i7mdsKZT/TgKFUm
         AsSrx4jRULTQ09Wya7v5ZoIRRBVGtwwmn7qa6jV5FkJ/gt9tcHQHGkKwpuhuxwXtEQvt
         l0C3bb2TRz1Lx6KsFQenX8cNxwXDHJ2Ugoui0L7FN+4gwVriIDpWWwhBl4K3jR2p8rK4
         HUXlEJ4Pg5m4WWlk7JqtTUnDF8NCTerlxL3Nk/HlCBiYS3Y8xl2oMsVXlVNVPRU/J+E8
         4bRw==
X-Gm-Message-State: AOJu0YxIIWdGmD8HFN9IiiXhxsfmlCqtcP49PFCOVNTvApxdlDwIO5ev
        9mGrsx318Z1BEeFcpZ6FeUyJkDuCuR1NpFcxze3g1PM5Df6DfnM43FZEzM2AMZJOt4Ao4OuK8GI
        GQ+FSFwnCod2DoQZ+9Ec96gYx/rE6F6ncPARbz0nazQ==
X-Received: by 2002:a17:902:e549:b0:1c5:70d3:f193 with SMTP id n9-20020a170902e54900b001c570d3f193mr22210213plf.10.1696973137452;
        Tue, 10 Oct 2023 14:25:37 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGHEguQ4N7lg7aridkHxtyB/VfYcw1MjO95tRaY7miJA3ybH/DJ6WxOMs1XQBczR1JDzMvAWA==
X-Received: by 2002:a17:902:e549:b0:1c5:70d3:f193 with SMTP id n9-20020a170902e54900b001c570d3f193mr22210195plf.10.1696973137142;
        Tue, 10 Oct 2023 14:25:37 -0700 (PDT)
Received: from localhost ([2001:67c:1560:8007::aac:c15c])
        by smtp.gmail.com with ESMTPSA id a4-20020a170902ecc400b001bdc3768ca5sm12222073plh.254.2023.10.10.14.25.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Oct 2023 14:25:36 -0700 (PDT)
From:   Dimitri John Ledkov <dimitri.ledkov@canonical.com>
To:     David Howells <dhowells@redhat.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Cc:     keyrings@vger.kernel.org, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] crypto: mscode_parser: remove sha224 authenticode support
Date:   Tue, 10 Oct 2023 22:25:29 +0100
Message-Id: <20231010212530.63470-1-dimitri.ledkov@canonical.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

It is possible to stand up own certificates and sign PE-COFF binaries
using SHA-224. However it never became popular or needed since it has
similar costs as SHA-256. Windows Authenticode infrastructure never
had support for SHA-224, and all secureboot keys used fro linux
vmlinuz have always been using at least SHA-256.

Given the point of mscode_parser is to support interoperatiblity with
typical de-facto hashes, remove support for SHA-224 to avoid
posibility of creating interoperatibility issues with rhboot/shim,
grub, and non-linux systems trying to sign or verify vmlinux.

SHA-224 itself is not removed from the kernel, as it is truncated
SHA-256. If requested I can write patches to remove SHA-224 support
across all of the drivers.

Signed-off-by: Dimitri John Ledkov <dimitri.ledkov@canonical.com>
---
 crypto/asymmetric_keys/mscode_parser.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/crypto/asymmetric_keys/mscode_parser.c b/crypto/asymmetric_keys/mscode_parser.c
index 6416bded0e..855cbc46a9 100644
--- a/crypto/asymmetric_keys/mscode_parser.c
+++ b/crypto/asymmetric_keys/mscode_parser.c
@@ -84,9 +84,6 @@ int mscode_note_digest_algo(void *context, size_t hdrlen,
 	case OID_sha512:
 		ctx->digest_algo = "sha512";
 		break;
-	case OID_sha224:
-		ctx->digest_algo = "sha224";
-		break;
 
 	case OID__NR:
 		sprint_oid(value, vlen, buffer, sizeof(buffer));
-- 
2.34.1

