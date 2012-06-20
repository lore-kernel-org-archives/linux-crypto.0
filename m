From: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
Subject: Re: [PATCH] crypto: tcrypt - Add mode 500 for ablkcipher test
Date: Wed, 20 Jun 2012 14:54:43 +0300
Message-ID: <20120620145443.86813sdrpknxwzs4@www.81.fi>
References: <1340190704-6445-1-git-send-email-arun.murthy@stericsson.com>
Mime-Version: 1.0
Content-Type: text/plain;
 charset=ISO-8859-1;
 DelSp="Yes";
 format="flowed"
Content-Transfer-Encoding: 7bit
Cc: linux-crypto@vger.kernel.org, herbert@gondor.apana.org.au,
	Berne Hebark <berne.hebark@stericsson.com>
To: Arun Murthy <arun.murthy@stericsson.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from sd-mail-sa-02.sanoma.fi ([158.127.18.162]:37409 "EHLO
	sd-mail-sa-02.sanoma.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754775Ab2FTLyq (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 20 Jun 2012 07:54:46 -0400
In-Reply-To: <1340190704-6445-1-git-send-email-arun.murthy@stericsson.com>
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Quoting Arun Murthy <arun.murthy@stericsson.com>:

> The existing mode 200 performs ecb(aes), cbc(aes), ctr(aes),  
> ecb(des), cbc(des)
> ecb(des3_ede), cbc(des3_ede) for synchronous block cihper. For  
> crypto hardware
> drivers ablkcipher's are used and hence add new mode 500 and its variants to
> perform the tests in asynchronous block cipher.
>
> Signed-off-by: Arun Murthy <arun.murthy@stericsson.com>
> Signed-off-by: Berne Hebark <berne.hebark@stericsson.com>
> Acked-by: Srinidhi Kasagar <srinidhi.kasagar@stericsson.com>
> Acked-by: Linus Walleij <linus.walleij@linaro.org>

Which tree are you using?

Commit 3f3baf359dd3cc56fbaf9a2fb1a425ce7c18dbff added async cipher  
speed tests for v3.3.

-Jussi
