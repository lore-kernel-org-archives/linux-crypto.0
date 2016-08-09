From: Jason Cooper <jason@lakedaemon.net>
Subject: Re: [PATCH v2] RANDOM: ATH9K RNG delivers zero bits of entropy
Date: Tue, 9 Aug 2016 14:04:44 +0000
Message-ID: <20160809140444.GB2013@io.lakedaemon.net>
References: <34197429.2CvoIfft9B@positron.chronox.de>
 <1654172.XfclnXhRmn@positron.chronox.de>
 <657897b90b8344eeab10d7a0f604988d@aptaiexm02f.ap.qualcomm.com>
 <1830987.VF9l4XmGxv@tauon.atsec.com>
 <20160808172930.GD4511@io.lakedaemon.net>
 <99963d34acea47bbacb3ca73b18fed9f@aptaiexm02f.ap.qualcomm.com>
 <20160809115622.GG9515@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Theodore Ts'o <tytso@mit.edu>,
	"Pan, Miaoqing" <miaoqing@qti.qualcomm.com>,
	Stephan Mueller <smueller@chronox.de>,
	"Sepehrdad, Pouyan" <pouyans@qti.qualcomm.com>,
	"herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	ath9k-devel <ath9k-devel@qca.qualcomm.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"ath9k-devel@lists.ath9k.org" <ath9k-devel@lists.ath9k.org>,
	Kalle Valo <kvalo@codeaurora.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from outbound1a.ore.mailhop.org ([54.213.22.21]:56570 "EHLO
	outbound1a.ore.mailhop.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932697AbcHIOEt (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 9 Aug 2016 10:04:49 -0400
Content-Disposition: inline
In-Reply-To: <20160809115622.GG9515@thunk.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Ted,

On Tue, Aug 09, 2016 at 07:56:22AM -0400, Theodore Ts'o wrote:
> On Tue, Aug 09, 2016 at 06:30:03AM +0000, Pan, Miaoqing wrote:
> > Agree with Jason's point, also understand Stephan's concern.  The
> > date rate can be roughly estimated by 'cat /dev/random |rngtest -c
> > 1000', the average speed is 1111.294Kibits/s. I will sent the patch
> > to disable ath9k RNG by default.
> 
> If the ATH9K is generating some random amount of data, but you don't
> know how random, and you're gathering it opportunistically --- for
> example, suppose a wireless driver gets the radio's signal strength
> through the normal course of its operation, and while there might not
> be that much randomness for someone who can observe the exact details
> of how the phone is positioned in the room --- but for which the
> analyst sitting in Fort Meade won't know whether or not the phone is
> on the desk, or in a knapsack under the table, the right interface to
> use is:
> 
>    void add_device_randomness(const void *buf, unsigned int size);
> 	
> This won't increase the entropy count, but if you have the bit of
> potential randomness "for free", you might as well contribute it to
> the entropy pool.  If it turns out that the chip was manufactured in
> China, and the MSS has backdoored it out the wazoo, it won't do any
> harm --- where as using the hwrng framework would be disastrous.

Ok, I get that.  However, we have Documentation/hw_random.txt saying:

  This data is NOT CHECKED by any fitness tests, and could potentially be
  bogus (if the hardware is faulty or has been tampered with).  Data is
  only output if the hardware "has-data" flag is set, but nevertheless a
  security-conscious person would run fitness tests on the data before
  assuming it is truly random.

Which I would read as "Don't assume 1 bit read from /dev/hwrng equals 1
bit of entropy."  Which runs counter to Stephan's reading of the rngd
code.

And then we have drivers like timeriomem-rng.c that appear to be
spitting out the raw 32bit register value of $SOC's timer.

Thankfully, most hw_random drivers don't set the quality.  So unless the
user sets the default_quality param, it's zero.

iiuc, Ted, you're saying using the hw_random framework would be
disasterous because despite most drivers having a default quality of 0,
rngd assumes 1 bit of entropy for every bit read?

thx,

Jason.
