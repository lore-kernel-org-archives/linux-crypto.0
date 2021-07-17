Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AEA57C636C9
	for <linux-crypto@archiver.kernel.org>; Sat, 17 Jul 2021 14:00:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 814596115A
	for <linux-crypto@archiver.kernel.org>; Sat, 17 Jul 2021 14:00:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233483AbhGQODS (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 17 Jul 2021 10:03:18 -0400
Received: from smtp-out2.suse.de ([195.135.220.29]:34440 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232893AbhGQODS (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 17 Jul 2021 10:03:18 -0400
Received: from imap1.suse-dmz.suse.de (imap1.suse-dmz.suse.de [192.168.254.73])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 464121FF14;
        Sat, 17 Jul 2021 14:00:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1626530421; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=IajkUIDctCZ3jnytmgu4H5g4bmZ6IGfTpK0hbibjwbI=;
        b=xHi81pc4e1E/R22aOVfiML6H363ZEN2VtAA+lPNE5Zf/+FRGij3CtMUpN2haxuqkOzz8ez
        EzhKWJa6cHoQ++jOqCtUbEoOizV8OWpMa0fli3QOqo8bvePF5wSlcMswv2iyAdCnH47JH9
        yS/H56naT8ojsNQOSw9rnOBL+WLkl+Y=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1626530421;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=IajkUIDctCZ3jnytmgu4H5g4bmZ6IGfTpK0hbibjwbI=;
        b=TECs47syT7ZzB/dr8hyDwJ74T1sHakhZlIcl8rMTVPD4j8pq4t72tFflNypSJ+lQMghOxL
        0ZzBtMzRUL5DsSCQ==
Received: from imap1.suse-dmz.suse.de (imap1.suse-dmz.suse.de [192.168.254.73])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap1.suse-dmz.suse.de (Postfix) with ESMTPS id 1D31913A57;
        Sat, 17 Jul 2021 14:00:21 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap1.suse-dmz.suse.de with ESMTPSA
        id nlq7BXXi8mC8XAAAGKfGzw
        (envelope-from <hare@suse.de>); Sat, 17 Jul 2021 14:00:21 +0000
Subject: Re: [PATCH 04/11] lib/base64: RFC4648-compliant base64 encoding
To:     Sagi Grimberg <sagi@grimberg.me>, Christoph Hellwig <hch@lst.de>
Cc:     Keith Busch <keith.busch@wdc.com>, linux-nvme@lists.infradead.org,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org
References: <20210716110428.9727-1-hare@suse.de>
 <20210716110428.9727-5-hare@suse.de>
 <a6708951-76f6-21bb-f7fe-e4bb32cd0448@grimberg.me>
From:   Hannes Reinecke <hare@suse.de>
Message-ID: <7f320b51-1077-9b3f-bf29-49d0753adf6c@suse.de>
Date:   Sat, 17 Jul 2021 16:00:20 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <a6708951-76f6-21bb-f7fe-e4bb32cd0448@grimberg.me>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 7/17/21 8:16 AM, Sagi Grimberg wrote:
> 
>> Add RFC4648-compliant base64 encoding and decoding routines.
> 
> Looks good to me (although didn't look in the logic itself).
> Can you maybe mention where was this taken from?

Umm ... yeah, I guess I can; I _think_ I've copied it from base64 
routines in fs/crypto/fname.c, but I'll check.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                Kernel Storage Architect
hare@suse.de                              +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), Geschäftsführer: Felix Imendörffer
