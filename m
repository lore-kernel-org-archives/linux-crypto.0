From: "Carlo E. Prelz" <fluido@fluido.as>
Subject: Re: Camellia encryption module: incompatible
Date: Wed, 10 Sep 2008 16:58:16 +0200
Message-ID: <20080910145816.GA30598@frittella.fluido.as>
References: <20080906124449.GB28842@frittella.fluido.as> <20080906144250.GA8829@gondor.apana.org.au> <1220817342.24115.0.camel@brick>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
To: Harvey Harrison <harvey.harrison@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from fluido.speedxs.nl ([83.98.238.192]:47684 "EHLO fluido.as"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751654AbYIJO5v (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Wed, 10 Sep 2008 10:57:51 -0400
Content-Disposition: inline
In-Reply-To: <1220817342.24115.0.camel@brick>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

	Subject: Re: Camellia encryption module: incompatible
	Date: dom 07 set 08 12:55:42 -0700

Quoting Harvey Harrison (harvey.harrison@gmail.com):

> > > Was this intentional? I saw no indication about this on the notes that
> > > went with the patch. 
> > 
> > No this is not intentional.  Thanks for reminding me.
> > 
> > Harvey, I think I'm going to revert the bitops change for now.
> > 
> 
> Please do, I still haven't managed to to track down why this changes
> any behavior, I'll resubmit at a later date if I ever figure it out.

I can confirm that, with 2.6.27-rc6, my camellia-encrypted partition
mounts cleanly once more.

Thanks

Carlo

-- 
  *         Se la Strada e la sua Virtu' non fossero state messe da parte,
* K * Carlo E. Prelz - fluido@fluido.as             che bisogno ci sarebbe
  *               di parlare tanto di amore e di rettitudine? (Chuang-Tzu)
