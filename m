Received: from out203-205-221-190.mail.qq.com (out203-205-221-190.mail.qq.com [203.205.221.190])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 955B51C862B;
	Sun, 17 Aug 2025 11:05:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.205.221.190
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755428736; cv=none; b=dqshMNx9z1B74asa6yAbcKyBa9Dor8VLDoduLTpLofIm4GRhWgInvYh3QR+IzvCGYjmPR2NCWBrMqgw9rV55bBvyHz48EzCmHZz+fI3gKDGNcxMkVeZxRED4HZxnQO8NCocdXy+576dEDdLy1et7oOhBRo2UK4mU7sWsEZG/RBE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755428736; c=relaxed/simple;
	bh=A+sLc0Z2QzPFdW2jsm+Jm9m+mMCPBnli1/PZvtzk2Ro=;
	h=Message-ID:From:To:Cc:Subject:Date:In-Reply-To:References:
	 MIME-Version; b=BUxiCE/h1wbkJG9HPA563iwIBa7yPREIvVVa6hpRlfONzOCIPFsD4ixbqlrQY7ejTSu6PF4qu7H9622khaQoevQztsXcCH/Yy+D2Aeuz0MW4txmHw+8TrXlpSpd7u4KdE5W7BRVgUCyaOnTYcyq9YOF8Tn69guXqPjfRIcaH+M0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=qq.com; spf=pass smtp.mailfrom=qq.com; dkim=pass (1024-bit key) header.d=qq.com header.i=@qq.com header.b=tQASYCgO; arc=none smtp.client-ip=203.205.221.190
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=qq.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=qq.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=qq.com header.i=@qq.com header.b="tQASYCgO"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qq.com; s=s201512;
	t=1755428730; bh=S+OOyZCkxFA0z+ofS7rk1Y077krAVqkdrfirLeMW+Bg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tQASYCgOcPDR3cwn5cUg7L2s1WgbyJT7s/5p2SJWnTa/9cWfAwvkg103opW49EJdY
	 T4TZeafgBzhKUK4+6dSw2JdHE/KN+rNWAVt+1C/XvOhYW7lf6CKgeQwklORCy8FNpR
	 NYSol6ZuOJirxgYQGHZBrNVq0FCHhWXu9EeiU8JM=
Received: from pek-lxu-l1.corp.ad.wrs.com ([111.198.230.220])
	by newxmesmtplogicsvrszb20-0.qq.com (NewEsmtp) with SMTP
	id ECE30023; Sun, 17 Aug 2025 18:59:14 +0800
X-QQ-mid: xmsmtpt1755428354tmhsx2fzl
Message-ID: <tencent_73E16EBC9654E89EECD6CEC4786A6C4C2D0A@qq.com>
X-QQ-XMAILINFO: NNoVXaH09J176/5h/iQ0jfRyMU9mwW6gLwkUzPyz6XJX+pr5Mjr6Lne0PenVWH
	 9aEqtFfUu4WEkuC8NUfIWSePcgZodkzia8eOXrcscy2ymwskoRDcWkGAng/rO0y3WR5T9x/Jn/tg
	 ArnMVZCft2y/9xCfCEpr9pz/X6yJmNESR8UAw9G2sevyd4uTdn+pV7jsz2x+pQ3Mshk3jxk/He7b
	 x35cihDSc1ouxYJFs2XtRkmBoMeL5YYCYBhVCFxbeGP/UW+nxBF8PhBTRo+RMtgqtS5DXKRsR4xq
	 svUlM0bjAX2FoftZPTgOLsjv7kpymNwRs+ge/EMY0ppcy15XxqllSe8Bw7CzjxeNeWSn2bItxWLa
	 xHSFpWUeoBr5g6ImOiVmFwpbyQswhzoiFq1Et/Om4xTt4eGBv5EyrUHx6L7dSY2I4sjooZiaDmUk
	 ps4bT/PZPI20F6GhOjmhwAjgbtjt19/WslKfE+SJZ0AZd4zDAYXZq+laPC8exwkH72xGI3tdMB3E
	 BHr5p9qyEf46e8L3hkKxudoI4W0wJDw8qQZS6JvYOQji5p6Dtr8G2pHmuEA2Cv9dETRW0AbKHyTm
	 gAWoSl+59YnUoFaTZr82Xcp/auV1UxkZJVLufjkfXAOpxcUfqIkrlHSVP0T+HFV7SC6GWvg8+S+r
	 EBkrHK/LL/wqWP+9puV7Q9BLalkb3zo/tpQ66nl/kugbVQNyb2jr4GN6mbA1v9WyppSn6wuz/Dzp
	 g7kYNoyl80YzOvyHl7+qWSAg/nH673udlQjdtmcaeJpqfUxk11FfCzeolLlK6iYyQXAdTkkieibd
	 h0POGLM07jJj6HI3Vk09dFhLOPMTUA/IgvtS5oPGCoy5OOputqJeMwbYVVy+rGet8S+SVGMBeGZ0
	 O49nrLqKiUP19+TpC8F/NDYYK9UV+Ae9E5E+YFoqi8bI8EEEDgkizUBCaOdEbNCpa07fHgMPQLNl
	 JsFEHD6xAKMqvYerfiKcxXRdYt0YBWvdn4Kn1+V14ErF78F+xNBDjvVLkvsX+a
X-QQ-XMRINFO: NyFYKkN4Ny6FSmKK/uo/jdU=
From: Edward Adam Davis <eadavis@qq.com>
To: herbert@gondor.apana.org.au
Cc: davem@davemloft.net,
	eadavis@qq.com,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	syzbot+e8bcd7ee3db6cb5cb875@syzkaller.appspotmail.com,
	syzkaller-bugs@googlegroups.com
Subject: [PATCH V2] crypto: Mark intermediary memory as clean
Date: Sun, 17 Aug 2025 18:59:15 +0800
X-OQ-MSGID: <20250817105914.245810-2-eadavis@qq.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <aKGYHwT31OaGzc5Z@gondor.apana.org.au>
References: <aKGYHwT31OaGzc5Z@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This is not a leak! The stack memroy is hashed and fed into the
entropy pool. We can't recover the original kernel memory from it.

Reported-by: syzbot+e8bcd7ee3db6cb5cb875@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=e8bcd7ee3db6cb5cb875
Signed-off-by: Edward Adam Davis <eadavis@qq.com>
---
V1 -> V2: mark it as unpoison

 crypto/jitterentropy-kcapi.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/crypto/jitterentropy-kcapi.c b/crypto/jitterentropy-kcapi.c
index 1266eb790708..4020a6e41b0e 100644
--- a/crypto/jitterentropy-kcapi.c
+++ b/crypto/jitterentropy-kcapi.c
@@ -117,6 +117,7 @@ int jent_hash_time(void *hash_state, __u64 time, u8 *addtl,
 		pr_warn_ratelimited("Unexpected digest size\n");
 		return -EINVAL;
 	}
+	kmsan_unpoison_memory(intermediary, SHA3_256_DIGEST_SIZE);
 
 	/*
 	 * This loop fills a buffer which is injected into the entropy pool.
-- 
2.43.0

