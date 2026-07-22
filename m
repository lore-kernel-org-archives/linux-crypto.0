Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D22FA40F723
	for <linux-crypto@vger.kernel.org>; Wed, 22 Jul 2026 10:28:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784716088; cv=none; b=XxcEwSik4VCO/f+0bCFwqt5lhrxpDDKEv4vlKwe01ky0dudoOK0zPxemVTzSoKZevOnd+hMrh6BBdG27nxHicJc+q46sYYhGDca4FdjGGpnDx4xnASH6M3GZsbuya1hYzPZR/x3ct9SI0Mn1uPSgx5Iwg/Mo2s/c/9qK9304DrE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784716088; c=relaxed/simple;
	bh=tamOOR1l91D8w89VvapZUATGFIOuqPucThTfL69mdWA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=A/WtocxCkfEKxL76QMv5WbdRl7yzDl3j95+mqieuRqQnortxmq3oc73gl4G0ydtMoOh4GtSvDWHS+UmICvUjY+qV2FMYQkjOAoQLoM56k3sbHjhI1iNJ3gBy5brXzMtr8rcpxZLROsnhFE9dYP430w8jwgK1xCdR2XZanOZ7ctk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 007B460288; Wed, 22 Jul 2026 12:27:58 +0200 (CEST)
From: Florian Westphal <fw@strlen.de>
To: herbert@gondor.apana.org.au
Cc: mikhail.v.gavrilov@gmail.com,
	linux-crypto@vger.kernel.org,
	Florian Westphal <fw@strlen.de>
Subject: [PATCH] rhashtable: fix false-positive lockdep splat on rhltable destruction
Date: Wed, 22 Jul 2026 12:27:48 +0200
Message-ID: <20260722102748.6292-1-fw@strlen.de>
X-Mailer: git-send-email 2.54.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Blamed commit removed ht->mutex usage during destruction but forgot to
switch rhashtable_free_one() to rcu_dereference_raw(), this triggers a
lockdep splat when an rhltable gets zapped.

Fixes: 09ae540e1d5c ("rhashtable: drop ht->mutex in rhashtable_free_and_destroy()")
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 lib/rhashtable.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/lib/rhashtable.c b/lib/rhashtable.c
index 40cfb38ac919..68de5019abbf 100644
--- a/lib/rhashtable.c
+++ b/lib/rhashtable.c
@@ -1260,7 +1260,7 @@ static void rhashtable_free_one(struct rhashtable *ht, struct rhash_head *obj,
 	list = container_of(obj, struct rhlist_head, rhead);
 	do {
 		obj = &list->rhead;
-		list = rht_dereference(list->next, ht);
+		list = rcu_dereference_raw(list->next);
 		free_fn(rht_obj(ht, obj), arg);
 	} while (list);
 }
-- 
2.54.0

