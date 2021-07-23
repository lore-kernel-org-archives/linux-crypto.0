Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D1AA2C4338F
	for <linux-crypto@archiver.kernel.org>; Fri, 23 Jul 2021 20:03:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B35B060ED7
	for <linux-crypto@archiver.kernel.org>; Fri, 23 Jul 2021 20:03:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229575AbhGWTXN (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 23 Jul 2021 15:23:13 -0400
Received: from mout.kundenserver.de ([217.72.192.75]:42203 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229461AbhGWTXN (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 23 Jul 2021 15:23:13 -0400
Received: from [192.168.0.113] ([178.252.67.224]) by mrelayeu.kundenserver.de
 (mreue107 [212.227.15.179]) with ESMTPSA (Nemesis) id
 1N0WPK-1lD9WG2tro-00wRmx; Fri, 23 Jul 2021 22:03:20 +0200
Subject: Re: [RFC PATCH 00/11] nvme: In-band authentication support
From:   Vladislav Bolkhovitin <vst@vlnb.net>
To:     Hannes Reinecke <hare@suse.de>, Christoph Hellwig <hch@lst.de>
Cc:     Sagi Grimberg <sagi@grimberg.me>,
        Keith Busch <keith.busch@wdc.com>,
        linux-nvme@lists.infradead.org,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org
References: <20210716110428.9727-1-hare@suse.de>
 <66b3b869-02bd-9dee-fadc-8538c6aad57a@vlnb.net>
 <e339e6e7-fc32-2480-ca99-516547105776@suse.de>
 <833cfd62-1e1f-1dca-2e38-ff07b3a5e8fb@vlnb.net>
Message-ID: <2f241490-3bfd-2151-9d76-970e0d6bfd68@vlnb.net>
Date:   Fri, 23 Jul 2021 23:02:58 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <833cfd62-1e1f-1dca-2e38-ff07b3a5e8fb@vlnb.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K1:RYCcHwZV9sA2oxeVhxRvbvDhd5IuKxNV2ReWMKOc/9Q4bIvmbX6
 h6RYWbMIsCKj8sHaD3mCj85uPWkaioVc64b2poXjAqL6ZAVFX6/lCeuHYGRPiUYMPFRMZs3
 gf2eSyAVZuQ+32sCM3KWsLbiP1O8r0GfyqR+AyID0fXyWBhKRqOj/KeB1ybFHHXSzJzLJnO
 sv95hCpvxxzYV0jPlRAaA==
X-UI-Out-Filterresults: notjunk:1;V03:K0:6o1bz3z+h+o=:SSV8EKT7vAJ43Nb0alAscD
 WQ5KoUhkGSrAz1FPXExqq06cM24bCc/R8cx3lRx312zN0WUMBmjArC8aoyEgonkERZpBO7EHL
 nPqIWj/miPP7TUgT3z9YDabBVEfAloiyX6Z0Q2Z7yf7zp2csLN2Ng62VDQ6QNsDQ6Isa8PSCj
 u8sgpPcK3ph3T8NutzUtlHlqBNRAKGxtGclidm/sFotHeO7fkOBHLQTqnDkQq2Ss86GnZyCBd
 x9m+AdLw5cy7h6IUgz3yKXD9FPjgCgGUmirSjKpbktYIEUEnBI2z0NXfK3DBOg14ogE0oE4cQ
 XaAOPG9Z60UYHlc4PyuaXCaH6TxX5oscN1Lc8DqwO95IiVolS85Zwk8kKZ9dbyG20+YJHnw7U
 T6jiTx8JRh+uUvsMZXa/7duyTXQrj0lb76rCt+hysevM3jFn43rKlHcjiGVDfTarCbBAUuYpw
 +Mdj1f1/ertRxzEoIijr72VDJyCAjnRTUR46HFNUNSmfNbr6ZqTj7UvoZvraeuJOtz+Ss0E+v
 JlKKbeCnWr4I+VsWLBoMfCRuYRWNDmbfD2XyGacbSU8MEOqsM87bEy4jAY2tk4CSjEiVFZter
 YuA3rpf1Hs4771+zTvNZlh/SlglwEJhXbFrZ0wJ19RQdWiy68glZSGK7nfTJhYQis8QXHlA0h
 r9PFe3w9zG+JElZDK8q6nOEWuH3gkOPBHZg6J/8z9Q5EcZQiR4IF2zYbfAMObcz8RCE3o+OPr
 QpRdbWOyIaZTAO5KDZsrg6QgDK/9tebFmXYBq+F5CPxSuDrJgJ5z/73WH3JrVBW4qGCAo35Ix
 RyO4Ue1rGj3yo9QbTr1pgdk5glUYLtW+0ShtPopYY9U0jKqbzVpNHNehDHhkVXl39iTNyON
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Another comment is that better to perform CRC check of dhchap_secret and
generation of dhchap_key right where the secret was specified (e.g.,
nvmet_auth_set_host_key() on the target side).

No need to do it every time for every connection and by that increase
authentication latency. As I wrote in the other comment, it might be 128
or more connections established during connecting to a single NVMe-oF
device.

Vlad
