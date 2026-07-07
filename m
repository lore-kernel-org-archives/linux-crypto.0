Received: from mail-pj1-f50.google.com (mail-pj1-f50.google.com [209.85.216.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69BF83EB10D
	for <linux-crypto@vger.kernel.org>; Tue,  7 Jul 2026 16:41:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783442482; cv=none; b=qr5lfkCeXDZ8mJSupxAXbwdlDcsjojTxViuL3eKspD1jlLWQCQ5bkhiu7cK1O1cWohIozsTxM4m3lMT/Q++0qKI7KYrGXFIFp+K/TfLA7FBoeHbPYNfYCgiY65GwbpY5xXMeWuGkgKJKaVDVwNZ6QyPmjbZtv1psn90z/w9Nd+g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783442482; c=relaxed/simple;
	bh=pRw2aE3zP/6+tyDlVYaq9PHDVORyZOUtI3jc6WRypW8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=hStnul2T2R/Frb41x4giLOHxuDw9NSbg8bpVLvfAIw86Y/dCYCJby0bp5BR+o0qf1itEOtCZdB57RRF8QBK+HCD2aDxqL2kqBbPWGYAM92hAz3Wo7E//l7NalyaDJPOtL5qTRDDvSGWUJPKZr9ai1crVhEPsqACBzt7qZTfVer0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=cwGL8Wgb; arc=none smtp.client-ip=209.85.216.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="cwGL8Wgb"
Received: by mail-pj1-f50.google.com with SMTP id 98e67ed59e1d1-3811e59df58so2781652a91.1
        for <linux-crypto@vger.kernel.org>; Tue, 07 Jul 2026 09:41:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783442480; x=1784047280; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=um+I22NvykoeURWhQfLJXvnvNPhwLnxmij4j6eD24dA=;
        b=cwGL8WgblSRMktM4HZS+7zwzswsjORwC88MIsGFWcco7R1ByZcjJtv5UU22owziwYw
         ZUR8rNt3mftv1DZoPpJf0Sf+AK14MQ8dmdxZcncLZz085VIxlZHL9jkH6nrZx/3pTZFq
         oq92JvQUTxQuJMfKX+7pf5uhYufTY+2lM3+nXTzSyz+kHKTmdqpNKcNRCYy2pVGvL4WJ
         xTotsBbzBu35seAnM4ooHu9qOSBO4zHWF8933LLRfP2e44DXOYPhYNUDPe640g9ZjiJG
         DoJtGLatw5jA+TI326WJ6n7rSn2qVYGcjb3Ogdeuf3UBgxpqP53o0hD1ePjTwPN37L1T
         h+KA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783442480; x=1784047280;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=um+I22NvykoeURWhQfLJXvnvNPhwLnxmij4j6eD24dA=;
        b=XnYnA6Zc1ByWCla5w9b2Pkyvp0m35mK8gzxadkTyJQd6rDqj9Mj2/Jih1rWSDUnQXw
         jfx0td1hK/bme7CzppyydPtU+Cyj7CT5K4fgzp6rvLKBe13xYSULc0947FawVhbEPOdA
         SeFp42/gNQj4k5oMBekQKZja/yusnTTrRTTV7r2qwxiVELkGs2g48qrXGtyBC47xkdmq
         jVrMzyvnbPLgWffRQ+PanXINGqzBOLSrfEluEN6+B4vfXz3Nc+nbw7OGVLDcKaGrMgPS
         4cV+zf/69FewkPK2bFycj7uF4o2MDD8q96JhTBd1cBOqsCGo22OZG2mAPWRfPmT4/5h+
         rxCw==
X-Gm-Message-State: AOJu0YzznXxpFnE0N+/Lhejetsj9avCngncRpWrBQkHK3NhpgDpz28rD
	UNj6zJWVm9KsR0FXYBO0MmR+Cnf/l3CZ5F0kpaT31u8nP2FzUa1M0/vZ
X-Gm-Gg: AfdE7cloEUFP7inCZLMvG7y/QT4QWO043Tzprf/gjAHcCgAMwEB45s/imPtGuqBbZJB
	vwvHv8IvveKBQvReE4zXT5YZXaLQQGpHzwDkOqC2uMqZeGvYg1C/wF5FRPzz2r9e8gJeNeVna5k
	1bqtHB3QsI0idFAOhH+3U0qF7TBPX8ugK9QWe8vzjKzyNfmZg2cLQfm/kIkZdkDUtOSF7nQ7NbM
	Dj1VeIypql+Lq5i8/T/KtW44vhM1Il6gxq8ZkvYO6CeiGyf+inq5PsMinEPv9d6QRVx/7J7zsNa
	4qMhbJNL90NkQCb/iUl89EZdCxmRppBLpK/BHS3FieloNx+dC7oql/HQ9fMxcBGJvHs9Qh1fa/i
	Ei4IXjDA4z874TJEPApD3ox+M+wO3gJSSMTqK1D224W0TSxctL4Ft01bIPfaNu7ErXL7hjhiqzy
	ZmwmAASU8sQIS9TRfGtEa+ktpK7jIsEg==
X-Received: by 2002:a17:90b:1d52:b0:37f:d9dc:557 with SMTP id 98e67ed59e1d1-38756ce150bmr6769726a91.16.1783442479843;
        Tue, 07 Jul 2026 09:41:19 -0700 (PDT)
Received: from LAPTOP-83ECOPAB.localdomain ([167.220.149.19])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-387d15f0c35sm1448027a91.8.2026.07.07.09.41.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Jul 2026 09:41:19 -0700 (PDT)
From: "Cen Zhang (Microsoft)" <blbllhy@gmail.com>
To: herbert@gondor.apana.org.au,
	tgraf@suug.ch,
	akpm@linux-foundation.org
Cc: linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	AutonomousCodeSecurity@microsoft.com,
	tgopinath@linux.microsoft.com,
	kys@microsoft.com,
	blbllhy@gmail.com
Subject: [PATCH v3] lib/rhashtable: clear stale iter->p on table restart
Date: Tue,  7 Jul 2026 12:41:15 -0400
Message-ID: <20260707164115.4979-1-blbllhy@gmail.com>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

rhashtable_walk_start_check() has two restart paths when resuming a walk.
When iter->walker.tbl is valid, it re-validates iter->p against the table
and sets iter->p = NULL if the object is gone.  When iter->walker.tbl is
NULL (table was freed during resize), it resets slot and skip but forgets
to clear iter->p.

rhashtable_walk_next() then dereferences the stale iter->p, reading
freed memory.  This is a use-after-free.

Any caller that does multi-fragment rhashtable walks across
walk_stop/walk_start boundaries is affected.  Concrete cases include
netlink_diag (__netlink_diag_dump in net/netlink/diag.c) and TIPC
(tipc_nl_sk_walk in net/tipc/socket.c).

Crash stack (netlink_diag):
  BUG: KASAN: slab-use-after-free in rhashtable_walk_next+0x365/0x3c0
  Read of size 8 at addr ffff88801a9d2438 (freed kmalloc-2k, offset 1080)
  Call Trace:
   rhashtable_walk_next+0x365/0x3c0 (lib/rhashtable.c:1016)
   __netlink_diag_dump+0x160/0x760 (net/netlink/diag.c:122)
   netlink_diag_dump+0xc2/0x240
   netlink_dump+0x5bc/0x1270
   netlink_recvmsg+0x7a3/0x980
   sock_recvmsg+0x1bc/0x200
   __sys_recvfrom+0x1d4/0x2c0

Fixes: 5d240a8936f6 ("rhashtable: improve rhashtable_walk stability when
stop/start used.")
Reported-by: AutonomousCodeSecurity@microsoft.com
Closes: https://lore.kernel.org/linux-crypto/CAB8m9Wh559e+=n8z51gB8DrbEyCc2mc0MgGjrRR6_VXBmU=2AQ@mail.gmail.com
Signed-off-by: Cen Zhang (Microsoft) <blbllhy@gmail.com>
---
v3: Solved patch format issue
v2: Fix commit subject in Fixes tag
Link: https://lore.kernel.org/linux-crypto/CAB8m9Wh559e+=n8z51gB8DrbEyCc2mc0MgGjrRR6_VXBmU=2AQ@mail.gmail.com

 lib/rhashtable.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/lib/rhashtable.c b/lib/rhashtable.c
index 40cfb38ac..d459bef24 100644
--- a/lib/rhashtable.c
+++ b/lib/rhashtable.c
@@ -878,6 +878,7 @@ int rhashtable_walk_start_check(struct rhashtable_iter *iter)
 		iter->walker.tbl = rht_dereference_rcu(ht->tbl, ht);
 		iter->slot = 0;
 		iter->skip = 0;
+		iter->p = NULL;
 		return -EAGAIN;
 	}
 
-- 
2.53.0

