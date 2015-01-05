From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: aesni - fix "by8" variant for 128 bit keys
Date: Mon, 5 Jan 2015 21:36:55 +1100
Message-ID: <20150105103655.GB25200@gondor.apana.org.au>
References: <1419976254-30208-1-git-send-email-minipli@googlemail.com>
 <54A57F02.1020502@openvpn.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Mathias Krause <minipli@googlemail.com>,
	"David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org,
	Romain Francoise <romain@orebokech.com>,
	Chandramouli Narayanan <mouli@linux.intel.com>
To: James Yonan <james@openvpn.net>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.apana.org.au ([209.40.204.226]:33304 "EHLO
	helcar.apana.org.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751511AbbAEKhK (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 5 Jan 2015 05:37:10 -0500
Content-Disposition: inline
In-Reply-To: <54A57F02.1020502@openvpn.net>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, Jan 01, 2015 at 10:08:18AM -0700, James Yonan wrote:
> On 30/12/2014 14:50, Mathias Krause wrote:
> >The "by8" counter mode optimization is broken for 128 bit keys with
> >input data longer than 128 bytes. It uses the wrong key material for
> >en- and decryption.
> >
> >The key registers xkey0, xkey4, xkey8 and xkey12 need to be preserved
> >in case we're handling more than 128 bytes of input data -- they won't
> >get reloaded after the initial load. They must therefore be (a) loaded
> >on the first iteration and (b) be preserved for the latter ones. The
> >implementation for 128 bit keys does not comply with (a) nor (b).
> >
> >Fix this by bringing the implementation back to its original source
> >and correctly load the key registers and preserve their values by
> >*not* re-using the registers for other purposes.
> >
> >Kudos to James for reporting the issue and providing a test case
> >showing the discrepancies.
> >
> >Reported-by: James Yonan <james@openvpn.net>
> >Cc: Chandramouli Narayanan <mouli@linux.intel.com>
> >Cc: <stable@vger.kernel.org> # v3.18
> >Signed-off-by: Mathias Krause <minipli@googlemail.com>
> 
> This looks great, fixes the issue on 3.18.1 for all of our use cases.
> 
> Thanks to Mathias for putting this together.

Patch applied to crypto.  Thanks a lot!
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
