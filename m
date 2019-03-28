Return-Path: <SRS0=b5bf=R7=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_NEOMUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7E4E4C43381
	for <linux-crypto@archiver.kernel.org>; Thu, 28 Mar 2019 06:16:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 55B152173C
	for <linux-crypto@archiver.kernel.org>; Thu, 28 Mar 2019 06:16:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725806AbfC1GQw (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 28 Mar 2019 02:16:52 -0400
Received: from vmicros1.altlinux.org ([194.107.17.57]:52468 "EHLO
        vmicros1.altlinux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725765AbfC1GQw (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 28 Mar 2019 02:16:52 -0400
Received: from imap.altlinux.org (imap.altlinux.org [194.107.17.38])
        by vmicros1.altlinux.org (Postfix) with ESMTP id CD4BE72CC64;
        Thu, 28 Mar 2019 09:16:48 +0300 (MSK)
Received: from altlinux.org (sole.flsd.net [185.75.180.6])
        by imap.altlinux.org (Postfix) with ESMTPSA id B19954A4AE9;
        Thu, 28 Mar 2019 09:16:48 +0300 (MSK)
Date:   Thu, 28 Mar 2019 09:16:48 +0300
From:   Vitaly Chikunov <vt@altlinux.org>
To:     Mimi Zohar <zohar@linux.ibm.com>
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        David Howells <dhowells@redhat.com>,
        Dmitry Kasatkin <dmitry.kasatkin@gmail.com>,
        linux-integrity@vger.kernel.org, keyrings@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v8 10/10] integrity: support EC-RDSA signatures for
 asymmetric_verify
Message-ID: <20190328061648.knexdusdcadubeu6@altlinux.org>
Mail-Followup-To: Mimi Zohar <zohar@linux.ibm.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        David Howells <dhowells@redhat.com>,
        Dmitry Kasatkin <dmitry.kasatkin@gmail.com>,
        linux-integrity@vger.kernel.org, keyrings@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20190326125842.24110-1-vt@altlinux.org>
 <20190326125842.24110-11-vt@altlinux.org>
 <1553710220.4608.9.camel@linux.ibm.com>
 <20190327201441.ikw76qzpgzm6t35b@altlinux.org>
 <1553718067.4608.43.camel@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=koi8-r
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1553718067.4608.43.camel@linux.ibm.com>
User-Agent: NeoMutt/20171215-106-ac61c7
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, Mar 27, 2019 at 04:21:07PM -0400, Mimi Zohar wrote:
> > > diff --git a/security/integrity/digsig_asymmetric.c
> b/security/integrity/digsig_asymmetric.c
> > > > index d775e03fbbcc..99080871eb9f 100644
> > > > --- a/security/integrity/digsig_asymmetric.c
> > > > +++ b/security/integrity/digsig_asymmetric.c
> > > > @@ -104,9 +104,16 @@ int asymmetric_verify(struct key *keyring, const char *sig,
> > > >  
> > > >  	memset(&pks, 0, sizeof(pks));
> > > >  
> > > > -	pks.pkey_algo = "rsa";
> > > >  	pks.hash_algo = hash_algo_name[hdr->hash_algo];
> > > > -	pks.encoding = "pkcs1";
> > > > +	if (hdr->hash_algo == HASH_ALGO_STREEBOG_256 ||
> > > > +	    hdr->hash_algo == HASH_ALGO_STREEBOG_512) {
> > > > +		/* EC-RDSA and Streebog should go together. */
> > > > +		pks.pkey_algo = "ecrdsa";
> > > > +		pks.encoding = "raw";
> > > 
> > > IMA signatures are stored as xattrs, making them persistent. šSupport
> > > for streebog was upstreamed in linux-5.0. šThis change would break
> > > existing systems using streebog. šAs long as this is not yet a concern
> > 
> > In what sense it would break systems?
> 
> For example, if executable files are currently labeled with
> rsa/streebog signatures, then enforcing file data integrity I assume
> would break if the kernel uses ecrdsa/streebog.

Ah. No, I did not implement RSA(Streebog) intentionally, since Streebog is
not in the list of permitted hashes for PKCS1. You may notice this by the
lack of appropriate rsa_asn1_template[] entry.

Thanks,

> 
> Mimi
> 
> > 
> > Unless kernel crashes or signature is recognized as valid, I think, it should
> > not be called a break.
> > 
> > > Reviewed-by: šMimi Zohar <zohar@linux.ibm.com>
> > 
> > Thanks!
> > 
> > > 
> > > > +	} else {
> > > > +		pks.pkey_algo = "rsa";
> > > > +		pks.encoding = "pkcs1";
> > > > +	}
> > > >  	pks.digest = (u8 *)data;
> > > >  	pks.digest_size = datalen;
> > > >  	pks.s = hdr->sig;
> > 
