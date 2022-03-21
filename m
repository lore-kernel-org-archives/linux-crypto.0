Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DA4B4C4332F
	for <linux-crypto@archiver.kernel.org>; Mon, 21 Mar 2022 17:45:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350190AbiCURqf (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 21 Mar 2022 13:46:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348318AbiCURqe (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 21 Mar 2022 13:46:34 -0400
Received: from smtp-1909.mail.infomaniak.ch (smtp-1909.mail.infomaniak.ch [IPv6:2001:1600:3:17::1909])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E551F3B2A6
        for <linux-crypto@vger.kernel.org>; Mon, 21 Mar 2022 10:45:08 -0700 (PDT)
Received: from smtp-3-0001.mail.infomaniak.ch (unknown [10.4.36.108])
        by smtp-2-3000.mail.infomaniak.ch (Postfix) with ESMTPS id 4KMhpV2Q0WzMptYB;
        Mon, 21 Mar 2022 18:45:06 +0100 (CET)
Received: from localhost (unknown [23.97.221.149])
        by smtp-3-0001.mail.infomaniak.ch (Postfix) with ESMTPA id 4KMhpT4slkzlhMBQ;
        Mon, 21 Mar 2022 18:45:05 +0100 (CET)
From:   =?UTF-8?q?Micka=C3=ABl=20Sala=C3=BCn?= <mic@digikod.net>
To:     Jarkko Sakkinen <jarkko@kernel.org>
Cc:     =?UTF-8?q?Micka=C3=ABl=20Sala=C3=BCn?= <mic@digikod.net>,
        David Howells <dhowells@redhat.com>,
        "David S . Miller" <davem@davemloft.net>,
        David Woodhouse <dwmw2@infradead.org>,
        Eric Snowberg <eric.snowberg@oracle.com>,
        Paul Moore <paul@paul-moore.com>, keyrings@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v1 0/1] Explain panic() calls for keyring initialization
Date:   Mon, 21 Mar 2022 18:45:47 +0100
Message-Id: <20220321174548.510516-1-mic@digikod.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

As suggested by Jarkko and explained by Paul, let's document the panic()
calls from the blacklist keyring initialization.  This series applies on
top of commit 50c486fe3108 ("certs: Allow root user to append signed hashes to the
blacklist keyring").  This can smoothly be rebased on top of Jarkko's
next branch.

[1] https://git.kernel.org/pub/scm/linux/kernel/git/jarkko/linux-tpmdd.git/commit/?id=50c486fe310890c134b5cb36cf9a4135475a6074

Regards,

Mickaël Salaün (1):
  certs: Explain the rational to call panic()

 certs/blacklist.c | 8 ++++++++
 1 file changed, 8 insertions(+)


base-commit: 50c486fe310890c134b5cb36cf9a4135475a6074
-- 
2.35.1

