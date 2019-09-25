Return-Path: <SRS0=gkGi=XU=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1B3EAC32793
	for <linux-crypto@archiver.kernel.org>; Wed, 25 Sep 2019 16:14:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E7E712146E
	for <linux-crypto@archiver.kernel.org>; Wed, 25 Sep 2019 16:14:01 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="yF7nxogd"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387908AbfIYQOB (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 25 Sep 2019 12:14:01 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:37510 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388006AbfIYQOA (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 25 Sep 2019 12:14:00 -0400
Received: by mail-wr1-f66.google.com with SMTP id i1so7651741wro.4
        for <linux-crypto@vger.kernel.org>; Wed, 25 Sep 2019 09:13:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=oTkLJDHd3Opt8Q7gQbNEv9bluAfNAUwUozJN7kv8cIw=;
        b=yF7nxogdOddiZ7APJUWvv8ZOZvf7wdIBsXoh5+aa06OqQerRa+w3xtndhPDTvbyeTs
         SxCDjPcJJ5qj5HXRHMljeXqQhUcT5u8DVC/xiVUQWc/xL7+i5gE2JMdr8DvOBarsLX5B
         EawpOjrIVlrozZgzbaV+7ympMMIMlrDR+vcF8xD93tAcRteh3dAQUd6LOhepRf1abFOU
         kJvyoTfNL3aOgWUg9OLo15VCRpFO8RzefWgCE9X6Zu++89AoZlW3h1MyeCH2qsIp0cPV
         P92XYhzshGFCxB/VVpNrKiPnXbbjfbGLkRrHxm15wdGgtvLZ667XLMgIGKtHMIEw6LVd
         7teg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=oTkLJDHd3Opt8Q7gQbNEv9bluAfNAUwUozJN7kv8cIw=;
        b=NFWAPvlOEnRU3ufsXJryyN9+icRPQWfy9oW4RcXrWvf34v/yw6JolvaVJr9Kek4Xgv
         dDIHoJ4ePqLoigR3+wnxkPQ1hnWLHn5mzacU7Nqdsz+ywfNSCUAfQ3MxXbwP/zpkRy29
         SELPAochuazjR68ZGIh6wBTECnp8BrC5bc1AxFudgZ1RfAB7mVIiCth7Mq7SZSg2+EBO
         UhYPmm3tk5E7wszPmQrtDqQsiR3KuNkwxiYC3zmDtRVfmvScrDtcJ/ASdnb3nQ0mYpl2
         /YvwS1dPXB/4zsf7+DDWcP2mUpL0b2ddVLLBYbN/g65qdL9B6m6vISBiU5MAFvOqoF7V
         /JCg==
X-Gm-Message-State: APjAAAWNsR75aOYmjBuv3UyHGfxK+pbN8XFL/zJN/0xJB6cRyzolskrD
        6nXUUtY90U+GTczr/Nxa3Z7V9VCjV4Ouscyu
X-Google-Smtp-Source: APXvYqzc7zDHo2pym+GG6Iqyv/Iy0z/3d/GbL+d0TyOdn6ZMUTam9B5o+BxEoxNyjw7X4aDT9QAIsg==
X-Received: by 2002:adf:afed:: with SMTP id y45mr10259853wrd.347.1569428038355;
        Wed, 25 Sep 2019 09:13:58 -0700 (PDT)
Received: from localhost.localdomain (laubervilliers-657-1-83-120.w92-154.abo.wanadoo.fr. [92.154.90.120])
        by smtp.gmail.com with ESMTPSA id o70sm4991085wme.29.2019.09.25.09.13.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Sep 2019 09:13:57 -0700 (PDT)
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
        Catalin Marinas <catalin.marinas@arm.com>
Subject: [RFC PATCH 08/18] crypto: testmgr - add a chacha20poly1305 test case
Date:   Wed, 25 Sep 2019 18:12:45 +0200
Message-Id: <20190925161255.1871-9-ard.biesheuvel@linaro.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190925161255.1871-1-ard.biesheuvel@linaro.org>
References: <20190925161255.1871-1-ard.biesheuvel@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Add a test case to the RFC7539 (non-ESP) test vector array that
exercises the newly added code path that may optimize away one
invocation of the shash when the assoclen is a multiple of the
Poly1305 block size.

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 crypto/testmgr.h | 45 ++++++++++++++++++++
 1 file changed, 45 insertions(+)

diff --git a/crypto/testmgr.h b/crypto/testmgr.h
index ef7d21f39d4a..5439b37f2b9f 100644
--- a/crypto/testmgr.h
+++ b/crypto/testmgr.h
@@ -18950,6 +18950,51 @@ static const struct aead_testvec rfc7539_tv_template[] = {
 			  "\x22\x39\x23\x36\xfe\xa1\x85\x1f"
 			  "\x38",
 		.clen	= 281,
+	}, {
+		.key	= "\x80\x81\x82\x83\x84\x85\x86\x87"
+			  "\x88\x89\x8a\x8b\x8c\x8d\x8e\x8f"
+			  "\x90\x91\x92\x93\x94\x95\x96\x97"
+			  "\x98\x99\x9a\x9b\x9c\x9d\x9e\x9f",
+		.klen	= 32,
+		.iv	= "\x07\x00\x00\x00\x40\x41\x42\x43"
+			  "\x44\x45\x46\x47",
+		.assoc	= "\x50\x51\x52\x53\xc0\xc1\xc2\xc3"
+			  "\xc4\xc5\xc6\xc7\x44\x45\x46\x47",
+		.alen	= 16,
+		.ptext	= "\x4c\x61\x64\x69\x65\x73\x20\x61"
+			  "\x6e\x64\x20\x47\x65\x6e\x74\x6c"
+			  "\x65\x6d\x65\x6e\x20\x6f\x66\x20"
+			  "\x74\x68\x65\x20\x63\x6c\x61\x73"
+			  "\x73\x20\x6f\x66\x20\x27\x39\x39"
+			  "\x3a\x20\x49\x66\x20\x49\x20\x63"
+			  "\x6f\x75\x6c\x64\x20\x6f\x66\x66"
+			  "\x65\x72\x20\x79\x6f\x75\x20\x6f"
+			  "\x6e\x6c\x79\x20\x6f\x6e\x65\x20"
+			  "\x74\x69\x70\x20\x66\x6f\x72\x20"
+			  "\x74\x68\x65\x20\x66\x75\x74\x75"
+			  "\x72\x65\x2c\x20\x73\x75\x6e\x73"
+			  "\x63\x72\x65\x65\x6e\x20\x77\x6f"
+			  "\x75\x6c\x64\x20\x62\x65\x20\x69"
+			  "\x74\x2e",
+		.plen	= 114,
+		.ctext	= "\xd3\x1a\x8d\x34\x64\x8e\x60\xdb"
+			  "\x7b\x86\xaf\xbc\x53\xef\x7e\xc2"
+			  "\xa4\xad\xed\x51\x29\x6e\x08\xfe"
+			  "\xa9\xe2\xb5\xa7\x36\xee\x62\xd6"
+			  "\x3d\xbe\xa4\x5e\x8c\xa9\x67\x12"
+			  "\x82\xfa\xfb\x69\xda\x92\x72\x8b"
+			  "\x1a\x71\xde\x0a\x9e\x06\x0b\x29"
+			  "\x05\xd6\xa5\xb6\x7e\xcd\x3b\x36"
+			  "\x92\xdd\xbd\x7f\x2d\x77\x8b\x8c"
+			  "\x98\x03\xae\xe3\x28\x09\x1b\x58"
+			  "\xfa\xb3\x24\xe4\xfa\xd6\x75\x94"
+			  "\x55\x85\x80\x8b\x48\x31\xd7\xbc"
+			  "\x3f\xf4\xde\xf0\x8e\x4b\x7a\x9d"
+			  "\xe5\x76\xd2\x65\x86\xce\xc6\x4b"
+			  "\x61\x16\xb3\xb8\x82\x76\x1f\x39"
+			  "\x35\x6f\x26\x8d\x28\x0f\xac\x45"
+			  "\x02\x5d",
+		.clen	= 130,
 	},
 };
 
-- 
2.20.1

