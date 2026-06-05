Received: from mail.nessuent.net (mail.nessuent.net [188.245.177.90])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 531EC2472B6;
	Fri,  5 Jun 2026 11:24:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=188.245.177.90
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780658651; cv=none; b=CkjSIo7fS8gtM/Hm5PITXB7PNqSZHAd7evezbdvOulnOA/kqIjMKiNzZKaIBO0CJMDDiQrPggcVDGGvAZpZohm0rOAG1g4wl02wOwi8Uz/6cy/J9iHkwC/NR1Vf4R1LLYEoRHKDgAxPywrscBF3bfHaLRtcNP7WirpT2nfIhQTQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780658651; c=relaxed/simple;
	bh=owQMsK+ubqH3All+RDAsOY8hpezoTCJc8xkI9nDoFxc=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:To:Cc; b=KEWPBRk6m3CthPGTx7Nq9gv9/cPYXPUsSemn8CHCNshPeT2z7LKOo15CyCTwU248RYnMGwUhYiGFvFroIcDoY4jndQs7iHo+2ndRjzZ8qMm3VkNMy/wahfAUeoVP8uwkWnPuXS6iA02d4vkrskWqgztMEQvUNhU04Uqw8YvQ4XQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=pitsidianak.is; spf=pass smtp.mailfrom=pitsidianak.is; dkim=pass (4096-bit key) header.d=pitsidianak.is header.i=@pitsidianak.is header.b=KsLHVpQB; arc=none smtp.client-ip=188.245.177.90
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=pitsidianak.is
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=pitsidianak.is
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=pitsidianak.is header.i=@pitsidianak.is header.b="KsLHVpQB"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=pitsidianak.is;
	s=mailSelector; t=1780658647;
	bh=owQMsK+ubqH3All+RDAsOY8hpezoTCJc8xkI9nDoFxc=;
	h=From:Date:Subject:To:Cc:From:Subject;
	b=KsLHVpQB1SMxTznenU+9SZV1BVFBnvTQxJLKmyaSxoCOZgOra+MlOk3BK3cuO4jrY
	 DPeYrGGO8S7SmoAN1oe5AyVH8ecEl8sxk6MI0OSHD9qPpYB+PF5MM3f4osjiXgWdG9
	 b2eY3VJDVidU/uVr+DsXV63Aj+w12B/3coqGetp05qXKmMdwDwcQSMf+oLMGlHXf1A
	 oh89uXlAeBYvAy3Qhaee282hpt66crnCSJJBQCO369WB51ri1Vip7a/GoMEcH+h0t/
	 BzMHYQ5iF7i6IB7Vdsa6aM6vlgHku/H4U5pHdE/E4yMZVkRFA5kyOnEZe4FwpQzO6p
	 SaT1jN7vEKa05jFwxjcK5fL8/vRfu1ZgfHPfnBRvdwqj9mBf4gNio6wsX5p9MbFLy/
	 PpI4cm8y9gS4N448EloIZ/3lsQJTNINfyHhoMvrFIGWkJZXVMOjkoNeQimNvqyKpf5
	 /r/BPaTnjVdigE+iwjhxrPGS3/BhhQk4sfelDsWkxLxe8zBmXrI3psGaG7sFVSUD+R
	 sg35Xt8XP4mXTpo80zpFmeTL9pkvyGltEdi2b411lM/ZzsOdcUz4JN/3D3WoUF3qg2
	 8UDluf22njfIhkgFk9D1JhbJbLI2AZ6+FAvChhImIkisPZKpuajBBUn3eJbdtKsuDu
	 d3PKdWn2lDgzJC6jmiph1NxY=
From: Manos Pitsidianakis <manos@pitsidianak.is>
Date: Fri, 05 Jun 2026 14:23:51 +0300
Subject: [PATCH v2] hw_random/core: fix rng list on registration error
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260605-hw_random_registration_rng_list-v2-1-d98b8ccbe16e@pitsidianak.is>
X-B4-Tracking: v=1; b=H4sIAMaxImoC/42NUQ6CMBBEr0L22xraUDB+eQ9DmkJX2Kgt2RLUE
 O7uygn8fJOZNytkZMIM52IFxoUypShgDgX0o48DKgrCYEpTl9ZYNb4c+xjS0zEOlGf2s0wcx8E
 9BFVTW92Zpmvq/gRimRhv9N4frq3wKKXEn/1w0b/0f/eilVaIujfaBltV4TLRnCmQj/5+pAztt
 m1fiH/YC9MAAAA=
X-Change-ID: 20260525-hw_random_registration_rng_list-7651b27b76c8
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org, 
 Manos Pitsidianakis <manos@pitsidianak.is>
