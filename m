From: Cornelia Huck <cornelia.huck@de.ibm.com>
Subject: Re: [PATCH v3] crypto: add virtio-crypto driver
Date: Mon, 28 Nov 2016 14:12:44 +0100
Message-ID: <20161128141244.4defcfa1.cornelia.huck@de.ibm.com>
References: <1480334903-6672-1-git-send-email-arei.gonglei@huawei.com>
        <1480334903-6672-2-git-send-email-arei.gonglei@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: <linux-kernel@vger.kernel.org>, <qemu-devel@nongnu.org>,
        <virtio-dev@lists.oasis-open.org>,
        <virtualization@lists.linux-foundation.org>,
        <linux-crypto@vger.kernel.org>, <luonengjun@huawei.com>,
        <mst@redhat.com>, <stefanha@redhat.com>,
        <weidong.huang@huawei.com>, <wu.wubin@huawei.com>,
        <xin.zeng@intel.com>, <claudio.fontana@huawei.com>,
        <herbert@gondor.apana.org.au>, <pasic@linux.vnet.ibm.com>,
        <davem@davemloft.net>, <jianjay.zhou@huawei.com>,
        <hanweidong@huawei.com>, <arei.gonglei@hotmail.com>,
        <xuquan8@huawei.com>, <longpeng2@huawei.com>,
        <salvatore.benedetto@intel.com>
To: Gonglei <arei.gonglei@huawei.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:36874 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1754466AbcK1NMz (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 28 Nov 2016 08:12:55 -0500
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.17/8.16.0.17) with SMTP id uASD9vWD143291
        for <linux-crypto@vger.kernel.org>; Mon, 28 Nov 2016 08:12:54 -0500
Received: from e06smtp08.uk.ibm.com (e06smtp08.uk.ibm.com [195.75.94.104])
        by mx0b-001b2d01.pphosted.com with ESMTP id 270mg6ve02-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-crypto@vger.kernel.org>; Mon, 28 Nov 2016 08:12:54 -0500
Received: from localhost
        by e06smtp08.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-crypto@vger.kernel.org> from <cornelia.huck@de.ibm.com>;
        Mon, 28 Nov 2016 13:12:52 -0000
In-Reply-To: <1480334903-6672-2-git-send-email-arei.gonglei@huawei.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, 28 Nov 2016 20:08:23 +0800
Gonglei <arei.gonglei@huawei.com> wrote:

> +static int virtcrypto_update_status(struct virtio_crypto *vcrypto)
> +{
> +	u32 status;
> +	int err;
> +
> +	virtio_cread(vcrypto->vdev,
> +	    struct virtio_crypto_config, status, &status);
> +
> +	/* Ignore unknown (future) status bits */
> +	status &= VIRTIO_CRYPTO_S_HW_READY;

I'm wondering what the driver really should do if it encounters unknown
status bits.

I'd expect that new status bits are guarded by a feature bit and that
the device should not set status bits if the respective feature bit has
not been negotiated. Therefore, unknown status bits would be a host
error and the driver should consider the device to be broken.

Thoughts?

> +
> +	if (vcrypto->status == status)
> +		return 0;
> +
> +	vcrypto->status = status;
> +
> +	if (vcrypto->status & VIRTIO_CRYPTO_S_HW_READY) {
> +		err = virtcrypto_dev_start(vcrypto);
> +		if (err) {
> +			dev_err(&vcrypto->vdev->dev,
> +				"Failed to start virtio crypto device.\n");
> +			virtcrypto_dev_stop(vcrypto);
> +			return -EPERM;
> +		}
> +		dev_info(&vcrypto->vdev->dev, "Accelerator is ready\n");
> +	} else {
> +		virtcrypto_dev_stop(vcrypto);
> +		dev_info(&vcrypto->vdev->dev, "Accelerator is not ready\n");
> +	}
> +
> +	return 0;
> +}
> +
