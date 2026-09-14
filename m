Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5052A3EFFBA;
	Mon, 14 Sep 2026 08:15:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789373709; cv=none; b=eqWX+7xVZm0q+DWZUbW736/dqSnSte8Syd2GthLo2F9VKFsonx+dLF6S+KAOLuOr+bzUQXapnwpaYUXkHSimN9d9FTIMKu9RMH2cZblINtnozJ6qjtwuPAFUDloTreIIqY3sQQYZx3xcT8UneCLn2kIoPX/NMvFQ5D+V6GKcLxE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789373709; c=relaxed/simple;
	bh=q/3kCHUCRPlYa+KGkiI9OcT5TV4ELNVW3HhU2DS+tYg=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=W3otRg380/u3VWFofWRs+vy2/HVC1tlkWQ6+8W0GpiAl8kw61/3A16Ea0JWSh8Kzr6BJA1OMASgp+QgcqyP/4hSvylaQTH3KG+htD/+w97+i0mymXpZQ8/3E4RnPRMnzkpwv6sks8oMF5MDJLvX8w9UrllQvZALtQ1c/PB0QIMM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XziPNHhQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XziPNHhQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68FAD1F000FF;
	Mon, 14 Sep 2026 08:15:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789373707;
	bh=hhy3y+RdyOlzV0mNEG3QJcfAPDjRe336pjQbMT65wf0=;
	h=From:To:Cc:Subject:Date;
	b=XziPNHhQKEQxv51Elz22SfWhe9WD4fWAT223dHBDdHZ30Lfc+0j753gFCA6dAtMs6
	 Ujuqcju29M+JIIQiMo8rY1UP883hT7Ngf4FlzxWu5pBAjSArydGIvJgDAUJpjl7BZf
	 8p43+jf50J1H5o1xOa2NMen0p8XH8j3jbVt2vRM3kYNtjjM32f58MN3ORTugLIX+5X
	 /1X7u/tk/9TG7v1b1g2XWAfaOZ6WihE6apRdmvHRqTPuulZ1kb9+xjtNQ+j341lhR6
	 Iy/FTWJ84WRxgDCy0zG4KfrYDL7ThNfnAVyhOeTn0lyZYx4tHf71xvVLHlrD8uNR6c
	 fQ0j0DnsSQ4Qw==
From: Thorsten Blum <blum@kernel.org>
To: =?UTF-8?q?Breno=20Leit=C3=A3o?= <leitao@debian.org>,
	Nayna Jain <nayna@linux.ibm.com>,
	Paulo Flabiano Smorigo <pfsmorigo@gmail.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Nicholas Piggin <npiggin@gmail.com>,
	"Christophe Leroy (CS GROUP)" <chleroy@kernel.org>,
	"Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
	Shrikanth Hegde <sshegde@linux.ibm.com>
Cc: Thorsten Blum <blum@kernel.org>,
	linux-crypto@vger.kernel.org,
	linuxppc-dev@lists.ozlabs.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] crypto: powerpc/vmx - clean up includes, metadata, and p8_init()
Date: Mon, 14 Sep 2026 10:15:01 +0200
Message-ID: <20260914081500.65737-2-blum@kernel.org>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1872; i=blum@kernel.org; h=from:subject; bh=q/3kCHUCRPlYa+KGkiI9OcT5TV4ELNVW3HhU2DS+tYg=; b=owGbwMvMwCUWt7pQ4caZUj3G02pJDFnL17J8mXfzzAO+uCyZXW90+li2FW7ad5xzae5dtR0hb ptOOIkt6yhlYRDjYpAVU2R5MOvHDN/SmspNJhE7YeawMoEMYeDiFICJnL7J8D+4iP+G9wXmtJUd X6ZLztN1fTDtYYfPMb20YzLX5oX5aDkw/DP46fpr+Yv/bxuyTyqwq5kHzWhZeyb3bePc7uehd+0 SVjIBAA==
X-Developer-Key: i=blum@kernel.org; a=openpgp; fpr=1D60735E8AEF3BE473B69D84733678FD8DFEEAD4
Content-Transfer-Encoding: 8bit

In p8_init(), remove the goto statement and return ret directly.

Remove any redundant includes, add a missing space in MODULE_AUTHOR(),
and join the MODULE_DESCRIPTION() strings for better grepability.

Also remove MODULE_VERSION(). It has never been updated and the kernel
release better reflects the module version.

Signed-off-by: Thorsten Blum <blum@kernel.org>
---
 arch/powerpc/crypto/vmx.c | 14 +++-----------
 1 file changed, 3 insertions(+), 11 deletions(-)

diff --git a/arch/powerpc/crypto/vmx.c b/arch/powerpc/crypto/vmx.c
index 08da5311dfdf..8abc4db8ee4e 100644
--- a/arch/powerpc/crypto/vmx.c
+++ b/arch/powerpc/crypto/vmx.c
@@ -8,12 +8,7 @@
  */
 
 #include <linux/module.h>
-#include <linux/moduleparam.h>
-#include <linux/types.h>
-#include <linux/err.h>
 #include <linux/cpufeature.h>
-#include <linux/crypto.h>
-#include <asm/cputable.h>
 #include <crypto/internal/skcipher.h>
 
 #include "aesp8-ppc.h"
@@ -24,7 +19,7 @@ static int __init p8_init(void)
 
 	ret = crypto_register_skcipher(&p8_aes_cbc_alg);
 	if (ret)
-		goto err;
+		return ret;
 
 	ret = crypto_register_skcipher(&p8_aes_ctr_alg);
 	if (ret)
@@ -40,7 +35,6 @@ static int __init p8_init(void)
 	crypto_unregister_skcipher(&p8_aes_ctr_alg);
 err_unregister_aes_cbc:
 	crypto_unregister_skcipher(&p8_aes_cbc_alg);
-err:
 	return ret;
 }
 
@@ -54,8 +48,6 @@ static void __exit p8_exit(void)
 module_cpu_feature_match(PPC_MODULE_FEATURE_VEC_CRYPTO, p8_init);
 module_exit(p8_exit);
 
-MODULE_AUTHOR("Marcelo Cerri<mhcerri@br.ibm.com>");
-MODULE_DESCRIPTION("IBM VMX cryptographic acceleration instructions "
-		   "support on Power 8");
+MODULE_AUTHOR("Marcelo Cerri <mhcerri@br.ibm.com>");
+MODULE_DESCRIPTION("IBM VMX cryptographic acceleration instructions support on Power 8");
 MODULE_LICENSE("GPL");
-MODULE_VERSION("1.0.0");
