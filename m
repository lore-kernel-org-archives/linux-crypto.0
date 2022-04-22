Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B3D56C433F5
	for <linux-crypto@archiver.kernel.org>; Fri, 22 Apr 2022 00:46:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1442975AbiDVAtM (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 21 Apr 2022 20:49:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1442974AbiDVAtM (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 21 Apr 2022 20:49:12 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5BD9F45050;
        Thu, 21 Apr 2022 17:46:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EF6C161F09;
        Fri, 22 Apr 2022 00:46:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32C72C385A7;
        Fri, 22 Apr 2022 00:46:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1650588379;
        bh=ccPDfoX2C32H41ke+6hpDAO7hhzT3fl0u/qddynrKkA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Epe7PEbUIEOn64wrF/ykIJkRCGi+iy91S7TKRjQ9ZM3WKzANkxyqYn294gG5yMfTy
         BLzpBU/YVSo0zdxtr4rDppRwixD6We+0NYjrYmkPN/Tfjaw4dt13bhbUHbPbteWmLy
         U4UV0038DLVAlgEBQkFVCCzuJh1gxOszssDL9GTz3fKgumftSqPEdYgxo9thNgJZTa
         lIrMjwyAUsLdgIDTus7pOKp1EDFwIy3Oc5m9Aka9Nz+ySAR+peBCclKBKB+Zf4wyyX
         DhZnwi02eiwuDZW01iRgp4Mi1UBpvEhCauONNacfR9q6Ek7sUKXzRfYvGotLSbQiuX
         M4op57x0T39bQ==
Date:   Thu, 21 Apr 2022 17:46:17 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc:     linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
        Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH v2] siphash: update the hsiphash documentation
Message-ID: <YmH62VkrJIvOAEQV@sol.localdomain>
References: <20220422002731.63801-1-ebiggers@kernel.org>
 <YmH5hDrUZKBymqYE@zx2c4.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YmH5hDrUZKBymqYE@zx2c4.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, Apr 22, 2022 at 02:40:36AM +0200, Jason A. Donenfeld wrote:
> Hi Eric,
> 
> On Thu, Apr 21, 2022 at 05:27:31PM -0700, Eric Biggers wrote:
> > +On 64-bit kernels, the hsiphash functions actually implement SipHash-1-3, a
> > +reduced-round variant of SipHash, instead of HalfSipHash-1-3. This is because in
> > +64-bit code, SipHash-1-3 is no slower than HalfSipHash-1-3, and can be faster.
> > +Note, this does *not* mean that in 64-bit kernels the hsiphash functions are the
> > +same as the siphash ones, or that they are secure; the hsiphash functions still
> > +use an insecure reduced-round algorithm and truncate their outputs to 32 bits.
>  
> Small nit: "less secure" rather than "insecure", as I don't think
> there's a super realistic attack against 1-3. I can make that change
> when committing if that's fine by you.
> 
> Jason

That's fine, assuming that you're just talking about SipHash-1-3, not also
HalfSipHash-1-3.  The section title is "HalfSipHash - SipHash's insecure younger
cousin", so the word "insecure" is applied to HalfSipHash already.

- Eric
