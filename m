Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.215.179
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793160215;
	b=F7iygTAnTuO4PeZhF1Lf8w9kCEIF/hhNyREj/aNhT4vULh3tXvE9e8NJYnTtgl3w4SzY
	 vWBA1J19dXTasZnBy9sFEx6RDzOKArK8JaCksg8RoFLU0P0xGzTT0wFDeX1ZYXiHWRj5Y
	 +CQ09jbB0Q5FmreKE81XDf7Y2W2ctxS90toh4vq+UWHbsXnQvjzokP3pxjnXqG4MM3B+P
	 d+fSdV1f60KwDN2xRs5vzuqQnU2VzDAe6cvVrwMAG3Upxn5uxOoUL/CFzX6A4PXKYDkUr
	 AlAluKTcpKvyzGOJfftVGRXakjajrGIqhP2vC5vkXEjdvFjKMty05vbbc9YRgDlTTmw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793160215;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:To:Cc:Subject:
	 Date:Message-Id:X-Mailer:MIME-Version:Content-Transfer-Encoding;
	bh=Ss8sAz9PIJHTokm5ODohJxcDhK4pxBivWqTZZ7RSTGs=;
	b=NU66jF6lYsLGwfw999wLPRgGkyylgdin04qu5BT/IXWnYA8feEv3UAIWEHj0wzESUSVz
	 +uEfDG8y1Sj45VFQGB8j3AAZrM/nv7dW8nlszKMeJJGU4F9H3EdJW6C+vzl4ckqcwed23
	 At9ShOtQ+voL7adLwhXsZ/nvf0ovzFwxJ3O7PbxhOS4txphfyQC1MxED8Gz/v3ZTUTAnr
	 +DrvOD7Uji2EUZ3IkV++y4IedrejN3KSrxnEUae2c41lL0Ru7qATBk4S9FFzDFGup71LN
	 ZTJ9/T737Lki67qttMOVBs1rHQj4FRbd87hJjq11BdbvmGnY3s5/ExjnxJXuwYByz6A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=YjqQ8V+P;
	arc=none smtp.remote-ip=209.85.215.179
Received: from mail-pg1-f179.google.com (mail-pg1-f179.google.com [209.85.215.179])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B6FE606A31D
	for <linux-crypto@vger.kernel.org>; Wed, 28 Oct 2026 04:03:34 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 2B6FE606A31D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=YjqQ8V+P
Received: by mail-pg1-f179.google.com with SMTP id 41be03b00d2f7-cd69954c755so416586a12.3
        for <linux-crypto@vger.kernel.org>; Tue, 27 Oct 2026 21:03:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793160214; x=1793765014; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=Ss8sAz9PIJHTokm5ODohJxcDhK4pxBivWqTZZ7RSTGs=;
        b=YjqQ8V+PihLHiLVm/7vidbzOKJC1IQpzeS3bR151cQPzMJj9LgbTScD3UXNex8hHAW
         hjqohocsTwoxwpd6wC22hOOZt4yQcUlGYBmS3VW+hMJX+6SbzlF1lpkWj7XKLBAGSMOO
         jOTd2bx2t9PbG2StRSJi3BYp6WXkjhxIyCBbohmuFr+VjltuUa0ijyDkGW6eAsLv/Ee2
         IXuYx+Wteo4MNf3QkRN5FnPw4OGI3daAKtEZhrz7iV6gm71E8I3RZnjQ+Fh4OiNBRrFO
         jNWbofABI/qkjwTrlQ3DIUMNcVBt5LbYbTzZFn89XDykoRq6g1iHCLDeCEsSdbQeSsoH
         T7TQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793160214; x=1793765014;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Ss8sAz9PIJHTokm5ODohJxcDhK4pxBivWqTZZ7RSTGs=;
        b=xnxGV8Phc/u91qwDelg7JZe7PyYgajOcEdbZwETnTq1FlC/6MxpjDK2j7BlMloT826
         OAuO7KnzuZtNakE46RLvFXjsbYg/2ejMD/dAFDW7E1ALLZpu7a2CmPmBaxRnhA0iqoi2
         KlKuiivwqsNWJIbQsJ2YucswmfN1skp/mfUoqGK7Td/fMCLZGzBEEBbEHM/jJZLdeV2U
         b8g6rqkyHBoZIP+Vsqv0Yk3oOALzsHIpOztoUfiGJAn6ZMJD4vdofzjUfNxLuSOArJba
         cFdZmsqQwjtLfdBXXlfz7pGf7DrZRzr2V6UWBpDxbsIdTYrWN/lf3WMGIQowHaJjp6BL
         nnNQ==
X-Gm-Message-State: AFq9FYKuVhIxlui+LikSAT/g6Y8XFoW11ieJ8TCrbLxTYfPDFA+r8rz9
	FEGX0037l14YPC2RHibxkuZOlYaRwkHsZmwwp2vG3JTMDumjCb1Va7SSIWCBTsNL
