Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 800D9C433EF
	for <linux-crypto@archiver.kernel.org>; Tue, 28 Sep 2021 07:16:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6A9016101A
	for <linux-crypto@archiver.kernel.org>; Tue, 28 Sep 2021 07:16:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239071AbhI1HST (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 28 Sep 2021 03:18:19 -0400
Received: from smtp-out1.suse.de ([195.135.220.28]:60336 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239254AbhI1HSO (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 28 Sep 2021 03:18:14 -0400
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id B83E822207;
        Tue, 28 Sep 2021 07:16:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1632813394; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=hPoc9HcKmX/HuJJ6DcP/Xn52CYGxWL8xcWnjG/kvr9U=;
        b=clw1hE466g10+JFJk1GI4mjnAgaR+tDTBycaR/UN9Bq1SBgrdDSJMWRQqRBzBKLkuebANN
        xGzUSjA/u9bWsLBKIKXiBhvkuNr5Wg3uFDEMDQrHzZk55QeUkfx0xjFrkCggGWP5cS5Zxj
        hJgVDnS9h2VZWehJ9az92Q2jPn48MMU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1632813394;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=hPoc9HcKmX/HuJJ6DcP/Xn52CYGxWL8xcWnjG/kvr9U=;
        b=uQ5SOG+MU/hXhQNBdw4qrcnYsSQb9w4hFkItJ5qbRf7f4oyHqxS5VC/QjQk+K6JbCrKDWG
        M1ZJs1M7iyvffdCQ==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id A5D5013ACF;
        Tue, 28 Sep 2021 07:16:34 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id xgr8J1LBUmGJYAAAMHmgww
        (envelope-from <hare@suse.de>); Tue, 28 Sep 2021 07:16:34 +0000
Subject: Re: [PATCH 04/12] lib/base64: RFC4648-compliant base64 encoding
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     Sagi Grimberg <sagi@grimberg.me>, Christoph Hellwig <hch@lst.de>,
        Keith Busch <keith.busch@wdc.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>,
        linux-nvme@lists.infradead.org, linux-crypto@vger.kernel.org
References: <20210928060356.27338-1-hare@suse.de>
 <20210928060356.27338-5-hare@suse.de> <YVK1D+GZgdFPRsaS@sol.localdomain>
From:   Hannes Reinecke <hare@suse.de>
Message-ID: <2eee5e3c-265d-d84f-6214-ad3bcd19d169@suse.de>
Date:   Tue, 28 Sep 2021 09:16:34 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <YVK1D+GZgdFPRsaS@sol.localdomain>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 9/28/21 8:24 AM, Eric Biggers wrote:
> On Tue, Sep 28, 2021 at 08:03:48AM +0200, Hannes Reinecke wrote:
>> + * Return: the length of the resulting base64url-encoded string in bytes.
> 
> base64, not base64url.
> 
>> + * Decodes a string using base64url encoding, i.e. the "Base 64 Encoding"
>> + * specified by RFC 4648, including the  '='-padding.
> 
> base64, not base64url.
> 
Sheesh, you are right.

But now you know I've copied it as requested :-)

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		           Kernel Storage Architect
hare@suse.de			                  +49 911 74053 688
SUSE Software Solutions Germany GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), GF: Felix Imendörffer
