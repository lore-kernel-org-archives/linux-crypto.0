From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCHv2 0/3] crypto user API fixes
Date: Tue, 19 Feb 2013 20:27:55 +0800
Message-ID: <20130219122754.GA16499@gondor.apana.org.au>
References: <1360084755-11044-1-git-send-email-minipli@googlemail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "David S. Miller" <davem@davemloft.net>,
	Steffen Klassert <steffen.klassert@secunet.com>,
	linux-crypto@vger.kernel.org
To: Mathias Krause <minipli@googlemail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from sting.hengli.com.au ([178.18.18.71]:37881 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754510Ab3BSM2G (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 19 Feb 2013 07:28:06 -0500
Content-Disposition: inline
In-Reply-To: <1360084755-11044-1-git-send-email-minipli@googlemail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Feb 05, 2013 at 06:19:12PM +0100, Mathias Krause wrote:
> This series fixes kernel memory disclosures (aka info leaks) and a bug
> in the empty string test. In addition to the first version of this
> series it also ensures all user supplied strings are nul-terminated
> before using them.
> 
> Patch 1 is the same as in the first series, patch 2 was changed as
> suggested by Herbert, patch 3 is new.
> 
> Please apply!

All applied to crypto.  Thanks!
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
