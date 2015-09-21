From: Tadeusz Struk <tadeusz.struk@intel.com>
Subject: [PATCH  v2 1/2] lib/scatterlist: Add sg_len helper
Date: Mon, 21 Sep 2015 16:44:14 -0700
Message-ID: <20150921234414.23782.63763.stgit@tstruk-mobl1>
References: <20150921234408.23782.52608.stgit@tstruk-mobl1>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: linux-crypto@vger.kernel.org, qat-linux@intel.com,
	tadeusz.struk@intel.com
To: herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga03.intel.com ([134.134.136.65]:2832 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756198AbbIUXqM (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Mon, 21 Sep 2015 19:46:12 -0400
In-Reply-To: <20150921234408.23782.52608.stgit@tstruk-mobl1>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Add sg_len function which returns the total number of bytes in sg.

Signed-off-by: Tadeusz Struk <tadeusz.struk@intel.com>
---
 include/linux/scatterlist.h |    1 +
 lib/scatterlist.c           |   18 ++++++++++++++++++
 2 files changed, 19 insertions(+)

diff --git a/include/linux/scatterlist.h b/include/linux/scatterlist.h
index 556ec1e..1ca63bd 100644
--- a/include/linux/scatterlist.h
+++ b/include/linux/scatterlist.h
@@ -242,6 +242,7 @@ static inline void *sg_virt(struct scatterlist *sg)
 }
 
 int sg_nents(struct scatterlist *sg);
+int sg_len(struct scatterlist *sg);
 int sg_nents_for_len(struct scatterlist *sg, u64 len);
 struct scatterlist *sg_next(struct scatterlist *);
 struct scatterlist *sg_last(struct scatterlist *s, unsigned int);
diff --git a/lib/scatterlist.c b/lib/scatterlist.c
index bafa993..dc71f27 100644
--- a/lib/scatterlist.c
+++ b/lib/scatterlist.c
@@ -57,6 +57,24 @@ int sg_nents(struct scatterlist *sg)
 EXPORT_SYMBOL(sg_nents);
 
 /**
+  * sg_len - return total size of bytes in the scatterlist
+  * @sg:         The scatterlist
+  *
+  * Description:
+  * Allows to know how the total size of bytes in sg, taking into acount
+  * chaining as well
+  **/
+int sg_len(struct scatterlist *sg)
+{
+	int len;
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
