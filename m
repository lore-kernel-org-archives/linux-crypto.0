Return-Path: <SRS0=Ubkd=C7=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DE4E7C4363D
	for <linux-crypto@archiver.kernel.org>; Tue, 22 Sep 2020 16:21:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8F32B23A1B
	for <linux-crypto@archiver.kernel.org>; Tue, 22 Sep 2020 16:21:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1600791693;
	bh=pCDMKkJqYt2tgKBzY7siELuMz/N2bEJBG7ZD5DoMia4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=TXmECf2pEHSjC+g8jJOoTO1ieuAuQct6w/PAoSs9U8q+0Iq5dVFndFIlxhZcdM6RG
	 ZjccnlSssJ2gNZWqSuHyRW1zzGOzAhBe+ihbi5Oc18jVnutNw9stlVL+tzUC/Krny/
	 QOwZz5GUJaEKBtkyyUF7nxxWT+ZIjBDnozobEKLg=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726632AbgIVQVd (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 22 Sep 2020 12:21:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:50472 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726631AbgIVQVc (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 22 Sep 2020 12:21:32 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 39B122086A;
        Tue, 22 Sep 2020 16:21:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600791692;
        bh=pCDMKkJqYt2tgKBzY7siELuMz/N2bEJBG7ZD5DoMia4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=SD/Fq8G01kIWmssW/Tx1ZkLlppmVPXOOe8LspTTe6Bqx5dabfY1Sip3sLdq4eCAbB
         UXp7P7S16ejf2T/iX0qDiL9amWOlx7njX/jv8VQfw8vvpEwCSAOKoygt0GNj7fCAhF
         N7sNRc1UlWirpo+M0DSgOT4pr7wEGSthGjztlNng=
Date:   Tue, 22 Sep 2020 18:21:52 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Torsten Duwe <duwe@lst.de>
Cc:     Stephan Mueller <smueller@chronox.de>,
        "Theodore Y. Ts'o" <tytso@mit.edu>,
        Nicolai Stange <nstange@suse.de>, linux-crypto@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        "Alexander E. Patrakov" <patrakov@gmail.com>,
        "Ahmed S. Darwish" <darwish.07@gmail.com>,
        Willy Tarreau <w@1wt.eu>,
        Matthew Garrett <mjg59@srcf.ucam.org>,
        Vito Caputo <vcaputo@pengaru.com>,
        Andreas Dilger <adilger.kernel@dilger.ca>,
        Jan Kara <jack@suse.cz>, Ray Strode <rstrode@redhat.com>,
        William Jon McCann <mccann@jhu.edu>,
        zhangjs <zachary@baishancloud.com>,
        Andy Lutomirski <luto@kernel.org>,
        Florian Weimer <fweimer@redhat.com>,
        Lennart Poettering <mzxreary@0pointer.de>,
        Peter Matthias <matthias.peter@bsi.bund.de>,
        Marcelo Henrique Cerri <marcelo.cerri@canonical.com>,
        Roman Drahtmueller <draht@schaltsekun.de>,
        Neil Horman <nhorman@redhat.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Julia Lawall <julia.lawall@inria.fr>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Andy Lavr <andy.lavr@gmail.com>,
        Eric Biggers <ebiggers@kernel.org>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Petr Tesarik <ptesarik@suse.cz>
Subject: Re: [DISCUSSION PATCH 00/41] random: possible ways towards NIST
 SP800-90B compliance
Message-ID: <20200922162152.GB2299429@kroah.com>
References: <20200921075857.4424-1-nstange@suse.de>
 <8618155.4vTCxPXJkl@tauon.chronox.de>
 <20200922132344.GA2728@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200922132344.GA2728@lst.de>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, Sep 22, 2020 at 03:23:44PM +0200, Torsten Duwe wrote:
> On Mon, Sep 21, 2020 at 10:40:37AM +0200, Stephan Mueller wrote:
> > Am Montag, 21. September 2020, 09:58:16 CEST schrieb Nicolai Stange:
> > 
> > > - people dislike the approach of having two competing implementations for
> > >   what is basically the same functionality in the kernel.
> > 
> > Is this really so bad considering the security implications on this topic? We 
> > also have multiple file systems, multiple memory allocators, etc...
> 
> Exactly. I thought Linux was about the freedom of choice.

http://www.islinuxaboutchoice.com/

:)
