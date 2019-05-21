Return-Path: <SRS0=VBnc=TV=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7A803C04AAF
	for <linux-crypto@archiver.kernel.org>; Tue, 21 May 2019 11:30:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 58D45217D4
	for <linux-crypto@archiver.kernel.org>; Tue, 21 May 2019 11:30:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727883AbfEULar (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 21 May 2019 07:30:47 -0400
Received: from mx1.redhat.com ([209.132.183.28]:2593 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726296AbfEULao (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 21 May 2019 07:30:44 -0400
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 399FB3082200;
        Tue, 21 May 2019 11:30:39 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.43.17.30])
        by smtp.corp.redhat.com (Postfix) with ESMTP id EC4F9176D4;
        Tue, 21 May 2019 11:30:35 +0000 (UTC)
Subject: Re: [PATCH] crypto: af_alg - implement keyring support
To:     Ondrej Mosnacek <omosnace@redhat.com>,
        Marcel Holtmann <marcel@holtmann.org>
Cc:     linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>,
        keyrings@vger.kernel.org, David Howells <dhowells@redhat.com>,
        Stephan Mueller <smueller@chronox.de>,
        Milan Broz <gmazyland@gmail.com>,
        Daniel Zatovic <dzatovic@redhat.com>
References: <20190521100034.9651-1-omosnace@redhat.com>
 <A3BC3B07-6446-4631-862A-F661FB9D63B9@holtmann.org>
 <CAFqZXNtCNG2s_Rk_v332HJA5HVXsJYXDsyzfTNgSU_MJ-mMByA@mail.gmail.com>
From:   Ondrej Kozina <okozina@redhat.com>
Message-ID: <265b6c1b-3ea9-15f6-29d4-3e5988248db1@redhat.com>
Date:   Tue, 21 May 2019 13:30:34 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <CAFqZXNtCNG2s_Rk_v332HJA5HVXsJYXDsyzfTNgSU_MJ-mMByA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-MW
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.47]); Tue, 21 May 2019 11:30:44 +0000 (UTC)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 5/21/19 1:02 PM, Ondrej Mosnacek wrote:
> Hi Marcel,
> 
> On Tue, May 21, 2019 at 12:48 PM Marcel Holtmann <marcel@holtmann.org> wrote:
>> Hi Ondrej,
>>
>>> This patch adds new socket options to AF_ALG that allow setting key from
>>> kernel keyring. For simplicity, each keyring key type (logon, user,
>>> trusted, encrypted) has its own socket option name and the value is just
>>> the key description string that identifies the key to be used. The key
>>> description doesn't need to be NULL-terminated, but bytes after the
>>> first zero byte are ignored.
>>
>> why use the description instead the actual key id? I wonder if a single socket option and a struct providing the key type and key id might be more useful.
> 
> I was basing this on the approach taken by dm-crypt/cryptsetup, which
> is actually the main target consumer for this feature (cryptsetup
> needs to be able to encrypt/decrypt data using a keyring key (possibly
> unreadable by userspace) without having to create a temporary dm-crypt
> mapping, which requires CAP_SYSADMIN). I'm not sure why they didn't
> just use key IDs there... @Milan/Ondrej, what was you motivation for
> using key descriptions rather than key IDs?
> 
We decided to use key descriptions so that we could identify more 
clearly devices managed by cryptsetup (thus 'cryptsetup:' prefix in our 
descriptions put in dm-crypt table). I understood numeric ids were too 
generic for this purpose. Also cryptsetup uses by default thread keyring 
to upload keys in kernel. Such keys are obsolete the moment cryptsetup 
process finishes.

I don't think it's any problem to go with IDs for your patch. IIUC, as 
long as process has permission to access key metadata it can obtain also 
current key id so it's not a big problem for as to adapt when we use kcapi.

Regards
O.
