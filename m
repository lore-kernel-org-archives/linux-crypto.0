Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.215.181
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793792480;
	b=xtIewpxi/gMcpaIKXeH7/q6ptgOK/lbVtH09xoZPRYuEXCWeeifC/LRZlhzDAihdSUvB
	 02Qr0vUn9TnVLpIZlIiaTwNqp+3LzrgGmowfpxldOTdOzqrEJ65NJ55ItCZxofUBMSqD2
	 nF2uN2wvYsUASwmf0fZnXERHXh0LJBxakUFXXVhIwobAQT+UDFLBMWZ5tNnMUy0N98Zf8
	 2Pb5C625iGBjOSTPosBOm02AVyFreramWgv0ykd+S7ym/tHOFoPvOOXU61p0v5zHO2EgK
	 krTo7TiKQJFPTOu2s0Tsav4dO9XZjQk2F2ptMCHsL7GWjBVWhp67lq86C9qHwyJOIUw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793792480;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:MIME-Version:Content-Transfer-Encoding;
	bh=E2LP6H5UsSB+UFazxVVR2+v0PYB1XW1mXgdBaNKHzKA=;
	b=O5JHQFcX1OgZIvFfDcrvV3hA6fDQI5JMKDor9qJrx5uvUlBZUPtriUsVARMox5LCRVpb
	 6g0mCqnRft3IukBHixA05SFoKLQypgHycZADiHRoG8MngrsdFmC2I1aa9lK+WIerJ5E1B
	 vtfbj2NUks9y0vK7tnQrHfndpuG5/UBVGBDybJ9AgBCDFfs+kqDUm++/brtl3q1Gmcmp0
	 SViajcgVBqmp8Vavb6eAsBtd4ZsdKgvXtT1vVM/8rwBF6AO4UUr3eQAXOmeXVH7paxBhK
	 GYxvre/e/+bbR3VuoxiqkO875bEqgMknYZBPz0ol+zDdePRc1wm5qTjQnXRMqwItf/w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=fkZl7+f6;
	arc=none smtp.remote-ip=209.85.215.181
Received: from mail-pg1-f181.google.com (mail-pg1-f181.google.com [209.85.215.181])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3925A606A31B
	for <linux-crypto@vger.kernel.org>; Wed,  4 Nov 2026 11:41:20 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 3925A606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=fkZl7+f6
Received: by mail-pg1-f181.google.com with SMTP id 41be03b00d2f7-cc4be0e5351so259457a12.0
        for <linux-crypto@vger.kernel.org>; Wed, 04 Nov 2026 03:41:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793792479; x=1794397279; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=E2LP6H5UsSB+UFazxVVR2+v0PYB1XW1mXgdBaNKHzKA=;
        b=fkZl7+f6L4V8arGYXAJZwGtYn1BREVgoRXS8+1r2Wc+nO0ckgQ8+tkvLM4FpgW+Z3O
         pZw5vZw5XPGdNk6oWaM4laOZxstUTknRveNfJyLl2lIArW54xbzOGLaH/TwDlCqBPf2J
         Blo4QSj5zOsZvB+k/h9YviK626EU7dFAp17F68vzTjCLDySdVVKVJKaHk/RFZrkYQNUl
         so46K78oQ1p3b1PTmq2HPIoQdXIr2g9f/0cO2+xLHqSbV74pgJpiggdyLcmQDLW292U2
         59elyZtGnzezqp/pGCtDnYHigwgnDtcsq+LurXBxunpsT3VSVp0wcS7ltJc6k4N8kggQ
         JKOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793792479; x=1794397279;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=E2LP6H5UsSB+UFazxVVR2+v0PYB1XW1mXgdBaNKHzKA=;
        b=hfrH1Itc8w5dz7XCJBHzLLmnshuIRN7oggHnpkuLfmDDXf0Zw8Njy1wiIe+VVPRgHV
         BHplzGBTWRrspSR5XQA/6Pjo1aSVQ//5pETXLIeb4TMOw5E+lC+DOuw2iQ5R7/ofW4k5
         3L8fnAzBmdUT2+NzRk45cTULaQpycWmiVoSw3mAb8MDBe1sHVdKeT8hVsSsBCe0Fgdrm
         02gA6qLm/rI0lqzkIdlIWk0v3FzWdBfQeZXKQIosspzPBX4jArOUfA/SRKATmFDTiGY3
         YzYGkcPJumDGfgd90bw8un3ahYhoDo9bX4VFN8d8yUePOxwUiih2KT5CkIofDHQb65sC
         xXqQ==
