Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DE627C433FE
	for <linux-crypto@archiver.kernel.org>; Tue, 22 Mar 2022 10:54:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233687AbiCVKzu (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 22 Mar 2022 06:55:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233707AbiCVKzt (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 22 Mar 2022 06:55:49 -0400
Received: from smtp-bc08.mail.infomaniak.ch (smtp-bc08.mail.infomaniak.ch [IPv6:2001:1600:4:17::bc08])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 797FA186E2
        for <linux-crypto@vger.kernel.org>; Tue, 22 Mar 2022 03:54:21 -0700 (PDT)
Received: from smtp-2-0001.mail.infomaniak.ch (unknown [10.5.36.108])
        by smtp-3-3000.mail.infomaniak.ch (Postfix) with ESMTPS id 4KN7f33TrrzMprjy;
        Tue, 22 Mar 2022 11:54:19 +0100 (CET)
Received: from ns3096276.ip-94-23-54.eu (unknown [23.97.221.149])
        by smtp-2-0001.mail.infomaniak.ch (Postfix) with ESMTPA id 4KN7f26RddzljsTT;
        Tue, 22 Mar 2022 11:54:18 +0100 (CET)
Message-ID: <d1a23bfa-9160-7270-2180-d9720c12a5cc@digikod.net>
Date:   Tue, 22 Mar 2022 11:55:25 +0100
MIME-Version: 1.0
User-Agent: 
Content-Language: en-US
To:     David Woodhouse <dwmw2@infradead.org>,
        Jarkko Sakkinen <jarkko@kernel.org>
Cc:     David Howells <dhowells@redhat.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Snowberg <eric.snowberg@oracle.com>,
        Paul Moore <paul@paul-moore.com>, keyrings@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20220321174548.510516-1-mic@digikod.net>
 <f595c9c2da606b799f3a8ded9807cb6d892156c5.camel@infradead.org>
From:   =?UTF-8?Q?Micka=c3=abl_Sala=c3=bcn?= <mic@digikod.net>
Subject: Re: [PATCH v1 0/1] Explain panic() calls for keyring initialization
In-Reply-To: <f595c9c2da606b799f3a8ded9807cb6d892156c5.camel@infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org


On 21/03/2022 19:29, David Woodhouse wrote:
> On Mon, 2022-03-21 at 18:45 +0100, Mickaël Salaün wrote:
>>
>> Mickaël Salaün (1):
>>    certs: Explain the rational to call panic()
> 
> Nit: "rationale". Even in Simplified English, I believe "rational" is a
> completely different word.

Right, "rational" is an adjective.


> 
>>   certs/blacklist.c | 8 ++++++++
>>   1 file changed, 8 insertions(+)
> 
> Also, isn't it about time we changed this to call it a denylist?
> 

It is important to note that this word is part of the kernel ABI because 
of the keyring name.
