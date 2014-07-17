From: David Lang <david@lang.hm>
Subject: Re: [PATCH, RFC] random: introduce getrandom(2) system call
Date: Thu, 17 Jul 2014 15:21:41 -0700 (PDT)
Message-ID: <alpine.DEB.2.02.1407171521020.17284@nftneq.ynat.uz>
References: <201407171848.s6HImBb4027900@glazunov.sibelius.xs4all.nl> <53C83383.4040507@amacapital.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Cc: Mark Kettenis <mark.kettenis@xs4all.nl>,
	"Theodore Ts'o" <tytso@mit.edu>, linux-kernel@vger.kernel.org,
	linux-crypto@vger.kernel.org, beck@openbsd.org
To: Andy Lutomirski <luto@amacapital.net>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.lang.hm ([64.81.33.126]:45882 "EHLO bifrost.lang.hm"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757592AbaGQWfF (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Thu, 17 Jul 2014 18:35:05 -0400
In-Reply-To: <53C83383.4040507@amacapital.net>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, 17 Jul 2014, Andy Lutomirski wrote:

> Can we please have a mode in which getrandom(2) can neither block nor
> fail?  If that gets added, then this can replace things like AT_RANDOM.

If a call to get random data isn't allowed to either block or fail, what is it 
supposed to return if there isn't random data available?

David Lang
