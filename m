Return-Path: <SRS0=adZj=OO=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3AC82C04EB9
	for <linux-crypto@archiver.kernel.org>; Wed,  5 Dec 2018 06:15:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0169520850
	for <linux-crypto@archiver.kernel.org>; Wed,  5 Dec 2018 06:15:17 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="cbGfMFfi"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 0169520850
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-crypto-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726866AbeLEGPQ (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 5 Dec 2018 01:15:16 -0500
Received: from mail.kernel.org ([198.145.29.99]:40988 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726853AbeLEGPQ (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 5 Dec 2018 01:15:16 -0500
Received: from sol.localdomain (c-24-23-142-8.hsd1.ca.comcast.net [24.23.142.8])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 832472084C;
        Wed,  5 Dec 2018 06:15:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1543990515;
        bh=HQ7Wh7LgPhqcMGTkr6mXgXPw29SZy7Zp7vMTIe5lqkI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=cbGfMFfi45BsvD7JawUvmjCfWqYalDh67O1wDlwBIgJAm6IqcU5pG+/Ltz5IdXqIM
         Ym1tsTL1HOnhm5PDvWEJxwqgc+Sle0Hi84YFXgFekgvTdWMurtqB2prWNEX9A2q3bF
         q5CyvrpS2Oz0IqyVP1zn+4dh/logvvf1J/Iu9feo=
Date:   Tue, 4 Dec 2018 22:15:14 -0800
From:   Eric Biggers <ebiggers@kernel.org>
To:     Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc:     Martin Willi <martin@strongswan.org>,
        "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
        <linux-crypto@vger.kernel.org>,
        Paul Crowley <paulcrowley@google.com>,
        Milan Broz <gmazyland@gmail.com>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 3/6] crypto: x86/chacha20 - limit the
 preemption-disabled section
Message-ID: <20181205061513.GB26750@sol.localdomain>
References: <20181129230217.158038-1-ebiggers@kernel.org>
 <20181129230217.158038-4-ebiggers@kernel.org>
 <acad781e9981c49b83b6dfdc8cefed6246df469a.camel@strongswan.org>
 <CAKv+Gu89RiDBx35rtGS2uOZ+TwPt6P8UjwpqE17xm7dtMx-nNQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
In-Reply-To: <CAKv+Gu89RiDBx35rtGS2uOZ+TwPt6P8UjwpqE17xm7dtMx-nNQ@mail.gmail.com>
User-Agent: Mutt/1.11.0 (2018-11-25)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org
Message-ID: <20181205061514.LE3assUOnZ-YlipjjPUTtVUUMKLd7_Yfv0HrAoGfmWs@z>

On Mon, Dec 03, 2018 at 03:13:37PM +0100, Ard Biesheuvel wrote:
> On Sun, 2 Dec 2018 at 11:47, Martin Willi <martin@strongswan.org> wrote:
> >
> >
> > > To improve responsiveness, disable preemption for each step of the
> > > walk (which is at most PAGE_SIZE) rather than for the entire
> > > encryption/decryption operation.
> >
> > It seems that it is not that uncommon for IPsec to get small inputs
> > scattered over multiple blocks. Doing FPU context saving for each walk
> > step then can slow down things.
> >
> > An alternative approach could be to re-enable preemption not based on
> > the walk steps, but on the amount of bytes processed. This would
> > satisfy both users, I guess.
> >
> > In the long run we probably need a better approach for FPU context
> > saving, as this really hurts performance-wise. For IPsec we should find
> > a way to avoid the (multiple) per-packet FPU save/restores in softirq
> > context, but I guess this requires support from process context
> > switching.
> >
> 
> At Jason's Zinc talk at plumbers, this came up, and apparently someone
> is working on this, i.e., to ensure that on x86, the FPU restore only
> occurs lazily, when returning to userland rather than every time you
> call kernel_fpu_end() [like we do on arm64 as well]
> 
> Not sure what the ETA for that work is, though, nor did I get the name
> of the guy working on it.

Thanks for the suggestion; I'll replace this with a patch that re-enables
preemption every 4 KiB encrypted.  That also avoids having to do a
kernel_fpu_begin(), kernel_fpu_end() pair just for hchacha_block_ssse3().  But
yes, I'd definitely like repeated kernel_fpu_begin(), kernel_fpu_end() to not be
incredibly slow.  That would help in a lot of other places too.

- Eric
