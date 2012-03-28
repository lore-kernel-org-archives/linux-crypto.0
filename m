From: Milan Broz <mbroz@redhat.com>
Subject: Re: Status of aes in Debian/Ubuntu?
Date: Wed, 28 Mar 2012 23:14:41 +0200
Message-ID: <4F737F41.1090309@redhat.com>
References: <20120328121744.GY32725@vnl.com> <1332952631.8994.44.camel@foxtrot.cjac.ntr.f5net.com> <20120328190322.GA16113@greengrey.org> <20120328204234.GD10584@vnl.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: Dale Amon <amon@vnl.com>, Ryan Corder <ryanc@greengrey.org>,
	"C.J. Adams-Collier KF7BMP" <cjac@colliertech.org>,
	linux-crypto@vger.kernel.org,
	"roosa, william MAJ RES" <william-roosa@us.army.mil>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:28886 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758524Ab2C1VPH (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Wed, 28 Mar 2012 17:15:07 -0400
In-Reply-To: <20120328204234.GD10584@vnl.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 03/28/2012 10:42 PM, Dale Amon wrote:
> So does anyone have a suggestion as to where I have
> gone wrong? It's been over half a decade since I've
> gone through this and even longer since I was doing
> the magic dance with patching and building my own
> losetup, mount, etc...

If you want something simple, use LUKS. cryptsetup
and dmcrypt is in all distributions by default.
Truecrypt uses dmcrypt by default as backend as well.

Of course, if you want use loop-aes, you have to
patch all utilities and kernel, it is not so complicated.

(cryptsetup can run loop-aes compatible mode as well and
can allocate loop device as well. But it is your
choice what encryption and utility to use to use
of course.)

For default losetup from util-linux, encryption option
is in fact deprecated in favor to cryptsetup.

Milan
