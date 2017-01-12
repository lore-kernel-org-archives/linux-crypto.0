From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: Re: [cryptodev:master 43/44] arch/arm/crypto/aes-cipher-core.S:21:
 Error: selected processor does not support `tt .req ip' in ARM mode
Date: Thu, 12 Jan 2017 20:44:38 +0000
Message-ID: <CAKv+Gu_PxGi2AqY079tOS9DZyu8+bmgfR1tJRWRVkVi_Yb3zLA@mail.gmail.com>
References: <201701130326.19FpToYy%fengguang.wu@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: kbuild-all@01.org,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>
To: kbuild test robot <fengguang.wu@intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-it0-f51.google.com ([209.85.214.51]:36922 "EHLO
        mail-it0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750753AbdALUok (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 12 Jan 2017 15:44:40 -0500
Received: by mail-it0-f51.google.com with SMTP id r185so22711703ita.0
        for <linux-crypto@vger.kernel.org>; Thu, 12 Jan 2017 12:44:39 -0800 (PST)
In-Reply-To: <201701130326.19FpToYy%fengguang.wu@intel.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Arnd,

On 12 January 2017 at 19:04, kbuild test robot <fengguang.wu@intel.com> wrote:
> tree:   https://git.kernel.org/pub/scm/linux/kernel/git/herbert/cryptodev-2.6.git master
> head:   1abee99eafab67fb1c98f9ecfc43cd5735384a86
> commit: 81edb42629758bacdf813dd5e4542ae26e3ad73a [43/44] crypto: arm/aes - replace scalar AES cipher
> config: arm-multi_v7_defconfig (attached as .config)
> compiler: arm-linux-gnueabi-gcc (Debian 6.1.1-9) 6.1.1 20160705
> reproduce:
>         wget https://git.kernel.org/cgit/linux/kernel/git/wfg/lkp-tests.git/plain/sbin/make.cross -O ~/bin/make.cross
>         chmod +x ~/bin/make.cross
>         git checkout 81edb42629758bacdf813dd5e4542ae26e3ad73a
>         # save the attached .config to linux build tree
>         make.cross ARCH=arm
>
> All errors (new ones prefixed by >>):
>
>    arch/arm/crypto/aes-cipher-core.S: Assembler messages:
>>> arch/arm/crypto/aes-cipher-core.S:21: Error: selected processor does not support `tt .req ip' in ARM mode

Did you ever see this error? This is very odd: .req simply declares an
alias for a register name, and this works fine locally

