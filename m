Return-Path: <SRS0=ccn8=ZY=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CA9C9C432C0
	for <linux-crypto@archiver.kernel.org>; Mon,  2 Dec 2019 14:47:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9B8442073C
	for <linux-crypto@archiver.kernel.org>; Mon,  2 Dec 2019 14:47:02 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="XBzzd//E"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727391AbfLBOrC (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 2 Dec 2019 09:47:02 -0500
Received: from mail-wm1-f66.google.com ([209.85.128.66]:54325 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727362AbfLBOrC (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 2 Dec 2019 09:47:02 -0500
Received: by mail-wm1-f66.google.com with SMTP id b11so22113406wmj.4
        for <linux-crypto@vger.kernel.org>; Mon, 02 Dec 2019 06:47:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=1OEEXNFhLWdVUoPK1KEMZ6ZVl5lL6eOjxFar5Jt1bvM=;
        b=XBzzd//Ej7ZVAohSTQNulkS1LROonP+B1EWp3R3bLHVyeqrYG/1jQcb6+UkcKdqT41
         550WoWAO4GWHjLUPOAsotAZk7tJENN0uv1EABJHwbtThMYfkuusK/OaL2Rvb3EB9Gb+2
         s6SVAnHXfC6h5kRh+WfXjcWqhxNDJbQaNMoM4RdZuxXM6BYLC1AF7ygf8BtlHDTiARJl
         E37iGnYDou3QPzqPzkU6yg9C9GlA9uiDiQll7o5DHysjbRTjRPmXnNe0AWBSBi9yM0fV
         QairsBzYoz5N0nESP2fgu2jyj5kj9XV4k0y9L7WnnW19wcwJ4QpjlzzHHqIL7Ub9EJay
         kYyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=1OEEXNFhLWdVUoPK1KEMZ6ZVl5lL6eOjxFar5Jt1bvM=;
        b=hGxOX593CDYsxMb3P62CkC1Sy2WhDigiI/xaXpiLWQYWJKCJXw+pJb/FOud2ef6y6L
         R9HUMLkO3sGt30kLcUKxzIT4cbMJhhkd1kRY+XQyVJUihN6ZSKVRo5lZmoiu/dtxP1R9
         t4NiAF6E1PgG0SNcC6QopfUKRVNmA3jL+chhseM/M0tlIpw54EQtSZoqxJe+SSZN6EJw
         j6XJ0CaSOvJPzHCgLAfbYRqqN7DLgXNRGrvSVwaL+dnFyIpiaC1MLw6xHCpEKzGt9L5e
         t2LBZVDdevDlRl1LWKUpkTOin64DRCSkvUP59pqRdjyUycQ8TcQDUx6HERl4ENJuEP2O
         jn7A==
X-Gm-Message-State: APjAAAXdhVLpK/JCDfVbUzKLz0sbbMuiVaxNowLCWoE2Os+9QPblVt2h
        OJtiA7ub8nMqQFSTaZ4HHVw=
X-Google-Smtp-Source: APXvYqxne9nNaTaugB3bsF19cAWnJh4QOBcvduESt6WLVgbvELIvZK7LeAKawX27eorgfRbOvPZgIA==
X-Received: by 2002:a1c:9602:: with SMTP id y2mr27332549wmd.23.1575298020040;
        Mon, 02 Dec 2019 06:47:00 -0800 (PST)
Received: from localhost.localdomain.com ([188.204.2.113])
        by smtp.gmail.com with ESMTPSA id r5sm8115170wrt.43.2019.12.02.06.46.58
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 02 Dec 2019 06:46:59 -0800 (PST)
From:   Pascal van Leeuwen <pascalvanl@gmail.com>
X-Google-Original-From: Pascal van Leeuwen <pvanleeuwen@verimatrix.com>
To:     linux-firmware@kernel.org
Cc:     linux-crypto@vger.kernel.org,
        Pascal van Leeuwen <pvanleeuwen@verimatrix.com>
Subject: [PATCH] inside-secure: add new "mini" firmware for the EIP197 driver
Date:   Mon,  2 Dec 2019 15:43:42 +0100
Message-Id: <1575297822-30977-1-git-send-email-pvanleeuwen@verimatrix.com>
X-Mailer: git-send-email 1.8.3.1
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

This adds the "minifw" version of the EIP197 firmware, which the inside-
secure driver will use as a fallback if the original full-featured
firmware cannot be found. This allows for using the inside-secure driver
and hardware without access to "official" firmware only available under
NDA. Note that this "minifw" was written by me (Pascal) specifically for
this driver and I am allowed by my employer, Verimatrix, to release this
for distribution with the Linux kernel.

Signed-off-by: Pascal van Leeuwen <pvanleeuwen@verimatrix.com>
---
 WHENCE                               |  15 +++++++++++++++
 inside-secure/eip197_minifw/ifpp.bin | Bin 0 -> 100 bytes
 inside-secure/eip197_minifw/ipue.bin | Bin 0 -> 108 bytes
 3 files changed, 15 insertions(+)
 create mode 100644 inside-secure/eip197_minifw/ifpp.bin
 create mode 100644 inside-secure/eip197_minifw/ipue.bin

diff --git a/WHENCE b/WHENCE
index 1558e33..8907b82 100644
--- a/WHENCE
+++ b/WHENCE
@@ -4672,3 +4672,18 @@ File: intel/ice/ddp/ice-1.3.4.0.pkg
 Link: intel/ice/ddp/ice.pkg -> ice-1.3.4.0.pkg
 
 License: Redistributable. See LICENSE.ice for details
+
+--------------------------------------------------------------------------
+
+Driver: inside-secure -- Inside Secure EIP197 crypto driver
+
+File: inside-secure/eip197_minifw/ipue.bin
+File: inside-secure/eip197_minifw/ifpp.bin
+
+Licence: Redistributable.
+Copyright (c) 2019 Verimatrix, Inc.
+
+Derived from proprietary unpublished source code.
+Permission is hereby granted for the distribution of this firmware
+as part of Linux or other Open Source operating system kernel,
+provided this copyright notice is accompanying it.
diff --git a/inside-secure/eip197_minifw/ifpp.bin b/inside-secure/eip197_minifw/ifpp.bin
new file mode 100644
index 0000000000000000000000000000000000000000..b4a832203abf269d379f2477d4ba3fa0a9c8a886
GIT binary patch
literal 100
zcmY#nXkbudX#ev;=E;GCW(KxkJ_d#f4Gav*3=J$Q4GkQs4GlcJ1`G@eq2+%Jt|%}l
g+*<y}S)hQyNr{1l0UKarU{NqGU;&vS0F(z|0Pvj?YXATM

literal 0
HcmV?d00001

diff --git a/inside-secure/eip197_minifw/ipue.bin b/inside-secure/eip197_minifw/ipue.bin
new file mode 100644
index 0000000000000000000000000000000000000000..2f54999c8303d750186c7154b261e887271ad153
GIT binary patch
literal 108
zcmY#sXkyT1Xkt-oc*LRJ@Q6o=;ro9JlL7{1h7Sy)3S140nG={3m>UEwwiYljN`CNR
zlx+1-c;>*M@H~J)PJw~J;GqD6fYs#x3C#>5(cKIT2P`HqByclGfb=IcFbGa)U|<kn
GfM5Wqs~kiC

literal 0
HcmV?d00001

-- 
1.8.3.1

