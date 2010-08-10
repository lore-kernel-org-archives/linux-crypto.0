From: Miloslav Trmac <mitr@redhat.com>
Subject: Re: [PATCH 0/4] RFC: "New" /dev/crypto user-space interface
Date: Tue, 10 Aug 2010 14:58:01 -0400 (EDT)
Message-ID: <140401738.160491281466681823.JavaMail.root@zmail07.collab.prod.int.phx2.redhat.com>
References: <1250838696.160111281466456373.JavaMail.root@zmail07.collab.prod.int.phx2.redhat.com>
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
Received: from mx4-phx2.redhat.com ([209.132.183.25]:46498 "EHLO
	mx02.colomx.prod.int.phx2.redhat.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932249Ab0HJS60 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 10 Aug 2010 14:58:26 -0400
In-Reply-To: <1250838696.160111281466456373.JavaMail.root@zmail07.collab.prod.int.phx2.redhat.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

----- "Neil Horman" <nhorman@tuxdriver.com> wrote:
> On Tue, Aug 10, 2010 at 11:36:16AM -0400, Miloslav Trmac wrote:
> > I think it would be useful to separate thinking about the data
> format and about the transmission mechanism.  ioctl() can quite well
> be used to carry "netlink-like" packets - blobs of data with specified
> length and flexible internal structure - and on the other hand,
> netlink could be (and often is) used to carry fixed structs instead of
> variable-length packets.
> 
> Yes, both mechanism can be used to carry either fixed or variable length
> payloads.  The difference is ioctl has no built in mechanism to do variable
> length data safely.  To do variable length data you need to setup a bunch of
> pointers to extra data that you have to copy separately.
No, I can do exactly what netlink does:

struct operation {
    // fixed params;
    size_t size_of_attrs;
    char attrs[]; // struct nlattr-tagged data
};

at the cost of one additional copy_from_user() (which netlink users often pay as well because using struct iovec is so convenient).  Or perhaps even better, I can make sure the userspace application won't mess up the pointer arithmetic and get rid of all of the macros:

struct operation {
    // fixed params;
    size_t num_attrs;
    struct { struct nlattr header; union { ... } data } attrs[];
}

at the same cost (and sacrificing string and variable-length parameters - but as argued below, pointers are still an option).

> Even then, you're
> fixing the number of pointers that you have in your base structure.  To add or
> remove any would break your communication protocol to user space.  This is
> exactly the point I made above.
The existence of a base structure does not inherently limit the number of extensions.

> And there is no need for versioning in the netlink packet, because the data
> types are all inlined, typed and attached to length values (at least when done
> correctly, see then nl_attr structure and associated macros).  You don't have
> that with your ioctl.  You could add it for certain, but at that point you're
> re-inventing the wheel.
Right, the nl_attr structure is quite nice, and I didn't know about it.  Still...


> > As for the transmission mechanism, netlink seems to me to be one of
> the least desirable options: as described above, it does not provide
> any inherent advantages to ioctl, and it has significantly higher
> overhead (sendmsg()+recvmsg(), handling netlink ACKs, matching
> requests and replies in multi-threaded programs), and it makes
> auditing difficult.
> 
> You're incorrect.  I've explained several of the advantiges above and in my previous
> email, you're just not seeing them.  I will grant you some additional overhead
> in the use of of two system calls rather than one per operation in the nominal
> case, but there is no reason that can't be mitigated by the bundling of multiple
> operations into a single netlink packet. 
None of the existing crypto libraries provide such interfaces, and restructuring applications to take advantage of them would often be difficult - just restructuring the NSS _internals_ to support this would be difficult.  Porting applications to a Linux-specific interface would make them less portable; besides, we have tried porting applications to a different library before (http://fedoraproject.org/wiki/FedoraCryptoConsolidation ), and based on that experience, any such new interface would have minimal, if any, impact.

> Likewise, matching requests and responses in a multi-threaded program is also an
> already solved issue in multiple ways.  The use of multiple sockets, in a 1 per
> thread fashion is the most obvious.
That would give each thread a separate namespace of keys/sessions, rather strange and a problem to fit into existing applications.

> Theres also countless approaches in which a
> thread can reassemble responses to registered requests in such a way that the
> user space portion of an application sees these calls as being synchronous.  Its
> really not that hard.
The overhead is still unnecessary.

> > > 2) Use of pointers.  Thats just a pain.  You have the compat ioctl stuff in
> > > place to handle the 32/64 bit conversions, but it would be really nice if you
> > > could avoid having to maintain that extra code path.
> > Pointers are pretty much unavoidable, to allow zero-copy references
> to input/output data.  If that means maintaining 32-bit compat paths
> (as opposed to codifying say uint128_t for pointers in fixed-size
> structures), then so be it: the 32-bit paths will simply have to be
> maintained.  Once we have the 32-bit compat paths, using pointers for
> other unformatted, variable-sized data (e.g. IVs, multiple-precision
> integers) seems to be easier than using variable-size data structures
> or explicit pointer arithmetic to compute data locations within the
> data packets.
> 
> No, they're not unavoidable.  Thats the point I made in my last email.  If you
> use netlink, you inline all your data into a single byte array, with the proper
> headers on it.  no use of additional pointers needed at all.  One buffer in, one
> buffer out.
Right, one copy of input data in sendmsg() from userspace to a skbuf, one copy of output data from a skbuf into userspace.  The submitted code already implements zero-copy for data: the pointers are used to form scatter-gather lists submitted directly to the crypto code.  I don't think I can do that with the linear skbuf I get from af_netlink.c.


Overall, I'd much rather do the programming necessary to clone the nl_attr code, than suffer the system call overhead and audit problems, if those are the only options.
    Mirek
