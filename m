Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93B8521420F
	for <linux-crypto@vger.kernel.org>; Mon, 30 Jun 2025 09:24:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751275476; cv=none; b=SADaFS/suFZQJ/uz4QqQ6utbcVWzUR6116l9ysB7k3PHDf95EsBgfnD28QUGZOyHOx4wcU3SJP8NrZGTMxw78fHS/thME/sU8ays1sAWS36kGP3wW1AmIP92+/tbWbL2uzebfwK3yBq8q7ZmG1xwYGfthXzb2HFSvaB/DaMRtn8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751275476; c=relaxed/simple;
	bh=O0tubtzTnr3IFNko/vVKRwP/B3+U+gcmQjpnQW4/ohs=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=YqS2JSYAjQ06K0moYSoju+JG0/5QXJCpL2bEp24Syq6bknYdBLGOwz1c7ytWSJUd2WG4E9jDsU8HMN3F8jZZ+d7pFAkiHgLO5tUy59Ks4/2FNNYv2Up1Zc/HU/RjF2mu+06v2usey/c9uxxg+l7JrWlJ0bs4EhzoPVU/J1zSsis=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Pdml55sx; arc=none smtp.client-ip=192.198.163.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Pdml55sx"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1751275475; x=1782811475;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=O0tubtzTnr3IFNko/vVKRwP/B3+U+gcmQjpnQW4/ohs=;
  b=Pdml55sxGstmtd7rokQkzf4nC/lBttaMYE60q7T9Otwcjc95RoAf5VMo
   Ocy/NbnDnXi0kR8SS9VtNd4Te6IbDOvEx0GibG7aQltEIcZPl5m28T5fd
   cnjpxKgZANWReu/98k92Nq5FUskXwABiL7B9SjxlDh4UUlo6UAFVpn9yk
   iZZhvptFkq17XU6zNMCm7VhZ+8HNCWaHe/xf+QJz6aCJGXt1B4rqUhQ2u
   CWMUnAjKzyOiKd6z82ll8TrbYgLY7mt/PQTdsQplfRaoi1n3PMP8Quagk
   FhsC07U/P9bn4gOQzrfDBWyLg24qX7+hC30YjiEQbVKUD5VXDuJoZ8ozs
   g==;
X-CSE-ConnectionGUID: 8m2BvftrRjStoGQAhUtQ7g==
X-CSE-MsgGUID: mhsnfc/YQuOKo3SxFTA7bg==
X-IronPort-AV: E=McAfee;i="6800,10657,11479"; a="53588450"
X-IronPort-AV: E=Sophos;i="6.16,277,1744095600"; 
   d="scan'208";a="53588450"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Jun 2025 02:24:34 -0700
X-CSE-ConnectionGUID: B5O1+Vc6TZyEgD8JB7WYQQ==
X-CSE-MsgGUID: 4M6/nOnhQY+183F7+3FWFQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,277,1744095600"; 
   d="scan'208";a="159139241"
Received: from t21-qat.iind.intel.com ([10.49.15.35])
  by orviesa005.jf.intel.com with ESMTP; 30 Jun 2025 02:24:32 -0700
From: Suman Kumar Chakraborty <suman.kumar.chakraborty@intel.com>
To: herbert@gondor.apana.org.au
Cc: linux-crypto@vger.kernel.org,
	qat-linux@intel.com
Subject: [PATCH] crypto: zstd - fix duplicate check warning
Date: Mon, 30 Jun 2025 10:24:18 +0100
Message-Id: <20250630092418.918411-1-suman.kumar.chakraborty@intel.com>
X-Mailer: git-send-email 2.40.1
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Fix the following warnings reported by the static analyzer Smatch:
    crypto/zstd.c:273 zstd_decompress()
    warn: duplicate check 'scur' (previous on line 235)

Fixes: f5ad93ffb541 ("crypto: zstd - convert to acomp")
Reported-by: Dan Carpenter <dan.carpenter@linaro.org>
Closes: https://lore.kernel.org/linux-crypto/92929e50-5650-40be-8c0a-de81e77f0acf@sabinyo.mountain/
Signed-off-by: Suman Kumar Chakraborty <suman.kumar.chakraborty@intel.com>
Reviewed-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
---
 crypto/zstd.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/crypto/zstd.c b/crypto/zstd.c
index 657e0cf7b952..24edb4d616b5 100644
--- a/crypto/zstd.c
+++ b/crypto/zstd.c
@@ -268,10 +268,9 @@ static int zstd_decompress(struct acomp_req *req)
 			total_out += outbuf.pos;
 
 			acomp_walk_done_dst(&walk, outbuf.pos);
-		} while (scur != inbuf.pos);
+		} while (inbuf.pos != scur);
 
-		if (scur)
-			acomp_walk_done_src(&walk, scur);
+		acomp_walk_done_src(&walk, scur);
 	} while (ret == 0);
 
 out:

base-commit: 864453d2e854790ec8bfe7e05f84ecdb0167026d
-- 
2.40.1

