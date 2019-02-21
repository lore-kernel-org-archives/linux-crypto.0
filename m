Return-Path: <SRS0=2gc/=Q4=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.2 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9346BC43381
	for <linux-crypto@archiver.kernel.org>; Thu, 21 Feb 2019 05:31:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4F736218C3
	for <linux-crypto@archiver.kernel.org>; Thu, 21 Feb 2019 05:31:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1550727063;
	bh=1ftmgs3bemtUx0kfjQiRxztsKdzHbGQrKC7sf+hRos0=;
	h=From:To:Cc:Subject:Date:List-ID:From;
	b=C6LnsE5K+G7Yn+tF5wYoqdpRiY8Z+B4k5D82zzh+rjkiFsa7/B+VG4ID1SDwN4iqJ
	 RCh0Xctde0ht+dXhhxehFtzK72HOQpaQiK5nBJSHmnAHtRr1aqM/YTJeGLC5M81Vmf
	 6N67vnmNh5S02rmGas2mQl9yD1pra/+NEADsfnjU=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725858AbfBUFbC (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 21 Feb 2019 00:31:02 -0500
Received: from mail.kernel.org ([198.145.29.99]:58294 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725648AbfBUFbC (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 21 Feb 2019 00:31:02 -0500
Received: from sol.localdomain (c-107-3-167-184.hsd1.ca.comcast.net [107.3.167.184])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EFBAA2147A;
        Thu, 21 Feb 2019 05:31:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1550727062;
        bh=1ftmgs3bemtUx0kfjQiRxztsKdzHbGQrKC7sf+hRos0=;
        h=From:To:Cc:Subject:Date:From;
        b=fJ7KplKbxJjJnZnzy5KG7j/h1ZFFWoIYBWIJGeDKTs6ncAQx4Nb5rz1P9fwdf6FRh
         wWfFpitsOWgdtBvm6SVKITlQzbpzo8be+Oz5VvLN3Zz4CAEdnk13A7JNEmZSQ58Wii
         72MScfK78I2afecuwo8SkgAIJFz9mx0j5nIRBKNg=
From:   Eric Biggers <ebiggers@kernel.org>
To:     ltp@lists.linux.it
Cc:     linux-crypto@vger.kernel.org
Subject: [PATCH 0/6] ltp: AF_ALG test helpers and a few regression tests
Date:   Wed, 20 Feb 2019 21:30:20 -0800
Message-Id: <20190221053026.18489-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.20.1
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

Eric Biggers (6):
  lib: add tst_af_alg lib
  crypto/af_alg01: new regression test for hmac nesting bug
  crypto/af_alg02: new regression test for salsa20 empty message bug
  crypto/af_alg03: new regression test for rfc7539 hash alg validation
  crypto/af_alg04: new regression test for vmac race conditions
  crypto/af_alg05: new regression test for skcipher_walk error bug

 configure.ac                       |   1 +
 include/lapi/if_alg.h              |  40 ++++++++
 include/tst_af_alg.h               | 136 ++++++++++++++++++++++++++
 lib/tst_af_alg.c                   | 147 +++++++++++++++++++++++++++++
 runtest/cve                        |   2 +
 testcases/kernel/crypto/.gitignore |   5 +
 testcases/kernel/crypto/af_alg01.c |  79 ++++++++++++++++
 testcases/kernel/crypto/af_alg02.c |  29 ++++++
 testcases/kernel/crypto/af_alg03.c |  31 ++++++
 testcases/kernel/crypto/af_alg04.c |  56 +++++++++++
 testcases/kernel/crypto/af_alg05.c |  43 +++++++++
 11 files changed, 569 insertions(+)
 create mode 100644 include/lapi/if_alg.h
 create mode 100644 include/tst_af_alg.h
 create mode 100644 lib/tst_af_alg.c
 create mode 100644 testcases/kernel/crypto/af_alg01.c
 create mode 100644 testcases/kernel/crypto/af_alg02.c
 create mode 100644 testcases/kernel/crypto/af_alg03.c
 create mode 100644 testcases/kernel/crypto/af_alg04.c
 create mode 100644 testcases/kernel/crypto/af_alg05.c

-- 
2.20.1

