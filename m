Received: from n169-114.mail.139.com (n169-114.mail.139.com [120.232.169.114])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BF153148CF;
	Sat, 25 Apr 2026 08:14:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=120.232.169.114
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777104897; cv=none; b=UIt+CNWhsMJeRr6ll3NuhFnXC0uxE7S8xKLqWMDNwReLh01rsf0FOcH538jiApj7eT+usX6dvW9dYeuoWqvzXUfBs4yRgsp8emiooj3pXSco2Y8B48XHGsVTJA6XVesCJ3ukDW1kDTxxXuNbW+Tln+C5vFwo9O1odRWNj/hEgAo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777104897; c=relaxed/simple;
	bh=ddfeOI+R7hDJpAcILUygndbFAujg5lQvECxLgLbVfkg=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=CcVlAFdupCK6qQib36nSkYMuceof6IZWnx1K/UIKK1A20f7oIpWGZFhq4hkr2tFKP2AhX09b/Lmdj2Mx+JzW623sZansfXtgj/B78SgKjdSJICWLQM6kEMDyDAF4Klyg3X6e+lGy6W9d1h8D8sGUD2wpuBr/L4Vr7dbyMHTtN/A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=139.com; spf=pass smtp.mailfrom=139.com; dkim=pass (1024-bit key) header.d=139.com header.i=@139.com header.b=PCmpbbFb; arc=none smtp.client-ip=120.232.169.114
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=139.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=139.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=139.com header.i=@139.com header.b="PCmpbbFb"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=139.com; s=dkim; l=0;
	h=from:subject:message-id:to:cc:mime-version;
	bh=47DEQpj8HBSa+/TImW+5JCeuQeRkm5NMpJWZG3hSuFU=;
	b=PCmpbbFbCZbJrq68Zc9F8HZr4M5TPwBZRf9bH5dOzhpz3FnHgFke6gHmzYszoZjp6lW5kwx8WOkxX
	 T4ByxOFCameBiognjLhTjs2HLnSfp0DLmllfpjcNsvNk3yT6tL9o/uDsIV8Dy5WX+VjS5cy0sg1TSn
	 VNwr5KMRhAww/nFE=
X-RM-TagInfo: emlType=0                                       
X-RM-SPAM:                                                                                        
X-RM-SPAM-FLAG:00000000
Received:from China-139-kernel-team (unknown[183.241.55.34])
	by rmsmtp-lg-appmail-42-12056 (RichMail) with SMTP id 2f1869ec77eaa3d-00a4a;
	Sat, 25 Apr 2026 16:14:40 +0800 (CST)
X-RM-TRANSID:2f1869ec77eaa3d-00a4a
From: Bin Lan <lanbincn@139.com>
To: gregkh@linuxfoundation.org,
	sashal@kernel.org,
	stable@vger.kernel.org
Cc: steffen.klassert@secunet.com,
	daniel.m.jordan@oracle.com,
	linux-crypto@vger.kernel.org,
	herbert@gondor.apana.org.au,
	Bin Lan <lanbincn@139.com>
Subject: [PATCH 6.12.y 0/2] backport to fix a race condition/UAF in padata_reorder
Date: Sat, 25 Apr 2026 16:14:28 +0800
Message-ID: <20260425081433.2763-1-lanbincn@139.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

After applying these patches to v6.12.y, the padata.c file matches the upstream 
version at commit 71203f68c774, with two exceptions:

1. cpumask_next_wrap API difference (line 310): The v6.12.y kernel still uses the 
old 4-argument form cpumask_next_wrap(cpu, pd->cpumask.pcpu, -1, false), 
whereas upstream uses the newer 2-argument form cpumask_next_wrap(cpu, pd->cpumask.pcpu).
These are functionally equivalent — upstream simply changed the API signature 
in a separate commit (dc5bb9b769c9), which is too invasive to backport.

2. Divide-by-zero guard in padata_mt_helper (after line 496): The v6.12.y 
doesn't include an extra check that forces chunk_size to at least 1 when 
the caller sets min_chunk to 0. This prevents a divide-by-zero panic. 

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


