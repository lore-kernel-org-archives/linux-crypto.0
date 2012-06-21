From: Arun MURTHY <arun.murthy@stericsson.com>
Subject: RE: [PATCH] crypto: tcrypt - Add mode 500 for ablkcipher test
Date: Thu, 21 Jun 2012 06:20:47 +0200
Message-ID: <F45880696056844FA6A73F415B568C69595AFC1A06@EXDCVYMBSTM006.EQ1STM.local>
References: <1340190704-6445-1-git-send-email-arun.murthy@stericsson.com>
 <20120620145443.86813sdrpknxwzs4@www.81.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Cc: "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	"herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
	Berne HEBARK <berne.hebark@stericsson.com>
To: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>,
	Geanta Neag Horia Ioan-B05471 <B05471@freescale.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from eu1sys200aog106.obsmtp.com ([207.126.144.121]:55110 "EHLO
	eu1sys200aog106.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751900Ab2FUEV7 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Thu, 21 Jun 2012 00:21:59 -0400
In-Reply-To: <20120620145443.86813sdrpknxwzs4@www.81.fi>
Content-Language: en-US
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

> Quoting Arun Murthy <arun.murthy@stericsson.com>:
> 
> > The existing mode 200 performs ecb(aes), cbc(aes), ctr(aes),
> > ecb(des), cbc(des)
> > ecb(des3_ede), cbc(des3_ede) for synchronous block cihper. For
> > crypto hardware
> > drivers ablkcipher's are used and hence add new mode 500 and its
> variants to
> > perform the tests in asynchronous block cipher.
> >
> > Signed-off-by: Arun Murthy <arun.murthy@stericsson.com>
> > Signed-off-by: Berne Hebark <berne.hebark@stericsson.com>
> > Acked-by: Srinidhi Kasagar <srinidhi.kasagar@stericsson.com>
> > Acked-by: Linus Walleij <linus.walleij@linaro.org>
> 
> Which tree are you using?
> 
> Commit 3f3baf359dd3cc56fbaf9a2fb1a425ce7c18dbff added async cipher
> speed tests for v3.3.
> 

Sorry for spamming, unknowingly I was working on a different branch.

Thanks and Regards,
Arun R Murthy
-------------
