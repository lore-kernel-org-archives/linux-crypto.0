Return-Path: <SRS0=Rknj=QD=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 72C43C282C0
	for <linux-crypto@archiver.kernel.org>; Sun, 27 Jan 2019 09:17:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 391182184E
	for <linux-crypto@archiver.kernel.org>; Sun, 27 Jan 2019 09:17:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=linaro.org header.i=@linaro.org header.b="Xnme5J3X"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726408AbfA0JRP (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 27 Jan 2019 04:17:15 -0500
Received: from mail-wr1-f68.google.com ([209.85.221.68]:34095 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726327AbfA0JRP (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 27 Jan 2019 04:17:15 -0500
Received: by mail-wr1-f68.google.com with SMTP id f7so14667070wrp.1
        for <linux-crypto@vger.kernel.org>; Sun, 27 Jan 2019 01:17:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=nwzFXZp4r2AeZe6qjoqonjhS/92kW8oVNzf0eM9qfFg=;
        b=Xnme5J3XBKZj2C9GAtm2EM2IP1D8wCCO9UcMf8EHhwSUispE0nX5nG1vfJSXMjqqM7
         9EXWJ4lvfkrg0iJCvJg8rLauwN4MNRPKkZQxzUFRJVGoQLzGf0YFKyixbg4+8ZjGvT5F
         QAwmfrZYA+4pogIFw4O3FQry0ezTwenSPBSxE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=nwzFXZp4r2AeZe6qjoqonjhS/92kW8oVNzf0eM9qfFg=;
        b=YdSh1M0pEJ3FS1kX016lAwI8KNoB2YevepSCZaCkFCe8ShWuOMAQI6neLbBA+/vGr9
         fLiOdd7CtXxbzf0jD+KumM4tagVbGbpwQztWzxdxI3SvRcQfkjmwjuSgFqbEgsRx7MX7
         b2IE8KE8p48egDagXDN3noec6hQGF8KbueBo5dRJXJl6fbI66K/Ifpj+lXafR2tYMrUf
         kt772j29DS/YbPmFXR18zvrOBZLcHtDcciv4sdCkEXVfoGQeONBaVdgRdnSziVte957a
         3hPznuaXopKLiAwwpiz298FnellHLWLwQ68k/C2QT3P9OWgvCGyRPSfkCasASDCHSUgN
         rWDw==
X-Gm-Message-State: AJcUuke+lk/YKApvhnpkWuPQ1JPOaqaz6BEp47cU385uVdY6yPaB8b7A
        H9ByCijAsB7h401fpXye3QXMIm/OziI7UQ==
X-Google-Smtp-Source: ALg8bN4y8eIcg+eKB1eoLl20JZAzVtnHOl4UaM/ZqeN8Gcg2T6nujff9G35Ny5VeMdC2+n44DrUlJw==
X-Received: by 2002:adf:aa9c:: with SMTP id h28mr17335102wrc.216.1548580633204;
        Sun, 27 Jan 2019 01:17:13 -0800 (PST)
Received: from sudo.home ([2a01:cb1d:112:6f00:887d:32e9:9391:d3bf])
        by smtp.gmail.com with ESMTPSA id o5sm45397013wrw.46.2019.01.27.01.17.11
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 27 Jan 2019 01:17:12 -0800 (PST)
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
To:     linux-crypto@vger.kernel.org
Cc:     herbert@gondor.apana.org.au, ebiggers@kernel.org,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH v3 0/4] crypto: fix crct10dif for ARM and arm64
Date:   Sun, 27 Jan 2019 10:16:51 +0100
Message-Id: <20190127091655.6262-1-ard.biesheuvel@linaro.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Fix the issues in both NEON implementations of the CRC-T10DIF routines,
that were reported by Eric's new testing code.

v3:
- fix commit log to state 'at least 16 bytes' not 'more than 16 bytes' (#1-#2)
- add Eric's R-b to all patches

v2:
- keep alignment specifiers where possible (#1)
- clarify/fix commit log (#2)
- add fixes/cc-stable/etc tags
- add patches that drop the now unreacheable code (#3 - #4)

Ard Biesheuvel (4):
  crypto: arm/crct10dif - revert to C code for short inputs
  crypto: arm64/crct10dif - revert to C code for short inputs
  crypto: arm/crct10dif - remove dead code
  crypto: arm64/crct10dif - remove dead code

 arch/arm/crypto/crct10dif-ce-core.S   | 27 +++++---------------
 arch/arm/crypto/crct10dif-ce-glue.c   | 23 +++++------------
 arch/arm64/crypto/crct10dif-ce-core.S | 11 --------
 arch/arm64/crypto/crct10dif-ce-glue.c | 25 +++++-------------
 4 files changed, 19 insertions(+), 67 deletions(-)

-- 
2.20.1

