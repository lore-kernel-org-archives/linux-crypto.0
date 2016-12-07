From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v5 1/1] crypto: add virtio-crypto driver
Date: Wed, 7 Dec 2016 17:48:43 +0800
Message-ID: <20161207094843.GA19970@gondor.apana.org.au>
References: <1480595945-63656-1-git-send-email-arei.gonglei@huawei.com>
 <1480595945-63656-2-git-send-email-arei.gonglei@huawei.com>
 <33183CC9F5247A488A2544077AF19020DA1546F2@DGGEMA505-MBX.china.huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
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
        "pasic@linux.vnet.ibm.com" <pasic@linux.vnet.ibm.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "Zhoujian (jay, Euler)" <jianjay.zhou@huawei.com>,
To: "Gonglei (Arei)" <arei.gonglei@huawei.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <33183CC9F5247A488A2544077AF19020DA1546F2@DGGEMA505-MBX.china.huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Tue, Dec 06, 2016 at 09:01:49AM +0000, Gonglei (Arei) wrote:
> 
> Would you please review and/or ack the virtio_crypto_algs.c?
> It is the realization of specified algs based on Linux Crypto Framework.

I have no issues with it.  If the virtio folks are happy with
the interface with the host then I'll take this patch.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
