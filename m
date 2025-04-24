Received: from fhigh-b4-smtp.messagingengine.com (fhigh-b4-smtp.messagingengine.com [202.12.124.155])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 086CA1FF1B5
	for <linux-crypto@vger.kernel.org>; Thu, 24 Apr 2025 20:20:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=202.12.124.155
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745526031; cv=none; b=B2fgCjYeJ09V4x/QomoMWwv8zq9w5poAjiEzIPnOvYt6aq/Q5/Xr+YKVSYBowASemJkVH2LCNy03KJkAU0HG4Bq9fsbaJ3TQ7mH+obbMwxm5mgk4ydI2HeUKxZEd7kxlzkNYxr8MnreQahP2K69YoM8XBkiP5jk4AYcLRKOFDW0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745526031; c=relaxed/simple;
	bh=NP5X5w5mD3/8bQOl2pBv24MgK+MLbdZvnm4Pz44y4Cg=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=dDrNk9j1Y74qcgZO9ch1wmJ5x0eHpHE9/nJTayJN9uj/exOmnUFmNvsv4jjsb+ad5QN8Cb1hF4Xk/xEOLeu6VonUs6fx/VhMI1m2w2nL+GWC5TKsL7AUct2Meo0lpdSYpblR5ToB48hoSWEf04loQj5tMCEfiGV614Be3EXJWCc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=queasysnail.net; spf=pass smtp.mailfrom=queasysnail.net; dkim=pass (2048-bit key) header.d=queasysnail.net header.i=@queasysnail.net header.b=rI857/Cb; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=GA6poD30; arc=none smtp.client-ip=202.12.124.155
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=queasysnail.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=queasysnail.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=queasysnail.net header.i=@queasysnail.net header.b="rI857/Cb";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="GA6poD30"
Received: from phl-compute-06.internal (phl-compute-06.phl.internal [10.202.2.46])
	by mailfhigh.stl.internal (Postfix) with ESMTP id C86752540224;
	Thu, 24 Apr 2025 16:20:26 -0400 (EDT)
Received: from phl-mailfrontend-01 ([10.202.2.162])
  by phl-compute-06.internal (MEProxy); Thu, 24 Apr 2025 16:20:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=queasysnail.net;
	 h=cc:cc:content-transfer-encoding:content-type:date:date:from
	:from:in-reply-to:message-id:mime-version:reply-to:subject
	:subject:to:to; s=fm1; t=1745526026; x=1745612426; bh=N3qCFQIi8M
	D9xQN8/hDXKmOWIYkFEcMsNlWWztyi05s=; b=rI857/Cb2rN0PE5WPnzV5AnjX5
	zcquJytNT2iSbCy/93TGBJOWEQ8kW7LWPJFAqp8t2I7cEt3g5E2h8Z0fJ5wVU69a
	qMEGdW3oxJQS66alhToGl2FQX5W+vfyGwomdfHNZQ0d1JFZE0In8huMJkyU1C8GN
	gbdvbqj5loIOFCEWBZ2fFRxCt+XJPzfrplkFiY8xXot6i63yW1uRc6fekGGITT4J
	TOmbT1xY/qBOZF3zfUiMo5IjI30aSJU79Fnxd2635K1gUPUIh/TezBaZndvHIBR5
	/nItG8gxAFY10kT5pXkkFZtJR43bCrZCVDQpO14FvIwt8emCO3D2N7+7KR9A==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:message-id:mime-version:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=
	1745526026; x=1745612426; bh=N3qCFQIi8MD9xQN8/hDXKmOWIYkFEcMsNlW
	Wztyi05s=; b=GA6poD308enndFz9c0jiXYy6kyx/DHAZ60fQluGvv8KTjLfnnsH
	bw6jKGEAJvvUAwcWI+DntFwCtyi5wTWTgvykHU9HulIDHSZjOwYWN/hwEg3JIMQ4
	nkXtIHzZe4s1dI5Lu23wRoYPrcMSeRrh7i2AmUiJqMWXdUkQ4+HaSM3LeKCx0fSj
	gCyzJboVh2xr0j8UMM2g0/kclitO9Bf/SkE76sBNwRk5do6UZ/IHKb9rxxYE+rQe
	aMhjO1WHxQfXaiVw16VCvyG1LJO1tabfiXZBHBjAD+V4lOvO6JPuPg0Az6snLUf7
	015tyr+Pj0342C2T4WawKp2QTQrKevyWEHQ==
X-ME-Sender: <xms:CZ0KaGb6EJZWLsJw0AdH5tGJlFa9hEpOGXueDBfyrYStv00Bqw-AiA>
    <xme:CZ0KaJZdMLhkj3hoE1UIIdeMC4hqJYX8ytfWuy6xn-Qa2N3v_tTwxx5aSAvmDJ5X8
    nqgV4OrsHxiRAAtAlI>
