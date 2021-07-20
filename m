Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5B493C636C8
	for <linux-crypto@archiver.kernel.org>; Tue, 20 Jul 2021 20:49:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4367461019
	for <linux-crypto@archiver.kernel.org>; Tue, 20 Jul 2021 20:49:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235573AbhGTUIx (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 20 Jul 2021 16:08:53 -0400
Received: from mout.kundenserver.de ([212.227.126.131]:36725 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237133AbhGTTr3 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 20 Jul 2021 15:47:29 -0400
Received: from [192.168.0.113] ([178.252.67.224]) by mrelayeu.kundenserver.de
 (mreue011 [212.227.15.163]) with ESMTPSA (Nemesis) id
 1N7Qgn-1l2w370noT-017lIO; Tue, 20 Jul 2021 22:27:00 +0200
Subject: Re: [RFC PATCH 00/11] nvme: In-band authentication support
To:     Hannes Reinecke <hare@suse.de>, Christoph Hellwig <hch@lst.de>
Cc:     Sagi Grimberg <sagi@grimberg.me>,
        Keith Busch <keith.busch@wdc.com>,
        linux-nvme@lists.infradead.org,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org
References: <20210716110428.9727-1-hare@suse.de>
From:   Vladislav Bolkhovitin <vst@vlnb.net>
Message-ID: <66b3b869-02bd-9dee-fadc-8538c6aad57a@vlnb.net>
Date:   Tue, 20 Jul 2021 23:26:37 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <20210716110428.9727-1-hare@suse.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K1:C+RFXPti1OtFpeySbbdTGDoG6HjjVzlMsUSbWdqc2G9TDwqgBF2
 +jx3Xta9ZLFtOURu1xlbdl1MDHUkiFA6IAe8c5C/egpw0fcgYVx01ep63GE7oZzIIOtmAJu
 PkULJW+6MqXSH/ePb02jfymaKIAjCohmZzoeWM6Gw6akIlmjmbDHQoAIlo8205VzvP7f1P+
 Sa4xEPr9W2sDFNcDcUz4A==
X-UI-Out-Filterresults: notjunk:1;V03:K0:pYwAjRlTAq0=:5wPmRJUct811TLss1SELLD
 KI6e4hZYGbwVyy7TJPMNWLtnKWUeDAcUPeh9FtSr4/cXdCzPDh1/w+vMXyfBgDiOZjOyQZlup
 BlZlJWZeYgY3rFK4HcB5KHIpn6Dpkcf6SzBTP1W7u9xqQHEu/9Jd838thy+aQAwsWyWotc0xF
 7wUUmWSo8EZhnnHfn7Pg/r2PALkQrOrjoFjZ/ANzc5XTWbGvl/xxSNzXQwQenJdWMcZToK7i1
 n+mpjWOdBIe6ullcYAy+L3nAfHxijGR5KGPr24N3A3xg+RL9cuyxI2q351wliqAoniU8exg9i
 N4NZ0vL1DecUx8ZE8Rt5QgnHa8eOUA0pXT1I9WClWF6k0LypDnkSS6tXPoWDcNV5kq+zn996P
 XL+PuKY8ZYs1Ung8CXqydBopp34Sl3fpvMM0p8AcAHd0TtFu/8KQ/0cguv0bLCxQumW/D+qCY
 3JYZM9cPOuJpfjvOyHlmGLxmQCtSYACahW0/EeE8RNMQSOhk5WMDXsPQmTaLT5yguPqEpIxCD
 EfnUw9hLpz8dWd53Q1ht/6ohNd5IEmWO3JzT2ORDN1T0Bylj9PvIFmsnaO7QzCo9vymBSsjRk
 /ESwp1ZwH5XBREizPVhGWfGPJItDa/gP7XktpWHilwlD+uZTTaRqMd2M2LqqPsPjQs1tClYsI
 XWqd1pSMrVVM0BegNsgIKmnY0k7LBItMRef5F73XWzInB6c86tIiyemUVAJ4+jNWLzgWQ6rYy
 iaXtZwfMAnjk/q6lbzUFJPrqT2orjBAG2Yy7mauB8tYB921koNahKsfRkEtsgM2I7exvb+mSr
 MNR/OwE89XTZGLAMgMjd9x90M0i/f1MaV85y5/04OhV/WwYGPNLXSWeSFH/hqiX7Qz3IA5s
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi,

Great to see those patches coming! After some review, they look to be
very well done. Some comments/suggestions below.

1. I strongly recommend to implement DH exponentials reuse (g x mod p /
g y mod p as well as g xy mod p) as specified in section 8.13.5.7
"DH-HMAC-CHAP Security Requirements". When I was working on TP 8006 I
had a prototype that demonstrated that DH math has quite significant
latency, something like (as far as I remember) 30ms for 4K group and few
hundreds of ms for 8K group. For single connection it is not a big deal,
but imagine AMD EPYC with 128 cores. Since all connections are created
sequentially, even with 30 ms per connection time to complete full
remote device connection would become 128*30 => almost 4 seconds. With
8K group it might be more than 10 seconds. Users are unlikely going to
be happy with this, especially in cases, when connecting multiple of
NVMe-oF devices is a part of a server or VM boot sequence.

If DH exponential reuse implemented, for all subsequent connections the
DH math is excluded, so authentication overhead becomes pretty much
negligible.

In my prototype I implemented DH exponential reuse as a simple
per-host/target cache that keeps DH exponentials (including g xy mod p)
for up to 10 seconds. Simple and sufficient.

Another, might be ever more significant reason why DH exponential reuse
is important is that without it x (or y on the host side) must always be
randomly generated each time a new connection is established. Which
means, for instance, for 8K groups for each connection 1KB of random
bytes must be taken from the random pool. With 128 connections it is now
128KB. Quite a big pressure on the random pool that DH exponential reuse
mostly avoids.

Those are the 2 reasons why we added this DH exponential reuse sentence
in the spec. In the original TP 8006 there was a small informative piece
explaining reasonings behind that, but for some reasons it was removed
from the final version.

2. What is the status of this code from perspective of stability in face
of malicious host behavior? Seems implementation is carefully done, but,
for instance, at the first look I was not able to find a code to clean
up if host in not acting for too long in the middle of exchange. Other
observation is that in nvmet_execute_auth_send()
nvmet_check_transfer_len() does not check if tl size is reasonable,
i.e., for instance, not 1GB.

For sure, we don't want to allow remote hosts to hang or crash target.
For instance, because of OOM conditions that happened, because malicious
host asked target to allocate too much memory or open to many being
authenticated connections in which the host is not going to reply in the
middle of exchange.

Asking, because don't want to go in my review too far ahead from the
author ;)

In this regard, it would be great if you add in your test application
ability to perform authentication with random parameters and randomly
stop responding. Overnight running of such test would give us good
degree of confidence that it will always work as expected.

Vlad

On 7/16/21 2:04 PM, Hannes Reinecke wrote:
> Hi all,
> 
> recent updates to the NVMe spec have added definitions for in-band
> authentication, and seeing that it provides some real benefit especially
> for NVMe-TCP here's an attempt to implement it.
> 
> Tricky bit here is that the specification orients itself on TLS 1.3,
> but supports only the FFDHE groups. Which of course the kernel doesn't
> support. I've been able to come up with a patch for this, but as this
> is my first attempt to fix anything in the crypto area I would invite
> people more familiar with these matters to have a look.
> 
> Also note that this is just for in-band authentication. Secure concatenation
> (ie starting TLS with the negotiated parameters) is not implemented; one would
> need to update the kernel TLS implementation for this, which at this time is
> beyond scope.
> 
> As usual, comments and reviews are welcome.
> 
> Hannes Reinecke (11):
>   crypto: add crypto_has_shash()
>   crypto: add crypto_has_kpp()
>   crypto/ffdhe: Finite Field DH Ephemeral Parameters
>   lib/base64: RFC4648-compliant base64 encoding
>   nvme: add definitions for NVMe In-Band authentication
>   nvme: Implement In-Band authentication
>   nvme-auth: augmented challenge support
>   nvmet: Parse fabrics commands on all queues
>   nvmet: Implement basic In-Band Authentication
>   nvmet-auth: implement support for augmented challenge
>   nvme: add non-standard ECDH and curve25517 algorithms
> 
>  crypto/Kconfig                         |    8 +
>  crypto/Makefile                        |    1 +
>  crypto/ffdhe_helper.c                  |  877 +++++++++++++++++
>  crypto/kpp.c                           |    6 +
>  crypto/shash.c                         |    6 +
>  drivers/nvme/host/Kconfig              |   11 +
>  drivers/nvme/host/Makefile             |    1 +
>  drivers/nvme/host/auth.c               | 1188 ++++++++++++++++++++++++
>  drivers/nvme/host/auth.h               |   23 +
>  drivers/nvme/host/core.c               |   77 +-
>  drivers/nvme/host/fabrics.c            |   65 +-
>  drivers/nvme/host/fabrics.h            |    8 +
>  drivers/nvme/host/nvme.h               |   15 +
>  drivers/nvme/host/trace.c              |   32 +
>  drivers/nvme/target/Kconfig            |   10 +
>  drivers/nvme/target/Makefile           |    1 +
>  drivers/nvme/target/admin-cmd.c        |    4 +
>  drivers/nvme/target/auth.c             |  608 ++++++++++++
>  drivers/nvme/target/configfs.c         |  102 +-
>  drivers/nvme/target/core.c             |   10 +
>  drivers/nvme/target/fabrics-cmd-auth.c |  472 ++++++++++
>  drivers/nvme/target/fabrics-cmd.c      |   30 +-
>  drivers/nvme/target/nvmet.h            |   71 ++
>  include/crypto/ffdhe.h                 |   24 +
>  include/crypto/hash.h                  |    2 +
>  include/crypto/kpp.h                   |    2 +
>  include/linux/base64.h                 |   16 +
>  include/linux/nvme.h                   |  187 +++-
>  lib/Makefile                           |    2 +-
>  lib/base64.c                           |  111 +++
>  30 files changed, 3961 insertions(+), 9 deletions(-)
>  create mode 100644 crypto/ffdhe_helper.c
>  create mode 100644 drivers/nvme/host/auth.c
>  create mode 100644 drivers/nvme/host/auth.h
>  create mode 100644 drivers/nvme/target/auth.c
>  create mode 100644 drivers/nvme/target/fabrics-cmd-auth.c
>  create mode 100644 include/crypto/ffdhe.h
>  create mode 100644 include/linux/base64.h
>  create mode 100644 lib/base64.c
> 
