From: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
Subject: Re: [PATCH] crypto/arc4: convert this stream cipher into a block
 cipher
Date: Fri, 12 Feb 2010 10:57:28 +0100
Message-ID: <20100212095728.GA2166@Chamillionaire.breakpoint.cc>
References: <Pine.LNX.4.64.1001260722080.20780@hs20-bc2-1.build.redhat.com>
 <20100209073718.GA17612@gondor.apana.org.au>
 <20100209145705.GA20421@Chamillionaire.breakpoint.cc>
 <20100209204519.GC26258@gondor.apana.org.au>
 <20100209211238.GC21548@Chamillionaire.breakpoint.cc>
 <20100209214522.GA27002@gondor.apana.org.au>
 <20100212084228.GA1535@Chamillionaire.breakpoint.cc>
 <4B7520A3.9010109@codelabs.ch>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	Mikulas Patocka <mpatocka@redhat.com>, mbroz@redhat.com,
	dm-devel@redhat.com, agk@redhat.com, linux-crypto@vger.kernel.org
To: Adrian-Ken Rueegsegger <ken@codelabs.ch>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([85.10.199.196]:40788 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750969Ab0BLJ5c (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 12 Feb 2010 04:57:32 -0500
Content-Disposition: inline
In-Reply-To: <4B7520A3.9010109@codelabs.ch>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

* Adrian-Ken Rueegsegger | 2010-02-12 10:34:27 [+0100]:

>Hi,
Hi,

>Sebastian Andrzej Siewior schrieb:
>> The name is still ecb(aes) but since this is provided by the blkcipher itself,
>Just to avoid any confusion you meant ecb(arc4) not ecb(aes) here right?

Yes, I do. Not sure how I got aes in there. I did not mix it up in the
patch :)

>
>-Adrian

Sebastian
