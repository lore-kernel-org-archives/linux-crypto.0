From: "Gonglei (Arei)" <arei.gonglei@huawei.com>
Subject: RE: [PATCH v5 1/1] crypto: add virtio-crypto driver
Date: Thu, 8 Dec 2016 02:00:19 +0000
Message-ID: <33183CC9F5247A488A2544077AF19020DA156A24@DGGEMA505-MBX.china.huawei.com>
References: <1480595945-63656-1-git-send-email-arei.gonglei@huawei.com>
 <1480595945-63656-2-git-send-email-arei.gonglei@huawei.com>
 <33183CC9F5247A488A2544077AF19020DA1546F2@DGGEMA505-MBX.china.huawei.com>
 <20161207094843.GA19970@gondor.apana.org.au>
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
        "pasic@linux.vnet.ibm.com" <pasic@linux.vnet.ibm.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "Zhoujian (jay, Euler)" <jianjay.zhou@huawei.com>,
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from dggrg01-dlp ([45.249.212.187]:2306 "EHLO dggrg01-dlp.huawei.com"
        rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
        id S933027AbcLHCAl (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 7 Dec 2016 21:00:41 -0500
In-Reply-To: <20161207094843.GA19970@gondor.apana.org.au>
Content-Language: zh-CN
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

>
> Subject: Re: [PATCH v5 1/1] crypto: add virtio-crypto driver
> 
> On Tue, Dec 06, 2016 at 09:01:49AM +0000, Gonglei (Arei) wrote:
> >
> > Would you please review and/or ack the virtio_crypto_algs.c?
> > It is the realization of specified algs based on Linux Crypto Framework.
> 
> I have no issues with it.  If the virtio folks are happy with
> the interface with the host then I'll take this patch.
> 
Cool, thanks!

Regards,
-Gonglei
