From: Sebastian Andrzej Siewior <sebatian@breakpoint.cc>
Subject: Re: [PATCH] dm-crypt: disable block encryption with arc4
Date: Tue, 9 Feb 2010 15:57:05 +0100
Message-ID: <20100209145705.GA20421@Chamillionaire.breakpoint.cc>
References: <Pine.LNX.4.64.1001260722080.20780@hs20-bc2-1.build.redhat.com>
 <20100209073718.GA17612@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Cc: Mikulas Patocka <mpatocka@redhat.com>, mbroz@redhat.com,
	linux-crypto@ml.breakpoint.cc, dm-devel@redhat.com, agk@redhat.com,
	linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([85.10.199.196]:33802 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753335Ab0BIO5M (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 9 Feb 2010 09:57:12 -0500
Content-Disposition: inline
In-Reply-To: <20100209073718.GA17612@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

* Herbert Xu | 2010-02-09 18:37:18 [+1100]:

>Mikulas Patocka <mpatocka@redhat.com> wrote:
>> 
>> You should rather add a flag CRYPTO_ALG_CHANGES_STATE to determine that a 
>> cipher can't be used to encrypt disks.
>
>No, please see my reply in the previous thread.  What we should
>do is fix arc4.  I just haven't got around to doing it yet.
>
>As to blacklisting algorithms not suitable for disk encryption,
>that is up to the dm-crypt maintainers to decide.

Herbert, what happend to the "check for streamcipher" idea you had? Is
it gone? On the other hand it wouldn't be probably that bad to have a
seprate interface to grab a block cipher _or_ a stream cipher. So
something like this wouldn't happen. This is basically the "check for
stream cipher" without encrypt = decrypt plus with a struct the cra_u
union.
I can't imaging how you want to fix arc4 that it will work in dm-crypt.
The algorithm relies more or less on the fact that it envolves itself
during processing of data.
Salsa works with dm-crypt because the internal state is taken from the
IV and is never written back. dm-crypt always encrypts/decrypts a 512
block in one go. Splitting it in two and requesting two 256 block
encryptions would work with _every_ other block cipher but break salsa.

>
>Cheers,

Sebastian
