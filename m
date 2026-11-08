Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794181380;
	b=Xn0vVP7I5+x63gzwfKeoc1T9DBbapzj1FZZki4LsJFbZz/7Fu6bk28Bp9gAQxQ15uKKB
	 p03sCyqr8t7sB3W0Qk20keWzQYa0WoffxhoSfJ+DE4f9drlNRQqcYyHGGS1ssensqSjSu
	 sMgbCFPypntJiMF9D6PaVkWbf8O10b1B4+86aF7en7RgMdM0l1JHmaxLN2/kYDFdj/wy4
	 DdbUmV1lz+oeYV71wWA1rVyfvrpFrOju6F3BywMgdcX9y455nm7HvdL498PiBjbNVVAJP
	 bEeYqltAN8wRjgXhXDSTlKE1eF8pt70e9wvuK8NtyoXWaGnN6YzvByIBa98gVdBtyuw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794181380;
	h=Received:DKIM-Signature:Received:From:Date:Subject:MIME-Version:
	 Content-Type:Message-Id:X-B4-Tracking:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=opqy2dA7s0XteS99ezevufI2qSC2s/Ry0FAQ5nqTeqE=;
	b=DgJ/e1Hw7Jj6OCUkciONVo7ltjjN3INgJZM8jsHekJTGXCUtPH99H2tvk6NehDpjSMa2
	 Cx0lBXgXaGzZTWSjKAWSSwYMLdfeBDvYDvlvHuDGKVsfyxBZZPTpfMnyI8X7kFIelfnnT
	 XBs1tysguFmyG+P7xtorQwfC2C7DyTGE5nvU8onR/FuoDGTuBucVjO3VIyRdjfFYbi27z
	 TZ7MG967UWGYe4QkoHP3mHeU2oguF4LWUhwQLfvhN6kdJP8zJO0MweAgLZkgfgoTb1kyi
	 Gkwm0lThAOjcLn6BxbN0zkcK4WPwOUMTppiM6BrOK2qRCtzQL96rOqs0aAhgNXijsXQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=DEVvfpFq;
	arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D52E3606A31C;
	Sun,  8 Nov 2026 23:42:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=DEVvfpFq
Authentication-Results: smtp.kernel.org; arc=none smtp.remote-ip=100.80.115.77
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1794181379;
	b=MOQ4AbK8V/yPLffbmri5g8+7In+Pss3Cm+vmzKtVJ42Ar7gAvDI/ihBq4umIxJax9XPY
	 wLuOj/0RkwPKW/z7k3B+lBUjIjQ/XvcBz0cN+Qzm+ncTc9PoP5vOxa5zYLxzpyUFqCdT3
	 xVpeys1YfYy6wczuz8nwEBDff3VNiSIjkjGj1b1qonjVadMW7nDfGYeHp7taBcHFkPCxs
	 GFSqflsMIDfAWDxLbP+G/UgIqzgDnncyCY0jHwAye4L9rFVD7ckGQeNDTLcVa5Ur2sBFX
	 mh1BeQV7pTCjDJrYGXGmUMQsYzxPKmDVfuhyBe8f3qCfBuAB/mDl1G9I4u6neWxqm/Q==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1794181379;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Message-Id:X-B4-Tracking:To:Cc:X-Mailer:X-Developer-Signature:
	 X-Developer-Key:X-Endpoint-Received:X-Original-From:Reply-To:
	 Content-Transfer-Encoding;
	bh=opqy2dA7s0XteS99ezevufI2qSC2s/Ry0FAQ5nqTeqE=;
	b=0Kp2+6gPRUgzjQCSL6x/v/FUwSxfzOqyoSrDxRU9lTGaDVHlC/R/kIEaYf68e6S/5nYt
	 yn8Y3EJDoVptdUNUsRCYysTR4me0/cINjEqSlvDaUbaNflZDtUEvnbXDfS2LoJkXD5T/Q
	 AT5cLwTF9bMZi9BKGXkg16RQV7X0ENvcbiYSg+nJmAFI+mojYLQ0xIOcrE3nHECLnBLie
	 +B8sKyVpwXd7qsSILNirEOrkwQgE4zrx8f0IkPEk1tMhTGd0RvXWq01+StazM5fDKHJsK
	 BsD8xl0n4iFPRi4XycjzIWoYSPprG4u6xAGVyD5/hlVTlCxYYWTLsnwtPAT1yo7VUfg==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id ACFF31F0089F;
	Sun,  8 Nov 2026 23:42:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794181379;
	bh=opqy2dA7s0XteS99ezevufI2qSC2s/Ry0FAQ5nqTeqE=;
	h=From:Date:Subject:To:Cc:Reply-To;
	b=DEVvfpFqQEmAPTfamJyLOgrBAkvk4GYGAaEBffroiizTE8ebhrN9sILzj+MO72ifY
	 7z20XOvFR6F/ub+sREaAQllA8SijwsnR4mz28LedVDWTGy1M0AzVWYoI7rEAZEa5SM
	 +Q72c5/fELEQRmUJMK5LRtyfbifFgI+0Dsmok8jxyZEeG7R6cDTdczw6STk9iZQNCr
	 S+xmdXRa/w6MKsR8gqK4px+E4kA7e4OrbHGFdsG3g5XTAzO5Y0aWf1gKiJRNAaBDpB
	 KVvkeMLaNw9RKw0dlFmb1sP7826TAjVRvXd0Hy59aiSXYlW8lgFtz4xtOvCSPPdOyX
	 S9MPLrDafwj/w==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id 0C35348181;
	Sun,  8 Nov 2026 23:42:58 +0000 (UTC)
