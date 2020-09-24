Return-Path: <SRS0=z3ky=DB=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CE634C2D0A8
	for <linux-crypto@archiver.kernel.org>; Thu, 24 Sep 2020 03:09:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 93BA62311E
	for <linux-crypto@archiver.kernel.org>; Thu, 24 Sep 2020 03:09:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726350AbgIXDJI (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 23 Sep 2020 23:09:08 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:48784 "EHLO fornost.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726281AbgIXDJI (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 23 Sep 2020 23:09:08 -0400
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.0.7])
        by fornost.hmeau.com with smtp (Exim 4.92 #5 (Debian))
        id 1kLHcx-0000jF-FN; Thu, 24 Sep 2020 13:09:00 +1000
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Thu, 24 Sep 2020 13:08:59 +1000
Date:   Thu, 24 Sep 2020 13:08:59 +1000
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Corentin Labbe <clabbe.montjoie@gmail.com>
Cc:     kernel test robot <lkp@intel.com>, kbuild-all@lists.01.org,
        linux-kernel@vger.kernel.org,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Eric Biggers <ebiggers@kernel.org>
Subject: Re: [v2 PATCH] crypto: sun4i-ss - Fix sparse endianness markers
Message-ID: <20200924030859.GA8223@gondor.apana.org.au>
References: <202009061621.J89kO43Q%lkp@intel.com>
 <20200907062400.GA15841@gondor.apana.org.au>
 <20200907160029.GC11894@Red>
 <20200908050036.GA19817@gondor.apana.org.au>
 <20200910122248.GA22506@Red>
 <20200911041354.GA5275@gondor.apana.org.au>
 <20200914104058.GA14265@Red>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200914104058.GA14265@Red>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, Sep 14, 2020 at 12:40:58PM +0200, Corentin Labbe wrote:
>
> I got this on next-20200910/multi_v7_defconfig BigEndian
> [   12.137856] alg: hash: skipping comparison tests for md5-sun4i-ss because md5-generic is unavailable
> md5-sun4i-ss md5 reqs=763
> [   98.286632] alg: ahash: md5 test failed (wrong result) on test vector \"random: psize=65 ksize=0\", cfg=\"random: use_finup src_divs=[95.28%@+1052, <reimport>0.61%@+4046, 0.87%@+24, <reimport,nosimd>3.24%@+542] key_offset=54\"
> 
> So sun4i-ss is not involved.
> Strangely /proc/crypto show:
> name         : md5                                                                                  
> driver       : md5-generic                                                                          
> module       : md5                                                                                  
> priority     : 0                                                                                    
> refcnt       : 1                                                                                    
> selftest     : passed                                                                               
> internal     : no                                                                                   
> type         : shash                                                                                
> blocksize    : 64                                                                                   
> digestsize   : 16
> 
> and I didnt see anything failed/unknow in /proc/crypto
> 
> Why the failed algorithm is not visible ?

Please include the complete /proc/crypto after you get the error.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
