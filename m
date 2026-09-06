Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 286C73B0ADC
	for <linux-crypto@vger.kernel.org>; Sun,  6 Sep 2026 11:46:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788695196; cv=none; b=TlfRbaXSo/6jcOFER7z9UV5LZpe7WakFlJivHCdAAMfbZeRWhRjHajompIZoRQRWR4A/WsfJby9oQmrmGM2JshQ9fLrM3wqPNR46Vk2ROAnqX96hAMatcBrXg3hKaE+fsyj7Ncce3juH0GMnKZlNA7suEFrbxEzMqAfqXXSqMLI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788695196; c=relaxed/simple;
	bh=WxryOoKfKqEGVk11d7TxwK3eBMl9xSeC1S+W9v6xurk=;
	h=Content-Type:MIME-Version:From:To:Cc:Subject:Date:Message-ID; b=E0mohqM69LJBLP5x/Utu56MibWfa7/WUFsPL7lhvK6njyF+bWvqXpLj7EkZtV6OdXyXRcV2tAOejWmipWeI5+RsfgPKnDF4avouy01HzKkC6V9SNsN9vJ8NA5Jbw3meLzCtTUSzIm++W9NOVlgX1Ji5xNXt4X2umhN08ir35XrY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=YThVNx7Z; arc=none smtp.client-ip=209.85.214.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="YThVNx7Z"
Received: by mail-pl1-f170.google.com with SMTP id d9443c01a7336-2cc891373e0so26939435ad.2
        for <linux-crypto@vger.kernel.org>; Sun, 06 Sep 2026 04:46:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788695194; x=1789299994; darn=vger.kernel.org;
        h=message-id:date:subject:cc:to:from:content-transfer-encoding
         :mime-version:content-type:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=WxryOoKfKqEGVk11d7TxwK3eBMl9xSeC1S+W9v6xurk=;
        b=YThVNx7Z9nYUDcYPkV0wDaJf6zCIQvguctkGxlkI4XRQxNAZiBGP9Zplti28jVr44u
         uJuDR4Wn3UIhqe4SM+6wey5cnbh7j2xSNI6M6pzf6yOn2G2oBt+uy94MRjzsL7Zy+ch5
         6yqN1CoRHvEmyhvM8GoHJuyJtEA+ZweNkApOaJvAIRXX1AFh5vty/3hq60rG7GFdyU8G
         z+InQsT88yk8tBcHAEMbKY8ZKuzVSgEzzscmnPisbFQ25chSMn3ZJWCx1PvDwBsHTOso
         JhCM8pdEghdqj+7BJR6+Qd6fd0B/73KOQ3sObd28M3lb0HGRpoG450z19Bnwx5WqpoDm
         y+tQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788695194; x=1789299994;
        h=message-id:date:subject:cc:to:from:content-transfer-encoding
         :mime-version:content-type:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=WxryOoKfKqEGVk11d7TxwK3eBMl9xSeC1S+W9v6xurk=;
        b=suykNLKIcIAw+lxFm3H9awaig8UB3MCa9D5YD+QPd6Q2zwXBYx3NzMxlsJaSQQftx6
         Gzq6hbWlZOKhVcAPU7x5s+eNe3AwW9nD2sPDueyiTw02NqkhQFmKlIVigXeSh8QmbzVT
         LFt7IKnM74mRiSAKL/qjdhxpWwn2xnZU1ZjBl9P5GQgg1v2SAZXH/rqKiRdn7/XM/T6i
         owv4s/irraY6dqCVSkj/oA4ZI+eeqfMsDUIXXUQvWHqmrJCnjX2Vt7YTp7Tz9xGQxxNh
         8/BucU5Z0y200ATvngJFKUEX8u/8tEgZQ+CP6EHrdkrhDst3H+FR5oIbeJhA8ut5HCzu
         uNzA==
X-Forwarded-Encrypted: i=1; AKwUvBzWcfhbIAwOuWlfEaztgu3RIkIrZP/RtUGJ6HWDuFBUI9Iz5BgLzM5vKQYxvH/pyY6UmCdisG4iBia24qc=@vger.kernel.org
X-Gm-Message-State: AFuF++l2dPT3Oc92yssaY4vNCuAaifNCoOpdiPeCAptZAKTPQjWBFpbo
	GwUvteBVgsesYStUgLLsfrMyQmzK3hefwHHnVo1qRUJzWQRFVoyzHS09
