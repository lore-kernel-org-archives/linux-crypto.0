Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 434E7EC873D
	for <linux-crypto@archiver.kernel.org>; Thu,  7 Sep 2023 16:26:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239034AbjIGQ0z (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 7 Sep 2023 12:26:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239214AbjIGQ0Q (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 7 Sep 2023 12:26:16 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C17335A5;
        Thu,  7 Sep 2023 09:22:35 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2F7DC116A4;
        Thu,  7 Sep 2023 10:15:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1694081733;
        bh=/VfQ9uuSzbzc4g98IJPGGzTV1REpCA2gHNPbmygK8ls=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=NdzIeIqYkCsiJSwOwR3HGZR9/Tc7MYl5Slfv8MFZWTLsENNWNTriMgcPA2uBqyDM8
         sRfGAGr/I9mTGarQ/uxSM/Iy8+Qiq+/0HB7FSr5YzNXePpp2hGuSZEVyiC5NVoOL2x
         xR1WETO0xZhHoxiabbPGgoq+k+CO/jq8EzJks+js=
Date:   Thu, 7 Sep 2023 11:15:30 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Cc:     Herbert Xu <herbert@gondor.apana.org.au>, stable@vger.kernel.org,
        Sasha Levin <sashal@kernel.org>, linux-crypto@vger.kernel.org,
        qat-linux@intel.com
Subject: Re: Bug in rsa-pkcs1pad in 6.1 and 5.15
Message-ID: <2023090724-campfire-unstirred-a36e@gregkh>
References: <ZPcFyp4jdE3uSeqW@gcabiddu-mobl1.ger.corp.intel.com>
 <ZPhAyty1r8ASyr+F@gondor.apana.org.au>
 <ZPiNIBvrpVz61doJ@gcabiddu-mobl1.ger.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZPiNIBvrpVz61doJ@gcabiddu-mobl1.ger.corp.intel.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, Sep 06, 2023 at 03:30:56PM +0100, Giovanni Cabiddu wrote:
> On Wed, Sep 06, 2023 at 05:05:14PM +0800, Herbert Xu wrote:
> > On Tue, Sep 05, 2023 at 11:41:14AM +0100, Giovanni Cabiddu wrote:
> > >
> > > Options:
> > >   1. Cherry-pick 5b11d1a360ea ("crypto: rsa-pkcs1pad - Use helper to set
> > >      reqsize") to both 6.1.x and 5.15.x trees.
> > >   2. Revert upstream commit 80e62ad58db0 ("crypto: qat - Use helper
> > >      to set reqsize").
> > >      In 6.1 revert da1729e6619c414f34ce679247721603ebb957dc
> > >      In 5.15 revert 3894f5880f968f81c6f3ed37d96bdea01441a8b7
> > > 
> > > Option #1 is preferred as the same problem might be impacting other
> > > akcipher implementations besides QAT. Option #2 is just specific to the
> > > QAT driver.
> > > 
> > > @Herbert, can you have a quick look in case I missed something? I tried
> > > both options in 6.1.51 and they appear to resolve the problem.
> > 
> > Yes I think backporting the rsa-pkcs1pad would be the best way
> > forward.
> Thanks Herbert.
> 
> Adding stable to the TO list. Would it be possible to cherry-pick the
> following upstream commit
> 
>     5b11d1a360ea ("crypto: rsa-pkcs1pad - Use helper to set reqsize")
> 
> to both the 6.1.x and 5.15.x trees?

Now queued up, thanks.

greg k-h
