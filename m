Return-Path: <SRS0=vipQ=TG=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A6E37C04AB4
	for <linux-crypto@archiver.kernel.org>; Mon,  6 May 2019 05:49:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7861E2087F
	for <linux-crypto@archiver.kernel.org>; Mon,  6 May 2019 05:49:33 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=c-s.fr header.i=@c-s.fr header.b="eja1F3bI"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726338AbfEFFtd (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 6 May 2019 01:49:33 -0400
Received: from pegase1.c-s.fr ([93.17.236.30]:52234 "EHLO pegase1.c-s.fr"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725830AbfEFFtc (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 6 May 2019 01:49:32 -0400
Received: from localhost (mailhub1-int [192.168.12.234])
        by localhost (Postfix) with ESMTP id 44yBdL41Vbz9v0RT;
        Mon,  6 May 2019 07:49:26 +0200 (CEST)
Authentication-Results: localhost; dkim=pass
        reason="1024-bit key; insecure key"
        header.d=c-s.fr header.i=@c-s.fr header.b=eja1F3bI; dkim-adsp=pass;
        dkim-atps=neutral
X-Virus-Scanned: Debian amavisd-new at c-s.fr
Received: from pegase1.c-s.fr ([192.168.12.234])
        by localhost (pegase1.c-s.fr [192.168.12.234]) (amavisd-new, port 10024)
        with ESMTP id up3DHxYn6wXS; Mon,  6 May 2019 07:49:26 +0200 (CEST)
Received: from messagerie.si.c-s.fr (messagerie.si.c-s.fr [192.168.25.192])
        by pegase1.c-s.fr (Postfix) with ESMTP id 44yBdL2nzPz9v0RR;
        Mon,  6 May 2019 07:49:26 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=c-s.fr; s=mail;
        t=1557121766; bh=fM4YSgumk/SKIoBFULA790fwpPryeVxwDuCklVesS4g=;
        h=Subject:References:To:From:Date:In-Reply-To:From;
        b=eja1F3bIWkwnjdc0xsLFHF1p0Hsj9G3vsnLr+B+mzaxLDAl9K76xy6wvF1RIv6NTe
         lPYgHkdYtVbkWIn+N376c52fIRQzGl8mAsfywiNoeWm8BkNE6aKWqk1K8LhJQfW2v3
         kufz5da4OBp5cSTKYYauYRRO1soa7nZmxCd15cbg=
Received: from localhost (localhost [127.0.0.1])
        by messagerie.si.c-s.fr (Postfix) with ESMTP id CC95E8B7F7;
        Mon,  6 May 2019 07:49:30 +0200 (CEST)
X-Virus-Scanned: amavisd-new at c-s.fr
Received: from messagerie.si.c-s.fr ([127.0.0.1])
        by localhost (messagerie.si.c-s.fr [127.0.0.1]) (amavisd-new, port 10023)
        with ESMTP id sBnEV6vuLZoB; Mon,  6 May 2019 07:49:30 +0200 (CEST)
Received: from PO15451 (po15451.idsi0.si.c-s.fr [172.25.231.6])
        by messagerie.si.c-s.fr (Postfix) with ESMTP id B59648B74F;
        Mon,  6 May 2019 07:49:30 +0200 (CEST)
Subject: Fwd: [Bug 203515] [crypto] alg: skcipher: p8_aes_ctr encryption test
 failed (wrong result) on test vector 3, cfg="uneven misaligned splits, may
 sleep"
References: <bug-203515-206035-IJDpu7ZL6G@https.bugzilla.kernel.org/>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
From:   Christophe Leroy <christophe.leroy@c-s.fr>
X-Forwarded-Message-Id: <bug-203515-206035-IJDpu7ZL6G@https.bugzilla.kernel.org/>
Message-ID: <e2393522-7f3a-1f04-9cb5-72e207adb9ac@c-s.fr>
Date:   Mon, 6 May 2019 07:49:30 +0200
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <bug-203515-206035-IJDpu7ZL6G@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: fr
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org




-------- Message transféré --------
Sujet : [Bug 203515] [crypto] alg: skcipher: p8_aes_ctr encryption test 
failed (wrong result) on test vector 3, cfg="uneven misaligned splits, 
may sleep"
Date : Sun, 05 May 2019 19:19:07 +0000
De : bugzilla-daemon@bugzilla.kernel.org
Pour : linuxppc-dev@lists.ozlabs.org

https://bugzilla.kernel.org/show_bug.cgi?id=203515

--- Comment #3 from Erhard F. (erhard_f@mailbox.org) ---
Created attachment 282623
   --> https://bugzilla.kernel.org/attachment.cgi?id=282623&action=edit
bisect.log

git-bisect found 4e7babba30d820c4195b1d58cf51dce3c22ecf2b as the 1st bad
commit:

# git bisect good | tee -a ~/bisect01.log
4e7babba30d820c4195b1d58cf51dce3c22ecf2b is the first bad commit
commit 4e7babba30d820c4195b1d58cf51dce3c22ecf2b
Author: Eric Biggers <ebiggers@google.com>
Date:   Thu Jan 31 23:51:46 2019 -0800

     crypto: testmgr - convert skcipher testing to use testvec_configs

     Convert alg_test_skcipher() to use the new test framework, adding a 
list
     of testvec_configs to test by default.  When the extra self-tests are
     enabled, randomly generated testvec_configs are tested as well.

     This improves skcipher test coverage mainly because now all algorithms
     have a variety of data layouts tested, whereas before each 
algorithm was
     responsible for declaring its own chunked test cases which were often
     missing or provided poor test coverage.  The new code also tests both
     the MAY_SLEEP and !MAY_SLEEP cases, different IV alignments, and 
buffers
     that cross pages.

     This has already found a bug in the arm64 ctr-aes-neonbs algorithm.
     It would have easily found many past bugs.

     I removed the skcipher chunked test vectors that were the same as
     non-chunked ones, but left the ones that were unique.

     Signed-off-by: Eric Biggers <ebiggers@google.com>
     Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

:040000 040000 c533a4dce0d9954923cd56a69e0d26eeee5324a3
c199b3af7a05160aede1522c4860abae5fbe2716 M      crypto

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
