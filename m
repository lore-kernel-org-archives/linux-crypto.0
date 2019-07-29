Return-Path: <SRS0=zv6R=V2=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7A233C7618B
	for <linux-crypto@archiver.kernel.org>; Mon, 29 Jul 2019 07:21:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5DADF21842
	for <linux-crypto@archiver.kernel.org>; Mon, 29 Jul 2019 07:21:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726840AbfG2HVn (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 29 Jul 2019 03:21:43 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:52929 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725917AbfG2HVn (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 29 Jul 2019 03:21:43 -0400
Received: by mail-wm1-f67.google.com with SMTP id s3so52777233wms.2;
        Mon, 29 Jul 2019 00:21:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=F8A+wJ9kuGKc1lY0KoBrqkMMH8t+4TAGTr5zwG14fGw=;
        b=F1VFRWI/FSRUE0c2wVr67UQruILjeBX7XH0hRJW5gi1Vfezyt4+PFyKLJwcrIVFPHg
         CRG7zDLpAjr0NNPN9tWoKiOLIwBDG5LTZqZ/tpSfK7LfDlFvZ0Uav/GA22QONdB8MfnS
         eK9Cm9d/8XxV26CGZdPvoqkYIN2TXpO+OelYoCSlzLWOiXdtbxia28kQsllHrrdzJS94
         mXC42h4Eq6i3NIKg5ZdMlnDxC4MsSy/BFD0xOeytiNMcO6YViXr0D11QDkYtYYSxsiAc
         4W7DUs3eaq/AR993Gl85NdiOfWNWkWv65jNctKwuAvd1ZbZfWO1CzSGQNSBXBe2XLg8R
         5Y7g==
X-Gm-Message-State: APjAAAULIB5Mulg2/qQXyyS4f7SQgkYfRk2wQ9IVcUZ2FzVWeT/7m3kS
        NT2m42ZiBm8SL1iJDotiTSxLurL/I4SvOAWNaIo=
X-Google-Smtp-Source: APXvYqyza07w5xJ62LL7Euv3oNrs9ipoRCD2TrufumAQPdufSc9TwOJ5QGI2N8XAiuGfUTevq9TvhZeSTW8CFlOk2Hk=
X-Received: by 2002:a1c:1f4e:: with SMTP id f75mr95425351wmf.137.1564384899174;
 Mon, 29 Jul 2019 00:21:39 -0700 (PDT)
MIME-Version: 1.0
References: <20190729070830.1.91742@1a45dae43dd5>
In-Reply-To: <20190729070830.1.91742@1a45dae43dd5>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Mon, 29 Jul 2019 09:21:26 +0200
Message-ID: <CAMuHMdVHTm=krp0wW_7RKVcyQWF-haTwwVCjNkfbU4b4RRR9Vw@mail.gmail.com>
Subject: crypto/aegis128-core.c:19:22: fatal error: asm/simd.h: No such file
 or directory
To:     Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Linux-Next <linux-next@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

---------- Forwarded message ---------
From: <noreply@ellerman.id.au>
Date: Mon, Jul 29, 2019 at 9:08 AM
Subject: kisskb: FAILED linux-next/m68k-allmodconfig/m68k Mon Jul 29, 17:00
To: <geert@linux-m68k.org>


FAILED linux-next/m68k-allmodconfig/m68k Mon Jul 29, 17:00

http://kisskb.ellerman.id.au/kisskb/buildresult/13898475/

Commit:   Add linux-next specific files for 20190729
          0d8b3265d9a6376b416b3ba86f758a5c6a85a6df
Compiler: m68k-linux-gcc (GCC) 4.6.3 / GNU ld (GNU Binutils) 2.22

Possible errors
---------------

crypto/aegis128-core.c:19:22: fatal error: asm/simd.h: No such file or directory
make[2]: *** [scripts/Makefile.build:274: crypto/aegis128-core.o] Error 1
make[1]: *** [Makefile:1079: crypto] Error 2
make: *** [Makefile:179: sub-make] Error 2

Possible warnings (115)
----------------------

WARNING: unmet direct dependencies detected for NEED_MULTIPLE_NODES
WARNING: unmet direct dependencies detected for NEED_MULTIPLE_NODES
WARNING: unmet direct dependencies detected for NEED_MULTIPLE_NODES
WARNING: unmet direct dependencies detected for NEED_MULTIPLE_NODES
<stdin>:1511:2: warning: #warning syscall clone3 not implemented [-Wcpp]
arch/m68k/mvme147/config.c:175:2: warning: #warning check me! [-Wcpp]
arch/m68k/mvme16x/config.c:440:2: warning: #warning check me! [-Wcpp]
arch/m68k/mvme16x/config.c:440:2: warning: #warning check me! [-Wcpp]
fs/afs/dynroot.c:124:6: warning: 'len' may be used uninitialized in
this function [-Wuninitialized]
kernel/printk/printk.c:194:16: warning: 'old' may be used
uninitialized in this function [-Wuninitialized]
drivers/base/regmap/regmap.c:2591:6: warning: 'ret' may be used
uninitialized in this function [-Wuninitialized]
drivers/base/regmap/regmap.c:1852:6: warning: 'ret' may be used
uninitialized in this function [-Wuninitialized]
fs/f2fs/file.c:3010:6: warning: 'err' may be used uninitialized in
this function [-Wuninitialized]
mm/memcontrol.c:1147:5: warning: value computed is not used [-Wunused-value]
include/linux/list.h:93:12: warning: 'head' may be used uninitialized
in this function [-Wuninitialized]
sound/hda/hdac_regmap.c:283:16: warning: 'err' may be used
uninitialized in this function [-Wuninitialized]
fs/btrfs/ref-verify.c:492:2: warning: 'ret' may be used uninitialized
in this function [-Wuninitialized]
fs/btrfs/ref-verify.c:545:2: warning: 'ret' may be used uninitialized
in this function [-Wuninitialized]
kernel/acct.c:177:2: warning: value computed is not used [-Wunused-value]
sound/soc/fsl/imx-audmix.c:302:45: warning: 'capture_dai_name' may be
used uninitialized in this function [-Wuninitialized]
sound/soc/codecs/arizona.c:1890:3: warning: 'aif_rx_state' may be used
uninitialized in this function [-Wuninitialized]
sound/soc/codecs/arizona.c:1887:3: warning: 'aif_tx_state' may be used
uninitialized in this function [-Wuninitialized]
drivers/block/paride/ppc6lnx.c:131:18: warning: cast to pointer from
integer of different size [-Wint-to-pointer-cast]
drivers/block/paride/ppc6lnx.c:142:3: warning: cast to pointer from
integer of different size [-Wint-to-pointer-cast]
drivers/block/paride/ppc6lnx.c:144:2: warning: cast to pointer from
integer of different size [-Wint-to-pointer-cast]
drivers/block/paride/ppc6lnx.c:145:2: warning: cast to pointer from
integer of different size [-Wint-to-pointer-cast]
drivers/block/paride/ppc6lnx.c:146:2: warning: cast to pointer from
integer of different size [-Wint-to-pointer-cast]
drivers/block/paride/ppc6lnx.c:147:2: warning: cast to pointer from
integer of different size [-Wint-to-pointer-cast]
drivers/block/paride/ppc6lnx.c:162:2: warning: cast to pointer from
integer of different size [-Wint-to-pointer-cast]
drivers/block/paride/ppc6lnx.c:201:2: warning: cast to pointer from
integer of different size [-Wint-to-pointer-cast]
drivers/block/paride/ppc6lnx.c:217:2: warning: cast to pointer from
integer of different size [-Wint-to-pointer-cast]
drivers/block/paride/ppc6lnx.c:235:4: warning: cast to pointer from
integer of different size [-Wint-to-pointer-cast]
drivers/block/paride/ppc6lnx.c:266:4: warning: cast to pointer from
integer of different size [-Wint-to-pointer-cast]
drivers/block/paride/ppc6lnx.c:329:11: warning: cast to pointer from
integer of different size [-Wint-to-pointer-cast]
drivers/block/paride/ppc6lnx.c:430:15: warning: cast to pointer from
integer of different size [-Wint-to-pointer-cast]
drivers/block/paride/ppc6lnx.c:537:5: warning: cast to pointer from
integer of different size [-Wint-to-pointer-cast]
drivers/block/paride/ppc6lnx.c:560:4: warning: cast to pointer from
integer of different size [-Wint-to-pointer-cast]
drivers/block/paride/ppc6lnx.c:575:6: warning: cast to pointer from
integer of different size [-Wint-to-pointer-cast]
fs/nfsd/nfs4xdr.c:2065:9: warning: 'str' may be used uninitialized in
this function [-Wuninitialized]
sound/soc/soc-pcm.c:1087:5: warning: 'ret' may be used uninitialized
in this function [-Wuninitialized]
sound/soc/soc-pcm.c:1105:9: warning: 'ret' may be used uninitialized
in this function [-Wuninitialized]
fs/ocfs2/alloc.c:7608:17: warning: 'first_bit' may be used
uninitialized in this function [-Wuninitialized]
fs/nfs/nfs3acl.c:44:2: warning: value computed is not used [-Wunused-value]
net/bridge/br_netlink.c:587:10: warning: 'err' may be used
uninitialized in this function [-Wuninitialized]
fs/ocfs2/file.c:2376:3: warning: value computed is not used [-Wunused-value]
sound/soc/codecs/da7219-aad.c:317:17: warning: 'pll_ctrl' may be used
uninitialized in this function [-Wuninitialized]
include/linux/list.h:65:12: warning: 'pdeo' may be used uninitialized
in this function [-Wuninitialized]
drivers/i2c/busses/i2c-sh_mobile.c:399:26: warning: 'data' may be used
uninitialized in this function [-Wuninitialized]
sound/soc/codecs/rt5665.c:2663:33: warning: 'val2' may be used
uninitialized in this function [-Wuninitialized]
sound/soc/codecs/rt5665.c:2660:33: warning: 'val1' may be used
uninitialized in this function [-Wuninitialized]
net/core/filter.c:3599:4: warning: value computed is not used [-Wunused-value]
lib/rbtree_test.c:220:18: warning: unused variable 'rb' [-Wunused-variable]
fs/posix_acl.c:148:3: warning: value computed is not used [-Wunused-value]
include/linux/via-core.h:192:2: warning: cast to pointer from integer
of different size [-Wint-to-pointer-cast]
include/linux/via-core.h:198:2: warning: cast to pointer from integer
of different size [-Wint-to-pointer-cast]
include/linux/via-core.h:206:2: warning: cast to pointer from integer
of different size [-Wint-to-pointer-cast]
drivers/input/joystick/analog.c:160:2: warning: #warning Precise timer
not defined for this architecture. [-Wcpp]
drivers/iommu/io-pgtable-arm-v7s.c:473:2: warning: 'cptep' may be used
uninitialized in this function [-Wuninitialized]
net/core/devlink.c:4443:6: warning: 'err' may be used uninitialized in
this function [-Wuninitialized]
drivers/iio/imu/bmi160/bmi160_core.c:618:3: warning: 'pin_name' may be
used uninitialized in this function [-Wuninitialized]
drivers/iio/imu/bmi160/bmi160_core.c:606:29: warning: 'int_map_mask'
may be used uninitialized in this function [-Wuninitialized]
drivers/iio/imu/bmi160/bmi160_core.c:599:29: warning: 'int_latch_mask'
may be used uninitialized in this function [-Wuninitialized]
drivers/iio/imu/bmi160/bmi160_core.c:577:47: warning:
'int_out_ctrl_shift' may be used uninitialized in this function
[-Wuninitialized]
drivers/hwmon/sch56xx-common.c:132:2: warning: cast to pointer from
integer of different size [-Wint-to-pointer-cast]
drivers/hwmon/smsc47b397.c:111:2: warning: cast to pointer from
integer of different size [-Wint-to-pointer-cast]
drivers/misc/altera-stapl/altera-lpt.c:20:2: warning: cast to pointer
from integer of different size [-Wint-to-pointer-cast]
drivers/misc/altera-stapl/altera-lpt.c:26:9: warning: cast to pointer
from integer of different size [-Wint-to-pointer-cast]
net/ncsi/ncsi-manage.c:672:19: warning: 'vid' may be used
uninitialized in this function [-Wuninitialized]
drivers/net/ethernet/8390/wd.c:289:4: warning: cast to pointer from
integer of different size [-Wint-to-pointer-cast]
drivers/net/ethernet/8390/wd.c:296:4: warning: cast to pointer from
integer of different size [-Wint-to-pointer-cast]
drivers/net/ethernet/8390/lib8390.c:201:12: warning: '__ei_open'
defined but not used [-Wunused-function]
drivers/net/ethernet/8390/lib8390.c:230:12: warning: '__ei_close'
defined but not used [-Wunused-function]
drivers/net/ethernet/8390/lib8390.c:254:13: warning: '__ei_tx_timeout'
defined but not used [-Wunused-function]
drivers/net/ethernet/8390/lib8390.c:300:20: warning: '__ei_start_xmit'
defined but not used [-Wunused-function]
drivers/net/ethernet/8390/lib8390.c:509:13: warning: '__ei_poll'
defined but not used [-Wunused-function]
drivers/net/ethernet/8390/lib8390.c:850:33: warning: '__ei_get_stats'
defined but not used [-Wunused-function]
drivers/net/ethernet/8390/lib8390.c:950:13: warning:
'__ei_set_multicast_list' defined but not used [-Wunused-function]
drivers/net/ethernet/8390/lib8390.c:988:27: warning:
'____alloc_ei_netdev' defined but not used [-Wunused-function]
net/mac80211/mlme.c:1576:3: warning: 'pwr_level_cisco' may be used
uninitialized in this function [-Wuninitialized]
drivers/mfd/rk808.c:732:12: warning: 'rk8xx_suspend' defined but not
used [-Wunused-function]
drivers/mfd/rk808.c:752:12: warning: 'rk8xx_resume' defined but not
used [-Wunused-function]
drivers/media/platform/fsl-viu.c:36:0: warning: "out_be32" redefined
[enabled by default]
drivers/media/platform/fsl-viu.c:37:0: warning: "in_be32" redefined
[enabled by default]
drivers/net/wireless/broadcom/b43/phy_n.c:190:21: warning: 'val_addr'
may be used uninitialized in this function [-Wuninitialized]
drivers/soc/qcom/rpmh.c:355:6: warning: 'ret' may be used
uninitialized in this function [-Wuninitialized]
drivers/media/usb/dvb-usb/pctv452e.c:918:2: warning: value computed is
not used [-Wunused-value]
drivers/net/tun.c:1834:30: warning: 'copylen' may be used
uninitialized in this function [-Wuninitialized]
drivers/net/tun.c:1747:46: warning: 'linear' may be used uninitialized
in this function [-Wuninitialized]
drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c:3477:23:
warning: 'rf_amode' may be used uninitialized in this function
[-Wuninitialized]
drivers/scsi/ppa.c:245:3: warning: cast to pointer from integer of
different size [-Wint-to-pointer-cast]
drivers/scsi/ppa.c:257:15: warning: cast to pointer from integer of
different size [-Wint-to-pointer-cast]
drivers/scsi/ppa.c:379:2: warning: cast to pointer from integer of
different size [-Wint-to-pointer-cast]
drivers/scsi/ppa.c:399:2: warning: cast to pointer from integer of
different size [-Wint-to-pointer-cast]
drivers/scsi/ppa.c:436:2: warning: cast to pointer from integer of
different size [-Wint-to-pointer-cast]
drivers/scsi/ppa.c:439:2: warning: cast to pointer from integer of
different size [-Wint-to-pointer-cast]
drivers/scsi/imm.c:248:2: warning: cast to pointer from integer of
different size [-Wint-to-pointer-cast]
drivers/scsi/imm.c:304:3: warning: cast to pointer from integer of
different size [-Wint-to-pointer-cast]
drivers/scsi/imm.c:306:3: warning: cast to pointer from integer of
different size [-Wint-to-pointer-cast]
drivers/scsi/imm.c:342:15: warning: cast to pointer from integer of
different size [-Wint-to-pointer-cast]
drivers/scsi/imm.c:462:2: warning: cast to pointer from integer of
different size [-Wint-to-pointer-cast]
drivers/scsi/imm.c:464:2: warning: cast to pointer from integer of
different size [-Wint-to-pointer-cast]
drivers/scsi/imm.c:466:2: warning: cast to pointer from integer of
different size [-Wint-to-pointer-cast]
drivers/scsi/imm.c:468:2: warning: cast to pointer from integer of
different size [-Wint-to-pointer-cast]
drivers/scsi/imm.c:471:2: warning: cast to pointer from integer of
different size [-Wint-to-pointer-cast]
drivers/scsi/imm.c:474:2: warning: cast to pointer from integer of
different size [-Wint-to-pointer-cast]
drivers/scsi/imm.c:487:2: warning: cast to pointer from integer of
different size [-Wint-to-pointer-cast]
drivers/scsi/imm.c:495:2: warning: cast to pointer from integer of
different size [-Wint-to-pointer-cast]
drivers/scsi/imm.c:564:2: warning: cast to pointer from integer of
different size [-Wint-to-pointer-cast]
drivers/tty/rocket_int.h:46:2: warning: cast to pointer from integer
of different size [-Wint-to-pointer-cast]
drivers/tty/rocket_int.h:54:2: warning: cast to pointer from integer
of different size [-Wint-to-pointer-cast]
drivers/tty/rocket_int.h:68:9: warning: cast to pointer from integer
of different size [-Wint-to-pointer-cast]
drivers/tty/rocket_int.h:73:9: warning: cast to pointer from integer
of different size [-Wint-to-pointer-cast]
drivers/tty/rocket_int.h:73:9: warning: cast to pointer from integer
of different size [-Wint-to-pointer-cast]
drivers/tty/rocket_int.h:73:9: warning: cast to pointer from integer
of different size [-Wint-to-pointer-cast]
drivers/tty/rocket_int.h:73:9: warning: cast to pointer from integer
of different size [-Wint-to-pointer-cast]



-- 
Gr{oetje,eeting}s,

                        Geert

-- 
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
