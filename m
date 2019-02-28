Return-Path: <SRS0=8Gy4=RD=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED,USER_AGENT_NEOMUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DC374C43381
	for <linux-crypto@archiver.kernel.org>; Thu, 28 Feb 2019 18:39:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id ABFED218CD
	for <linux-crypto@archiver.kernel.org>; Thu, 28 Feb 2019 18:39:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732957AbfB1Sj1 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 28 Feb 2019 13:39:27 -0500
Received: from vmicros1.altlinux.org ([194.107.17.57]:58248 "EHLO
        vmicros1.altlinux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732879AbfB1Sj0 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 28 Feb 2019 13:39:26 -0500
Received: from imap.altlinux.org (imap.altlinux.org [194.107.17.38])
        by vmicros1.altlinux.org (Postfix) with ESMTP id 2E47172CA65;
        Thu, 28 Feb 2019 21:39:24 +0300 (MSK)
Received: from altlinux.org (sole.flsd.net [185.75.180.6])
        by imap.altlinux.org (Postfix) with ESMTPSA id 0FC2F4A4AE7;
        Thu, 28 Feb 2019 21:39:24 +0300 (MSK)
Date:   Thu, 28 Feb 2019 21:39:23 +0300
From:   Vitaly Chikunov <vt@altlinux.org>
To:     David Howells <dhowells@redhat.com>
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        Mimi Zohar <zohar@linux.ibm.com>,
        linux-integrity@vger.kernel.org, keyrings@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5 04/10] crypto: akcipher - new verify API for public
 key algorithms
Message-ID: <20190228183923.5klzwli5zmeew54j@altlinux.org>
Mail-Followup-To: David Howells <dhowells@redhat.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Mimi Zohar <zohar@linux.ibm.com>, linux-integrity@vger.kernel.org,
        keyrings@vger.kernel.org, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20190224060828.2527-5-vt@altlinux.org>
 <20190224060828.2527-1-vt@altlinux.org>
 <14843.1551377934@warthog.procyon.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=koi8-r
Content-Disposition: inline
In-Reply-To: <14843.1551377934@warthog.procyon.org.uk>
User-Agent: NeoMutt/20171215-106-ac61c7
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

David,

On Thu, Feb 28, 2019 at 06:18:54PM +0000, David Howells wrote:
> Vitaly Chikunov <vt@altlinux.org> wrote:
> 
> > +	digest = kmemdup(sig->digest, sig->digest_size, GFP_KERNEL);
> > +	if (!digest)
> 
> You shouldn't need to copy the digest.  It's being passed in to the crypto
> algorithm, not extracted out.

That's how Herbert suggested to do it. Quoting FYI:

| On Fri, Feb 01, 2019 at 02:26:55PM +0800, Herbert Xu wrote:
| > On Fri, Jan 25, 2019 at 09:01:16PM +0300, Vitaly Chikunov wrote:
| > >
| > > @@ -781,36 +780,17 @@ static int tpm_key_verify_signature(const struct key *key,
| > >     if (!req)
| > >             goto error_free_tfm;
| > >
| > > -   ret = -ENOMEM;
| > > -   outlen = crypto_akcipher_maxsize(tfm);
| > > -   output = kmalloc(outlen, GFP_KERNEL);
| > > -   if (!output)
| > > -           goto error_free_req;
| > > -
| > > -   sg_init_one(&sig_sg, sig->s, sig->s_size);
| > > -   sg_init_one(&digest_sg, output, outlen);
| > > -   akcipher_request_set_crypt(req, &sig_sg, &digest_sg, sig->s_size,
| > > -                              outlen);
| > > +   sg_init_table(&src_sg, 2);
| > > +   sg_set_buf(&src_sg[0], sig->s, sig->s_size);
| > > +   sg_set_buf(&src_sg[1], sig->digest, sig->digest_size);
| > > +   akcipher_request_set_crypt(req, &src_sg, NULL, sig->s_size,
| > > +                              sig->digest_size);
| >
| > It's not clear that sig->digest is guaranteed to be kmalloc memory.
| > In any case, it's best not to mix unrelated changes in a single
| > patch.  So please keep the kmalloc on output and then copy
| > sig->digest into it and put output into the SG list.


> > +		if (memcmp(c, outbuf_enc, c_size)) {
> 
> Please use == 0 and != 0 with memcmp() and strcmp().  Their return values are
> kind of inverted in sense if you treat them as boolean.

OK.

Thanks!

