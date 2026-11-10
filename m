Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.52
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794347767;
	b=nedSuJ6zJHdouMUcalnFzYtBJfhfbsWcbI7a5rrm1r7qEYgXJ+evkoHMtK70LVpZg0ji
	 yBMy0dSe/Om4hhCuyK3is0QDfRR0awnZUmkG1ElXDuPuG4/rKjRvjs2b2xz+XQ7WiRXbt
	 jH5r7LOayAiczZHo5NQC0VPnAuz/1KNfREp/Z+9k09lvQ0C7P4ahaCwRyJow3OmFWX8Ce
	 /nXU7pNceQMNXuoF4HhmC9raAJBbFS3JPL/G1eCQDwH4Snqv9nmS5QqgAa7asGPZCPhUP
	 59Lg+2Fuc8PqDhCsVbvTi/xA1Iv/caCYJ8GJDGyMJbt2gog5dSW6GczmU4Jg/1t4MLA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794347767;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Type:X-Developer-Signature:X-Developer-Key:
	 Content-Transfer-Encoding;
	bh=27advilcz2wP6UN5M54Q2ZsQBSdNoHnIxCKVWfLF+lY=;
	b=xzrQkAB5YBRH1HjolMjYCFH+GeFs1TVnzr0C8OIvZqlUH/gu06qnX8H7+Vj01ixQhrdv
	 YNu7PzPZX3RoLLLq2nH0+DnwOAFRkGZMo25FH7j5Zy3lrQpGJios52SsgLxEp9A1SYwMr
	 AiRZSqQOL8eEloFu/lm+5UuINxg7V0HRU3lubqxv3zVTI9K5b0kQpqEzUagbQ/KJVNtQ4
	 Hg6k80W1u8qmFBjQ+iEgt0+MaShXeGpF5jY7D9D4ZdU1updBse3KzOTXngH0yfglE+Ic3
	 ibvyz/JFEtTydbhjdLfkg9mXdy60Rapx309GdB/akZAWexx8H3tEYBJyPf7tJn3/cxQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=baylibre.com;
	spf=pass smtp.mailfrom=baylibre.com;
	dkim=pass header.d=baylibre.com header.i=@baylibre.com header.a=rsa-sha256 header.s=google header.b=ScGfBWdz;
	arc=none smtp.remote-ip=209.85.128.52
Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2372160A3815
	for <linux-crypto@vger.kernel.org>; Tue, 10 Nov 2026 21:56:06 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 2372160A3815
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=baylibre.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=baylibre.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=baylibre.com header.i=@baylibre.com header.a=rsa-sha256 header.s=google header.b=ScGfBWdz
Received: by mail-wm1-f52.google.com with SMTP id 5b1f17b1804b1-4a35d5d4a20so31011665e9.2
        for <linux-crypto@vger.kernel.org>; Tue, 10 Nov 2026 13:56:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre.com; s=google; t=1794347765; x=1794952565; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=27advilcz2wP6UN5M54Q2ZsQBSdNoHnIxCKVWfLF+lY=;
        b=ScGfBWdzik4szXie/VCmd8A40UJAuOEaH5sQ2qBEwDOhKcFV9auLP5OuISf1VY2fXN
         Cn/0fxi5pPDkZL+7+iPgl/OQAKWzlajmlSvSRLAqDDPzqXds933DX9ZkUHsuqmXizUyY
         cbCVG6Mpbkz5PjHFMdGOOJO7ZamHwwfq0EZ2GrlvI/hyq0qy6ef4cL6UFPoOz7BEBBVv
         x6ZU7Ej90v7Ya3PwwvXb7nevs3BevJGszA9/j2ysmZELQnOHJ7Fr8f/PsEgdebl+LoFg
         pmrN8DChJGbkDr60f20J/1uu5FfXoKd4WWz/DCalfHiMXtRj61Jf2vig+PxjUtoOa9Jk
         F1Hg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794347765; x=1794952565;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=27advilcz2wP6UN5M54Q2ZsQBSdNoHnIxCKVWfLF+lY=;
        b=f7+ykqc+EpTQuvWkth+xvBk3GlhY8ZffwiRRsF9ecIu1JQhnaXrLJVyzS7lZo7D0Yt
         0DmP/oYG4tGrgx1dG/0k+m6z36TmPxBSDUd2Dic9QWW128qVSeKIhuCdxO/GUkmggSD9
         qM1EJKH3LRt98bti8wlH2Y6uLDSxb1+/aMmtbeiQwGmuXy6Em/WQap7XcLNppCIcwB1j
         AKpvGAoCfXKAVdwnfiV4I25Pm1RJtd5xrrO5RUI1HJL6LdkKJIjusN5IHvvnw2mAPfPO
         NBUZauojlp3/H0HcwQ+5zsr47fyxZ1UXNmiWpspBRQKhaSf4gBbJjOEH9UK3h2hfzWui
         WukQ==
X-Forwarded-Encrypted: i=1; AL+hErHs3iKPO8dAvyvMwLlDFSnH0sq1guZJ/GSBQxZlAVESB9qGBh7WKdz5kwuKxqqH+0+IThPTkOTLWpbROjg=@vger.kernel.org
X-Gm-Message-State: APuU4Z+nKPkj5JphZmLKa52OdryUqZ/tJ5uERsiAhXUHdBoDEmin9dvR
	/n1ZjpK2TML6NQ3fETibu7Jv9WRd6HflLX6Xakw0adKVoQZ4LMBWpVZIdQeutm7wOqg=
