Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C6447C43217
	for <linux-crypto@archiver.kernel.org>; Mon, 20 Dec 2021 22:53:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232589AbhLTWxq (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 20 Dec 2021 17:53:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232509AbhLTWxp (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 20 Dec 2021 17:53:45 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED417C06173E;
        Mon, 20 Dec 2021 14:53:44 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A85C1B810D9;
        Mon, 20 Dec 2021 22:53:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE766C36AE9;
        Mon, 20 Dec 2021 22:53:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1640040822;
        bh=cCvAYvimTasxgt3WRJv5uzSW80vJgzjktDsVsO5OmRE=;
        h=From:To:Cc:Subject:Date:From;
        b=sP5WkXfFG4W3iXiaKIJU4jPhK0XOWNyoX43xjboNGUMb9j3B/cTcW0GlXNAQddWsi
         4imsj62J/cR3MmmMRt8oIWj8j8oX9EH6fTeX9vFWNIugCYnqdtVDOyLVzpAgHLwPTu
         01RxFCfHDJWrqflpX0bnj6e+YSLR8z4Ljg1CVZUOG3pbZszz5C4hqCy7cPO0LE6G4q
         rDzxigl5LTFlz6+J3bZ3U5bR42M7uH3QHxfnMnmtbFhNk1Ek+vYuazFkCQlMb9ZMlR
         GITqKuwGwR9mbhMgSsw1rtvxo0ULy7QRyIOwWFJPJQ3ahHAVKl1dHTk2VUrpLN29OO
         eypNYUo5fpdPg==
From:   Eric Biggers <ebiggers@kernel.org>
To:     Theodore Ts'o <tytso@mit.edu>,
        "Jason A . Donenfeld " <Jason@zx2c4.com>
Cc:     linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
        "Paul E . McKenney" <paulmck@kernel.org>
Subject: [PATCH v2 0/2] random: fix some data races
Date:   Mon, 20 Dec 2021 16:41:55 -0600
Message-Id: <20211220224157.111959-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

This series fixes some data races in random.c.

Changed v1 => v2:
   - Remove unneeded 'inline' keywords
   - Use READ_ONCE() instead of smp_load_acquire()
   - Updated commit message
   - Added patch to fix data race on crng init time

Eric Biggers (2):
  random: fix data race on crng_node_pool
  random: fix data race on crng init time

 drivers/char/random.c | 61 +++++++++++++++++++++++--------------------
 1 file changed, 33 insertions(+), 28 deletions(-)

-- 
2.34.1

