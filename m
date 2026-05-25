Received: from mail.nessuent.net (mail.nessuent.net [188.245.177.90])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A81043D0C0B;
	Mon, 25 May 2026 07:25:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=188.245.177.90
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779693962; cv=none; b=gQywe+d8lFdHKbODTO1DeZLS8ZHIQZeMUh3oEXJMxBNNo631X+CZdfX4hfqjzOcdMwmj9ogdsxFHWA8ztCb+zs4y+QOUnpv4iIACoO90XhxKmdFK2wC4hMW7Xzz56d1goxI1l2IinqGm6/YJTxzBXDW565Wv6Ei4elaMzu1kh8w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779693962; c=relaxed/simple;
	bh=1XKBzlq2q6IJBnFExAy9XCfZ9r8rmlTfHdfrGJ379G0=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:To:Cc; b=GkSwEjmVHNKExH8/g0nTceCPX22Bh71iXrEzPN2gFE2LCGHv+KtrF97RZss7RfoWm1PNmJIfvvS2GQYHvAWDKjAjLGp60E4dzuz6yoLttAHnSa/usc702HIHOipsHTMW/fTmIPZV3sjHw/yWc4zZurOwbkSw9mwtgVT78QjGViI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=pitsidianak.is; spf=pass smtp.mailfrom=pitsidianak.is; dkim=pass (4096-bit key) header.d=pitsidianak.is header.i=@pitsidianak.is header.b=oHFxBO1p; arc=none smtp.client-ip=188.245.177.90
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=pitsidianak.is
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=pitsidianak.is
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=pitsidianak.is header.i=@pitsidianak.is header.b="oHFxBO1p"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=pitsidianak.is;
	s=mailSelector; t=1779693951;
	bh=1XKBzlq2q6IJBnFExAy9XCfZ9r8rmlTfHdfrGJ379G0=;
	h=From:Date:Subject:To:Cc:From:Subject;
	b=oHFxBO1pLU6pvjWL5SYRZtJFf+qiIDlA5MGY1j5k6m3kJgEOisa9SE7KgHCpcm9MN
	 LR7DCvz5ULsdl6oJwZXoQPozL8yit6UtPDGcOcztq5CMwKXrd2dGgOgFuRwd4aR0fe
	 rgRYU13tRriDFrFO+nkdh8RiCyJKZGzk/hncf0nOa2e9e9aU9N9peboFrnwKWQ1Yj2
	 HXgC1DrrVauZTDJUzl6mtLy7+AU2hzC/q8JQcjQO3h+AC4MOviFtmVY2imq6hscfAr
	 8/m9Tt4f2qRnM/oRgioCpoYvsPgUYTq5uhEVirhPf8RTsXBPENFylamjksGPj9EOby
	 Mbk/3gVuad0xX7ju+JJhzEatQJ/33vRIuy5Josy+UZUFgI6eqhXgP6qxBTUhO58WJM
	 ZL/gzZyiNJfrRf9N2usqucRa+es/fiZ9T1vJOzEOhmov2+9IxLU6owEZmTCU87Guh3
	 u8YQeg18yBdRNvKc3boCWFaQa7TpyWpx3A//O+grK5q79d4fkhdwBQ84Rh+3grz/vW
	 OH/gztToWRuQdR9c3kVOjUg793wv/CMRzqoJPUlp6j8Udv4BuyVphSxEnlXqbhp6nB
	 iBRvSMBwFm1xFdZZunWHudHXBle7jjf4zHFYJns7SfmFONy1Ehm+Ow39f2N6unpfEw
	 /w1mV7XTOw37nN3IP+Q2hB8A=
From: Manos Pitsidianakis <manos@pitsidianak.is>
Date: Mon, 25 May 2026 10:25:39 +0300
Subject: [PATCH] hw_random/core: fix rng list on registration error
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260525-hw_random_registration_rng_list-v1-1-ee1c215d544d@pitsidianak.is>
X-B4-Tracking: v=1; b=H4sIAHL5E2oC/x3NQQqEMAyF4atI1ha00Fa8ikipmqkBrZIWHRDvP
 mGW3+J/74GMTJihrx5gvCjTkQRtXcG8hhRR0SIG3WjbGG3UensOaTl2zxgpFw5FEs8p+k2onDX
 tpN3k7NyBrJyMH/r+H4bxfX9rx0xicQAAAA==
