Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0727225FA10
	for <linux-crypto@vger.kernel.org>; Sun, 14 Dec 2025 21:42:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765748557; cv=none; b=Qo6eVcKWAzT3alB/Db2yn3yiPMv691DC+x7FVrsOpaUh+fQQ/wkhzzFks1OBXNut4DKn+EeMLr9tK/6SHTdSfDlzRWbw4TtGFr9XyLeyIDE3ibMtSHkUELlJBj9+syXQ/h2St404UdRTDsz+w5AKbpPWaLs0nNknCu5dCNGdrQE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765748557; c=relaxed/simple;
	bh=oXRAcUtGVzlpNcMwVHhdbmwxH3U1dSuk+X5lnWkjtoM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Aawr25D583RNx8VSEt/rKjuaw/0o3dIL/viKijQtOK0qsjXOv/OZ837gS05rCaN0fL/4qGGvQqKPnfU7Rs+1q1QtEbLLG0N83X7T+jLU/xbFQnWtWyz/fFjEFsLNZDZyX0mpSXjWIJThZITOUU7T+/ExnZfPDgA2pcuQfU/Tgls=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=aUfva+W9; arc=none smtp.client-ip=209.85.214.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="aUfva+W9"
Received: by mail-pl1-f179.google.com with SMTP id d9443c01a7336-2a0d5c365ceso7841925ad.3
        for <linux-crypto@vger.kernel.org>; Sun, 14 Dec 2025 13:42:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1765748555; x=1766353355; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=87NSTu402a5eezjIm5velKw7bOgsKXGr7hCGd3Is6wM=;
        b=aUfva+W9DXeaEHnLKMy7BisdPnoyr/9YVyytbt8z1tMMeEctkdRQpkn/Ki5h9Sw1Jb
         AZbzUfF91f7jhEjxfKIMT0OytF5zMHt7fHpMfrF9Z8Qop2qji7AsRg9kzmD6ZwGc/YN9
         I2jO2rCGgiAFajbGxrHpd9ZDtPmUltVRWD81Gr93cZJBbKI4xy1xoqwQ67q8pLViWUDj
         OzOr+HTVpt8CvrG6H2oxn+XvhA8/YxSYkZ12r57V5NRjr9+n0kSgx3F9NdFV91drL7WR
         vi31yQuMXBbUPrgmBNuoIPgWAHRqg9Cmg+iHNvCoE+pIpxARqVkPTNbOvZYW/9LwmtFK
         yRrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765748555; x=1766353355;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=87NSTu402a5eezjIm5velKw7bOgsKXGr7hCGd3Is6wM=;
        b=oQKdF7NDIQywu0aXemM5BKLWVxIh1ohswJoY6LmrCIgzHDC2eHyhDekWt0oqO4IlR9
         2dDkIv/xTcb5veKJvjhbL0dRCJzDtKnkb8O9MU6xt2mz+hkYQkIAF0HF3aOI+PlgLidI
         tOPIQoUTiBOZB1zJPa+SojBIVXlx6pJo67rtjqZrG3QsUpfsg1uiXMG8bsiTxF0+UdBk
         /DQi+XJebKAW6MVmqAVmmoLny2ibh1Nubqv7g8zvxnqVdE7sClQvIQhy1UcEW2MzJqdt
         hUKJcFK69SjV2buTBP/cGj6qFJ7jwYdcaut4AuKqw4Y+7XwzaMfIkh4h4zuc6z0VoloL
         ERvQ==
X-Gm-Message-State: AOJu0YyM9HfucERkxemGbu4DClB/etwa/PwlrHPA5E5Q3nq6MQtQ26XP
	4KZwIWk7kzZgtjNcRgAk2EEPqBlfy1ihLv8Sf7LAEiDqoo7HYaK8fcLwKiqXHvNQ
X-Gm-Gg: AY/fxX7l7R7+gGA1y2Tiu8FEYfQcTUhSIU+zWTyCx4w1+6x/kZFzHrJhO61JwbG1J/x
	DF9JXHCJkXmjNCqJlyKRRRrIZ+rKAXt3tnQZJ3S3UqWcHVF1wqxQe1VbcQaynLEbG0y5DfLIUot
	rfuQrXSm0kol7CIXdFEB03eGvBJFkf43EXeWUUe2Q66iuQS30STAvODCRcB85Wi2bGHCsA8iOsw
	LPC9ul96csqxv1V135f9Dua/eitGMk+YI6Li9cuICdobso2G8HXMhxNFobaCusUVjsT5WY/UN2+
	rR2r+MD5ahxR5xyJOOdMip9TMNYcRTn+HrAf6sQQxFYaeJr5mGN42hOIQ7sDZCabR0Uu4vKXGOO
	PEo6GEdRdRH1dK44HMRcceh4/992M4rt0dID9rP3bjOXD/sdXeVwxrkBqGjqAlj5ds2kbuO1Azn
	A4zXIbl6jwByvST5Uz/rijIfnHoTrUNl9OdnkrOZ8+suZpD6hGDrk=
X-Google-Smtp-Source: AGHT+IFI0InN4grXWy9p+LmwIdxPbSDN/hJR+n9KnMmibK+jqan7VnWOqpO6hnC2Vpj478m+VlhFkg==
X-Received: by 2002:a05:7022:2490:b0:11f:1e59:4c2d with SMTP id a92af1059eb24-11f349a4815mr6710722c88.7.1765748554850;
        Sun, 14 Dec 2025 13:42:34 -0800 (PST)
