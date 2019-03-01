Return-Path: <SRS0=jX8O=RE=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_NEOMUTT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7861DC43381
	for <linux-crypto@archiver.kernel.org>; Fri,  1 Mar 2019 16:06:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4EF082084F
	for <linux-crypto@archiver.kernel.org>; Fri,  1 Mar 2019 16:06:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388971AbfCAQGn (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 1 Mar 2019 11:06:43 -0500
Received: from vmicros1.altlinux.org ([194.107.17.57]:49976 "EHLO
        vmicros1.altlinux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727952AbfCAQGn (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 1 Mar 2019 11:06:43 -0500
Received: from imap.altlinux.org (imap.altlinux.org [194.107.17.38])
        by vmicros1.altlinux.org (Postfix) with ESMTP id 86BFC72CA65;
        Fri,  1 Mar 2019 19:06:39 +0300 (MSK)
Received: from altlinux.org (sole.flsd.net [185.75.180.6])
        by imap.altlinux.org (Postfix) with ESMTPSA id 63AC34A4AE7;
        Fri,  1 Mar 2019 19:06:39 +0300 (MSK)
Date:   Fri, 1 Mar 2019 19:06:38 +0300
From:   Vitaly Chikunov <vt@altlinux.org>
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     David Howells <dhowells@redhat.com>,
        Mimi Zohar <zohar@linux.vnet.ibm.com>,
        Dmitry Kasatkin <dmitry.kasatkin@gmail.com>,
        linux-integrity@vger.kernel.org, keyrings@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 1/4] X.509: Parse public key parameters from x509 for
 akcipher
Message-ID: <20190301160638.z266z767m4ky3ohk@altlinux.org>
Mail-Followup-To: Herbert Xu <herbert@gondor.apana.org.au>,
        David Howells <dhowells@redhat.com>,
        Mimi Zohar <zohar@linux.vnet.ibm.com>,
        Dmitry Kasatkin <dmitry.kasatkin@gmail.com>,
        linux-integrity@vger.kernel.org, keyrings@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20190210184628.yupsxgjlaicwbxg6@altlinux.org>
 <20190219043732.x3sbwzqlz4ikntxo@gondor.apana.org.au>
 <20190224064840.hii4ccjksjdnewae@altlinux.org>
 <20190228061444.3escryzoit3idtwg@gondor.apana.org.au>
 <20190228070449.gjwoq4c2b3x5grie@altlinux.org>
 <20190228075141.s6mftb44yuylbzys@gondor.apana.org.au>
 <20190228082801.2aofw23r2shzwy4n@altlinux.org>
 <20190228090125.6n62v4oxpwl5yzv4@gondor.apana.org.au>
 <20190228103337.sbjujn27qkkgxqt2@altlinux.org>
 <20190228103715.ijvimcfysiguiwty@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=koi8-r
Content-Disposition: inline
In-Reply-To: <20190228103715.ijvimcfysiguiwty@gondor.apana.org.au>
User-Agent: NeoMutt/20171215-106-ac61c7
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Herbert,

On Thu, Feb 28, 2019 at 06:37:15PM +0800, Herbert Xu wrote:
> On Thu, Feb 28, 2019 at 01:33:37PM +0300, Vitaly Chikunov wrote:
> >
> > To make the same for set_{pub,priv}_key it will require patching RSA
> > drivers anyway, since length of the key is stored just once as keylen
> > argument.
> 
> No we don't need to use the same format for different algorithms.
> RSA should stay as is.

I will rework as you suggest. But, just want to state that I disagree
with this approach of implicitly appending parameters data to the key
stream without any argument signifying it or length covering it. This
fitting into the old API is also somewhat disagree to your words that
we could change internal API:

On Thu, Feb 28, 2019 at 02:14:44PM +0800, Herbert Xu wrote:
> On Sun, Feb 24, 2019 at 09:48:40AM +0300, Vitaly Chikunov wrote:
> ...
> This compatibility does not matter.  We can always add translating
> layers into the crypto API to deal with this.  The only ABI that
> matters is the one to user-space.