X-Gm-Gg: AYBFou2EjVQFeOoxQArhYo0M0O2qKxT7D80h4DFQt4fBaSRjgoxTNIN8ooGkbH2CZ9e
	9WYE69vRXTJDU/58LLPmX30VpvW2Z13aKpTbySb10sVEpGwz547m35dREgLiZ3h26Sn9PVl+Xd3
	M4oYdvSls4Oi+yYcdOvPkTPiWKaidtn82ePgX09UwkmZ2Y4PGV6orXnWOztJnNHAAfP5JTtZ//2
	uztOcjNVxX56244f1yYJDE+wlSOIh8DRqHBK6z45KSeYWgzAMFHhqqi7Wfl/4mfYCThxRdJEYhF
	blb/7AMMbhYO1aaLt2JmbL5c31XlutnwGJxd1TQRpKqjKJX5ry9Yie94AdUpOkUm+UbL8oVDzYp
	WYxSCZ3dOICY9UaEtQZxrpSIOJjXjTuaDYr1mV38rKVx2TfgZsqw50UxMZOrayIW/9XxYSR/SZY
	jIWQVibyCWbu1IMtuxGrPVHg/jRX2h9O8JTXAyjFwRmNx/cjXPo9Gs
X-Received: by 2002:a17:903:1670:b0:2d9:438e:b70d with SMTP id d9443c01a7336-2db1232c88emr261040555ad.1.1788695194391;
        Sun, 06 Sep 2026 04:46:34 -0700 (PDT)
Received: from [127.0.0.1] ([115.190.67.8])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2db1497d9ddsm31787565ad.31.2026.09.06.04.46.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 06 Sep 2026 04:46:33 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: base64
From: Ma Yukun <0x4fe6@gmail.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Martin Kaiser <martin@kaiser.cx>, linux-crypto@vger.kernel.org
Subject: [PATCH v2] hwrng: imx-rngc - check return value of clk_prepare_enable()
Date: Sun, 06 Sep 2026 19:46:29 +0800
Message-ID: <178869518976.1724.8613243679737914482@gmail.com>

Y2xrX3ByZXBhcmVfZW5hYmxlKCkgY2FuIGZhaWwgaGVyZSBhbmQgaXRzIHJldHVybiB2YWx1ZSBp
cyBjdXJyZW50bHkKaWdub3JlZC4gSWYgdGhlIGNsb2NrIGZhaWxzIHRvIGVuYWJsZSwgdGhlIHBy
b2JlIGNvbnRpbnVlcyB0byByZWFkCmZyb20gdGhlIGhhcmR3YXJlIHJlZ2lzdGVycyB3aXRob3V0
IGEgY2xvY2ssIHdoaWNoIGNhbiBjYXVzZSBhIGJ1cwpoYW5nIG9yIGV4dGVybmFsIGFib3J0LgoK
Q2hlY2sgdGhlIHJldHVybiB2YWx1ZSBhbmQgZmFpbCBwcm9iZSBpZiB0aGUgY2xvY2sgY2Fubm90
IGJlIGVuYWJsZWQuCgpGaXhlczogMWQ1NDQ5NDQ1YmQwICgiaHdybmc6IG14LXJuZ2MgLSBhZGQg
YSBkcml2ZXIgZm9yIEZyZWVzY2FsZSBSTkdDIikKU2lnbmVkLW9mZi1ieTogTWEgWXVrdW4gPDB4
NGZlNkBnbWFpbC5jb20+Ci0tLQp2MjogZml4IHBhdGNoIGZvcm1hdHRpbmcsIGFkZCBtaXNzaW5n
IGNvbnRleHQgbGluZQoKIGRyaXZlcnMvY2hhci9od19yYW5kb20vaW14LXJuZ2MuYyB8IDQgKysr
LQogMSBmaWxlIGNoYW5nZWQsIDMgaW5zZXJ0aW9ucygrKSwgMSBkZWxldGlvbigtKQoKZGlmZiAt
LWdpdCBhL2RyaXZlcnMvY2hhci9od19yYW5kb20vaW14LXJuZ2MuYyBiL2RyaXZlcnMvY2hhci9o
d19yYW5kb20vaW14LXJuZ2MuYwppbmRleCA3NjkzMzI4ZjEuLjU4YmRjN2E2YiAxMDA2NDQKLS0t
IGEvZHJpdmVycy9jaGFyL2h3X3JhbmRvbS9pbXgtcm5nYy5jCisrKyBiL2RyaXZlcnMvY2hhci9o
d19yYW5kb20vaW14LXJuZ2MuYwpAQCAtMjY2LDcgKzI2Niw5IEBAIHN0YXRpYyBpbnQgX19pbml0
IGlteF9ybmdjX3Byb2JlKHN0cnVjdCBwbGF0Zm9ybV9kZXZpY2UgKnBkZXYpCiAJaWYgKGlycSA8
IDApCiAJCXJldHVybiBpcnE7CiAKLQljbGtfcHJlcGFyZV9lbmFibGUocm5nYy0+Y2xrKTsKKwly
ZXQgPSBjbGtfcHJlcGFyZV9lbmFibGUocm5nYy0+Y2xrKTsKKwlpZiAocmV0KQorCQlyZXR1cm4g
cmV0OwogCiAJdmVyX2lkID0gcmVhZGwocm5nYy0+YmFzZSArIFJOR0NfVkVSX0lEKTsKIAlybmdf
dHlwZSA9IEZJRUxEX0dFVChSTkdfVFlQRSwgdmVyX2lkKTsKLS0gCjIuNDMuMAo=
