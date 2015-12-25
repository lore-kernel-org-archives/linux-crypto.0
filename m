From: Julia Lawall <julia.lawall@lip6.fr>
Subject: Re: crypto: algif_skcipher - Require setkey before accept(2)
Date: Fri, 25 Dec 2015 09:38:29 +0100 (CET)
Message-ID: <alpine.DEB.2.02.1512250937550.2003@localhost6.localdomain6>
References: <201512241831.VN3LufSe%fengguang.wu@intel.com> <alpine.DEB.2.02.1512250753010.2084@localhost6.localdomain6> <20151225074112.GA14723@gondor.apana.org.au>
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
Received: from mail2-relais-roc.national.inria.fr ([192.134.164.83]:52773 "EHLO
	mail2-relais-roc.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751943AbbLYIic (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 25 Dec 2015 03:38:32 -0500
In-Reply-To: <20151225074112.GA14723@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>



On Fri, 25 Dec 2015, Herbert Xu wrote:

> On Fri, Dec 25, 2015 at 07:54:48AM +0100, Julia Lawall wrote:
> > Lines 766, 767 don't look correct at all.
> 
> Thanks Julia.  I have sent an updated patch in the original thread.
> I wonder why I haven't received the original kbuild test robot
> email though.

I goes to me to check for false positives first.

julia
