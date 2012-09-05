From: Dan Williams <djbw@fb.com>
Subject: Re: [PATCH v7 1/8] Talitos: Support for async_tx XOR offload
Date: Tue, 4 Sep 2012 18:19:45 -0700
Message-ID: <CAA9_cmfT1R2+r9_8g0giMJz+wvrNce6T6GPDpvUTtcA-UyAZNQ@mail.gmail.com>
References: <1344500448-10927-1-git-send-email-qiang.liu@freescale.com>
	<CAA9_cmdqmuhAcaqfkjvKSpsTL350BAJcY8pn6U=SJ9Nok1-XuA@mail.gmail.com>
	<BCB48C05FCE8BC4D9E61E841ECBE6DB70FFB67@039-SN2MPN1-011.039d.mgd.msft.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	"herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
	"davem@davemloft.net" <davem@davemloft.net>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
	Li Yang-R58472 <r58472@freescale.com>,
	Phillips Kim-R1AAHA <R1AAHA@freescale.com>,
	"vinod.koul@intel.com" <vinod.koul@intel.com>,
	"arnd@arndb.de" <arnd@arndb.de>,
	"gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
	Dave Jiang <dave.jiang@gmail.com>
To: Liu Qiang-B32616 <B32616@freescale.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <BCB48C05FCE8BC4D9E61E841ECBE6DB70FFB67@039-SN2MPN1-011.039d.mgd.msft.net>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Tue, Sep 4, 2012 at 5:28 AM, Liu Qiang-B32616 <B32616@freescale.com> wrote:
>> Will this engine be coordinating with another to handle memory copies?
>>  The dma mapping code for async_tx/raid is broken when dma mapping
>> requests overlap or cross dma device boundaries [1].
>>
>> [1]: http://marc.info/?l=linux-arm-kernel&m=129407269402930&w=2
> Yes, it needs fsl-dma to handle memcpy copies.
> I read your link, the unmap address is stored in talitos hwdesc, the address will be unmapped when async_tx ack this descriptor, I know fsl-dma won't wait this ack flag in current kernel, so I fix it in fsl-dma patch 5/8. Do you mean that?

Unfortunately no.  I'm open to other suggestions. but as far as I can
see it requires deeper changes to rip out the dma mapping that happens
in async_tx and the automatic unmapping done by drivers.  It should
all be pushed to the client (md).

Currently async_tx hides hardware details from md such that it doesn't
even care if the operation is offloaded to hardware at all, but that
takes things too far.  In the worst case an copy->xor chain handled by
multiple channels results in :

1/ dma_map(copy_chan...)
2/ dma_map(xor_chan...)
3/ <exec copy>
4/ dma_unmap(copy_chan...)
5/ <exec xor> <---initiated by the copy_chan
6/ dma_unmap(xor_chan...)

Step 2 violates the dma api since the buffers belong to the xor_chan
until unmap.  Step 5 also causes the random completion context of the
copy channel to bleed into submission context of the xor channel which
is problematic.  So the order needs to be:

1/ dma_map(copy_chan...)
2/ <exec copy>
3/ dma_unmap(copy_chan...)
4/ dma_map(xor_chan...)
5/ <exec xor> <--initiated by md in a static context
6/ dma_unmap(xor_chan...)

Also, if xor_chan and copy_chan lie with the same dma mapping domain
(iommu or parent device) then we can map the stripe once and skip the
extra maintenance for the duration of the chain of operations.  This
dumps a lot of hardware details on md, but I think it is the only way
to get consistent semantics when arbitrary offload devices are
involved.

--
Dan
