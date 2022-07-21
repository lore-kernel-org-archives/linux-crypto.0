Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9FC33C433EF
	for <linux-crypto@archiver.kernel.org>; Thu, 21 Jul 2022 04:08:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229834AbiGUEI0 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 21 Jul 2022 00:08:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231936AbiGUEHz (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 21 Jul 2022 00:07:55 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2267A13CEB
        for <linux-crypto@vger.kernel.org>; Wed, 20 Jul 2022 21:07:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C5D6DB8226B
        for <linux-crypto@vger.kernel.org>; Thu, 21 Jul 2022 04:07:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C6F7C341C6;
        Thu, 21 Jul 2022 04:07:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1658376467;
        bh=w/3+UTMt3kqH0GQg/nhdlD5vm9VIFFb8qiazKnPHDhc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=s/+YlFxShHbO5aZ84YnplW1HxmJ38ZWLQ4ChjZ9SvfNJxRVexrgWrlTxmICDOcjYL
         UfsFHAVEkHMbp7qQNmVYbJ/FohfSvB5MZZvbk8iMQPhjHHudfI3PNFWtRHuTHETpKq
         lSuG7bThpoJ7YGcC5wfLUmXbLZVHrr1G4p/M7vWEwbeV7PTAZ93RTwkolKXCRPtOnv
         yB1sPCWyw09cDlTca/ggGKr1ryE7idzuqpM3iHy6+xJARvKlX9AO4c76ZQyChUIu9S
         E8EFL5whyYzqjC87+tRo4gMSueeysGmIxvWVSgLXC5FctJzNWux6sYxWLmfhZHF/G/
         KMkwhMOe+csmg==
Date:   Wed, 20 Jul 2022 21:07:45 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     "Guozihua (Scott)" <guozihua@huawei.com>
Cc:     "Jason A. Donenfeld" <Jason@zx2c4.com>,
        linux-crypto@vger.kernel.org, luto@kernel.org, tytso@mit.edu
Subject: Re: Inquiry about the removal of flag O_NONBLOCK on /dev/random
Message-ID: <YtjREZMzuppTJHeR@sol.localdomain>
References: <13e1fa9d-4df8-1a99-ca22-d9d655f2d023@huawei.com>
 <YtaPJPkewin5uWdn@zx2c4.com>
 <b9cb514c-30ed-0b8b-5d54-75001e07bd36@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b9cb514c-30ed-0b8b-5d54-75001e07bd36@huawei.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, Jul 21, 2022 at 11:50:27AM +0800, Guozihua (Scott) wrote:
> On 2022/7/19 19:01, Jason A. Donenfeld wrote:
> > Hi,
> > 
> > On Thu, Jul 14, 2022 at 03:33:47PM +0800, Guozihua (Scott) wrote:
> > > Recently we noticed the removal of flag O_NONBLOCK on /dev/random by
> > > commit 30c08efec888 ("random: make /dev/random be almost like
> > > /dev/urandom"), it seems that some of the open_source packages e.g.
> > > random_get_fd() of util-linux and __getrandom() of glibc. The man page
> > > for random() is not updated either.
> > > 
> > > Would anyone please kindly provide some background knowledge of this
> > > flag and it's removal? Thanks!
> > 
> > I didn't write that code, but I assume it was done this way because it
> > doesn't really matter that much now, as /dev/random never blocks after
> > the RNG is seeded. And now a days, the RNG gets seeded with jitter
> > fairly quickly as a last resort, so almost nobody waits a long time.
> > 
> > Looking at the two examples you mentioned, the one in util-linux does
> > that if /dev/urandom fails, which means it's mostly unused code, and the
> > one in glibc is for GNU Hurd, not Linux. I did a global code search and
> > found a bunch of other instances pretty similar to the util-linux case,
> > where /dev/random in O_NONBLOCK mode is used as a fallback to
> > /dev/urandom, which means it's basically never used. (Amusingly one such
> > user of this pattern is Ted's pwgen code from way back at the turn of
> > the millennium.)
> > 
> > All together, I couldn't really find anywhere that the removal of
> > O_NONBLOCK semantics would actually pose a problem for, especially since
> > /dev/random doesn't block at all after being initialized. So I'm
> > slightly leaning toward the "doesn't matter, do nothing" course of
> > action.
> > 
> > But on the other hand, you did somehow notice this, so that's important
> > perhaps. How did you run into it? *Does* it actually pose a problem? Or
> > was this a mostly theoretical finding from perusing source code?
> > Something like the below diff would probably work and isn't too
> > invasive, but I think I'd prefer to leave it be unless this really did
> > break some userspace of yours. So please let me know.
> > 
> > Regards,
> > Jason
> > 
> > diff --git a/drivers/char/random.c b/drivers/char/random.c
> > index 70d8d1d7e2d7..6f232ac258bf 100644
> > --- a/drivers/char/random.c
> > +++ b/drivers/char/random.c
> > @@ -1347,6 +1347,10 @@ static ssize_t random_read_iter(struct kiocb *kiocb, struct iov_iter *iter)
> >   {
> >   	int ret;
> > +	if (!crng_ready() &&
> > +	    ((kiocb->ki_flags & IOCB_NOWAIT) || (kiocb->ki_filp->f_flags & O_NONBLOCK)))
> > +		return -EAGAIN;
> > +
> >   	ret = wait_for_random_bytes();
> >   	if (ret != 0)
> >   		return ret;
> > 
> > .
> 
> Hi Jason, Thanks for the respond.
> 
> The reason this comes to me is that we have an environment that is super
> clean with very limited random events and with very limited random hardware
> access. It would take up to 80 minutes before /dev/random is fully
> initialized. I think it would be great if we can restore the O_NONBLOCK
> flag.
> 
> Would you mind merge this change into mainstream or may I have the honor?
> 

Can you elaborate on how this change would actually solve a problem for you?  Do
you actually have a program that is using /dev/random with O_NONBLOCK, and that
handles the EAGAIN error correctly?  Just because you're seeing a program wait
for the RNG to be initialized doesn't necessarily mean that this change would
make a difference, as the program could just be reading from /dev/random without
O_NONBLOCK or calling getrandom() without GRND_NONBLOCK.  The behavior of those
(more common) cases would be unchanged by Jason's proposed change.

- Eric
