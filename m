From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH 00/47] arch-removal: device drivers
Date: Thu, 15 Mar 2018 10:09:43 +0100
Message-ID: <CAK8P3a151M35ywHyABt2KFypPaiZROYuL10ztChwjSwqS9haHg@mail.gmail.com>
References: <20180314153603.3127932-1-arnd@arndb.de>
 <20180315063238.3303b8d1@bbrezillon>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: Ulf Hansson <ulf.hansson@linaro.org>, linux-usb@vger.kernel.org,
 Wolfram Sang <wsa@the-dreams.de>, linux-iio@vger.kernel.org,
 Viresh Kumar <viresh.kumar@linaro.org>,
 Linus Walleij <linus.walleij@linaro.org>,
 Alexandre Belloni <alexandre.belloni@bootlin.com>,
 IDE-ML <linux-ide@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
 linux-mtd <linux-mtd@lists.infradead.org>, linux-i2c@vger.kernel.org,
 linux-rtc@vger.kernel.org, Lars-Peter Clausen <lars@metafoo.de>,
 Herbert Xu <herbert@gondor.apana.org.au>, Jonathan Corbet <corbet@lwn.net>,
 "open list:DOCUMENTATION" <linux-doc@vger.kernel.org>,
 Alan Stern <stern@rowland.harvard.edu>, linux-serial@vger.kernel.org,
 Jiri Slaby <jslaby@suse.com>, linux-mmc <linux-mmc@vger.kernel.org>,
 Shaohua Li <shli@kernel.org>, wg@grandegger.com,
 "open list:HARDWARE RANDOM NUMBER GENERATOR CORE"
 <linux-crypto@vger.kernel.org>, linux-pwm@vger
To: Boris Brezillon <boris.brezillon@bootlin.com>
Return-path: <linux-mtd-bounces+gldm-linux-mtd-36=gmane.org@lists.infradead.org>
In-Reply-To: <20180315063238.3303b8d1@bbrezillon>
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

On Thu, Mar 15, 2018 at 6:32 AM, Boris Brezillon
<boris.brezillon@bootlin.com> wrote:
> Hi Arnd,
>
> On Wed, 14 Mar 2018 16:35:13 +0100
> Arnd Bergmann <arnd@arndb.de> wrote:
>
>> Hi driver maintainers,
>>
>> I just posted one series with the removal of eight architectures,
>> see https://lkml.org/lkml/2018/3/14/505 for details, or
>> https://lwn.net/Articles/748074/ for more background.
>>
>> These are the device drivers that go along with them. I have already
>> picked up the drivers for arch/metag/ into my tree, they were reviewed
>> earlier.
>>
>> Please let me know if you have any concerns with the patch, or if you
>> prefer to pick up the patches in your respective trees.  I created
>> the patches with 'git format-patch -D', so they will not apply without
>> manually removing those files.
>>
>> For anything else, I'd keep the removal patches in my asm-generic tree
>> and will send a pull request for 4.17 along with the actual arch removal.
>>

>
> If you don't mind, I'd like to take the mtd patches through the MTD
> tree. As you've probably noticed, nand code has been moved around and
> it's easier for me to carry those 2 simple changes in my tree than
> creating an immutable branch.
>
> Let me know if this is a problem.

Sounds good, I've removed the two patches from my tree now.
I've already sent a version of those that is based on your latest tree to
you for inclusion.

      Arnd

______________________________________________________
Linux MTD discussion mailing list
http://lists.infradead.org/mailman/listinfo/linux-mtd/
