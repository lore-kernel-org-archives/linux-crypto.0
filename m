From: Miloslav Trmac <mitr@redhat.com>
Subject: Re: [PATCH 0/4] RFC: "New" /dev/crypto user-space interface
Date: Tue, 10 Aug 2010 15:18:44 -0400 (EDT)
Message-ID: <580234324.162701281467924180.JavaMail.root@zmail07.collab.prod.int.phx2.redhat.com>
References: <1649376471.162481281467800176.JavaMail.root@zmail07.collab.prod.int.phx2.redhat.com>
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
Received: from mx4-phx2.redhat.com ([209.132.183.25]:36636 "EHLO
	mx02.colomx.prod.int.phx2.redhat.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754536Ab0HJTS5 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 10 Aug 2010 15:18:57 -0400
In-Reply-To: <1649376471.162481281467800176.JavaMail.root@zmail07.collab.prod.int.phx2.redhat.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

----- "Miloslav Trmac" <mitr@redhat.com> wrote:
> ----- "Neil Horman" <nhorman@tuxdriver.com> wrote:
> > Likewise, matching requests and responses in a multi-threaded program is also an
> > already solved issue in multiple ways.  The use of multiple sockets, in a 1 per
> > thread fashion is the most obvious.
> That would give each thread a separate namespace of keys/sessions,
> rather strange and a problem to fit into existing applications.
Hm, that's actually not necessarily true, depending on the specifics, but it does bring up the more general problem of "crypto contexts" and their lifetimes.

The proposed patch treats each open("/dev/crypto") as a new context within which keys and sessions are allocated.  Only processes having this FD can access the keys and namespaces, and transferring the FD also transfers access to the crypto data.  On last close() the data is automatically freed.

With netlink we could associate the data with the caller's netlink address, but we don't get any notification that the caller has exited.  The other option is to have only one, per-process, context, which again runs into the problem that netlink message handling is, at least semantically, separate from the calling process.
    Mirek
