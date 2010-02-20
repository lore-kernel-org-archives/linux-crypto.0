From: Richard Hartmann <richih.mailinglist@gmail.com>
Subject: Re: [PATCH 05/19] crypto: proc - Fix checkpatch errors
Date: Sat, 20 Feb 2010 11:26:46 +0100
Message-ID: <2d460de71002200226w5fa27d85maa3fa75e1dca8fdd@mail.gmail.com>
References: <1266538925-3245-1-git-send-email-richih.mailinglist@gmail.com>
	 <m1d402t2qp.fsf@fess.ebiederm.org>
	 <2d460de71002190210qb9d5685n2fca0e7eff011b04@mail.gmail.com>
	 <20100219121752.GA21682@gondor.apana.org.au>
	 <2d460de71002190835t29c6bd6bjbee8e2f787d9ab49@mail.gmail.com>
	 <20100220004615.GB30844@gondor.apana.org.au>
	 <2d460de71002191759w5241431an92f48de21c9af7af@mail.gmail.com>
	 <20100220024814.GA32053@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
	linux-crypto@vger.kernel.org,
	"David S. Miller" <davem@davemloft.net>,
	Benjamin Gilbert <bgilbert@cs.cmu.edu>,
	linux-kernel@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-bw0-f209.google.com ([209.85.218.209]:64255 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753004Ab0BTK0s (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sat, 20 Feb 2010 05:26:48 -0500
In-Reply-To: <20100220024814.GA32053@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Sat, Feb 20, 2010 at 03:48, Herbert Xu <herbert@gondor.apana.org.au> wrote:

>> In this case, please hold seed, tcrypt, wp512 & xcbc. I will
>> refactor them.
>
> OK.

Another workflow question:
Does LKML as a whole prefer rebased patches, patches on top of the
old one or does not one care as long as it's clear what to apply in what
order?
Or does everyone have a different opionion, in which case: What is
yours?


> Thanks for checking.

No need to thank me. You decide what goes in and I accept that.
I signed up to weworking stuff until it suits the relevant maintainer
before I cloned the repo.


Richard
