From: "Michael S. Tsirkin" <mst@redhat.com>
Subject: Re: [PATCH v6 2/2] crypto: add virtio-crypto driver
Date: Tue, 13 Dec 2016 00:05:19 +0200
Message-ID: <20161212234941-mutt-send-email-mst@kernel.org>
References: <1481171829-116496-1-git-send-email-arei.gonglei@huawei.com>
 <1481171829-116496-3-git-send-email-arei.gonglei@huawei.com>
 <33183CC9F5247A488A2544077AF19020DA15A07C@DGGEMA505-MBX.china.huawei.com>
 <20161212105407.GA3033@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "Gonglei (Arei)" <arei.gonglei@huawei.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "qemu-devel@nongnu.org" <qemu-devel@nongnu.org>,
        "virtio-dev@lists.oasis-open.org" <virtio-dev@lists.oasis-open.org>,
        "virtualization@lists.linux-foundation.org"
        <virtualization@lists.linux-foundation.org>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        Luonengjun <luonengjun@huawei.com>,
        "stefanha@redhat.com" <stefanha@redhat.com>,
        "Huangweidong (C)" <weidong.huang@huawei.com>,
        "Wubin (H)" <wu.wubin@huawei.com>,
        "xin.zeng@intel.com" <xin.zeng@intel.com>,
        Claudio Fontana <Claudio.Fontana@huawei.com>,
        "pasic@linux.vnet.ibm.com" <pasic@linux.vnet.ibm.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "Zhoujian (jay, Euler)" <jianjay.zhou@huawei.c
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:38256 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932273AbcLLWFZ (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 12 Dec 2016 17:05:25 -0500
Content-Disposition: inline
In-Reply-To: <20161212105407.GA3033@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, Dec 12, 2016 at 06:54:07PM +0800, Herbert Xu wrote:
> On Mon, Dec 12, 2016 at 06:25:12AM +0000, Gonglei (Arei) wrote:
> > Hi, Michael & Herbert
> > 
> > Because the virtio-crypto device emulation had been in QEMU 2.8,
> > would you please merge the virtio-crypto driver for 4.10 if no other
> > comments? If so, Miachel pls ack and/or review the patch, then
> > Herbert will take it (I asked him last week). Thank you!
> > 
> > Ps: Note on 4.10 merge window timing from Linus
> >  https://lkml.org/lkml/2016/12/7/506
> > 
> > Dec 23rd is the deadline for 4.10 merge window.
> 
> Sorry but it's too late for 4.10.  It needed to have been in my
> tree before the merge window opened to make it for this cycle.
> 
> Cheers,


Objections to me merging this? I'm preparing my tree right now.

> -- 
> Email: Herbert Xu <herbert@gondor.apana.org.au>
> Home Page: http://gondor.apana.org.au/~herbert/
> PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