X-Developer-Signature: v=1; a=openpgp-sha256; l=1584; i=manos@pitsidianak.is;
 h=from:subject:message-id; bh=owQMsK+ubqH3All+RDAsOY8hpezoTCJc8xkI9nDoFxc=;
 b=LS0tLS1CRUdJTiBQR1AgTUVTU0FHRS0tLS0tCgpvd0VCYlFLUy9aQU5Bd0FLQVhjcHgzQi9mZ
 25RQWNzbVlnQnFJckhWN2krb1oxWWR4OURaUTI5ZDY4cXpSQUdhCi9Gc2x3RzBFaEpUV05rZTc1
 Z1NKQWpNRUFBRUtBQjBXSVFUTVhCdE9SS0JXODRkd0hSQjNLY2R3ZjM0SjBBVUMKYWlLeDFRQUt
 DUkIzS2Nkd2YzNEowTnM5RC80K2FJSWR0Q2tPV2RZeHIwaExBZTlsQkRjUGVOcXBoVnlYUEo5UA
 pUMGJ4SzgvaFg0UGN3b3hRalhxSVJvdWxOYktZUjN0VXNTWTA5QkY5UTk3UVl3Um5YbWlaSVU0R
 EE0T1dEZ0tXCkk2QjA5eHRNSXAzSDFJL1QrVkNicUxaUGpaWFZrTWh2TkZoVDEzdWVEREluaVlG
 ODhmZUZwVUcwc3FEdFEyclYKOVdPNXRsbFZzMzhqWm9vbFd1K01PNnNXZFI0RWFRQXMzM1pTcjh
 1MmZWMXVZcnZNd0dBRHRTaEp5YjA3MVM1bQpIRFJpcFNVZ1l4dDhOVytaNyszRFRXWmp4ejY3L3
 BBNjV3OVg3TDFOTHFxRUozK1lCeVNpY3hLY2h3Mllkcng4ClE1UjMrU2MwSEZWSXRrRU9oS2Z1M
 2V4YnFDWE5MV083L0NzdGkyUTRLQ2t3elBuNlZWMHRmL0NpTDR2S3BqUTcKcy9oY0NyV1dqcFZ5
 bkVIdXg0VVp5RU5UNS9vNUFKbUJmejRhQnFPVXpOL3cyVTNjL3FhOW4rZmwzc01Qc1Z2QwpJbjM
 yOUNoeGZHYmtMdWR2MUZURXpjT1YvNWFBeEY2ZkVRclZ5emZ4UlZOTW55RkpFYWtvb1IzQUFkWF
 Z6N2xICjVnZ0FJZnlwN291V3JHRExub015NENVbFBPUDlpYUNFaEJrbnh5NHd3QS9GcllVK1IzZ
 zM0RmFibmFWenV6ZWMKcm41UHJHcktzL1FqZkZrRlEzUDNFUklOTW1yOEN5RnBiS3RPcWl5dDZB
 SDJmMkE2Rk8wd1BvcFI1OG9LNjNoYQpuY3ZGemUyYm81RkRiQzRZMGxCbllSQU9vUGJrWTI5MGx
 zZ1IrcUwyaC9XTExiQzcrL0Z3MmhGQkRvRjd0bVFmCllnSkJ2UT09Cj16a3VPCi0tLS0tRU5EIF
 BHUCBNRVNTQUdFLS0tLS0K
X-Developer-Key: i=manos@pitsidianak.is; a=openpgp;
 fpr=7C721DF9DB3CC7182311C0BF68BC211D47B421E1

hwrng_register(rng) does the following:

1. Checks if rng has name and read methods set
2. Checks if the name already exists
3. Adds rng to global rng_list
4. May try to set rng to current_rng

If step 4 fails, it returns an error. However, it does not remove the
rng from rng_list, causing a dangling reference which can result in
use-after-free if the caller frees rng, since registration failed.

Add a list_del_init() cleanup step.

Fixes: 2bbb6983887f ("hwrng: use rng source with best quality")
Signed-off-by: Manos Pitsidianakis <manos@pitsidianak.is>
---
Changes in v2:
- Add Fixes: trailer
- Link to v1: https://lore.kernel.org/r/20260525-hw_random_registration_rng_list-v1-1-ee1c215d544d@pitsidianak.is
---
 drivers/char/hw_random/core.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/char/hw_random/core.c b/drivers/char/hw_random/core.c
index aba92d777f72604861b644469032c8f443f1ed50..3015b863412ee17c734eb4ce2feebe78f5049d89 100644
--- a/drivers/char/hw_random/core.c
+++ b/drivers/char/hw_random/core.c
@@ -604,11 +604,13 @@ int hwrng_register(struct hwrng *rng)
 			 */
 			err = set_current_rng(rng);
 			if (err)
-				goto out_unlock;
+				goto out_list_del;
 		}
 	}
 	mutex_unlock(&rng_mutex);
 	return 0;
+out_list_del:
+	list_del_init(&rng->list);
 out_unlock:
 	mutex_unlock(&rng_mutex);
 out:

---
base-commit: 8bc67e4db64aa72732c474b44ea8622062c903f0
change-id: 20260525-hw_random_registration_rng_list-7651b27b76c8

Best regards,
-- 
Manos Pitsidianakis <manos@pitsidianak.is>

