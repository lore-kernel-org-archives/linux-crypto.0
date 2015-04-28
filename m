From: Sagi Grimberg <sagig@dev.mellanox.co.il>
Subject: Re: [PATCH v3 0/5] target: Fix several problems related to T10-PI
 support
Date: Tue, 28 Apr 2015 13:22:39 +0300
Message-ID: <553F5F6F.5040800@dev.mellanox.co.il>
References: <1429972410-7146-1-git-send-email-akinobu.mita@gmail.com>	<553CBF07.6080902@dev.mellanox.co.il> <yq1tww1uo4d.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Akinobu Mita <akinobu.mita@gmail.com>,
	target-devel@vger.kernel.org,
	Tim Chen <tim.c.chen@linux.intel.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org,
	Nicholas Bellinger <nab@linux-iscsi.org>,
	Sagi Grimberg <sagig@mellanox.com>,
	Christoph Hellwig <hch@lst.de>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <yq1tww1uo4d.fsf@sermon.lab.mkp.net>
Sender: target-devel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On 4/28/2015 2:50 AM, Martin K. Petersen wrote:
>>>>>> "Sagi" == Sagi Grimberg <sagig@dev.mellanox.co.il> writes:
>
> Sagi> The problem is that the HBA does not have the write_same
> Sagi> functionality you introduce here, i.e. generate multiple same
> Sagi> protection fields for a single data block.
>
> Adding support to DIX would be problematic since it would essentially
> turn a WRITE SAME into a WRITE. You'd only do one block of DMA but you'd
> get N blocks going over the wire.

I thought that WRITE_SAME with DIX would include PI for the block that
is being sent over the wire, the initiator and target HBAs will verify
the single block integrity and the target backend will expand the PI
for the number of same sectors involved (unless the target backend
includes another wire, in this case it should handle it like the
initiator...)

>
> In target mode it is conceivable to set up a prot sgl after parsing the
> CDB and let the HBA do the work. But I'm not aware of any hardware that
> allows that.

I don't either, I think it would be simpler to have the target core
implement it instead of having each fabric driver doing the same thing.

>
> Sagi> In this case, for WRITE_SAME, have the fabrics generate/verify a
> Sagi> single data block (one integrity field) like they do today, and
> Sagi> then the core will expand it to the correct number of sectors
> Sagi> using some form of sbc_dif_expand_same()
>
> Yeah. In a simple world you'd just keep overriding the ref tag in the
> received PI tuple. But for performance reasons you'll obviously want to
> do I/O in units bigger than a single block. Blindly preallocating PI to
> fit the entire I/O is also be problematic, however, since a block count
> of 0 unfortunately means "the whole disk".
>

It seems that the only one that can handle write_same PI expansion is
the backend.

The initiator can pass PI for the block that is transferred, and the
target is responsible to handle it. The target will also pass this
single block with PI to it's backend. The backend is responsible to
update PI for all the sectors that are written.

Sounds right?

Sagi.
