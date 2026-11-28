Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.216.43
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795840862;
	b=xgGdgi0Y6JteX93keCOzaUQ4NE+idRXJsDnxPsbqzlU5s8/gCUlOjHBH3bUuM9ILgo8G
	 8LWHlA7SYnsG3HTTXnSC/KtBSU8mmGBmiezXhszu5EuWHuGo8Cn72JzrjYxplrQSM9oG+
	 22/mjqviuxcZY70b8HA72HG2H8tteAM0aKyp3QWbx904ToW8E+oqDNw+PTYEhs2yTWMW1
	 HUIs/hxqoCn+SRyUaSTG+45Flhw1Y9elt2fpQ2Mbz1vUvZlZvrB45zyWqJpuggfxCr1vE
	 BOrURMZz1g/usZcdSa8rnRO3NueS/LXwlIJ5JExENPHjsOXzQIgIj4+7zpbb8/NhISw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795840862;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=G1zg7oDnPMMLPkGbaldczgRDAJIrfK55owtXYdnhz5Y=;
	b=cKebdjXh5TdeDaRqChPw6EN+ySwrlQLb/SmaXGgP5Bp+WG3YZ5vRv2NEHj3bLcvOM72F
	 3g450LmFTVeSyomk8fnjb6IgyGcK6TGDU5DDNnQefXRgzbv9QDIlA3RadEkKDQikmNCty
	 3cwx9rlKh8mbmXnBdnj6q0CcbLVzms/tNMM0Zo1GStb5T21UYAxEQMuRKa5bps3VAp9tV
	 JtzonQs8nFLq0EeGOHtduOirKrwZFif+u68QZOzQmTpFfwe92rKH1JmN0wUPxrMHw/Dcs
	 QN8b0K1kJ5MZXjGW+QUUo1bvGAB2vAT2jLVw4blg3s8g4FikOWsp4fV9SC4APZESqdg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=GxlrDgtb;
	arc=none smtp.remote-ip=209.85.216.43
Received: from mail-pj1-f43.google.com (mail-pj1-f43.google.com [209.85.216.43])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 239B3606A31C
	for <linux-crypto@vger.kernel.org>; Sat, 28 Nov 2026 04:41:02 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 239B3606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=GxlrDgtb
Received: by mail-pj1-f43.google.com with SMTP id 98e67ed59e1d1-3b3e85baf7cso5054217a91.0
        for <linux-crypto@vger.kernel.org>; Fri, 27 Nov 2026 20:41:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795840861; x=1796445661; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=G1zg7oDnPMMLPkGbaldczgRDAJIrfK55owtXYdnhz5Y=;
        b=GxlrDgtb14O81jpISTbcaVBRGDgmTfQsDcs1AaRKdxWl7mp/t7TLGt7vVQRIfVryDk
         aPHHldiBeXC6T/JVb0pHAARynaGMetwoyzWzEXZ1BuFYCKs3Xan+aKA/RIby3K6fvjtT
         RxN4X65YbR2fXqgmopcRoMmmJ1dNrNF2P3S4pzbqWLmWU95G8NCP5aQhLOTtPOEIT+mi
         wWSG65nBFxK6zWgQVxU1pnFrH74Az1KvVFPap34dAzD2ifcOElqkowyBZsGgMXa0nE3h
         VS6KBERQyFY29ztrAEKECdQCl+1RHVNeuS8o8F2KvwuVYR4gWRGqbvj+yWu5OTkhIsKP
         JuAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795840861; x=1796445661;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=G1zg7oDnPMMLPkGbaldczgRDAJIrfK55owtXYdnhz5Y=;
        b=uSG0KsjQOzF/pcBjFQrIITsVEUhc70lwUWQb4/jEVnvluLjOd1P2la17IxU+hfH4g0
         36UObjYpDUtu1RCSPxutAtTk3qZzPb5YQNBGN730YhGXi9mcHju51qsJGs69XRpizKSD
         rIcXU+MgPpEeoAh3Hpt1yEDgOJ9hGQD5nlQ1EcLVER4w/fvu1r5GD7xkYAwQivmY/f4W
         p8uhXg6nswoonpmtlNRt/qa0uSN1MCmldJlCkfDPBCkdz0R6LPF9nssmQHVrMZPl1Rg4
         wR7QvSKCdYyjYZAPGzagDCDWEU8pCFVmtv1jaczC5Q3qO7/aHKdDxWvxmPz8U7Oj4pZD
         D2QQ==
X-Gm-Message-State: APuU4Z8O4XEi0h6GFawPfkna3+dFYBDmg0ZDciWeYVRbMVS5gxSq7WLM
	4hWYhlAmAmcyoqZKRxnwOghf9CGnTBLM4TXbFG80e5WSEozLK2DG65l4qdu8mA==
