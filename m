Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D00CEC43334
	for <linux-crypto@archiver.kernel.org>; Sat, 23 Jul 2022 23:09:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239029AbiGWXJh (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 23 Jul 2022 19:09:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239028AbiGWXJh (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 23 Jul 2022 19:09:37 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 396EC1AF3B
        for <linux-crypto@vger.kernel.org>; Sat, 23 Jul 2022 16:09:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E1BDBB80923
        for <linux-crypto@vger.kernel.org>; Sat, 23 Jul 2022 23:09:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B38BC341CB
        for <linux-crypto@vger.kernel.org>; Sat, 23 Jul 2022 23:09:33 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
        dkim=fail reason="key not found in DNS" (0-bit key) header.d=opensuse.org header.i=@opensuse.org header.b="e/0aeUqr"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=opensuse.org;
        s=20210105; t=1658617772;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=HBlDwPkms0blEARPTlBdVEUCUmRBC2AdWFMDOvhbc98=;
        b=e/0aeUqrJDTL/dxKxNsEdzzj/k9Yg0E//mQoHz3QzyKGiitDDuqUA5+crJmzrvrjLcFGe/
        NE7oCYc54V1KN/jb7OesR/QhHnJ6cf2vd4mptronXabiOQY1/IV7lW6WW65L0aiVvhou0Z
        Y3OAZmccWh0w0xYjLtDcmvZYiM6nvKk=
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id e9df0b8e (TLSv1.3:AEAD-AES256-GCM-SHA384:256:NO)
        for <linux-crypto@vger.kernel.org>;
        Sat, 23 Jul 2022 23:09:32 +0000 (UTC)
MIME-Version: 1.0
References: <YtwgTySJyky0OcgG@zx2c4.com> <Ytwg8YEJn+76h5g9@zx2c4.com>
In-Reply-To: <Ytwg8YEJn+76h5g9@zx2c4.com>
From:   =?UTF-8?Q?Cristian_Rodr=C3=ADguez?= <crrodriguez@opensuse.org>
Date:   Sat, 23 Jul 2022 15:04:36 -0400
Message-ID: <CAPBLoAdtEcpJg7sZQ7+z7HeCQzAs7Am7ep9GBFuBGxUeC3NyEw@mail.gmail.com>
Subject: Re: arc4random - are you sure we want these?
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc:     libc-alpha@sourceware.org, linux-crypto@vger.kernel.org,
        Adhemerval Zanella Netto <adhemerval.zanella@linaro.org>,
        Florian Weimer <fweimer@redhat.com>,
        Yann Droneaud <ydroneaud@opteya.com>, jann@thejh.net,
        Michael@phoronix.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Sat, Jul 23, 2022 at 12:25 PM Jason A. Donenfeld via Libc-alpha
<libc-alpha@sourceware.org> wrote:

> For that reason, past discussion of having some random number generation
> in userspace libcs has geared toward doing this in the vDSO, somehow,
> where the kernel can be part and parcel of that effort.

On linux just making this interface call "something" from the VDSO that

- does not block.
- cannot ever fail or if it does indeed need to bail out it kills the
calling thread as last resort.

(if neither of those can be provided, we are back to square one)

Will be beyond awesome because it could be usable everywhere,
including the dynamic linker, malloc or whatever else
question is..is there any at least experimental patch  with a hope of
beign accepted available ?
