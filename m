Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5ABE141C2F6
	for <linux-crypto@vger.kernel.org>; Wed,  8 Jul 2026 11:16:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783509414; cv=none; b=quN4fVZQ7PbrhDTc+sPLShWyVYWP8OOafXjGC0TqSpQihVPU4U9FDJW/ZzqOg5KuoS4wwlN6ju5JC2zzOaVVno1Awh/+lWGfkv4en4oN3B2scxh2ya7oceJaLvmt4U+G9gIw49EoyqjHqy657UNtaexY3fSjFcCv7FlJJ+LlZJM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783509414; c=relaxed/simple;
	bh=6qbdlzxZyZLMBPwj2Zmz1sZXp72LcZLMsWmZZfgKkIw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=csouWFV6mQgAvJNVCD3Dnt/iBJvUfkKIfXtQ6xVs0Sq0Y0UmhwaxU0RRYaQ5OLZC71HkBjIxjU6u1ZmO6+6fafEt5WwnHe7n4FjjpkgutApqEk93vVfpPOVgvMWRgkzWm1TFHq9m8hPFkjQMxd6Wmo/6e7gQs/K76swNjX9CbZk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=baylibre.com; spf=pass smtp.mailfrom=baylibre.com; dkim=pass (2048-bit key) header.d=baylibre.com header.i=@baylibre.com header.b=LkWLrnQ3; arc=none smtp.client-ip=209.85.128.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=baylibre.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=baylibre.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=baylibre.com header.i=@baylibre.com header.b="LkWLrnQ3"
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-493b61b52b6so5140225e9.1
        for <linux-crypto@vger.kernel.org>; Wed, 08 Jul 2026 04:16:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre.com; s=google; t=1783509407; x=1784114207; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=TaCMfmYh26EG6vWNYZX/3pfm5a0Em0kXW/5DfKVSZ90=;
        b=LkWLrnQ3ECbfTq6TddjybytKEzf4Cl7tEqKOJZLqy8UK4pbYP9FJf5Vy6rZYrxdcoh
         vv3/kPzt2knhFJ1vKQJAyH2UMlyBNIj2Yo3aegwSSunGMpdnA4kq4/JyQaoG9VIyPWIg
         sOzqUsc+1bEbAqA2WYdjDuKil6832+6S7++Tk6HyN5d4FKiLGxczlbHDJ1pwPIS94jr5
         nrr+nJEiZLM56nofMaycl0/+UCmr3Etb+i7YG1uPqM57Kht31QciLMZ2YQjXrY99t5nI
         LoQOMyWd4QBvHb7oFrpgqhXEDqJHmGcvkPnrF7p8jm0Gxy6ui48a0R8BbKfu1vInCasY
         1AAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783509407; x=1784114207;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=TaCMfmYh26EG6vWNYZX/3pfm5a0Em0kXW/5DfKVSZ90=;
        b=GXYzrF2M2zlxeJGerMeLD3irY+zXhdxiAGyquWomKlF1Ijgc+DCoJQ1Mm9I6Fy4OkV
         ou28tmMSmxxTQ3sONu/TWz5vnZL+jAreRB7X2OfbVjCISSQKUd1q6d+mvcmkp2LQORt+
         DrrinGAuA4cuuCMFhRMqk/97TBAR8loTO4YDM7T60w+n49LM0SX4a0QOaQW1rqsRjJnV
         CdrcbtXh5tFriiVbm1C844hw3jvJ7J9iKLmmnRnJMjuRkz/Tpl7B6QG/sVomaFqbTXmt
         onOAFLw0nZClur1epCF6ZHAoFtCkKbXa9W5l31gjq9Rik1hVFDCaeSwQMbi8JP6tjNqh
         ZzwQ==
X-Forwarded-Encrypted: i=1; AHgh+Rq8OB2JLGwW6Zt37N10IxExcAWBmOEjcBc3b6od5Y3GfZqtXqs94Vgtz1clyY2mZ4J9EvGXbyFC4+TRjVQ=@vger.kernel.org
X-Gm-Message-State: AOJu0YwCqW5o8O/bMhlTQDQWC3buB1IAe8YW0CWORsW+1Jj3YIGd9LRu
	NHt3WyPK4HwjoEsVwFmAF1UgyCdK1fniS+obhYn2lloR7P6HHW/mFdgJZ6Lsr3UqAyM=
