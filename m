Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C262AC43334
	for <linux-crypto@archiver.kernel.org>; Sun, 24 Jul 2022 23:34:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230121AbiGXXed (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 24 Jul 2022 19:34:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229451AbiGXXec (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 24 Jul 2022 19:34:32 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3014BE09C
        for <linux-crypto@vger.kernel.org>; Sun, 24 Jul 2022 16:34:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D7235B80D6E
        for <linux-crypto@vger.kernel.org>; Sun, 24 Jul 2022 23:34:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46BD9C341C0
        for <linux-crypto@vger.kernel.org>; Sun, 24 Jul 2022 23:34:28 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
        dkim=fail reason="key not found in DNS" (0-bit key) header.d=ucla.edu header.i=@ucla.edu header.b="BTOX5fa2"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ucla.edu; s=20210105;
        t=1658705666;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:in-reply-to:in-reply-to;
        bh=b4+oKpcW5j+7xNdarhJICYlrGeD9IROoPOmw3qqdiTs=;
        b=BTOX5fa2/oSGwLhYc8bhJNdUGgHvaCBYLbCS9pooez0lM8h9CzgZGFtomHD+SRZUbsgl1b
        VcLJlayK63I/B024XBSH47ViwgVVZazXyMhwnkUEogdxs3f5uNF2dPyaox2CQcwGcWzr1d
        Ac6Ohzo5irfjkc37XLb/9nBBAHZJivw=
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 4b09eee8 (TLSv1.3:AEAD-AES256-GCM-SHA384:256:NO)
        for <linux-crypto@vger.kernel.org>;
        Sun, 24 Jul 2022 23:34:26 +0000 (UTC)
From:   Paul Eggert <eggert@cs.ucla.edu>
Date:   Sat, 23 Jul 2022 17:18:05 +0000
To:     libc-alpha@sourceware.org, linux-crypto@vger.kernel.org
Subject: Re: arc4random - are you sure we want these?
Message-Id: <555f2208-6a04-8c3c-ea52-41ad02b33b0c@cs.ucla.edu>
X-MARC-Message: https://marc.info/?l=glibc-alpha&m=165859657522871
In-Reply-To: <Ytwg8YEJn+76h5g9@zx2c4.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 7/23/22 09:25, Jason A. Donenfeld via Libc-alpha wrote:
> it's hard to recommend that anybody really use these functions.
> Just keep using getrandom(2), which has mostly favorable semantics.

Yes, that's what I plan to do in GNU projects like Coreutils and Emacs.

Although I don't recommend arc4random, I suppose it was added for 
source-code compatibility with the BSDs (I wasn't involved in the decision).

> is there anyway that glibc can *not*  do this, or has that
> ship fully sailed

It hasn't fully sailed since we haven't done a release.

> it's fun to make a random number generator, and so lots
> of projects figure out some way to make yet another one somewhere
> somehow.

That's a bit harsh. Coreutils still has its own random number generator 
because it needed to be portable to a bunch of platforms and there was 
no standard. Eventually we'll rip it out but there's no rush. Having 
written much of that code I can reliably assert that it was not fun.
