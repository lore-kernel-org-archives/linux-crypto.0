Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_NONE
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7DD32C433E0
	for <linux-crypto@archiver.kernel.org>; Tue, 26 Jan 2021 05:59:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 24AE0221EA
	for <linux-crypto@archiver.kernel.org>; Tue, 26 Jan 2021 05:59:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726290AbhAZF6i (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 26 Jan 2021 00:58:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728632AbhAYNKt (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 25 Jan 2021 08:10:49 -0500
Received: from mail-lj1-x230.google.com (mail-lj1-x230.google.com [IPv6:2a00:1450:4864:20::230])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59665C0613D6
        for <linux-crypto@vger.kernel.org>; Mon, 25 Jan 2021 05:10:06 -0800 (PST)
Received: by mail-lj1-x230.google.com with SMTP id 3so15214232ljc.4
        for <linux-crypto@vger.kernel.org>; Mon, 25 Jan 2021 05:10:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to
         :content-transfer-encoding;
        bh=gGTG0+ByK3gatZqPGURL/t6ijXFyusS9Y9xKrdb4nGg=;
        b=RJyfYKbr/dGi5UweztVGMIqPFgcxhKZRIQgqbzin0+T48UbafnbGQXQODjPs+7ctLZ
         7hPX23tZCLkFyHq7SeooyHAKKExVLwAeF8/gQbEwkJ8Tq8XfFHEa4vLHNPPSsTDN879T
         svWbJNAQ9XTTD6jJSC34AXHsLEAVM5465j/hH55XEezPPQcm6RxjBtc7qKkPg8R6dd0w
         J3GkMkO4joVAw6ranualwt568bcUDRzGyCewyrlXEz97BnpAqbd8sNBgBbswaNQvG5Py
         LoaU5JYPTSVT6i+sVPFnAhPNBd9Dp1BIJpQIzxA8SWmtFuMXYXOe0EOCabKnTd10WaZ+
         PKAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to
         :content-transfer-encoding;
        bh=gGTG0+ByK3gatZqPGURL/t6ijXFyusS9Y9xKrdb4nGg=;
        b=U/WU4hyJMMZBR+sr47VD4iJhnpiMZVyEMafEvOKOEyecHAr/4mXRPXRHVPEBOduJcP
         2xjX8RiZFJJu8ljFNm1EKAMdA9opytXx6/et5ZWKYOpkxGKplnf7xog8ucRMxWijziVg
         Tw3nL/kvfimWYGiUe3hh/Q4V1zpX2skOIgsPo1JO+7oL8e5/nLxziKDbQlhIcZkFBiU7
         hZH/+xvAIw2U9iOG6u+CNyRgpS8WuIuDHRtQGJI0J2pjbrPkMd4qKdZcH/d6h/76w5Jl
         57ZvbPwGFd7+6+IA72wbp+X5ztfqhyyjVFMchi/ygY+a1cw634F26SQzAwIVTBozMruL
         QBgQ==
X-Gm-Message-State: AOAM530JGOzTVc60ialx+tmap08t/pmtVQmf4OwF7Sd3eQu72siwuR9F
        JBwcD7lcwh2fAJliBXGyhG70iZJu2tqSdZbhYHskfua4263j4A==
X-Google-Smtp-Source: ABdhPJzLnMNOm7IZoo+ytFtF06VBk6VY/hsBek2e8If7N9zS8yUDsKnJ2ZlDF25nm3Mk9J+QiTq1H27vaQajAErxHFQ=
X-Received: by 2002:a2e:b8c7:: with SMTP id s7mr140952ljp.397.1611580204812;
 Mon, 25 Jan 2021 05:10:04 -0800 (PST)
MIME-Version: 1.0
From:   Janusz Dziedzic <janusz.dziedzic@gmail.com>
Date:   Mon, 25 Jan 2021 14:09:53 +0100
Message-ID: <CAFED-jkqPP2nHjnKRrvBqC8H0aB4910A2cFVFnHxfOxjUQeHXw@mail.gmail.com>
Subject: kcryptd, copy big file, unresponsive system (GUI)
To:     linux-crypto@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hello,

Not sure this is correct group.
Problem I have.

PC:
 - hp elitebook 850 g5  + nvme SSD 512G
 - Ubuntu 20.x
 - kernel

janusz@eb850:~$ uname -a
Linux eb850 5.4.0-62-generic #70-Ubuntu SMP Tue Jan 12 12:45:47 UTC
2021 x86_64 x86_64 x86_64 GNU/Linux

Also check linux-image-5.11.0-rc4+ - but didn't help.

Simple copy big file:
janusz@eb850:~$ ls -al tmp.tar.gz
-rw-r--r-- 1 janusz janusz 3847997532 sty 24 20:09 tmp.tar.gz
janusz@eb850:~$ cp tmp.tar.gz tmp2.tar.gz

GUI apps became unresponsive - slack/teams/firefox ...

Top show all CPU (cores) ~100% usage in WA (io and kcryptd).
Only I see this issue?
Seems dm-crypt starving my system...


nvme0n1 259:0 0 465,8G 0 disk
=E2=94=9C=E2=94=80nvme0n1p1 259:1 0 512M 0 part /boot/efi
=E2=94=9C=E2=94=80nvme0n1p2 259:2 0 732M 0 part /boot
=E2=94=94=E2=94=80nvme0n1p3 259:3 0 464,6G 0 part
  =E2=94=94=E2=94=80nvme0n1p3_crypt 253:0 0 464,6G 0 crypt
    =E2=94=9C=E2=94=80ubuntu--vg-root 253:1 0 463,6G 0 lvm /
    =E2=94=94=E2=94=80ubuntu--vg-swap_1 253:2 0 980M 0 lvm [SWAP]


System became unresponsive for few minutes. Example top I get:

top - 09:00:33 up 12 min, 1 user, load average: 11,55, 7,23, 3,60
Tasks: 341 total, 1 running, 340 sleeping, 0 stopped, 0 zombie
%Cpu0 : 1,3 us, 7,0 sy, 0,0 ni, 0,0 id, 91,7 wa, 0,0 hi, 0,0 si, 0,0 st
%Cpu1 : 5,9 us, 7,3 sy, 0,0 ni, 0,0 id, 86,8 wa, 0,0 hi, 0,0 si, 0,0 st
%Cpu2 : 3,7 us, 7,0 sy, 0,3 ni, 27,4 id, 61,5 wa, 0,0 hi, 0,0 si, 0,0 st
%Cpu3 : 3,0 us, 6,6 sy, 0,0 ni, 0,0 id, 90,4 wa, 0,0 hi, 0,0 si, 0,0 st
%Cpu4 : 2,0 us, 6,7 sy, 0,0 ni, 69,3 id, 22,0 wa, 0,0 hi, 0,0 si, 0,0 st
%Cpu5 : 4,7 us, 8,0 sy, 0,7 ni, 0,0 id, 86,7 wa, 0,0 hi, 0,0 si, 0,0 st
%Cpu6 : 4,4 us, 5,8 sy, 0,0 ni, 0,0 id, 89,8 wa, 0,0 hi, 0,0 si, 0,0 st
%Cpu7 : 2,0 us, 6,7 sy, 0,0 ni, 0,0 id, 91,3 wa, 0,0 hi, 0,0 si, 0,0 st
MiB Mem : 31922,9 total, 18111,2 free, 3655,1 used, 10156,6 buff/cache
MiB Swap: 980,0 total, 980,0 free, 0,0 used. 26893,0 avail Mem

    PID USER PR NI VIRT RES SHR S %CPU %MEM TIME+ COMMAND
   3635 janusz 20 0 2841208 302720 117252 S 8,9 0,9 1:10.78 Web Content
   2059 janusz 20 0 4961508 284548 102652 S 6,9 0,9 0:26.83 gnome-shell
   1823 janusz 9 -11 3352488 19036 15332 S 6,3 0,1 0:41.25 pulseaudio
   2631 janusz 20 0 819484 53192 38340 S 5,9 0,2 0:07.68 gnome-terminal-
    454 root 20 0 0 0 0 D 5,6 0,0 0:08.08 kworker/u16:7+kcryptd/253:0
   3452 janusz 20 0 3905104 362944 194092 S 5,6 1,1 0:52.16 firefox
   4667 root 20 0 0 0 0 D 5,6 0,0 0:05.93 kworker/u16:3+kcryptd/253:0
    126 root 20 0 0 0 0 D 5,3 0,0 0:06.50 kworker/u16:1+kcryptd/253:0
    447 root 20 0 0 0 0 D 5,3 0,0 0:07.15 kworker/u16:5+kcryptd/253:0
    450 root 20 0 0 0 0 D 5,3 0,0 0:08.38 kworker/u16:6+kcryptd/253:0 .





top - 13:37:23 up 4:04, 1 user, load average: 56,55, 60,02, 43,35
Tasks: 430 total, 1 running, 429 sleeping, 0 stopped, 0 zombie
%Cpu0 : 1,7 us, 1,3 sy, 0,0 ni, 0,0 id, 96,0 wa, 0,0 hi, 1,0 si, 0,0 st
%Cpu1 : 3,0 us, 2,7 sy, 0,0 ni, 0,0 id, 94,0 wa, 0,0 hi, 0,3 si, 0,0 st
%Cpu2 : 3,7 us, 1,0 sy, 0,0 ni, 9,3 id, 86,0 wa, 0,0 hi, 0,0 si, 0,0 st
%Cpu3 : 3,5 us, 2,1 sy, 0,0 ni, 0,0 id, 94,3 wa, 0,0 hi, 0,0 si, 0,0 st
%Cpu4 : 3,6 us, 2,6 sy, 0,0 ni, 0,0 id, 93,8 wa, 0,0 hi, 0,0 si, 0,0 st
%Cpu5 : 2,0 us, 1,7 sy, 0,0 ni, 0,0 id, 96,3 wa, 0,0 hi, 0,0 si, 0,0 st
%Cpu6 : 3,8 us, 1,7 sy, 0,0 ni, 94,5 id, 0,0 wa, 0,0 hi, 0,0 si, 0,0 st
%Cpu7 : 2,0 us, 1,0 sy, 0,0 ni, 0,0 id, 97,0 wa, 0,0 hi, 0,0 si, 0,0 st
MiB Mem : 31925,3 total, 4748,0 free, 6415,8 used, 20761,6 buff/cache
MiB Swap: 980,0 total, 980,0 free, 0,0 used. 23416,2 avail Mem


BR
Janusz
