Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EAE40C433F5
	for <linux-crypto@archiver.kernel.org>; Mon, 22 Nov 2021 11:56:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236716AbhKVL7s (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 22 Nov 2021 06:59:48 -0500
Received: from smtp-out1.suse.de ([195.135.220.28]:48300 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230425AbhKVL7s (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 22 Nov 2021 06:59:48 -0500
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 28B75218F8;
        Mon, 22 Nov 2021 11:56:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1637582201; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=EOVSkwGsIpMFFdVifoD5CWCMq+XpR/GM6uEsw6krylE=;
        b=fVeNWmvudEacGP0kpWKTLNNCo38v7E+6Z/+PaHmllocRVAsuQyQZW4zfA5v/3fpJwR/MOh
        xHo8MdFEyx+VRH1tnk1Jps/whVvVEbfCehtabVKyNPJPXGRfPDPHtL9+dOkxEcSdtUeiaT
        hZCjPZIPjHTtt4KhnGjSM9uSSF/zttY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1637582201;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=EOVSkwGsIpMFFdVifoD5CWCMq+XpR/GM6uEsw6krylE=;
        b=eRR/vcR80250UjHd5sJriMp5vjwk0GZnAnwzwOr4j+Q3bp6isCNX3H4N0TlyzKV2lWpdzt
        go9TBXWABcCj4hCg==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id EAE8913398;
        Mon, 22 Nov 2021 11:56:40 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id fAO0OHiFm2F1JwAAMHmgww
        (envelope-from <hare@suse.de>); Mon, 22 Nov 2021 11:56:40 +0000
Subject: Re: [PATCHv6 00/12] nvme: In-band authentication support
To:     Sagi Grimberg <sagi@grimberg.me>
Cc:     Christoph Hellwig <hch@lst.de>, Keith Busch <keith.busch@wdc.com>,
        linux-nvme@lists.infradead.org, David Miller <davem@davemloft.org>,
        linux-crypto@vger.kernel.org
References: <20211122074727.25988-1-hare@suse.de>
 <14b025bc-746f-ea73-a325-7805c4b46c28@grimberg.me>
 <8e0909ad-f431-2600-7b68-d86d014fc9ec@suse.de>
 <8ba377cc-5c33-7cba-456e-bfc890f1ad88@grimberg.me>
 <ff0acc79-40d7-8247-6f80-e1c6f635df3f@suse.de>
 <153a78a9-8978-afc1-d321-35719feb5b7f@grimberg.me>
From:   Hannes Reinecke <hare@suse.de>
Organization: SUSE Linux GmbH
Message-ID: <55524670-23b0-a7d9-4398-043477faa37a@suse.de>
Date:   Mon, 22 Nov 2021 12:56:40 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <153a78a9-8978-afc1-d321-35719feb5b7f@grimberg.me>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 11/22/21 12:45 PM, Sagi Grimberg wrote:
> 
>>>>> What about the bug fix folded in?
>>>>
>>>> Yeah, and that, to
>>>> Forgot to mention it.
>>>
>>> It is not the code that you shared in the other thread right?
>>>
>> Yes, it is.
>> It has been folded into v6.
> 
> I don't see it in patch 07/12


+	ret = nvme_auth_process_dhchap_success1(ctrl, chap);
+	if (ret) {
+		/* Controller authentication failed */
+		goto fail2;
+	}
+

v5 had 'if (ret < 0) [' here.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		        Kernel Storage Architect
hare@suse.de			               +49 911 74053 688
SUSE Software Solutions Germany GmbH, 90409 Nürnberg
GF: F. Imendörffer, HRB 36809 (AG Nürnberg)
