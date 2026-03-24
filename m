Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1713B38236B
	for <linux-crypto@vger.kernel.org>; Tue, 24 Mar 2026 18:09:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774375750; cv=none; b=mCmlwpoqIJVKgaaNiWgewMIpquO0qpAdHXXnLGexN6Nf6q5deadHmK12Oo7j3D3Y6ok6zJiT+F+gSr6ep9z96kQ5zNWhhC3qcRqTyDjCzMnhY1byF6SOS81SlcuXHNWmNExKvVi2VYOnci8A26h5iN5NctxphxC12minIp5gdjI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774375750; c=relaxed/simple;
	bh=QBM/lO5cE0v1ryA/0eO17TXYANGoE/KQkIZT6063PSE=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=PWpy6niI4/HZGQWoD96MOrSga2Cfn1GvAWa8ioIzKHybsHb3mScffQ/3SlunqqhuXXgWQMVZgFto0+JIItfvS2/EN+lbrPxXAF1W2NZNkGDqoN1qzqyaBgrIqjW4Ca70P2foRIsCEEDS776QsWBU0gKTH0eZdvfcH/oIPRoREds=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ftrulPE8; arc=none smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ftrulPE8"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1774375749; x=1805911749;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=QBM/lO5cE0v1ryA/0eO17TXYANGoE/KQkIZT6063PSE=;
  b=ftrulPE8A95u+rOeSD/2/3juiHrBF5q0JPpWH0ng2psjtpWnuuPsjc9v
   qbgcItoV+EmmPkx0TA+eTFQULIfIJQz/DBoN7jrH/Hgoc27wnoVBi+Qmp
   KRGUH5Vr6/l/5Q7gfKWOGyVCuIhQslBU9YVPuRckQUF+EMIO836/CgQAQ
   F1Gkw/1/Vbzfw6JvxZYmbqUQMTS5pduSrgc/Qu73uZ3kVLKGiHsn1gf0j
   UTmgRQEKvTO8a4KzlureweJosRy2n7ph8jHR8D7r2Z5l32+ivKaSzeASx
   noUuteCHEKF3TOop9MI7EHDvwPFx/wyHuxXESUUcSpA0RWggjS4o+3KUQ
   w==;
X-CSE-ConnectionGUID: t8mY53NZQ5SvezmCaIeXJQ==
X-CSE-MsgGUID: 6oE679riREuI3KN4DlKv8A==
X-IronPort-AV: E=McAfee;i="6800,10657,11739"; a="86878467"
X-IronPort-AV: E=Sophos;i="6.23,138,1770624000"; 
   d="scan'208";a="86878467"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Mar 2026 11:09:09 -0700
X-CSE-ConnectionGUID: a0J2aDhLSX+GHWLQ6EEfCw==
X-CSE-MsgGUID: vJDUkpPATsWFbAtliAy2KA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,138,1770624000"; 
   d="scan'208";a="219557756"
Received: from silpixa00401971.ir.intel.com ([10.20.226.106])
  by fmviesa006.fm.intel.com with ESMTP; 24 Mar 2026 11:09:07 -0700
From: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
To: herbert@gondor.apana.org.au
Cc: linux-crypto@vger.kernel.org,
	qat-linux@intel.com,
	Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
	Laurent M Coquerel <laurent.m.coquerel@intel.com>
Subject: [PATCH] crypto: deflate - fix decompression window size
Date: Tue, 24 Mar 2026 18:08:58 +0000
Message-ID: <20260324180905.120703-1-giovanni.cabiddu@intel.com>
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
allow window sizes up to MAX_WBITS (15 bits, 32KB).  Using a smaller
window than the one used during compression causes decompression to fail
for externally generated data. This might occur if data is compressed
with a compressor that is not deflate-generic (i.e. this
implementation).

Use -MAX_WBITS when calling zlib_inflateInit2() to accept all valid raw
DEFLATE streams. The inflate workspace allocated in deflate_alloc_stream()
is already sized using zlib_inflate_workspacesize(), which accounts for
the maximum window size, so no allocation change is needed.

Fixes: 08cabc7d3c86 ("crypto: deflate - Convert to acomp")
Signed-off-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Reviewed-by: Laurent M Coquerel <laurent.m.coquerel@intel.com>
---
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

