From: Sandy Harris <sandyinchina@gmail.com>
Subject: RFC possible changes for Linux random device
Date: Mon, 15 Sep 2014 20:40:35 -0400
Message-ID: <CACXcFmnWUOBO-_MhMKUEY1xB1Tk4fSUrvfkmwCQicJSELqa8XA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wi0-f174.google.com ([209.85.212.174]:46889 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757832AbaIPAkg (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 15 Sep 2014 20:40:36 -0400
Received: by mail-wi0-f174.google.com with SMTP id n3so5322555wiv.1
        for <linux-crypto@vger.kernel.org>; Mon, 15 Sep 2014 17:40:35 -0700 (PDT)
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

I have started a thread with the above title on Perry's crypto list. Archive at:
http://www.metzdowd.com/pipermail/cryptography/2014-September/022795.html

First message was:

I have some experimental code to replace parts of random.c It is not
finished but far enough along to seek comment. It does compile with
either gcc or clang, run and produce reasonable-looking results but is
not well-tested. splint(1) complains about parts of it, but do not
think it is indicating any real problems.

Next two posts will be the main code and a support program it uses.

I change nothing on the input side; the entropy collection and
estimation parts of existing code are untouched. The hashing and
output routines, though, are completely replaced, and much of the
initialisation code is modified.

It uses the 128-bit hash from AES-GCM instead of 160-bit SHA-1.
Changing the hash allows other changes. One design goal was improved
decoupling so that heavy use of /dev/urandom does not deplete the
entropy pool for /dev/random. Another was simpler mixing in of
additional data in various places.
