From: SF Markus Elfring <elfring@users.sourceforge.net>
Subject: [PATCH v2 0/3] crypto-ixp4xx: Deletion of a few unnecessary checks
Date: Tue, 17 Nov 2015 16:32:47 +0100
Message-ID: <564B489F.10308@users.sourceforge.net>
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
 <5317A59D.4@users.sourceforge.net> <5648D2C1.8050603@users.sourceforge.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Cc: LKML <linux-kernel@vger.kernel.org>,
	kernel-janitors@vger.kernel.org,
	Julia Lawall <julia.lawall@lip6.fr>
To: linux-crypto@vger.kernel.org,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mout.web.de ([212.227.15.3]:50342 "EHLO mout.web.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751711AbbKQPdD (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Tue, 17 Nov 2015 10:33:03 -0500
In-Reply-To: <5648D2C1.8050603@users.sourceforge.net>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Tue, 17 Nov 2015 16:26:01 +0100
Subject: [PATCH 0/3] crypto-ixp4xx: Deletion of a few unnecessary checks

Further update suggestions were taken into account after a patch
was applied from static source code analysis.

Markus Elfring (3):
  Delete unnecessary checks before the function call "dma_pool_destroy"
  Reduce assignment for a variable in init_ixp_crypto()
  crypto-ixp4xx: Less function calls in init_ixp_crypto() after error detection

 drivers/crypto/ixp4xx_crypto.c | 27 ++++++++++++++-------------
 1 file changed, 14 insertions(+), 13 deletions(-)

-- 
2.6.2
