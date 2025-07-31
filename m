Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF841246BA1;
	Thu, 31 Jul 2025 19:27:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753990044; cv=none; b=sqbUrtARYE4kmHKJ4Zx3JuihZOmlJtTy9+/liLquVnRGcXKCqQ+lAGdSFeZO10xCGRTcy1q7bMrB2Wn8+0xyIAOAEf2iySqFxDALt/6HhmFEQ9EER8l853mr94l0JDvGgwYEVFn2NSUf08jpoxKR8VfvUuHESodzl3GUWu/iZ4I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753990044; c=relaxed/simple;
	bh=mN6755sqt+qk29UV1NSYQyBofmrRuYpedQbewjBEPeE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FoUjiol/5MJQHGRLJMoX6Z3SJ5tKppWVCEbmueuxvJ5T2vog+oQqByatRkbQ8yJS7zbZ+zkdBabjy2R6FDLo6gBdqrgFAA4otffcN6dlxZfFCxXwacbTSeEScbflatu/znUGwjCy1pCseywhp6n2nH4QvtnfQlHmNz7Kts8MswU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Pu2HFAYW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Pu2HFAYW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC63BC4CEF5;
	Thu, 31 Jul 2025 19:27:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1753990044;
	bh=mN6755sqt+qk29UV1NSYQyBofmrRuYpedQbewjBEPeE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Pu2HFAYWz5yqGcgXNNYm582+Fk3k69nctpy8EcQab7qq/KIk9Kd3DXkAzveCoCuz4
	 5itTcx9OfyuxGduJUDmdE95ikprre8FvBXUhWBE+4Oz7P1M9OtBS+gp/xagXxnanAs
	 fsKuIRxaupJnAL31H6XdYBT/azrV5ofscAWtPYgYnxltL11RjlLkoKzXBw4m7VpXEN
	 lcQzJfC/6dzg2lCHbmKnBB1shYV3nXHgqcKWqf0nYFYhxs2PtRX0XDN1nwVW1BMbbv
	 KoRXh1aGGwsjXwSpmg/ZVIA2yLjjrjVTIDP6nINy7NR96qKyaruDP55J/6WjXtzxKG
	 1fA/1LjoixGdw==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-usb@vger.kernel.org,
	Andreas Noever <andreas.noever@gmail.com>,
	Michael Jamet <michael.jamet@intel.com>,
	Mika Westerberg <westeri@kernel.org>,
	Yehezkel Bernat <YehezkelShB@gmail.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH 1/2] thunderbolt: Compare HMAC values in constant time
Date: Thu, 31 Jul 2025 12:25:44 -0700
Message-ID: <20250731192545.29869-2-ebiggers@kernel.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250731192545.29869-1-ebiggers@kernel.org>
References: <20250731192545.29869-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

To prevent timing attacks, HMAC value comparison needs to be constant
time.  Replace the memcmp() with the correct function, crypto_memneq().

Fixes: f67cf491175a ("thunderbolt: Add support for Internal Connection Manager (ICM)")
Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---
 drivers/thunderbolt/domain.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/thunderbolt/domain.c b/drivers/thunderbolt/domain.c
index 45239703745e5..7e0eb3c07f1c7 100644
--- a/drivers/thunderbolt/domain.c
+++ b/drivers/thunderbolt/domain.c
@@ -11,10 +11,11 @@
 #include <linux/module.h>
 #include <linux/pm_runtime.h>
 #include <linux/slab.h>
 #include <linux/random.h>
 #include <crypto/hash.h>
+#include <crypto/utils.h>
 
 #include "tb.h"
 
 static DEFINE_IDA(tb_domain_ida);
 
@@ -746,11 +747,11 @@ int tb_domain_challenge_switch_key(struct tb *tb, struct tb_switch *sw)
 	ret = crypto_shash_digest(shash, challenge, sizeof(hmac), hmac);
 	if (ret)
 		goto err_free_shash;
 
 	/* The returned HMAC must match the one we calculated */
-	if (memcmp(response, hmac, sizeof(hmac))) {
+	if (crypto_memneq(response, hmac, sizeof(hmac))) {
 		ret = -EKEYREJECTED;
 		goto err_free_shash;
 	}
 
 	crypto_free_shash(tfm);
-- 
2.50.1

