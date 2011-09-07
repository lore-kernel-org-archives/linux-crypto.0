From: Nikos Mavrogiannopoulos <n.mavrogiannopoulos@gmail.com>
Subject: Re: [PATCH] random: add blocking facility to urandom
Date: Wed, 07 Sep 2011 23:20:48 +0200
Message-ID: <4E67E030.1020702@gmail.com>
References: <1314974248-1511-1-git-send-email-jarod@redhat.com> <4E67B75B.8010500@redhat.com> <20110907192737.GD20571@thunk.org> <201109071602.24519.sgrubb@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Ted Ts'o <tytso@mit.edu>, Jarod Wilson <jarod@redhat.com>,
	Sasha Levin <levinsasha928@gmail.com>,
	linux-crypto@vger.kernel.org, Matt Mackall <mpm@selenic.com>,
	Neil Horman <nhorman@redhat.com>,
	Herbert Xu <herbert.xu@redhat.com>,
	Stephan Mueller <stephan.mueller@atsec.com>,
	lkml <linux-kernel@vger.kernel.org>
To: Steve Grubb <sgrubb@redhat.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:65316 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754554Ab1IGVUh (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 7 Sep 2011 17:20:37 -0400
In-Reply-To: <201109071602.24519.sgrubb@redhat.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 09/07/2011 10:02 PM, Steve Grubb wrote:

> When a system is underattack, do you really want to be using a PRNG
> for anything like seeding openssl? Because a PRNG is what urandom
> degrades into when its attacked.

Using a PRNG is not a problem. Making sure it is well seeded and no
input from the attacker can compromise its state are the difficult
parts. Making predictable estimates and blocking when your estimates are
off, makes it a good target for DoS. When your system is under attack,
you want to use your services. If they block then the attack might
have just been successful.

regards,
Nikos
