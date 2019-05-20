Return-Path: <SRS0=w/0I=TU=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A260FC04AAC
	for <linux-crypto@archiver.kernel.org>; Mon, 20 May 2019 16:43:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 65A1E216B7
	for <linux-crypto@archiver.kernel.org>; Mon, 20 May 2019 16:43:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1558370621;
	bh=fCdxG8+b8/D7X3ES8TZmI5BNMHlaHykxE72SAhLWVCU=;
	h=From:To:Cc:Subject:Date:List-ID:From;
	b=V5+DuwyozIDDQ32GdWgweVGembJiT8aAWony5aw/8gu/B50jIb/H+FOiKE89WMwp8
	 uoT09D2Mel0cUjyQL0anzdNp2A/DV8XjXLTxSNfwp0/hQPEjNfw+91z4KJf5ncFhUx
	 mPpYiBiDuYW+4YXx2GePar5EqmbdZxFgDXtvzyTI=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389194AbfETQnk (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 20 May 2019 12:43:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:49746 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388804AbfETQnk (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 20 May 2019 12:43:40 -0400
Received: from ebiggers-linuxstation.mtv.corp.google.com (unknown [104.132.1.77])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D6BD4214DA;
        Mon, 20 May 2019 16:43:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558370619;
        bh=fCdxG8+b8/D7X3ES8TZmI5BNMHlaHykxE72SAhLWVCU=;
        h=From:To:Cc:Subject:Date:From;
        b=1Ru1Xb6TwVr2t+PtdQgR6S6T8ZDC4i0pwcoW0DLuynYGE4sRNzWP0Xpn0DIwAKCtP
         oZH05UGZK2P2fZhzHYeU4GpSP2M4HhO2Si/22MM/Rrq2ADK7r1bzL/gxeeNOcfhj+g
         /uuaYCzzeX1PC63bwweK17ZyHgrVwVNL+U7kJZJE=
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>
Cc:     linuxppc-dev@lists.ozlabs.org, Daniel Axtens <dja@axtens.net>,
        =?UTF-8?q?Breno=20Leit=C3=A3o?= <leitao@debian.org>,
        Nayna Jain <nayna@linux.ibm.com>,
        Paulo Flabiano Smorigo <pfsmorigo@gmail.com>
Subject: [PATCH] crypto: vmx - convert to SPDX license identifiers
Date:   Mon, 20 May 2019 09:42:32 -0700
Message-Id: <20190520164232.159053-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.21.0.1020.gf2820cf01a-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

Remove the boilerplate license text and replace it with the equivalent
SPDX license identifier.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 drivers/crypto/vmx/aes.c     | 14 +-------------
 drivers/crypto/vmx/aes_cbc.c | 14 +-------------
 drivers/crypto/vmx/aes_ctr.c | 14 +-------------
 drivers/crypto/vmx/aes_xts.c | 14 +-------------
 drivers/crypto/vmx/vmx.c     | 14 +-------------
 5 files changed, 5 insertions(+), 65 deletions(-)

diff --git a/drivers/crypto/vmx/aes.c b/drivers/crypto/vmx/aes.c
index 603a620819941..2e9476158df49 100644
--- a/drivers/crypto/vmx/aes.c
+++ b/drivers/crypto/vmx/aes.c
@@ -1,21 +1,9 @@
+// SPDX-License-Identifier: GPL-2.0
 /**
  * AES routines supporting VMX instructions on the Power 8
  *
  * Copyright (C) 2015 International Business Machines Inc.
  *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation; version 2 only.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
- *
  * Author: Marcelo Henrique Cerri <mhcerri@br.ibm.com>
  */
 
diff --git a/drivers/crypto/vmx/aes_cbc.c b/drivers/crypto/vmx/aes_cbc.c
index a1a9a6f0d42cf..dae8af3c46dce 100644
--- a/drivers/crypto/vmx/aes_cbc.c
+++ b/drivers/crypto/vmx/aes_cbc.c
@@ -1,21 +1,9 @@
+// SPDX-License-Identifier: GPL-2.0
 /**
  * AES CBC routines supporting VMX instructions on the Power 8
  *
  * Copyright (C) 2015 International Business Machines Inc.
  *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation; version 2 only.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
- *
  * Author: Marcelo Henrique Cerri <mhcerri@br.ibm.com>
  */
 
diff --git a/drivers/crypto/vmx/aes_ctr.c b/drivers/crypto/vmx/aes_ctr.c
index 192a53512f5e8..dc31101178446 100644
--- a/drivers/crypto/vmx/aes_ctr.c
+++ b/drivers/crypto/vmx/aes_ctr.c
@@ -1,21 +1,9 @@
+// SPDX-License-Identifier: GPL-2.0
 /**
  * AES CTR routines supporting VMX instructions on the Power 8
  *
  * Copyright (C) 2015 International Business Machines Inc.
  *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation; version 2 only.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
- *
  * Author: Marcelo Henrique Cerri <mhcerri@br.ibm.com>
  */
 
diff --git a/drivers/crypto/vmx/aes_xts.c b/drivers/crypto/vmx/aes_xts.c
index 00d412d811ae6..aee1339f134ec 100644
--- a/drivers/crypto/vmx/aes_xts.c
+++ b/drivers/crypto/vmx/aes_xts.c
@@ -1,21 +1,9 @@
+// SPDX-License-Identifier: GPL-2.0
 /**
  * AES XTS routines supporting VMX In-core instructions on Power 8
  *
  * Copyright (C) 2015 International Business Machines Inc.
  *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundations; version 2 only.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY of FITNESS FOR A PARTICUPAR PURPOSE. See the
- * GNU General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
- *
  * Author: Leonidas S. Barbosa <leosilva@linux.vnet.ibm.com>
  */
 
diff --git a/drivers/crypto/vmx/vmx.c b/drivers/crypto/vmx/vmx.c
index a9f5198306155..abd89c2bcec4d 100644
--- a/drivers/crypto/vmx/vmx.c
+++ b/drivers/crypto/vmx/vmx.c
@@ -1,21 +1,9 @@
+// SPDX-License-Identifier: GPL-2.0
 /**
  * Routines supporting VMX instructions on the Power 8
  *
  * Copyright (C) 2015 International Business Machines Inc.
  *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation; version 2 only.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
- *
  * Author: Marcelo Henrique Cerri <mhcerri@br.ibm.com>
  */
 
-- 
2.21.0.1020.gf2820cf01a-goog

