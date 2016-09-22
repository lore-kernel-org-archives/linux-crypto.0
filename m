From: levent demir <levent.demir@inria.fr>
Subject: Re: [BUG] crypto: atmel-aes - erro when compiling with
 VERBOSE_DEBUG enable
Date: Thu, 22 Sep 2016 14:45:57 +0200
Message-ID: <1474548357.12981.19.camel@inria.fr>
References: <20160922092629.GA5508@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Cc: linux-crypto@vger.kernel.org, cyrille.pitchen@atmel.com
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail3-relais-sop.national.inria.fr ([192.134.164.104]:44754
        "EHLO mail3-relais-sop.national.inria.fr" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752263AbcIVMqJ (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 22 Sep 2016 08:46:09 -0400
In-Reply-To: <20160922092629.GA5508@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Fix debug function call in atmel_aes_write

Signed-off-by: Levent DEMIR <levent.demir@inria.fr>
---
 drivers/crypto/atmel-aes.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/atmel-aes.c b/drivers/crypto/atmel-aes.c
index e3d40a8..2b0f926 100644
--- a/drivers/crypto/atmel-aes.c
+++ b/drivers/crypto/atmel-aes.c
@@ -317,7 +317,7 @@ static inline void atmel_aes_write(struct
atmel_aes_dev *dd,
 		char tmp[16];
 
 		dev_vdbg(dd->dev, "write 0x%08x into %s\n", value,
-			 atmel_aes_reg_name(offset, tmp));
+			atmel_aes_reg_name(offset, tmp, sizeof(tmp)));
 	}
 #endif /* VERBOSE_DEBUG */
 
-- 
2.5.5

Le jeudi 22 septembre 2016 à 17:26 +0800, Herbert Xu a écrit :
> levent demir <levent.demir@inria.fr> wrote:
> > Hello, 
> > 
> > if you enable VERBOSE_DEBUG and compile you will have the following
> > error : 
> > 
> > drivers/crypto/atmel-aes.c:323:5: error: too few arguments to function
> > 'atmel_aes_reg_name'
> >     atmel_aes_reg_name(offset, tmp));
> >     ^
> > include/linux/device.h:1306:41: note: in definition of macro 'dev_vdbg'
> >   dev_printk(KERN_DEBUG, dev, format, ##arg); \
> >                                         ^
> > drivers/crypto/atmel-aes.c:205:20: note: declared here
> > static const char *atmel_aes_reg_name(u32 offset, char *tmp, size_t sz)
> > 
> > Indeed, in atmel_aes_write function the call to atmel_aes_reg_name
> > contains only two arguments instead of 3 : 
> > 
> > atmel_aes_reg_name(offset, tmp));
> > 
> > To fix it, one has to only add the size of tmp as third argument : 
> > 
> > atmel_aes_reg_name(offset, tmp, sizeof(tmp)));
> 
> Thanks for the patch.  In order to apply it, you need to fix the
> white-space damage as well as add a sign-off.  For details please
> refer to Documentation/SubmittingPatches.
> 
> Cheers,
