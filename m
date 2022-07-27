Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5FE8AC04A68
	for <linux-crypto@archiver.kernel.org>; Wed, 27 Jul 2022 20:15:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229914AbiG0UPz (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 27 Jul 2022 16:15:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229839AbiG0UPy (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 27 Jul 2022 16:15:54 -0400
Received: from outgoing.mit.edu (outgoing-auth-1.mit.edu [18.9.28.11])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C12CB5246D
        for <linux-crypto@vger.kernel.org>; Wed, 27 Jul 2022 13:15:53 -0700 (PDT)
Received: from cwcc.thunk.org (pool-173-48-118-63.bstnma.fios.verizon.net [173.48.118.63])
        (authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
        by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 26RKFOGv020117
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 27 Jul 2022 16:15:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=outgoing;
        t=1658952928; bh=GxWAfRdc2ziEHfuvaVSBjk+KH/YGCESIRjxmtlJYudk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To;
        b=ojvFcyI/zBCfy88UvCqPwr/NDkthmvMJV4/gswmhsC1kS8t9zSOBKX99hc/NNnUb4
         RIDPehRjM1VSZf1ckqmOUfcaqql8Q5LFS6y+JXZpeqLSOd5FEoqxtfsQQyYmhlJZJV
         1yk5UrvgXKK1F1LC5KR49okskMlBMLp2HtYXSAJQF9UaQr+N5QX04xoAevzpQUEDCZ
         tdTJj8MDKTFP1OMKyr7orSNcBKXPvdK9mcIL0vmn3+fK+ugBtt8/S+PR/sIDgpgUSA
         CtfeNEJusIMOHBH5U2myS9PovZqhsNWc5qKVgVNlikBIMBm8QwYjk0DF9VqRRaCD5C
         xa6YCzMgOvgYA==
Received: by cwcc.thunk.org (Postfix, from userid 15806)
        id 1D10E15C3434; Wed, 27 Jul 2022 16:15:24 -0400 (EDT)
Date:   Wed, 27 Jul 2022 16:15:24 -0400
From:   "Theodore Ts'o" <tytso@mit.edu>
To:     Florian Weimer <fweimer@redhat.com>
Cc:     Adhemerval Zanella Netto <adhemerval.zanella@linaro.org>,
        Rich Felker <dalias@libc.org>,
        Yann Droneaud <ydroneaud@opteya.com>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>, libc-alpha@sourceware.org,
        linux-crypto@vger.kernel.org, Michael@phoronix.com, jann@thejh.net
Subject: Re: arc4random - are you sure we want these?
Message-ID: <YuGc3O88Zxb5HkxY@mit.edu>
References: <6bf352e9-1312-40de-4733-3219721b343c@linaro.org>
 <20220725153303.GF7074@brightrain.aerifal.cx>
 <878rohp2ll.fsf@oldenburg.str.redhat.com>
 <20220725174430.GI7074@brightrain.aerifal.cx>
 <CAPBLoAe89Pwt=F_jcZirVXQA7JtugV+5+BWHBt0RaZka1y0K=g@mail.gmail.com>
 <20220725184929.GJ7074@brightrain.aerifal.cx>
 <YuCa1lDqoxdnZut/@mit.edu>
 <a5b6307d-6811-61b6-c13d-febaa6ad1e48@linaro.org>
 <YuEwR0bJhOvRtmFe@mit.edu>
 <87v8rid8ju.fsf@oldenburg.str.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87v8rid8ju.fsf@oldenburg.str.redhat.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, Jul 27, 2022 at 02:49:57PM +0200, Florian Weimer wrote:
> * Theodore Ts'o:
> 
> > But even if you didn't take the latest kernels, I think you will find
> > that if you actually benchmark how many queries per second a real-life
> > secure web server or VPN gateway, even the original 5.15.0 /dev/random
> > driver was plenty fast enough for real world cryptographic use cases.
> 
> The idea is to that arc4random() is suitable in pretty much all places
> that have historically used random() (outside of deterministic
> simulations).  Straight calls to getrandom are much, much slower than
> random(), and it's not even the system call overhead.

What are those places?  And what are their performance and security
requirements?  I've heard some people claim that arc4random() is
supposed to provide strong security guarantees.  I've heard others
claim that it doesn't, or at least glibc was planning on disclaiming
security guaranteees.  So there seems to be a lack of clarity about
the security requirements.

What about the performance requirements?  Designing an interface where
the requirement "as fast as possible" is often not a great pathway to
success, because the reality is that engineering is always about
tradeoffs.

If there are no security requirements (given the claim that some
people want to put in the documentation disclaiming that arc4random
might not be secure), why not just have people continue to use
random(3)?

    	      	     	      	     - Ted
