From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [BUGFIX] crypto: Fix ctr(aes) testing by specifying geniv
Date: Thu, 13 Aug 2009 23:12:53 +1000
Message-ID: <20090813131253.GA27289@gondor.apana.org.au>
References: <1249285483-22286-1-git-send-email-ying.huang@intel.com> <20090805094506.GA12528@gondor.apana.org.au> <1249524767.24238.318.camel@yhuang-dev.sh.intel.com> <1250044020.5337.214.camel@yhuang-dev.sh.intel.com> <20090813045300.GA19993@gondor.apana.org.au> <20090813073910.GA21784@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
To: Huang Ying <ying.huang@intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:40515 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753847AbZHMNMy (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 13 Aug 2009 09:12:54 -0400
Content-Disposition: inline
In-Reply-To: <20090813073910.GA21784@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, Aug 13, 2009 at 05:39:10PM +1000, Herbert Xu wrote:
> 
> Oh I see what's going on.  It's the switch from chainiv to eseqiv
> that created the error.  I'll apply your patch.

Actually we can't use seqiv on raw counter mode because it cannot
guarantee IV uniqueness.  I think reverting to chainiv is the safer
option.

commit aef27136b8b5e526f2e96ca1caa30a6d07e70f42
Author: Herbert Xu <herbert@gondor.apana.org.au>
Date:   Thu Aug 13 23:10:39 2009 +1000

    crypto: ctr - Use chainiv on raw counter mode
    
    Raw counter mode only works with chainiv, which is no longer
    the default IV generator on SMP machines.  This broke raw counter
    mode as it can no longer instantiate as a givcipher.
    
    This patch fixes it by always picking chainiv on raw counter
    mode.  This is based on the diagnosis and a patch by Huang
    Ying.
    
    Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

diff --git a/crypto/ctr.c b/crypto/ctr.c
index 2d7425f..6c3bfab 100644
--- a/crypto/ctr.c
+++ b/crypto/ctr.c
@@ -219,6 +219,8 @@ static struct crypto_instance *crypto_ctr_alloc(struct rtattr **tb)
 	inst->alg.cra_blkcipher.encrypt = crypto_ctr_crypt;
 	inst->alg.cra_blkcipher.decrypt = crypto_ctr_crypt;
 
+	inst->alg.cra_blkcipher.geniv = "chainiv";
+
 out:
 	crypto_mod_put(alg);
 	return inst;

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
