Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8446BC433EF
	for <linux-crypto@archiver.kernel.org>; Tue, 19 Jul 2022 11:02:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231484AbiGSLCI (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 19 Jul 2022 07:02:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229886AbiGSLCG (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 19 Jul 2022 07:02:06 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64E62240A2
        for <linux-crypto@vger.kernel.org>; Tue, 19 Jul 2022 04:02:05 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2537AB81AE4
        for <linux-crypto@vger.kernel.org>; Tue, 19 Jul 2022 11:02:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1BD61C341C6;
        Tue, 19 Jul 2022 11:02:02 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
        dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="iOnkJaCt"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
        t=1658228520;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=pXDQxTx+dmJpY2x4ee5U0BedYJZnC9f95KBTc0KWQk0=;
        b=iOnkJaCt7qTmqpXwUSAGG/CVaoS/3+SyNF23LBSe8TTRdkZM3Ud1r604wO3bR7UzxlnVhX
        EyT+FSs3lfYUOuEBS460PqOjIk7yUQWm5fc8A3bElzzyvW8yOWLy2cRfpSoRK3+GFkjHyH
        6DNSOvMrF6gAJGissgk/56xF95Sdvio=
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id d795adb8 (TLSv1.3:AEAD-AES256-GCM-SHA384:256:NO);
        Tue, 19 Jul 2022 11:02:00 +0000 (UTC)
Date:   Tue, 19 Jul 2022 13:01:56 +0200
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
To:     "Guozihua (Scott)" <guozihua@huawei.com>
Cc:     linux-crypto@vger.kernel.org, luto@kernel.org, tytso@mit.edu,
        ebiggers@kernel.org
Subject: Re: Inquiry about the removal of flag O_NONBLOCK on /dev/random
Message-ID: <YtaPJPkewin5uWdn@zx2c4.com>
References: <13e1fa9d-4df8-1a99-ca22-d9d655f2d023@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <13e1fa9d-4df8-1a99-ca22-d9d655f2d023@huawei.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi,

On Thu, Jul 14, 2022 at 03:33:47PM +0800, Guozihua (Scott) wrote:
> Recently we noticed the removal of flag O_NONBLOCK on /dev/random by 
> commit 30c08efec888 ("random: make /dev/random be almost like 
> /dev/urandom"), it seems that some of the open_source packages e.g. 
> random_get_fd() of util-linux and __getrandom() of glibc. The man page 
> for random() is not updated either.
> 
> Would anyone please kindly provide some background knowledge of this 
> flag and it's removal? Thanks!

I didn't write that code, but I assume it was done this way because it
doesn't really matter that much now, as /dev/random never blocks after
the RNG is seeded. And now a days, the RNG gets seeded with jitter
fairly quickly as a last resort, so almost nobody waits a long time.

Looking at the two examples you mentioned, the one in util-linux does
that if /dev/urandom fails, which means it's mostly unused code, and the
one in glibc is for GNU Hurd, not Linux. I did a global code search and
found a bunch of other instances pretty similar to the util-linux case,
where /dev/random in O_NONBLOCK mode is used as a fallback to
/dev/urandom, which means it's basically never used. (Amusingly one such
user of this pattern is Ted's pwgen code from way back at the turn of
the millennium.)

All together, I couldn't really find anywhere that the removal of
O_NONBLOCK semantics would actually pose a problem for, especially since
/dev/random doesn't block at all after being initialized. So I'm
slightly leaning toward the "doesn't matter, do nothing" course of
action.

But on the other hand, you did somehow notice this, so that's important
perhaps. How did you run into it? *Does* it actually pose a problem? Or
was this a mostly theoretical finding from perusing source code?
Something like the below diff would probably work and isn't too
invasive, but I think I'd prefer to leave it be unless this really did
break some userspace of yours. So please let me know.

Regards,
Jason

diff --git a/drivers/char/random.c b/drivers/char/random.c
index 70d8d1d7e2d7..6f232ac258bf 100644
--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -1347,6 +1347,10 @@ static ssize_t random_read_iter(struct kiocb *kiocb, struct iov_iter *iter)
 {
 	int ret;
 
+	if (!crng_ready() &&
+	    ((kiocb->ki_flags & IOCB_NOWAIT) || (kiocb->ki_filp->f_flags & O_NONBLOCK)))
+		return -EAGAIN;
+
 	ret = wait_for_random_bytes();
 	if (ret != 0)
 		return ret;