X-Change-ID: 20260525-hw_random_registration_rng_list-7651b27b76c8
To: Olivia Mackall <olivia@selenic.com>, 
 Herbert Xu <herbert@gondor.apana.org.au>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org, 
 Manos Pitsidianakis <manos@pitsidianak.is>
X-Developer-Signature: v=1; a=openpgp-sha256; l=1361; i=manos@pitsidianak.is;
 h=from:subject:message-id; bh=1XKBzlq2q6IJBnFExAy9XCfZ9r8rmlTfHdfrGJ379G0=;
 b=LS0tLS1CRUdJTiBQR1AgTUVTU0FHRS0tLS0tCgpvd0VCYlFLUy9aQU5Bd0FLQVhjcHgzQi9mZ
 25RQWNzbVlnQnFFL2w4VTJxaVdaU3BnZ09XdkV0WDdaYXlhV01RClRVaEduWGZ5eXlLWGRpVEJN
 aCtKQWpNRUFBRUtBQjBXSVFUTVhCdE9SS0JXODRkd0hSQjNLY2R3ZjM0SjBBVUMKYWhQNWZBQUt
 DUkIzS2Nkd2YzNEowRnVZRC85OXhWK1FPMlRiQThkUWtYMkJ6KzlsQzNjZTl3WXM2NXZTcHBWTg
 pRcUVNRm84V21Gcncrdm9kUlpzNUdnb014SzFLWWxiSCtScm1aczUyR01RNnhlb3VQSU8wcE5WZ
 mJTcmpmL2RoCjNEcWtRVDRJZjVRVmZvckdGZFZTZEJETWtPQjBLM1pxZUNhSlRxeEdWTEU4bU1X
 U21WbkpZVnFLNW5TSXJpcXQKTE9Sb3JPWFVORGRMZzJGN2cvM2w1WG1la0M3SWt2VGcwSDJ1RFg
 5by9pU3pYZzdyRDk1MWZhc2V1NDRYMzRXSwpRdUpZSlFYU1FOSUtNeTVGMlNLMjlWaS9KSEdsWk
 NzNHpPSDZwRm4wRXpSRDgrV3VOOUFKM1pUVFIyMnM3ZXJpCjd6cFN2a0NJcXhabE9SQVAyaDhNM
 1ZMSmFET3hmVTVqczFPbk5Ub3JoZ1lzN21aN2JnZXJ5RkpxRmJDNFZvOUcKNk9Sa2U4ekg2SmFX
 SG54MTJ1b0o5TkkrRVRDU3MzVkNpdjl3MHdrblRZUHVzSnpxaVBjeVdVdFlTSVJpbFdBTApJeEd
 4TEgwRjd4Qks4UUM3d1R0N0J4YkNFeGRjak1BK1plUXpDay9SM01jcVhrOFl4OS9qNGNuWFRSZn
 ZrOTVNCmJzM0NsNHBsVXNESUkreG1uWndYcUVuN3hMdHpoVVMvWjRxd0ljM0YwZ0JJK2lLVzl4O
 U8zSGxiK3llcnJHZXoKb0N3NmtwYWJrQXBtNWRXTVlESDRwNWFmbmFpOHN0UElkS1g3ZkIvVW5P
 T0J5Z3I4MmRDVGlUTmxLNitCMzZONgoydTZ3L0h6TkpDQTJkY0JyVG5PSVNmUlF3M0I0eE5VY3d
 4YWFRQVhlTytKSE52S1NuekRDWGdzSXFvbWdJeGhzCk05V3A1UT09Cj1XR3NlCi0tLS0tRU5EIF
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

Signed-off-by: Manos Pitsidianakis <manos@pitsidianak.is>
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

