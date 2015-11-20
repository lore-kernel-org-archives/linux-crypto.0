From: Andy Shevchenko <andy.shevchenko@gmail.com>
Subject: Re: [PATCH 02/13] dmaengine: Introduce
	dma_request_slave_channel_compat_reason()
Date: Fri, 20 Nov 2015 14:24:06 +0200
Message-ID: <CAHp75VdoHqPMNGFfz4mPhX+Lw+vxgiyqFS8j5+kQ9Z9CHt=OTA@mail.gmail.com>
References: <1432646768-12532-1-git-send-email-peter.ujfalusi@ti.com>
 <4533695.7ZVFN1S94o@wuerfel> <564EF502.6040708@ti.com>
 <6118451.vaLZWOZEF5@wuerfel>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
 ALSA Development Mailing List <alsa-devel@alsa-project.org>,
 Vinod Koul <vinod.koul@intel.com>, Linux MMC List <linux-mmc@vger.kernel.org>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 linux-spi <linux-spi@vger.kernel.org>, Peter Ujfalusi <peter.ujfalusi@ti.com>,
 Tony Lindgren <tony@atomide.com>, Geert Uytterhoeven <geert@linux-m68k.org>,
 linux-crypto <linux-crypto@vger.kernel.org>,
 "linux-serial@vger.kernel.org" <linux-serial@vger.kernel.org>,
 dmaengine <dmaengine@vger.kernel.org>, Dan Williams <dan.j.williams@intel.com>,
 "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
 Linux Media Mailing List <linux-media@vger.kernel.org>
To: Arnd Bergmann <arnd@arndb.de>
Return-path: <alsa-devel-bounces@alsa-project.org>
In-Reply-To: <6118451.vaLZWOZEF5@wuerfel>
List-Unsubscribe: <http://mailman.alsa-project.org/mailman/options/alsa-devel>,
 <mailto:alsa-devel-request@alsa-project.org?subject=unsubscribe>
List-Archive: <http://mailman.alsa-project.org/pipermail/alsa-devel/>
List-Post: <mailto:alsa-devel@alsa-project.org>
List-Help: <mailto:alsa-devel-request@alsa-project.org?subject=help>
List-Subscribe: <http://mailman.alsa-project.org/mailman/listinfo/alsa-devel>,
 <mailto:alsa-devel-request@alsa-project.org?subject=subscribe>
Errors-To: alsa-devel-bounces@alsa-project.org
Sender: alsa-devel-bounces@alsa-project.org
List-Id: linux-crypto.vger.kernel.org

On Fri, Nov 20, 2015 at 12:58 PM, Arnd Bergmann <arnd@arndb.de> wrote:
> On Friday 20 November 2015 12:25:06 Peter Ujfalusi wrote:
>> On 11/19/2015 01:25 PM, Arnd Bergmann wrote:

> Another idea would be to remove the filter function from struct dma_chan_map
> and pass the map through platform data

Why not unified device properties?

-- 
With Best Regards,
Andy Shevchenko
