Return-Path: <SRS0=bUM2=WR=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,INCLUDES_PULL_REQUEST,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 50AF8C3A59E
	for <linux-crypto@archiver.kernel.org>; Wed, 21 Aug 2019 09:19:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 20D0522DA7
	for <linux-crypto@archiver.kernel.org>; Wed, 21 Aug 2019 09:19:03 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="owjf5ozH"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726447AbfHUJTC (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 21 Aug 2019 05:19:02 -0400
Received: from mail-lj1-f193.google.com ([209.85.208.193]:36845 "EHLO
        mail-lj1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726425AbfHUJTC (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 21 Aug 2019 05:19:02 -0400
Received: by mail-lj1-f193.google.com with SMTP id u15so1464029ljl.3
        for <linux-crypto@vger.kernel.org>; Wed, 21 Aug 2019 02:19:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=tUd0zabNgRGIWQQLoD4aLQLc4AhyYftLwRBXYM93gBs=;
        b=owjf5ozHccwHns0IT2uiMNlWSabmW6qE7YFtLi2GqwB7tbXO9LpHfT8kggM29Bfa3o
         xFmIobFylprAaz//da2YA9Ply2QiEVkO7PupMV0Yy5e9RsAp79JiRjpv6UY7cLQqcyVm
         DZmO0KCGrrg69i/3TUBcMqMbB2ScsLJsu7dBL6/rNeW3vNp9D6mH2Ki3MyJAoL7/yeWL
         VwG5gaIPodQzLLj+6uODoX3rOFldj2ap/W2pMKXenTMAqVyhDE5N9CQo4NKg+XtoXmJk
         JZ08vUACCf3iCsmOfFV0Mr+uOHmuQrM8lBHBFKJTLFgl5fhysvU4o9rlqAZUNWh/PNnG
         ESRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=tUd0zabNgRGIWQQLoD4aLQLc4AhyYftLwRBXYM93gBs=;
        b=CZ9r3ScvT2e9YaMXYSHuooPdTCFKOe69dq/4/7rX8b1cjXZ19a8L/YzEDMzWTaOSRO
         grnEPkLLPL4CMkOzHPwXJ9LlZpIAuWt2rwy8fI4dHAjscrtZBxVOjSRi/axHEBylsL3y
         YyeRB728MJYc6NVbEi3m0qz2AXqyRcgDO++4svrwOCAv/SwTmKZDxIJvKUMelvpGHqHH
         0y1G0LBUDVyBMagjUX7JWpidd7Th/u27HmvH+ezMdC6cre482Gw5xlIFJ6BeL6ADnV0u
         yn9cf3pMFRci+1ibiehj/dvLUBKqnqn+GFHOoglzaEA1mXiegN45fEYRow+X6d6lUqOc
         oakg==
X-Gm-Message-State: APjAAAUBUcfrMknS2e+joUc4hERf5TqHiIUUAKvfdN2K8PqRvoK6Z38E
        XAeN5evf8ONGZsdGo/bCZSgDyy8GyBCmNCzjNiM6ubYt
X-Google-Smtp-Source: APXvYqyAduugRk6fPokYkhHbOMhZDjbrs4UkJMLgFUpDLLZLSA4sAymgz7kcLCON1bnays2SCm5If2cuRbATNL8et7s=
X-Received: by 2002:a2e:93cc:: with SMTP id p12mr12726895ljh.11.1566379139908;
 Wed, 21 Aug 2019 02:18:59 -0700 (PDT)
MIME-Version: 1.0
From:   Pascal van Leeuwen <pascalvanl@gmail.com>
Date:   Wed, 21 Aug 2019 11:18:49 +0200
Message-ID: <CAK9qPMC34ANoTR1mR6hrUq4gMztZ_BORW3ypuZ_ZUYFFqTOpng@mail.gmail.com>
Subject: [GIT PULL v2] inside-secure: add new "mini" firmware for the EIP197 driver
To:     linux-firmware@kernel.org
Cc:     linux-crypto@vger.kernel.org,
        Pascal van Leeuwen <pvanleeuwen@verimatrix.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

The following changes since commit 07b925b450bfb4cf3e141c612ec5b104658cd020:

  Install only listed firmware files (2019-08-15 07:46:53 -0400)

are available in the git repository at:

  https://github.com/pvanleeuwen/linux-firmware-clean.git is_driver_fw2

for you to fetch changes up to 728c53fbddc22ebaf49783de1fda7c4c66bde120:

  inside-secure: add new "mini" firmware for the EIP197 driver
(2019-08-21 09:45:26 +0200)

----------------------------------------------------------------

changes since v1:
- changed license type from GPLv2 to redistributable

Pascal van Leeuwen (1):
      inside-secure: add new "mini" firmware for the EIP197 driver

 WHENCE                               |  16 ++++++++++++++++
 inside-secure/eip197_minifw/ifpp.bin | Bin 0 -> 100 bytes
 inside-secure/eip197_minifw/ipue.bin | Bin 0 -> 108 bytes
 3 files changed, 16 insertions(+)
 create mode 100644 inside-secure/eip197_minifw/ifpp.bin
 create mode 100644 inside-secure/eip197_minifw/ipue.bin

diff --git a/WHENCE b/WHENCE
index 9b2f476..cb2660b 100644
--- a/WHENCE
+++ b/WHENCE
@@ -4516,3 +4516,19 @@ File: meson/vdec/gxl_mpeg4_5.bin
 File: meson/vdec/gxm_h264.bin

 Licence: Redistributable. See LICENSE.amlogic_vdec for details.
+
+--------------------------------------------------------------------------
+
+Driver: inside-secure -- Inside Secure EIP197 crypto driver
+
+File: inside-secure/eip197_minifw/ipue.bin
+File: inside-secure/eip197_minifw/ifpp.bin
+
+Licence: Redistributable.
+ Copyright (c) 2019 Verimatrix, Inc.
+
+  Derived from proprietary unpublished source code.
+  Permission is hereby granted for the distribution of this firmware
+  as part of Linux or other Open Source operating system kernel,
+  provided this copyright notice is accompanying it.
+
diff --git a/inside-secure/eip197_minifw/ifpp.bin
b/inside-secure/eip197_minifw/ifpp.bin
new file mode 100644
index 0000000..b4a8322
Binary files /dev/null and b/inside-secure/eip197_minifw/ifpp.bin differ
diff --git a/inside-secure/eip197_minifw/ipue.bin
b/inside-secure/eip197_minifw/ipue.bin
new file mode 100644
index 0000000..2f54999
Binary files /dev/null and b/inside-secure/eip197_minifw/ipue.bin differ
