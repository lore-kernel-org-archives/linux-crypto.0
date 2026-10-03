Received: from mail-dy1-f176.google.com (mail-dy1-f176.google.com [74.125.82.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A212C344DAA
	for <linux-crypto@vger.kernel.org>; Sat,  3 Oct 2026 06:08:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791007718; cv=none; b=nYfa+kxdlFbyCN0X3W/cihPYwplGmXyrJWXfO3qUrBoMJHU4NaCA1jpflysmLd9atQtggA0CL3HGxEHw7Z4v5j6Rh2uCwS/MZiwM6bUrgqoTXfXvFuT6Xa34auNz1AV5YveNh7Z7ob8ZlWjF/Ui3hN0EFEn6cmnUX6RRc18yRfU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791007718; c=relaxed/simple;
	bh=Bq6MIY7CYCGN5YFO83plBrLT0wDS2LRD2/45NbCikMY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=QNm0tCRFz6A+DgfG0sBzHviU7VMXpq99WgIMkHCKpwv6T7DclBKGrP14ogduaUY8pDBT+4j9llact2cgAyzfBHBLoqEgy0BVaVIoKq3l5BGDkdrtSrGmQn7ZkQUj5+DlHhTl86OWgWu/zqFKmdPwN2hWS8MBKQNAd24pZQAErQs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ONiK2IVN; arc=none smtp.client-ip=74.125.82.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ONiK2IVN"
Received: by mail-dy1-f176.google.com with SMTP id 5a478bee46e88-34ca2d54925so350097eec.0
        for <linux-crypto@vger.kernel.org>; Fri, 02 Oct 2026 23:08:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791007716; x=1791612516; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=xvPvgzZ7iYnqitO0H1oFllRNtu+MflvF26mLCrcp718=;
        b=ONiK2IVNxf4hQGT6f3SZK54c9rAUF9yxU5YImJzhjRu0o8L3BR7qKqmSqd9+CrKfaL
         9JdIS/Dv72cephy8A7J9qD/BibBIvhcV+DqCHJQcVlt7q2Gv9RSO/OLoCBR0nZEsWppl
         eiifKI0uTUxJO4ypazFqVgwi4fTHRb3721E3uxpzEvLouIE59qRFNBtiQ2iTy7P1FLQm
         bNSbBLKKRwrH30MzfEqoCBEDTOWXnripJk7mdguTdZIo5XadVo6Gh0KXEVDovmDbJfAH
         qoi2wBvWlHL8f2kH7scN9diOmrdywlPZOKGB7Wm7l3red86L9OyEwguELm8wV/MzMXkB
         KtcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791007716; x=1791612516;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=xvPvgzZ7iYnqitO0H1oFllRNtu+MflvF26mLCrcp718=;
        b=CW4oSvimjiNyAA3uKCJHgIKQJ6prBp232k0WTIVc9k5Bfr0NNPEos5W+Qjpdkz8AAr
         iT0ev0Hul7Oh42/1ZMWmdERWFCU3kJc6BhnrxtstOpPvrjARPknpE6KYqy9fHWshekbJ
         7jmTy7ycf+FYtO+HDfOZwkPCNGNOgcK8omwOJFMqTdbjf0TsqgtdqWYM9FMdOsm8nXFQ
         byZO19USlr3S2q9UqZcVkneQkxOqQF35ZX6ZcFRe394AThkNLC/8gPqx8TJ2WxPzKe6I
         QAhPmPuMmB5pC31ChNxPrj/jaJ9Hxk18o0qGBx+6yDs0twG9bR6kQ+SmM5PBlB/Q3Vpy
         CTcw==
X-Forwarded-Encrypted: i=1; AKwUvBwM1sbQ1hMojcG8ixHXFjJb04u6NphRVitwG0i+OJFQGbelrghn7rBeSxQkZTy5wLu7bZ5/enQvmW8PRmQ=@vger.kernel.org
X-Gm-Message-State: AFq9FYJVB3MRKUwqRD5EWKPZ/+7ZKzyT66wxbX99JkUipKkSQWH6Sp0f
	BY/ZWlr0O2TUAo/rhwkr8dPstSQt3JJ/pPa8+HmRlLBpySzLGUcxlFIQXyCScw==
X-Gm-Gg: AYBFou2Ciwvjyr3qI4a1yRihtBPiA3UhmlJmXP8vRTLhT6p2eq5u8vrRIYK7uLoBpLX
	iWQ3g3y+DmuO2SEMVDwgCBGaY+5WYBR1b8EreBwNKw2HH0sA3otQigaa3Z9TV3n/NIdPWyc6EV0
	f2jm19KtmV9j2l/Jsa9fDzNSecLl0xCvvvVaGLv8KblsYRPeZrS/qqMcPAshwrwYrerOBVRQ4wB
	Tf6uX0fT1j2U2XXhJOnqygZNPkXhErmWwmEC3yCoJXI1I0Q8EyPfSzgSu0ndnt0VaOc+lFf0Fcu
	0Jv2KFeHxmQ2AcVbrjx9Jk7KckWHfgWmo/tHK3xXR+X4WUA6QRVdCARvZCezqMn5+Y0lFCfNi2E
	MnkHAR4327bOVtR0R4ll266Vje/OrzEtPyd5Mfu+NMfpt0vwr3TLrxPOnLtyyKVkDftr5LNamtC
	TADRBLnkDZr5OmPGn+Yw9AJnzWy31n8flRtC/6OcmJ8UynQA7OUEEE1ZnpcpDOEFteWXv4CHkGJ
	8CPQty4waZYaz/n9rk=
X-Received: by 2002:a05:7300:550a:b0:351:fff:6cc0 with SMTP id 5a478bee46e88-351114114b8mr2562425eec.17.1791007715633;
        Fri, 02 Oct 2026 23:08:35 -0700 (PDT)
Received: from kernel ([103.219.206.69])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-34f067301b5sm12313344eec.1.2026.10.02.23.08.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 02 Oct 2026 23:08:35 -0700 (PDT)
From: Mohamad Raizudeen <raizudeen.kerneldev@gmail.com>
To: ebiggers@kernel.org,
	ardb@kernel.org
Cc: Jason@zx2c4.com,
	skhan@linuxfoundation.org,
	me@brighamcampbell.com,
	jkoolstra@xs4all.nl,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Mohamad Raizudeen <raizudeen.kerneldev@gmail.com>,
	stable@vger.kernel.org
Subject: [PATCH] crypto: chacha20poly1305 - Fix missing state zeroization in xchacha decrypt
Date: Sat,  3 Oct 2026 11:38:26 +0530
Message-ID: <20261003060826.7792-1-raizudeen.kerneldev@gmail.com>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The `__chacha20poly1305_decrypt` function does not zeroize the chacha
state, unlike its encrypt counterpart. The regular
`chacha20poly1305_decrypt` function handles this by manually calling
chacha_zeroize_state(). However, `xchacha20poly1305_decrypt` returns
the result directly without clearing the state.

This leaves the derived chacha20 subkey on the stack after the function
returns. Fix this by storing the return value, calling
chacha_zeroize_state() and then returning the result, matching the
logic in `chacha20poly1305_decrypt`.

Fixes: ed20078b7e333 ("crypto: chacha20poly1305 - import construction and selftest from Zinc")
Cc: stable@vger.kernel.org
Signed-off-by: Mohamad Raizudeen <raizudeen.kerneldev@gmail.com>
---
 lib/crypto/chacha20poly1305.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/lib/crypto/chacha20poly1305.c b/lib/crypto/chacha20poly1305.c
index ea42a28f4ff7..03b14d272520 100644
--- a/lib/crypto/chacha20poly1305.c
+++ b/lib/crypto/chacha20poly1305.c
@@ -199,10 +199,13 @@ bool xchacha20poly1305_decrypt(u8 *dst, const u8 *src, const size_t src_len,
 			       const u8 key[at_least CHACHA20POLY1305_KEY_SIZE])
 {
 	struct chacha_state chacha_state;
+	bool ret;
 
 	xchacha_init(&chacha_state, key, nonce);
-	return __chacha20poly1305_decrypt(dst, src, src_len, ad, ad_len,
+	ret = __chacha20poly1305_decrypt(dst, src, src_len, ad, ad_len,
 					  &chacha_state);
+	chacha_zeroize_state(&chacha_state);
+	return ret;
 }
 EXPORT_SYMBOL(xchacha20poly1305_decrypt);
 
-- 
2.53.0

