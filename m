Return-Path: <SRS0=jBdH=UR=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BCDCBC31E5D
	for <linux-crypto@archiver.kernel.org>; Tue, 18 Jun 2019 09:32:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9602F206B7
	for <linux-crypto@archiver.kernel.org>; Tue, 18 Jun 2019 09:32:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="dxRxqplD"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729406AbfFRJcZ (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 18 Jun 2019 05:32:25 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:33296 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729220AbfFRJcY (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 18 Jun 2019 05:32:24 -0400
Received: by mail-wm1-f65.google.com with SMTP id h19so1860989wme.0
        for <linux-crypto@vger.kernel.org>; Tue, 18 Jun 2019 02:32:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=uoXN0FMlnCUpKu8imJJI+ugif3yVx1vilVzoC6zQYtE=;
        b=dxRxqplD6Zfbb3Hp0XNyUCxyslkEl2gBsG8ZzNJl+E+Fy0rIZbK4Mpfwllp/cfqPD8
         P2soYlureqG3MP757/bHuyPVAnUlcfG09FdHa4XM5DeAJR//kGf4e+AnukNU7Rfx3nVG
         q1sa392gND3elQEVt7twNPpZZxdVA86wOB4NH3vjGP6+3UXBS0a9D4DBpf7J6EWaj/To
         4tNjZ5nJLlChKa05JX5O0I/2QJvlUMD0CuqQoUCDlCFjDQUJraZpITjJcW2b1+Nj3kDR
         ETzkrR2fQyOrR9lnvuP2cNLmMNib8yd3gWQnPOXB/YyksxXbRfjz1vbNnFO9T+2tOATU
         t1jw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=uoXN0FMlnCUpKu8imJJI+ugif3yVx1vilVzoC6zQYtE=;
        b=LxuobBQpcTTZfLyR/FXMxtFl1Dv9ioCZJXhKJ8QK86aJ3wT/LXeEdDimHD6bBM4ynW
         ekVKoL15Ko9IKiRbq1gmdPLijZmgcrHHU0Wrms3svfki2rulr1znEKedZagO4SQFwY7G
         ZSbbAAySB7t2kCs1V6kMzlL1TuYInlSRsm6bWKdR1NcVHjc5is66/IUTY7tIeCsAHXs6
         6P+WIXwSfLfAtxSRphchljzqLxeMItZlkyGMk0fsfK7pYK+b4NPgxufPvMuCHZCNZ8wX
         jnXheZlGfkzcPoGI/jNOKKCFZ4Ok6j5N8JdADdH54IIL2VjNXF+uV5m3adtZdgSVLDIq
         ilxg==
X-Gm-Message-State: APjAAAUSxPNLieyndEGCMZ9G+sL7j1upu9jqE7p6YxxWE2PozaLUO060
        Elz0ZWEczu8sDrRunv/H8IBOQw==
X-Google-Smtp-Source: APXvYqynweZQ417+bPZXKGYxSPB0gSxGojFa7Ep9w3PBtpqmepqATNENbwmZ/TT4f1MFsaRI9xbcyQ==
X-Received: by 2002:a1c:3942:: with SMTP id g63mr2375742wma.61.1560850342398;
        Tue, 18 Jun 2019 02:32:22 -0700 (PDT)
Received: from sudo.home ([2a01:cb1d:112:6f00:c97b:2293:609c:ae03])
        by smtp.gmail.com with ESMTPSA id y1sm1517104wma.32.2019.06.18.02.32.21
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 18 Jun 2019 02:32:21 -0700 (PDT)
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
To:     netdev@vger.kernel.org
Cc:     Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Eric Biggers <ebiggers@kernel.org>,
        linux-crypto@vger.kernel.org, herbert@gondor.apana.org.au,
        edumazet@google.com, davem@davemloft.net, kuznet@ms2.inr.ac.ru,
        yoshfuji@linux-ipv6.org, jbaron@akamai.com, cpaasch@apple.com,
        David.Laight@aculab.com, ycheng@google.com
Subject: [PATCH 2/2] net: fastopen: use endianness agnostic representation of the cookie
Date:   Tue, 18 Jun 2019 11:32:07 +0200
Message-Id: <20190618093207.13436-3-ard.biesheuvel@linaro.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190618093207.13436-1-ard.biesheuvel@linaro.org>
References: <20190618093207.13436-1-ard.biesheuvel@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Use an explicit little endian representation of the fastopen
cookie, so that the value no longer depends on the endianness
of the system. This fixes a theoretical issue only, since
fastopen keys are unlikely to be shared across load balancing
server farms that are mixed in endiannes, but it might pop up
in validation/selftests as well, so let's just settle on little
endian across the board.

Note that this change only affects big endian systems.

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 include/linux/tcp.h     |  2 +-
 net/ipv4/tcp_fastopen.c | 16 ++++++++--------
 2 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/include/linux/tcp.h b/include/linux/tcp.h
index 3d3659c638a6..f3a85a7fb4b1 100644
--- a/include/linux/tcp.h
+++ b/include/linux/tcp.h
@@ -58,7 +58,7 @@ static inline unsigned int tcp_optlen(const struct sk_buff *skb)
 
 /* TCP Fast Open Cookie as stored in memory */
 struct tcp_fastopen_cookie {
-	u64	val[DIV_ROUND_UP(TCP_FASTOPEN_COOKIE_MAX, sizeof(u64))];
+	__le64	val[DIV_ROUND_UP(TCP_FASTOPEN_COOKIE_MAX, sizeof(u64))];
 	s8	len;
 	bool	exp;	/* In RFC6994 experimental option format */
 };
diff --git a/net/ipv4/tcp_fastopen.c b/net/ipv4/tcp_fastopen.c
index 61c15c3d3584..2704441a0bb0 100644
--- a/net/ipv4/tcp_fastopen.c
+++ b/net/ipv4/tcp_fastopen.c
@@ -123,10 +123,10 @@ static bool __tcp_fastopen_cookie_gen_cipher(struct request_sock *req,
 	if (req->rsk_ops->family == AF_INET) {
 		const struct iphdr *iph = ip_hdr(syn);
 
-		foc->val[0] = siphash(&iph->saddr,
-				      sizeof(iph->saddr) +
-				      sizeof(iph->daddr),
-				      key);
+		foc->val[0] = cpu_to_le64(siphash(&iph->saddr,
+					  sizeof(iph->saddr) +
+					  sizeof(iph->daddr),
+					  key));
 		foc->len = TCP_FASTOPEN_COOKIE_SIZE;
 		return true;
 	}
@@ -134,10 +134,10 @@ static bool __tcp_fastopen_cookie_gen_cipher(struct request_sock *req,
 	if (req->rsk_ops->family == AF_INET6) {
 		const struct ipv6hdr *ip6h = ipv6_hdr(syn);
 
-		foc->val[0] = siphash(&ip6h->saddr,
-				      sizeof(ip6h->saddr) +
-				      sizeof(ip6h->daddr),
-				      key);
+		foc->val[0] = cpu_to_le64(siphash(&ip6h->saddr,
+					  sizeof(ip6h->saddr) +
+					  sizeof(ip6h->daddr),
+					  key));
 		foc->len = TCP_FASTOPEN_COOKIE_SIZE;
 		return true;
 	}
-- 
2.17.1

