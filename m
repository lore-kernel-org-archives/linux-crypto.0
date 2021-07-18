Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EC04AC636C8
	for <linux-crypto@archiver.kernel.org>; Sun, 18 Jul 2021 12:22:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CF436610CB
	for <linux-crypto@archiver.kernel.org>; Sun, 18 Jul 2021 12:22:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233273AbhGRMZN (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 18 Jul 2021 08:25:13 -0400
Received: from smtp-out1.suse.de ([195.135.220.28]:55998 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233251AbhGRMZN (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 18 Jul 2021 08:25:13 -0400
Received: from imap1.suse-dmz.suse.de (imap1.suse-dmz.suse.de [192.168.254.73])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id D71BF224EB;
        Sun, 18 Jul 2021 12:22:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1626610934; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=pugyD51b77ZzuWl1Jldtt+XqGHZGBTYClAPtWrnyQCA=;
        b=jYVsQlu5W5FlNCN4W7Sw612NN8CSZ0FVAZ90I7qLCgBoJET+PJOb/achfvmyqLd39xJgNM
        Ni1OWvNJdZHcdpoj22NQo+fY0/yP89s4VE4AcTRnwdHMa612FLfLH10GUPUngyW3TQVgWB
        pRyXIRy6YQaLexbkIDcJNGY0dG4YNfM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1626610934;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=pugyD51b77ZzuWl1Jldtt+XqGHZGBTYClAPtWrnyQCA=;
        b=1e5cukwEBcVb4JIyJU46lkt7eN5noYoVf8FxWGUd/3714Qnekh1XrXO7U9h53whQUkjvL1
        3fgkbPeTC/9224BQ==
Received: from imap1.suse-dmz.suse.de (imap1.suse-dmz.suse.de [192.168.254.73])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap1.suse-dmz.suse.de (Postfix) with ESMTPS id AED2E13AD2;
        Sun, 18 Jul 2021 12:22:14 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap1.suse-dmz.suse.de with ESMTPSA
        id GsOoKfYc9GD3OgAAGKfGzw
        (envelope-from <hare@suse.de>); Sun, 18 Jul 2021 12:22:14 +0000
Subject: Re: [PATCH 03/11] crypto/ffdhe: Finite Field DH Ephemeral Parameters
To:     =?UTF-8?Q?Stephan_M=c3=bcller?= <smueller@chronox.de>,
        Christoph Hellwig <hch@lst.de>
Cc:     Sagi Grimberg <sagi@grimberg.me>,
        Keith Busch <keith.busch@wdc.com>,
        linux-nvme@lists.infradead.org,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org
References: <20210716110428.9727-1-hare@suse.de>
 <20210716110428.9727-4-hare@suse.de>
 <29491463.gfxVf8N7Et@positron.chronox.de>
From:   Hannes Reinecke <hare@suse.de>
Message-ID: <fceab658-f7dd-3588-790f-c0eec2743ab0@suse.de>
Date:   Sun, 18 Jul 2021 14:22:14 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <29491463.gfxVf8N7Et@positron.chronox.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 7/17/21 5:03 PM, Stephan Müller wrote:
> Am Freitag, 16. Juli 2021, 13:04:20 CEST schrieb Hannes Reinecke:
> 
> Hi Hannes,
> 
>> +#include <linux/module.h>
>> +#include <crypto/internal/kpp.h>
>> +#include <crypto/kpp.h>
>> +#include <crypto/dh.h>
>> +#include <linux/mpi.h>
>> +
>> +/*
>> + * ffdhe2048 generator (g), modulus (p) and group size (q)
>> + */
>> +const u8 ffdhe2048_g[] = { 0x02 };
> 
> What about using static const here (and for all the following groups)?
> 
Yes, of course. Will be fixing it.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                Kernel Storage Architect
hare@suse.de                              +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), Geschäftsführer: Felix Imendörffer
