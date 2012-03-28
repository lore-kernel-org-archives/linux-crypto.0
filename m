From: Sebastien Agnolini <sebastien.agnolini@gmail.com>
Subject: Old PADATA patch vs crypto-2.6 tree
Date: Wed, 28 Mar 2012 13:53:41 +0200
Message-ID: <CAFB-WE9o5TDZrxiFz=Lbe=87XdcHw4wEcEwtC3FKJ_DR2_MYCA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:41576 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752297Ab2C1Lxl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 28 Mar 2012 07:53:41 -0400
Received: by pbcun15 with SMTP id un15so1687749pbc.19
        for <linux-crypto@vger.kernel.org>; Wed, 28 Mar 2012 04:53:41 -0700 (PDT)
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hey,

How activate the IPsec parallelization ?
I compiled the crypto-2.6 kernel with this param :
CONFIG_CRYPTO_... =3D y
CONFIG_PADATA =3D y
CONFIG_SMP=3Dy
After installation on 2 servers (IPSEC tunnel), i don't detect the IPse=
c
parallelization.
The algorithm is loaded (present in /proc/crypto), but only one core wo=
rks.

So, What are the other parameters that I forgot for the compilation of =
the
kernel? IRQ, IO, Scheduler parameters... Am i missing something ?
I thought that the parallelization was automatically started. True ?
What are the conditions to observe a parallel work ?
A "little" documentation will be Welcome.

I'd like compare the bandwidth of my test platform using the =AB old =BB=
 PADATA
patch.

Sebastien
