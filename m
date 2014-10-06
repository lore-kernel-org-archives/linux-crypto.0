From: Sandy Harris <sandyinchina@gmail.com>
Subject: Re: memset() in crypto code?
Date: Mon, 6 Oct 2014 14:52:22 -0400
Message-ID: <CACXcFmmNfgtHjwX7kJP8EKR01AMi-yujTZ55oTghJ7+J-eSzDA@mail.gmail.com>
References: <CACXcFmkQSZrQHqmcauAvpyexkjL5YpNKa-O0Or1VMuU4hawzkA@mail.gmail.com>
	<20141006174403.GB14468@titan.lakedaemon.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: Jason Cooper <jason@lakedaemon.net>, linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-ie0-f182.google.com ([209.85.223.182]:51379 "EHLO
	mail-ie0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753180AbaJFSwX (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 6 Oct 2014 14:52:23 -0400
Received: by mail-ie0-f182.google.com with SMTP id rp18so3931882iec.27
        for <linux-crypto@vger.kernel.org>; Mon, 06 Oct 2014 11:52:22 -0700 (PDT)
In-Reply-To: <20141006174403.GB14468@titan.lakedaemon.net>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, Oct 6, 2014 at 1:44 PM, Jason Cooper <jason@lakedaemon.net> wrote:

> On Sat, Oct 04, 2014 at 11:09:40PM -0400, Sandy Harris wrote:

>> There was recently a patch to the random driver to replace memset()
>> because, according to the submitter, gcc sometimes optimises memset()
>> away ...

> memzero_explicit() is a good start, ...

As I see it, memzero_explicit() is a rather ugly kluge, albeit an
acceptable one in the circumstances.

A real fix would make memset() do the right thing reliably; if the
programmer puts in memset( x, 0, nbytes) then the memory should be
cleared, no ifs or buts. I do not know or care if that means changes
in the compiler or in the library code or even both, but the fix
should make the standard library code work right, not require adding a
new function and expecting everyone to use it.
