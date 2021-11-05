Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C58E0C4332F
	for <linux-crypto@archiver.kernel.org>; Fri,  5 Nov 2021 01:50:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B210B61268
	for <linux-crypto@archiver.kernel.org>; Fri,  5 Nov 2021 01:50:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231840AbhKEBwm (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 4 Nov 2021 21:52:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231754AbhKEBwh (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 4 Nov 2021 21:52:37 -0400
Received: from mail-wm1-x336.google.com (mail-wm1-x336.google.com [IPv6:2a00:1450:4864:20::336])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9AA6C061714
        for <linux-crypto@vger.kernel.org>; Thu,  4 Nov 2021 18:49:58 -0700 (PDT)
Received: by mail-wm1-x336.google.com with SMTP id b2-20020a1c8002000000b0032fb900951eso8528483wmd.4
        for <linux-crypto@vger.kernel.org>; Thu, 04 Nov 2021 18:49:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=arista.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=dNwZbIKE8lWneBjLIglBIBwD0K8M5nQ1YwG5fYxV9yQ=;
        b=S6873E77/TJAfAk2C/saKYt/6NEm0CteTcVWlSBIfx1IWNTD7Q8bjsrowiXO88I7S+
         LEH+nrIQC8MQCABpuao3qyBTNN9A278yGM3a1irACwfOGwcc1q+uIqfLfRACZq0tiJzk
         ovBpHKT6QjjaXbDQVDrOPug+/QiRYxUMaM6bdh3UHjaW1FekQyY9xh4+TT6CJHnQs/zO
         H5mJcJFblppVgwfKrU81pamfcy160SDTTyPFBxLoMUtXfhxncvJK1zWzJuWdiBhCelIz
         ahUuGr5fxFkbdaBsh0NRLVDKc13euXGU3uqc4pR8j3wHmfMLsY5I/FhfMNxBYtWo42JB
         0xzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=dNwZbIKE8lWneBjLIglBIBwD0K8M5nQ1YwG5fYxV9yQ=;
        b=iLTWiAKtSyLr9hqbqdM27pGzc/qg5oDzpKCUvqouEBm+ijHxTknIFKgwnSd5ReXVjW
         b7CSkUlN2/6I+BURRrqhwl3h0A9lOHzTooSNNU11JewppIKUraLrqqybYtgCIPwa208c
         RitE9WmQfQGIS8YIeS17gpfCEsYr9DCqerF8mlZho0gDv3Og7BOOMPqN9qHlnu3aB/d8
         V6066TNfD2fWcxPBiImXIuMl+y9ijqDKwrz3aXXVO8Oli2sy11LWVP1uzeBKNB7hP3HB
         7Om+RNfNdlaA/D7AF5/GZzpxKvpIhDX1Z0k6UCjtDlKRZURqA7dsGEmATZwTcO8WGeDr
         6dKQ==
X-Gm-Message-State: AOAM532n1AfWWvDasOZ+YlwUiOG2R4uSxxe526JeYPogpw/LkkQ7wcdw
        /Sg9FVHlWo+2urLln/2NMYob/A==
X-Google-Smtp-Source: ABdhPJyMGEIoev86k8g8uhwR4iMxEaS98FgaftBQIKbdzzTI4hjx8cTbU0bLfu9OlD5UJTes221/6A==
X-Received: by 2002:a05:600c:4f0f:: with SMTP id l15mr9170724wmq.25.1636076997577;
        Thu, 04 Nov 2021 18:49:57 -0700 (PDT)
Received: from localhost.localdomain ([2a02:8084:e84:2480:228:f8ff:fe6f:83a8])
        by smtp.gmail.com with ESMTPSA id c6sm7202421wmq.46.2021.11.04.18.49.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Nov 2021 18:49:57 -0700 (PDT)
From:   Dmitry Safonov <dima@arista.com>
To:     linux-kernel@vger.kernel.org
Cc:     Dmitry Safonov <0x7f454c46@gmail.com>,
        Dmitry Safonov <dima@arista.com>,
        Andy Lutomirski <luto@amacapital.net>,
        David Ahern <dsahern@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Francesco Ruggeri <fruggeri@arista.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Leonard Crestez <cdleonard@gmail.com>,
        linux-crypto@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH 2/5] tcp/md5: Don't leak ahash in OOM
Date:   Fri,  5 Nov 2021 01:49:50 +0000
Message-Id: <20211105014953.972946-3-dima@arista.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211105014953.972946-1-dima@arista.com>
References: <20211105014953.972946-1-dima@arista.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

In quite unlikely scenario when __tcp_alloc_md5sig_pool() succeeded in
crypto_alloc_ahash(), but later failed to allocate per-cpu request or
scratch area ahash will be leaked.
In theory it can happen multiple times in OOM condition for every
setsockopt(TCP_MD5SIG{,_EXT}).

Add a clean-up path to free ahash.

Signed-off-by: Dmitry Safonov <dima@arista.com>
---
 net/ipv4/tcp.c | 16 ++++++++++++----
 1 file changed, 12 insertions(+), 4 deletions(-)

diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index c0856a6af9f5..eb478028b1ea 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -4276,15 +4276,13 @@ static void __tcp_alloc_md5sig_pool(void)
 					       GFP_KERNEL,
 					       cpu_to_node(cpu));
 			if (!scratch)
-				return;
+				goto out_free;
 			per_cpu(tcp_md5sig_pool, cpu).scratch = scratch;
 		}
-		if (per_cpu(tcp_md5sig_pool, cpu).md5_req)
-			continue;
 
 		req = ahash_request_alloc(hash, GFP_KERNEL);
 		if (!req)
-			return;
+			goto out_free;
 
 		ahash_request_set_callback(req, 0, NULL, NULL);
 
@@ -4295,6 +4293,16 @@ static void __tcp_alloc_md5sig_pool(void)
 	 */
 	smp_wmb();
 	tcp_md5sig_pool_populated = true;
+	return;
+
+out_free:
+	for_each_possible_cpu(cpu) {
+		if (per_cpu(tcp_md5sig_pool, cpu).md5_req == NULL)
+			break;
+		ahash_request_free(per_cpu(tcp_md5sig_pool, cpu).md5_req);
+		per_cpu(tcp_md5sig_pool, cpu).md5_req = NULL;
+	}
+	crypto_free_ahash(hash);
 }
 
 bool tcp_alloc_md5sig_pool(void)
-- 
2.33.1

