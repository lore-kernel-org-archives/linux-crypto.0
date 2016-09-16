From: Cata Vasile <cata.vasile@nxp.com>
Subject: crypto: caam from tasklet to threadirq
Date: Fri, 16 Sep 2016 14:01:00 +0000
Message-ID: <DB5PR04MB1302AD00536D2E37E726E104EEF30@DB5PR04MB1302.eurprd04.prod.outlook.com>
References: <DB5PR04MB130229BBD433C8FF7BDD975FEEF90@DB5PR04MB1302.eurprd04.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Cc: Horia Geanta Neag <horia.geanta@nxp.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
To: "rmk+kernel@armlinux.org.uk" <rmk+kernel@armlinux.org.uk>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-db5eur01on0070.outbound.protection.outlook.com ([104.47.2.70]:23872
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1757736AbcIPPfD (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 16 Sep 2016 11:35:03 -0400
In-Reply-To: <DB5PR04MB130229BBD433C8FF7BDD975FEEF90@DB5PR04MB1302.eurprd04.prod.outlook.com>
Content-Language: en-US
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi,

We've tried to test and benchmark your submitted work[1].

Cryptographic offloading is also=A0used in IPsec in the Linux Kernel. In he=
avy traffic scenarios, the NIC driver competes with the crypto device drive=
r. Most NICs use the NAPI context, which is one of the most prioritized con=
text types. In IPsec scenarios  the performance is trashed because, althoug=
h raw data gets in to device, the data is encrypted/decrypted and=A0the deq=
ueue code in CAAM driver has a hard time being scheduled to actually call t=
he callback to notify the networking stack it can continue working=A0with  =
that data.

Being this scenario, at heavy load, the Kernel warns on=A0rcu stalls and th=
e forwarding path has a lot of latency.
Have you tried benchmarking the board you used for testing?

I have ran some on our other platforms. The after benchmark fails to run at=
 the top level of the before results. The rcu stall does not always stall i=
n the same place. The after ping latency is greater, and oscillates a lot.

It might be a good idea for the codebase to change to a threadirq, but from=
 a pragmatic perspective, the whole system has to suffer. That is one the r=
easons most crypto accelerators try to run dequeue primitives in high prior=
ity contexts.


Regards,
Catalin Vasile


[1]=A0https://git.kernel.org/cgit/linux/kernel/git/herbert/cryptodev-2.6.gi=
t/commit/?id=3D66d2e2028091a074aa1290d2eeda5ddb1a6c329c
     =
