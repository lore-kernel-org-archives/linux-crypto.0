From: Steve Grubb <sgrubb@redhat.com>
Subject: Re: [PATCH 0/4] RFC: "New" /dev/crypto user-space interface
Date: Tue, 10 Aug 2010 09:24:31 -0400
Message-ID: <201008100924.32326.sgrubb@redhat.com>
References: <20100809143943.GB19862@gondor.apana.org.au> <1976107781.89151281398455116.JavaMail.root@zmail07.collab.prod.int.phx2.redhat.com> <20100810124628.GA3072@hmsreliant.think-freely.org>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: Miloslav Trmac <mitr@redhat.com>,
	Herbert Xu <herbert@gondor.hengli.com.au>,
	Neil Horman <nhorman@redhat.com>,
	Nikos Mavrogiannopoulos <n.mavrogiannopoulos@gmail.com>,
	linux-crypto@vger.kernel.org, Linda Wang <lwang@redhat.com>
To: Neil Horman <nhorman@tuxdriver.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:40496 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754860Ab0HJNYu (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Tue, 10 Aug 2010 09:24:50 -0400
In-Reply-To: <20100810124628.GA3072@hmsreliant.think-freely.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tuesday, August 10, 2010 08:46:28 am Neil Horman wrote:
> Specifically, my concerns are twofold:
> 
> 1) struct format.  By passing down a structure as your doing through an
> ioctl call, theres  no way to extend/modify that structure easily for
> future use.  For instance the integration of aead might I think requires a
> blocking factor to be sepcified, and entry for which you have no available
> field in your crypt_ops structure.  If you extend the structure in a later
> release of this code, you create a potential incompatibility with user
> space because you are no longer guaranteed that the size of the crypt_op
> structure is the same, and you need to be prepared for a range of sizes to
> get passed down, at which point it becomes difficult to differentiate
> between older code thats properly formatted, and newer code thats
> legitimately broken.  You might could add a version field to mitigate
> that, but it gets ugly pretty quickly.

Yeah, this does call out for versioning. But the ioctls are just for crypto 
parameter setup. Hopefully, that doesn't change too much since its just to 
select an algorithm, possibly ask for a key to be wrapped and loaded, or ask 
for a key to be created and exported. After setup, you just start using the 
device.
 

> Thats why I had suggested the use of a netlink protocol to manage this kind
> of interface.  There are other issue to manage there, but they're really
> not that big a deal, comparatively speaking, and that interface allows for
> the easy specification of arbitrary length data in a fashion that doesn't
> cause user space breakage when additional algorithms/apis are added.

The problem with the netlink approach is that auditing is not as good because 
netlink is an async protocol. The kernel can only use the credentials that 
ride in the skb with the command since there is no guarantee the process has 
not changed credentials by the time you get the packet. Adding more 
credentials to the netlink headers is also not good. As it is now, the 
auditing is synchronous with the syscall and we can get at more information 
and reliably create the audit records called out by the protection profiles or 
FIPS-140 level 2.

-Steve
