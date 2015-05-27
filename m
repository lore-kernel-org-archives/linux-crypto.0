From: Peter Ujfalusi <peter.ujfalusi@ti.com>
Subject: Re: [PATCH 11/13] spi: omap2-mcspi: Support for deferred probing
 when requesting DMA channels
Date: Wed, 27 May 2015 14:15:12 +0300
Message-ID: <5565A740.2020707@ti.com>
References: <1432646768-12532-1-git-send-email-peter.ujfalusi@ti.com> <1432646768-12532-12-git-send-email-peter.ujfalusi@ti.com> <20150526152730.GT21577@sirena.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: <vinod.koul@intel.com>, <tony@atomide.com>,
	<devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<dan.j.williams@intel.com>, <dmaengine@vger.kernel.org>,
	<linux-serial@vger.kernel.org>, <linux-omap@vger.kernel.org>,
	<linux-mmc@vger.kernel.org>, <linux-crypto@vger.kernel.org>,
	<linux-spi@vger.kernel.org>, <linux-media@vger.kernel.org>,
	<alsa-devel@alsa-project.org>
To: Mark Brown <broonie@kernel.org>
Return-path: <linux-mmc-owner@vger.kernel.org>
In-Reply-To: <20150526152730.GT21577@sirena.org.uk>
Sender: linux-mmc-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Mark,

On 05/26/2015 06:27 PM, Mark Brown wrote:
> On Tue, May 26, 2015 at 04:26:06PM +0300, Peter Ujfalusi wrote:
>=20
>> Switch to use ma_request_slave_channel_compat_reason() to request th=
e DMA
>> channels. Only fall back to pio mode if the error code returned is n=
ot
>> -EPROBE_DEFER, otherwise return from the probe with the -EPROBE_DEFE=
R.
>=20
> I've got two patches from a patch series here with no cover letter...
> I'm guessing there's no interdependencies or anything?  Please always
> ensure that when sending a patch series everyone getting the patches =
can
> tell what the series as a whole looks like (if there's no dependencie=
s
> consider posting as individual patches rather than a series).

I have put the maintainers of the relevant subsystems as CC in the comm=
it
message and sent the series to all of the mailing lists. This series wa=
s
touching 7 subsystems and I thought not spamming every maintainer with =
all the
mails might be better.

In v2 I will keep this in mind.

The series depends on the first two patch, which adds the
dma_request_slave_channel_compat_reason() function.

--=20
P=E9ter
