Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 105FF17A2F0;
	Sat, 26 Apr 2025 06:11:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745647896; cv=none; b=tmvMkCdEw9BQDHmCjijY0ck10TvktOAbiQQp06Gqolf44JercL9IplKBzukyjzk50KiUQrCvPC3/y2a7kjtTTCiztzjLvIQcurHnwPeKGJkU1aBcsn1sc6eotMLumow4zUvSIwvpcpxRQ+G7Jd42qetxpyuOqasdn3vbEDB+g2o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745647896; c=relaxed/simple;
	bh=bB98xDqQD5ADQCaHwG2kKcl9a/X9KNfvJtbGOtE3yiA=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=il+AW6qdOWnTBiZocRxmMHQ0ggWNsYCeX1bwrXftd0+VB6jCo01RPaOPd6oJI6pGpb6e4YttvRiJBcqAjPpf2ipybcQJWLujmpfrL0WqkahBaWlpMSwn4d81UtqgPIUjxQn/5ukDs8cHeyt1EmgPihWvJSPaLon9gp9oJTcwTMY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=pH4bpXGK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="pH4bpXGK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 798BFC4CEE2;
	Sat, 26 Apr 2025 06:11:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1745647895;
	bh=bB98xDqQD5ADQCaHwG2kKcl9a/X9KNfvJtbGOtE3yiA=;
	h=From:To:Cc:Subject:Date:From;
	b=pH4bpXGKD1UKWQa0Z7XdUM6IuYWlTLzNcAGBGvmdm6xwdhGRBa5P9n518vnWsoiMa
	 ecgfkvrKkAfQCnXzB+Z0h/pTSFnhmXfgwnbfVav6x1aaEnxQBzFRmxv1Z76JSgh5ce
	 2/w3C2tJZntt4egnpsEcbNxNcvg3dVffDuNPXLwHLMMQyaGgvg+u/VwnZd/TUQvvjE
	 2wv31diLYT4V6sBgfnX5mTSjXqgIZjXk2pgKUuHbBykxkGjO1mjQt+fHkUUtHOOSal
	 Ucn+iuGVwpK+HpeZU84yN0lt1Y+CQ84h8KyPh9SEWman7wr1P8XxZ9Lgw62RHd1vzO
	 f47EHtwS6742w==
From: Kees Cook <kees@kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Kees Cook <kees@kernel.org>,
	Kristen Accardi <kristen.c.accardi@intel.com>,
	Vinicius Costa Gomes <vinicius.gomes@intel.com>,
	"David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-hardening@vger.kernel.org
Subject: [PATCH] crypto: iaa: Adjust workqueue allocation type
Date: Fri, 25 Apr 2025 23:11:31 -0700
Message-Id: <20250426061130.work.001-kees@kernel.org>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1507; i=kees@kernel.org; h=from:subject:message-id; bh=bB98xDqQD5ADQCaHwG2kKcl9a/X9KNfvJtbGOtE3yiA=; b=owGbwMvMwCVmps19z/KJym7G02pJDBk8lcJt25lOv2nTrNwaEXGnUNGrgnHd4tKXTC8zdyiua Gxpvb2no5SFQYyLQVZMkSXIzj3OxeNte7j7XEWYOaxMIEMYuDgFYCITLjP8z7n/5k2Q5v+dMe++ uUcXuz63dXXkuyN2YZpcpDRTQLnbO0aGY18P+Z7qjPOtzcsRU5iYK7rtzc2i5f8NRSb279OLd1v LCwA=
X-Developer-Key: i=kees@kernel.org; a=openpgp; fpr=A5C3F68F229DD60F723E6E138972F4DFDC6DC026
Content-Transfer-Encoding: 8bit

In preparation for making the kmalloc family of allocators type aware,
we need to make sure that the returned type from the allocation matches
the type of the variable being assigned. (Before, the allocator would
always return "void *", which can be implicitly cast to any pointer type.)

The assigned type is "struct idxd_wq **", but the returned type will be
"struct wq **". These are the same size allocation (pointer sized), but
the types don't match. Adjust the allocation type to match the assignment.

Signed-off-by: Kees Cook <kees@kernel.org>
---
Cc: Kristen Accardi <kristen.c.accardi@intel.com>
Cc: Vinicius Costa Gomes <vinicius.gomes@intel.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: <linux-crypto@vger.kernel.org>
---
 drivers/crypto/intel/iaa/iaa_crypto_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/intel/iaa/iaa_crypto_main.c b/drivers/crypto/intel/iaa/iaa_crypto_main.c
index 09d9589f2d68..4aa503d6b15c 100644
--- a/drivers/crypto/intel/iaa/iaa_crypto_main.c
+++ b/drivers/crypto/intel/iaa/iaa_crypto_main.c
@@ -725,7 +725,7 @@ static int alloc_wq_table(int max_wqs)
 
 	for (cpu = 0; cpu < nr_cpus; cpu++) {
 		entry = per_cpu_ptr(wq_table, cpu);
-		entry->wqs = kcalloc(max_wqs, sizeof(struct wq *), GFP_KERNEL);
+		entry->wqs = kcalloc(max_wqs, sizeof(*entry->wqs), GFP_KERNEL);
 		if (!entry->wqs) {
 			free_wq_table();
 			return -ENOMEM;
-- 
2.34.1

