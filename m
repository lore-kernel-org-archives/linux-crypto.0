Return-Path: <SRS0=9Mwu=SN=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_NEOMUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B9345C282CE
	for <linux-crypto@archiver.kernel.org>; Thu, 11 Apr 2019 21:09:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8430F20850
	for <linux-crypto@archiver.kernel.org>; Thu, 11 Apr 2019 21:09:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727160AbfDKVJB (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 11 Apr 2019 17:09:01 -0400
Received: from vmicros1.altlinux.org ([194.107.17.57]:38818 "EHLO
        vmicros1.altlinux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726694AbfDKVJA (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 11 Apr 2019 17:09:00 -0400
Received: from imap.altlinux.org (imap.altlinux.org [194.107.17.38])
        by vmicros1.altlinux.org (Postfix) with ESMTP id A79A672CC58;
        Fri, 12 Apr 2019 00:08:57 +0300 (MSK)
Received: from altlinux.org (sole.flsd.net [185.75.180.6])
        by imap.altlinux.org (Postfix) with ESMTPSA id 727D54A4A2A;
        Fri, 12 Apr 2019 00:08:57 +0300 (MSK)
Date:   Fri, 12 Apr 2019 00:08:57 +0300
From:   Vitaly Chikunov <vt@altlinux.org>
To:     Denis Kenzior <denkenz@gmail.com>,
        Herbert Xu <herbert@gondor.apana.org.au>
Cc:     linux-crypto@vger.kernel.org
Subject: Re: [PATCH v9 05/10] X.509: parse public key parameters from x509
 for akcipher
Message-ID: <20190411210856.sy3qagw6nhjpebbo@altlinux.org>
Mail-Followup-To: Denis Kenzior <denkenz@gmail.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        linux-crypto@vger.kernel.org
References: <20190411155122.13245-1-vt@altlinux.org>
 <20190411155122.13245-6-vt@altlinux.org>
 <48828e0e-0aef-dece-e7ad-4c0ea9cefbe7@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=koi8-r
Content-Disposition: inline
In-Reply-To: <48828e0e-0aef-dece-e7ad-4c0ea9cefbe7@gmail.com>
User-Agent: NeoMutt/20171215-106-ac61c7
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Denis, Herbert,

On Thu, Apr 11, 2019 at 12:18:36PM -0500, Denis Kenzior wrote:
> Hi Vitaly,
> 
> On 04/11/2019 10:51 AM, Vitaly Chikunov wrote:
> > Some public key algorithms (like EC-DSA) keep in parameters field
> > important data such as digest and curve OIDs (possibly more for
> > different EC-DSA variants). Thus, just setting a public key (as
> > for RSA) is not enough.
> > 
> > Append parameters into the key stream for akcipher_set_{pub,priv}_key.
> > Appended data is: (u32) algo OID, (u32) parameters length, parameters
> > data.
> > 
> > This does not affect current akcipher API nor RSA ciphers (they could
> > ignore it). Idea of appending parameters to the key stream is by Herbert
> > Xu.
> > 
> > Cc: David Howells <dhowells@redhat.com>
> > Cc: Denis Kenzior <denkenz@gmail.com>
> > Cc: keyrings@vger.kernel.org
> > Signed-off-by: Vitaly Chikunov <vt@altlinux.org>
> > ---
> >   crypto/asymmetric_keys/asym_tpm.c         |  9 +++-
> >   crypto/asymmetric_keys/public_key.c       | 72 ++++++++++++++++++++++++-------
> >   crypto/asymmetric_keys/x509.asn1          |  2 +-
> >   crypto/asymmetric_keys/x509_cert_parser.c | 31 +++++++++++++
> >   crypto/testmgr.c                          | 24 +++++++++--
> >   crypto/testmgr.h                          |  5 +++
> >   include/crypto/akcipher.h                 | 18 ++++----
> >   include/crypto/public_key.h               |  4 ++
> >   8 files changed, 136 insertions(+), 29 deletions(-)
> > 
> 
> Looks good to me.
> 
> Reviewed-by: Denis Kenzior <denkenz@gmail.com>

Thanks!

> By the way:
> 
> > @@ -400,11 +401,12 @@ static inline int crypto_akcipher_set_pub_key(struct crypto_akcipher *tfm,
> >    * crypto_akcipher_set_priv_key() - Invoke set private key operation
> >    *
> >    * Function invokes the algorithm specific set key function, which knows
> > - * how to decode and interpret the encoded key
> > + * how to decode and interpret the encoded keya and parameters
> 
> Seems to be a stray 'a' after 'key'?

Ah! Herbert, should I resend the whole patchset with this typo fix, or
you could apply small change if you going to accept it?

Thanks,

> 
> Regards,
> -Denis
