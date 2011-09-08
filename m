From: Sandy Harris <sandyinchina@gmail.com>
Subject: Re: [PATCH] random: add blocking facility to urandom
Date: Thu, 8 Sep 2011 10:43:38 +0800
Message-ID: <CACXcFmk5M2DeO6RKL2pbmBLsLqvSCaqO5aUaFiU1eYA1fGozhQ@mail.gmail.com>
References: <1314974248-1511-1-git-send-email-jarod@redhat.com>
	<1315417137-12093-1-git-send-email-jarod@redhat.com>
	<1315419179.3576.6.camel@lappy>
	<4E67B75B.8010500@redhat.com>
	<20110907192737.GD20571@thunk.org>
	<4E67C7AD.9050903@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: "Ted Ts'o" <tytso@mit.edu>, Sasha Levin <levinsasha928@gmail.com>,
	linux-crypto@vger.kernel.org, Matt Mackall <mpm@selenic.com>,
	Neil Horman <nhorman@redhat.com>,
	Herbert Xu <herbert.xu@redhat.com>,
	Steve Grubb <sgrubb@redhat.com>,
	Stephan Mueller <stephan.mueller@atsec.com>,
	lkml <linux-kernel@vger.kernel.org>
To: Jarod Wilson <jarod@redhat.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-vx0-f174.google.com ([209.85.220.174]:47177 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755954Ab1IHCnj (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 7 Sep 2011 22:43:39 -0400
In-Reply-To: <4E67C7AD.9050903@redhat.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Jarod Wilson <jarod@redhat.com> wrote:

> Ted Ts'o wrote:

>> Yeah, but there are userspace programs that depend on urandom not
>> blocking... so your proposed change would break them.
>> ...

> But only if you've set the sysctl to a non-zero value, ...
>
> But again, I want to stress that out of the box, there's absolutely no
> change to the way urandom behaves, no blocking, this *only* kicks in if you
> twiddle the sysctl because you have some sort of security requirement that
> mandates it.

So it only breaks things on systems with high security requirements?
