Return-Path: <SRS0=BuJA=DQ=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 877FFC433E7
	for <linux-crypto@archiver.kernel.org>; Fri,  9 Oct 2020 05:30:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2D45822244
	for <linux-crypto@archiver.kernel.org>; Fri,  9 Oct 2020 05:30:18 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="WLsTGBgL"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730626AbgJIFaR (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 9 Oct 2020 01:30:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730468AbgJIFaR (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 9 Oct 2020 01:30:17 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03D6CC0613D2;
        Thu,  8 Oct 2020 22:30:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:Content-Type:
        In-Reply-To:MIME-Version:Date:Message-ID:From:References:Cc:To:Subject:Sender
        :Reply-To:Content-ID:Content-Description;
        bh=4pjyAWId0ghwBgR3VsDX1F0k5S1+a8uKnwgxeFTVCIc=; b=WLsTGBgLuMFl4CVIpocMpZeRyd
        ocsjE7j4JS3MwzE15i5TDRAfYofvp7biITlQlb9cFZKVCVGL3K7m2i7mukTpLJJ/tMry37YMq+v0j
        yI7EOf9dsaSbNGwTn4UVI6VHFs1OFtGtSpFarjwO0aamVXfLokbhkwo4JS6OQF31qh2P9aqgFCZqN
        ZRwt1wwhxPDmrYkGk2Dc2ONg9ltQ/ITq5CiI8RAEoriw3ELKyriFVayhBfZerrdu/nClSYGnqp+MR
        PoLrLYiirwszTlU4ue6ybSOzBJ7gSXVgCkQaldFeyxirCFgIYg+rWVjSHp/Y41ilOKHSYtlzIJkWM
        00LvHgyg==;
Received: from [2601:1c0:6280:3f0::8280] (helo=dragon.site)
        by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kQkyl-00065Z-7f; Fri, 09 Oct 2020 05:30:07 +0000
Subject: Re: drivers/crypto/chelsio/chcr_ktls.c:1078: undefined reference to
 `tls_get_record'
To:     kernel test robot <lkp@intel.com>,
        Rohit Maheshwari <rohitm@chelsio.com>
Cc:     kbuild-all@lists.01.org, linux-kernel@vger.kernel.org,
        linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
References: <202008080002.xe30V0kb%lkp@intel.com>
From:   Randy Dunlap <rdunlap@infradead.org>
Message-ID: <c015720e-d83e-1400-a67f-ab1a736a3d7b@infradead.org>
Date:   Thu, 8 Oct 2020 22:30:02 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <202008080002.xe30V0kb%lkp@intel.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 8/7/20 9:16 AM, kernel test robot wrote:
> tree:   https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git master
> head:   86cfccb66937dd6cbf26ed619958b9e587e6a115
> commit: 5a4b9fe7fece62ecab6fb28fe92362f83b41c33e cxgb4/chcr: complete record tx handling
> date:   5 months ago
> config: parisc-randconfig-r013-20200807 (attached as .config)
> compiler: hppa-linux-gcc (GCC) 9.3.0
> reproduce (this is a W=1 build):
>          wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
>          chmod +x ~/bin/make.cross
>          git checkout 5a4b9fe7fece62ecab6fb28fe92362f83b41c33e
>          # save the attached .config to linux build tree
>          COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-9.3.0 make.cross ARCH=parisc
> 
> If you fix the issue, kindly add following tag as appropriate
> Reported-by: kernel test robot <lkp@intel.com>
> 
> All errors (new ones prefixed by >>):
> 
>     hppa-linux-ld: drivers/crypto/chelsio/chcr_ktls.o: in function `chcr_ktls_xmit':
>>> drivers/crypto/chelsio/chcr_ktls.c:1078: undefined reference to `tls_get_record'
>     hppa-linux-ld: drivers/crypto/chelsio/chcr_ktls.o: in function `.LC10':
>>> chcr_ktls.c:(.rodata.cst4+0x0): undefined reference to `tls_validate_xmit_skb'

Hi,
Has anyone tried to fix this build error?
It still fails on v5.9-rc8.

CONFIG_TLS=m
but
CONFIG_CRYPTO_DEV_CHELSIO=y
CONFIG_CHELSIO_TLS_DEVICE=y

so the builtin driver cannot reach the TLS loadable module symbols.

--
~Randy
