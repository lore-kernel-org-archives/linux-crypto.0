From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: next build: 208 builds: 9 failed, 199 passed, 857 errors, 444
 warnings (next-20170323)
Date: Thu, 23 Mar 2017 17:19:14 +0100
Message-ID: <CAK8P3a0OHuqV-iK0T3BaYnsNgT2RDpAgpa5vQEFneEZZ65Dn9g@mail.gmail.com>
References: <58d36150.82ce190a.a6597.51eb@mx.google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Cc: kernel-build-reports@lists.linaro.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-crypto@vger.kernel.org, linux-mips@linux-mips.org,
        "Steven J. Hill" <steven.hill@cavium.com>,
        Ralf Baechle <ralf@linux-mips.org>
To: "kernelci.org bot" <bot@kernelci.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-ot0-f171.google.com ([74.125.82.171]:36288 "EHLO
        mail-ot0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S965084AbdCWQTQ (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 23 Mar 2017 12:19:16 -0400
In-Reply-To: <58d36150.82ce190a.a6597.51eb@mx.google.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, Mar 23, 2017 at 6:46 AM, kernelci.org bot <bot@kernelci.org> wrote:

> acs5k_defconfig (arm) =E2=80=94 PASS, 0 errors, 2 warnings, 0 section mis=
matches
>
> Warnings:
> :1328:2: warning: #warning syscall arch_prctl not implemented [-Wcpp]
> :1328:2: warning: #warning syscall arch_prctl not implemented [-Wcpp]

patch sent today, we don't really want this syscall except on x86

> allmodconfig (arm64) =E2=80=94 FAIL, 6 errors, 5 warnings, 0 section mism=
atches
>
> Errors:
> ERROR (phandle_references): Reference to non-existent node or label "pwm_=
f_clk_pins"
> ERROR (phandle_references): Reference to non-existent node or label "pwm_=
ao_a_3_pins"
> ERROR: Input tree has errors, aborting (use -f to force output)
> ERROR (phandle_references): Reference to non-existent node or label "pwm_=
f_clk_pins"
> ERROR (phandle_references): Reference to non-existent node or label "pwm_=
ao_a_3_pins"
> ERROR: Input tree has errors, aborting (use -f to force output)

Kevin has already backed out the commit that caused this.

> Warnings:
> :1325:2: warning: #warning syscall statx not implemented [-Wcpp]

Should get fixed in the next few days when the patch gets picked up for arm=
64.

> drivers/misc/aspeed-lpc-ctrl.c:232:17: warning: format '%x' expects argum=
ent of type 'unsigned int', but argument 4 has type 'resource_size_t {aka l=
ong long unsigned int}' [-Wformat=3D]

patch sent today

> include/uapi/linux/byteorder/big_endian.h:32:26: warning: large integer i=
mplicitly truncated to unsigned type [-Woverflow]
> include/uapi/linux/byteorder/big_endian.h:32:26: warning: large integer i=
mplicitly truncated to unsigned type [-Woverflow]

I sent this one a few days ago

> allmodconfig (x86) =E2=80=94 PASS, 0 errors, 11 warnings, 0 section misma=
tches
>
> Warnings:
> drivers/crypto/cavium/zip/zip_main.c:489:18: warning: format '%ld' expect=
s argument of type 'long int', but argument 4 has type 'long long int' [-Wf=
ormat=3D]
> drivers/crypto/cavium/zip/zip_main.c:489:18: warning: format '%ld' expect=
s argument of type 'long int', but argument 5 has type 'long long int' [-Wf=
ormat=3D]

This one too.

> cavium_octeon_defconfig (mips) =E2=80=94 FAIL, 830 errors, 3 warnings, 0 =
section mismatches
>
> Errors:
> arch/mips/include/asm/octeon/cvmx-mio-defs.h:78:3: error: expected specif=
ier-qualifier-list before '__BITFIELD_FIELD'
> arch/mips/include/asm/octeon/cvmx-mio-defs.h:95:3: error: expected specif=
ier-qualifier-list before '__BITFIELD_FIELD'

Maybe caused by 4cd156de2ca8 ("MIPS: Octeon: Remove unused MIO types
and macros.")
I have not looked in detail

> net/bridge/br_netlink.c:1339:1: warning: the frame size of 2544 bytes is =
larger than 2048 bytes [-Wframe-larger-than=3D]
> net/wireless/nl80211.c:1399:1: warning: the frame size of 2208 bytes is l=
arger than 2048 bytes [-Wframe-larger-than=3D]
> net/wireless/nl80211.c:1888:1: warning: the frame size of 3840 bytes is l=
arger than 2048 bytes [-Wframe-larger-than=3D]
> net/wireless/nl80211.c:4429:1: warning: the frame size of 2240 bytes is l=
arger than 2048 bytes [-Wframe-larger-than=3D]

Still need to rework my patches.

    Arnd
