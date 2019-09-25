Return-Path: <SRS0=gkGi=XU=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 84B52C432C2
	for <linux-crypto@archiver.kernel.org>; Wed, 25 Sep 2019 16:14:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 583762146E
	for <linux-crypto@archiver.kernel.org>; Wed, 25 Sep 2019 16:14:15 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="XRKs2NYw"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388451AbfIYQOP (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 25 Sep 2019 12:14:15 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:44534 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388175AbfIYQOO (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 25 Sep 2019 12:14:14 -0400
Received: by mail-wr1-f65.google.com with SMTP id i18so7615066wru.11
        for <linux-crypto@vger.kernel.org>; Wed, 25 Sep 2019 09:14:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=0Jn67cgHpegjUHsejza3rXvNu+oyRcsIfVJ14lUdJdc=;
        b=XRKs2NYw1E8U9jJNC8URLm1v/D0E45ZGzjruLuYncb+se4PRgodkTOSbJKomErYA8A
         aBx3lV2el3sxyCNKIL4eXbNQPuR1xtPQ7AqCKcspizIUydpWF8XSp1d/12gAYylUfZkW
         Vq2CGQalEf6bYg4NWNLgpr4GZbbJ3I7nj8HX65C6pUaO256ht0C6HhxLS98Arc0Bdtbf
         t9NJmmRz17ZRwZ2KtyMCn2begsYmiEYQfixNVxYVzjqwsxv2xGCLr4vQAJz+w5NX5tiV
         0aMtvtcgmSHOgQautTSanq/Mc/wFnViTtqZPwXuEVF+Ycc9wGZRGOk4F+AEA8/eJCIF0
         qasQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=0Jn67cgHpegjUHsejza3rXvNu+oyRcsIfVJ14lUdJdc=;
        b=Tom/C8XZ9BClAXDA4/5iq/ZUjoBr6n9Pqws0R1cBMoe1wHduoyGLYkI8njL9MLrSfL
         Dj7/IC+u9yJEOFHyUgaBxWF5ky1al94kj2UT745bb90DuSu6cWKmBF53iX07QSEmR4PQ
         z6lsqENrrQ3e3qip6VK5+3zEd2wy239/lmSXe5CoyUWmwvFumQXsPz9mEWf5Up5KBB2c
         Kgn1LOV575JJDFeoAbyX6otUHsqIR5v/3QPtghC1KsGZb3/g0I0vLK/OC6fZ++kuOpHc
         urlyVJGFYks66W6vwB51tuOoDwcg/+sbG/H2k/RMWscKHlX1Ht4NvKXl5l0r/iyuEi96
         2AVg==
X-Gm-Message-State: APjAAAXH6a0jrNednA2pWB2THuluQnzUywIItqg3z8UjK1tsEUs93yr9
        QrLbph76jHgAPBeRKKn8ta4mFnfaKhF1tJ04
X-Google-Smtp-Source: APXvYqxG3ZsPD1p2O9Mgdd9cJrxp7TwXatNXcNgf+8foDbIum7T7zIqBBIHsTAaJyjCie+BmcAs/Ug==
X-Received: by 2002:adf:e908:: with SMTP id f8mr9903669wrm.210.1569428052551;
        Wed, 25 Sep 2019 09:14:12 -0700 (PDT)
Received: from localhost.localdomain (laubervilliers-657-1-83-120.w92-154.abo.wanadoo.fr. [92.154.90.120])
        by smtp.gmail.com with ESMTPSA id o70sm4991085wme.29.2019.09.25.09.14.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Sep 2019 09:14:11 -0700 (PDT)
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
To:     linux-crypto@vger.kernel.org
Cc:     linux-arm-kernel@lists.infradead.org,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        David Miller <davem@davemloft.net>,
        Greg KH <gregkh@linuxfoundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "Jason A . Donenfeld" <Jason@zx2c4.com>,
        Samuel Neves <sneves@dei.uc.pt>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Eric Biggers <ebiggers@google.com>,
        Andy Lutomirski <luto@kernel.org>,
        Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Bruno Wolff III <bruno@wolff.to>
Subject: [RFC PATCH 16/18] netlink: use new strict length types in policy for 5.2
Date:   Wed, 25 Sep 2019 18:12:53 +0200
Message-Id: <20190925161255.1871-17-ard.biesheuvel@linaro.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190925161255.1871-1-ard.biesheuvel@linaro.org>
References: <20190925161255.1871-1-ard.biesheuvel@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Taken from
https://git.zx2c4.com/WireGuard/commit/src?id=3120425f69003be287cb2d308f89c7a6a0335ff0

Reported-by: Bruno Wolff III <bruno@wolff.to>
---
 drivers/net/wireguard/netlink.c | 17 ++++++++---------
 1 file changed, 8 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireguard/netlink.c b/drivers/net/wireguard/netlink.c
index 3763e8c14ea5..676d36725120 100644
--- a/drivers/net/wireguard/netlink.c
+++ b/drivers/net/wireguard/netlink.c
@@ -21,8 +21,8 @@ static struct genl_family genl_family;
 static const struct nla_policy device_policy[WGDEVICE_A_MAX + 1] = {
 	[WGDEVICE_A_IFINDEX]		= { .type = NLA_U32 },
 	[WGDEVICE_A_IFNAME]		= { .type = NLA_NUL_STRING, .len = IFNAMSIZ - 1 },
-	[WGDEVICE_A_PRIVATE_KEY]	= { .len = NOISE_PUBLIC_KEY_LEN },
-	[WGDEVICE_A_PUBLIC_KEY]		= { .len = NOISE_PUBLIC_KEY_LEN },
+	[WGDEVICE_A_PRIVATE_KEY]	= { .type = NLA_EXACT_LEN, .len = NOISE_PUBLIC_KEY_LEN },
+	[WGDEVICE_A_PUBLIC_KEY]		= { .type = NLA_EXACT_LEN, .len = NOISE_PUBLIC_KEY_LEN },
 	[WGDEVICE_A_FLAGS]		= { .type = NLA_U32 },
 	[WGDEVICE_A_LISTEN_PORT]	= { .type = NLA_U16 },
 	[WGDEVICE_A_FWMARK]		= { .type = NLA_U32 },
@@ -30,12 +30,12 @@ static const struct nla_policy device_policy[WGDEVICE_A_MAX + 1] = {
 };
 
 static const struct nla_policy peer_policy[WGPEER_A_MAX + 1] = {
-	[WGPEER_A_PUBLIC_KEY]				= { .len = NOISE_PUBLIC_KEY_LEN },
-	[WGPEER_A_PRESHARED_KEY]			= { .len = NOISE_SYMMETRIC_KEY_LEN },
+	[WGPEER_A_PUBLIC_KEY]				= { .type = NLA_EXACT_LEN, .len = NOISE_PUBLIC_KEY_LEN },
+	[WGPEER_A_PRESHARED_KEY]			= { .type = NLA_EXACT_LEN, .len = NOISE_SYMMETRIC_KEY_LEN },
 	[WGPEER_A_FLAGS]				= { .type = NLA_U32 },
-	[WGPEER_A_ENDPOINT]				= { .len = sizeof(struct sockaddr) },
+	[WGPEER_A_ENDPOINT]				= { .type = NLA_MIN_LEN, .len = sizeof(struct sockaddr) },
 	[WGPEER_A_PERSISTENT_KEEPALIVE_INTERVAL]	= { .type = NLA_U16 },
-	[WGPEER_A_LAST_HANDSHAKE_TIME]			= { .len = sizeof(struct __kernel_timespec) },
+	[WGPEER_A_LAST_HANDSHAKE_TIME]			= { .type = NLA_EXACT_LEN, .len = sizeof(struct __kernel_timespec) },
 	[WGPEER_A_RX_BYTES]				= { .type = NLA_U64 },
 	[WGPEER_A_TX_BYTES]				= { .type = NLA_U64 },
 	[WGPEER_A_ALLOWEDIPS]				= { .type = NLA_NESTED },
@@ -44,7 +44,7 @@ static const struct nla_policy peer_policy[WGPEER_A_MAX + 1] = {
 
 static const struct nla_policy allowedip_policy[WGALLOWEDIP_A_MAX + 1] = {
 	[WGALLOWEDIP_A_FAMILY]		= { .type = NLA_U16 },
-	[WGALLOWEDIP_A_IPADDR]		= { .len = sizeof(struct in_addr) },
+	[WGALLOWEDIP_A_IPADDR]		= { .type = NLA_MIN_LEN, .len = sizeof(struct in_addr) },
 	[WGALLOWEDIP_A_CIDR_MASK]	= { .type = NLA_U8 }
 };
 
@@ -591,12 +591,10 @@ static const struct genl_ops genl_ops[] = {
 		.start = wg_get_device_start,
 		.dumpit = wg_get_device_dump,
 		.done = wg_get_device_done,
-		.policy = device_policy,
 		.flags = GENL_UNS_ADMIN_PERM
 	}, {
 		.cmd = WG_CMD_SET_DEVICE,
 		.doit = wg_set_device,
-		.policy = device_policy,
 		.flags = GENL_UNS_ADMIN_PERM
 	}
 };
@@ -608,6 +606,7 @@ static struct genl_family genl_family __ro_after_init = {
 	.version = WG_GENL_VERSION,
 	.maxattr = WGDEVICE_A_MAX,
 	.module = THIS_MODULE,
+	.policy = device_policy,
 	.netnsok = true
 };
 
-- 
2.20.1

