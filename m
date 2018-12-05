Return-Path: <SRS0=adZj=OO=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from mail-oi1-f169.google.com ([209.85.167.169]:35363 "EHLO
        mail-oi1-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725905AbeLEBBC (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 4 Dec 2018 20:01:02 -0500
Received: by mail-oi1-f169.google.com with SMTP id v6so16088390oif.2
        for <linux-crypto@vger.kernel.org>; Tue, 04 Dec 2018 17:01:01 -0800 (PST)
MIME-Version: 1.0
From: Shipof _ <shipof123main@gmail.com>
Date: Tue, 4 Dec 2018 17:00:48 -0800
Message-ID: <CAGfvYQryvS4C=XM3ZBA11y+XPAM5XLkh71f7iV3c8GpeXdMOVw@mail.gmail.com>
Subject: Using Advanced Vector eXtensions with hand-coded x64 algorithms (e.g /arch/x86/blowfish-x86_64-asm_64.S)
To: linux-crypto@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

I was curious if it might make implementing F() faster to use
instructions that are meant to work with sets of data similar to what
would be processed
