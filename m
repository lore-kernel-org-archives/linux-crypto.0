Received: from esa5.hc1455-7.c3s2.iphmx.com (esa5.hc1455-7.c3s2.iphmx.com [68.232.139.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77DCC3D81;
	Tue,  8 Apr 2025 04:18:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=68.232.139.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744085893; cv=none; b=fqJNsCz1nMN834H4WKIXQAdNZsHX+6qmfIVG503TovSdf1JZlB/+NUvhxgRNhbk6WGa15fYz2ex2VTNsrfYKD1OU7LNXnif6R9Dojogkz3atXmp79bB9V7ChpeSDBApQBd/ISl4JlSShH0ILld1/cgFau+BoGll7oIxrNgbfyZg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744085893; c=relaxed/simple;
	bh=O/Tn1U4L5YYmQ1KHlDb+KfX9uYMb4KE782y8YRNBRxc=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=ua/i7NhxJWCu6PfOB8cfMYf4KUAD0Kahl754L/+ki8pPdgfeKo+xhkDt8efzUnabx2MlLcO6+/iZhpY1nDGWuxouXXsO/DcbxAA1vv3Siiq45BDypSd8iEO8UCw6JIOocOTcOALUuDD2tFvLwKckUo8uxQWIHMpMEvVVYbl4rvQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=fujitsu.com; spf=pass smtp.mailfrom=fujitsu.com; dkim=pass (2048-bit key) header.d=fujitsu.com header.i=@fujitsu.com header.b=mGVSFPDQ; arc=none smtp.client-ip=68.232.139.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=fujitsu.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fujitsu.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fujitsu.com header.i=@fujitsu.com header.b="mGVSFPDQ"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=fujitsu.com; i=@fujitsu.com; q=dns/txt; s=fj2;
  t=1744085891; x=1775621891;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=O/Tn1U4L5YYmQ1KHlDb+KfX9uYMb4KE782y8YRNBRxc=;
  b=mGVSFPDQxQ2S6/fOlY/FX9AIOW09Og0aHL0l/L4X9FCcwZuJVYfxoThi
   0WsmF/tP8mQxAzLq0Zm/ax+hQE+UBqzMlrwrk/j6q1khSzE4bvDug6KCx
   dH6maWnRrodY7YSRbKy1R5IcWJPUvnmnbP0fzIoZ3rKcRgWpRKQg8eD4j
   Xh5awaPY7oyZgNuwTwoj1LnJyqQPWkuV6vs2WKqnegSnBRz5ldPUI5yH/
   1EfBr6S67qTfyD9ylaHiaiVMgzVec730N+vy/yS8Li+A5cAYsvbCwEw3y
   d8CgUxUkhpgF+hggkhy8dh9nR3IwSJbKVlLHQcRy1fN2QaxkRWeXgEBjU
   w==;
X-CSE-ConnectionGUID: xdMbCyNxQ9uH2vgM4dalFg==
X-CSE-MsgGUID: PTUOwp60THqMQBXcua4wvg==
X-IronPort-AV: E=McAfee;i="6700,10204,11397"; a="194925658"
X-IronPort-AV: E=Sophos;i="6.15,197,1739804400"; 
   d="scan'208";a="194925658"
Received: from unknown (HELO oym-r4.gw.nic.fujitsu.com) ([210.162.30.92])
  by esa5.hc1455-7.c3s2.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Apr 2025 13:16:59 +0900
Received: from oym-m1.gw.nic.fujitsu.com (oym-nat-oym-m1.gw.nic.fujitsu.com [192.168.87.58])
	by oym-r4.gw.nic.fujitsu.com (Postfix) with ESMTP id 24823DBB87;
	Tue,  8 Apr 2025 13:16:56 +0900 (JST)
Received: from edo.cn.fujitsu.com (edo.cn.fujitsu.com [10.167.33.5])
	by oym-m1.gw.nic.fujitsu.com (Postfix) with ESMTP id D8EEED8AE6;
	Tue,  8 Apr 2025 13:16:55 +0900 (JST)
Received: from iaas-rpma.. (unknown [10.167.135.44])
	by edo.cn.fujitsu.com (Postfix) with ESMTP id 2F7731A0078;
	Tue,  8 Apr 2025 12:16:54 +0800 (CST)
From: Li Zhijian <lizhijian@fujitsu.com>
To: herbert@gondor.apana.org.au,
	davem@davemloft.net,
	linux-crypto@vger.kernel.org
Cc: mcoquelin.stm32@gmail.com,
	alexandre.torgue@foss.st.com,
	linux-stm32@st-md-mailman.stormreply.com,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	Li Zhijian <lizhijian@fujitsu.com>,
	Erhard Furtner <erhard_f@mailbox.org>
Subject: [PATCH] crypto/testmgr: Fix acomp_req leak
Date: Tue,  8 Apr 2025 12:16:47 +0800
Message-Id: <20250408041647.88489-1-lizhijian@fujitsu.com>
X-Mailer: git-send-email 2.31.1
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The kmemleak reported that
...
unreferenced object 0xffff888108d6c300 (size 256):
  comm "cryptomgr_test", pid 183, jiffies 4294700957
  hex dump (first 32 bytes):
    00 c1 d6 08 81 88 ff ff 00 cb d6 08 81 88 ff ff  ................
    50 cd a7 81 ff ff ff ff b8 fb 93 02 00 c9 ff ff  P...............
  backtrace (crc 29cca632):
    __kmalloc_noprof+0x2fa/0x430
    test_acomp+0x174/0x960
    alg_test_comp+0x6f/0x90
    alg_test.part.26+0x105/0x410
    cryptomgr_test+0x20/0x40
    kthread+0x10c/0x250
    ret_from_fork+0x30/0x40
    ret_from_fork_asm+0x1a/0x30
unreferenced object 0xffff888108d6c100 (size 256):
  comm "cryptomgr_test", pid 183, jiffies 4294700972
  hex dump (first 32 bytes):
    00 1d da 08 81 88 ff ff 00 c3 d6 08 81 88 ff ff  ................
    50 cd a7 81 ff ff ff ff b8 fb 93 02 00 c9 ff ff  P...............
  backtrace (crc 3047d62b):
    __kmalloc_noprof+0x2fa/0x430
    test_acomp+0x174/0x960
    alg_test_comp+0x6f/0x90
    alg_test.part.26+0x105/0x410
    cryptomgr_test+0x20/0x40
    kthread+0x10c/0x250
    ret_from_fork+0x30/0x40
    ret_from_fork_asm+0x1a/0x30

acomp_request will be chained to req[0], however,
acomp_request_free(), it will not free the whole chain.

Fix it by freeing them one by one.

Fixes: 99585c2192cb ("crypto: testmgr - Add multibuffer acomp testing")
Reported-by: Erhard Furtner <erhard_f@mailbox.org>
Closes: https://lore.kernel.org/linux-crypto/20250408002741.089f1e9a@outsider.home/
Signed-off-by: Li Zhijian <lizhijian@fujitsu.com>
---
 crypto/testmgr.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/crypto/testmgr.c b/crypto/testmgr.c
index abd609d4c8ef..7f02feee9fb6 100644
--- a/crypto/testmgr.c
+++ b/crypto/testmgr.c
@@ -3498,10 +3498,10 @@ static int test_acomp(struct crypto_acomp *tfm,
 	ret = 0;
 
 out:
-	acomp_request_free(reqs[0]);
 	for (i = 0; i < MAX_MB_MSGS; i++) {
 		kfree(output[i]);
 		kfree(decomp_out[i]);
+		acomp_request_free(reqs[i]);
 	}
 	kfree(dst);
 	kfree(src);
-- 
2.27.0

