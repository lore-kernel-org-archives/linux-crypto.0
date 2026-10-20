Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=185.125.188.123
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792464886;
	b=ckDBkUmIMYKozaHCepYeLGDK5hgX5qDMJ2rlID2yOeetl+y2llPr5BGaJqgCLAC/LnJw
	 Td87SIq3dks9P+0/rKoBcwWrExa0fXl+ZoGngLARmeWlDklQMH2pdjTS/biCwUWixKiZW
	 4iMURXB7w7oI8Zz9TJa6e/v2rlXhVFLu6IdC6ebfvA+DRRfPisch/4HO/zAwZ5YxkYqqm
	 I2KqPfGzxNUQJfuGs5eYGydLTec8hbkT0FcHF7sVqINdEARP+0kOFJpJS/GstN4GY56qa
	 pFs3TbvXRakl3iuyHkm3wwzeeWfbAYXyRQGGf0MHMZxwGmKinJKN6Pp5bXvdymaFNJA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792464886;
	h=DMARC-Filter:Received:DKIM-Signature:Received:
	 X-Google-DKIM-Signature:X-Forwarded-Encrypted:X-Gm-Message-State:
	 X-Gm-Gg:X-Received:X-Received:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:MIME-Version:Content-Transfer-Encoding;
	bh=qaK8zFu57aq74kEwOz4Te5AP+DwuCrGiq1hirbm0z9E=;
	b=f4Ap+1Vz+2nl+WSVi+YUN1FEhRUsHIR+6wJKEmy2F7OCy1WFWpVviZSnSP15kktgBNA1
	 qR8gdTZreJHtAZyBAaN/PfNc2MJrlIHGFagFfYCABNTGtypvnIDCIyD/eleYzC4X4EGyS
	 0up6ENzkpjXnH5SCQNO9rijGREScbc1BH9/2xNPZX2LJUcRY8Z5l4qoDGaBaN1Ps/2wk5
	 eQfGWo9j8eglbJ720QmCj9R74fHuzItUS6SkFw48M/kMTG5WmuBs1t2HIWIXWusygqEcb
	 Wv+Fo4IkIL+yzs3q8Py7Fs0wjx/DWXXoDP2I+rlt8TikCLi/J4lgSvY18fVedh49XEw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=canonical.com;
	spf=pass smtp.mailfrom=canonical.com;
	dkim=pass header.d=canonical.com header.i=@canonical.com header.a=rsa-sha256 header.s=20251003 header.b=WDwew8nB;
	arc=none smtp.remote-ip=185.125.188.123
Received: from smtp-relay-internal-1.canonical.com (smtp-relay-internal-1.canonical.com [185.125.188.123])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C7B7606A31A
	for <linux-crypto@vger.kernel.org>; Tue, 20 Oct 2026 02:54:44 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 5C7B7606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=canonical.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=canonical.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key, unprotected) header.d=canonical.com header.i=@canonical.com header.a=rsa-sha256 header.s=20251003 header.b=WDwew8nB
