From: "Tan Swee Heng" <thesweeheng@gmail.com>
Subject: Problems encountered with latest cryptodev-2.6 under UML
Date: Sun, 2 Dec 2007 23:59:51 +0800
Message-ID: <fd3e431c0712020759tbc41c91o39c0c3e56be66734@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: "Herbert Xu" <herbert@gondor.apana.org.au>
To: "Linux Crypto" <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rn-out-0910.google.com ([64.233.170.188]:24594 "EHLO
	rn-out-0102.google.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751103AbXLBP7x (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sun, 2 Dec 2007 10:59:53 -0500
Received: by rn-out-0102.google.com with SMTP id i6so2064260rng
        for <linux-crypto@vger.kernel.org>; Sun, 02 Dec 2007 07:59:51 -0800 (PST)
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi all, in the past week I've been having problems with the latest
cryptodev-2.6 tree under UML. One was resolved; but 2 wasn't.

PROBLEM ONE: Compilation
When compiling, I get

    In file included from include2/asm/rwsem.h:4,
                     from /var/tmp/uml/cryptodev-2.6/include/linux/rwsem.h:24,
    ... <snipped> ...
    include/asm/arch/rwsem.h:165: error: 'struct cpuinfo_um' has no
member named 'x86'

I wasn't alone, as this post showed:
<http://www.mail-archive.com/linux-kernel@vger.kernel.org/msg233332.html>.
Thankfully that post mentioned the patch at
<http://lkml.org/lkml/2007/11/19/220> which resolved it.

PROBLEM TWO: setkey()
After compilation I was able to run UML. But "modprobe tcrypt mode=3"
gave the following error:

    ... snipped...
    testing cbc(des) encryption
    test 1 (64 bit key):
    setkey() failed flags=200000

    testing cbc(des) decryption
    test 1 (64 bit key):
    setkey() failed flags=200000


PROBLEM THREE: Unable to remove chainiv
Once loaded, chainiv could not be removed. For example:

    [root@localhost ~]# lsmod
    Module                  Size  Used by
    cbc                     3392  0
    des_generic            16480  0
    ecb                     2496  0
    chainiv                 2232  3
    crypto_blkcipher        8516  3 cbc,ecb,chainiv
    cryptomgr               2688  0
    crypto_algapi          11936  6
cbc,des_generic,ecb,chainiv,crypto_blkcipher,cryptomgr
    binfmt_misc             7816  1
    [root@localhost ~]# modprobe -r cbc des ecb
    [root@localhost ~]# lsmod
    Module                  Size  Used by
    chainiv                 2232  4
    crypto_blkcipher        8516  1 chainiv
    cryptomgr               2688  0
    crypto_algapi          11936  3 chainiv,crypto_blkcipher,cryptomgr
    binfmt_misc             7816  1
    [root@localhost ~]# modprobe -r chainiv
    FATAL: Module chainiv is in use.

Notice that the chainiv "Used by" field seems to be wrong.


Anyone else facing the same problems? I've resorted to rolling back to
19f4711b.... in the meantime but obviously this is not a long-term
solution. Would be glad if someone can point me in the right
directions to resolve these problems.

Swee Heng
