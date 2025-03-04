Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D20B1F4168
	for <linux-crypto@vger.kernel.org>; Tue,  4 Mar 2025 12:47:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741092434; cv=none; b=hRaavEnWuiENZPpaLUFRYVRpfDWw2mXmM70R6Yk0YlZ8dQ39sH1XgIe6dvAEoTDaCZrFzZkAeGzX1Mb5CgSW6+93zoGzAAvMXRBTW6fGGuoZzheUL+gjrxusozG7v0AhzkDmMDJ/i7nnA9MXSP23SuW2SerM5y91FYYxc2YI5Ww=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741092434; c=relaxed/simple;
	bh=ErhgQClLYZeW777Cfg1S+MjPfgTOaig3pW5nhvGLGxc=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=M7LqngQ1dK3soyFAMtWTU1DwiCJyR5isLjdDc4/GFyXcVkHniCTqLVrz+BPR4U29w1ASOGVSLzZexIIG+0k5kgzJ2D2xdN3jSD+Mmn0ajqmP4hxHBhxyPlv4b/NlXrVSa4puy/4pCZCdenW5BB77Ou7y6q8uwstibZAsTdviLhs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=Qz7SmdlT; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=Qz7SmdlT; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="Qz7SmdlT";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="Qz7SmdlT"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 306B21F393;
	Tue,  4 Mar 2025 12:47:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1741092430; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=JH6fHSlYvmwz91Y2uwvaZTyrBFuPhL2lwni0hhoA3Vg=;
	b=Qz7SmdlTiLlMIB6/z1i89zASe8MqEdtDar+shkrKTMOKHOtTDXe+2lO/BmPm1cfUCjERPR
	xg6S1lZZPSINFadUZrimNLNofeSpbjeTD2mlV/uHveZRNUc9E2L1SmVEU0BeJAWcRrBaG1
	9md95k5XS3rcxeWz4Xo3DRcay/XTuvA=
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1741092430; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=JH6fHSlYvmwz91Y2uwvaZTyrBFuPhL2lwni0hhoA3Vg=;
	b=Qz7SmdlTiLlMIB6/z1i89zASe8MqEdtDar+shkrKTMOKHOtTDXe+2lO/BmPm1cfUCjERPR
	xg6S1lZZPSINFadUZrimNLNofeSpbjeTD2mlV/uHveZRNUc9E2L1SmVEU0BeJAWcRrBaG1
	9md95k5XS3rcxeWz4Xo3DRcay/XTuvA=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 2858D1393C;
	Tue,  4 Mar 2025 12:47:10 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id z1bTCU72xme+EAAAD6G6ig
	(envelope-from <dsterba@suse.com>); Tue, 04 Mar 2025 12:47:10 +0000
From: David Sterba <dsterba@suse.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: David Sterba <dsterba@suse.com>,
	linux-kernel@vger.kernel.org,
	linux-crypto@vger.kernel.org,
	Nick Terrell <terrelln@fb.com>
Subject: [PATCH] MAINTAINERS: add myself to co-maintain ZSTD
Date: Tue,  4 Mar 2025 13:46:58 +0100
Message-ID: <20250304124700.24574-1-dsterba@suse.com>
X-Mailer: git-send-email 2.47.1
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Level: 
X-Spamd-Result: default: False [-2.80 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_MISSING_CHARSET(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MIME_TRACE(0.00)[0:+];
	TO_DN_SOME(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	ARC_NA(0.00)[];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_FIVE(0.00)[5];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:email,suse.com:mid];
	RCVD_TLS_ALL(0.00)[]
X-Spam-Score: -2.80
X-Spam-Flag: NO

Recently the ZSTD tree has been removed from linux-next due to lack of
updates for last year [1]. As there are several users of ZSTD in kernel
we need to keep the code maintained and updated. I'll act as a backup to
get the ZSTD upstream to linux, Nick is OK with that [2].

[1] https://lore.kernel.org/all/20250216224200.50b9dd6a@canb.auug.org.au/
[2] https://github.com/facebook/zstd/issues/4262#issuecomment-2691527952

CC: Nick Terrell <terrelln@fb.com>
Signed-off-by: David Sterba <dsterba@suse.com>
---
 MAINTAINERS | 1 +
 1 file changed, 1 insertion(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 8e0736dc2ee0..b50c0eff3606 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -26274,6 +26274,7 @@ F:	mm/zsmalloc.c
 
 ZSTD
 M:	Nick Terrell <terrelln@fb.com>
+M:	David Sterba <dsterba@suse.com>
 S:	Maintained
 B:	https://github.com/facebook/zstd/issues
 T:	git https://github.com/terrelln/linux.git
-- 
2.47.1