Received: from mail-pj1-f70.google.com (mail-pj1-f70.google.com [209.85.216.70])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-relay-internal-1.canonical.com (Postfix) with ESMTPS id 5AA553F98D
	for <linux-crypto@vger.kernel.org>; Tue, 20 Oct 2026 02:54:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
	s=20251003; t=1792464877;
	bh=qaK8zFu57aq74kEwOz4Te5AP+DwuCrGiq1hirbm0z9E=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version;
	b=WDwew8nBjdw0Dz09jSec5KT6hlRnZ9r7AdGFN3SBoyUj/4nb2VsuhcRFpSqa0c8Sd
	 M8oLKH5sPAiK8+iReuCk9IS01ey59+d/nkMUGyEJw7HuQu/wtDa0knpru0xKUh8X9h
	 +h2lwTxTdhggDRQwhDjEq4LrfcCvkyW8YfkT62NQqYO0vt8SQuJSXyVRVB3lAL5C/N
	 1G2v4YDGpSfclTg4zMTaEL8hcNvm8nhBaRCV6w1QNrg/da0hkF3DHGD2tYJgCvG4hB
	 WArEEJHohFXmR+K9lkQOrXgAJnr+n4zixW2uutk4YFBxYKy/A1uOrdz+s3SobWHnmQ
	 wYlCvD7nAGrArJEYXYAPTX3u3ZpiK2Gzc06tbDKfdlMj8lhv5DAx7HiCynTq1oodJQ
	 m89R+dxJFtsmF8osUbbfrB9s/lbN5FmliMtIYcp6v/E5jrqpPXYNlZhr8sOBXfo95i
	 kBtKF1I/TnKKoRASvP5QqDXDwbI/CiH6tNe/zXPDrYoVT9hWMoIOeaMAHAlyFL60iz
	 J6D8xLu2wJeSfzO4Xc7WYhnh6LBAk2MpuBHM89G53/AbaCBoUMy267diXlr44sTy4J
	 SI6Z5y2XXaGH1DAPE51+GUCMjv8CoiuQXrI3KAlhdMNDNDWyKke2jY65snV67THc8T
	 22pTB+zbNzG4+EMuElooQiOE=
Received: by mail-pj1-f70.google.com with SMTP id 98e67ed59e1d1-3ab27eb38d6so2994669a91.2
        for <linux-crypto@vger.kernel.org>; Mon, 19 Oct 2026 19:54:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792464875; x=1793069675;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=qaK8zFu57aq74kEwOz4Te5AP+DwuCrGiq1hirbm0z9E=;
        b=12rZcCW92Y1cnUm19Ydrz7Y4SWQPIsOBDG46wAcs6yZ3dcwXlXMJffdkOvwr2nyC+e
         wTP3J4kgFzxXuzkrDl1G5i49A9VWWBOKcp1tUGBM+YGH+QG6Pr6TMXfUiFpMAOGWHgs9
         bUyH9UEIEtwFPHTnBwik5nD6nMwGPyf61mRhqNzaYnqXvdi0OsCUkO7tBU/oQq0u4XaZ
         PKaB656FRsbgCcK8r1+QQbRSonGMz+nS1yhhyOau0IJJarber+Vm6LSjssJbJA0u4f9B
         6hMnk131yezNioKtSXCW8YjKOhFIdwvYY8+tmsjgODvDo//LSguODqWYRhMABbDlMBbp
         DGGA==
X-Forwarded-Encrypted: i=1; AKwUvBx3+Gv5JRjIDSkUW16hlWSLSrVOY5es+V5XPQh/GOYUX5/H9pTnX0ITWQuamb5UsaEjisYzfH+i7HYV48U=@vger.kernel.org
X-Gm-Message-State: AFq9FYKOB3VDIqdZwK8rYsh8tUi5cGAzE1k+pv32JAnmmG5gn1Y0OXQF
	IVYrKpl7OvhK+NdkZ/1kN4WUAFLS3BJBUj4NRQe7dftuToFl9SwChXp6nDI5kj/Vl4H/S5pjUn7
	TVVK6m8lXtrbZXWxO9dWsPj4m4kEcCfdTUXT5ynyow1gEB4qJUotPZO8VPa0k0ewsSl6e/bV8Yq
	G563a1Dw==
X-Gm-Gg: AYBFou2HLZQ+SKjxOJfXTPuqGeaIxPrlTl0+NOKwsbhHKf+pfNA/jIzKyObL1aI9LwH
	5K+kgQTDnEJ5ngFekg89Q2Cv+nEekC8bjRtG72pAwZDxid7dcWKmtpKt5P8eagKo1rcdtMP6zx7
	vVz50h4Cp54lcnn0iiMzViThHPNKX2KqbVci4dqMiMrclxiJej4aoiuVGEkVOnwKiCbXUBuyCkT
	z8s4KiPfMBUzVFk8L5yDc2YOPuLwfy9nFOYykKMpAXJ9c7DZscEgBwL8VZjeUkdh8WgvRa+vSFX
	vHz5uQrKEJU+4g8xDySFngyA7EmpgxIku3PKbZ+2CkJutpwdFizwrIu7adxqXAKBIKqjs4/BYsG
	9gK4623sJIg==
