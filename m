Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6D926C12002
	for <linux-crypto@archiver.kernel.org>; Mon, 19 Jul 2021 09:56:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 40F786108B
	for <linux-crypto@archiver.kernel.org>; Mon, 19 Jul 2021 09:56:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235032AbhGSJQL (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 19 Jul 2021 05:16:11 -0400
Received: from smtp-out2.suse.de ([195.135.220.29]:43264 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231928AbhGSJQL (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 19 Jul 2021 05:16:11 -0400
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 3C747201DA;
        Mon, 19 Jul 2021 09:56:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1626688610; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=p+KYZhu8MHF65CyDgaHI85CrDt1saurCBksyVHMp+A8=;
        b=jD5T8bRvtKTlaUFvNTfYd9BGX9kBnfID77sxAfQaZhVJDApYrLOHNYOnx/yeHyxShuMvxm
        RBiGqT4o57GnSuRKT/xE4eT53WIVE02wfg8Xy4wAbbSReWdlyERErabWmIL6DvyvBaceAj
        RNrruKZmcBNvx57Z6DuxAHsad47c8o0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1626688610;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=p+KYZhu8MHF65CyDgaHI85CrDt1saurCBksyVHMp+A8=;
        b=8mwf2UGIcy5I4+UCBM8M4c6xQ2sW05K/yFJNE28P7Hb1Cod11q1LbozDQvILdU52fbLzSf
        YqqihxCPQET2vmCQ==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 2B6F513CA7;
        Mon, 19 Jul 2021 09:56:50 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id QIlGCmJM9WDLMwAAMHmgww
        (envelope-from <hare@suse.de>); Mon, 19 Jul 2021 09:56:50 +0000
To:     Sagi Grimberg <sagi@grimberg.me>, Christoph Hellwig <hch@lst.de>
Cc:     Keith Busch <keith.busch@wdc.com>, linux-nvme@lists.infradead.org,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org
References: <20210716110428.9727-1-hare@suse.de>
 <20210716110428.9727-12-hare@suse.de>
 <9ac44322-5c89-da94-b540-6086d2a32bc2@grimberg.me>
From:   Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 11/11] nvme: add non-standard ECDH and curve25517
 algorithms
Message-ID: <e0e02c98-8537-c853-55b6-5b829f5f1ee6@suse.de>
Date:   Mon, 19 Jul 2021 11:56:49 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <9ac44322-5c89-da94-b540-6086d2a32bc2@grimberg.me>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 7/19/21 11:23 AM, Sagi Grimberg wrote:
> 
>> TLS 1.3 specifies ECDH and curve25517 in addition to the FFDHE
>> groups, and these are already implemented in the kernel.
> 
> So?
> 
>> So add support for these non-standard groups for NVMe in-band
>> authentication to validate the augmented challenge implementation.
> 
> Why? why should users come to expect controllers to support it?

Having ECDH and curve25517 algorithms (which are known-good
implementations) allows one to validate the ffdhe implementation, ie to
ensure that the remainder of the protocol works as designed, even if the
ffdhe implementation might not.
And one could argue that TLS1.3 specifies all of these algorithms, so
NVMe with it's explicit reference to TLS should do so, too.

But I don't insist on it; it's just nice for debugging, that's all.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		           Kernel Storage Architect
hare@suse.de			                  +49 911 74053 688
SUSE Software Solutions Germany GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), GF: Felix Imendörffer
