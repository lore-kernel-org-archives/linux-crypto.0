From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH v2] RANDOM: ATH9K RNG delivers zero bits of entropy
Date: Tue, 9 Aug 2016 07:56:22 -0400
Message-ID: <20160809115622.GG9515@thunk.org>
References: <34197429.2CvoIfft9B@positron.chronox.de>
 <1654172.XfclnXhRmn@positron.chronox.de>
 <657897b90b8344eeab10d7a0f604988d@aptaiexm02f.ap.qualcomm.com>
 <1830987.VF9l4XmGxv@tauon.atsec.com>
 <20160808172930.GD4511@io.lakedaemon.net>
 <99963d34acea47bbacb3ca73b18fed9f@aptaiexm02f.ap.qualcomm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jason Cooper <jason@lakedaemon.net>,
	Stephan Mueller <smueller@chronox.de>,
	"Sepehrdad, Pouyan" <pouyans@qti.qualcomm.com>,
	"herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	ath9k-devel <ath9k-devel@qca.qualcomm.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"ath9k-devel@lists.ath9k.org" <ath9k-devel@lists.ath9k.org>,
	Kalle Valo <kvalo@codeaurora.org>
To: "Pan, Miaoqing" <miaoqing@qti.qualcomm.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <99963d34acea47bbacb3ca73b18fed9f@aptaiexm02f.ap.qualcomm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Tue, Aug 09, 2016 at 06:30:03AM +0000, Pan, Miaoqing wrote:
> Agree with Jason's point, also understand Stephan's concern.  The
> date rate can be roughly estimated by 'cat /dev/random |rngtest -c
> 1000', the average speed is 1111.294Kibits/s. I will sent the patch
> to disable ath9k RNG by default.

If the ATH9K is generating some random amount of data, but you don't
know how random, and you're gathering it opportunistically --- for
example, suppose a wireless driver gets the radio's signal strength
through the normal course of its operation, and while there might not
be that much randomness for someone who can observe the exact details
of how the phone is positioned in the room --- but for which the
analyst sitting in Fort Meade won't know whether or not the phone is
on the desk, or in a knapsack under the table, the right interface to
use is:

   void add_device_randomness(const void *buf, unsigned int size);
	
This won't increase the entropy count, but if you have the bit of
potential randomness "for free", you might as well contribute it to
the entropy pool.  If it turns out that the chip was manufactured in
China, and the MSS has backdoored it out the wazoo, it won't do any
harm --- where as using the hwrng framework would be disastrous.

Cheerfs,

						- Ted
