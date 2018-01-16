From: Kamil Konieczny <k.konieczny@partner.samsung.com>
Subject: Re: [PATCH] crypto: mxs-dcp: Add empty hash export and import
Date: Tue, 16 Jan 2018 19:28:17 +0100
Message-ID: <7d87fa40-8e17-e855-b83d-48d3623ca345@partner.samsung.com>
References: <CGME20180116161641eucas1p1f776ccf0d08da2d3b670e5b2ad550ea6@eucas1p1.samsung.com>
        <4f3389a1-d6aa-b3cc-2299-d638058ddd48@partner.samsung.com>
        <CAOMZO5AsWyhTUbnQNnAaSGXUpZtKUp-jsmQzwKw=14J9SX4KOg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
        Marek Vasut <marex@denx.de>,
        "David S. Miller" <davem@davemloft.net>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        linux-crypto@vger.kernel.org,
        linux-kernel <linux-kernel@vger.kernel.org>
To: Fabio Estevam <festevam@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-reply-to: <CAOMZO5AsWyhTUbnQNnAaSGXUpZtKUp-jsmQzwKw=14J9SX4KOg@mail.gmail.com>
Content-language: en-US
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org



On 16.01.2018 18:28, Fabio Estevam wrote:
> Hi Kamil,
> 
> On Tue, Jan 16, 2018 at 2:16 PM, Kamil Konieczny
> <k.konieczny@partner.samsung.com> wrote:
>> Crypto framework will require async hash export/import, so add empty
>> functions to prevent OOPS.
> 
> Which Oops exactly are you getting?

None now, it is for preparation for patch removing export/import wrappers.

> 
> Just booted 4.14.13 and the mxs-dcp driver does not even probe successfully:
> 
> [    2.455404] mxs-dcp 80028000.dcp: Failed to register sha1 hash!
> [    2.464042] mxs-dcp: probe of 80028000.dcp failed with error -22
> 

With this option turned on in config:

crypto: Disable run-time self tests 

driver should load. Can you verify ?

Btw, there is no maintainer for this file.

-- 
Best regards,
Kamil Konieczny
Samsung R&D Institute Poland
