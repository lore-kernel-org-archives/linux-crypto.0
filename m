From: Daniel Borkmann <dborkman@redhat.com>
Subject: Re: memset() in crypto code?
Date: Sun, 05 Oct 2014 12:33:50 +0200
Message-ID: <54311E8E.7000107@redhat.com>
References: <CACXcFmkQSZrQHqmcauAvpyexkjL5YpNKa-O0Or1VMuU4hawzkA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: linux-crypto@vger.kernel.org, herbert@gondor.apana.org.au,
	tytso@mit.edu, hannes@stressinduktion.org, gmazyland@gmail.com,
	julia.lawall@lip6.fr
To: Sandy Harris <sandyinchina@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:59278 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751327AbaJEKeK (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Sun, 5 Oct 2014 06:34:10 -0400
In-Reply-To: <CACXcFmkQSZrQHqmcauAvpyexkjL5YpNKa-O0Or1VMuU4hawzkA@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Sandy,

On 10/05/2014 05:09 AM, Sandy Harris wrote:
> There was recently a patch to the random driver to replace memset()
> because, according to the submitter, gcc sometimes optimises memset()
> away which might leave data unnecessarily exposed. The solution
> suggested was a function called memzero_explicit(). There was a fair
> bit of discussion and the patch was accepted.
>
> In the crypto directory of the kernel source I have:
>
> $ grep memset *.c | wc -l
> 133
> $
>
> I strongly suspect some of these should be fixed.

I have submitted it here one month ago for crypto and it's still
awaiting to be applied:

   http://www.spinics.net/lists/linux-crypto/msg11965.html

As the random driver patch has been applied to random -dev, it will be
available from 3.18 onwards, but the dependency for crypto is currently
there, that's why I asked Ted to take it through his tree; hopefully
this will happen soonish (but I haven't heard anything back ever since) ...

Thanks!

Daniel
