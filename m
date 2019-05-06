Return-Path: <SRS0=vipQ=TG=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_PASS,
	T_DKIMWL_WL_HIGH,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8968FC04A6B
	for <linux-crypto@archiver.kernel.org>; Mon,  6 May 2019 15:53:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5B1D22087F
	for <linux-crypto@archiver.kernel.org>; Mon,  6 May 2019 15:53:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1557158001;
	bh=BLcD29/VI2mp8KC4x3+710PG8BnqJZVG8LHHcwbiiV0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=mi1w5MNqWLfC+jcFspCyfBUlCzfV4jupVREq2TxQwgQdYT/qor74/nR1zqArh+OQR
	 Iqz9PEQbg1vq/SD1xuFkcVfqNYcRrU7w2aNMbbV6XQu9RByGBfLbAv9xL7PPQD+7Lr
	 AoPlkaDKEWWrRFEqoOBwwNEsDVCNsJVbeYYZZBBo=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726381AbfEFPxU (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 6 May 2019 11:53:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:59754 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726321AbfEFPxU (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 6 May 2019 11:53:20 -0400
Received: from sol.localdomain (c-24-5-143-220.hsd1.ca.comcast.net [24.5.143.220])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C98C12053B;
        Mon,  6 May 2019 15:53:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557157999;
        bh=BLcD29/VI2mp8KC4x3+710PG8BnqJZVG8LHHcwbiiV0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=qlqC0hMJyDU4ed7PhIQar013DoZYr3shz8rwF80hGoNGfcrsQGevjFGQHvv+dzhrB
         PVS5yeILn9UMcvBXamMmjWOTf1AtaawkIjjLqwdwwrEGAnmKGT0peVCBPHLWDCVlKj
         10vho5MxpDWev0cNodnzMP+ERX7yencKEsi5foes=
Date:   Mon, 6 May 2019 08:53:17 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Michael Ellerman <mpe@ellerman.id.au>
Cc:     Nayna <nayna@linux.vnet.ibm.com>, Daniel Axtens <dja@axtens.net>,
        leo.barbosa@canonical.com,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Stephan Mueller <smueller@chronox.de>, nayna@linux.ibm.com,
        omosnacek@gmail.com, leitao@debian.org, pfsmorigo@gmail.com,
        linux-crypto@vger.kernel.org, marcelo.cerri@canonical.com,
        George Wilson <gcwilson@linux.ibm.com>,
        linuxppc-dev@lists.ozlabs.org
Subject: Re: [PATCH] crypto: vmx - fix copy-paste error in CTR mode
Message-ID: <20190506155315.GA661@sol.localdomain>
References: <20190315020901.16509-1-dja@axtens.net>
 <20190315022414.GA1671@sol.localdomain>
 <875zsku5mk.fsf@dja-thinkpad.axtens.net>
 <20190315043433.GC1671@sol.localdomain>
 <8736nou2x5.fsf@dja-thinkpad.axtens.net>
 <20190410070234.GA12406@sol.localdomain>
 <87imvkwqdh.fsf@dja-thinkpad.axtens.net>
 <2c8b042f-c7df-cb8b-3fcd-15d6bb274d08@linux.vnet.ibm.com>
 <8736mmvafj.fsf@concordia.ellerman.id.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8736mmvafj.fsf@concordia.ellerman.id.au>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Sat, Apr 13, 2019 at 01:41:36PM +1000, Michael Ellerman wrote:
> Nayna <nayna@linux.vnet.ibm.com> writes:
> 
> > On 04/11/2019 10:47 AM, Daniel Axtens wrote:
> >> Eric Biggers <ebiggers@kernel.org> writes:
> >>
> >>> Are you still planning to fix the remaining bug?  I booted a ppc64le VM, and I
> >>> see the same test failure (I think) you were referring to:
> >>>
> >>> alg: skcipher: p8_aes_ctr encryption test failed (wrong result) on test vector 3, cfg="uneven misaligned splits, may sleep"
> >>>
> >> Yes, that's the one I saw. I don't have time to follow it up at the
> >> moment, but Nayna is aware of it.
> >>
> >
> > Yes Eric, we identified this as a separate issue of misalignment and 
> > plan to post a separate patch to address it.
> 
> I also wrote it down in my write-only TODO list here:
> 
>   https://github.com/linuxppc/issues/issues/238
> 
> 
> cheers

Any progress on this?  Someone just reported this again here:
https://bugzilla.kernel.org/show_bug.cgi?id=203515

- Eric
