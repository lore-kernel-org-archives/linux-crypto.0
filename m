Received: from n169-113.mail.139.com (n169-113.mail.139.com [120.232.169.113])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E72C255E43;
	Mon, 27 Apr 2026 05:48:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=120.232.169.113
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777268924; cv=none; b=ETEdqiAdqAZzs0f7CkHYKPgdMD5bd5ZGWKBDoLamm3j8MxHVqu4pRon7o4nyFZhprDDRvUxuiBmCuzk+8WGlS+okbVbRdkH7RGGMMfef2wX2SNAX/eA+3fSIvs+3HJge2XVNDeNlqqQK051pyV6xNP/yaywUvs8bBDM5gqom0yk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777268924; c=relaxed/simple;
	bh=OSGfXIgCoTn4Lmg1h8RH5QjW3igILX2lfnY1spGS5s4=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=rCdqVkqMNzsdGXff7dsYnRpYKcvx0Z+iI/9TRHUmOn/6Lzvy7BUCLrN4lzsu5llqfoA6/pwVTFBi76VNtomAS8IJsQx3+Mip0Rr7Jmqi6Ry6Bpmh+Rlimw7c9aJwGqlJKIQBSOCs0esfXzrsCKP4auDwzbfgglhG+pKsNkeow+I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=139.com; spf=pass smtp.mailfrom=139.com; dkim=pass (1024-bit key) header.d=139.com header.i=@139.com header.b=NVFZb9iG; arc=none smtp.client-ip=120.232.169.113
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=139.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=139.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=139.com header.i=@139.com header.b="NVFZb9iG"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=139.com; s=dkim; l=0;
	h=from:subject:message-id:to:cc:mime-version;
	bh=47DEQpj8HBSa+/TImW+5JCeuQeRkm5NMpJWZG3hSuFU=;
	b=NVFZb9iG2zMmgvx5onN9B20c3TUnq+xLcBJDcuFnTxaDQ82kiABPXGs1G6AQ4oPznRNiOXH9breTX
	 W3uyaw7XHL5kVPjtaNBBjnYkJDlx+QWkVkD9FFv0iqq4bBCYsD8JWKEp6Oc0JHaPrjJUDxNBWUDbPX
	 sbQ47dDywmFAffKY=
X-RM-TagInfo: emlType=0                                       
X-RM-SPAM:                                                                                        
X-RM-SPAM-FLAG:00000000
Received:from China-139-kernel-team (unknown[60.247.85.88])
	by rmsmtp-lg-appmail-33-12047 (RichMail) with SMTP id 2f0f69eef8a4fca-07055;
	Mon, 27 Apr 2026 13:48:25 +0800 (CST)
X-RM-TRANSID:2f0f69eef8a4fca-07055
From: Bin Lan <lanbincn@139.com>
To: gregkh@linuxfoundation.org,
	sashal@kernel.org,
	stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	steffen.klassert@secunet.com,
	daniel.m.jordan@oracle.com,
	linux-crypto@vger.kernel.org,
	Bin Lan <lanbincn@139.com>
Subject: [PATCH 6.6.y 0/2] backport to fix a race condition/UAF in padata_reorder
Date: Mon, 27 Apr 2026 13:46:41 +0800
Message-Id: <20260427054643.4121360-1-lanbincn@139.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This series backports the fix for a use-after-free vulnerability in the 
padata subsystem, to the Linux 6.6.y stable branch.

Backport notes for 6.6.y:
  - The upstream fix (commit 71203f68c774) was written against mainline
    which uses the 2-argument cpumask_next_wrap(cpu, mask) API introduced
    by dc5bb9b769c9 ("cpumask: deprecate cpumask_next_wrap()"). Since
    6.6.y still has the original 4-argument API, the call in
    padata_reorder() is adapted to:
      cpumask_next_wrap(cpu, pd->cpumask.pcpu, -1, false)
    This is functionally equivalent.

  - The context in padata_find_next() differs from mainline due to
    f954a2d37637 ("padata: switch padata_find_next() to using
    cpumask_next_wrap()") not being present in 6.6.y. The conflict was
    resolved.

After applying this series to v6.6.y, kernel/padata.c matches the upstream file at
commit 71203f68c774 with the following expected differences:

  1. cpumask_next_wrap() uses the 4-arg form (API not renamed in 6.6.y)
  2. padata_do_multithreaded() in 6.6.y lacks NUMA-aware dispatch (not backported)
  3. padata_do_multithreaded() in 6.6.y has an extra divide-by-zero guard for
     chunk_size

Thanks
Bin Lan

Herbert Xu (2):
  padata: Fix pd UAF once and for all
  padata: Remove comment for reorder_work

 include/linux/padata.h |   4 --
 kernel/padata.c        | 136 +++++++++++------------------------------
 2 files changed, 37 insertions(+), 103 deletions(-)

-- 
2.43.0


