From: Cornelia Huck <cornelia.huck@de.ibm.com>
Subject: Re: [virtio-dev] Re: [PATCH v3] crypto: add virtio-crypto driver
Date: Tue, 29 Nov 2016 10:44:06 +0100
Message-ID: <20161129104406.6c110ae0.cornelia.huck@de.ibm.com>
References: <1480334903-6672-1-git-send-email-arei.gonglei@huawei.com>
        <1480334903-6672-2-git-send-email-arei.gonglei@huawei.com>
        <20161128141244.4defcfa1.cornelia.huck@de.ibm.com>
        <33183CC9F5247A488A2544077AF19020DA14A53D@DGGEMA505-MBX.china.huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
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
To: "Gonglei (Arei)" <arei.gonglei@huawei.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:53865 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751063AbcK2JoT (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 29 Nov 2016 04:44:19 -0500
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.17/8.16.0.17) with SMTP id uAT9iBbV085759
        for <linux-crypto@vger.kernel.org>; Tue, 29 Nov 2016 04:44:19 -0500
Received: from e06smtp13.uk.ibm.com (e06smtp13.uk.ibm.com [195.75.94.109])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2711wp58n5-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-crypto@vger.kernel.org>; Tue, 29 Nov 2016 04:44:18 -0500
Received: from localhost
        by e06smtp13.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-crypto@vger.kernel.org> from <cornelia.huck@de.ibm.com>;
        Tue, 29 Nov 2016 09:44:15 -0000
In-Reply-To: <33183CC9F5247A488A2544077AF19020DA14A53D@DGGEMA505-MBX.china.huawei.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, 29 Nov 2016 01:37:44 +0000
"Gonglei (Arei)" <arei.gonglei@huawei.com> wrote:

> > On Mon, 28 Nov 2016 20:08:23 +0800
> > Gonglei <arei.gonglei@huawei.com> wrote:
> > 
> > > +static int virtcrypto_update_status(struct virtio_crypto *vcrypto)
> > > +{
> > > +	u32 status;
> > > +	int err;
> > > +
> > > +	virtio_cread(vcrypto->vdev,
> > > +	    struct virtio_crypto_config, status, &status);
> > > +
> > > +	/* Ignore unknown (future) status bits */
> > > +	status &= VIRTIO_CRYPTO_S_HW_READY;
> > 
> > I'm wondering what the driver really should do if it encounters unknown
> > status bits.
> > 
> > I'd expect that new status bits are guarded by a feature bit and that
> > the device should not set status bits if the respective feature bit has
> > not been negotiated. Therefore, unknown status bits would be a host
> > error and the driver should consider the device to be broken.
> > 
> > Thoughts?
> > 
> I agree with you. 
> 
> The reasonable way is reset the device if the driver
> receive an unknown status IMO.

What about setting FAILED in the generic virtio status? This indicates
to the host that the driver 'has given up on the device', as the spec
puts it. If the driver simply resets it, chances are that we will end
up in the same situation again (after all, that's a host bug).

Or/additionally use virtio_break_device(), as a quick grep revealed
that qemu, for one, does not do anything with FAILED. That way at least
the driver will stop mucking with the device.
