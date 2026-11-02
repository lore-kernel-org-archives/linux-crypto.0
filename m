Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.221.54
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793634837;
	b=klOHzwob+omTDU+jYZlhMpM+765AKBnTwjIOxNaEY4ACtzJVTkAGJMuEMVmuoxdyEBoy
	 XN0USRQrAR6uViD/AEV0axXjLY8G78SN6pSPQ8z2kC033OdToNwkPSKP2m+ABY1xKmQpj
	 j74j193K3SQFDUncQKaJ/62pkduFcWxmsIKw+GqiJQ2LfRoOxOI7xBLb80oEmPhwX+ZmK
	 0Fhk4YSuFimr1Z1WYxGUkBSsV1AD7SsyD7vn9xbKiaouIX9+0Aj+LJqsC71Ot7SNnWCF3
	 oR3lIceT1sLLEQnXzrdwm+8vX+oauHvB6ZQB87wlWwWdhuCDi6sWDyfW1RV+ldQiUPA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793634837;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:X-Google-Original-From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 MIME-Version:Content-Transfer-Encoding;
	bh=73DR8o62Fs8K8T2lKj1AIW1Z0OeA4tbHKQ/fX8k3s30=;
	b=bT/WfSp3s1XjUl+wnpCqPUvZAKzvn9Y22Loh6n6A7p0CjuJM5BOMrnTU5E56TmNrjb1v
	 BkbAgQGzfECsZPU4vRruT7FF8GUqpXrgfu4wGP1Olx4j9OtpJSgDdWnqUVxjfuk7/phDd
	 Xvtje4DoCl4am8/uq0hWwoaYWnvVVv0NWqSREcgWlINQpEzYl+vlB/wS/BysfmufINAuO
	 X61EQpbYIfpRN5Z3m/efvFS3xQI6e7tLGjQz6T8uGP7CcO7daFKPluE0T84GWsp5P55il
	 Tt6No/qh2Npja8L2aHFlGs4L501FnfEZRJ+xC+9NdFkF5Ty+RyYBGkX/xvCmnftviHw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=GSTzNnTp;
	arc=none smtp.remote-ip=209.85.221.54
Received: from mail-wr1-f54.google.com (mail-wr1-f54.google.com [209.85.221.54])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8EC9607B78F
	for <linux-crypto@vger.kernel.org>; Mon,  2 Nov 2026 15:53:56 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org C8EC9607B78F
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=GSTzNnTp
Received: by mail-wr1-f54.google.com with SMTP id ffacd0b85a97d-48afcfc4bf5so3259591f8f.1
        for <linux-crypto@vger.kernel.org>; Mon, 02 Nov 2026 07:53:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793634835; x=1794239635; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=73DR8o62Fs8K8T2lKj1AIW1Z0OeA4tbHKQ/fX8k3s30=;
        b=GSTzNnTpuWGoXoGwURiFUC+RcXlSjBM2byaI+KR0CSGw+H/KFBUlBesE+xenaYscIB
         k9GXHRknAoBNiRKs+8i4IeB8dHdxSgdTDVPDk79Ktc17BWcLA99KuIOdGOF38WxFFpbZ
         ZWqIiya+OOtDEjXCswiSRcmaJ3QgwmjDpfVA9bnJp+DjgnPuu/GbfpbbzuIlhMpXxBdG
         rJc+cmAmHOTLh8h/sk35iHv2Ml5TB+sdYeDpBoV2NSTsXzSbHhz7WVGvpI6qiv0wsRwM
         3xZauCPTaOBYo2/eXXNSxiQ1qDolSe78LZwAI8cqy7giQvyF9yCXt7pQVYmaF8Ct1Sn4
         6kPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793634835; x=1794239635;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=73DR8o62Fs8K8T2lKj1AIW1Z0OeA4tbHKQ/fX8k3s30=;
        b=vt072CSn/f3sQMMg1OPNZGkrP5SWvgd+xhmbnUJVVFw/VUOklYj2084IaNzXyjKfwC
         w6IASOyQeKptFlrM1fjKrfTbjWyTeZzpzOAd6qJljUhwNFu93edh5s/gyF6CdUS1JvfO
         oIDuhExojHVu7EADbPzjjRBS1Ad4VMEaUhU/FIp6i1UdPvhRxBryO9PIMURIDtLixoEm
         osHjkx7S23YfYInBrKQH8fpJ84E2a+c5R9srvHa+seEsKmhLSyu7WoBJSnC1wMxv/8Um
         70DKLa/i/NGDFVWeolDSRX4VfwGitwSM0SYCdP2rev/+9qv4lJHz2t8BsmpYWIX/RNvY
         G7Xg==
