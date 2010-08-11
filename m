From: Linus Walleij <linus.walleij@stericsson.com>
Subject: Re: [PATCH 0/4] RFC: "New" /dev/crypto user-space interface
Date: Wed, 11 Aug 2010 08:50:25 +0200
Message-ID: <AANLkTi=K_UtN6=7WXELfkZYOUGMdmiZv-nGM9OCmuowd@mail.gmail.com>
References: <1281039477-29703-1-git-send-email-mitr@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Herbert Xu <herbert@gondor.hengli.com.au>,
	Neil Horman <nhorman@redhat.com>,
	Nikos Mavrogiannopoulos <n.mavrogiannopoulos@gmail.com>,
	linux-crypto@vger.kernel.org
To: =?ISO-8859-2?Q?Miloslav_Trma=E8?= <mitr@redhat.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-qw0-f46.google.com ([209.85.216.46]:58087 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751898Ab0HKGu2 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 11 Aug 2010 02:50:28 -0400
Received: by qwh6 with SMTP id 6so9137975qwh.19
        for <linux-crypto@vger.kernel.org>; Tue, 10 Aug 2010 23:50:27 -0700 (PDT)
In-Reply-To: <1281039477-29703-1-git-send-email-mitr@redhat.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Miloslav,

first, thanks a lot for working on the userspace API, we have long missed this
API and I've asked some times in the past about the status and proposals have
been stalled some times, so it is really fun to see that something is happening!

We recognize that since Redhat is providing hardware for governments, this
work will likely continue until the desired mechanism is available in a form
that can be integrated and shipped, which gives great confidence that it is
going to happen this time.

At ST-Ericsson we have considered to provide a user API to the kernel crypto
facilities as well, we have some rough initial ideas on how to go about this.
It has some similarities to what you/Redhat has presented, but we have some
further goals:

1. We'd like the API have to be general enough to not change with new
   algorithms. Having to recompile user space programs becasuse of a minor
   change is messing things up for us. This may be solved by a
   functionality which presents the available crypto resources in the
   user API. (As opposed to using enums for the algorithms.)

   c.f how the ALSA mixer presents a lot of things to userspace without
   using any enums at all in /dev/snd/controlC0 for card 0. For example
   in include/linux/soundcard.h you find the different control knobs
   enumerated with strings so as to avoid explicit enums.

   We'd try to avoid as many enums as possible, and really only define
   the necessary information nodes so that userspace can look for
   strings like "aes-plain" instead, which is the same that dmcrypt
   is using, and there are already descriptions of available algorithms
   in /proc/crypto (from crypto/proc.c) using this format.

2. To avoid security hazards the API would benefit from being programmed
   with at least some secure programming concepts in mid. Input argument
   checking separate from algorithm separate from output argument checking,
   and erasing of information from stacks and buffers. More or less
   the advice you will find in places like:
   http://www.dwheeler.com/secure-programs/

   (Evidently we and others will help out reviewing and patching up
   proposed code in this aspect, also since you're working on
   government business I believe security audits will be mandatory?)

   For internal keys, a function for compare of HMAC function results
   could improve security considerably.

3. A general interface for stream ciphers would be nice. The only differences
   are that they do not operate on blocks, but bits, and that they
always require
   an IV. Arguably this can be added later if the aspect if just considered when
   devising the interface. The recent discussion in this thread
regarding netlink
   points in a direction where streams are a natural part of the concept I
   believe.

There are some submission-related comments as well:

- The API description in the commit log of patch 1 should be a file in
  Documentation/crypto/usespace-api.txt or so instead, this is of general
  interest.

- The big patch 0002 to crypto/userspace is including the Makefile
  changes for patch 0004 making it non-bisectable. Also it is very large,
  is it possible to break it down a little? Many files are prefixed "ncr-*"
  and I don't see why - can this prefix simply be removed?

  I hope the patch 0004 with software fallbacks is not strictly required
  by the userspace API so these two can be considered separately?
  Else can you describe how the dependecies go.. surely  it must be
  possible to patch in the software fallbacks in libtom* separately?

- The big patch containing the entire libtomcrypt should be destined to
  drivers/staging or similar at this point (OK it is not a driver, should have
  been lib/staging if such a thing existed). The sheer size of it makes it very
  hard to review, and all attempts at breaking it in smaller pieces would
  be much appreciated. For example is it possible to have one patch per
  algorithm?

  Also: isn't this creating a fork of the library? Not that it matters much as
  Linux is finding good use of it.

  Since it is a fork, it should be adopted to the Linux source hiearchy, and
  since here every algorithm is directly in crypto/ please remove all the
  libtomcrypt subdir and put all directly into crypto/ for simplicity (subdirs
  below like hashes, headers etc are nice and should be preserved though).

  libtomath seems to be duplicating a lot of in-kernel stuff already found
  inside the kernel, and needs to be merged with care. Arguably parts of
  this can be cleaned-up later but it'd be nice to make some initial attempts
  at unifying the math infrastructure.

Overall, thanks for working on this.

Yours,
Linus Walleij (et al)
