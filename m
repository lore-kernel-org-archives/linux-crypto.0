From: Peter Ujfalusi <peter.ujfalusi@ti.com>
Subject: Re: [PATCH 02/13] dmaengine: Introduce dma_request_slave_channel_compat_reason()
Date: Thu, 4 Jun 2015 18:58:06 +0300
Message-ID: <5570758E.6030302@ti.com>
References: <1432646768-12532-1-git-send-email-peter.ujfalusi@ti.com> <1432646768-12532-3-git-send-email-peter.ujfalusi@ti.com> <20150529093317.GF3140@localhost> <CAMuHMdVJ0h9qXxBWH9L2y4O2KLkEq12KW_6k8rTgi+Lux=C0gw@mail.gmail.com> <20150529101846.GG3140@localhost> <55687892.7050606@ti.com> <20150602125535.GS3140@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Geert Uytterhoeven <geert@linux-m68k.org>,
	Tony Lindgren <tony@atomide.com>,
	"devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	Dan Williams <dan.j.williams@intel.com>,
	<dmaengine@vger.kernel.org>,
	"linux-serial@vger.kernel.org" <linux-serial@vger.kernel.org>,
	"linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
	Linux MMC List <linux-mmc@vger.kernel.org>,
	<linux-crypto@vger.kernel.org>,
	linux-spi <linux-spi@vger.kernel.org>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	ALSA Development Mailing List <alsa-devel@alsa-project.org>
To: Vinod Koul <vinod.koul@intel.com>
Return-path: <linux-media-owner@vger.kernel.org>
In-Reply-To: <20150602125535.GS3140@localhost>
Sender: linux-media-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Vinod,

On 06/02/2015 03:55 PM, Vinod Koul wrote:
> On Fri, May 29, 2015 at 05:32:50PM +0300, Peter Ujfalusi wrote:
>> On 05/29/2015 01:18 PM, Vinod Koul wrote:
>>> On Fri, May 29, 2015 at 11:42:27AM +0200, Geert Uytterhoeven wrote:
>>>> On Fri, May 29, 2015 at 11:33 AM, Vinod Koul <vinod.koul@intel.com=
> wrote:
>>>>> On Tue, May 26, 2015 at 04:25:57PM +0300, Peter Ujfalusi wrote:
>>>>>> dma_request_slave_channel_compat() 'eats' up the returned error =
codes which
>>>>>> prevents drivers using the compat call to be able to do deferred=
 probing.
>>>>>>
>>>>>> The new wrapper is identical in functionality but it will return=
 with error
>>>>>> code in case of failure and will pass the -EPROBE_DEFER to the c=
aller in
>>>>>> case dma_request_slave_channel_reason() returned with it.
>>>>> This is okay but am worried about one more warpper, how about fix=
ing
>>>>> dma_request_slave_channel_compat()
>>>>
>>>> Then all callers of dma_request_slave_channel_compat() have to be
>>>> modified to handle ERR_PTR first.
>>>>
>>>> The same is true for (the existing) dma_request_slave_channel_reas=
on()
>>>> vs. dma_request_slave_channel().
>>> Good point, looking again, I think we should rather fix
>>> dma_request_slave_channel_reason() as it was expected to return err=
 code and
>>> add new users. Anyway users of this API do expect the reason...
>>
>> Hrm, they are for different use.dma_request_slave_channel()/_reason(=
) is for
>> drivers only working via DT or ACPI while
>> dma_request_slave_channel_compat()/_reason() is for drivers expected=
 to run in
>> DT/ACPI or legacy mode as well.
>>
>> I added the dma_request_slave_channel_compat_reason() because OMAP/d=
aVinci
>> drivers are using this to request channels - they need to support DT=
 and
>> legacy mode.
> I think we should hide these things behind the API and do this behind=
 the
> hood for ACPI/DT systems.
>=20
> Also it makes sense to use right API and mark rest as depricated

So to convert the dma_request_slave_channel_compat() and not to create =
_reason
variant?

Or to have single API to request channel? The problem with that is that=
 we
need different parameters for legacy and DT for example.

>>
>> But it is doable to do this for both the non _compat and _compat ver=
sion:
>> 1. change all users to check IS_ERR_OR_NULL(chan)
>>  return the PTR_ERR if not NULL, or do whatever the driver was doing=
 in case
>> of chan =3D=3D NULL.
>> 2. change the non _compat and _compat versions to do the same as the=
 _reason
>> variants, #define the _reason ones to the non _reason names
>> 3. Rename the _reason use to non _reason function in drivers
>> 4. Remove the #defines for the _reason functions
>> 5. Change the IS_ERR_OR_NULL(chan) to IS_ERR(chan) in all drivers
>> The result:
>> Both dma_request_slave_channel() and dma_request_slave_channel_compa=
t() will
>> return ERR_PTR in case of failure or in success they will return the=
 pinter to
>> chan.
>>
>> Is this what you were asking?
>> It is a bit broader than what this series was doing: taking care of
>> OMAP/daVinci drivers for deferred probing regarding to dmaengine ;)
> Yes but it would make sense right? I know it is a larger work but the=
n we
> wouldn't want another dma_request_slave_xxx API, at some point we hav=
e stop
> it exapnding, perhpas now :)

Yes, it make sense to get rid if the _reason() things and have the
dma_request_slave_channel() and dma_request_slave_channel_compat() retu=
rn with
error code

One thing we need to do for this is to change the error codes coming ba=
ck from
the _dt() and _acpi() calls when we boot in legacy mode. Right now the =
only
error code which comes back is -ENODEV and -EPROBE_DEFER. We need to
differentiate between 'real' errors and from the fact that we did not b=
ooted
with DT or the ACPI is not available.
IMHO if we boot with DT and the channel request fails with other than
-EPROBE_DEFER we should not go and try to get the channel via legacy AP=
I.

> Yes I am all ears to stage this work and not do transition gardually.=
=2E
>=20


--=20
P=E9ter
