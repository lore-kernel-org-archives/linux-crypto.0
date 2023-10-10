Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C9823CD68F1
	for <linux-crypto@archiver.kernel.org>; Tue, 10 Oct 2023 06:42:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1442220AbjJJGmu (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 10 Oct 2023 02:42:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1442156AbjJJGmt (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 10 Oct 2023 02:42:49 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2ED1A97
        for <linux-crypto@vger.kernel.org>; Mon,  9 Oct 2023 23:42:48 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BBE80C433C7
        for <linux-crypto@vger.kernel.org>; Tue, 10 Oct 2023 06:42:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1696920167;
        bh=TkTpqC8YTXsLxFwTzSuOwUQEH5VeXl8PhVfR92dFEcs=;
        h=From:To:Subject:Date:From;
        b=HV2nQjBX0N4/CEZDQeMn9IQjuv5kTK5rbLbQgM0s2j/67CVXdO0YSwkC4ohTSgdRq
         G2K14C4UzOfVUhEWUh1DcCaJxIY6nc/NBeSmyqoUgjL3/kGP0UrtbYGsR6kllUNyhE
         9QYmsOxl3/YSM1fwY4afoxr0kmvwPsvKVICZYIkTZXzrHqIFkMEDEqWNdPuYZdH9Ha
         Fev0IhO5kdeswS6mfhgirhhwWHceW4NR9600zu2ObH8b7J04DnQqketJxLbK933tK8
         DYID2N1qPcMCWySUmBryD0NrEhejnNtUjwhkyEDAC5l5jdezMqzFB6sQdk0xBfJbIV
         VY7Vwe6wOa1FQ==
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-crypto@vger.kernel.org
Subject: [PATCH 0/5] crypto: arm64 - clean up backwards function names
Date:   Mon,  9 Oct 2023 23:41:22 -0700
Message-ID: <20231010064127.323261-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.42.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

In the Linux kernel, a function whose name has two leading underscores
is conventionally called by the same-named function without leading
underscores -- not the other way around.  Some of the arm64 crypto code
got this backwards.  Fix it.

Eric Biggers (5):
  crypto: arm64/sha1-ce - clean up backwards function names
  crypto: arm64/sha2-ce - clean up backwards function names
  crypto: arm64/sha512-ce - clean up backwards function names
  crypto: arm64/sha256 - clean up backwards function names
  crypto: arm64/sha512 - clean up backwards function names

 arch/arm64/crypto/sha1-ce-core.S   |  8 ++++----
 arch/arm64/crypto/sha1-ce-glue.c   | 21 ++++++++++----------
 arch/arm64/crypto/sha2-ce-core.S   |  8 ++++----
 arch/arm64/crypto/sha2-ce-glue.c   | 31 +++++++++++++++---------------
 arch/arm64/crypto/sha256-glue.c    | 26 ++++++++++++-------------
 arch/arm64/crypto/sha512-ce-core.S |  8 ++++----
 arch/arm64/crypto/sha512-ce-glue.c | 26 ++++++++++++-------------
 arch/arm64/crypto/sha512-glue.c    | 12 +++++-------
 8 files changed, 69 insertions(+), 71 deletions(-)

base-commit: 8468516f9f93a41dc65158b6428a1a1039c68f20
-- 
2.42.0

