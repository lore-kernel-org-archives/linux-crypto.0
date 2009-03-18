From: Martin Michlmayr <tbm@cyrius.com>
Subject: Re: [WIP/RFC] crypto: add support for Orion5X crypto engine
Date: Wed, 18 Mar 2009 17:33:11 +0100
Message-ID: <20090318163311.GN8453@deprecation.cyrius.com>
References: <20090317215844.GA23739@Chamillionaire.breakpoint.cc> <49C11965.9000200@teltonika.lt>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-arm-kernel@lists.arm.linux.org.uk,
	linux-crypto@vger.kernel.org
To: Sebastian Andrzej Siewior <arm-kernel@ml.breakpoint.cc>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from sorrow.cyrius.com ([65.19.161.204]:42953 "EHLO
	sorrow.cyrius.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750981AbZCRQfj (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 18 Mar 2009 12:35:39 -0400
Content-Disposition: inline
In-Reply-To: <49C11965.9000200@teltonika.lt>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

* Paulius Zaleckas <paulius.zaleckas@teltonika.lt> [2009-03-18 17:55]:
> > +config CRYPTO_DEV_MARVELL_CRYPTO_ENGINE
> 
> CRYPTO_DEV...CRYPTO_ENGINE
> Maybe CRYPTO_DEV_MARVELL would be enough?

... and since we're talking about naming issues, I think you should
replace "mav" with "mv" to be in line with other uses inside the
kernel (e.g. sata-mv).

Thanks for working on this driver!
-- 
Martin Michlmayr
http://www.cyrius.com/
