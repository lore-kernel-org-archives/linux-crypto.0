From: Sandy Harris <sandyinchina@gmail.com>
Subject: Re: memset() in crypto code?
Date: Mon, 6 Oct 2014 13:59:06 -0400
Message-ID: <CACXcFmmv2hKaVNS3hok6V=7VmrqTMF1_Pn2z0e31dd_YywBfKQ@mail.gmail.com>
References: <CACXcFmkQSZrQHqmcauAvpyexkjL5YpNKa-O0Or1VMuU4hawzkA@mail.gmail.com>
	<20141006174403.GB14468@titan.lakedaemon.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: Jason Cooper <jason@lakedaemon.net>, linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-ig0-f181.google.com ([209.85.213.181]:47261 "EHLO
	mail-ig0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753065AbaJFR7H (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 6 Oct 2014 13:59:07 -0400
Received: by mail-ig0-f181.google.com with SMTP id r10so3215239igi.14
        for <linux-crypto@vger.kernel.org>; Mon, 06 Oct 2014 10:59:06 -0700 (PDT)
In-Reply-To: <20141006174403.GB14468@titan.lakedaemon.net>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, Oct 6, 2014 at 1:44 PM, Jason Cooper <jason@lakedaemon.net> wrote:

> On Sat, Oct 04, 2014 at 11:09:40PM -0400, Sandy Harris wrote:
>> There was recently a patch to the random driver to replace memset()
>> because, according to the submitter, gcc sometimes optimises memset()
>> away which might leave data unnecessarily exposed. The solution
>> suggested was a function called memzero_explicit(). There was a fair
>> bit of discussion and the patch was accepted.
>
> Do you have a pointer?

https://lkml.org/lkml/2014/8/25/497
