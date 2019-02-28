Return-Path: <SRS0=8Gy4=RD=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_NEOMUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 11A74C10F00
	for <linux-crypto@archiver.kernel.org>; Thu, 28 Feb 2019 19:07:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DCBEB20C01
	for <linux-crypto@archiver.kernel.org>; Thu, 28 Feb 2019 19:07:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726810AbfB1THq (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 28 Feb 2019 14:07:46 -0500
Received: from vmicros1.altlinux.org ([194.107.17.57]:59954 "EHLO
        vmicros1.altlinux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726214AbfB1THq (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 28 Feb 2019 14:07:46 -0500
Received: from imap.altlinux.org (imap.altlinux.org [194.107.17.38])
        by vmicros1.altlinux.org (Postfix) with ESMTP id B67D972CA65;
        Thu, 28 Feb 2019 22:07:42 +0300 (MSK)
Received: from altlinux.org (sole.flsd.net [185.75.180.6])
        by imap.altlinux.org (Postfix) with ESMTPSA id 6C4AE4A4AE7;
        Thu, 28 Feb 2019 22:07:42 +0300 (MSK)
Date:   Thu, 28 Feb 2019 22:07:42 +0300
From:   Vitaly Chikunov <vt@altlinux.org>
To:     David Howells <dhowells@redhat.com>
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        Mimi Zohar <zohar@linux.ibm.com>,
        linux-integrity@vger.kernel.org, keyrings@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5 04/10] crypto: akcipher - new verify API for public
 key algorithms
Message-ID: <20190228190741.fv2qxwwtlpdffhwq@altlinux.org>
Mail-Followup-To: David Howells <dhowells@redhat.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Mimi Zohar <zohar@linux.ibm.com>, linux-integrity@vger.kernel.org,
        keyrings@vger.kernel.org, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20190228183923.5klzwli5zmeew54j@altlinux.org>
 <20190224060828.2527-5-vt@altlinux.org>
 <20190224060828.2527-1-vt@altlinux.org>
 <14843.1551377934@warthog.procyon.org.uk>
 <17533.1551380529@warthog.procyon.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=koi8-r
Content-Disposition: inline
In-Reply-To: <17533.1551380529@warthog.procyon.org.uk>
User-Agent: NeoMutt/20171215-106-ac61c7
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

David,

On Thu, Feb 28, 2019 at 07:02:09PM +0000, David Howells wrote:
> | > It's not clear that sig->digest is guaranteed to be kmalloc memory.
> 
> Well, public_key_signature_free() will go bang if it's not kfree'able.

Well, I had similar argument, FYI:

| On Fri, Feb 01, 2019 at 10:09:23AM +0300, Vitaly Chikunov wrote:
| > On Fri, Feb 01, 2019 at 02:26:55PM +0800, Herbert Xu wrote:
| > >
| > > It's not clear that sig->digest is guaranteed to be kmalloc memory.
| > > In any case, it's best not to mix unrelated changes in a single
| > > patch.  So please keep the kmalloc on output and then copy
| > > sig->digest into it and put output into the SG list.
| >
| > It is not guaranteed that sig->s will be kmalloc memory either. (Except
| > we know it for sure like we know the same about sig->digest).
| >
| > You can see in public_key_signature_free() that both fields are kfree'd
| > together.
| >
| > So, I don't understand why we should treat sig->digest differently than
| > sig->s.
| >
| > I was just removing kmalloc'ed output as crypto_akcipher_verify() does
| > not need any output anymore. So, it's not some sort of mixing unrelated
| > changes, from my point of view.

But then I thought Herbert knows better and implemented his suggestion.

Now I have contradictory requests from two maintainers.


