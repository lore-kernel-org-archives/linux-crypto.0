From: Sandy Harris <sandyinchina@gmail.com>
Subject: random(4) overheads question
Date: Mon, 26 Sep 2011 14:41:11 +0800
Message-ID: <CACXcFmmXrP4+1ZpG-vmda2agVCTKW7uMa08LLisTy+xfjzA04w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:42585 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750808Ab1IZGlM (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 26 Sep 2011 02:41:12 -0400
Received: by wwf22 with SMTP id 22so6292138wwf.1
        for <linux-crypto@vger.kernel.org>; Sun, 25 Sep 2011 23:41:11 -0700 (PDT)
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

I'm working on a demon that collects timer randomness, distills it
some, and pushes the results into /dev/random.

My code produces the random material in 32-bit chunks. The current
version sends it to /dev/random 32 bits at a time, doing a write() and
an entropy-update ioctl() for each chunk. Obviously I could add some
buffering and write fewer and larger chunks. My questions are whether
that is worth doing and, if so, what the optimum write() size is
likely to be.

I am not overly concerned about overheads on my side of the interface,
unless they are quite large. My concern is whether doing many small
writes wastes kernel resources.
