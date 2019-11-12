Return-Path: <SRS0=Y60y=ZE=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DCD3EC43331
	for <linux-crypto@archiver.kernel.org>; Tue, 12 Nov 2019 10:20:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BCFB521D7F
	for <linux-crypto@archiver.kernel.org>; Tue, 12 Nov 2019 10:20:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727185AbfKLKUd (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 12 Nov 2019 05:20:33 -0500
Received: from mx2.suse.de ([195.135.220.15]:56680 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726212AbfKLKUc (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 12 Nov 2019 05:20:32 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 61789B40A;
        Tue, 12 Nov 2019 10:20:31 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id A1FD1DA7AF; Tue, 12 Nov 2019 11:20:35 +0100 (CET)
From:   David Sterba <dsterba@suse.com>
To:     linux-crypto@vger.kernel.org
Cc:     ebiggers@kernel.org, David Sterba <dsterba@suse.com>
Subject: [PATCH v2 0/7] BLAKE2b cleanups
Date:   Tue, 12 Nov 2019 11:20:23 +0100
Message-Id: <cover.1573553665.git.dsterba@suse.com>
X-Mailer: git-send-email 2.23.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi,

the patchset implements cleanups suggested by Eric in
https://lore.kernel.org/linux-crypto/20191025051550.GA103313@sol.localdomain/

The diff is almost the same, split into pieces with some additional
comments where it would help understand the simplifications. This is
based on v7 of the BLAKE2b patchset.

The self-tests have been run for each patch on x86_64.

V2:
- rename digest_setkey to blake2b_setkey, this is in patch 7 that also
  does a rename, to avoid a too-trivial separate patch
- minor withespace fix in patch 6

David Sterba (7):
  crypto: blake2b: merge _final implementation to callback
  crypto: blake2b: merge blake2 init to api callback
  crypto: blake2b: simplify key init
  crypto: blake2b: delete unused structs or members
  crypto: blake2b: open code set last block helper
  crypto: blake2b: merge _update to api callback
  crypto: blake2b: rename tfm context and _setkey callback

 crypto/blake2b_generic.c | 279 ++++++++++++---------------------------
 1 file changed, 82 insertions(+), 197 deletions(-)

-- 
2.23.0