X-Gm-Gg: AfdE7clRDI0KVwjgtlXp9YrQUbilyUyGXviZLufKJYfdVFl+GFwA6lMFCMOJmApdej9
	j+/MtprMBDzYF0oXjVI9/wUvXRl2gYYl8VkBnT8mTHRHZgCvra6aZyumUf6W+XseoeNdlxHaqaV
	IhBPW80X8A9eL8M0RNe0NReQ1bKv327wyCCdDhd3N5TOzNwcr9OgQ0UlMhnZfjsLh6qcoXplvtV
	Erl2L0LC9BrT7M21WKSx99LO+8KpLBMHOiBETow1g8leuxBgrKEEyXI42gEEFD45ByQd07f9M+N
	ak9Rn7JL61+LYpKCBQLNdLiXZ8covxKTLjSw1AkSCDzkWQQpxxfNkv/hyOOGEGWkdiV1BY+KUXG
	313FfyfTitXgQCJMob4sqEDs7DFzRKliW1r7jT6PdIQbd/fU/jV9VuuMpnsC4Ipaj2idmhzq5Ra
	pl5leplnf1YunxnbLzyw66X7761caOybNQbNcABkxzuTP25///FsFP8YVrvRXtAzHO8NADkFyms
	X9N
X-Received: by 2002:a05:600c:6992:b0:493:bb0:3b43 with SMTP id 5b1f17b1804b1-493e6d1702emr16184795e9.2.1783509407586;
        Wed, 08 Jul 2026 04:16:47 -0700 (PDT)
Received: from localhost (p200300f65f47db04930dc5bd4534e1e5.dip0.t-ipconnect.de. [2003:f6:5f47:db04:930d:c5bd:4534:e1e5])
        by smtp.gmail.com with UTF8SMTPSA id 5b1f17b1804b1-493e0f43912sm151033615e9.7.2026.07.08.04.16.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Jul 2026 04:16:47 -0700 (PDT)
From: =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig=20=28The=20Capable=20Hub=29?= <u.kleine-koenig@baylibre.com>
To: Lee Jones <lee@kernel.org>
Cc: Qunqin Zhao <zhaoqunqin@loongson.cn>,
	linux-crypto@vger.kernel.org,
	mfd@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2 07/23] mfd: loongson-se: Drop unused assignment of acpi_device_id driver data
Date: Wed,  8 Jul 2026 13:15:14 +0200
Message-ID:  <52d02d74d8c7589731ee0f0805123cfbf2f992d3.1783507945.git.u.kleine-koenig@baylibre.com>
X-Mailer: git-send-email 2.55.0.11.g153666a7d9bb
In-Reply-To: <cover.1783507945.git.u.kleine-koenig@baylibre.com>
References: <cover.1783507945.git.u.kleine-koenig@baylibre.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-Developer-Signature: v=1; a=openpgp-sha256; l=884; i=u.kleine-koenig@baylibre.com; h=from:subject:message-id; bh=6qbdlzxZyZLMBPwj2Zmz1sZXp72LcZLMsWmZZfgKkIw=; b=owEBbQGS/pANAwAKAY+A+1h9Ev5OAcsmYgBqTjFPPm0q2sX6r6XfARwoVd2skEs5VWoujN4Ud vzHvIn7q0yJATMEAAEKAB0WIQQ/gaxpOnoeWYmt/tOPgPtYfRL+TgUCak4xTwAKCRCPgPtYfRL+ TubsCACTTwl3FBbqji9gTFIlLTGwskOG7AMEO/JNLuTUuUjQbDjrOaRx4RBnzS1QSWiwvrppY/I sXi6ufnyXqLXQN01yDrJIEC+nynzVhvLvQe0GJ5BO/k5TKjsEFQIrbyo1wly7I8Bz2rKdf8m/tx mhib8ir8vuJRFy6NHOYM3agc0ndS+QpslK0fVkWY00CzVS4js4sDjt5z6Syv3Mvddp3mwBhU2QR yicc4eEHDtVnzvg4KD7hvS0RziNA929vjMSegWodsBJfkv9P2BjMkIciiEqqAi/rNpGMMcSSA2Q TtUd7iXvjeC1yHAuowD5pgObwNKE4S/OJqIva6rqpiE4hhy7
X-Developer-Key: i=u.kleine-koenig@baylibre.com; a=openpgp; fpr=0D2511F322BFAB1C1580266BE2DCDD9132669BD6
Content-Transfer-Encoding: 8bit

The driver explicitly set the .driver_data member of struct
acpi_device_id to zero without relying on that value. Drop this unused
assignment.

This patch doesn't modify the compiled array, only its representation in
source form benefits.

Signed-off-by: Uwe Kleine-König (The Capable Hub) <u.kleine-koenig@baylibre.com>
---
 drivers/mfd/loongson-se.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/mfd/loongson-se.c b/drivers/mfd/loongson-se.c
index 3902ba377d69..4c668e2d2241 100644
--- a/drivers/mfd/loongson-se.c
+++ b/drivers/mfd/loongson-se.c
@@ -233,7 +233,7 @@ static int loongson_se_probe(struct platform_device *pdev)
 }
 
 static const struct acpi_device_id loongson_se_acpi_match[] = {
-	{ "LOON0011", 0 },
+	{ "LOON0011" },
 	{ }
 };
 MODULE_DEVICE_TABLE(acpi, loongson_se_acpi_match);
-- 
2.55.0.11.g153666a7d9bb

