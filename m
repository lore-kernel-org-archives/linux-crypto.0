From: Michael Bohn <bohn75@googlemail.com>
Subject: hifn_795x module on a 64 bit system
Date: Sat, 27 Feb 2010 15:04:13 +0100
Message-ID: <da90d1f21002270604q771dfacj28071771bca33ebe@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-fx0-f219.google.com ([209.85.220.219]:43571 "EHLO
	mail-fx0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S968340Ab0B0OEP (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sat, 27 Feb 2010 09:04:15 -0500
Received: by fxm19 with SMTP id 19so970687fxm.21
        for <linux-crypto@vger.kernel.org>; Sat, 27 Feb 2010 06:04:13 -0800 (PST)
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hello
is there a way to use the hifn_795x  module on a 64 bit system. ( with
4GB  RAM ) ?

I get this error message if I try to load this module.


# modprobe hifn_795x

FATAL: Error inserting hifn_795x
(/lib/modules/2.6.32-gentoo-r6/kernel/drivers/crypto/hifn_795x.ko):
Invalid argument

# dmesg  | grep -i hifn

[    3.466307] HIFN supports only 32-bit addresses.

[ 1147.645181] HIFN supports only 32-bit addresses.




Thanks in advance for the reply.


Michael
