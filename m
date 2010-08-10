From: Miloslav Trmac <mitr@redhat.com>
Subject: Re: [PATCH 0/4] RFC: "New" /dev/crypto user-space interface
Date: Tue, 10 Aug 2010 14:36:48 -0400 (EDT)
Message-ID: <1989857381.157821281465408038.JavaMail.root@zmail07.collab.prod.int.phx2.redhat.com>
References: <20100810183412.GA32254@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Cc: Neil Horman <nhorman@tuxdriver.com>,
	Neil Horman <nhorman@redhat.com>,
	Nikos Mavrogiannopoulos <n.mavrogiannopoulos@gmail.com>,
	linux-crypto@vger.kernel.org, Linda Wang <lwang@redhat.com>,
	Steve Grubb <sgrubb@redhat.com>
To: Herbert Xu <herbert@gondor.hengli.com.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mx4-phx2.redhat.com ([209.132.183.25]:47085 "EHLO
	mx02.colomx.prod.int.phx2.redhat.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932515Ab0HJShA (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 10 Aug 2010 14:37:00 -0400
In-Reply-To: <20100810183412.GA32254@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

----- "Herbert Xu" <herbert@gondor.hengli.com.au> wrote:
> On Tue, Aug 10, 2010 at 02:19:59PM -0400, Miloslav Trmac wrote:
> >
> > 2) simplicity and reliability: you are downplaying the overhead and
> synchronization necessary (potentially among multiple processes!) to
> simply receive a response, but it is still enormous compared to the
> single syscall case.  Even worse, netlink(7) says "netlink is not a
> reliable protocol.  ... but may drop messages".  Would you accept such
> a mechanism to transfer "write data to file" operations?  "Compress
> data using AES" is much more similar to "write data to file" than to
> "change this aspect of kernel routing configuration" - it is an
> application-level service, not a way to communicate long-term
> parameters to a pretty independent subsystem residing in the kernel.
> 
> That just shows you have no idea how netlink works.
I'm learning as fast as I can by reading all available documentation :)  Nevertheless I believe the point stands even without the reliability problem.
    Mirek
