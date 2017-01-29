From: Arkadiusz Miskiewicz <a.miskiewicz@gmail.com>
Subject: 4.10 aesni-intel no longer having lrw/ablk_helper dependencies?
Date: Sun, 29 Jan 2017 22:31:59 +0100
Message-ID: <201701292231.59656.a.miskiewicz@gmail.com>
Reply-To: arekm@maven.pl
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-lf0-f53.google.com ([209.85.215.53]:33454 "EHLO
        mail-lf0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750755AbdA2VcD (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 29 Jan 2017 16:32:03 -0500
Received: by mail-lf0-f53.google.com with SMTP id x1so99145939lff.0
        for <linux-crypto@vger.kernel.org>; Sun, 29 Jan 2017 13:32:03 -0800 (PST)
Received: from xps.localnet (89-65-45-9.dynamic.chello.pl. [89.65.45.9])
        by smtp.gmail.com with ESMTPSA id 206sm3182076ljf.35.2017.01.29.13.32.00
        for <linux-crypto@vger.kernel.org>
        (version=TLS1 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Sun, 29 Jan 2017 13:32:00 -0800 (PST)
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi.

[arekm@xps ~]$ modinfo --set-version 4.9.6 aesni-intel | grep depends
depends:        glue_helper,aes-x86_64,lrw,cryptd,ablk_helper

[arekm@xps ~]$ modinfo --set-version  4.10.0-rc5-00161-gfd694aaa46c7 aesni-
intel |grep depends
depends:        glue_helper,aes-x86_64,crypto_simd,cryptd

With 4.10.0 lrw and ablk_helper are no longer in dependencies while
aesni-intel seem to still need these. My luks encrypted rootfs fails to=20
unlock. Initrd generation script only installs modules based on dependencie=
s=20
and that seems to be a reason for luks unlock failure with 4.10rc - some=20
missing modules.

=46ailure looks like that:
$ insmod path/to/aesni-intel.ko
dmesg gets logged:
"AVX2 version of gcm_enc/dec engaged
AES CTR mode by8 optimization enabled."
and insmod reports that it cannot insert aesni-intel because of unresolved=
=20
symbol or unknown option but nothing more is logged in dmesg.

4.9.x works fine.

What did change/how to figure out deps now?

Both modules exist:
[arekm@xps ~]$ modinfo --set-version  4.10.0-rc5-00161-gfd694aaa46c7 lrw
filename:       /lib/modules/4.10.0-rc5-00161-
gfd694aaa46c7/kernel/crypto/lrw.ko.xz
alias:          crypto-lrw
alias:          lrw
description:    LRW block cipher mode
license:        GPL
depends:        gf128mul
intree:         Y
vermagic:       4.10.0-rc5-00161-gfd694aaa46c7 SMP preempt mod_unload
signat:         PKCS#7
signer:
sig_key:
sig_hashalgo:   md4

[arekm@xps ~]$ modinfo --set-version  4.10.0-rc5-00161-gfd694aaa46c7=20
ablk_helper
filename:       /lib/modules/4.10.0-rc5-00161-
gfd694aaa46c7/kernel/crypto/ablk_helper.ko.xz
license:        GPL
depends:        cryptd
intree:         Y
vermagic:       4.10.0-rc5-00161-gfd694aaa46c7 SMP preempt mod_unload
signat:         PKCS#7
signer:
sig_key:
sig_hashalgo:   md4


=2D-=20
Arkadiusz Mi=C5=9Bkiewicz, arekm / ( maven.pl | pld-linux.org )
