Return-Path: <SRS0=EdI7=3L=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6172BC33CB6
	for <linux-crypto@archiver.kernel.org>; Wed, 22 Jan 2020 10:47:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 321A1205F4
	for <linux-crypto@archiver.kernel.org>; Wed, 22 Jan 2020 10:47:14 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="hxjQD1cO"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730009AbgAVKrG (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 22 Jan 2020 05:47:06 -0500
Received: from mail-wm1-f68.google.com ([209.85.128.68]:36881 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729538AbgAVKpk (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 22 Jan 2020 05:45:40 -0500
Received: by mail-wm1-f68.google.com with SMTP id f129so6638573wmf.2;
        Wed, 22 Jan 2020 02:45:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=5zYX4Jf3SoJmK3XdkNoRVBS9pHpU9EWpsuHkQgGbzAI=;
        b=hxjQD1cOckw3ae6t2qBrX2hWBY6QnRIJrmzY+XWV7qqk0k++mg8OwtTjDFPE4UfFVz
         DeYO22zyfQTVYwhlEmnEvzE/IzFDx2RAb2g9C3sXQnJDCKKr4QVjEkeX+Bvx4x78sCum
         KQlSgLxEnJfAkEtTUnUuVCmF9U5vX0DR+fT5Ufhebh1IVBrwNpd4BhFC7vMgBwoWoO2+
         q67TlsT6augRPFHoaan14pL748i0aMPNCnafZ8vwZbFxH75RRk9H19C4fx5qKUATpoIt
         7g8d0PYCzK/4/+T2mnOpbWmdQJ7InrgjP/nGl03lU6kCK/PpY5CMb0ToYR86w0wJVJHb
         pdHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=5zYX4Jf3SoJmK3XdkNoRVBS9pHpU9EWpsuHkQgGbzAI=;
        b=lAV3dH605JOeOORz+F5k04pHCYOWGiJ2ZHJ0WwvxOK+I9M0nTANcdxWBPgMRVt/M7P
         8NKK2QbT5bCnMdE4Jw8kN+kS7u4aDDsl6JOXR0W6QBFy7kPha2zoZnQfmnRU/ulhBs9F
         AD7G5MSyNacgrzDPHwkF4rCsimKH128VgGEZhzGHk2fbCRFNM9IuJVcwOBaNMt2RWGC4
         M39ahNYlt0Ql/p1vvErUs10c5IzWRNWWe02CeUIvztZFlnzpJYsvy1qmG/qXS72HiZ0S
         wmuBLAqOaF05bcD5dNxI8V+2hMiqwzYq+y+4v62x1lYwEYS7c7vSBlw1Sl22n/AVwnbO
         U0qw==
X-Gm-Message-State: APjAAAWWPLSkb+WoxtlYDBzd1EqfcwuT0bWzINRLkNyWVDFBRCi2Extk
        BvV5aRsJcouBZWBegoIIsrs=
X-Google-Smtp-Source: APXvYqyOWDMb0OEWsOhxrr6+wZfB8A7e90KHh+ZUyDKcI6pFfhr1s5iEfhz9hjgMqOxLSNSkrc+vqA==
X-Received: by 2002:a1c:5945:: with SMTP id n66mr2248657wmb.98.1579689939491;
        Wed, 22 Jan 2020 02:45:39 -0800 (PST)
Received: from Red.localdomain ([2a01:cb1d:3d5:a100:2e56:dcff:fed2:c6d6])
        by smtp.googlemail.com with ESMTPSA id n3sm3443953wmc.27.2020.01.22.02.45.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Jan 2020 02:45:38 -0800 (PST)
From:   Corentin Labbe <clabbe.montjoie@gmail.com>
To:     davem@davemloft.net, herbert@gondor.apana.org.au,
        mripard@kernel.org, wens@csie.org, iuliana.prodan@nxp.com
Cc:     linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-sunxi@googlegroups.com,
        Corentin Labbe <clabbe.montjoie@gmail.com>
Subject: [PATCH 0/9] crypto: engine: permit to handle multiple requests
Date:   Wed, 22 Jan 2020 11:45:19 +0100
Message-Id: <20200122104528.30084-1-clabbe.montjoie@gmail.com>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hello

The sun8i-ce hardware can work on multiple requests in one batch.
For this it use a task descriptor, and chain them.
For the moment, the driver does not use this mechanism and do requests
one at a time and issue an irq for each.

Using the chaining will permit to issue less interrupts, and increase
thoughput.

But the crypto/engine can enqueue lots of requests but can ran them only
one by one.

This serie introduce a way to batch requests in crypto/engine by adding
a new function can_queue_more() that a driver can implement to tell
crypto_engine if it can handle more request.

For testing the serie, the selftest are not enough, since it issue
request one at a time.
I have used LUKS for testing it.
Tested on sun8i-ce (with/without batching).
And tested for non-regression on caam, amlogic and sun8i-ss drivers.

The 4 first patchs are cleanup necessary for permit crypto_engine to
handle more requests.
The 5th patch introduce the new wrappers for handle multiple requests.
Lasts patchs are for enabling batching in sun8i-ce.

Regards

Corentin Labbe (9):
  crypto: engine: workqueue can only be processed one by one
  crypto: engine: get rid of cur_req_prepared
  crypto: engine: get rid of cur_req
  crypto: engine: permit to choose queue length
  crypto: engine: add enqueue_request/can_do_more
  crypto: sun8i-ce: move iv data to request context
  crypto: sun8i-ce: increase task list size
  crypto: sun8i-ce: split into prepare/run/unprepare
  crypto: sun8i-ce: permit to batch requests

 crypto/crypto_engine.c                        |  99 +++++++-----
 .../allwinner/sun8i-ce/sun8i-ce-cipher.c      | 153 ++++++++++++++----
 .../crypto/allwinner/sun8i-ce/sun8i-ce-core.c |  19 ++-
 drivers/crypto/allwinner/sun8i-ce/sun8i-ce.h  |  20 ++-
 include/crypto/engine.h                       |  19 +--
 5 files changed, 213 insertions(+), 97 deletions(-)

-- 
2.24.1

