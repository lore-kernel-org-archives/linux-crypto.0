From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: Camellia encryption module: incompatible
Date: Sun, 7 Sep 2008 00:42:50 +1000
Message-ID: <20080906144250.GA8829@gondor.apana.org.au>
References: <20080906124449.GB28842@frittella.fluido.as>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Harvey Harrison <harvey.harrison@gmail.com>,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
To: "Carlo E. Prelz" <fluido@fluido.as>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:57761 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751607AbYIFOm7 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sat, 6 Sep 2008 10:42:59 -0400
Content-Disposition: inline
In-Reply-To: <20080906124449.GB28842@frittella.fluido.as>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Sat, Sep 06, 2008 at 02:44:49PM +0200, Carlo E. Prelz wrote:
> Hello there. I see you are the person who pushed upwards changes
> related to the Linux crypto susbsystem for 2.6.27. I wanted to let you
> know that, on a Core2 laptop platform, the new code for the Camellia
> module generates different encrypted content. Both implementations
> work, but a file that was encrypted with pre-2.6.27 cannot be
> decrypted with the current code. 
> 
> Was this intentional? I saw no indication about this on the notes that
> went with the patch. 

No this is not intentional.  Thanks for reminding me.

Harvey, I think I'm going to revert the bitops change for now.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
