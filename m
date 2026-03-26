Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 647CD34EEE7
	for <linux-crypto@vger.kernel.org>; Thu, 26 Mar 2026 10:04:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774519482; cv=none; b=Cj4Bl5NuZODaUyBxaD6ouajC4vIJqv89R9qMoBmrsGUtKhuZQozV4QDiKg45nblA8yJM2ihpHe7cMxvDcYXUKEi0RHCo61XoZUS1JPMc6UsTbDumIMys70x3REYQUQ0+YkDE1gPkch6GHtX7J7eANVnTWj3GI9azmnHQ86TnMMY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774519482; c=relaxed/simple;
	bh=EKHc8UZRl7Y1xRPOrJAOYj/pVHhoxoc5HmxGsIfSpOY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=gg+9GAYu4IFyjntMCUC8/mdBQhRkSDrSqgeVJZcpfiCUTxiWqEoO1dXB06BWParmlZFpv46vBbNbucodVE/a94Ei8vhdudDPH1bSVLXT35ZZoLbjehUzaRaBiYIjezwZvi8qZk5iHDVLisyniAAJ79RfAiyY91mh2zfZEmpYvuo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ddjgGiwh; arc=none smtp.client-ip=192.198.163.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ddjgGiwh"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1774519481; x=1806055481;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=EKHc8UZRl7Y1xRPOrJAOYj/pVHhoxoc5HmxGsIfSpOY=;
  b=ddjgGiwhFi1fyPrkIYOrFvDdhHka8KmYDRZ4YHRG2TJBhSoPFViA2eyw
   9egGjDlLpiOUmeNrOhTrr6nD/m1jTPGFJ87g2HygVjCQzSpSJL5GAEjzQ
   oMB4VAAuL738a6g1U5awHtQXa/zKW7c3dt8cIDXzHeIU4KOpXhmM6HY2Z
   GC1y6SlQ7HDcTzlQp6drHliGdiFNZieHC1iAZPCYYdT6ZT0hV7HTwQYvb
   4mySxBEQnvN41k4UlX9Ru94ARJPU4DZqR7a/C4KHkarFiouL2nnxbFgB4
   tFDiK98e4Ub8wlAg6tR98/jOkCDTqwgwFRtJBOsEWwaNCzXdDy0I1WpgO
   w==;
X-CSE-ConnectionGUID: lsAoaIuTSB+No4VX/YTg3Q==
X-CSE-MsgGUID: HCcSbp+aQI+WPfZFUrpgBQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11740"; a="63124265"
X-IronPort-AV: E=Sophos;i="6.23,141,1770624000"; 
   d="scan'208";a="63124265"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Mar 2026 03:04:40 -0700
X-CSE-ConnectionGUID: i6TJ0/JjTWOHLTnwl8xfWg==
X-CSE-MsgGUID: RsonTxjKTeyr0AupYsoAjQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,141,1770624000"; 
   d="scan'208";a="262874350"
Received: from silpixa00401971.ir.intel.com ([10.20.226.106])
  by orviesa001.jf.intel.com with ESMTP; 26 Mar 2026 03:04:38 -0700
From: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
To: herbert@gondor.apana.org.au
Cc: linux-crypto@vger.kernel.org,
	qat-linux@intel.com,
	Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
	Laurent M Coquerel <laurent.m.coquerel@intel.com>
Subject: [PATCH v2] crypto: deflate - fix decompression window size
Date: Thu, 26 Mar 2026 09:59:22 +0000
Message-ID: <20260326100433.57324-1-giovanni.cabiddu@intel.com>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Organization: Intel Research and Development Ireland Ltd - Co. Reg. #308263 - Collinstown Industrial Park, Leixlip, County Kildare - Ireland
Content-Transfer-Encoding: 8bit

deflate_decompress() initializes the inflate stream with windowBits set
to -DEFLATE_DEF_WINBITS (11 bits, 2KB window). Valid raw DEFLATE streams
allow window sizes up to MAX_WBITS (15 bits, 32KB).

Data compressed with a history window larger than 2 KB, for example
produced by hardware compressors such as QAT or IAA, might not be
decompressed by deflate-generic since the inflate stream is initialized
with a 2 KB window. This might be seen, for example, when
deflate-generic is used as fallback.

Use -MAX_WBITS when calling zlib_inflateInit2() to accept all valid raw
DEFLATE streams. The inflate workspace allocated in deflate_alloc_stream()
is already sized using zlib_inflate_workspacesize(), which accounts for
the maximum window size, so no allocation change is needed.

Fixes: f6ded09de8bd ("crypto: acomp - add support for deflate via scomp")
Signed-off-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Reviewed-by: Laurent M Coquerel <laurent.m.coquerel@intel.com>
---
Changes since v1:
- Updated commit message to clearly state why this is needed for the
  deflate algorithm (i.e. allow data produced by HW compressors with
  larger history windows to be decompressed by deflate-generic, which
  is used as fallback).
- Updated fixes tag to point to the commit that introduced deflate
  support in scomp.

 crypto/deflate.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/crypto/deflate.c b/crypto/deflate.c
index 46fc7def8d4c..d347e506e6c3 100644
--- a/crypto/deflate.c
+++ b/crypto/deflate.c
@@ -203,7 +203,7 @@ static int deflate_decompress(struct acomp_req *req)
 	s = crypto_acomp_lock_stream_bh(&deflate_streams);
 	ds = s->ctx;
 
-	err = zlib_inflateInit2(&ds->stream, -DEFLATE_DEF_WINBITS);
+	err = zlib_inflateInit2(&ds->stream, -MAX_WBITS);
 	if (err != Z_OK) {
 		err = -EINVAL;
 		goto out;
-- 
2.53.0

