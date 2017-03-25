From: Stephan =?ISO-8859-1?Q?M=FCller?= <smueller@chronox.de>
Subject: Re: KPP: DH/ECDH -- allocation returns ENOENT
Date: Sat, 25 Mar 2017 14:49:32 +0100
Message-ID: <14907475.FJ9jHvJebq@positron.chronox.de>
References: <2264613.TBqMtEgLeW@positron.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Cc: salvatore benedetto <salvatore.benedetto@gmail.com>,
        linux-crypto@vger.kernel.org
To: Stephan =?ISO-8859-1?Q?M=FCller?= <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:58404 "EHLO mail.eperm.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750731AbdCYNts (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 25 Mar 2017 09:49:48 -0400
In-Reply-To: <2264613.TBqMtEgLeW@positron.chronox.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Samstag, 25. März 2017, 05:59:07 CET schrieb Stephan Müller:

Hi,

> Hi Salvatore,
> 
> when I test 4.11-rc1 with the DH and ECDH options enabled, I get -ENOENT
> when trying to allocate the ciphers dh/dh_generic/ecdh.
> 
> Note, the dh/ecdh kernel modules are loaded.

Apologies, please disregard this email. I had a patch in the kernel that 
forgot to remove :-)

Ciao
Stephan
