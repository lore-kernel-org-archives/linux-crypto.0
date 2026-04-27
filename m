Received: from n169-114.mail.139.com (n169-114.mail.139.com [120.232.169.114])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BEF3389105;
	Mon, 27 Apr 2026 07:48:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=120.232.169.114
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777276110; cv=none; b=SYH2tlc+jIoyg0m0Ie2cICMvo1CUr4A1skx4Ji9R3EMuuLwaYcFf5C8pVUCYgFbT3TGj6O/eniipudPkJyYisyYsl115w200jpFjwy746z7ipFsWuRq/hn+rk9wTTHrnIRO5h3TXpC8awJWXqjsihQ7i6PwmdzwnssKXVRNmAbM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777276110; c=relaxed/simple;
	bh=98JmroxkQRjjW4KlW3LXkMnJd1s8aFp7/+zrFJ5iJ3w=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=COzkAcfNHpAOYvdS/14NJvjf4iydVjTTtA6l5ZgCwox/vUJwW4C+HN18azSJBJpcump/nCu8PpdtzYGdgTKJcgl3Wuwbn2htxW8kjuBeDTrRxxyqPGCgoQ4/BPUXQ/8iNOT+nsesY1o34bcaLldzl09Vb3RR8REV0HnjZ9sOYBI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=139.com; spf=pass smtp.mailfrom=139.com; dkim=pass (1024-bit key) header.d=139.com header.i=@139.com header.b=X0w/uhGn; arc=none smtp.client-ip=120.232.169.114
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=139.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=139.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=139.com header.i=@139.com header.b="X0w/uhGn"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=139.com; s=dkim; l=0;
	h=from:subject:message-id:to:cc:mime-version;
	bh=47DEQpj8HBSa+/TImW+5JCeuQeRkm5NMpJWZG3hSuFU=;
	b=X0w/uhGnEbjLUVVpLL4dwXEqj7T2Je+lGydnu9MOFhUdSQEdrKLKEQxfSJVhl0BZEWp26BB95sHqo
	 J2746UxCa+lIdrhlwy7J/cEk9c4bwrYguauMphfqvNYeBQD7N8jahRpQxTK4O7gxr1NheVQzfjYEho
	 P8WqQFLXlLaQxTHw=
X-RM-TagInfo: emlType=0                                       
X-RM-SPAM:                                                                                        
X-RM-SPAM-FLAG:00000000
Received:from China-139-kernel-team (unknown[60.247.85.88])
	by rmsmtp-lg-appmail-44-12058 (RichMail) with SMTP id 2f1a69ef14bcfd3-06052;
	Mon, 27 Apr 2026 15:48:19 +0800 (CST)
X-RM-TRANSID:2f1a69ef14bcfd3-06052
From: Bin Lan <lanbincn@139.com>
To: gregkh@linuxfoundation.org,
	sashal@kernel.org,
	stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	steffen.klassert@secunet.com,
	daniel.m.jordan@oracle.com,
	linux-crypto@vger.kernel.org,
	Bin Lan <bin.lan.cn@windriver.com>
Subject: [PATCH 6.1.y 0/2] backport to fix a race condition/UAF in padata_reorder
Date: Mon, 27 Apr 2026 15:47:12 +0800
Message-Id: <20260427074714.1569476-1-lanbincn@139.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Bin Lan <bin.lan.cn@windriver.com>

This series backports the fix for a use-after-free vulnerability in the
padata subsystem, to the Linux 6.1.y stable branch.

Backport notes for 6.1.y:

  - The upstream fix (commit 71203f68c774) was written against mainline
    which uses the 2-argument cpumask_next_wrap(cpu, mask) API introduced
    by dc5bb9b769c9 ("cpumask: deprecate cpumask_next_wrap()"). Since
    6.1.y still has the original 4-argument API, the call in
    padata_reorder() is adapted to:
      cpumask_next_wrap(cpu, pd->cpumask.pcpu, -1, false)
    This is functionally equivalent.

  - The context in padata_find_next() differs from mainline due to
    f954a2d37637 ("padata: switch padata_find_next() to using
    cpumask_next_wrap()") not being present in 6.1.y. The conflict was
    resolved.

After applying this series, kernel/padata.c matches the upstream file at
commit 71203f68c774 with a few differences. None of these differences 
affect the fix, the core changes to padata_find_next(), padata_reorder(), 
and padata_do_serial() are identical.

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


