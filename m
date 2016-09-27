From: Stephan Mueller <smueller@chronox.de>
Subject: Re: [v2] RANDOM: ATH9K RNG delivers zero bits of entropy
Date: Tue, 27 Sep 2016 17:17:02 +0200
Message-ID: <1477295.yC8zZtqI66@tauon.atsec.com>
References: <1654172.XfclnXhRmn@positron.chronox.de> <2ba03f89daee4f09a88a1238943eb49d@euamsexm01a.eu.qualcomm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: Ted Tso <tytso@mit.edu>, herbert@gondor.apana.org.au,
        linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
        ath9k-devel@qca.qualcomm.com, linux-wireless@vger.kernel.org,
        ath9k-devel@lists.ath9k.org, Kalle Valo <kvalo@codeaurora.org>,
        Jason Cooper <jason@lakedaemon.net>
To: Kalle Valo <kvalo@qca.qualcomm.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:48046 "EHLO mail.eperm.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752183AbcI0PRI (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 27 Sep 2016 11:17:08 -0400
In-Reply-To: <2ba03f89daee4f09a88a1238943eb49d@euamsexm01a.eu.qualcomm.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Dienstag, 27. September 2016, 16:44:16 CEST schrieb Kalle Valo:

Hi Kalle,

> Stephan Mueller <smueller@chronox.de> wrote:
> > The ATH9K driver implements an RNG which is completely bypassing the
> > standard Linux HW generator logic.
> > 
> > The RNG may or may not deliver entropy. Considering the conservative
> > approach in treating entropy with respect to non-auditable sources, this
> > patch changes the delivered entropy value to zero. The RNG still feeds
> > data into the input_pool but it is assumed to have no entropy.
> > 
> > When the ATH9K RNG changes to use the HW RNG framework, it may re-enable
> > the entropy estimation considering that a user can change that value at
> > boot and runtime.
> > 
> > Reviewed-by: Jason Cooper <jason@lakedaemon.net>
> > Signed-off-by: Stephan Mueller <smueller@chronox.de>
> 
> Based on the discussion I'm dropping this patch. But the discussion was
> hard to follow so please let me know if I misunderstood.

I guess the rejection is appropriate, but something needs to be done: 
add_hwgenerator_randomness should not be used in this scenario.
> 
> Patch set to Rejected.



Ciao
Stephan
