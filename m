Return-Path: <SRS0=ISqn=SC=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_MUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F0301C43381
	for <linux-crypto@archiver.kernel.org>; Sun, 31 Mar 2019 22:43:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B7BAA20870
	for <linux-crypto@archiver.kernel.org>; Sun, 31 Mar 2019 22:43:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1554072214;
	bh=IAiku0ZXIIePqghkFZxZ4RIn43ETCLf5QySyeLVSxGk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=rnDuXjZliDgI6JM2OtDxyApTxRcRyLF4I1Z6O5ZTaI0yp08+z7jZAMrNk804itL/x
	 Zwc4yRwKuXCFE0V9WO8UGFk1j6k64WaNATFyjvPFhKwY6NHQ1rWiJMdUGyk6PlQaRZ
	 OpK3yIVbx49Q6dpG9iW4H53BfNyZH/A4bWaiYxL0=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731364AbfCaWnd (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 31 Mar 2019 18:43:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:37636 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731172AbfCaWnd (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 31 Mar 2019 18:43:33 -0400
Received: from sol.localdomain (c-24-5-143-220.hsd1.ca.comcast.net [24.5.143.220])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 709642086C;
        Sun, 31 Mar 2019 22:43:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1554072212;
        bh=IAiku0ZXIIePqghkFZxZ4RIn43ETCLf5QySyeLVSxGk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=HSivdQkNj9JIPcMQhCryX1Tj1Icj6RMEsKIdidtgxefJKY3xoOMsfwHHcK8+dUIDS
         uHo136SoSbaGiQvzCEuXfaJl8bsbMTw09ONAZeR5lkORMvvcerdeZch2HmTSz38TZJ
         WKuXpRPs1GiWXW6HkdqUMqTAiAyqEZVZwazTdoQg=
Date:   Sun, 31 Mar 2019 15:43:30 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Vitaly Chikunov <vt@altlinux.org>
Cc:     Theodore Ts'o <tytso@mit.edu>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>,
        herbert@gondor.apana.org.au, linux-crypto@vger.kernel.org
Subject: Re: Should we consider removing Streebog from the Linux Kernel?
Message-ID: <20190331224329.GA681@sol.localdomain>
References: <20190325044550.GI5675@mit.edu>
 <20190325060041.wl23bncqjab7dj5c@altlinux.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190325060041.wl23bncqjab7dj5c@altlinux.org>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi Vitaly,

On Mon, Mar 25, 2019 at 09:00:41AM +0300, Vitaly Chikunov wrote:
> Theodore,
> 
> On Mon, Mar 25, 2019 at 12:45:50AM -0400, Theodore Ts'o wrote:
> > Given the precedent that has been established for removing the SPECK
> 
> As far as I know Speck is removed because:
> 
> | commit 578bdaabd015b9b164842c3e8ace9802f38e7ecc
> | Author: Jason A. Donenfeld <Jason@zx2c4.com>
> | Date:   Tue Aug 7 08:22:25 2018 +0200
> |
> |   crypto: speck - remove Speck
> |
> |   These are unused, undesired, and have never actually been used by
> |   anybody. The original authors of this code have changed their mind about
> |   its inclusion. While originally proposed for disk encryption on low-end
> |   devices, the idea was discarded [1] in favor of something else before
> |   that could really get going. Therefore, this patch removes Speck.
> |
> |   [1] https://marc.info/?l=linux-crypto-vger&m=153359499015659
> 
> None of these arguments apply to Streebog.
> 
> Thanks,
> 
> 
> > cipher from the kernel, I wonder if we should be removing Streebog on
> > the same basis, in light of the following work:
> > 
> > 	https://who.paris.inria.fr/Leo.Perrin/pi.html
> > 	https://tosc.iacr.org/index.php/ToSC/article/view/7405
> > 
> > Regards,
> > 
> > 						- Ted
> > 
> > -----------
> > 
> > >From the Cryptography mailing list on metzdowd.com:
> > 
> > From: "perrin.leo@gmail.com" <perrin.leo@gmail.com>
> > Subject: [Cryptography] New Results on the Russian S-box
> > 
> > Hello everyone,
> > 
> > I have recently sent an e-mail to the CFRG mailing list about my results
> > on the S-box shared by both of the latest Russian standards in symmetric
> > crypto and I have been told that it might interest the subscribers of
> > this mailing list.
> > 
> > In a paper that I am about to present at the Fast Software Encryption
> > conference, I describe what I claim to be the structure used by the
> > S-box of the hash function Streebog and the block cipher Kuznyechik.
> > Their authors never disclosed their design process---and in fact claimed
> > that it was generated randomly. I established that it is not the case.
> > More worryingly, the structure they used has a very strong algebraic
> > structure which, in my opinion, demands a renewed security analysis in
> > its light. Overall, I would not recommend using these algorithms until
> > their designers have provided satisfactory explanations about their
> > S-box choice.

Can you elaborate on why you want to use Streebog?  When we added Speck, we
explained in great detail why it was useful from a technical perspective (before
Adiantum was ready).  I don't see any such explanation for Streebog.

- Eric
