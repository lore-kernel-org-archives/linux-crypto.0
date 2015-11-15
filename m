From: SF Markus Elfring <elfring@users.sourceforge.net>
Subject: [PATCH 0/4] crypto-ixp4xx: Deletion of a few unnecessary checks
Date: Sun, 15 Nov 2015 19:45:21 +0100
Message-ID: <5648D2C1.8050603@users.sourceforge.net>
References: <5307CAA2.8060406@users.sourceforge.net>
 <alpine.DEB.2.02.1402212321410.2043@localhost6.localdomain6>
 <530A086E.8010901@users.sourceforge.net>
 <alpine.DEB.2.02.1402231635510.1985@localhost6.localdomain6>
 <530A72AA.3000601@users.sourceforge.net>
 <alpine.DEB.2.02.1402240658210.2090@localhost6.localdomain6>
 <530B5FB6.6010207@users.sourceforge.net>
 <alpine.DEB.2.10.1402241710370.2074@hadrien>
 <530C5E18.1020800@users.sourceforge.net>
 <alpine.DEB.2.10.1402251014170.2080@hadrien>
 <530CD2C4.4050903@users.sourceforge.net>
 <alpine.DEB.2.10.1402251840450.7035@hadrien>
 <530CF8FF.8080600@users.sourceforge.net>
 <alpine.DEB.2.02.1402252117150.2047@localhost6.localdomain6>
 <530DD06F.4090703@users.sourceforge.net>
 <alpine.DEB.2.02.1402262129250.2221@localhost6.localdomain6>
 <5317A59D.4@users.sourceforge.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Cc: LKML <linux-kernel@vger.kernel.org>,
	kernel-janitors@vger.kernel.org,
	Julia Lawall <julia.lawall@lip6.fr>
To: "David S. Miller" <davem@davemloft.net>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mout.web.de ([212.227.17.12]:51826 "EHLO mout.web.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751574AbbKOSpf (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Sun, 15 Nov 2015 13:45:35 -0500
In-Reply-To: <5317A59D.4@users.sourceforge.net>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Sun, 15 Nov 2015 19:39:00 +0100

Further update suggestions were taken into account after a patch
was applied from static source code analysis.

Markus Elfring (4):
  Delete unnecessary checks before the function call "dma_pool_destroy"
  Two function calls less in init_ixp_crypto() after error detection
  Reduce assignment for a variable in init_ixp_crypto()
  Less function calls in init_ixp_crypto() after error detection

 drivers/crypto/ixp4xx_crypto.c | 28 +++++++++++++++-------------
 1 file changed, 15 insertions(+), 13 deletions(-)

-- 
2.6.2
