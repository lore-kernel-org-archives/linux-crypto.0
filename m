From: satpal parmar <systems.satpal@gmail.com>
Subject: Openswan IPsec: ARM cortex SoC board to board ping works but board to
 Ubuntu does not
Date: Fri, 2 Mar 2012 16:11:18 +0530
Message-ID: <CAGgcXb7dMetJ0OS498X9Fn3Py6OAfWhN2j+kA1HzyJFzbfJ_tg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: users@openswan.org, linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-pw0-f46.google.com ([209.85.160.46]:52169 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753048Ab2CBKlT (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 2 Mar 2012 05:41:19 -0500
Received: by pbcup15 with SMTP id up15so2001293pbc.19
        for <linux-crypto@vger.kernel.org>; Fri, 02 Mar 2012 02:41:18 -0800 (PST)
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi All !

I recently ported Openswan on ARM cortex based SOC running linux
2.6.37 (ipsec netkey stack) and openswan 2.6.23. On this board I have
H/W accelerator support for AES/DES/SHA.
(http://processors.wiki.ti.com/index.php/Installing_AM387x_C6A814x_DM814x_Crypto_Support).
AES/DES crypto operation are working fine and I am able to ping
through IPsec tunnel from my board to PC and vice versa. However when
I am trying ping with SHA-MD5 I am not able to ping  to and from
Ubuntu machine .

My ubuntu machine details:
root@vnl-desktop:~# uname -a
Linux vnl-desktop 2.6.32-33-generic #72-Ubuntu SMP Fri Jul 29 21:08:37
UTC 2011 i686 GNU/Linux

MYost probably it could be a IPsec configuration issue on Ubuntu
machine but I am not able to locate  what configuration could affect
behavior of only one crypto algorithm. Since I am using same
configuration for IPsec for testing all Crypto algo supported in H/W
(DES/AES/SHA-MD5 )and  I am successfully able to ping through IPSec
tunnel for DES and AES.

Just wondering if any one came across any such issue before. Do we
have separate config for SHA-MD5?

Appreciate any help /pointer reagrading this issue.

-SP
