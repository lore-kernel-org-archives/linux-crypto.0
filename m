From: "Gonglei (Arei)" <arei.gonglei@huawei.com>
Subject: RE: [PATCH v3] crypto: add virtio-crypto driver
Date: Tue, 29 Nov 2016 08:22:58 +0000
Message-ID: <33183CC9F5247A488A2544077AF19020DA14A7A9@DGGEMA505-MBX.china.huawei.com>
References: <1480334903-6672-1-git-send-email-arei.gonglei@huawei.com>
 <1480334903-6672-2-git-send-email-arei.gonglei@huawei.com>
 <20161128162055.GB11196@stefanha-x1.localdomain>
 <20161128185747-mutt-send-email-mst@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "qemu-devel@nongnu.org" <qemu-devel@nongnu.org>,
        "virtio-dev@lists.oasis-open.org" <virtio-dev@lists.oasis-open.org>,
        "virtualization@lists.linux-foundation.org"
        <virtualization@lists.linux-foundation.org>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        Luonengjun <luonengjun@huawei.com>,
        "Huangweidong (C)" <weidong.huang@huawei.com>,
        "Wubin (H)" <wu.wubin@huawei.com>,
        "xin.zeng@intel.com" <xin.zeng@intel.com>,
        "Claudio Fontana" <Claudio.Fontana@huawei.com>,
        "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
        "pasic@linux.vnet.ibm.com" <pasic@linux.vnet.ibm.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "Zhoujian (jay, Euler)" <jianjay.zhou@huawei.com>,
        "Hanweidong (Randy)"
To: "Gonglei (Arei)" <arei.gonglei@huawei.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Language: zh-CN
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Hi,

> > > > +source "drivers/crypto/virtio/Kconfig"
> > > > +
> > > >  endif # CRYPTO_HW
> > > > diff --git a/drivers/crypto/Makefile b/drivers/crypto/Makefile
> > > > index ad7250f..bc53cb8 100644
> > > > --- a/drivers/crypto/Makefile
> > > > +++ b/drivers/crypto/Makefile
> > > > @@ -32,3 +32,4 @@ obj-$(CONFIG_CRYPTO_DEV_VMX) += vmx/
> > > >  obj-$(CONFIG_CRYPTO_DEV_SUN4I_SS) += sunxi-ss/
> > > >  obj-$(CONFIG_CRYPTO_DEV_ROCKCHIP) += rockchip/
> > > >  obj-$(CONFIG_CRYPTO_DEV_CHELSIO) += chelsio/
> > > > +obj-$(CONFIG_CRYPTO_DEV_VIRTIO) += virtio/
> > > > diff --git a/drivers/crypto/virtio/Kconfig b/drivers/crypto/virtio/Kconfig
> > > > new file mode 100644
> > > > index 0000000..ceae88c
> > > > --- /dev/null
> > > > +++ b/drivers/crypto/virtio/Kconfig
> > > > @@ -0,0 +1,10 @@
> > > > +config CRYPTO_DEV_VIRTIO
> > > > +	tristate "VirtIO crypto driver"
> > > > +	depends on VIRTIO
> > > > +    select CRYPTO_AEAD
> > > > +    select CRYPTO_AUTHENC
> > > > +    select CRYPTO_BLKCIPHER
> > >
> > > Inconsistent tab vs space whitespace usage.
> > >
> Will fix.
> 
> > > > +	default m
> > > > +	help
> > > > +	  This driver provides support for virtio crypto device. If you
> > > > +	  choose 'M' here, this module will be called virtio-crypto.
> > >
> > > All the other virtio drivers use underscore ('_') instead of hyphen
> > > ('-').
> >
> > Except virtio-rng.
> >
> > >  I suggest calling it virtio_crypto for consistency.
> > >
> OK, I will change the Makefile to fix it.
> 

I tried to do this, but I failed. Because virtio_crypto.ko
consists of more than one source file which include tree files currently,
and virtio_crypto.ko matchs the name of virtio_crypto.c.
That's different with all other virtio drivers.

The Makefile can't address this situation well, I googled it, and I find a way in
 http://stackoverflow.com/questions/13606075/building-a-kernel-module-from-several-source-files-which-one-of-them-has-the-sam

 Proper way to fix in kernel make file would be as:

# 
obj-m += module.o

#append other source files except module.c which would be include by default
module-objs += src1.o src2.o

Unfortunately it doesn't work because virtio_crypto.c isn't compiled.

# insmod virtio_crypto.ko 
insmod: ERROR: could not insert module virtio_crypto.ko: Unknown symbol in module

# dmesg
[74339.311801] virtio_crypto: Unknown symbol virtqueue_is_broken (err 0)
[74339.311816] virtio_crypto: Unknown symbol crypto_register_algs (err 0)
[74339.311833] virtio_crypto: Unknown symbol virtqueue_add_sgs (err 0)
[74339.311839] virtio_crypto: Unknown symbol virtqueue_get_buf (err 0)
[74339.311844] virtio_crypto: Unknown symbol virtqueue_kick (err 0)
[74339.311854] virtio_crypto: Unknown symbol crypto_ablkcipher_type (err 0)
[74339.311860] virtio_crypto: Unknown symbol crypto_unregister_algs (err 0)

It seems that I have no choice but to name the module to 'virtio-crypto' for simplicity.

Regards,
-Gonglei