X-Gm-Message-State: APuU4Z8b9pUbrWmzjSTMb73DsZTGF4aA0WBXsEvHsrDcIzQV5VHJP0DD
	rTDNDqf+oUVB3Mk3ToUfk705toU2RIf9750xZ8K/rzZPAj9Vm3VbDDijLmaJhw==
X-Gm-Gg: AYBFou1wRQFV6n6yqFHbQ+0Ee9ksWK5GRMNfTRl58ZoXZEpTluTFsBE1t1HhEI+DmiB
	XlZi4lgqxKzILdPBFoGphgtsZ7jojUFj9Lo1pWiOGKYz40UVGZe91T6kVStVrjl31ajLpq+kLGt
	VCybhVwYjj6aNq7875iX529qIV9uiiXdmLJEZSG5MEyLI7jqEK6ubAazWRHZeg28EcYptfeSwQO
	YkJByKio/9GA4c7m1Qi1pyY0gfv8sfRjW33f8HbFytKrwWUt7URCQx/t/fvvMP7gQeAF9hsP2EX
	q5HdoZqHgyo0ngRSawoU3eW7ph+jCJMqusxdaprdZXnXTZSsGfFVKHww2BRutTNKXZn9y+o5rrZ
	TbfzwqbCVyxAdLmcptqKCHvwxU7wu5+2ya9dmNLZMYyyI+3RY7Vq/4RR0p7ZUOK1QX1v7erTv4C
	Az3ze0c7XOSzdfYbs5iwPoEyj1SK7Y6ni6U8dJFRZzQH7JC8m6Jm4ftq33ZYc5xLn/fAFN7qFfV
	dSBfxHimB4AMaWHBAIMkIUv9CUQswJeg+ba9Y3BOR0JSFOwjRSF+lki4jV4d43lNq0uxyrdkfAt
	QtVm2hj7KUvcHNs1VZKlGKgCziNHCNe1AY089KacYzpbrneZ1c/lQeTFp5LnzI/vsioM5N54kKY
	=
X-Received: by 2002:a17:90b:57c5:b0:3ad:eb29:3383 with SMTP id 98e67ed59e1d1-3ae897cc800mr13485965a91.22.1793792479440;
        Wed, 04 Nov 2026 03:41:19 -0800 (PST)
Received: from d.home.yangfl.dn42 ([2a09:bac1:7680:28::4:396])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b093d481a3sm3770036a91.1.2026.11.04.03.41.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Nov 2026 03:41:18 -0800 (PST)
From: David Yang <mmyangfl@gmail.com>
To: linux-crypto@vger.kernel.org
Cc: David Yang <mmyangfl@gmail.com>,
	Olivia Mackall <olivia@selenic.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig=20=28The=20Capable=20Hub=29?= <u.kleine-koenig@baylibre.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Danilo Krummrich <dakr@kernel.org>,
	Takashi Sakamoto <o-takashi@sakamocchi.jp>,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2 0/2] hwrng: histb: fix the FIFO batch timeout
Date: Wed,  4 Nov 2026 19:41:03 +0800
Message-ID: <20261104114108.2378751-1-mmyangfl@gmail.com>
X-Mailer: git-send-email 2.53.0
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

The poll timeout in histb_rng_wait() was derived for a single word, while
the device feeds the FIFO in batches. Fix the timeout, and print with
dev_*() so that the messages name the device.

v2:
 - reword
v1: https://lore.kernel.org/r/20261103041403.4071708-1-mmyangfl@gmail.com

David Yang (2):
  hwrng: histb - fix read timeout
  hwrng: histb - use device messages

 drivers/char/hw_random/histb-rng.c | 20 ++++++++++++++------
 1 file changed, 14 insertions(+), 6 deletions(-)

-- 
2.53.0

