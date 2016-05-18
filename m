From: Denis B <begun.denis@gmail.com>
Subject: IV generation in cryptographic driver in AEAD
Date: Wed, 18 May 2016 15:06:19 +0300
Message-ID: <CADREXso6P503yNN93zcsU2LQFsKtFhWw3x3SuP_F=F2R6snRUw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-vk0-f51.google.com ([209.85.213.51]:34615 "EHLO
	mail-vk0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751667AbcERMGU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 18 May 2016 08:06:20 -0400
Received: by mail-vk0-f51.google.com with SMTP id c189so58007254vkb.1
        for <linux-crypto@vger.kernel.org>; Wed, 18 May 2016 05:06:20 -0700 (PDT)
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hello,

In AEAD mode (or in any case, in IPSec ESP IPv4 =E2=80=93 esp4.c), in k=
ernel
versions prior to 4.2 the cryptographic driver is expected to generate
an IV.

What if my driver is unable to generate an IV?

Thanks,
Dennis.
