Return-Path: <SRS0=JhzL=27=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4EA1CC33CA2
	for <linux-crypto@archiver.kernel.org>; Fri, 10 Jan 2020 08:28:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 22F822082E
	for <linux-crypto@archiver.kernel.org>; Fri, 10 Jan 2020 08:28:30 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=chronox.de header.i=@chronox.de header.b="jzDF/Nb2"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726940AbgAJI2a (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 10 Jan 2020 03:28:30 -0500
Received: from mo4-p03-ob.smtp.rzone.de ([81.169.146.172]:30152 "EHLO
        mo4-p03-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726735AbgAJI2a (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 10 Jan 2020 03:28:30 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1578644908;
        s=strato-dkim-0002; d=chronox.de;
        h=References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
        X-RZG-CLASS-ID:X-RZG-AUTH:From:Subject:Sender;
        bh=WeU7GSmu1EkFlO5QCvOiHrGIGIjXm22hmyaIrxBKF4s=;
        b=jzDF/Nb2WII27MmnSpakkGXAfR0wdYBNLoI2jHKtJM/rI1k5yDSDi5o5SRxH0ejjG2
        awaivvFrOJbfM37Mx0J3a0YQSwo2HQ7dgdjYjFwa2WXAA+jUuntye+DjSOfgU9f2cyDz
        i53xKgkEZYwW7zfq6pxYlLNrO6saAOhmgDiEXSKPYl2R739snLNWDKCoc8zOJlzo/Gtv
        0Y9SVHHofrsnvjKfrx7mW96+2wum9ZWCzYY/Tkbe0wR+C28owVTMGFxEw7bkaH0jqugA
        Ld32DVadIETPSugRv7bzBqMKqoznZi4BETzvjAXHgEv8wXLvJlCQllh1wAfsPXTC+4an
        sOJg==
X-RZG-AUTH: ":P2ERcEykfu11Y98lp/T7+hdri+uKZK8TKWEqNyiHySGSa9k9xmwdNnzGHXPZJPScHivh"
X-RZG-CLASS-ID: mo00
Received: from tauon.chronox.de
        by smtp.strato.de (RZmta 46.1.4 DYNA|AUTH)
        with ESMTPSA id u04585w0A8RL7xf
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
        (Client did not present a certificate);
        Fri, 10 Jan 2020 09:27:21 +0100 (CET)
From:   Stephan Mueller <smueller@chronox.de>
To:     Randy Dunlap <rdunlap@infradead.org>
Cc:     Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-crypto@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        linux-api@vger.kernel.org,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        "Alexander E. Patrakov" <patrakov@gmail.com>,
        "Ahmed S. Darwish" <darwish.07@gmail.com>,
        "Theodore Y. Ts'o" <tytso@mit.edu>, Willy Tarreau <w@1wt.eu>,
        Matthew Garrett <mjg59@srcf.ucam.org>,
        Vito Caputo <vcaputo@pengaru.com>,
        Andreas Dilger <adilger.kernel@dilger.ca>,
        Jan Kara <jack@suse.cz>, Ray Strode <rstrode@redhat.com>,
        William Jon McCann <mccann@jhu.edu>,
        zhangjs <zachary@baishancloud.com>,
        Andy Lutomirski <luto@kernel.org>,
        Florian Weimer <fweimer@redhat.com>,
        Lennart Poettering <mzxreary@0pointer.de>,
        Nicolai Stange <nstange@suse.de>,
        "Peter, Matthias" <matthias.peter@bsi.bund.de>,
        Marcelo Henrique Cerri <marcelo.cerri@canonical.com>,
        Roman Drahtmueller <draht@schaltsekun.de>,
        Neil Horman <nhorman@redhat.com>,
        Julia Lawall <julia.lawall@inria.fr>
Subject: Re: [PATCH v27 10/12] LRNG - add SP800-90B compliant health tests
Date:   Fri, 10 Jan 2020 09:27:20 +0100
Message-ID: <1988924.7r6H7Qibty@tauon.chronox.de>
In-Reply-To: <cd9e893a-ce63-4e9a-fc19-553b1c5f1cff@infradead.org>
References: <6157374.ptSnyUpaCn@positron.chronox.de> <2325404.ZKTBb4nKji@positron.chronox.de> <cd9e893a-ce63-4e9a-fc19-553b1c5f1cff@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Am Freitag, 10. Januar 2020, 01:20:44 CET schrieb Randy Dunlap:

Hi Randy,

I have removed the two stars in front of each comment.

I have also fixed the respective comments in lrng_interfaces.c, 
lrng_archrandom.c, lrng_chacha20.c, lrng_drng.c, lrng_pool.c, lrng_switch.c, 
lrng_sw_noise.c. In all other files there were no changes needed.

Thank you.


Ciao
Stephan


