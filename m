From: Miloslav Trmac <mitr@redhat.com>
Subject: Re: [PATCH 0/4] RFC: "New" /dev/crypto user-space interface
Date: Tue, 10 Aug 2010 22:06:05 -0400 (EDT)
Message-ID: <42346356.184831281492365997.JavaMail.root@zmail07.collab.prod.int.phx2.redhat.com>
References: <227903841.184591281491835434.JavaMail.root@zmail07.collab.prod.int.phx2.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Cc: Neil Horman <nhorman@tuxdriver.com>,
	Herbert Xu <herbert@gondor.hengli.com.au>,
	Nikos Mavrogiannopoulos <n.mavrogiannopoulos@gmail.com>,
	linux-crypto@vger.kernel.org, Linda Wang <lwang@redhat.com>,
	Steve Grubb <sgrubb@redhat.com>
To: Neil Horman <nhorman@redhat.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mx4-phx2.redhat.com ([209.132.183.25]:57712 "EHLO
	mx02.colomx.prod.int.phx2.redhat.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756889Ab0HKCGV (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 10 Aug 2010 22:06:21 -0400
In-Reply-To: <227903841.184591281491835434.JavaMail.root@zmail07.collab.prod.int.phx2.redhat.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

----- "Neil Horman" <nhorman@redhat.com> wrote:
> Ok, well, I suppose we're just not going to agree on this.  I don't know how
> else to argue my case, you seem to be bent on re-inventing the wheel instead of
> using what we have.  Good luck. 
Well, I basically spent yesterday learning about netlink and looking how it can or can not be adapted.  I still see drawbacks that are not balanced by any benefits that are exclusive to netlink.

As a very unscientific benchmark, I modified a simple example program to add a simple non-blocking getmsg(..., MSG_PEEK) call on a netlink socket after each encryption operation; this is only a lower bound on the overhead because no copying of data between userspace and the skbuffer takes place and zero copy is still available.  With cbc(aes), encrypting 256 bytes per operation, the throughput dropped from 156 MB/s to 124 MB/s (-20%); even with 32 KB per operation there is still a decrease from 131 to 127 MB/s (-2.7%).

If I have to do a little more programming work to get a permanent 20% performance boost, why not?


How about this: The existing ioctl (1-syscall interface) remains, using a very minimal fixed header (probably just a handle and perhaps algorithm ID) and using the netlink struct nlattr for all other attributes (both input and output, although I don't expect many output attribute).

- This gives us exactly the same flexibility benefits as using netlink directly.
- It uses the 1-syscall, higher performance, interface.
- The crypto operations are run in process context, making it possible to implement zero-copy operations and reliable auditing.
- The existing netlink parsing routines (both in the kernel and in libnl) can be used; formatting routines will have to be rewritten, but that's the easier part.

This kind of partial netlink reuse already has a precedent in the kernel, see zlib_compress_setup().

Would everyone be happy with such an approach?
    Mirek
