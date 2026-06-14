Received: from mail-qv1-f50.google.com (mail-qv1-f50.google.com [209.85.219.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C71FE3A3E95
	for <linux-crypto@vger.kernel.org>; Sun, 14 Jun 2026 13:06:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781442393; cv=none; b=Li8KxPx7eNruTX2VlMGw4jxzzLWUY/uZDmoTg5ANHA3bzz/FMH88cRHQ1mKlZd1BsknP0qcCzgmLPeifgwPdu2k4I3h3/1CUS2uoiBEp+L7dC1kMIiHf3tQNJ3AhAMH8TRWlqn4DmrHVsk6ImIqpANCVxYN1Bs6pPuGsFi8o2Jg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781442393; c=relaxed/simple;
	bh=rF6sCoztLXjlxMtB6xkicao0AozijnSumVrTNBVRDvY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=owGLv9yH+zJ6VfziZCbjhQB0kV00glkSkrrSt8u/vZE9wGxQaWPIDX28x1tdzVlOmmkXVXGlUGbqtytxcczROv+cTRvL7NUgZb6RRDDL/UTIP44vQkQCRUh/GUMBO0F1nPWadIHlz5S413hLHaUnn3cfwBnyGaOuJDTvEQBZfF4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=PQvKMcep; arc=none smtp.client-ip=209.85.219.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="PQvKMcep"
Received: by mail-qv1-f50.google.com with SMTP id 6a1803df08f44-8ce9df31840so20309036d6.1
        for <linux-crypto@vger.kernel.org>; Sun, 14 Jun 2026 06:06:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1781442391; x=1782047191; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vYsRIUHn/T50/e6tT+zlseboGzQDeAAfLQ53dkRo3sM=;
        b=PQvKMcepXoMN9J+Q60QViowMWmusZjxl3Qk/cbXN9dFeS5i2XEpZSndRv4E5lOv2xU
         I584gYZJLX7jaujk21VxQsM72Z/P8WaHHMPSY/JZKBM4g3UjMxNuq1mIwYeQxGDW88lM
         mUju6NGHT3hg9UFLRg4nmC3y9qUTvi0wJBSvfduUSUhDI40gxYF2/GbeZXRSeRbWB0vO
         5NqZkGMXZI1bOVJz1r9lpJRo2zucPcxYbNCdXYBHEL7yw3sXnrOxzWJC/noqcvKVgXBR
         PiL5Ok6RsNo1zZ6Q1IM9nOrNrLrETtLK26DwfLuMixTU5XdH6o7Chszz5cbSVRilI86d
         kILg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781442391; x=1782047191;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=vYsRIUHn/T50/e6tT+zlseboGzQDeAAfLQ53dkRo3sM=;
        b=GmNiAVD4sCIarkDQ6NPQyBZXe0qlfwgEHlwfzzBqREj8HiAK6KLeB9xU7Pl403kz7M
         /RoGRYtq2zESyA6dfezzgwwJbMpJec5uIYBrPUVYCqyRWcLy6rNWcHyJ2mmBjjpvRg89
         Pk+mh4QMm6i57AHgEyh4jtCrScpkJZRNA2z35TCo3E81eXZ/jlyVTDDH5s6wH6fIEKrh
         +HxQymfvwX6BYstngNaTBT2R42PAdOmIDTi3W62Z+bQlPS5vvYERabDRomwopdM2VaKR
         aXtPl7lqUXol0bwXu4eshOn4I5Ojjl9xX8eFyNY7CSc8P2SgJ81k/35pX/xlSpLgutr+
         zlxw==
X-Forwarded-Encrypted: i=1; AFNElJ/irbLhN0tUOVn8/xqiR44NTLbMcnIuBc23cEyhBYih/lCDYGJN0Q7si9krc3NsUxfa9FFSdj7HHw6oTug=@vger.kernel.org
X-Gm-Message-State: AOJu0YykQVDBO4BPPEfyNUaE7kMkNlI+J7MeNAYsYpzcd9a7cpf3jBvf
	aipzoTnLPU9kTX/WkMUiF+ePDkBFwkGF8VWhx3a2xSTdJ6W758ePzGC82bfALLPR
X-Gm-Gg: Acq92OETegtyIPkCj2YP3kC+w8+4bK99fpWwCO7wkDtZy8Lb9KN4qCIMA3NO2Ofx1dL
	/bLr+YlkF12xx40OCP8hhTWwo3dSvYaIbhJBMv19SQdnO58TNo1g/noMZZLiOkfL4fDbKcAk0wR
	HZ4mmaVe1asThXzxtFrkg4EAQq9NUVYXztexgeZOsR96soRGQMNQFwHdZijHRQWS/4hgFFShcA2
	Y7I6bEMP6qeXzX3mPpLEfeNTCtBLBWUqKsFTrOcFXu7hUNyvZ9hzzRtmFCP9lN3pzjGrPGDTHc+
	jRM4CuB2t8EMIbXRzgNZ+MdvE/3GiWn4LG6MqxupEpE0t81/OjCFX9K1+xEkCIoQoNvjJ4bqoSH
	AmeR5iP+kO1J36f8nPWiJ16eCzyE7kLeM2TRlFjD+Vuyz91H9gmglMLe1v6eplXdhCBO4t+8hDX
	uvkAOvH9CycnL4C2imvkKCtCMy8gGQ1+XeqAI0MbrAGcBpRkJt4YPJtxrEZDLiGOGV76SVLmo4z
	YCIeQ5NEfRW4OcUBD/cyQb2OsCx5FthVvH46JhHdaqMQjDbVUEsQg==
X-Received: by 2002:a05:6214:d86:b0:8cd:b80e:6157 with SMTP id 6a1803df08f44-8d32c012ac2mr183913286d6.14.1781442390652;
        Sun, 14 Jun 2026 06:06:30 -0700 (PDT)
Received: from server0.tail6e7dd.ts.net (c-68-48-65-54.hsd1.mi.comcast.net. [68.48.65.54])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-8d301a32d5csm77937106d6.12.2026.06.14.06.06.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 14 Jun 2026 06:06:30 -0700 (PDT)
From: Michael Bommarito <michael.bommarito@gmail.com>
To: Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
	Herbert Xu <herbert@gondor.apana.org.au>
Cc: "David S . Miller" <davem@davemloft.net>,
	Kees Cook <kees@kernel.org>,
	qat-linux@intel.com,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] crypto: qat - add KUnit coverage for the migration import parser
Date: Sun, 14 Jun 2026 09:06:19 -0400
Message-ID: <20260614130619.2519534-3-michael.bommarito@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260614130619.2519534-1-michael.bommarito@gmail.com>
References: <20260614130619.2519534-1-michael.bommarito@gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

Add KUnit coverage for the remote (migration import) path of the QAT
live migration state manager. The cases drive the real
adf_mstate_mgr_init_from_remote() -> adf_mstate_sect_validate() parser
on a buffer sized as the GEN4 VFIO migration backend allocates it, and
include the preh_len == buffer-size boundary case that is the
regression oracle for the preceding fix. The test file is included from
adf_mstate_mgr.c so it can reach the file-local preamble and section
types, gated by CONFIG_CRYPTO_DEV_QAT_KUNIT_TEST. It is offered as a
separate patch so it can be taken or dropped independently of the fix.

Reproduced under KASAN on QEMU; the boundary case reports the
slab-out-of-bounds read on an unfixed tree and passes once the fix is
in place.

Assisted-by: Claude:claude-opus-4-8
Signed-off-by: Michael Bommarito <michael.bommarito@gmail.com>
---
Three cases under KASAN on QEMU x86_64: a valid empty preamble, a valid
in-bounds section header, and the preh_len == buffer-size (4096) boundary
case. The boundary case is the regression oracle for patch 1: it reports
the slab-out-of-bounds read on an unfixed tree and returns -EINVAL with
the fix in place. The two valid cases drive the same parser path with no
out-of-bounds access and pass on both trees.

 drivers/crypto/intel/qat/Kconfig              | 16 ++++
 .../intel/qat/qat_common/adf_mstate_mgr.c     |  4 +
 .../qat/qat_common/adf_mstate_mgr_test.c      | 81 +++++++++++++++++++
 3 files changed, 101 insertions(+)
 create mode 100644 drivers/crypto/intel/qat/qat_common/adf_mstate_mgr_test.c

diff --git a/drivers/crypto/intel/qat/Kconfig b/drivers/crypto/intel/qat/Kconfig
index 9d6e6f52d2dcb..116f7f94c9a64 100644
--- a/drivers/crypto/intel/qat/Kconfig
+++ b/drivers/crypto/intel/qat/Kconfig
@@ -133,3 +133,19 @@ config CRYPTO_DEV_QAT_ERROR_INJECTION
 
 	  This functionality is available via debugfs entry of the Intel(R)
 	  QuickAssist device
+
+config CRYPTO_DEV_QAT_KUNIT_TEST
+	bool "KUnit tests for Intel(R) QAT live migration state manager" if !KUNIT_ALL_TESTS
+	depends on CRYPTO_DEV_QAT && KUNIT=y
+	default KUNIT_ALL_TESTS
+	help
+	  Build KUnit tests for the Intel(R) QAT live migration state
+	  manager remote-import parser (adf_mstate_mgr.c). The tests drive
+	  the migration setup parser on a buffer sized as the QAT GEN4
+	  VFIO migration backend allocates it and check that a malformed
+	  remote preamble is rejected before any out-of-bounds access.
+
+	  For more information on KUnit and unit tests in general, please
+	  refer to the KUnit documentation in Documentation/dev-tools/kunit/.
+
+	  If unsure, say N.
diff --git a/drivers/crypto/intel/qat/qat_common/adf_mstate_mgr.c b/drivers/crypto/intel/qat/qat_common/adf_mstate_mgr.c
index 7370b87f72a2f..701279409c32c 100644
--- a/drivers/crypto/intel/qat/qat_common/adf_mstate_mgr.c
+++ b/drivers/crypto/intel/qat/qat_common/adf_mstate_mgr.c
@@ -326,3 +326,7 @@ found:
 
 	return sect;
 }
