From: Fabio Estevam <festevam@gmail.com>
Subject: Re: [PATCH] crypto: mxs-dcp: Add empty hash export and import
Date: Tue, 16 Jan 2018 15:28:18 -0200
Message-ID: <CAOMZO5AsWyhTUbnQNnAaSGXUpZtKUp-jsmQzwKw=14J9SX4KOg@mail.gmail.com>
References: <CGME20180116161641eucas1p1f776ccf0d08da2d3b670e5b2ad550ea6@eucas1p1.samsung.com>
 <4f3389a1-d6aa-b3cc-2299-d638058ddd48@partner.samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
        Marek Vasut <marex@denx.de>,
        "David S. Miller" <davem@davemloft.net>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        linux-crypto@vger.kernel.org,
        linux-kernel <linux-kernel@vger.kernel.org>
To: Kamil Konieczny <k.konieczny@partner.samsung.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-oi0-f53.google.com ([209.85.218.53]:37240 "EHLO
        mail-oi0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750796AbeAPR2U (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 16 Jan 2018 12:28:20 -0500
In-Reply-To: <4f3389a1-d6aa-b3cc-2299-d638058ddd48@partner.samsung.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Kamil,

On Tue, Jan 16, 2018 at 2:16 PM, Kamil Konieczny
<k.konieczny@partner.samsung.com> wrote:
> Crypto framework will require async hash export/import, so add empty
> functions to prevent OOPS.

Which Oops exactly are you getting?

Just booted 4.14.13 and the mxs-dcp driver does not even probe successfully:

[    2.455404] mxs-dcp 80028000.dcp: Failed to register sha1 hash!
[    2.464042] mxs-dcp: probe of 80028000.dcp failed with error -22