From: Vincent Jardin via B4 Relay <devnull+vjardin.free.fr@kernel.org>
Date: Mon, 09 Nov 2026 00:42:54 +0100
Subject: [PATCH RFC] crypto: caam - never share the gcm and skcipher
 descriptors serially
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Message-Id: <20261109-for-upstream-caam-shdsc-share-never-v1-v1-1-65a1dd146db2@free.fr>
X-B4-Tracking: v=1; b=H4sIAP0I8WoC/x2NsQoCMRAFf+XY2oUk4im2gh9gKxYhefG2MHfsa
 hCO+3eDzcA0MysZVGB0HlZSNDGZaxe/GyhNsT7BkrtTcGH03p24zMqfxd6K+OIUO2zKljqjgis
 alJtnjOVYDnAxhz312KIo8v2P7nS7XuixbT+z/oCIfQAAAA==
To: =?utf-8?q?Horia_Geant=C4=83?= <horia.geanta@nxp.com>, 
 Pankaj Gupta <pankaj.gupta@nxp.com>, 
 Sahil Malhotra <sahil.malhotra@nxp.com>, 
 Herbert Xu <herbert@gondor.apana.org.au>, 
 "David S. Miller" <davem@davemloft.net>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org, 
 Vincent Jardin <vjardin@free.fr>
X-Mailer: b4 0.13.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1794181377; l=2652;
 i=vjardin@free.fr; s=20260525; h=from:subject:message-id;
 bh=GjgJFHU6i0RDErS9t9bCe4m/vvJ6D6x0VQ3z3zcG9iA=;
 b=fPogTEoHycur6tnNhWpxrxlaar2/uhPjtIH747LHL7Aord5CzukTNCgAotCO74RcK1cmyuAVH
 SAHlGW8k7vED9aFiXbxAxzF/uXFjuZzk1+4rYLGtEuSZfDd87qsEi+q
X-Developer-Key: i=vjardin@free.fr; a=ed25519;
 pk=hppgLeFpGpKOi7LNwGEZ4jOYofJCoGd4Jf1ltAabiLw=
X-Endpoint-Received: by B4 Relay for vjardin@free.fr/20260525 with
 auth_id=871
