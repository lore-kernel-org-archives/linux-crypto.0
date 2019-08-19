Return-Path: <SRS0=LpGJ=WP=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CDE33C3A5A0
	for <linux-crypto@archiver.kernel.org>; Mon, 19 Aug 2019 14:22:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A13AD20651
	for <linux-crypto@archiver.kernel.org>; Mon, 19 Aug 2019 14:22:30 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="Fzb/ft5n"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726028AbfHSOW3 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 19 Aug 2019 10:22:29 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:53041 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726935AbfHSOW3 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 19 Aug 2019 10:22:29 -0400
Received: by mail-wm1-f68.google.com with SMTP id o4so1798565wmh.2
        for <linux-crypto@vger.kernel.org>; Mon, 19 Aug 2019 07:22:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=PugF/khGc++UobH1xigOCuI7JbK9qCa/EKqEGByRJRU=;
        b=Fzb/ft5nGpUaHHxIAvT13NCjBo86kQICK7LGGiczPOiObAmTUfRWmQdFcGoDz5rVAv
         e75NVMZufZNgJcLSCaalbU5QxV3w2uLA21z9/G3K2C3egqGTQqhYfljN4/iiBuoIONE1
         xroek9zBQQN6Sp38EmjCAaudQ06dtG4R+qUL3lBYeztjO2FARCBLSKDsxI/SpqnZDcUN
         EZ3mk6VL0cvl4O+DcRVh1EIOCU7W/2mUxyoZOgGd6Ww9BzPiv2W5phftJVHMGk/jOVV3
         Yx2KK7eTmyWo9GRCSQSV6gVs07x8WtAYFA+8vzft/TgFJ4+npsIg8Idfjv871m1/eG8W
         uobA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=PugF/khGc++UobH1xigOCuI7JbK9qCa/EKqEGByRJRU=;
        b=uZBYF8W9ozdkvv6A6LMzl8TXNHQXRKOiJ1VyZTDCYGoVhzuJ1lM4Zz0NVLjr2XTsIV
         WeNF8n5EExYWkybnon4P+eNn1wnrwnLcq9P4MDmt85t7FFEuheCzygC1AqwlVZ/bCgCN
         DvLxoSv+xMHreIOw5cmegqor3g/ncotWI6Vg+Sc1nKlAjcM6rjAd4emZTFs6rWlFqy5t
         BmwmQ02uu2MInZjX9fVVnwJ4+0LxpBdpL6e+YDU3XTCKWvxqUWTrlEgrOdsIEREKB/+m
         vJ3QFdvE1zpv4u8XAx9N5eGiT2T2fhkR+f9lpBYBAiUwdA/c72Q/5PUmt9r6nI1HZZPn
         /bPg==
X-Gm-Message-State: APjAAAUb61ooVW8w1CAv2F/NLxW/DKOdt3Sxo1bpd0dFQ8kp/C6M1Ekq
        2rnXte23Y12hXSbVFQGRIjjc3WB2bzFv2g==
X-Google-Smtp-Source: APXvYqyyDSK++hWJZPoyNGbwoPY0194tL8S7EInbScrh9+gVW9c9VjbBJLY/pjYdMveWUf17b1c2nA==
X-Received: by 2002:a1c:7606:: with SMTP id r6mr20234780wmc.118.1566224547164;
        Mon, 19 Aug 2019 07:22:27 -0700 (PDT)
Received: from localhost.localdomain (11.172.185.81.rev.sfr.net. [81.185.172.11])
        by smtp.gmail.com with ESMTPSA id o17sm13643356wrx.60.2019.08.19.07.22.23
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 19 Aug 2019 07:22:26 -0700 (PDT)
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
To:     linux-crypto@vger.kernel.org
Cc:     herbert@gondor.apana.org.au,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Vladimir Zapolskiy <vz@mleia.com>,
        Kamil Konieczny <k.konieczny@partner.samsung.com>,
        linux-samsung-soc@vger.kernel.org
Subject: [PATCH 0/2] drivers/crypto - s5p fixes
Date:   Mon, 19 Aug 2019 17:22:24 +0300
Message-Id: <20190819142226.1703-1-ard.biesheuvel@linaro.org>
X-Mailer: git-send-email 2.17.1
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Fix a couple of issues in the s5p crypto driver that were caught in fuzz
testing.

Cc: Krzysztof Kozlowski <krzk@kernel.org>
Cc: Vladimir Zapolskiy <vz@mleia.com>
Cc: Kamil Konieczny <k.konieczny@partner.samsung.com>
Cc: linux-samsung-soc@vger.kernel.org

Ard Biesheuvel (2):
  crypto: s5p - deal gracefully with bogus input sizes
  crypto: s5p - use correct block size of 1 for ctr(aes)

 drivers/crypto/s5p-sss.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

-- 
2.17.1

