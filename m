From: Geanta Neag Horia Ioan-B05471 <B05471@freescale.com>
Subject: RE: [PATCH] crypto: tcrypt - Add mode 500 for ablkcipher test
Date: Wed, 20 Jun 2012 11:44:31 +0000
Message-ID: <FD18E5D573A8AB48A365D4D78185DE99219F37@039-SN1MPN1-002.039d.mgd.msft.net>
References: <1340190704-6445-1-git-send-email-arun.murthy@stericsson.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Cc: Berne Hebark <berne.hebark@stericsson.com>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	"herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>
To: Arun Murthy <arun.murthy@stericsson.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from db3ehsobe003.messaging.microsoft.com ([213.199.154.141]:16159
	"EHLO db3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932115Ab2FTLok convert rfc822-to-8bit
	(ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Wed, 20 Jun 2012 07:44:40 -0400
In-Reply-To: <1340190704-6445-1-git-send-email-arun.murthy@stericsson.com>
Content-Language: en-US
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

> -----Original Message-----
> From: linux-crypto-owner@vger.kernel.org [mailto:linux-crypto-
> owner@vger.kernel.org] On Behalf Of Arun Murthy
> Sent: Wednesday, June 20, 2012 2:12 PM
> To: linux-crypto@vger.kernel.org; herbert@gondor.apana.org.au
> Cc: arun.murthy@stericsson.com; Berne Hebark
> Subject: [PATCH] crypto: tcrypt - Add mode 500 for ablkcipher test
> 
> The existing mode 200 performs ecb(aes), cbc(aes), ctr(aes), ecb(des),
> cbc(des)
> ecb(des3_ede), cbc(des3_ede) for synchronous block cihper. For crypto
> hardware
> drivers ablkcipher's are used and hence add new mode 500 and its variants
> to
> perform the tests in asynchronous block cipher.
> 
> Signed-off-by: Arun Murthy <arun.murthy@stericsson.com>
> Signed-off-by: Berne Hebark <berne.hebark@stericsson.com>
> Acked-by: Srinidhi Kasagar <srinidhi.kasagar@stericsson.com>
> Acked-by: Linus Walleij <linus.walleij@linaro.org>
> ---

You are using a deprecated tree (github ?).
Current crypto is located at git.kernel.org

Horia
