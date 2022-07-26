Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4D634C43334
	for <linux-crypto@archiver.kernel.org>; Tue, 26 Jul 2022 12:20:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233086AbiGZMUq (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 26 Jul 2022 08:20:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232662AbiGZMUp (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 26 Jul 2022 08:20:45 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7C4AB4B5
        for <linux-crypto@vger.kernel.org>; Tue, 26 Jul 2022 05:20:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5CF186150B
        for <linux-crypto@vger.kernel.org>; Tue, 26 Jul 2022 12:20:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 117DEC341C8;
        Tue, 26 Jul 2022 12:20:42 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
        dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="J+aPaSK1"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
        t=1658838041;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=huAD2pZwlf6UsyFSUwFIRPTakCSMqmpOF7e8Vzl53bg=;
        b=J+aPaSK1i4COjZ42HiTmo7U2jZ3SZ+B3vxIGl2l17S/Ae33VYSVmi/guELkE41cY0kVymp
        4ElGAIzVd3FwQ3g2xaati1Smqmrh+xp9GP5XpFZVaG769W8iDOxI5GaOMT7tKtB7JQYJ4Y
        iUbAi+uCogzvOpXMUWRH3ls/F8thaJA=
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 511d27c9 (TLSv1.3:AEAD-AES256-GCM-SHA384:256:NO);
        Tue, 26 Jul 2022 12:20:40 +0000 (UTC)
Date:   Tue, 26 Jul 2022 14:20:38 +0200
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
To:     Adhemerval Zanella Netto <adhemerval.zanella@linaro.org>
Cc:     libc-alpha@sourceware.org, Florian Weimer <fweimer@redhat.com>,
        Cristian =?utf-8?Q?Rodr=C3=ADguez?= <crrodriguez@opensuse.org>,
        Paul Eggert <eggert@cs.ucla.edu>, linux-crypto@vger.kernel.org
Subject: Re: [PATCH v2] arc4random: simplify design for better safety
Message-ID: <Yt/cFoln0FvK7hn7@zx2c4.com>
References: <20220725225728.824128-1-Jason@zx2c4.com>
 <20220725232810.843433-1-Jason@zx2c4.com>
 <9c576e6b-77c9-88c5-50a3-a43665ea5e93@linaro.org>
 <Yt/V78eyHIG/kms3@zx2c4.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <Yt/V78eyHIG/kms3@zx2c4.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, Jul 26, 2022 at 01:54:23PM +0200, Jason A. Donenfeld wrote:
> > Also, does it make sense to fallback if we build for a kernel that should
> > always support getrandom?
> 
> I guess only if syscall filtering is a concern. But if not, then maybe
> yea? We could do this in a follow-up commit, or I could do this in v4.
> Would `#if __LINUX_KERNEL_VERSION >` be the right mechanism to use here?
> If so, I think the way I'd implement that would be:
>
> [...]
>
> And then arc4random_getrandom_failure() being a noreturn function would
> make gcc optimize out the rest.
> 
> Does that seem like a good approach?

It actually winds up looking a bit more like the below. Let me know if
you want that in v4.

diff --git a/stdlib/arc4random.c b/stdlib/arc4random.c
index c0f132ea9b..8fcf41e7de 100644
--- a/stdlib/arc4random.c
+++ b/stdlib/arc4random.c
@@ -43,7 +43,7 @@ __arc4random_buf (void *p, size_t n)
     {
       ssize_t l;

-      if (!atomic_load_relaxed (&have_getrandom))
+      if (!__ASSUME_GETRANDOM && !atomic_load_relaxed (&have_getrandom))
 	break;

       l = __getrandom_nocancel (p, n, 0);
@@ -59,7 +59,7 @@ __arc4random_buf (void *p, size_t n)
 	arc4random_getrandom_failure (); /* Weird, should never happen.  */
       else if (l == -EINTR)
 	continue; /* Interrupted by a signal; keep going.  */
-      else if (l == -ENOSYS)
+      else if (!__ASSUME_GETRANDOM && l == -ENOSYS)
 	{
 	  atomic_store_relaxed (&have_getrandom, false);
 	  break; /* No syscall, so fallback to /dev/urandom.  */
diff --git a/sysdeps/unix/sysv/linux/kernel-features.h b/sysdeps/unix/sysv/linux/kernel-features.h
index 74adc3956b..75d5f953d4 100644
--- a/sysdeps/unix/sysv/linux/kernel-features.h
+++ b/sysdeps/unix/sysv/linux/kernel-features.h
@@ -236,4 +236,11 @@
 # define __ASSUME_FUTEX_LOCK_PI2 0
 #endif

+/* The getrandom() syscall was added in 3.17.  */
+#if __LINUX_KERNEL_VERSION >= 0x031100
+# define __ASSUME_GETRANDOM 1
+#else
+# define __ASSUME_GETRANDOM 0
+#endif
+
 #endif /* kernel-features.h */
