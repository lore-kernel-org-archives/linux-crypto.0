Return-Path: <SRS0=PdDN=R6=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_NEOMUTT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 427B9C10F00
	for <linux-crypto@archiver.kernel.org>; Wed, 27 Mar 2019 20:14:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1F02B2087C
	for <linux-crypto@archiver.kernel.org>; Wed, 27 Mar 2019 20:14:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727451AbfC0UOr (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 27 Mar 2019 16:14:47 -0400
Received: from vmicros1.altlinux.org ([194.107.17.57]:44754 "EHLO
        vmicros1.altlinux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727089AbfC0UOr (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 27 Mar 2019 16:14:47 -0400
Received: from imap.altlinux.org (imap.altlinux.org [194.107.17.38])
        by vmicros1.altlinux.org (Postfix) with ESMTP id 5470572CC64;
        Wed, 27 Mar 2019 23:14:43 +0300 (MSK)
Received: from altlinux.org (sole.flsd.net [185.75.180.6])
        by imap.altlinux.org (Postfix) with ESMTPSA id 1B15B4A4AE9;
        Wed, 27 Mar 2019 23:14:43 +0300 (MSK)
Date:   Wed, 27 Mar 2019 23:14:41 +0300
From:   Vitaly Chikunov <vt@altlinux.org>
To:     Mimi Zohar <zohar@linux.ibm.com>
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        David Howells <dhowells@redhat.com>,
        Dmitry Kasatkin <dmitry.kasatkin@gmail.com>,
        linux-integrity@vger.kernel.org, keyrings@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v8 10/10] integrity: support EC-RDSA signatures for
 asymmetric_verify
Message-ID: <20190327201441.ikw76qzpgzm6t35b@altlinux.org>
Mail-Followup-To: Mimi Zohar <zohar@linux.ibm.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        David Howells <dhowells@redhat.com>,
        Dmitry Kasatkin <dmitry.kasatkin@gmail.com>,
        linux-integrity@vger.kernel.org, keyrings@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20190326125842.24110-1-vt@altlinux.org>
 <20190326125842.24110-11-vt@altlinux.org>
 <1553710220.4608.9.camel@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=koi8-r
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1553710220.4608.9.camel@linux.ibm.com>
User-Agent: NeoMutt/20171215-106-ac61c7
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, Mar 27, 2019 at 02:10:20PM -0400, Mimi Zohar wrote:
> On Tue, 2019-03-26 at 15:58 +0300, Vitaly Chikunov wrote:
> > Allow to use EC-RDSA signatures for IMA by determining signature type by
> > the hash algorithm name. This works good for EC-RDSA since Streebog and
> > EC-RDSA should always be used together.
> > 
> > Cc: Mimi Zohar <zohar@linux.ibm.com>
> > Cc: Dmitry Kasatkin <dmitry.kasatkin@gmail.com>
> > Cc: linux-integrity@vger.kernel.org
> > Signed-off-by: Vitaly Chikunov <vt@altlinux.org>
> > ---
> >  security/integrity/digsig_asymmetric.c | 11 +++++++++--
> >  1 file changed, 9 insertions(+), 2 deletions(-)
> > 
> > diff --git a/security/integrity/digsig_asymmetric.c b/security/integrity/digsig_asymmetric.c
> > index d775e03fbbcc..99080871eb9f 100644
> > --- a/security/integrity/digsig_asymmetric.c
> > +++ b/security/integrity/digsig_asymmetric.c
> > @@ -104,9 +104,16 @@ int asymmetric_verify(struct key *keyring, const char *sig,
> >  
> >  	memset(&pks, 0, sizeof(pks));
> >  
> > -	pks.pkey_algo = "rsa";
> >  	pks.hash_algo = hash_algo_name[hdr->hash_algo];
> > -	pks.encoding = "pkcs1";
> > +	if (hdr->hash_algo == HASH_ALGO_STREEBOG_256 ||
> > +	    hdr->hash_algo == HASH_ALGO_STREEBOG_512) {
> > +		/* EC-RDSA and Streebog should go together. */
> > +		pks.pkey_algo = "ecrdsa";
> > +		pks.encoding = "raw";
> 
> IMA signatures are stored as xattrs, making them persistent. šSupport
> for streebog was upstreamed in linux-5.0. šThis change would break
> existing systems using streebog. šAs long as this is not yet a concern

In what sense it would break systems?

Unless kernel crashes or signature is recognized as valid, I think, it should
not be called a break.

> Reviewed-by: šMimi Zohar <zohar@linux.ibm.com>

Thanks!

> 
> > +	} else {
> > +		pks.pkey_algo = "rsa";
> > +		pks.encoding = "pkcs1";
> > +	}
> >  	pks.digest = (u8 *)data;
> >  	pks.digest_size = datalen;
> >  	pks.s = hdr->sig;
