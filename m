Return-Path: <SRS0=SXL7=D3=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3F395C41604
	for <linux-crypto@archiver.kernel.org>; Tue, 20 Oct 2020 20:40:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DE61622256
	for <linux-crypto@archiver.kernel.org>; Tue, 20 Oct 2020 20:40:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2438568AbgJTUkC (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 20 Oct 2020 16:40:02 -0400
Received: from mail-qv1-f67.google.com ([209.85.219.67]:41556 "EHLO
        mail-qv1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2438558AbgJTUkC (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 20 Oct 2020 16:40:02 -0400
Received: by mail-qv1-f67.google.com with SMTP id t20so1609568qvv.8;
        Tue, 20 Oct 2020 13:40:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=fySJMPCABR3H70rEvYBVacbPjL+hPWAsa/DU0+SQkpE=;
        b=ozsZoXq1ZCd04UVJoaS2V2/zwHh9f+FtcFN1RYXXIZO4+6pfT6IJnkgHXFOiVdYp5d
         e8tEiFT/7rrRAH8TTjb7MqTGab92O0EOvEWy0gZgJ9pnpK32JIE8nhzJgsBcCq/OxwHi
         pM3t1k2+X8s3uk3SW4FK/4e87VcBoyVTNNbk26mok3xzaKbxBJQ/Qq7jVBY1EpJXyCo9
         lxSjrFOvaJyhnPUFJnbRHNdGXt7+ojOzjW0QVLSH/+IcYv0NJr8sX8gcNgyeMTeDDG3O
         XydHe1RfBudnJUx+A/Yw1/twzlsQTi9WT3z42NKvmlijOOF0ilqjkXl1/8LkCJfh/LBq
         Qjgg==
X-Gm-Message-State: AOAM532Mm9A0LuNghgKzafCySolAdtcJMduNmdYC96OPeSPAJZu8FhzH
        xD6HiGUlYMra4EDhzJlsroY=
X-Google-Smtp-Source: ABdhPJyt4OYVx3p2QTs6voQLUquQTJV1czab5xLFmamkDBKLU9F04lhH6AIQIveNIE2AZx8bBceQAA==
X-Received: by 2002:a05:6214:180d:: with SMTP id o13mr5310427qvw.34.1603226399526;
        Tue, 20 Oct 2020 13:39:59 -0700 (PDT)
Received: from rani.riverdale.lan ([2001:470:1f07:5f3::b55f])
        by smtp.gmail.com with ESMTPSA id m18sm1411165qkk.102.2020.10.20.13.39.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Oct 2020 13:39:58 -0700 (PDT)
From:   Arvind Sankar <nivedita@alum.mit.edu>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        David Laight <David.Laight@ACULAB.COM>
Cc:     linux-kernel@vger.kernel.org
Subject: [PATCH v2 0/6] crypto: lib/sha256 - cleanup/optimization
Date:   Tue, 20 Oct 2020 16:39:51 -0400
Message-Id: <20201020203957.3512851-1-nivedita@alum.mit.edu>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Patch 1 -- Use memzero_explicit() instead of structure assignment/plain
memset() to clear sensitive state.

Patch 2 -- I am not sure about this one: currently the temporary
variables used in the generic sha256 implementation are cleared, but the
clearing is optimized away due to lack of compiler barriers. I don't
think it's really necessary to clear them, but I'm not a cryptanalyst,
so I would like comment on whether it's indeed safe not to, or we should
instead add the required barriers to force clearing.

The last four patches are optimizations for generic sha256.

v2:
- Add patch to combine K and W arrays, suggested by David
- Reformat SHA256_ROUND() macro a little

Arvind Sankar (6):
  crypto: Use memzero_explicit() for clearing state
  crypto: lib/sha256 - Don't clear temporary variables
  crypto: lib/sha256 - Clear W[] in sha256_update() instead of
    sha256_transform()
  crypto: lib/sha256 - Unroll SHA256 loop 8 times intead of 64
  crypto: lib/sha256 - Unroll LOAD and BLEND loops
  crypto: lib/sha - Combine round constants and message schedule

 include/crypto/sha1_base.h   |   3 +-
 include/crypto/sha256_base.h |   3 +-
 include/crypto/sha512_base.h |   3 +-
 include/crypto/sm3_base.h    |   3 +-
 lib/crypto/sha256.c          | 211 +++++++++++------------------------
 5 files changed, 71 insertions(+), 152 deletions(-)

-- 
2.26.2