X-Received: by 2002:a17:90b:28d0:b0:3ac:83c1:2bd with SMTP id 98e67ed59e1d1-3acef13e5ccmr8407893a91.28.1792464875198;
        Mon, 19 Oct 2026 19:54:35 -0700 (PDT)
X-Received: by 2002:a17:90b:28d0:b0:3ac:83c1:2bd with SMTP id 98e67ed59e1d1-3acef13e5ccmr8407884a91.28.1792464874827;
        Mon, 19 Oct 2026 19:54:34 -0700 (PDT)
Received: from ZBook.gateway ([123.208.39.53])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3ad5d5679d5sm1962994a91.7.2026.10.19.19.54.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Oct 2026 19:54:34 -0700 (PDT)
From: Changwei Zou <changwei.zou@canonical.com>
To: herbert@gondor.apana.org.au,
	sahil.malhotra@nxp.com
Cc: davem@davemloft.net,
	horia.geanta@nxp.com,
	pankaj.gupta@nxp.com,
	gaurav.jain@nxp.com,
	jeffbarnes@linux.microsoft.com,
	stephane.debusne@cynove.com,
	iuliana.prodan@nxp.com,
	martin.kepplinger-novakovic@ginzinger.com,
	lukas@wunner.de,
	sahil.malhotra@oss.nxp.com,
	changwei.zou@canonical.com,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v3 0/2] crypto: caam - Fix RSA error-path unmap and unaligned dst buffers
Date: Tue, 20 Oct 2026 13:54:24 +1100
Message-ID: <20261020025426.955531-1-changwei.zou@canonical.com>
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

This series fixes two issues in the rsa-caam driver.

Patch 1 fixes wrong unmap operations where rsa_pub_unmap() was called
regardless of the key type.

Patch 2 adds a bounce buffer to handle unaligned RSA destination
buffers on DMA-incoherent hardware such as i.MX8, fixing intermittent
-EKEYREJECTED errors when loading signed kernel modules.

Changes in v3:
- Patch 1: Dispatch the error-path unmap on the operation (the completion
  callback rsa_pub_done vs rsa_priv_f_done) instead of key->d, so the
  unmap always matches the map.
- Patch 2: Bound the bounce-buffer copy-back to the RSA output size
  (key->n_sz) instead of the full dst_len, so the trailing capacity of
  the caller's destination buffer is left untouched; add Tested-by from
  Stephane Debusne.

Changes in v2:
- Patch 1: Add Fixes: tag; pick up Reviewed-by from Sahil Malhotra.
- Patch 2: Move the !bounce_buf check out of do_rsa_bounce_buf() into
  the caller rsa_bounce_buf_done() so the helper is only entered when a
  bounce buffer actually exists; add Reported-by/Closes and Tested-by
  from Martin Kepplinger-Novakovic.

Link to v2:
https://lore.kernel.org/linux-crypto/20261004210200.290119-1-changwei.zou@canonical.com/

Link to v1:
https://lore.kernel.org/linux-crypto/20260821045555.806471-1-changwei.zou@canonical.com/

Changwei Zou (2):
  crypto: caam - Fix wrong unmap operations
  crypto: caam - Use bounce buffer for unaligned RSA destination buffers

 drivers/crypto/caam/caampkc.c | 130 ++++++++++++++++++++++++++++++----
 drivers/crypto/caam/caampkc.h |   6 ++
 2 files changed, 123 insertions(+), 13 deletions(-)

-- 
2.43.0

