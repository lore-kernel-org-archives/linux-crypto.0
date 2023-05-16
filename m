Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9370DC77B7F
	for <linux-crypto@archiver.kernel.org>; Tue, 16 May 2023 08:34:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230019AbjEPIeF (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 16 May 2023 04:34:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52650 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230257AbjEPIeE (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 16 May 2023 04:34:04 -0400
X-Greylist: delayed 586 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Tue, 16 May 2023 01:33:42 PDT
Received: from psionic.psi5.com (psionic.psi5.com [185.187.169.70])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE55D4C12
        for <linux-crypto@vger.kernel.org>; Tue, 16 May 2023 01:33:42 -0700 (PDT)
Received: from [192.168.10.129] (unknown [39.110.247.193])
        (using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (Client did not present a certificate)
        by psionic.psi5.com (Postfix) with ESMTPSA id 1EFB23F07A
        for <linux-crypto@vger.kernel.org>; Tue, 16 May 2023 10:23:23 +0200 (CEST)
Message-ID: <6a12ff63-268b-88fe-a4b4-2c21fe510a79@hogyros.de>
Date:   Tue, 16 May 2023 17:23:16 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
To:     linux-crypto@vger.kernel.org
Content-Language: en-US
From:   Simon Richter <Simon.Richter@hogyros.de>
Subject: async import/export for ahash
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi,

I have an ahash implementation on hardware with separate memory, so I 
need to send a command and wait for a response to export the hash state.

As far as I can see, the export function is synchronous. Am I allowed to 
sleep here?

    Simon
