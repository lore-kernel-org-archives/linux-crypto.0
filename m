Return-Path: <SRS0=8Gy4=RD=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_NEOMUTT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5212DC43381
	for <linux-crypto@archiver.kernel.org>; Thu, 28 Feb 2019 05:37:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 272F421850
	for <linux-crypto@archiver.kernel.org>; Thu, 28 Feb 2019 05:37:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730669AbfB1FhL (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 28 Feb 2019 00:37:11 -0500
Received: from vmicros1.altlinux.org ([194.107.17.57]:43504 "EHLO
        vmicros1.altlinux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725862AbfB1FhK (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 28 Feb 2019 00:37:10 -0500
Received: from imap.altlinux.org (imap.altlinux.org [194.107.17.38])
        by vmicros1.altlinux.org (Postfix) with ESMTP id 5545A72CC53;
        Thu, 28 Feb 2019 08:37:07 +0300 (MSK)
Received: from altlinux.org (sole.flsd.net [185.75.180.6])
        by imap.altlinux.org (Postfix) with ESMTPSA id 370A64A4AE7;
        Thu, 28 Feb 2019 08:37:07 +0300 (MSK)
Date:   Thu, 28 Feb 2019 08:37:07 +0300
From:   Vitaly Chikunov <vt@altlinux.org>
To:     Mimi Zohar <zohar@linux.ibm.com>
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        David Howells <dhowells@redhat.com>,
        linux-integrity@vger.kernel.org, keyrings@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5 04/10] crypto: akcipher - new verify API for public
 key algorithms
Message-ID: <20190228053707.xdod46ohnobtyt4g@altlinux.org>
Mail-Followup-To: Mimi Zohar <zohar@linux.ibm.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        David Howells <dhowells@redhat.com>,
        linux-integrity@vger.kernel.org, keyrings@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20190224060828.2527-1-vt@altlinux.org>
 <20190224060828.2527-5-vt@altlinux.org>
 <1551310117.10911.108.camel@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=koi8-r
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1551310117.10911.108.camel@linux.ibm.com>
User-Agent: NeoMutt/20171215-106-ac61c7
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, Feb 27, 2019 at 06:28:37PM -0500, Mimi Zohar wrote:
> 
> On Sun, 2019-02-24 at 09:08 +0300, Vitaly Chikunov wrote:
> > Previous akcipher .verify() just `decrypts' (using RSA encrypt which is
> > using public key) signature to uncover message hash, which was then
> > compared in upper level public_key_verify_signature() with the expected
> > hash value, which itself was never passed into verify().
> > 
> > This approach was incompatible with EC-DSA family of algorithms,
> > because, to verify a signature EC-DSA algorithm also needs a hash value
> > as input; then it's used (together with a signature divided into halves
> > `r||s') to produce a witness value, which is then compared with `r' to
> > determine if the signature is correct. Thus, for EC-DSA, nor
> > requirements of .verify() itself, nor its output expectations in
> > public_key_verify_signature() wasn't sufficient.
> > 
> > Make improved .verify() call which gets hash value as input and produce
> > complete signature check without any output besides status.
> > 
> > Now for the top level verification only crypto_akcipher_verify() needs
> > to be called.
> 
> All but this patch apply. šWhich branch is this patch based against?

This patchest is over 920d7f7215d87005beb4aa2b90b9cb0b74b36947 in
cryptodev/master.

> 
> Mimi
