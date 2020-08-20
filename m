Return-Path: <SRS0=QJ87=B6=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A9BE8C433E1
	for <linux-crypto@archiver.kernel.org>; Thu, 20 Aug 2020 18:21:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 71E46207DE
	for <linux-crypto@archiver.kernel.org>; Thu, 20 Aug 2020 18:21:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1597947684;
	bh=FehLwW5sI54Lc7Xmb4zRBemrPAV6i19xSX0gM5Td5Hg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=m8782ZJbY+HNzEDemexnr1zTFDDBIkEs/VCa1CUrTxe869UL3bIidm39aULApoUOW
	 ZvFkZwiKjQ0PsBZdKvfh6W/SiCYVnsOziOGhuekIPMHyQicT4UoB/pFoXzamX+2bY/
	 y09GZMKdbxKXhFViNLF0qCQpdM9n+OVt0+NgaJhs=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726896AbgHTSVX (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 20 Aug 2020 14:21:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:54312 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727064AbgHTSVT (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 20 Aug 2020 14:21:19 -0400
Received: from sol.hsd1.ca.comcast.net (c-107-3-166-239.hsd1.ca.comcast.net [107.3.166.239])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id ECDD9208B3;
        Thu, 20 Aug 2020 18:21:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597947678;
        bh=FehLwW5sI54Lc7Xmb4zRBemrPAV6i19xSX0gM5Td5Hg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KcyK7O86zC0+FofuAU7uT6N7cI/auU2W47KNPjVscQnD84mzyNpEgwdh5UOqEAtHj
         MpSGKSh9uOUpznMF8MlFK5MOCkCPqSNm1DvJH8FOE4R/oYbbo5NlmTPh9gEblFTEFh
         3hqaGyQ37tWPpeGtAnSFBrA9jaaazo0l7iHIyxms=
From:   Eric Biggers <ebiggers@kernel.org>
To:     ltp@lists.linux.it
Cc:     linux-crypto@vger.kernel.org,
        Naresh Kamboju <naresh.kamboju@linaro.org>
Subject: [LTP PATCH 1/2] lib/tst_af_alg: add tst_alg_sendmsg()
Date:   Thu, 20 Aug 2020 11:19:17 -0700
Message-Id: <20200820181918.404758-2-ebiggers@kernel.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200820181918.404758-1-ebiggers@kernel.org>
References: <20200820181918.404758-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

Add a helper function which sends data to an AF_ALG request socket,
including control data.  This is needed by af_alg02, but it may also be
useful for other AF_ALG tests in the future.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 include/tst_af_alg.h | 32 ++++++++++++++++++++++
 lib/tst_af_alg.c     | 64 ++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 96 insertions(+)

diff --git a/include/tst_af_alg.h b/include/tst_af_alg.h
index fc4b1989a..fd2ff0647 100644
--- a/include/tst_af_alg.h
+++ b/include/tst_af_alg.h
@@ -133,4 +133,36 @@ int tst_alg_setup(const char *algtype, const char *algname,
 int tst_alg_setup_reqfd(const char *algtype, const char *algname,
 			const uint8_t *key, unsigned int keylen);
 
+/** Specification of control data to send to an AF_ALG request socket */
+struct tst_alg_sendmsg_params {
+
+	/** If true, send ALG_SET_OP with ALG_OP_ENCRYPT */
+	bool encrypt;
+
+	/** If true, send ALG_SET_OP with ALG_OP_DECRYPT */
+	bool decrypt;
+
+	/** If ivlen != 0, send ALG_SET_IV */
+	const uint8_t *iv;
+	unsigned int ivlen;
+
+	/** If assoclen != 0, send ALG_SET_AEAD_ASSOCLEN */
+	unsigned int assoclen;
+
+	/* Value to use as msghdr::msg_flags */
+	uint32_t msg_flags;
+};
+
+/**
+ * Send some data to an AF_ALG request socket, including control data.
+ * @param reqfd An AF_ALG request socket
+ * @param data The data to send
+ * @param datalen The length of data in bytes
+ * @param params Specification of the control data to send
+ *
+ * On failure, tst_brk() is called with TBROK.
+ */
+void tst_alg_sendmsg(int reqfd, const void *data, size_t datalen,
+		     const struct tst_alg_sendmsg_params *params);
+
 #endif /* TST_AF_ALG_H */
diff --git a/lib/tst_af_alg.c b/lib/tst_af_alg.c
index 97be548b4..d3895a83d 100644
--- a/lib/tst_af_alg.c
+++ b/lib/tst_af_alg.c
@@ -146,3 +146,67 @@ int tst_alg_setup_reqfd(const char *algtype, const char *algname,
 	close(algfd);
 	return reqfd;
 }
+
+void tst_alg_sendmsg(int reqfd, const void *data, size_t datalen,
+		     const struct tst_alg_sendmsg_params *params)
+{
+	struct iovec iov = {
+		.iov_base = (void *)data,
+		.iov_len = datalen,
+	};
+	struct msghdr msg = {
+		.msg_iov = &iov,
+		.msg_iovlen = 1,
+		.msg_flags = params->msg_flags,
+	};
+	size_t controllen;
+	uint8_t *control;
+	struct cmsghdr *cmsg;
+	struct af_alg_iv *alg_iv;
+
+	if (params->encrypt && params->decrypt)
+		tst_brk(TBROK, "Both encrypt and decrypt are specified");
+
+	controllen = 0;
+	if (params->encrypt || params->decrypt)
+		controllen += CMSG_SPACE(sizeof(uint32_t));
+	if (params->ivlen)
+		controllen += CMSG_SPACE(sizeof(struct af_alg_iv) +
+					 params->ivlen);
+	if (params->assoclen)
+		controllen += CMSG_SPACE(sizeof(uint32_t));
+
+	control = SAFE_MALLOC(controllen);
+	memset(control, 0, controllen);
+	msg.msg_control = control;
+	msg.msg_controllen = controllen;
+	cmsg = CMSG_FIRSTHDR(&msg);
+
+	if (params->encrypt || params->decrypt) {
+		cmsg->cmsg_level = SOL_ALG;
+		cmsg->cmsg_type = ALG_SET_OP;
+		cmsg->cmsg_len = CMSG_LEN(sizeof(uint32_t));
+		*(uint32_t *)CMSG_DATA(cmsg) =
+			params->encrypt ? ALG_OP_ENCRYPT : ALG_OP_DECRYPT;
+		cmsg = CMSG_NXTHDR(&msg, cmsg);
+	}
+	if (params->ivlen) {
+		cmsg->cmsg_level = SOL_ALG;
+		cmsg->cmsg_type = ALG_SET_IV;
+		cmsg->cmsg_len = CMSG_LEN(sizeof(struct af_alg_iv) +
+					  params->ivlen);
+		alg_iv = (struct af_alg_iv *)CMSG_DATA(cmsg);
+		alg_iv->ivlen = params->ivlen;
+		memcpy(alg_iv->iv, params->iv, params->ivlen);
+		cmsg = CMSG_NXTHDR(&msg, cmsg);
+	}
+	if (params->assoclen) {
+		cmsg->cmsg_level = SOL_ALG;
+		cmsg->cmsg_type = ALG_SET_AEAD_ASSOCLEN;
+		cmsg->cmsg_len = CMSG_LEN(sizeof(uint32_t));
+		*(uint32_t *)CMSG_DATA(cmsg) = params->assoclen;
+		cmsg = CMSG_NXTHDR(&msg, cmsg);
+	}
+
+	SAFE_SENDMSG(datalen, reqfd, &msg, 0);
+}
-- 
2.28.0

