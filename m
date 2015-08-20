From: Vinod Koul <vinod.koul@intel.com>
Subject: Re: [PATCH v1 3/4] Crypto: Add support for APM X-Gene SoC CRC32C h/w
 accelerator driver
Date: Thu, 20 Aug 2015 12:40:28 +0530
Message-ID: <20150820071028.GH13546@localhost>
References: <1438258268-3099-1-git-send-email-rsahu@apm.com>
 <1438258268-3099-4-git-send-email-rsahu@apm.com>
 <20150820054828.GY13546@localhost>
 <CAFd313xG2_4NGHspuJwThY=jUSPiBm3egvXVvhv8XxKctgMv1A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: dan.j.williams@intel.com, Herbert Xu <herbert@gondor.apana.org.au>,
	davem@davemloft.net, linux-crypto@vger.kernel.org,
	dmaengine@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
	linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, jcm@redhat.com,
	patches@apm.com
To: Rameshwar Sahu <rsahu@apm.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAFd313xG2_4NGHspuJwThY=jUSPiBm3egvXVvhv8XxKctgMv1A@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Thu, Aug 20, 2015 at 12:31:44PM +0530, Rameshwar Sahu wrote:
> Hi Vinod,
> 
> On Thu, Aug 20, 2015 at 11:18 AM, Vinod Koul <vinod.koul@intel.com> wrote:
> > On Thu, Jul 30, 2015 at 05:41:07PM +0530, Rameshwar Prasad Sahu wrote:
> >> +     nents = sg_nents(req->src);
> >> +     sg_count = dma_map_sg(dev, req->src, nents, DMA_TO_DEVICE);
> >> +     if (!sg_count) {
> >> +             dev_err(dev, "Failed to map src sg");
> >> +             return -ENOMEM;
> > mapping error shouldn't be no mem error
> Okay, I guess then -EIO will be fine here??

yes better

-- 
~Vinod
