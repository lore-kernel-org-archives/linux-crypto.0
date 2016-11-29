From: "Gonglei (Arei)" <arei.gonglei@huawei.com>
Subject: RE: [PATCH v3] crypto: add virtio-crypto driver
Date: Tue, 29 Nov 2016 06:47:52 +0000
Message-ID: <33183CC9F5247A488A2544077AF19020DA14A720@DGGEMA505-MBX.china.huawei.com>
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
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from dggrg03-dlp ([45.249.212.189]:2427 "EHLO dggrg03-dlp.huawei.com"
        rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
        id S1754300AbcK2GsY (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 29 Nov 2016 01:48:24 -0500
Content-Language: zh-CN
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

>
> > > > +
> > > > +/* Note: kernel crypto API realization */
> > > > +static int virtio_crypto_ablkcipher_setkey(struct crypto_ablkcipher *tfm,
> > > > +					 const uint8_t *key,
> > > > +					 unsigned int keylen)
> > > > +{
> > > > +	struct virtio_crypto_ablkcipher_ctx *ctx =
> > crypto_ablkcipher_ctx(tfm);
> > > > +	int ret;
> > > > +
> > > > +	spin_lock(&ctx->lock);
> > > > +
> > > > +	if (!ctx->vcrypto) {
> > > > +		/* New key */
> > > > +		int node = virtio_crypto_get_current_node();
> > > > +		struct virtio_crypto *vcrypto =
> > > > +				      virtcrypto_get_dev_node(node);
> > > > +		if (!vcrypto) {
> > > > +			vcrypto = virtcrypto_devmgr_get_first();
> >
> > Is this the standard way to do this? How does this work with
> > multiple crypto devices (e.g. with different capabilities)?
> >
> Actually there is a simple schedule algorithms in virtcrypto_get_dev_node(),
> which return the device used fewest on the node.
> 
> If we don't find a device in the node, select the first on as default.
> But I forgot to check the first devices whether the device has started here.
> 
Oh, the virtcrypto_get_dev_node() had done this work, the calling of
virtcrypto_devmgr_get_first() here is superfluous. Will remove it.

Regards,
-Gonglei
