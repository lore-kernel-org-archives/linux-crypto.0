Return-Path: <SRS0=jBdH=UR=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 672BEC31E5B
	for <linux-crypto@archiver.kernel.org>; Tue, 18 Jun 2019 21:28:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2D06D2082C
	for <linux-crypto@archiver.kernel.org>; Tue, 18 Jun 2019 21:28:08 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="zoKcuhnP"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730301AbfFRV2H (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 18 Jun 2019 17:28:07 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:35186 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730102AbfFRV2G (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 18 Jun 2019 17:28:06 -0400
Received: by mail-wr1-f65.google.com with SMTP id m3so1077381wrv.2
        for <linux-crypto@vger.kernel.org>; Tue, 18 Jun 2019 14:28:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=NgQVif3SJzNXiAZCno1M2C2zTfT84Y/U1CUnXY4DVsM=;
        b=zoKcuhnPc6YVnlS3X3fUJX74xIyUsF/Wc3w19VeACAsSP3fFi6sXxOrYahrn4KHoWb
         M4wXn/yuqgZOr4/oxr98AUkEp3V/OlQnzQxj/5NCSiPikL2n62i6k0JH1clAtRtEdhWh
         D2B3Yb/hvBB3wnXKMPBfraXnKPX1XSOdGLz/Vyl3ApnwHXU4nzTqNnzL98gOCJPuuASf
         brEC8unTqTLjtqnIxDWeuOXc+NZRrrKybJRa7I9oTfyQyJ5JhGzpgl3LDyB8d+L8GKo7
         TScSIfSdX1U/dOcgU6Rsny5veX3bsVYUtWP73SPGPTXURai1Pi0D3mhbBlCl7xib8QDd
         j/aA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=NgQVif3SJzNXiAZCno1M2C2zTfT84Y/U1CUnXY4DVsM=;
        b=j5lAfSBsdu24rR2WKc1qOy/7nHZ1bymCWNIvohhAXu6LJzm/tA7ZgAFOlbU4qgZZ1h
         i+foxnIxAPCu4Mxuuv1h9e0C03en+oijXY6D5lYBk83QklZh95WJiarr/rrIJfRzLlK0
         129pOUsAbr4IDKeYeEIxsBpzYl1nJO5N9JyueF6Jdu4ag0n2GYAbWOajP/4xrcGhrgbD
         QhFNrC2GxwqvBn0J3TC+VMPBwskA5vobLnz8kgrZ0+TUeqLSBm3h82A2VZ2wAqYDHRuo
         w1EcxmuqRAbaf15+LJvgJYS2dRme8MzYzbLAb0HIoOHuhR8tQQKKntCKMi/XXiTSZdo0
         Cx3A==
X-Gm-Message-State: APjAAAUM7YH0LYguqBWn3FfYgaSUE4gE/yqajakgik/703vBO7e83zEu
        KElF4yLT9J+q+HLyth1o/VLsDyn65/RslTcs
X-Google-Smtp-Source: APXvYqxCmwvTG3xENPWFv7zECq2kphLnb2KN6MXafy6Nrte3k30uDJ2JFjEDHUMHHdlkW7sQi76feA==
X-Received: by 2002:adf:f442:: with SMTP id f2mr16345724wrp.275.1560893284262;
        Tue, 18 Jun 2019 14:28:04 -0700 (PDT)
Received: from e111045-lin.arm.com (lfbn-nic-1-216-10.w2-15.abo.wanadoo.fr. [2.15.62.10])
        by smtp.gmail.com with ESMTPSA id h21sm2273831wmb.47.2019.06.18.14.28.03
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 18 Jun 2019 14:28:03 -0700 (PDT)
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
To:     linux-crypto@vger.kernel.org
Cc:     Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Eric Biggers <ebiggers@google.com>, dm-devel@redhat.com,
        linux-fscrypt@vger.kernel.org,
        Gilad Ben-Yossef <gilad@benyossef.com>,
        Milan Broz <gmazyland@gmail.com>
Subject: [PATCH v2 0/4]  crypto: switch to crypto API for ESSIV generation
Date:   Tue, 18 Jun 2019 23:27:45 +0200
Message-Id: <20190618212749.8995-1-ard.biesheuvel@linaro.org>
X-Mailer: git-send-email 2.17.1
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

This series creates an ESSIV template that produces a skcipher or AEAD
transform based on a tuple of the form '<skcipher>,<cipher>,<shash>'
(or '<aead>,<cipher>,<shash>' for the AEAD case). It exposes the
encapsulated sync or async skcipher/aead by passing through all operations,
while using the cipher/shash pair to transform the input IV into an ESSIV
output IV.

This matches what both users of ESSIV in the kernel do, and so it is proposed
as a replacement for those, in patches #2 and #4.

This code has been tested using the fscrypt test suggested by Eric
(generic/549), as well as the mode-test script suggested by Milan for
the dm-crypt case. I also tested the aead case in a virtual machine,
but it definitely needs some wider testing from the dm-crypt experts.

Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Eric Biggers <ebiggers@google.com>
Cc: dm-devel@redhat.com
Cc: linux-fscrypt@vger.kernel.org
Cc: Gilad Ben-Yossef <gilad@benyossef.com>
Cc: Milan Broz <gmazyland@gmail.com>

Ard Biesheuvel (4):
  crypto: essiv - create wrapper template for ESSIV generation
  fs: crypto: invoke crypto API for ESSIV handling
  md: dm-crypt: infer ESSIV block cipher from cipher string directly
  md: dm-crypt: switch to ESSIV crypto API template

 crypto/Kconfig              |   4 +
 crypto/Makefile             |   1 +
 crypto/essiv.c              | 624 ++++++++++++++++++++
 drivers/md/Kconfig          |   1 +
 drivers/md/dm-crypt.c       | 237 ++------
 fs/crypto/Kconfig           |   1 +
 fs/crypto/crypto.c          |   5 -
 fs/crypto/fscrypt_private.h |   9 -
 fs/crypto/keyinfo.c         |  88 +--
 9 files changed, 675 insertions(+), 295 deletions(-)
 create mode 100644 crypto/essiv.c

-- 
2.17.1

