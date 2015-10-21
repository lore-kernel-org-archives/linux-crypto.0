From: Sandy Harris <sandyinchina@gmail.com>
Subject: Randomness for crypto, github repositories
Date: Wed, 21 Oct 2015 12:01:58 -0400
Message-ID: <CACXcFmkg_YMdxr59rHxqskSj1__6-ooakyCWxe8rXsjyOu+6Mg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: rng@lists.bitrot.info, linux-crypto@vger.kernel.org,
	Cryptography <cryptography@metzdowd.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-io0-f170.google.com ([209.85.223.170]:35310 "EHLO
	mail-io0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752016AbbJUQB7 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 21 Oct 2015 12:01:59 -0400
Received: by iofz202 with SMTP id z202so62198093iof.2
        for <linux-crypto@vger.kernel.org>; Wed, 21 Oct 2015 09:01:58 -0700 (PDT)
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

I've just created github repositories for two projects:

https://github.com/sandy-harris/random.test

Test program for things I want to add to the Linux random(4) driver. I
am proposing a fairly radical rewrite. This gives an executable test
program for my new code, not a driver.

https://github.com/sandy-harris/maxwell

A demon to feed random(4) with entropy derived from the timer.
Intended mainly for use on limited systems which may lack other good
sources.
