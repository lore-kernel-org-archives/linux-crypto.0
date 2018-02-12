From: Jitendra Lulla <lulla.jitendra@gmail.com>
Subject: hashing bit oriented messages
Date: Mon, 12 Feb 2018 11:48:20 +0530
Message-ID: <CAEux+EMLLZVj3nA31nHAtFica2HTdSAb=E=7g6WR3z45sXoZ8g@mail.gmail.com>
Reply-To: lullajd@yahoo.com
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-crypto <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-ua0-f179.google.com ([209.85.217.179]:32959 "EHLO
        mail-ua0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751105AbeBLGSl (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 12 Feb 2018 01:18:41 -0500
Received: by mail-ua0-f179.google.com with SMTP id p12so8812528uad.0
        for <linux-crypto@vger.kernel.org>; Sun, 11 Feb 2018 22:18:41 -0800 (PST)
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi,

the following NIST link has test vectors for SHA1/2/3.
https://csrc.nist.gov/projects/cryptographic-algorithm-validation-program/secure-hashing

They have test vectors for bit oriented messages also e.g. a message
of 7 bits for example. [grep "Bit-Oriented" on the page, bottom of the
page]

Some sw implementations do support computing SHA* on such messages
which are not byte aligned.

e.g. libdigest-sha3-perl and  libdigest-sha-perl  (tried on Ubuntu)
Some example runs at the bottom of this mail.

I have following queries, could anybody please help me with them:

1. When would one want to compute digests on such messages eg. a 7 bit
message or a 133 bit message? Any practical use case?
2. testmgr.h doesnt have tests for such messages. Does linux kernel
crypto framework support it or have plans for it?
3. Does any fips certification mandate bit-oriented tests to pass ?

thanks
Jitendra

example invocations:
jlulla@ubuntu:~/Link to progs$ perl -e "print qq(1)" | sha3sum -0 -a 224
6f2fc54a6b11a6da611ed734505b9cab89eecc1dc7dd2debd27bd1c9 ^-

jlulla@ubuntu:~/Link to progs$ perl -e "print qq(011)" | shasum -0 -a 256
1f7794d4b0b67d3a6edcd17aba2144a95828032f7943ed26bf0c7c7628945f48 ^-


jlulla@ubuntu:~/Link to progs$ perl -e "print qq(1101110)" | shasum -0 -a 256
83e848e33f2aec12959a5de8232989ee09e7841f9f031147a651d286e8c7218e ^-

perl -e "print qq(0001100)" | sha3sum -0 -a 384
b5a8cb0bf073b6b68d95cd33f5b09289670120bb931fc838b830d2592268b9e145a09088172b96eafb0093ef9a85df08
^-
