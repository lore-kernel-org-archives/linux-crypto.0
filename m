From: Peter Ujfalusi <peter.ujfalusi@ti.com>
Subject: Re: [PATCH 02/13] dmaengine: Introduce
	dma_request_slave_channel_compat_reason()
Date: Fri, 29 May 2015 17:32:50 +0300
Message-ID: <55687892.7050606@ti.com>
References: <1432646768-12532-1-git-send-email-peter.ujfalusi@ti.com>
 <1432646768-12532-3-git-send-email-peter.ujfalusi@ti.com>
 <20150529093317.GF3140@localhost>
 <CAMuHMdVJ0h9qXxBWH9L2y4O2KLkEq12KW_6k8rTgi+Lux=C0gw@mail.gmail.com>
 <20150529101846.GG3140@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: quoted-printable
Cc: "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
 ALSA Development Mailing List <alsa-devel@alsa-project.org>,
 Tony Lindgren <tony@atomide.com>, Linux MMC List <linux-mmc@vger.kernel.org>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 linux-spi <linux-spi@vger.kernel.org>, linux-crypto@vger.kernel.org,
 "linux-serial@vger.kernel.org" <linux-serial@vger.kernel.org>,
 dmaengine@vger.kernel.org, Dan Williams <dan.j.williams@intel.com>,
 "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
 Linux Media Mailing List <linux-media@vger.kernel.org>
To: Vinod Koul <vinod.koul@intel.com>, Geert Uytterhoeven
 <geert@linux-m68k.org>
Return-path: <alsa-devel-bounces@alsa-project.org>
In-Reply-To: <20150529101846.GG3140@localhost>
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

On 05/29/2015 01:18 PM, Vinod Koul wrote:
> On Fri, May 29, 2015 at 11:42:27AM +0200, Geert Uytterhoeven wrote:
>> On Fri, May 29, 2015 at 11:33 AM, Vinod Koul <vinod.koul@intel.com> wrot=
e:
>>> On Tue, May 26, 2015 at 04:25:57PM +0300, Peter Ujfalusi wrote:
>>>> dma_request_slave_channel_compat() 'eats' up the returned error codes =
which
>>>> prevents drivers using the compat call to be able to do deferred probi=
ng.
>>>>
>>>> The new wrapper is identical in functionality but it will return with =
error
>>>> code in case of failure and will pass the -EPROBE_DEFER to the caller =
in
>>>> case dma_request_slave_channel_reason() returned with it.
>>> This is okay but am worried about one more warpper, how about fixing
>>> dma_request_slave_channel_compat()
>>
>> Then all callers of dma_request_slave_channel_compat() have to be
>> modified to handle ERR_PTR first.
>>
>> The same is true for (the existing) dma_request_slave_channel_reason()
>> vs. dma_request_slave_channel().
> Good point, looking again, I think we should rather fix
> dma_request_slave_channel_reason() as it was expected to return err code =
and
> add new users. Anyway users of this API do expect the reason...

Hrm, they are for different use.dma_request_slave_channel()/_reason() is for
drivers only working via DT or ACPI while
dma_request_slave_channel_compat()/_reason() is for drivers expected to run=
 in
DT/ACPI or legacy mode as well.

I added the dma_request_slave_channel_compat_reason() because OMAP/daVinci
drivers are using this to request channels - they need to support DT and
legacy mode.

But it is doable to do this for both the non _compat and _compat version:
1. change all users to check IS_ERR_OR_NULL(chan)
 return the PTR_ERR if not NULL, or do whatever the driver was doing in case
of chan =3D=3D NULL.
2. change the non _compat and _compat versions to do the same as the _reason
variants, #define the _reason ones to the non _reason names
3. Rename the _reason use to non _reason function in drivers
4. Remove the #defines for the _reason functions
5. Change the IS_ERR_OR_NULL(chan) to IS_ERR(chan) in all drivers
The result:
Both dma_request_slave_channel() and dma_request_slave_channel_compat() will
return ERR_PTR in case of failure or in success they will return the pinter=
 to
chan.

Is this what you were asking?
It is a bit broader than what this series was doing: taking care of
OMAP/daVinci drivers for deferred probing regarding to dmaengine ;)

-- =

P=E9ter