X-Gm-Gg: AYBFou1wRxLVAmyVV+xU5sdLyX1siq/TDcRdKrCRCUusYpK/Qzwbz8i7okAB3tgImwR
	/b+jt4VQAUHYhrqOtzm/49fjrd6H0Tdd9E88eSlAm7wsGr2z7dla4VvwaAN48sH22hLBJktPPGq
	BgCF6gP94l40Hk3WbP+65Zqbl34qnPzL8/d4T7TOTN/oW+bU91/6E53yCFLb3C+Pbflw/jXWsPR
	RRJNLwtAFmTuAcPq7C6sAbI7TcGavaE58+rzC98HSMKkMAhjnRV4KoO8ruvzQZ07v7CnbBUOFFI
	MdzdJQMyCdzgR7D/vR3zbEBkz9voYre7BvW3sqxZah6Lv5GmxAZOiuOCfSPBbMyqn5LtwW1EN1Q
	RlsV9r/IbogrqEEP01W9QTzYfEVXLHexMDndcqpAccp/TOoFzA1dYC7RwUfYOKRWQTttgOTlOT4
	CIlc3FO1dnaQrVvzYlDqY5eCYQgkbjBoeJuUsifnTTLro24kTC95q6rirdPx7nCxPQpqD3xZz6p
	jkGk0KNc74QOxNJTcIPk2ZExKdAtU/4QOY0hViZyNxr8jBMb/K8S+SEiJ7rWIFg5ihS/JBkeol9
	Ssb9TvSWMgLFg6O80szRRTper7pWdttEkORQ8JICQ/nurCO9Dg==
X-Received: by 2002:a17:90a:ec84:b0:3ad:c4e9:7beb with SMTP id 98e67ed59e1d1-3ae58299f81mr854798a91.43.1793160214292;
        Tue, 27 Oct 2026 21:03:34 -0700 (PDT)
Received: from spiderman.taila3fd8c.ts.net ([202.112.47.77])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3ae5a586662sm930651a91.14.2026.10.27.21.03.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Oct 2026 21:03:34 -0700 (PDT)
From: Li Ximo <lixicaicai@gmail.com>
To: T Pratham <t-pratham@ti.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>
Cc: linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Wang Haoran <haoranwangsec@gmail.com>,
	Li Ximo <lixicaicai@gmail.com>
Subject: [PATCH] crypto: ti - dthev2: fix empty-list wild pointer in dthe_get_dev()
Date: Wed, 28 Oct 2026 12:03:19 +0800
Message-Id: <20261028040319.171479-1-lixicaicai@gmail.com>
X-Mailer: git-send-email 2.25.1
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

From: Wang Haoran <haoranwangsec@gmail.com>

While auditing list_first_entry() users we found that dthe_get_dev()
calls list_first_entry() on the global dthe_dev_list.dev_list without
checking whether the list is empty. list_first_entry() never returns
NULL: on an empty list head->next == head, so container_of() produces
a bogus non-NULL pointer into the static dthe_dev_list structure. The
existing "if (dev_data)" check is therefore dead code - it can never
be false - and list_move_tail(&dev_data->list, ...) then reads and
writes through that wild pointer, corrupting the list head, after
which callers use the bogus pointer for engine/MMIO accesses.

The empty list is reachable because dthe_remove() removes the device
from the list (list_del) before unregistering the crypto algorithms
(dthe_unregister_algs). On single-device SoCs the list is empty from
that point on, while the algorithms remain registered, so a new
tfm (ctx->dev_data not yet cached) can still reach dthe_get_dev() and
perform the lookup on the empty list. K3 DTHE is a platform device, so
unbind/remove is enough to open this window.

Fix this with two changes: switch dthe_get_dev() to
list_first_entry_or_null(), which makes the existing NULL check
effective and returns NULL when no device is registered; and reorder
dthe_remove() to unregister the algorithms before removing the device
from the list, mirroring the probe order (list_add before
dthe_register_algs) and preventing new requests from being dispatched
once the device is gone. This was found by code audit; we do not have
K3 hardware to reproduce it.

Note that the nine dthe_get_dev() call sites in dthev2-aes.c do not
check for a NULL return. With the remove() reordering the empty-list
window is closed, so the NULL return is purely defensive; adding NULL
checks to the callers may nevertheless be a worthwhile follow-up.

Reported-by: Wang Haoran <haoranwangsec@gmail.com>
Reported-by: Li Ximo <lixicaicai@gmail.com>
Signed-off-by: Wang Haoran <haoranwangsec@gmail.com>
---
 drivers/crypto/ti/dthev2-common.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/crypto/ti/dthev2-common.c b/drivers/crypto/ti/dthev2-common.c
index ba6cde75d..099c0b923 100644
--- a/drivers/crypto/ti/dthev2-common.c
+++ b/drivers/crypto/ti/dthev2-common.c
@@ -39,7 +39,8 @@ struct dthe_data *dthe_get_dev(struct dthe_tfm_ctx *ctx)
 		return ctx->dev_data;
 
 	spin_lock_bh(&dthe_dev_list.lock);
-	dev_data = list_first_entry(&dthe_dev_list.dev_list, struct dthe_data, list);
+	dev_data = list_first_entry_or_null(&dthe_dev_list.dev_list,
+					    struct dthe_data, list);
 	if (dev_data)
 		list_move_tail(&dev_data->list, &dthe_dev_list.dev_list);
 	spin_unlock_bh(&dthe_dev_list.lock);
@@ -200,12 +201,12 @@ static void dthe_remove(struct platform_device *pdev)
 {
 	struct dthe_data *dev_data = platform_get_drvdata(pdev);
 
+	dthe_unregister_algs();
+
 	spin_lock(&dthe_dev_list.lock);
 	list_del(&dev_data->list);
 	spin_unlock(&dthe_dev_list.lock);
 
-	dthe_unregister_algs();
-
 	crypto_engine_exit(dev_data->engine);
 
 	dma_release_channel(dev_data->dma_aes_rx);
-- 
2.30.2

