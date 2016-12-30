From: Kalle Valo <kvalo@codeaurora.org>
Subject: Re: orinoco: Use shash instead of ahash for MIC calculations
Date: Fri, 30 Dec 2016 14:02:45 +0200
Message-ID: <87vau1k4ka.fsf@purkki.adurom.net>
References: <8818c45b9ec6a04d85fabf9bb437cf119fd23659.1481575835.git.luto@kernel.org>
        <20161230113451.C10ED614E4@smtp.codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        linux-wireless@vger.kernel.org, Eric Biggers <ebiggers3@gmail.com>,
        linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Stephan Mueller <smueller@chronox.de>
To: Andrew Lutomirski <luto@kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:59994 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753401AbcL3MCu (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 30 Dec 2016 07:02:50 -0500
In-Reply-To: <20161230113451.C10ED614E4@smtp.codeaurora.org> (Kalle Valo's
        message of "Fri, 30 Dec 2016 11:34:51 +0000 (UTC)")
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Kalle Valo <kvalo@codeaurora.org> writes:

> Andrew Lutomirski <luto@kernel.org> wrote:
>> Eric Biggers pointed out that the orinoco driver pointed scatterlists
>> at the stack.
>> 
>> Fix it by switching from ahash to shash.  The result should be
>> simpler, faster, and more correct.
>> 
>> Cc: stable@vger.kernel.org # 4.9 only
>> Reported-by: Eric Biggers <ebiggers3@gmail.com>
>> Signed-off-by: Andy Lutomirski <luto@kernel.org>
>
> 11 patches applied to wireless-drivers-next.git, thanks.
>
> 1fef293b8a98 orinoco: Use shash instead of ahash for MIC calculations
> a08b98196a36 rt2800: make rx ampdu_factor depend on number of rx chains
> e49abb19d1bf rt2800: don't set ht parameters for non-aggregated frames
> a51b89698ccc rt2800: set minimum MPDU and PSDU lengths to sane values
> 8f03a7c6e7f9 rt2800: set MAX_PSDU len according to remote STAs capabilities
> 8845254112ac rt2800: rename adjust_freq_offset function
> bc0077053948 rt2800: warn if doing VCO recalibration for unknow RF chip
> 24d42ef3b152 rt2800: perform VCO recalibration for RF5592 chip
> d96324703ffa rt2x00: merge agc and vco works with link tuner
> eb79a8fe94c8 rt2800: replace mdelay by usleep on vco calibration.
> 31369c323ba0 rt2800: replace msleep() with usleep_range() on channel switch

Oh man, when I was applying rt2800 patches I did an off by one error
with my patchwork script ('commit 2-12' vs 'commit 1-11') and
accidentally applied this orinoco patch to wireless-drivers-next along
with the 10 rt2800 patches above. And failed to spot that before pushing
the tree :(

As this orinoco patch is pretty important I'll cherry pick it manually
to wireless-drivers also so that it goes to 4.10. This means that the
patch is in both trees, but just with a different commit id.

Sorry for the mess.

-- 
Kalle Valo
