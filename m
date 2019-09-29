Return-Path: <SRS0=xDoY=XY=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 17354C352A9
	for <linux-crypto@archiver.kernel.org>; Sun, 29 Sep 2019 17:39:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E79F921D7B
	for <linux-crypto@archiver.kernel.org>; Sun, 29 Sep 2019 17:39:52 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="P+Wm3k9f"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730508AbfI2Rjv (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 29 Sep 2019 13:39:51 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:45507 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729378AbfI2Rjv (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 29 Sep 2019 13:39:51 -0400
Received: by mail-wr1-f66.google.com with SMTP id r5so8403054wrm.12
        for <linux-crypto@vger.kernel.org>; Sun, 29 Sep 2019 10:39:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=c7gRGregGvO6OT7bIf1xMnSekX73Q+P1Ihexxh5ywF4=;
        b=P+Wm3k9f1uAZZ/SNB31mpqeYK+eLX9OOI/5HnTmGYLG/xEEAABkB/ZkELx4gYu5Xbm
         xldLa/dGsozZm59dGU6mkT7mvdpDFMBGyt1bbgnMcEqMcS29+mRSylfBG0FjJzwEMUGX
         FMtpZXCK3CBaBp+BQSps4Faghk44UqFofjft3yyoUIbliBjWho4gNp0ojvLTyWC/bA7A
         ra0eCjtILW2dNCvVIg4dk4eIuBhzR8eav+cmNFwC7rjwLalcp7riVGbINgoBXKU33lRZ
         Ac//reNGK2z4JfmWjPs5eZWxnc9dCrFXU4DYb8j1HQZlk4bUUCxfw/6/pVuqeJJ9Rwn8
         VfMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=c7gRGregGvO6OT7bIf1xMnSekX73Q+P1Ihexxh5ywF4=;
        b=ZMQ4TAFG4e4o9/I5yt8JwzTMzeXG3ETmgdH7rNBGX8qDrRDNp/z1OXf6exW9bsRguE
         wSnbaNQLi6ybftO/i/uoMJEAHiZe/IZ+sCO694Zbv5NinwheMxaQnHRFIyW5/539EloO
         BUhiis2ruD2JhPP3jixSajPNYC4x2W+DM+QFL8rZ1r9xb051+eWexBBdG3gnmQH84aVw
         yXjDJQYFb4znpin6Qv8E8XlAWhdCZf783uVzi5+WgklEQkCFy9W0qfHFEbYvDyKKJuzW
         9UCJ9I6q08qZB/1n5dLsp3x4OvEa8Qpt3xxXR0EDXnuY2maZHjaNQLj1v2a3aogxirFn
         JydQ==
X-Gm-Message-State: APjAAAW5RyP1LKZlbPpcevIa0L40J1w9HLptJyKudwdbxP0VEk/eW9A/
        m9NOgwLG0E0/+AKjN3Y1zG8Tc5Ni5sy1Sc/Z
X-Google-Smtp-Source: APXvYqy9WWMhyZeEe+zBtNm2oB+VpCOYYMVVcZe2utYKqYu/+9/fbSSAPJvP2S5GFAGrlLBCyjUyjA==
X-Received: by 2002:a5d:620d:: with SMTP id y13mr9891717wru.86.1569778789010;
        Sun, 29 Sep 2019 10:39:49 -0700 (PDT)
Received: from e123331-lin.nice.arm.com (bar06-5-82-246-156-241.fbx.proxad.net. [82.246.156.241])
        by smtp.gmail.com with ESMTPSA id q192sm17339779wme.23.2019.09.29.10.39.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 29 Sep 2019 10:39:47 -0700 (PDT)
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
        Martin Willi <martin@strongswan.org>
Subject: [RFC PATCH 19/20] netlink: use new strict length types in policy for 5.2
Date:   Sun, 29 Sep 2019 19:38:49 +0200
Message-Id: <20190929173850.26055-20-ard.biesheuvel@linaro.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190929173850.26055-1-ard.biesheuvel@linaro.org>
References: <20190929173850.26055-1-ard.biesheuvel@linaro.org>
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
2.17.1

