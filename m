Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1EAFCC4361B
	for <linux-crypto@archiver.kernel.org>; Fri, 18 Dec 2020 09:57:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D591523A82
	for <linux-crypto@archiver.kernel.org>; Fri, 18 Dec 2020 09:57:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728223AbgLRJ5M (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 18 Dec 2020 04:57:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725884AbgLRJ5L (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 18 Dec 2020 04:57:11 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51C7DC0617B0;
        Fri, 18 Dec 2020 01:56:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=JSLM4OfM7/trItGTOdPouTwDzw71WhBmeFz89kT06OY=; b=sN58et3oH3htVeS5g3JX1kh9Vh
        Qzcj+BJ6D3ZaOIiKFdXVenbj+XZlh8FDcZG9+RBo3GHy852bQ5ryYYrX1nTMSef3ouh6+tb2n6qrq
        u6I2E1zSgHB/cvWCv33p6byKUbzldvE2NRExtUpuTXMy7OBj6TxakRqEFDpgZRoYdtw1zh4sBNNu3
        TyD2c9oZwB7vNS9+Cj1oJ7aRGdWF0Dpu7/wFkIOyX4V1vhn6w6qjwZoAxQtzqZxkRB5gfPpPxNCvB
        uKufbIhCsgP50fW+XoUDAgaDz5Jq0Oo5lPIUO3OSAsJFQG9k0ZaNVmqc8SBGJrQgczw+UmYcJYEWa
        HKode4/Q==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=noisy.programming.kicks-ass.net)
        by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kqCUb-0006z4-EG; Fri, 18 Dec 2020 09:56:09 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id DC5DC300B22;
        Fri, 18 Dec 2020 10:56:07 +0100 (CET)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id A50FC2027619D; Fri, 18 Dec 2020 10:56:07 +0100 (CET)
Date:   Fri, 18 Dec 2020 10:56:07 +0100
From:   Peter Zijlstra <peterz@infradead.org>
To:     Dave Hansen <dave.hansen@intel.com>
Cc:     "Chang S. Bae" <chang.seok.bae@intel.com>, tglx@linutronix.de,
        mingo@kernel.org, bp@suse.de, luto@kernel.org, x86@kernel.org,
        herbert@gondor.apana.org.au, dan.j.williams@intel.com,
        ravi.v.shankar@intel.com, ning.sun@intel.com,
        kumar.n.dwarakanath@intel.com, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [NEEDS-REVIEW] [RFC PATCH 7/8] crypto: x86/aes-kl - Support AES
 algorithm using Key Locker instructions
Message-ID: <20201218095607.GD3021@hirez.programming.kicks-ass.net>
References: <20201216174146.10446-1-chang.seok.bae@intel.com>
 <20201216174146.10446-8-chang.seok.bae@intel.com>
 <8353acb0-03cf-a334-b505-416e0fc58b63@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8353acb0-03cf-a334-b505-416e0fc58b63@intel.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, Dec 17, 2020 at 12:58:34PM -0800, Dave Hansen wrote:
> On 12/16/20 9:41 AM, Chang S. Bae wrote:
> > +config CRYPTO_AES_KL
> > +	tristate "AES cipher algorithms (AES-KL)"
> > +	depends on X86_KEYLOCKER
> > +	select CRYPTO_AES_NI_INTEL
> > +	help
> > +	  Use AES Key Locker instructions for AES algorithm.
> > +
> > +	  AES cipher algorithms (FIPS-197). AES uses the Rijndael
> > +	  algorithm.
> > +
> > +	  Rijndael appears to be consistently a very good performer in both
> > +	  hardware and software across a wide range of computing
> > +	  environments regardless of its use in feedback or non-feedback
> > +	  modes. Its key setup time is excellent, and its key agility is
> > +	  good. Rijndael's very low memory requirements make it very well
> > +	  suited for restricted-space environments, in which it also
> > +	  demonstrates excellent performance. Rijndael's operations are
> > +	  among the easiest to defend against power and timing attacks.
> > +
> > +	  The AES specifies three key sizes: 128, 192 and 256 bits
> > +
> > +	  See <http://csrc.nist.gov/encryption/aes/> for more information.
> > +

It's direct copy-pasta from CRYPTO_AES_NI_INTEL until about here.

> > +	  For 128- and 256-bit keys, the AES cipher algorithm is
> > +	  implemented by AES Key Locker instructions. This implementation
> > +	  does not need an AES key once wrapped to an encoded form. For AES
> > +	  compliance, 192-bit is processed by AES-NI instructions.
> 
> Giving a history lesson and high-level overview of AES doesn't quite
> seem appropriate here, unless this is the first the kernel has seen of AES.

And the new bits aren't really enlightening either, as you point out.
