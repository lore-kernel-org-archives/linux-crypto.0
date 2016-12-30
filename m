From: Kalle Valo <kvalo@adurom.com>
Subject: Re: orinoco: Use shash instead of ahash for MIC calculations
Date: Fri, 30 Dec 2016 14:15:53 +0200
Message-ID: <87mvfdk3ye.fsf@purkki.adurom.net>
References: <8818c45b9ec6a04d85fabf9bb437cf119fd23659.1481575835.git.luto@kernel.org>
        <20161230113451.C10ED614E4@smtp.codeaurora.org>
        <87vau1k4ka.fsf@purkki.adurom.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        linux-wireless@vger.kernel.org, Eric Biggers <ebiggers3@gmail.com>,
        linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Stephan Mueller <smueller@chronox.de>
To: Andrew Lutomirski <luto@kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <87vau1k4ka.fsf@purkki.adurom.net> (Kalle Valo's message of "Fri,
        30 Dec 2016 14:02:45 +0200")
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Kalle Valo <kvalo@codeaurora.org> writes:

> Kalle Valo <kvalo@codeaurora.org> writes:
>
>> Andrew Lutomirski <luto@kernel.org> wrote:
>>> Eric Biggers pointed out that the orinoco driver pointed scatterlists
>>> at the stack.
>>> 
>>> Fix it by switching from ahash to shash.  The result should be
>>> simpler, faster, and more correct.
>>> 
>>> Cc: stable@vger.kernel.org # 4.9 only
>>> Reported-by: Eric Biggers <ebiggers3@gmail.com>
>>> Signed-off-by: Andy Lutomirski <luto@kernel.org>
>>
>> 11 patches applied to wireless-drivers-next.git, thanks.
>>
>> 1fef293b8a98 orinoco: Use shash instead of ahash for MIC calculations
>> a08b98196a36 rt2800: make rx ampdu_factor depend on number of rx chains
>> e49abb19d1bf rt2800: don't set ht parameters for non-aggregated frames
>> a51b89698ccc rt2800: set minimum MPDU and PSDU lengths to sane values
>> 8f03a7c6e7f9 rt2800: set MAX_PSDU len according to remote STAs capabilities
>> 8845254112ac rt2800: rename adjust_freq_offset function
>> bc0077053948 rt2800: warn if doing VCO recalibration for unknow RF chip
>> 24d42ef3b152 rt2800: perform VCO recalibration for RF5592 chip
>> d96324703ffa rt2x00: merge agc and vco works with link tuner
>> eb79a8fe94c8 rt2800: replace mdelay by usleep on vco calibration.
>> 31369c323ba0 rt2800: replace msleep() with usleep_range() on channel switch
>
> Oh man, when I was applying rt2800 patches I did an off by one error
> with my patchwork script ('commit 2-12' vs 'commit 1-11') and
> accidentally applied this orinoco patch to wireless-drivers-next along
> with the 10 rt2800 patches above. And failed to spot that before pushing
> the tree :(
>
> As this orinoco patch is pretty important I'll cherry pick it manually
> to wireless-drivers also so that it goes to 4.10. This means that the
> patch is in both trees, but just with a different commit id.

This is the commit in wireless-drivers:

commit 570b90fa230b8021f51a67fab2245fe8df6fe37d
Author: Andrew Lutomirski <luto@kernel.org>
Date:   Mon Dec 12 12:55:55 2016 -0800

    orinoco: Use shash instead of ahash for MIC calculations
    
    Eric Biggers pointed out that the orinoco driver pointed
    scatterlists
    at the stack.
    
    Fix it by switching from ahash to shash.  The result should be
    simpler, faster, and more correct.
    
    kvalo: cherry picked from commit
    1fef293b8a9850cfa124a53c1d8878d355010403 as I
    accidentally applied this patch to wireless-drivers-next when I was
    supposed to
    apply this wireless-drivers
    
    Cc: stable@vger.kernel.org # 4.9 only
    Reported-by: Eric Biggers <ebiggers3@gmail.com>
    Signed-off-by: Andy Lutomirski <luto@kernel.org>
    Signed-off-by: Kalle Valo <kvalo@codeaurora.org>

-- 
Kalle Valo
