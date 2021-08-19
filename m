Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DEE65C4320A
	for <linux-crypto@archiver.kernel.org>; Thu, 19 Aug 2021 12:37:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C767E6023D
	for <linux-crypto@archiver.kernel.org>; Thu, 19 Aug 2021 12:37:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238537AbhHSMh6 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 19 Aug 2021 08:37:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231179AbhHSMh5 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 19 Aug 2021 08:37:57 -0400
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C71DDC061756
        for <linux-crypto@vger.kernel.org>; Thu, 19 Aug 2021 05:37:20 -0700 (PDT)
Received: by mail-pl1-x635.google.com with SMTP id o10so3893039plg.0
        for <linux-crypto@vger.kernel.org>; Thu, 19 Aug 2021 05:37:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=7bTAAAg/tSsrf+D8xI/Og4ucIPc2yXEtddxl3LKJlfo=;
        b=cEXhG+Ao9ul84iqgEzwLvcUXXrwwuMZwPfq0z0giT5U1QbqaMEh+OVWJq46XSj28wF
         DMekvEHMZP3g5KZIyrnoLS9o57GAd+qTwfLHivANfJhQxwoFuv6li0knpUvNdVmRzHr7
         vGK1oMd5hiMNuwBODV7JrR+gw9Ir79RBycTZ5T4d8trSAw7yrmwHGAIkkMha1lIgqiPd
         agrUIInE2IOsJud91iPsQ/NTvwA2Qg8Xr0qm/vGDYBTlx/q0zBToN0HAm7FQH/Dn/IBf
         XWN7HHorrqtYd+QXP3zl0XA7+oD23qMpgiz7ZFxEeA2fAMArJEA/sMO3DfX1cQsAP420
         JnVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=7bTAAAg/tSsrf+D8xI/Og4ucIPc2yXEtddxl3LKJlfo=;
        b=nvBN+n7oJEG8W7Of4OeVzE9GRVkgn3DzgXjbO8tx2RRfZKdtKqTeineO640Fe7Oom1
         3MChQoFvLtRaK2vbY77rm5mr23MwGWGZV/4bZURUHI5GtxfVuhI+lD3UffC/nN3v3Bxs
         LxO1EZx6nx8+ubTIWOHvdbAul+Z2kFWU1Dp9iYvO/WWEJMw4T72YkpbWacY2Smu2x+oi
         wDErNZ58/Um2Uj6j/33CjWU41CzfxQ61y9G8vZwc81JG2Ykh1uY7l7lc49G/yYu5nj1/
         dvBK4RqF49r2FM0pA+ToLYvUmeBACtTebC62FBqNvKHTLD9ajsatEhebZv5wahmp046R
         uzOA==
X-Gm-Message-State: AOAM533ZOmK2WyJtpTb8iCcpSVdSJBA56+rdNzXt/wwbesGCfbTSNwdG
        bKrV/f2ODlVUGxNxIhLCZqAuBg==
X-Google-Smtp-Source: ABdhPJz6i/rouwXLVzKVQ0cKW9jH3P17xaE3a6k7aLKspKYXFi8nENwtkGg3qgU2QrSMrc+N3qBupQ==
X-Received: by 2002:a17:90a:a581:: with SMTP id b1mr4918393pjq.153.1629376640330;
        Thu, 19 Aug 2021 05:37:20 -0700 (PDT)
Received: from libai.bytedance.net ([61.120.150.71])
        by smtp.gmail.com with ESMTPSA id r8sm3859964pgp.30.2021.08.19.05.37.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Aug 2021 05:37:19 -0700 (PDT)
From:   zhenwei pi <pizhenwei@bytedance.com>
To:     jarkko@kernel.org
Cc:     dhowells@redhat.com, herbert@gondor.apana.org.au,
        davem@davemloft.net, keyrings@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        zhenwei pi <pizhenwei@bytedance.com>
Subject: [RESEND] crypto: public_key: fix overflow during implicit conversion
Date:   Thu, 19 Aug 2021 20:37:10 +0800
Message-Id: <20210819123710.1170050-1-pizhenwei@bytedance.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hit kernel warning like this, it can be reproduced by verifying 256
bytes datafile by keyctl command, run script:
RAWDATA=rawdata
SIGDATA=sigdata

modprobe pkcs8_key_parser

rm -rf *.der *.pem *.pfx
rm -rf $RAWDATA
dd if=/dev/random of=$RAWDATA bs=256 count=1

openssl req -nodes -x509 -newkey rsa:4096 -keyout key.pem -out cert.pem \
  -subj "/C=CN/ST=GD/L=SZ/O=vihoo/OU=dev/CN=xx.com/emailAddress=yy@xx.com"

KEY_ID=`openssl pkcs8 -in key.pem -topk8 -nocrypt -outform DER | keyctl \
  padd asymmetric 123 @s`

keyctl pkey_sign $KEY_ID 0 $RAWDATA enc=pkcs1 hash=sha1 > $SIGDATA
keyctl pkey_verify $KEY_ID 0 $RAWDATA $SIGDATA enc=pkcs1 hash=sha1

Then the kernel reports:
 WARNING: CPU: 5 PID: 344556 at crypto/rsa-pkcs1pad.c:540
   pkcs1pad_verify+0x160/0x190
 ...
 Call Trace:
  public_key_verify_signature+0x282/0x380
  ? software_key_query+0x12d/0x180
  ? keyctl_pkey_params_get+0xd6/0x130
  asymmetric_key_verify_signature+0x66/0x80
  keyctl_pkey_verify+0xa5/0x100
  do_syscall_64+0x35/0xb0
  entry_SYSCALL_64_after_hwframe+0x44/0xae

The reason of this issue, in function 'asymmetric_key_verify_signature':
'.digest_size(u8) = params->in_len(u32)' leads overflow of an u8 value,
so use u32 instead of u8 for digest_size field. And reorder struct
public_key_signature, it saves 8 bytes on a 64-bit machine.

Thanks to Jarkko Sakkinen for suggestions.

Signed-off-by: zhenwei pi <pizhenwei@bytedance.com>
---
 include/crypto/public_key.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/crypto/public_key.h b/include/crypto/public_key.h
index 47accec68cb0..f603325c0c30 100644
--- a/include/crypto/public_key.h
+++ b/include/crypto/public_key.h
@@ -38,9 +38,9 @@ extern void public_key_free(struct public_key *key);
 struct public_key_signature {
 	struct asymmetric_key_id *auth_ids[2];
 	u8 *s;			/* Signature */
-	u32 s_size;		/* Number of bytes in signature */
 	u8 *digest;
-	u8 digest_size;		/* Number of bytes in digest */
+	u32 s_size;		/* Number of bytes in signature */
+	u32 digest_size;	/* Number of bytes in digest */
 	const char *pkey_algo;
 	const char *hash_algo;
 	const char *encoding;
-- 
2.25.1

