From: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
Subject: Re: [PATCH 5/8] dmaengine: mv_xor: bug fix for racing condition in
 descriptors cleanup
Date: Tue, 12 May 2015 17:51:17 +0200
Message-ID: <20150512175117.1eaff739@free-electrons.com>
References: <1431445063-20226-1-git-send-email-maxime.ripard@free-electrons.com>
	<1431445063-20226-6-git-send-email-maxime.ripard@free-electrons.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Cc: Vinod Koul <vinod.koul@intel.com>,
	Dan Williams <dan.j.williams@intel.com>,
	Gregory Clement <gregory.clement@free-electrons.com>,
	Jason Cooper <jason@lakedaemon.net>,
	Andrew Lunn <andrew@lunn.ch>,
	Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
	dmaengine@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
	Lior Amsalem <alior@marvell.com>,
	Thomas Petazzoni <thomas@free-electrons.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>
To: Maxime Ripard <maxime.ripard@free-electrons.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from down.free-electrons.com ([37.187.137.238]:58036 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932843AbbELPv1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 12 May 2015 11:51:27 -0400
In-Reply-To: <1431445063-20226-6-git-send-email-maxime.ripard@free-electrons.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Maxime,

On Tue, 12 May 2015 17:37:40 +0200, Maxime Ripard wrote:
> From: Lior Amsalem <alior@marvell.com>
> 
> This patch fixes a bug in the XOR driver where the cleanup function can be
> called and free descriptors that never been processed by the engine (which
> result in data errors).
> 
> The cleanup function will free descriptors based on the ownership bit in
> the descriptors.
> 
> Signed-off-by: Lior Amsalem <alior@marvell.com>
> Reviewed-by: Ofer Heifetz <oferh@marvell.com>
> Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>

If this is fixing a bug, shouldn't it be Cc'ed to stable@ ? But then it
needs to be the first patch in the series.

>From what I remember, this series both fixes some issues *and* adds
RAID6 support. We need to separate out the two things so that the fixes
can be propagated to stable.

Thanks,

Thomas
-- 
Thomas Petazzoni, CTO, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com
