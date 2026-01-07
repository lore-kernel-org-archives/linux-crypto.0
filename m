Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8ACE023EAAF;
	Wed,  7 Jan 2026 03:40:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767757227; cv=none; b=jE62zZmqUTfgCpGwPTkC9qt40XI2uP+eVlnGyCT9Wk4IGnxz1dKnDAFVrexG2BrfEh9EnGkBZOI5olPaZzn2KvRwcLN23aJDyA1b0zTKv8xsAgX0RAxDBEYsQEdMn76hGL4mLa3ef0boSbIVfijFNL39CAWq41TsSqlrxdJeS/8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767757227; c=relaxed/simple;
	bh=kH7mtdtCbvLNJd6LVOB/JdBSoJ0rpDnazuCGt/8CVSo=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=sYZ9gaI50wrHy9F7Wgo0ipuV7RwirNIFhmFsKCU/cLAOTjG8lz1b8qj9PagARBegocJFYH4J41WxKLfFKm+jIG6uxuCaDNYegY23pjxt9E627bEFJFRmetPrMFXh2GHg+hZAtUYsGuowJZxQ1rUsx8TZk0QguaLEUNutfmu1fAU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Ks5bjbU8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Ks5bjbU8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D15AFC4CEF7;
	Wed,  7 Jan 2026 03:40:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1767757227;
	bh=kH7mtdtCbvLNJd6LVOB/JdBSoJ0rpDnazuCGt/8CVSo=;
	h=From:To:Cc:Subject:Date:From;
	b=Ks5bjbU8nBgd2GdBKgZ0zbt+t54q8uisHIvVZCggpnvN5Zr2GfiG1/Eq43iJIEI+7
	 1gOdlwIH3apj/VsKxfFbQSwCYOBdVx3kilcbTilgDcGLFCm/HmOGVrkbrw8MB7+/ln
	 Oq2Wf9IoXlJDDOvEyM5FN8TmtiTmR5aFN/bjhrrH/K3tG8Ll6N1t0gpllpxvgKBKSV
	 QZZlpppLa3bZYe1b2+4vMLQLkiQWAxnpg3xgAFniSz5PyerG0/STPRP3AXleSi2Dzc
	 AmyQlhV957uUDiaEjDzamHDMjwhtMVy5nb4/T3Zy6gU/WnMKcCnFQI2OALeQv30rs5
	 LQY/0lCpglmHw==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	Ard Biesheuvel <ardb@kernel.org>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH] MAINTAINERS: add test vector generation scripts to "CRYPTO LIBRARY"
Date: Tue,  6 Jan 2026 19:39:48 -0800
Message-ID: <20260107033948.29368-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.52.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The scripts in scripts/crypto/ are used to generate files in
lib/crypto/, so they should be included in "CRYPTO LIBRARY".

Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---

This patch is targeting libcrypto-fixes

 MAINTAINERS | 1 +
 1 file changed, 1 insertion(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 765ad2daa218..87d97df65959 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -6703,10 +6703,11 @@ M:	Ard Biesheuvel <ardb@kernel.org>
 L:	linux-crypto@vger.kernel.org
 S:	Maintained
 T:	git https://git.kernel.org/pub/scm/linux/kernel/git/ebiggers/linux.git libcrypto-next
 T:	git https://git.kernel.org/pub/scm/linux/kernel/git/ebiggers/linux.git libcrypto-fixes
 F:	lib/crypto/
+F:	scripts/crypto/
 
 CRYPTO SPEED TEST COMPARE
 M:	Wang Jinchao <wangjinchao@xfusion.com>
 L:	linux-crypto@vger.kernel.org
 S:	Maintained

base-commit: 9ace4753a5202b02191d54e9fdf7f9e3d02b85eb
-- 
2.52.0

