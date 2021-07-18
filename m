Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 270FDC636C8
	for <linux-crypto@archiver.kernel.org>; Sun, 18 Jul 2021 12:44:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 010346100C
	for <linux-crypto@archiver.kernel.org>; Sun, 18 Jul 2021 12:44:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233488AbhGRMri (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 18 Jul 2021 08:47:38 -0400
Received: from smtp-out2.suse.de ([195.135.220.29]:47508 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232859AbhGRMrh (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 18 Jul 2021 08:47:37 -0400
Received: from imap1.suse-dmz.suse.de (imap1.suse-dmz.suse.de [192.168.254.73])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 256142014B;
        Sun, 18 Jul 2021 12:44:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1626612279; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=uGvSJCtE89wYB1aW87Os9l7E9zsyPETbtXOQsO+kQo8=;
        b=tYqfNE8cI9vnPeevBhf4CCG2wN+qtnDHkd3uNIcs2pnrzwpAYUp6MN10+XGAf+P8cwGmeH
        HnrZopVsZIBzxmS2vQ9aVHCgF3p1ZaKlsCZx3UjRmuL+vZBlW42H8mxjbwJx5I8iu7DYHo
        fvWDh3dZzSUmFTe1uFI6iAXNGqqGJfI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1626612279;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=uGvSJCtE89wYB1aW87Os9l7E9zsyPETbtXOQsO+kQo8=;
        b=y9gcQX8MLz6+z+PtthxS85whmNZJMTrfEWwzYBYRxVWX4YVZRX+B7EqqxIEQoTaqa5wZ4T
        Z9z017urunFGfiAg==
Received: from imap1.suse-dmz.suse.de (imap1.suse-dmz.suse.de [192.168.254.73])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap1.suse-dmz.suse.de (Postfix) with ESMTPS id 0306913AD2;
        Sun, 18 Jul 2021 12:44:39 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap1.suse-dmz.suse.de with ESMTPSA
        id 5jMTADci9GCUPgAAGKfGzw
        (envelope-from <hare@suse.de>); Sun, 18 Jul 2021 12:44:39 +0000
Subject: Re: [PATCH 11/11] nvme: add non-standard ECDH and curve25517
 algorithms
To:     =?UTF-8?Q?Stephan_M=c3=bcller?= <smueller@chronox.de>,
        Christoph Hellwig <hch@lst.de>
Cc:     Sagi Grimberg <sagi@grimberg.me>,
        Keith Busch <keith.busch@wdc.com>,
        linux-nvme@lists.infradead.org,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org
References: <20210716110428.9727-1-hare@suse.de>
 <20210716110428.9727-12-hare@suse.de>
 <2097520.Z47m7augs3@positron.chronox.de>
From:   Hannes Reinecke <hare@suse.de>
Message-ID: <cea86e44-6e2b-46be-2005-e03db413fd2b@suse.de>
Date:   Sun, 18 Jul 2021 14:44:38 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <2097520.Z47m7augs3@positron.chronox.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 7/17/21 6:50 PM, Stephan Müller wrote:
> Am Freitag, 16. Juli 2021, 13:04:28 CEST schrieb Hannes Reinecke:
> 
> Hi Hannes,
> 
>> TLS 1.3 specifies ECDH and curve25517 in addition to the FFDHE
> 
> curve25519?
> 

Of course.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                Kernel Storage Architect
hare@suse.de                              +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), Geschäftsführer: Felix Imendörffer
