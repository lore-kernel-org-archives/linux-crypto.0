From: Jason Cooper <jason@lakedaemon.net>
Subject: Re: [PATCH v2] RANDOM: ATH9K RNG delivers zero bits of entropy
Date: Mon, 8 Aug 2016 22:04:52 +0000
Message-ID: <20160808220452.GA2013@io.lakedaemon.net>
References: <34197429.2CvoIfft9B@positron.chronox.de>
 <1654172.XfclnXhRmn@positron.chronox.de>
 <657897b90b8344eeab10d7a0f604988d@aptaiexm02f.ap.qualcomm.com>
 <1830987.VF9l4XmGxv@tauon.atsec.com>
 <20160808172930.GD4511@io.lakedaemon.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "Pan, Miaoqing" <miaoqing@qti.qualcomm.com>,
	Ted Tso <tytso@mit.edu>,
	"Sepehrdad, Pouyan" <pouyans@qti.qualcomm.com>,
	"herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	ath9k-devel <ath9k-devel@qca.qualcomm.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"ath9k-devel@lists.ath9k.org" <ath9k-devel@lists.ath9k.org>,
	Kalle Valo <kvalo@codeaurora.org>
To: Stephan Mueller <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from outbound1a.ore.mailhop.org ([54.213.22.21]:11219 "EHLO
	outbound1a.ore.mailhop.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752291AbcHHWE6 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 8 Aug 2016 18:04:58 -0400
Content-Disposition: inline
In-Reply-To: <20160808172930.GD4511@io.lakedaemon.net>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Stephan,

On Mon, Aug 08, 2016 at 05:29:30PM +0000, Jason Cooper wrote:
> On Mon, Aug 08, 2016 at 08:41:36AM +0200, Stephan Mueller wrote:
...
> > If you think that this patch is a challenge because your driver starts to 
> > spin, please help and offer another solution.
> 
> Well, I don't buy the reasoning listed above for not using the hwrng
> framework.  Interrupt timings were never designed to be a source of entropy
> either.  We need to grab it where ever we can find it, especially on
> embedded systems.  Documentation/hw_random.txt even says:
> 
> """
> This data is NOT CHECKED by any fitness tests, and could potentially be
> bogus (if the hardware is faulty or has been tampered with).
> """
> 
> I really don't think there's a problem with adding these sorts of
> sources under char/hw_random/.  I think the only thing we would be
> concerned about, other than the already addressed entropy estimation,
> would be constraining the data rate.

Further research yields char/hw_random/timeriomem-rng.c

It could use an update to ->read() vice data_{present,read}(), but it's
functionally exactly what the ath9k rng is doing. :)

thx,

Jason.
