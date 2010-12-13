From: Tobias Karnat <tobias.karnat@googlemail.com>
Subject: Re: Crypto Hardware Drivers?
Date: Mon, 13 Dec 2010 18:43:23 +0100
Message-ID: <1292262203.18430.22.camel@Tobias-Karnat>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: linux-crypto@vger.kernel.org
To: Kent Borg <kentborg@borg.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:52640 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758528Ab0LMRn2 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 13 Dec 2010 12:43:28 -0500
Received: by wwa36 with SMTP id 36so6578592wwa.1
        for <linux-crypto@vger.kernel.org>; Mon, 13 Dec 2010 09:43:27 -0800 (PST)
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi,

In case it is based on TI OMAP, there are already drivers available:

OMAP SHA1/MD5 driver:
http://marc.info/?l=linux-crypto-vger&m=127246431212905&w=2
http://marc.info/?l=linux-crypto-vger&m=129017544602970&w=2

OMAP2/3 AES HW accelerator driver:
http://marc.info/?l=linux-crypto-vger&m=128231192601283&w=2
http://marc.info/?l=linux-crypto-vger&m=129110479321959&w=2

However the OMAP's are supposed to also support DES/3DES acceleration,
in case my guess was right, do you can think of writing a driver for it?

-Tobias
