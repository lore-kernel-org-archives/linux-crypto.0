From: Sandy Harris <sandyinchina@gmail.com>
Subject: Fwd: maxwell RNG
Date: Sun, 31 Jul 2016 20:47:06 -0400
Message-ID: <CACXcFmnvXBVjx6GNE9JSUZTgT4JXhUzU_y2HZaYFOhhmhTLxKg@mail.gmail.com>
References: <CACXcFmmX=+hjwOM1voVh7dwcXyoek0KSPse=REEMDKa7LRHf9w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: "Theodore Ts'o" <tytso@mit.edu>, John Denker <jsd@av8n.com>,
	Stephan Mueller <smueller@chronox.de>,
	linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-vk0-f54.google.com ([209.85.213.54]:34955 "EHLO
	mail-vk0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750805AbcHAArI (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sun, 31 Jul 2016 20:47:08 -0400
Received: by mail-vk0-f54.google.com with SMTP id w127so89082536vkh.2
        for <linux-crypto@vger.kernel.org>; Sun, 31 Jul 2016 17:47:08 -0700 (PDT)
In-Reply-To: <CACXcFmmX=+hjwOM1voVh7dwcXyoek0KSPse=REEMDKa7LRHf9w@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Version 2 of my maxwell(8) rng is now at:
https://github.com/sandy-harris/maxwell

It is a fairly simple program to gather entropy from timer
fluctuations & feed results into the Linux random(4) device. Small
--only 600 lines so reasonably easy to audit -- cheap & effective.

It has not changed much since the original (2012) release. The main
changes now are a new interface (cleaner command-line option set) and
a variety of cleanups to both code & documentation.
