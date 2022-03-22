Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 51F73C433EF
	for <linux-crypto@archiver.kernel.org>; Tue, 22 Mar 2022 11:12:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232821AbiCVLNx (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 22 Mar 2022 07:13:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229484AbiCVLNw (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 22 Mar 2022 07:13:52 -0400
X-Greylist: delayed 1221 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Tue, 22 Mar 2022 04:12:24 PDT
Received: from smtp-8fa9.mail.infomaniak.ch (smtp-8fa9.mail.infomaniak.ch [83.166.143.169])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 930AC814B2
        for <linux-crypto@vger.kernel.org>; Tue, 22 Mar 2022 04:12:23 -0700 (PDT)
Received: from smtp-3-0001.mail.infomaniak.ch (unknown [10.4.36.108])
        by smtp-2-3000.mail.infomaniak.ch (Postfix) with ESMTPS id 4KN82t309nzMqKsG;
        Tue, 22 Mar 2022 12:12:22 +0100 (CET)
Received: from localhost (unknown [23.97.221.149])
        by smtp-3-0001.mail.infomaniak.ch (Postfix) with ESMTPA id 4KN82s6GyjzlhMCJ;
        Tue, 22 Mar 2022 12:12:21 +0100 (CET)
From:   =?UTF-8?q?Micka=C3=ABl=20Sala=C3=BCn?= <mic@digikod.net>
To:     Jarkko Sakkinen <jarkko@kernel.org>
Cc:     =?UTF-8?q?Micka=C3=ABl=20Sala=C3=BCn?= <mic@digikod.net>,
        David Howells <dhowells@redhat.com>,
        "David S . Miller" <davem@davemloft.net>,
        David Woodhouse <dwmw2@infradead.org>,
        Eric Snowberg <eric.snowberg@oracle.com>,
        Paul Moore <paul@paul-moore.com>,
        Tyler Hicks <tyhicks@linux.microsoft.com>,
        keyrings@vger.kernel.org, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 0/1] Explain panic() calls for keyring initialization
Date:   Tue, 22 Mar 2022 12:13:22 +0100
Message-Id: <20220322111323.542184-1-mic@digikod.net>
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

This second version fixes some minor spelling issues.

[1] https://git.kernel.org/pub/scm/linux/kernel/git/jarkko/linux-tpmdd.git/commit/?id=50c486fe310890c134b5cb36cf9a4135475a6074

Previous version:
https://lore.kernel.org/r/20220321174548.510516-1-mic@digikod.net

Regards,

Mickaël Salaün (1):
  certs: Explain the rationale to call panic()

 certs/blacklist.c | 9 +++++++++
 1 file changed, 9 insertions(+)


base-commit: 50c486fe310890c134b5cb36cf9a4135475a6074
-- 
2.35.1

