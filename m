Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="JLUZYGk0"
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40B6D479A
	for <linux-crypto@vger.kernel.org>; Mon, 11 Dec 2023 06:00:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1702303199;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=jNtOY4LpZQRmFFwaKjy6gBWig0U9E1fsIgKhcHzr1a8=;
	b=JLUZYGk0tqtYaPJ5kVPbIjFzzfHonixcfZP0yrCmCO8K54K7BensbDTstb4FMgU/QszSQl
	/8X1w74FjmOe5EtlzRd6cR/rfBZxCVy5YanV436wY2/bYOmH5eS0AabyG8IMwtErBLPA9W
	28YNXI2TBVfL9DRSk535gQnFpk827iE=
Received: from mail-pf1-f198.google.com (mail-pf1-f198.google.com
 [209.85.210.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-660-vjNXav4SPFefOL-DTOlDEA-1; Mon, 11 Dec 2023 08:59:57 -0500
X-MC-Unique: vjNXav4SPFefOL-DTOlDEA-1
Received: by mail-pf1-f198.google.com with SMTP id d2e1a72fcca58-6ce6fa748c5so5309529b3a.3
        for <linux-crypto@vger.kernel.org>; Mon, 11 Dec 2023 05:59:57 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1702303197; x=1702907997;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=jNtOY4LpZQRmFFwaKjy6gBWig0U9E1fsIgKhcHzr1a8=;
        b=AVe2VHnt7V0Uf3B8V23eTlpd2Uk+XKcMZmhC67zR/BDVc3S0WDoG3OtZ61hAUnR4aq
         R7hWgQFfQp/XOwihcahCURugEuG/ZjUZRnSbajowD9C1qhQU6f+mpRdCdqnjOa8JiIyd
         hsN6+F44TjcK05CmUsu11s9a1l/TM9kYwYCF81TxvhxAO5OmG6oPvmo3BvumTzbagPun
         NduK6up4VzN2jPRSAo9udNXNiRuM1mKL+tVRqOrsEfO45xytChJV/S8CcPHoCVyiXM/c
         LFP6EbfL8mUpXgv9e88ot0wHzKH5MBm9WxMSTfN6nMOL2cKvhO7qssF00r8b5vO2FJZj
         JkYg==
X-Gm-Message-State: AOJu0YwZte4OQBvEYQCmd8g+Y5YXEucBJ9GddkKwBMJ2kRXjPLoNF8Rh
	GRpm2sTDsz4Q5nufYxSipzGjaAAoc//OOALVfHo+xWAmDkuiIzOViT5KbalcAduhtUQf7j//LgR
	EWFs5L+sdzO4IsaVrsVuQoRXu
X-Received: by 2002:a05:6a00:4b05:b0:6cd:8a19:c324 with SMTP id kq5-20020a056a004b0500b006cd8a19c324mr5065047pfb.3.1702303196833;
        Mon, 11 Dec 2023 05:59:56 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFH8pcpJUYWrPme/AvUNGcFfSPB3UcpRig9J/TmAImLAZ/9Rz5Hmp0l8B3NXjdGvBgSAZW9vA==
X-Received: by 2002:a05:6a00:4b05:b0:6cd:8a19:c324 with SMTP id kq5-20020a056a004b0500b006cd8a19c324mr5065039pfb.3.1702303196506;
        Mon, 11 Dec 2023 05:59:56 -0800 (PST)
Received: from kernel-devel.local ([240d:1a:c0d:9f00:245e:16ff:fe87:c960])
        by smtp.gmail.com with ESMTPSA id ei43-20020a056a0080eb00b006ce6e431292sm6280383pfb.38.2023.12.11.05.59.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 Dec 2023 05:59:56 -0800 (PST)
From: Shigeru Yoshida <syoshida@redhat.com>
To: herbert@gondor.apana.org.au,
	davem@davemloft.net
Cc: dhowells@redhat.com,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Shigeru Yoshida <syoshida@redhat.com>
Subject: [PATCH] crypto: af_alg/hash: Fix uninit-value access in af_alg_free_sg()
Date: Mon, 11 Dec 2023 22:59:49 +0900
Message-ID: <20231211135949.689204-1-syoshida@redhat.com>
X-Mailer: git-send-email 2.41.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

KMSAN reported the following uninit-value access issue:

=====================================================
BUG: KMSAN: uninit-value in af_alg_free_sg+0x1c1/0x270 crypto/af_alg.c:547
 af_alg_free_sg+0x1c1/0x270 crypto/af_alg.c:547
 hash_sendmsg+0x188f/0x1ce0 crypto/algif_hash.c:172
 sock_sendmsg_nosec net/socket.c:730 [inline]
 __sock_sendmsg net/socket.c:745 [inline]
 ____sys_sendmsg+0x997/0xd60 net/socket.c:2584
 ___sys_sendmsg+0x271/0x3b0 net/socket.c:2638
 __sys_sendmsg net/socket.c:2667 [inline]
 __do_sys_sendmsg net/socket.c:2676 [inline]
 __se_sys_sendmsg net/socket.c:2674 [inline]
 __x64_sys_sendmsg+0x2fa/0x4a0 net/socket.c:2674
 do_syscall_x64 arch/x86/entry/common.c:51 [inline]
 do_syscall_64+0x44/0x110 arch/x86/entry/common.c:82
 entry_SYSCALL_64_after_hwframe+0x63/0x6b

Uninit was created at:
 slab_post_alloc_hook+0x103/0x9e0 mm/slab.h:768
 slab_alloc_node mm/slub.c:3478 [inline]
 __kmem_cache_alloc_node+0x5d5/0x9b0 mm/slub.c:3517
 __do_kmalloc_node mm/slab_common.c:1006 [inline]
 __kmalloc+0x118/0x410 mm/slab_common.c:1020
 kmalloc include/linux/slab.h:604 [inline]
 sock_kmalloc+0x104/0x1a0 net/core/sock.c:2681
 hash_accept_parent_nokey crypto/algif_hash.c:418 [inline]
 hash_accept_parent+0xbc/0x470 crypto/algif_hash.c:445
 af_alg_accept+0x1d8/0x810 crypto/af_alg.c:439
 hash_accept+0x368/0x800 crypto/algif_hash.c:254
 do_accept+0x803/0xa70 net/socket.c:1927
 __sys_accept4_file net/socket.c:1967 [inline]
 __sys_accept4+0x170/0x340 net/socket.c:1997
 __do_sys_accept4 net/socket.c:2008 [inline]
 __se_sys_accept4 net/socket.c:2005 [inline]
 __x64_sys_accept4+0xc0/0x150 net/socket.c:2005
 do_syscall_x64 arch/x86/entry/common.c:51 [inline]
 do_syscall_64+0x44/0x110 arch/x86/entry/common.c:82
 entry_SYSCALL_64_after_hwframe+0x63/0x6b

CPU: 0 PID: 14168 Comm: syz-executor.2 Not tainted 6.7.0-rc4-00009-gbee0e7762ad2 #13
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.16.2-1.fc38 04/01/2014
=====================================================

In hash_sendmsg(), hash_alloc_result() may fail and return -ENOMEM if
sock_kmalloc() fails. In this case, hash_sendmsg() jumps to the unlock_free
label and calls af_alg_free_sg() with ctx->sgl.sgt.sgl uninitialized. This
causes the above uninit-value access issue for ctx->sgl.sgt.sgl.

This patch fixes this issue by initializing ctx->sgl.sgt.sgl when the
structure is allocated in hash_accept_parent_nokey().

Fixes: c662b043cdca ("crypto: af_alg/hash: Support MSG_SPLICE_PAGES")
Signed-off-by: Shigeru Yoshida <syoshida@redhat.com>
---
 crypto/algif_hash.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/crypto/algif_hash.c b/crypto/algif_hash.c
index 82c44d4899b9..a51b58d36d60 100644
--- a/crypto/algif_hash.c
+++ b/crypto/algif_hash.c
@@ -419,6 +419,7 @@ static int hash_accept_parent_nokey(void *private, struct sock *sk)
 	if (!ctx)
 		return -ENOMEM;
 
+	ctx->sgl.sgt.sgl = NULL;
 	ctx->result = NULL;
 	ctx->len = len;
 	ctx->more = false;
-- 
2.41.0

