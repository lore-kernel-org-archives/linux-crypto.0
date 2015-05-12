From: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
Subject: Re: [PATCH 2/8] dmaengine: mv_xor: add support for a38x command in
 descriptor mode
Date: Tue, 12 May 2015 18:05:39 +0200
Message-ID: <20150512180539.4ea5d158@free-electrons.com>
References: <1431445063-20226-1-git-send-email-maxime.ripard@free-electrons.com>
	<1431445063-20226-3-git-send-email-maxime.ripard@free-electrons.com>
	<20150512174936.284783d4@free-electrons.com>
	<20150512155824.GJ19927@lunn.ch>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: Maxime Ripard <maxime.ripard@free-electrons.com>,
	Vinod Koul <vinod.koul@intel.com>,
	Dan Williams <dan.j.williams@intel.com>,
	Gregory Clement <gregory.clement@free-electrons.com>,
	Jason Cooper <jason@lakedaemon.net>,
	Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
	dmaengine@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
	Lior Amsalem <alior@marvell.com>,
	Thomas Petazzoni <thomas@free-electrons.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>
To: Andrew Lunn <andrew@lunn.ch>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20150512155824.GJ19927@lunn.ch>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Andrew,

On Tue, 12 May 2015 17:58:24 +0200, Andrew Lunn wrote:

> A quick grep for marvell,orion, marvell,kirkwood and marvell,dove
> suggests it should have the - if we want to be consistent with older
> Marvell devices. As you said, starting with marvell,armanda it gets
> pretty inconsistent :-(

Yes, with the "-" would be better IMO.

Thomas
-- 
Thomas Petazzoni, CTO, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com
