From: Adrian-Ken Rueegsegger <ken@codelabs.ch>
Subject: Re: [PATCH] crypto/arc4: convert this stream cipher into a block
 cipher
Date: Fri, 12 Feb 2010 10:34:27 +0100
Message-ID: <4B7520A3.9010109@codelabs.ch>
References: <Pine.LNX.4.64.1001260722080.20780@hs20-bc2-1.build.redhat.com> <20100209073718.GA17612@gondor.apana.org.au> <20100209145705.GA20421@Chamillionaire.breakpoint.cc> <20100209204519.GC26258@gondor.apana.org.au> <20100209211238.GC21548@Chamillionaire.breakpoint.cc> <20100209214522.GA27002@gondor.apana.org.au> <20100212084228.GA1535@Chamillionaire.breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	Mikulas Patocka <mpatocka@redhat.com>, mbroz@redhat.com,
	dm-devel@redhat.com, agk@redhat.com, linux-crypto@vger.kernel.org
To: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mailx.swiss-it.ch ([81.6.4.203]:59170 "EHLO mailx.swiss-it.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751844Ab0BLJmI (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Fri, 12 Feb 2010 04:42:08 -0500
In-Reply-To: <20100212084228.GA1535@Chamillionaire.breakpoint.cc>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi,

Sebastian Andrzej Siewior schrieb:
> the state has been moved from ctx into iv. That way encrypt()/decrypt() can
> deliver the same result for a given IV. This patch makes the cipher work with
> dm-crypt not that it is a good thing. However, the performance may have
> improved :)
> The name is still ecb(aes) but since this is provided by the blkcipher itself,

Just to avoid any confusion you meant ecb(arc4) not ecb(aes) here right?

-Adrian
