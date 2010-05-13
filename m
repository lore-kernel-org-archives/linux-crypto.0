From: Pedro Ribeiro <pedrib@gmail.com>
Subject: Best mode of operation for AES-128 on x86_64?
Date: Thu, 13 May 2010 01:07:21 +0100
Message-ID: <AANLkTikZrBQ8Va2oZAK-D1EVxt9wcniS5kf2W-GqcMWJ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-ew0-f216.google.com ([209.85.219.216]:44244 "EHLO
	mail-ew0-f216.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752048Ab0EMAHY (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 12 May 2010 20:07:24 -0400
Received: by ewy8 with SMTP id 8so366371ewy.28
        for <linux-crypto@vger.kernel.org>; Wed, 12 May 2010 17:07:22 -0700 (PDT)
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hello,

I'm currently using a LUKS volume which contains an encrypted LVM with
itself contains my root, home and swap partitions.

My processor is a core 2 duo 2.26ghz and I'm running x86_64. I'm using
cbc-essiv:sha256 and AES with 128 bit key.

I was wondering, is CBC mode the fastest?
I have a fast processor and can't really complain about the read/write
speed, but I was wondering if I could gain any speed from counter mode
or other mode.

I would also like to ask what are the real world speed gains when
using AES-NI? Can anyone please point me to some benchmarks, if there
are any?

Thank for the help,
Pedro
