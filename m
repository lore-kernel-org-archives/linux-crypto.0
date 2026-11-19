Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=135.181.196.210
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795132861;
	b=5e7bnzetJuukCmfOkoRTjF35kdB9kGk02EQBOPJsrwZre4iBSoLqEJFbGcJqMencp0gR
	 NuSTMxgmpWTKuOdQbUBGEC8OtV0O2l0cgnzB9ef/Hx/cRtPh6ujOT8/AAMxpu9faqTOWX
	 R86F3vLha8kACoObktliSHOV/tjpo/txutqzo5XKQKDqgzCfEmdyYjQFO81tMy91GGsl7
	 Iz+yTnOg+mZYBX/zvgCFubewhAMq2A+vI63NHrqP6oHuv0hQP427F/XSIIHSgqilRH21M
	 qu6XCGH84ddPTjmjMuiW8dTJGkYTG/ld8dl4+PSUtiNYWzC/V8K12XXhRTVU/dRD8FQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795132861;
	h=DMARC-Filter:DKIM-Signature:Received:From:Date:Subject:MIME-Version:
	 Content-Type:Content-Transfer-Encoding:Message-Id:X-B4-Tracking:
	 X-Change-ID:To:Cc:X-Mailer:X-Developer-Signature:X-Developer-Key;
	bh=5FJBzUYikHTz9Jwg01bNdUYmr9ueJ0Ev2tfSqj/4shQ=;
	b=Ioac4Ivhx/fpSQM3Td2B0kq48bTnJdq44tElwSww+HKmGa3UkTIIrnbdVp0LcFpk8EbC
	 xdHHWzRaUKJ2CF6funEY1uNHoLpwQrqBo7eMxYC1dXVHphLBd/JJAqUBhJDrFPDFGt99M
	 Hy7s2YlwRIyWe+Gifh4vmWMqtIOCvPEzXMWVDpORqLnqcJdtDkGJm8B3MxVXXgUyt/93V
	 pNbSVDX4zt+LmKuKigwjo6LRJEUAKr7L4zYJhmI9FwncqVQ+OBY0pNYNC0qHGAi244KBu
	 r0/vRibqA1Gs8U/L0DrFcqsmK6d6u2Uq9jXuseZfRCio1RUg5LenbyTU52vfiJbaEkQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=puri.sm;
	spf=pass smtp.mailfrom=puri.sm;
	dkim=pass header.d=puri.sm header.i=@puri.sm header.a=rsa-sha256 header.s=smtp2 header.b=GWdmvqhq;
	arc=none smtp.remote-ip=135.181.196.210
Received: from ms.puri.sm (ms.puri.sm [135.181.196.210])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BB2F606A32C;
	Fri, 20 Nov 2026 00:01:00 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 7BB2F606A32C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=puri.sm
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=puri.sm
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=puri.sm header.i=@puri.sm header.a=rsa-sha256 header.s=smtp2 header.b=GWdmvqhq
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=puri.sm; s=smtp2;
	t=1795132853; bh=SiwjhZMnEdkRN2oANYVb8ccwnFJVVPfeFZQs/1CS3is=;
	h=From:Date:Subject:To:Cc;
	b=GWdmvqhqktMJerRbqIhgH8P6eflIwNH3kL2B/4RlJa9SQ/JDYI0mIb2jOQ8ow/ARg
	 75H0+nzlxU92R9lvuYxAexr6POka6nOtCV0teCCDQmWj4rPETCxvDZQcLvwG/deT66
	 L1F8DFTofKOjH9ODNt3k0kBrrHDW6BU9sGWcs0ZBAqPvJ9Q+gCBHrC0D8Vs4znQUdk
	 FSADZLaqCgMUn9o9tldo/F9BKKI/BjSCyCTuXgfZbv2SMwoK1ajnDxCWGhKx8WD5fh
	 THwfD0YDTUZNeLhhZta6vwftuGqr/gdb99BVlTgIHK3NK/6dYlJ7oRoQwSoFflgqhu
	 D39gHKVoNHt0Q==
Received: from pliszka.localdomain (83.24.14.135.ipv4.supernova.orange.pl [83.24.14.135])
	by ms.puri.sm (Postfix) with ESMTPSA id 6FF661F770;
	Thu, 19 Nov 2026 16:00:52 -0800 (PST)
From: Sebastian Krzyszkowiak <sebastian.krzyszkowiak@puri.sm>
Date: Fri, 20 Nov 2026 00:59:57 +0100
Subject: [PATCH] crypto: caam - handle empty message in ahash_finup_first
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261120-caam-empty-v1-1-d82106209428@puri.sm>
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/z1Py26DMBD8FeRzjQFVSPArVQ7GmYITbMh6qagQ/
 x4bV73tPDV7iACyCKIvDkH4scEuPoL6oxBm0n6EtPeIRVM1bV03lTRaOwm38q/s2s+u0mgroyF
 iYCV82/0q+7plHLbhAcOpITkGHSAH0t5MifLYWTkdGPSXJ7y2uIFzSfYzAX0xMa+hV2q0XD5BH
 nO50KjWbVDBODVbv+0qC8mjru6LleksI/e/wCzOWe6LJMj8Wd2J23m+AaxZ3coPAQAA
X-Change-ID: 20261120-caam-empty-96490ae60cae
To: =?utf-8?q?Horia_Geant=C4=83?= <horia.geanta@nxp.com>, 
 Pankaj Gupta <pankaj.gupta@nxp.com>, 
 Sahil Malhotra <sahil.malhotra@nxp.com>, 
 Herbert Xu <herbert@gondor.apana.org.au>, 
 "David S. Miller" <davem@davemloft.net>
