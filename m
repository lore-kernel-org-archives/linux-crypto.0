From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [dm-crypt] cryptsetup with arc4 cipher
Date: Sat, 8 Aug 2009 13:10:23 +1000
Message-ID: <20090808031023.GA14272@gondor.apana.org.au>
References: <87iqh050re.wl@obsidian.enotty.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: mbroz@redhat.com, linux-crypto@ml.breakpoint.cc, dm-crypt@saout.de,
	linux-crypto@vger.kernel.org
To: Stelios Bounanos <sb-lst@enotty.net>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:34089 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932892AbZHHDKp (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 7 Aug 2009 23:10:45 -0400
Content-Disposition: inline
In-Reply-To: <87iqh050re.wl@obsidian.enotty.net>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Stelios Bounanos <sb-lst@enotty.net> wrote:
>
>> Again, why crypto API allows to use it and do not produce error then?
> 
> Yes, if arc4 is only used for WEP perhaps the crypto API should emit an
> error earlier so that "cryptsetup luksOpen" fails.

I'm going to fix arc4 so that this "random" behaviour does not
occur.  However, that is not to say that it is a good idea to
use arc4 for disk encryption.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
