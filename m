Return-Path: <SRS0=t+Y3=BH=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7E5A7C433E1
	for <linux-crypto@archiver.kernel.org>; Tue, 28 Jul 2020 22:03:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 599CE2075D
	for <linux-crypto@archiver.kernel.org>; Tue, 28 Jul 2020 22:03:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=candelatech.com header.i=@candelatech.com header.b="a99f1G6O"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729512AbgG1WDa (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 28 Jul 2020 18:03:30 -0400
Received: from mail2.candelatech.com ([208.74.158.173]:42062 "EHLO
        mail3.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729437AbgG1WDa (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 28 Jul 2020 18:03:30 -0400
Received: from [192.168.254.5] (unknown [50.34.202.127])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail3.candelatech.com (Postfix) with ESMTPSA id F087113C2B0
        for <linux-crypto@vger.kernel.org>; Tue, 28 Jul 2020 15:03:29 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mail3.candelatech.com F087113C2B0
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=candelatech.com;
        s=default; t=1595973810;
        bh=002seJvFn/8xfwTaV6ngO1WljEQNLrdWtOav/biwk+k=;
        h=From:Subject:To:Date:From;
        b=a99f1G6OGTFLJO0CVavB2MzrOE+EeT1lQdu9SeSN1/rpExm6/59hkiykA6sIbFTJ7
         mrDEPqK5m+DjNPluOVnJUjubPi4kZzBJvLCWaQyTAXBtKVPAR8SogcIZpoEJs4U6qB
         3UE7iS5o/Ze+r1B/3xDFniVyWSd0nxPrA5c8nrsY=
From:   Ben Greear <greearb@candelatech.com>
Subject: Help getting aesni crypto patch upstream
To:     linux-crypto@vger.kernel.org
Organization: Candela Technologies
Message-ID: <2a55b661-512b-9479-9fff-0f2e2a581765@candelatech.com>
Date:   Tue, 28 Jul 2020 15:03:29 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-MW
Content-Transfer-Encoding: 7bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hello,

As part of my wifi test tool, I need to do decrypt AES on the CPU, and the only way this
performs well is to use aesni.  I've been using a patch for years that does this, but
recently somewhere between 5.4 and 5.7, the API I've been using has been removed.

Would anyone be interested in getting this support upstream?  I'd be happy to pay for
the effort.

Here is the patch in question:

https://github.com/greearb/linux-ct-5.7/blob/master/wip/0001-crypto-aesni-add-ccm-aes-algorithm-implementation.patch

Please keep me in CC, I'm not subscribed to this list.

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com
