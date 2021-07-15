Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-21.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT,
	USER_IN_DEF_DKIM_WL autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 91F12C636C9
	for <linux-crypto@archiver.kernel.org>; Thu, 15 Jul 2021 21:31:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7240B61380
	for <linux-crypto@archiver.kernel.org>; Thu, 15 Jul 2021 21:31:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230354AbhGOVeq (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 15 Jul 2021 17:34:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230293AbhGOVep (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 15 Jul 2021 17:34:45 -0400
Received: from mail-qk1-x749.google.com (mail-qk1-x749.google.com [IPv6:2607:f8b0:4864:20::749])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 921DAC06175F
        for <linux-crypto@vger.kernel.org>; Thu, 15 Jul 2021 14:31:50 -0700 (PDT)
Received: by mail-qk1-x749.google.com with SMTP id h12-20020a05620a400cb02903b8e915ccceso1471925qko.18
        for <linux-crypto@vger.kernel.org>; Thu, 15 Jul 2021 14:31:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=+0CqKbStwjYWWb/ryAHBHEWWcIXAfliOA3KIW2RGcrc=;
        b=plB8GojpEEkoNTKH3F9DdwVbb84EzvTN2m4GMmtRucpxcGFdCDzVIxbnay70zWIV6t
         5hVxnxwSWEa9XFvJomnSp+YQiVM/IBpi3WcaDhs8tV0ATvHvtvaDYv6W4Nq52ScI+bh2
         GCPZr2YtZqI/+t4lP2vjUCAZRYKB0YJG63RZWMuxoy8z7ywSwZqAyx4c1luEzbTNZMEO
         Nv9abzba1NLEFeW+ia/ynIwfAnzOmUNpGepjvR67IlB3mRs7XfTSyoo/0qYqOU6h+S7N
         ecSSfblKFR8FMG13Zn6dqYXsr2QaXQHgFKphlzp9vY8j0hos6t/AF/d0nzjSNkxYMbOB
         ZHLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=+0CqKbStwjYWWb/ryAHBHEWWcIXAfliOA3KIW2RGcrc=;
        b=cuDIJbkLGsv6BE0D/yaullY4CwS1XS7kwXTmk4GYSi4FmHBBb5q4fZWw9A0hTpuegl
         y1jUsVTu6cIcyLsnDH4FrT5EY/ocgCjbhM+tGJM8ynCpElIsAeS82znpQj874xsDoVrs
         J7hXmKsCiKofyt+qsx6Gy8IuRUvGQw3hzXvpgIV/2oYJjoHERjZGG9tiF2HJ6Ycu8FGi
         gBNl/qioHt07pXtrpTeDBY4cVYLzNM2233aF45w1YbzHpxkK2GSIsKKbSfsjo87hckGK
         yX9EfUBhZEtYFxt+vOPOexupkzjkOWqrSkI9YXZFEwukrOVl0qA2sksgpXo3TblkrHpw
         qyeQ==
X-Gm-Message-State: AOAM5334Byb4SUYK97WxwwXsaM/JfA/hVDiX0su/UM4eh8uoAdqmoFDK
        NezMJEIywHl5+CRsR5yDr2kGXZyBMJY8Pg==
X-Google-Smtp-Source: ABdhPJy/eBmCYCwMjQaNiQaXg29RMcXkX5uWK7li3SQGv473sCsY4R0anVECgOPekGVLsF1hq3x81kSSI9beYA==
X-Received: from dlatypov.svl.corp.google.com ([2620:15c:2cd:202:24a2:4c13:4cc0:8818])
 (user=dlatypov job=sendgmr) by 2002:a0c:c352:: with SMTP id
 j18mr6454516qvi.7.1626384709654; Thu, 15 Jul 2021 14:31:49 -0700 (PDT)
Date:   Thu, 15 Jul 2021 14:31:36 -0700
Message-Id: <20210715213138.1363079-1-dlatypov@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.32.0.402.g57bb445576-goog
Subject: [RFC v1 0/2] crypto: tcrypt: small changes to run under KUnit
From:   Daniel Latypov <dlatypov@google.com>
To:     herbert@gondor.apana.org.au
Cc:     davem@davemloft.net, linux-crypto@vger.kernel.org,
        brendanhiggins@google.com, davidgow@google.com,
        linux-kernel@vger.kernel.org, kunit-dev@googlegroups.com,
        Daniel Latypov <dlatypov@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

tcrypt.c calls itself a "[q]uick & dirty crypto testing module."
One that "will only exist until we have a better testing mechanism."

This RFC seeks to start a discussion if KUnit can fill the role of that
"better testing mechanism."

As-is, these example changes don't make the test code much cleaner.
But they do provide a new way of running the test that's hopefully more
accessible, namely
$ ./tools/testing/kunit/kunit.py run --kunitconfig=crypto
...
[16:53:16] Starting KUnit Kernel ...
[16:53:19] ============================================================
[16:53:19] ======== [PASSED] tcrypt ========
[16:53:19] [PASSED] tcrypt
[16:53:19] ============================================================
[16:53:19] Testing complete. 1 tests run. 0 failed. 0 crashed. 0 skipped.
[16:53:19] Elapsed time: 8.806s total, 0.001s configuring, 5.764s building, 0.000s running

This series contains
* an initial patch with the boilerplate needed to run
under KUnit and track pass/fail status in the `test` context object
instead of passing around an int.
* another change to plumb the `test` context object to other test cases
that could previously fail w/o affecting the overall pass/fail status.

I haven't reformatted the code for now just to make the changes a bit
easier to read and skim over. checkpatch.pl isn't happy about the
spacing in the second patch.

== Other pros ==

If we want, we can go down the path of trying to structure the tests in
more idiomatic KUnit fashion to get some benefits like 
* automatically freeing memory at the end of tests when allocated using
  kunit_kmalloc() and friends instead of having to maintain labels
  * can be made to call arbitrary cleanup functions as well
  * this hopefully makes the tests more readable, at the expense of a
  bit more runtime overhead dynamically tracking these allocations
  * doing this just for the kmalloc's and __get_free_page() directly in
  * tcrypt.c saves 100+ lines of code.

* flagging test cases with KASAN issues (and eventually UBSAN)

* a bit easier way to dynamically run subsets of tests via glob
  * e.g. kunit.py run 'crypto.*sha512*'
  * KUnit currently only supports filtering by the suite ("crypto")
  right now, but we should have test-level filtering support soonish.

== Cons ==

The main cons are we'd be slightly changing how these tests are built
and run with these example patches

These changes are mainly
* building the test now requires CONFIG_KUNIT
* Running `insmod` on the module will always return 0, even if tests
  failed
  * the test instead prints out (K)TAP output to denote pass/fail
  * this is the format kselftest uses, but it's not fully standardized

And if we eventually try to restructure the test as mentioned above:
* more disruptive changes to how the tests are run
  * we'd have to move away from using the "mode" parameter
* a decent amount of code churn

Daniel Latypov (2):
  crypto: tcrypt: minimal conversion to run under KUnit
  crypto: tcrypt: call KUNIT_FAIL() instead of pr_err()

 crypto/Kconfig  |    5 +-
 crypto/tcrypt.c | 1063 +++++++++++++++++++++++------------------------
 2 files changed, 524 insertions(+), 544 deletions(-)


base-commit: e9338abf0e186336022293d2e454c106761f262b
-- 
2.32.0.402.g57bb445576-goog

