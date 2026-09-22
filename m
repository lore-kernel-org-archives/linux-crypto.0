Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 825083B895A
	for <linux-crypto@vger.kernel.org>; Tue, 22 Sep 2026 03:20:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790047211; cv=none; b=AAH5rfhwWiBTMYzwfsghKL1FMb1bkZsxeGlCoUQyvS/mUmrFBmAsqryvYJ3un8mOH3E9uePOlj8dLWzhE2bK/WbclTWXMQWnM4z/pcWgXYDvj3fZ8CzuuUtCfaakyF9hvoT6g0PtsE5FMuyckgIFAfUhs6IRv4Yc8F3SjbhRo6M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790047211; c=relaxed/simple;
	bh=eAoZWdyBQ0gvYpfyVz0P1IC+IR+fZJNTzfQ1SyhSuw4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=u55NBlWMDBH3euOmcr+GeYSSQT+YyIOqrRqgDR1RBPJISsI2kcF8K/yAR3gvqywbIj1jm1lAoNcj5zFj7O80Nmlu4mI2f+Nw+rwW93RwCVBtHZe2qo7NzUdmo/SkPPY8R/Cj1Fe08AHq1CBJuq4UuAuyi9rFMKnWDy7N6qNHV9g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Y0Q3x0go; arc=none smtp.client-ip=209.85.214.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Y0Q3x0go"
Received: by mail-pl1-f172.google.com with SMTP id d9443c01a7336-2dd1dcdcf95so4326345ad.1
        for <linux-crypto@vger.kernel.org>; Mon, 21 Sep 2026 20:20:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790047210; x=1790652010; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=AJoHTp8J0uzmIlfrfln9mMPGZu9ifn6RaYx8B2B0mpM=;
        b=Y0Q3x0goH0l1iEWFUm8rmJ5LWj/5PPKYKBmYDgND8+KUighyWX+wsKK6YIW9QvznY3
         s6GXc9oUm6+clQ4bAaVnxqV7Xn3lYMF7MMFPOdc3ABbyXwzBSVKW9bGt1/Nvf9UPOTmh
         yE+wtiVU63e6RTZDy3CS1m9DJVvnjE5QG8I8dL9u+srpZstFJv6xqZWihR6shUWr39wh
         My2hc998rLgKvzKNfLBSmmT2LMemAlJQKVo5TVFZIMj4UmwXZClDun5/z7cnhoGMywYm
         W+GG5heJgKkr2rQbsw8qe0VbVanWdCB4cL/Tm0eKYDzV77FXWmpFTQ7D0QrtYnVsNbUn
         Hs5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790047210; x=1790652010;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=AJoHTp8J0uzmIlfrfln9mMPGZu9ifn6RaYx8B2B0mpM=;
        b=m4Gl662A3PZsnBRtt8ZXoZGzCkHhu+cgmBmeLQnsr/0dDvlDItMvArvwQWgtnqi8zi
         84jjh8ZCqqL9Pl+d8MjNP1v6VLbHLUVZbDAUDhS3TwKXZfJzJmh1pP0g3/Hba1IAkrGu
         h/EUnkpKkhUzrD8suNvXCpozQyd9Xfe10nNADGnx8Xh78HE8KHmeACIq+snrhvhU8CBW
         qKa0M8/kvB468wVjjBnXm9736L6bh+KaaVGu8oxQChlLKRAEtjVPcUSPHrz1ucmkzKrw
         xzd/Ba+JzDJv9Uz56EfhT1lUCJk2mm3WMn6S1Te5fhKiW6Cac8RxTnZTQt/VLF0YbybG
         8svg==
X-Forwarded-Encrypted: i=1; AKwUvBxF1LXVos6paAb6QRXPVBLOGHEBxjZ6AnQJqrZ6IOb5DvvB5kb0RbBTGFQu5goKu/DZO6Hz0h5cKAR13r0=@vger.kernel.org
X-Gm-Message-State: AFuF++k6DaYLfFXMpOyS0tJBDFhTnn4rvtUXuivhl5ka9iOPs86ADC3W
	ynITsYprh2ZunSDmGqil7KCWuNDhxe1IWXYYeCgu6LeHqyZgRf3mZhJgOVNkrw==
