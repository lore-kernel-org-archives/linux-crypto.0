Received: from mail-pf1-f171.google.com (mail-pf1-f171.google.com [209.85.210.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 199C7364025
	for <linux-crypto@vger.kernel.org>; Fri, 15 May 2026 05:42:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778823775; cv=none; b=IcV4eMZCuIx/t4h0DCQhDcEvxf9unqOjYuY46YUovPk5jGN4W5ZHpd0bDFfxuCxKzrWJtm2MeInipjd81RpWbJBCrVSQ4+BLlz3GtgYQZT7PsmJCu6JB+Z5QlYN08I8ZEf3S/rrWUhxt7Mv/73dDLlQlTcF0Sf3bcyQJxiMmz28=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778823775; c=relaxed/simple;
	bh=GnGzQTNG2sWXCYiVIHV6PxxXdvgI+nP2hkQMIdexBZc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jGvr28bCmh5pkMYo4bHTuP8R4tJ38vW6tYAwBq1FkudUZhtUE1Ef8yWubsPjmSP7+f7rIH/KQ2+ErdsosvHP04FSGPjgi4GA9iJq0LyN69dbCsK8yaxd+yd38enxsR1+Q6K2Sl3HITlGw62VYxCVy4Xr1zpf+fUpxEugpuf6MtI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=IeVeAtJj; arc=none smtp.client-ip=209.85.210.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="IeVeAtJj"
Received: by mail-pf1-f171.google.com with SMTP id d2e1a72fcca58-82f8b60e485so4387845b3a.0
        for <linux-crypto@vger.kernel.org>; Thu, 14 May 2026 22:42:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1778823773; x=1779428573; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Vu8r9w9o/+B86iBJC+fZKkUwDRzmjJF1xgahG3OvjQQ=;
        b=IeVeAtJju4/+vUQAXwnjDov4VYTPkTmxzLXBJaqJ5dVcHLFzly+VOfRY6jY4kl3Vut
         YZ0uFVkIJw3/0tH6XOb1c+lxX+hBBjL9+0/KqENkkcLYEwsuMnvfu08U8ujHWh7UZtGF
         vhsBZoNinnxsxp6z87QiRL/+Z1lESdhyAaztjtDrjeHLmLbOkJvK/DFrn/jBrORl0Pjk
         zceUQdWI2nUx3Ggi5khpRYqAGOtwpJvpfgrDTQlx2Sxr/02P0mPDXBY+98IeoAA4d4dI
         BIZwurFwOZs/Avh31IrqaImqDSFQFyby+ItLgMY0t1fpfxXbCnZRVxMLyw+LHRK7oCA/
         wnrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778823773; x=1779428573;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Vu8r9w9o/+B86iBJC+fZKkUwDRzmjJF1xgahG3OvjQQ=;
        b=qB7SB/H6p1+C25cdRt50IszMaaJmIbyBv0Szwokl896S//L+oGfyRaV7aBmX2fOFEP
         jz4PI4vXNXeULqn+7JbWerswS0LFCeEStsTlZ5KVxr8Yy0EDYuIoeiEU7LZ8Oli8CObP
         erzhxc2MgJxKg0J9PKvOLiJ2dWtNMeLupxf9zl4cBnq0N+n0+kpo4J822Os4rP2w7Tp7
         ls2EweFimUK++usw6j8aVO+Vjc98gXg3MagRawONX0a68pq9VUQVJIGSz31btQt+OjOK
         tw6aoc+B7EsmTlRzivu72gpaJcWR+sIX8ftxhxicKOoTloPoN2EEroH/OmGv++3YeMgr
         4yqA==
X-Forwarded-Encrypted: i=1; AFNElJ+DKriXJmzgJPSjE4cjoFqxh5608RDZT1w2OwZ57pUUaBgVIU/Jkaqb9BHmA7N+pRpbHqHQaQ8p9jwxeV4=@vger.kernel.org
X-Gm-Message-State: AOJu0YzFM7AfFZJtujxPCdfVZ4goBuVhyeak8M+7Zrw/K7S8HdQTt94O
	P9Gsoss+UTkB8zuD4ymqZWsMrlxPcjcMJie9GGQcBjuRC9Wvgx5+8WWa
X-Gm-Gg: Acq92OG7kvxVQvPi1aI6JJzFCt8m3heBHjre+kOdiMkNXSC66K9KkOJyj1rTXfyNIlL
	w8iyML+TWHVGu1qi26txqhbqf1a8sGfuDERAWTk8pIC58N9py7We0OruZqaULvXoLoqz1M8AXhg
	PaCFfE0/yhhvYYZlQaiVIu6QX62FI6kGHIR84QX+CVUcYbY0dQlQk8ziYwphPa1J+dM/K6r0+HF
	mnYmlIMQzQdVz+FnHtj8CtTHejQxbcGSLS6e3lOAxNKfxNDCKe9fM+e+5yo+toXw8SpSEVmz1cV
	yaMoj62fp+6OmRHS7/+Evt8UjcXRv7KOhDTuNymtmpP0ivQqBVhFconTAq7eVJb837wgfL939sX
	j+ThcW8rSXh6p7GZxY+XMHx1BbMSe5M8j16rDjsJex4fNPbCCrBK5rWWi5Hu0rz/m1bKq5D6r74
	gH/ixaQr2iHibvXqbhp4N+sGPsUQOdvDUOSgg9E9D5rsW/o+I77Kvpk+xLrhFnoisp3yfQjU3yt
	v1uM7PeV7rBxHA052jeIGZtpu4=
X-Received: by 2002:a05:6a00:ace:b0:829:8a84:b9fc with SMTP id d2e1a72fcca58-83f33ba720amr2908112b3a.8.1778823773353;
        Thu, 14 May 2026 22:42:53 -0700 (PDT)
Received: from harrison-Surface-Pro-12in-1st-Ed-with-Snapdragon.wework.com ([203.117.161.34])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-83f2b9bec8fsm3106116b3a.33.2026.05.14.22.42.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 May 2026 22:42:52 -0700 (PDT)
From: Harrison Vanderbyl <harrison.vanderbyl@gmail.com>
To: andersson@kernel.org,
	konradybcio@kernel.org,
	robh@kernel.org,
	krzk+dt@kernel.org,
	conor+dt@kernel.org,
	Herbert Xu <herbert@gondor.apana.org.au>,
	davem@davemloft.net,
	neil.armstrong@linaro.org,
	maarten.lankhorst@linux.intel.com,
	mripard@kernel.org,
	tzimmermann@suse.de,
	airlied@gmail.com,
	simona@ffwll.ch,
	jikos@kernel.org,
	bentiss@kernel.org,
	luzmaximilian@gmail.com,
	hansg@kernel.org,
	ilpo.jarvinen@linux.intel.com
Cc: Douglas Anderson <dianders@chromium.org>,
	Jessica Zhang <jesszhan0024@gmail.com>,
	linux-arm-msm@vger.kernel.org,
	devicetree@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-crypto@vger.kernel.org,
	dri-devel@lists.freedesktop.org,
	linux-input@vger.kernel.org,
	platform-driver-x86@vger.kernel.org,
	Jiri Kosina <jkosina@suse.com>
Subject: [PATCH v2 4/7] hid: Pen battery quirk for Surface Pro 12in
Date: Fri, 15 May 2026 15:41:49 +1000
Message-ID: <de275cc63e764d2acddf72bf3f50e89f307f41b5.1778822464.git.harrison.vanderbyl@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cover.1778822464.git.harrison.vanderbyl@gmail.com>
References: <cover.1778822464.git.harrison.vanderbyl@gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The pen setup for this device uses bluetooth for
communicating battery levels and status instead of
reporting it over i2c.

Without this quirk, the device either reports an
extra, broken phantom battery, or hangs.

Signed-off-by: Harrison Vanderbyl <harrison.vanderbyl@gmail.com>
Acked-by: Jiri Kosina <jkosina@suse.com>
---
 drivers/hid/hid-ids.h   | 1 +
 drivers/hid/hid-input.c | 2 ++
 2 files changed, 3 insertions(+)

diff --git a/drivers/hid/hid-ids.h b/drivers/hid/hid-ids.h
index 0cf63742315b..d16f55479786 100644
--- a/drivers/hid/hid-ids.h
+++ b/drivers/hid/hid-ids.h
@@ -459,6 +459,7 @@
 #define USB_DEVICE_ID_HP_X2		0x074d
 #define USB_DEVICE_ID_HP_X2_10_COVER	0x0755
 #define I2C_DEVICE_ID_CHROMEBOOK_TROGDOR_POMPOM	0x2F81
+#define I2C_DEVICE_ID_SURFACE_PRO_12IN  0x4376
 
 #define USB_VENDOR_ID_ELECOM		0x056e
 #define USB_DEVICE_ID_ELECOM_BM084	0x0061
diff --git a/drivers/hid/hid-input.c b/drivers/hid/hid-input.c
index d73cfa2e73d3..61ecd840d0bd 100644
--- a/drivers/hid/hid-input.c
+++ b/drivers/hid/hid-input.c
@@ -395,6 +395,8 @@ static const struct hid_device_id hid_battery_quirks[] = {
 	  HID_BATTERY_QUIRK_AVOID_QUERY },
 	{ HID_I2C_DEVICE(USB_VENDOR_ID_ELAN, I2C_DEVICE_ID_CHROMEBOOK_TROGDOR_POMPOM),
 	  HID_BATTERY_QUIRK_AVOID_QUERY },
+	{ HID_I2C_DEVICE(USB_VENDOR_ID_ELAN, I2C_DEVICE_ID_SURFACE_PRO_12IN),
+	  HID_BATTERY_QUIRK_IGNORE },
 	/*
 	 * Elan HID touchscreens seem to all report a non present battery,
 	 * set HID_BATTERY_QUIRK_IGNORE for all Elan I2C and USB HID devices.
-- 
2.53.0

