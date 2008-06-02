From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] tcrypt: add self test for des3_ebe cipher operating in cbc mode
Date: Mon, 2 Jun 2008 22:48:48 +1000
Message-ID: <20080602124847.GA25391@gondor.apana.org.au>
References: <20080523195145.GA28328@hmsreliant.think-freely.org> <20080524000624.GB26747@gondor.apana.org.au> <20080524003458.GB10168@localhost.localdomain> <4841F6F6.2020502@swiss-it.ch> <20080601160349.GA29225@localhost.localdomain> <4842C9CA.9070506@swiss-it.ch> <20080601221839.GA5171@localhost.localdomain> <48432622.1090300@swiss-it.ch> <20080602083210.GA22264@gondor.apana.org.au> <20080602124542.GA15844@hmsreliant.think-freely.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Adrian-Ken Rueegsegger <rueegsegger@swiss-it.ch>,
	linux-crypto@vger.kernel.org, davem@davemloft.net
To: Neil Horman <nhorman@tuxdriver.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:56507 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753763AbYFBMs4 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 2 Jun 2008 08:48:56 -0400
Content-Disposition: inline
In-Reply-To: <20080602124542.GA15844@hmsreliant.think-freely.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, Jun 02, 2008 at 08:45:42AM -0400, Neil Horman wrote:
>
> Copy that.  I think I found the problem, anyway.  The verdict is that Adrian was
> right, and I'm klutz.  I mixed up the output vector from a successful and a
> failed test during development.  I'll repost shortly.  Sorry for the trouble!

No worries.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