Received: from wsfd-netdev58.anl.eng.rdu2.dc.redhat.com ([66.187.232.140])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-11f2e30491dsm40396886c88.16.2025.12.14.13.42.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 14 Dec 2025 13:42:34 -0800 (PST)
From: Xin Long <lucien.xin@gmail.com>
To: linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S . Miller" <davem@davemloft.net>,
	Steffen Klassert <steffen.klassert@secunet.com>
Subject: [PATCH] crypto: seqiv: check req->iv only for synchronous completion
Date: Sun, 14 Dec 2025 16:42:29 -0500
Message-ID: <3c52d1ab5bf6f591c4cc04061e6d35b8830599fd.1765748549.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.47.1
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Xiumei reported a UAF crash when intel_qat is used in ipsec:

[] BUG: KASAN: slab-use-after-free in seqiv_aead_encrypt+0x81a/0x8f0
[] Call Trace:
[]  <TASK>
[]  seqiv_aead_encrypt+0x81a/0x8f0
[]  esp_output_tail+0x706/0x1be0 [esp4]
[]  esp_output+0x4bb/0x9bb [esp4]
[]  xfrm_output_one+0xbac/0x10d0
[]  xfrm_output_resume+0x11e/0xc30
[]  xfrm4_output+0x109/0x460
[]  __ip_queue_xmit+0xc51/0x17f0
[]  __tcp_transmit_skb+0x2555/0x3240
[]  tcp_write_xmit+0x88f/0x3df0
[]  __tcp_push_pending_frames+0x94/0x320
[]  tcp_rcv_established+0x79f/0x3540
[]  tcp_v4_do_rcv+0x4ae/0x8a0
[]  __release_sock+0x29b/0x3b0
[]  release_sock+0x53/0x1d0
[]  tcp_sendmsg+0x35/0x40

[] Allocated by task 7455:
[]  esp_output_tail+0x151/0x1be0 [esp4]
[]  esp_output+0x4bb/0x9bb [esp4]
[]  xfrm_output_one+0xbac/0x10d0
[]  xfrm_output_resume+0x11e/0xc30
[]  xfrm4_output+0x109/0x460
[]  __ip_queue_xmit+0xc51/0x17f0
[]  __tcp_transmit_skb+0x2555/0x3240
[]  tcp_write_xmit+0x88f/0x3df0
[]  __tcp_push_pending_frames+0x94/0x320
[]  tcp_rcv_established+0x79f/0x3540
[]  tcp_v4_do_rcv+0x4ae/0x8a0
[]  __release_sock+0x29b/0x3b0
[]  release_sock+0x53/0x1d0
[]  tcp_sendmsg+0x35/0x40

[] Freed by task 0:
[]  kfree+0x1d5/0x640
[]  esp_output_done+0x43d/0x870 [esp4]
[]  qat_alg_callback+0x83/0xc0 [intel_qat]
[]  adf_ring_response_handler+0x377/0x7f0 [intel_qat]
[]  adf_response_handler+0x66/0x170 [intel_qat]
[]  tasklet_action_common+0x2c9/0x460
[]  handle_softirqs+0x1fd/0x860
[]  __irq_exit_rcu+0xfd/0x250
[]  irq_exit_rcu+0xe/0x30
[]  common_interrupt+0xbc/0xe0
[]  asm_common_interrupt+0x26/0x40

The req allocated in esp_output_tail() may complete asynchronously when
crypto_aead_encrypt() returns -EINPROGRESS or -EBUSY. In this case, the
req can be freed in qat_alg_callback() via esp_output_done(), yet
seqiv_aead_encrypt() still accesses req->iv after the encrypt call
returns:

  if (unlikely(info != req->iv))

There is no guarantee that req remains valid after an asynchronous
submission, and this access will result in this use-after-free.

Fix this by checking req->iv only when the encryption completes
synchronously, and skipping the check for -EINPROGRESS/-EBUSY returns.

Fixes: 856e3f4092cf ("crypto: seqiv - Add support for new AEAD interface")
Reported-by: Xiumei Mu <xmu@redhat.com>
Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 crypto/seqiv.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/crypto/seqiv.c b/crypto/seqiv.c
index 2bae99e33526..94f6f708ff5f 100644
--- a/crypto/seqiv.c
+++ b/crypto/seqiv.c
@@ -23,9 +23,6 @@ static void seqiv_aead_encrypt_complete2(struct aead_request *req, int err)
 	struct aead_request *subreq = aead_request_ctx(req);
 	struct crypto_aead *geniv;
 
-	if (err == -EINPROGRESS || err == -EBUSY)
-		return;
-
 	if (err)
 		goto out;
 
@@ -40,7 +37,8 @@ static void seqiv_aead_encrypt_complete(void *data, int err)
 {
 	struct aead_request *req = data;
 
-	seqiv_aead_encrypt_complete2(req, err);
+	if (err != -EINPROGRESS && err != -EBUSY)
+		seqiv_aead_encrypt_complete2(req, err);
 	aead_request_complete(req, err);
 }
 
@@ -89,7 +87,7 @@ static int seqiv_aead_encrypt(struct aead_request *req)
 	scatterwalk_map_and_copy(info, req->dst, req->assoclen, ivsize, 1);
 
 	err = crypto_aead_encrypt(subreq);
-	if (unlikely(info != req->iv))
+	if (err != -EINPROGRESS && err != -EBUSY && unlikely(info != req->iv))
 		seqiv_aead_encrypt_complete2(req, err);
 	return err;
 }
-- 
2.47.1

