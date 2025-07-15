Received: from mail-pg1-f179.google.com (mail-pg1-f179.google.com [209.85.215.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 152E25C96;
	Tue, 15 Jul 2025 06:24:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752560669; cv=none; b=ABzvJ3TuewGZyYnUNpc8AD2Jx8A7iUmzRmGUUPI4sW868UMcBK4sLjQVMRVeaXUwH03S+F4zS/YwS7CswQXMtH0drvIYn0ywB2SXa2UqZaBf/Q/Mfnud72V1OFFijY+YNZvweXSD/0bplOIZAOIlNdJeIa2c1OgEWe5Cvv4N648=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752560669; c=relaxed/simple;
	bh=g4vK8+ewCImz+rjK4arl+/dmIVCWj1Nv+zLRHy1djlM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=OIxd5kPwvIvGDL77zd/7CQbbmug266qKNB9VdSGO7ltIPiGh50T6HytuKB80xKo6Mt1frdwb8WNLB3EEssqf/V6IC0ajyp+8UTRUgezRtzTrQEGmT5PHKaSGwbhuvbzvRCAZDGKUJOQosmTf4rfKU8287Oql1gFxPfmY2RpUmbI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=EpQ3RY1b; arc=none smtp.client-ip=209.85.215.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="EpQ3RY1b"
Received: by mail-pg1-f179.google.com with SMTP id 41be03b00d2f7-b31c84b8052so5878047a12.1;
        Mon, 14 Jul 2025 23:24:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1752560667; x=1753165467; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=/3GeJz9Omz0FOn0Kb8h9EISLJATP2UufU29k8Dqxp0Y=;
        b=EpQ3RY1bj0fGYLiwYWYAJcmvvOyE/g70AX82qHEe3UwwYftSLG9LFCimysCDJ6zEX9
         NEUQqk8aHbtY5tYrMCydkQp5Nn4nj8S0LEoKT+5JLGaPoPDxXprKQh+mLOBb8FySSNrV
         TeBC/qS/WHYuLvePlss9QSEpVKwEJndV9WdKpDYDO2kWk/3C6Wq5BqQUBtkdPow9kDsR
         lcWsBAXLzKmSkBK+vFqNLVLx65SehlO1dRCfnPiqOTnF9sWWV5uxHzQTdxY2WKfWISD+
         IFfh2EbZpVgJSBCt1b0kdGnry+sin8m+qXGSyyZOSBaiAmh31muNT6UasJLPsJ+EWpXV
         QCaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752560667; x=1753165467;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=/3GeJz9Omz0FOn0Kb8h9EISLJATP2UufU29k8Dqxp0Y=;
        b=rOS+e8ESo+BwQbTG8mB74RoXYwpzbTnzD5lo9JMpJ3UgipvKY01wBuFpy3in51ROKG
         Wsd+BaKaxZjgtuSK8cydhH7amJ33vmPzA3UyPs/JgFVUvpDu087wylSM9SMipT4nJ6WG
         yty4Rf95B9bzADYr3AgPZQwSMk+5xaelufeZSI30HyvllHmT6klCoVLtFOTUm5sFfA0R
         5GX2TtldPfmxuhB31SSbDmeZuMkPRIdM+BShi2nzFCNTHj4dpvi0BN8m04+8gRsbuVXe
         /86DdNoDgj2I67JkFAxI1zutMXu1uU4rOhfS8gWeczNZMIi+0cCoQvREL0XWGphc4853
         f5Uw==
X-Forwarded-Encrypted: i=1; AJvYcCUMWycDZT6wwxKEGeD6ZvOD9HVtgsaIIS47lzOKjbZm0EXtmWN+woxdii9r82wd4a/efcTbhOYOGGAiOag=@vger.kernel.org
X-Gm-Message-State: AOJu0YxdnI24qp5GHZS1OB9coWDd54XR0uqQ6z/iOo4oQ4WxaPOrTuNC
	K45CNz9O/ssLq6PnVEtNx4qqi11BCj0OMeT3OAJDK9WEtJxi427DPn9l
X-Gm-Gg: ASbGncuoxema3vtIDEjtv8xWH180HvQ2RSXtqwy0nbEBHH1pCjm2WEnVCouHLt2d4+i
	B4FWL05AJIKEry2yOF/dMGXeiO1s6DUJsCsSpa+dJ00vv0ClAEU78aVULahr54B6OfLG7sDf6iT
	ONe/M+9Fc2EtWOtP/gy4NMOMoMnjDY2e2DCyjuKbLNMZsDsxV1usXjV4JzjtHEu3rvmp2keXixL
	mf0MSgQcYlwlazhGYnBeO6H5m0InFiB9hA3Hnw+ROCY/q93qCJtopv5PmIpeG3lchbhUc6RRjNm
	95Z72TzaLFB9G0cLgb5cVuy2cEbKaq9urSOk6ywVlPuCi9UNiQ0zs6NVopRSUhKN2abP9RIkify
	iEZxOLV3ngw==
X-Google-Smtp-Source: AGHT+IGr5QFN4my7ai4srRYNbiB648JUm4RpfKdWKlSeX2rSE4Qy8CMDRILi7aFyybTbT/54Byj0Lw==
X-Received: by 2002:a05:6a21:b8b:b0:21f:5598:4c2c with SMTP id adf61e73a8af0-2311e535ba7mr27840761637.13.1752560667173;
        Mon, 14 Jul 2025 23:24:27 -0700 (PDT)
Received: from ws ([103.167.140.11])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-74eb9f536aesm11729467b3a.137.2025.07.14.23.24.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Jul 2025 23:24:26 -0700 (PDT)
From: Xiao Liang <shaw.leon@gmail.com>
To: Steffen Klassert <steffen.klassert@secunet.com>,
	Daniel Jordan <daniel.m.jordan@oracle.com>,
	Herbert Xu <herbert@gondor.apana.org.au>
Cc: linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] padata: Reset next CPU when reorder sequence wraps around
Date: Tue, 15 Jul 2025 14:23:57 +0800
Message-ID: <20250715062401.172642-1-shaw.leon@gmail.com>
X-Mailer: git-send-email 2.50.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When seq_nr wraps around, the next reorder job with seq 0 is hashed to
the first CPU in padata_do_serial(). Correspondingly, need reset pd->cpu
to the first one when pd->processed wraps around. Otherwise, if the
number of used CPUs is not a power of 2, padata_find_next() will be
checking a wrong list, hence deadlock.

Fixes: 6fc4dbcf0276 ("padata: Replace delayed timer with immediate workqueue in padata_reorder")
Signed-off-by: Xiao Liang <shaw.leon@gmail.com>
---
 kernel/padata.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/kernel/padata.c b/kernel/padata.c
index 7eee94166357..ebb52c6db637 100644
--- a/kernel/padata.c
+++ b/kernel/padata.c
@@ -290,7 +290,11 @@ static struct padata_priv *padata_find_next(struct parallel_data *pd,
 	if (remove_object) {
 		list_del_init(&padata->list);
 		++pd->processed;
-		pd->cpu = cpumask_next_wrap(cpu, pd->cpumask.pcpu);
+		/* When sequence wraps around, reset to the first CPU. */
+		if (unlikely(pd->processed == 0))
+			pd->cpu = cpumask_first(pd->cpumask.pcpu);
+		else
+			pd->cpu = cpumask_next_wrap(cpu, pd->cpumask.pcpu);
 	}
 
 	spin_unlock(&reorder->lock);
-- 
2.50.0

