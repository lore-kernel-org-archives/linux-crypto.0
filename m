From: Julia Lawall <julia.lawall@lip6.fr>
Subject: Re: crypto: algif_skcipher - Require setkey before accept(2)
Date: Fri, 25 Dec 2015 07:54:48 +0100 (CET)
Message-ID: <alpine.DEB.2.02.1512250753010.2084@localhost6.localdomain6>
References: <201512241831.VN3LufSe%fengguang.wu@intel.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: kbuild-all@01.org, Dmitry Vyukov <dvyukov@google.com>,
	"David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
	syzkaller <syzkaller@googlegroups.com>,
	Kostya Serebryany <kcc@google.com>,
	Alexander Potapenko <glider@google.com>,
	Eric Dumazet <edumazet@google.com>,
	Sasha Levin <sasha.levin@oracle.com>,
	Kees Cook <keescook@google.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail2-relais-roc.national.inria.fr ([192.134.164.83]:61647 "EHLO
	mail2-relais-roc.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751513AbbLYGyw (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 25 Dec 2015 01:54:52 -0500
In-Reply-To: <201512241831.VN3LufSe%fengguang.wu@intel.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Lines 766, 767 don't look correct at all.

julia

On Thu, 24 Dec 2015, kbuild test robot wrote:

> In-Reply-To: <20151224093902.GA8235@gondor.apana.org.au>
> 
> [if your patch is applied to the wrong git tree, please drop us a note to help improving the system]
> Hi Herbert,
> 
> [auto build test WARNING on crypto/master]
> [also build test WARNING on next-20151223]
> [cannot apply to v4.4-rc6]
> 
> url:    https://github.com/0day-ci/linux/commits/Herbert-Xu/crypto-algif_skcipher-Require-setkey-before-accept-2/20151224-174142
> base:   https://git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto-2.6.git master
> :::::: branch date: 63 minutes ago
> :::::: commit date: 63 minutes ago
> 
> >> crypto/algif_skcipher.c:767:18-21: ERROR: reference preceded by free on line 766
> 
> git remote add linux-review https://github.com/0day-ci/linux
> git remote update linux-review
> git checkout 7f3e28b295bcfeb7fba928af15780f1bb3051430
> vim +767 crypto/algif_skcipher.c
> 
> 7f3e28b2 Herbert Xu 2015-12-24  760  	tfm = kzalloc(sizeof(*tfm), GFP_KERNEL);
> 7f3e28b2 Herbert Xu 2015-12-24  761  	if (!tfm)
> 7f3e28b2 Herbert Xu 2015-12-24  762  		return ERR_PTR(-ENOMEM);
> 7f3e28b2 Herbert Xu 2015-12-24  763  
> 7f3e28b2 Herbert Xu 2015-12-24  764  	tfm->skcipher = crypto_alloc_skcipher(name, type, mask);
> 7f3e28b2 Herbert Xu 2015-12-24  765  	if (IS_ERR(tfm->skcipher)) {
> 7f3e28b2 Herbert Xu 2015-12-24 @766  		kfree(tfm);
> 7f3e28b2 Herbert Xu 2015-12-24 @767  		return ERR_CAST(tfm->skcipher);
> 7f3e28b2 Herbert Xu 2015-12-24  768  	}
> 7f3e28b2 Herbert Xu 2015-12-24  769  
> 7f3e28b2 Herbert Xu 2015-12-24  770  	return tfm;
> 
> ---
> 0-DAY kernel test infrastructure                Open Source Technology Center
> https://lists.01.org/pipermail/kbuild-all                   Intel Corporation
> 
