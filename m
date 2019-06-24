Return-Path: <SRS0=EE7o=UX=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 181FDC43613
	for <linux-crypto@archiver.kernel.org>; Mon, 24 Jun 2019 07:38:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E15D92089F
	for <linux-crypto@archiver.kernel.org>; Mon, 24 Jun 2019 07:38:32 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="vuvWawKO"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726632AbfFXHic (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 24 Jun 2019 03:38:32 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:53010 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726077AbfFXHic (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 24 Jun 2019 03:38:32 -0400
Received: by mail-wm1-f66.google.com with SMTP id s3so11725644wms.2
        for <linux-crypto@vger.kernel.org>; Mon, 24 Jun 2019 00:38:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Qk5haYv1+A59FcEkEBkZM43lIkd8QPZ0KTOnGr5KAdY=;
        b=vuvWawKOKrLHbP7A6PkmMFQLHSSl3WCqN3q5XyqVY69xQqwrByzqE/v89OEB/r2XlO
         mVVVf9ihXihb5KFRm5vDLOrwB/WL/QR+iBPLqN6IX9Ytq34pOo/SA8lrImXUaN4d8KVJ
         MUVmtBbGCAHj4S31932kY3Egv7VPhjCiuMboP2mAl8HHTJC98NrDMQv+tIX/oWBCms0x
         XkHkFy3oFrOppCYeSjO6NhCy4oO1wg+HYXI6eXeMr6jAmZqHgJ7F3NkigmsBHJQoLqu0
         wKkRCSLE/8pPHtnxBOYa6fNW/OtvWFhEHfABl+zn57tODQapmaqrutyEHwK0mdRkN66i
         /Fkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Qk5haYv1+A59FcEkEBkZM43lIkd8QPZ0KTOnGr5KAdY=;
        b=k4cfMut6Z9cXyIyPzqFhAel36QD657HXsfd5PI9odJKbDBfysLmjc92RQCOHizphKR
         KimPhvOblgf6uWaQJ9GkBMi0qyl0/POPZscOXpME08s/TZnAY9/TPiU7R17nT2G0xiuP
         J5Vhkl2lu749XUOAVlQ4PiCKV6i9hWax8ilYwvXNL+diWKk7jvZUQdCvpD2AitJN45qv
         dNUoK9zaUeSvjlOJNlGJJmPG15P7oeR8xTvoTpe8a/yKUPfT5idZth8viCmQIZTTblUj
         32Gjj01WGzwnTMPytJt5y9JWz1UmyoPt0eZMMx3XX6RWpeO74/cwVcC3u6Bmg0+pjWxL
         pteQ==
X-Gm-Message-State: APjAAAVp5IUfuTpik4li1dOGaE/9zhINz4m+boQfHzV4Kus8+/ZqSVtD
        0V5TraqQBUrO0q0fa8RiV+IzPre0T73Llw==
X-Google-Smtp-Source: APXvYqz9u3EsP2geCu/tEbvFGgysFsWtzxoqtJlB2Awyrfgqn7pNRWwx1B+WA6QtCqIJEJcqCntpJw==
X-Received: by 2002:a7b:c301:: with SMTP id k1mr13966481wmj.43.1561361910079;
        Mon, 24 Jun 2019 00:38:30 -0700 (PDT)
Received: from sudo.home ([2a01:cb1d:112:6f00:4866:7cdc:a930:8455])
        by smtp.gmail.com with ESMTPSA id 203sm7419280wmc.30.2019.06.24.00.38.29
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 24 Jun 2019 00:38:29 -0700 (PDT)
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
To:     linux-crypto@vger.kernel.org
Cc:     linux-arm-kernel@lists.infradead.org,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Eric Biggers <ebiggers@google.com>,
        Ondrej Mosnacek <omosnace@redhat.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Steve Capper <steve.capper@arm.com>
Subject: [PATCH 1/6] crypto: aegis128 - use unaliged helper in unaligned decrypt path
Date:   Mon, 24 Jun 2019 09:38:13 +0200
Message-Id: <20190624073818.29296-2-ard.biesheuvel@linaro.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190624073818.29296-1-ard.biesheuvel@linaro.org>
References: <20190624073818.29296-1-ard.biesheuvel@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Use crypto_aegis128_update_u() not crypto_aegis128_update_a() in the
decrypt path that is taken when the source or destination pointers
are not aligned.

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 crypto/aegis128.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/crypto/aegis128.c b/crypto/aegis128.c
index d78f77fc5dd1..125e11246990 100644
--- a/crypto/aegis128.c
+++ b/crypto/aegis128.c
@@ -208,7 +208,7 @@ static void crypto_aegis128_decrypt_chunk(struct aegis_state *state, u8 *dst,
 			crypto_aegis_block_xor(&tmp, &state->blocks[1]);
 			crypto_xor(tmp.bytes, src, AEGIS_BLOCK_SIZE);
 
-			crypto_aegis128_update_a(state, &tmp);
+			crypto_aegis128_update_u(state, &tmp);
 
 			memcpy(dst, tmp.bytes, AEGIS_BLOCK_SIZE);
 
-- 
2.20.1

