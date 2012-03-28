From: Dale Amon <amon@vnl.com>
Subject: Re: Status of aes in Debian/Ubuntu?
Date: Wed, 28 Mar 2012 22:33:05 +0100
Message-ID: <20120328213305.GG10584@vnl.com>
References: <20120328121744.GY32725@vnl.com>
 <1332952631.8994.44.camel@foxtrot.cjac.ntr.f5net.com>
 <20120328190322.GA16113@greengrey.org>
 <20120328204234.GD10584@vnl.com>
 <4F737F41.1090309@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Dale Amon <amon@vnl.com>, Ryan Corder <ryanc@greengrey.org>,
	"C.J. Adams-Collier KF7BMP" <cjac@colliertech.org>,
	linux-crypto@vger.kernel.org,
	"roosa, william MAJ RES" <william-roosa@us.army.mil>
To: Milan Broz <mbroz@redhat.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from grendel.xisp.net ([96.255.255.193]:52160 "EHLO ba-blue.xisp.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S933165Ab2C1Vdp (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Wed, 28 Mar 2012 17:33:45 -0400
Content-Disposition: inline
In-Reply-To: <4F737F41.1090309@redhat.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Mar 28, 2012 at 11:14:41PM +0200, Milan Broz wrote:
> If you want something simple, use LUKS. cryptsetup
> and dmcrypt is in all distributions by default.
> Truecrypt uses dmcrypt by default as backend as well.

Looking around a bit, it appears that cryptsetup is in
the ubuntu server set up disk.

> Of course, if you want use loop-aes, you have to
> patch all utilities and kernel, it is not so complicated.

I'm not wedded to it... as I noted I have been out of
the loop, crypt or otherwise, for half a decade.

> (cryptsetup can run loop-aes compatible mode as well and
> can allocate loop device as well. But it is your
> choice what encryption and utility to use to use
> of course.)
> 
> For default losetup from util-linux, encryption option
> is in fact deprecated in favor to cryptsetup.

Okay. Now do cryptsetup and the others work in a pretty
standard way? ie, put them in your /etc/fstab and
just feed them a password when you want to mount? Or if
it is a loopback image, you just do the usual

	mount -o loop file /mnt

?
