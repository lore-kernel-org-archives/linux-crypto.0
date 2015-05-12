From: Dan Williams <dan.j.williams@intel.com>
Subject: Re: [PATCH 0/8] ARM: mvebu: Add support for RAID6 PQ offloading
Date: Tue, 12 May 2015 09:05:41 -0700
Message-ID: <CAPcyv4gshyaji2HarAeOg3XOiNnmGwnSOMuFGWpuDu8ZTGg=jw@mail.gmail.com>
References: <1431445063-20226-1-git-send-email-maxime.ripard@free-electrons.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Vinod Koul <vinod.koul@intel.com>,
	Gregory Clement <gregory.clement@free-electrons.com>,
	Jason Cooper <jason@lakedaemon.net>,
	Andrew Lunn <andrew@lunn.ch>,
	Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
	"dmaengine@vger.kernel.org" <dmaengine@vger.kernel.org>,
	"linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	linux-crypto@vger.kernel.org, Lior Amsalem <alior@marvell.com>,
	Thomas Petazzoni <thomas@free-electrons.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>
To: Maxime Ripard <maxime.ripard@free-electrons.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1431445063-20226-1-git-send-email-maxime.ripard@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Tue, May 12, 2015 at 8:37 AM, Maxime Ripard
<maxime.ripard@free-electrons.com> wrote:
> Hi,
>
> This serie refactors the mv_xor in order to support the latest Armada
> 38x features, including the PQ support in order to offload the RAID6
> PQ operations.
>
> Not all the PQ operations are supported by the XOR engine, so we had
> to introduce new async_tx flags in the process to identify
> un-supported operations.
>
> Please note that this is currently not usable because of a possible
> regression in the RAID stack in 4.1 that is being discussed at the
> moment here: https://lkml.org/lkml/2015/5/7/527

This is problematic as async_tx is a wart on the dmaengine subsystem
and needs to be deprecated, I just have yet to find the time to do
that work.  It turns out it was a mistake to hide the device details
from md, it should be explicitly managing the dma channels, not
relying on a abstraction api.  The async_tx api usage of the
dma-mapping api is broken in that it relies on overlapping mappings of
the same address.  This happens to work on x86, but on arm it needs
explicit non-overlapping mappings.  I started the work to reference
count dma-mappings in 3.13, and we need to teach md to use
dmaengine_unmap_data explicitly.  Yielding dma channel management to
md also results in a more efficient implementation as we can dma_map()
the stripe cache once rather than per-io.  The  "async_tx_ack()"
disaster can also go away when md is explicitly handling channel
switching.
