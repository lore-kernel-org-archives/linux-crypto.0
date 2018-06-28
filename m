From: Linus Walleij <linus.walleij@linaro.org>
Subject: Re: [PATCH 2/9] crypto: atmel-ecc: Silently ignore missing clock
 frequency
Date: Thu, 28 Jun 2018 10:47:12 +0200
Message-ID: <CACRpkdYDABDgYe=FOsQK9=p-mB3Qr8wVb=hbbEgzo_qUCbutPQ@mail.gmail.com>
References: <20180605134950.6605-1-linus.walleij@linaro.org>
 <20180605134950.6605-2-linus.walleij@linaro.org>
 <e33b8860-2ff4-da8f-8500-ad24ab6c1e4e@microchip.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: linux-i2c@vger.kernel.org, Herbert Xu <herbert@gondor.apana.org.au>,
 linux-crypto@vger.kernel.org, Linux ARM <linux-arm-kernel@lists.infradead.org>,
 Wolfram Sang <wsa@the-dreams.de>
To: Tudor Ambarus <tudor.ambarus@microchip.com>
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <e33b8860-2ff4-da8f-8500-ad24ab6c1e4e@microchip.com>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
List-Id: linux-crypto.vger.kernel.org

On Mon, Jun 11, 2018 at 11:46 AM Tudor Ambarus
<tudor.ambarus@microchip.com> wrote:
> On 06/05/2018 04:49 PM, Linus Walleij wrote:
> > The Atmel ECC driver contains a check for the I2C bus clock
> > frequency, so as to check that the I2C adapter in use
> > satisfies the device specs.
> >
> > If the device is connected to a device tree node that does not
> > contain a clock frequency setting, such as an I2C mux or gate,
> > this blocks the probe. Make the probe continue silently if
> > no clock frequency can be found, assuming all is safe.
>
> I don't think it's safe. We use bus_clk_rate to compute the ecc508's
> wake token. If you can't wake the device, it will ignore all your
> commands.

I see. I wonder why it works so well for me then?
Could we just print a warning and continue?
The general advice for the kernel is not to bail out if
hardware is not optimally configured, but continue with
a warning that maybe not everything is all right.

> My proposal was to introduce a bus_freq_hz member in the i2c_adapter
> structure (https://patchwork.kernel.org/patch/10307637/), but I haven't
> received feedback yet, Wolfram?
>
> I would say first to check the bus_freq_hz from adapter (if it will be
> accepted) else to look into dt and, in the last case, if nowhere
> provided, to block the probe.

So blocking the probe because we are not 100% sure the hardware
will work is against established practice: the established practice
is to be liberal with letting probe() continue, but emit a warning.

In my case that is good because it makes the hardware probe
and work without any visible problems.

I *can* try to traverse the device tree upwards from the mux node
to find the parent I2C controller and its "clock-frequency"
property. I felt that was hackish, but if you prefer the hack I
can try to use that.

Yours,
Linus Walleij
