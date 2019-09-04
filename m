Return-Path: <SRS0=oAbn=W7=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CB1B1C3A5A7
	for <linux-crypto@archiver.kernel.org>; Wed,  4 Sep 2019 10:54:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9DA0B2077B
	for <linux-crypto@archiver.kernel.org>; Wed,  4 Sep 2019 10:54:59 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="i6pMlB6U"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729020AbfIDKy6 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 4 Sep 2019 06:54:58 -0400
Received: from mail-yw1-f66.google.com ([209.85.161.66]:42671 "EHLO
        mail-yw1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727722AbfIDKy6 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 4 Sep 2019 06:54:58 -0400
Received: by mail-yw1-f66.google.com with SMTP id i207so7102701ywc.9;
        Wed, 04 Sep 2019 03:54:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=59s6uUbvi9D98ZNsytr4rsBrjjCNcx38K+42gcO4Xm0=;
        b=i6pMlB6Ufm3xJUOWgAI857Y1p0OkeHpjYk9k3e4kK830ZlU8a9AMj11pqTX4z2KQ7o
         hFazH3OF+cYzkcqjyeCMRD57zPHbl6EE+ZSyBaQgkv5gYGumNW2jA3u9LjevHxPfxL7/
         c4VPvDYTIMlWeJleD/d2pXZ8e6oKWwf0D8A/rbLgP5fQDdUEOMltsS4w4gxWxanxDyXb
         B7fgad8Ee9i0LcLheyNx9t6coI25I+W8b/v4RjrxyRkiUhSpaou7nl9vBk5a4DerfKuk
         MsKV1d9IUK0MEs/UYG6hYkJHepkImHQyLLSe50/X147mD2/1szWpzrktxrU90gcgKwMh
         PWyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=59s6uUbvi9D98ZNsytr4rsBrjjCNcx38K+42gcO4Xm0=;
        b=rPu3w67f9tNR+046DMa77Luyd7yH+686OItmOiWIRKaD+Ok9nhqJD3Q4QdI43hWYeE
         /ZSIZJWw3ytC5vP4qhdzOGDyJQt/MqaWcbd0x0C6XHx1CetY44PLpCFgnybD9PWErP3m
         /OyMlO2P2MISAPGkLpt8jiD60b6c+XRdpLxRxlbYRjWWz2ARKCQeoK70HumT0cHvexSQ
         BKg4DYuqHWPYsGGq2fwIFLquZlGL28B2BU71XT6wxuerYy/lK8FjO5M0OCUvwoIs1sIc
         sWX6ZoYIav7j2R5XWNvhtgg0Pp14rEjocs0svRP+hngjtkJOTO1g6mlJpv8iIU7F72bF
         cyjw==
X-Gm-Message-State: APjAAAVzCBDjCNWBRvAmN8J1iZ3U42lAzV1l33BgE/tocvF/BO7DYzmS
        1UKHrT3zNJDw2jmPeziuXbrDTSMRTn7YvcG1z2FAMPjNPO3805Q=
X-Google-Smtp-Source: APXvYqxcYI4mArx0eHYjWtUHeboM6zxtlsbUazlikoNT8LvpRgMcSmxX9K4Uw84yraWCENizchWDUvuJgLY00Ro8C9I=
X-Received: by 2002:a81:6c8:: with SMTP id 191mr26019625ywg.181.1567594497157;
 Wed, 04 Sep 2019 03:54:57 -0700 (PDT)
MIME-Version: 1.0
From:   Hunter Nins <hunternins@gmail.com>
Date:   Wed, 4 Sep 2019 03:54:46 -0700
Message-ID: <CA+ex1uD4tQ+6V2k3YOA=bufEmHWL24tLVB+Q+oBtTGO-g-W4YQ@mail.gmail.com>
Subject: Question: kexec() ISO images using encrypted partitions and/or
 "persistent RAM".
To:     linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Good day,

I'm currently experimenting with the use of kexec() to change the
currently-running kernel on my test machine (Intel PC). So far, so
good: I'm able to change the currently-running kernel and initrd image
via kexec, and am now attempting to live-boot an ISO image (i.e.
Ubuntu 18.04 Server amd64 image), via the following snippet (not yet
working):

mount -o loop -t iso9660 /public/ubuntu.iso /boot
ISO_FILE="/public/ubuntu.iso"
DEVICE="/dev/sda3"
UUID=$(blkid ${DEVICE} | tail -1 | tr " " "\n" | grep UUID | cut -d\" -f2)
APPEND="toram fromiso=/dev/disk/by-uuid/${UUID}/${ISO_FILE}
iso-scan/filename=/${ISO_PATH}"
    kexec -l /boot/casper/vmlinuz --initrd=/boot/casper/initrd
--append="${APPEND}"

Question: is it possible to kexec() into an ISO that's stored on my
sole (LUKS encrypted) OS partition on the device, or from a RAM disk?
I've looked into using PRAM, for example
(https://lwn.net/Articles/561330/) to store the ISO in a persistent
RAM disk, but the feature appears to be a non-standard, beta feature
at best. My alternative is to attempt to kexec + ISO boot from an
encrypted partition (i.e. "/dev/mapper/ubuntu--vg-root"), which I'm
not sure is possible/supported, as I'm not permitted to have
non-encrypted partitions or USB thumb drives on the server I'm
currently testing this on.

Thank you.
