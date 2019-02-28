Return-Path: <SRS0=8Gy4=RD=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_NEOMUTT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 45194C43381
	for <linux-crypto@archiver.kernel.org>; Thu, 28 Feb 2019 08:28:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1FED62184A
	for <linux-crypto@archiver.kernel.org>; Thu, 28 Feb 2019 08:28:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731200AbfB1I2G (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 28 Feb 2019 03:28:06 -0500
Received: from vmicros1.altlinux.org ([194.107.17.57]:51748 "EHLO
        vmicros1.altlinux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730832AbfB1I2G (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 28 Feb 2019 03:28:06 -0500
Received: from imap.altlinux.org (imap.altlinux.org [194.107.17.38])
        by vmicros1.altlinux.org (Postfix) with ESMTP id D68AC72CC53;
        Thu, 28 Feb 2019 11:28:02 +0300 (MSK)
Received: from altlinux.org (sole.flsd.net [185.75.180.6])
        by imap.altlinux.org (Postfix) with ESMTPSA id A23974A4AE7;
        Thu, 28 Feb 2019 11:28:02 +0300 (MSK)
Date:   Thu, 28 Feb 2019 11:28:01 +0300
From:   Vitaly Chikunov <vt@altlinux.org>
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     David Howells <dhowells@redhat.com>,
        Mimi Zohar <zohar@linux.vnet.ibm.com>,
        Dmitry Kasatkin <dmitry.kasatkin@gmail.com>,
        linux-integrity@vger.kernel.org, keyrings@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 1/4] X.509: Parse public key parameters from x509 for
 akcipher
Message-ID: <20190228082801.2aofw23r2shzwy4n@altlinux.org>
Mail-Followup-To: Herbert Xu <herbert@gondor.apana.org.au>,
        David Howells <dhowells@redhat.com>,
        Mimi Zohar <zohar@linux.vnet.ibm.com>,
        Dmitry Kasatkin <dmitry.kasatkin@gmail.com>,
        linux-integrity@vger.kernel.org, keyrings@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20190106133608.820-1-vt@altlinux.org>
 <20190106133608.820-2-vt@altlinux.org>
 <20190209214240.56gq7ivn3pw3bssf@altlinux.org>
 <20190210184628.yupsxgjlaicwbxg6@altlinux.org>
 <20190219043732.x3sbwzqlz4ikntxo@gondor.apana.org.au>
 <20190224064840.hii4ccjksjdnewae@altlinux.org>
 <20190228061444.3escryzoit3idtwg@gondor.apana.org.au>
 <20190228070449.gjwoq4c2b3x5grie@altlinux.org>
 <20190228075141.s6mftb44yuylbzys@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=koi8-r
Content-Disposition: inline
In-Reply-To: <20190228075141.s6mftb44yuylbzys@gondor.apana.org.au>
User-Agent: NeoMutt/20171215-106-ac61c7
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, Feb 28, 2019 at 03:51:41PM +0800, Herbert Xu wrote:
> On Thu, Feb 28, 2019 at 10:04:49AM +0300, Vitaly Chikunov wrote:
> > 
> > It seems that you insist on set_params to be removed and both key and
> > params to be passed into set_{pub,priv}_key. This means reworking all
> > existing RSA drivers and callers, right? Can you please confirm that
> > huge rework to avoid misunderstanding?
> 
> I don't understand why we even need to touch the existing RSA
> drivers.  Nothing needs to change as far as they're concerned.
> 
> Only the new algorithms would need to decode the extra parameters
> in the key stream.

        int (*set_pub_key)(struct crypto_akcipher *tfm, const void *key,
                           unsigned int keylen);
        int (*set_priv_key)(struct crypto_akcipher *tfm, const void *key,
                            unsigned int keylen);

So you want `keylen' not to cover parameters data, but parameters
actually present in key after `keylen' bytes (in come packed format)?
(And if there is no parameters appended, there is still appended some
marker, like 0, to signify that there is no parameters.)

This looks a bit counter-intuitive usage of arguments (as argument
signifying length does not cover all arguments data), is this ok to you?


More intuitive would be to add at least paramlen argument to signify how
much data is appended. Or (if we add argument anyway) additional
const void *params, unsigned int paramlen - which callers who don't
have params will pass NULL, and RSA drivers just ignore.

