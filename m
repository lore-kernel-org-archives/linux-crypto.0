From: Todor Colov <todorcolov@gmail.com>
Subject: Re: IV is not send by kernel (ESP packet)
Date: Tue, 3 Jun 2014 06:23:09 +0000 (UTC)
Message-ID: <loom.20140603T081949-176@post.gmane.org>
References: <51ADDD52.8010404@wasko.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:36254 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932190AbaFCGaF (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Tue, 3 Jun 2014 02:30:05 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <glkc-linux-crypto@m.gmane.org>)
	id 1WriEV-0002G2-4d
	for linux-crypto@vger.kernel.org; Tue, 03 Jun 2014 08:30:03 +0200
Received: from zatc01cs102.atlanta.hp.com ([15.227.185.72])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-crypto@vger.kernel.org>; Tue, 03 Jun 2014 08:30:03 +0200
Received: from todorcolov by zatc01cs102.atlanta.hp.com with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-crypto@vger.kernel.org>; Tue, 03 Jun 2014 08:30:03 +0200
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Grzegorz,







IV generator "eseqiv" adds one block more with "seq of SA" to the "src" 

packet which is being encrypted with "IV salt" and send as IV.



Change your default IV generation method to "chainiv" and you'll solve the 



issue.Proposed patch is something like:







--- linux-3.14.4/crypto/cbc.c   2014-05-13 14:33:14.000000000 +0300







+++ linux-3.14.4-mod/crypto/cbc.c       2014-06-01 09:26:18.311525275 +0300







@@ -255,6 +255,7 @@







        inst->alg.cra_blkcipher.setkey = crypto_cbc_setkey;







         inst->alg.cra_blkcipher.encrypt = crypto_cbc_encrypt;







        inst->alg.cra_blkcipher.decrypt = crypto_cbc_decrypt;







+       inst->alg.cra_blkcipher.geniv = "chainiv";















 out_put_alg:







         crypto_mod_put(alg);















Regads,



Todor