X-Gm-Gg: AYBFou2cMWYdU6zJWiRX7MDEQeLMCi2upanDcAbAqbBg/WKs0JV1ueTUuisR/j1qi0E
	VQnsfU9gQJ1AYKSI93dktcvsAF231N4AQTEQ/AToTk8khEyhHJBhtTOGooHKGrhIQxOVtsINbMa
	dZjskEbq+XodqrZAMtbri8yNiKOKsgzOT5M8oYzkGXFYPeUdT6c0rb87N0sCJm6AazHTT11mJLQ
	RJXTR0x6Tr5RKgPI1qHwinZxmfuovg5T9Vv2nMvhYG+/VINTOjq/n0qRb2MzomW1TQ26zdZZ7Sp
	ZU2vHGKZZyPIHVBeIS7jFw0Sdj9WAr1kcJVw3+FtTgYpV4yZUVDwiZSK1kCjdWR1kN4SZ/yGgwa
	bBNjpWUev4hQ22wVsG1Q8mPyBkCoKjiLRIKCzgRHn9duPSvotUnIRY8ua0g0IeJyV+cLrZRBCsy
	rpbKccFVnGu/J8MRSIYxBqVwjjOeDF5+zBojlqxV2k00kEQIZZaW7miRNabgJgggYKqdYFkE3hI
	5S7Nplz2f4y7oEOn+n7hU8ad5Dr5n++A8Z/jCEirQ2e5U7OfJ7M7KK2VF/kF9glZSOuHnHkoAXE
	spL+ANVfVKlMXh1TrMItH2QtZvvBzQbSfD0=
X-Received: by 2002:a05:600c:3554:b0:4a4:4d57:8487 with SMTP id 5b1f17b1804b1-4ba0936c8admr6184475e9.5.1794347765628;
        Tue, 10 Nov 2026 13:56:05 -0800 (PST)
Received: from localhost ([2a02:8071:56d1:2de0:1d24:d58d:2b65:c291])
        by smtp.gmail.com with UTF8SMTPSA id 5b1f17b1804b1-4ba0204e22csm84491605e9.12.2026.11.10.13.56.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Nov 2026 13:56:05 -0800 (PST)
From: =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig=20=28The=20Capable=20Hub=29?= <u.kleine-koenig@baylibre.com>
To: Lee Jones <lee@kernel.org>
Cc: Qunqin Zhao <zhaoqunqin@loongson.cn>,
	linux-crypto@vger.kernel.org,
	mfd@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	Linus Walleij <linusw@kernel.org>
Subject: [PATCH v4 07/20] mfd: loongson-se: Drop unused assignment of acpi_device_id driver data
Date: Tue, 10 Nov 2026 22:54:32 +0100
Message-ID:  <98b0f85e2b1c5330958be64c2bca859cb0e16628.1794347059.git.u.kleine-koenig@baylibre.com>
X-Mailer: git-send-email 2.56.0.rc1
In-Reply-To: <cover.1794347059.git.u.kleine-koenig@baylibre.com>
References: <cover.1794347059.git.u.kleine-koenig@baylibre.com>
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-Developer-Signature: v=1; a=openpgp-sha256; l=919; i=u.kleine-koenig@baylibre.com; h=from:subject:message-id; bh=WctLszqVF045tp6nwF22xHoE9K0taY4KKqQ1CbqyIGQ=; b=owEBbQGS/pANAwAKAY+A+1h9Ev5OAcsmYgBq85KqD2/HtYab3u2BGN1KZ9z27I7+Z4HOPLlbB ODCx1BiL/eJATMEAAEKAB0WIQQ/gaxpOnoeWYmt/tOPgPtYfRL+TgUCavOSqgAKCRCPgPtYfRL+ TiY1CACST/5p5AX3YvgpdzTMs32H9OuTz+rye6bieanuEfNXqUb1EI11zexHwkp+qT8zOamGcvM UDrCpZmkkj9EodEchekm3zO5dkHT1gMDhyrcvERhGxUYi0FqNpFA1rXdxmFMemjJBeUhyeNm8IT bkMepOvkdEf2vGnBUXUtwDEDIUGR+f1G1yjugjUJ49rE+J+7bYx2JBHqoUrpfgkf5i3QYO1UxEQ JfKv8wUEmKRXHDt7f58nUBylOhN5iaKnqqQOh9NUOSM8cdDtyPEkd8IxXfTWADHNgRd62Sxg56j EC0zVyRXbt8dARWu/o7h0USm2c2tpI6gd2TT2aGuFdbmgAVm
X-Developer-Key: i=u.kleine-koenig@baylibre.com; a=openpgp; fpr=0D2511F322BFAB1C1580266BE2DCDD9132669BD6
Content-Transfer-Encoding: 8bit

The driver explicitly set the .driver_data member of struct
acpi_device_id to zero without relying on that value. Drop this unused
assignment.

This patch doesn't modify the compiled array, only its representation in
source form benefits.

Reviewed-by: Linus Walleij <linusw@kernel.org>
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
2.56.0.rc1

