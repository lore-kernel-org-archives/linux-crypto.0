Received: from mail-lf1-f43.google.com (mail-lf1-f43.google.com [209.85.167.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4FF4367F25
	for <linux-crypto@vger.kernel.org>; Wed, 22 Apr 2026 21:33:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776893639; cv=none; b=qYAekvXIvm26g/kn89xeoy/hXk47dr+6lFjyyRxYtyfbO0SGhTfuh3nhZeqp8zYPSTzKAnWOR31hTcBssf3mJnzaFxxZ72UCBWJ+89Dyq+NMHyNO4MR6ijoSF8mqc0BZOrNJyoulC+AdWiflMMJqq2v4qF2OA5FTRIc2n0zs9qw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776893639; c=relaxed/simple;
	bh=bu0ezSg3eXSHAn4od+sePxTgFrnLMGA7X7vvdBY4CqA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=cdC6SqiSy4gm4A0lWxYQj3HHcuhXsM2bQeiCsRBhng3geBRXTgPIo6IntzSNaYwQGG9HmIdXQcB7kfa+aC4DQLC4hGkhV/KMEVxDBEN7qmVl1uXvu500UFb4mFB2/hgsehP2710g0U4TTMuu04czsWucbmVZutpUK+lagbLCT68=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=N2F+if5d; arc=none smtp.client-ip=209.85.167.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="N2F+if5d"
Received: by mail-lf1-f43.google.com with SMTP id 2adb3069b0e04-59e5aa4ca41so5855383e87.2
        for <linux-crypto@vger.kernel.org>; Wed, 22 Apr 2026 14:33:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776893636; x=1777498436; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=dpp/pvEccJSCs2aYmYF/uD58hQ1rAlm0k4dG4FOoPeI=;
        b=N2F+if5docbWjNhKevq4MTY/v6tDoWIsLnFfXZrEzKiwFP2pq5MBHHP/lY7DsAqg/d
         HMegnPScTlmiMvyHY8OO9D17FdDLfdsdj29VROaG7WluT9Gt69pvCh+dYeqUc6oKcs70
         Qx89Hna1md369LPnl1SFqCsGgXCprc+wJCGYcCNOpg4+870dePKvgktZ9lTpifYMOJYq
         JxCzDMh+E04KwKJNpq9jYAGYa71pNuLYVovIBsjjVAo9X/ruoA1GG1awMsFzgUnKteER
         GGErIBE/sU7PxrRvPe3m1rxvKHrxzNbc76b96+x0OqM67qptDWN8v8Hpnr6qAlV/WQRD
         aPlw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776893636; x=1777498436;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=dpp/pvEccJSCs2aYmYF/uD58hQ1rAlm0k4dG4FOoPeI=;
        b=U9Sj/m0RudChzS6lli4RQQk/xkz8q8dKiEyeNvM0vPBM1wUxE3s4Ouqz/KDxR4NBTY
         28JOd9Dtsv1Sb+G+JxoOke0XbFyIi1hmCA1Mi2/1mdqWY3RUoFX77CRC1krJ5VwBuum0
         VxgD6hWeWO30uMt1H2F/QYSvzXhEoJ1IYIesJN7il+5dc7I9tyOjPT9k5vrnkZli7R9t
         ch62RBxyHhiOf8lwt7TJBtMMwLPD9xSZQKFL957VwO5dXUwfLqt1rAV6inkreSDHIGUN
         cnJqX0IkMhxiWiKLvGoeKZF8hnmVYUdH4QgVgjXUrPNiOLr+lPUvJeqCE6ofTzjmED97
         1Clw==
X-Forwarded-Encrypted: i=1; AFNElJ+n3E057YHC7dGBkVpRBAHj6xsibiI0XkeZmU1L5v881THpyaNeBoLXWuYngYnVCURXbluOfYEOC77oaKw=@vger.kernel.org
X-Gm-Message-State: AOJu0YzCEJHINkp1f5tN8wwrn+vYnzFLPCVLm3T+uV9njW2cRDGvAMFl
	B7MQmwV0VSdOB1SrurfRnk1nA2tkxL0AUzoVNMYyhvo4H5FCbc6VsWpg6IXNM8EcpzarTFtNzbA
	=
X-Gm-Gg: AeBDievaM+qOhHVnv+V7oCJYTOEDdA+gCcnIijt0jp/Moq45IzHJ70w3IWY0cOWovkb
	6H1GXrUvF75EPU2/t7RPuaOI65ma1gPcG/CAIQ6wZr15BYaBlcGJ9FvMcNJMTy//MfbnKESoy3g
	nQf00y43A+Ni1MPh86Q5t2S5TaKT8wjeSmoIOan6CyKvPX2yeC/W4Hi2T8VsVRQzHaqsP7wp7K3
	fpwpSo5qecd2+H3jAKh20VgbGUCl6fAa0c0+Tfppnk4hd57HM69sw3XA9oby+S85OmhM4I9Xb28
	j/nX/m7rdSKFnnT9VB2VZdk8EcV1r5FZgKrzY1z7oNa6uSk06Q9Ukzt2360atq81jPsIeDafPJx
	QZFzFC80onjk1rGzNFvAwFQ0Y0Wxgtqdk52H6DilOraZn8xAT2g6ZvAS0UPTbkMhTLenKVkFWfr
	B0DVMob9r54HMSy60C3nwgLs6+nTN48hiJ1+SMTd9+7dFQ
X-Received: by 2002:a05:6512:1109:b0:5a3:fd71:2781 with SMTP id 2adb3069b0e04-5a4172e7c37mr7632660e87.34.1776893635715;
        Wed, 22 Apr 2026 14:33:55 -0700 (PDT)
Received: from localhost ([188.234.148.119])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-5a4185ad343sm4697828e87.2.2026.04.22.14.33.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Apr 2026 14:33:54 -0700 (PDT)
From: Mikhail Gavrilov <mikhail.v.gavrilov@gmail.com>
To: Thomas Graf <tgraf@suug.ch>,
	Herbert Xu <herbert@gondor.apana.org.au>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Christian Brauner <brauner@kernel.org>,
	Jan Kara <jack@suse.cz>,
	"Darrick J . Wong" <djwong@kernel.org>,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	Mikhail Gavrilov <mikhail.v.gavrilov@gmail.com>
Subject: [PATCH 0/1] rhashtable: fix fs_reclaim circular dep in free_and_destroy
Date: Thu, 23 Apr 2026 02:33:48 +0500
Message-ID: <20260422213349.1345098-1-mikhail.v.gavrilov@gmail.com>
X-Mailer: git-send-email 2.54.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi all,

This fixes a lockdep "possible circular locking dependency detected"
between fs_reclaim and the rhashtable &ht->mutex class that surfaces
on kernels built from vfs-7.1-rc1.xattr or later. The cycle is created
by the simple_xattrs rhashtable conversion (commit b32c4a213698
"xattr: add rhashtable-based simple_xattr infrastructure") and its
per-subsystem adaptations in shmem (52b364fed6e1), kernfs (5bd97f5c5f24),
and pidfs (50704c391fbf), which made rhashtable_free_and_destroy()
reachable from evict() under the dcache shrinker. The deferred rehash
worker provides the forward edge (&ht->mutex -> fs_reclaim), and the
teardown path under fs_reclaim provides the reverse edge
(fs_reclaim -> &ht->mutex). Full splat and analysis are in the patch's
commit message.

The fix is in rhashtable_free_and_destroy() rather than in the three
simple_xattrs callers because:

 (a) three callers are affected, a library fix closes all of them at
     once;

 (b) after cancel_work_sync() returns, the rehash worker is quiesced
     and the function's documented contract already requires the
     caller to guarantee no concurrent operations -- so the mutex
     protects nothing and can just be removed.

A review of lib/rhashtable.c confirms that this is the only site
where &ht->mutex is acquired from a path reachable under fs_reclaim;
the deferred worker is the only other acquisition site and it is the
forward edge. Removing the acquisition therefore eliminates the class
cycle entirely.

The splat was observed organically on my workstation at ~35h uptime
under normal mixed workload with CONFIG_PROVE_LOCKING=y. Attempts at
synthetic reproduction within a few-minute window (tmpfs and kernfs
zombies, ~60k reclaim-path executions of simple_xattr_ht_free()) did
not trip lockdep, consistent with the rare coincidence-of-edges
profile of the bug; the forward edge is already present in
/proc/lockdep on idle systems via rht_deferred_worker, so verification
of the fix is by absence of the splat on a patched kernel under
extended normal workload.

Thanks,
Mikhail

Mikhail Gavrilov (1):
  rhashtable: drop ht->mutex in rhashtable_free_and_destroy()

 lib/rhashtable.c | 23 +++++++++++++++++------
 1 file changed, 17 insertions(+), 6 deletions(-)

-- 
2.54.0

