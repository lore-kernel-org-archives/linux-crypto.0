Return-Path: <SRS0=TFX5=DJ=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7F4BCC4363D
	for <linux-crypto@archiver.kernel.org>; Fri,  2 Oct 2020 13:57:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 447EA206E3
	for <linux-crypto@archiver.kernel.org>; Fri,  2 Oct 2020 13:57:29 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=chronox.de header.i=@chronox.de header.b="Mw4Zw7RV"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726176AbgJBN52 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 2 Oct 2020 09:57:28 -0400
Received: from mo4-p02-ob.smtp.rzone.de ([81.169.146.168]:12124 "EHLO
        mo4-p02-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726017AbgJBN52 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 2 Oct 2020 09:57:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1601647044;
        s=strato-dkim-0002; d=chronox.de;
        h=References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
        X-RZG-CLASS-ID:X-RZG-AUTH:From:Subject:Sender;
        bh=qvUTBmw7zaltg8PizsIdwYWZd2GA1Dicw6Gas7obdEk=;
        b=Mw4Zw7RVYBftoDXayBd4rnVOJDPchW8Q6qYN0tmIbDncP7lkph8VqWHM8on74j6h4U
        dNmPiFG3UNDCXK4FsMB32u+cKshPecBp9l2mJsvz72QfhBBpdSVKUOi07g/zlhOK+X+s
        Mj1ReKe1WUSnbkTKrTI7waHOWfhl7vzj96n0fYTXd96olsg5nRZ5Gp0MbkSxo43m2TZ2
        J3LQp5mYLuHpMQg8xvUHycXHLCTce37kQqryBJeWVSC126pX8rTj+Tf4x02qE8PQIOrx
        dVTeiMhXHt/E/BU1ux6FdnofTTKWgSwBeNuv1NKQo6wfaLPic2Yw4KlXel+09VO0ViU1
        Zmtw==
X-RZG-AUTH: ":P2ERcEykfu11Y98lp/T7+hdri+uKZK8TKWEqNyiHySGSa9k9xmwdNnzGHXPZJfSYkOI="
X-RZG-CLASS-ID: mo00
Received: from tauon.chronox.de
        by smtp.strato.de (RZmta 47.2.1 DYNA|AUTH)
        with ESMTPSA id C0b627w92DuT1IC
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
        (Client did not present a certificate);
        Fri, 2 Oct 2020 15:56:29 +0200 (CEST)
From:   Stephan Mueller <smueller@chronox.de>
To:     Torsten Duwe <duwe@lst.de>, Willy Tarreau <w@1wt.eu>
Cc:     "Theodore Y. Ts'o" <tytso@mit.edu>, linux-crypto@vger.kernel.org,
        Nicolai Stange <nstange@suse.de>,
        LKML <linux-kernel@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        "Alexander E. Patrakov" <patrakov@gmail.com>,
        "Ahmed S. Darwish" <darwish.07@gmail.com>,
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
        Neil Horman <nhorman@redhat.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Julia Lawall <julia.lawall@inria.fr>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Andy Lavr <andy.lavr@gmail.com>,
        Eric Biggers <ebiggers@kernel.org>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Petr Tesarik <ptesarik@suse.cz>
Subject: Re: [DISCUSSION PATCH 00/41] random: possible ways towards NIST SP800-90B compliance
Date:   Fri, 02 Oct 2020 15:56:28 +0200
Message-ID: <2961243.vtBmWVcJkq@tauon.chronox.de>
In-Reply-To: <20201002131555.GD3783@1wt.eu>
References: <20200921075857.4424-1-nstange@suse.de> <20201002123836.GA14807@lst.de> <20201002131555.GD3783@1wt.eu>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Am Freitag, 2. Oktober 2020, 15:15:55 CEST schrieb Willy Tarreau:

Hi Willy,

> > And this is all ???
> 
> Possibly a lot of people got used to seeing the numerous versions
> and are less attentive to new series, it's possible that your message
> will wake everyone up.

I think that points to my patch series. My patch series which provide a 
complete separate, API and ABI compliant drop in replacement of /dev/random, 
nobody from the gatekeepers cared to even answer. It would not touch the 
existing code.

After waiting some time without changing the code (e.g. after Andi Lutomirski 
commented), I got no answer at all from the gatekeepers, not even any 
indication in what direction I should move if something was not desired in the 
patch series.

Thus I continued adding the features that I think are necessary and for which 
I received comments from mathematicians. What else should I do?

With the patch set v35 of my patch series, I see all my goals finally 
achieved at I expect the code to be stable from here on. The last one was the 
hardest: to get rid of all non-cryptographic conditioning operations and yet 
retain performance en par or even superior to the existing /dev/random 
implementation.

Ciao
Stephan


