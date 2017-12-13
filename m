From: Georg Sauthoff <mail@georg.so>
Subject: Encrypt selftest fails with qat_c3xxx
Date: Wed, 13 Dec 2017 20:27:58 +0100
Message-ID: <20171213192758.GA24992@dell12.lru.li>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
        Salvatore Benedetto <salvatore.benedetto@intel.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Pablo Marcos Oltra <pablo.marcos.oltra@intel.com>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: qat-linux@intel.com
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from escher.lru.li ([217.146.132.159]:56826 "EHLO escher.lru.li"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753130AbdLMThj (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 13 Dec 2017 14:37:39 -0500
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hello,

running Fedora 27 on an Intel Atom C3758 CPU Supermicro system
(A2SDi-8C+-HLN4F) I've noticed that crypto selftests fail when the
qat_c3xxx module is loaded (it is loaded, by default). That means that
stuff like `modprobe dm-crypt`, `cryptsetup benchmark` and `cryptsetup
luksOpen` fail.

The kernel log then contains the following messages:

alg: akcipher: encrypt test failed. err -22
alg: akcipher: test 1 failed for pkcs1pad(qat-rsa,sha256), err=-22

When I blacklist the qat_c3xxx/intel_qat modules the crypto works
as expected.

I can reproduce this issue with 4.14.3-300.fc27.x86_64,
kernel-4.13.16-302.fc27.x86_64 and kernel-4.13.9-300.fc27.x86-64.

See also my report in the Fedora bug tracker:

https://bugzilla.redhat.com/show_bug.cgi?id=1522962#c5

The loaded firmware has this checksum:

md5sum /lib/firmware/qat_c3xxx_mmp.bin
fb7deea913d87aed7676222269a593e6  /lib/firmware/qat_c3xxx_mmp.bin

Is this an issue with the driver, the firmware or does the QAT
co-processor need some additional setup?

Best regards
Georg
-- 
'(EE) Caught signal 11 (Segmentation fault). Server aborting
 (EE) Please also check the log file at "/dev/null" for additional information.'
(Fedora 21, gdm-Xorg)
