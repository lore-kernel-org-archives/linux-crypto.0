Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.222.173
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795898909;
	b=RWodFd+kbzpSqW0UL1VqbhaeRi92QfLNhU+c9QzVN1YILPPydVX9hH0GVxIdoG7WjEgq
	 TkxRnMkH3qptdIKH03FVQyuJJnp32tYwwem189pnyQdpYIq5lhT03CEjBIOYvUheWm1nT
	 EFxwTvetz88+h97dClSn+hkPJgV1Nep9XTFMp7/nOapfu4h3hWWPSYLrVF+RYkcyn7tb9
	 9ESPuoMsMQ4NRCA8M7OV0LP2g4vAWyDFUgwvXTGm8AJe7eb2Mzm/BKvQ6FpIRrC71uPoW
	 vTbbB91VDXdwf9sK1RSr5SZhrOYcSTlPE48SZhuEjTGnozJE0eZ2T7/dKDW+C/y5l+w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795898909;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=8uFkCouADvv/PwrDiLIDkEmbHzshEe6Pf7KjecclxlQ=;
	b=hrsgBpj7zjWFv0bPocVo2YE9EItgC2rAG29OgSFTBvONnSNUKxVQJtEY0R7H5sSekpWu
	 AcEp6hS19ffkLqbL8MRbtKnLAP8sU9mXbyXk3YsF1mdIyNS0tKaAm6zXArma+WUd9a29+
	 Yws2eIEsNn8Gxa3/HOFrO/RHIBKSttMpLrGMTl2+aE2aPVMcHE/bsdGATiQobSABk0EHE
	 ZFCv/zahX6Ln4qfjv013vfEsIYLn1i82ywjCGW+L4/uMSVcDY49zLPAkzz+qBj+Xy3Q7D
	 BXnKYZlfsgTdAXZXJ2XRizG8WEZiHJ1x0cYB4ovZ4frDBThprymbhBFcB3I9lxDpJfg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=t4M1pwap;
	arc=none smtp.remote-ip=209.85.222.173
Received: from mail-qk1-f173.google.com (mail-qk1-f173.google.com [209.85.222.173])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 203C2606A31C
	for <linux-crypto@vger.kernel.org>; Sat, 28 Nov 2026 20:48:28 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 203C2606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=t4M1pwap
Received: by mail-qk1-f173.google.com with SMTP id af79cd13be357-94962d80d34so523381285a.2
        for <linux-crypto@vger.kernel.org>; Sat, 28 Nov 2026 12:48:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795898908; x=1796503708; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=8uFkCouADvv/PwrDiLIDkEmbHzshEe6Pf7KjecclxlQ=;
        b=t4M1pwapxfAgUnRnEqi9OcFsZ++pOoMi6lKKIhQ6THgk24+u0bFobvMrDTHD44gQ9T
         AZSB96Oja1nxsGEBYqgjA8cr+AJZYNbPyj4PcS95ICnsi5Dh3fAKdWBvz5uSTU0smdm0
         dSZA5oeBXzSzagSzv9ZZbmsAR1kvgLfAFOEbd1AYqXqR/qMT/2vNd/nETC4TFSDNGvFQ
         M0V1sQvrix9Vi2djuXC0zQIvJQerBuU1kut0oCOltXyuSQMpk00ItnLqYYxZ103Rmj1n
         F8K08Tx/1tZ6C3h1L4Z7k/kPetdeD33PJTgzs0x+2GF9WVj7rsRia2dCg22rUyOyGiVI
         fGcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795898908; x=1796503708;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=8uFkCouADvv/PwrDiLIDkEmbHzshEe6Pf7KjecclxlQ=;
        b=25aE/ddcjvSe36vQLawcBtOKnS0TzHdIHHuRPpGgWSjsbb1EJnUkGYDBX2vl4icNHp
         Go6tVYismupa5n2Ad4HH8wD5GtZUg0A4tKuHGOhznBk0inxRJaisXvgNmzbcGgHsPpHs
         yhx3uDWAtXPkPyYYEN+K8mbZR07BDjEifKLIUnsZOCTzDo4DNu25oCkT1MWoFLoYHOc+
         A53UAaC77X9hxQTxiOrz4XdT71x7lrFlH3VpBinfOFS24eVcmppuJY0WUT9Ql9fpUaxE
         K5NkeOZoTo3IahpnHJ2ZPMVXh/+3z3KnhWTmBG90cjR5E++D3eQX9u4YK+kzYbQU/A8S
         74Kw==
X-Forwarded-Encrypted: i=1; AL+hErHWOFYSJdBLAOm5oTfKFdvgi66ae/DPIPPkMf9yVgDzlXdZrpqTgVL+noC4kWFa7hOpSOjcVFbJ40sTsZ8=@vger.kernel.org
X-Gm-Message-State: APuU4Z8w9JF9pC+asmH+cceQCRAlGPW8cuhlnR2NhE7f8H5FlL2XogGM
	mA6HOjMVdAgvUAn5Jk8KiRqRxBuRHREyjRMSdrs0PzKVVyFRUICbIV31
