From: Rameshwar Sahu <rsahu@apm.com>
Subject: Re: [PATCH v2 0/3] dmaengine: Add supports for APM X-Gene SoC CRC32C
 accerlerator driver
Date: Mon, 30 Nov 2015 14:19:33 +0530
Message-ID: <CAFd313z2dncWmBQJY48RkReVOhQqLs13UzehwrbizBbputOSEw@mail.gmail.com>
References: <rsahu@apm.com>
	<1447665169-14003-1-git-send-email-rsahu@apm.com>
	<CAFd313zqimQtG8epeo3U7gzxWRf0hqO4K8hOFy4UK-6pG5GcJg@mail.gmail.com>
	<20151130083950.GA7792@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: davem@davemloft.net, Vinod Koul <vinod.koul@intel.com>,
	dan.j.williams@intel.com, dmaengine@vger.kernel.org,
	Arnd Bergmann <arnd@arndb.de>, linux-kernel@vger.kernel.org,
	devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	jcm@redhat.com, patches@apm.com, linux-crypto@vger.kernel.org,
	Kaustubh Gondkar <kgondkar@apm.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20151130083950.GA7792@gondor.apana.org.au>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Hi Herbert,

On Mon, Nov 30, 2015 at 2:09 PM, Herbert Xu <herbert@gondor.apana.org.au> wrote:
> On Mon, Nov 30, 2015 at 02:06:03PM +0530, Rameshwar Sahu wrote:
>> On Mon, Nov 16, 2015 at 2:42 PM,  <rsahu@apm.com> wrote:
>> > From: Rameshwar Prasad Sahu <rsahu@apm.com>
>> >
>> > This patch implements support for APM X-Gene SoC CRC32C h/w accelerator driver
>> > and adds CRC32C computations support in dmaengine framework. APM X-Gene SoC has
>> > DMA engine capable of performing CRC32C computations.
>> >
>> > v2 changes:
>> >         1. Added helper function in dmaengine framework
>> >         2. Documented CRC32C support in Documentations/dmaengine/provider.txt
>> >         3. Fixed algo name
>> >         4. Fixed coding style issues
>> >
>> > Signed-off-by: Rameshwar Prasad Sahu <rsahu@apm.com>
>> > ---
>> >
>> > Rameshwar Prasad Sahu (3):
>> >   dmaengine: Add support for new feature CRC32C computations
>> >   dmaengine: xgene-dma: Add support for CRC32C computations via DMA
>> >     engine
>> >   Crypto: Add support for APM X-Gene SoC CRC32C h/w accelerator driver
>> >
>> >  Documentation/dmaengine/provider.txt |    3 +
>> >  drivers/crypto/Kconfig               |    8 +
>> >  drivers/crypto/Makefile              |    1 +
>> >  drivers/crypto/xgene-crc32c.c        |  234 +++++++++++++++++++++++++
>> >  drivers/dma/dmaengine.c              |    2 +
>> >  drivers/dma/xgene-dma.c              |  314 ++++++++++++++++++++++++++++++++--
>> >  include/linux/dmaengine.h            |   13 ++
>> >  7 files changed, 560 insertions(+), 15 deletions(-)
>> >  create mode 100755 drivers/crypto/xgene-crc32c.c
>>
>> Any Comments on above patchset ??
>
> The main user of crc32c is lib/libcrc32c.c.  Unfortunately it is
> entire synchronous so it won't be able to use your crc32c driver
> at all.

This is asynchronous implementation of the crc32c, mainly for
offloading the computations, So client (who want to use it) can call
it as like other async crypto algos available in linux/crypto, so they
have frame the layer on top of this.
>
> So who is going to be using this?
One of our client is using this layer for offloading the crc32c to our
dmaengine hw.

>
> Cheers,
> --
> Email: Herbert Xu <herbert@gondor.apana.org.au>
> Home Page: http://gondor.apana.org.au/~herbert/
> PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
