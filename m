Return-Path: <SRS0=aEsr=7F=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B7B1FC433E1
	for <linux-crypto@archiver.kernel.org>; Sat, 23 May 2020 18:52:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5BC1F20812
	for <linux-crypto@archiver.kernel.org>; Sat, 23 May 2020 18:52:55 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=chronox.de header.i=@chronox.de header.b="i0RZS86E"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387537AbgEWSwy (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 23 May 2020 14:52:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387536AbgEWSwy (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 23 May 2020 14:52:54 -0400
Received: from mo6-p02-ob.smtp.rzone.de (mo6-p02-ob.smtp.rzone.de [IPv6:2a01:238:20a:202:5302::12])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF0E5C061A0E
        for <linux-crypto@vger.kernel.org>; Sat, 23 May 2020 11:52:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1590259972;
        s=strato-dkim-0002; d=chronox.de;
        h=References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
        X-RZG-CLASS-ID:X-RZG-AUTH:From:Subject:Sender;
        bh=n6sVyRgBLjvmg0LOaMebZv0GmcvjtJpEuoZM7jrzuU0=;
        b=i0RZS86EZChCWsf3nQr3I5f6Z8CrrXIp+/qEGxz7YsD0MnBF4TBZ3ubQ6A+ggIkoXv
        hwFMdAliC0nm07KBToK4H1/VzLkv18IYWW+FBQogzRB3UZBx0H6amemZTUrAxqxwcCR9
        bpjqgbT9jrYVOD7WGOJ13u3RoBdBcLyu7LUxq2pD2Sk+jcvv6UtNXBeAd3eQDP6vTNPD
        A29Xq6j9e7L3MD56l4yyKSw6e5U4S9GAz7bMPHyBc99QLwUDUBDA/KHniMiG/cclhVyy
        p7UPqPjDVyBiUGxC/ZFgY3yZNQFYspo8p58ZzpuIzH4/WUpSANduhMNcXOqc/t2z92Vg
        z4bQ==
X-RZG-AUTH: ":P2ERcEykfu11Y98lp/T7+hdri+uKZK8TKWEqNyiHySGSa9k9xmwdNnzGHXPbJ/SdwHc="
X-RZG-CLASS-ID: mo00
Received: from positron.chronox.de
        by smtp.strato.de (RZmta 46.7.0 DYNA|AUTH)
        with ESMTPSA id k09005w4NIqlI26
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
        (Client did not present a certificate);
        Sat, 23 May 2020 20:52:47 +0200 (CEST)
From:   Stephan =?ISO-8859-1?Q?M=FCller?= <smueller@chronox.de>
To:     Gilad Ben-Yossef <gilad@benyossef.com>,
        Ard Biesheuvel <ardb@kernel.org>
Cc:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        Eric Biggers <ebiggers@kernel.org>
Subject: Re: [RFC/RFT PATCH 0/2] crypto: add CTS output IVs for arm64 and testmgr
Date:   Sat, 23 May 2020 20:52:46 +0200
Message-ID: <9730423.nUPlyArG6x@positron.chronox.de>
In-Reply-To: <CAMj1kXFJJcg-YeSw+_FDfyOvjQTJ6w1YyKqWaxCWSjDhRLEDoA@mail.gmail.com>
References: <20200519190211.76855-1-ardb@kernel.org> <CAOtvUMc8PhToLDVO+Y4NVhVkA6B7yndp3gbaeaQZJtrW_NSzaw@mail.gmail.com> <CAMj1kXFJJcg-YeSw+_FDfyOvjQTJ6w1YyKqWaxCWSjDhRLEDoA@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Am Donnerstag, 21. Mai 2020, 15:23:41 CEST schrieb Ard Biesheuvel:

Hi Ard,

> On Thu, 21 May 2020 at 15:01, Gilad Ben-Yossef <gilad@benyossef.com> wrote:
> > Hi Ard,
> > 
> > Thank you for looping me in.
> > 
> > On Wed, May 20, 2020 at 10:09 AM Ard Biesheuvel <ardb@kernel.org> wrote:
> > > On Wed, 20 May 2020 at 09:01, Stephan Mueller <smueller@chronox.de> 
wrote:
> > > > Am Mittwoch, 20. Mai 2020, 08:54:10 CEST schrieb Ard Biesheuvel:
> > > > 
> > > > Hi Ard,
> > > > 
> > > > > On Wed, 20 May 2020 at 08:47, Stephan Mueller <smueller@chronox.de> 
wrote:
> > > ...
> > > 
> > > > > > The state of all block chaining modes we currently have is defined
> > > > > > with
> > > > > > the
> > > > > > IV. That is the reason why I mentioned it can be implemented
> > > > > > stateless
> > > > > > when I am able to get the IV output from the previous operation.
> > > > > 
> > > > > But it is simply the same as the penultimate block of ciphertext. So
> > > > > you can simply capture it after encrypt, or before decrypt. There is
> > > > > really no need to rely on the CTS transformation to pass it back to
> > > > > you via the buffer that is only specified to provide an input to the
> > > > > CTS transform.
> > > > 
> > > > Let me recheck that as I am not fully sure on that one. But if it can
> > > > be
> > > > handled that way, it would make life easier.
> > > 
> > > Please refer to patch 2. The .iv_out test vectors were all simply
> > > copied from the appropriate offset into the associated .ctext member.
> > 
> > Not surprisingly since to the best of my understanding this behaviour
> > is not strictly specified, ccree currently fails the IV output check
> > with the 2nd version of the patch.
> 
> That is what I suspected, hence the cc:
> > If I understand you correctly, the expected output IV is simply the
> > next to last block of the ciphertext?
> 
> Yes. But this happens to work for the generic case because the CTS
> driver itself requires the encapsulated CBC mode to return the output
> IV, which is simply passed through back to the caller. CTS mode itself
> does not specify any kind of output IV, so we should not rely on this
> behavior.

Note, the update to the spec based on your suggestion is already in a merge 
request:

https://github.com/usnistgov/ACVP/issues/860

Thanks for your input.

Ciao
Stephan


