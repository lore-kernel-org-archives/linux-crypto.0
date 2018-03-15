From: Boris Brezillon <boris.brezillon@bootlin.com>
Subject: Re: [PATCH 00/47] arch-removal: device drivers
Date: Thu, 15 Mar 2018 06:32:38 +0100
Message-ID: <20180315063238.3303b8d1@bbrezillon>
References: <20180314153603.3127932-1-arnd@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: ulf.hansson@linaro.org, linux-usb@vger.kernel.org, wsa@the-dreams.de,
 linux-iio@vger.kernel.org, viresh.kumar@linaro.org, linus.walleij@linaro.org,
 alexandre.belloni@bootlin.com, linux-ide@vger.kernel.org,
 netdev@vger.kernel.org, linux-mtd@lists.infradead.org,
 linux-i2c@vger.kernel.org, linux-rtc@vger.kernel.org, lars@metafoo.de,
 herbert@gondor.apana.org.au, corbet@lwn.net, linux-doc@vger.kernel.org,
 stern@rowland.harvard.edu, linux-serial@vger.kernel.org, jslaby@suse.com,
 linux-mmc@vger.kernel.org, shli@kernel.org, wg@grandegger.com,
 linux-crypto@vger.kernel.org, linux-pwm@vger.kernel.org,
 linux-watchdog@vger.kernel.org, alsa-devel@alsa-project.org,
 b.zolnierkie@samsung.com, linux-input@vger.kernel.org,
 linux-can@vger.kernel.org, linux-raid@vger.kernel.org,
 linux-gpio@vger.kernel.org, broonie@kernel.org, bp@alien8.de,
 linux-fbdev@vger.kernel.org, mchehab@kernel.org, lin
To: Arnd Bergmann <arnd@arndb.de>
Return-path: <linux-mtd-bounces+gldm-linux-mtd-36=gmane.org@lists.infradead.org>
In-Reply-To: <20180314153603.3127932-1-arnd@arndb.de>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-mtd>,
 <mailto:linux-mtd-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-mtd/>
List-Post: <mailto:linux-mtd@lists.infradead.org>
List-Help: <mailto:linux-mtd-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-mtd>,
 <mailto:linux-mtd-request@lists.infradead.org?subject=subscribe>
Sender: "linux-mtd" <linux-mtd-bounces@lists.infradead.org>
Errors-To: linux-mtd-bounces+gldm-linux-mtd-36=gmane.org@lists.infradead.org
List-Id: linux-crypto.vger.kernel.org

Hi Arnd,

On Wed, 14 Mar 2018 16:35:13 +0100
Arnd Bergmann <arnd@arndb.de> wrote:

> Hi driver maintainers,
> 
> I just posted one series with the removal of eight architectures,
> see https://lkml.org/lkml/2018/3/14/505 for details, or
> https://lwn.net/Articles/748074/ for more background.
> 
> These are the device drivers that go along with them. I have already
> picked up the drivers for arch/metag/ into my tree, they were reviewed
> earlier.
> 
> Please let me know if you have any concerns with the patch, or if you
> prefer to pick up the patches in your respective trees.  I created
> the patches with 'git format-patch -D', so they will not apply without
> manually removing those files.
> 
> For anything else, I'd keep the removal patches in my asm-generic tree
> and will send a pull request for 4.17 along with the actual arch removal.
> 
>        Arnd
> 
> Arnd Bergmann
>   edac: remove tile driver
>   net: tile: remove ethernet drivers
>   net: adi: remove blackfin ethernet drivers
>   net: 8390: remove m32r specific bits
>   net: remove cris etrax ethernet driver
>   net: smsc: remove m32r specific smc91x configuration
>   raid: remove tile specific raid6 implementation
>   rtc: remove tile driver
>   rtc: remove bfin driver
>   char: remove obsolete ds1302 rtc driver
>   char: remove tile-srom.c
>   char: remove blackfin OTP driver
>   pcmcia: remove m32r drivers
>   pcmcia: remove blackfin driver
>   ASoC: remove blackfin drivers
>   video/logo: remove obsolete logo files
>   fbdev: remove blackfin drivers
>   fbdev: s1d13xxxfb: remove m32r specific hacks
>   crypto: remove blackfin CRC driver
>   media: platform: remove blackfin capture driver
>   media: platform: remove m32r specific arv driver
>   cpufreq: remove blackfin driver
>   cpufreq: remove cris specific drivers
>   gpio: remove etraxfs driver
>   pinctrl: remove adi2/blackfin drivers
>   ata: remove bf54x driver
>   input: keyboard: remove bf54x driver
>   input: misc: remove blackfin rotary driver
>   mmc: remove bfin_sdh driver
>   can: remove bfin_can driver
>   watchdog: remove bfin_wdt driver
>   mtd: maps: remove bfin-async-flash driver
>   mtd: nand: remove bf5xx_nand driver

If you don't mind, I'd like to take the mtd patches through the MTD
tree. As you've probably noticed, nand code has been moved around and
it's easier for me to carry those 2 simple changes in my tree than
creating an immutable branch.

Let me know if this is a problem.

Regards,

Boris

-- 
Boris Brezillon, Bootlin (formerly Free Electrons)
Embedded Linux and Kernel engineering
https://bootlin.com

______________________________________________________
Linux MTD discussion mailing list
http://lists.infradead.org/mailman/listinfo/linux-mtd/
