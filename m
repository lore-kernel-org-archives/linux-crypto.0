From: Russell King - ARM Linux <linux@armlinux.org.uk>
Subject: Re: AF_ALG broken?
Date: Mon, 8 Aug 2016 23:58:51 +0100
Message-ID: <20160808225851.GE1041@n2100.armlinux.org.uk>
References: <20160808164427.GB1041@n2100.armlinux.org.uk>
 <5469036.jmYhrDdAzD@positron.chronox.de>
 <5217898.dpPNhAO3PW@tauon.atsec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org
To: Stephan Mueller <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from pandora.armlinux.org.uk ([78.32.30.218]:59475 "EHLO
	pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751433AbcHHW7D (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 8 Aug 2016 18:59:03 -0400
Content-Disposition: inline
In-Reply-To: <5217898.dpPNhAO3PW@tauon.atsec.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, Aug 08, 2016 at 08:30:32PM +0200, Stephan Mueller wrote:
> Am Montag, 8. August 2016, 20:18:32 CEST schrieb Stephan Mueller:
> 
> Hi Stephan,
> 
> > Am Montag, 8. August 2016, 17:44:27 CEST schrieb Russell King - ARM Linux:
> > 
> > Hi Russell,
> > 
> > > Hi,
> > > 
> > > When trying to use the openssl AF_ALG module with 4.8-rc1 with imx
> > > caam, I get this:
> > > 
> > > $ OPENSSL_CONF=/shared/crypto/openssl-imx.cnf strace openssl dgst -md5
> > > </bin/bash ...
> > > socket(PF_ALG, SOCK_SEQPACKET, 0)       = 3
> > > close(3)                                = 0
> > > socket(PF_ALG, SOCK_SEQPACKET, 0)       = 3
> > > bind(3, {sa_family=AF_ALG, sa_data="hash\0\0\0\0\0\0\0\0\0\0"}, 88) = 0
> > > accept(3, 0, NULL)                      = 4
> > > fstat64(0, {st_mode=S_IFREG|0755, st_size=666864, ...}) = 0
> > > mmap2(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0)
> > > =
> > > 0xb6fab000 read(0,
> > > "\177ELF\1\1\1\0\0\0\0\0\0\0\0\0\2\0(\0\1\0\0\0\21'\2\0004\0\0\0"...,
> > > 8192)
> > > = 8192 send(4,
> > > "\177ELF\1\1\1\0\0\0\0\0\0\0\0\0\2\0(\0\1\0\0\0\21'\2\0004\0\0\0"...,
> > > 8192,
> > > MSG_MORE) = -1 ENOKEY (Required key not available)
> > > 
> > > This used to work, so something in the kernel AF_ALG API has changed
> > > which has broken userspace.  Any ideas what's up, or where to look?
> > 
> > This seems to be the the change added by Herbert to fix a security issue.
> > This caused a similar stirr in the cryptsetup user space tool.
> > 
> > I guess you are affected by 6de62f15b581f920ade22d758f4c338311c2f0d4
> 
> Just to be clear: the settings on the tfmfd must be completed before an 
> accept(). If make an operation on the tfmfd after the accept call, you get 
> the ENOKEY.

As you can see from the above strace, there's no operations on fd 3
after the accept call.  The only operation on the accepted fd (fd 4)
is the send().  So, I'm not sure I follow what you're saying.

I've also checked - there's no updates for af-alg-rr, so everyone
who's using af-alg-rr must have been broken by this change - if there
_are_ any users of AF_ALG with openssl.  Maybe everyone just patches
cryptodev into their kernel?

I don't know, but this seems to go completely against Linus' no
userspace regressions, which seems to be an absolute requirement of
all kernel development... Linus flames people for arguing against
that rule!

-- 
RMK's Patch system: http://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line: currently at 9.6Mbps down 400kbps up
according to speedtest.net.