X-Gm-Gg: AYBFou3N54MPRmmD/MCFl+uxLPcmflTfAlOgdAddXV61f5nYdRCz2Ny3QOVL/Mk/QuO
	YCzx2LgwN6+JS8jZKQIobIlGbXDmk22pI2PjKIpGCinjubjMO72A8E5JdJsmnhbaAQ4ySSbrRoK
	XbnwT9OZbC+BlWVMAwTUwUsEhUznr1OdpCbcmkuZWNvDk3DbNwFc2+EQmcdptmUkXwe1oP1t4HV
	RGg+Jx/QuFwuqO9EgKATWNeNEPV9SOPcXESdjZxRta1hNwRqbwYcs73+dZGVmUNiuM7Inn+G/cU
	aGpN0swBElg6rEGPEpJr891TgkvvbA2OGV/eZ3xlGFpqc1GUm6+29bmbcSIuKNy0pKYiXaT4/SY
	nDB64Ldrnyrvmv79+phZ14iSzN0q7dG51sQw3ALnSUKH44N57MH4KzPbh6worTSWlBGnfqRRj2S
	bSxKmAyw/Q+QsnYB7KucQMcC6VQTjhsjn3fmTQLJJfaw1ZTZRrwVjO5VFSV5OR4QBKxAStuzAgB
	h6cydXbe9Z9pY5fThnlYzUbq5IgoRu/L3OzITpLtFa7XJSlnAKIbdWLEaf3hqf+6pAdX5D7EEo/
	PcuWFRbkn5QDUek5lpbz3tt4
X-Received: by 2002:a17:903:4b2f:b0:2df:34c0:7303 with SMTP id d9443c01a7336-2df59ad92afmr12464055ad.40.1790047209771;
        Mon, 21 Sep 2026 20:20:09 -0700 (PDT)
Received: from phuc-desktop.. ([183.91.15.56])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2df5cf83512sm1940355ad.5.2026.09.21.20.20.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Sep 2026 20:20:08 -0700 (PDT)
From: phucduc.bui@gmail.com
To: Corentin Labbe <clabbe.montjoie@gmail.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	davem@davemloft.net,
	Chen-Yu Tsai <wens@kernel.org>,
	Jernej Skrabec <jernej.skrabec@gmail.com>,
	Samuel Holland <samuel@sholland.org>,
	Gilad Ben-Yossef <gilad@benyossef.com>,
	Hans Ulli Kroll <ulli.kroll@googlemail.com>,
	Linus Walleij <linusw@kernel.org>,
	linux-crypto@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org
Cc: linux-sunxi@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	bui duc phuc <phucduc.bui@gmail.com>
Subject: [PATCH 0/3] crypto: Use pm_runtime_resume_and_get()
Date: Tue, 22 Sep 2026 10:19:51 +0700
Message-ID: <20260922031954.320895-1-phucduc.bui@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: bui duc phuc <phucduc.bui@gmail.com>

Hi all,

This series replaces open-coded pm_runtime_get_sync() and
pm_runtime_put_noidle() error handling with
pm_runtime_resume_and_get() in several crypto drivers.

No functional change intended.

Best regards,
Phuc

bui duc phuc (3):
  crypto: sun8i-ss - Use pm_runtime_resume_and_get()
  crypto: ccree - Use pm_runtime_resume_and_get()
  crypto: sl3516 - Use pm_runtime_resume_and_get()

 drivers/crypto/allwinner/sun8i-ss/sun8i-ss-hash.c | 3 +--
 drivers/crypto/ccree/cc_pm.c                      | 8 +-------
 drivers/crypto/gemini/sl3516-ce-cipher.c          | 3 +--
 drivers/crypto/gemini/sl3516-ce-rng.c             | 6 ++----
 4 files changed, 5 insertions(+), 15 deletions(-)

-- 
2.43.0

