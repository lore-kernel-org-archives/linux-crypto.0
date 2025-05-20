Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DAD22242910;
	Tue, 20 May 2025 16:11:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747757515; cv=none; b=Ma428zK8/nAaywx9vGrjOUqwohGWWOgEwUDn3AYZAd8a/nvTof468xpaaL5LAKITyjzXNJvcJdgfsfl742dX06n7JyOLkSAQWvxJ1LE//1X+0P3/Arj+WocriSZnABAEFqbIbyhOUAmfg+anztVDBB1Zwo9eTGSn0yytwQkYQ0o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747757515; c=relaxed/simple;
	bh=8TCv7iaNOgpcGg7fLSHMHTHKnprZSRXQCZrTY/VJgR8=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=uVDs6rDy6E+TY44z8lV79Hnw2p8ETUHmtFPlAEDBFfzSRnIgSiIz/Sj/pYCPrApg9wAh4vunZcpUeLFjQahBiXwjBr0FHsEJf4r/HexfJlpF2vACecDjZX4ASCBgPJ8fOSQU8Ifs9Y89w0i3zqAVySlLpw/m6ftndRnBFDC6JRo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ddIqWwlM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ddIqWwlM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA7CFC4CEE9;
	Tue, 20 May 2025 16:11:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1747757514;
	bh=8TCv7iaNOgpcGg7fLSHMHTHKnprZSRXQCZrTY/VJgR8=;
	h=From:To:Cc:Subject:Date:From;
	b=ddIqWwlM5IMoAd6xU9iYH1SfbJrgQ9hh/qOVHQbYahrwQsOUCSCtqri/AMep18FEU
	 QaXE5PAwESrihZRRUB00HFBaPm3e7iSw5jyIQ6csehhjYxyP99r9dRboT7dDUsHAXF
	 oDVmjS/M0nQ58LSViKa3Dn9gAnrYMkDMRWWO9oWaGjfFF7xSWMdJscfKBka4Vd0p3P
	 crh3+BFlg4os0UVFSiqhwhWoMtizS6VLZLI8mYssETQarrjdD7LhnJ5zVEYt7TaJ5I
	 DkHiIIg3KnhRAbRXnJ/6WfXISzZhZQ1RXua4P1Lr07TgDf7HJBO2Dagyritsu3Ni9l
	 fcdJm/O+DzU4A==
From: Arnd Bergmann <arnd@kernel.org>
To: Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Karthikeyan Gopal <karthikeyan.gopal@intel.com>,
	Laurent M Coquerel <laurent.m.coquerel@intel.com>,
	Suman Kumar Chakraborty <suman.kumar.chakraborty@intel.com>
Cc: Arnd Bergmann <arnd@arndb.de>,
	George Abraham P <george.abraham.p@intel.com>,
	qat-linux@intel.com,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] crypto: qat - add missing header inclusion
Date: Tue, 20 May 2025 18:11:36 +0200
Message-Id: <20250520161148.3562622-1-arnd@kernel.org>
X-Mailer: git-send-email 2.39.5
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Arnd Bergmann <arnd@arndb.de>

Without this header, building the new driver fails with:

In file included from drivers/crypto/intel/qat/qat_common/adf_gen6_shared.c:7:
drivers/crypto/intel/qat/qat_common/adf_gen4_pfvf.h: In function 'adf_gen4_init_pf_pfvf_ops':
drivers/crypto/intel/qat/qat_common/adf_gen4_pfvf.h:13:34: error: 'adf_pfvf_comms_disabled' undeclared (first use in this function)
   13 |         pfvf_ops->enable_comms = adf_pfvf_comms_disabled;
      |                                  ^~~~~~~~~~~~~~~~~~~~~~~

Fixes: 17fd7514ae68 ("crypto: qat - add qat_6xxx driver")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/crypto/intel/qat/qat_common/adf_gen2_pfvf.h | 1 +
 drivers/crypto/intel/qat/qat_common/adf_gen4_pfvf.h | 1 +
 2 files changed, 2 insertions(+)

diff --git a/drivers/crypto/intel/qat/qat_common/adf_gen2_pfvf.h b/drivers/crypto/intel/qat/qat_common/adf_gen2_pfvf.h
index a716545a764c..9efee0053f3a 100644
--- a/drivers/crypto/intel/qat/qat_common/adf_gen2_pfvf.h
+++ b/drivers/crypto/intel/qat/qat_common/adf_gen2_pfvf.h
@@ -4,6 +4,7 @@
 #define ADF_GEN2_PFVF_H
 
 #include <linux/types.h>
+#include "adf_common_drv.h"
 #include "adf_accel_devices.h"
 
 #define ADF_GEN2_ERRSOU3 (0x3A000 + 0x0C)
diff --git a/drivers/crypto/intel/qat/qat_common/adf_gen4_pfvf.h b/drivers/crypto/intel/qat/qat_common/adf_gen4_pfvf.h
index 17d1b774d4a8..2c8708117f70 100644
--- a/drivers/crypto/intel/qat/qat_common/adf_gen4_pfvf.h
+++ b/drivers/crypto/intel/qat/qat_common/adf_gen4_pfvf.h
@@ -4,6 +4,7 @@
 #define ADF_GEN4_PFVF_H
 
 #include "adf_accel_devices.h"
+#include "adf_common_drv.h"
 
 #ifdef CONFIG_PCI_IOV
 void adf_gen4_init_pf_pfvf_ops(struct adf_pfvf_ops *pfvf_ops);
-- 
2.39.5

