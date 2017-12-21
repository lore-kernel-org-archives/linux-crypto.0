From: Cheah Kok Cheong <thrust73@gmail.com>
Subject: [PATCH] padata: add SPDX identifier
Date: Thu, 21 Dec 2017 19:35:30 +0800
Message-ID: <1513856130-7843-1-git-send-email-thrust73@gmail.com>
References: <20171221110557.GA7329@linux-Precision-WorkStation-T5500>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        thrust73@gmail.com, pombredanne@nexb.com
To: steffen.klassert@secunet.com
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-pf0-f193.google.com ([209.85.192.193]:41139 "EHLO
        mail-pf0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751762AbdLULgn (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 21 Dec 2017 06:36:43 -0500
In-Reply-To: <20171221110557.GA7329@linux-Precision-WorkStation-T5500>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Add SPDX license identifier according to the type of license text found
in the file.

Cc: Philippe Ombredanne <pombredanne@nexb.com>
Signed-off-by: Cheah Kok Cheong <thrust73@gmail.com>
---
 kernel/padata.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/kernel/padata.c b/kernel/padata.c
index e265953..eb9a9d9 100644
--- a/kernel/padata.c
+++ b/kernel/padata.c
@@ -1,3 +1,4 @@
+// SPDX-License-Identifier: GPL-2.0
 /*
  * padata.c - generic interface to process data streams in parallel
  *
-- 
2.7.4
