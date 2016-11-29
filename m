From: Cornelia Huck <cornelia.huck@de.ibm.com>
Subject: Re: [PATCH v3] crypto: add virtio-crypto driver
Date: Tue, 29 Nov 2016 10:29:35 +0100
Message-ID: <20161129102935.405892bd.cornelia.huck@de.ibm.com>
References: <1480334903-6672-1-git-send-email-arei.gonglei@huawei.com>
	<1480334903-6672-2-git-send-email-arei.gonglei@huawei.com>
	<20161128162055.GB11196@stefanha-x1.localdomain>
	<20161128185747-mutt-send-email-mst@kernel.org>
	<33183CC9F5247A488A2544077AF19020DA14A7A9@DGGEMA505-MBX.china.huawei.com>
	<20161129092549.GC5152@stefanha-x1.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: "Gonglei (Arei)" <arei.gonglei@huawei.com>,
        "Michael S. Tsirkin"
 <mst@redhat.com>,
        "linux-kernel@vger.kernel.org"
 <linux-kernel@vger.kernel.org>,
        "qemu-devel@nongnu.org"
 <qemu-devel@nongnu.org>,
        "virtio-dev@lists.oasis-open.org"
 <virtio-dev@lists.oasis-open.org>,
        "virtualization@lists.linux-foundation.org"
 <virtualization@lists.linux-foundation.org>,
        "linux-crypto@vger.kernel.org"
 <linux-crypto@vger.kernel.org>,
        Luonengjun <luonengjun@huawei.com>,
        "Huangweidong (C)" <weidong.huang@huawei.com>,
        "Wubin (H)"
 <wu.wubin@huawei.com>,
        "xin.zeng@intel.com" <xin.zeng@intel.com>,
        Claudio
 Fontana <Claudio.Fontana@huawei.com>,
        "herbert@gondor.apana.org.au"
 <herbert@gondor.apana.org.au>,
        "pasic@linux.vnet.ibm.com"
 <pasic@linux.vnet.ibm.com>,
        "davem@davemloft.net" <davem@daveml
To: Stefan Hajnoczi <stefanha@redhat.com>
Return-path: <virtio-dev-return-1736-gcvd-virtio-dev=m.gmane.org@lists.oasis-open.org>
Sender: <virtio-dev@lists.oasis-open.org>
List-Post: <mailto:virtio-dev@lists.oasis-open.org>
List-Help: <mailto:virtio-dev-help@lists.oasis-open.org>
List-Unsubscribe: <mailto:virtio-dev-unsubscribe@lists.oasis-open.org>
List-Subscribe: <mailto:virtio-dev-subscribe@lists.oasis-open.org>
In-Reply-To: <20161129092549.GC5152@stefanha-x1.localdomain>
List-Id: linux-crypto.vger.kernel.org

On Tue, 29 Nov 2016 09:25:49 +0000
Stefan Hajnoczi <stefanha@redhat.com> wrote:

> On Tue, Nov 29, 2016 at 08:22:58AM +0000, Gonglei (Arei) wrote:
> > Hi,
> > 
> > > > > > +source "drivers/crypto/virtio/Kconfig"
> > > > > > +
> > > > > >  endif # CRYPTO_HW
> > > > > > diff --git a/drivers/crypto/Makefile b/drivers/crypto/Makefile
> > > > > > index ad7250f..bc53cb8 100644
> > > > > > --- a/drivers/crypto/Makefile
> > > > > > +++ b/drivers/crypto/Makefile
> > > > > > @@ -32,3 +32,4 @@ obj-$(CONFIG_CRYPTO_DEV_VMX) += vmx/
> > > > > >  obj-$(CONFIG_CRYPTO_DEV_SUN4I_SS) += sunxi-ss/
> > > > > >  obj-$(CONFIG_CRYPTO_DEV_ROCKCHIP) += rockchip/
> > > > > >  obj-$(CONFIG_CRYPTO_DEV_CHELSIO) += chelsio/
> > > > > > +obj-$(CONFIG_CRYPTO_DEV_VIRTIO) += virtio/
> > > > > > diff --git a/drivers/crypto/virtio/Kconfig b/drivers/crypto/virtio/Kconfig
> > > > > > new file mode 100644
> > > > > > index 0000000..ceae88c
> > > > > > --- /dev/null
> > > > > > +++ b/drivers/crypto/virtio/Kconfig
> > > > > > @@ -0,0 +1,10 @@
> > > > > > +config CRYPTO_DEV_VIRTIO
> > > > > > +	tristate "VirtIO crypto driver"
> > > > > > +	depends on VIRTIO
> > > > > > +    select CRYPTO_AEAD
> > > > > > +    select CRYPTO_AUTHENC
> > > > > > +    select CRYPTO_BLKCIPHER
> > > > >
> > > > > Inconsistent tab vs space whitespace usage.
> > > > >
> > > Will fix.
> > > 
> > > > > > +	default m
> > > > > > +	help
> > > > > > +	  This driver provides support for virtio crypto device. If you
> > > > > > +	  choose 'M' here, this module will be called virtio-crypto.
> > > > >
> > > > > All the other virtio drivers use underscore ('_') instead of hyphen
> > > > > ('-').
> > > >
> > > > Except virtio-rng.
> > > >
> > > > >  I suggest calling it virtio_crypto for consistency.
> > > > >
> > > OK, I will change the Makefile to fix it.
> > > 
> > 
> > I tried to do this, but I failed. Because virtio_crypto.ko
> > consists of more than one source file which include tree files currently,
> > and virtio_crypto.ko matchs the name of virtio_crypto.c.
> > That's different with all other virtio drivers.
> 
> Can you rename virtio_crypto.c to virtio_crypto_core.c?

+1

I think that's the way to go.
