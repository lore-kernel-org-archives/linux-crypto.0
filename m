Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 363A7C433ED
	for <linux-crypto@archiver.kernel.org>; Mon, 17 May 2021 23:33:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 10ABA61285
	for <linux-crypto@archiver.kernel.org>; Mon, 17 May 2021 23:33:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245727AbhEQXeX (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 17 May 2021 19:34:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:57232 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231543AbhEQXeX (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 17 May 2021 19:34:23 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2F47461285;
        Mon, 17 May 2021 23:33:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1621294386;
        bh=6uXpjzQSaNiu+fB3dgNd9CX/Q09665X6oI7RAWVKgyI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=dsUp9MiIwS1g/0q3JktkF3LHLlIyoGVZLcrNQAZjQYSK90mQ3aqbdqd5lwQasBjj/
         HfSWma9y7WSC6ozWSwKKAPPbdbXUolGMj+53a+ClUMh8zBV4DHLI0MLsAcAnbvAU6p
         zN/VP5HM5+op7O10e2UCemNL+wt3ozEGSRfQbB0bv70uPcl76wUwHZwXQAKQT2I1Nh
         6ynqq+Uq+SU/Rjzws5DzWjD+fqtyr1aNWfa1fWafy012WAeFz3AqhQK81Uxti05prJ
         bzIepc2ol3RW/n1k6YNiAF+cahvipH/gE+2BrNAQmF2bXJDxOVbrILHSV8W/LZRhsw
         tPR/ppkuqi0yQ==
Date:   Mon, 17 May 2021 16:33:04 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     "Bae, Chang Seok" <chang.seok.bae@intel.com>
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@kernel.org>, Borislav Petkov <bp@suse.de>,
        Andy Lutomirski <luto@kernel.org>, X86 ML <x86@kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "Williams, Dan J" <dan.j.williams@intel.com>,
        "Hansen, Dave" <dave.hansen@intel.com>,
        "Shankar, Ravi V" <ravi.v.shankar@intel.com>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH v2 10/11] crypto: x86/aes-kl - Support AES algorithm
 using Key Locker instructions
Message-ID: <YKL9MPWRFM8+pm3m@gmail.com>
References: <20210514201508.27967-1-chang.seok.bae@intel.com>
 <20210514201508.27967-11-chang.seok.bae@intel.com>
 <YKLhc6HX9+JunQ/X@gmail.com>
 <ED9DFB96-B15E-493F-9089-4B69F5456532@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <ED9DFB96-B15E-493F-9089-4B69F5456532@intel.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, May 17, 2021 at 10:20:44PM +0000, Bae, Chang Seok wrote:
> On May 17, 2021, at 14:34, Eric Biggers <ebiggers@kernel.org> wrote:
> > On Fri, May 14, 2021 at 01:15:07PM -0700, Chang S. Bae wrote:
> >> Included are methods for ECB, CBC, CTR, and XTS modes. They are not
> >> compatible with other implementations as referencing an encrypted form
> >> only.
> > 
> > Your code uses the standard algorithm names like cbc(aes), which implies that it
> > is compatible with the standard cbc(aes).  So which is it -- compatible or not
> > compatible -- and if it isn't compatible, what is the expected use case?
> 
> Yes, it provides AES-CBC functionality. Well, it was intended to avoid mixed
> use of functions -- setkey(), decrypt(), and encrypt() -- from others.
> Perhaps, rewrite this as:
> 
>   Each method should not be used along with other implementations'. E.g., KL’s
>   setkey() output can’t be used to the input to the encrypt() method of AES-NI or
>   generic implementation.
> 

Sure.  But that is just the implementation, so not really as interesting as what
the user sees.  I think you need to do a better job explaining what this looks
like from a user's perspective.  It sounds like the answer is "it looks the
same" -- right?  What is the benefit, exactly?  (Please be more specific than
"it protects the AES keys".)

- Eric