X-Forwarded-Encrypted: i=1; AKwUvBwiXguxEuKBMHODvH2YEp0KFvMoGYbZ7mhJAnpfnJfu2HV4Cdgchr/Pl3An3keilBjlOmXa+K8iNRHK2Zk=@vger.kernel.org
X-Gm-Message-State: APuU4Z9F5F9+cdyXTTNRfEdEIpBFCf1H6xHkh6WK5JzviPMLTTofkGly
	FzFvkb1ry7dKXq89U5n7G9iX2rtCFdNdfOmGwPG+HZVeydsKpWQMpCM=
X-Gm-Gg: AYBFou3xmFsmx9BoqW+5RN58OPK7RpFgnqPstUaJ6wSwYhJUQGWZXMC4hdWj1NDDp4m
	Ms43KtQwZlu563mnIelcoMsTojFH0dMjKGnJ1E3izF0Tj5bEm8E2OvfdJlsjECcXrYrJ5BdnoFg
	tt/u7u6NKVe8WCDJr8VCXWpn7qdU/PoplU/ESCcR023GArurfjW9lJAMnhh7M30MfPe/rzwwQbv
	zGCIler48w/J3iI9F01O9BasG5m5c8N1CciM/qYW5G7GHjNEhv2KnHyA0AlvU0/hKIpUUJssaJF
	sSfpmLwO0aAkYkNjxPniy8QNpwS8qWdyA58UephdrBYRkBzKdKGzH32+dl2wVYvQfe9Y5HLgSqY
	tBCRpELe4N+gvKkGIC0LTszcB8XqUPDwz2YgEZQFCQFh29QEJ1YWfEdvHzlqehHHyg2uGC/JB/v
	w3xYBxOaHyCCqIi9tr1pIVEp6o0/r1yCSkEWjdKfDNpDwwe3RN8mLJDA/rO1K3pi3jzRzNhlTSZ
	oZnpCyHFKKqb6EVYNefJEdFkY4Ase07o87PmeW+eDivEs0nbnggZOoMATZigW8PoSaz63lHnLuc
	a7HyTj4NbfE=
X-Received: by 2002:a05:6000:26c1:b0:48e:870:7791 with SMTP id ffacd0b85a97d-48e6e30b824mr21941019f8f.26.1793634834903;
        Mon, 02 Nov 2026 07:53:54 -0800 (PST)
Received: from debian.. ([2001:41d0:303:db6b::])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48e71b80eb1sm22010082f8f.34.2026.11.02.07.53.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Nov 2026 07:53:54 -0800 (PST)
From: Tristan Madani <tristmd@gmail.com>
X-Google-Original-From: Tristan Madani <tristan@talencesecurity.com>
To: steffen.klassert@secunet.com,
	daniel.m.jordan@oracle.com
Cc: herbert@gondor.apana.org.au,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org,
	Tristan Madani <tristan@talencesecurity.com>
Subject: [PATCH] padata: fix lockdep warning in padata_find_next()
Date: Mon,  2 Nov 2026 15:53:53 +0000
Message-ID: <20261102155353.1268322-1-tristan@talencesecurity.com>
X-Mailer: git-send-email 2.47.3
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

padata_find_next() acquires reorder->lock while the caller
padata_reorder() already holds squeue->serial.lock. Both locks are of
type struct padata_list and thus share the same lockdep class, which
triggers a false positive recursive locking warning even though the two
instances always protect different data.

Annotate the inner lock with spin_lock_nested() to tell lockdep about
the valid nesting.

Fixes: 16295bec6398 ("padata: Generic parallelization/serialization interface")
Cc: stable@vger.kernel.org
Signed-off-by: Tristan Madani <tristan@talencesecurity.com>
---
 kernel/padata.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/padata.c b/kernel/padata.c
index 0d3ea1b68b1f7..2f769ba7dfa99 100644
--- a/kernel/padata.c
+++ b/kernel/padata.c
@@ -253,7 +253,7 @@ static struct padata_priv *padata_find_next(struct parallel_data *pd, int cpu,
 
 	reorder = per_cpu_ptr(pd->reorder_list, cpu);
 
-	spin_lock(&reorder->lock);
+	spin_lock_nested(&reorder->lock, SINGLE_DEPTH_NESTING);
 	if (list_empty(&reorder->list))
 		goto notfound;
 
-- 
2.47.3

