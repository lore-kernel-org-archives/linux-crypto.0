From: Sasha Levin <levinsasha928@gmail.com>
Subject: Re: [PATCH] random: add blocking facility to urandom
Date: Thu, 08 Sep 2011 00:38:31 +0300
Message-ID: <1315431511.3576.66.camel@lappy>
References: <1314974248-1511-1-git-send-email-jarod@redhat.com>
	 <201109071656.49758.sgrubb@redhat.com> <1315429827.3576.61.camel@lappy>
	 <201109071728.31162.sgrubb@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: Ted Ts'o <tytso@mit.edu>, Jarod Wilson <jarod@redhat.com>,
	linux-crypto@vger.kernel.org, Matt Mackall <mpm@selenic.com>,
	Neil Horman <nhorman@redhat.com>,
	Herbert Xu <herbert.xu@redhat.com>,
	Stephan Mueller <stephan.mueller@atsec.com>,
	lkml <linux-kernel@vger.kernel.org>
To: Steve Grubb <sgrubb@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <201109071728.31162.sgrubb@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Wed, 2011-09-07 at 17:28 -0400, Steve Grubb wrote:
> On Wednesday, September 07, 2011 05:10:27 PM Sasha Levin wrote:
> > > > > > Something similar probably happens for getting junk on disks before
> > > > > > creating an encrypted filesystem on top of them.
> > > > > 
> > > > > During system install, this sysctl is not likely to be applied.
> > > > 
> > > > It may happen at any time you need to create a new filesystem, which
> > > > won't necessarily happen during system install.
> > > > 
> > > > See for example the instructions on how to set up a LUKS filesystem:
> > > > https://wiki.archlinux.org/index.php/System_Encryption_with_LUKS#Prepar
> > > > atio n_and_mapping
> > > 
> > > Those instructions might need to be changed. That is one way of many to
> > > get random numbers on the disk. Anyone really needing the security to
> > > have the sysctl on will also probably accept that its doing its job and
> > > keeping the numbers random. Again, no effect unless you turn it on.
> > 
> > There are bunch of other places that would need to be changed in that
> > case :)
> > 
> > Why not implement it as a user mode CUSE driver that would
> > wrap /dev/urandom and make it behave any way you want to? why push it
> > into the kernel?
> 
> For one, auditing does not work for FUSE or things like that. We have to be able to 
> audit who is using what. Then there are the FIPS-140 requirements and this will spread 
> it. There are problems sending crypto audit events from user space, too.

auditd doesn't work with FUSE? afaik it should, FUSE is a filesystem
like any other.

-- 

Sasha.
