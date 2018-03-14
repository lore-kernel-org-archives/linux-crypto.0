From: "Rafael J. Wysocki" <rafael@kernel.org>
Subject: Re: [PATCH 00/47] arch-removal: device drivers
Date: Wed, 14 Mar 2018 23:45:54 +0100
Message-ID: <CAJZ5v0jsoxWRiwPOCJH6AAz-MiccOuicD8peCevLRMbTfc7LEg@mail.gmail.com>
References: <20180314153603.3127932-1-arnd@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: Ulf Hansson <ulf.hansson@linaro.org>,
 "open list:ULTRA-WIDEBAND \(UWB\) SUBSYSTEM:" <linux-usb@vger.kernel.org>,
 Wolfram Sang <wsa@the-dreams.de>, linux-iio@vger.kernel.org,
 Viresh Kumar <viresh.kumar@linaro.org>,
 Linus Walleij <linus.walleij@linaro.org>, alexandre.belloni@bootlin.com,
 linux-ide@vger.kernel.org, netdev <netdev@vger.kernel.org>,
 linux-mtd@lists.infradead.org, linux-i2c <linux-i2c@vger.kernel.org>,
 linux-rtc@vger.kernel.org, Lars-Peter Clausen <lars@metafoo.de>,
 Herbert Xu <herbert@gondor.apana.org.au>, Jonathan Corbet <corbet@lwn.net>,
 "open list:DOCUMENTATION" <linux-doc@vger.kernel.org>,
 Alan Stern <stern@rowland.harvard.edu>, linux-serial@vger.kernel.org,
 Jiri Slaby <jslaby@suse.com>, linux-mmc <linux-mmc@vger.kernel.org>,
 shli@kernel.org, wg@grandegger.com, linux-crypto@vger.kernel.org,
 Linux PWM List <linux-pwm@vger.kernel.org>, linux-watchdog@vger.k
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

On Wed, Mar 14, 2018 at 4:35 PM, Arnd Bergmann <arnd@arndb.de> wrote:
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

Please include the cpufreq patches into that and you can add ACKs from
me on them if that helps.

Thanks!

______________________________________________________
Linux MTD discussion mailing list
http://lists.infradead.org/mailman/listinfo/linux-mtd/