X-ME-Received: <xmr:CZ0KaA_1VDKtx2YHX8h0TKaR748qZyAwVt6SqyteppW2UYOgJWnuAAEVUqJB>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefvddrtddtgddvhedtgeduucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdggtfgfnhhsuhgsshgtrhhisggv
    pdfurfetoffkrfgpnffqhgenuceurghilhhouhhtmecufedttdenucesvcftvggtihhpih
    gvnhhtshculddquddttddmnecujfgurhephffvvefufffkofgggfestdekredtredttden
    ucfhrhhomhepufgrsghrihhnrgcuffhusghrohgtrgcuoehsugesqhhuvggrshihshhnrg
    hilhdrnhgvtheqnecuggftrfgrthhtvghrnhepjedtuefgffekjeefheekieeivdejhedv
    udffveefteeuffehgeettedvhfffveffnecuvehluhhsthgvrhfuihiivgeptdenucfrrg
    hrrghmpehmrghilhhfrhhomhepshgusehquhgvrghshihsnhgrihhlrdhnvghtpdhnsggp
    rhgtphhtthhopeegpdhmohguvgepshhmthhpohhuthdprhgtphhtthhopehlihhnuhigqd
    gtrhihphhtohesvhhgvghrrdhkvghrnhgvlhdrohhrghdprhgtphhtthhopehsugesqhhu
    vggrshihshhnrghilhdrnhgvthdprhgtphhtthhopehhvghrsggvrhhtsehgohhnughorh
    drrghprghnrgdrohhrghdrrghupdhrtghpthhtoheprghruggssehkvghrnhgvlhdrohhr
    gh
X-ME-Proxy: <xmx:CZ0KaIo9D_MtCXePF5DI6CEM4luXAqnsUX_vVMWLVJuetkyICTg8aQ>
    <xmx:CZ0KaBr0QtJQJKJ3vNnuhJl4KsPjrPPbORzzNjrHifjxvYNVGUVDjw>
    <xmx:CZ0KaGTnr8KyokMMAlgBUmWiFl_c-FXV0obV6DPt0hGPR873rHEpJQ>
    <xmx:CZ0KaBrvlmlgu79b9wtNOorrbJAgZCqgn2Etk0kbnFDiHhg1CEqELA>
    <xmx:Cp0KaEImW8Jt-cMSfDBHFbyFJAfwhrsivZbSyH9IxN8QuNoMrxz6AuiN>
Feedback-ID: i934648bf:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 24 Apr 2025 16:20:25 -0400 (EDT)
From: Sabrina Dubroca <sd@queasysnail.net>
To: linux-crypto@vger.kernel.org
Cc: Sabrina Dubroca <sd@queasysnail.net>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Ard Biesheuvel <ardb@kernel.org>
Subject: [PATCH] crypto: scompress - increment scomp_scratch_users when already allocated
Date: Thu, 24 Apr 2025 22:15:50 +0200
Message-ID: <71f7715ffb4a29837335779c92ba842a4b862dda.1745507687.git.sd@queasysnail.net>
X-Mailer: git-send-email 2.49.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Commit ddd0a42671c0 only increments scomp_scratch_users when it was 0,
causing a panic when using ipcomp:

    Oops: general protection fault, probably for non-canonical address 0xdffffc0000000000: 0000 [#1] SMP KASAN NOPTI
    KASAN: null-ptr-deref in range [0x0000000000000000-0x0000000000000007]
    CPU: 1 UID: 0 PID: 619 Comm: ping Tainted: G                 N  6.15.0-rc3-net-00032-ga79be02bba5c #41 PREEMPT(full)
    Tainted: [N]=TEST
    Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS Arch Linux 1.16.3-1-1 04/01/2014
    RIP: 0010:inflate_fast+0x5a2/0x1b90
    [...]
    Call Trace:
     <IRQ>
     zlib_inflate+0x2d60/0x6620
     deflate_sdecompress+0x166/0x350
     scomp_acomp_comp_decomp+0x45f/0xa10
     scomp_acomp_decompress+0x21/0x120
     acomp_do_req_chain+0x3e5/0x4e0
     ipcomp_input+0x212/0x550
     xfrm_input+0x2de2/0x72f0
    [...]
    Kernel panic - not syncing: Fatal exception in interrupt
    Kernel Offset: disabled
    ---[ end Kernel panic - not syncing: Fatal exception in interrupt ]---

Instead, let's keep the old increment, and decrement back to 0 if the
scratch allocation fails.

Fixes: ddd0a42671c0 ("crypto: scompress - Fix scratch allocation failure handling")
Signed-off-by: Sabrina Dubroca <sd@queasysnail.net>
---
 crypto/scompress.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/crypto/scompress.c b/crypto/scompress.c
index 5762fcc63b51..ca1819248c3f 100644
--- a/crypto/scompress.c
+++ b/crypto/scompress.c
@@ -163,11 +163,10 @@ static int crypto_scomp_init_tfm(struct crypto_tfm *tfm)
 		if (ret)
 			goto unlock;
 	}
-	if (!scomp_scratch_users) {
+	if (!scomp_scratch_users++) {
 		ret = crypto_scomp_alloc_scratches();
 		if (ret)
-			goto unlock;
-		scomp_scratch_users++;
+			scomp_scratch_users--;
 	}
 unlock:
 	mutex_unlock(&scomp_lock);
-- 
2.49.0

