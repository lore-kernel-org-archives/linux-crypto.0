Return-Path: <SRS0=y31I=WC=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,INCLUDES_PULL_REQUEST,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 57AF4C433FF
	for <linux-crypto@archiver.kernel.org>; Tue,  6 Aug 2019 12:54:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1CFF420B1F
	for <linux-crypto@archiver.kernel.org>; Tue,  6 Aug 2019 12:54:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="IfRbbjGu"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729506AbfHFMyj (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 6 Aug 2019 08:54:39 -0400
Received: from mail-lj1-f178.google.com ([209.85.208.178]:35173 "EHLO
        mail-lj1-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728918AbfHFMyj (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 6 Aug 2019 08:54:39 -0400
Received: by mail-lj1-f178.google.com with SMTP id x25so82224371ljh.2
        for <linux-crypto@vger.kernel.org>; Tue, 06 Aug 2019 05:54:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=oGcUuvQkMqJuyLxeUSXyAzFKKfBgYSzIUmeWfk8uSh8=;
        b=IfRbbjGumscr4zZ4+SvX2dfuyaJ3vcjrO1igeRruEqCXqkaHoXBAGiUig+9YcIT8x7
         qbkjslapT/6bUAvSFRnY7J+hnh96yXUCi9a6eHqMZ3yrOFM68q9ZlANh60I3EdABpvJP
         ilKdrDGUtr4SVkc4M+BhcuqhIMGpWkXROiQw24UHAYQ0W+qu6mu23Cv7+05GEVDLOodX
         CuYIYr3vu9auLU+Cl719UxzXRfUMEKG/GAWeEWzsTudP9qDm2/twvZ0qohV2l+ZJi0Lk
         y6vmH2xUZc02DgNtieAkYx3B/2UE5GW80Gzh9U5HeaRSd3u6wK4bfx/1ifgXjsqpMY37
         gfiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=oGcUuvQkMqJuyLxeUSXyAzFKKfBgYSzIUmeWfk8uSh8=;
        b=P9SscoUX6YJkoQY8MbH0pYlarYzYy5nk6fHbzKW7nMsXN2311osv4o6m7TfOAtOZAi
         cuOAAOkkfsuvLpd4y4yPaowJJ17punRzEwWBYnUUsQSJ+Trb1freDQa9iXbtiiFccCl5
         Jh/QrVVmnh9DnzwtfB28ZY4gz2+UYH0SML0+UPMRn1CH5cI7ndvj3j0+/r5u5ZTzyJEB
         1y7VbCHGeU8AUae4H0B+1pYYVjygKxH0PVHnGUnHlgzIclaXtX0nc9zWsEz8XsyP7ktj
         eYxziBKIbyVwT/wy5OHVYjQvhmMTay6Zw9fTLLBT/9pM7YNB4ldu45sV+OxUZwRxHFv/
         DswA==
X-Gm-Message-State: APjAAAVT0uWaZzIO1wN96sc+sKtsVNd1xQRD2uKhw264mjPaJVobWn6r
        SfKS/ZSZQhSJVu2a0fXycqkBAQHys7ahVNfnzKKxPP+R
X-Google-Smtp-Source: APXvYqxomcHM5CTwxb2/pzIFSGOGA6T9mmXaqMvox9vUtmrG41DBflQO+6X8V7rG30K11NURBrQWatCXJhKGhNlmmp4=
X-Received: by 2002:a05:651c:20d:: with SMTP id y13mr1674650ljn.204.1565096076879;
 Tue, 06 Aug 2019 05:54:36 -0700 (PDT)
MIME-Version: 1.0
From:   Pascal van Leeuwen <pascalvanl@gmail.com>
Date:   Tue, 6 Aug 2019 14:54:26 +0200
Message-ID: <CAK9qPMA=-MnkdpkUE_CU5FRmZ6LSk2FzfBJNsB0XRiaYxy9UWA@mail.gmail.com>
Subject: [GIT PULL] inside-secure: add new GPLv2 "mini" firmware for the
 EIP197 driver
To:     linux-firmware@kernel.org
Cc:     linux-crypto@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

The following changes since commit dff98c6c57383fe343407bcb7b6e775e0b87274f:

  Merge branch 'master' of git://github.com/skeggsb/linux-firmware
(2019-07-26 07:32:37 -0400)

are available in the git repository at:


  https://github.com/pvanleeuwen/linux-firmware-clean.git is_driver_fw

for you to fetch changes up to fbfe41f92f941d19b840ec0e282f422379982ccb:

  inside-secure: add new GPLv2 "mini" firmware for the EIP197 driver
(2019-08-06 13:19:44 +0200)

----------------------------------------------------------------
Pascal van Leeuwen (1):
      inside-secure: add new GPLv2 "mini" firmware for the EIP197 driver

 WHENCE                               |  10 ++++++++++
 inside-secure/eip197_minifw/ifpp.bin | Bin 0 -> 100 bytes
 inside-secure/eip197_minifw/ipue.bin | Bin 0 -> 108 bytes
 3 files changed, 10 insertions(+)
 create mode 100644 inside-secure/eip197_minifw/ifpp.bin
 create mode 100644 inside-secure/eip197_minifw/ipue.bin

diff --git a/WHENCE b/WHENCE
index 31edbd4..fce2ef7 100644
--- a/WHENCE
+++ b/WHENCE
@@ -4514,3 +4514,13 @@ File: meson/vdec/gxl_mpeg4_5.bin
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
+Licence: GPLv2. See GPL-2 for details.
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
