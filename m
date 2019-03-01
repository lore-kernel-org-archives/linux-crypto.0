Return-Path: <SRS0=jX8O=RE=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED,USER_AGENT_NEOMUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 68D07C43381
	for <linux-crypto@archiver.kernel.org>; Fri,  1 Mar 2019 02:34:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3CC9820643
	for <linux-crypto@archiver.kernel.org>; Fri,  1 Mar 2019 02:34:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731684AbfCACeQ (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 28 Feb 2019 21:34:16 -0500
Received: from orcrist.hmeau.com ([104.223.48.154]:51904 "EHLO
        deadmen.hmeau.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725896AbfCACeQ (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 28 Feb 2019 21:34:16 -0500
Received: from gondobar.mordor.me.apana.org.au ([192.168.128.4] helo=gondobar)
        by deadmen.hmeau.com with esmtps (Exim 4.89 #2 (Debian))
        id 1gzY03-0007Aw-OZ; Fri, 01 Mar 2019 10:34:11 +0800
Received: from herbert by gondobar with local (Exim 4.89)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1gzY01-0003Ha-BG; Fri, 01 Mar 2019 10:34:09 +0800
Date:   Fri, 1 Mar 2019 10:34:09 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     David Howells <dhowells@redhat.com>,
        Mimi Zohar <zohar@linux.ibm.com>,
        linux-integrity@vger.kernel.org, keyrings@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5 04/10] crypto: akcipher - new verify API for public
 key algorithms
Message-ID: <20190301023409.e2zgemssjjrrty4t@gondor.apana.org.au>
References: <20190228183923.5klzwli5zmeew54j@altlinux.org>
 <20190224060828.2527-5-vt@altlinux.org>
 <20190224060828.2527-1-vt@altlinux.org>
 <14843.1551377934@warthog.procyon.org.uk>
 <17533.1551380529@warthog.procyon.org.uk>
 <20190228190741.fv2qxwwtlpdffhwq@altlinux.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190228190741.fv2qxwwtlpdffhwq@altlinux.org>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, Feb 28, 2019 at 10:07:42PM +0300, Vitaly Chikunov wrote:
> David,
> 
> On Thu, Feb 28, 2019 at 07:02:09PM +0000, David Howells wrote:
> > | > It's not clear that sig->digest is guaranteed to be kmalloc memory.
> > 
> > Well, public_key_signature_free() will go bang if it's not kfree'able.
> 
> Well, I had similar argument, FYI:
> 
> | On Fri, Feb 01, 2019 at 10:09:23AM +0300, Vitaly Chikunov wrote:
> | > On Fri, Feb 01, 2019 at 02:26:55PM +0800, Herbert Xu wrote:
> | > >
> | > > It's not clear that sig->digest is guaranteed to be kmalloc memory.
> | > > In any case, it's best not to mix unrelated changes in a single
> | > > patch.  So please keep the kmalloc on output and then copy
> | > > sig->digest into it and put output into the SG list.
> | >
> | > It is not guaranteed that sig->s will be kmalloc memory either. (Except
> | > we know it for sure like we know the same about sig->digest).
> | >
> | > You can see in public_key_signature_free() that both fields are kfree'd
> | > together.
> | >
> | > So, I don't understand why we should treat sig->digest differently than
> | > sig->s.
> | >
> | > I was just removing kmalloc'ed output as crypto_akcipher_verify() does
> | > not need any output anymore. So, it's not some sort of mixing unrelated
> | > changes, from my point of view.
> 
> But then I thought Herbert knows better and implemented his suggestion.
> 
> Now I have contradictory requests from two maintainers.

My main point is to not include unrelated changes into your patch.
If you want to eliminate the copy that's fine, but please do it in
a separate patch.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