+
+#if IS_ENABLED(CONFIG_CRYPTO_DEV_QAT_KUNIT_TEST)
+#include "adf_mstate_mgr_test.c"
+#endif
diff --git a/drivers/crypto/intel/qat/qat_common/adf_mstate_mgr_test.c b/drivers/crypto/intel/qat/qat_common/adf_mstate_mgr_test.c
new file mode 100644
index 0000000000000..e067c13f4a9dd
--- /dev/null
+++ b/drivers/crypto/intel/qat/qat_common/adf_mstate_mgr_test.c
@@ -0,0 +1,81 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/* Copyright(c) 2026 Intel Corporation */
+
+/*
+ * KUnit coverage for the QAT live migration remote-import parser. The cases
+ * drive the real adf_mstate_mgr_init_from_remote() on a buffer sized as the
+ * GEN4 VFIO migration backend allocates it (4096 bytes), including the
+ * preh_len == buffer-size boundary case. Included from adf_mstate_mgr.c to
+ * reach the file-local preamble and section types.
+ */
+
+#include <kunit/test.h>
+
+#define ADF_MSTATE_TEST_BUF_SIZE 4096
+
+static void qat_mstate_remote_run(struct kunit *test, u16 preh_len,
+				  u16 n_sects, u32 sect0_size, int expect)
+{
+	struct adf_mstate_mgr mgr;
+	struct adf_mstate_preh *pre;
+	u8 *buf;
+	int ret;
+
+	buf = kzalloc(ADF_MSTATE_TEST_BUF_SIZE, GFP_KERNEL);
+	KUNIT_ASSERT_NOT_NULL(test, buf);
+
+	pre = (struct adf_mstate_preh *)buf;
+	pre->magic = ADF_MSTATE_MAGIC;
+	pre->version = ADF_MSTATE_VERSION;
+	pre->preh_len = preh_len;
+	pre->n_sects = n_sects;
+	pre->size = 0;
+
+	/* Place an in-bounds section header when there is room for one. */
+	if (n_sects &&
+	    (u32)preh_len + sizeof(struct adf_mstate_sect_h) <= ADF_MSTATE_TEST_BUF_SIZE) {
+		struct adf_mstate_sect_h *s =
+			(struct adf_mstate_sect_h *)(buf + preh_len);
+
+		s->size = sect0_size;
+		s->sub_sects = 0;
+	}
+
+	ret = adf_mstate_mgr_init_from_remote(&mgr, buf, ADF_MSTATE_TEST_BUF_SIZE,
+					      NULL, NULL);
+	KUNIT_EXPECT_EQ(test, ret, expect);
+
+	kfree(buf);
+}
+
+/* Valid empty preamble: the validation loop never runs. */
+static void qat_mstate_remote_empty(struct kunit *test)
+{
+	qat_mstate_remote_run(test, sizeof(struct adf_mstate_preh), 0, 0, 0);
+}
+
+/* Valid in-bounds section header: same parser path, no out-of-bounds read. */
+static void qat_mstate_remote_inbounds_sect(struct kunit *test)
+{
+	qat_mstate_remote_run(test, sizeof(struct adf_mstate_preh), 1, 0, 0);
+}
+
+/* preh_len == buffer size puts the cursor past the allocation; expect -EINVAL. */
+static void qat_mstate_remote_oob_header(struct kunit *test)
+{
+	qat_mstate_remote_run(test, ADF_MSTATE_TEST_BUF_SIZE, 1, 0, -EINVAL);
+}
+
+static struct kunit_case qat_mstate_remote_cases[] = {
+	KUNIT_CASE(qat_mstate_remote_empty),
+	KUNIT_CASE(qat_mstate_remote_inbounds_sect),
+	KUNIT_CASE(qat_mstate_remote_oob_header),
+	{}
+};
+
+static struct kunit_suite qat_mstate_remote_suite = {
+	.name = "qat_mstate_remote",
+	.test_cases = qat_mstate_remote_cases,
+};
+
+kunit_test_suite(qat_mstate_remote_suite);
-- 
2.53.0

