Return-Path: <SRS0=F/PC=RY=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_NEOMUTT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AF1BAC43381
	for <linux-crypto@archiver.kernel.org>; Thu, 21 Mar 2019 11:42:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 87EF3218B0
	for <linux-crypto@archiver.kernel.org>; Thu, 21 Mar 2019 11:42:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727909AbfCULmP (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 21 Mar 2019 07:42:15 -0400
Received: from vmicros1.altlinux.org ([194.107.17.57]:48358 "EHLO
        vmicros1.altlinux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727883AbfCULmP (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 21 Mar 2019 07:42:15 -0400
Received: from imap.altlinux.org (imap.altlinux.org [194.107.17.38])
        by vmicros1.altlinux.org (Postfix) with ESMTP id 50ED972CC53;
        Thu, 21 Mar 2019 14:42:11 +0300 (MSK)
Received: from altlinux.org (sole.flsd.net [185.75.180.6])
        by imap.altlinux.org (Postfix) with ESMTPSA id 178504A4A16;
        Thu, 21 Mar 2019 14:42:11 +0300 (MSK)
Date:   Thu, 21 Mar 2019 14:42:10 +0300
From:   Vitaly Chikunov <vt@altlinux.org>
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     David Howells <dhowells@redhat.com>,
        Mimi Zohar <zohar@linux.ibm.com>,
        Dmitry Kasatkin <dmitry.kasatkin@gmail.com>,
        linux-integrity@vger.kernel.org, keyrings@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v7 02/11] crypto: akcipher - check the presence of
 callback before the call
Message-ID: <20190321114209.qdaql3kdtfsnfzla@altlinux.org>
Mail-Followup-To: Herbert Xu <herbert@gondor.apana.org.au>,
        David Howells <dhowells@redhat.com>,
        Mimi Zohar <zohar@linux.ibm.com>,
        Dmitry Kasatkin <dmitry.kasatkin@gmail.com>,
        linux-integrity@vger.kernel.org, keyrings@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20190301175918.29694-1-vt@altlinux.org>
 <20190301175918.29694-3-vt@altlinux.org>
 <20190321111918.4kr7vdgz23xzjwed@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=koi8-r
Content-Disposition: inline
In-Reply-To: <20190321111918.4kr7vdgz23xzjwed@gondor.apana.org.au>
User-Agent: NeoMutt/20171215-106-ac61c7
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Herbert,

On Thu, Mar 21, 2019 at 07:19:18PM +0800, Herbert Xu wrote:
> On Fri, Mar 01, 2019 at 08:59:09PM +0300, Vitaly Chikunov wrote:
> > Because with introduction of EC-RDSA and change in workings of RSA in
> > regard to sign/verify, akcipher could have not all callbacks defined,
> > check the presence of callbacks before calling them to increase
> > robustness.
> > 
> > Signed-off-by: Vitaly Chikunov <vt@altlinux.org>
> > ---
> >  include/crypto/akcipher.h | 25 ++++++++++++++++---------
> >  1 file changed, 16 insertions(+), 9 deletions(-)
> > 
> > diff --git a/include/crypto/akcipher.h b/include/crypto/akcipher.h
> > index 2d690494568c..f537fad1989f 100644
> > --- a/include/crypto/akcipher.h
> > +++ b/include/crypto/akcipher.h
> > @@ -268,7 +268,10 @@ static inline unsigned int crypto_akcipher_maxsize(struct crypto_akcipher *tfm)
> >  {
> >  	struct akcipher_alg *alg = crypto_akcipher_alg(tfm);
> >  
> > -	return alg->max_size(tfm);
> > +	if (alg->max_size)
> > +		return alg->max_size(tfm);
> > +	else
> > +		return 0;
> >  }
> 
> Please do these checks at registration time instead and provide
> default implementations as needed.

I guess patch "PATCH v7 01/11] KEYS: report to keyctl only actually
supported key ops" should also be removed and will infer anything from
presence of the callbacks.


Thanks,


> 
> Thanks,
> -- 
> Email: Herbert Xu <herbert@gondor.apana.org.au>
> Home Page: http://gondor.apana.org.au/~herbert/
> PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
