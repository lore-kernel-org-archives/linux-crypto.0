From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Crypto Fixes for 3.16
Date: Thu, 31 Jul 2014 21:59:08 +0800
Message-ID: <20140731135908.GA5834@gondor.apana.org.au>
References: <20120823083242.GA23102@gondor.apana.org.au>
 <20121109093005.GA25632@gondor.apana.org.au>
 <20130328082841.GA7425@gondor.apana.org.au>
 <20131203124129.GA12067@gondor.apana.org.au>
 <20131209115705.GA1361@gondor.apana.org.au>
 <20140101061016.GA22579@gondor.apana.org.au>
 <20140203125944.GA31446@gondor.apana.org.au>
 <20140710090314.GA15729@gondor.apana.org.au>
 <20140718105717.GA18087@gondor.apana.org.au>
 <20140728140507.GA11926@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Linus Torvalds <torvalds@linux-foundation.org>,
	"David S. Miller" <davem@davemloft.net>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.apana.org.au ([209.40.204.226]:54669 "EHLO
	helcar.apana.org.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751489AbaGaN7R (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 31 Jul 2014 09:59:17 -0400
Content-Disposition: inline
In-Reply-To: <20140728140507.GA11926@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Linus:

This push adds missing SELinux labeling to AF_ALG sockets which
apparently causes SELinux (or at least the SELinux people) to
misbehave :)

Please pull from

git://git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto-2.6.git

or

master.kernel.org:/pub/scm/linux/kernel/git/herbert/crypto-2.6.git


Milan Broz (1):
      crypto: af_alg - properly label AF_ALG socket

 crypto/af_alg.c |    2 ++
 1 file changed, 2 insertions(+)
 
Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
