From: Sebastian Siewior <bigeasy@breakpoint.cc>
Subject: Re: [crypto] fix writting into unallocated memory in setkey_aligned
Date: Fri, 3 Aug 2007 15:58:56 +0200
Message-ID: <20070803135856.GD17687@Chamillionaire.breakpoint.cc>
References: <20070802125743.GC24639@Chamillionaire.breakpoint.cc> <20070803123425.GA25948@gondor.apana.org.au> <20070803132628.GC17687@Chamillionaire.breakpoint.cc> <20070803134302.GA26727@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Cc: linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([85.10.199.196]:45998 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761636AbXHCN66 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 3 Aug 2007 09:58:58 -0400
Content-Disposition: inline
In-Reply-To: <20070803134302.GA26727@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

* Herbert Xu | 2007-08-03 21:43:02 [+0800]:

>On Fri, Aug 03, 2007 at 03:26:28PM +0200, Sebastian Siewior wrote:
>> 
>> Why not? This is used by _any_ cipher/hash/... user in tree. Most of
>> algos specify an alignment of 3 what is very likely to become. I
>> checked IPsec and they allocated keys with an alignment of 7.
>> padlock-aes specifies an alignment of 15 so there is a 50-50 chance that
>> it will go well :)
>> I don't know if you count this as user, but tcrypt.c has an alignment of
>> 3 and the tgr hash needs 7.
>
>Thanks for checking.
np

>I'll get this pushed into stable too.

This bug is only available in upcomming v2.6.23, isn't it?

>Cheers,

Sebastian