>>> arch/arm/crypto/aes-cipher-core.S:174: Error: ARM register expected -- `movw tt,#:lower16:crypto_ft_tab'
>>> arch/arm/crypto/aes-cipher-core.S:174: Error: ARM register expected -- `movt tt,#:upper16:crypto_ft_tab'
>>> arch/arm/crypto/aes-cipher-core.S:174: Error: ARM register expected -- `ldr r8,[tt,r8,lsl#2]'
>>> arch/arm/crypto/aes-cipher-core.S:174: Error: ARM register expected -- `ldr t0,[tt,t0,lsl#2]'
>>> arch/arm/crypto/aes-cipher-core.S:174: Error: ARM register expected -- `ldr r9,[tt,r9,lsl#2]'
>>> arch/arm/crypto/aes-cipher-core.S:174: Error: ARM register expected -- `ldr t1,[tt,t1,lsl#2]'
>>> arch/arm/crypto/aes-cipher-core.S:174: Error: ARM register expected -- `ldr t2,[tt,t2,lsl#2]'
>>> arch/arm/crypto/aes-cipher-core.S:174: Error: ARM register expected -- `ldr r10,[tt,r10,lsl#2]'
>>> arch/arm/crypto/aes-cipher-core.S:174: Error: ARM register expected -- `ldr t0,[tt,t0,lsl#2]'
>>> arch/arm/crypto/aes-cipher-core.S:174: Error: ARM register expected -- `ldr r11,[tt,r11,lsl#2]'
>>> arch/arm/crypto/aes-cipher-core.S:174: Error: ARM register expected -- `ldr r10,[tt,r10,lsl#2]'
>>> arch/arm/crypto/aes-cipher-core.S:174: Error: ARM register expected -- `ldr t0,[tt,t0,lsl#2]'
>>> arch/arm/crypto/aes-cipher-core.S:174: Error: ARM register expected -- `ldr r11,[tt,r11,lsl#2]'
>>> arch/arm/crypto/aes-cipher-core.S:174: Error: ARM register expected -- `ldr t1,[tt,t1,lsl#2]'
>>> arch/arm/crypto/aes-cipher-core.S:174: Error: ARM register expected -- `ldr t2,[tt,t2,lsl#2]'
>>> arch/arm/crypto/aes-cipher-core.S:174: Error: ARM register expected -- `ldr r5,[tt,r5,lsl#2]'
>>> arch/arm/crypto/aes-cipher-core.S:174: Error: ARM register expected -- `ldr t0,[tt,t0,lsl#2]'
>>> arch/arm/crypto/aes-cipher-core.S:174: Error: ARM register expected -- `ldr r6,[tt,r6,lsl#2]'
>>> arch/arm/crypto/aes-cipher-core.S:174: Error: ARM register expected -- `ldr r4,[tt,r4,lsl#2]'
>
> vim +21 arch/arm/crypto/aes-cipher-core.S
>
>     15          .align          5
>     16
>     17          rk              .req    r0
>     18          rounds          .req    r1
>     19          in              .req    r2
>     20          out             .req    r3
>   > 21          tt              .req    ip
>     22
>     23          t0              .req    lr
>     24          t1              .req    r2
>     25          t2              .req    r3
>     26
>     27          .macro          __select, out, in, idx
>     28          .if             __LINUX_ARM_ARCH__ < 7
>     29          and             \out, \in, #0xff << (8 * \idx)
>     30          .else
>     31          ubfx            \out, \in, #(8 * \idx), #8
>     32          .endif
>     33          .endm
>     34
>     35          .macro          __load, out, in, idx
>     36          .if             __LINUX_ARM_ARCH__ < 7 && \idx > 0
>     37          ldr             \out, [tt, \in, lsr #(8 * \idx) - 2]
>     38          .else
>     39          ldr             \out, [tt, \in, lsl #2]
>     40          .endif
>     41          .endm
>     42
>     43          .macro          __hround, out0, out1, in0, in1, in2, in3, t3, t4, enc
>     44          __select        \out0, \in0, 0
>     45          __select        t0, \in1, 1
>     46          __load          \out0, \out0, 0
>     47          __load          t0, t0, 1
>     48
>     49          .if             \enc
>     50          __select        \out1, \in1, 0
>     51          __select        t1, \in2, 1
>     52          .else
>     53          __select        \out1, \in3, 0
>     54          __select        t1, \in0, 1
>     55          .endif
>     56          __load          \out1, \out1, 0
>     57          __select        t2, \in2, 2
>     58          __load          t1, t1, 1
>     59          __load          t2, t2, 2
>     60
>     61          eor             \out0, \out0, t0, ror #24
>     62
>     63          __select        t0, \in3, 3
>     64          .if             \enc
>     65          __select        \t3, \in3, 2
>     66          __select        \t4, \in0, 3
>     67          .else
>     68          __select        \t3, \in1, 2
>     69          __select        \t4, \in2, 3
>     70          .endif
>     71          __load          \t3, \t3, 2
>     72          __load          t0, t0, 3
>     73          __load          \t4, \t4, 3
>     74
>     75          eor             \out1, \out1, t1, ror #24
>     76          eor             \out0, \out0, t2, ror #16
>     77          ldm             rk!, {t1, t2}
>     78          eor             \out1, \out1, \t3, ror #16
>     79          eor             \out0, \out0, t0, ror #8
>     80          eor             \out1, \out1, \t4, ror #8
>     81          eor             \out0, \out0, t1
>     82          eor             \out1, \out1, t2
>     83          .endm
>     84
>     85          .macro          fround, out0, out1, out2, out3, in0, in1, in2, in3
>     86          __hround        \out0, \out1, \in0, \in1, \in2, \in3, \out2, \out3, 1
>     87          __hround        \out2, \out3, \in2, \in3, \in0, \in1, \in1, \in2, 1
>     88          .endm
>     89
>     90          .macro          iround, out0, out1, out2, out3, in0, in1, in2, in3
>     91          __hround        \out0, \out1, \in0, \in3, \in2, \in1, \out2, \out3, 0
>     92          __hround        \out2, \out3, \in2, \in1, \in0, \in3, \in1, \in0, 0
>     93          .endm
>     94
>     95          .macro          __rev, out, in
>     96          .if             __LINUX_ARM_ARCH__ < 6
>     97          lsl             t0, \in, #24
>     98          and             t1, \in, #0xff00
>     99          and             t2, \in, #0xff0000
>    100          orr             \out, t0, \in, lsr #24
>    101          orr             \out, \out, t1, lsl #8
>    102          orr             \out, \out, t2, lsr #8
>    103          .else
>    104          rev             \out, \in
>    105          .endif
>    106          .endm
>    107
>    108          .macro          __adrl, out, sym, c
>    109          .if             __LINUX_ARM_ARCH__ < 7
>    110          ldr\c           \out, =\sym
>    111          .else
>    112          movw\c          \out, #:lower16:\sym
>    113          movt\c          \out, #:upper16:\sym
>    114          .endif
>    115          .endm
>    116
>    117          .macro          do_crypt, round, ttab, ltab
>    118          push            {r3-r11, lr}
>    119
>    120          ldr             r4, [in]
>    121          ldr             r5, [in, #4]
>    122          ldr             r6, [in, #8]
>    123          ldr             r7, [in, #12]
>    124
>    125          ldm             rk!, {r8-r11}
>    126
>    127  #ifdef CONFIG_CPU_BIG_ENDIAN
>    128          __rev           r4, r4
>    129          __rev           r5, r5
>    130          __rev           r6, r6
>    131          __rev           r7, r7
>    132  #endif
>    133
>    134          eor             r4, r4, r8
>    135          eor             r5, r5, r9
>    136          eor             r6, r6, r10
>    137          eor             r7, r7, r11
>    138
>    139          __adrl          tt, \ttab
>    140
>    141          tst             rounds, #2
>    142          bne             1f
>    143
>    144  0:      \round          r8, r9, r10, r11, r4, r5, r6, r7
>    145          \round          r4, r5, r6, r7, r8, r9, r10, r11
>    146
>    147  1:      subs            rounds, rounds, #4
>    148          \round          r8, r9, r10, r11, r4, r5, r6, r7
>    149          __adrl          tt, \ltab, ls
>    150          \round          r4, r5, r6, r7, r8, r9, r10, r11
>    151          bhi             0b
>    152
>    153  #ifdef CONFIG_CPU_BIG_ENDIAN
>    154          __rev           r4, r4
>    155          __rev           r5, r5
>    156          __rev           r6, r6
>    157          __rev           r7, r7
>    158  #endif
>    159
>    160          ldr             out, [sp]
>    161
>    162          str             r4, [out]
>    163          str             r5, [out, #4]
>    164          str             r6, [out, #8]
>    165          str             r7, [out, #12]
>    166
>    167          pop             {r3-r11, pc}
>    168
>    169          .align          3
>    170          .ltorg
>    171          .endm
>    172
>    173  ENTRY(__aes_arm_encrypt)
>  > 174          do_crypt        fround, crypto_ft_tab, crypto_fl_tab
>    175  ENDPROC(__aes_arm_encrypt)
>    176
>    177  ENTRY(__aes_arm_decrypt)
>  > 178          do_crypt        iround, crypto_it_tab, crypto_il_tab
>    179  ENDPROC(__aes_arm_decrypt)
>
> ---
> 0-DAY kernel test infrastructure                Open Source Technology Center
> https://lists.01.org/pipermail/kbuild-all                   Intel Corporation