X-Gm-Gg: AZFdTZdpNdPjg3cm+ojkSfG79GDzRFS3RUti2GrT3ybtdYN4+wp4nhWmA+KAW9AppZm
	OhZgStF1bT226ZDdbeoAUiarpbPwTHH1pQBvidoq/mMDqbKjaovVTZ1uuAXsR/Q+dnSt+mAU+LD
	evvdimA+kOjr331UmH0pNSwRbiSYQdOU3IBCKgwENxXYd3jogMz6DIp2QLcMmljqbwNKh8Ndnj9
	XShVDPgXAWNyyWciKc0aB7bYnAwE8+FMKKgiQW0ZHsQkDOg9GD8d+Chhs3yUAldc+1tMGeXM/ji
	pedAhQm8xMisHVcjhg5b4RVRwd35J3tuALbpJ6PgXr+KdzGGDQ/aNb21BwjwqstmmvxjF3Qh3a6
	ag//GfHi9BXSS/1OMjAhdaxaOmCG7zoDL36kOxcBJXZ1memtIsR7/f0fDrLeZaYK+zfNim7tcbR
	4u+Xx49hVs8e+WR7urdMSshA8GrMPkoxN9FN7BdB+SHzIuPsVJCqDqpQt2/2sodilcWafKoXHm+
	5Rh5twPbgMkQlz7TA6hcVH2hj2pzXX1GZXOsTFeInFu96EOS8JyIUyVUSYycBOG/FCzBtozzGvJ
	M3/LASnW3E1pXGDJCjuJU7AdBFNeedyFNxhZMtT7/JDbC6gZjNEKvA430nmoz7u8khTNdLHN6XP
	xla//xni8WzgHSyN73VBtFdY4dJmHmo+4QyfJ
X-Received: by 2002:a05:620a:838a:b0:949:6f9f:34fe with SMTP id af79cd13be357-949ba9fe0acmr4910187985a.36.1795898907994;
        Sat, 28 Nov 2026 12:48:27 -0800 (PST)
Received: from BOOST-MACHINE.localdomain ([163.252.152.153])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-949bb349db3sm2129739885a.7.2026.11.28.12.48.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 28 Nov 2026 12:48:27 -0800 (PST)
From: Timur Kussainov <kusainov.timur@gmail.com>
To: Herbert Xu <herbert@gondor.apana.org.au>,
	Corentin Labbe <clabbe@baylibre.com>
Cc: "David S . Miller" <davem@davemloft.net>,
	Heiko Stuebner <heiko@sntech.de>,
	linux-crypto@vger.kernel.org,
	linux-rockchip@lists.infradead.org,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	Timur Kussainov <kusainov.timur@gmail.com>
Subject: [PATCH 2/2] crypto: rockchip - fix debugfs leak when stats are disabled
Date: Sat, 28 Nov 2026 15:47:45 -0500
Message-ID: <20261128204745.1044083-3-kusainov.timur@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261128204745.1044083-1-kusainov.timur@gmail.com>
References: <20261128204745.1044083-1-kusainov.timur@gmail.com>
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Since commit 1a15d26c3131 ("crypto: rk3288 - Use new crypto_engine_op
interface") register_debugfs() creates /sys/kernel/debug/rk3288_crypto
unconditionally, but the dentry is only stored in rocklist, and only
removed in rk_crypto_remove(), when CONFIG_CRYPTO_DEV_ROCKCHIP_DEBUG is
enabled.

With the option disabled the directory is leaked on module removal.
Reading the stale "stats" file afterwards dereferences the freed module
and oopses, and a re-probe fails to create the directory again.

Create the debugfs entries only when CONFIG_CRYPTO_DEV_ROCKCHIP_DEBUG is
enabled, as the Kconfig help text describes, and remove them
unconditionally (debugfs_remove_recursive() handles NULL).

Fixes: 1a15d26c3131 ("crypto: rk3288 - Use new crypto_engine_op interface")
Signed-off-by: Timur Kussainov <kusainov.timur@gmail.com>
---
 drivers/crypto/rockchip/rk3288_crypto.c | 19 +++++++------------
 1 file changed, 7 insertions(+), 12 deletions(-)

diff --git a/drivers/crypto/rockchip/rk3288_crypto.c b/drivers/crypto/rockchip/rk3288_crypto.c
index b2b629fff..b600ef8b0 100644
--- a/drivers/crypto/rockchip/rk3288_crypto.c
+++ b/drivers/crypto/rockchip/rk3288_crypto.c
@@ -235,18 +235,15 @@ DEFINE_SHOW_ATTRIBUTE(rk_crypto_debugfs);
 
 static void register_debugfs(struct rk_crypto_info *crypto_info)
 {
-	struct dentry *dbgfs_dir __maybe_unused;
-	struct dentry *dbgfs_stats __maybe_unused;
+	if (!IS_ENABLED(CONFIG_CRYPTO_DEV_ROCKCHIP_DEBUG))
+		return;
 
 	/* Ignore error of debugfs */
-	dbgfs_dir = debugfs_create_dir("rk3288_crypto", NULL);
-	dbgfs_stats = debugfs_create_file("stats", 0444, dbgfs_dir, &rocklist,
-					  &rk_crypto_debugfs_fops);
-
-#ifdef CONFIG_CRYPTO_DEV_ROCKCHIP_DEBUG
-	rocklist.dbgfs_dir = dbgfs_dir;
-	rocklist.dbgfs_stats = dbgfs_stats;
-#endif
+	rocklist.dbgfs_dir = debugfs_create_dir("rk3288_crypto", NULL);
+	rocklist.dbgfs_stats = debugfs_create_file("stats", 0444,
+						   rocklist.dbgfs_dir,
+						   &rocklist,
+						   &rk_crypto_debugfs_fops);
 }
 
 static int rk_crypto_register(struct rk_crypto_info *crypto_info)
@@ -420,9 +417,7 @@ static void rk_crypto_remove(struct platform_device *pdev)
 	spin_unlock_bh(&rocklist.lock);
 
 	if (!first) {
-#ifdef CONFIG_CRYPTO_DEV_ROCKCHIP_DEBUG
 		debugfs_remove_recursive(rocklist.dbgfs_dir);
-#endif
 		rk_crypto_unregister();
 	}
 	rk_crypto_pm_exit(crypto_tmp);
-- 
2.47.3

