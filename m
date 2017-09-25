From: Casey Leedom <leedom@chelsio.com>
Subject: Re: DMA error when sg->offset value is greater than PAGE_SIZE in
 Intel IOMMU
Date: Mon, 25 Sep 2017 20:19:21 +0000
Message-ID: <MWHPR12MB16002A374CBB41BB201BA061C87A0@MWHPR12MB1600.namprd12.prod.outlook.com>
References: <20170920080151.GA3348@gondor.apana.org.au>,<1506365131.5294.37.camel@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Cc: "joro@8bytes.org" <joro@8bytes.org>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Michael Werner <werner@chelsio.com>
To: David Woodhouse <dwmw2@infradead.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "Harsh Jain" <Harsh@chelsio.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-by2nam01on0121.outbound.protection.outlook.com ([104.47.34.121]:52670
        "EHLO NAM01-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S966091AbdIYUTX (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 25 Sep 2017 16:19:23 -0400
In-Reply-To: <1506365131.5294.37.camel@infradead.org>
Content-Language: en-US
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

| From: David Woodhouse <dwmw2@infradead.org>
| Sent: Monday, September 25, 2017 11:45 AM
|
| On Wed, 2017-09-20 at 16:01 +0800, Herbert Xu wrote:
| > Harsh Jain <Harsh@chelsio.com> wrote:
| > >
| > > While debugging DMA mapping error in chelsio crypto driver we
| > observed that when scatter/gather list received by driver has some
| > entry with page->offset > 4096 (PAGE_SIZE). It starts giving DMA
| > error.  Without IOMMU it works fine.
| >
| > This is not a bug.  The network stack can and will feed us such
| > SG lists.
|
| Hm? Under what circumstances is the offset permitted to be >
| PAGE_SIZE?

  As I noted earlier, this is an area of the kernel with which I'm not supe=
r
familiar.  Both Herbert Xu and our local VM Expert have said that having
Scatter/Gather Lists with Offsets greater than Page Size is not a bug ...

  I'm mostly trying to help out keeping focus on this because Harsh is in
India (presumable enjoying a good night's sleep while we look at this.
Hopefully we'll have a present of a bug fix for him when he wakes up ... :-=
)

Casey
