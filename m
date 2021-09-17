Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 37348C43219
	for <linux-crypto@archiver.kernel.org>; Fri, 17 Sep 2021 15:15:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2410861248
	for <linux-crypto@archiver.kernel.org>; Fri, 17 Sep 2021 15:15:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344072AbhIQPRK (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 17 Sep 2021 11:17:10 -0400
Received: from mo4-p01-ob.smtp.rzone.de ([85.215.255.53]:21347 "EHLO
        mo4-p01-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244190AbhIQPQ3 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 17 Sep 2021 11:16:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1631891643;
    s=strato-dkim-0002; d=chronox.de;
    h=References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Cc:Date:
    From:Subject:Sender;
    bh=hXXk4nPUWnojCv6BJNGDklRDkogj+LUgMe4Oenl3dYI=;
    b=l7GJ9r7lsM9YdczXWFS7mEQH8e6hOUA82dtVNKyk21d0CCj2obzQ4Qk1WjbvvYOy/g
    mO/VVk3aARAk6eqjJ+3LwrpBOxYUgda/6mT6JgzJHgLRy9+Dz/mr8e8aveSjLvo+2VQx
    30UnyJYCQFbwXrJvIywTyWbBDwWOx6w92XOupgvVnaew8kLDwb1xweh47zlArwhWIgIc
    fv9/vtq/uyoFa0z623rAECkH0lfR7ACKLaPQDi7fFzO5xjrVrq5kTkqTQ34GdfU7fDzQ
    pcsbJzgHuHPk5z0Xj+2Mu9DQ2KsJ+cVwy/S4hzOdTASHe/QnFZsa9gkdF9f0pMwvNeK6
    Ibkg==
Authentication-Results: strato.com;
    dkim=none
X-RZG-AUTH: ":P2ERcEykfu11Y98lp/T7+hdri+uKZK8TKWEqNzyCzy1Sfr67uExK884EC0GFGHavLSFZjMdeXg=="
X-RZG-CLASS-ID: mo00
Received: from tauon.chronox.de
    by smtp.strato.de (RZmta 47.33.3 DYNA|AUTH)
    with ESMTPSA id f080d4x8HFE2ed0
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
        (Client did not present a certificate);
    Fri, 17 Sep 2021 17:14:02 +0200 (CEST)
Message-ID: <33c77eb10e91f50c1d39065147b6e085d2fd753c.camel@chronox.de>
Subject: Re: [PATCH v42 01/13] Linux Random Number Generator
From:   Stephan Mueller <smueller@chronox.de>
To:     kernel test robot <lkp@intel.com>, Tso Ted <tytso@mit.edu>,
        linux-crypto@vger.kernel.org
Cc:     kbuild-all@lists.01.org, Willy Tarreau <w@1wt.eu>,
        Nicolai Stange <nstange@suse.de>,
        LKML <linux-kernel@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        "Alexander E. Patrakov" <patrakov@gmail.com>,
        "Ahmed S. Darwish" <darwish.07@gmail.com>
Date:   Fri, 17 Sep 2021 17:14:01 +0200
In-Reply-To: <202109172238.fNcqoasE-lkp@intel.com>
References: <2645866.lzt4QeR4KX@positron.chronox.de>
         <202109172238.fNcqoasE-lkp@intel.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.38.4 (3.38.4-1.fc33) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Am Freitag, dem 17.09.2021 um 23:02 +0800 schrieb kernel test robot:
> Hi "Stephan,
> 
> Thank you for the patch! Perhaps something to improve:
> 
> [auto build test WARNING on herbert-crypto-2.6/master]
> [cannot apply to char-misc/char-misc-testing herbert-cryptodev-2.6/master
> v5.15-rc1 next-20210917]
> [If your patch is applied to the wrong git tree, kindly drop us a note.
> And when submitting patch, we suggest to use '--base' as documented in
> https://git-scm.com/docs/git-format-patch]
> 
> url:    
> https://github.com/0day-ci/linux/commits/Stephan-M-ller/dev-random-a-new-approach/20210917-174624
> base:   
> https://git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto-2.6.git maste
> r
> config: nds32-allyesconfig (attached as .config)
> compiler: nds32le-linux-gcc (GCC) 11.2.0
> reproduce (this is a W=1 build):
>         wget 
> https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O
> ~/bin/make.cross
>         chmod +x ~/bin/make.cross
>         # 
> https://github.com/0day-ci/linux/commit/335ce64ab466685e61b363a33a405c9c49c7a099
>         git remote add linux-review https://github.com/0day-ci/linux
>         git fetch --no-tags linux-review Stephan-M-ller/dev-random-a-new-
> approach/20210917-174624
>         git checkout 335ce64ab466685e61b363a33a405c9c49c7a099
>         # save the attached .config to linux build tree
>         COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-11.2.0 make.cross
> ARCH=nds32 
> 
> If you fix the issue, kindly add following tag as appropriate
> Reported-by: kernel test robot <lkp@intel.com>
> 
> All warnings (new ones prefixed by >>):
> 
> > > drivers/char/lrng/lrng_chacha20.c:35: warning: This comment starts with
> > > '/**', but isn't a kernel-doc comment. Refer Documentation/doc-
> > > guide/kernel-doc.rst
>     * Update of the ChaCha20 state by either using an unused buffer part or
> by

...

All comments will start with '/*' instead of '/**' from now on.

Thanks
Stephan

