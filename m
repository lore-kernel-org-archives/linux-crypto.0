Received: from out-186.mta1.migadu.com (out-186.mta1.migadu.com [95.215.58.186])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 060363750BF
	for <linux-crypto@vger.kernel.org>; Fri, 20 Mar 2026 08:49:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.186
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773996593; cv=none; b=ImDr8C402NmC3cke/ogRV89Njio8ETeiqiTLVdJugjjStjtXYqnM3HhYVxkdOKoXe7JQzwYY1l1gi/kb4W5JcEr1YNwxYSBCS17wc1k5MiPRAbWjWSl+HRe+ZoN/BkN8Bp4efZ1pLN30g1PGlDcUbgzIzaV7hYNiqtsP/mcsQBc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773996593; c=relaxed/simple;
	bh=fS46rTjiGgSzi3MWcwcXeXN0mlGqe7jt3cqh8IomgFk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XHzD2pQ56mL80XfaZ9AQmPZwVrN9ohrVyU/5BJ3PqR+lVb0hPAGFJ1ojfNpHdjvvZkK5njL4oAYMIIJeRNDaG7WXPG90yxWrhoawQq9peJzkdJ0A21xHzNo7GThH2VD8oi+yH44Vh6eq03pxxxqwU+fKD2viRylVAIfn5ZHD19M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=a6B8WhbC; arc=none smtp.client-ip=95.215.58.186
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="a6B8WhbC"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1773996588;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=izBpg3f4YsX+0N/YH8T17Ma2BiNyBCvm7Snr6+pnP1s=;
	b=a6B8WhbCKhlkLZh25B+fJjUtDE+V8ipFSZHjbFSa9r9aV1THdd8ZfgOXQEW/TkU81tEbTK
	nUiuJzojPI6m77qrVliMsB6Gv6mxGyT+xhYB8K8Ct+mdxq8v/1wDKUmYjpO03K9fzcmQD1
	/PGidZXC+LvLp30mGIaS9Be1fSQ8GpE=
From: Thorsten Blum <thorsten.blum@linux.dev>
To: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Maxime Coquelin <mcoquelin.stm32@gmail.com>,
	Alexandre Torgue <alexandre.torgue@foss.st.com>,
	Colin Ian King <colin.i.king@gmail.com>,
	Kees Cook <kees@kernel.org>,
	=?UTF-8?q?Maxime=20M=C3=A9r=C3=A9?= <maxime.mere@foss.st.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Thorsten Blum <thorsten.blum@linux.dev>
Cc: linux-crypto@vger.kernel.org,
	linux-stm32@st-md-mailman.stormreply.com,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] crypto: stm32 - use list_first_entry_or_null to simplify cryp_find_dev
Date: Fri, 20 Mar 2026 09:49:14 +0100
Message-ID: <20260320084914.7180-4-thorsten.blum@linux.dev>
In-Reply-To: <20260320084914.7180-3-thorsten.blum@linux.dev>
References: <20260320084914.7180-3-thorsten.blum@linux.dev>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1158; i=thorsten.blum@linux.dev; h=from:subject; bh=fS46rTjiGgSzi3MWcwcXeXN0mlGqe7jt3cqh8IomgFk=; b=owGbwMvMwCUWt7pQ4caZUj3G02pJDJl7uYRvdnaf6P13MGC5mZTXtuU8Nc1+4ffmGp9k0f7Ep cxpcfF0RykLgxgXg6yYIsuDWT9m+JbWVG4yidgJM4eVCWQIAxenAExkmRAjw1edX79VZN9LTwt8 PNfnxL534ucuMNledLWqFPI+sV7nuD0jw76v8x3OP13QstZjSl2moWvhoVAX90W8d/dcffy1vG0 yKxcA
X-Developer-Key: i=thorsten.blum@linux.dev; a=openpgp; fpr=1D60735E8AEF3BE473B69D84733678FD8DFEEAD4
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Use list_first_entry_or_null() to simplify stm32_cryp_find_dev() and
remove the now-unused local variable 'struct stm32_cryp *tmp'.

Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
---
 drivers/crypto/stm32/stm32-cryp.c | 16 +++++-----------
 1 file changed, 5 insertions(+), 11 deletions(-)

diff --git a/drivers/crypto/stm32/stm32-cryp.c b/drivers/crypto/stm32/stm32-cryp.c
index 3c9b3f679461..b79877099942 100644
--- a/drivers/crypto/stm32/stm32-cryp.c
+++ b/drivers/crypto/stm32/stm32-cryp.c
@@ -361,19 +361,13 @@ static int stm32_cryp_it_start(struct stm32_cryp *cryp);
 
 static struct stm32_cryp *stm32_cryp_find_dev(struct stm32_cryp_ctx *ctx)
 {
-	struct stm32_cryp *tmp, *cryp = NULL;
+	struct stm32_cryp *cryp;
 
 	spin_lock_bh(&cryp_list.lock);
-	if (!ctx->cryp) {
-		list_for_each_entry(tmp, &cryp_list.dev_list, list) {
-			cryp = tmp;
-			break;
-		}
-		ctx->cryp = cryp;
-	} else {
-		cryp = ctx->cryp;
-	}
-
+	if (!ctx->cryp)
+		ctx->cryp = list_first_entry_or_null(&cryp_list.dev_list,
+						     struct stm32_cryp, list);
+	cryp = ctx->cryp;
 	spin_unlock_bh(&cryp_list.lock);
 
 	return cryp;
