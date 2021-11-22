Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7F739C433EF
	for <linux-crypto@archiver.kernel.org>; Mon, 22 Nov 2021 11:48:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236395AbhKVLvm (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 22 Nov 2021 06:51:42 -0500
Received: from mo4-p01-ob.smtp.rzone.de ([85.215.255.53]:10778 "EHLO
        mo4-p01-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239233AbhKVLvm (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 22 Nov 2021 06:51:42 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1637581665;
    s=strato-dkim-0002; d=chronox.de;
    h=References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Cc:Date:
    From:Subject:Sender;
    bh=Va5hWs1VX9Y9ooPFaLxshreMZpO4nVxZePaTQ9rd1vw=;
    b=kvkQvBHHYfMgldJJfXRg32NDXbpCH+OUs9kNJ8GNvBrnydZXTXANUEhnv4vui0Q7Y2
    QIaPR9Lz+28X4/abjff7i/9gGYJBnoSWQgrjPi13n2fJSjawUFmDXroY/4OmT6Atl4tI
    kSmsFSmRV/R3Ln8le0q3hcOM0QiB70xNl3hHMtaBbsSyea/hduI8qTbOXUb5/Olt8IWV
    oiVGg8pTv23rvIFIWNtRTZhpz4Ql9SStATdC8BdFOuOx6get8wahkHbYe4UywwnYB6wP
    YDcFUkdLyz3pwNfFRt8ukOgp59y1uljH+cpK6aXbG0rczs2tKDz61s9mkUfEXh+GPeHv
    M+mw==
Authentication-Results: strato.com;
    dkim=none
X-RZG-AUTH: ":P2ERcEykfu11Y98lp/T7+hdri+uKZK8TKWEqNyiHySGSa9k9xmwdNnzGHXPZIfSfAhhe"
X-RZG-CLASS-ID: mo00
Received: from tauon.chronox.de
    by smtp.strato.de (RZmta 47.34.6 DYNA|AUTH)
    with ESMTPSA id y09e43xAMBli1I4
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
        (Client did not present a certificate);
    Mon, 22 Nov 2021 12:47:44 +0100 (CET)
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
Subject: Re: [PATCH v43 01/15] Linux Random Number Generator
Date:   Mon, 22 Nov 2021 12:47:43 +0100
Message-ID: <5540546.7F5nsSknLy@tauon.chronox.de>
In-Reply-To: <202111221831.lPHo6KJJ-lkp@intel.com>
References: <4641592.OV4Wx5bFTl@positron.chronox.de> <202111221831.lPHo6KJJ-lkp@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Am Montag, 22. November 2021, 11:33:26 CET schrieb kernel test robot:

Hi,

> All errors (new ones prefixed by >>):
> >> drivers/char/lrng/lrng_chacha20.c:32:8: error: structure variable
> >> 'chacha20' with 'latent_entropy' attribute has a non-integer field
> >> 'block'
>       32 | struct chacha20_state chacha20 __latent_entropy;
> 
>          |        ^~~~~~~~~~~~~~
> 
> vim +32 drivers/char/lrng/lrng_chacha20.c

Thanks for the notification.

I think this is a false-positive discussed before. __latent_entropy is 
seemingly allowed for an entire linear buffer as seen in the declaration of 
the variable input_pool_data in driver/char/random.c which is an array of u32.

The struct chacha20_state is a linear buffer of u32 words. 

struct chacha20_block {
        u32 constants[4];
        union {
                u32 u[CHACHA_KEY_SIZE_WORDS];
                u8  b[CHACHA_KEY_SIZE];
        } key;
        u32 counter;
        u32 nonce[3];
};

Therefore it should be identical to the aforementioned example. The 
__latent_entropy marker therefore seems to be appropriate for this structure.

Ciao
Stephan