Cc: kernel@puri.sm, linux-crypto@vger.kernel.org, stable@vger.kernel.org, 
 Sebastian Krzyszkowiak <sebastian.krzyszkowiak@puri.sm>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=2459;
 i=sebastian.krzyszkowiak@puri.sm; h=from:subject:message-id;
 bh=SiwjhZMnEdkRN2oANYVb8ccwnFJVVPfeFZQs/1CS3is=;
 b=owEBbQKS/ZANAwAKAejyNc8728P/AcsmYgBq/420fMctKLZ8q5RAt1ZYuFXIEnWduLKmclRe+
 jNgeF5JUUSJAjMEAAEKAB0WIQQi3Z+uAGoRQ1g2YXzo8jXPO9vD/wUCav+NtAAKCRDo8jXPO9vD
 /+5+D/9WRgZ7yFruzo+TOC/w/FVrEQQv+fjuX2QuiPy08qtBgDidocLnXvaRlkVNyzCSsCf7ZpR
 6KqWGj6BBlyRJbGkc70VJxHLFSnZ7O7UY0Nd31IPzjnrgFiSebDB7S/GdF25eFf7VUhrU1dtJRV
 QLEbHGLqTq2LFvoeCbOydAt6vz9F1S1+KRqbF5O4ju15QHPUKU4SyAYm1wdLv6gYeb86ve3SvVW
 KP9eCO+ICPRqBFZPNHyG1PlqBxEL4Z7Zdt5j/FYT63sg0wzXcyDohJrlN33J+J23hOyXfqsgfyL
 oI8FUbePIdYRNlE9uotdGIGvb4E8ahmKVYRuwkLJ28P5eLVYEBeVY+V5/ocGLgd+nYb6GVZiaoF
 qVw2e6zZ/Vf9gCznTqNaWXRPQ5xn12xIFIdUdm/8uOKY15fiv0Q8d0UByCw850VO7btFe8j7vDu
 ZXcF9mOhCq65oPz45sBr6OImvXdHemhkKm4VGUCUHTMnN7SrHPXy+7GDct5/sCdcHJuPbuOrGd2
 giFgJrHyy3sFWrOSyo+lADqjBO3KFxmuZBCcQ1+XCHcEQK+anBgvMQLn/Ie9TEol+Wtjbta0T6b
 ittqDH1akhkf5En3SHpYwidrMgLnqdCx5JCFQ9Ei+GGAEuC4OYnZiYQ4kHPUEg1wJh1ZaNxciXw
 xk8JCbXfQGg6q8A==
X-Developer-Key: i=sebastian.krzyszkowiak@puri.sm; a=openpgp;
 fpr=22DD9FAE006A11435836617CE8F235CF3BDBC3FF

Since commit 9d7a0ab1c753 ("crypto: ahash - Handle partial blocks in API"),
crypto_ahash_final calls crypto_ahash_finup with req->nbytes == 0.
This leads to an oops on an empty message to hash when ahash_edesc_add_src
calls sg_dma_address(req->src) if the caller passes NULL as req->src:

    Unable to handle kernel NULL pointer dereference at virtual
    address 0000000000000010
    Call trace:
     ahash_edesc_add_src+0x40/0x390 (P)
     ahash_digest+0xcc/0x250
     ahash_finup_first+0x18/0x30
     ahash_finup+0x24/0x38
     ahash_do_req_chain+0xc0/0x1b0
     crypto_ahash_finup+0x168/0x200
     hash_recvmsg+0xb0/0x1f0 [algif_hash]

It can be reproduced on i.MX 8M Quad with the following Python snippet:

    import socket
    s = socket.socket(socket.AF_ALG, socket.SOCK_SEQPACKET, 0)
    s.bind(("hash", "sha256"))
    op, _ = s.accept()
    print(op.recv(32).hex())

The oops was observed being triggered by iwd.

ahash_finup_first runs only when nothing has been hashed yet, so handle
the empty-message case by routing it to ahash_final_no_ctx.

Fixes: 9d7a0ab1c753 ("crypto: ahash - Handle partial blocks in API")
Cc: stable@vger.kernel.org
Signed-off-by: Sebastian Krzyszkowiak <sebastian.krzyszkowiak@puri.sm>
---
 drivers/crypto/caam/caamalg_qi2.c | 3 +++
 drivers/crypto/caam/caamhash.c    | 3 +++
 2 files changed, 6 insertions(+)

diff --git a/drivers/crypto/caam/caamalg_qi2.c b/drivers/crypto/caam/caamalg_qi2.c
index ef67122bef57..d449634a9bfb 100644
--- a/drivers/crypto/caam/caamalg_qi2.c
+++ b/drivers/crypto/caam/caamalg_qi2.c
@@ -4331,6 +4331,9 @@ static int ahash_update_first(struct ahash_request *req)
 
 static int ahash_finup_first(struct ahash_request *req)
 {
+	if (!req->nbytes)
+		return ahash_final_no_ctx(req);
+
 	return ahash_digest(req);
 }
 
diff --git a/drivers/crypto/caam/caamhash.c b/drivers/crypto/caam/caamhash.c
index 3cd71810380f..5794c26e0efb 100644
--- a/drivers/crypto/caam/caamhash.c
+++ b/drivers/crypto/caam/caamhash.c
@@ -1499,6 +1499,9 @@ static int ahash_update_first(struct ahash_request *req)
 
 static int ahash_finup_first(struct ahash_request *req)
 {
+	if (!req->nbytes)
+		return ahash_final_no_ctx(req);
+
 	return ahash_digest(req);
 }
 

---
base-commit: d785d132202e8e8e93335ebf74ad5b29fca0951f
change-id: 20261120-caam-empty-96490ae60cae

Best regards,
--  
Sebastian Krzyszkowiak <sebastian.krzyszkowiak@puri.sm>

