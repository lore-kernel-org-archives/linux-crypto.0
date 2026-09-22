Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48A1947F2C6;
	Tue, 22 Sep 2026 18:11:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790100711; cv=none; b=W/zviPeVzno/3eN7SutOYZOvgW0ocmRcnwHdMgf2xdEPMDE3oAd6S+DdtYccbB61iL8vlN48tysP4MgyUgPxaYzm88D2HGK8aT8k09hMEidrR8amtNRfxxcFBJBgJd/JR33QggBBOL7vo961i1ZKEyyuk7Eyvx9Dj1Kb0blTc4k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790100711; c=relaxed/simple;
	bh=dR6FCo+L/QkWk3dKyErZP2vzU3uNhD6loPTSwdYvDbM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=fX4ZDNaIyoBRKz9RDkFqrgFal7MH8qAlczL4d6NGNzkO1adqNFiiGBexWKl7p20Pn8SZQEsd+xwnpID1Mzg43hrx01p3R5Y0LpohGAim4vd39uuVvH6PPq0fnKqF/4tlmoMzU3zMH2ghO4oSYY3lRLA8jNchquVAoDTdFYXfCqA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=CxEuc4z9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CxEuc4z9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4CC481F000FF;
	Tue, 22 Sep 2026 18:11:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790100709;
	bh=x9rRjorTTQ1NG8iXQLdD0SXMgi5+L77Za3fVFjVv25U=;
	h=From:To:Cc:Subject:Date;
	b=CxEuc4z9Kf7Ty64z41xnHnYUUSDYyHxAJC3yIkv3GP/H/3rS7mpVcbnQmrJ06g9Cx
	 DwH6briJBcKoQrHJIEFvZeKPciBcTNBvv3k43ECvkb0PxEtqgU+fjCKUXw/f4ZrNCB
	 275qAx2s85TmU2aO3MWTJTLZwi4GKC2fOcZsUDzGP3hfcF8xeIOyatrZKX2G4xs/sD
	 jXDtd/ISxXPIzrRUfPr9DzC25otfRWFe4bQu+Gr6yyvr4FgumNNCqE/reDyCGTTGK8
	 4qujWCIX/vlTVZSWLsQP37Ov5A1JoIg0qC5QRzQpi7VutZZ978BYHx20UFgu0IBukt
	 unwEs9gAoge7Q==
From: Thorsten Blum <blum@kernel.org>
To: Olivia Mackall <olivia@selenic.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Kees Cook <kees@kernel.org>,
	Michael Buesch <mb@bu3sch.de>,
	Andrew Morton <akpm@osdl.org>,
	Jan Beulich <jbeulich@novell.com>,
	Greg Kroah-Hartman <gregkh@suse.de>,
	Chris Wright <chrisw@sous-sol.org>
Cc: Thorsten Blum <blum@kernel.org>,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] hwrng: intel - return -ENOMEM when ioremap() fails
Date: Tue, 22 Sep 2026 20:11:01 +0200
Message-ID: <20260922181102.67309-3-blum@kernel.org>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=788; i=blum@kernel.org; h=from:subject; bh=dR6FCo+L/QkWk3dKyErZP2vzU3uNhD6loPTSwdYvDbM=; b=owGbwMvMwCUWt7pQ4caZUj3G02pJDFmbjmxTOZKmnO5ixX/JbELAPvXMFSfX9/PHrjLxqFGxt X4+63t+RwkLgxgXg6yYIsuDWT9m+JbWVG4yidgJM4eVCWQIAxenAEzk8RuG//ExOd4toRWd6cmM HeLKrMGrH5b9itZgWrdf02XGm2caWgw/Jp+T/Z/0XWm1d4lphENk+9vNggK6MuEvGVU+Cu2RO8A MAA==
X-Developer-Key: i=blum@kernel.org; a=openpgp; fpr=1D60735E8AEF3BE473B69D84733678FD8DFEEAD4
Content-Transfer-Encoding: 8bit

intel_init_hw_struct() incorrectly returns -EBUSY when ioremap() fails.
Return -ENOMEM instead.

Fixes: 641dd002d207 ("[PATCH] fix Intel RNG detection")
Signed-off-by: Thorsten Blum <blum@kernel.org>
---
 drivers/char/hw_random/intel-rng.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/char/hw_random/intel-rng.c b/drivers/char/hw_random/intel-rng.c
index d24e747203c1..a4dd21a9de98 100644
--- a/drivers/char/hw_random/intel-rng.c
+++ b/drivers/char/hw_random/intel-rng.c
@@ -318,8 +318,8 @@ PFX "RNG, try using the 'no_fwh_detect' option.\n";
 	}
 
 	intel_rng_hw->mem = ioremap(INTEL_FWH_ADDR, INTEL_FWH_ADDR_LEN);
-	if (intel_rng_hw->mem == NULL)
-		return -EBUSY;
+	if (!intel_rng_hw->mem)
+		return -ENOMEM;
 
 	return 0;
 }
