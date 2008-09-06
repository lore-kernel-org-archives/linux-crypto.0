From: "Carlo E. Prelz" <fluido@fluido.as>
Subject: Re: Camellia encryption module: incompatible
Date: Sat, 6 Sep 2008 22:57:56 +0200
Message-ID: <20080906205756.GB13532@frittella.fluido.as>
References: <20080906124449.GB28842@frittella.fluido.as> <20080906144250.GA8829@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: "Carlo E. Prelz" <fluido@fluido.as>,
	Harvey Harrison <harvey.harrison@gmail.com>,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from fluido.speedxs.nl ([83.98.238.192]:60416 "EHLO fluido.as"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752841AbYIFVCu (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Sat, 6 Sep 2008 17:02:50 -0400
Content-Disposition: inline
In-Reply-To: <20080906144250.GA8829@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

	Subject: Re: Camellia encryption module: incompatible
	Date: dom 07 set 08 12:42:50 +1000

Quoting Herbert Xu (herbert@gondor.apana.org.au):

> No this is not intentional.  Thanks for reminding me.

Thank you all for all the work that goes into maintaining Linux... 

> Harvey, I think I'm going to revert the bitops change for now.

I will be glad to verify that all is OK as soon as the change
percolates into a 2.6.27-rc patch.

Carlo

-- 
  *         Se la Strada e la sua Virtu' non fossero state messe da parte,
* K * Carlo E. Prelz - fluido@fluido.as             che bisogno ci sarebbe
  *               di parlare tanto di amore e di rettitudine? (Chuang-Tzu)
