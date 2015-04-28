From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH v3 0/5] target: Fix several problems related to T10-PI support
Date: Tue, 28 Apr 2015 19:06:48 -0400
Message-ID: <yq1d22nyhrr.fsf@sermon.lab.mkp.net>
References: <1429972410-7146-1-git-send-email-akinobu.mita@gmail.com>
	<553CBF07.6080902@dev.mellanox.co.il>
	<yq1tww1uo4d.fsf@sermon.lab.mkp.net>
	<553F5F6F.5040800@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>,
	Akinobu Mita <akinobu.mita@gmail.com>,
	target-devel@vger.kernel.org,
	Tim Chen <tim.c.chen@linux.intel.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org,
	Nicholas Bellinger <nab@linux-iscsi.org>,
	Sagi Grimberg <sagig@mellanox.com>,
	Christoph Hellwig <hch@lst.de>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
To: Sagi Grimberg <sagig@dev.mellanox.co.il>
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <553F5F6F.5040800@dev.mellanox.co.il> (Sagi Grimberg's message of
	"Tue, 28 Apr 2015 13:22:39 +0300")
Sender: target-devel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

>>>>> "Sagi" == Sagi Grimberg <sagig@dev.mellanox.co.il> writes:

Sagi,

Sagi> I thought that WRITE_SAME with DIX would include PI for the block
Sagi> that is being sent over the wire, the initiator and target HBAs
Sagi> will verify the single block integrity and the target backend will
Sagi> expand the PI for the number of same sectors involved (unless the
Sagi> target backend includes another wire, in this case it should
Sagi> handle it like the initiator...)

Yep. I'm just saying there's nothing to be done wrt. DIX and WRITE SAME
on the initiator side. If you were to do something special it would
effectively mean turning WRITE SAME into a WRITE which kind of defeats
the purpose.

>> In target mode it is conceivable to set up a prot sgl after parsing
>> the CDB and let the HBA do the work. But I'm not aware of any
>> hardware that allows that.

Sagi> I don't either, I think it would be simpler to have the target
Sagi> core implement it instead of having each fabric driver doing the
Sagi> same thing.

Yep.

Sagi> The initiator can pass PI for the block that is transferred, and
Sagi> the target is responsible to handle it. The target will also pass
Sagi> this single block with PI to it's backend. The backend is
Sagi> responsible to update PI for all the sectors that are written.

Sagi> Sounds right?

Yes, I agree.

-- 
Martin K. Petersen	Oracle Linux Engineering
