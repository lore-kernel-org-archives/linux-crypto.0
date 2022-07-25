Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E607DC433EF
	for <linux-crypto@archiver.kernel.org>; Mon, 25 Jul 2022 13:48:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233238AbiGYNsR (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 25 Jul 2022 09:48:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229514AbiGYNsQ (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 25 Jul 2022 09:48:16 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8149DEE3F
        for <linux-crypto@vger.kernel.org>; Mon, 25 Jul 2022 06:48:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 8F2F7CE1275
        for <linux-crypto@vger.kernel.org>; Mon, 25 Jul 2022 13:48:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4455EC341C6;
        Mon, 25 Jul 2022 13:48:11 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
        dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="Z3WX/CCD"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
        t=1658756889;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=7acSDg+FLApbk7YRG2ijgEmuKhqRCl2sNSvR2/TFFiQ=;
        b=Z3WX/CCDmZqzUPtFUt2QDbVZP/wTVAFfGnyr6yoEDGZ7LITZgaAY6fckopF21SIK7K5qvf
        LtmwqhvscR1ljurXVAfi/z+4n27ehmDD8YIR0fCULALA9z3x3wMJ33rKY4w2GOoPisGqg7
        A4ig2mKPzGc/iKm9oGV0qRdCiazw0K0=
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 9016ef83 (TLSv1.3:AEAD-AES256-GCM-SHA384:256:NO);
        Mon, 25 Jul 2022 13:48:09 +0000 (UTC)
Date:   Mon, 25 Jul 2022 15:48:07 +0200
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
To:     Jeffrey Walton <noloader@gmail.com>
Cc:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        libc-alpha@sourceware.org
Subject: Re: arc4random - are you sure we want these?
Message-ID: <Yt6fF/+QBwI2bih+@zx2c4.com>
References: <YtwgTySJyky0OcgG@zx2c4.com>
 <Ytwg8YEJn+76h5g9@zx2c4.com>
 <87bktdsdrk.fsf@oldenburg.str.redhat.com>
 <Yt54x7uWnsL3eZSx@zx2c4.com>
 <CAH8yC8n2FM9uXimT71Ej0mUw8TsDR-2RRQaN_DJ2g=UG_TBKWA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAH8yC8n2FM9uXimT71Ej0mUw8TsDR-2RRQaN_DJ2g=UG_TBKWA@mail.gmail.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi Jeffrey,

Please keep libc-alpha@sourceware.org CC'd.

On Mon, Jul 25, 2022 at 09:25:58AM -0400, Jeffrey Walton wrote:
> On Mon, Jul 25, 2022 at 7:08 AM Jason A. Donenfeld <Jason@zx2c4.com> wrote:
> >  ...
> > > The performance numbers suggest that we benefit from buffering in user
> > > space.
> >
> > The question is whether it's safe and advisable to buffer this way in
> > userspace. Does userspace have the right information now of when to
> > discard the buffer and get a new one? I suspect it does not.
> 
> I _think_ the sharp edge on userspace buffering is generator state.
> Most generator threat models I have seen assume the attacker does not
> know the generator's state. If buffering occurs in the application,
> then it may be easier for an attacker to learn of the generator's
> state. If buffering occurs in the kernel, then generator state should
> be private from an userspace application's view.

I guess that's one concern, if you're worried about heartbleed-like
attacks, in which an undetected RNG state compromise might be easier to
pull off.

What I have in mind, though, are the various triggers and heuristics
that the kernel uses for when it needs to reseed. These userspace
doesn't know about.

Jason