X-Gm-Gg: AZFdTZcpiwa0MS6ER9JY2g2cn0/JoANJ7Lr6GOEm3jkuDq8MwXooH93QX0n1V350W5j
	bI4p97YT6m1UlX8zhKXKApi8UKzr+vlN3DDfEte9058o+eNPkDQw5dyfjlzMi15hNGStGfiVuqE
	t4bta+cJwOL8lJKTDfWa9TgJDI8fwjXccVn9eP6nYHA7UjPAM1i7fc8YA3SXX8pPURyQy29Mryh
	Ew3XyrbcgpG85ucq+HCRb2srFhRKVgAxhVFbmcl+5cYDi96Q81DAN1lQZ4NbX+atJ7T+KpczU9o
	OXghxunB3Er04xI45sEu4awwplXISni7glXZoBbFeoTTYvE3v15l8oZFcOgVrL+IP87QPWuJWKe
	UhZH/LtMP7OYoVh3c3D8PgRFDEHvuN8pVgLmTluUNha9l/hrjhk88P9TaKR8Hqno5a/uLJmsgjh
	OToCFPbq3CPnqC1WMUQ/AfjB8TYYiYZmofIG9i7/ywvDX8EMOCbB1mVsxfimIjq3zSnzlcC4RbO
	b7TOcilT60RFK9kAq8/D+TJSJi2w/7+AxsWAkGGvsRSrVTdFUS2sEOj4/xA/suvbMaEnu0sqUls
	N3nQUu3pQZGwIR+qUvEneh/p5D5Tywi0qsDH6z2rCskX+W85euztJm7zu39rbZxBDEjXM9WtSn0
	UZE0lt/OmqW1hVYyqQmDBw1DbsT03B35kUzpOoQ37IOLQpUwiEqiyqcq+pyRPxVWdpioF/hlfaK
	9knw==
X-Received: by 2002:a17:90b:390c:b0:3a7:9e3d:b3 with SMTP id 98e67ed59e1d1-3b41c9beafamr24728083a91.66.1795840861545;
        Fri, 27 Nov 2026 20:41:01 -0800 (PST)
Received: from ryzen.lan ([2601:644:8000:37f::e34])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b41abb1b66sm42716729a91.1.2026.11.27.20.41.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 Nov 2026 20:41:01 -0800 (PST)
From: Rosen Penev <rosenp@gmail.com>
To: linux-crypto@vger.kernel.org,
	Herbert Xu <herbert@gondor.apana.org.au>
Cc: Srujana Challa <schalla@marvell.com>,
	Bharat Bhushan <bbhushan2@marvell.com>,
	"David S. Miller" <davem@davemloft.net>,
	Rosen Penev <rosenp@gmail.com>,
	Arnaud Ebalard <arno@natisbad.org>,
	Boris Brezillon <bbrezillon@kernel.org>,
	Russell King <rmk+kernel@arm.linux.org.uk>,
	Romain Perier <romain.perier@free-electrons.com>,
	stable@vger.kernel.org
Subject: [PATCH 6/8] crypto: cesa - put the non-TDMA hash padding behind the data
Date: Fri, 27 Nov 2026 20:40:48 -0800
Message-ID: <20261128044050.722617-7-rosenp@gmail.com>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261128044050.722617-1-rosenp@gmail.com>
References: <20261128044050.722617-1-rosenp@gmail.com>
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

Commit e62291c1d9f4 ("crypto: marvell/cesa - Fix sparse warnings")
changed mv_cesa_ahash_std_step() to build the hash padding in the cache
and copy it to SRAM, instead of building it in place right behind the
data. The length is advanced before the copy, so the padding lands one
padding length too far, and the engine hashes as many bytes of stale
SRAM in its place.

Copy the padding first, then account for it.

Fixes: e62291c1d9f4 ("crypto: marvell/cesa - Fix sparse warnings")
Cc: stable@vger.kernel.org
Signed-off-by: Rosen Penev <rosenp@gmail.com>
---
 drivers/crypto/marvell/cesa/hash.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/marvell/cesa/hash.c b/drivers/crypto/marvell/cesa/hash.c
index f6894ed7c1cc..6fcd78427b71 100644
--- a/drivers/crypto/marvell/cesa/hash.c
+++ b/drivers/crypto/marvell/cesa/hash.c
@@ -253,7 +253,6 @@ static void mv_cesa_ahash_std_step(struct ahash_request *req)
 						      new_cache_ptr);
 			} else {
 				i = mv_cesa_ahash_pad_req(creq, creq->cache);
-				len += i;
 				if (engine->pool)
 					memcpy(engine->sram_pool + len +
 					       CESA_SA_DATA_SRAM_OFFSET,
@@ -262,6 +261,7 @@ static void mv_cesa_ahash_std_step(struct ahash_request *req)
 					memcpy_toio(engine->sram + len +
 						    CESA_SA_DATA_SRAM_OFFSET,
 						    creq->cache, i);
+				len += i;
 			}
 
 			if (frag_mode == CESA_SA_DESC_CFG_LAST_FRAG)
-- 
2.56.1

