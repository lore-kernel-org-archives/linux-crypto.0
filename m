Return-Path: <SRS0=5sM8=RP=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: *
X-Spam-Status: No, score=1.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,
	UNWANTED_LANGUAGE_BODY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A8C09C43381
	for <linux-crypto@archiver.kernel.org>; Tue, 12 Mar 2019 18:47:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 68701206BA
	for <linux-crypto@archiver.kernel.org>; Tue, 12 Mar 2019 18:47:01 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="AgfTy5CU"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726490AbfCLSrA (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 12 Mar 2019 14:47:00 -0400
Received: from mail-ed1-f48.google.com ([209.85.208.48]:45026 "EHLO
        mail-ed1-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726360AbfCLSrA (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 12 Mar 2019 14:47:00 -0400
Received: by mail-ed1-f48.google.com with SMTP id b20so3191448edw.11;
        Tue, 12 Mar 2019 11:46:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=SCi6tpE6CE+oDHDs6uNwg+g/KpfaHm6pqUvqq5nu1P0=;
        b=AgfTy5CUObOTUHf3Gv870pXCCRYK555MubczC19t5tKT1CFT5+qitUNCTuUGeIRmLC
         XQNSDKhPngr+wwWu0DxtiRRowOhuqpbaaWTMBVUXcrEqMSh+HUL9I8l8vnNzazrhx/Lz
         rd/wujrNnHDutriHvRaipZcGRjCqEyOfU+/xHdras0stbK8PRWU0hDIG0BktSpnZNLD/
         ANZv7gPK/Ayr/1TdjpuI0MmY7UGhoMJLputPWhLsgmnjlQx2C5xBhJEN45OdO5XccyZy
         iOOSzednDiUFmSn6OrCYDc22B7u77BXKZxKzuBzCd7ER5QYPvBN9zX+ioE16ykv2y/NZ
         vy0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=SCi6tpE6CE+oDHDs6uNwg+g/KpfaHm6pqUvqq5nu1P0=;
        b=bDu87wNqfm6y/kxdNUXYl/H899+e0H2By+Pvozp0gAXq2iHbkxdlSf041UZKQLl0NN
         /mqX2Zzw6ttnrPDV8g+gyxdHi3flpxcgxv4p4ioTAgxvP593qM829LmzdntGInSFhxOB
         GBCyHlYKmAuJtqmKTPLwF0jZwZoiL45/gaiiZL4FXx5kfs/hqG1K0bO33rHWz6r4xn7d
         6rD2Qo382GItZ6cD671S+ebK9FYB4l0HLJGHJTj32J+0iHQ4ZVJfvQQPv7N9lY62qFGV
         dLXXSj28NiOw9w2rLOBHipBWzVTmEcX5fcDqbmqOJs23v1bHLq4QoGxXLLZPZz/aLxz4
         wdKA==
X-Gm-Message-State: APjAAAWkLSGwZkziOqIOCI0dHubHGxbsU56/9MwLRnbr5qkzS/XG7iYo
        69wfiZO/n5lbNqDJZYCUfTKdiRewUo1m3wlYnv9PnQKF
X-Google-Smtp-Source: APXvYqx81btzgYfTrk86gZIPcNAOzN8oIlYRZSnu7/ziNGe0HU7nPU0orno/LySBltF0rbOU4YJKXdFmD6IrjLi4jx0=
X-Received: by 2002:a50:971b:: with SMTP id c27mr4658048edb.171.1552416418554;
 Tue, 12 Mar 2019 11:46:58 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a50:aa0a:0:0:0:0:0 with HTTP; Tue, 12 Mar 2019 11:46:57
 -0700 (PDT)
From:   Jari Ruusu <jari.ruusu@gmail.com>
Date:   Tue, 12 Mar 2019 20:46:57 +0200
Message-ID: <CACMCwJKuE0R_J46sFdDjUYSkBbUP_YqymTEcSL0m-xwmDWep_w@mail.gmail.com>
Subject: Announce loop-AES-v3.7n file/swap crypto package
To:     linux-crypto@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

loop-AES changes since previous release:
- Worked around kernel interface changes on 5.0 kernels.
- Some #ifdef spaghetti removed for 5.x kernels.


bzip2 compressed tarball is here:

    http://loop-aes.sourceforge.net/loop-AES/loop-AES-v3.7n.tar.bz2
    md5sum 615393772cd9b51cfaad646265aa4f11

    http://loop-aes.sourceforge.net/loop-AES/loop-AES-v3.7n.tar.bz2.sign

-- 
Jari Ruusu  4096R/8132F189 12D6 4C3A DCDA 0AA4 27BD  ACDF F073 3C80 8132 F189
