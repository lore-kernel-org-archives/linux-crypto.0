Received: from mx2.zhaoxin.com (mx2.zhaoxin.com [61.152.208.219])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E11F734B426
	for <linux-crypto@vger.kernel.org>; Fri, 13 Mar 2026 08:02:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=61.152.208.219
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773388974; cv=none; b=lxm9ClxB78TRS6qP4DGmbWdG8tpZD6IM17L1PclE66Yo7N1PJbyYX0lsoaOYirH/m6FIbsnOwCs5i/3vCnpmv9pc/g47n65Ml4wqrFNu8XlQPpRcYA0hpDUle7w3uUtQmSj/mFPRFQWCGZIiMQvi5fZxSi8woe00B0Q3ndEi44o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773388974; c=relaxed/simple;
	bh=HMMmNHbKOwt9UaccN9dNWdldruTYBDd9WN90JR0hE+E=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=Gh7C5D1Ns/T0q/KSUvyka3DWEgd9vT5p2FHZvjdbwgjV9rHEMquJWIaOQK0txPLUQXren9CxmORy+mskyCNuzQnMJI0QB7AoZDYIeffM7xuiUR6fqR84kLriGaUSSzdxEwlhwd2s0rV4kLYyKc5HUJD6HIpblvrfJQv9PioGCeI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=zhaoxin.com; spf=pass smtp.mailfrom=zhaoxin.com; arc=none smtp.client-ip=61.152.208.219
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=zhaoxin.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zhaoxin.com
X-ASG-Debug-ID: 1773388967-1eb14e06ec0ff80001-Xm9f1P
Received: from zhaoxin.com (zxmail.zhaoxin.com [10.28.208.166]) by mx2.zhaoxin.com with ESMTP id kccdu47E41KhY2Lp; Fri, 13 Mar 2026 16:02:47 +0800 (CST)
X-Barracuda-Envelope-From: AlanSong-oc@zhaoxin.com
X-Barracuda-RBL-Trusted-Forwarder: 10.28.208.166
Received: from desktop-a4i8d8t.zhaoxin.com (desktop-a4i8d8t.zhaoxin.com [10.32.65.156])
	by zhaoxin.com (f222c4) with ESMTP9496d38eed325444d40b1fa47ff3502d
	Fri, 13 Mar 2026 16:02:46 +0800
X-Eyou-Smtpauth: AlanSong-oc@zhaoxin.com
X-Barracuda-RBL-Trusted-Forwarder: 10.32.65.156
X-Eyou-EnvelopeSender: AlanSong-oc@zhaoxin.com
From: AlanSong-oc <AlanSong-oc@zhaoxin.com>
To: herbert@gondor.apana.org.au,
	davem@davemloft.net,
	ebiggers@kernel.org,
	Jason@zx2c4.com,
	ardb@kernel.org,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	x86@kernel.org
Cc: CobeChen@zhaoxin.com,
	TonyWWang-oc@zhaoxin.com,
	YunShen@zhaoxin.com,
	GeorgeXue@zhaoxin.com,
	LeoLiu@zhaoxin.com,
	HansHu@zhaoxin.com,
	AlanSong-oc <AlanSong-oc@zhaoxin.com>
Subject: [PATCH v4 0/2] lib/crypto: x86/sha: Add PHE Extensions support
Date: Fri, 13 Mar 2026 16:01:48 +0800
X-ASG-Orig-Subj: [PATCH v4 0/2] lib/crypto: x86/sha: Add PHE Extensions support
Message-Id: <20260313080150.9393-1-AlanSong-oc@zhaoxin.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Eyou-Sender: <alansong-oc@zhaoxin.com>
X-Barracuda-Connect: zxmail.zhaoxin.com[10.28.208.166]
X-Barracuda-Start-Time: 1773388967
X-Barracuda-URL: https://10.28.252.36:4443/cgi-mod/mark.cgi
X-Virus-Scanned: by bsmtpd at zhaoxin.com
X-Barracuda-Scan-Msg-Size: 2108
X-Barracuda-BRTS-Status: 1
X-Barracuda-Bayes: INNOCENT GLOBAL 0.0000 1.0000 -2.0210
X-Barracuda-Spam-Score: -2.02
X-Barracuda-Spam-Status: No, SCORE=-2.02 using global scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=1000.0 tests=
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.3.155781
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------

This series adds support for PHE Extensions optimized SHA256 transform
functions for Zhaoxin processors in lib/crypto, and disables
the padlock-sha driver on Zhaoxin platforms due to self-test failures.

After applying this patch series, the data block processing throughput
increases by approximately 2 to 5 times on the Zhaoxin KX-7000 platform,
depending on block size and hash algorithm, as measured by
CRYPTO_LIB_BENCHMARK. The KUnit test suites also pass successfully.

Changes in v4:
- Include benchmark results, test results, and the specification link
  directly in the commit message instead of the cover letter.
- Check CONFIG_CPU_SUP_ZHAOXIN directly in the condition rather than
  using #if/#endif for conditional compilation.
- Combine the CPU family check and the X86_FEATURE_PHE_EN feature check
  into a single condition.
- Correct the comment describing the instruction register requirements
  in both 32-bit and 64-bit operation modes.
- Fix the inline assembly constraints to match the instruction behavior
  for input and output registers.
- Only include XSHA256 support for SHA-256 and drop XSHA1 support.

Changes in v3:
- Implement PHE Extensions optimized SHA1 and SHA256 transform functions
  using inline assembly instead of separate assembly files
- Eliminate unnecessary casts
- Add CONFIG_CPU_SUP_ZHAOXIN check to compile out the code when disabled
- Use 'boot_cpu_data.x86' to identify the CPU family instead of
  'cpu_data(0).x86'
- Only check X86_FEATURE_PHE_EN for CPU support, consistent with other
  CPU feature checks.
- Disable the padlock-sha driver on Zhaoxin processors with CPU family
  0x07 and newer.

Changes in v2:
- Add Zhaoxin support to lib/crypto instead of extending the existing
  padlock-sha driver

AlanSong-oc (2):
  crypto: padlock-sha - Disable for Zhaoxin processor
  lib/crypto: x86/sha256: PHE Extensions optimized SHA256 transform
    function

 drivers/crypto/padlock-sha.c |  7 +++++++
 lib/crypto/x86/sha256.h      | 25 +++++++++++++++++++++++++
 2 files changed, 32 insertions(+)

-- 
2.34.1

