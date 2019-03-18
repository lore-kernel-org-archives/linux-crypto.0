Return-Path: <SRS0=sPcw=RV=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C9AECC43381
	for <linux-crypto@archiver.kernel.org>; Mon, 18 Mar 2019 17:14:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9C385217F5
	for <linux-crypto@archiver.kernel.org>; Mon, 18 Mar 2019 17:14:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1552929263;
	bh=snIRfIjtFalm5inQ4LXZtt+Pr6EEa5ZmFds/LDoe4uQ=;
	h=From:To:Cc:Subject:Date:List-ID:From;
	b=NwM9DZmRC20Z91el6Iiz8cr65gLsWTjwe/rG55tDFsnQnXGAJHFOOHgDVjpAEKWb/
	 2HZNcE/six48sNPuejOWD56XQRLcdezKe4/OopAXzTAwvNB2CO4ikJZxbm/PZWc9NL
	 g6rhqa/IOrOHOuxHlyrEUiuBWvU03hvjGcjFRz0g=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726835AbfCRROW (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 18 Mar 2019 13:14:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:34438 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726626AbfCRROW (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 18 Mar 2019 13:14:22 -0400
Received: from ebiggers-linuxstation.mtv.corp.google.com (unknown [104.132.1.77])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DB64620863;
        Mon, 18 Mar 2019 17:14:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1552929262;
        bh=snIRfIjtFalm5inQ4LXZtt+Pr6EEa5ZmFds/LDoe4uQ=;
        h=From:To:Cc:Subject:Date:From;
        b=HhYi1HKEcyiGNGxDbjDjFC+3xcA4NvLPHlX2OFmVkjvhwgYwI2r/0OeiFeJI2lpF+
         wXxWHnmq+kFSqLV922LzsLrHQHJUDTqtt7KpThOsI7GNOkOAdblEGBPl9m9jCeA7ML
         Nb5HUw/ClPLZueQeNrKp6spVIf+oRXRpkxpx+Hv0=
From:   Eric Biggers <ebiggers@kernel.org>
To:     ltp@lists.linux.it
Cc:     linux-crypto@vger.kernel.org
Subject: [PATCH v2 0/6] ltp: AF_ALG test helpers and a few regression tests
Date:   Mon, 18 Mar 2019 10:13:21 -0700
Message-Id: <20190318171327.237014-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.21.0.225.g810b269d1ac-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hello,

This series adds helper functions for testing AF_ALG (the userspace
interface to algorithms in the Linux kernel's crypto API) to the
Linux Test Project.  It then adds a few sample regression tests.

I've had these patches sitting around for a while with the goal of also
writing some "real" tests that test for more than these specific bugs,
but haven't gotten around to it yet.  And I now consider further
improving the in-kernel crypto self-tests to be a higher priority.  But
I figured I'd send this out as-is in case people are interested in
having this merged, e.g. maybe other people want to add AF_ALG tests to
LTP too and the 'tst_af_alg' lib would be a good starting point.

Changed since v1:

    - Define 'AF_ALG' in include/lapi/socket.h if undefined.
      Also move 'SOL_ALG' definition to there.

    - Add all new tests to runtest/crypto.

    - In af_alg01, use .test() and .tcnt rather than a 'for' loop.

    - Consistently use 'algfd' rather than 'alg_fd', and similarly for reqfd.

    - Make two error messages in tst_af_alg.c clearer.

    - Add SPDX license identifier to include/lapi/if_alg.h.

Eric Biggers (6):
  lib: add tst_af_alg lib
  crypto/af_alg01: new regression test for hmac nesting bug
  crypto/af_alg02: new regression test for salsa20 empty message bug
  crypto/af_alg03: new regression test for rfc7539 hash alg validation
  crypto/af_alg04: new regression test for vmac race conditions
  crypto/af_alg05: new regression test for skcipher_walk error bug

 configure.ac                       |   1 +
 include/lapi/if_alg.h              |  38 ++++++++
 include/lapi/socket.h              |   8 ++
 include/tst_af_alg.h               | 136 ++++++++++++++++++++++++++
 lib/tst_af_alg.c                   | 147 +++++++++++++++++++++++++++++
 runtest/crypto                     |   5 +
 runtest/cve                        |   2 +
 testcases/kernel/crypto/.gitignore |   5 +
 testcases/kernel/crypto/af_alg01.c |  78 +++++++++++++++
 testcases/kernel/crypto/af_alg02.c |  29 ++++++
 testcases/kernel/crypto/af_alg03.c |  31 ++++++
 testcases/kernel/crypto/af_alg04.c |  56 +++++++++++
 testcases/kernel/crypto/af_alg05.c |  43 +++++++++
 13 files changed, 579 insertions(+)
 create mode 100644 include/lapi/if_alg.h
 create mode 100644 include/tst_af_alg.h
 create mode 100644 lib/tst_af_alg.c
 create mode 100644 testcases/kernel/crypto/af_alg01.c
 create mode 100644 testcases/kernel/crypto/af_alg02.c
 create mode 100644 testcases/kernel/crypto/af_alg03.c
 create mode 100644 testcases/kernel/crypto/af_alg04.c
 create mode 100644 testcases/kernel/crypto/af_alg05.c

-- 
2.21.0.225.g810b269d1ac-goog

