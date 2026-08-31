Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E33194AEBFA;
	Mon, 31 Aug 2026 13:49:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788184142; cv=none; b=kEF7DnVOvfvc6DRUV/dD1hWdsyX7HOSjOtvBSmLfSMn4akdB80XAlhIbX4Jq6dZ8L1x9NIhdJXcPEo9GMkQl5RKkcQqC/AWMDH+xUrp6HFOeb96YFiua+mHsUXqezaoVi1jVS0UvfPOHPzd2BRkS+ZU0nYUGVQf7aTZCFSOG6zE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788184142; c=relaxed/simple;
	bh=P9cITSBQwsUaGmiskV4Yf88tAa2R9GMlDqy7yg0RjLk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=OgDJibbEvkHj86tYlSsehw/TaXBKDH5/sZgeiHTcKyK09lp4NPoVI1mh4RbkJlPiyWsyMgrkqClOuFQTsJU3pycRApsjX+DzDkDPKleDWm1qY4jvobYLqvfy5fDpJVN1ue5EVp+vDb7TXrD6vYC1czr6/pt4D3WTDKvJIr375WE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZwkXp5Xh; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZwkXp5Xh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 907B71F00ACF;
	Mon, 31 Aug 2026 13:48:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788184140;
	bh=CXazQErvLFJ2PhKGMzA7OzB+VrO5rrZMlu8+901gGLk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZwkXp5XhZtUZP+x65p1lxPwwHaOAmPWFWz4aNLL6PG362OFrq4Le67EvvpJ6wSTXj
	 /Bfg8iCfCVNVX9NH8Tj145kIRK2fPgOI7vee4O/k23dRl9ZcGqIAvwn5cUYD7GZJxr
	 8DwlzbMB3xdAyBBTlz5d4KJPbTPG/ZKVDeih/m+lbhZkRAMxTYeowA5AG65ndwUJPy
	 eyEdscf3cRaur4Svqbh2wVmCwe7a2zyAJmPZS8t85T7noEIElSxAawaf5qclMq1s46
	 e0Mdrxk3+ym93vS8zjlST4vXX19cfSKPGdXasR8V8ILGrcGuoEwLkgGLDuKt57koyR
	 M+w9r/hmjxiOg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Thorsten Blum <thorsten.blum@linux.dev>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>,
	davem@davemloft.net,
	nicolas.ferre@microchip.com,
	alexandre.belloni@bootlin.com,
	claudiu.beznea@tuxon.dev,
	linux-crypto@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-6.12] crypto: atmel-sha204a - remove sysfs group before hwrng
Date: Mon, 31 Aug 2026 09:29:04 -0400
Message-ID: <20260831133314.4125787-516-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260831133314.4125787-1-sashal@kernel.org>
References: <20260831133314.4125787-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.18.48
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Thorsten Blum <thorsten.blum@linux.dev>

[ Upstream commit d58b4a09d7f06750a706b70d068f5a678dad8233 ]

atmel_sha204a_probe() registers the hwrng before creating the sysfs
group. Mirror this order in atmel_sha204a_remove() by removing the sysfs
group before unregistering the hwrng.

Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

The background searches finished. The Herbert crypto tree is reachable,
and the upstream commit is **`d58b4a09d7f06`** (`crypto: atmel-sha204a -
remove sysfs group before hwrng`). It isn’t in the current **6.18.44**
ancestry — the buggy teardown order is still present in
`drivers/crypto/atmel-sha204a.c`.

That doesn’t change the earlier verdict: **YES** for backport to this
tree. It’s a one-line reorder that should keep the existing `kfree()`
(the LKML version also dropped it, which would be wrong here).

 drivers/crypto/atmel-sha204a.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/crypto/atmel-sha204a.c b/drivers/crypto/atmel-sha204a.c
index 8a3520c9a0ff5..2a37a4aeda92b 100644
--- a/drivers/crypto/atmel-sha204a.c
+++ b/drivers/crypto/atmel-sha204a.c
@@ -205,11 +205,10 @@ static void atmel_sha204a_remove(struct i2c_client *client)
 {
 	struct atmel_i2c_client_priv *i2c_priv = i2c_get_clientdata(client);
 
+	sysfs_remove_group(&client->dev.kobj, &atmel_sha204a_groups);
 	devm_hwrng_unregister(&client->dev, &i2c_priv->hwrng);
 	atmel_i2c_flush_queue();
 
-	sysfs_remove_group(&client->dev.kobj, &atmel_sha204a_groups);
-
 	kfree((void *)i2c_priv->hwrng.priv);
 }
 
-- 
2.53.0

