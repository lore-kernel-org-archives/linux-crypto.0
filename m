From: Sandy Harris <sandyinchina@gmail.com>
Subject: Re: [Cryptography] Randomness for crypto, github repositories
Date: Wed, 21 Oct 2015 13:28:08 -0400
Message-ID: <CACXcFm=Fa1OkM7atPfzC6GXFxL64JBB9kX9EN1eV-i=u5ziTqQ@mail.gmail.com>
References: <CACXcFmkg_YMdxr59rHxqskSj1__6-ooakyCWxe8rXsjyOu+6Mg@mail.gmail.com>
	<ce4305849b5abc370afd5336d2328a73.squirrel@www.deadhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-crypto@vger.kernel.org,
	Cryptography <cryptography@metzdowd.com>
To: rng@lists.bitrot.info
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-io0-f180.google.com ([209.85.223.180]:34900 "EHLO
	mail-io0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751404AbbJUR2I (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 21 Oct 2015 13:28:08 -0400
Received: by iofz202 with SMTP id z202so65021635iof.2
        for <linux-crypto@vger.kernel.org>; Wed, 21 Oct 2015 10:28:08 -0700 (PDT)
In-Reply-To: <ce4305849b5abc370afd5336d2328a73.squirrel@www.deadhat.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Oct 21, 2015 at 1:06 PM,  <dj@deadhat.com> wrote:

> I've only looked at it briefly, but I have a question.. Are you trying to
> use the GCM Galois multiply as an entropy extractor?

Yes, the basic idea is to use a series of GCM multiplies over the pool
data to replace the hashing of that data in the current driver. There
are complications; each hash uses two quasi-constants -- initialiser
and GCM multiplier -- and hashes a counter along with the pool data.
The counter changes on every iteration and is sometimes changed more
drastically, and the constants are sometimes updated

> I don't know of any proof that it is a good extractor for any class of
> entropic data. That doesn't mean there isn't one, but I've not heard of
> one.

Good question. It seems to me th at if it is secure for its
authentication usage, where it replaces an HMAC, then it should be
safe in this application. But no, I don't have a proof & the question
is worth some analysis.
