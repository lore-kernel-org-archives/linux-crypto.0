Return-Path: <SRS0=6oT7=ZS=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E0135C432C0
	for <linux-crypto@archiver.kernel.org>; Tue, 26 Nov 2019 19:31:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3B6FA20866
	for <linux-crypto@archiver.kernel.org>; Tue, 26 Nov 2019 19:31:07 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=chronox.de header.i=@chronox.de header.b="XfUYt5Ax"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726576AbfKZTbG (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 26 Nov 2019 14:31:06 -0500
Received: from mo4-p02-ob.smtp.rzone.de ([81.169.146.168]:28268 "EHLO
        mo4-p02-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726299AbfKZTbG (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 26 Nov 2019 14:31:06 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1574796664;
        s=strato-dkim-0002; d=chronox.de;
        h=References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
        X-RZG-CLASS-ID:X-RZG-AUTH:From:Subject:Sender;
        bh=ZFKAqYpbbjnGol8k3VcaYvgyvKkNLTdKc+1X7uXlroE=;
        b=XfUYt5AxuLESQ5gMBtfHO18ZAOWzUflCUigM7aHSjLFM4nL6uhZUsgWMsL6apnH+ri
        zyIJMXBnmWdFZxWTWCLEvDCvcytbZXSLqzQ5GWClhG5K4kh8/aicXLHQNEv0W9oK6x20
        wpDn2IThg6OguDbQB18zUoS9L6WPWbl1oJUZeMBCCYj9gORJlsWSJQUbR8nSNdzre2CR
        NRWrvS192g8wdW6UA39DlcdHFDPGykSPxKWf1BSTkOkponaELxg805e7Kl34wWT0RgoS
        B81ca9c7PQxXDFY9Xi5Ko766TnUVWNOcVGUiYaU5cKBdevmQiybqbQ2sRcIja4ukuvzO
        odSA==
X-RZG-AUTH: ":P2ERcEykfu11Y98lp/T7+hdri+uKZK8TKWEqNyiHySGSa9k9xmwdNnzGHXPaJvScdGvN"
X-RZG-CLASS-ID: mo00
Received: from tauon.chronox.de
        by smtp.strato.de (RZmta 45.0.2 DYNA|AUTH)
        with ESMTPSA id m074f2vAQJRY80E
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
        (Client did not present a certificate);
        Tue, 26 Nov 2019 20:27:34 +0100 (CET)
From:   Stephan Mueller <smueller@chronox.de>
To:     Julia Lawall <julia.lawall@inria.fr>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
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
        Randy Dunlap <rdunlap@infradead.org>,
        Arnd Bergmann <arnd@arndb.de>, kbuild-all@lists.01.org
Subject: Re: [PATCH v26 12/12] LRNG - add interface for gathering of raw entropy (fwd)
Date:   Tue, 26 Nov 2019 20:27:33 +0100
Message-ID: <3845228.ihUtNFa0QL@tauon.chronox.de>
In-Reply-To: <alpine.DEB.2.21.1911261903060.2605@hadrien>
References: <alpine.DEB.2.21.1911261903060.2605@hadrien>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Am Dienstag, 26. November 2019, 19:04:10 CET schrieb Julia Lawall:

Hi Julia,

> Hello,
> 
> Should something be done about the lock on line 162?

Yes, thank you for the report. There should be an unlock, naturally.

Ciao
Stephan


