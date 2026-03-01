Received: from mail-pf1-f182.google.com (mail-pf1-f182.google.com [209.85.210.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CF582D7812
	for <linux-crypto@vger.kernel.org>; Sun,  1 Mar 2026 12:08:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772366888; cv=none; b=KBgPsbXX3RVHASWGYV6evR94ctbsxOcWzHEz9uvSgrtdTzKR62/ujTe5BbEdo7UMHSvuk/U/TyOvc5+CLPnSz7mexjBTW4/auryt6N2PdLlfRUuqFtvXoN9/Y7/bMnpl9lNMDh/NSRLJ7WGih+IxM94XMYpaCwJypjilGvkUF2s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772366888; c=relaxed/simple;
	bh=cuvQUE2Fhntyo9wZzFh6Sr6QfYFezsxo+UdSSyYB44w=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=l8r2tjLWbixp8iEuDXv3bVGM0XYUot5+ZWdEH391XqymXRRSIGuHw2gn+x1U3n3pvxp+i9jQovuBfPYoWFP04uKDjtZYlhVkZ9mssthDttLY5zpiPVzFftxGRrgayHAmXwmjoVPVwNPhYDLx6kgyUeGDjG/KSIoJBWiDcPdgx20=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=MlgJVs6I; arc=none smtp.client-ip=209.85.210.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="MlgJVs6I"
Received: by mail-pf1-f182.google.com with SMTP id d2e1a72fcca58-82748095892so1473892b3a.0
        for <linux-crypto@vger.kernel.org>; Sun, 01 Mar 2026 04:08:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1772366887; x=1772971687; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=qG1HgotwU2avY/4uG3n4wNhHxPZiFDdyIpVyiHq5gWs=;
        b=MlgJVs6IDPPF2YdwSDQtX9E5OrdhIO/10jF7XYiAzs1e3vYUXFmi1hJHW7PDNd0WnD
         4+eHjL1v2crZ/Wsk+gugcfDXZ9DnZvyfaeKmvCKpowGjdrBtga5pcEtOLYlcf0+u0ZKG
         veBn0z4F3ou9xodTgslYxDj3v+O39neGcQ6l1+/LCIWUwrwVFWMQBrr1+8MGpKFbqR8e
         KdB7V9I+iunSl0PT6ydg5iHaPv9iN0AboEolDv7gBKlUoZLSz2g+hBoMI1EZ7OTDG5Td
         Q4l3R/ri7ZHvwQj5t5auNtTmbqVVwi7Hg8BNmTFIlYFJ8PWYUZi+FcLKUxJX6679thJP
         xniQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772366887; x=1772971687;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qG1HgotwU2avY/4uG3n4wNhHxPZiFDdyIpVyiHq5gWs=;
        b=fgxAVj5wpGsYJgTPRUdpf2YrSTKSa1EnZIHbdDWEU9wGJy4FSr4alpaKy41Q9KHka+
         IgFfPvmCzvmXJl7RBP1nZlpfoL/L/BPZDoJwxBUexDHliOYqrkziycFDYH6zgXaSwxoe
         aQ0BpaVGgaCJXKcKEjOOL5QNmVIxKSgC3rkhGjcWb2ygGd6Gh/4hJDOekMBUgKYYGH1C
         PiNLReFvV+kjlLaXG2lvBUrGY1AI9t1oeGFbKsVavGf5st4oUcYCRy9JdnsHdhUMLaZs
         Fxc/rTfAjrY942ZK19iEiw3YJWIq1ngICXDEg0jqKDJpi1tacJRG+TQxPeDx//m0v2ic
         bN3A==
X-Gm-Message-State: AOJu0YwVQfbXX/upoHG/zbfafSGuM4wkprBYKanRQRrTha2X2gocd6DW
	eykS/61XHWqeZSBlBL1vmbPFjWGIbvJ5YKEgt68dPxGP3UZ0scMbHxSQ/bgYhZxC
X-Gm-Gg: ATEYQzzf7vR+Yz5Q+HS69PKZPv+brdX0Zm/LC7bH1b6ThBd3fYybu+Yx2TwuTvmJACm
	w5BwBhgSM4fQ1QQxOTTOpaS5SnSIa42kVfW53L85JDpM3yAi21RSVcubuq1LiqwVmkN1OqX53WM
	9mCKcs4vqi4N0dP8iJz09vHTmfCSHDOUs6D1W6lLa87CbVpEq5x8MtICPowlpZUYTw+XVgC7o7c
	+XC3DygUGQR4ke+7w/p65XXn58rS2I35uMMGtPVrDNQt0s81rDgRIuIfRT+apj3d52Rej3s/NiR
	JLWC65eaZBiD5TnOGVcxmwEqSTOGTfqw8ZemXpRl6FrGqaZHEUCsvDbobqnS+VQOHrM8XYcpPCW
	otD37yTOXMz7yqf2zDorEZK+kVkFuZhYlIqSSjIV8mHCK1Q5c3IFBY/9ZseRE3N8TD1bINQtb4C
	kQYwpl3NSJiqIahQWQ+sTM2/PaugPiRPcYSd40R62sX7C89X6Gyj8I+FoZmm6Z/E3zZK0h8nOE+
	fHOGd0D0SqhOzLp/A7eQdHgKcTtErb8UgGJdTDnvg==
X-Received: by 2002:aa7:88d6:0:b0:824:9eaf:54ea with SMTP id d2e1a72fcca58-8274d977cb2mr7122908b3a.28.1772366886513;
        Sun, 01 Mar 2026 04:08:06 -0800 (PST)
Received: from fedora.domain.name ([2401:4900:1c80:eb23:e561:7e2a:9fa:6245])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8273a088517sm10228077b3a.65.2026.03.01.04.08.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 01 Mar 2026 04:08:05 -0800 (PST)
From: Rajveer Chaudhari <rajveer.chaudhari.linux@gmail.com>
To: herbert@gondor.apana.org.au,
	davem@davemloft.net
Cc: linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Rajveer Chaudhari <rajveer.chaudhari.linux@gmail.com>
Subject: [PATCH v2] crypto: drbg - convert to guard(mutex)
Date: Sun,  1 Mar 2026 17:37:43 +0530
Message-ID: <20260301120743.27041-1-rajveer.chaudhari.linux@gmail.com>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Replaced old manual mutex locking/unlocking with
new safe guard(mutex) in drbg_instantiate().
This ensures mutex gets unlocked on every return and prevents deadlocks.

Signed-off-by: Rajveer Chaudhari <rajveer.chaudhari.linux@gmail.com>
---
v2: Fix linux/ header ordering alphabetically
---
 crypto/drbg.c | 13 ++++---------
 1 file changed, 4 insertions(+), 9 deletions(-)

diff --git a/crypto/drbg.c b/crypto/drbg.c
index 1d433dae9955..5dba9be568bd 100644
--- a/crypto/drbg.c
+++ b/crypto/drbg.c
@@ -100,8 +100,9 @@
 #include <crypto/drbg.h>
 #include <crypto/df_sp80090a.h>
 #include <crypto/internal/cipher.h>
-#include <linux/kernel.h>
+#include <linux/cleanup.h>
 #include <linux/jiffies.h>
+#include <linux/kernel.h>
 #include <linux/string_choices.h>
 
 /***************************************************************
@@ -1349,7 +1350,7 @@ static int drbg_instantiate(struct drbg_state *drbg, struct drbg_string *pers,
 
 	pr_devel("DRBG: Initializing DRBG core %d with prediction resistance "
 		 "%s\n", coreref, str_enabled_disabled(pr));
-	mutex_lock(&drbg->drbg_mutex);
+	guard(mutex)(&drbg->drbg_mutex);
 
 	/* 9.1 step 1 is implicit with the selected DRBG type */
 
@@ -1370,7 +1371,7 @@ static int drbg_instantiate(struct drbg_state *drbg, struct drbg_string *pers,
 
 		ret = drbg_alloc_state(drbg);
 		if (ret)
-			goto unlock;
+			return ret;
 
 		ret = drbg_prepare_hrng(drbg);
 		if (ret)
@@ -1384,15 +1385,9 @@ static int drbg_instantiate(struct drbg_state *drbg, struct drbg_string *pers,
 	if (ret && !reseed)
 		goto free_everything;
 
-	mutex_unlock(&drbg->drbg_mutex);
-	return ret;
-
-unlock:
-	mutex_unlock(&drbg->drbg_mutex);
 	return ret;
 
 free_everything:
-	mutex_unlock(&drbg->drbg_mutex);
 	drbg_uninstantiate(drbg);
 	return ret;
 }
-- 
2.53.0

