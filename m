From: Daniel Borkmann <dborkman@redhat.com>
Subject: Re: memset() in crypto code?
Date: Mon, 06 Oct 2014 21:02:02 +0200
Message-ID: <5432E72A.3070309@redhat.com>
References: <CACXcFmkQSZrQHqmcauAvpyexkjL5YpNKa-O0Or1VMuU4hawzkA@mail.gmail.com> <20141006174403.GB14468@titan.lakedaemon.net> <CACXcFmmNfgtHjwX7kJP8EKR01AMi-yujTZ55oTghJ7+J-eSzDA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Jason Cooper <jason@lakedaemon.net>, linux-crypto@vger.kernel.org,
	hannes@stressinduktion.org
To: Sandy Harris <sandyinchina@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:11931 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753011AbaJFTCL (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Mon, 6 Oct 2014 15:02:11 -0400
In-Reply-To: <CACXcFmmNfgtHjwX7kJP8EKR01AMi-yujTZ55oTghJ7+J-eSzDA@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 10/06/2014 08:52 PM, Sandy Harris wrote:
> On Mon, Oct 6, 2014 at 1:44 PM, Jason Cooper <jason@lakedaemon.net> wrote:
>> On Sat, Oct 04, 2014 at 11:09:40PM -0400, Sandy Harris wrote:
...
>>> There was recently a patch to the random driver to replace memset()
>>> because, according to the submitter, gcc sometimes optimises memset()
>>> away ...
>
>> memzero_explicit() is a good start, ...
>
> As I see it, memzero_explicit() is a rather ugly kluge, albeit an
> acceptable one in the circumstances.

Right.

> A real fix would make memset() do the right thing reliably; if the
> programmer puts in memset( x, 0, nbytes) then the memory should be
> cleared, no ifs or buts. I do not know or care if that means changes
> in the compiler or in the library code or even both, but the fix
> should make the standard library code work right, not require adding a
> new function and expecting everyone to use it.

That would be a desirable goal, ideally perhaps as a built-in from
the compiler itself, just as memset(). Applications such as openssh
implement for the very same purpose their bzero_explicit() variant
just as well.
