Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E8FC7C433EF
	for <linux-crypto@archiver.kernel.org>; Wed, 16 Feb 2022 10:02:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232641AbiBPKCN (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 16 Feb 2022 05:02:13 -0500
Received: from gmail-smtp-in.l.google.com ([23.128.96.19]:56110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232637AbiBPKCN (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 16 Feb 2022 05:02:13 -0500
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 842439BF70;
        Wed, 16 Feb 2022 02:02:00 -0800 (PST)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 437A31F37D;
        Wed, 16 Feb 2022 10:01:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1645005719;
        h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
         cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=VdVQOy+sPvfsqUg3D3Kt7VC/vYBeiMYJP+Nr1pAL6C8=;
        b=RpMDLxm2DyHTo2IGX3scsEDsfOp0N/EWj04ADtUqQ3S6F8E+F2NnaNtFWYYfWsq23blUmz
        PU7KJeOauwnJex1ZW7T9phOlLsbaIeXvmubu8oBfNI4yuDr13rMPk+qdy/bWxRkf4+QUpA
        LCHJ+lqPucID808yQ7lG+RcXnO4NMCg=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1645005719;
        h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
         cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=VdVQOy+sPvfsqUg3D3Kt7VC/vYBeiMYJP+Nr1pAL6C8=;
        b=PXDUbz8PtUHVLzXWRgvX3mKns1tmElrGsi+O1s67OEHrSSzbmn6Np7NeJ2Em+n+9dJ4nc1
        t+blfLrvWmgDFHDA==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id E349113A9F;
        Wed, 16 Feb 2022 10:01:58 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id CFaNNZbLDGIjAgAAMHmgww
        (envelope-from <pvorel@suse.cz>); Wed, 16 Feb 2022 10:01:58 +0000
Date:   Wed, 16 Feb 2022 11:01:57 +0100
From:   Petr Vorel <pvorel@suse.cz>
To:     Nicolai Stange <nstange@suse.de>
Cc:     linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>, leitao@debian.org,
        Nayna Jain <nayna@linux.ibm.com>,
        Paulo Flabiano Smorigo <pfsmorigo@gmail.com>,
        linuxppc-dev@lists.ozlabs.org, linux-kbuild@vger.kernel.org
Subject: Re: [PATCH v2 1/2] crypto: vmx: Turn CRYPTO_DEV_VMX_ENCRYPT into
 tristate
Message-ID: <YgzLlZRAk21HwCzV@pevik>
Reply-To: Petr Vorel <pvorel@suse.cz>
References: <20220215185936.15576-1-pvorel@suse.cz>
 <20220215185936.15576-2-pvorel@suse.cz>
 <87tuczf96a.fsf@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87tuczf96a.fsf@suse.de>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi,

side notes about the subject (following private notes from Nicolai):

I dared to use "crypto: vmx: " in subject, next version I'll use "crypto: vmx - "
as it's used in crypto.

Also continue the subject line into the rest of the commit message isn't
probably wanted.

Kind regards,
Petr
