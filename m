Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 95A64C433EF
	for <linux-crypto@archiver.kernel.org>; Mon, 25 Jul 2022 16:02:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235454AbiGYQCE (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 25 Jul 2022 12:02:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233374AbiGYQCE (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 25 Jul 2022 12:02:04 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E8F22601
        for <linux-crypto@vger.kernel.org>; Mon, 25 Jul 2022 09:02:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B992A612BB
        for <linux-crypto@vger.kernel.org>; Mon, 25 Jul 2022 16:02:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CFD90C341C8
        for <linux-crypto@vger.kernel.org>; Mon, 25 Jul 2022 16:02:01 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
        dkim=fail reason="key not found in DNS" (0-bit key) header.d=libc.org header.i=@libc.org header.b="LSvVvGDP"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=libc.org; s=20210105;
        t=1658764920;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ejztlBvsrQr7extiIh0BXqGoobD6HaYsVYFTKfFfHtE=;
        b=LSvVvGDPGIYof6hKUh615xwv/E8zn4gPlP/bzpsnJO0b3bfM9QytISO+RtlMCRESK6RRTq
        9Z7kKhP/ZGKjwBKduSnmMKyjuXd/u7vIM27wrHwqp5xP/FoIuz3YR/v4Pbroq+3govfSd2
        EzuRRg4eRHNQjdlpuq/V/WMJMlvwBm8=
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 2d5a0b8a (TLSv1.3:AEAD-AES256-GCM-SHA384:256:NO)
        for <linux-crypto@vger.kernel.org>;
        Mon, 25 Jul 2022 16:02:00 +0000 (UTC)
Date:   Mon, 25 Jul 2022 11:33:04 -0400
From:   Rich Felker <dalias@libc.org>
To:     Adhemerval Zanella Netto <adhemerval.zanella@linaro.org>
Cc:     "Jason A. Donenfeld" <Jason@zx2c4.com>, libc-alpha@sourceware.org,
        Florian Weimer <fweimer@redhat.com>,
        Yann Droneaud <ydroneaud@opteya.com>, jann@thejh.net,
        Michael@phoronix.com, Paul Eggert <eggert@cs.ucla.edu>,
        linux-crypto@vger.kernel.org
Subject: Re: arc4random - are you sure we want these?
Message-ID: <20220725153303.GF7074@brightrain.aerifal.cx>
References: <YtwgTySJyky0OcgG@zx2c4.com>
 <Ytwg8YEJn+76h5g9@zx2c4.com>
 <6bf352e9-1312-40de-4733-3219721b343c@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6bf352e9-1312-40de-4733-3219721b343c@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Sat, Jul 23, 2022 at 02:39:29PM -0300, Adhemerval Zanella Netto via Libc-alpha wrote:
> On 23/07/22 13:25, Jason A. Donenfeld wrote:
> > Firstly, for what use cases does this actually help? As of recent
> > changes to the Linux kernels -- now backported all the way to 4.9! --
> > getrandom() and /dev/urandom are extremely fast and operate over per-cpu
> > states locklessly. Sure you avoid a syscall by doing that in userspace,
> > but does it really matter? Who exactly benefits from this?
> 
> Mainly performance, since glibc both export getrandom and getentropy. 
> There were some discussion on maillist and we also decided to explicit
> state this is not a CSRNG on our documentation.

This is an extreme documentation/specification bug that *hurts*
portability and security. The core contract of the historical
arc4random function is that it *is* a CSPRNG. Having a function by
that name that's allowed not to be one means now all software using it
has to add detection for the broken glibc variant.

If the glibc implementation has flaws that actually make it not a
CSPRNG, this absolutely needs to be fixed. Not doing so is
irresponsible and will set everyone back a long ways.

If this is just a case of trying to be "cautious" about overpromising
things, the documentation needs fixed to specify that this is a
CSPRNG. I'm particularly worried about the wording "these still use a
Pseudo-Random generator and should not be used in cryptographic
contexts". *All* CSPRNGs are PRNGs. Being pseudo-random does not make
it not cryptographically safe. The safety depends on the original
source of the entropy and the practical irreversibility and other
cryptographic properties of the extension function. The fact that this
has been stated so poorly in the documentation really has me worried
that someone does not understand the issues. I haven't dug into the
list mails or actual code to determine to what extent that's the case,
but it's really, *really* worrying.

Rich
