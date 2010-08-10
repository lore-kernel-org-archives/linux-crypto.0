From: Miloslav Trmac <mitr@redhat.com>
Subject: Re: [PATCH 0/4] RFC: "New" /dev/crypto user-space interface
Date: Tue, 10 Aug 2010 11:36:16 -0400 (EDT)
Message-ID: <530081823.135171281454576874.JavaMail.root@zmail07.collab.prod.int.phx2.redhat.com>
References: <801204854.134521281454377550.JavaMail.root@zmail07.collab.prod.int.phx2.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Cc: Herbert Xu <herbert@gondor.hengli.com.au>,
	Neil Horman <nhorman@redhat.com>,
	Nikos Mavrogiannopoulos <n.mavrogiannopoulos@gmail.com>,
	linux-crypto@vger.kernel.org, Linda Wang <lwang@redhat.com>,
	Steve Grubb <sgrubb@redhat.com>
To: Neil Horman <nhorman@tuxdriver.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mx3-phx2.redhat.com ([209.132.183.24]:48660 "EHLO
	mx01.colomx.prod.int.phx2.redhat.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932070Ab0HJPg1 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 10 Aug 2010 11:36:27 -0400
In-Reply-To: <801204854.134521281454377550.JavaMail.root@zmail07.collab.prod.int.phx2.redhat.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>


----- "Neil Horman" <nhorman@tuxdriver.com> wrote:
> On Mon, Aug 09, 2010 at 08:00:55PM -0400, Miloslav Trmac wrote:
> > Is the proposed interface acceptable in the general approach (enums
> for algorithms/operations, unions for parameters, session
> init/update/finalize)?  With respect to flexibility, do you have
> specific suggestions or areas of concern?
> 
> I know we spoke about this previously, but since you're asking publically, I'll
> make my argument here so that we can have the debate in public as well.  I'm ok
> wih the general enumeration of operations in user space (I honestly can't see
> how you would do it otherwise).  What worries me though is the use ioctl for
> these operations  and the flexibility that it denies you in future updates. 
> Specifically, my concerns are twofold:
> 
> 1) struct format.  By passing down a structure as your doing through an ioctl
> call, theres  no way to extend/modify that structure easily for future use.  For
> instance the integration of aead might I think requires a blocking factor to be
> sepcified, and entry for which you have no available field in your crypt_ops
> structure.  If you extend the structure in a later release of this code, you
> create a potential incompatibility with user space because you are no longer
> guaranteed that the size of the crypt_op structure is the same, and you need to
> be prepared for a range of sizes to get passed down, at which point it becomes
> difficult to differentiate between older code thats properly formatted, and
> newer code thats legitimately broken.  You might could add a version field to
> mitigate that, but it gets ugly pretty quickly.

I think it would be useful to separate thinking about the data format and about the transmission mechanism.  ioctl() can quite well be used to carry "netlink-like" packets - blobs of data with specified length and flexible internal structure - and on the other hand, netlink could be (and often is) used to carry fixed structs instead of variable-length packets.

So, any advantages netlink packets have in this respect can be provided using the ioctl() interface as well.  Besides, adding new ioctl commands provides a quite natural versioning mechanism (of course, it would be better to design the data format right the first time, but the option to easily extend the interface is available).  Versioned data structure that "gets ugly pretty quickly" is exactly what one can get with the netlink packets, I think :) - and it is not that bad actually.

Using a different design of the structures, perhaps appending a flexible array of "attributes" at the end of each operation structure, is certainly something to consider, if you think this is the way to go; the added flexibility is undisputable, at the cost of some encoding/decoding overhead.

As for the transmission mechanism, netlink seems to me to be one of the least desirable options: as described above, it does not provide any inherent advantages to ioctl, and it has significantly higher overhead (sendmsg()+recvmsg(), handling netlink ACKs, matching requests and replies in multi-threaded programs), and it makes auditing difficult.

> 2) Use of pointers.  Thats just a pain.  You have the compat ioctl stuff in
> place to handle the 32/64 bit conversions, but it would be really nice if you
> could avoid having to maintain that extra code path.
Pointers are pretty much unavoidable, to allow zero-copy references to input/output data.  If that means maintaining 32-bit compat paths (as opposed to codifying say uint128_t for pointers in fixed-size structures), then so be it: the 32-bit paths will simply have to be maintained.  Once we have the 32-bit compat paths, using pointers for other unformatted, variable-sized data (e.g. IVs, multiple-precision integers) seems to be easier than using variable-size data structures or explicit pointer arithmetic to compute data locations within the data packets.
    Mirek
