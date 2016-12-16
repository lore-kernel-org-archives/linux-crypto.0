From: "Gonglei (Arei)" <arei.gonglei@huawei.com>
Subject: RE: [virtio-dev] Re: [Qemu-devel] [PATCH v7 1/1] crypto: add
 virtio-crypto driver
Date: Fri, 16 Dec 2016 00:40:14 +0000
Message-ID: <33183CC9F5247A488A2544077AF19020DA166351@DGGEMA505-MBX.china.huawei.com>
References: <1481716249-185392-1-git-send-email-arei.gonglei@huawei.com>
 <1481716249-185392-2-git-send-email-arei.gonglei@huawei.com>
 <bcf62fa0-8fc9-daaf-ea7b-e09eb83b593a@linux.vnet.ibm.com>
 <33183CC9F5247A488A2544077AF19020DA163033@DGGEMA505-MBX.china.huawei.com>
 <82063967A54EF84C8AFCD6BD7F6AD93310C14374@SHSMSX103.ccr.corp.intel.com>
 <33183CC9F5247A488A2544077AF19020DA16320F@DGGEMA505-MBX.china.huawei.com>
 <20161215184153-mutt-send-email-mst@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Cc: "Zeng, Xin" <xin.zeng@intel.com>,
        Halil Pasic <pasic@linux.vnet.ibm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "qemu-devel@nongnu.org" <qemu-devel@nongnu.org>,
        "virtio-dev@lists.oasis-open.org" <virtio-dev@lists.oasis-open.org>,
        "virtualization@lists.linux-foundation.org"
        <virtualization@lists.linux-foundation.org>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "Huangweidong (C)" <weidong.huang@huawei.com>,
        Claudio Fontana <Claudio.Fontana@huawei.com>,
        Luonengjun <luonengjun@huawei.com>,
        "Hanweidong (Randy)" <hanweidong@huawei.com>,
        "Xuquan (Quan Xu)" <xuquan8@huawei.com>,
        "Wanzongshun (Vincent)" <wanzongshun@huawei.com>,
        "stefanha@redhat.com" <stefanha@redhat.com>,
        "Zhoujian (jay, Euler)" <jianjay.zhou@huawei.com>,
To: "Michael S. Tsirkin" <mst@redhat.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from dggrg03-dlp ([45.249.212.189]:2438 "EHLO dggrg03-dlp.huawei.com"
        rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752342AbcLPAlY (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 15 Dec 2016 19:41:24 -0500
In-Reply-To: <20161215184153-mutt-send-email-mst@kernel.org>
Content-Language: zh-CN
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Michael,

>
> >
> >
> > > Subject: RE: [Qemu-devel] [PATCH v7 1/1] crypto: add virtio-crypto driver
> > >
> > > On Thursday, December 15, 2016 8:45 AM, Gonglei (Arei) Wrote:
> > > < > > diff --git a/drivers/crypto/virtio/virtio_crypto_core.c
> > > < > b/drivers/crypto/virtio/virtio_crypto_core.c
> > > < > > new file mode 100644
> > > < > > index 0000000..c0854a1
> > > < > > --- /dev/null
> > > < > > +++ b/drivers/crypto/virtio/virtio_crypto_core.c
> > > < > > @@ -0,0 +1,474 @@
> > > < > [..]
> > > < > > +
> > > < > > +static void virtcrypto_dataq_callback(struct virtqueue *vq)
> > > < > > +{
> > > < > > +	struct virtio_crypto *vcrypto = vq->vdev->priv;
> > > < > > +	struct virtio_crypto_request *vc_req;
> > > < > > +	unsigned long flags;
> > > < > > +	unsigned int len;
> > > < > > +	struct ablkcipher_request *ablk_req;
> > > < > > +	int error;
> > > < > > +
> > > < > > +	spin_lock_irqsave(&vcrypto->lock, flags);
> > > < >
> > > < > Would it make sense to use a per virtqueue lock
> > > < > like in virtio_blk for example instead of locking on the whole
> > > < > device? OK, it seems you use only one dataqueue, so it
> > > < > may not be that relevant.
> > > < >
> > > < Currently yes, both the backend device (cryptodev-backend-builtin)
> > > < and the frontend driver use one dataqueue.
> > > <
> > >
> > > I think it makes sense to use per virtqueue lock here though it only uses one
> > > queue so far,
> > > but in the spec we already have multi queues support.
> > >
> > Yes, I agree. Will do that in V8 soon.
> > Hope to catch up with Michael's pull request for 4.10.
> >
> > Regards,
> > -Gonglei
> 
> I merged v7, this change will have to wait. Sorry.
> 
That's OK. Thanks!

I can post a separate patch after this pull request. 

Regards,
-Gonglei
