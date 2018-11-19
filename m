Return-Path: <SRS0=9Ofa=N6=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from a9-99.smtp-out.amazonses.com ([54.240.9.99]:47942 "EHLO
        a9-99.smtp-out.amazonses.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725987AbeKTFoF (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 20 Nov 2018 00:44:05 -0500
Date: Mon, 19 Nov 2018 19:19:04 +0000
From: Christopher Lameter <cl@linux.com>
To: Jerome Glisse <jglisse@redhat.com>
cc: Jason Gunthorpe <jgg@ziepe.ca>, Leon Romanovsky <leon@kernel.org>,
        Kenneth Lee <liguozhu@hisilicon.com>,
        Tim Sell <timothy.sell@unisys.com>, linux-doc@vger.kernel.org,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Zaibo Xu <xuzaibo@huawei.com>, zhangfei.gao@foxmail.com,
        linuxarm@huawei.com, haojian.zhuang@linaro.org,
        Hao Fang <fanghao11@huawei.com>,
        Gavin Schenk <g.schenk@eckelmann.de>,
        RDMA mailing list <linux-rdma@vger.kernel.org>,
        Zhou Wang <wangzhou1@hisilicon.com>,
        Doug Ledford <dledford@redhat.com>,
        =?ISO-8859-15?Q?Uwe_Kleine-K=F6nig?=
        <u.kleine-koenig@pengutronix.de>,
        David Kershner <david.kershner@unisys.com>,
        Kenneth Lee <nek.in.cn@gmail.com>,
        Johan Hovold <johan@kernel.org>,
        Cyrille Pitchen <cyrille.pitchen@free-electrons.com>,
        Sagar Dharia <sdharia@codeaurora.org>,
        Jens Axboe <axboe@kernel.dk>, guodong.xu@linaro.org,
        linux-netdev <netdev@vger.kernel.org>,
        Randy Dunlap <rdunlap@infradead.org>,
        linux-kernel@vger.kernel.org, Vinod Koul <vkoul@kernel.org>,
        linux-crypto@vger.kernel.org,
        Philippe Ombredanne <pombredanne@nexb.com>,
        Sanyog Kale <sanyog.r.kale@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        linux-accelerators@lists.ozlabs.org
Subject: Re: [RFCv3 PATCH 1/6] uacce: Add documents for WarpDrive/uacce
In-Reply-To: <20181119184215.GB4593@redhat.com>
Message-ID: <010001672d69716a-743e5098-eb2f-41ca-bf98-6e17eaaba00f-000000@email.amazonses.com>
References: <20181113002354.GO3695@mtr-leonro.mtl.com> <95310df4-b32c-42f0-c750-3ad5eb89b3dd@gmail.com> <20181114160017.GI3759@mtr-leonro.mtl.com> <20181115085109.GD157308@Turing-Arch-b> <20181115145455.GN3759@mtr-leonro.mtl.com> <20181119091405.GE157308@Turing-Arch-b>
 <20181119091910.GF157308@Turing-Arch-b> <20181119104801.GF8268@mtr-leonro.mtl.com> <20181119164853.GA4593@redhat.com> <20181119182752.GA4890@ziepe.ca> <20181119184215.GB4593@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, 19 Nov 2018, Jerome Glisse wrote:

> > IIRC this is solved in IB by automatically calling
> > madvise(MADV_DONTFORK) before creating the MR.
> >
> > MADV_DONTFORK
> >   .. This is useful to prevent copy-on-write semantics from changing the
> >   physical location of a page if the parent writes to it after a
> >   fork(2) ..
>
> This would work around the issue but this is not transparent ie
> range marked with DONTFORK no longer behave as expected from the
> application point of view.

Why would anyone expect a range registered via MR behave as normal? Device
I/O is going on into that range. Memory is already special.


> Also it relies on userspace doing the right thing (which is not
> something i usualy trust :)).

This has been established practice for 15 or so years in a couple of use
cases. Again user space already has to be doing special things in order to
handle RDMA is that area.
