From: Daniel Borkmann <dborkman@redhat.com>
Subject: Re: [PATCH] crypto: memzero_explicit - make sure to clear out sensitive
 data
Date: Sun, 07 Sep 2014 21:53:11 +0200
Message-ID: <540CB7A7.6070505@redhat.com>
References: <1410108360-15363-1-git-send-email-dborkman@redhat.com> <540C9295.8070409@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Cc: herbert@gondor.apana.org.au, tytso@mit.edu,
	hannes@stressinduktion.org, linux-crypto@vger.kernel.org,
	Julia Lawall <julia.lawall@lip6.fr>,
	device-mapper development <dm-devel@redhat.com>
To: Milan Broz <gmazyland@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:1541 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751368AbaIGTyG (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Sun, 7 Sep 2014 15:54:06 -0400
In-Reply-To: <540C9295.8070409@gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Milan,

On 09/07/2014 07:15 PM, Milan Broz wrote:
> On 09/07/2014 06:46 PM, Daniel Borkmann wrote:
>> Recently, in commit 13aa93c70e71 ("random: add and use memzero_explicit()
>> for clearing data"), we have found that GCC may optimize some memset()
>> cases away when it detects a stack variable is not being used anymore
>> and going out of scope. This can happen, for example, in cases when we
>> are clearing out sensitive information such as keying material or any
>> e.g. intermediate results from crypto computations, etc.
>
> Hi,
>
> do you plan to send patches also for other crypto code in kernel?
> (I am almost sure we have the same pattern in dmcrypt.)
>
> If not, I can do this for the dmcrypt part.

Yes, please feel free and go ahead.

I have checked random driver, crypto and networking subsystem. With this
patch that I've sent here, these three are covered (in networking, there
was no such candidate, just one false positive in Bluetooth). But if you
find other areas with a similar case, feel free to go ahead and fix it,
very much appreciated.

Thanks & best,
Daniel

> Milan
>
