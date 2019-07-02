Return-Path: <SRS0=X5ob=U7=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 95162C06510
	for <linux-crypto@archiver.kernel.org>; Tue,  2 Jul 2019 16:06:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6052120989
	for <linux-crypto@archiver.kernel.org>; Tue,  2 Jul 2019 16:06:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1562083578;
	bh=NzUh+dGND0X6x1d2WK0u77MPzTq27D+4N0HJEZaArNI=;
	h=Date:From:To:Cc:Subject:List-ID:From;
	b=zhCy7tVjuehEzE92AETF1IjA43t5gHNJvTZBX8YZCXXasc77uHAidq42cW2/9wP5B
	 1p6LP4MW+v1c9j2xqxixe4m4UKYNmUeZRn8225MFQKdeBMBMsOWAM5m4uOzpUN9FRn
	 Q/BVhrJl0b4cpfDHTNcRxXG4L6ABd5TlPDUHTZbA=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725972AbfGBQGR (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 2 Jul 2019 12:06:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:52550 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725858AbfGBQGR (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 2 Jul 2019 12:06:17 -0400
Received: from sol.localdomain (c-24-5-143-220.hsd1.ca.comcast.net [24.5.143.220])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 53ABD206A3;
        Tue,  2 Jul 2019 16:06:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1562083576;
        bh=NzUh+dGND0X6x1d2WK0u77MPzTq27D+4N0HJEZaArNI=;
        h=Date:From:To:Cc:Subject:From;
        b=Ytjd6MqSB/0TdW+HZLP8Fq6GuCp/NdjieGOAA0087SN2qVdgTK+Y6HVeHMpHIE/Ge
         RpTltODOTLSA+bEviOX5heOK/T1rOInLczw+wxBKQoObhOV8dzz7K+yI/v3mmYiYxI
         eItIGPA6nYj88JiXF5NwHkApy31gkP5FUKYVht6U=
Date:   Tue, 2 Jul 2019 09:06:14 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Tom Lendacky <thomas.lendacky@amd.com>,
        Gary Hook <gary.hook@amd.com>
Cc:     linux-crypto@vger.kernel.org, Cfir Cohen <cfir@google.com>,
        David Rientjes <rientjes@google.com>
Subject: gcm-aes-ccp self-tests failure
Message-ID: <20190702160614.GC895@sol.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi Tom and Gary,

On latest cryptodev tree, I'm seeing the following self-test failure after I
built a kernel with the AMD CCP driver and crypto self-tests enabled, and booted
it on system with a Ryzen processor ("Threadripper 1950X"):

[    4.378985] alg: aead: gcm-aes-ccp encryption test failed (wrong result) on test vector 2, cfg="two even aligned splits"

i.e., in some cases the AES-GCM implementation produces the wrong ciphertext
and/or authentication tag.

Is this is a known issue?  When will it be fixed?

The potentially relevant bits of my Kconfig are:

	CONFIG_CRYPTO_AES=y
	CONFIG_CRYPTO_GCM=y
	CONFIG_CRYPTO_DEV_CCP=y
	CONFIG_CRYPTO_DEV_CCP_DD=y
	CONFIG_CRYPTO_DEV_SP_CCP=y
	CONFIG_CRYPTO_DEV_CCP_CRYPTO=y
	CONFIG_CRYPTO_DEV_SP_PSP=y
	# CONFIG_CRYPTO_MANAGER_DISABLE_TESTS is not set
	CONFIG_DEBUG_KERNEL=y
	CONFIG_CRYPTO_MANAGER_EXTRA_TESTS=y

- Eric