X-Original-From: Vincent Jardin <vjardin@free.fr>
Reply-To: vjardin@free.fr
Content-Transfer-Encoding: 7bit

From: Vincent Jardin <vjardin@free.fr>

The gcm and skcipher shared descriptors were built with HDR_SHARE_SERIAL,
so the SEC runs the jobs of one key one after the other:
it leads to about 4 Gbps per key on LX2160A, whatever the number of
CPUs or queues. No hardware reason for this code has been found.

From benchmarks, when built with HDR_SHARE_NEVER, the performance
is much better and scales: for instance with one CPU, AES-128-GCM,
the gains are:
  - 325 -> 592 MB/s at 1420 B
  - 498 -> 6283 MB/s at 16 KiB

Signed-off-by: Vincent Jardin <vjardin@free.fr>
---
 drivers/crypto/caam/caamalg_desc.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/crypto/caam/caamalg_desc.c b/drivers/crypto/caam/caamalg_desc.c
index 04c1105eb1f5..32d614a3431d 100644
--- a/drivers/crypto/caam/caamalg_desc.c
+++ b/drivers/crypto/caam/caamalg_desc.c
@@ -639,7 +639,7 @@ void cnstr_shdsc_gcm_encap(u32 * const desc, struct alginfo *cdata,
 	u32 *key_jump_cmd, *zero_payload_jump_cmd, *zero_assoc_jump_cmd1,
 	    *zero_assoc_jump_cmd2;
 
-	init_sh_desc(desc, HDR_SHARE_SERIAL);
+	init_sh_desc(desc, HDR_SHARE_NEVER);
 
 	/* skip key loading if they are loaded due to sharing */
 	key_jump_cmd = append_jump(desc, JUMP_JSL | JUMP_TEST_ALL |
@@ -765,7 +765,7 @@ void cnstr_shdsc_gcm_decap(u32 * const desc, struct alginfo *cdata,
 {
 	u32 *key_jump_cmd, *zero_payload_jump_cmd, *zero_assoc_jump_cmd1;
 
-	init_sh_desc(desc, HDR_SHARE_SERIAL);
+	init_sh_desc(desc, HDR_SHARE_NEVER);
 
 	/* skip key loading if they are loaded due to sharing */
 	key_jump_cmd = append_jump(desc, JUMP_JSL |
@@ -1463,7 +1463,7 @@ void cnstr_shdsc_skcipher_encap(u32 * const desc, struct alginfo *cdata,
 	bool is_chacha20 = ((cdata->algtype & OP_ALG_ALGSEL_MASK) ==
 			    OP_ALG_ALGSEL_CHACHA20);
 
-	init_sh_desc(desc, HDR_SHARE_SERIAL | HDR_SAVECTX);
+	init_sh_desc(desc, HDR_SHARE_NEVER | HDR_SAVECTX);
 	/* Skip if already shared */
 	key_jump_cmd = append_jump(desc, JUMP_JSL | JUMP_TEST_ALL |
 				   JUMP_COND_SHRD);
@@ -1539,7 +1539,7 @@ void cnstr_shdsc_skcipher_decap(u32 * const desc, struct alginfo *cdata,
 	bool is_chacha20 = ((cdata->algtype & OP_ALG_ALGSEL_MASK) ==
 			    OP_ALG_ALGSEL_CHACHA20);
 
-	init_sh_desc(desc, HDR_SHARE_SERIAL | HDR_SAVECTX);
+	init_sh_desc(desc, HDR_SHARE_NEVER | HDR_SAVECTX);
 	/* Skip if already shared */
 	key_jump_cmd = append_jump(desc, JUMP_JSL | JUMP_TEST_ALL |
 				   JUMP_COND_SHRD);

---
base-commit: 82e91fe19fb838f235f7c8829afc1eb389c93bdf
change-id: 20261108-for-upstream-caam-shdsc-share-never-v1-e6f7f5e0ad23

Best regards,
-- 
Vincent Jardin <vjardin@free.fr>


