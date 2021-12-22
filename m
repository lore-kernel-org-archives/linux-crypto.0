Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 38436C433F5
	for <linux-crypto@archiver.kernel.org>; Wed, 22 Dec 2021 19:11:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233746AbhLVTLU (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 22 Dec 2021 14:11:20 -0500
Received: from smtp-out2.suse.de ([195.135.220.29]:44802 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345139AbhLVTLK (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 22 Dec 2021 14:11:10 -0500
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id EB0CC1F389;
        Wed, 22 Dec 2021 19:11:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1640200269;
        h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
         cc:cc:mime-version:mime-version:content-type:content-type;
        bh=CQ4BRD7XOXGviURz95Pcs+HPig6+APXYQuFUjee294s=;
        b=kSYEgkaXXDoMA+aJkZuOnxGquO0766Cb/2MD5vfoRomO5QO2YFo67tUlhk9OotTuvnC3Wi
        BvsI+woZIUOuBPRsCIG07Dkrr625ck/wviQL/CLN2SfLXhXN1xbEks0OgiF7RCITgclD00
        McJQ5eb6K1N8w1ODMWyTUyMNeX+oCQM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1640200269;
        h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
         cc:cc:mime-version:mime-version:content-type:content-type;
        bh=CQ4BRD7XOXGviURz95Pcs+HPig6+APXYQuFUjee294s=;
        b=aknlSyfp91X/7R59N0Ddzdbq6AqNM3UFWEFzsKUgLM7Wb1fhiKgc97m977/kLNPDDHA4mz
        VCTJCenpDCYhPbBA==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id B454713D75;
        Wed, 22 Dec 2021 19:11:09 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id mN8DKk14w2FHWAAAMHmgww
        (envelope-from <pvorel@suse.cz>); Wed, 22 Dec 2021 19:11:09 +0000
Date:   Wed, 22 Dec 2021 20:11:07 +0100
From:   Petr Vorel <pvorel@suse.cz>
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     linux-crypto@vger.kernel.org, Eric Biggers <ebiggers@kernel.org>
Subject: ELIBBAD vs. ENOENT for ciphers not allowed by FIPS
Message-ID: <YcN4S7NIV9F0XXPP@pevik>
Reply-To: Petr Vorel <pvorel@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi Herbert,

do I understand the crypto code correctly, that although crypto/testmgr.c in
alg_test() returns -EINVAL for non-fips allowed algorithms (that means
failing crypto API test) the API in crypto_alg_lookup() returns -ELIBBAD for
failed test?

Why ELIBBAD and not ENOENT like for missing ciphers? To distinguish between
missing cipher and disabled one due fips?

Kind regards,
Petr
