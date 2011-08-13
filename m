From: Thomas Meyer <thomas@m3y3r.de>
Subject: Re: [PATCH] n2_crypto: Fix a get/put_cpu() imbalance
Date: Sat, 13 Aug 2011 09:59:58 +0200
Message-ID: <1313222402.16820.12.camel@localhost.localdomain>
References: <1312619188.5589.27.camel@localhost.localdomain>
	 <20110810105958.GA2607@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: davem@davemloft.net, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from www17.your-server.de ([213.133.104.17]:54351 "EHLO
	www17.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750907Ab1HMIAl (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sat, 13 Aug 2011 04:00:41 -0400
In-Reply-To: <20110810105958.GA2607@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

From: Thomas Meyer <thomas@m3y3r.de>

Fix a get/put_cpu() imbalance in the error case when qp == NULL

Signed-off-by: Thomas Meyer <thomas@m3y3r.de>
---

Am Mittwoch, den 10.08.2011, 18:59 +0800 schrieb Herbert Xu:
On Sat, Aug 06, 2011 at 08:26:25AM +0000, Thomas Meyer wrote:
> > From: Thomas Meyer <thomas@m3y3r.de>
> > 
> > Fix a get/put_cpu() imbalance in the error case when qp == NULL
> > 
> > Signed-off-by: Thomas Meyer <thomas@m3y3r.de>
> 
> I tried to apply your patch but it doesn't work as your mailer
> has turned all the tabs into spaces.
> 

Actually this was not my mailer's fault...

> Please resend and make
> sure that you can still apply the patch that the list forwards
> back to you.
> 
> Thanks,
> 

diff --git a/drivers/crypto/n2_core.c b/drivers/crypto/n2_core.c
index d0183ddb..8944dab 100644
--- a/drivers/crypto/n2_core.c
+++ b/drivers/crypto/n2_core.c
@@ -1006,9 +1006,9 @@ static int n2_do_ecb(struct ablkcipher_request *req, bool encrypt)
 
 	spin_unlock_irqrestore(&qp->lock, flags);
 
+out:
 	put_cpu();
 
-out:
 	n2_chunk_complete(req, NULL);
 	return err;
 }
@@ -1096,9 +1096,9 @@ static int n2_do_chaining(struct ablkcipher_request *req, bool encrypt)
 
 	spin_unlock_irqrestore(&qp->lock, flags);
 
+out:
 	put_cpu();
 
-out:
 	n2_chunk_complete(req, err ? NULL : final_iv_addr);
 	return err;
 }
