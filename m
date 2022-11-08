Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D2AC3C433FE
	for <linux-crypto@archiver.kernel.org>; Tue,  8 Nov 2022 14:20:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234585AbiKHOUr (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 8 Nov 2022 09:20:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57144 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233762AbiKHOUp (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 8 Nov 2022 09:20:45 -0500
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A961862D3;
        Tue,  8 Nov 2022 06:20:44 -0800 (PST)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 598C61FB65;
        Tue,  8 Nov 2022 14:20:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1667917243; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=zEIm8FIV+6p3ETHKPUDk0ZSb7Xtz18tlXw3EGnkfS8c=;
        b=lFEhg6EpE0jYcbBG1BXDU5AVguKqeTKYVwLBV8cVFPBb3q2bxgWJiRCDA3bXkZM8av8tUy
        Q9fg7tbQKczVjISNK8HX1T1+EbK7cSLrTdbqKnWJkYQHyBJZaTq3IJPiqKs/5SMTqjsk/1
        8xkjmblhV+5pfU4MDWiZKBqMRLJWmBI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1667917243;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=zEIm8FIV+6p3ETHKPUDk0ZSb7Xtz18tlXw3EGnkfS8c=;
        b=WhQJesnek4dczWRnT/mqbEXdi7omlk34VRLPhy56Gn6wsAKu1UKsIQoEhwClpf2r9Q0UhO
        WYEjHCx1eoltHPAg==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 479E513398;
        Tue,  8 Nov 2022 14:20:43 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id PWbQELtlamMIKQAAMHmgww
        (envelope-from <nstange@suse.de>); Tue, 08 Nov 2022 14:20:43 +0000
From:   Nicolai Stange <nstange@suse.de>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Vladis Dronov <vdronov@redhat.com>,
        Stephan Mueller <smueller@chronox.de>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        Nicolai Stange <nstange@suse.de>
Subject: [PATCH 0/4] Trivial set of FIPS 140-3 related changes
Date:   Tue,  8 Nov 2022 15:20:21 +0100
Message-Id: <20221108142025.13461-1-nstange@suse.de>
X-Mailer: git-send-email 2.38.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi all,

these four rather unrelated patches are basically a dump of some of the
more trivial changes required for working towards FIPS 140-3 conformance.

Please pick as you deem appropriate.

Thanks!

Nicolai

Nicolai Stange (4):
  crypto: xts - restrict key lengths to approved values in FIPS mode
  crypto: testmgr - disallow plain cbcmac(aes) in FIPS mode
  crypto: testmgr - disallow plain ghash in FIPS mode
  crypto: testmgr - allow ecdsa-nist-p256 and -p384 in FIPS mode

 crypto/testmgr.c     | 4 ++--
 include/crypto/xts.h | 7 +++++++
 2 files changed, 9 insertions(+), 2 deletions(-)

-- 
2.38.0

