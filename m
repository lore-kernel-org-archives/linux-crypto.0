From: "Gonglei (Arei)" <arei.gonglei@huawei.com>
Subject: RE: [virtio-dev] Re: [PATCH v3] crypto: add virtio-crypto driver
Date: Tue, 29 Nov 2016 11:50:31 +0000
Message-ID: <33183CC9F5247A488A2544077AF19020DA14AA1C@DGGEMA505-MBX.china.huawei.com>
References: <1480334903-6672-1-git-send-email-arei.gonglei@huawei.com>
        <1480334903-6672-2-git-send-email-arei.gonglei@huawei.com>
        <20161128141244.4defcfa1.cornelia.huck@de.ibm.com>
        <33183CC9F5247A488A2544077AF19020DA14A53D@DGGEMA505-MBX.china.huawei.com>
 <20161129104406.6c110ae0.cornelia.huck@de.ibm.com>
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
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from dggrg01-dlp ([45.249.212.187]:2300 "EHLO dggrg01-dlp.huawei.com"
        rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
        id S1756116AbcK2LvH (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 29 Nov 2016 06:51:07 -0500
In-Reply-To: <20161129104406.6c110ae0.cornelia.huck@de.ibm.com>
Content-Language: zh-CN
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

>
> Subject: Re: [virtio-dev] Re: [PATCH v3] crypto: add virtio-crypto driver
> 
> On Tue, 29 Nov 2016 01:37:44 +0000
> "Gonglei (Arei)" <arei.gonglei@huawei.com> wrote:
> 
> > > On Mon, 28 Nov 2016 20:08:23 +0800
> > > Gonglei <arei.gonglei@huawei.com> wrote:
> > >
> > > > +static int virtcrypto_update_status(struct virtio_crypto *vcrypto)
> > > > +{
> > > > +	u32 status;
> > > > +	int err;
> > > > +
> > > > +	virtio_cread(vcrypto->vdev,
> > > > +	    struct virtio_crypto_config, status, &status);
> > > > +
> > > > +	/* Ignore unknown (future) status bits */
> > > > +	status &= VIRTIO_CRYPTO_S_HW_READY;
> > >
> > > I'm wondering what the driver really should do if it encounters unknown
> > > status bits.
> > >
> > > I'd expect that new status bits are guarded by a feature bit and that
> > > the device should not set status bits if the respective feature bit has
> > > not been negotiated. Therefore, unknown status bits would be a host
> > > error and the driver should consider the device to be broken.
> > >
> > > Thoughts?
> > >
> > I agree with you.
> >
> > The reasonable way is reset the device if the driver
> > receive an unknown status IMO.
> 
> What about setting FAILED in the generic virtio status? This indicates
> to the host that the driver 'has given up on the device', as the spec
> puts it. If the driver simply resets it, chances are that we will end
> up in the same situation again (after all, that's a host bug).
> 
> Or/additionally use virtio_break_device(), as a quick grep revealed
> that qemu, for one, does not do anything with FAILED. That way at least
> the driver will stop mucking with the device.
> 
I prefer to the second way. The device set the incorrect status,
then the driver prevent the device from being used and print some
error message to notice that.

Patch will go.

Regards,
-Gonglei
> 
> ---------------------------------------------------------------------
> To unsubscribe, e-mail: virtio-dev-unsubscribe@lists.oasis-open.org
> For additional commands, e-mail: virtio-dev-help@lists.oasis-open.org
