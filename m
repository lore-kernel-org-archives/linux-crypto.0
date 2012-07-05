From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Subject: Re: [PATCH] crypto: twofish-avx - remove useless instruction
Date: Thu, 5 Jul 2012 20:46:12 -0300
Message-ID: <20120705234612.GD29301@khazad-dum.debian.net>
References: <20120705184358.GE2091@kronos.redsun>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
To: Johannes Goetzfried
	<Johannes.Goetzfried@informatik.stud.uni-erlangen.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:41386 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753476Ab2GEXqR (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 5 Jul 2012 19:46:17 -0400
Content-Disposition: inline
In-Reply-To: <20120705184358.GE2091@kronos.redsun>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, 05 Jul 2012, Johannes Goetzfried wrote:
> The register %rdx is written, but never read till the end of the encryption
> routine. Therefore let's delete the useless instruction.

Is it useless, or is it there to harden against some side-channel
attack?

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
