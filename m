From: Sebastian Siewior <linux-crypto@ml.breakpoint.cc>
Subject: Re: [crypto] fix writting into unallocated memory in setkey_aligned
Date: Fri, 3 Aug 2007 15:26:28 +0200
Message-ID: <20070803132628.GC17687@Chamillionaire.breakpoint.cc>
References: <20070802125743.GC24639@Chamillionaire.breakpoint.cc> <20070803123425.GA25948@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Cc: linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([85.10.199.196]:51351 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756876AbXHCN0c (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 3 Aug 2007 09:26:32 -0400
Content-Disposition: inline
In-Reply-To: <20070803123425.GA25948@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

* Herbert Xu | 2007-08-03 20:34:25 [+0800]:

>On Thu, Aug 02, 2007 at 02:57:43PM +0200, Sebastian Siewior wrote:
>> setkey_unaligned() commited in ca7c39385ce1a7b44894a4b225a4608624e90730
>> overwrites unallocated memory in the following memset() because I used the
>> wrong buffer length.
>
>Good catch.  Thanks!
>
>We don't have any in-tree users that will trigger this right
>now do we?

Why not? This is used by _any_ cipher/hash/... user in tree. Most of
algos specify an alignment of 3 what is very likely to become. I
checked IPsec and they allocated keys with an alignment of 7.
padlock-aes specifies an alignment of 15 so there is a 50-50 chance that
it will go well :)
I don't know if you count this as user, but tcrypt.c has an alignment of
3 and the tgr hash needs 7.

>Cheers,

Cheers,
Sebastian
