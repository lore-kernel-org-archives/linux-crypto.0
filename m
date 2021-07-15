Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9A77DC07E96
	for <linux-crypto@archiver.kernel.org>; Thu, 15 Jul 2021 05:25:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 70AB66136E
	for <linux-crypto@archiver.kernel.org>; Thu, 15 Jul 2021 05:25:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231718AbhGOF2g (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 15 Jul 2021 01:28:36 -0400
Received: from mo4-p01-ob.smtp.rzone.de ([81.169.146.167]:19389 "EHLO
        mo4-p01-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229675AbhGOF2g (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 15 Jul 2021 01:28:36 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1626326694;
    s=strato-dkim-0002; d=chronox.de;
    h=References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Cc:Date:
    From:Subject:Sender;
    bh=YvOvb7F9+bANpwvucgDOlOa9eGWo3BPDkvFZuhPIXrY=;
    b=jLsq06flzzaEXx/DputCqkaJwAU4avvqYoqEfIyhNkmfoLNUo1f1G0NyOEvr8/faWe
    odramQov7akwq71vQN9j8xfRtD6/3z+P7QuL8S0zUNiZh+pkowFdPNZ71vvusAwPqeBH
    Di8UTVUIHt2bpW5rpzSCHqUF1IU+t1EPUrLTdffXJFU5CtZSo9oNxKwFUvHIlmiOek/j
    M7TvyHVTNKFJE9EW5MhCuFe3lLdGjSuknPM6DUo4z2c4IxMNWtpPxS/moyvEyx31bpsC
    w+CFFX7rdzbLHmKUDFqeTfZEr58dtYAJeQKjoKo9HXYnqTl6AjenMgKp7c3lL7ZTsACN
    B5rQ==
Authentication-Results: strato.com;
    dkim=none
X-RZG-AUTH: ":P2ERcEykfu11Y98lp/T7+hdri+uKZK8TKWEqNyiHySGSa9k9xmwdNnzGHXPaLvSd940="
X-RZG-CLASS-ID: mo00
Received: from positron.chronox.de
    by smtp.strato.de (RZmta 47.28.1 DYNA|AUTH)
    with ESMTPSA id 9043bbx6F5Oq1F8
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
        (Client did not present a certificate);
    Thu, 15 Jul 2021 07:24:52 +0200 (CEST)
From:   Stephan =?ISO-8859-1?Q?M=FCller?= <smueller@chronox.de>
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
Subject: Re: [PATCH v41 01/13] Linux Random Number Generator
Date:   Thu, 15 Jul 2021 07:24:52 +0200
Message-ID: <2681052.7KKukIsK80@positron.chronox.de>
In-Reply-To: <202107150632.Yy6v9Pmq-lkp@intel.com>
References: <1944948.TYRkL7eqjW@positron.chronox.de> <202107150632.Yy6v9Pmq-lkp@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Am Donnerstag, 15. Juli 2021, 00:55:23 CEST schrieb kernel test robot:

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
> 
>     26
>     27	/*
>     28	 * Have a static memory blocks for the ChaCha20 DRNG instance to
> avoid calling 29	 * kmalloc too early in the boot cycle. For subsequent
> allocation requests, 30	 * such as per-NUMA-node DRNG instances, kmalloc
> will be used. 31	 */
> 
>   > 32	struct chacha20_state chacha20 __latent_entropy;
> 
>     33

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


