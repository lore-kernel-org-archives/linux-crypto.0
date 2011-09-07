From: Sasha Levin <levinsasha928@gmail.com>
Subject: Re: [PATCH] random: add blocking facility to urandom
Date: Wed, 07 Sep 2011 23:00:42 +0300
Message-ID: <1315425642.3576.30.camel@lappy>
References: <1314974248-1511-1-git-send-email-jarod@redhat.com>
	 <1315417137-12093-1-git-send-email-jarod@redhat.com>
	 <1315419179.3576.6.camel@lappy>  <4E67B75B.8010500@redhat.com>
	 <1315422330.3576.22.camel@lappy>  <4E67C659.1080707@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: linux-crypto@vger.kernel.org, Matt Mackall <mpm@selenic.com>,
	Neil Horman <nhorman@redhat.com>,
	Herbert Xu <herbert.xu@redhat.com>,
	Steve Grubb <sgrubb@redhat.com>,
	Stephan Mueller <stephan.mueller@atsec.com>,
	lkml <linux-kernel@vger.kernel.org>
To: Jarod Wilson <jarod@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <4E67C659.1080707@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Wed, 2011-09-07 at 15:30 -0400, Jarod Wilson wrote:
> Sasha Levin wrote:
> > On Wed, 2011-09-07 at 14:26 -0400, Jarod Wilson wrote:
> >> Sasha Levin wrote:
> >> [..] And anything done in
> >> userspace is going to be full of possible holes [..]
> >
> > Such as? Is there an example of a case which can't be handled in
> > userspace?
> 
> How do you mandate preventing reads from urandom when there isn't 
> sufficient entropy? You likely wind up needing to restrict access to the 
> actual urandom via permissions and selinux policy or similar, and then 
> run a daemon or something that provides a pseudo-urandom that brokers 
> access to the real urandom. Get the permissions or policy wrong, and 
> havoc ensues. An issue with the initscript or udev rule to hide the real 
> urandom, and things can fall down. Its a whole lot more fragile than 
> this approach, and a lot more involved in setting it up.

Replace /dev/urandom with a simple CUSE driver, redirect reads to the
real urandom after applying your threshold.

-- 

Sasha.
