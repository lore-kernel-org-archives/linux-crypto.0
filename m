Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A859A1DF25D;
	Wed,  6 Nov 2024 12:10:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730895026; cv=none; b=CTUqouwrAQTJnK9LkyjjfCqZToeQyNRlM7n9rLYQwch7oUKAlFZblfAad6lKRi9ueUfaaFLBT1Flc2Wc74cDzTJ2uksnFCapIOR8KVHlTkIGLxqBU5ype86T7g1y1h7dDYT1HpcCJU/rIc6MN+izF9/7CkzjkjMb2Y0XadmZS1Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730895026; c=relaxed/simple;
	bh=aW2xwDVdp7frKIFfXC7YyDMLsPfx5p8hyx6ZkoQG7D8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OIp0d1sSTKi83iqpfjrp9Yt4yidWHOApkVVWtyziY929FNBtjL8NCD724z3o59bkbANYSTPM+//La8uZQlREJIBLKdCdQBBejs7KpzOwdDjJ2Lj0wB+1zBSB7D0vv4hGnpjG0DZxhIjyETwdPl5UrWTUtFw2jXOOHPuUH+im5vo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=pLpXnFk/; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=hNLG7Mek; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=pLpXnFk/; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=hNLG7Mek; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="pLpXnFk/";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="hNLG7Mek";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="pLpXnFk/";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="hNLG7Mek"
Received: from kitsune.suse.cz (unknown [10.100.12.127])
	by smtp-out1.suse.de (Postfix) with ESMTP id B212D21CB9;
	Wed,  6 Nov 2024 12:10:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1730895022; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=8ohwiTc+yZhDyRvRbtXG6pJM+owozZa197xSwSi956s=;
	b=pLpXnFk/ycD+ULfoIakRcKlvXI5oUXDANOX4VJs3LOyoEWXt2wCuNjXLXwEs0fYddQUEcm
	kVFqrE/cm1N4XnPWdKHxXzbUFmdSxItvKEx8psbvDrxsug35o0yPtAw+o2X2MAdu1mQGuL
	3or5unDeqOGozBmIXbB0W4o4x3WxAFw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1730895022;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=8ohwiTc+yZhDyRvRbtXG6pJM+owozZa197xSwSi956s=;
	b=hNLG7MekLxD2oSy9GQ81JHS6Syztv0ET2URzJ2oIrG4qJ9W8/DIHAItGY+v0gWuZ2CsF8Y
	IP/1fWptmtgTdGBg==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1730895022; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=8ohwiTc+yZhDyRvRbtXG6pJM+owozZa197xSwSi956s=;
	b=pLpXnFk/ycD+ULfoIakRcKlvXI5oUXDANOX4VJs3LOyoEWXt2wCuNjXLXwEs0fYddQUEcm
	kVFqrE/cm1N4XnPWdKHxXzbUFmdSxItvKEx8psbvDrxsug35o0yPtAw+o2X2MAdu1mQGuL
	3or5unDeqOGozBmIXbB0W4o4x3WxAFw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1730895022;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=8ohwiTc+yZhDyRvRbtXG6pJM+owozZa197xSwSi956s=;
	b=hNLG7MekLxD2oSy9GQ81JHS6Syztv0ET2URzJ2oIrG4qJ9W8/DIHAItGY+v0gWuZ2CsF8Y
	IP/1fWptmtgTdGBg==
From: Michal Suchanek <msuchanek@suse.de>
To: linuxppc-dev@lists.ozlabs.org
Cc: Michal Suchanek <msuchanek@suse.de>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Nicholas Piggin <npiggin@gmail.com>,
	Christophe Leroy <christophe.leroy@csgroup.eu>,
	Naveen N Rao <naveen@kernel.org>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Danny Tsen <dtsen@linux.ibm.com>,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Nicolai Stange <nstange@suse.com>
Subject: [PATCH] aes-gcm-p10: Use the correct bit to test for P10
Date: Wed,  6 Nov 2024 13:09:33 +0100
Message-ID: <20241106121019.25629-1-msuchanek@suse.de>
X-Mailer: git-send-email 2.46.1
In-Reply-To: <20240923133040.4630-3-dtsen@linux.ibm.com>
References: <20240923133040.4630-3-dtsen@linux.ibm.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Score: -2.80
X-Spamd-Result: default: False [-2.80 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_MISSING_CHARSET(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	RCPT_COUNT_TWELVE(0.00)[13];
	RCVD_COUNT_ZERO(0.00)[0];
	ARC_NA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	FROM_HAS_DN(0.00)[];
	FREEMAIL_CC(0.00)[suse.de,gondor.apana.org.au,davemloft.net,ellerman.id.au,gmail.com,csgroup.eu,kernel.org,linux.ibm.com,vger.kernel.org,suse.com];
	TO_DN_SOME(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:email,suse.de:mid,suse.de:email];
	FREEMAIL_ENVRCPT(0.00)[gmail.com]
X-Spam-Flag: NO
X-Spam-Level: 

A hwcap feature bit is passed to cpu_has_feature, resulting in testing
for CPU_FTR_MMCRA instead of the 3.1 platform revision.

Fixes: c954b252dee9 ("crypto: powerpc/p10-aes-gcm - Register modules as SIMD")
Reported-by: Nicolai Stange <nstange@suse.com>
Signed-off-by: Michal Suchanek <msuchanek@suse.de>
---
 arch/powerpc/crypto/aes-gcm-p10-glue.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/powerpc/crypto/aes-gcm-p10-glue.c b/arch/powerpc/crypto/aes-gcm-p10-glue.c
index e52629334cf8..1f8b67775658 100644
--- a/arch/powerpc/crypto/aes-gcm-p10-glue.c
+++ b/arch/powerpc/crypto/aes-gcm-p10-glue.c
@@ -414,7 +414,7 @@ static int __init p10_init(void)
 {
 	int ret;
 
-	if (!cpu_has_feature(PPC_FEATURE2_ARCH_3_1))
+	if (!cpu_has_feature(CPU_FTR_ARCH_31))
 		return 0;
 
 	ret = simd_register_aeads_compat(gcm_aes_algs,
-- 
2.46.1

