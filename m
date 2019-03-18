Return-Path: <SRS0=sPcw=RV=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5205CC43381
	for <linux-crypto@archiver.kernel.org>; Mon, 18 Mar 2019 18:27:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2E97D20811
	for <linux-crypto@archiver.kernel.org>; Mon, 18 Mar 2019 18:27:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726788AbfCRS1v (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 18 Mar 2019 14:27:51 -0400
Received: from mx2.suse.de ([195.135.220.15]:48138 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726513AbfCRS1v (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 18 Mar 2019 14:27:51 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 429E5AE00;
        Mon, 18 Mar 2019 18:27:50 +0000 (UTC)
Date:   Mon, 18 Mar 2019 19:27:47 +0100
From:   Petr Vorel <pvorel@suse.cz>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     ltp@lists.linux.it, linux-crypto@vger.kernel.org
Subject: Re: [LTP] [PATCH v2 0/6] ltp: AF_ALG test helpers and a few
 regression tests
Message-ID: <20190318182747.GA5924@dell5510>
Reply-To: Petr Vorel <pvorel@suse.cz>
References: <20190318171327.237014-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190318171327.237014-1-ebiggers@kernel.org>
User-Agent: Mutt/1.11.3 (2019-02-01)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi Eric,

> This series adds helper functions for testing AF_ALG (the userspace
> interface to algorithms in the Linux kernel's crypto API) to the
> Linux Test Project.  It then adds a few sample regression tests.

> I've had these patches sitting around for a while with the goal of also
> writing some "real" tests that test for more than these specific bugs,
> but haven't gotten around to it yet.  And I now consider further
> improving the in-kernel crypto self-tests to be a higher priority.  But
> I figured I'd send this out as-is in case people are interested in
> having this merged, e.g. maybe other people want to add AF_ALG tests to
> LTP too and the 'tst_af_alg' lib would be a good starting point.

> Changed since v1:

>     - Define 'AF_ALG' in include/lapi/socket.h if undefined.
>       Also move 'SOL_ALG' definition to there.
The only minor issue is with missing SOL_ALG on older distros.

Going to push it with this fix including lapi/socket.h on lib/tst_af_alg.c and
testcases/kernel/crypto/af_alg01.c.


Kind regards,
Petr

diff --git lib/tst_af_alg.c lib/tst_af_alg.c
index 5cae85721..9ce1ca471 100644
--- lib/tst_af_alg.c
+++ lib/tst_af_alg.c
@@ -9,6 +9,7 @@
 #define TST_NO_DEFAULT_MAIN
 #include "tst_test.h"
 #include "tst_af_alg.h"
+#include "lapi/socket.h"
 
 int tst_alg_create(void)
 {
diff --git testcases/kernel/crypto/af_alg01.c testcases/kernel/crypto/af_alg01.c
index 1ce0e2508..bb6e01738 100644
--- testcases/kernel/crypto/af_alg01.c
+++ testcases/kernel/crypto/af_alg01.c
@@ -14,6 +14,7 @@
 
 #include "tst_test.h"
 #include "tst_af_alg.h"
+#include "lapi/socket.h"
 
 static void test_with_hash_alg(const char *hash_algname)
 {
