Return-Path: <SRS0=zZ2Z=US=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 12B62C43613
	for <linux-crypto@archiver.kernel.org>; Wed, 19 Jun 2019 21:28:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DAAFF2166E
	for <linux-crypto@archiver.kernel.org>; Wed, 19 Jun 2019 21:28:05 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="KPt+kATM"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730574AbfFSV2E (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 19 Jun 2019 17:28:04 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:53955 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726230AbfFSV2E (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 19 Jun 2019 17:28:04 -0400
Received: by mail-wm1-f66.google.com with SMTP id x15so924104wmj.3
        for <linux-crypto@vger.kernel.org>; Wed, 19 Jun 2019 14:28:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=2W+A8exQdTLW2o/0GNC5h3yhth+mAF462dKpVE0akAo=;
        b=KPt+kATM0pNRSxDxTYwGPefvmQU9t7J7bsC+3A3g/U5Mj89z8dRxUMsb/AkxX8jSOW
         ra/zd3KFE0bcd4xTrpuFPudTXz/nrJyJ8mVzYYIlItjbyJc9r8IumkGxh+GhRELWpba2
         6/ISjeN9QEY9vTiIeqZ0d8C8qy5yZBiMjXw5/PTsR418SUFfkszAMzFhNdfyj+zig4s9
         LtqCCVmv9GxLRV8aEKz3NtHTDAUntfWfpr6S+pJ8uq5O1CDPtSIN/U6P1lWHSdHeDdG2
         79g8VeGyeqtnSn5F4+eeQJApe/4ZjEvk+q9jXPF2GcUXYHEzPS0Y8RaKw/wC7quaRPLr
         K6rg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=2W+A8exQdTLW2o/0GNC5h3yhth+mAF462dKpVE0akAo=;
        b=b6aE5x8th5Qnk9fatgpgyOx6FLfNsQ/vIMQEbLdhKuAL2J3vQGqDfVU+t6OFPi5EIV
         E2rElPM7R0ugQt+P8xc7PmSmfBgiHj+wKOgLZ/kNQJATxHJInbgVPSb5W6IcElX5ZlOT
         q6Cxk4y5PAoTGfoDtkqgrTJd02QQzhODoHqwnXLOfapKbnW8tSpJbZ29qXWBzfUwrwgy
         681RvFRiGH5qu33qOpqskYkDiWr8IREjKu5jVZUj1l+1eDiQzneBSu/VCyeRhRfE22s5
         D6Zh/n70v4FrCXkmSjt9PBMXiLIMzV8EKW55GHobl74n4VQ/sz68GuSZbT/Fl+SSRkT0
         I4Mw==
X-Gm-Message-State: APjAAAUqiHOldbLF2dX9yRDK5W6grPxj5mEr0OnnyKFQ1XnLfpWZ+oVk
        yUnPqmhQtSWtDc+SvJw6BwFS8Q==
X-Google-Smtp-Source: APXvYqyxUgE++9OcJ5aJ72TNsTVML/ORHguL1JiMQxHDKyoU+EBRxgAojh853qZXoQpVy0TqDIKmzg==
X-Received: by 2002:a1c:dc45:: with SMTP id t66mr10179970wmg.63.1560979682493;
        Wed, 19 Jun 2019 14:28:02 -0700 (PDT)
Received: from e111045-lin.arm.com (lfbn-nic-1-216-10.w2-15.abo.wanadoo.fr. [2.15.62.10])
        by smtp.gmail.com with ESMTPSA id e21sm24975786wra.27.2019.06.19.14.28.00
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Wed, 19 Jun 2019 14:28:01 -0700 (PDT)
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
To:     netdev@vger.kernel.org
Cc:     Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Eric Biggers <ebiggers@kernel.org>,
        linux-crypto@vger.kernel.org, herbert@gondor.apana.org.au,
        edumazet@google.com, davem@davemloft.net, kuznet@ms2.inr.ac.ru,
        yoshfuji@linux-ipv6.org, jbaron@akamai.com, cpaasch@apple.com,
        David.Laight@aculab.com, ycheng@google.com
Subject: [PATCH net-next v3 0/1] net: fastopen: follow-up tweaks for SipHash switch
Date:   Wed, 19 Jun 2019 23:27:46 +0200
Message-Id: <20190619212747.25773-1-ard.biesheuvel@linaro.org>
X-Mailer: git-send-email 2.17.1
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Some fixes for the fastopen code after switching to SipHash, which were
spotted in review after the change had already been queued.

Changes since v2:
- add missing pairs of braces in compound literals used to assign the
  fastopen keys

cc: Eric Biggers <ebiggers@kernel.org>
cc: linux-crypto@vger.kernel.org
cc: herbert@gondor.apana.org.au
cc: edumazet@google.com
cc: davem@davemloft.net
cc: kuznet@ms2.inr.ac.ru
cc: yoshfuji@linux-ipv6.org
cc: jbaron@akamai.com
cc: cpaasch@apple.com
cc: David.Laight@aculab.com
cc: ycheng@google.com

Ard Biesheuvel (1):
  net: fastopen: robustness and endianness fixes for SipHash

 include/linux/tcp.h        |  2 +-
 include/net/tcp.h          |  8 ++--
 net/ipv4/sysctl_net_ipv4.c |  3 +-
 net/ipv4/tcp.c             |  3 +-
 net/ipv4/tcp_fastopen.c    | 39 +++++++++++---------
 5 files changed, 28 insertions(+), 27 deletions(-)

-- 
2.17.1

