From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 0/4] RFC: "New" /dev/crypto user-space interface
Date: Tue, 10 Aug 2010 14:34:12 -0400
Message-ID: <20100810183412.GA32254@gondor.apana.org.au>
References: <20100810175740.GC3072@hmsreliant.think-freely.org> <1257297871.155001281464399281.JavaMail.root@zmail07.collab.prod.int.phx2.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Neil Horman <nhorman@tuxdriver.com>,
	Neil Horman <nhorman@redhat.com>,
	Nikos Mavrogiannopoulos <n.mavrogiannopoulos@gmail.com>,
	linux-crypto@vger.kernel.org, Linda Wang <lwang@redhat.com>,
	Steve Grubb <sgrubb@redhat.com>
To: Miloslav Trmac <mitr@redhat.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.apana.org.au ([209.40.204.226]:45234 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932523Ab0HJSeR (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 10 Aug 2010 14:34:17 -0400
Content-Disposition: inline
In-Reply-To: <1257297871.155001281464399281.JavaMail.root@zmail07.collab.prod.int.phx2.redhat.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Aug 10, 2010 at 02:19:59PM -0400, Miloslav Trmac wrote:
>
> 2) simplicity and reliability: you are downplaying the overhead and synchronization necessary (potentially among multiple processes!) to simply receive a response, but it is still enormous compared to the single syscall case.  Even worse, netlink(7) says "netlink is not a reliable protocol.  ... but may drop messages".  Would you accept such a mechanism to transfer "write data to file" operations?  "Compress data using AES" is much more similar to "write data to file" than to "change this aspect of kernel routing configuration" - it is an application-level service, not a way to communicate long-term parameters to a pretty independent subsystem residing in the kernel.

That just shows you have no idea how netlink works.  The reliability
comment is in the context of congestion control, and does not apply
in this case.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
