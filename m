From: Peter Ujfalusi <peter.ujfalusi@ti.com>
Subject: Re: [PATCH 02/13] dmaengine: Introduce
 dma_request_slave_channel_compat_reason()
Date: Thu, 19 Nov 2015 12:34:22 +0200
Message-ID: <564DA5AE.3060608@ti.com>
References: <1432646768-12532-1-git-send-email-peter.ujfalusi@ti.com>
 <6347063.Gd6coh6hX8@wuerfel> <564C8E1F.8010501@ti.com>
 <6358656.jIv3GGCCXu@wuerfel>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: quoted-printable
Cc: "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
 ALSA Development Mailing List <alsa-devel@alsa-project.org>,
 Vinod Koul <vinod.koul@intel.com>, Linux MMC List <linux-mmc@vger.kernel.org>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 linux-spi <linux-spi@vger.kernel.org>, Tony Lindgren <tony@atomide.com>,
 Geert Uytterhoeven <geert@linux-m68k.org>, linux-crypto@vger.kernel.org,
 "linux-serial@vger.kernel.org" <linux-serial@vger.kernel.org>,
 dmaengine@vger.kernel.org, Dan Williams <dan.j.williams@intel.com>,
 "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
 Linux Media Mailing List <linux-media@vger.kernel.org>
To: Arnd Bergmann <arnd@arndb.de>
Return-path: <alsa-devel-bounces@alsa-project.org>
In-Reply-To: <6358656.jIv3GGCCXu@wuerfel>
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

On 11/18/2015 05:07 PM, Arnd Bergmann wrote:
> On Wednesday 18 November 2015 16:41:35 Peter Ujfalusi wrote:
>> On 11/18/2015 04:29 PM, Arnd Bergmann wrote:
>>> On Wednesday 18 November 2015 16:21:26 Peter Ujfalusi wrote:
>>>> 2. non slave channel requests, where only the functionality matters, l=
ike
>>>> memcpy, interleaved, memset, etc.
>>>> We could have a simple:
>>>> dma_request_channel(mask);
>>>>
>>>> But looking at the drivers using dmaengine legacy dma_request_channel(=
) API:
>>>> Some sets DMA_INTERRUPT or DMA_PRIVATE or DMA_SG along with DMA_SLAVE:
>>>> drivers/misc/carma/carma-fpga.c                 DMA_INTERRUPT|DMA_SLAV=
E|DMA_SG
>>>> drivers/misc/carma/carma-fpga-program.c         DMA_MEMCPY|DMA_SLAVE|D=
MA_SG
>>>> drivers/media/platform/soc_camera/mx3_camera.c  DMA_SLAVE|DMA_PRIVATE
>>>> sound/soc/intel/common/sst-firmware.c           DMA_SLAVE|DMA_MEMCPY
>>>>
>>>> as examples.
>>>> Not sure how valid are these...
> =

> I just had a look myself. carma has been removed fortunately in linux-nex=
t,
> so we don't have to worry about that any more.
> =

> I assume that the sst-firmware.c case is a mistake, it should just use a
> plain DMA_SLAVE and not DMA_MEMCPY.
> =

> Aside from these, everyone else uses either DMA_CYCLIC in addition to
> DMA_SLAVE, which seems valid, or they use DMA_PRIVATE, which I think is
> redundant in slave drivers and can be removed.

Yep, CYCLIC. How could I forgot that ;)

>>> It's usually not much harder to separate out the legacy case from
>>> the normal dma_request_slave_channel_reason(), so those drivers don't
>>> really need to use the unified compat API.
>>
>> The current dma_request_slave_channel()/_reason() is not the 'legacy' AP=
I.
>> Currently there is no way to get the reason why the dma channel request =
fails
>> when using the _compat() version of the API, which is used by drivers wh=
ich
>> can be used in DT or in legacy mode as well. Sure, they all could have l=
ocal
>> if(){}else{} for handling this, but it is not a nice thing.
>>
>> As it was discussed instead of adding the _reason() version for the _com=
pat
>> call, we should simplify the dmaengine API for getting the channel and a=
t the
>> same time we will have ERR_PTR returned instead of NULL.
> =

> What I meant was that we don't need to handle them with the unified
> simple interface. The users of DMA_CYCLIC can just keep using
> an internal helper that only deals with the legacy case, or use
> dma_request_slave() or whatever is the new API for the DT case.

I think we can go with a single API, but I don't really like that:
dma_request_channel(dev, name, *mask, fn, fn_param);

This would cover all current uses being legacy, DT/ACPI, compat, etc:
dma_request_channel(NULL, NULL, &mask, fn, fn_param); /* Legacy slave */
dma_request_channel(NULL, NULL, &mask, NULL, NULL); /* memcpy. etc */
dma_request_channel(dev, name, NULL, NULL, NULL); /* DT/ACPI, current slave=
 */
dma_request_channel(dev, name, &mask, fn, fn_param); /* current compat */

Note, that we need "const dma_cap_mask_t *mask" to be able to make the mask
optional.

If we have two main APIs, one to request slave channels and one to get any
channel with given capability
dma_request_slave_channel(NULL, NULL, &mask, fn, fn_param); /* Legacy slave=
 */
dma_request_slave_channel(dev, name, NULL, NULL, NULL); /* DT/ACPI, current
							   slave */
dma_request_slave_channel(dev, name, &mask, fn, fn_param); /* current compa=
t*/

This way we can omit the mask also in cases when the client only want to get
DMA_SLAVE, we can just build up the mask within the function. If the mask is
provided we would copy the bits from the provided mask, so for example if y=
ou
want to have DMA_SLAVE+DMA_CYCLIC, the driver only needs to pass DMA_CYCLIC,
the DMA_SLAVE is going to be set anyways.

dma_request_channel(mask); /* memcpy. etc, non slave mostly */

Not sure how to name this as reusing existing (good, descriptive) function
names would mean changes all over the kernel to start off this.

Not used and
request_dma_channel(); /* as _irq/_mem_region/_resource, etc */
request_dma();
dma_channel_request();

All in all, not sure which way would be better...

-- =

P=E9ter
