From: Stephan =?ISO-8859-1?Q?M=FCller?= <smueller@chronox.de>
Subject: KPP: DH/ECDH -- allocation returns ENOENT
Date: Sat, 25 Mar 2017 05:59:07 +0100
Message-ID: <2264613.TBqMtEgLeW@positron.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: linux-crypto@vger.kernel.org
To: salvatore benedetto <salvatore.benedetto@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:58380 "EHLO mail.eperm.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S935564AbdCYE7R (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 25 Mar 2017 00:59:17 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Salvatore,

when I test 4.11-rc1 with the DH and ECDH options enabled, I get -ENOENT when 
trying to allocate the ciphers dh/dh_generic/ecdh.

Note, the dh/ecdh kernel modules are loaded.

Ciao
Stephan
