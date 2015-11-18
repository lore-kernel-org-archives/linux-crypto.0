From: Vinod Koul <vinod.koul@intel.com>
Subject: Re: [PATCH 02/13] dmaengine: Introduce
 dma_request_slave_channel_compat_reason()
Date: Wed, 18 Nov 2015 21:36:18 +0530
Message-ID: <20151118160618.GV25173@localhost>
References: <1432646768-12532-1-git-send-email-peter.ujfalusi@ti.com>
 <6358656.jIv3GGCCXu@wuerfel>
 <CAHp75VeZFXp9i_zz7CBkVQVPGQxuzYk9AbWbbbn33r8YX3LCdw@mail.gmail.com>
 <8215351.e99Q2vhQ5T@wuerfel>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
 ALSA Development Mailing List <alsa-devel@alsa-project.org>,
 Tony Lindgren <tony@atomide.com>, Linux MMC List <linux-mmc@vger.kernel.org>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 linux-spi <linux-spi@vger.kernel.org>, Peter Ujfalusi <peter.ujfalusi@ti.com>,
 Andy Shevchenko <andy.shevchenko@gmail.com>,
 Geert Uytterhoeven <geert@linux-m68k.org>,
 linux-crypto <linux-crypto@vger.kernel.org>,
 "linux-serial@vger.kernel.org" <linux-serial@vger.kernel.org>,
 dmaengine <dmaengine@vger.kernel.org>, Dan Williams <dan.j.williams@intel.com>,
 "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
 Linux Media Mailing List <linux-media@vger.kernel.org>
To: Arnd Bergmann <arnd@arndb.de>
Return-path: <alsa-devel-bounces@alsa-project.org>
Content-Disposition: inline
In-Reply-To: <8215351.e99Q2vhQ5T@wuerfel>
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

On Wed, Nov 18, 2015 at 04:51:54PM +0100, Arnd Bergmann wrote:
> On Wednesday 18 November 2015 17:43:04 Andy Shevchenko wrote:
> > >
> > > I assume that the sst-firmware.c case is a mistake, it should just use a
> > > plain DMA_SLAVE and not DMA_MEMCPY.
> > 
> > Other way around.
> > 
> 
> Ok, I see. In that case I guess it also shouldn't call
> dmaengine_slave_config(), right? I don't think that's valid
> on a MEMCPY channel.

Yes it is not valid. In this case the dma driver should invoke a generic memcpy
and not need slave parameters, knowing the hw and reason for this (firmware
download to DSP memory), this doesn't qualify for slave case.
In fact filter function doesn't need a channel, any channel in this
controller will be good

-- 
~Vinod
