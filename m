From: Peter Ujfalusi <peter.ujfalusi@ti.com>
Subject: Re: [PATCH 02/13] dmaengine: Introduce
 dma_request_slave_channel_compat_reason()
Date: Mon, 22 Jun 2015 14:31:00 +0300
Message-ID: <5587F1F4.1060905@ti.com>
References: <1432646768-12532-1-git-send-email-peter.ujfalusi@ti.com>
 <1432646768-12532-3-git-send-email-peter.ujfalusi@ti.com>
 <20150529093317.GF3140@localhost>
 <CAMuHMdVJ0h9qXxBWH9L2y4O2KLkEq12KW_6k8rTgi+Lux=C0gw@mail.gmail.com>
 <20150529101846.GG3140@localhost> <55687892.7050606@ti.com>
 <20150602125535.GS3140@localhost> <5570758E.6030302@ti.com>
 <20150612125837.GJ28601@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: quoted-printable
Cc: "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
 ALSA Development Mailing List <alsa-devel@alsa-project.org>,
 Tony Lindgren <tony@atomide.com>, Linux MMC List <linux-mmc@vger.kernel.org>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 linux-spi <linux-spi@vger.kernel.org>,
 Geert Uytterhoeven <geert@linux-m68k.org>, linux-crypto@vger.kernel.org,
 "linux-serial@vger.kernel.org" <linux-serial@vger.kernel.org>,
 dmaengine@vger.kernel.org, Dan Williams <dan.j.williams@intel.com>,
 "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
 Linux Media Mailing List <linux-media@vger.kernel.org>
To: Vinod Koul <vinod.koul@intel.com>
Return-path: <alsa-devel-bounces@alsa-project.org>
In-Reply-To: <20150612125837.GJ28601@localhost>
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

On 06/12/2015 03:58 PM, Vinod Koul wrote:
> Sorry this slipped thru

I was away for a week anyways ;)

> Thinking about it again, I think we should coverge to two APIs and mark t=
he
> legacy depracuated and look to convert folks and phase that out

Currently, w/o this series we have these APIs:
/* to be used with DT/ACPI */
dma_request_slave_channel(dev, name)		/* NULL on failure */
dma_request_slave_channel_reason(dev, name)	/* error code on failure */

/* Legacy mode only - no DT/ACPI lookup */
dma_request_channel(mask, fn, fn_param) /* NULL on failure */

/* to be used with DT/ACPI or legacy boot */
dma_request_slave_channel_compat(mask, fn, fn_param, dev, name)	/* NULL on
failure */

To request _any_ channel to be used for memcpy one has to use
dma_request_channel(mask, NULL, NULL);

If I did not missed something.

As we need different types of parameters for DT/ACPI and legacy (non DT/ACPI
lookup) and the good API names are already taken, we might need to settle:

/* to be used with DT/ACPI */
dma_request_slave_channel(dev, name) /* error code on failure */
- Convert users to check IS_ERR_OR_NULL() instead against NULL
- Mark dma_request_slave_channel_reason() deprecated and convert the curren=
t users

/* to be used with DT/ACPI or legacy boot */
dma_request_slave_channel_compat(mask, fn, fn_param, dev, name) /* error co=
de
on failure */
- Convert users to check IS_ERR_OR_NULL() instead against NULL
- Do not try legacy mode if either OF or ACPI failed because of real error

/* Legacy mode only - no DT/ACPI lookup */
dma_request_channel_legacy(mask, fn, fn_param) /* error code on failure */
- convert users of dma_request_channel()
- mark dma_request_channel() deprecated

/* to be used to get a channel for memcpy for example */
dma_request_any_channel(mask) /* error code on failure */
- Convert current dma_request_channel(mask, NULL, NULL) users
I know, any of the other function could be prepared to handle this when
parameters are missing, but it is a bit cleaner to have separate API for th=
is.

It would be nice to find another name for the
dma_request_slave_channel_compat() so with the new name we could have chance
to rearrange the parameters: (dev, name, mask, fn, fn_param)

We would end up with the following APIs, all returning with error code on f=
ailure:
dma_request_slave_channel(dev, name);
dma_request_channel_legacy(mask, fn, fn_param);
dma_request_slave_channel_compat(mask, fn, fn_param, dev, name);
dma_request_any_channel(mask);

What do you think?

-- =

P=E9ter
