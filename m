Received: from out203-205-221-242.mail.qq.com (out203-205-221-242.mail.qq.com [203.205.221.242])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B0EC146A72;
	Sat,  9 Aug 2025 10:05:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.205.221.242
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754733910; cv=none; b=HTYpn0UHEdReDJ9wjvug4m4i6ao9/o80QyOwImI/7y9HJm9LuRRnvQpoEdDLGIZZONX3Q3c0V/rtGh8DEe2s38eS1PjEi+pJbPO6Q4TNXfhTCjgtgb7V+WMjZhmy6nER5lNb23Jpr20Zk99CMbu8BI4chTjN0rwBxRaDDOpb4JA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754733910; c=relaxed/simple;
	bh=lVNZ6Vs+ZMKKXx3J6Dt8FT9hY4HAY8MLWksoD2tTOyc=;
	h=Message-ID:From:To:Cc:Subject:Date:In-Reply-To:References:
	 MIME-Version; b=XR1PrbYmQrfzyO859uFcd3dIpOy9flVvTJnyfgr853Y/f4YL06mebhu3WTkSUF3nfPC6lUfQ2ly+GXin5GhwZlYefaZfLIU1816NY7daKWOZCo7AUSIrel6Nn0iPcQ/E9ZkK4Im0xE2DnodJiIiSv80Iq5p6CjGwEJdmRGcqx6w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=qq.com; spf=pass smtp.mailfrom=qq.com; dkim=pass (1024-bit key) header.d=qq.com header.i=@qq.com header.b=SSE1jwF8; arc=none smtp.client-ip=203.205.221.242
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=qq.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=qq.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=qq.com header.i=@qq.com header.b="SSE1jwF8"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qq.com; s=s201512;
	t=1754733592; bh=DKmkljtQB7ro0+vyMCwEguJAv66dTk4iG4899l3s0Hk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SSE1jwF8KMOM2lDmI1YxfLGGaZz0loe6UXyS5+LmKFo9/Ojzs0KkCdXlR3271eIGN
	 LtIhnVsaT8QaWBBsrDGVGrFnl5mLPdJdhr/Q2ygtCvlrdXO7Bvv4VTeaCP5AizeW+l
	 ZYVB4RfSu99orLrKp/ZZbaJFMsnjlluzKTfmA13M=
Received: from pek-lxu-l1.corp.ad.wrs.com ([111.198.231.14])
	by newxmesmtplogicsvrszb16-1.qq.com (NewEsmtp) with SMTP
	id EF2BB6B8; Sat, 09 Aug 2025 17:59:50 +0800
X-QQ-mid: xmsmtpt1754733590tuxu8ia6i
Message-ID: <tencent_B406618996EEF22ED6CC8EA7DF46FD92D206@qq.com>
X-QQ-XMAILINFO: Nq1uWKlIb9DMQ2GdnJ6K2hM4AFeSO37h50FFuFrT75jNbtFnBYc6FpF0W1e1vg
	 PrCTGKPDOx3GqJ/cVM8LtZK1AsEEhbTs5UCXF0l1OBQUPKHr2jo7CHG2NQlntLcjzeAes93MJ78u
	 kqmKFSD8SfVrRFaz0EwQwlBPcBJXZFh22LRhJ67ZUiLS0gtk8rlY95qjeHiMeheDr8jOGnv+knVW
	 L9ZPfB0c2WWvlHL5/VYAmxJ4CgQ51jnL5sIRmgbzQ6jBU7+r8S3PhqB9nDtwvMmNcPfkeIiwuRDn
	 9VK4Pp6W/qbdw6VyGQoH4XlfGBQWGWOUntpnZrJ3514ILthisC0vhZX6axH4VaHRPvOs0FtExgZ1
	 J9dke9Sl5WPdYbPP/e8wLNvWCDIAXruhDlCVLlv2IE75F7oIFdPCGKLNIekOfOFjZ9bZnrMGW7La
	 +WrU9OAbQdFrKaVyLHwu7nQUd6xlNoX/Tces3gCQGhGnVHiofQ8Vc+UlzVTpKfSHoYiWCgm25wTA
	 IcbTG9q/P+s7N+S9F9wrUS6wsLmMs47TcK/mW00BBfIHoe85NpJVxrJ1dQ9VwslLAp+ahyUvbTt8
	 qxn/zKa1HOyeYTCbjdex9MiBJeol3IyC8hsFnC2wisW1LY45ul7+JC7uZx5nDWpkbJ7+9iIFcRj1
	 GPo74O1ixPkLCFDU79UJKU2xKbYdT5xNoyG4fkR+ijBojdsgNvn/a3kJjHxFi9pWQhNyQ2kVzKIC
	 6ss5PL/GZR1qeYS7kIFICoiAq+MRbZcLE/JNnCDJCRCJvQ4RHXnWyD6Ci/aV50L9WofNRDwLJXRA
	 Bpn2I059PgpBNlNdnV7y/6Wn+nbArATixGUE+yz4crleJ4QotStesgoQMYauOwhIabFuhcqdhUKK
	 CIRAQNts1ZaDEj3jafTWXnPUREk6t4hcTa2HwKZXDv/PzUAWJYUA7ORve8KPsANY7QZpe7Ph9niA
	 Xw+ZmpLGRSA0ry7tEOZ63FM3SNp7Mg
X-QQ-XMRINFO: Mp0Kj//9VHAxr69bL5MkOOs=
From: Edward Adam Davis <eadavis@qq.com>
To: syzbot+e8bcd7ee3db6cb5cb875@syzkaller.appspotmail.com
Cc: davem@davemloft.net,
	herbert@gondor.apana.org.au,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	syzkaller-bugs@googlegroups.com
Subject: [PATCH] crypto: Prevent kernel-infoleak in rng_recvmsg
Date: Sat,  9 Aug 2025 17:59:43 +0800
X-OQ-MSGID: <20250809095942.310397-2-eadavis@qq.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <6895b041.050a0220.7f033.0058.GAE@google.com>
References: <6895b041.050a0220.7f033.0058.GAE@google.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Initialize the intermediary array member to 0 to prevent the kernel from
leaking uninitialized data to user space.

Reported-by: syzbot+e8bcd7ee3db6cb5cb875@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=e8bcd7ee3db6cb5cb875
Tested-by: syzbot+e8bcd7ee3db6cb5cb875@syzkaller.appspotmail.com
Signed-off-by: Edward Adam Davis <eadavis@qq.com>
---
 crypto/jitterentropy-kcapi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/crypto/jitterentropy-kcapi.c b/crypto/jitterentropy-kcapi.c
index c24d4ff2b4a8..9e9e069f55af 100644
--- a/crypto/jitterentropy-kcapi.c
+++ b/crypto/jitterentropy-kcapi.c
@@ -107,7 +107,7 @@ int jent_hash_time(void *hash_state, __u64 time, u8 *addtl,
 {
 	struct shash_desc *hash_state_desc = (struct shash_desc *)hash_state;
 	SHASH_DESC_ON_STACK(desc, hash_state_desc->tfm);
-	u8 intermediary[SHA3_256_DIGEST_SIZE];
+	u8 intermediary[SHA3_256_DIGEST_SIZE] = { 0 };
 	__u64 j = 0;
 	int ret;
 
-- 
2.43.0

