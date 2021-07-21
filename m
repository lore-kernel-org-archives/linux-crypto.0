Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.4 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A4BB3C12002
	for <linux-crypto@archiver.kernel.org>; Wed, 21 Jul 2021 06:08:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 83BF4610D2
	for <linux-crypto@archiver.kernel.org>; Wed, 21 Jul 2021 06:08:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229450AbhGUF1o (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 21 Jul 2021 01:27:44 -0400
Received: from smtp-out1.suse.de ([195.135.220.28]:45774 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232143AbhGUF1k (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 21 Jul 2021 01:27:40 -0400
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id D97D4224CD;
        Wed, 21 Jul 2021 06:08:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1626847685; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=HYj9KiJVrhiYcTQ+iUDXp8rg+ELidPbaHpW20hGsliE=;
        b=THp1dYd43Q1OmgNGTDgkYdnnKsE5tk7cecT6Af9uSYxb2NlqcFs9qWJo8FIcREcOMmK2rk
        Q6CMYdpsNCC1qL1f6+H5KFeDNd+rbJhtIjAhXjnGyjgtuWfCp3EqM3G4AYeITQO0PO3w9u
        t7gzI8i+jgvPRBmshZLYKOYF18sAvfM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1626847685;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=HYj9KiJVrhiYcTQ+iUDXp8rg+ELidPbaHpW20hGsliE=;
        b=EyakkcMPna1jg0ywbNF4HH2MxLV1uoIaGBMolNepkidTfDgMOquJGPONPUgik6dmIPEZB6
        rmC4kDgTzY076bBQ==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id C8BF4133D1;
        Wed, 21 Jul 2021 06:08:05 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id uCexMMW592C9bAAAMHmgww
        (envelope-from <hare@suse.de>); Wed, 21 Jul 2021 06:08:05 +0000
Subject: Re: [PATCH 06/11] nvme: Implement In-Band authentication
To:     Vladislav Bolkhovitin <vst@vlnb.net>,
        Christoph Hellwig <hch@lst.de>
Cc:     Sagi Grimberg <sagi@grimberg.me>,
        Keith Busch <keith.busch@wdc.com>,
        linux-nvme@lists.infradead.org,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org
References: <20210716110428.9727-1-hare@suse.de>
 <20210716110428.9727-7-hare@suse.de>
 <2946f3ff-bfa5-2487-4d91-c5286e3a7189@vlnb.net>
From:   Hannes Reinecke <hare@suse.de>
Message-ID: <a728cc00-700a-203b-d229-a4592af7b936@suse.de>
Date:   Wed, 21 Jul 2021 08:08:05 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <2946f3ff-bfa5-2487-4d91-c5286e3a7189@vlnb.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 7/20/21 10:27 PM, Vladislav Bolkhovitin wrote:
> 
> On 7/16/21 2:04 PM, Hannes Reinecke wrote:
> 
> [...]
> 
>> +struct nvmet_dhchap_hash_map {
>> +	int id;
>> +	int hash_len;
>> +	const char hmac[15];
>> +	const char digest[15];
>> +} hash_map[] = {
>> +	{.id = NVME_AUTH_DHCHAP_HASH_SHA256,
>> +	 .hash_len = 32,
>> +	 .hmac = "hmac(sha256)", .digest = "sha256" },
>> +	{.id = NVME_AUTH_DHCHAP_HASH_SHA384,
>> +	 .hash_len = 48,
>> +	 .hmac = "hmac(sha384)", .digest = "sha384" },
>> +	{.id = NVME_AUTH_DHCHAP_HASH_SHA512,
>> +	 .hash_len = 64,
>> +	 .hmac = "hmac(sha512)", .digest = "sha512" },
>> +};
> 
> "hmac()" is always here, so why not to just auto-generate hmac(sha512)
> from sha512?
> 

... all part of the learning curve ...
If that's true then of course I can auto-generate the hmac name.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		           Kernel Storage Architect
hare@suse.de			                  +49 911 74053 688
SUSE Software Solutions Germany GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), GF: Felix Imendörffer
