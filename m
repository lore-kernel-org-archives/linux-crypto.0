Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8333CC433F5
	for <linux-crypto@archiver.kernel.org>; Mon, 22 Nov 2021 11:49:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239440AbhKVLwy (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 22 Nov 2021 06:52:54 -0500
Received: from mo4-p02-ob.smtp.rzone.de ([81.169.146.169]:14943 "EHLO
        mo4-p02-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239439AbhKVLwy (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 22 Nov 2021 06:52:54 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1637581740;
    s=strato-dkim-0002; d=chronox.de;
    h=References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Cc:Date:
    From:Subject:Sender;
    bh=idcm2fGiUVAqhb6CIXgEIpmN4C9IyNkJW12CfRNpqsM=;
    b=fZNPaSvszMsFkYjliAXe5BcuCYjid8DGur5eDy8duXn88gN1saGf6EFbZbxyIgbuXK
    vMpVhnE2ySirIttCUsu7EJnN+MGAn9SFmyRQeevZ8ruKhgkNOH+59FTEJTSZ2lkVDMhH
    uTrVePk1jzMBcjBDqr4mDVO6FiGVfzJmk8kbf+CtmkvsDEXaCEV65fgbCIqVhMg4/ZNc
    lyXKaI0xXgOqzkj6M25ADCzg6+e4pu51NDtUGkDUIvtHsSebXvWrIs3vFFnDvZU1eCUM
    o7hS/SpitCgV6PSU0Q9zXSeVEe5jLInxR1lG+o0Wu8xaLa9Vr86tzAocKT/PnaNzPBhB
    j+hg==
Authentication-Results: strato.com;
    dkim=none
X-RZG-AUTH: ":P2ERcEykfu11Y98lp/T7+hdri+uKZK8TKWEqNyiHySGSa9k9xmwdNnzGHXPZIfSfAhhe"
X-RZG-CLASS-ID: mo00
Received: from tauon.chronox.de
    by smtp.strato.de (RZmta 47.34.6 DYNA|AUTH)
    with ESMTPSA id y09e43xAMBmx1IY
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
        (Client did not present a certificate);
    Mon, 22 Nov 2021 12:48:59 +0100 (CET)
From:   Stephan Mueller <smueller@chronox.de>
To:     Tso Ted <tytso@mit.edu>, linux-crypto@vger.kernel.org,
        kernel test robot <lkp@intel.com>
Cc:     kbuild-all@lists.01.org, Willy Tarreau <w@1wt.eu>,
        Nicolai Stange <nstange@suse.de>,
        LKML <linux-kernel@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        "Alexander E. Patrakov" <patrakov@gmail.com>,
        "Ahmed S. Darwish" <darwish.07@gmail.com>
Subject: Re: [PATCH v43 05/15] LRNG - CPU entropy source
Date:   Mon, 22 Nov 2021 12:48:59 +0100
Message-ID: <2163781.cDACm6s5pA@tauon.chronox.de>
In-Reply-To: <202111221515.dn88DKHw-lkp@intel.com>
References: <6686472.9J7NaK4W3v@positron.chronox.de> <202111221515.dn88DKHw-lkp@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Am Montag, 22. November 2021, 08:09:59 CET schrieb kernel test robot:

Hi,

> All warnings (new ones prefixed by >>):
> >> drivers/char/lrng/lrng_es_archrandom.c:81:1: warning: 'inline' is not at
> >> beginning of declaration [-Wold-style-declaration]
>       81 | static u32 inline lrng_get_arch_data_compress(u8 *outbuf, u32
> requested_bits,
>          | ^~~~~~

Thank you for the note, this will be fixed.

Ciao
Stephan


