Return-Path: <SRS0=HcFc=OV=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	USER_AGENT_MUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CF89FC6783B
	for <linux-crypto@archiver.kernel.org>; Wed, 12 Dec 2018 02:40:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 95F672084E
	for <linux-crypto@archiver.kernel.org>; Wed, 12 Dec 2018 02:40:18 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=thunk.org header.i=@thunk.org header.b="U8h8CMxq"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 95F672084E
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=mit.edu
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-crypto-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726237AbeLLCkR (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 11 Dec 2018 21:40:17 -0500
Received: from imap.thunk.org ([74.207.234.97]:52272 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726211AbeLLCkR (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 11 Dec 2018 21:40:17 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=thunk.org;
         s=ef5046eb; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=bzNuIfCkh83UKRbWepju59ymEQp9nN1zEvGUvSO2Dfs=; b=U8h8CMxq/VtXKdMTeMmAHZzh+h
        6dXDAVKBsKNjcVP16cqdl0M2AHVmEbMPaKTBPRoPmxoATNcmcoh8B4ZmH0v+tkvF3aQXjk1YxRAni
        byTlh9lC8nQ9NQK09ATSlBjX9/4mvrmLWGyYRwxBkeRPXLx2OOWulXYsARSUDZcOV6Fc=;
Received: from root (helo=callcc.thunk.org)
        by imap.thunk.org with local-esmtp (Exim 4.89)
        (envelope-from <tytso@thunk.org>)
        id 1gWuRb-0000Gg-FZ; Wed, 12 Dec 2018 02:40:15 +0000
Received: by callcc.thunk.org (Postfix, from userid 15806)
        id CE12E7A4FD5; Tue, 11 Dec 2018 21:40:14 -0500 (EST)
Date:   Tue, 11 Dec 2018 21:40:14 -0500
From:   "Theodore Y. Ts'o" <tytso@mit.edu>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     linux-fscrypt@vger.kernel.org,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
        <linux-crypto@vger.kernel.org>
Subject: Re: [PATCH] fscrypt: remove CRYPTO_CTR dependency
Message-ID: <20181212024014.GE4464@thunk.org>
References: <20180905192400.71160-1-ebiggers@kernel.org>
 <CAKv+Gu8=dDk+bes8O7oOQ3zTgPHyVi49-gwH1btwdys-vgfyqg@mail.gmail.com>
 <20181204234506.GD70682@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
In-Reply-To: <20181204234506.GD70682@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org
Message-ID: <20181212024014.tF5Ox1FU5Y88N6fpgc7qJhZcZDX7V0gjyzlhJPzh-Kw@z>

On Tue, Dec 04, 2018 at 03:45:07PM -0800, Eric Biggers wrote:
> On Thu, Sep 06, 2018 at 12:43:41PM +0200, Ard Biesheuvel wrote:
> > On 5 September 2018 at 21:24, Eric Biggers <ebiggers@kernel.org> wrote:
> > > From: Eric Biggers <ebiggers@google.com>
> > >
> > > fscrypt doesn't use the CTR mode of operation for anything, so there's
> > > no need to select CRYPTO_CTR.  It was added by commit 71dea01ea2ed
> > > ("ext4 crypto: require CONFIG_CRYPTO_CTR if ext4 encryption is
> > > enabled").  But, I've been unable to identify the arm64 crypto bug it
> > > was supposedly working around.
> > >
> > > I suspect the issue was seen only on some old Android device kernel
> > > (circa 3.10?).  So if the fix wasn't mistaken, the real bug is probably
> > > already fixed.  Or maybe it was actually a bug in a non-upstream crypto
> > > driver.
> > >
> > > So, remove the dependency.  If it turns out there's actually still a
> > > bug, we'll fix it properly.
> > >
> > > Signed-off-by: Eric Biggers <ebiggers@google.com>
> > 
> > Acked-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>

Thanks, applied.

					- Ted
