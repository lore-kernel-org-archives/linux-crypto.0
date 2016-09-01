From: NTU <neotheuser@gmail.com>
Subject: CONFIG_FIPS without module loading support?
Date: Wed, 31 Aug 2016 20:32:42 -0500
Message-ID: <CAM5Ud7MDpZyTrcQ2NtghG6cGT8qfGfP6zYw+vJDQrHqFHor6sg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-it0-f44.google.com ([209.85.214.44]:36843 "EHLO
        mail-it0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752513AbcIABdM (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 31 Aug 2016 21:33:12 -0400
Received: by mail-it0-f44.google.com with SMTP id i184so41987169itf.1
        for <linux-crypto@vger.kernel.org>; Wed, 31 Aug 2016 18:32:44 -0700 (PDT)
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hello,

CRYPTO_FIPS depends on MODULE_SIG and I understand why it would as you
wouldn't want unsigned modules from external sources being loaded. If
CONFIG_MODULES is disabled though (no module loading) there are no
modules to sign in the first place.

Wouldn't it make more sense for CONFIG_FIPS to depend on (MODULE_SIG
[=y] && CONFIG_MODULES [y]) ?

Thank you!

Alec Ari
