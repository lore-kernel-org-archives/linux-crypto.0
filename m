From: "Gonglei (Arei)" <arei.gonglei@huawei.com>
Subject: RE: [virtio-dev] Re: [PATCH v3] crypto: add virtio-crypto driver
Date: Tue, 29 Nov 2016 01:37:44 +0000
Message-ID: <33183CC9F5247A488A2544077AF19020DA14A53D@DGGEMA505-MBX.china.huawei.com>
References: <1480334903-6672-1-git-send-email-arei.gonglei@huawei.com>
        <1480334903-6672-2-git-send-email-arei.gonglei@huawei.com>
 <20161128141244.4defcfa1.cornelia.huck@de.ibm.com>
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
        "mst@redhat.com" <mst@redhat.com>,
        "stefanha@redhat.com" <stefanha@redhat.com>,
        "Huangweidong (C)" <weidong.huang@huawei.com>,
        "Wubin (H)" <wu.wubin@huawei.com>,
        "xin.zeng@intel.com" <xin.zeng@intel.com>,
        Claudio Fontana <Claudio.Fontana@huawei.com>,
        "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
        "pasic@linux.vnet.ibm.com" <pasic@linux.vnet.ibm.com>,
        "davem@davemloft.net" <davem@davemloft.
To: Cornelia Huck <cornelia.huck@de.ibm.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20161128141244.4defcfa1.cornelia.huck@de.ibm.com>
Content-Language: zh-CN
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

>
> Subject: [virtio-dev] Re: [PATCH v3] crypto: add virtio-crypto driver
> 
> On Mon, 28 Nov 2016 20:08:23 +0800
> Gonglei <arei.gonglei@huawei.com> wrote:
> 
> > +static int virtcrypto_update_status(struct virtio_crypto *vcrypto)
> > +{
> > +	u32 status;
> > +	int err;
> > +
> > +	virtio_cread(vcrypto->vdev,
> > +	    struct virtio_crypto_config, status, &status);
> > +
> > +	/* Ignore unknown (future) status bits */
> > +	status &= VIRTIO_CRYPTO_S_HW_READY;
> 
> I'm wondering what the driver really should do if it encounters unknown
> status bits.
> 
> I'd expect that new status bits are guarded by a feature bit and that
> the device should not set status bits if the respective feature bit has
> not been negotiated. Therefore, unknown status bits would be a host
> error and the driver should consider the device to be broken.
> 
> Thoughts?
> 
I agree with you. 

The reasonable way is reset the device if the driver
receive an unknown status IMO.

Regards,
-Gonglei

> > +
> > +	if (vcrypto->status == status)
> > +		return 0;
> > +
> > +	vcrypto->status = status;
> > +
> > +	if (vcrypto->status & VIRTIO_CRYPTO_S_HW_READY) {
> > +		err = virtcrypto_dev_start(vcrypto);
> > +		if (err) {
> > +			dev_err(&vcrypto->vdev->dev,
> > +				"Failed to start virtio crypto device.\n");
> > +			virtcrypto_dev_stop(vcrypto);
> > +			return -EPERM;
> > +		}
> > +		dev_info(&vcrypto->vdev->dev, "Accelerator is ready\n");
> > +	} else {
> > +		virtcrypto_dev_stop(vcrypto);
> > +		dev_info(&vcrypto->vdev->dev, "Accelerator is not ready\n");
> > +	}
> > +
> > +	return 0;
> > +}
> > +
> 
> 
> ---------------------------------------------------------------------
> To unsubscribe, e-mail: virtio-dev-unsubscribe@lists.oasis-open.org
> For additional commands, e-mail: virtio-dev-help@lists.oasis-open.org
