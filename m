Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 91B0AC433EF
	for <linux-crypto@archiver.kernel.org>; Tue, 21 Dec 2021 14:57:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231251AbhLUO5n (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 21 Dec 2021 09:57:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235665AbhLUO5m (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 21 Dec 2021 09:57:42 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5132C061574
        for <linux-crypto@vger.kernel.org>; Tue, 21 Dec 2021 06:57:41 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AA707B81055
        for <linux-crypto@vger.kernel.org>; Tue, 21 Dec 2021 14:57:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B383C36AE9;
        Tue, 21 Dec 2021 14:57:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1640098659;
        bh=fDVnXn7hLtZs57bKf3tWAlZc0lNJbpyMTCr7smWDzek=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=OXz3fr2LpRR2HcEqWjaAu0sGSVooDCsWLpL5lLYmCA+MEapK9pWCFRr07ABH8pV9Q
         RF+5mD5RJgF1OehvHemyGfDBdR4dG2wei/P6G4iWGaVg2fmuyZNMuADOGiHV5zu/9Y
         GVqlfHg1rDJStZqMr89gyfM/UwahLOGbr9JwUQgFFG4OFkdwFPG1Mu/yEAz7TOff4N
         i7Uboeq9j1D96LURvPJUsULDoxbV70/87wqKgMCJ22rrDYsAgn4YPCT2Pz2Xg7h8jZ
         hO1xo0/gOeumcDFdS7vWbywBEy9lSc+8zVE2b2T9dUAIKCn+R9MxZ+UV5S2o+Onhx5
         C3X3Ft4/YmXJw==
Date:   Tue, 21 Dec 2021 06:57:37 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Ard Biesheuvel <ardb@kernel.org>
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Sabrina Dubroca <sd@queasysnail.net>
Subject: Re: x86 AES crypto alignment
Message-ID: <20211221065737.0db2a746@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <CAMj1kXGV+DHZSOw7t8NgZojMsA6bq-VENz-WxQH+rb8yFj0zyA@mail.gmail.com>
References: <20211207113252.162701ed@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <20211208044037.GA11399@gondor.apana.org.au>
        <20211207212907.6e91821b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <20211220150343.4e12a4d2@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <20211220161125.78bc4d66@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <20211220165251.400813dc@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <CAMj1kXG+FGBHr=+vUwVz-u5n7oHpRxikLsOogVW0bOvNow3jHQ@mail.gmail.com>
        <CAMj1kXGV+DHZSOw7t8NgZojMsA6bq-VENz-WxQH+rb8yFj0zyA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, 21 Dec 2021 08:24:48 +0100 Ard Biesheuvel wrote:
> > Could you check whether this means that gcm_context_data in
> > gcmaes_crypt_by_sg() does not have to be aligned either? It would be
> > nice if we could drop that horrible hack as well.
> 
> I guess you meant by "we take care of the meta-data (key, iv etc.)
> alignment anyway" that we have these hacks for gcm_context_data (which
> carries the key) and the IV, using oversized buffers on the stack and
> open coded realignment.
> 
> It would be really nice if we could just get rid of all of that as
> well, and just use {v}movdqu to load those items.

Yup, exactly. I did something close to s/movdqa/movdqu/ initially,
but doing a competent job removing the alignment assumption would
be more effort. Let's see if I can see the copy if any perf profile...

FWIW there is a comment up top in arch/x86/crypto/aesni-intel_asm.S
which explains the aligned operations were chosen because they have
a shorter encoding. Seems like an intentional choice.
