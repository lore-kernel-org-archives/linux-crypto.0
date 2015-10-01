From: Tadeusz Struk <tadeusz.struk@intel.com>
Subject: [PATCH  v4 1/3] lib/scatterlist: Add sg_len helper
Date: Thu, 01 Oct 2015 13:28:51 -0700
Message-ID: <20151001202850.7193.77248.stgit@tstruk-mobl1>
References: <20151001202845.7193.51602.stgit@tstruk-mobl1>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: linux-crypto@vger.kernel.org, qat-linux@intel.com,
	tadeusz.struk@intel.com
To: herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:22161 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753419AbbJAUa4 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Thu, 1 Oct 2015 16:30:56 -0400
In-Reply-To: <20151001202845.7193.51602.stgit@tstruk-mobl1>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Add sg_len function which returns the total number of bytes in sg.

Signed-off-by: Tadeusz Struk <tadeusz.struk@intel.com>
---
 include/linux/scatterlist.h |    1 +
 lib/scatterlist.c           |   20 ++++++++++++++++++++
 2 files changed, 21 insertions(+)

diff --git a/include/linux/scatterlist.h b/include/linux/scatterlist.h
index 556ec1e..dba8f78 100644
--- a/include/linux/scatterlist.h
+++ b/include/linux/scatterlist.h
@@ -242,6 +242,7 @@ static inline void *sg_virt(struct scatterlist *sg)
 }
 
 int sg_nents(struct scatterlist *sg);
+unsigned int sg_len(struct scatterlist *sg);
 int sg_nents_for_len(struct scatterlist *sg, u64 len);
 struct scatterlist *sg_next(struct scatterlist *);
 struct scatterlist *sg_last(struct scatterlist *s, unsigned int);
diff --git a/lib/scatterlist.c b/lib/scatterlist.c
index bafa993..2ae4c53 100644
--- a/lib/scatterlist.c
+++ b/lib/scatterlist.c
@@ -57,6 +57,26 @@ int sg_nents(struct scatterlist *sg)
 EXPORT_SYMBOL(sg_nents);
 
 /**
+  * sg_len - return total size of bytes in the scatterlist
+  * @sg:         The scatterlist
+  *
+  * Description:
+  * Allows to know the total size of bytes in an sg, taking into account
+  * chaining as well.
+  *
+  * Returns: total size of bytes in the scatterlist
+  **/
+unsigned int sg_len(struct scatterlist *sg)
+{
+	unsigned int len;
+
+	for (len = 0; sg; sg = sg_next(sg))
+		len += sg->length;
+	return len;
+}
+EXPORT_SYMBOL(sg_len);
+
+/**
  * sg_nents_for_len - return total count of entries in scatterlist
  *                    needed to satisfy the supplied length
  * @sg:		The scatterlist
